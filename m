Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5A47AC029
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 12:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbjIWKMa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 06:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbjIWKMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 06:12:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C088CC7;
        Sat, 23 Sep 2023 03:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695463909; x=1726999909;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aB9X6AvBbEVqHF8pDqD66jUIoaqA7x/kswu7ifFPwEo=;
  b=EQlheWZQyM+xpEc5LFCK3iJgqh0a1Ze+1mZLQP5I4taeSAhoioEPueCd
   SZldmEgMktZEv7DyX7L4WPl328qXiit5gJ7LrWDBlRd/kOULG2SYM1rTh
   pb+o53btUjxPYK4IzJAVn65ISmEtqinNkLFJUfb8KWIU1BuwwTcLmYlNr
   Q9J0Rit1JS/Qnns53xB/gBwhBLQ3mqZTa6z6RyuroNtHRTzzkLWgCwoQ0
   VMYW/wYa2aBfgN7Sow24afJAUJxih4C4yjAJPvu2BCFwbNqPCzDcbsbee
   12WkpZXimQC4Fx9bMxi8uRw/3IddbIp9VuKL906ry4xPqStjnGtitp/Da
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="447492362"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="447492362"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2023 03:11:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="813388187"
X-IronPort-AV: E=Sophos;i="6.03,171,1694761200"; 
   d="scan'208";a="813388187"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 23 Sep 2023 03:11:47 -0700
From:   Xin Li <xin3.li@intel.com>
To:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        peterz@infradead.org, jgross@suse.com, ravi.v.shankar@intel.com,
        mhiramat@kernel.org, andrew.cooper3@citrix.com,
        jiangshanlai@gmail.com, nik.borisov@suse.com
Subject: [PATCH v11 24/37] x86/idtentry: Incorporate definitions/declarations of the FRED entries
Date:   Sat, 23 Sep 2023 02:41:59 -0700
Message-Id: <20230923094212.26520-25-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230923094212.26520-1-xin3.li@intel.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
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

FRED and IDT can share most of the definitions and declarations so
that in the majority of cases the actual handler implementation is the
same.

The differences are the exceptions where FRED stores exception related
information on the stack and the sysvec implementations as FRED can
handle irqentry/exit() in the dispatcher instead of having it in each
handler.

Also add stub defines for vectors which are not used due to Kconfig
decisions to spare the ifdeffery in the actual FRED dispatch code.

Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v9:
* Except NMI/#DB/#MCE, FRED really should share the exception handlers
  with IDT (Thomas Gleixner).

Changes since v8:
* Put IDTENTRY changes in a separate patch (Thomas Gleixner).
---
 arch/x86/include/asm/idtentry.h | 71 +++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index cfca68f6cb84..4f26ee9b8b74 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -13,15 +13,18 @@
 
 #include <asm/irq_stack.h>
 
+typedef void (*idtentry_t)(struct pt_regs *regs);
+
 /**
  * DECLARE_IDTENTRY - Declare functions for simple IDT entry points
  *		      No error code pushed by hardware
  * @vector:	Vector number (ignored for C)
  * @func:	Function name of the entry point
  *
- * Declares three functions:
+ * Declares four functions:
  * - The ASM entry point: asm_##func
  * - The XEN PV trap entry point: xen_##func (maybe unused)
+ * - The C handler called from the FRED event dispatcher (maybe unused)
  * - The C handler called from the ASM entry point
  *
  * Note: This is the C variant of DECLARE_IDTENTRY(). As the name says it
@@ -31,6 +34,7 @@
 #define DECLARE_IDTENTRY(vector, func)					\
 	asmlinkage void asm_##func(void);				\
 	asmlinkage void xen_asm_##func(void);				\
+	void fred_##func(struct pt_regs *regs);				\
 	__visible void func(struct pt_regs *regs)
 
 /**
@@ -137,6 +141,17 @@ static __always_inline void __##func(struct pt_regs *regs,		\
 #define DEFINE_IDTENTRY_RAW(func)					\
 __visible noinstr void func(struct pt_regs *regs)
 
+/**
+ * DEFINE_FREDENTRY_RAW - Emit code for raw FRED entry points
+ * @func:	Function name of the entry point
+ *
+ * @func is called from the FRED event dispatcher with interrupts disabled.
+ *
+ * See @DEFINE_IDTENTRY_RAW for further details.
+ */
+#define DEFINE_FREDENTRY_RAW(func)					\
+noinstr void fred_##func(struct pt_regs *regs)
+
 /**
  * DECLARE_IDTENTRY_RAW_ERRORCODE - Declare functions for raw IDT entry points
  *				    Error code pushed by hardware
@@ -233,17 +248,27 @@ static noinline void __##func(struct pt_regs *regs, u32 vector)
 #define DEFINE_IDTENTRY_SYSVEC(func)					\
 static void __##func(struct pt_regs *regs);				\
 									\
+static __always_inline void instr_##func(struct pt_regs *regs)		\
+{									\
+	kvm_set_cpu_l1tf_flush_l1d();					\
+	run_sysvec_on_irqstack_cond(__##func, regs);			\
+}									\
+									\
 __visible noinstr void func(struct pt_regs *regs)			\
 {									\
 	irqentry_state_t state = irqentry_enter(regs);			\
 									\
 	instrumentation_begin();					\
-	kvm_set_cpu_l1tf_flush_l1d();					\
-	run_sysvec_on_irqstack_cond(__##func, regs);			\
+	instr_##func (regs);						\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
 }									\
 									\
+void fred_##func(struct pt_regs *regs)					\
+{									\
+	instr_##func (regs);						\
+}									\
+									\
 static noinline void __##func(struct pt_regs *regs)
 
 /**
@@ -260,19 +285,29 @@ static noinline void __##func(struct pt_regs *regs)
 #define DEFINE_IDTENTRY_SYSVEC_SIMPLE(func)				\
 static __always_inline void __##func(struct pt_regs *regs);		\
 									\
-__visible noinstr void func(struct pt_regs *regs)			\
+static __always_inline void instr_##func(struct pt_regs *regs)		\
 {									\
-	irqentry_state_t state = irqentry_enter(regs);			\
-									\
-	instrumentation_begin();					\
 	__irq_enter_raw();						\
 	kvm_set_cpu_l1tf_flush_l1d();					\
 	__##func (regs);						\
 	__irq_exit_raw();						\
+}									\
+									\
+__visible noinstr void func(struct pt_regs *regs)			\
+{									\
+	irqentry_state_t state = irqentry_enter(regs);			\
+									\
+	instrumentation_begin();					\
+	instr_##func (regs);						\
 	instrumentation_end();						\
 	irqentry_exit(regs, state);					\
 }									\
 									\
+void fred_##func(struct pt_regs *regs)					\
+{									\
+	instr_##func (regs);						\
+}									\
+									\
 static __always_inline void __##func(struct pt_regs *regs)
 
 /**
@@ -410,15 +445,18 @@ __visible noinstr void func(struct pt_regs *regs,			\
 /* C-Code mapping */
 #define DECLARE_IDTENTRY_NMI		DECLARE_IDTENTRY_RAW
 #define DEFINE_IDTENTRY_NMI		DEFINE_IDTENTRY_RAW
