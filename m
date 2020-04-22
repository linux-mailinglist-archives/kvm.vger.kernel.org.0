Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D511B3601
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 06:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgDVEL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 00:11:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:60134 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726503AbgDVEL4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 00:11:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 02E0AAD89;
        Wed, 22 Apr 2020 04:11:52 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     bigeasy@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        joel@joelfernandes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dave@stgolabs.net,
        Paul Mackerras <paulus@ozlabs.org>,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 4/5] kvm: Replace vcpu->swait with rcuwait
Date:   Tue, 21 Apr 2020 21:07:38 -0700
Message-Id: <20200422040739.18601-5-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200422040739.18601-1-dave@stgolabs.net>
References: <20200422040739.18601-1-dave@stgolabs.net>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The use of any sort of waitqueue (simple or regular) for
wait/waking vcpus has always been an overkill and semantically
wrong. Because this is per-vcpu (which is blocked) there is
only ever a single waiting vcpu, thus no need for any sort of
queue.

As such, make use of the rcuwait primitive, with the following
considerations:

  - rcuwait already provides the proper barriers that serialize
  concurrent waiter and waker.

  - Task wakeup is done in rcu read critical region, with a
  stable task pointer.

  - Because there is no concurrency among waiters, we need
  not worry about rcuwait_wait_event() calls corrupting
  the wait->task. As a consequence, this saves the locking
  done in swait when modifying the queue. This also applies
  to per-vcore wait for powerpc kvm-hv.

The x86 tscdeadline_latency test mentioned in 8577370fb0cb
("KVM: Use simple waitqueue for vcpu->wq") shows that, on avg,
latency is reduced by around 15-20% with this change.

Cc: Paul Mackerras <paulus@ozlabs.org>
Cc: kvmarm@lists.cs.columbia.edu
Cc: linux-mips@vger.kernel.org
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 arch/mips/kvm/mips.c                  |  6 ++----
 arch/powerpc/include/asm/kvm_book3s.h |  2 +-
 arch/powerpc/include/asm/kvm_host.h   |  2 +-
 arch/powerpc/kvm/book3s_hv.c          | 22 ++++++++--------------
 arch/powerpc/kvm/powerpc.c            |  2 +-
 arch/x86/kvm/lapic.c                  |  2 +-
 include/linux/kvm_host.h              | 10 +++++-----
 virt/kvm/arm/arch_timer.c             |  2 +-
 virt/kvm/arm/arm.c                    |  9 +++++----
 virt/kvm/async_pf.c                   |  3 +--
 virt/kvm/kvm_main.c                   | 19 +++++++++----------
 11 files changed, 35 insertions(+), 44 deletions(-)

diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index 8f05dd0a0f4e..fad6acce46e4 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -284,8 +284,7 @@ static enum hrtimer_restart kvm_mips_comparecount_wakeup(struct hrtimer *timer)
 	kvm_mips_callbacks->queue_timer_int(vcpu);
 
 	vcpu->arch.wait = 0;
-	if (swq_has_sleeper(&vcpu->wq))
-		swake_up_one(&vcpu->wq);
+	rcuwait_wake_up(&vcpu->wait);
 
 	return kvm_mips_count_timeout(vcpu);
 }
@@ -511,8 +510,7 @@ int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 
 	dvcpu->arch.wait = 0;
 
-	if (swq_has_sleeper(&dvcpu->wq))
-		swake_up_one(&dvcpu->wq);
+	rcuwait_wake_up(&dvcpu->wait);
 
 	return 0;
 }
diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 506e4df2d730..6e5d85ba588d 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -78,7 +78,7 @@ struct kvmppc_vcore {
 	struct kvm_vcpu *runnable_threads[MAX_SMT_THREADS];
 	struct list_head preempt_list;
 	spinlock_t lock;
-	struct swait_queue_head wq;
+	struct rcuwait wait;
 	spinlock_t stoltb_lock;	/* protects stolen_tb and preempt_tb */
 	u64 stolen_tb;
 	u64 preempt_tb;
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 1dc63101ffe1..337047ba4a56 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -751,7 +751,7 @@ struct kvm_vcpu_arch {
 	u8 irq_pending; /* Used by XIVE to signal pending guest irqs */
 	u32 last_inst;
 
-	struct swait_queue_head *wqp;
+	struct rcuwait *waitp;
 	struct kvmppc_vcore *vcore;
 	int ret;
 	int trap;
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 93493f0cbfe8..b8d42f523ca7 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -230,13 +230,11 @@ static bool kvmppc_ipi_thread(int cpu)
 static void kvmppc_fast_vcpu_kick_hv(struct kvm_vcpu *vcpu)
 {
 	int cpu;
-	struct swait_queue_head *wqp;
+	struct rcuwait *wait;
 
-	wqp = kvm_arch_vcpu_wq(vcpu);
-	if (swq_has_sleeper(wqp)) {
-		swake_up_one(wqp);
+	wait = kvm_arch_vcpu_get_wait(vcpu);
+	if (rcuwait_wake_up(wait))
 		++vcpu->stat.halt_wakeup;
-	}
 
 	cpu = READ_ONCE(vcpu->arch.thread_cpu);
 	if (cpu >= 0 && kvmppc_ipi_thread(cpu))
@@ -2125,7 +2123,7 @@ static struct kvmppc_vcore *kvmppc_vcore_create(struct kvm *kvm, int id)
 
 	spin_lock_init(&vcore->lock);
 	spin_lock_init(&vcore->stoltb_lock);
-	init_swait_queue_head(&vcore->wq);
+	rcuwait_init(&vcore->wait);
 	vcore->preempt_tb = TB_NIL;
 	vcore->lpcr = kvm->arch.lpcr;
 	vcore->first_vcpuid = id;
@@ -3784,7 +3782,6 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	ktime_t cur, start_poll, start_wait;
 	int do_sleep = 1;
 	u64 block_ns;
-	DECLARE_SWAITQUEUE(wait);
 
 	/* Poll for pending exceptions and ceded state */
 	cur = start_poll = ktime_get();
@@ -3812,10 +3809,7 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 		}
 	}
 
-	prepare_to_swait_exclusive(&vc->wq, &wait, TASK_INTERRUPTIBLE);
-
 	if (kvmppc_vcore_check_block(vc)) {
-		finish_swait(&vc->wq, &wait);
 		do_sleep = 0;
 		/* If we polled, count this as a successful poll */
 		if (vc->halt_poll_ns)
@@ -3828,8 +3822,8 @@ static void kvmppc_vcore_blocked(struct kvmppc_vcore *vc)
 	vc->vcore_state = VCORE_SLEEPING;
 	trace_kvmppc_vcore_blocked(vc, 0);
 	spin_unlock(&vc->lock);
-	schedule();
-	finish_swait(&vc->wq, &wait);
+	rcuwait_wait_event(&vc->wait,
+			   kvmppc_vcore_check_block(vc), TASK_INTERRUPTIBLE);
 	spin_lock(&vc->lock);
 	vc->vcore_state = VCORE_INACTIVE;
 	trace_kvmppc_vcore_blocked(vc, 1);
@@ -3940,7 +3934,7 @@ static int kvmppc_run_vcpu(struct kvm_run *kvm_run, struct kvm_vcpu *vcpu)
 			kvmppc_start_thread(vcpu, vc);
 			trace_kvm_guest_enter(vcpu);
 		} else if (vc->vcore_state == VCORE_SLEEPING) {
-			swake_up_one(&vc->wq);
+		        rcuwait_wake_up(&vc->wait);
 		}
 
 	}
@@ -4279,7 +4273,7 @@ static int kvmppc_vcpu_run_hv(struct kvm_run *run, struct kvm_vcpu *vcpu)
 	}
 	user_vrsave = mfspr(SPRN_VRSAVE);
 
-	vcpu->arch.wqp = &vcpu->arch.vcore->wq;
+	vcpu->arch.waitp = &vcpu->arch.vcore->wait;
 	vcpu->arch.pgdir = kvm->mm->pgd;
 	vcpu->arch.state = KVMPPC_VCPU_BUSY_IN_HOST;
 
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index e15166b0a16d..4a074b587520 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -751,7 +751,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (err)
 		goto out_vcpu_uninit;
 
-	vcpu->arch.wqp = &vcpu->wq;
+	vcpu->arch.waitp = &vcpu->wait;
 	kvmppc_create_vcpu_debugfs(vcpu, vcpu->vcpu_id);
 	return 0;
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9af25c97612a..fb2f56ba171d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1833,7 +1833,7 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 	/* If the preempt notifier has already run, it also called apic_timer_expired */
 	if (!apic->lapic_timer.hv_timer_in_use)
 		goto out;
-	WARN_ON(swait_active(&vcpu->wq));
+	WARN_ON(rcu_dereference(vcpu->wait.task));
 	cancel_hv_timer(apic);
 	apic_timer_expired(apic);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 6d58beb65454..fc34021546bd 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -23,7 +23,7 @@
 #include <linux/irqflags.h>
 #include <linux/context_tracking.h>
 #include <linux/irqbypass.h>
-#include <linux/swait.h>
+#include <linux/rcuwait.h>
 #include <linux/refcount.h>
 #include <linux/nospec.h>
 #include <asm/signal.h>
@@ -277,7 +277,7 @@ struct kvm_vcpu {
 	struct mutex mutex;
 	struct kvm_run *run;
 
-	struct swait_queue_head wq;
+	struct rcuwait wait;
 	struct pid __rcu *pid;
 	int sigset_active;
 	sigset_t sigset;
@@ -956,12 +956,12 @@ static inline bool kvm_arch_has_assigned_device(struct kvm *kvm)
 }
 #endif
 
