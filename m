Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10C5E6AD584
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 04:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbjCGDGy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 22:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjCGDGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 22:06:03 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E407A80E26;
        Mon,  6 Mar 2023 19:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678158332; x=1709694332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JbvAq9INt68NatqqmP2U9nOnHNc976vHMsLHgFC3s2k=;
  b=G/UKup+A35zTgN81L/9PDQDCLbubSi2bZ1166b9VRaVx+cu4S97MLGXU
   a2rrNyahgssPFGHi7A+oyJSxI4YPtQEcLiDtRISmZqfCcKbWXOAY2sqI3
   q28WG+lG+zi1eHXzx+ON3Y/0mC8+9+Mb/bTuKbiIt2ueL4ld1bu+qk5mP
   s0NQW1JJCcd1Wy8GjTEIItDCUPTOTOQAjgFaVBQMdLd4qB89zK/YLvpRC
   2OfoE4uxtO3dxVTyTzBZyz2jYtnke0WRwShz7/vtFsDdVoWdJ8GX9yp0E
   juYsItpX1SUsrI/xD2TtO7nwBpWi/2zAGJ0qnzCYVU6eveLCEAvvEYRet
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="338072516"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="338072516"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 19:05:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="676409866"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="676409866"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga002.jf.intel.com with ESMTP; 06 Mar 2023 19:05:19 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [PATCH v5 22/34] x86/fred: FRED initialization code
Date:   Mon,  6 Mar 2023 18:39:34 -0800
Message-Id: <20230307023946.14516-23-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230307023946.14516-1-xin3.li@intel.com>
References: <20230307023946.14516-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

The code to initialize FRED when it's available and _not_ disabled.

cpu_init_fred_exceptions() is the core function to initialize FRED,
which
  1. Sets up FRED entrypoints for events happening in ring 0 and 3.
  2. Sets up a default stack for event handling.
  3. Sets up dedicated event stacks for DB/NMI/MC/DF, equivalent to
     the IDT IST stacks.
  4. Forces 32-bit system calls to use "int $0x80" only.
  5. Enables FRED and invalidtes IDT.

When the FRED is used, cpu_init_exception_handling() initializes FRED
through calling cpu_init_fred_exceptions(), otherwise it sets up TSS
IST and loads IDT.

As FRED uses the ring 3 FRED entrypoint for SYSCALL and SYSENTER,
it skips setting up SYSCALL/SYSENTER related MSRs, e.g., MSR_LSTAR.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Co-developed-by: Xin Li <xin3.li@intel.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/fred.h  | 14 +++++++
 arch/x86/include/asm/traps.h |  2 +
 arch/x86/kernel/Makefile     |  1 +
 arch/x86/kernel/cpu/common.c | 74 +++++++++++++++++++++++-------------
 arch/x86/kernel/fred.c       | 73 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/irqinit.c    |  7 +++-
 arch/x86/kernel/traps.c      | 16 +++++++-
 7 files changed, 157 insertions(+), 30 deletions(-)
 create mode 100644 arch/x86/kernel/fred.c

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index 54746e8c0a17..cd974edc8e8a 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -99,8 +99,22 @@ DECLARE_FRED_HANDLER(fred_exc_debug);
 DECLARE_FRED_HANDLER(fred_exc_page_fault);
 DECLARE_FRED_HANDLER(fred_exc_machine_check);
 
+/*
+ * The actual assembly entry and exit points
+ */
+extern __visible void fred_entrypoint_user(void);
+
+/*
+ * Initialization
+ */
+void cpu_init_fred_exceptions(void);
+void fred_setup_apic(void);
+
 #endif /* __ASSEMBLY__ */
 
+#else
+#define cpu_init_fred_exceptions() BUG()
+#define fred_setup_apic() BUG()
 #endif /* CONFIG_X86_FRED */
 
 #endif /* ASM_X86_FRED_H */
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index da4c21ed68b4..69fafef1136e 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -56,6 +56,8 @@ void __noreturn handle_stack_overflow(struct pt_regs *regs,
 	void f (struct pt_regs *regs)
 typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));
 
+system_interrupt_handler get_system_interrupt_handler(unsigned int i);
+
 int external_interrupt(struct pt_regs *regs, unsigned int vector);
 
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index dd61752f4c96..08d9c0a0bfbe 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -47,6 +47,7 @@ obj-y			+= platform-quirks.o
 obj-y			+= process_$(BITS).o signal.o signal_$(BITS).o
 obj-y			+= traps.o idt.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o dumpstack.o nmi.o
+obj-$(CONFIG_X86_FRED)	+= fred.o
 obj-$(CONFIG_MODIFY_LDT_SYSCALL)	+= ldt.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o
 obj-$(CONFIG_JUMP_LABEL)	+= jump_label.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index e8cf6f4cfb52..eea41cb8722e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -58,6 +58,7 @@
 #include <asm/microcode_intel.h>
 #include <asm/intel-family.h>
 #include <asm/cpu_device_id.h>
