Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7456C3D7885
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 16:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbhG0Obb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 10:31:31 -0400
Received: from outbound-smtp10.blacknight.com ([46.22.139.15]:34015 "EHLO
        outbound-smtp10.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232467AbhG0Obb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 27 Jul 2021 10:31:31 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp10.blacknight.com (Postfix) with ESMTPS id 2575A1C4213
        for <kvm@vger.kernel.org>; Tue, 27 Jul 2021 15:31:30 +0100 (IST)
Received: (qmail 27122 invoked from network); 27 Jul 2021 14:31:29 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.17.255])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 27 Jul 2021 14:31:29 -0000
Date:   Tue, 27 Jul 2021 15:31:28 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>, bristot@redhat.com,
        bsegall@google.com, dietmar.eggemann@arm.com, joshdon@google.com,
        juri.lelli@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        linux@rasmusvillemoes.dk, mgorman@suse.de, mingo@kernel.org,
        rostedt@goodmis.org, valentin.schneider@arm.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH 1/1] sched/fair: improve yield_to vs fairness
Message-ID: <20210727143128.GA3809@techsingularity.net>
References: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
 <20210707123402.13999-1-borntraeger@de.ibm.com>
 <20210707123402.13999-2-borntraeger@de.ibm.com>
 <20210723093523.GX3809@techsingularity.net>
 <YQALDHw7Cr+vbeqN@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <YQALDHw7Cr+vbeqN@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021 at 03:33:00PM +0200, Peter Zijlstra wrote:
> On Fri, Jul 23, 2021 at 10:35:23AM +0100, Mel Gorman wrote:
> > diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> > index 44c452072a1b..ddc0212d520f 100644
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -4522,7 +4522,8 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
> >  			se = second;
> >  	}
> >  
> > -	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
> > +	if (cfs_rq->next &&
> > +	    (cfs_rq->skip == left || wakeup_preempt_entity(cfs_rq->next, left) < 1)) {
> >  		/*
> >  		 * Someone really wants this to run. If it's not unfair, run it.
> >  		 */
> 
> With a little more context this function reads like:
> 
> 	se = left;
> 
> 	if (cfs_rq->skip && cfs_rq->skip == se) {
> 		...
> +		if (cfs_rq->next && (cfs_rq->skip == left || ...))
> 
> If '...' doesn't change @left (afaict it doesn't), then your change (+)
> is equivalent to '&& true', or am I reading things wrong?

You're not reading it wrong although the patch is clumsy and may introduce
unfairness that gets incrementally worse if there was repeated yields to
the same task. A second patch was posted that does

-       if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
+       if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, se) < 1) {

i.e. if the skip hint picks a second alternative then next or last buddies
should be compared to the second alternative and not "left". It doesn't
help indicating that the skip hint is not obeyed because "second" failed
the entity_before() or wakeup_preempt_entity() checks. I'm waiting on a
trace to see which check dominates.

That said, I'm still undecided on how to approach this. None of the
proposed patches on their own helps but the options are

1. Strictly obey the next buddy if the skip hint is the same se as left
   (first patch which I'm not very happy with even if it helped the
   test case)

2. My second patch which compares next/last with "second" if the skip
   hint skips "left". This may be a sensible starting point no matter
   what

3. Relaxing how "second" is selected if next or last buddies are set

4. vruntime tricks even if it punishes fairness for the task yielding
   the CPU. The advantage of this approach is if there are multiple tasks
   ahead of the task being yielded to then yield_to task will become
   "left" very quickly regardless of any buddy-related hints.

I don't know what "3" would look like yet, it might be very fragile but
lets see what the tracing says. Otherwise, testing 2+4 might be worthwhile
to see if the combination helps Christian's test case when the cpu cgroup
is involved.

-- 
Mel Gorman
SUSE Labs
