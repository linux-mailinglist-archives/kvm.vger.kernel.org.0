Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07AC1429A24
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbhJLAI4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:56 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51368 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbhJLAI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:29 -0400
Message-ID: <20211011223612.026348843@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=F7eBvI4wTZKF2FFjAfkIvrpU/tpV4FMMwx2h4uht6Zc=;
        b=3eE9DPHOI4bp04QMFmVoutVBNMKOWdxSBAZIUnagLsSIMcUHw0zov41ft5Q7P+/N8tI+KH
        ph+o0+DSnGjyTMx+QWbbUD+3ccla4Fj+qjgY8O+WBPZP/NNByS1xYC8gl8c7EPMz+Icgmu
        OpOsGbQv7q4THZVORHL97dIz+yVxp4F8R//pnv0Z2taSsg8c2RtFtVLyDMx2QlzSva5n7B
        Ky+hWGH4MfWizbvHYU5gAd3A/DfI91mUf2GMWSbq/Ua1BXE5guKPcTU1rdVJ/JLXF19fft
        ziz3CKbgfCridTbTywHZpOBSSu6IShAU+NFhO+tndlwq/0ysd5/jwcfNDDwXFw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=F7eBvI4wTZKF2FFjAfkIvrpU/tpV4FMMwx2h4uht6Zc=;
        b=iAwcRI4xeQdK58PpCVHvfYfPI4Ig/nJKd4/K/DDTCa1eA+/fvOP9IeDFHm0v0UIj7lOzBq
        95W5zrvTL97M3zCg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 29/31] x86/fpu: Mop up the internal.h leftovers
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:42 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the global interfaces to api.h and the rest into the core.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/api.h      |   10 ++++++++++
 arch/x86/include/asm/fpu/internal.h |   18 ------------------
 arch/x86/kernel/fpu/init.c          |    1 +
 arch/x86/kernel/fpu/xstate.h        |    3 +++
 4 files changed, 14 insertions(+), 18 deletions(-)

--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -110,6 +110,16 @@ extern int cpu_has_xfeatures(u64 xfeatur
 
 static inline void update_pasid(void) { }
 
+/* Trap handling */
+extern int  fpu__exception_code(struct fpu *fpu, int trap_nr);
+extern void fpu_sync_fpstate(struct fpu *fpu);
+
+/* Boot, hotplug and resume */
+extern void fpu__init_cpu(void);
+extern void fpu__init_system(struct cpuinfo_x86 *c);
+extern void fpu__init_check_bugs(void);
+extern void fpu__resume_cpu(void);
+
 #ifdef CONFIG_MATH_EMULATION
 extern void fpstate_init_soft(struct swregs_state *soft);
 #else
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -23,22 +23,4 @@
 #include <asm/cpufeature.h>
 #include <asm/trace/fpu.h>
 
-/*
- * High level FPU state handling functions:
- */
-extern void fpu__clear_user_states(struct fpu *fpu);
-extern int  fpu__exception_code(struct fpu *fpu, int trap_nr);
-
-extern void fpu_sync_fpstate(struct fpu *fpu);
-
-/*
- * Boot time FPU initialization functions:
- */
-extern void fpu__init_cpu(void);
-extern void fpu__init_system_xstate(void);
-extern void fpu__init_cpu_xstate(void);
-extern void fpu__init_system(struct cpuinfo_x86 *c);
-extern void fpu__init_check_bugs(void);
-extern void fpu__resume_cpu(void);
-
 #endif /* _ASM_X86_FPU_INTERNAL_H */
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -12,6 +12,7 @@
 
 #include "internal.h"
 #include "legacy.h"
+#include "xstate.h"
 
 /*
  * Initialize the registers found in all CPUs, CR0 and CR4:
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -18,6 +18,9 @@ static inline void xstate_init_xcomp_bv(
 extern void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsave,
 				      u32 pkru_val, enum xstate_copy_mode copy_mode);
 
+extern void fpu__init_cpu_xstate(void);
+extern void fpu__init_system_xstate(void);
+
 /* XSAVE/XRSTOR wrapper functions */
 
 #ifdef CONFIG_X86_64

