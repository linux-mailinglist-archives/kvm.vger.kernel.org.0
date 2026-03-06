Return-Path: <kvm+bounces-73080-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oLu+IffxqmncYwEAu9opvQ
	(envelope-from <kvm+bounces-73080-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:25:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D52223C08
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 16:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B5583303B91B
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 15:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E0133BD63D;
	Fri,  6 Mar 2026 15:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FMeD8+bK"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0D73B8940;
	Fri,  6 Mar 2026 15:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772810708; cv=none; b=pngTZZWegMUlVwLfEm7ufBtlUNgV5aUhnHU0eCcmipF9/UfuuGYhVnR20zlH3MCG4dVNZtDZ/Ikp+25OpsPy5xbqcoijMBS8LJ2msTPcuCQSNUzEVBHtcAB8eSIGTcXvzkSQ/qQKkMRSDiMsJX93NkrFFq09GlX72hjVqEOic+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772810708; c=relaxed/simple;
	bh=nmsVeIwvkC3xQsg9K74jbgL/9M8xxjjC7uOWPDYn7ew=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WhTa4YDsPfB4Uo5b87iEeW6jWDJKc8M6QWNkZv2lLNXMIMzMt9G93m8x6WQ9J1KiUikj3UQq8DiQ4EZCqnQNPgw2hkVwpTKMdkte+OSs1AopyQiYFi60Vs03xiOUk3WU3pCormc0bnaxjOWqD2ERxaHwNh8UKRKJqk8T9OCJbSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FMeD8+bK; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=i2DluJ59j3AvknQHCo85rv7wQct3pw9SU3OG6dLCKUA=; b=FMeD8+bKB3LBbsEZWMnuFqlcNM
	rCtC9QrweiJiKQTjMGGQXtTDe2UGrcuNkOTwyRSKMFlebZFWitc2bgOo6x4nUwn5ZGluxbe+7TXxM
	yzJ6w0egflQtyw95ELUM3JdifjC3GWCVRppWjTH3tsq9t1Slkaqz+sagw5MIucW/mI/+DmswDBzJN
	tXIsVIdjJzu1Nqz3F56sZDklTZsvV1xgSW7XuyUAxZlWRjXvmNQktQuZJfVySuwm1UeoRo6+mD5s6
	9BDIO8iG1s+nEEfvdZ1FPZvYqSRFFl7L7O5Me1bzkQvsF1FCLB54UxKSnb1ErUB3sC0u0H/I9unTD
	VBvu8PnQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vyX2x-0000000Gu9V-3mNp;
	Fri, 06 Mar 2026 15:25:00 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9BFB6300462; Fri, 06 Mar 2026 16:24:58 +0100 (CET)
Date: Fri, 6 Mar 2026 16:24:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@kernel.org>
Cc: Jiri Slaby <jirislaby@kernel.org>, Matthieu Baerts <matttbe@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
	rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"luto@kernel.org" <luto@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <MKoutny@suse.com>,
	Waiman Long <longman@redhat.com>, Marco Elver <elver@google.com>
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups, RCU
 stalls, timeout
Message-ID: <20260306152458.GT606826@noisy.programming.kicks-ass.net>
References: <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
 <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
 <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
 <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org>
 <87zf4m2qvo.ffs@tglx>
 <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org>
 <87tsuu2i59.ffs@tglx>
 <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org>
 <87qzpx2sck.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87qzpx2sck.ffs@tglx>
X-Rspamd-Queue-Id: 41D52223C08
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=casper.20170209];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	DKIM_TRACE(0.00)[infradead.org:+];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73080-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.919];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[noisy.programming.kicks-ass.net:mid,infradead.org:dkim,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 10:57:15AM +0100, Thomas Gleixner wrote:

> I tried with tons of test cases which stress test mmcid with threads and
> failed.

Are some of those in tools/testing/selftests ?

Anyway, I was going over that code, and I noticed that there seems to be
inconsistent locking for mm_mm_cid::pcpu.

There's a bunch of sites that state we need rq->lock for remote access;
but then things like sched_mm_cid_fork() and sched_mm_cid_exit() seem to
think that holding mm_cid->lock is sufficient.

This doesn't make sense to me, but maybe I missed something.

Anyway, I cobbled together the below, and that builds and boots and
passes everything in tools/testing/selftests/rseq.


YMMV

---
diff --git a/include/linux/rseq_types.h b/include/linux/rseq_types.h
index da5fa6f40294..df2b4629cbfd 100644
--- a/include/linux/rseq_types.h
+++ b/include/linux/rseq_types.h
@@ -2,9 +2,12 @@
 #ifndef _LINUX_RSEQ_TYPES_H
 #define _LINUX_RSEQ_TYPES_H
 
+#include <linux/compiler_types.h>
 #include <linux/irq_work_types.h>
 #include <linux/types.h>
 #include <linux/workqueue_types.h>
+#include <linux/mutex.h>
+#include <asm/percpu.h>
 
 #ifdef CONFIG_RSEQ
 struct rseq;
@@ -145,8 +148,14 @@ struct sched_mm_cid {
  *		while a task with a CID is running
  */
 struct mm_cid_pcpu {
-	unsigned int	cid;
-}____cacheline_aligned_in_smp;
+	unsigned int		cid;
+} ____cacheline_aligned_in_smp;
+
+/*
+ * See helpers in kernel/sched/sched.h that convert
+ * from __rq_lockp(rq) to RQ_LOCK.
+ */
+token_context_lock(RQ_LOCK);
 
 /**
  * struct mm_mm_cid - Storage for per MM CID data
@@ -167,7 +176,7 @@ struct mm_cid_pcpu {
  */
 struct mm_mm_cid {
 	/* Hotpath read mostly members */
-	struct mm_cid_pcpu	__percpu *pcpu;
+	struct mm_cid_pcpu	__percpu *pcpu __guarded_by(RQ_LOCK);
 	unsigned int		mode;
 	unsigned int		max_cids;
 
@@ -179,11 +188,11 @@ struct mm_mm_cid {
 	struct mutex		mutex;
 
 	/* Low frequency modified */
-	unsigned int		nr_cpus_allowed;
-	unsigned int		users;
-	unsigned int		pcpu_thrs;
-	unsigned int		update_deferred;
-}____cacheline_aligned_in_smp;
+	unsigned int		nr_cpus_allowed __guarded_by(&lock);
+	unsigned int		users		__guarded_by(&lock);
+	unsigned int		pcpu_thrs	__guarded_by(&lock);
+	unsigned int		update_deferred __guarded_by(&lock);
+} ____cacheline_aligned_in_smp;
 #else /* CONFIG_SCHED_MM_CID */
 struct mm_mm_cid { };
 struct sched_mm_cid { };
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2b571e640372..f7c03c9c4fd0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5335,7 +5335,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 		}
 	}
 