+#include <asm/fred.h>
 #include <asm/uv/uv.h>
 #include <asm/sigframe.h>
 #include <asm/traps.h>
@@ -2054,28 +2055,6 @@ static void wrmsrl_cstar(unsigned long val)
 /* May not be marked __init: used by software suspend */
 void syscall_init(void)
 {
-	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
-	wrmsrl(MSR_LSTAR, (unsigned long)entry_SYSCALL_64);
-
-#ifdef CONFIG_IA32_EMULATION
-	wrmsrl_cstar((unsigned long)entry_SYSCALL_compat);
-	/*
-	 * This only works on Intel CPUs.
-	 * On AMD CPUs these MSRs are 32-bit, CPU truncates MSR_IA32_SYSENTER_EIP.
-	 * This does not cause SYSENTER to jump to the wrong location, because
-	 * AMD doesn't allow SYSENTER in long mode (either 32- or 64-bit).
-	 */
-	wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);
-	wrmsrl_safe(MSR_IA32_SYSENTER_ESP,
-		    (unsigned long)(cpu_entry_stack(smp_processor_id()) + 1));
-	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, (u64)entry_SYSENTER_compat);
-#else
-	wrmsrl_cstar((unsigned long)ignore_sysret);
-	wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)GDT_ENTRY_INVALID_SEG);
-	wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
-	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, 0ULL);
-#endif
-
 	/*
 	 * Flags to clear on syscall; clear as much as possible
 	 * to minimize user space-kernel interference.
@@ -2086,6 +2065,41 @@ void syscall_init(void)
 	       X86_EFLAGS_IF|X86_EFLAGS_DF|X86_EFLAGS_OF|
 	       X86_EFLAGS_IOPL|X86_EFLAGS_NT|X86_EFLAGS_RF|
 	       X86_EFLAGS_AC|X86_EFLAGS_ID);
+
+	/*
+	 * The default user and kernel segments
+	 */
+	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
+
+	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
+		/* Both sysexit and sysret cause #UD when FRED is enabled */
+		wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)GDT_ENTRY_INVALID_SEG);
+		wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
+		wrmsrl_safe(MSR_IA32_SYSENTER_EIP, 0ULL);
+	} else {
+		wrmsrl(MSR_LSTAR, (unsigned long)entry_SYSCALL_64);
+
+#ifdef CONFIG_IA32_EMULATION
+		wrmsrl_cstar((unsigned long)entry_SYSCALL_compat);
+		/*
+		 * This only works on Intel CPUs.
+		 * On AMD CPUs these MSRs are 32-bit, CPU truncates
+		 * MSR_IA32_SYSENTER_EIP.
+		 * This does not cause SYSENTER to jump to the wrong
+		 * location, because AMD doesn't allow SYSENTER in
+		 * long mode (either 32- or 64-bit).
+		 */
+		wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);
+		wrmsrl_safe(MSR_IA32_SYSENTER_ESP,
+			    (unsigned long)(cpu_entry_stack(smp_processor_id()) + 1));
+		wrmsrl_safe(MSR_IA32_SYSENTER_EIP, (u64)entry_SYSENTER_compat);
+#else
+		wrmsrl_cstar((unsigned long)ignore_sysret);
+		wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)GDT_ENTRY_INVALID_SEG);
+		wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
+		wrmsrl_safe(MSR_IA32_SYSENTER_EIP, 0ULL);
+#endif
+	}
 }
 
 #else	/* CONFIG_X86_64 */
@@ -2218,18 +2232,24 @@ void cpu_init_exception_handling(void)
 	/* paranoid_entry() gets the CPU number from the GDT */
 	setup_getcpu(cpu);
 
-	/* IST vectors need TSS to be set up. */
-	tss_setup_ist(tss);
+	/* Set up the TSS */
 	tss_setup_io_bitmap(tss);
 	set_tss_desc(cpu, &get_cpu_entry_area(cpu)->tss.x86_tss);
-
 	load_TR_desc();
 
 	/* GHCB needs to be setup to handle #VC. */
 	setup_ghcb();
 
