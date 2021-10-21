Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8C3E436571
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 17:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhJUPPD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 11:15:03 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60850 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbhJUPOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 11:14:53 -0400
Date:   Thu, 21 Oct 2021 15:12:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634829156;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mje5Bm/3VaABR7MUBx0dHJl9N7C6id4Wum76l//uCPY=;
        b=Fe1O4JrbKBdYlys1Gn6goFArM+bOL6OnT4Hl5rv5wtrbHFYq+zmw5UTJdK4xC8MLON1GZi
        VsEbz60zKNrHBI4PydaP5x1FHvDYS6aAmgR3O5cSuUKzPyajj91Obkr6Iwhjd1b1geDOj7
        Gvq/v3sd4JDXBPFUF2y2jYZuTCQseUXdUWtI/SCKvLUZ8uonCnp29hIny/TeBuU2+cV1fi
        rj+QIO2QMTtC4yS83iqdKenxhAzZM3AT2Hn7gjwdris6F1Bp12faayVOM5NiW2CtfAXqpB
        5cxBmM2KQrm1phTBceUjkrR+GWf6HY3q8yDcLhZPUWYasZ3FUQEt6hyLLpyRXQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634829156;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mje5Bm/3VaABR7MUBx0dHJl9N7C6id4Wum76l//uCPY=;
        b=Yo9H0S7Kee0tnUVkbQtqv7ARGnpxcDQCmt4NLSC9szDxsvinlCzDZHpe2wBcsmkhiSyncn
        jFPG2ux7k0dPpiCg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/fpu] x86/fpu: Replace KVMs xstate component clearing
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211013145322.399567049@linutronix.de>
References: <20211013145322.399567049@linutronix.de>
MIME-Version: 1.0
Message-ID: <163482915547.25758.12156220669471444460.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following commit has been merged into the x86/fpu branch of tip:

Commit-ID:     087df48c298c1cb829f4cd468d90f93234b1bc44
Gitweb:        https://git.kernel.org/tip/087df48c298c1cb829f4cd468d90f93234b1bc44
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Wed, 13 Oct 2021 16:55:31 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 20 Oct 2021 22:26:41 +02:00

x86/fpu: Replace KVMs xstate component clearing

In order to prepare for the support of dynamically enabled FPU features,
move the clearing of xstate components to the FPU core code.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: kvm@vger.kernel.org
Link: https://lkml.kernel.org/r/20211013145322.399567049@linutronix.de
---
 arch/x86/include/asm/fpu/api.h    |  1 +
 arch/x86/include/asm/fpu/xstate.h |  1 -
 arch/x86/kernel/fpu/xstate.c      | 12 +++++++++++-
 arch/x86/kernel/fpu/xstate.h      |  2 ++
 arch/x86/kvm/x86.c                | 14 +++++---------
 5 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index 5ac5e45..a97cf3e 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -132,6 +132,7 @@ DECLARE_PER_CPU(struct fpu *, fpu_fpregs_owner_ctx);
 
 /* fpstate-related functions which are exported to KVM */
 extern void fpu_init_fpstate_user(struct fpu *fpu);
+extern void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfeature);
 
 /* KVM specific functions */
 extern void fpu_swap_kvm_fpu(struct fpu *save, struct fpu *rstor, u64 restore_mask);
diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
index b8cebc0..fb329bb 100644
--- a/arch/x86/include/asm/fpu/xstate.h
+++ b/arch/x86/include/asm/fpu/xstate.h
@@ -128,7 +128,6 @@ extern u64 xstate_fx_sw_bytes[USER_XSTATE_FX_SW_WORDS];
 extern void __init update_regset_xstate_info(unsigned int size,
 					     u64 xstate_mask);
 
-void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
 int xfeature_size(int xfeature_nr);
 int copy_uabi_from_kernel_to_xstate(struct xregs_state *xsave, const void *kbuf);
 int copy_sigframe_from_user_to_xstate(struct xregs_state *xsave, const void __user *ubuf);
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 937ad5b..b1409a7 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -908,7 +908,6 @@ void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
 
 	return __raw_xsave_addr(xsave, xfeature_nr);
 }
-EXPORT_SYMBOL_GPL(get_xsave_addr);
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
 
@@ -1257,6 +1256,17 @@ void xrstors(struct xregs_state *xstate, u64 mask)
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
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index bb6d7d2..99f8cfe 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -21,6 +21,8 @@ extern void __copy_xstate_to_uabi_buf(struct membuf to, struct xregs_state *xsav
 extern void fpu__init_cpu_xstate(void);
 extern void fpu__init_system_xstate(void);
 
+extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
+
 /* XSAVE/XRSTOR wrapper functions */
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a18d467..96936a2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10705,7 +10705,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.apf.halted = false;
 
 	if (vcpu->arch.guest_fpu && kvm_mpx_supported()) {
-		void *mpx_state_buffer;
+		struct fpstate *fpstate = vcpu->arch.guest_fpu->fpstate;
 
 		/*
 		 * To avoid have the INIT path from kvm_apic_has_events() that be
@@ -10713,14 +10713,10 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
