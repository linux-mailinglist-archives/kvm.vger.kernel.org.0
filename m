Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506B365FD8B
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbjAFJUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjAFJUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:17 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4FB6B5EB;
        Fri,  6 Jan 2023 01:20:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996815; x=1704532815;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ntf8jaiwEE+fGtM3gCkXz+ISQnT30q6joOVeczDYVtI=;
  b=kiYluqBASHVpdOXnXpCoMdB4xF3wIJfDostkzjsbBjtStRDTkUSYwWmw
   9CXVG2OgtQnSPSX/+e+EPq0XnXYH5KgueEZtF1Q6c3wx/re36QW+oj2y7
   Pg504PiZedLJXJVkBJdI8z4ZTKiu2NWbmBLSTK29gqwibIMWjTEV0G9Rh
   RFLXGcl2ii9LtYwX8Gy2TlRk1RofVvmqwz1TT4jftXwv0bi07FxDaUr39
   bjtV1nxuArr2P8InBFf10ArJVyLZZm6LeREJg+pH4IiKrK8FWzj1fYZkn
   ZyD1O78GbKC0ANoSlCp1uJY+ZjjEqsk+taxpvbpSsDgfOHArjJgyGpUcj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511382"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511382"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139344"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139344"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:11 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 02/32] x86/traps: add a system interrupt table for system interrupt dispatch
Date:   Fri,  6 Jan 2023 00:55:47 -0800
Message-Id: <20230106085617.17248-3-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106085617.17248-1-xin3.li@intel.com>
References: <20230106085617.17248-1-xin3.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

Upon receiving an external interrupt, KVM VMX reinjects it through
calling the interrupt handler in its IDT descriptor on the current
kernel stack, which essentially uses the IDT as an interrupt dispatch
table.

However the IDT is one of the lowest level critical data structures
between a x86 CPU and the Linux kernel, we should avoid using it
*directly* whenever possible, espeically in a software defined manner.

On x86, external interrupts are divided into the following groups
  1) system interrupts
  2) external device interrupts
With the IDT, system interrupts are dispatched through the IDT
directly, while external device interrupts are all routed to the
external interrupt dispatch function common_interrupt(), which
dispatches external device interrupts through a per-CPU external
interrupt dispatch table vector_irq.

To eliminate dispatching external interrupts through the IDT, add
a system interrupt handler table for dispatching a system interrupt
to its corresponding handler directly. Thus a software based dispatch
function will be:

  void external_interrupt(struct pt_regs *regs, u8 vector)
  {
    if (is_system_interrupt(vector))
      system_interrupt_handlers[vector_to_sysvec(vector)](regs);
    else /* external device interrupt */
      common_interrupt(regs, vector);
  }

What's more, with the Intel FRED (Flexible Return and Event Delivery)
architecture, IDT, the hardware based event dispatch table, is gone,
and the Linux kernel needs to dispatch events to their handlers with
vector to handler mappings, the dispatch function external_interrupt()
is also needed.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Co-developed-by: Xin Li <xin3.li@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/idtentry.h | 56 +++++++++++++++++++++++++++------
 arch/x86/include/asm/traps.h    |  7 +++++
 arch/x86/kernel/traps.c         | 40 +++++++++++++++++++++++
 3 files changed, 93 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index 72184b0b2219..966d720046f1 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -167,18 +167,24 @@ __visible noinstr void func(struct pt_regs *regs, unsigned long error_code)
 
 /**
  * DECLARE_IDTENTRY_IRQ - Declare functions for device interrupt IDT entry
- *			  points (common/spurious)
+ *			  points (common/spurious) and their corresponding
+ *			  software based dispatch handlers in non-noinstr
+ *			  text section
  * @vector:	Vector number (ignored for C)
  * @func:	Function name of the entry point
  *
  * Maps to DECLARE_IDTENTRY_ERRORCODE()
  */
 #define DECLARE_IDTENTRY_IRQ(vector, func)				\
