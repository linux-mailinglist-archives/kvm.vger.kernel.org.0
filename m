Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A096642E5ED
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234953AbhJOBTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:19:03 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46502 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233864AbhJOBS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:28 -0400
Message-ID: <20211015011539.401510559@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=a0QlIBSwa8Sfkm3ncNnZ66ijbSmBxDzHL00Gh1+jgG8=;
        b=YDjjTJxr2ss7qy7lo8vvqjbv9xjUaysd0vgtrniH8KxrwdZwT0r4fXuS8qQqoJcbvCui2/
        jDlIuUXYnnj/DtRgPZivQq59ppY+j1HoIpF973tqQWmuVKk3HqceyZoBENJurdwUGbLNMf
        HSv3bvdNV+HqknCOPsaaLN4tzTU6TpsxqoEAkN2fGZiB5htGSdh3clnf36zFRLBTiiKDRV
        wiza3WdOHAWS/C3g+laQFT+QnG5qwhZV5vQwdBEwPqsBIN3s3iM2drEnxoGKeOB0Qd6hX2
        qfpsMeP7+5C3BuPVoUpoNaC7GGQHd6aCMq7B7HAdJLNK6G0ShwP5E5HgxFovXg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=a0QlIBSwa8Sfkm3ncNnZ66ijbSmBxDzHL00Gh1+jgG8=;
        b=HBGw1Y5LebYxp8ouulS1s0IpM5DHTqSMKydMf10sIB+ByhoMSd86cX3I/reWLbxHMYanhe
        QnS1aeUA02MkA7Cg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 18/30] x86/fpu: Clean up cpu feature tests
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:21 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Further disintegration of internal.h:

Move the cpu feature tests to a core header and remove the unused one.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/internal.h | 18 ------------------
 arch/x86/kernel/fpu/core.c          |  1 +
 arch/x86/kernel/fpu/internal.h      | 11 +++++++++++
 arch/x86/kernel/fpu/regset.c        |  2 ++
 4 files changed, 14 insertions(+), 18 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 398c87c8e199..5da7528b3b2f 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -51,24 +51,6 @@ extern void fpu__resume_cpu(void);
 # define WARN_ON_FPU(x) ({ (void)(x); 0; })
 #endif
 
-/*
- * FPU related CPU feature flag helper routines:
- */
-static __always_inline __pure bool use_xsaveopt(void)
-{
-	return static_cpu_has(X86_FEATURE_XSAVEOPT);
-}
-
-static __always_inline __pure bool use_xsave(void)
-{
-	return static_cpu_has(X86_FEATURE_XSAVE);
-}
-
-static __always_inline __pure bool use_fxsr(void)
-{
-	return static_cpu_has(X86_FEATURE_FXSR);
-}
-
 extern union fpregs_state init_fpstate;
 extern void fpstate_init_user(union fpregs_state *state);
 
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 4fb63a0cb4ef..058df2643999 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -17,6 +17,7 @@
 #include <linux/hardirq.h>
 #include <linux/pkeys.h>
 
+#include "internal.h"
 #include "xstate.h"
 
 #define CREATE_TRACE_POINTS
diff --git a/arch/x86/kernel/fpu/internal.h b/arch/x86/kernel/fpu/internal.h
index 036f84c236dd..a8aac21ba364 100644
--- a/arch/x86/kernel/fpu/internal.h
+++ b/arch/x86/kernel/fpu/internal.h
@@ -2,6 +2,17 @@
 #ifndef __X86_KERNEL_FPU_INTERNAL_H
 #define __X86_KERNEL_FPU_INTERNAL_H
 
+/* CPU feature check wrappers */
+static __always_inline __pure bool use_xsave(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_XSAVE);
+}
+
+static __always_inline __pure bool use_fxsr(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_FXSR);
+}
+
 /* Init functions */
 extern void fpu__init_prepare_fx_sw_frame(void);
 
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 66ed317ebc0d..ccf0c59955f1 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -10,6 +10,8 @@
 #include <asm/fpu/regset.h>
 #include <asm/fpu/xstate.h>
 
+#include "internal.h"
+
 /*
  * The xstateregs_active() routine is the same as the regset_fpregs_active() routine,
  * as the "regset->n" for the xstate regset will be updated based on the feature

