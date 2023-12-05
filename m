Return-Path: <kvm+bounces-3542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6726F805291
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:24:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8A421F214EA
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DD2967E84;
	Tue,  5 Dec 2023 11:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g4EsLdSj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05F81A6;
	Tue,  5 Dec 2023 03:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701775292; x=1733311292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0d3DQGm/I5ml9Pn9RDXaRIVibuYwsK2Hzyh1Rbxiqo8=;
  b=g4EsLdSjtIj+YHoEqhXj51NKOGBEKipU5n8PGwGRp9qPCphb83Nb7zuj
   keCM6KUMqRdCPTRgDgescGcN0gkTHx2VUiDklES37mtUiU0e2JHkmf3AG
   W0QKZtm+VpQoflM8M/L3hSTAnzjcPnyMcmVYF/Gz5QzHkiBVayiyF04j0
   1HdhgdESeBVTr01HJvynAhW2IFNVWffYLfoGF9mlTG8iTt6S2W7oWwUpn
   JbqOiJHBeNG+tiCBKplaCQtZqOEp6Id9H9oy/vycisE5zhUeo6P8ROkxH
   N+R5kvi51MFzoxPcEPljBHn7YKqL9MBx87Vzmxs42mDriEm8zRw38RMPv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="942569"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="942569"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 03:21:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="1018192976"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="1018192976"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 05 Dec 2023 03:21:22 -0800
From: Xin Li <xin3.li@intel.com>
To: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-edac@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org
Cc: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	peterz@infradead.org,
	jgross@suse.com,
	ravi.v.shankar@intel.com,
	mhiramat@kernel.org,
	andrew.cooper3@citrix.com,
	jiangshanlai@gmail.com,
	nik.borisov@suse.com,
	shan.kang@intel.com
Subject: [PATCH v13 22/35] x86/idtentry: Incorporate definitions/declarations of the FRED entries
Date: Tue,  5 Dec 2023 02:50:11 -0800
Message-ID: <20231205105030.8698-23-xin3.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205105030.8698-1-xin3.li@intel.com>
References: <20231205105030.8698-1-xin3.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FRED and IDT can share most of the definitions and declarations so
that in the majority of cases the actual handler implementation is the
same.

The differences are the exceptions where FRED stores exception related
information on the stack and the sysvec implementations as FRED can
handle irqentry/exit() in the dispatcher instead of having it in each
handler.

Also add stub defines for vectors which are not used due to Kconfig
decisions to spare the ifdeffery in the actual FRED dispatch code.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Change since v9:
* Except NMI/#DB/#MCE, FRED really should share the exception handlers
  with IDT (Thomas Gleixner).

Change since v8:
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
2.43.0


