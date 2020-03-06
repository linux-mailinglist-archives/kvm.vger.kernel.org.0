Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49FBF17C979
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 01:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCGAMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 19:12:14 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54688 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgCGAMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 19:12:14 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jAN4V-0007av-Pl; Sat, 07 Mar 2020 01:12:04 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 2F759104097;
        Sat,  7 Mar 2020 01:12:03 +0100 (CET)
Message-Id: <20200307000259.448059232@linutronix.de>
User-Agent: quilt/0.65
Date:   Sat, 07 Mar 2020 00:42:06 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [patch 2/2] x86/kvm: Sanitize kvm_async_pf_task_wait()
References: <20200306234204.847674001@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While working on the entry consolidation I stumbled over the KVM async page
fault handler and kvm_async_pf_task_wait() in particular. It took me a
while to realize that the randomly sprinkled around rcu_irq_enter()/exit()
invocations are just cargo cult programming. Several patches "fixed" RCU
splats by curing the symptoms without noticing that the code is flawed 
from a design perspective.

The main problem is that this async injection is not based on a proper
handshake mechanism and only respects the minimal requirement, i.e. the
guest is not in a state where it has interrupts disabled.

Aside of that the actual code is a convoluted one fits it all swiss army
knife. It is invoked from different places with different RCU constraints:

  1) Host side:

     vcpu_enter_guest()
       kvm_x86_ops->handle_exit()
         kvm_handle_page_fault()
           kvm_async_pf_task_wait()

     The invocation happens from fully preemptible context.

  2) Guest side:

     The async page fault interrupted:

         a) user space

	 b) preemptible kernel code which is not in a RCU read side
	    critical section

     	 c) non-preemtible kernel code or a RCU read side critical section
	    or kernel code with CONFIG_PREEMPTION=n which allows not to
	    differentiate between #2b and #2c.

RCU is watching for:

  #1  The vCPU exited and current is definitely not the idle task

  #2a The #PF entry code on the guest went through enter_from_user_mode()
      which reactivates RCU

  #2b There is no preemptible, interrupts enabled code in the kernel
      which can run with RCU looking away. (The idle task is always
      non preemptible).

