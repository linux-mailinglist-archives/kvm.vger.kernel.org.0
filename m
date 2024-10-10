Return-Path: <kvm+bounces-28409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A30C998206
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:22:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C91BEB2A66D
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167621BC097;
	Thu, 10 Oct 2024 09:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="q162aNhX"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D591A3BAD;
	Thu, 10 Oct 2024 09:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728551938; cv=none; b=N45n3f8tG0iuFbOfBBQ99P/ZI+A0kF2M/7VvR8YVUaFegnnsmkR6ObB7AOKFeymSwvBKTWlI/3dqSapZZq/ytuQeLjM5LNtv6L70orpMxZFXvo8jCj9g9isJgimRs3n/TiVF0KmcKXQKeIab5ZOqYDbijcx1VnCxUjaxiuD1MDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728551938; c=relaxed/simple;
	bh=hH7CjFFoCMVhIHLjz7xyQncFYAA2ChNfKMEoODR5rZw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b+jy2XcAgqtpVX/0ZF38Aq/w6lVkQXGdRKOPgVy25TAGIRUIb6XD/UuzwBjkJwGO8T1B0UKHRcjaRrFkPkv3cP/6fNVETiunkw2G1soKtfFuiBkrMnBFhHrbuoYwVVdIPLjXlixSWBHaT27PxS+jzKtbtPFb4t7wtMCJHDGm0fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=q162aNhX; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+T+Gik2iLAOphOqsW/CwOpPiWH5BOYie6Oblxai0KYs=; b=q162aNhX6YHB2OYO7aTR8pXcAh
	ptubUMrNkoFmhagM79Fh0QW+BBD+9eiD++V8Koi/WCAyg8yZa7oZSv/wOaP8PK0NGwzfI+4FdkkiG
	NBL5pdFhKjCEhID1H4C+knorwyYer/n95/gr9O2z/bOsxuShQGq/kI1jy0yhHqdWDasMDh5Ajjqbl
	DuSA2DTCokuUl5IUvX+gr2/b0J2I4MrkgE4Xq+/08gv1ySgTAzSNLeOmPhDppaglGRgDn8nq0MG3y
	dn+Soq2KVDAhF3vB7NecjpyIhJTcVkr8Je3vvf0lwD8QETa0JWhRGih55rGLYerIbZfg+mDPJ8LQ5
	igj0GX1A==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1sypJj-00000005JTn-3pcC;
	Thu, 10 Oct 2024 09:18:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 4992B30088D; Thu, 10 Oct 2024 11:18:43 +0200 (CEST)
Date: Thu, 10 Oct 2024 11:18:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, mingo@redhat.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, linux-kernel@vger.kernel.org,
	kprateek.nayak@amd.com, wuyun.abel@bytedance.com,
	youssefesmat@chromium.org, tglx@linutronix.de, efault@gmx.de,
	kvm@vger.kernel.org
Subject: Re: [PATCH 17/24] sched/fair: Implement delayed dequeue
Message-ID: <20241010091843.GK33184@noisy.programming.kicks-ass.net>
References: <20240727102732.960974693@infradead.org>
 <20240727105030.226163742@infradead.org>
 <CGME20240828223802eucas1p16755f4531ed0611dc4871649746ea774@eucas1p1.samsung.com>
 <5618d029-769a-4690-a581-2df8939f26a9@samsung.com>
 <ZwdA0sbA2tJA3IKh@google.com>
 <20241010081940.GC17263@noisy.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241010081940.GC17263@noisy.programming.kicks-ass.net>

On Thu, Oct 10, 2024 at 10:19:40AM +0200, Peter Zijlstra wrote:
> On Wed, Oct 09, 2024 at 07:49:54PM -0700, Sean Christopherson wrote:
> 
> > TL;DR: Code that checks task_struct.on_rq may be broken by this commit.
> 
> Correct, and while I did look at quite a few, I did miss KVM used it,
> damn.
> 
> > Peter,
> > 
> > Any thoughts on how best to handle this?  The below hack-a-fix resolves the issue,
> > but it's obviously not appropriate.  KVM uses vcpu->preempted for more than just
> > posted interrupts, so KVM needs equivalent functionality to current->on-rq as it
> > was before this commit.
> > 
> > @@ -6387,7 +6390,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
> >  
> >         WRITE_ONCE(vcpu->scheduled_out, true);
> >  
> > -       if (current->on_rq && vcpu->wants_to_run) {
> > +       if (se_runnable(&current->se) && vcpu->wants_to_run) {
> >                 WRITE_ONCE(vcpu->preempted, true);
> >                 WRITE_ONCE(vcpu->ready, true);
> >         }
> 
> se_runnable() isn't quite right, but yes, a helper along those lines is
> probably best. Let me try and grep more to see if there's others I
> missed as well :/

How's the below? I remember looking at the freezer thing before and
deciding it isn't a correctness thing, but given I added the helper, I
changed it anyway. I've added a bunch of comments and the perf thing is
similar to KVM, it wants to know about preemptions so that had to change
too.

---
 include/linux/sched.h         |  5 +++++
 kernel/events/core.c          |  2 +-
 kernel/freezer.c              |  7 ++++++-
 kernel/rcu/tasks.h            |  9 +++++++++
 kernel/sched/core.c           | 12 +++++++++---
 kernel/time/tick-sched.c      |  5 +++++
 kernel/trace/trace_selftest.c |  2 +-
 virt/kvm/kvm_main.c           |  2 +-
 8 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0053f0664847..2b1f454e4575 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2134,6 +2134,11 @@ static inline void set_task_cpu(struct task_struct *p, unsigned int cpu)
 
 #endif /* CONFIG_SMP */
 
+static inline bool task_is_runnable(struct task_struct *p)
+{
+	return p->on_rq && !p->se.sched_delayed;
+}
+
 extern bool sched_task_on_rq(struct task_struct *p);
 extern unsigned long get_wchan(struct task_struct *p);
 extern struct task_struct *cpu_curr_snapshot(int cpu);
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e3589c4287cb..cdd09769e6c5 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -9251,7 +9251,7 @@ static void perf_event_switch(struct task_struct *task,
 		},
 	};
 
