Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AA642E5F3
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbhJOBTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:19:21 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46568 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234890AbhJOBSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:39 -0400
Message-ID: <20211015011539.686806639@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=HPmsI8Eo9P3rBuDPDWMzg9zb6tyYtZovtLirQSc3828=;
        b=JFHB7etDaLVe2OjomSvUdWgtSvyzw7KAvmTFe/1kJZnYUpcYNiDRXUZ/vxfd6cSsonOIIJ
        n+/KwuRy3qXlzJL13HKVuyNvQtMTp9Q6yGsthlq5i893i53H+JkHHAiTVw1qYISjTf1akN
        ePujTTT+TYvtuTkSvIvKEdLg5owyOBMqEUJKurQsLyh/5ygAKrtGX2+JlgukWdtOuUFxB/
        kISLIQnRl+0k5/AE46nl3z6oEmpt/4QJee+/0Nt7VYBa9iDMiHANdEaSmw38K1DteiQgu8
        nh+FeQkp8KpLdSJAE+J6TNUZV1S6BtaEXOg/7K71JOab2fSSf09ijTpVJR8MzA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=HPmsI8Eo9P3rBuDPDWMzg9zb6tyYtZovtLirQSc3828=;
        b=c83JqMIaEVgo1+BHbGbRBsrjB7Hyxgy/jBjn0thqZ1wXNEj1PkAuaxFdedhf33M+2M7N7W
        vh0AyACrg4QVBzBA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 23/30] x86/fpu: Move fpregs_restore_userregs() to core
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:30 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only used internally in the FPU core code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: Fixed changelog - Boris
---
 arch/x86/include/asm/fpu/internal.h | 83 +-------------------------------------
 arch/x86/kernel/fpu/context.h       | 85 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/fpu/core.c          |  1 +-
 arch/x86/kernel/fpu/regset.c        |  1 +-
 arch/x86/kernel/fpu/signal.c        |  1 +-
 5 files changed, 88 insertions(+), 83 deletions(-)
 create mode 100644 arch/x86/kernel/fpu/context.h
---
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index f8413a509ba5..74b7cc3d2e77 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -55,89 +55,6 @@ extern void restore_fpregs_from_fpstate(union fpregs_state *fpstate, u64 mask);
 
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
diff --git a/arch/x86/kernel/fpu/context.h b/arch/x86/kernel/fpu/context.h
new file mode 100644
index 000000000000..e652282842c8
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
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 45ad0baa0128..4b407215abef 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -17,6 +17,7 @@
 #include <linux/hardirq.h>
 #include <linux/pkeys.h>
 
+#include "context.h"
 #include "internal.h"
 #include "legacy.h"
 #include "xstate.h"
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index ccf0c59955f1..a40150e350b6 100644
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -10,6 +10,7 @@
 #include <asm/fpu/regset.h>
 #include <asm/fpu/xstate.h>
 
+#include "context.h"
 #include "internal.h"
 
 /*
diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index 873b65ca22ed..e4df905e59b0 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -16,6 +16,7 @@
 #include <asm/trapnr.h>
 #include <asm/trace/fpu.h>
 
+#include "context.h"
 #include "internal.h"
 #include "legacy.h"
 #include "xstate.h"

