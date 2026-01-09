jouer(ax,L,t):-advGentil_AX(L,C),C>=3,!.
jouer(ax,L,C):-grad_AX(ax,L,C).

grad_AX(ax,[],c):-!.
grad_AX(ax,[[c,_]],c):-!.
grad_AX(ax,[[c,c]|L],c):-entente_AX(L,0),!.
grad_AX(ax,[[c,t]|L],c):-entente_AX(L,0),!.
grad_AX(ax,[[c,c]|L],t):-dette_AX(L,X),X>0,!.
grad_AX(ax,[[c,c]|_],c).
grad_AX(ax,[[c,t]|_],t).
grad_AX(ax,[[t,c]|L],t):-trahison_AX([[t,c]|L],T,D),T<D,!.
grad_AX(ax,[[t,c]|L],c):-trahison_AX([[t,c]|L],T,T),!.
grad_AX(ax,[[t,t]|L],t):-trahison_AX([[t,t]|L],T,D),T<D.
grad_AX(ax,[[t,t]|L],c):-trahison_AX([[t,t]|L],T,T).
% au dessus on à grad_AX qui fonctionne comme la strat graduelle on
% commence par une phase de 2 coopération puis on trahit le nbe de fois
% où l'adversaire nous a trahit précédemment puis on retente la même
% phase de 2 coopération si l'adversaire ne nous trahit pas on continue
% de coopérer.

entente_AX([],0).
entente_AX([[c,_]|L],C):-!,entente_AX(L,I),C is I+1.
entente_AX([[t,_]|_],0).
% entente_AX permet de compter le nombre de fois où on a coopérer
% successivement sur les tours précédent, je l'utilise dans (grad_AX),
% afin de savoir si ma phase de coopération est fini où non.

advGentil_AX([],0).
advGentil_AX([[_,c]|L],C):-!,entente_AX(L,I),C is I+1.
advGentil_AX([[_,t]|_],0).
% advGentil_AX permet de compter le nombre de fois où l'adversaire a
% coopérer successivement sur les tours précédent.

trahison_AX([],0,0).
trahison_AX([[t,_]|L],T,D):-!,trahison_AX(L,I,D),T is I+1.
trahison_AX([[c,c]|L],0,D):-!,dette_AX([[c,c]|L],D).
trahison_AX([[c,t]|L],0,D):-!,dette_AX([[c,t]|L],D).
% trahison_AX me permet en premier lieux de savoir le nombre de fois où
% j'ai trahit mon adversaire successivement dans les tours précédent
% puis grâce à dette_AX je compte le nombre trahison que m'a fait
% l'adversaire à partir de ma dernière phase de coopération. Donc
% trahison me donne le nbe de trahison que j'ai faite (T) et celles de
% mon adversaire (D). Je m'en sert dans grad_AX enfin de savoir après une
% phase de coopération combien de fois je doit trahir l'adversaire afin
% de me venger et de me stopper au bon moment quand (T=D) afin de
% réentamer une phase de coopération.

dette_AX([],0).
dette_AX([[c,t],[c,c]|L],D):-!,dette_AX(L,D).
dette_AX([[t,t],[c,c]|L],D):-!,dette_AX(L,D).
dette_AX([[c,t]|L],D):-!,dette_AX(L,I),D is I+1.
dette_AX([[c,c],[_,t]|L],D):-!,dette_AX(L,I),D is I+1.

dette_AX([[c,c],[c,c],[c,t]|L],D):-!,dette_AX([[c,t]|L],I),D is I+1.
dette_AX([[c,c],[c,c],[t,t]|L],D):-!,dette_AX([[t,t]|L],I),D is I+1.
%Attention aux deux lignes du dessus mais normalement c'est bon

dette_AX([[t,t]|L],D):-!,dette_AX(L,I),D is I+1.
dette_AX([[_,c]|_],0).


% vengeance_AX me sert à rien au final mais me permet de compter le nbe
% de fois où l'adversaire m'a trahit successivement.

%vengeance_AX([],_).
%vengeance_AX([[_,t]|L],T):-!,vengeance_AX(L,I),T is I+1.
%vengeance_AX([[c,t],[c,c]|L],T):-Y==c,X==t
%vengeance_AX([[_,c]|_],0).

