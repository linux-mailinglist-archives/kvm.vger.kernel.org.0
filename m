Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CECB429A1C
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbhJLAIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:44 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51550 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbhJLAI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:29 -0400
Message-ID: <20211011223611.366238313@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=f3VP54IkLXbEb26hhi82VGdpjCIjZgFZjEVfCyYt2Fw=;
        b=NzSzQ0ztq7fLv5bhCnK5br8bRZnbTr1pd1adGQRiul7L+GeY3ySgupn+Cd4RnuIreIiUOf
        lD/imwH3v2y21mTGv97PAxTZILkcFOwctzZ5lhQnAQAK7jyEDFQV80BdFGmXYcMMYMK4ov
        mTjy23xuvvHXuMxraSlbWoX2c8RPl4QlM+EIranW/LuoqK+yD5ezuiaaiRyhx84tefkDfs
        wV2bmtXktlcD2cAnIoQdkOkjKyN1Y+yfKSA6d7qYjLOxGdeaWYaG7OIc8esWmYkiKgaYEF
        FRABdsUd36lOtbLLWN967cwegmsPfid1dkTq6t4JKckQKTQ5wsp1DONL9A1hhg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=f3VP54IkLXbEb26hhi82VGdpjCIjZgFZjEVfCyYt2Fw=;
        b=08jkdat4JviMl8stWrrF9MCYeaupfI5h/oj87mC/PyTAnzKEUxobZoQfk08OHxgNVGLAUo
        qJqKoqmuTNQPB4DQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 18/31] x86/fpu: Move context switch and exit to user inlines
 into sched.h
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:25 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

internal.h is a kitchen sink which needs to get out of the way to prepare
for the upcoming changes.

Move the context switch and exit to user inlines into a separate header,
which is all that code needs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/internal.h |   60 -------------------------------
 arch/x86/include/asm/fpu/sched.h    |   68 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/fpu/core.c          |    1 
 arch/x86/kernel/process.c           |    2 -
 arch/x86/kernel/process_32.c        |    2 -
 arch/x86/kernel/process_64.c        |    2 -
 6 files changed, 72 insertions(+), 63 deletions(-)

--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -27,16 +27,11 @@
  * High level FPU state handling functions:
  */
 extern bool fpu__restore_sig(void __user *buf, int ia32_frame);
-extern void fpu__drop(struct fpu *fpu);
 extern void fpu__clear_user_states(struct fpu *fpu);
 extern int  fpu__exception_code(struct fpu *fpu, int trap_nr);
 
 extern void fpu_sync_fpstate(struct fpu *fpu);
 
-/* Clone and exit operations */
-extern int  fpu_clone(struct task_struct *dst, unsigned long clone_flags);
-extern void fpu_flush_thread(void);
-
 /*
  * Boot time FPU initialization functions:
  */
