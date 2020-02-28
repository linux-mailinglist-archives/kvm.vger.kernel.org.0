Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B525173FD6
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2020 19:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbgB1Sm6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Feb 2020 13:42:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgB1Sm6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Feb 2020 13:42:58 -0500
Received: from localhost (c-67-180-165-146.hsd1.ca.comcast.net [67.180.165.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBCE924677;
        Fri, 28 Feb 2020 18:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582915376;
        bh=eAl5CYW0aDLQd2hTkXyJKqFnRf+gxtnaW7YBSBf6F3k=;
        h=From:To:Cc:Subject:Date:From;
        b=pCihTVHhkIKLnGn/N6n/O0W/d3KcUxDOoL7RyyzM47k0sjhzpj55zBfjR8tDe5SD2
         a/q10QdaVZgewaEVMYNpAcVi9W8gm2tbbbIDapgKri0TA53DZAZ09W6+7xC8/ooXKr
         wMQ6kXFd1M/jZt4IA3FnyT48FHubHcfvvDewbwhg=
From:   Andy Lutomirski <luto@kernel.org>
To:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>
Subject: [PATCH] x86/kvm: Handle async page faults directly through do_page_fault()
Date:   Fri, 28 Feb 2020 10:42:48 -0800
Message-Id: <6bf68d0facc36553324c38ec798b0feebf6742b7.1582915284.git.luto@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM overloads #PF to indicate two types of not-actually-page-fault
events.  Right now, the KVM guest code intercepts them by modifying
the IDT and hooking the #PF vector.  This makes the already fragile
fault code even harder to understand, and it also pollutes call
traces with async_page_fault and do_async_page_fault for normal page
faults.

Clean it up by moving the logic into do_page_fault() using a static
branch.  This gets rid of the platform trap_init override mechanism
completely.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/entry/entry_64.S       |  4 ----
 arch/x86/include/asm/kvm_para.h | 17 +++++++++++++++-
 arch/x86/include/asm/x86_init.h |  2 --
 arch/x86/kernel/kvm.c           | 36 +++++++++++++++++++--------------
 arch/x86/kernel/traps.c         |  2 --
 arch/x86/kernel/x86_init.c      |  1 -
 arch/x86/mm/fault.c             | 20 ++++++++++++++++++
 7 files changed, 57 insertions(+), 25 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index f2bb91e87877..be1fc6f2fe85 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1202,10 +1202,6 @@ idtentry xendebug		do_debug		has_error_code=0
 idtentry general_protection	do_general_protection	has_error_code=1
 idtentry page_fault		do_page_fault		has_error_code=1	read_cr2=1
 
-#ifdef CONFIG_KVM_GUEST
-idtentry async_page_fault	do_async_page_fault	has_error_code=1	read_cr2=1
-#endif
-
 #ifdef CONFIG_X86_MCE
 idtentry machine_check		do_mce			has_error_code=0	paranoid=1
 #endif
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 9b4df6eaa11a..4d72f5488584 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -92,7 +92,17 @@ void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
-void do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address);
+extern bool do_kvm_handle_async_pf(struct pt_regs *regs, unsigned long error_code, unsigned long address);
+
+DECLARE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
+
+static inline bool kvm_handle_async_pf(struct pt_regs *regs, unsigned long error_code, unsigned long address)
+{
+	if (static_branch_unlikely(&kvm_async_pf_enabled))
+		return do_kvm_handle_async_pf(regs, error_code, address);
+	else
+		return false;
+}
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void __init kvm_spinlock_init(void);
@@ -130,6 +140,11 @@ static inline void kvm_disable_steal_time(void)
 {
 	return;
 }
+
+static inline bool kvm_handle_async_pf(struct pt_regs *regs, unsigned long error_code, unsigned long address)
+{
+	return false;
+}
 #endif
 
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 96d9cd208610..6807153c0410 100644
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
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index d817f255aed8..93ab0cbd304e 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -35,6 +35,8 @@
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
 
+DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
+
 static int kvmapf = 1;
 
 static int __init parse_no_kvmapf(char *arg)
@@ -242,25 +244,29 @@ u32 kvm_read_and_reset_pf_reason(void)
 EXPORT_SYMBOL_GPL(kvm_read_and_reset_pf_reason);
 NOKPROBE_SYMBOL(kvm_read_and_reset_pf_reason);
 
-dotraplinkage void
-do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address)
+bool
+do_kvm_handle_async_pf(struct pt_regs *regs, unsigned long error_code, unsigned long address)
 {
+	/*
+	 * If we get a page fault right here, the pf_reason seems likely
+	 * to be clobbered.  Bummer.
+	 */
+
 	switch (kvm_read_and_reset_pf_reason()) {
 	default:
-		do_page_fault(regs, error_code, address);
-		break;
+		return false;
 	case KVM_PV_REASON_PAGE_NOT_PRESENT:
 		/* page is swapped out by the host. */
 		kvm_async_pf_task_wait((u32)address, !user_mode(regs));
-		break;
+		return true;
 	case KVM_PV_REASON_PAGE_READY:
 		rcu_irq_enter();
 		kvm_async_pf_task_wake((u32)address);
 		rcu_irq_exit();
-		break;
+		return true;
 	}
 }