I.e. all schedulable states (#1, #2a, #2b) do not need any of this RCU
voodoo at all.

In #2c RCU is eventually not watching, but as that state cannot schedule
anyway there is no point to worry about it so it has to invoke
rcu_irq_enter() before running that code. This can be optimized, but this
will be done as an extra step in course of the entry code consolidation
work.

So the proper solution for this is to:

  - Split kvm_async_pf_task_wait() into schedule and halt based waiting
    interfaces which share the enqueueing code.

  - Add comments (condensed form of this changelog) to spare others the
    time waste and pain of reverse engineering all of this with the help of
    uncomprehensible changelogs and code history.

  - Invoke kvm_async_pf_task_wait_schedule() from kvm_handle_page_fault(),
    user mode and schedulable kernel side async page faults (#1, #2a, #2b)

  - Invoke kvm_async_pf_task_wait_halt() for the non schedulable kernel
    case (#2c).

    For this case also remove the rcu_irq_exit()/enter() pair around the
    halt as it is just a pointless exercise:

       - vCPUs can VMEXIT at any any random point and can be scheduled out
         for an arbitrary amount of time by the host and this is not any
         different except that it voluntary triggers the exit via halt.

       - The interrupted context could have RCU watching already. So the
	 rcu_irq_exit() before the halt is not gaining anything aside of
	 confusing the reader. Claiming that this might prevent RCU stalls
	 is just an illusion.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/kvm_para.h |    2 
 arch/x86/kernel/kvm.c           |  156 ++++++++++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu.c          |    2 
 3 files changed, 115 insertions(+), 45 deletions(-)

--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -88,7 +88,7 @@ static inline long kvm_hypercall4(unsign
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
-void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
+void kvm_async_pf_task_wait_schedule(u32 token);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 void kvm_disable_steal_time(void);
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -75,7 +75,7 @@ struct kvm_task_sleep_node {
 	struct swait_queue_head wq;
 	u32 token;
 	int cpu;
-	bool halted;
+	bool use_halt;
 };
 
 static struct kvm_task_sleep_head {
@@ -98,75 +98,145 @@ static struct kvm_task_sleep_node *_find
 	return NULL;
 }
 
-/*
- * @interrupt_kernel: Is this called from a routine which interrupts the kernel
- * 		      (other than user space)?
- */
-void kvm_async_pf_task_wait(u32 token, int interrupt_kernel)
+static bool kvm_async_pf_queue_task(u32 token, bool use_halt,
+				    struct kvm_task_sleep_node *n)
 {
 	u32 key = hash_32(token, KVM_TASK_SLEEP_HASHBITS);
 	struct kvm_task_sleep_head *b = &async_pf_sleepers[key];
-	struct kvm_task_sleep_node n, *e;
-	DECLARE_SWAITQUEUE(wait);
-
-	rcu_irq_enter();
+	struct kvm_task_sleep_node *e;
 
 	raw_spin_lock(&b->lock);
 	e = _find_apf_task(b, token);
 	if (e) {
 		/* dummy entry exist -> wake up was delivered ahead of PF */
 		hlist_del(&e->link);
-		kfree(e);
 		raw_spin_unlock(&b->lock);
+		kfree(e);
+		return false;
+	}
 
-		rcu_irq_exit();
+	n->token = token;
+	n->cpu = smp_processor_id();
+	n->use_halt = use_halt;
+	init_swait_queue_head(&n->wq);
+	hlist_add_head(&n->link, &b->list);
+	raw_spin_unlock(&b->lock);
+	return true;
+}
+
+/*
+ * kvm_async_pf_task_wait_schedule - Wait for pagefault to be handled
+ * @token:	Token to identify the sleep node entry
+ *
+ * Invoked from the async pagefault handling code or from the VM exit page
+ * fault handler. In both cases RCU is watching.
+ */
+void kvm_async_pf_task_wait_schedule(u32 token)
+{
+	struct kvm_task_sleep_node n;
+	DECLARE_SWAITQUEUE(wait);
+
+	lockdep_assert_irqs_disabled();
+
+	if (!kvm_async_pf_queue_task(token, false, &n))
 		return;
+
+	for (;;) {
+		prepare_to_swait_exclusive(&n.wq, &wait, TASK_UNINTERRUPTIBLE);
+		if (hlist_unhashed(&n.link))
+			break;
+
+		local_irq_enable();
+		schedule();
+		local_irq_disable();
 	}
+	finish_swait(&n.wq, &wait);
+}
+EXPORT_SYMBOL_GPL(kvm_async_pf_task_wait_schedule);
 
-	n.token = token;
-	n.cpu = smp_processor_id();
-	n.halted = is_idle_task(current) ||
-		   (IS_ENABLED(CONFIG_PREEMPT_COUNT)
-		    ? preempt_count() > 1 || rcu_preempt_depth()
-		    : interrupt_kernel);
-	init_swait_queue_head(&n.wq);
-	hlist_add_head(&n.link, &b->list);
-	raw_spin_unlock(&b->lock);
+/*
+ * Invoked from the async page fault handler.
+ */
+static void kvm_async_pf_task_wait_halt(u32 token)
+{
+	struct kvm_task_sleep_node n;
+
+	if (!kvm_async_pf_queue_task(token, true, &n))
+		return;
 
 	for (;;) {
-		if (!n.halted)
-			prepare_to_swait_exclusive(&n.wq, &wait, TASK_UNINTERRUPTIBLE);
 		if (hlist_unhashed(&n.link))
 			break;
+		/*
+		 * No point in doing anything about RCU here. Any RCU read
+		 * side critical section or RCU watching section can be
+		 * interrupted by VMEXITs and the host is free to keep the
+		 * vCPU scheduled out as long as it sees fit. This is not
+		 * any different just because of the halt induced voluntary
+		 * VMEXIT.
+		 *
+		 * Also the async page fault could have interrupted any RCU
+		 * watching context, so invoking rcu_irq_exit()/enter()
+		 * around this is not gaining anything.
+		 */
+		native_safe_halt();
+		local_irq_disable();
+	}
+}
 
-		rcu_irq_exit();
+/* Invoked from the async page fault handler */
+static void kvm_async_pf_task_wait(u32 token, bool usermode)
+{
+	bool can_schedule;
 
-		if (!n.halted) {
-			local_irq_enable();
-			schedule();
-			local_irq_disable();
-		} else {
-			/*
-			 * We cannot reschedule. So halt.
-			 */
-			native_safe_halt();
-			local_irq_disable();
-		}
+	/*
+	 * No need to check whether interrupts were disabled because the
+	 * host will (hopefully) only inject an async page fault into
+	 * interrupt enabled regions.
+	 *
+	 * If CONFIG_PREEMPTION is enabled then check whether the code
+	 * which triggered the page fault is preemptible. This covers user
+	 * mode as well because preempt_count() is obviously 0 there.
+	 *
+	 * The check for rcu_preempt_depth() is also required because
+	 * voluntary scheduling inside a rcu read locked section is not
+	 * allowed.
+	 *
+	 * The idle task is already covered by this because idle always
+	 * has a preempt count > 0.
+	 *
+	 * If CONFIG_PREEMPTION is disabled only allow scheduling when
+	 * coming from user mode as there is no indication whether the
+	 * context which triggered the page fault could schedule or not.
+	 */
+	if (IS_ENABLED(CONFIG_PREEMPTION))
+		can_schedule = preempt_count() + rcu_preempt_depth() == 0;
+	else
+		can_schedule = usermode;
 
+	/*
+	 * If the kernel context is allowed to schedule then RCU is
+	 * watching because no preemptible code in the kernel is inside RCU
+	 * idle state. So it can be treated like user mode. User mode is
+	 * safe because the #PF entry invoked enter_from_user_mode().
+	 *
+	 * For the non schedulable case invoke rcu_irq_enter() for
+	 * now. This will be moved out to the pagefault entry code later
+	 * and only invoked when really needed.
+	 */
+	if (can_schedule) {
+		kvm_async_pf_task_wait_schedule(token);
+	} else {
 		rcu_irq_enter();
+		kvm_async_pf_task_wait_halt(token);
+		rcu_irq_exit();
 	}
-	if (!n.halted)
-		finish_swait(&n.wq, &wait);
-
-	rcu_irq_exit();
-	return;
 }
-EXPORT_SYMBOL_GPL(kvm_async_pf_task_wait);
 
 static void apf_task_wake_one(struct kvm_task_sleep_node *n)
 {
 	hlist_del_init(&n->link);
-	if (n->halted)
+	if (n->use_halt)
 		smp_send_reschedule(n->cpu);
 	else if (swq_has_sleeper(&n->wq))
 		swake_up_one(&n->wq);
@@ -255,7 +325,7 @@ bool __kvm_handle_async_pf(struct pt_reg
 		return false;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
-		kvm_async_pf_task_wait(token, !user_mode(regs));
+		kvm_async_pf_task_wait(token, user_mode(regs));
 		return true;
 	case KVM_PV_REASON_PAGE_READY:
 		rcu_irq_enter();
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4205,7 +4205,7 @@ int kvm_handle_page_fault(struct kvm_vcp
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		vcpu->arch.apf.host_apf_reason = 0;
 		local_irq_disable();
-		kvm_async_pf_task_wait(fault_address, 0);
+		kvm_async_pf_task_wait_schedule(fault_address);
 		local_irq_enable();
 		break;
 	case KVM_PV_REASON_PAGE_READY:

