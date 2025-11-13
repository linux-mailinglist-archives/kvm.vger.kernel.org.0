Return-Path: <kvm+bounces-63014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2888EC57CF8
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 14:57:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5977D4E4D4F
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 13:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0A6212574;
	Thu, 13 Nov 2025 13:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZTzVUSCs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1164823EA89
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763042208; cv=none; b=g4EWgthGmUyqbb0BtaXE+EhKDuYpDBUqtuqyuEI8TOL0t3svGUp7bnoO/bV3jZwHDlgofZA3ubOz3QPvDkTo46l6tjW0HvC+9nR7zQDkXkXtfrYC/jL1QsmnJ9wrpi5ARTajMEgT2OVkTUETQf2Ibp3PlGuVgIwsUjH767OVOD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763042208; c=relaxed/simple;
	bh=Yomi8gai9zxmTgtke2BTNkhhTGczwSDG9bFYSoKT5KA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n9tCGf5vAhOesg2ssFbOkj3R0aEkyjb9Ek50a5oUN/gxRzmtAs9OI/H/444waJ0MLOCwZ8M1U50HReQJxeKjH/UhSvuzWK2xNJo2xK7zYq/PxCEXTnUwayWuKKd7e02sO9DoIqtHfscRZ3umQa9QpB9FLI6x4aJWVUn/H7/YeK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZTzVUSCs; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-340e525487eso524043a91.3
        for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 05:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763042206; x=1763647006; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FzBiKLiKHYDmby4m7BGSwJMDuZMkRd4gUMHcWFGZeUA=;
        b=ZTzVUSCsVUKA9/SUrVWW0suUh0/YiI5GUJOjW+Uvonu+1wqpme+M1u3UVfKBZ3n6e+
         xkvRQNpr3wTaokqruQAh5JQ7qHCUZi0jgHvfVJss7I+01SelG+rYxEDax6iuHkv5E07l
         cvG2SZThHnw7d0e2hCyou3kQJHDZQ+GfXnqXORnxQSffgthLiydNeAhqaAdOrsVN8wP0
         fRja+xZj7QnYz7/Zujwi7sO6PbQj6W3X/RrOdg0BM/UkBNn1dysPx14AKjaa9SMhqlrA
         RGGu88AW1rWe1mk0fQHvxAu/AsW5z2u3KQttzXxR7ljgWzkRq9fn6wvKECvBVRKacKXK
         TdIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763042206; x=1763647006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FzBiKLiKHYDmby4m7BGSwJMDuZMkRd4gUMHcWFGZeUA=;
        b=lS02DW9DP/WjKcyKkCYiAtRBS6vFkp0m/4rV0f0WYbzO3Ac5YhjHxFYCKXrkebu5Cd
         lzYKN2hMYY+mUbnc1gPxaR93Zt8m+1uLmPrHkP8jWCgwLJX3434IfcmDJnBICYuLlqyZ
         0D12z2/udx0msRqln85oW8ZKNbWZr2+CIBmhYZmMi1siuWrkqTZJ5KZTzg9ubt1vq+XI
         0/anoHEghGMLbwVAie7IXk2f7KAAG1OL18fgWH26lv8pzChEwv5KUR/ty63C9Pi4yLqf
         h8pf/G+bXG/DAYXmzT4UaGS25t0Odr9+ope+lCYZgrIc0900dqEmyTxaTyYLX/Mgs4w0
         COSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWVdXffk6NE4FOsub43DQY3+G1HaWhs6P6fX7DmtxtwzvVXyGVMYl4lROk4Gjls/ib/OyU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqrNpQ+ciFVVyd7tzXmcsHcYGOQxlYlng4Oo7PWENO9X4gC7dE
	4oaT8bQ6/tY3FVeHpyhyKx2blUTumrDt75BHFvba7BSYK8rsyaO5xBknlrl8uHB21IIicE3hvHB
	CA9drCFOfERw79u/D6qt+CndI0cS5084=
