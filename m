Return-Path: <kvm+bounces-73100-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SGcpMaUHq2kMZgEAu9opvQ
	(envelope-from <kvm+bounces-73100-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:58:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 54A2C22590C
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 17:58:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A5B853042D47
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 16:57:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981DD401484;
	Fri,  6 Mar 2026 16:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCEFH8g4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6B733BBC6;
	Fri,  6 Mar 2026 16:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772816245; cv=none; b=dekzVQUWJCqJ5V5ZYM0mFdr0TyMqeGb37OXhWFA1m65GurpddF/dGS8xcubXX/4gV3lfI6qpxuvytSdnHE7VHDzo2S71nlvx1LTf8AieyHiEeTNPMRcvVsvZKI1koQ3K4EkrRf0XZCffO7lqRq/FfRSQdMRk3ogpMt+zfqskcRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772816245; c=relaxed/simple;
	bh=eaABNllMG0qTbtWw4Y2G9zMyK6AnHKYBqWoLTy3MoZs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=GsA91B0V1fki6h7dAWHd3RYjthwbf6FVvMbUdYi4vq52OZVt6gnEid6tWRlrUHvM+JqSnehJelFzXq1x00IhVofMEN7gcIN7leGSR72zf6LFKFuDctwDPCqivr5otSd7s3PHBlhU4LuTaPlkXMtzv2DujluZJ2M4o73lYU9g1Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DCEFH8g4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E8FC4CEF7;
	Fri,  6 Mar 2026 16:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772816245;
	bh=eaABNllMG0qTbtWw4Y2G9zMyK6AnHKYBqWoLTy3MoZs=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=DCEFH8g4MVZzxEJLk1gFC38/FByh62Ts5Is8J4c0LdCQZrDbVJJ8jKJwNJRUiiEQq
	 4HotBbKq0R34CMIh+QadGC6vEtrvpaWx0qZAqLg/tgVsN/Zh3U16evf2Xl7FzPlpyz
	 1kfq7nDlYYN81Gx97RaKAV4+QQeM3yF97qsRcrgnf0frhpTFrTHRqWcEGpawtnxJlS
	 iE1hOSEmixn/knt+Yc+FbhDJgV+EN2nJRWXrRIGwmZfTwFj1NrMlN80cZXhwonko2z
	 UkcLeVt/Phh+IzM08d/PeaFVvx+4oXTfyKDnSfCAhol7/bQZQTTQ3MyGOf994BssJW
	 iViLbzGMk+2Ng==
Message-ID: <bacd7e6a-18a3-4e81-9b37-3e59fb1b2183@kernel.org>
Date: Fri, 6 Mar 2026 17:57:17 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: Stalls when starting a VSOCK listening socket: soft lockups, RCU
 stalls, timeout
Content-Language: en-GB, fr-BE
From: Matthieu Baerts <matttbe@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>, Jiri Slaby <jirislaby@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, kvm@vger.kernel.org,
 virtualization@lists.linux.dev, Netdev <netdev@vger.kernel.org>,
 rcu@vger.kernel.org, MPTCP Linux <mptcp@lists.linux.dev>,
 Linux Kernel <linux-kernel@vger.kernel.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, "luto@kernel.org"
 <luto@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <MKoutny@suse.com>,
 Waiman Long <longman@redhat.com>
References: <b24ffcb3-09d5-4e48-9070-0b69bc654281@kernel.org>
 <7f3e74d7-67dc-48d7-99d2-0b87f671651b@kernel.org>
 <863a5291-a636-47d0-891c-bb0524d2e134@kernel.org>
 <20260302114636.GL606826@noisy.programming.kicks-ass.net>
 <717310d8-6274-4b7f-8a19-561c45f5f565@kernel.org>
 <a2b573b4-af61-4b84-a7d1-012ed6bb23c9@kernel.org>
 <ba067933-bf3b-476d-a0bb-53eda56996ca@kernel.org> <87zf4m2qvo.ffs@tglx>
 <47cba228-bba7-4e58-a69d-ea41f8de6602@kernel.org> <87tsuu2i59.ffs@tglx>
 <7efde2b5-3b72-4858-9db0-22493d446301@kernel.org> <87qzpx2sck.ffs@tglx>
 <9798cb27-0f52-42fa-b0da-a7834039da1f@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <9798cb27-0f52-42fa-b0da-a7834039da1f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 54A2C22590C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73100-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[matttbe@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.989];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,opensuse.org:url]