@@ -82,7 +77,6 @@ extern void fpstate_init_soft(struct swr
 #else
 static inline void fpstate_init_soft(struct swregs_state *soft) {}
 #endif
-extern void save_fpregs_to_fpstate(struct fpu *fpu);
 
 /*
  * Returns 0 on success or the trap number when the operation raises an
@@ -464,58 +458,4 @@ static inline void fpregs_restore_userre
 	clear_thread_flag(TIF_NEED_FPU_LOAD);
 }
 
-/*
- * FPU state switching for scheduling.
- *
- * This is a two-stage process:
- *
- *  - switch_fpu_prepare() saves the old state.
- *    This is done within the context of the old process.
- *
- *  - switch_fpu_finish() sets TIF_NEED_FPU_LOAD; the floating point state
- *    will get loaded on return to userspace, or when the kernel needs it.
- *
- * If TIF_NEED_FPU_LOAD is cleared then the CPU's FPU registers
- * are saved in the current thread's FPU register state.
- *
- * If TIF_NEED_FPU_LOAD is set then CPU's FPU registers may not
- * hold current()'s FPU registers. It is required to load the
- * registers before returning to userland or using the content
- * otherwise.
- *
- * The FPU context is only stored/restored for a user task and
- * PF_KTHREAD is used to distinguish between kernel and user threads.
- */
-static inline void switch_fpu_prepare(struct fpu *old_fpu, int cpu)
-{
-	if (static_cpu_has(X86_FEATURE_FPU) && !(current->flags & PF_KTHREAD)) {
-		save_fpregs_to_fpstate(old_fpu);
-		/*
-		 * The save operation preserved register state, so the
-		 * fpu_fpregs_owner_ctx is still @old_fpu. Store the
-		 * current CPU number in @old_fpu, so the next return
-		 * to user space can avoid the FPU register restore
-		 * when is returns on the same CPU and still owns the
-		 * context.
-		 */
-		old_fpu->last_cpu = cpu;
-
-		trace_x86_fpu_regs_deactivated(old_fpu);
-	}
-}
-
-/*
- * Misc helper functions:
- */
-
-/*
- * Delay loading of the complete FPU state until the return to userland.
- * PKRU is handled separately.
- */
-static inline void switch_fpu_finish(void)
-{
-	if (cpu_feature_enabled(X86_FEATURE_FPU))
-		set_thread_flag(TIF_NEED_FPU_LOAD);
-}
-
 #endif /* _ASM_X86_FPU_INTERNAL_H */
--- /dev/null
+++ b/arch/x86/include/asm/fpu/sched.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_FPU_SCHED_H
+#define _ASM_X86_FPU_SCHED_H
+
+#include <linux/sched.h>
+
+#include <asm/cpufeature.h>
+#include <asm/fpu/types.h>
+
+#include <asm/trace/fpu.h>
+
+extern void save_fpregs_to_fpstate(struct fpu *fpu);
+extern void fpu__drop(struct fpu *fpu);
+extern int  fpu_clone(struct task_struct *dst, unsigned long clone_flags);
+extern void fpu_flush_thread(void);
+
+/*
+ * FPU state switching for scheduling.
+ *
+ * This is a two-stage process:
+ *
+ *  - switch_fpu_prepare() saves the old state.
+ *    This is done within the context of the old process.
+ *
+ *  - switch_fpu_finish() sets TIF_NEED_FPU_LOAD; the floating point state
+ *    will get loaded on return to userspace, or when the kernel needs it.
+ *
+ * If TIF_NEED_FPU_LOAD is cleared then the CPU's FPU registers
+ * are saved in the current thread's FPU register state.
+ *
+ * If TIF_NEED_FPU_LOAD is set then CPU's FPU registers may not
+ * hold current()'s FPU registers. It is required to load the
+ * registers before returning to userland or using the content
+ * otherwise.
+ *
+ * The FPU context is only stored/restored for a user task and
+ * PF_KTHREAD is used to distinguish between kernel and user threads.
+ */
+static inline void switch_fpu_prepare(struct fpu *old_fpu, int cpu)
+{
+	if (cpu_feature_enabled(X86_FEATURE_FPU) &&
+	    !(current->flags & PF_KTHREAD)) {
+		save_fpregs_to_fpstate(old_fpu);
+		/*
+		 * The save operation preserved register state, so the
+		 * fpu_fpregs_owner_ctx is still @old_fpu. Store the
+		 * current CPU number in @old_fpu, so the next return
+		 * to user space can avoid the FPU register restore
+		 * when is returns on the same CPU and still owns the
+		 * context.
+		 */
+		old_fpu->last_cpu = cpu;
+
+		trace_x86_fpu_regs_deactivated(old_fpu);
+	}
+}
+
+/*
+ * Delay loading of the complete FPU state until the return to userland.
+ * PKRU is handled separately.
+ */
+static inline void switch_fpu_finish(void)
+{
+	if (cpu_feature_enabled(X86_FEATURE_FPU))
+		set_thread_flag(TIF_NEED_FPU_LOAD);
+}
+
+#endif /* _ASM_X86_FPU_SCHED_H */
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -8,6 +8,7 @@
  */
 #include <asm/fpu/internal.h>
 #include <asm/fpu/regset.h>
+#include <asm/fpu/sched.h>
 #include <asm/fpu/signal.h>
 #include <asm/fpu/types.h>
 #include <asm/traps.h>
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -30,7 +30,7 @@
 #include <asm/apic.h>
 #include <linux/uaccess.h>
 #include <asm/mwait.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/sched.h>
 #include <asm/debugreg.h>
 #include <asm/nmi.h>
 #include <asm/tlbflush.h>
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -41,7 +41,7 @@
 
 #include <asm/ldt.h>
 #include <asm/processor.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/sched.h>
 #include <asm/desc.h>
 
 #include <linux/err.h>
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -42,7 +42,7 @@
 
 #include <asm/processor.h>
 #include <asm/pkru.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/sched.h>
 #include <asm/mmu_context.h>
 #include <asm/prctl.h>
 #include <asm/desc.h>

