Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C01EC437CCD
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 20:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbhJVS6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 14:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbhJVS6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 14:58:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04A0C061764;
        Fri, 22 Oct 2021 11:55:51 -0700 (PDT)
Message-ID: <20211022185312.896403942@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634928950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=htssBdQUYBVwaYBGDYdhnsAarY+zPvx6OtXbFv+POrs=;
        b=IFieWsjZyEpNUblkBsaaSP2KMpzDclpQroFaC1DnH75V6tDWeOdgHSp1lw4N6I6oHqbWoa
        meEA71u5+34FPi7n+OKfyCvY1GGluzgnfSbX+ty9gbR3tOrvS5it62/jmyadohhQLI3CYH
        cO84HwNdWTEhhAD7cvyjD5bbErAOtg/d0mCytc5sRHXmS4+AhgrhwG5dCzuMtzFJHZgrje
        JA0oe/4ZTyJi2rIzni2xOX35WOUctpjkPMv+x/HKEnPT1/2xL+qoRnE6La86CTQCoX5t/e
        g9n1pePpjoOjx3A5QosyCmbummmqN/xgLq/QdFkHUJ3CpzRemxYJ29+1KGAfUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634928950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=htssBdQUYBVwaYBGDYdhnsAarY+zPvx6OtXbFv+POrs=;
        b=8GknkpgIMk8a5vVhBqWKYmObv6T/BEEm2nZ18QguXDkKsgffKxYtxIpkKKAZvboz4+DbIr
        3+F8gWJbTb9AY3Bg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, "Nakajima, Jun" <jun.nakajima@intel.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [patch V2 1/4] x86/fpu: Prepare for sanitizing KVM FPU code
References: <20211022184540.581350173@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 22 Oct 2021 20:55:49 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the upcoming AMX support it's necessary to do a proper integration with
KVM. To avoid more nasty hackery in KVM which violate encapsulation extend
struct fpu and fpstate so the fpstate switching can be consolidated and
simplified.

Currently KVM allocates two FPU structs which are used for saving the user
state of the vCPU thread and restoring the guest state when entering
vcpu_run() and doing the reverse operation before leaving vcpu_run().

With the new fpstate mechanism this can be reduced to one extra buffer by
swapping the fpstate pointer in current::thread::fpu. This makes the
upcoming support for AMX and XFD simpler because then fpstate information
(features, sizes, xfd) are always consistent and it does not require any
nasty workarounds.

Add fpu::__task_fpstate to save the regular fpstate pointer while the task
is inside vcpu_run(). Add some state fields to fpstate to indicate the
nature of the state.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/types.h | 44 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)
---
diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index b0cf6b75e467..81a01de1fec2 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -322,8 +322,32 @@ struct fpstate {
 	/* @user_xfeatures:	xfeatures valid in UABI buffers */
 	u64			user_xfeatures;
 
+	/* @is_valloc:		Indicator for dynamically allocated state */
+	unsigned int		is_valloc	: 1;
+
+	/* @is_guest:		Indicator for guest state (KVM) */
+	unsigned int		is_guest	: 1;
+
+	/*
+	 * @is_confidential:	Indicator for KVM confidential mode.
+	 *			The FPU registers are restored by the
+	 *			vmentry firmware from encrypted guest
+	 *			memory. On vmexit the FPU registers are
+	 *			saved by firmware to encrypted guest memory
+	 *			and the registers are scrubbed before
+	 *			returning to the host. So there is no
+	 *			content which is worth saving and restoring
+	 *			The fpstate has to be there so that
+	 *			preemption and softirq FPU usage works.
+	 *			without special casing.
+	 */
+	unsigned int		is_confidential	: 1;
+
+	/* @in_use:		State is in use */
+	unsigned int		in_use		: 1;
+
 	/* @regs: The register state union for all supported formats */
-	union fpregs_state		regs;
+	union fpregs_state	regs;
 
 	/* @regs is dynamically sized! Don't add anything after @regs! */
 } __attribute__ ((aligned (64)));
@@ -364,6 +388,14 @@ struct fpu {
 	struct fpstate			*fpstate;
 
 	/*
+	 * @__task_fpstate:
+	 *
+	 * Pointer to an inactive struct fpstate. Initialized to NULL. Is
+	 * used only for KVM support to swap out the regular task fpstate.
+	 */
+	struct fpstate			*__task_fpstate;
+
+	/*
 	 * @__fpstate:
 	 *
 	 * Initial in-memory storage for FPU registers which are saved in
@@ -379,6 +411,16 @@ struct fpu {
 };
 
 /*
+ * Guest pseudo FPU container
+ */
+struct fpu_guest {
+	/*
+	 * @fpstate:			Pointer to the allocated guest fpstate
+	 */
+	struct fpstate			*fpstate;
+};
+
+/*
  * FPU state configuration data. Initialized at boot time. Read only after init.
  */
 struct fpu_state_config {