X-Gm-Gg: ASbGncvyRgaa8myEEjc30az8iayQ8fS2CyyxReKn+WX+xXINGRgQnqF2WugLNw53mwV
	ALZo5l3cREkLShfZfs1Xgw0OB5p9p/MYyVpf8GHZn0/Ffew2+mKdvtrgDXOiThcD2fuT3GsuzhR
	ZgdRg1ctGhXlsJCCVHrUYHUmbFEYcgg2cqqAbgK+eXRiAO6F7LAiaoPPPK5fuOLvZ5UOzy4NR3r
	wwAVJ2mkTc1/XHiOgPM5Bq4HpDshYjhYTzwlUApHEwQjYqNlArT+oywt7GNUEcOxlJK97A=
X-Google-Smtp-Source: AGHT+IHPnfuLcZDAqVRQbujvEfGZtcIFqE5zCR4lFpIeb1M7uvDmHY4b33tCR5JQmBPqnBE3GLQtWvAAF5b9BafAISU=
X-Received: by 2002:a17:90a:d403:b0:343:b610:901c with SMTP id
 98e67ed59e1d1-343ddea7c0dmr8825559a91.26.1763042206161; Thu, 13 Nov 2025
 05:56:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251110033232.12538-1-kernellwp@gmail.com> <7bc4b0b7-42ea-42fc-ae96-3084f44bdc81@amd.com>
 <CANRm+CxZfFVk=dX3Koi_RUH6ppr_zc6fs3HHPaYkRGwV7h9L7w@mail.gmail.com>
 <079d48d9-a663-49d5-9bc6-f6518eb54810@amd.com> <CANRm+Cy2O9j_itDmJcAwUebV2h=2hvfZxuxtHqKD-vF1XohGAw@mail.gmail.com>
 <34b2d375-1535-41c1-9ec4-bb054641abd5@amd.com>
In-Reply-To: <34b2d375-1535-41c1-9ec4-bb054641abd5@amd.com>
From: Wanpeng Li <kernellwp@gmail.com>
Date: Thu, 13 Nov 2025 21:56:34 +0800
X-Gm-Features: AWmQ_blMLDgYk8EDEdUzMyiebuRBeBAyMBcBHaemq-rgapQY0YcP663yGXtOeZM
Message-ID: <CANRm+Cxrk2XEn+uVTv2=-1T101npyg4eOmedG_fehqFBVjJRag@mail.gmail.com>
Subject: Re: [PATCH 00/10] sched/kvm: Semantics-aware vCPU scheduling for
 oversubscribed KVM
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Prateek,

On Thu, 13 Nov 2025 at 17:48, K Prateek Nayak <kprateek.nayak@amd.com> wrot=
e:
>
> Hello Wanpeng,
>
> On 11/13/2025 2:03 PM, Wanpeng Li wrote:
> >>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> >>>> index b4617d631549..87560f5a18b3 100644
> >>>> --- a/kernel/sched/fair.c
> >>>> +++ b/kernel/sched/fair.c
> >>>> @@ -8962,10 +8962,28 @@ static void yield_task_fair(struct rq *rq)
> >>>>          * which yields immediately again; without the condition the=
 vruntime
