Return-Path: <kvm+bounces-3540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CE26805286
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:24:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4573D1F214C4
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E3B465EDE;
	Tue,  5 Dec 2023 11:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y57+k4cT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542691AA;
	Tue,  5 Dec 2023 03:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701775292; x=1733311292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k2EFvyDZMYbQ2fXvfAoaFsJLuhPG//kHzGw1Pxarr6c=;
  b=Y57+k4cTuyds4UhLuiv8ehRoWCtBpNMvYI789irrnD4+v+nWUk/pXkZ+
   7rp5SzZPIBE+9srf3iGmmaWYcBN9LAAP0K/eALJNjW1ogYmOnGoeTXfUg
   6m3QTgIiHFwAc6sxknq5I5AEbYUSj2R73RXNtz1EnsxSqpJDjyoGYRa6+
   f6fCjRhaLAPbZHlOz7VkRxQIKJKjGH9KW/OG9j+YjfE+v20TmqFYwZ2/0
   1GL/IMrGOxA17nh2Ez7nzHOIX7OCOwGpv0qev04L+r1u3xaNOB+MjcAET
   Mcxd15B1PpI6KfOG6SRRkakIhpXf6I83fKHG9hdnJ9ljv0vUkKEwVieEP
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="942582"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="942582"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2023 03:21:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="1018192980"
X-IronPort-AV: E=Sophos;i="6.04,252,1695711600"; 
   d="scan'208";a="1018192980"
Received: from unknown (HELO fred..) ([172.25.112.68])
  by fmsmga006.fm.intel.com with ESMTP; 05 Dec 2023 03:21:23 -0800
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
Subject: [PATCH v13 23/35] x86/fred: Add a debug fault entry stub for FRED
Date: Tue,  5 Dec 2023 02:50:12 -0800
Message-ID: <20231205105030.8698-24-xin3.li@intel.com>
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

From: "H. Peter Anvin (Intel)" <hpa@zytor.com>

When occurred on different ring level, i.e., from user or kernel context,
#DB needs to be handled on different stack: User #DB on current task
stack, while kernel #DB on a dedicated stack. This is exactly how FRED
event delivery invokes an exception handler: ring 3 event on level 0
stack, i.e., current task stack; ring 0 event on the #DB dedicated stack
specified in the IA32_FRED_STKLVLS MSR. So unlike IDT, the FRED debug
exception entry stub doesn't do stack switch.

On a FRED system, the debug trap status information (DR6) is passed on
the stack, to avoid the problem of transient state. Furthermore, FRED
transitions avoid a lot of ugly corner cases the handling of which can,
and should be, skipped.

The FRED debug trap status information saved on the stack differs from
DR6 in both stickiness and polarity; it is exactly in the format which
debug_read_clear_dr6() returns for the IDT entry points.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Tested-by: Shan Kang <shan.kang@intel.com>
Signed-off-by: Xin Li <xin3.li@intel.com>
---

Changes since v9:
* Disable #DB to avoid endless recursion and stack overflow when a
  watchpoint/breakpoint is set in the code path which is executed by
  #DB handler (Thomas Gleixner).

Changes since v1:
* call irqentry_nmi_{enter,exit}() in both IDT and FRED debug fault kernel
  handler (Peter Zijlstra).
---
 arch/x86/kernel/traps.c | 43 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 38 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index c876f1d36a81..848c85208a57 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -50,6 +50,7 @@
 #include <asm/ftrace.h>
 #include <asm/traps.h>
 #include <asm/desc.h>
+#include <asm/fred.h>
 #include <asm/fpu/api.h>
 #include <asm/cpu.h>
 #include <asm/cpu_entry_area.h>
@@ -934,8 +935,7 @@ static bool notify_debug(struct pt_regs *regs, unsigned long *dr6)
 	return false;
 }
 
-static __always_inline void exc_debug_kernel(struct pt_regs *regs,
-					     unsigned long dr6)
+static noinstr void exc_debug_kernel(struct pt_regs *regs, unsigned long dr6)
 {
 	/*
 	 * Disable breakpoints during exception handling; recursive exceptions
@@ -947,6 +947,11 @@ static __always_inline void exc_debug_kernel(struct pt_regs *regs,
 	 *
 	 * Entry text is excluded for HW_BP_X and cpu_entry_area, which
 	 * includes the entry stack is excluded for everything.
+	 *
+	 * For FRED, nested #DB should just work fine. But when a watchpoint or
+	 * breakpoint is set in the code path which is executed by #DB handler,
+	 * it results in an endless recursion and stack overflow. Thus we stay
+	 * with the IDT approach, i.e., save DR7 and disable #DB.
 	 */
 	unsigned long dr7 = local_db_save();
 	irqentry_state_t irq_state = irqentry_nmi_enter(regs);
@@ -976,7 +981,8 @@ static __always_inline void exc_debug_kernel(struct pt_regs *regs,
 	 * Catch SYSENTER with TF set and clear DR_STEP. If this hit a
 	 * watchpoint at the same time then that will still be handled.
 	 */
-	if ((dr6 & DR_STEP) && is_sysenter_singlestep(regs))
+	if (!cpu_feature_enabled(X86_FEATURE_FRED) &&
+	    (dr6 & DR_STEP) && is_sysenter_singlestep(regs))
 		dr6 &= ~DR_STEP;
 
 	/*
@@ -1008,8 +1014,7 @@ static __always_inline void exc_debug_kernel(struct pt_regs *regs,
 	local_db_restore(dr7);
 }
 
-static __always_inline void exc_debug_user(struct pt_regs *regs,
-					   unsigned long dr6)
+static noinstr void exc_debug_user(struct pt_regs *regs, unsigned long dr6)
 {
 	bool icebp;
 
@@ -1093,6 +1098,34 @@ DEFINE_IDTENTRY_DEBUG_USER(exc_debug)
 {
 	exc_debug_user(regs, debug_read_clear_dr6());
 }
+
+#ifdef CONFIG_X86_FRED
+/*
+ * When occurred on different ring level, i.e., from user or kernel
+ * context, #DB needs to be handled on different stack: User #DB on
+ * current task stack, while kernel #DB on a dedicated stack.
+ *
+ * This is exactly how FRED event delivery invokes an exception
+ * handler: ring 3 event on level 0 stack, i.e., current task stack;
+ * ring 0 event on the #DB dedicated stack specified in the
+ * IA32_FRED_STKLVLS MSR. So unlike IDT, the FRED debug exception
+ * entry stub doesn't do stack switch.
+ */
+DEFINE_FREDENTRY_DEBUG(exc_debug)
+{
+	/*
+	 * FRED #DB stores DR6 on the stack in the format which
+	 * debug_read_clear_dr6() returns for the IDT entry points.
+	 */
+	unsigned long dr6 = fred_event_data(regs);
+
+	if (user_mode(regs))
+		exc_debug_user(regs, dr6);
+	else
+		exc_debug_kernel(regs, dr6);
+}
+#endif /* CONFIG_X86_FRED */
+
 #else
 /* 32 bit does not have separate entry points. */
 DEFINE_IDTENTRY_RAW(exc_debug)
-- 
2.43.0


