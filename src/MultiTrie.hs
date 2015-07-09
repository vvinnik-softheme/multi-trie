module MultiTrie where

import Prelude hiding (lookup, map, null)
import qualified Data.Map as M
import qualified Data.List as L

data MultiTrie n v = MultiTrie
    {
        values :: [v],
        children :: M.Map n (MultiTrie n v)
    }
    deriving (Eq, Show)

empty :: MultiTrie n v
empty = MultiTrie [] M.empty

singleton :: v -> MultiTrie n v
singleton x = MultiTrie [x] M.empty

null :: MultiTrie n v -> Bool
null (MultiTrie vs m) = L.null vs && L.all null (M.elems m)

size :: MultiTrie n v -> Int
size (MultiTrie vs m) = L.length vs + L.sum (L.map size (M.elems m))

lookup :: Ord n => [n] -> MultiTrie n v -> MultiTrie n v
lookup [] mt = mt
lookup (n:ns) (MultiTrie _ m) = lookup' ns (M.lookup n m)
    where
        lookup' _ Nothing = empty
        lookup' ns' (Just mt) = lookup ns' mt

fetch :: Ord n => [n] -> MultiTrie n v -> [v]
fetch ns = values . lookup ns

update :: Ord n => (MultiTrie n v -> MultiTrie n v) -> [n] -> MultiTrie n v -> MultiTrie n v
update f [] mt = f mt
update f (n:ns) (MultiTrie vs m) = MultiTrie vs (M.alter (Just . update f ns . unnothing) n m)
    where
        unnothing Nothing = empty
        unnothing (Just mt') = mt'

put :: v -> MultiTrie n v -> MultiTrie n v
put x (MultiTrie vs m) = MultiTrie (x : vs) m

insert :: [n] -> v -> MultiTrie n v -> MultiTrie n v
insert = undefined

replace :: [n] -> MultiTrie n v -> MultiTrie n v -> MultiTrie n v
replace = undefined

superpose :: [n] -> MultiTrie n v -> MultiTrie n v -> MultiTrie n v
superpose = undefined

map :: (v -> w) -> MultiTrie n v -> MultiTrie n w
map f (MultiTrie vs m) = MultiTrie (L.map f vs) (M.map (map f) m)

apply :: MultiTrie n (v -> w) -> MultiTrie n v -> MultiTrie n w
apply = undefined

union :: MultiTrie n v -> MultiTrie n v -> MultiTrie n v
union = undefined

bind :: MultiTrie n v -> (v -> MultiTrie n w) -> MultiTrie n w
bind = undefined

toMap :: MultiTrie n v -> M.Map [n] [v]
toMap = undefined

fromList :: [([n], v)] -> MultiTrie n v
fromList = L.foldr (uncurry insert) empty

showTree :: (Show n, Show v) => MultiTrie n v -> String
showTree = undefined

showTreeWith :: (n -> [v] -> String) -> MultiTrie n v -> Bool -> String
showTreeWith = undefined