-	if (!sched_in && task->on_rq) {
+	if (!sched_in && task_is_runnable(task)) {
 		switch_event.event_id.header.misc |=
 				PERF_RECORD_MISC_SWITCH_OUT_PREEMPT;
 	}
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 44bbd7dbd2c8..8d530d0949ff 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -109,7 +109,12 @@ static int __set_task_frozen(struct task_struct *p, void *arg)
 {
 	unsigned int state = READ_ONCE(p->__state);
 
-	if (p->on_rq)
+	/*
+	 * Allow freezing the sched_delayed tasks; they will not execute until
+	 * ttwu() fixes them up, so it is safe to swap their state now, instead
+	 * of waiting for them to get fully dequeued.
+	 */
+	if (task_is_runnable(p))
 		return 0;
 
 	if (p != current && task_curr(p))
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 6333f4ccf024..4d7ee95df06e 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -985,6 +985,15 @@ static bool rcu_tasks_is_holdout(struct task_struct *t)
 	if (!READ_ONCE(t->on_rq))
 		return false;
 
+	/*
+	 * t->on_rq && !t->se.sched_delayed *could* be considered sleeping but
+	 * since it is a spurious state (it will transition into the
+	 * traditional blocked state or get woken up without outside
+	 * dependencies), not considering it such should only affect timing.
+	 *
+	 * Be conservative for now and not include it.
+	 */
+
 	/*
 	 * Idle tasks (or idle injection) within the idle loop are RCU-tasks
 	 * quiescent states. But CPU boot code performed by the idle task
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0bacc5cd3693..be5c04eb5ba0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -548,6 +548,11 @@ sched_core_dequeue(struct rq *rq, struct task_struct *p, int flags) { }
  *   ON_RQ_MIGRATING state is used for migration without holding both
  *   rq->locks. It indicates task_cpu() is not stable, see task_rq_lock().
  *
+ *   Additionally it is possible to be ->on_rq but still be considered not
+ *   runnable when p->se.sched_delayed is true. These tasks are on the runqueue
+ *   but will be dequeued as soon as they get picked again. See the
+ *   task_is_runnable() helper.
+ *
  * p->on_cpu <- { 0, 1 }:
  *
  *   is set by prepare_task() and cleared by finish_task() such that it will be
@@ -4358,9 +4363,10 @@ static bool __task_needs_rq_lock(struct task_struct *p)
  * @arg: Argument to function.
  *
  * Fix the task in it's current state by avoiding wakeups and or rq operations
- * and call @func(@arg) on it.  This function can use ->on_rq and task_curr()
- * to work out what the state is, if required.  Given that @func can be invoked
- * with a runqueue lock held, it had better be quite lightweight.
+ * and call @func(@arg) on it.  This function can use task_is_runnable() and
+ * task_curr() to work out what the state is, if required.  Given that @func
+ * can be invoked with a runqueue lock held, it had better be quite
+ * lightweight.
  *
  * Returns:
  *   Whatever @func returns
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 753a184c7090..59efa14ce185 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -435,6 +435,11 @@ static void tick_nohz_kick_task(struct task_struct *tsk)
 	 *   tick_nohz_task_switch()
 	 *     LOAD p->tick_dep_mask
 	 */
+	// XXX given a task picks up the dependency on schedule(), should we
+	// only care about tasks that are currently on the CPU instead of all
+	// that are on the runqueue?
+	//
+	// That is, does this want to be: task_on_cpu() / task_curr()?
 	if (!sched_task_on_rq(tsk))
 		return;
 
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index c4ad7cd7e778..1469dd8075fa 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -1485,7 +1485,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	/* reset the max latency */
 	tr->max_latency = 0;
 
-	while (p->on_rq) {
+	while (task_is_runnable(p)) {
 		/*
 		 * Sleep to make sure the -deadline thread is asleep too.
 		 * On virtual machines we can't rely on timings,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 05cbb2548d99..0c666f1870af 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -6387,7 +6387,7 @@ static void kvm_sched_out(struct preempt_notifier *pn,
 
 	WRITE_ONCE(vcpu->scheduled_out, true);
 
-	if (current->on_rq && vcpu->wants_to_run) {
+	if (task_is_runnable(current) && vcpu->wants_to_run) {
 		WRITE_ONCE(vcpu->preempted, true);
 		WRITE_ONCE(vcpu->ready, true);
 	}

