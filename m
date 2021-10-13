Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938ED42C417
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237612AbhJMO5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:57:39 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35376 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237434AbhJMO5g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:57:36 -0400
Message-ID: <20211013145322.399567049@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634136932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=VN+bgfPvy8oG5qDv8nOVEMCkG7ge3h/lsMiht5xt0Hw=;
        b=O6aawK5zxskGtEhvkytuk64xaOvFNsCAuuQ+cj12RGZ/KB1gK+WdgdoCdb7zIWbib2Xsu/
        ZaWzTQ3PiA1cKE5cuMN42WYFryn4EcL/yM/V2W4xKeR6qLWDQTLV6HYQ9pZ0mKz+6DwiWo
        VO0wFGWnofa50pi/l2ob4j+xHaIH58kFyRimuPxMvjz0xkdA+6O3oRjoe/iVlk1w1U/c/G
        AbhgRKjUP3yA7oRr3OR7YmePkHtz2kFLMNU+POwrceldlPMRN/+eOZIAIOuDSThKixx3HM
        v3iG8N3Q9gEqwgcU3BjMyB4Nlaz1g8yGzYargz1D1VoW53VqW6XKnL5NJnCvbw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634136932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=VN+bgfPvy8oG5qDv8nOVEMCkG7ge3h/lsMiht5xt0Hw=;
        b=8b3N9rtSY9jtD5G70VV1iTRbjTB+kwuICXj5oMUbg6RqFFUYqWAvvUtcM/kMM4aS79VAAe
        TqkcCAvR9gpkdrDQ==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 04/21] x86/fpu: Replace KVMs xstate component clearing
References: <20211013142847.120153383@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 13 Oct 2021 16:55:31 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to prepare for the support of dynamically enabled FPU features,
move the clearing of xstate components to the FPU core code.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
 arch/x86/include/asm/fpu/api.h    |    1 +
 arch/x86/include/asm/fpu/xstate.h |    1 -
 arch/x86/kernel/fpu/xstate.c      |   12 +++++++++++-
 arch/x86/kernel/fpu/xstate.h      |    2 ++
 arch/x86/kvm/x86.c                |   14 +++++---------
 5 files changed, 19 insertions(+), 11 deletions(-)

--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -132,6 +132,7 @@ DECLARE_PER_CPU(struct fpu *, fpu_fpregs
 
 /* fpstate-related functions which are exported to KVM */
 extern void fpu_init_fpstate_user(struct fpu *fpu);
+extern void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature);
 
 /* KVM specific functions */
 extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -128,7 +128,6 @@ extern u64 xstate_fx_sw_bytes[USER_XSTAT
 extern void __init update_regset_xstate_info(unsigned int size,
 					     u64 xstate_mask);
 
-void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
 int xfeature_size(int xfeature_nr);
 int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf);
 int copy_sigframe_from_user_to_xstate(struct xregs_state *xsave, const void __user *ubuf);
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -908,7 +908,6 @@ void *get_xsave_addr(struct xregs_state
 
 	return __raw_xsave_addr(xsave, xfeature_nr);
 }
-EXPORT_SYMBOL_GPL(get_xsave_addr);
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
 
@@ -1257,6 +1256,17 @@ void xrstors(struct xregs_state *xstate,
 	WARN_ON_ONCE(err);
 }
 
+#if IS_ENABLED(CONFIG_KVM)
+void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature)
+{
+	void *addr = get_xsave_addr(&fps->regs.xsave, xfeature);
+
+	if (addr)
+		memset(addr, 0, xstate_sizes[xfeature]);
+}
+EXPORT_SYMBOL_GPL(fpstate_clear_xstate_component);
+#endif
+
 #ifdef CONFIG_PROC_PID_ARCH_STATUS
 /*
  * Report the amount of time elapsed in millisecond since last AVX512
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -21,6 +21,8 @@ extern void __copy_xstate_to_uabi_buf(st
 extern void fpu__init_cpu_xstate(void);
 extern void fpu__init_system_xstate(void);
 
+extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
+
 /* XSAVE/XRSTOR wrapper functions */
 
 #ifdef CONFIG_X86_64
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10689,7 +10689,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcp
 	vcpu->arch.apf.halted = false;
 
 	if (vcpu->arch.guest_fpu && kvm_mpx_supported()) {
-		void *mpx_state_buffer;
+		struct fpstate *fpstate = vcpu->arch.guest_fpu->fpstate;
 
 		/*
 		 * To avoid have the INIT path from kvm_apic_has_events() that be
@@ -10697,14 +10697,10 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcp
 		 */
 		if (init_event)
 			kvm_put_guest_fpu(vcpu);
-		mpx_state_buffer = get_xsave_addr(&vcpu->arch.guest_fpu->state.xsave,
-					XFEATURE_BNDREGS);
-		if (mpx_state_buffer)
-			memset(mpx_state_buffer, 0, sizeof(struct mpx_bndreg_state));
-		mpx_state_buffer = get_xsave_addr(&vcpu->arch.guest_fpu->state.xsave,
-					XFEATURE_BNDCSR);
-		if (mpx_state_buffer)
-			memset(mpx_state_buffer, 0, sizeof(struct mpx_bndcsr));
+
+		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDREGS);
+		fpstate_clear_xstate_component(fpstate, XFEATURE_BNDCSR);
+
 		if (init_event)
 			kvm_load_guest_fpu(vcpu);
 	}

