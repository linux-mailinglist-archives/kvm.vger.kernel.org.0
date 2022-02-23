Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603C34C0C1F
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 06:28:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238514AbiBWF1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 00:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238341AbiBWF0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 00:26:49 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B3A6D1A2
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:09 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id z15-20020a25bb0f000000b00613388c7d99so26693968ybg.8
        for <kvm@vger.kernel.org>; Tue, 22 Feb 2022 21:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8mE7Rl7hvX81PshmRchAKXUw+5mI1RoqZfuGnjfnK/Y=;
        b=nQn+PHDiNT2rMQDvqUgnDcQMr757vUw1xTfeWksvd/uBs+Y7jycIPiRL7S70urPZ7R
         8fkcrVfE/buziQatz1VzPrbZiKkVL88UDR47kWH9EmA5cOthED7jMA11HUYJo4xm65uX
         LbfLzZbh1vmkmQVGPzCZHhrvQkG2yMMs6jlVlPGs+f1MYI9eWUOQGRHF/yHWkKAQuG9+
         90/ZWnlFIBlEl9DgOrfwf+XgiBD2V3yGyekMz3rvqGQAKX6yRkMkTlYi4dCG11i6F1bh
         Phi+HrSt7E6OdAajjE7T2WGE+PvAmrOCFwLD3vGl5nSuUdeg1Ly1y8XU57nLBdCyfJFb
         Mrkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8mE7Rl7hvX81PshmRchAKXUw+5mI1RoqZfuGnjfnK/Y=;
        b=Uesk2CEKgc4E1BbLIOIa121hddf52Jlcxsa+KyRiyC4MNVTLOIP2W3WIx3R+l9w8Sn
         EPsSOGH/17xyxTtSJaigoCtd7sEDfuACMv2e3Wiu4Gs5gDRZdEnu2nOOECOZxNz3QY83
         5k0PIN3HUCANZaMJPxY6IiI/8fJYjYshNC3hNl7+rOUufCdyS9+tT6w1vo9t8MQS4UzB
         d1oTKAfS5H5Bz7syP5egMqzAPNc0J4FnIaO/mwOMpaBYmIGxyBUegsyTZBc294UHCLdM
         OlBt+AVDoG/0uQH+Ptl8xVdcUDbZ7BLL/e3Ito0WTV4rYubk1F35HoJLQdMG4I/PJMDY
         v0pQ==
X-Gm-Message-State: AOAM530GaDCKUAAx8BNA+oWdtIzGmjmmaEEY4t/9eggLTn2hjcFfA4mD
        IG5Xiq3Xc9WvrtfMg/3puRBKJ6tAWfBw
X-Google-Smtp-Source: ABdhPJw219sWzgLSxca1tmB8U/7JNof+qQBV1MFnda0VeJBWRGjfZ3IqT80R/0u8HdfUK/arZaU6tbXLeppv
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:ccbe:5d15:e2e6:322])
 (user=junaids job=sendgmr) by 2002:a0d:df4e:0:b0:2d0:ab1e:6055 with SMTP id
 i75-20020a0ddf4e000000b002d0ab1e6055mr27301388ywe.333.1645593896772; Tue, 22
 Feb 2022 21:24:56 -0800 (PST)
Date:   Tue, 22 Feb 2022 21:22:08 -0800
In-Reply-To: <20220223052223.1202152-1-junaids@google.com>
Message-Id: <20220223052223.1202152-33-junaids@google.com>
Mime-Version: 1.0
References: <20220223052223.1202152-1-junaids@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [RFC PATCH 32/47] x86: asi: Allocate FPU state separately when ASI is enabled.
From:   Junaid Shahid <junaids@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        pjt@google.com, oweisse@google.com, alexandre.chartre@oracle.com,
        rppt@linux.ibm.com, dave.hansen@linux.intel.com,
        peterz@infradead.org, tglx@linutronix.de, luto@kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We are going to be mapping the task_struct in the restricted ASI
address space. However, the task_struct also contains the FPU
register state embedded inside it, which can contain sensitive
information. So when ASI is enabled, always allocate the FPU
state from a separate slab cache to keep it out of task_struct.

