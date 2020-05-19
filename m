Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3431DA34A
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 23:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgESVN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 17:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgESVN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 17:13:28 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D14C08C5C1;
        Tue, 19 May 2020 14:13:28 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jb9Y6-0001xv-Jy; Tue, 19 May 2020 23:13:18 +0200
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 2BC6F100D00;
        Tue, 19 May 2020 23:13:18 +0200 (CEST)
Message-Id: <20200519211224.476627641@linutronix.de>
User-Agent: quilt/0.65
Date:   Tue, 19 May 2020 22:31:31 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [patch 3/7] x86/kvm/svm: Add hardirq tracing on guest enter/exit
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


Entering guest mode is more or less the same as returning to user
space. From an instrumentation point of view both leave kernel mode and the
transition to guest or user mode reenables interrupts on the host. In user
mode an interrupt is served directly and in guest mode it causes a VM exit
which then handles or reinjects the interrupt.

The transition from guest mode or user mode to kernel mode disables
interrupts, which needs to be recorded in instrumentation to set the
correct state again.

This is important for e.g. latency analysis because otherwise the execution
time in guest or user mode would be wrongly accounted as interrupt disabled
and could trigger false positives.

Add hardirq tracing to guest enter/exit functions in the same way as it
is done in the user mode enter/exit code, respecting the RCU requirements.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lkml.kernel.org/r/20200505134341.579034898@linutronix.de


diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 40242e0af20d..46d69567faab 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3390,12 +3390,21 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
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
+	 * This ensures that e.g. latency analysis on the host observes
+	 * guest mode as interrupt enabled.
+	 *
+	 * guest_enter_irqoff() informs context tracking about the
+	 * transition to guest mode and if enabled adjusts RCU state
+	 * accordingly.
 	 */
+	trace_hardirqs_on_prepare();
+	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
 	guest_enter_irqoff();
+	lockdep_hardirqs_on(CALLER_ADDR0);
 
 	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
 
@@ -3407,14 +3416,22 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	loadsegment(gs, svm->host.gs);
 #endif
 #endif
+
 	/*
-	 * Tell context tracking that this CPU is back.
+	 * VMEXIT disables interrupts (host state), but tracing and lockdep
+	 * have them in state 'on' as recorded before entering guest mode.
+	 * Same as enter_from_user_mode().
+	 *
+	 * guest_exit_irqoff() restores host context and reinstates RCU if
+	 * enabled and required.
 	 *
 	 * This needs to be done before the below as native_read_msr()
 	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
 	 * into world and some more.
 	 */
+	lockdep_hardirqs_off(CALLER_ADDR0);
 	guest_exit_irqoff();
+	trace_hardirqs_off_prepare();
 
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the

