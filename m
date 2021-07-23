Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D093D37E6
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 11:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhGWJCv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 05:02:51 -0400
Received: from outbound-smtp61.blacknight.com ([46.22.136.249]:49851 "EHLO
        outbound-smtp61.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231430AbhGWJCu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 05:02:50 -0400
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jul 2021 05:02:50 EDT
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp61.blacknight.com (Postfix) with ESMTPS id DE824FB2FB
        for <kvm@vger.kernel.org>; Fri, 23 Jul 2021 10:35:24 +0100 (IST)
Received: (qmail 13966 invoked from network); 23 Jul 2021 09:35:24 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.17.255])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 23 Jul 2021 09:35:24 -0000
Date:   Fri, 23 Jul 2021 10:35:23 +0100
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
Message-ID: <20210723093523.GX3809@techsingularity.net>
References: <YIlXQ43b6+7sUl+f@hirez.programming.kicks-ass.net>
 <20210707123402.13999-1-borntraeger@de.ibm.com>
 <20210707123402.13999-2-borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210707123402.13999-2-borntraeger@de.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 07, 2021 at 02:34:02PM +0200, Christian Borntraeger wrote:
> After some debugging in situations where a smaller sched_latency_ns and
> smaller sched_migration_cost settings helped for KVM host, I was able to
> come up with a reduced testcase.
> This testcase has 2 vcpus working on a shared memory location and
> waiting for mem % 2 == cpu number to then do an add on the shared
> memory.
> To start simple I pinned all vcpus to one host CPU. Without the
> yield_to in KVM the testcase was horribly slow. This is expected as each
> vcpu will spin a whole time slice. With the yield_to from KVM things are
> much better, but I was still seeing yields being ignored.
> In the end pick_next_entity decided to keep the current process running
> due to fairness reasons.  On this path we really know that there is no
> point in continuing current. So let us make things a bit unfairer to
> current.
> This makes the reduced testcase noticeable faster. It improved a more
> realistic test case (many guests on some host CPUs with overcomitment)
> even more.
> In the end this is similar to the old compat_sched_yield approach with
> an important difference:
> Instead of doing it for all yields we now only do it for yield_to
> a place where we really know that current it waiting for the target.
> 
> What are alternative implementations for this patch
> - do the same as the old compat_sched_yield:
>   current->vruntime = rightmost->vruntime+1
> - provide a new tunable sched_ns_yield_penalty: how much vruntime to add
>   (could be per architecture)
> - also fiddle with the vruntime of the target
>   e.g. subtract from the target what we add to the source
> 
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

I think this one accidentally fell off everyones radar including mine.
At the time this patch was mailed I remembered thinking that playing games with
vruntime might have other consequences. For example, what I believe is
the most relevant problem for KVM is that a task spinning to acquire a
lock may be waiting on a vcpu holding the lock that has been
descheduled. Without vcpu pinning, it's possible that the holder is on
the same runqueue as the lock acquirer so the acquirer is wasting CPU.

In such a case, changing the acquirers vcpu may mean that it unfairly
loses CPU time simply because it's a lock acquirer. Vincent, what do you
think? Christian, would you mind testing this as an alternative with your
demonstration test case and more importantly the "realistic test case"?

--8<--
sched: Do not select highest priority task to run if it should be skipped

pick_next_entity will consider the "next buddy" over the highest priority
task if it's not unfair to do so (as determined by wakekup_preempt_entity).
The potential problem is that an in-kernel user of yield_to() such as
KVM may explicitly want to yield the current task because it is trying
to acquire a spinlock from a task that is currently descheduled and
potentially running on the same runqueue. However, if it's more fair from
the scheduler perspective to continue running the current task, it'll continue
to spin uselessly waiting on a descheduled task to run.

This patch will select the targeted task to run even if it's unfair if the
highest priority task is explicitly marked as "skip".

This was evaluated using a debugging patch to expose yield_to as a system
call. A demonstration program creates N number of threads and arranges
them in a ring that are updating a shared value in memory. Each thread
spins until the value matches the thread ID. It then updates the value
and wakes the next thread in the ring. It measures how many times it spins
before it gets its turn. Without the patch, the number of spins is highly
variable and unstable but with the patch it's more consistent.

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 44c452072a1b..ddc0212d520f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4522,7 +4522,8 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 			se = second;
 	}
 
-	if (cfs_rq->next && wakeup_preempt_entity(cfs_rq->next, left) < 1) {
+	if (cfs_rq->next &&
+	    (cfs_rq->skip == left || wakeup_preempt_entity(cfs_rq->next, left) < 1)) {
 		/*
 		 * Someone really wants this to run. If it's not unfair, run it.
 		 */

-- 
Mel Gorman
SUSE Labs
