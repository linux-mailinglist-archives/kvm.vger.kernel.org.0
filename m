Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D824A429A1B
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbhJLAIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:42 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51392 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233868AbhJLAI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:29 -0400
Message-ID: <20211011223611.428058983@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=FrTsmTxLY4zfOsBVawKDcdgr8GHMDRr6FsbCRBLv7c8=;
        b=AJZj8LGJV9V7rypaeLzso38sXinKcIbf0lvzDsOzeQ1su5WdTa9lHkEvNK5lPNsTMhNN1i
        nLCGWjaU4CdrZ4+HN7hgRMHTZLbMYngky3jxl0v2xCedNLlSvAoEzmLMSHkqLwb27ooWzi
        d5yGi6O5/CuP/k9PqsxriS3Vb+cF76UMUGk8/DRduLLf13B0xyO6kuLsLtJo5hPQQPzaVV
        SHmUryfs+k1EGIhyjFUXF7/v145TcyX7yeawb6UG+v7iSmpMFXkX0UK2x75LlJb2IVdhwr
        I3PiMmXBEHxUXQIOEqbUlqP7SewAy3abqlMd9ctHf7mla4ezOJYZvbEfKPoW+Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=FrTsmTxLY4zfOsBVawKDcdgr8GHMDRr6FsbCRBLv7c8=;
        b=YLJojTzGPqnBX0Tcse7hEcrjuBuStsuS5+1Ngrr8mubTkRtX//sBhs4qRhkbs9BRbtPBDV
        ByNdNzCbLAv7RuCQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 19/31] x86/fpu: Clean up cpu feature tests
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:27 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Further disintegration of internal.h:

Move the cpu feature tests to a core header and remove the unused one.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/internal.h |   18 ------------------
 arch/x86/kernel/fpu/core.c          |    1 +
 arch/x86/kernel/fpu/internal.h      |   11 +++++++++++
 arch/x86/kernel/fpu/regset.c        |    2 ++
 4 files changed, 14 insertions(+), 18 deletions(-)

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
 
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -17,6 +17,7 @@
 #include <linux/hardirq.h>
 #include <linux/pkeys.h>
 
+#include "internal.h"
 #include "xstate.h"
 
 #define CREATE_TRACE_POINTS
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