-	DECLARE_IDTENTRY_ERRORCODE(vector, func)
+	DECLARE_IDTENTRY_ERRORCODE(vector, func);			\
+	void dispatch_##func(struct pt_regs *regs, unsigned long error_code)
 
 /**
  * DEFINE_IDTENTRY_IRQ - Emit code for device interrupt IDT entry points
- * @func:	Function name of the entry point
+ *			 and their corresponding software based dispatch
+ *			 handlers in non-noinstr text section.
+ * @func:		Function name of the IDT entry point
+ * @dispatch_func:	Function name of the software based dispatch handler
  *
  * The vector number is pushed by the low level entry stub and handed
  * to the function as error_code argument which needs to be truncated
@@ -204,10 +210,20 @@ __visible noinstr void func(struct pt_regs *regs,			\
 	irqentry_exit(regs, state);					\
 }									\
 									\
+void dispatch_##func(struct pt_regs *regs, unsigned long error_code)	\
+{									\
+	u32 vector = (u32)(u8)error_code;				\
+									\
+	kvm_set_cpu_l1tf_flush_l1d();					\
+	run_irq_on_irqstack_cond(__##func, regs, vector);		\
+}									\
+									\
 static noinline void __##func(struct pt_regs *regs, u32 vector)
 
 /**
  * DECLARE_IDTENTRY_SYSVEC - Declare functions for system vector entry points
+ *			     and their corresponding software based dispatch
+ *			     handlers in non-noinstr text section
  * @vector:	Vector number (ignored for C)
  * @func:	Function name of the entry point
  *
@@ -215,15 +231,20 @@ static noinline void __##func(struct pt_regs *regs, u32 vector)
  * - The ASM entry point: asm_##func
  * - The XEN PV trap entry point: xen_##func (maybe unused)
  * - The C handler called from the ASM entry point
+ * - The C handler used in the system interrupt handler table
  *
  * Maps to DECLARE_IDTENTRY().
  */
 #define DECLARE_IDTENTRY_SYSVEC(vector, func)				\
-	DECLARE_IDTENTRY(vector, func)
+	DECLARE_IDTENTRY(vector, func);					\
+	void dispatch_table_##func(struct pt_regs *regs)
 
 /**
  * DEFINE_IDTENTRY_SYSVEC - Emit code for system vector IDT entry points
- * @func:	Function name of the entry point
+ *			    and their corresponding software based dispatch
+ *			    handlers in non-noinstr text section
+ * @func:		Function name of the IDT entry point
+ * @dispatch_table_func:Function name of the software based dispatch handler
  *
  * irqentry_enter/exit() and irq_enter/exit_rcu() are invoked before the
  * function body. KVM L1D flush request is set.
@@ -244,12 +265,21 @@ __visible noinstr void func(struct pt_regs *regs)			\
 	irqentry_exit(regs, state);					\
 }									\
 									\
+void dispatch_table_##func(struct pt_regs *regs)			\
+{									\
+	kvm_set_cpu_l1tf_flush_l1d();					\
+	run_sysvec_on_irqstack_cond(__##func, regs);			\
+}									\
+									\
 static noinline void __##func(struct pt_regs *regs)
 
 /**
  * DEFINE_IDTENTRY_SYSVEC_SIMPLE - Emit code for simple system vector IDT
- *				   entry points
- * @func:	Function name of the entry point
+ *				   entry points and their corresponding
+ *				   software based dispatch handlers in
+ *				   non-noinstr text section
+ * @func:		Function name of the IDT entry point
+ * @dispatch_table_func:Function name of the software based dispatch handler
  *
  * Runs the function on the interrupted stack. No switch to IRQ stack and
  * only the minimal __irq_enter/exit() handling.
@@ -273,6 +303,14 @@ __visible noinstr void func(struct pt_regs *regs)			\
 	irqentry_exit(regs, state);					\
 }									\
 									\
+void dispatch_table_##func(struct pt_regs *regs)			\
+{									\
+	__irq_enter_raw();						\
+	kvm_set_cpu_l1tf_flush_l1d();					\
+	__##func (regs);						\
+	__irq_exit_raw();						\
+}									\
+									\
 static __always_inline void __##func(struct pt_regs *regs)
 
 /**
@@ -638,9 +676,7 @@ DECLARE_IDTENTRY(X86_TRAP_VE,		exc_virtualization_exception);
 
 /* Device interrupts common/spurious */
 DECLARE_IDTENTRY_IRQ(X86_TRAP_OTHER,	common_interrupt);