+#define DEFINE_FREDENTRY_NMI		DEFINE_FREDENTRY_RAW
 
 #ifdef CONFIG_X86_64
 #define DECLARE_IDTENTRY_MCE		DECLARE_IDTENTRY_IST
 #define DEFINE_IDTENTRY_MCE		DEFINE_IDTENTRY_IST
 #define DEFINE_IDTENTRY_MCE_USER	DEFINE_IDTENTRY_NOIST
+#define DEFINE_FREDENTRY_MCE		DEFINE_FREDENTRY_RAW
 
 #define DECLARE_IDTENTRY_DEBUG		DECLARE_IDTENTRY_IST
 #define DEFINE_IDTENTRY_DEBUG		DEFINE_IDTENTRY_IST
 #define DEFINE_IDTENTRY_DEBUG_USER	DEFINE_IDTENTRY_NOIST
+#define DEFINE_FREDENTRY_DEBUG		DEFINE_FREDENTRY_RAW
 #endif
 
 #else /* !__ASSEMBLY__ */
@@ -651,23 +689,36 @@ DECLARE_IDTENTRY(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi);
 DECLARE_IDTENTRY_SYSVEC(REBOOT_VECTOR,			sysvec_reboot);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,	sysvec_call_function_single);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_VECTOR,		sysvec_call_function);
+#else
+# define fred_sysvec_reschedule_ipi			NULL
+# define fred_sysvec_reboot				NULL
+# define fred_sysvec_call_function_single		NULL
+# define fred_sysvec_call_function			NULL
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
 # ifdef CONFIG_X86_MCE_THRESHOLD
 DECLARE_IDTENTRY_SYSVEC(THRESHOLD_APIC_VECTOR,		sysvec_threshold);
+# else
+# define fred_sysvec_threshold				NULL
 # endif
 
 # ifdef CONFIG_X86_MCE_AMD
 DECLARE_IDTENTRY_SYSVEC(DEFERRED_ERROR_VECTOR,		sysvec_deferred_error);
+# else
+# define fred_sysvec_deferred_error			NULL
 # endif
 
 # ifdef CONFIG_X86_THERMAL_VECTOR
 DECLARE_IDTENTRY_SYSVEC(THERMAL_APIC_VECTOR,		sysvec_thermal);
+# else
+# define fred_sysvec_thermal				NULL
 # endif
 
 # ifdef CONFIG_IRQ_WORK
 DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		sysvec_irq_work);
+# else
+# define fred_sysvec_irq_work				NULL
 # endif
 #endif
 
@@ -675,12 +726,16 @@ DECLARE_IDTENTRY_SYSVEC(IRQ_WORK_VECTOR,		sysvec_irq_work);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_WAKEUP_VECTOR,	sysvec_kvm_posted_intr_wakeup_ipi);
 DECLARE_IDTENTRY_SYSVEC(POSTED_INTR_NESTED_VECTOR,	sysvec_kvm_posted_intr_nested_ipi);
+#else
+# define fred_sysvec_kvm_posted_intr_ipi		NULL
+# define fred_sysvec_kvm_posted_intr_wakeup_ipi		NULL
+# define fred_sysvec_kvm_posted_intr_nested_ipi		NULL
 #endif
 
 #if IS_ENABLED(CONFIG_HYPERV)
 DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_hyperv_callback);
 DECLARE_IDTENTRY_SYSVEC(HYPERV_REENLIGHTENMENT_VECTOR,	sysvec_hyperv_reenlightenment);
-DECLARE_IDTENTRY_SYSVEC(HYPERV_STIMER0_VECTOR,	sysvec_hyperv_stimer0);
+DECLARE_IDTENTRY_SYSVEC(HYPERV_STIMER0_VECTOR,		sysvec_hyperv_stimer0);
 #endif
 
 #if IS_ENABLED(CONFIG_ACRN_GUEST)
-- 
2.34.1

