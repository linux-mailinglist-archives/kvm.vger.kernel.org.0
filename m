Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE000623BFB
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 07:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbiKJGjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 01:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbiKJGjU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 01:39:20 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C06B29C91;
        Wed,  9 Nov 2022 22:39:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668062359; x=1699598359;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fNThYHDmqBlYOeK5UL+m4NKHtKLRQgciD55ArNLCN84=;
  b=idBducjoIPmUfiMZcmDeLIoFAcqGezowW9w1zRjUxLu7PHNJeecinjT0
   iK7yIxV837xWQHptQiYXyNxBYYkxO75SyjHdkhLszvigNvshBqPoH9y9V
   peB7rEJO5h1nLs75df9ZXyo8qwIOTiFdXswtR2ankb4gm5weB/yiaLA0+
   V7mE+cs6IZMUb8YNkUpF4KoiSJpSLKvXlF9ZHwGFjqB/1HHPu1D02DH5q
   +CAPp0ra1VUR6v3Em14TC1jRLS/fOTx5v+hFd/7ky6gqdFlgtL0Isntmi
   Fo1wlW1zYBC6x1YkGMdvmCxsPR8WfCJ3yhJNr8Ine60taxLN9jM9mpTi7
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="375474001"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="375474001"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 22:39:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="588057209"
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="588057209"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by orsmga003.jf.intel.com with ESMTP; 09 Nov 2022 22:39:17 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, kevin.tian@intel.com
Subject: [RESEND PATCH 2/6] x86/traps: add a system interrupt table for system interrupt dispatch
Date:   Wed,  9 Nov 2022 22:15:41 -0800
Message-Id: <20221110061545.1531-3-xin3.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221110061545.1531-1-xin3.li@intel.com>
References: <20221110061545.1531-1-xin3.li@intel.com>
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
      system_interrupt_handler_table[vector_to_sysvec(vector)](regs);
    else /* external device interrupt */
      common_interrupt(regs, vector);
  }

What's more, with the Intel FRED (Flexible Return and Event Delivery)
architecture, IDT, the hardware based event dispatch table, is gone,
and the Linux kernel needs to dispatch events to their handlers with
vector to handler mappings, the dispatch function external_interrupt()
is also needed.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---
 arch/x86/include/asm/traps.h |  8 ++++++
 arch/x86/kernel/traps.c      | 55 ++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 47ecfff2c83d..3dc63d753bda 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -47,4 +47,12 @@ void __noreturn handle_stack_overflow(struct pt_regs *regs,
 				      struct stack_info *info);
 #endif
 
+/*
+ * How system interrupt handlers are called.
+ */
+#define DECLARE_SYSTEM_INTERRUPT_HANDLER(f)			\
+	void f (struct pt_regs *regs __maybe_unused,		\
+		unsigned long vector __maybe_unused)
+typedef DECLARE_SYSTEM_INTERRUPT_HANDLER((*system_interrupt_handler));
+
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 178015a820f0..95dd917ef9ad 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1444,6 +1444,61 @@ DEFINE_IDTENTRY_SW(iret_error)
 }
 #endif
 
+#define SYSV(x,y) [(x) - FIRST_SYSTEM_VECTOR] = (system_interrupt_handler)y
+
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wcast-function-type"
+
+/*
+ * The initializer spurious_interrupt() has two arguments of types struct
+ * pt_regs * and unsigned long, and the system interrupt handlers with
+ * prefix sysvec_ are all defined with either DEFINE_IDTENTRY_SYSVEC or
+ * DEFINE_IDTENTRY_SYSVEC_SIMPLE, both with only one argument of type
+ * struct pt_regs *. Because all handlers only declare and require a subset
+ * of the arguments provided by the full system_interrupt_handler prototype,
+ * the function type cast is safe here.
+ */
+const system_interrupt_handler system_interrupt_handler_table[NR_SYSTEM_VECTORS] = {
+	[0 ... NR_SYSTEM_VECTORS-1]		= spurious_interrupt,
+#ifdef CONFIG_SMP
+	SYSV(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi),
+	SYSV(CALL_FUNCTION_VECTOR,		sysvec_call_function),
+	SYSV(CALL_FUNCTION_SINGLE_VECTOR,	sysvec_call_function_single),
+	SYSV(REBOOT_VECTOR,			sysvec_reboot),
+#endif
+
+#ifdef CONFIG_X86_THERMAL_VECTOR
+	SYSV(THERMAL_APIC_VECTOR,		sysvec_thermal),
+#endif
+
+#ifdef CONFIG_X86_MCE_THRESHOLD
+	SYSV(THRESHOLD_APIC_VECTOR,		sysvec_threshold),
+#endif
+
+#ifdef CONFIG_X86_MCE_AMD
+	SYSV(DEFERRED_ERROR_VECTOR,		sysvec_deferred_error),
+#endif
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	SYSV(LOCAL_TIMER_VECTOR,		sysvec_apic_timer_interrupt),
+	SYSV(X86_PLATFORM_IPI_VECTOR,		sysvec_x86_platform_ipi),
+# ifdef CONFIG_HAVE_KVM
+	SYSV(POSTED_INTR_VECTOR,		sysvec_kvm_posted_intr_ipi),
+	SYSV(POSTED_INTR_WAKEUP_VECTOR,		sysvec_kvm_posted_intr_wakeup_ipi),
+	SYSV(POSTED_INTR_NESTED_VECTOR,		sysvec_kvm_posted_intr_nested_ipi),
+# endif
+# ifdef CONFIG_IRQ_WORK
+	SYSV(IRQ_WORK_VECTOR,			sysvec_irq_work),
+# endif
+	SYSV(SPURIOUS_APIC_VECTOR,		sysvec_spurious_apic_interrupt),
+	SYSV(ERROR_APIC_VECTOR,			sysvec_error_interrupt),
+#endif
+};
+
+#pragma GCC diagnostic pop
+
+#undef SYSV
+
 void __init trap_init(void)
 {
 	/* Init cpu_entry_area before IST entries are set up */
-- 
2.34.1

