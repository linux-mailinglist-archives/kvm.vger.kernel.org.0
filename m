Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2B52190FC
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgGHTxn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbgGHTxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:53:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70798C08C5C1;
        Wed,  8 Jul 2020 12:53:42 -0700 (PDT)
Message-Id: <20200708195321.934715094@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594238021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=Q/0rxpdoDSIfJysNnP2MHVMd9KS2WUtgcO1VSsks6s0=;
        b=BUEasXMHi1inxAAg7UdnSdkB+/oZxDC4PTmqfPEP5LXAP39tqZM2OT0iQiDS37YEF95xe4
        8eXy5vpXI3rDWY9mVhohf5y0lUn4SNATtzfcLcfCNDRcTwvzIp7hKcCEyg/U1iaaZd5j9t
        PSDu4mQ1pXp6fVYplPR+g+uE/DMpWO0JcWyKYu2CYT+vIGf8VZNzv+wtVpKHy54RZMIaHh
        3B0CE2ouuFfR6veh8KWoEj/AoDl561E6rgoiJkKY/L++qsJdGY2Ie0wy072rMHoyMEAFQU
        0R7c00DzFP+zTIKvF75CFai3x19q3QpLOluEytyGWOqqItirENI0oRaa7Nb+4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594238021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=Q/0rxpdoDSIfJysNnP2MHVMd9KS2WUtgcO1VSsks6s0=;
        b=Dwo6IQCn5b8l/Ds8gc0rN7tVH3Vg2GJjbNAMjiJajjRyc+KgR5SIvXF+VZE30izfjoX+8A
        /mMEkm0JwV0M7LBA==
Date:   Wed, 08 Jul 2020 21:51:56 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>
Subject: [patch V2 3/7] x86/kvm/svm: Add hardirq tracing on guest enter/exit
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
 arch/x86/kvm/svm/svm.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3400,12 +3400,21 @@ static __no_kcsan fastpath_t svm_vcpu_ru
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
 
@@ -3417,14 +3426,22 @@ static __no_kcsan fastpath_t svm_vcpu_ru
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
+	trace_hardirqs_off_finish();
 
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the

