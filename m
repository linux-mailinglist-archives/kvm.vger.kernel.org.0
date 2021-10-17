Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16497430B06
	for <lists+kvm@lfdr.de>; Sun, 17 Oct 2021 19:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344391AbhJQRFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Oct 2021 13:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344340AbhJQRFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Oct 2021 13:05:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7D6C06161C;
        Sun, 17 Oct 2021 10:03:22 -0700 (PDT)
Message-ID: <20211017152048.726038584@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634490199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=aHWXrxAAqFdnNUVjMAZJd7nF6eNjzsty49yxP1lnWL4=;
        b=BXQTb/URty11XKDlTMPmGPMX/xT5uyr0QZtzQSX9ecg/718GLsRM523Ovfu/v10VSNHlA0
        ziXzKwjneX33lTWtmvCaZHzfRUes+at448L4K3jPAFLGgd+wAfdVnMAcM2aJz8CItlz61O
        mqw7VC/x0kf9mZ+spXqR+t1XuFblgRsKdmVh+eTSJtgPu3aeGHf//WqIvD4KRW03Uj/eK/
        NSLYt0c6mgikwaUcHWG58XtJo1LccQQsbfMzGeReYdozhQGHym+dSsB9OyqSV2hDYW+jCP
        InUrk0hdTM2m7eHtd8jLK+dmjf5Gq8DkB+FOTn2rLqRYhv4IFw/1a/bKPULjng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634490199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=aHWXrxAAqFdnNUVjMAZJd7nF6eNjzsty49yxP1lnWL4=;
        b=WxUCi+DhQ7vev8oFfE+Cq0puViSCljF/COTrEX1ffezZ/GL1snTQuvvkf7By+EG1lIkRUd
        p7yO+3mqW9d0qOBA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, "Nakajima, Jun" <jun.nakajima@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [patch 4/4] x86/fpu: Remove old KVM FPU interface
References: <20211017151447.829495362@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 17 Oct 2021 19:03:19 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No more users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/api.h |  2 --
 arch/x86/kernel/fpu/core.c     | 32 --------------------------------
 2 files changed, 34 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 239909a95368..286a66ff0bd1 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -131,14 +131,12 @@ static inline void fpstate_init_soft(struct swregs_state *soft) {}
 DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 
 /* fpstate-related functions which are exported to KVM */
-extern void fpu_init_fpstate_user(struct fpu *fpu);
 extern void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature);
 
 /* KVM specific functions */
 extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
 extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
 extern int fpu_swap_kvm_fpstate(struct fpu_guest *gfpu, bool enter_guest, u64 restore_mask);
-extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
 
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
 extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 60681dc8a725..4b09f0f70082 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -248,29 +248,6 @@ int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest,
 }
 EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpstate);
 
-void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask)
-{
-	fpregs_lock();
-
-	if (save) {
-		struct fpstate *fpcur = current->thread.fpu.fpstate;
-
-		if (test_thread_flag(TIF_NEED_FPU_LOAD))
-			memcpy(&save->fpstate->regs, &fpcur->regs, fpcur->size);
-		else
-			save_fpregs_to_fpstate(save);
-	}
-
-	if (rstor) {
-		restore_mask &= XFEATURE_MASK_FPSTATE;
-		restore_fpregs_from_fpstate(rstor->fpstate, restore_mask);
-	}
-
-	fpregs_mark_activate();
-	fpregs_unlock();
-}
-EXPORT_SYMBOL_GPL(fpu_swap_kvm_fpu);
-
 void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf,
 				    unsigned int size, u32 pkru)
 {
@@ -440,15 +417,6 @@ void fpstate_reset(struct fpu *fpu)
 	__fpstate_reset(fpu->fpstate);
 }
 
-#if IS_ENABLED(CONFIG_KVM)
-void fpu_init_fpstate_user(struct fpu *fpu)
-{
-	fpstate_reset(fpu);
-	fpstate_init_user(fpu->fpstate);
-}
-EXPORT_SYMBOL_GPL(fpu_init_fpstate_user);
-#endif
-
 /* Clone current's FPU state on fork */
 int fpu_clone(struct task_struct *dst)
 {

