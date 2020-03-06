Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E45B917C97A
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 01:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCGAMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 19:12:20 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54694 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgCGAMT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 19:12:19 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jAN4V-0007au-El; Sat, 07 Mar 2020 01:12:04 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id EA253104088;
        Sat,  7 Mar 2020 01:12:02 +0100 (CET)
Message-Id: <20200307000259.340436953@linutronix.de>
User-Agent: quilt/0.65
Date:   Sat, 07 Mar 2020 00:42:05 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andy Lutomirski <luto@kernel.org>
Subject: [patch 1/2] x86/kvm: Handle async page faults directly through do_page_fault()
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

From: Andy Lutomirski <luto@kernel.org>

KVM overloads #PF to indicate two types of not-actually-page-fault
events.  Right now, the KVM guest code intercepts them by modifying
the IDT and hooking the #PF vector.  This makes the already fragile
fault code even harder to understand, and it also pollutes call
traces with async_page_fault and do_async_page_fault for normal page
faults.

Clean it up by moving the logic into do_page_fault() using a static
branch.  This gets rid of the platform trap_init override mechanism
completely.

[ tglx: Fixed up 32bit, removed error code from the async functions and
  	massaged coding style ]

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/entry/entry_32.S       |    8 --------
 arch/x86/entry/entry_64.S       |    4 ----
 arch/x86/include/asm/kvm_para.h |   19 +++++++++++++++++--
 arch/x86/include/asm/x86_init.h |    2 --
 arch/x86/kernel/kvm.c           |   39 +++++++++++++++++++++------------------
 arch/x86/kernel/traps.c         |    2 --
 arch/x86/kernel/x86_init.c      |    1 -
 arch/x86/mm/fault.c             |   19 +++++++++++++++++++
 8 files changed, 57 insertions(+), 37 deletions(-)

--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -1698,14 +1698,6 @@ SYM_CODE_START(general_protection)
 	jmp	common_exception
 SYM_CODE_END(general_protection)
 
-#ifdef CONFIG_KVM_GUEST
-SYM_CODE_START(async_page_fault)
-	ASM_CLAC
-	pushl	$do_async_page_fault
-	jmp	common_exception_read_cr2
-SYM_CODE_END(async_page_fault)
-#endif
-
 SYM_CODE_START(rewind_stack_do_exit)
 	/* Prevent any naive code from trying to unwind to our caller. */
 	xorl	%ebp, %ebp
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1202,10 +1202,6 @@ idtentry xendebug		do_debug		has_error_c
 idtentry general_protection	do_general_protection	has_error_code=1
 idtentry page_fault		do_page_fault		has_error_code=1	read_cr2=1
 
-#ifdef CONFIG_KVM_GUEST
-idtentry async_page_fault	do_async_page_fault	has_error_code=1	read_cr2=1
-#endif
-
 #ifdef CONFIG_X86_MCE
 idtentry machine_check		do_mce			has_error_code=0	paranoid=1
 #endif
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -91,8 +91,18 @@ unsigned int kvm_arch_para_hints(void);
 void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
-extern void kvm_disable_steal_time(void);
-void do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address);
+void kvm_disable_steal_time(void);
+bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token);
+
+DECLARE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
+
+static __always_inline bool kvm_handle_async_pf(struct pt_regs *regs, u32 token)
+{
+	if (static_branch_unlikely(&kvm_async_pf_enabled))
+		return __kvm_handle_async_pf(regs, token);
+	else
+		return false;
+}
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void __init kvm_spinlock_init(void);
@@ -130,6 +140,11 @@ static inline void kvm_disable_steal_tim
 {
 	return;
 }
+
+static inline bool kvm_handle_async_pf(struct pt_regs *regs, u32 token)
+{
+	return false;
+}
 #endif
 
 #endif /* _ASM_X86_KVM_PARA_H */
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -50,14 +50,12 @@ struct x86_init_resources {
  * @pre_vector_init:		init code to run before interrupt vectors
  *				are set up.
  * @intr_init:			interrupt init code
- * @trap_init:			platform specific trap setup
  * @intr_mode_select:		interrupt delivery mode selection
  * @intr_mode_init:		interrupt delivery mode setup
  */
 struct x86_init_irqs {
 	void (*pre_vector_init)(void);
 	void (*intr_init)(void);
-	void (*trap_init)(void);
 	void (*intr_mode_select)(void);
 	void (*intr_mode_init)(void);
 };
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -35,6 +35,8 @@
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
 
+DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
+
 static int kvmapf = 1;
 
 static int __init parse_no_kvmapf(char *arg)
@@ -242,25 +244,27 @@ u32 kvm_read_and_reset_pf_reason(void)
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
 NOKPROBE_SYMBOL(kvm_read_and_reset_pf_reason);
 
-dotraplinkage void
-do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address)
+bool __kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 {
+	/*
+	 * If we get a page fault right here, the pf_reason seems likely
+	 * to be clobbered.  Bummer.
+	 */
 	switch (kvm_read_and_reset_pf_reason()) {
 	default:
-		do_page_fault(regs, error_code, address);
-		break;
+		return false;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
-		kvm_async_pf_task_wait((u32)address, !user_mode(regs));
-		break;
+		kvm_async_pf_task_wait(token, !user_mode(regs));
+		return true;
 	case KVM_PV_REASON_PAGE_READY:
 		rcu_irq_enter();
-		kvm_async_pf_task_wake((u32)address);
+		kvm_async_pf_task_wake(token);
 		rcu_irq_exit();
-		break;
+		return true;
 	}
 }
