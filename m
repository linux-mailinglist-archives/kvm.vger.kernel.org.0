Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2B2429A0F
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbhJLAI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhJLAIX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:23 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F03C061570;
        Mon, 11 Oct 2021 17:06:22 -0700 (PDT)
Message-ID: <20211011223611.727493295@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=1r7yu5vPXy5SyZnbjR2SneOXObpzizgNxt6TRa0bb3Y=;
        b=EsJpGlx7k28MLM28soBIOU/nF1Pxbxe/6ynmcrKN6410Gy4yVh4a6npib47T8BHXIFvpU9
        dKPXFUBpxxL/r130VnY6cRgFm3grdNXYihQlWqUXD81VNWe1K4hP6kMefy3wQdviICExXV
        iKovkRazh3xRi+nhSdW1Bi0wzNjPOS6COKxBmxOdHdoYWRne/nEbaNuhl6icTuv1yIwv1k
        bt24pSCJNvfBQlcdY5eLCYCoJPnNkl7smgH3QlX4SO0z/PpyIgMDbmZDaZLTiMNAgUrT3k
        CqMbykhWN041EiOsT4EI2rnaUiGnFQDvm+AZIu+dd7Eiqh0QVa4U18+h2x7wrQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=1r7yu5vPXy5SyZnbjR2SneOXObpzizgNxt6TRa0bb3Y=;
        b=xZJFmxLS5rl/XeCZBMM8bDZ/qHCiB6opt8STgu04uh8Hnb8uu7y1qbwXeJITxaOoTIFdhM
        dHGMcHQOXo46YkCQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 24/31] x86/fpu: Move fpregs_restore_userregs() to core
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:34 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only used core internaly.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/internal.h |   83 -----------------------------------
 arch/x86/kernel/fpu/context.h       |   85 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/fpu/core.c          |    1 
 arch/x86/kernel/fpu/regset.c        |    1 
 arch/x86/kernel/fpu/signal.c        |    1 
 5 files changed, 88 insertions(+), 83 deletions(-)

