Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171D6429A16
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbhJLAIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51368 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbhJLAIY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:24 -0400
Message-ID: <20211011223611.787198449@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=bRtRVFO/Qk9SnYYppFE5b04AKhvpImwNUBtl9GhSMVg=;
        b=gHrmNgi5IG/m3Y5i56g570joBTJp8ga7dJ9Rt8KNv/hw5z7AfF+cs/CyUHRTxVOtOMSEJ6
        EP+yqjeaozNiX5pStTjY92XhXNc0lHvwSUGhjwJMBYYG2Y2Acnlof2stV1g/80KZCTkTcd
        hz7OwWOrwkCotUYh89RuVMzvV4XCd5n/fq6e4+qn6NZVMOFePwE7h8pfrwaF65bA+LNEYg
        CvHN2GQQ9NdQu52Hxd2VgVxBVig5+PAdX4o0dQckK0b3e95gvKmztbk/P1TLDxPnhgL0oZ
        O4EwoMnLa7i4x+2HNnhkaeD8jfyx2lJzKpa+M/ekPleSAv2fYBlS28J2aF25sQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=bRtRVFO/Qk9SnYYppFE5b04AKhvpImwNUBtl9GhSMVg=;
        b=m7v2hdlyCl1AbGvAAySMBN34qNqhT9bb5FU3tczmOj4rYmmj4+00X1Sx5MEW5+ubmemQQn
        1YZNmm2kviAXDEDw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 25/31] x86/fpu: Move mxcsr related code to core
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:36 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No need to expose that to code which only needs the XCR0 accessors.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/xcr.h |   11 -----------
 arch/x86/kernel/fpu/init.c     |    1 +
 arch/x86/kernel/fpu/legacy.h   |    7 +++++++
 arch/x86/kernel/fpu/regset.c   |    1 +
 arch/x86/kernel/fpu/xstate.c   |    3 ++-
 arch/x86/kvm/svm/sev.c         |    2 +-
 6 files changed, 12 insertions(+), 13 deletions(-)

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
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -11,6 +11,7 @@
 #include <linux/init.h>
 
 #include "internal.h"
+#include "legacy.h"
 
 /*
  * Initialize the registers found in all CPUs, CR0 and CR4:
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
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -12,6 +12,7 @@
 
 #include "context.h"
 #include "internal.h"
+#include "legacy.h"
 
 /*
  * The xstateregs_active() routine is the same as the regset_fpregs_active() routine,
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

