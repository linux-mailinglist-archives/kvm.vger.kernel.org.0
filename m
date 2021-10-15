Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB1E42E605
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234819AbhJOBU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbhJOBTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:19:48 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75D2C06178A;
        Thu, 14 Oct 2021 18:16:36 -0700 (PDT)
Message-ID: <20211015011539.844565975@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=oLjS3bh1ZdpLwkMG093WGxLYcrvexFUXTWx+VBYZ9fg=;
        b=FCtSS7iHv41GYQlWrVG3OHSMxrcXz0sWV4o0PY1UiUyZprua26YqhZAPpHzIX07+9k7tuP
        8OYcHc2qYcHnjyJOhOcsPbYExVTkxQO2LddPZ+gx+7ynxL3GIgKcOiqD94SPm+kLQANZVV
        J9id8VKw8QTliokmZixFigzZIwzfZUbnaMeotw7Bqf4dQZurswx5hsgtT+D9D3stoqp3Uq
        EqMPFivGOsn1uLIMqx0g2ths0vzwG8H7RmmGzGw0++TMoymTl+3I4RXmN+N2kIqVwvRiS7
        OLAYx1NEwnU67duNEZD28rzsWdEr4ZV3ctkVU35fnP0Gp8mYupcvpF0lb17aAw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=oLjS3bh1ZdpLwkMG093WGxLYcrvexFUXTWx+VBYZ9fg=;
        b=z9DJdedrcaXA9hCfgbRwgFNdahmRHYwfe4dUw86qjt/ozkJG/nsQhHXNxj2V1YX0UcWf56
        OyftwTgEu9yznZAQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 26/30] x86/fpu: Remove internal.h dependency from fpu/signal.h
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:35 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to remove internal.h make signal.h independent of it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/ia32/ia32_signal.c         |  1 -
 arch/x86/include/asm/fpu/api.h      |  3 +++
 arch/x86/include/asm/fpu/internal.h |  7 -------
 arch/x86/include/asm/fpu/signal.h   | 13 +++++++++++++
 arch/x86/kernel/fpu/signal.c        |  1 -
 arch/x86/kernel/ptrace.c            |  1 -
 arch/x86/kernel/signal.c            |  1 -
 arch/x86/mm/extable.c               |  3 ++-
 8 files changed, 18 insertions(+), 12 deletions(-)
---
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 828ab0a9239b..c9c3859322fa 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -24,7 +24,6 @@
 #include <linux/syscalls.h>
 #include <asm/ucontext.h>
 #include <linux/uaccess.h>
-#include <asm/fpu/internal.h>
 #include <asm/fpu/signal.h>
 #include <asm/ptrace.h>
 #include <asm/ia32_unistd.h>
diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index ed0e2baa3f4b..764f3ae028c1 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -116,6 +116,9 @@ extern void fpstate_init_soft(struct swregs_state *soft);
 static inline void fpstate_init_soft(struct swregs_state *soft) {}
 #endif
 
+/* State tracking */
+DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
+
 /* fpstate */
 extern union fpregs_state init_fpstate;
 
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index d8bb49134ebb..8f97d3e375de 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -26,7 +26,6 @@
 /*
  * High level FPU state handling functions:
  */
-extern bool fpu__restore_sig(void __user *buf, int ia32_frame);
 extern void fpu__clear_user_states(struct fpu *fpu);
 extern int  fpu__exception_code(struct fpu *fpu, int trap_nr);
 
@@ -42,10 +41,4 @@ extern void fpu__init_system(struct cpuinfo_x86 *c);
 extern void fpu__init_check_bugs(void);
 extern void fpu__resume_cpu(void);
 
-extern void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
-
-extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
-
-DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
-
 #endif /* _ASM_X86_FPU_INTERNAL_H */
diff --git a/arch/x86/include/asm/fpu/signal.h b/arch/x86/include/asm/fpu/signal.h
index 04868a76239a..9a63a21c219d 100644
--- a/arch/x86/include/asm/fpu/signal.h
+++ b/arch/x86/include/asm/fpu/signal.h
@@ -5,6 +5,11 @@
 #ifndef _ASM_X86_FPU_SIGNAL_H
 #define _ASM_X86_FPU_SIGNAL_H
 
+#include <linux/compat.h>
+#include <linux/user.h>
+
+#include <asm/fpu/types.h>
+
 #ifdef CONFIG_X86_64
 # include <uapi/asm/sigcontext.h>
 # include <asm/user32.h>
@@ -31,4 +36,12 @@ fpu__alloc_mathframe(unsigned long sp, int ia32_frame,
 
 unsigned long fpu__get_fpstate_size(void);
 
+extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
+extern void fpu__clear_user_states(struct fpu *fpu);
+extern bool fpu__restore_sig(void __user *buf, int ia32_frame);
+
+extern void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
+
+extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
+
 #endif /* _ASM_X86_FPU_SIGNAL_H */
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index e4df905e59b0..5f5fb443b2e2 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -7,7 +7,6 @@
 #include <linux/cpu.h>
 #include <linux/pagemap.h>
 
-#include <asm/fpu/internal.h>
 #include <asm/fpu/signal.h>
 #include <asm/fpu/regset.h>
 #include <asm/fpu/xstate.h>
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 4c208ea3bd9f..1a789c8a3c3f 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -29,7 +29,6 @@
 
 #include <linux/uaccess.h>
 #include <asm/processor.h>
-#include <asm/fpu/internal.h>
 #include <asm/fpu/signal.h>
 #include <asm/fpu/regset.h>
 #include <asm/debugreg.h>
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 02ee68e68184..58bd07071d14 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -30,7 +30,6 @@
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
-#include <asm/fpu/internal.h>
 #include <asm/fpu/signal.h>
 #include <asm/vdso.h>
 #include <asm/mce.h>
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 043ec385af45..79c2e30d93ae 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -4,7 +4,8 @@
 #include <linux/sched/debug.h>
 #include <xen/xen.h>
 
-#include <asm/fpu/internal.h>
+#include <asm/fpu/signal.h>
+#include <asm/fpu/xstate.h>
 #include <asm/sev.h>
 #include <asm/traps.h>
 #include <asm/kdebug.h>

