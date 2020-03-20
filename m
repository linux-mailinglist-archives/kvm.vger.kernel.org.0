Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A944618DABB
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbgCTWEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:04:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37516 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbgCTWEY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:24 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPkA-0004eT-UU; Fri, 20 Mar 2020 23:03:55 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 9282D1040CC;
        Fri, 20 Mar 2020 23:03:49 +0100 (CET)
Message-Id: <20200320180034.391111270@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:16 +0100
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
Subject: [RESEND][patch V3 20/23] x86/kvm/svm: Handle hardirqs proper on guest
 enter/exit
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

SVM hard interrupt disabled state handling is interesting. It disables
interrupts via CLGI and then invokes local_irq_enable(). This is done after
context tracking. local_irq_enable() can call into the tracer and lockdep
which requires to turn RCU on and off.

Replace it with the scheme which is used when exiting to user mode which
handles tracing and the preparatory lockdep step before context tracking
and the final lockdep step afterwards. Enable interrupts with a plain STI
in the assembly code instead. 

Do the reverse operation when coming out of guest mode.

This allows to move the actual entry code into the .noinstr.text section
and verify correctness with objtool.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
 arch/x86/kvm/svm.c |   40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5767,17 +5767,26 @@ static void svm_vcpu_run(struct kvm_vcpu
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	/*
-	 * Tell context tracking that this CPU is about to enter guest
-	 * mode. This has to be after x86_spec_ctrl_set_guest() because
-	 * that can take locks (lockdep needs RCU) and calls into world and
-	 * some more.
+	 * VMENTER enables interrupts (host state), but the kernel state is
+	 * interrupts disabled when this is invoked. Also tell RCU about
+	 * it. This is the same logic as for exit_to_user_mode().
+	 *
+	 * 1) Trace interrupts on state
+	 * 2) Prepare lockdep with RCU on
+	 * 3) Invoke context tracking if enabled to adjust RCU state
+	 * 4) Tell lockdep that interrupts are enabled
+	 *
+	 * This has to be after x86_spec_ctrl_set_guest() because that can
+	 * take locks (lockdep needs RCU) and calls into world and some
+	 * more.
 	 */
+	__trace_hardirqs_on();
+	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
 	guest_enter_irqoff();
-
-	/* This is wrong vs. lockdep. Will be fixed in the next step */
-	local_irq_enable();
+	lockdep_hardirqs_on(CALLER_ADDR0);
 
 	asm volatile (
+		"sti \n\t"
 		"push %%" _ASM_BP "; \n\t"
 		"mov %c[rbx](%[svm]), %%" _ASM_BX " \n\t"
 		"mov %c[rcx](%[svm]), %%" _ASM_CX " \n\t"
@@ -5838,7 +5847,8 @@ static void svm_vcpu_run(struct kvm_vcpu
 		"xor %%edx, %%edx \n\t"
 		"xor %%esi, %%esi \n\t"
 		"xor %%edi, %%edi \n\t"
-		"pop %%" _ASM_BP
+		"pop %%" _ASM_BP "\n\t"
+		"cli \n\t"
 		:
 		: [svm]"a"(svm),
 		  [vmcb]"i"(offsetof(struct vcpu_svm, vmcb_pa)),
@@ -5878,14 +5888,23 @@ static void svm_vcpu_run(struct kvm_vcpu
 	loadsegment(gs, svm->host.gs);
 #endif
 #endif
+
 	/*
-	 * Tell context tracking that this CPU is back.
+	 * VMEXIT disables interrupts (host state, see the CLI in the ASM
+	 * above), but tracing and lockdep have them in state 'on'. Same as
+	 * enter_from_user_mode().
+	 *
+	 * 1) Tell lockdep that interrupts are disabled
+	 * 2) Invoke context tracking if enabled to reactivate RCU
+	 * 3) Trace interrupts off state
 	 *
 	 * This needs to be done before the below as native_read_msr()
 	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
 	 * into world and some more.
 	 */
+	lockdep_hardirqs_off(CALLER_ADDR0);
 	guest_exit_irqoff();
+	__trace_hardirqs_off();
 
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
@@ -5907,9 +5926,6 @@ static void svm_vcpu_run(struct kvm_vcpu
 
 	reload_tss(vcpu);
 
-	/* This is wrong vs. lockdep. Will be fixed in the next step */
-	local_irq_disable();
-
 	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	vcpu->arch.cr2 = svm->vmcb->save.cr2;