-static inline struct swait_queue_head *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
+static inline struct rcuwait *kvm_arch_vcpu_get_wait(struct kvm_vcpu *vcpu)
 {
 #ifdef __KVM_HAVE_ARCH_WQP
-	return vcpu->arch.wqp;
+	return vcpu->arch.waitp;
 #else
-	return &vcpu->wq;
+	return &vcpu->wait;
 #endif
 }
 
diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 93bd59b46848..b2805105bbe5 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -593,7 +593,7 @@ void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu)
 	if (map.emul_ptimer)
 		soft_timer_cancel(&map.emul_ptimer->hrtimer);
 
-	if (swait_active(kvm_arch_vcpu_wq(vcpu)))
+	if (rcu_dereference(kvm_arch_vpu_get_wait(vcpu)) != NULL)
 		kvm_timer_blocking(vcpu);
 
 	/*
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 48d0ec44ad77..f94a10bb1251 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -579,16 +579,17 @@ void kvm_arm_resume_guest(struct kvm *kvm)
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		vcpu->arch.pause = false;
-		swake_up_one(kvm_arch_vcpu_wq(vcpu));
+		rcuwait_wake_up(kvm_arch_vcpu_get_wait(vcpu));
 	}
 }
 
 static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 {
-	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
+	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
-	swait_event_interruptible_exclusive(*wq, ((!vcpu->arch.power_off) &&
-				       (!vcpu->arch.pause)));
+	rcuwait_wait_event(*wait,
+			   (!vcpu->arch.power_off) &&(!vcpu->arch.pause),
+			   TASK_INTERRUPTIBLE);
 
 	if (vcpu->arch.power_off || vcpu->arch.pause) {
 		/* Awaken to handle a signal, request we sleep again later. */
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index 15e5b037f92d..10b533f641a6 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -80,8 +80,7 @@ static void async_pf_execute(struct work_struct *work)
 
 	trace_kvm_async_pf_completed(addr, cr2_or_gpa);
 
-	if (swq_has_sleeper(&vcpu->wq))
-		swake_up_one(&vcpu->wq);
+	rcuwait_wake_up(&vcpu->wait);
 
 	mmput(mm);
 	kvm_put_kvm(vcpu->kvm);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74bdb7bf3295..835fb109badf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -341,7 +341,7 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->kvm = kvm;
 	vcpu->vcpu_id = id;
 	vcpu->pid = NULL;
-	init_swait_queue_head(&vcpu->wq);
+	rcuwait_init(&vcpu->wait);
 	kvm_async_pf_vcpu_init(vcpu);
 
 	vcpu->pre_pcpu = -1;
@@ -2671,7 +2671,6 @@ static int kvm_vcpu_check_block(struct kvm_vcpu *vcpu)
 void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 {
 	ktime_t start, cur;
-	DECLARE_SWAITQUEUE(wait);
 	bool waited = false;
 	u64 block_ns;
 
@@ -2697,8 +2696,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		} while (single_task_running() && ktime_before(cur, stop));
 	}
 
+	prepare_to_rcuwait(&vcpu->wait);
 	for (;;) {
-		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
+		set_current_state(TASK_INTERRUPTIBLE);
 
 		if (kvm_vcpu_check_block(vcpu) < 0)
 			break;
@@ -2706,8 +2706,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		waited = true;
 		schedule();
 	}
-
-	finish_swait(&vcpu->wq, &wait);
+	finish_rcuwait(&vcpu->wait);
 	cur = ktime_get();
 out:
 	kvm_arch_vcpu_unblocking(vcpu);
@@ -2738,11 +2737,10 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_block);
 
 bool kvm_vcpu_wake_up(struct kvm_vcpu *vcpu)
 {
-	struct swait_queue_head *wqp;
+	struct rcuwait *wait;
 
-	wqp = kvm_arch_vcpu_wq(vcpu);
-	if (swq_has_sleeper(wqp)) {
-		swake_up_one(wqp);
+	wait = kvm_arch_vcpu_get_wait(vcpu);
+	if (rcuwait_wake_up(wait)) {
 		WRITE_ONCE(vcpu->ready, true);
 		++vcpu->stat.halt_wakeup;
 		return true;
@@ -2884,7 +2882,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 				continue;
 			if (vcpu == me)
 				continue;
-			if (swait_active(&vcpu->wq) && !vcpu_dy_runnable(vcpu))
+			if (rcu_dereference(vcpu->wait.task) &&
+			    !vcpu_dy_runnable(vcpu))
 				continue;
 			if (READ_ONCE(vcpu->preempted) && yield_to_kernel_mode &&
 				!kvm_arch_vcpu_in_kernel(vcpu))
-- 
2.16.4

