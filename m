Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132A9219109
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726356AbgGHTxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:53:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53434 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgGHTxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:53:42 -0400
Message-Id: <20200708195321.822002354@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594238019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=O37pX8HCMturL+rhqBaE0iWzy5y3hehqvpiNhW/ZQz0=;
        b=spuQzcY+mFKo78t/CNljjZWO5/ivf9wUU/Lav18NYybvdo1ZlU1x74CJhp0Z9stGohgc9M
        rBK4Et5MlndlRoHO8o4o66Y0alJgqJjvbCAsMkEGLcMlRkxKqL7HrlBcgOuhBVvVeguR3+
        13oHqGkIsFyxHCa1tM62mzj3x4NLisLVfv8ZD9GTCBvdo0Lz4xVBp93ZlkFYJCYo9y/EO+
        BYZB12YSjiwx5pp/AZfX2snSzDGZFQSVCi54vcabFeuBBaRdudlH7S6CMS6imDbdSXU8eF
        MTp6lcP6JHpq1VIBHaQZPqgrvMyUZudXDaud0zji0JsomwEcB3JZTuFxQMv8GQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594238019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=O37pX8HCMturL+rhqBaE0iWzy5y3hehqvpiNhW/ZQz0=;
        b=SawKJOaJBHxztqPVVNApI0Gorktq1IGQCGry/58TZQK/L5PprosVYw6t6YjgBlG/3eVGJb
        M/8yr3e0XhW4MKBA==
Date:   Wed, 08 Jul 2020 21:51:55 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>
Subject: [patch V2 2/7] x86/kvm/vmx: Add hardirq tracing to guest enter/exit
References: <20200708195153.746357686@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

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



---
 arch/x86/kvm/vmx/vmx.c |   27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6729,9 +6729,21 @@ static fastpath_t vmx_vcpu_run(struct kv
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
 
 	/*
-	 * Tell context tracking that this CPU is about to enter guest mode.
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
 
 	/* L1D Flush includes CPU buffer clear to mitigate MDS */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
@@ -6748,9 +6760,20 @@ static fastpath_t vmx_vcpu_run(struct kv
 	vcpu->arch.cr2 = read_cr2();
 
 	/*
-	 * Tell context tracking that this CPU is back.
+	 * VMEXIT disables interrupts (host state), but tracing and lockdep
+	 * have them in state 'on' as recorded before entering guest mode.
+	 * Same as enter_from_user_mode().
+	 *
+	 * guest_exit_irqoff() restores host context and reinstates RCU if
+	 * enabled and required.
+	 *
+	 * This needs to be done before the below as native_read_msr()
+	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
+	 * into world and some more.
 	 */
+	lockdep_hardirqs_off(CALLER_ADDR0);
 	guest_exit_irqoff();
+	trace_hardirqs_off_finish();
 
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the

