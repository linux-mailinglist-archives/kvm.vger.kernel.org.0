Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24FD3D6784
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 21:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231921AbhGZSwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 14:52:07 -0400
Received: from outbound-smtp19.blacknight.com ([46.22.139.246]:35091 "EHLO
        outbound-smtp19.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231639AbhGZSwG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Jul 2021 14:52:06 -0400
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp19.blacknight.com (Postfix) with ESMTPS id 07DDA1C3D9E
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 20:32:34 +0100 (IST)
Received: (qmail 30353 invoked from network); 26 Jul 2021 19:32:33 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.17.255])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 26 Jul 2021 19:32:33 -0000
Date:   Mon, 26 Jul 2021 20:32:32 +0100
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
Message-ID: <20210726193232.GZ3809@techsingularity.net>
References: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
 <20210707123402.13999-1-borntraeger@de.ibm.com>
 <20210707123402.13999-2-borntraeger@de.ibm.com>
 <20210723093523.GX3809@techsingularity.net>
 <ddb81bc9-1429-c392-adac-736e23977c84@de.ibm.com>
 <20210723162137.GY3809@techsingularity.net>
 <1acd7520-bd4b-d43d-302a-8dcacf6defa5@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1acd7520-bd4b-d43d-302a-8dcacf6defa5@de.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021 at 08:41:15PM +0200, Christian Borntraeger wrote:
> > Potentially. The patch was a bit off because while it noticed that skip
> > was not being obeyed, the fix was clumsy and isolated. The current flow is
> > 
> > 1. pick se == left as the candidate
> > 2. try pick a different se if the "ideal" candidate is a skip candidate
> > 3. Ignore the se update if next or last are set
> > 
> > Step 3 looks off because it ignores skip if next or last buddies are set
> > and I don't think that was intended. Can you try this?
> > 
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 44c452072a1b..d56f7772a607 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4522,12 +4522,12 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> >   			se = second;
> >   	}
> > -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
> > +	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1) {
> >   		/*
> >   		 * Someone really wants this to run. If it's not unfair, run it.
> >   		 */
> >   		se = cfs_rq->next;
> > -	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, left) < 1) {
> > +	} else if (cfs_rq->last && wakeup_preempt_entity(cfs_rq->last, se) < 1) {
> >   		/*
> >   		 * Prefer last buddy, try to return the CPU to a preempted task.
> >   		 */
> > 
> 
> This one alone does not seem to make a difference. Neither in ignored yield, nor
> in performance.
> 
> Your first patch does really help in terms of ignored yields when
> all threads are pinned to one host CPU.

Ok, that tells us something. It implies, but does not prove, that the
block above that handles skip is failing either the entity_before()
test or the wakeup_preempt_entity() test. To what degree that should be
relaxed when cfs_rq->next is !NULL is harder to determine.

> After that we do have no ignored yield
> it seems. But it does not affect the performance of my testcase.

Ok, this is the first patch. The second patch is not improving ignored
yields at all so the above paragraph still applies. It would be nice
if you could instrument with trace_printk when cfs->rq_next is valid
whether it's the entity_before() check that is preventing the skip or
wakeup_preempt_entity. Would that be possible?

I still think the second patch is right independent of it helping your
test case because it makes no sense to me at all that the task after the
skip candidate is ignored if there is a next or last buddy.

> I did some more experiments and I removed the wakeup_preempt_entity checks in
> pick_next_entity - assuming that this will result in source always being stopped
> and target always being picked. But still, no performance difference.
> As soon as I play with vruntime I do see a difference (but only without the cpu cgroup
> controller). I will try to better understand the scheduler logic and do some more
> testing. If you have anything that I should test, let me know.
> 

The fact that vruntime tricks only makes a difference when cgroups are
involved is interesting. Can you describe roughly what how the cgroup
is configured? Similarly, does your config have CONFIG_SCHED_AUTOGROUP
or CONFIG_FAIR_GROUP_SCHED set? I assume FAIR_GROUP_SCHED must be and
I wonder if the impact of your patch is dropping groups of tasks in
priority as opposed to individual tasks. I'm not that familiar with how
groups are handled in terms of how they are prioritised unfortunately.

I'm still hesitant to consider the vruntime hammer in case it causes
fairness problems when vruntime is no longer reflecting time spent on
the CPU.

-- 
Mel Gorman
SUSE Labs
