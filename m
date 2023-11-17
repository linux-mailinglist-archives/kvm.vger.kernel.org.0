Return-Path: <kvm+bounces-1942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B94267EEF88
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 10:59:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E4121F27BEF
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 09:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B785179BE;
	Fri, 17 Nov 2023 09:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LeN7DDwJ"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5F9A7;
	Fri, 17 Nov 2023 01:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Fpc2mbNdYwlAzet5KDJmFtGhBTZCq41Y1vmPk+UljsU=; b=LeN7DDwJjX0tmJvZM3tCEPHYDy
	clgtnQmoz9tp0+ovs7D4fbNJGI0tJoZ3UcYs8afWeNrH+nNqG3qnR/PF6BwuJNZEvpyUe8p4p2c9C
	1Nl+mRnze7EJXeCHlJQ1pYFKuqi6cDhhAcj+M9xrRMiKYZreMJ8c5Gg59E/wkWBYwjpk5epvuv7dq
	dMjwSMZRVp7bFUo0d+EVW7Gxej//KYd1USboLxHWBI1ReCSreTkVb2x4NcguvSknnynLElcbmqa+f
	N16BOhSu9xHvWDDg1qA4uFj67ACkjw+6tnMQk64+z4XU59s9xMvX8IkP7WEvRzKNM63VRJtuolE90
	8JRT2arg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r3vcX-007CyC-1H;
	Fri, 17 Nov 2023 09:58:46 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 14B82300478; Fri, 17 Nov 2023 10:58:41 +0100 (CET)
Date: Fri, 17 Nov 2023 10:58:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tobias Huschle <huschle@linux.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	mst@redhat.com, jasowang@redhat.com
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
Message-ID: <20231117095841.GL4779@noisy.programming.kicks-ass.net>
References: <c7b38bc27cc2c480f0c5383366416455@linux.ibm.com>
 <20231117092318.GJ8262@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231117092318.GJ8262@noisy.programming.kicks-ass.net>

On Fri, Nov 17, 2023 at 10:23:18AM +0100, Peter Zijlstra wrote:
> Now, IF this is the problem, I might have a patch that helps:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git/commit/?h=sched/eevdf&id=119feac4fcc77001cd9bf199b25f08d232289a5c

And then I turn around and wipe the repository invalidating that link.

The sched/eevdf branch should be re-instated (with different SHA1), but
I'll include the patch below for reference.

---
Subject: sched/eevdf: Delay dequeue
From: Peter Zijlstra <peterz@infradead.org>
Date: Fri Sep 15 00:48:45 CEST 2023

For tasks that have negative-lag (have received 'excess' service), delay the
dequeue and keep them in the runnable tree until they're eligible again. Or
rather, keep them until they're selected again, since finding their eligibility
crossover point is expensive.

The effect is a bit like sleeper bonus, the tasks keep contending for service
until either they get a wakeup or until they're selected again and are really
dequeued.

