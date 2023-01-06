Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B5D65FDA4
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 10:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233974AbjAFJV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 04:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbjAFJUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 04:20:23 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6336B5DB;
        Fri,  6 Jan 2023 01:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672996821; x=1704532821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HxTCreXXWqz2iyTTMZZZILWM+lNGkPXPUC6O03X4+dc=;
  b=OGrh40OcOemafPYqVaQuAlhPcyCjfjH+bq1PSIns32Sn0KK43VkJXSrB
   /T/BFRS8kgrm+JG8sB3Kmmt3O/x3u/WwglWNMyG+OG20QYoUkSH5YY8u6
   ZkQ5Yf219/N+DGFBjrxCDrKbO7BkGr0RFvjnIOsobcpFOnz8OKwZT5JrL
   X9aC25UK+tliumeLJH6sgWx3wULx9NdRY5AAcx3ACFSNrqJz12Cl4lPSx
   PPop8cyndaRPoowzSZ7bfr8RGtd5msl6cyQi44SVxzdU7g52rvd3XclRB
   DeCKWhI/zFTreVpry2wIdj+BAg3OE5/dF6M7uOEA7yUbtZT6lbSfGvmxk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="322511532"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="322511532"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 01:20:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="719139407"
X-IronPort-AV: E=Sophos;i="5.96,304,1665471600"; 
   d="scan'208";a="719139407"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 01:20:15 -0800
From:   Xin Li <xin3.li@intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, seanjc@google.com, pbonzini@redhat.com,
        ravi.v.shankar@intel.com
Subject: [RFC PATCH v2 18/32] x86/fred: add a debug fault entry stub for FRED
Date:   Fri,  6 Jan 2023 00:56:03 -0800
Message-Id: <20230106085617.17248-19-xin3.li@intel.com>
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

Add a debug fault entry stub for FRED.

On a FRED system, the debug trap status information (DR6) is passed
on the stack, to avoid the problem of transient state. Furthermore,
FRED transitions avoid a lot of ugly corner cases the handling of which
can, and should be, skipped.

The FRED debug trap status information saved on the stack differs from DR6
in both stickiness and polarity; it is exactly what debug_read_clear_dr6()
returns, and exc_debug_user()/exc_debug_kernel() expect.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v1:
* call irqentry_nmi_{enter,exit}() in both IDT and FRED debug fault kernel
  handler (Peter Zijlstra).
---
 arch/x86/include/asm/fred.h |  1 +
 arch/x86/kernel/traps.c     | 56 +++++++++++++++++++++++++++----------
 2 files changed, 42 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/fred.h b/arch/x86/include/asm/fred.h
index de300bda60ee..def4b3455c1f 100644
--- a/arch/x86/include/asm/fred.h
+++ b/arch/x86/include/asm/fred.h
@@ -94,6 +94,7 @@ static __always_inline unsigned long fred_event_data(struct pt_regs *regs)
 #define DEFINE_FRED_HANDLER(f) noinstr DECLARE_FRED_HANDLER(f)
 typedef DECLARE_FRED_HANDLER((*fred_handler));
 
+DECLARE_FRED_HANDLER(fred_exc_debug);
 DECLARE_FRED_HANDLER(fred_exc_page_fault);
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 99386836b02e..503cb5a62f70 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -47,6 +47,7 @@
 #include <asm/debugreg.h>
 #include <asm/realmode.h>
 #include <asm/text-patching.h>
+#include <asm/fred.h>
 #include <asm/ftrace.h>
 #include <asm/traps.h>
 #include <asm/desc.h>
@@ -1020,21 +1021,9 @@ static bool notify_debug(struct pt_regs *regs, unsigned long *dr6)
 	return false;
 }
 
-static __always_inline void exc_debug_kernel(struct pt_regs *regs,
-					     unsigned long dr6)
+static __always_inline void debug_kernel_common(struct pt_regs *regs,
+						unsigned long dr6)
 {
-	/*
-	 * Disable breakpoints during exception handling; recursive exceptions
-	 * are exceedingly 'fun'.
-	 *
-	 * Since this function is NOKPROBE, and that also applies to
-	 * HW_BREAKPOINT_X, we can't hit a breakpoint before this (XXX except a
-	 * HW_BREAKPOINT_W on our stack)
-	 *
-	 * Entry text is excluded for HW_BP_X and cpu_entry_area, which
-	 * includes the entry stack is excluded for everything.
-	 */
-	unsigned long dr7 = local_db_save();
 	irqentry_state_t irq_state = irqentry_nmi_enter(regs);
 	instrumentation_begin();
 
@@ -1062,7 +1051,8 @@ static __always_inline void exc_debug_kernel(struct pt_regs *regs,
 	 * Catch SYSENTER with TF set and clear DR_STEP. If this hit a
 	 * watchpoint at the same time then that will still be handled.
 	 */
-	if ((dr6 & DR_STEP) && is_sysenter_singlestep(regs))
+	if (!cpu_feature_enabled(X86_FEATURE_FRED) &&
+	    (dr6 & DR_STEP) && is_sysenter_singlestep(regs))
 		dr6 &= ~DR_STEP;
 
 	/*
@@ -1090,7 +1080,25 @@ static __always_inline void exc_debug_kernel(struct pt_regs *regs,
 out:
 	instrumentation_end();
 	irqentry_nmi_exit(regs, irq_state);
+}
 
+static __always_inline void exc_debug_kernel(struct pt_regs *regs,
+					     unsigned long dr6)
+{
+	/*
+	 * Disable breakpoints during exception handling; recursive exceptions
+	 * are exceedingly 'fun'.
+	 *
+	 * Since this function is NOKPROBE, and that also applies to
+	 * HW_BREAKPOINT_X, we can't hit a breakpoint before this (XXX except a
+	 * HW_BREAKPOINT_W on our stack)
+	 *
+	 * Entry text is excluded for HW_BP_X and cpu_entry_area, which
+	 * includes the entry stack is excluded for everything.
+	 */
+	unsigned long dr7 = local_db_save();
+
+	debug_kernel_common(regs, dr6);
 	local_db_restore(dr7);
 }
 
@@ -1179,6 +1187,24 @@ DEFINE_IDTENTRY_DEBUG_USER(exc_debug)
 {
 	exc_debug_user(regs, debug_read_clear_dr6());
 }
+
+# ifdef CONFIG_X86_FRED
+DEFINE_FRED_HANDLER(fred_exc_debug)
+{
+	/*
+	 * The FRED debug information saved onto stack differs from
+	 * DR6 in both stickiness and polarity; it is exactly what
+	 * debug_read_clear_dr6() returns.
+	 */
+	unsigned long dr6 = fred_event_data(regs);
+
+	if (user_mode(regs))
+		exc_debug_user(regs, dr6);
+	else
+		debug_kernel_common(regs, dr6);
+}
+# endif /* CONFIG_X86_FRED */
+
 #else
 /* 32 bit does not have separate entry points. */
 DEFINE_IDTENTRY_RAW(exc_debug)
-- 
2.34.1

