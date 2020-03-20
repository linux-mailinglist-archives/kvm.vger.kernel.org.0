Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0047B18DAC5
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 23:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgCTWE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 18:04:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:37509 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727433AbgCTWET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 18:04:19 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jFPkF-0004fa-6o; Fri, 20 Mar 2020 23:03:59 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 17D611040CD;
        Fri, 20 Mar 2020 23:03:50 +0100 (CET)
Message-Id: <20200320180034.580811627@linutronix.de>
User-Agent: quilt/0.65
Date:   Fri, 20 Mar 2020 19:00:18 +0100
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
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RESEND][patch V3 22/23] x86/kvm/vmx: Move guest enter/exit into
 .noinstr.text
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

Split out the really last steps of guest enter and the early guest exit
code and mark it .noinstr.text along with the ASM code invoked from there.

The few functions which are invoked from there are either made
__always_inline or marked with noinstr which moves them into the
.noinstr.text section.

Use native_wrmsr() in the L1D flush code to prevent a tracepoint from being
inserted.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
---
 arch/x86/include/asm/hardirq.h  |    4 -
 arch/x86/include/asm/kvm_host.h |    8 +++
 arch/x86/kvm/vmx/ops.h          |    4 +
 arch/x86/kvm/vmx/vmenter.S      |    2 
 arch/x86/kvm/vmx/vmx.c          |  105 ++++++++++++++++++++++------------------
 arch/x86/kvm/x86.c              |    2 
 6 files changed, 76 insertions(+), 49 deletions(-)

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
--- a/arch/x86/kvm/vmx/ops.h
+++ b/arch/x86/kvm/vmx/ops.h
@@ -131,7 +131,9 @@ do {									\
 			  : : op1 : "cc" : error, fault);		\
 	return;								\
 error:									\
+	instr_begin();							\
 	insn##_error(error_args);					\
+	instr_end();							\
 	return;								\
 fault:									\
 	kvm_spurious_fault();						\
@@ -146,7 +148,9 @@ do {									\
 			  : : op1, op2 : "cc" : error, fault);		\
 	return;								\
 error:									\
+	instr_begin();							\
 	insn##_error(error_args);					\
+	instr_end();							\
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
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5931,7 +5931,7 @@ static int vmx_handle_exit(struct kvm_vc
  * information but as all relevant affected CPUs have 32KiB L1D cache size
  * there is no point in doing so.
  */
-static void vmx_l1d_flush(struct kvm_vcpu *vcpu)
+static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 {
 	int size = PAGE_SIZE << L1D_CACHE_ORDER;
 
@@ -5964,7 +5964,7 @@ static void vmx_l1d_flush(struct kvm_vcp
 	vcpu->stat.l1d_flush++;
 
 	if (static_cpu_has(X86_FEATURE_FLUSH_L1D)) {
-		wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
+		native_wrmsrl(MSR_IA32_FLUSH_CMD, L1D_FLUSH);
 		return;
 	}
 
@@ -6452,7 +6452,7 @@ static void vmx_update_hv_timer(struct k
 	}
 }
 
-void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
+void noinstr vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp)
 {
 	if (unlikely(host_rsp != vmx->loaded_vmcs->host_state.rsp)) {
 		vmx->loaded_vmcs->host_state.rsp = host_rsp;
@@ -6462,6 +6462,61 @@ void vmx_update_host_rsp(struct vcpu_vmx
 
 bool __vmx_vcpu_run(struct vcpu_vmx *vmx, unsigned long *regs, bool launched);
 
+static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
+					struct vcpu_vmx *vmx)
+{
+	instr_begin();
+	/*
+	 * VMENTER enables interrupts (host state), but the kernel state is
+	 * interrupts disabled when this is invoked. Also tell RCU about
+	 * it. This is the same logic as for exit_to_user_mode().
+	 *
+	 * 1) Trace interrupts on state
+	 * 2) Prepare lockdep with RCU on
+	 * 3) Invoke context tracking if enabled to adjust RCU state
+	 * 4) Tell lockdep that interrupts are enabled
+	 */
+	__trace_hardirqs_on();
+	lockdep_hardirqs_on_prepare(CALLER_ADDR0);
+	instr_end();
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
+	 * have them in state 'on'. Same as enter_from_user_mode().
+	 *
+	 * 1) Tell lockdep that interrupts are disabled
+	 * 2) Invoke context tracking if enabled to reactivate RCU
+	 * 3) Trace interrupts off state
+	 *
+	 * This needs to be done before the below as native_read_msr()
+	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
+	 * into world and some more.
+	 */
+	lockdep_hardirqs_off(CALLER_ADDR0);
+	guest_exit_irqoff();
+
+	instr_begin();
+	__trace_hardirqs_off();
+	instr_end();
+}
+
 static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
@@ -6538,49 +6593,9 @@ static void vmx_vcpu_run(struct kvm_vcpu
 	x86_spec_ctrl_set_guest(vmx->spec_ctrl, 0);
 
 	/*
-	 * VMENTER enables interrupts (host state), but the kernel state is
-	 * interrupts disabled when this is invoked. Also tell RCU about
-	 * it. This is the same logic as for exit_to_user_mode().
-	 *
-	 * 1) Trace interrupts on state
-	 * 2) Prepare lockdep with RCU on
-	 * 3) Invoke context tracking if enabled to adjust RCU state
-	 * 4) Tell lockdep that interrupts are enabled
+	 * The actual VMENTER/EXIT is in the .noinstr.text section.
 	 */
-	__trace_hardirqs_on();
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
-	 * have them in state 'on'. Same as enter_from_user_mode().
-	 *
-	 * 1) Tell lockdep that interrupts are disabled
-	 * 2) Invoke context tracking if enabled to reactivate RCU
-	 * 3) Trace interrupts off state
-	 *
-	 * This needs to be done before the below as native_read_msr()
-	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
-	 * into world and some more.
-	 */
-	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
-	__trace_hardirqs_off();
+	vmx_vcpu_enter_exit(vcpu, vmx);
 
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -354,7 +354,7 @@ int kvm_set_apic_base(struct kvm_vcpu *v
 }
 EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
-asmlinkage __visible void kvm_spurious_fault(void)
+asmlinkage __visible noinstr void kvm_spurious_fault(void)
 {
 	/* Fault while not rebooting.  We want the trace. */
 	BUG_ON(!kvm_rebooting);

