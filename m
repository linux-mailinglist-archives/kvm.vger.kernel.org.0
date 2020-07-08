Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E58219105
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgGHTyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:54:02 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:53434 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgGHTxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:53:45 -0400
Message-Id: <20200708195322.144607767@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594238023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=4r8tutqjl6w8J75q+Hjv1+S3tRKSERjhTclsLZCy0sw=;
        b=cpqWCgTMofZ6udiA4LRNbZ3VbhOt5plHIcDLLwBzrm/+KEBjdVfT+4oOHEuOVetIJfzkX7
        vKxJjA6Mq0780PydLkh8rdXXdMFz/dkhCT1xlT/FhX504DOXGWVWd4463/+TXVQQZPrQV5
        kUAeHHHAL2GfUGFu2i4nl2Eo91fo1N6LI2UBB11y2Kdq1PWrspqka6O0rVctXWN8SJlwOd
        YVBD7VDMVTae2TOMPbM6ZSyZOoRIFNKHVLzVLPuLrEKCm7dMK9TR8PHqlzpggrAfSGA/eX
        B5wB9U9xekhztFonUTOi3IISoz0xlXz0GSdKtFksgznahyYZ/hwUJ16OC3P6Cw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594238023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=4r8tutqjl6w8J75q+Hjv1+S3tRKSERjhTclsLZCy0sw=;
        b=wevcbg9JkI2Sr6SA9i1E8X37rATyR35DdmbyIw6ELkvyrq1Ctxve/r+YSMhl39qa1cRTk0
        cILqi4070u9d+EDg==
Date:   Wed, 08 Jul 2020 21:51:58 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>
Subject: [patch V2 5/7] x86/kvm/svm: Move guest enter/exit into .noinstr.text
References: <20200708195153.746357686@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Move the functions which are inside the RCU off region into the
non-instrumentable text section.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>

---
 arch/x86/kvm/svm/svm.c     |   98 +++++++++++++++++++++++++--------------------
 arch/x86/kvm/svm/vmenter.S |    2 
 2 files changed, 56 insertions(+), 44 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3344,6 +3344,60 @@ static fastpath_t svm_exit_handlers_fast
 
 void __svm_vcpu_run(unsigned long vmcb_pa, unsigned long *regs);
 
+static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
+					struct vcpu_svm *svm)
+{
+	/*
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
+	 */
+	instrumentation_begin();
+	trace_hardirqs_on_prepare();
+	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	instrumentation_end();
+
+	guest_enter_irqoff();
+	lockdep_hardirqs_on(CALLER_ADDR0);
+
+	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
+
+#ifdef CONFIG_X86_64
+	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
+#else
+	loadsegment(fs, svm->host.fs);
+#ifndef CONFIG_X86_32_LAZY_GS
+	loadsegment(gs, svm->host.gs);
+#endif
+#endif
+
+	/*
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
+	 */
+	lockdep_hardirqs_off(CALLER_ADDR0);
+	guest_exit_irqoff();
+
+	instrumentation_begin();
+	trace_hardirqs_off_finish();
+	instrumentation_end();
+}
+
 static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	fastpath_t exit_fastpath;
@@ -3399,49 +3453,7 @@ static __no_kcsan fastpath_t svm_vcpu_ru
 	 */
 	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	/*
-	 * VMENTER enables interrupts (host state), but the kernel state is
-	 * interrupts disabled when this is invoked. Also tell RCU about
-	 * it. This is the same logic as for exit_to_user_mode().
-	 *
-	 * This ensures that e.g. latency analysis on the host observes
-	 * guest mode as interrupt enabled.
-	 *
-	 * guest_enter_irqoff() informs context tracking about the
-	 * transition to guest mode and if enabled adjusts RCU state
-	 * accordingly.
-	 */
-	trace_hardirqs_on_prepare();
-	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
-	guest_enter_irqoff();
-	lockdep_hardirqs_on(CALLER_ADDR0);
-
-	__svm_vcpu_run(svm->vmcb_pa, (unsigned long *)&svm->vcpu.arch.regs);
-
-#ifdef CONFIG_X86_64
-	wrmsrl(MSR_GS_BASE, svm->host.gs_base);
-#else
-	loadsegment(fs, svm->host.fs);
-#ifndef CONFIG_X86_32_LAZY_GS
-	loadsegment(gs, svm->host.gs);
-#endif
-#endif
-
-	/*
-	 * VMEXIT disables interrupts (host state), but tracing and lockdep
-	 * have them in state 'on' as recorded before entering guest mode.
-	 * Same as enter_from_user_mode().
-	 *
-	 * guest_exit_irqoff() restores host context and reinstates RCU if
-	 * enabled and required.
-	 *
-	 * This needs to be done before the below as native_read_msr()
-	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
-	 * into world and some more.
-	 */
-	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
-	trace_hardirqs_off_finish();
+	svm_vcpu_enter_exit(vcpu, svm);
 
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -27,7 +27,7 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
-	.text
+.section .noinstr.text, "ax"
 
 /**
  * __svm_vcpu_run - Run a vCPU via a transition to SVM guest mode