-	/* Finally load the IDT */
-	load_current_idt();
+	if (cpu_feature_enabled(X86_FEATURE_FRED)) {
+		/* Set up FRED exception handling */
+		cpu_init_fred_exceptions();
+	} else {
+		/* IST vectors need TSS to be set up. */
+		tss_setup_ist(tss);
+
+		/* Finally load the IDT */
+		load_current_idt();
+	}
 }
 
 /*
diff --git a/arch/x86/kernel/fred.c b/arch/x86/kernel/fred.c
new file mode 100644
index 000000000000..827b58fd98d4
--- /dev/null
+++ b/arch/x86/kernel/fred.c
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/kernel.h>
+#include <asm/desc.h>
+#include <asm/fred.h>
+#include <asm/tlbflush.h>	/* For cr4_set_bits() */
+#include <asm/traps.h>
+
+/*
+ * Initialize FRED on this CPU. This cannot be __init as it is called
+ * during CPU hotplug.
+ */
+void cpu_init_fred_exceptions(void)
+{
+	wrmsrl(MSR_IA32_FRED_CONFIG,
+	       FRED_CONFIG_ENTRYPOINT(fred_entrypoint_user) |
+	       FRED_CONFIG_REDZONE(8) | /* Reserve for CALL emulation */
+	       FRED_CONFIG_INT_STKLVL(0));
+
+	wrmsrl(MSR_IA32_FRED_STKLVLS,
+	       FRED_STKLVL(X86_TRAP_DB,  1) |
+	       FRED_STKLVL(X86_TRAP_NMI, 2) |
+	       FRED_STKLVL(X86_TRAP_MC,  2) |
+	       FRED_STKLVL(X86_TRAP_DF,  3));
+
+	/* The FRED equivalents to IST stacks... */
+	wrmsrl(MSR_IA32_FRED_RSP1, __this_cpu_ist_top_va(DB));
+	wrmsrl(MSR_IA32_FRED_RSP2, __this_cpu_ist_top_va(NMI));
+	wrmsrl(MSR_IA32_FRED_RSP3, __this_cpu_ist_top_va(DF));
+
+	/* Not used with FRED */
+	wrmsrl(MSR_LSTAR, 0ULL);
+	wrmsrl(MSR_CSTAR, 0ULL);
+	wrmsrl_safe(MSR_IA32_SYSENTER_CS,  (u64)GDT_ENTRY_INVALID_SEG);
+	wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
+	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, 0ULL);
+
+	/* Enable FRED */
+	cr4_set_bits(X86_CR4_FRED);
+	idt_invalidate();	/* Any further IDT use is a bug */
+
+	/* Use int $0x80 for 32-bit system calls in FRED mode */
+	setup_clear_cpu_cap(X86_FEATURE_SYSENTER32);
+	setup_clear_cpu_cap(X86_FEATURE_SYSCALL32);
+}
+
+/*
+ * Initialize system vectors from a FRED perspective, so
+ * lapic_assign_system_vectors() can do its job.
+ */
+void __init fred_setup_apic(void)
+{
+	int i;
+
+	for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
+		set_bit(i, system_vectors);
+
+	/*
+	 * Don't set the non assigned system vectors in the
+	 * system_vectors bitmap. Otherwise they show up in
+	 * /proc/interrupts.
+	 */
+#ifdef CONFIG_SMP
+	set_bit(IRQ_MOVE_CLEANUP_VECTOR, system_vectors);
+#endif
+
+	for (i = 0; i < NR_SYSTEM_VECTORS; i++) {
+		if (get_system_interrupt_handler(i) != NULL) {
+			set_bit(i + FIRST_SYSTEM_VECTOR, system_vectors);
+		}
+	}
+
+	/* The rest are fair game... */
+}
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index c683666876f1..2a510f72dd11 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -28,6 +28,7 @@
 #include <asm/setup.h>
 #include <asm/i8259.h>
 #include <asm/traps.h>
+#include <asm/fred.h>
 #include <asm/prom.h>
 
 /*
@@ -96,7 +97,11 @@ void __init native_init_IRQ(void)
 	/* Execute any quirks before the call gates are initialised: */
 	x86_init.irqs.pre_vector_init();
 
-	idt_setup_apic_and_irq_gates();
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		fred_setup_apic();
+	else
+		idt_setup_apic_and_irq_gates();
+
 	lapic_assign_system_vectors();
 
 	if (!acpi_ioapic && !of_ioapic && nr_legacy_irqs()) {
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4b0f63344526..c7253b4901f0 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1517,12 +1517,21 @@ static system_interrupt_handler system_interrupt_handlers[NR_SYSTEM_VECTORS] = {
 
 #undef SYSV
 
+system_interrupt_handler get_system_interrupt_handler(unsigned int i)
+{
+	if (i >= NR_SYSTEM_VECTORS)
+		return NULL;
+
+	return system_interrupt_handlers[i];
+}
+
 void __init install_system_interrupt_handler(unsigned int n, const void *asm_addr, const void *addr)
 {
 	BUG_ON(n < FIRST_SYSTEM_VECTOR);
 
 	system_interrupt_handlers[n - FIRST_SYSTEM_VECTOR] = (system_interrupt_handler)addr;
-	alloc_intr_gate(n, asm_addr);
+	if (!cpu_feature_enabled(X86_FEATURE_FRED))
+		alloc_intr_gate(n, asm_addr);
 }
 
 #ifndef CONFIG_X86_LOCAL_APIC
@@ -1590,7 +1599,10 @@ void __init trap_init(void)
 
 	/* Initialize TSS before setting up traps so ISTs work */
 	cpu_init_exception_handling();
+
 	/* Setup traps as cpu_init() might #GP */
-	idt_setup_traps();
+	if (!cpu_feature_enabled(X86_FEATURE_FRED))
+		idt_setup_traps();
+
 	cpu_init();
 }
-- 
2.34.1

