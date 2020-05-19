Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACD81DA341
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 23:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgESVNa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 17:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727803AbgESVNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 17:13:30 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF26C08C5C0;
        Tue, 19 May 2020 14:13:29 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jb9Y4-0001wu-6B; Tue, 19 May 2020 23:13:16 +0200
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id B14A2100D00;
        Tue, 19 May 2020 23:13:15 +0200 (CEST)
Message-Id: <20200519211224.286191418@linutronix.de>
User-Agent: quilt/0.65
Date:   Tue, 19 May 2020 22:31:29 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [patch 1/7] x86/kvm: Move context tracking where it belongs
References: <20200519203128.773151484@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Context tracking for KVM happens way too early in the vcpu_run()
code. Anything after guest_enter_irqoff() and before guest_exit_irqoff()
cannot use RCU and should also be not instrumented.

The current way of doing this covers way too much code. Move it closer to
the actual vmenter/exit code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lkml.kernel.org/r/20200505134341.379326289@linutronix.de


diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4e9cd2a73ad0..40242e0af20d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3389,6 +3389,14 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
+	/*
+	 * Tell context tracking that this CPU is about to enter guest
+	 * mode. This has to be after x86_spec_ctrl_set_guest() because
+	 * that can take locks (lockdep needs RCU) and calls into world and
+	 * some more.
+	 */
+	guest_enter_irqoff();
+
 	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
 #ifdef CONFIG_X86_64
@@ -3399,6 +3407,14 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	loadsegment(gs, svm->host.gs);
 #endif
 #endif
+	/*
+	 * Tell context tracking that this CPU is back.
+	 *
+	 * This needs to be done before the below as native_read_msr()
+	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
+	 * into world and some more.
+	 */
+	guest_exit_irqoff();
 
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6a03c27ff314..ad0159f68ce4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6724,6 +6724,11 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
 
+	/*
+	 * Tell context tracking that this CPU is about to enter guest mode.
+	 */
+	guest_enter_irqoff();
+
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
@@ -6739,6 +6744,11 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr2 = read_cr2();
 
 	/*
+	 * Tell context tracking that this CPU is back.
+	 */
+	guest_exit_irqoff();
+
+	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
 	 * SPEC_CTRL MSR it may have left it on; save the value and
 	 * turn it off. This is much more efficient than blindly adding
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 471fccf7f850..28663a6688d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8438,7 +8438,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	}
 
 	trace_kvm_entry(vcpu->vcpu_id);
-	guest_enter_irqoff();
 
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
@@ -8500,7 +8499,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
 
-	guest_exit_irqoff();
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
 		if (delta != S64_MIN) {

