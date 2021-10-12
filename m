Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2EEC429A23
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbhJLAIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:55 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51544 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbhJLAI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:29 -0400
Message-ID: <20211011223611.905227254@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=BHEwndCCeICn4y0xsJCnPp3PZLShkZDVpkgf+lOaHZA=;
        b=HczKWxcGHiQq8dfAk6o4PbxVoeIJiNwxZ4+jKfQRQdSgFGkQ+9IPG/rFPlkjX8HPKQDAU/
        61Rl5jJnmnPTNXWZVNpWk1PmZ6L/rBPx1rnTXlfHx27V1pD8h4hdLrIGbZo+qUsyZX+sqA
        wscTITRXXa+ft9ML7roxkFSY7R0FMilIfKI9z+IgkLRybAY3WcjZ0tgEkxB40s7sUTypvw
        NrPgl1d61XBThdTXJqyZ4SbIPLzi8/7jpPROtDkrRrM+OycNUdoDXtB8xlxIzojl6nCZyz
        90cnR6j7B0G6uBRylpNo/+EoG9924kNVqaIZKyaM+HlaFhO3PO5JfmiJ1jKQFw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=BHEwndCCeICn4y0xsJCnPp3PZLShkZDVpkgf+lOaHZA=;
        b=P+AuLL4f6EreRiFb22KLo5UeviCaAisyFupMC3Q4HMvTwPiKwbKAEwlc1gH/jES+jGAWT9
        FJAvKEq/bJBg6kBQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 27/31] x86/fpu: Remove internal.h dependency from fpu/signal.h
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:39 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to remove internal.h make signal.h independent of it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/ia32/ia32_signal.c         |    1 -
 arch/x86/include/asm/fpu/api.h      |    3 +++
 arch/x86/include/asm/fpu/internal.h |    7 -------
 arch/x86/include/asm/fpu/signal.h   |   13 +++++++++++++
 arch/x86/kernel/fpu/signal.c        |    1 -
 arch/x86/kernel/ptrace.c            |    1 -
 arch/x86/kernel/signal.c            |    1 -
 arch/x86/mm/extable.c               |    3 ++-
 8 files changed, 18 insertions(+), 12 deletions(-)

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
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -116,6 +116,9 @@ extern void fpstate_init_soft(struct swr
 static inline void fpstate_init_soft(struct swregs_state *soft) {}
 #endif
 
+/* State tracking */
+DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
+
 /* FPSTATE */
 extern union fpregs_state init_fpstate;
 
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -26,7 +26,6 @@
 /*
  * High level FPU state handling functions:
  */
-extern bool fpu__restore_sig(void __user *buf, int ia32_frame);
 extern void fpu__clear_user_states(struct fpu *fpu);
 extern int  fpu__exception_code(struct fpu *fpu, int trap_nr);
 
@@ -42,10 +41,4 @@ extern void fpu__init_system(struct cpui
 extern void fpu__init_check_bugs(void);
 extern void fpu__resume_cpu(void);
 
-extern void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
-
-extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
-
-DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
-
 #endif /* _ASM_X86_FPU_INTERNAL_H */
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
@@ -31,4 +36,12 @@ fpu__alloc_mathframe(unsigned long sp, i
 
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
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -7,7 +7,6 @@
 #include <linux/cpu.h>
 #include <linux/pagemap.h>
 
-#include <asm/fpu/internal.h>
 #include <asm/fpu/signal.h>
 #include <asm/fpu/regset.h>
 #include <asm/fpu/xstate.h>
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -29,7 +29,6 @@
 
 #include <linux/uaccess.h>
 #include <asm/processor.h>
-#include <asm/fpu/internal.h>
 #include <asm/fpu/signal.h>
 #include <asm/fpu/regset.h>
 #include <asm/debugreg.h>
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -30,7 +30,6 @@
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
-#include <asm/fpu/internal.h>
 #include <asm/fpu/signal.h>
 #include <asm/vdso.h>
 #include <asm/mce.h>
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