-	mm_cid_switch_to(prev, next);
+	mm_cid_switch_to(rq, prev, next);
 
 	/*
 	 * Tell rseq that the task was scheduled in. Must be after
@@ -10511,6 +10511,7 @@ void call_trace_sched_update_nr_running(struct rq *rq, int count)
  * fork(), exit() and affinity changes
  */
 static void __mm_update_max_cids(struct mm_mm_cid *mc)
+	__must_hold(&mc->lock)
 {
 	unsigned int opt_cids, max_cids;
 
@@ -10523,15 +10524,17 @@ static void __mm_update_max_cids(struct mm_mm_cid *mc)
 }
 
 static inline unsigned int mm_cid_calc_pcpu_thrs(struct mm_mm_cid *mc)
+	__must_hold(&mc->lock)
 {
 	unsigned int opt_cids;
 
 	opt_cids = min(mc->nr_cpus_allowed, mc->users);
 	/* Has to be at least 1 because 0 indicates PCPU mode off */
-	return max(min(opt_cids - opt_cids / 4, num_possible_cpus() / 2), 1);
+	return max(min(opt_cids - (opt_cids / 4), num_possible_cpus() / 2), 1);
 }
 
 static bool mm_update_max_cids(struct mm_struct *mm)
+	__must_hold(&mm->mm_cid.lock)
 {
 	struct mm_mm_cid *mc = &mm->mm_cid;
 	bool percpu = cid_on_cpu(mc->mode);
@@ -10558,6 +10561,7 @@ static bool mm_update_max_cids(struct mm_struct *mm)
 		return false;
 
 	/* Flip the mode and set the transition flag to bridge the transfer */
+	WARN_ON_ONCE(mc->mode & MM_CID_TRANSIT);
 	WRITE_ONCE(mc->mode, mc->mode ^ (MM_CID_TRANSIT | MM_CID_ONCPU));
 	/*
 	 * Order the store against the subsequent fixups so that
@@ -10568,16 +10572,28 @@ static bool mm_update_max_cids(struct mm_struct *mm)
 	return true;
 }
 
+/*
+ * Silly helper because we cannot express that mm_mm_cid::users is updated
+ * while holding both mutex and lock and can thus be read while holding
+ * either.
+ */
+static __always_inline unsigned int mm_cid_users(struct mm_struct *mm)
+	__must_hold(&mm->mm_cid.mutex)
+{
+	__assume_ctx_lock(&mm->mm_cid.lock);
+	return mm->mm_cid.users;
+}
+
 static inline void mm_update_cpus_allowed(struct mm_struct *mm, const struct cpumask *affmsk)
 {
 	struct cpumask *mm_allowed;
 	struct mm_mm_cid *mc;
 	unsigned int weight;
 
-	if (!mm || !READ_ONCE(mm->mm_cid.users))
+	if (!mm || !data_race(READ_ONCE(mm->mm_cid.users)))
 		return;
 	/*
-	 * mm::mm_cid::mm_cpus_allowed is the superset of each threads
+	 * mm::mm_cid::mm_cpus_allowed is the superset of each thread's
 	 * allowed CPUs mask which means it can only grow.
 	 */
 	mc = &mm->mm_cid;
@@ -10609,6 +10625,7 @@ static inline void mm_update_cpus_allowed(struct mm_struct *mm, const struct cpu
 
 static inline void mm_cid_complete_transit(struct mm_struct *mm, unsigned int mode)
 {
+	WARN_ON_ONCE(!(mm->mm_cid.mode & MM_CID_TRANSIT));
 	/*
 	 * Ensure that the store removing the TRANSIT bit cannot be
 	 * reordered by the CPU before the fixups have been completed.
@@ -10633,11 +10650,12 @@ static void mm_cid_fixup_cpus_to_tasks(struct mm_struct *mm)
 
 	/* Walk the CPUs and fixup all stale CIDs */
 	for_each_possible_cpu(cpu) {
-		struct mm_cid_pcpu *pcp = per_cpu_ptr(mm->mm_cid.pcpu, cpu);
 		struct rq *rq = cpu_rq(cpu);
+		struct mm_cid_pcpu *pcp;
 
 		/* Remote access to mm::mm_cid::pcpu requires rq_lock */
 		guard(rq_lock_irq)(rq);
+		pcp = mm_cid_pcpu(&mm->mm_cid, rq);
 		/* Is the CID still owned by the CPU? */
 		if (cid_on_cpu(pcp->cid)) {
 			/*
@@ -10675,6 +10693,7 @@ static bool mm_cid_fixup_task_to_cpu(struct task_struct *t, struct mm_struct *mm
 {
 	/* Remote access to mm::mm_cid::pcpu requires rq_lock */
 	guard(task_rq_lock)(t);
+	__assume_ctx_lock(RQ_LOCK);
 	/* If the task is not active it is not in the users count */
 	if (!t->mm_cid.active)
 		return false;
@@ -10689,6 +10708,7 @@ static bool mm_cid_fixup_task_to_cpu(struct task_struct *t, struct mm_struct *mm
 }
 
 static void mm_cid_do_fixup_tasks_to_cpus(struct mm_struct *mm)
+	__must_hold(&mm->mm_cid.mutex)
 {
 	struct task_struct *p, *t;
 	unsigned int users;
@@ -10703,7 +10723,7 @@ static void mm_cid_do_fixup_tasks_to_cpus(struct mm_struct *mm)
 	 * The caller has already transferred. The newly incoming task is
 	 * already accounted for, but not yet visible.
 	 */
-	users = mm->mm_cid.users - 2;
+	users = mm_cid_users(mm) - 2;
 	if (!users)
 		return;
 
@@ -10727,18 +10747,19 @@ static void mm_cid_do_fixup_tasks_to_cpus(struct mm_struct *mm)
 	}
 }
 
-static void mm_cid_fixup_tasks_to_cpus(void)
+static void mm_cid_fixup_tasks_to_cpus(struct mm_struct *mm)
+	__must_hold(mm->mm_cid.mutex)
 {
-	struct mm_struct *mm = current->mm;
-
 	mm_cid_do_fixup_tasks_to_cpus(mm);
 	mm_cid_complete_transit(mm, MM_CID_ONCPU);
 }
 
 static bool sched_mm_cid_add_user(struct task_struct *t, struct mm_struct *mm)
+	__must_hold(&mm->mm_cid.mutex)
+	__must_hold(&mm->mm_cid.lock)
 {
 	t->mm_cid.active = 1;
-	mm->mm_cid.users++;
+	mm->mm_cid.users++; /* mutex && lock */
 	return mm_update_max_cids(mm);
 }
 
@@ -10750,8 +10771,9 @@ void sched_mm_cid_fork(struct task_struct *t)
 	WARN_ON_ONCE(!mm || t->mm_cid.cid != MM_CID_UNSET);
 
 	guard(mutex)(&mm->mm_cid.mutex);
-	scoped_guard(raw_spinlock_irq, &mm->mm_cid.lock) {
-		struct mm_cid_pcpu *pcp = this_cpu_ptr(mm->mm_cid.pcpu);
+	scoped_guard(rq_lock_irq, this_rq()) {
+		struct mm_cid_pcpu *pcp = mm_cid_pcpu(&mm->mm_cid, this_rq());
+		guard(raw_spinlock)(&mm->mm_cid.lock);
 
 		/* First user ? */
 		if (!mm->mm_cid.users) {
@@ -10777,7 +10799,7 @@ void sched_mm_cid_fork(struct task_struct *t)
 	}
 
 	if (percpu) {
-		mm_cid_fixup_tasks_to_cpus();
+		mm_cid_fixup_tasks_to_cpus(mm);
 	} else {
 		mm_cid_fixup_cpus_to_tasks(mm);
 		t->mm_cid.cid = mm_get_cid(mm);
@@ -10785,6 +10807,8 @@ void sched_mm_cid_fork(struct task_struct *t)
 }
 
 static bool sched_mm_cid_remove_user(struct task_struct *t)
+	__must_hold(t->mm->mm_cid.mutex)
+	__must_hold(t->mm->mm_cid.lock)
 {
 	t->mm_cid.active = 0;
 	scoped_guard(preempt) {
@@ -10792,11 +10816,13 @@ static bool sched_mm_cid_remove_user(struct task_struct *t)
 		t->mm_cid.cid = cid_from_transit_cid(t->mm_cid.cid);
 		mm_unset_cid_on_task(t);
 	}
-	t->mm->mm_cid.users--;
+	t->mm->mm_cid.users--; /* mutex && lock */
 	return mm_update_max_cids(t->mm);
 }
 
 static bool __sched_mm_cid_exit(struct task_struct *t)
+	__must_hold(t->mm->mm_cid.mutex)
+	__must_hold(t->mm->mm_cid.lock)
 {
 	struct mm_struct *mm = t->mm;
 
@@ -10837,8 +10863,9 @@ void sched_mm_cid_exit(struct task_struct *t)
 	 */
 	scoped_guard(mutex, &mm->mm_cid.mutex) {
 		/* mm_cid::mutex is sufficient to protect mm_cid::users */
-		if (likely(mm->mm_cid.users > 1)) {
-			scoped_guard(raw_spinlock_irq, &mm->mm_cid.lock) {
+		if (likely(mm_cid_users(mm) > 1)) {
+			scoped_guard(rq_lock_irq, this_rq()) {
+				guard(raw_spinlock)(&mm->mm_cid.lock);
 				if (!__sched_mm_cid_exit(t))
 					return;
 				/*
@@ -10847,16 +10874,17 @@ void sched_mm_cid_exit(struct task_struct *t)
 				 * TRANSIT bit. If the CID is owned by the CPU
 				 * then drop it.
 				 */
-				mm_drop_cid_on_cpu(mm, this_cpu_ptr(mm->mm_cid.pcpu));
+				mm_drop_cid_on_cpu(mm, mm_cid_pcpu(&mm->mm_cid, this_rq()));
 			}
 			mm_cid_fixup_cpus_to_tasks(mm);
 			return;
 		}
 		/* Last user */
-		scoped_guard(raw_spinlock_irq, &mm->mm_cid.lock) {
+		scoped_guard(rq_lock_irq, this_rq()) {
+			guard(raw_spinlock)(&mm->mm_cid.lock);
 			/* Required across execve() */
 			if (t == current)
-				mm_cid_transit_to_task(t, this_cpu_ptr(mm->mm_cid.pcpu));
+				mm_cid_transit_to_task(t, mm_cid_pcpu(&mm->mm_cid, this_rq()));
 			/* Ignore mode change. There is nothing to do. */
 			sched_mm_cid_remove_user(t);
 		}
@@ -10893,7 +10921,7 @@ static void mm_cid_work_fn(struct work_struct *work)
 
 	guard(mutex)(&mm->mm_cid.mutex);
 	/* Did the last user task exit already? */
-	if (!mm->mm_cid.users)
+	if (!mm_cid_users(mm))
 		return;
 
 	scoped_guard(raw_spinlock_irq, &mm->mm_cid.lock) {
@@ -10924,13 +10952,14 @@ static void mm_cid_irq_work(struct irq_work *work)
 
 void mm_init_cid(struct mm_struct *mm, struct task_struct *p)
 {
-	mm->mm_cid.max_cids = 0;
 	mm->mm_cid.mode = 0;
-	mm->mm_cid.nr_cpus_allowed = p->nr_cpus_allowed;
-	mm->mm_cid.users = 0;
-	mm->mm_cid.pcpu_thrs = 0;
-	mm->mm_cid.update_deferred = 0;
-	raw_spin_lock_init(&mm->mm_cid.lock);
+	mm->mm_cid.max_cids = 0;
+	scoped_guard (raw_spinlock_init, &mm->mm_cid.lock) {
+		mm->mm_cid.nr_cpus_allowed = p->nr_cpus_allowed;
+		mm->mm_cid.users = 0;
+		mm->mm_cid.pcpu_thrs = 0;
+		mm->mm_cid.update_deferred = 0;
+	}
 	mutex_init(&mm->mm_cid.mutex);
 	mm->mm_cid.irq_work = IRQ_WORK_INIT_HARD(mm_cid_irq_work);
 	INIT_WORK(&mm->mm_cid.work, mm_cid_work_fn);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fd36ae390520..8c761822d6b2 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3870,13 +3870,39 @@ static __always_inline void mm_cid_update_task_cid(struct task_struct *t, unsign
 	}
 }
 
-static __always_inline void mm_cid_update_pcpu_cid(struct mm_struct *mm, unsigned int cid)
+/*
+ * Helpers to convert from __rq_lockp(rq) to RQ_LOCK intermediate.
+ */
+static __always_inline
+void mm_cid_update_pcpu_cid(struct rq *rq, struct mm_struct *mm, unsigned int cid)
+	__must_hold(__rq_lockp(rq))
 {
+	__assume_ctx_lock(RQ_LOCK);
+	lockdep_assert(rq->cpu == smp_processor_id());
 	__this_cpu_write(mm->mm_cid.pcpu->cid, cid);
 }
 
-static __always_inline void mm_cid_from_cpu(struct task_struct *t, unsigned int cpu_cid,
-					    unsigned int mode)
+static __always_inline
+unsigned int mm_cid_pcpu_cid(struct rq *rq, struct mm_struct *mm)
+	__must_hold(__rq_lockp(rq))
+{
+	__assume_ctx_lock(RQ_LOCK);
+	lockdep_assert(rq->cpu == smp_processor_id());
+	return __this_cpu_read(mm->mm_cid.pcpu->cid);
+}
+
+static __always_inline
+struct mm_cid_pcpu *mm_cid_pcpu(struct mm_mm_cid *mc, struct rq *rq)
+	__must_hold(__rq_lockp(rq))
+
+{
+	__assume_ctx_lock(RQ_LOCK);
+	return per_cpu_ptr(mc->pcpu, rq->cpu);
+}
+
+static __always_inline void mm_cid_from_cpu(struct rq *rq, struct task_struct *t,
+					    unsigned int cpu_cid, unsigned int mode)
+	__must_hold(__rq_lockp(rq))
 {
 	unsigned int max_cids, tcid = t->mm_cid.cid;
 	struct mm_struct *mm = t->mm;
@@ -3906,12 +3932,13 @@ static __always_inline void mm_cid_from_cpu(struct task_struct *t, unsigned int
 		if (mode & MM_CID_TRANSIT)
 			cpu_cid = cpu_cid_to_cid(cpu_cid) | MM_CID_TRANSIT;
 	}
-	mm_cid_update_pcpu_cid(mm, cpu_cid);
+	mm_cid_update_pcpu_cid(rq, mm, cpu_cid);
 	mm_cid_update_task_cid(t, cpu_cid);
 }
 
-static __always_inline void mm_cid_from_task(struct task_struct *t, unsigned int cpu_cid,
-					     unsigned int mode)
+static __always_inline void mm_cid_from_task(struct rq *rq, struct task_struct *t,
+					     unsigned int cpu_cid, unsigned int mode)
+	__must_hold(__rq_lockp(rq))
 {
 	unsigned int max_cids, tcid = t->mm_cid.cid;
 	struct mm_struct *mm = t->mm;
@@ -3920,7 +3947,7 @@ static __always_inline void mm_cid_from_task(struct task_struct *t, unsigned int
 	/* Optimize for the common case, where both have the ONCPU bit clear */
 	if (likely(cid_on_task(tcid | cpu_cid))) {
 		if (likely(tcid < max_cids)) {
-			mm_cid_update_pcpu_cid(mm, tcid);
+			mm_cid_update_pcpu_cid(rq, mm, tcid);
 			return;
 		}
 		/* Try to converge into the optimal CID space */
@@ -3929,7 +3956,7 @@ static __always_inline void mm_cid_from_task(struct task_struct *t, unsigned int
 		/* Hand over or drop the CPU owned CID */
 		if (cid_on_cpu(cpu_cid)) {
 			if (cid_on_task(tcid))
-				mm_drop_cid_on_cpu(mm, this_cpu_ptr(mm->mm_cid.pcpu));
+				mm_drop_cid_on_cpu(mm, mm_cid_pcpu(&mm->mm_cid, rq));
 			else
 				tcid = cpu_cid_to_cid(cpu_cid);
 		}
@@ -3939,11 +3966,12 @@ static __always_inline void mm_cid_from_task(struct task_struct *t, unsigned int
 		/* Set the transition mode flag if required */
 		tcid |= mode & MM_CID_TRANSIT;
 	}
-	mm_cid_update_pcpu_cid(mm, tcid);
+	mm_cid_update_pcpu_cid(rq, mm, tcid);
 	mm_cid_update_task_cid(t, tcid);
 }
 
-static __always_inline void mm_cid_schedin(struct task_struct *next)
+static __always_inline void mm_cid_schedin(struct rq *rq, struct task_struct *next)
+	__must_hold(__rq_lockp(rq))
 {
 	struct mm_struct *mm = next->mm;
 	unsigned int cpu_cid, mode;
@@ -3951,15 +3979,16 @@ static __always_inline void mm_cid_schedin(struct task_struct *next)
 	if (!next->mm_cid.active)
 		return;
 
-	cpu_cid = __this_cpu_read(mm->mm_cid.pcpu->cid);
+	cpu_cid = mm_cid_pcpu_cid(rq, mm);
 	mode = READ_ONCE(mm->mm_cid.mode);
 	if (likely(!cid_on_cpu(mode)))
-		mm_cid_from_task(next, cpu_cid, mode);
+		mm_cid_from_task(rq, next, cpu_cid, mode);
 	else
-		mm_cid_from_cpu(next, cpu_cid, mode);
+		mm_cid_from_cpu(rq, next, cpu_cid, mode);
 }
 
-static __always_inline void mm_cid_schedout(struct task_struct *prev)
+static __always_inline void mm_cid_schedout(struct rq *rq, struct task_struct *prev)
+	__must_hold(__rq_lockp(rq))
 {
 	struct mm_struct *mm = prev->mm;
 	unsigned int mode, cid;
@@ -3980,7 +4009,7 @@ static __always_inline void mm_cid_schedout(struct task_struct *prev)
 			cid = cid_to_cpu_cid(cid);
 
 		/* Update both so that the next schedule in goes into the fast path */
-		mm_cid_update_pcpu_cid(mm, cid);
+		mm_cid_update_pcpu_cid(rq, mm, cid);
 		prev->mm_cid.cid = cid;
 	} else {
 		mm_drop_cid(mm, cid);
@@ -3988,10 +4017,12 @@ static __always_inline void mm_cid_schedout(struct task_struct *prev)
 	}
 }
 
-static inline void mm_cid_switch_to(struct task_struct *prev, struct task_struct *next)
+static inline void mm_cid_switch_to(struct rq *rq, struct task_struct *prev,
+				    struct task_struct *next)
+	__must_hold(__rq_lockp(rq))
 {
-	mm_cid_schedout(prev);
-	mm_cid_schedin(next);
+	mm_cid_schedout(rq, prev);
+	mm_cid_schedin(rq, next);
 }
 
 #else /* !CONFIG_SCHED_MM_CID: */

