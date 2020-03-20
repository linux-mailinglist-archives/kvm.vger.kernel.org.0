Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5D518DADE
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbgCTWGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:06:01 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37472 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgCTWEN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:13 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPk9-0004d8-QA; Fri, 20 Mar 2020 23:03:53 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 1AAE61040C9;
        Fri, 20 Mar 2020 23:03:49 +0100 (CET)
Message-Id: <20200320180034.203489576@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:14 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paul McKenney <paulmck@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RESEND][patch V3 18/23] x86/kvm: Move context tracking where it belongs
References: <20200320175956.033706968@linutronix.de>
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

The invocation of guest_enter_irqoff() is way before the actual VMENTER
happens. guest_exit_irqoff() happens way after the VMEXIT.

While the comment in guest_enter_irqoff() says that KVM does not hold
references to RCU protected data, for the whole call chain before VMENTER
and after VMEXIT there is no guarantee that no RCU protected data is
accessed.

There are tracepoints hidden in MSR access functions and there are calls
into code which takes locks. The latter might cause lockdep to run into RCU
trouble. As the call chains are hard to follow it's unclear whether there
might be RCU trouble lurking in some corner cases.

The VMENTER path after context tracking contains also exit conditions which
abort the VMENTER. The VMEXIT return path reenables interrupts before
switching RCU back on which means that the interrupt entry/exit has to
switch in on and then off again. If tracepoints on local_irq_enable() and
local_irqdisable() are enabled then two more RCU on/off transitions are
happening.

Move it down into the VMX/SVM code close to the actual entry/exit. This is
the first step to bring parts of this code into the .noinstr.text section
so it can be verified with objtool.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
 arch/x86/kvm/svm.c     |   18 ++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c |   10 ++++++++++
 arch/x86/kvm/x86.c     |    2 --
 3 files changed, 28 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5766,6 +5766,15 @@ static void svm_vcpu_run(struct kvm_vcpu
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
+	/* This is wrong vs. lockdep. Will be fixed in the next step */
 	local_irq_enable();
 
 	asm volatile (
@@ -5869,6 +5878,14 @@ static void svm_vcpu_run(struct kvm_vcpu
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
@@ -5890,6 +5907,7 @@ static void svm_vcpu_run(struct kvm_vcpu
 
 	reload_tss(vcpu);
 
+	/* This is wrong vs. lockdep. Will be fixed in the next step */
 	local_irq_disable();
 
 	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6537,6 +6537,11 @@ static void vmx_vcpu_run(struct kvm_vcpu
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
@@ -6552,6 +6557,11 @@ static void vmx_vcpu_run(struct kvm_vcpu
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
@@ -8350,7 +8350,6 @@ static int vcpu_enter_guest(struct kvm_v
 	}
 
 	trace_kvm_entry(vcpu->vcpu_id);
-	guest_enter_irqoff();
 
 	fpregs_assert_state_consistent();
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
@@ -8413,7 +8412,6 @@ static int vcpu_enter_guest(struct kvm_v
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
 
-	guest_exit_irqoff();
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
 		if (delta != S64_MIN) {

