Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39DEC42E5D9
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234779AbhJOBST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbhJOBSN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:13 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B6DC061753;
        Thu, 14 Oct 2021 18:16:07 -0700 (PDT)
Message-ID: <20211015011538.839822981@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=p/XFR0aVQMKKxVzOYz6MXsECkHIm28ch1vdabn5duRg=;
        b=ikhPjIVeyC3IOe8gjkJYB46r2rQjjJiCfZdPDICGuMX5n7Z5IBAUvkDO82g/ZWV4oVSfB0
        r2AwyyiwCflbr/JpV8KGpB+7Ih80Yxzf0UbUk3yftB38zcKlPVwxFoY329+xo5GPJicZH2
        orJ5D5Uy9tHbvLesk3LhaLrRMc8c/2sUC8Q6lCfPHjYNDUdMKZYlrjs4AslcH6Y5Hpgkx/
        FFdX1VdSQy09pD8O4vYLc0WnU29x5NnIx/y+Y/pjVXxhD4Wxmn+u9YV+sMsfNtYmtz+q7f
        rLnRJVC52i1RGzzha31CIISxyOIKdXJNfofWerH6fKU54XIBfUGj0xBLx8HLPA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=p/XFR0aVQMKKxVzOYz6MXsECkHIm28ch1vdabn5duRg=;
        b=y2iPbKYe3fOsGW0Vw6X8btssEiOozCvl7wx3IRjYAvUR7iiwFtTrXysaEi2ks6PxY/j8+e
        ilZ8DqpeRi8OdJCg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 08/30] x86/fpu: Do not inherit FPU context for kernel and
 IO worker threads
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:06 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no reason why kernel and IO worker threads need a full clone of
the parent's FPU state. Both are kernel threads which are not supposed to
use FPU. So copying a large state or doing XSAVE() is pointless. Just clean
out the minimaly required state for those tasks.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/fpu/core.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)
---
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 191269edac97..9a6b195a8a00 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -212,6 +212,15 @@ static inline void fpstate_init_xstate(struct xregs_state *xsave)
 	xsave->header.xcomp_bv = XCOMP_BV_COMPACTED_FORMAT | xfeatures_mask_all;
 }
 
+static inline unsigned int init_fpstate_copy_size(void)
+{
+	if (!use_xsave())
+		return fpu_kernel_xstate_size;
+
+	/* XSAVE(S) just needs the legacy and the xstate header part */
+	return sizeof(init_fpstate.xsave);
+}
+
 static inline void fpstate_init_fxstate(struct fxregs_state *fx)
 {
 	fx->cwd = 0x37f;
@@ -260,6 +269,23 @@ int fpu_clone(struct task_struct *dst)
 		return 0;
 
 	/*
+	 * Enforce reload for user space tasks and prevent kernel threads
+	 * from trying to save the FPU registers on context switch.
+	 */
+	set_tsk_thread_flag(dst, TIF_NEED_FPU_LOAD);
+
+	/*
+	 * No FPU state inheritance for kernel threads and IO
+	 * worker threads.
+	 */
+	if (dst->flags & (PF_KTHREAD | PF_IO_WORKER)) {
+		/* Clear out the minimal state */
+		memcpy(&dst_fpu->state, &init_fpstate,
+		       init_fpstate_copy_size());
+		return 0;
+	}
+
+	/*
 	 * If the FPU registers are not owned by current just memcpy() the
 	 * state.  Otherwise save the FPU registers directly into the
 	 * child's FPU context, without any memory-to-memory copying.
@@ -272,8 +298,6 @@ int fpu_clone(struct task_struct *dst)
 		save_fpregs_to_fpstate(dst_fpu);
 	fpregs_unlock();
 
-	set_tsk_thread_flag(dst, TIF_NEED_FPU_LOAD);
-
 	trace_x86_fpu_copy_src(src_fpu);
 	trace_x86_fpu_copy_dst(dst_fpu);
 
@@ -322,15 +346,6 @@ static inline void restore_fpregs_from_init_fpstate(u64 features_mask)
 	pkru_write_default();
 }
 
-static inline unsigned int init_fpstate_copy_size(void)
-{
-	if (!use_xsave())
-		return fpu_kernel_xstate_size;
-
-	/* XSAVE(S) just needs the legacy and the xstate header part */
-	return sizeof(init_fpstate.xsave);
-}
-
 /*
  * Reset current->fpu memory state to the init values.
  */