X-Rspamd-Action: no action

Hi Thomas, Jiri, Peter,

On 06/03/2026 12:06, Matthieu Baerts wrote:
> On 06/03/2026 10:57, Thomas Gleixner wrote:
>> On Fri, Mar 06 2026 at 06:48, Jiri Slaby wrote:
>>> On 05. 03. 26, 20:25, Thomas Gleixner wrote:
>>>> Is there simple way to reproduce?
>>>
>>> Unfortunately not at all. To date, I even cannot reproduce locally, it 
>>> reproduces exclusively in opensuse build service (and github CI as per 
>>> Matthieu's report). I have a project in there with packages which fail 
>>> more often than others:
>>>    https://build.opensuse.org/project/monitor/home:jirislaby:softlockup
>>> But it's all green ATM.
>>>
>>> Builds of Go 1.24 and tests of rust 1.90 fail the most. The former even 
>>> takes only ~ 8 minutes, so it's not that intensive build at all. So the 
>>> reasons are unknown to me. At least, Go apparently uses threads for 
>>> building (unlike gcc/clang with forks/processes). Dunno about rust.
>>
>> I tried with tons of test cases which stress test mmcid with threads and
>> failed.
> 
> On my side, I didn't manage to reproduce it locally either.

Apparently I can now... sorry, I don't know why I was not able to do
that before!

(...)

> It is possible to locally launch the same command using the same QEMU
> version (but not the same host kernel) with the help of Docker:
> 
>   $ cd <kernel source code>
>   # docker run -v "${PWD}:${PWD}:rw" -w "${PWD}" --rm \
>     -it --privileged mptcp/mptcp-upstream-virtme-docker:latest \
>     manual normal
> 
> This will build a new kernel in O=.virtme/build, launch it and give you
> access to a prompt.
> 
> 
> After that, you can do also use the "auto" mode with the last built
> image to boot the VM, only print "OK", stop and retry if there were no
> errors:
> 
>   $ cd <kernel source code>
>   $ echo 'echo OK' > .virtme-exec-run
>   # i=1; \
>     while docker run -v "${PWD}:${PWD}:rw" -w "${PWD}" --rm \
>     -it --privileged mptcp/mptcp-upstream-virtme-docker:latest \
>     vm auto normal; do \
>       echo "== Attempt: $i: OK =="; \
>       i=$((i+1)); \
>     done; \
>     echo "== Failure after $i attempts =="

After having sent this email, I re-checked on my side, and I was able to
reproduce this issue with the technique described above: using the
docker image with "build" argument, then max 50 boot iterations with "vm
auto normal" argument. I then used 'git bisect' between v6.18 and
v6.19-rc1 to find the guilty commit, and got:

  653fda7ae73d ("sched/mmcid: Switch over to the new mechanism")

Reverting it on top of v6.19-rc1 fixes the issue.

Unfortunatelly, reverting it on top of Linus' tree causes some
conflicts. I did my best to resolve them, and with this patch attached
below -- also available in [1] -- I no longer have the issue. I don't
know if it is correct -- some quick tests don't show any issues -- nor
if Jiri should test it. I guess the final fix will be different from
this simple revert.

Note: I also tried Peter's patch (thank you for sharing it!), but I can
still reproduce the issue with it on top of Linus' tree.

[1] https://git.kernel.org/matttbe/net-next/c/5e4b47fd150c

Cheers,
Matt

---
diff --git a/include/linux/rseq.h b/include/linux/rseq.h
index b9d62fc2140d..ef4ff117d037 100644
--- a/include/linux/rseq.h
+++ b/include/linux/rseq.h
@@ -84,6 +84,24 @@ static __always_inline void rseq_sched_set_ids_changed(struct task_struct *t)
 	t->rseq.event.ids_changed = true;
 }
 