--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -55,89 +55,6 @@ extern void restore_fpregs_from_fpstate(
 
 extern bool copy_fpstate_to_sigframe(void __user *buf, void __user *fp, int size);
 
-/*
- * FPU context switch related helper methods:
- */
-
 DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 
-/*
- * The in-register FPU state for an FPU context on a CPU is assumed to be
- * valid if the fpu->last_cpu matches the CPU, and the fpu_fpregs_owner_ctx
- * matches the FPU.
- *
- * If the FPU register state is valid, the kernel can skip restoring the
- * FPU state from memory.
- *
- * Any code that clobbers the FPU registers or updates the in-memory
- * FPU state for a task MUST let the rest of the kernel know that the
- * FPU registers are no longer valid for this task.
- *
- * Either one of these invalidation functions is enough. Invalidate
- * a resource you control: CPU if using the CPU for something else
- * (with preemption disabled), FPU for the current task, or a task that
- * is prevented from running by the current task.
- */
-static inline void __cpu_invalidate_fpregs_state(void)
-{
-	__this_cpu_write(fpu_fpregs_owner_ctx, NULL);
-}
-
-static inline void __fpu_invalidate_fpregs_state(struct fpu *fpu)
-{
-	fpu->last_cpu = -1;
-}
-
-static inline int fpregs_state_valid(struct fpu *fpu, unsigned int cpu)
-{
-	return fpu == this_cpu_read(fpu_fpregs_owner_ctx) && cpu == fpu->last_cpu;
-}
-
-/*
- * These generally need preemption protection to work,
- * do try to avoid using these on their own:
- */
-static inline void fpregs_deactivate(struct fpu *fpu)
-{
-	this_cpu_write(fpu_fpregs_owner_ctx, NULL);
-	trace_x86_fpu_regs_deactivated(fpu);
-}
-
-static inline void fpregs_activate(struct fpu *fpu)
-{
-	this_cpu_write(fpu_fpregs_owner_ctx, fpu);
-	trace_x86_fpu_regs_activated(fpu);
-}
-
-/* Internal helper for switch_fpu_return() and signal frame setup */
-static inline void fpregs_restore_userregs(void)
-{
-	struct fpu *fpu = &current->thread.fpu;
-	int cpu = smp_processor_id();
-
-	if (WARN_ON_ONCE(current->flags & PF_KTHREAD))
-		return;
-
-	if (!fpregs_state_valid(fpu, cpu)) {
-		u64 mask;
-
-		/*
-		 * This restores _all_ xstate which has not been
-		 * established yet.
-		 *
-		 * If PKRU is enabled, then the PKRU value is already
-		 * correct because it was either set in switch_to() or in
-		 * flush_thread(). So it is excluded because it might be
-		 * not up to date in current->thread.fpu.xsave state.
-		 */
-		mask = xfeatures_mask_restore_user() |
-			xfeatures_mask_supervisor();
-		restore_fpregs_from_fpstate(&fpu->state, mask);
-
-		fpregs_activate(fpu);
-		fpu->last_cpu = cpu;
-	}
-	clear_thread_flag(TIF_NEED_FPU_LOAD);
-}
-
 #endif /* _ASM_X86_FPU_INTERNAL_H */
--- /dev/null
+++ b/arch/x86/kernel/fpu/context.h
@@ -0,0 +1,85 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __X86_KERNEL_FPU_CONTEXT_H
+#define __X86_KERNEL_FPU_CONTEXT_H
+
+#include <asm/fpu/xstate.h>
+#include <asm/trace/fpu.h>
+
+/* Functions related to FPU context tracking */
+
+/*
+ * The in-register FPU state for an FPU context on a CPU is assumed to be
+ * valid if the fpu->last_cpu matches the CPU, and the fpu_fpregs_owner_ctx
+ * matches the FPU.
+ *
+ * If the FPU register state is valid, the kernel can skip restoring the
+ * FPU state from memory.
+ *
+ * Any code that clobbers the FPU registers or updates the in-memory
+ * FPU state for a task MUST let the rest of the kernel know that the
+ * FPU registers are no longer valid for this task.
+ *
+ * Either one of these invalidation functions is enough. Invalidate
+ * a resource you control: CPU if using the CPU for something else
+ * (with preemption disabled), FPU for the current task, or a task that
+ * is prevented from running by the current task.
+ */
+static inline void __cpu_invalidate_fpregs_state(void)
+{
+	__this_cpu_write(fpu_fpregs_owner_ctx, NULL);
+}
+
+static inline void __fpu_invalidate_fpregs_state(struct fpu *fpu)
+{
+	fpu->last_cpu = -1;
+}
+
+static inline int fpregs_state_valid(struct fpu *fpu, unsigned int cpu)
+{
+	return fpu == this_cpu_read(fpu_fpregs_owner_ctx) && cpu == fpu->last_cpu;
+}
+
+static inline void fpregs_deactivate(struct fpu *fpu)
+{
+	__this_cpu_write(fpu_fpregs_owner_ctx, NULL);
+	trace_x86_fpu_regs_deactivated(fpu);
+}
+
+static inline void fpregs_activate(struct fpu *fpu)
+{
+	__this_cpu_write(fpu_fpregs_owner_ctx, fpu);
+	trace_x86_fpu_regs_activated(fpu);
+}
+
+/* Internal helper for switch_fpu_return() and signal frame setup */
+static inline void fpregs_restore_userregs(void)
+{
+	struct fpu *fpu = &current->thread.fpu;
+	int cpu = smp_processor_id();
+
+	if (WARN_ON_ONCE(current->flags & PF_KTHREAD))
+		return;
+
+	if (!fpregs_state_valid(fpu, cpu)) {
+		u64 mask;
+
+		/*
+		 * This restores _all_ xstate which has not been
+		 * established yet.
+		 *
+		 * If PKRU is enabled, then the PKRU value is already
+		 * correct because it was either set in switch_to() or in
+		 * flush_thread(). So it is excluded because it might be
+		 * not up to date in current->thread.fpu.xsave state.
+		 */
+		mask = xfeatures_mask_restore_user() |
+			xfeatures_mask_supervisor();
+		restore_fpregs_from_fpstate(&fpu->state, mask);
+
+		fpregs_activate(fpu);
+		fpu->last_cpu = cpu;
+	}
+	clear_thread_flag(TIF_NEED_FPU_LOAD);
+}
+
+#endif
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -17,6 +17,7 @@
 #include <linux/hardirq.h>
 #include <linux/pkeys.h>
 
+#include "context.h"
 #include "internal.h"
 #include "legacy.h"
 #include "xstate.h"
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -10,6 +10,7 @@
 #include <asm/fpu/regset.h>
 #include <asm/fpu/xstate.h>
 
+#include "context.h"
 #include "internal.h"
 
 /*
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -16,6 +16,7 @@
 #include <asm/trapnr.h>
 #include <asm/trace/fpu.h>
 
+#include "context.h"
 #include "internal.h"
 #include "legacy.h"
 #include "xstate.h"

