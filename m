Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192D1437CCE
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 20:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbhJVS6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 14:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbhJVS6L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 14:58:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7425BC061764;
        Fri, 22 Oct 2021 11:55:53 -0700 (PDT)
Message-ID: <20211022185312.954684740@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634928952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=kCtOWqjSOO50HHU/dvNrsvDWI43RKBmIiECch92mDqE=;
        b=cbDwcui6g7/5nwRW79oytZoY5tXNFcVzkbndV/Klflub5k46Opd1fch3MmyuQhtOKnmp0J
        nSIcSH388OuTey5jOBzVVZ95WSjCKKsbK4n3SPeLmgKD/2dQTM/MZz+MVKCABn+F+SnC3f
        mMqJx3kQ4dNW1XKUEB7oOvfnlKreZMqDn740oBUGJOpTQOLJRBaz7iyNTAfPwz6o+cTgow
        18bfft0Jk+ucZ4cQ68D42e28s0o8lOJa8hIOXr4GhtHHlU77Kd/Yle6QQ1MCmXNbYMaPYz
        XRdPJu0wcLlqBKf1egCgNYrqAQwLkoJ1M8GiBGM/Cn0OZYeXQpjacJ1NJ2GbMg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634928952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=kCtOWqjSOO50HHU/dvNrsvDWI43RKBmIiECch92mDqE=;
        b=i6Fo2Gt+SMBKokgIZXy5VbvrxKU8z5P7SvrgAYOD7tWMXaAevMo19oMT9Wq/2wuEhuHtwC
        2iWG//QUj+dgaeBw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, "Nakajima, Jun" <jun.nakajima@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [patch V2 2/4] x86/fpu: Provide infrastructure for KVM FPU cleanup
References: <20211022184540.581350173@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 22 Oct 2021 20:55:51 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the upcoming AMX support it's necessary to do a proper integration with
KVM. Currently KVM allocates two FPU structs which are used for saving the user
state of the vCPU thread and restoring the guest state when entering
vcpu_run() and doing the reverse operation before leaving vcpu_run().

With the new fpstate mechanism this can be reduced to one extra buffer by
swapping the fpstate pointer in current::thread::fpu. This makes the
upcoming support for AMX and XFD simpler because then fpstate information
(features, sizes, xfd) are always consistent and it does not require any
nasty workarounds.

Provide:

  - An allocator which initializes the state properly

  - A replacement for the existing FPU swap mechanim

Aside of the reduced memory foot print, this also makes state switching
more efficient when TIF_FPU_NEED_LOAD is set. It does not require a memcpy
as the state is already correct in the to be swapped out fpstate.

The existing interfaces will be removed once KVM is converted over.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V2: Remove the restore_mask argument as the result is constant anyway - Paolo
---
 arch/x86/include/asm/fpu/api.h |   13 ++++++
 arch/x86/kernel/fpu/core.c     |   85 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 92 insertions(+), 6 deletions(-)
---
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -135,9 +135,22 @@ extern void fpu_init_fpstate_user(struct
 extern void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature);
 
 /* KVM specific functions */
+extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
+extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
+extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest);
 extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
 
 extern int fpu_copy_kvm_uabi_to_fpstate(struct fpu *fpu, const void *buf, u64 xcr0, u32 *pkru);
 extern void fpu_copy_fpstate_to_kvm_uabi(struct fpu *fpu, void *buf, unsigned int size, u32 pkru);
 
+static inline void fpstate_set_confidential(struct fpu_guest *gfpu)
+{
+	gfpu->fpstate->is_confidential = true;
+}
+
+static inline bool fpstate_is_confidential(struct fpu_guest *gfpu)
+{
+	return gfpu->fpstate->is_confidential;
+}
+
 #endif /* _ASM_X86_FPU_API_H */
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -176,6 +176,75 @@ void fpu_reset_from_exception_fixup(void
 }
 
 #if IS_ENABLED(CONFIG_KVM)
+static void __fpstate_reset(struct fpstate *fpstate);
+
+bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
+{
+	struct fpstate *fpstate;
+	unsigned int size;
+
+	size = fpu_user_cfg.default_size + ALIGN(offsetof(struct fpstate, regs), 64);
+	fpstate = vzalloc(size);
+	if (!fpstate)
+		return false;
+
+	__fpstate_reset(fpstate);
+	fpstate_init_user(fpstate);
+	fpstate->is_valloc	= true;
+	fpstate->is_guest	= true;
+
+	gfpu->fpstate = fpstate;
+	return true;
+}
+EXPORT_SYMBOL_GPL(fpu_alloc_guest_fpstate);
+
+void fpu_free_guest_fpstate(struct fpu_guest *gfpu)
+{
+	struct fpstate *fps = gfpu->fpstate;
+
+	if (!fps)
+		return;
+
+	if (WARN_ON_ONCE(!fps->is_valloc || !fps->is_guest || fps->in_use))
+		return;
+
+	gfpu->fpstate = NULL;
+	vfree(fps);
+}
+EXPORT_SYMBOL_GPL(fpu_free_guest_fpstate);
+
+int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
+{
+	struct fpstate *guest_fps = guest_fpu->fpstate;
+	struct fpu *fpu = &current->thread.fpu;
+	struct fpstate *cur_fps = fpu->fpstate;
+
+	fpregs_lock();
+	if (!cur_fps->is_confidential && !test_thread_flag(TIF_NEED_FPU_LOAD))
+		save_fpregs_to_fpstate(fpu);
+
+	/* Swap fpstate */
+	if (enter_guest) {
+		fpu->__task_fpstate = cur_fps;
+		fpu->fpstate = guest_fps;
+		guest_fps->in_use = true;
+	} else {
+		guest_fps->in_use = false;
+		fpu->fpstate = fpu->__task_fpstate;
+		fpu->__task_fpstate = NULL;
+	}
+
+	cur_fps = fpu->fpstate;
+
+	if (!cur_fps->is_confidential)
+		restore_fpregs_from_fpstate(cur_fps, XFEATURE_MASK_FPSTATE);
+
+	fpregs_mark_activate();
+	fpregs_unlock();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpstate);
+
 void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask)
 {
 	fpregs_lock();
@@ -352,16 +421,20 @@ void fpstate_init_user(struct fpstate *f
 		fpstate_init_fstate(fpstate);
 }
 
+static void __fpstate_reset(struct fpstate *fpstate)
+{
+	/* Initialize sizes and feature masks */
+	fpstate->size		= fpu_kernel_cfg.default_size;
+	fpstate->user_size	= fpu_user_cfg.default_size;
+	fpstate->xfeatures	= fpu_kernel_cfg.default_features;
+	fpstate->user_xfeatures	= fpu_user_cfg.default_features;
+}
+
 void fpstate_reset(struct fpu *fpu)
 {
 	/* Set the fpstate pointer to the default fpstate */
 	fpu->fpstate = &fpu->__fpstate;
-
-	/* Initialize sizes and feature masks */
-	fpu->fpstate->size		= fpu_kernel_cfg.default_size;
-	fpu->fpstate->user_size		= fpu_user_cfg.default_size;
-	fpu->fpstate->xfeatures		= fpu_kernel_cfg.default_features;
-	fpu->fpstate->user_xfeatures	= fpu_user_cfg.default_features;
+	__fpstate_reset(fpu->fpstate);
 }
 
 #if IS_ENABLED(CONFIG_KVM)