-NOKPROBE_SYMBOL(do_async_page_fault);
+NOKPROBE_SYMBOL(__kvm_handle_async_pf);
 
 static void __init paravirt_ops_setup(void)
 {
@@ -306,7 +310,11 @@ static notrace void kvm_guest_apic_eoi_w
 static void kvm_guest_cpu_init(void)
 {
 	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) && kvmapf) {
-		u64 pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
+		u64 pa;
+
+		WARN_ON_ONCE(!static_branch_likely(&kvm_async_pf_enabled));
+
+		pa = slow_virt_to_phys(this_cpu_ptr(&apf_reason));
 
 #ifdef CONFIG_PREEMPTION
 		pa |= KVM_ASYNC_PF_SEND_ALWAYS;
@@ -592,12 +600,6 @@ static int kvm_cpu_down_prepare(unsigned
 }
 #endif
 
-static void __init kvm_apf_trap_init(void)
-{
-	update_intr_gate(X86_TRAP_PF, async_page_fault);
-}
-
-
 static void kvm_flush_tlb_others(const struct cpumask *cpumask,
 			const struct flush_tlb_info *info)
 {
@@ -632,8 +634,6 @@ static void __init kvm_guest_init(void)
 	register_reboot_notifier(&kvm_pv_reboot_nb);
 	for (i = 0; i < KVM_TASK_SLEEP_HASHSIZE; i++)
 		raw_spin_lock_init(&async_pf_sleepers[i].lock);
-	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
-		x86_init.irqs.trap_init = kvm_apf_trap_init;
 
 	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
 		has_steal_clock = 1;
@@ -670,6 +670,9 @@ static void __init kvm_guest_init(void)
 	 * overcommitted.
 	 */
 	hardlockup_detector_disable();
+
+	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) && kvmapf)
+		static_branch_enable(&kvm_async_pf_enabled);
 }
 
 static noinline uint32_t __kvm_cpuid_base(void)
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -936,7 +936,5 @@ void __init trap_init(void)
 
 	idt_setup_ist_traps();
 
-	x86_init.irqs.trap_init();
-
 	idt_setup_debugidt_traps();
 }
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -79,7 +79,6 @@ struct x86_init_ops x86_init __initdata
 	.irqs = {
 		.pre_vector_init	= init_ISA_irqs,
 		.intr_init		= native_init_IRQ,
-		.trap_init		= x86_init_noop,
 		.intr_mode_select	= apic_intr_mode_select,
 		.intr_mode_init		= apic_intr_mode_init
 	},
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -30,6 +30,7 @@
 #include <asm/desc.h>			/* store_idt(), ...		*/
 #include <asm/cpu_entry_area.h>		/* exception stack		*/
 #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
+#include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -1505,6 +1506,24 @@ do_page_fault(struct pt_regs *regs, unsi
 		unsigned long address)
 {
 	prefetchw(&current->mm->mmap_sem);
+	/*
+	 * KVM has two types of events that are, logically, interrupts, but
+	 * are unfortunately delivered using the #PF vector.  These events are
+	 * "you just accessed valid memory, but the host doesn't have it right
+	 * now, so I'll put you to sleep if you continue" and "that memory
+	 * you tried to access earlier is available now."
+	 *
+	 * We are relying on the interrupted context being sane (valid RSP,
+	 * relevant locks not held, etc.), which is fine as long as the
+	 * interrupted context had IF=1.  We are also relying on the KVM
+	 * async pf type field and CR2 being read consistently instead of
+	 * getting values from real and async page faults mixed up.
+	 *
+	 * Fingers crossed.
+	 */
+	if (kvm_handle_async_pf(regs, (u32)address))
+		return;
+
 	trace_page_fault_entries(regs, hw_error_code, address);
 
 	if (unlikely(kmmio_fault(regs, address)))