+/*
+ * Invoked from switch_mm_cid() in context switch when the task gets a MM
+ * CID assigned.
+ *
+ * This does not raise TIF_NOTIFY_RESUME as that happens in
+ * rseq_sched_switch_event().
+ */
+static __always_inline void rseq_sched_set_task_mm_cid(struct task_struct *t, unsigned int cid)
+{
+	/*
+	 * Requires a comparison as the switch_mm_cid() code does not
+	 * provide a conditional for it readily. So avoid excessive updates
+	 * when nothing changes.
+	 */
+	if (t->rseq.ids.mm_cid != cid)
+		t->rseq.event.ids_changed = true;
+}
+
 /* Enforce a full update after RSEQ registration and when execve() failed */
 static inline void rseq_force_update(void)
 {
@@ -163,6 +181,7 @@ static inline void rseq_handle_slowpath(struct pt_regs *regs) { }
 static inline void rseq_signal_deliver(struct ksignal *ksig, struct pt_regs *regs) { }
 static inline void rseq_sched_switch_event(struct task_struct *t) { }
 static inline void rseq_sched_set_ids_changed(struct task_struct *t) { }
+static inline void rseq_sched_set_task_mm_cid(struct task_struct *t, unsigned int cid) { }
 static inline void rseq_force_update(void) { }
 static inline void rseq_virt_userspace_exit(void) { }
 static inline void rseq_fork(struct task_struct *t, u64 clone_flags) { }
diff --git a/include/linux/rseq_types.h b/include/linux/rseq_types.h
index da5fa6f40294..61d294d3bbd7 100644
--- a/include/linux/rseq_types.h
+++ b/include/linux/rseq_types.h
@@ -131,18 +131,18 @@ struct rseq_data { };
 /**
  * struct sched_mm_cid - Storage for per task MM CID data
  * @active:	MM CID is active for the task
- * @cid:	The CID associated to the task either permanently or
- *		borrowed from the CPU
+ * @cid:	The CID associated to the task
+ * @last_cid:	The last CID associated to the task
  */
 struct sched_mm_cid {
 	unsigned int		active;
 	unsigned int		cid;
+	unsigned int		last_cid;
 };
 
 /**
  * struct mm_cid_pcpu - Storage for per CPU MM_CID data
- * @cid:	The CID associated to the CPU either permanently or
- *		while a task with a CID is running
+ * @cid:	The CID associated to the CPU
  */
 struct mm_cid_pcpu {
 	unsigned int	cid;
diff --git a/kernel/fork.c b/kernel/fork.c
index 65113a304518..af3f65f963e2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -999,6 +999,7 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 
 #ifdef CONFIG_SCHED_MM_CID
 	tsk->mm_cid.cid = MM_CID_UNSET;
+	tsk->mm_cid.last_cid = MM_CID_UNSET;
 	tsk->mm_cid.active = 0;
 #endif
 	return tsk;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7f77c165a6e..cc969711cb08 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5281,7 +5281,7 @@ context_switch(struct rq *rq, struct task_struct *prev,
 		}
 	}
 
-	mm_cid_switch_to(prev, next);
+	switch_mm_cid(prev, next);
 
 	/*
 	 * Tell rseq that the task was scheduled in. Must be after
@@ -10634,7 +10634,7 @@ static bool mm_cid_fixup_task_to_cpu(struct task_struct *t, struct mm_struct *mm
 	return true;
 }
 
-static void mm_cid_do_fixup_tasks_to_cpus(struct mm_struct *mm)
+static void __maybe_unused mm_cid_do_fixup_tasks_to_cpus(struct mm_struct *mm)
 {
 	struct task_struct *p, *t;
 	unsigned int users;
@@ -10673,7 +10673,7 @@ static void mm_cid_do_fixup_tasks_to_cpus(struct mm_struct *mm)
 	}
 }
 
-static void mm_cid_fixup_tasks_to_cpus(void)
+static void __maybe_unused mm_cid_fixup_tasks_to_cpus(void)
 {
 	struct mm_struct *mm = current->mm;
 
@@ -10691,81 +10691,25 @@ static bool sched_mm_cid_add_user(struct task_struct *t, struct mm_struct *mm)
 void sched_mm_cid_fork(struct task_struct *t)
 {
 	struct mm_struct *mm = t->mm;
-	bool percpu;
 
 	WARN_ON_ONCE(!mm || t->mm_cid.cid != MM_CID_UNSET);
 
 	guard(mutex)(&mm->mm_cid.mutex);
-	scoped_guard(raw_spinlock_irq, &mm->mm_cid.lock) {
-		struct mm_cid_pcpu *pcp = this_cpu_ptr(mm->mm_cid.pcpu);
-
-		/* First user ? */
-		if (!mm->mm_cid.users) {
-			sched_mm_cid_add_user(t, mm);
-			t->mm_cid.cid = mm_get_cid(mm);
-			/* Required for execve() */
-			pcp->cid = t->mm_cid.cid;
-			return;
-		}
-
-		if (!sched_mm_cid_add_user(t, mm)) {
-			if (!cid_on_cpu(mm->mm_cid.mode))
-				t->mm_cid.cid = mm_get_cid(mm);
-			return;
-		}
-
-		/* Handle the mode change and transfer current's CID */
-		percpu = cid_on_cpu(mm->mm_cid.mode);
-		if (!percpu)
-			mm_cid_transit_to_task(current, pcp);
-		else
-			mm_cid_transit_to_cpu(current, pcp);
-	}
-
-	if (percpu) {
-		mm_cid_fixup_tasks_to_cpus();
-	} else {
-		mm_cid_fixup_cpus_to_tasks(mm);
-		t->mm_cid.cid = mm_get_cid(mm);
+	scoped_guard(raw_spinlock, &mm->mm_cid.lock) {
+		sched_mm_cid_add_user(t, mm);
+		/* Preset last_cid for mm_cid_select() */
+		t->mm_cid.last_cid = mm->mm_cid.max_cids - 1;
 	}
 }
 
 static bool sched_mm_cid_remove_user(struct task_struct *t)
 {
 	t->mm_cid.active = 0;
-	scoped_guard(preempt) {
-		/* Clear the transition bit */
-		t->mm_cid.cid = cid_from_transit_cid(t->mm_cid.cid);
-		mm_unset_cid_on_task(t);
-	}
+	mm_unset_cid_on_task(t);
 	t->mm->mm_cid.users--;
 	return mm_update_max_cids(t->mm);
 }
 
-static bool __sched_mm_cid_exit(struct task_struct *t)
-{
-	struct mm_struct *mm = t->mm;
-
-	if (!sched_mm_cid_remove_user(t))
-		return false;
-	/*
-	 * Contrary to fork() this only deals with a switch back to per
-	 * task mode either because the above decreased users or an
-	 * affinity change increased the number of allowed CPUs and the
-	 * deferred fixup did not run yet.
-	 */
-	if (WARN_ON_ONCE(cid_on_cpu(mm->mm_cid.mode)))
-		return false;
-	/*
-	 * A failed fork(2) cleanup never gets here, so @current must have
-	 * the same MM as @t. That's true for exit() and the failed
-	 * pthread_create() cleanup case.
-	 */
-	if (WARN_ON_ONCE(current->mm != mm))
-		return false;
-	return true;
-}
-
 /*
  * When a task exits, the MM CID held by the task is not longer required as
  * the task cannot return to user space.
@@ -10776,48 +10720,10 @@ void sched_mm_cid_exit(struct task_struct *t)
 
 	if (!mm || !t->mm_cid.active)
 		return;
-	/*
-	 * Ensure that only one instance is doing MM CID operations within
-	 * a MM. The common case is uncontended. The rare fixup case adds
-	 * some overhead.
-	 */
-	scoped_guard(mutex, &mm->mm_cid.mutex) {
-		/* mm_cid::mutex is sufficient to protect mm_cid::users */
-		if (likely(mm->mm_cid.users > 1)) {
-			scoped_guard(raw_spinlock_irq, &mm->mm_cid.lock) {
-				if (!__sched_mm_cid_exit(t))
-					return;
-				/*
-				 * Mode change. The task has the CID unset
-				 * already and dealt with an eventually set
-				 * TRANSIT bit. If the CID is owned by the CPU
-				 * then drop it.
-				 */
-				mm_drop_cid_on_cpu(mm, this_cpu_ptr(mm->mm_cid.pcpu));
-			}
-			mm_cid_fixup_cpus_to_tasks(mm);
-			return;
-		}
-		/* Last user */
-		scoped_guard(raw_spinlock_irq, &mm->mm_cid.lock) {
-			/* Required across execve() */
-			if (t == current)
-				mm_cid_transit_to_task(t, this_cpu_ptr(mm->mm_cid.pcpu));
-			/* Ignore mode change. There is nothing to do. */
-			sched_mm_cid_remove_user(t);
-		}
-	}
 
-	/*
-	 * As this is the last user (execve(), process exit or failed
-	 * fork(2)) there is no concurrency anymore.
-	 *
-	 * Synchronize eventually pending work to ensure that there are no
-	 * dangling references left. @t->mm_cid.users is zero so nothing
-	 * can queue this work anymore.
-	 */
-	irq_work_sync(&mm->mm_cid.irq_work);
-	cancel_work_sync(&mm->mm_cid.work);
+	guard(mutex)(&mm->mm_cid.mutex);
+	scoped_guard(raw_spinlock, &mm->mm_cid.lock)
+		sched_mm_cid_remove_user(t);
 }
 
 /* Deactivate MM CID allocation across execve() */