Signed-off-by: Junaid Shahid <junaids@google.com>


---
 arch/x86/include/asm/fpu/api.h |  1 +
 arch/x86/kernel/fpu/core.c     | 45 ++++++++++++++++++++++++++++++++--
 arch/x86/kernel/fpu/init.c     |  7 ++++--
 arch/x86/kernel/fpu/internal.h |  1 +
 arch/x86/kernel/fpu/xstate.c   | 21 +++++++++++++---
 arch/x86/kernel/process.c      |  7 +++++-
 6 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index c2767a6a387e..6f5ca3c2ef4a 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -112,6 +112,7 @@ extern void fpu__init_cpu(void);
 extern void fpu__init_system(struct cpuinfo_x86 *c);
 extern void fpu__init_check_bugs(void);
 extern void fpu__resume_cpu(void);
+extern void fpstate_cache_init(void);
 
 #ifdef CONFIG_MATH_EMULATION
 extern void fpstate_init_soft(struct swregs_state *soft);
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 8ea306b1bf8e..d7859573973d 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -59,6 +59,8 @@ static DEFINE_PER_CPU(bool, in_kernel_fpu);
  */
 DEFINE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 
+struct kmem_cache *fpstate_cachep;
+
 static bool kernel_fpu_disabled(void)
 {
 	return this_cpu_read(in_kernel_fpu);
@@ -443,7 +445,9 @@ static void __fpstate_reset(struct fpstate *fpstate)
 void fpstate_reset(struct fpu *fpu)
 {
 	/* Set the fpstate pointer to the default fpstate */
-	fpu->fpstate = &fpu->__fpstate;
+	if (!cpu_feature_enabled(X86_FEATURE_ASI))
+		fpu->fpstate = &fpu->__fpstate;
+
 	__fpstate_reset(fpu->fpstate);
 
 	/* Initialize the permission related info in fpu */
@@ -464,6 +468,26 @@ static inline void fpu_inherit_perms(struct fpu *dst_fpu)
 	}
 }
 