-#ifdef CONFIG_X86_LOCAL_APIC
 DECLARE_IDTENTRY_IRQ(X86_TRAP_OTHER,	spurious_interrupt);
-#endif
 
 /* System vector entry points */
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -651,7 +687,7 @@ DECLARE_IDTENTRY_SYSVEC(X86_PLATFORM_IPI_VECTOR,	sysvec_x86_platform_ipi);
 #endif
 
 #ifdef CONFIG_SMP
-DECLARE_IDTENTRY(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi);
+DECLARE_IDTENTRY_SYSVEC(RESCHEDULE_VECTOR,		sysvec_reschedule_ipi);
 DECLARE_IDTENTRY_SYSVEC(IRQ_MOVE_CLEANUP_VECTOR,	sysvec_irq_move_cleanup);
 DECLARE_IDTENTRY_SYSVEC(REBOOT_VECTOR,			sysvec_reboot);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,	sysvec_call_function_single);
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 47ecfff2c83d..28c8ba5fd81c 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -47,4 +47,11 @@ void __noreturn handle_stack_overflow(struct pt_regs *regs,
 				      struct stack_info *info);
 #endif
 
+/*
+ * How system interrupt handlers are called.
+ */
+#define DECLARE_SYSTEM_INTERRUPT_HANDLER(f)	\
+	void f (struct pt_regs *regs)
+typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index d3fdec706f1d..8f751c06c052 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1451,6 +1451,46 @@ DEFINE_IDTENTRY_SW(iret_error)
 }
 #endif
 
+#define SYSV(x,y) [(x) - FIRST_SYSTEM_VECTOR] = y
+
+static system_interrupt_handler system_interrupt_handlers[NR_SYSTEM_VECTORS] = {
+#ifdef CONFIG_SMP
+	SYSV(RESCHEDULE_VECTOR,			dispatch_table_sysvec_reschedule_ipi),
+	SYSV(CALL_FUNCTION_VECTOR,		dispatch_table_sysvec_call_function),
+	SYSV(CALL_FUNCTION_SINGLE_VECTOR,	dispatch_table_sysvec_call_function_single),
+	SYSV(REBOOT_VECTOR,			dispatch_table_sysvec_reboot),
+#endif
+
+#ifdef CONFIG_X86_THERMAL_VECTOR
+	SYSV(THERMAL_APIC_VECTOR,		dispatch_table_sysvec_thermal),
+#endif
+
+#ifdef CONFIG_X86_MCE_THRESHOLD
+	SYSV(THRESHOLD_APIC_VECTOR,		dispatch_table_sysvec_threshold),
+#endif
+
+#ifdef CONFIG_X86_MCE_AMD
+	SYSV(DEFERRED_ERROR_VECTOR,		dispatch_table_sysvec_deferred_error),
+#endif
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	SYSV(LOCAL_TIMER_VECTOR,		dispatch_table_sysvec_apic_timer_interrupt),
+	SYSV(X86_PLATFORM_IPI_VECTOR,		dispatch_table_sysvec_x86_platform_ipi),
+# ifdef CONFIG_HAVE_KVM
+	SYSV(POSTED_INTR_VECTOR,		dispatch_table_sysvec_kvm_posted_intr_ipi),
+	SYSV(POSTED_INTR_WAKEUP_VECTOR,		dispatch_table_sysvec_kvm_posted_intr_wakeup_ipi),
+	SYSV(POSTED_INTR_NESTED_VECTOR,		dispatch_table_sysvec_kvm_posted_intr_nested_ipi),
+# endif
+# ifdef CONFIG_IRQ_WORK
+	SYSV(IRQ_WORK_VECTOR,			dispatch_table_sysvec_irq_work),
+# endif
+	SYSV(SPURIOUS_APIC_VECTOR,		dispatch_table_sysvec_spurious_apic_interrupt),
+	SYSV(ERROR_APIC_VECTOR,			dispatch_table_sysvec_error_interrupt),
+#endif
+};
+
+#undef SYSV
+
 void __init trap_init(void)
 {
 	/* Init cpu_entry_area before IST entries are set up */
-- 
2.34.1

