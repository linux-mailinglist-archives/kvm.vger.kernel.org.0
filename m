Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8BD42E5F4
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhJOBTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:19:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46584 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234898AbhJOBSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:39 -0400
Message-ID: <20211015011539.740012411@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=K1kVt48y5cwbSkcpNYxYQMCbOR59BkxrewWCF+G1Xvo=;
        b=g2CpoeImdKTInzgSVFX8GXWXSh0upwKRKOGP0Uyb/z7q9GJaapEOpWNGJ++VtEFtqNUIrr
        5Lw1A1XHNo54/secSjRw9PvVkndcn3w0GwLrOYDGlXuP4rB8QCPTnFHFfDNOSGPzWXqisG
        tv7X/K7uTo+cGgCLb/+Cg4E0080ONqvPq5L5EVguUzn6xZGOojYq+PHzEKzipJ44pWPZJT
        kxfZhDRv82GUDMeclK/cW4XIB+414ZCzhbyIIlHpC+NQHDiE1aMQuPuW9GOWt7VDtJflQv
        oncyV3hmwMsYnGwEy/nqpKQ9txioIi7G0fWXHsk+Q3SB7VlfeyPgO6/pEnoFAQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=K1kVt48y5cwbSkcpNYxYQMCbOR59BkxrewWCF+G1Xvo=;
        b=5bNYA6weSFa+S84SalQOf+L8nvkJkmZkhPo5mz5b+vNaM9EfvXeujcMcccWGnVQdx2ZzrV
        9l/zWCZ34dUy1mCg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 24/30] x86/fpu: Move mxcsr related code to core
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:31 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need to expose that to code which only needs the XCR0 accessors.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/xcr.h | 11 -----------
 arch/x86/kernel/fpu/init.c     |  1 +
 arch/x86/kernel/fpu/legacy.h   |  7 +++++++
 arch/x86/kernel/fpu/regset.c   |  1 +
 arch/x86/kernel/fpu/xstate.c   |  3 ++-
 arch/x86/kvm/svm/sev.c         |  2 +-
 6 files changed, 12 insertions(+), 13 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/xcr.h b/arch/x86/include/asm/fpu/xcr.h
index 1c7ab8d95da5..79f95d3787e2 100644
--- a/arch/x86/include/asm/fpu/xcr.h
+++ b/arch/x86/include/asm/fpu/xcr.h
@@ -2,17 +2,6 @@
 #ifndef _ASM_X86_FPU_XCR_H
 #define _ASM_X86_FPU_XCR_H
 
-/*
- * MXCSR and XCR definitions:
- */
-
-static inline void ldmxcsr(u32 mxcsr)
-{
-	asm volatile("ldmxcsr %0" :: "m" (mxcsr));
-}
-
-extern unsigned int mxcsr_feature_mask;
-
 #define XCR_XFEATURE_ENABLED_MASK	0x00000000
 
 static inline u64 xgetbv(u32 index)
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 24873dfe2dba..e77084a6ae7c 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 
 #include "internal.h"
+#include "legacy.h"
 
 /*
  * Initialize the registers found in all CPUs, CR0 and CR4:
diff --git a/arch/x86/kernel/fpu/legacy.h b/arch/x86/kernel/fpu/legacy.h
index 2ff36b0f79e9..17c26b164c63 100644
--- a/arch/x86/kernel/fpu/legacy.h
+++ b/arch/x86/kernel/fpu/legacy.h
@@ -4,6 +4,13 @@
 
 #include <asm/fpu/types.h>
 
+extern unsigned int mxcsr_feature_mask;
+
+static inline void ldmxcsr(u32 mxcsr)
+{
+	asm volatile("ldmxcsr %0" :: "m" (mxcsr));
+}
+
 /*
  * Returns 0 on success or the trap number when the operation raises an
  * exception.
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index a40150e350b6..3d8ed45da166 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -12,6 +12,7 @@
 
 #include "context.h"
 #include "internal.h"
+#include "legacy.h"
 
 /*
  * The xstateregs_active() routine is the same as the regset_fpregs_active() routine,
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 246a7fea06b1..f0305b2b227f 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -14,8 +14,9 @@
 
 #include <asm/fpu/api.h>
 #include <asm/fpu/internal.h>
-#include <asm/fpu/signal.h>
 #include <asm/fpu/regset.h>
+#include <asm/fpu/signal.h>
+#include <asm/fpu/xcr.h>
 
 #include <asm/tlbflush.h>
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75e0b21ad07c..e153f3907507 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -17,10 +17,10 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
-#include <asm/fpu/internal.h>
 
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
+#include <asm/fpu/xcr.h>
 
 #include "x86.h"
 #include "svm.h"