+void fpstate_cache_init(void)
+{
+	if (cpu_feature_enabled(X86_FEATURE_ASI)) {
+		size_t fpstate_size;
+
+		/* TODO: Is the ALIGN-64 really needed? */
+		fpstate_size = fpu_kernel_cfg.default_size +
+			       ALIGN(offsetof(struct fpstate, regs), 64);
+
+		fpstate_cachep = kmem_cache_create_usercopy(
+						"fpstate",
+						fpstate_size,
+						__alignof__(struct fpstate),
+						SLAB_PANIC | SLAB_ACCOUNT,
+						offsetof(struct fpstate, regs),
+						fpu_kernel_cfg.default_size,
+						NULL);
+	}
+}
+
 /* Clone current's FPU state on fork */
 int fpu_clone(struct task_struct *dst, unsigned long clone_flags)
 {
@@ -473,6 +497,22 @@ int fpu_clone(struct task_struct *dst, unsigned long clone_flags)
 	/* The new task's FPU state cannot be valid in the hardware. */
 	dst_fpu->last_cpu = -1;
 
+	if (cpu_feature_enabled(X86_FEATURE_ASI)) {
+		dst_fpu->fpstate = kmem_cache_alloc_node(
+						fpstate_cachep, GFP_KERNEL,
+						page_to_nid(virt_to_page(dst)));
+		if (!dst_fpu->fpstate)
+			return -ENOMEM;
+
+		/*
+		 * TODO: We may be able to skip the copy since the registers are
+		 * restored below anyway.
+		 */
+		memcpy(dst_fpu->fpstate, src_fpu->fpstate,
+		       fpu_kernel_cfg.default_size +
+		       offsetof(struct fpstate, regs));
+	}
+
 	fpstate_reset(dst_fpu);
 
 	if (!cpu_feature_enabled(X86_FEATURE_FPU))
@@ -531,7 +571,8 @@ int fpu_clone(struct task_struct *dst, unsigned long clone_flags)
 void fpu_thread_struct_whitelist(unsigned long *offset, unsigned long *size)
 {
 	*offset = offsetof(struct thread_struct, fpu.__fpstate.regs);
-	*size = fpu_kernel_cfg.default_size;
+	*size = cpu_feature_enabled(X86_FEATURE_ASI)
+		? 0 : fpu_kernel_cfg.default_size;
 }
 
 /*
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 621f4b6cac4a..8b722bf98135 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -161,9 +161,11 @@ static void __init fpu__init_task_struct_size(void)
 
 	/*
 	 * Add back the dynamically-calculated register state
-	 * size.
+	 * size, except when ASI is enabled, since in that case
+	 * the FPU state is always allocated dynamically.
 	 */
-	task_size += fpu_kernel_cfg.default_size;
+	if (!cpu_feature_enabled(X86_FEATURE_ASI))
+		task_size += fpu_kernel_cfg.default_size;
 
 	/*
 	 * We dynamically size 'struct fpu', so we require that
@@ -223,6 +225,7 @@ static void __init fpu__init_init_fpstate(void)
  */
 void __init fpu__init_system(struct cpuinfo_x86 *c)
 {
+	current->thread.fpu.fpstate = &current->thread.fpu.__fpstate;
 	fpstate_reset(&current->thread.fpu);
 	fpu__init_system_early_generic(c);
 
diff --git a/arch/x86/kernel/fpu/internal.h b/arch/x86/kernel/fpu/internal.h
index dbdb31f55fc7..30acc7d0cb1a 100644
--- a/arch/x86/kernel/fpu/internal.h
+++ b/arch/x86/kernel/fpu/internal.h
@@ -3,6 +3,7 @@
 #define __X86_KERNEL_FPU_INTERNAL_H
 
 extern struct fpstate init_fpstate;
+extern struct kmem_cache *fpstate_cachep;
 
 /* CPU feature check wrappers */
 static __always_inline __pure bool use_xsave(void)
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index d28829403ed0..96d12f351f19 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -13,6 +13,7 @@
 #include <linux/seq_file.h>
 #include <linux/proc_fs.h>
 #include <linux/vmalloc.h>
+#include <linux/slab.h>
 
 #include <asm/fpu/api.h>
 #include <asm/fpu/regset.h>
@@ -1495,8 +1496,15 @@ arch_initcall(xfd_update_static_branch)
 
 void fpstate_free(struct fpu *fpu)
 {
-	if (fpu->fpstate && fpu->fpstate != &fpu->__fpstate)
-		vfree(fpu->fpstate);
+	WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_ASI) &&
+		     fpu->fpstate == &fpu->__fpstate);
+
+	if (fpu->fpstate && fpu->fpstate != &fpu->__fpstate) {
+		if (fpu->fpstate->is_valloc)
+			vfree(fpu->fpstate);
+		else
+			kmem_cache_free(fpstate_cachep, fpu->fpstate);
+	}
 }
 
 /**
@@ -1574,7 +1582,14 @@ static int fpstate_realloc(u64 xfeatures, unsigned int ksize,
 
 	fpregs_unlock();
 
-	vfree(curfps);
+	WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_ASI) && !curfps);
+	if (curfps) {
+		if (curfps->is_valloc)
+			vfree(curfps);
+		else
+			kmem_cache_free(fpstate_cachep, curfps);
+	}
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index c8d4a00a4de7..f9bd1c3415d4 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -80,6 +80,11 @@ EXPORT_PER_CPU_SYMBOL(cpu_tss_rw);
 DEFINE_PER_CPU(bool, __tss_limit_invalid);
 EXPORT_PER_CPU_SYMBOL_GPL(__tss_limit_invalid);
 
+void __init arch_task_cache_init(void)
+{
+	fpstate_cache_init();
+}
+
 /*
  * this gets called so that we can store lazy state into memory and copy the
  * current task into the new thread.
@@ -101,7 +106,7 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 #ifdef CONFIG_X86_64
 void arch_release_task_struct(struct task_struct *tsk)
 {
-	if (fpu_state_size_dynamic())
+	if (fpu_state_size_dynamic() || cpu_feature_enabled(X86_FEATURE_ASI))
 		fpstate_free(&tsk->thread.fpu);
 }
 #endif
-- 
2.35.1.473.g83b2b277ed-goog

