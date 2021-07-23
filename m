Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C71D3D3D8C
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 18:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhGWPrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 11:47:12 -0400
Received: from outbound-smtp37.blacknight.com ([46.22.139.220]:45001 "EHLO
        outbound-smtp37.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229492AbhGWPrM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 11:47:12 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jul 2021 11:47:12 EDT
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp37.blacknight.com (Postfix) with ESMTPS id 2147123E9
        for <kvm@vger.kernel.org>; Fri, 23 Jul 2021 17:21:39 +0100 (IST)
Received: (qmail 20456 invoked from network); 23 Jul 2021 16:21:38 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.17.255])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 23 Jul 2021 16:21:38 -0000
Date:   Fri, 23 Jul 2021 17:21:37 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     peterz@infradead.org, bristot@redhat.com, bsegall@google.com,
        dietmar.eggemann@arm.com, joshdon@google.com,
        juri.lelli@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH 1/1] sched/fair: improve yield_to vs fairness
Message-ID: <20210723162137.GY3809@techsingularity.net>
References: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
 <20210707123402.13999-1-borntraeger@de.ibm.com>
 <20210707123402.13999-2-borntraeger@de.ibm.com>
 <20210723093523.GX3809@techsingularity.net>
 <ddb81bc9-1429-c392-adac-736e23977c84@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <ddb81bc9-1429-c392-adac-736e23977c84@de.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 23, 2021 at 02:36:21PM +0200, Christian Borntraeger wrote:
> > sched: Do not select highest priority task to run if it should be skipped
> > 
> > <SNIP>
> >
> > index 44c452072a1b..ddc0212d520f 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4522,7 +4522,8 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> >   			se = second;
> >   	}
> > -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
> > +	if (cfs_rq->next &&
> > +	    (cfs_rq->skip == left || wakeup_preempt_entity(cfs_rq->next, left) < 1)) {
> >   		/*
> >   		 * Someone really wants this to run. If it's not unfair, run it.
> >   		 */
> > 
> 
> I do see a reduction in ignored yields, but from a performance aspect for my
> testcases this patch does not provide a benefit, while the the simple
> 	curr->vruntime += sysctl_sched_min_granularity;
> does.

I'm still not a fan because vruntime gets distorted. From the docs

   Small detail: on "ideal" hardware, at any time all tasks would have the same
   p->se.vruntime value --- i.e., tasks would execute simultaneously and no task
   would ever get "out of balance" from the "ideal" share of CPU time

If yield_to impacts this "ideal share" then it could have other
consequences.

I think your patch may be performing better in your test case because every
"wrong" task selected that is not the yield_to target gets penalised and
so the yield_to target gets pushed up the list.

> I still think that your approach is probably the cleaner one, any chance to improve this
> somehow?
> 

Potentially. The patch was a bit off because while it noticed that skip
was not being obeyed, the fix was clumsy and isolated. The current flow is

1. pick se == left as the candidate
2. try pick a different se if the "ideal" candidate is a skip candidate
3. Ignore the se update if next or last are set

Step 3 looks off because it ignores skip if next or last buddies are set
and I don't think that was intended. Can you try this?

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 44c452072a1b..d56f7772a607 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4522,12 +4522,12 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 			se = second;
 	}
 
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
+	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1) {
 		/*
 		 * Someone really wants this to run. If it's not unfair, run it.
 		 */
 		se = cfs_rq->next;
-	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1) {
+	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1) {
 		/*
 		 * Prefer last buddy, try to return the CPU to a preempted task.
 		 */