-NOKPROBE_SYMBOL(do_async_page_fault);
+NOKPROBE_SYMBOL(do_kvm_handle_async_pf);
 
 static void __init paravirt_ops_setup(void)
 {
@@ -306,7 +312,11 @@ static notrace void kvm_guest_apic_eoi_write(u32 reg, u32 val)
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
@@ -570,11 +580,6 @@ static int kvm_cpu_down_prepare(unsigned int cpu)
 }
 #endif
 
-static void __init kvm_apf_trap_init(void)
-{
-	update_intr_gate(X86_TRAP_PF, async_page_fault);
-}
-
 static DEFINE_PER_CPU(cpumask_var_t, __pv_tlb_mask);
 
 static void kvm_flush_tlb_others(const struct cpumask *cpumask,
@@ -611,8 +616,6 @@ static void __init kvm_guest_init(void)
 	register_reboot_notifier(&kvm_pv_reboot_nb);
 	for (i = 0; i < KVM_TASK_SLEEP_HASHSIZE; i++)
 		raw_spin_lock_init(&async_pf_sleepers[i].lock);
-	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF))
-		x86_init.irqs.trap_init = kvm_apf_trap_init;
 
 	if (kvm_para_has_feature(KVM_FEATURE_STEAL_TIME)) {
 		has_steal_clock = 1;
@@ -652,6 +655,9 @@ static void __init kvm_guest_init(void)
 	 * overcommitted.
 	 */
 	hardlockup_detector_disable();
+
+	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF) && kvmapf)
+		static_branch_enable(&kvm_async_pf_enabled);
 }
 
 static noinline uint32_t __kvm_cpuid_base(void)
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 6ef00eb6fbb9..bcb514c801f2 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -936,7 +936,5 @@ void __init trap_init(void)
 
 	idt_setup_ist_traps();
 
-	x86_init.irqs.trap_init();
-
 	idt_setup_debugidt_traps();
 }
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 85f1a90c55cd..123f1c1f1788 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -79,7 +79,6 @@ struct x86_init_ops x86_init __initdata = {
 	.irqs = {
 		.pre_vector_init	= init_ISA_irqs,
 		.intr_init		= native_init_IRQ,
-		.trap_init		= x86_init_noop,
 		.intr_mode_select	= apic_intr_mode_select,
 		.intr_mode_init		= apic_intr_mode_init
 	},
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index fa4ea09593ab..ba04be080142 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -30,6 +30,7 @@
 #include <asm/desc.h>			/* store_idt(), ...		*/
 #include <asm/cpu_entry_area.h>		/* exception stack		*/
 #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
+#include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -1505,6 +1506,25 @@ do_page_fault(struct pt_regs *regs, unsigned long hw_error_code,
 		unsigned long address)
 {
 	prefetchw(&current->mm->mmap_sem);
+	/*
+	 * KVM has two types of events that are, logically, interrupts, but
+	 * are unfortunately delivered using the #PF vector.  These events are
+	 * "you just accessed valid memory, but the host doesn't have it right
+	 * not, so I'll put you to sleep if you continue" and "that memory
+	 * you tried to access earlier is available now."
+	 *
+	 * We are relying on the interrupted context being sane (valid
+	 * RSP, relevant locks not held, etc.), which is fine as long as
+	 * the the interrupted context had IF=1.  We are also relying on
+	 * the KVM async pf type field and CR2 being read consistently
+	 * instead of getting values from real and async page faults
+	 * mixed up.
+	 *
+	 * Fingers crossed.
+	 */
+	if (kvm_handle_async_pf(regs, hw_error_code, address))
+		return;
+
 	trace_page_fault_entries(regs, hw_error_code, address);
 
 	if (unlikely(kmmio_fault(regs, address)))
-- 
2.24.1

