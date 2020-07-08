Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5F62190FD
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgGHTxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgGHTxk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:53:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821D9C061A0B;
        Wed,  8 Jul 2020 12:53:40 -0700 (PDT)
Message-Id: <20200708195321.724574345@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594238018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=cW72dPqtZuMh9vmtb+qgVOPPO4Xy97uOj4LUQgr9ay8=;
        b=ZWD4T0pPums1mWXn/Y1A2+KqF94bKL9jeD+LHsCT4ub01yuZQDDT25AFDF7i28Uig4bwV+
        bGaehYaMcAyDu7Jz6T3ANHfylRF86QlDFvzzr+OaiqbARirhAxvn2L60UJALnIhKPLzTK3
        dFSQryKIEQfKHLfUiYzphiHPFKZRa/+gj0RwkvUqykcAotS4XXiAFOjO+OpZdW5IMwVFlt
        KjaRQBu8gRdWqRBJMcb+ORAUyAq+T4PFcJ06qYKZ/wuAgESiKIGrCl/6NDqcC+gnSkHFO7
        sxL8DRWYvy7yKapZd09lg6CEOukrKFtzQkNN6OU4Ep298dWm+xeL9++cpXp5oQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594238018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=cW72dPqtZuMh9vmtb+qgVOPPO4Xy97uOj4LUQgr9ay8=;
        b=L2TJL1vZnF4cYPM/JhiZopc7KpQpgFxAUZlosxop8UxF8/nKKyUwDsR1A4ahInKiSsOj1C
        lyWDtQufAablizBw==
Date:   Wed, 08 Jul 2020 21:51:54 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>
Subject: [patch V2 1/7] x86/kvm: Move context tracking where it belongs
References: <20200708195153.746357686@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Context tracking for KVM happens way too early in the vcpu_run()
code. Anything after guest_enter_irqoff() and before guest_exit_irqoff()
cannot use RCU and should also be not instrumented.

The current way of doing this covers way too much code. Move it closer to
the actual vmenter/exit code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/svm.c |   16 ++++++++++++++++
 arch/x86/kvm/vmx/vmx.c |   10 ++++++++++
 arch/x86/kvm/x86.c     |    2 --
 3 files changed, 26 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3399,6 +3399,14 @@ static __no_kcsan fastpath_t svm_vcpu_ru
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
@@ -3409,6 +3417,14 @@ static __no_kcsan fastpath_t svm_vcpu_ru
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
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6728,6 +6728,11 @@ static fastpath_t vmx_vcpu_run(struct kv
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
@@ -6743,6 +6748,11 @@ static fastpath_t vmx_vcpu_run(struct kv
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
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8501,7 +8501,6 @@ static int vcpu_enter_guest(struct kvm_v
 	}
 
 	trace_kvm_entry(vcpu->vcpu_id);
-	guest_enter_irqoff();
 
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
@@ -8563,7 +8562,6 @@ static int vcpu_enter_guest(struct kvm_v
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
 
-	guest_exit_irqoff();
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
 		if (delta != S64_MIN) {

