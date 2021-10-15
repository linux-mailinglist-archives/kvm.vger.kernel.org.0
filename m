Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2366B42E5F1
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbhJOBTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbhJOBSj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF4AC061764;
        Thu, 14 Oct 2021 18:16:22 -0700 (PDT)
Message-ID: <20211015011539.349132461@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Yuqjn+FZ4rFAoVIpNWFlNZmrURRaY784kqZDrND8iCM=;
        b=AnW2PD1tiDYlkIdPWNY5n58jPT+kJIY8HQ2vXXVMD/VFncas/C/DJIhMK/QV8zAdcsgTA9
        RO+vvOr0iV5IGpvOrZ9sETYZGSfgNLQEPL8d4b6YwL/HE7OzpR8Z8GJGxhEksIkCc04V6K
        wJ1VI54VPF64jMcPc9HpIYyUxzWkxRaF7W5P3Bt+52ceLGBLXkwasbo13rCQvGi2PWZKad
        BjmGJtAELctNfY5JLkebcdGZORJVu+R4W096V1TqT60tcUcWTUrqxNgStNsu/D3Vv1to2R
        h64vDj7/EufJw9LkHyYxeNpybKA5aydc0Z6VSKEW0CAeYExDVNPGitf7OEKOPA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=Yuqjn+FZ4rFAoVIpNWFlNZmrURRaY784kqZDrND8iCM=;
        b=B0luzzmX5T6fpBcOhp8U41C8TBTpw3X3kCREv/ZQGk1fHNGgDTUjw+CP2l7BjhHMI456tv
        810lwyFGD5LuK1BA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 17/30] x86/fpu: Move context switch and exit to user
 inlines into sched.h
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:20 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

internal.h is a kitchen sink which needs to get out of the way to prepare
for the upcoming changes.

Move the context switch and exit to user inlines into a separate header,
which is all that code needs.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/internal.h | 60 +----------------------------------
 arch/x86/include/asm/fpu/sched.h    | 68 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kernel/fpu/core.c          |  1 +-
 arch/x86/kernel/process.c           |  2 +-
 arch/x86/kernel/process_32.c        |  2 +-
 arch/x86/kernel/process_64.c        |  2 +-
 6 files changed, 72 insertions(+), 63 deletions(-)
 create mode 100644 arch/x86/include/asm/fpu/sched.h
---
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 3ac55ba55782..398c87c8e199 100644
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
-extern int  fpu_clone(struct task_struct *dst);
-extern void fpu_flush_thread(void);
-
 /*
  * Boot time FPU initialization functions:
  */
@@ -82,7 +77,6 @@ extern void fpstate_init_soft(struct swregs_state *soft);
 #else
 static inline void fpstate_init_soft(struct swregs_state *soft) {}
 #endif
-extern void save_fpregs_to_fpstate(struct fpu *fpu);
 
 /*
  * Returns 0 on success or the trap number when the operation raises an
@@ -464,58 +458,4 @@ static inline void fpregs_restore_userregs(void)
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
diff --git a/arch/x86/include/asm/fpu/sched.h b/arch/x86/include/asm/fpu/sched.h
new file mode 100644
index 000000000000..cdb78d590c86
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
+extern int  fpu_clone(struct task_struct *dst);
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
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 5ed58b22a75b..4fb63a0cb4ef 100644
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
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index d2227c55e683..5cd82082353e 100644
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
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index d008e222a302..26edb1cd07a4 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -41,7 +41,7 @@
 
 #include <asm/ldt.h>
 #include <asm/processor.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/sched.h>
 #include <asm/desc.h>
 
 #include <linux/err.h>
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 39f12ef1c85c..3402edec236c 100644
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

