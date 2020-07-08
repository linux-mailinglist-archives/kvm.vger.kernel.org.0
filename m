Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAF721910A
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgGHTyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgGHTxo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 15:53:44 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99B4C061A0B;
        Wed,  8 Jul 2020 12:53:43 -0700 (PDT)
Message-Id: <20200708195322.037311579@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594238022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=L8WFl/qe3bcU20FmleRqAp3Ck6NxoIyNeaRZ5GSxwe4=;
        b=XfStOCYTMjEEcEia8QQfb1042hqloaB38lQS7WlsinhyyhUFIWoiZ9VhiLnLrdbeQte/7O
        hMu5HJ8mDj60YbebjR28RGJqvxFv/8tHs6RmLD5m09BmjfwjOJysLReSlEXIPSG7dQ1+/l
        WrCkyANpnrB0sdnDc/KRLYNrJrDMCzhjL1Oh7PVVIA9x+leep0JQvFH6ppkc7/YQxSCC3I
        LYOSdCqbgNC2SNmaPlMhlw57uy7En5896yGzyEDdwFrefcm77bfXMDMYHmzk6RtS1Z65/A
        weabWqpMFEfUFXDJI1yHQLNb3XwEfQUA/25C8quJtCPRzN6j59PFgRGU0DByMQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594238022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=L8WFl/qe3bcU20FmleRqAp3Ck6NxoIyNeaRZ5GSxwe4=;
        b=BUkiJ1yYbCQkbC6EL40F2W8tcrxzg/88DJ8ZzOcJVRulQtEThm4BpQs9vw+eNiqtivIsGA
        y+n9Q9q+BIjdoTCw==
Date:   Wed, 08 Jul 2020 21:51:57 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>
Subject: [patch V2 4/7] x86/kvm/vmx: Move guest enter/exit into .noinstr.text
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
 arch/x86/include/asm/hardirq.h  |    4 -
 arch/x86/include/asm/kvm_host.h |    8 ++
 arch/x86/kvm/vmx/ops.h          |    4 +
 arch/x86/kvm/vmx/vmenter.S      |    5 +
 arch/x86/kvm/vmx/vmx.c          |  111 ++++++++++++++++++++++------------------
 arch/x86/kvm/x86.c              |    2 
 6 files changed, 81 insertions(+), 53 deletions(-)

--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -67,12 +67,12 @@ static inline void kvm_set_cpu_l1tf_flus
 	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
 }
 
-static inline void kvm_clear_cpu_l1tf_flush_l1d(void)
+static __always_inline void kvm_clear_cpu_l1tf_flush_l1d(void)
 {
 	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 0);
 }
 
-static inline bool kvm_get_cpu_l1tf_flush_l1d(void)
+static __always_inline bool kvm_get_cpu_l1tf_flush_l1d(void)
 {
 	return __this_cpu_read(irq_stat.kvm_cpu_l1tf_flush_l1d);
 }
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1636,7 +1636,15 @@ asmlinkage void kvm_spurious_fault(void)
 	insn "\n\t"							\
 	"jmp	668f \n\t"						\
 	"667: \n\t"							\
+	"1: \n\t"							\
+	".pushsection .discard.instr_begin \n\t"			\
+	".long 1b - . \n\t"						\
+	".popsection \n\t"						\
 	"call	kvm_spurious_fault \n\t"				\
+	"1: \n\t"							\
+	".pushsection .discard.instr_end \n\t"				\
+	".long 1b - . \n\t"						\
+	".popsection \n\t"						\
 	"668: \n\t"							\
 	_ASM_EXTABLE(666b, 667b)
 
--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -146,7 +146,9 @@ do {									\
 			  : : op1 : "cc" : error, fault);		\
 	return;								\
 error:									\
+	instrumentation_begin();					\
 	insn##_error(error_args);					\
+	instrumentation_end();						\
 	return;								\
 fault:									\
 	kvm_spurious_fault();						\
@@ -161,7 +163,9 @@ do {									\
 			  : : op1, op2 : "cc" : error, fault);		\
 	return;								\
 error:									\
+	instrumentation_begin();					\
 	insn##_error(error_args);					\
+	instrumentation_end();						\
 	return;								\
 fault:									\
 	kvm_spurious_fault();						\
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -27,7 +27,7 @@
 #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
 #endif
 
-	.text
+.section .noinstr.text, "ax"
 
 /**
  * vmx_vmenter - VM-Enter the current loaded VMCS
@@ -234,6 +234,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	jmp 1b
 SYM_FUNC_END(__vmx_vcpu_run)
 
+
+.section .text, "ax"
+
 /**
  * vmread_error_trampoline - Trampoline from inline asm to vmread_error()
  * @field:	VMCS field encoding that failed
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6113,7 +6113,7 @@ static int vmx_handle_exit(struct kvm_vc
  * information but as all relevant affected CPUs have 32KiB L1D cache size
  * there is no point in doing so.
  */
-static void vmx_l1d_flush(struct kvm_vcpu *vcpu)
+static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 {
 	int size = PAGE_SIZE << L1D_CACHE_ORDER;
 
@@ -6146,7 +6146,7 @@ static void vmx_l1d_flush(struct kvm_vcp
 	vcpu->stat.l1d_flush++;
 
 	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
-		wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
+		native_wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
 		return;
 	}
 
@@ -6632,7 +6632,7 @@ static void vmx_update_hv_timer(struct k
 	}
 }
 
-void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
+void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 {
 	if (unlikely(host_rsp != vmx->loaded_vmcs->host_state.rsp)) {
 		vmx->loaded_vmcs->host_state.rsp = host_rsp;
@@ -6654,6 +6654,63 @@ static fastpath_t vmx_exit_handlers_fast
 
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
+static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
+					struct vcpu_vmx *vmx)
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
+	/* L1D Flush includes CPU buffer clear to mitigate MDS */
+	if (static_branch_unlikely(&vmx_l1d_should_flush))
+		vmx_l1d_flush(vcpu);
+	else if (static_branch_unlikely(&mds_user_clear))
+		mds_clear_cpu_buffers();
+
+	if (vcpu->arch.cr2 != read_cr2())
+		write_cr2(vcpu->arch.cr2);
+
+	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
+				   vmx->loaded_vmcs->launched);
+
+	vcpu->arch.cr2 = read_cr2();
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
 static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	fastpath_t exit_fastpath;
@@ -6728,52 +6785,8 @@ static fastpath_t vmx_vcpu_run(struct kv
 	 */
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
 
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
-	/* L1D Flush includes CPU buffer clear to mitigate MDS */
-	if (static_branch_unlikely(&vmx_l1d_should_flush))
-		vmx_l1d_flush(vcpu);
-	else if (static_branch_unlikely(&mds_user_clear))
-		mds_clear_cpu_buffers();
-
-	if (vcpu->arch.cr2 != read_cr2())
-		write_cr2(vcpu->arch.cr2);
-
-	vmx->fail = __vmx_vcpu_run(vmx, (unsigned long *)&vcpu->arch.regs,
-				   vmx->loaded_vmcs->launched);
-
-	vcpu->arch.cr2 = read_cr2();
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
+	/* The actual VMENTER/EXIT is in the .noinstr.text section. */
+	vmx_vcpu_enter_exit(vcpu, vmx);
 
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -379,7 +379,7 @@ int kvm_set_apic_base(struct kvm_vcpu *v
 }
 EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
-asmlinkage __visible void kvm_spurious_fault(void)
+asmlinkage __visible noinstr void kvm_spurious_fault(void)
 {
 	/* Fault while not rebooting.  We want the trace. */
 	BUG_ON(!kvm_rebooting);