This means that any actual dequeue happens with positive lag (serviced owed)
and are more readily ran when woken next.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/sched.h   |    1 
 kernel/sched/core.c     |   88 +++++++++++++++++++++++++++++++++++++++---------
 kernel/sched/fair.c     |   11 ++++++
 kernel/sched/features.h |   11 ++++++
 kernel/sched/sched.h    |    3 +
 5 files changed, 97 insertions(+), 17 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -916,6 +916,7 @@ struct task_struct {
 	unsigned			sched_reset_on_fork:1;
 	unsigned			sched_contributes_to_load:1;
 	unsigned			sched_migrated:1;
+	unsigned			sched_delayed:1;
 
 	/* Force alignment to the next boundary: */
 	unsigned			:0;
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3856,12 +3856,23 @@ static int ttwu_runnable(struct task_str
 
 	rq = __task_rq_lock(p, &rf);
 	if (task_on_rq_queued(p)) {
+		update_rq_clock(rq);
+		if (unlikely(p->sched_delayed)) {
+			p->sched_delayed = 0;
+			/* mustn't run a delayed task */
+			WARN_ON_ONCE(task_on_cpu(rq, p));
+			if (sched_feat(GENTLE_DELAY)) {
+				dequeue_task(rq, p, DEQUEUE_SAVE | DEQUEUE_NOCLOCK);
+				if (p->se.vlag > 0)
+					p->se.vlag = 0;
+				enqueue_task(rq, p, ENQUEUE_RESTORE | ENQUEUE_NOCLOCK);
+			}
+		}
 		if (!task_on_cpu(rq, p)) {
 			/*
 			 * When on_rq && !on_cpu the task is preempted, see if
 			 * it should preempt the task that is current now.
 			 */
-			update_rq_clock(rq);
 			wakeup_preempt(rq, p, wake_flags);
 		}
 		ttwu_do_wakeup(p);
@@ -6565,6 +6576,24 @@ pick_next_task(struct rq *rq, struct tas
 # define SM_MASK_PREEMPT	SM_PREEMPT
 #endif
 
+static void deschedule_task(struct rq *rq, struct task_struct *p, unsigned long prev_state)
+{
+	p->sched_contributes_to_load =
+		(prev_state & TASK_UNINTERRUPTIBLE) &&
+		!(prev_state & TASK_NOLOAD) &&
+		!(prev_state & TASK_FROZEN);
+
+	if (p->sched_contributes_to_load)
+		rq->nr_uninterruptible++;
+
+	deactivate_task(rq, p, DEQUEUE_SLEEP | DEQUEUE_NOCLOCK);
+
+	if (p->in_iowait) {
+		atomic_inc(&rq->nr_iowait);
+		delayacct_blkio_start();
+	}
+}
+
 /*
  * __schedule() is the main scheduler function.
  *
@@ -6650,6 +6679,8 @@ static void __sched notrace __schedule(u
 
 	switch_count = &prev->nivcsw;
 
+	WARN_ON_ONCE(prev->sched_delayed);
+
 	/*
 	 * We must load prev->state once (task_struct::state is volatile), such
 	 * that we form a control dependency vs deactivate_task() below.
@@ -6659,14 +6690,6 @@ static void __sched notrace __schedule(u
 		if (signal_pending_state(prev_state, prev)) {
 			WRITE_ONCE(prev->__state, TASK_RUNNING);
 		} else {
-			prev->sched_contributes_to_load =
-				(prev_state & TASK_UNINTERRUPTIBLE) &&
-				!(prev_state & TASK_NOLOAD) &&
-				!(prev_state & TASK_FROZEN);
-
-			if (prev->sched_contributes_to_load)
-				rq->nr_uninterruptible++;
-
 			/*
 			 * __schedule()			ttwu()
 			 *   prev_state = prev->state;    if (p->on_rq && ...)
@@ -6678,17 +6701,50 @@ static void __sched notrace __schedule(u
 			 *
 			 * After this, schedule() must not care about p->state any more.
 			 */
-			deactivate_task(rq, prev, DEQUEUE_SLEEP | DEQUEUE_NOCLOCK);
-
-			if (prev->in_iowait) {
-				atomic_inc(&rq->nr_iowait);
-				delayacct_blkio_start();
-			}
+			if (sched_feat(DELAY_DEQUEUE) &&
+			    prev->sched_class->delay_dequeue_task &&
+			    prev->sched_class->delay_dequeue_task(rq, prev))
+				prev->sched_delayed = 1;
+			else
+				deschedule_task(rq, prev, prev_state);
 		}
 		switch_count = &prev->nvcsw;
 	}
 
-	next = pick_next_task(rq, prev, &rf);
+	for (struct task_struct *tmp = prev;;) {
+		unsigned long tmp_state;
+
+		next = pick_next_task(rq, tmp, &rf);
+		if (unlikely(tmp != prev))
+			finish_task(tmp);
+
+		if (likely(!next->sched_delayed))
+			break;
+
+		next->sched_delayed = 0;
+
+		/*
+		 * A sched_delayed task must not be runnable at this point, see
+		 * ttwu_runnable().
+		 */
+		tmp_state = READ_ONCE(next->__state);
+		if (WARN_ON_ONCE(!tmp_state))
+			break;
+
+		prepare_task(next);
+		/*
+		 * Order ->on_cpu and ->on_rq, see the comments in
+		 * try_to_wake_up(). Normally this is smp_mb__after_spinlock()
+		 * above.
+		 */
+		smp_wmb();
+		deschedule_task(rq, next, tmp_state);
+		if (sched_feat(GENTLE_DELAY) && next->se.vlag > 0)
+			next->se.vlag = 0;
+
+		tmp = next;
+	}
+
 	clear_tsk_need_resched(prev);
 	clear_preempt_need_resched();
 #ifdef CONFIG_SCHED_DEBUG
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8540,6 +8540,16 @@ static struct task_struct *__pick_next_t
 	return pick_next_task_fair(rq, NULL, NULL);
 }
 
+static bool delay_dequeue_task_fair(struct rq *rq, struct task_struct *p)
+{
+	struct sched_entity *se = &p->se;
+	struct cfs_rq *cfs_rq = cfs_rq_of(se);
+
+	update_curr(cfs_rq);
+
+	return !entity_eligible(cfs_rq, se);
+}
+
 /*
  * Account for a descheduled task:
  */
@@ -13151,6 +13161,7 @@ DEFINE_SCHED_CLASS(fair) = {
 
 	.wakeup_preempt		= check_preempt_wakeup_fair,
 
+	.delay_dequeue_task	= delay_dequeue_task_fair,
 	.pick_next_task		= __pick_next_task_fair,
 	.put_prev_task		= put_prev_task_fair,
 	.set_next_task          = set_next_task_fair,
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -24,6 +24,17 @@ SCHED_FEAT(PREEMPT_SHORT, true)
  */
 SCHED_FEAT(PLACE_SLEEPER, false)
 SCHED_FEAT(GENTLE_SLEEPER, true)
+/*
+ * Delay dequeueing tasks until they get selected or woken.
+ *
+ * By delaying the dequeue for non-eligible tasks, they remain in the
+ * competition and can burn off their negative lag. When they get selected
+ * they'll have positive lag by definition.
+ *
+ * GENTLE_DELAY clips the lag on dequeue (or wakeup) to 0.
+ */
+SCHED_FEAT(DELAY_DEQUEUE, true)
+SCHED_FEAT(GENTLE_DELAY, true)
 
 /*
  * Prefer to schedule the task we woke last (assuming it failed
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2254,6 +2254,7 @@ struct sched_class {
 
 	void (*wakeup_preempt)(struct rq *rq, struct task_struct *p, int flags);
 
+	bool (*delay_dequeue_task)(struct rq *rq, struct task_struct *p);
 	struct task_struct *(*pick_next_task)(struct rq *rq);
 
 	void (*put_prev_task)(struct rq *rq, struct task_struct *p);
@@ -2307,7 +2308,7 @@ struct sched_class {
 
 static inline void put_prev_task(struct rq *rq, struct task_struct *prev)
 {
-	WARN_ON_ONCE(rq->curr != prev);
+//	WARN_ON_ONCE(rq->curr != prev);
 	prev->sched_class->put_prev_task(rq, prev);
 }
 