> >>>>          * ends up quickly running away.
> >>>>          */
> >>>> -       if (entity_eligible(cfs_rq, se)) {
> >>>> +       do {
> >>>> +               cfs_rq =3D cfs_rq_of(se);
> >>>> +
> >>>> +               /*
> >>>> +                * Another entity will be selected at next pick.
> >>>> +                * Single entity on cfs_rq can never be ineligible.
> >>>> +                */
> >>>> +               if (!entity_eligible(cfs_rq, se))
> >>>> +                       break;
> >>>> +
> >>>>                 se->vruntime =3D se->deadline;
> >>>
> >>> Setting vruntime =3D deadline zeros out lag. Does this cause fairness
> >>> drift with repeated yields? We explicitly recalculate vlag after
> >>> adjustment to preserve EEVDF invariants.
> >>
> >> We only push deadline when the entity is eligible. Ineligible entity
> >> will break out above. Also I don't get how adding a penalty to an
> >> entity in the cgroup hierarchy of the yielding task when there are
> >> other runnable tasks considered as "preserve(ing) EEVDF invariants".
> >
> > Our penalty preserves EEVDF invariants by recalculating all scheduler s=
tate:
> >    se->vruntime =3D new_vruntime;
> >    se->deadline =3D se->vruntime + calc_delta_fair(se->slice, se);
> >    se->vlag =3D avg_vruntime(cfs_rq) - se->vruntime;
> >    update_min_vruntime(cfs_rq); // maintains cfs_rq consistency
>
> So your exact implementation in yield_deboost_apply_penalty() is:
>
> > +     new_vruntime =3D se_y_lca->vruntime + penalty;
> > +
> > +     /* Validity check */
> > +     if (new_vruntime <=3D se_y_lca->vruntime)
> > +             return;
> > +
> > +     se_y_lca->vruntime =3D new_vruntime;
>
> You've updated this vruntime to something that you've seen fit based on
> your performance data - better performance is not necessarily fair.
>
> update_curr() uses:
>
>     /* Time elapsed. */
>     delta_exec =3D now - se->exec_start;
>     se->exec_start =3D now;
>
>     curr->vruntime +=3D calc_delta_fair(delta_exec, curr);
>
>
> "delta_exec" is based on the amount of time entity has run as opposed
> to the penalty calculation which simply advances the vruntime by half a
> slice because someone in the hierarchy decided to yield.

CFS already separates time accounting from policy enforcement.
place_entity() modifies vruntime based on lag without time
passage=E2=80=94it's placement policy, not time accounting. Similarly,
yield_task_fair() advances the deadline without consuming time=E2=80=94poli=
cy
to trigger reschedule. Our penalty follows this established pattern:
bounded vruntime adjustment to implement yield_to() semantics in
hierarchical scheduling. Time accounting ( update_curr ) and
scheduling policy (placement, yielding, penalties) are distinct
mechanisms in CFS.

>
> Also assume the vCPU yielding and the target is on the same cgroup -
> you'll advance the vruntime of task in yield_deboost_apply_penalty() and
> then again in yield_task_fair()?

This is deliberate. When tasks share the same cgroup, they need both
hierarchy-level and leaf-level adjustments.
yield_deboost_apply_penalty() positions the task in cgroup timeline
(affects picking at that level), while yield_task_fair() advances the
deadline (triggers immediate reschedule). Without both, same-cgroup
yield loses effectiveness=E2=80=94the task would be repicked despite yieldi=
ng.
The double adjustment ensures yield works at both the task level and
across hierarchy levels. This matches CFS's multi-level scheduling
philosophy.

>
>
> > +     se_y_lca->deadline =3D se_y_lca->vruntime + calc_delta_fair(se_y_=
lca->slice, se_y_lca);
> > +     se_y_lca->vlag =3D avg_vruntime(cfs_rq_common) - se_y_lca->vrunti=
me;
>
> There is no point in setting vlag for a running entity

Maintaining invariants when modifying scheduler state is standard
practice throughout fair.c. reweight_entity() updates vlag for curr
when changing weights to preserve the lag relationship. We follow the
same principle=E2=80=94when artificially advancing vruntime, recalculate vl=
ag
to maintain vlag =3D V - v . This prevents inconsistency when the entity
later dequeues. It's defensive correctness at negligible cost. The
alternative=E2=80=94leaving vlag stale=E2=80=94risks subtle bugs when sched=
uler state
assumptions are violated.

>
> > +     update_min_vruntime(cfs_rq_common);
>
> > This is the same update pattern used in update_curr(). The EEVDF
> > relationship lag =3D (V - v) * w remains valid=E2=80=94vlag becomes mor=
e
> > negative as vruntime increases.
>
> Sure "V" just moves to the new avg_vruntime() to give the 0-lag
> point but modifying the vruntime arbitrarily doesn't seem fair to
> me.

yield_to() API explicitly requests directed unfairness. CFS already
implements unfairness mechanisms: nice values, cgroup weights,
set_next_buddy() immediate preference. Without our mechanism,
yield_to() silently fails across cgroups=E2=80=94buddy hints vanish at
hierarchy boundaries where EEVDF makes independent decisions. We make
the documented API functional. The real question: should yield_to()
work in production environments (nested cgroups)? If yes, vruntime
adjustment is necessary. If not, deprecate the API.

>
> > The presence of other runnable tasks
> > doesn't affect the mathematical correctness; each entity's lag is
> > computed independently relative to avg_vruntime.
> >
> >>
> >>>
> >>>>                 se->deadline +=3D calc_delta_fair(se->slice, se);
> >>>> -       }
> >>>> +
> >>>> +               /*
> >>>> +                * If we have more than one runnable task queued bel=
ow
> >>>> +                * this cfs_rq, the next pick will likely go for a
> >>>> +                * different entity now that we have advanced the
> >>>> +                * vruntime and the deadline of the running entity.
> >>>> +                */
> >>>> +               if (cfs_rq->h_nr_runnable > 1)
> >>>
> >>> Stopping at h_nr_runnable > 1 may not handle cross-cgroup yield_to()
> >>> correctly. Shouldn't the penalty apply at the LCA of yielder and
> >>> target? Otherwise the vruntime adjustment might not affect the level
> >>> where they actually compete.
> >>
> >> So here is the case I'm going after - consider the following
> >> hierarchy:
> >>
> >>      root
> >>     /    \
> >>   CG0   CG1
> >>    |     |
> >>    A     B
> >>
> >>   CG* are cgroups and, [A-Z]* are tasks
> >>
> >> A decides to yield to B, and advances its deadline on CG0's timeline.
> >> Currently, if CG0 is eligible and CG1 isn't, pick will still select
> >> CG0 which will in-turn select task A and it'll yield again. This
> >> cycle repeates until vruntime of CG0 turns large enough to make itself
> >> ineligible and route the EEVDF pick to CG1.
> >
> > Yes, natural convergence works, but requires multiple cycles. Your
> > h_nr_runnable > 1 stops propagation when another entity might be
> > picked, but "might" depends on vruntime ordering which needs time to
> > develop. Our penalty forces immediate ineligibility at the LCA. One
> > penalty application vs N natural yield cycles.
> >
> >>
> >> Now consider:
> >>
> >>
> >>        root
> >>       /    \
> >>     CG0   CG1
> >>    /   \   |
> >>   A     C  B
> >>
> >> Same scenario: A yields to B. A advances its vruntime and deadline
> >> as a prt of yield. Now, why should CG0 sacrifice its fair share of
> >> runtime for A when task B is runnable? Just because one task decided
> >> to yield to another task in a different cgroup doesn't mean other
> >> waiting tasks on that hierarchy suffer.
> >
> > You're right that C suffers unfairly if it's independent work. This is
> > a known tradeoff.
>
> So KVM is only one of the user of yield_to(). This whole debouncer
> infrastructure seems to be over complicating all this. If anything
> is yielding across cgroup boundary - that seems like bad
> configuration and if necessary, the previous suggestion does stuff
> fairly. I don't mind accounting the lost time in
> yield_to_task_fair() and account it to target task but apart from
> that, I don't think any of it is "fair".

Time-transfer fails fundamentally: lock holders often have higher
vruntime (ran more), so crediting them backwards doesn't change EEVDF
pick order. Our penalty pushes yielder back=E2=80=94effective regardless. T=
he
infrastructure addresses real measured problems: rate limiting
prevents overhead, debounce stops ping-pong accumulation, LCA
targeting fixes hierarchy picking. Nested cgroups are production
standard (systemd, containers, cloud)=E2=80=94not misconfiguration.
Performance gains prove yield_to was broken. Open to simplifications,
but they must actually solve the hierarchical scheduling problem.

Regards,
Wanpeng

