Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA5C42E5F9
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhJOBTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:19:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46628 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhJOBSp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:45 -0400
Message-ID: <20211015011539.948837194@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=hx/pIt3bXp8CbN6mt/mxogSML+lH+MiBhjTh9wH9cQs=;
        b=SscN3BvHGQfZMD3X2uDjNaaZKCjeIbOn5kV7SigkTf0a6v3nFjliDSekMvuSQRNAlaAKfz
        EYamYkrCrhRPJ+7DnisXL/IIUu/3txP8S5/cT+Kd1xuG+PtJDG/+cJDGT8XrZhF6/LepA4
        zxy5uUAewVP8IXB5FVELG7arGjWCkYF39EV9c33HDVCC8enFn/3ahbH04Se6itqXyRXICU
        +89mX4bjMXCWr1hIZGw4f+6doyof1iE/juZsEjG+QFxVz3ty2iHHsFegR43JWjQ+5cwYC8
        ieJtzT5OkN4OMFeiYF7UIV2U6XZcCMooB1F1XqZL9MxpvLzSr+McxZQzrd/LOg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=hx/pIt3bXp8CbN6mt/mxogSML+lH+MiBhjTh9wH9cQs=;
        b=9jUf8OC/+VdtIJJJVDZ1pEAIOFtRedrJQcb4R+NxQjK7VsjVejqiKfvgFzyzvkM88KXJUF
        jQetQhX3Lm8RvhAg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 28/30] x86/fpu: Mop up the internal.h leftovers
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:38 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the global interfaces to api.h and the rest into the core.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/api.h      | 10 ++++++++++
 arch/x86/include/asm/fpu/internal.h | 18 ------------------
 arch/x86/kernel/fpu/init.c          |  1 +
 arch/x86/kernel/fpu/xstate.h        |  3 +++
 4 files changed, 14 insertions(+), 18 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 764f3ae028c1..b68d8ce599e4 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -110,6 +110,16 @@ extern int cpu_has_xfeatures(u64 xfeatures_mask, const char **feature_name);
 
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
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 8f97d3e375de..8df83e887ff6 100644
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
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index e77084a6ae7c..d420d29e58be 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -12,6 +12,7 @@
 
 #include "internal.h"
 #include "legacy.h"
+#include "xstate.h"
 
 /*
  * Initialize the registers found in all CPUs, CR0 and CR4:
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index ae61baa97682..bb6d7d298d2a 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -18,6 +18,9 @@ static inline void xstate_init_xcomp_bv(struct xregs_state *xsave, u64 mask)
 extern void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsave,
 				      u32 pkru_val, enum xstate_copy_mode copy_mode);
 
+extern void fpu__init_cpu_xstate(void);
+extern void fpu__init_system_xstate(void);
+
 /* XSAVE/XRSTOR wrapper functions */
 
 #ifdef CONFIG_X86_64