@@ -10831,12 +10737,18 @@ void sched_mm_cid_after_execve(struct task_struct *t)
 {
 	if (t->mm)
 		sched_mm_cid_fork(t);
+	guard(preempt)();
+	mm_cid_select(t);
 }
 
 static void mm_cid_work_fn(struct work_struct *work)
 {
 	struct mm_struct *mm = container_of(work, struct mm_struct, mm_cid.work);
 
+	/* Make it compile, but not functional yet */
+	if (!IS_ENABLED(CONFIG_NEW_MM_CID))
+		return;
+
 	guard(mutex)(&mm->mm_cid.mutex);
 	/* Did the last user task exit already? */
 	if (!mm->mm_cid.users)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 43bbf0693cca..b60d49fc9c11 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -4003,7 +4003,83 @@ static inline void mm_cid_switch_to(struct task_struct *prev, struct task_struct
 	mm_cid_schedin(next);
 }
 
+/* Active implementation */
+static inline void init_sched_mm_cid(struct task_struct *t)
+{
+	struct mm_struct *mm = t->mm;
+	unsigned int max_cid;
+
+	if (!mm)
+		return;
+
+	/* Preset last_mm_cid */
+	max_cid = min_t(int, READ_ONCE(mm->mm_cid.nr_cpus_allowed), atomic_read(&mm->mm_users));
+	t->mm_cid.last_cid = max_cid - 1;
+}
+
+static inline bool __mm_cid_get(struct task_struct *t, unsigned int cid, unsigned int max_cids)
+{
+	struct mm_struct *mm = t->mm;
+
+	if (cid >= max_cids)
+		return false;
+	if (test_and_set_bit(cid, mm_cidmask(mm)))
+		return false;
+	t->mm_cid.cid = t->mm_cid.last_cid = cid;
+	__this_cpu_write(mm->mm_cid.pcpu->cid, cid);
+	return true;
+}
+
+static inline bool mm_cid_get(struct task_struct *t)
+{
+	struct mm_struct *mm = t->mm;
+	unsigned int max_cids;
+
+	max_cids = READ_ONCE(mm->mm_cid.max_cids);
+
+	/* Try to reuse the last CID of this task */
+	if (__mm_cid_get(t, t->mm_cid.last_cid, max_cids))
+		return true;
+
+	/* Try to reuse the last CID of this mm on this CPU */
+	if (__mm_cid_get(t, __this_cpu_read(mm->mm_cid.pcpu->cid), max_cids))
+		return true;
+
+	/* Try the first zero bit in the cidmask. */
+	return __mm_cid_get(t, find_first_zero_bit(mm_cidmask(mm), num_possible_cpus()), max_cids);
+}
+
+static inline void mm_cid_select(struct task_struct *t)
+{
+	/*
+	 * mm_cid_get() can fail when the maximum CID, which is determined
+	 * by min(mm->nr_cpus_allowed, mm->mm_users) changes concurrently.
+	 * That's a transient failure as there cannot be more tasks
+	 * concurrently on a CPU (or about to be scheduled in) than that.
+	 */
+	for (;;) {
+		if (mm_cid_get(t))
+			break;
+	}
+}
+
+static inline void switch_mm_cid(struct task_struct *prev, struct task_struct *next)
+{
+	if (prev->mm_cid.active) {
+		if (prev->mm_cid.cid != MM_CID_UNSET)
+			clear_bit(prev->mm_cid.cid, mm_cidmask(prev->mm));
+		prev->mm_cid.cid = MM_CID_UNSET;
+	}
+
+	if (next->mm_cid.active) {
+		mm_cid_select(next);
+		rseq_sched_set_task_mm_cid(next, next->mm_cid.cid);
+	}
+}
+
 #else /* !CONFIG_SCHED_MM_CID: */
+static inline void mm_cid_select(struct task_struct *t) { }
+static inline void switch_mm_cid(struct task_struct *prev, struct task_struct *next) { }
 static inline void mm_cid_switch_to(struct task_struct *prev, struct task_struct *next) { }
 #endif /* !CONFIG_SCHED_MM_CID */
 
-- 
Sponsored by the NGI0 Core fund.

