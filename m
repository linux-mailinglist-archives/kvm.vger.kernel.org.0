Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E414D87F46
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 18:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437208AbfHIQPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 12:15:37 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53094 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437112AbfHIQPJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Aug 2019 12:15:09 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 94E62305D360;
        Fri,  9 Aug 2019 19:01:39 +0300 (EEST)
Received: from localhost.localdomain (unknown [89.136.169.210])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4DB88305B7A1;
        Fri,  9 Aug 2019 19:01:39 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     linux-mm@kvack.org, virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        =?UTF-8?q?Samuel=20Laur=C3=A9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>
Subject: [RFC PATCH v6 78/92] kvm: x86: add tracepoints for interrupt and exception injections
Date:   Fri,  9 Aug 2019 19:00:33 +0300
Message-Id: <20190809160047.8319-79-alazar@bitdefender.com>
In-Reply-To: <20190809160047.8319-1-alazar@bitdefender.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This patch introduces additional tracepoints that are meant to help
in following the flow of interrupts and exceptions queued to a guest
VM. At the same time the kvm_exit tracepoint is enhanced with the
vCPU ID.

One scenario in which these help is debugging lost interrupts due to
a buggy VMEXIT handler.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/kvm/svm.c     |   9 +++-
 arch/x86/kvm/trace.h   | 118 ++++++++++++++++++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.c |   8 ++-
 arch/x86/kvm/x86.c     |  12 +++--
 4 files changed, 116 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index cb536a2611f6..00bdf885f9a4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -799,6 +799,8 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 	bool reinject = vcpu->arch.exception.injected;
 	u32 error_code = vcpu->arch.exception.error_code;
 
+	trace_kvm_inj_exception(vcpu);
+
 	/*
 	 * If we are within a nested VM we'd better #VMEXIT and let the guest
 	 * handle the exception
@@ -5108,6 +5110,8 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	trace_kvm_inj_nmi(vcpu);
+
 	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID | SVM_EVTINJ_TYPE_NMI;
 	vcpu->arch.hflags |= HF_NMI_MASK;
 	set_intercept(svm, INTERCEPT_IRET);
@@ -5133,7 +5137,8 @@ static void svm_set_irq(struct kvm_vcpu *vcpu)
 
 	BUG_ON(!(gif_set(svm)));
 
-	trace_kvm_inj_virq(vcpu->arch.interrupt.nr);
+	trace_kvm_inj_interrupt(vcpu);
+
 	++vcpu->stat.irq_injections;
 
 	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
@@ -5637,6 +5642,8 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 
+	trace_kvm_cancel_inj(vcpu);
+
 	control->exit_int_info = control->event_inj;
 	control->exit_int_info_err = control->event_inj_err;
 	control->event_inj = 0;
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 6432d08c7de7..cb47889ddc2c 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -227,6 +227,7 @@ TRACE_EVENT(kvm_exit,
 	TP_ARGS(exit_reason, vcpu, isa),
 
 	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned int,	exit_reason	)
 		__field(	unsigned long,	guest_rip	)
 		__field(	u32,	        isa             )
@@ -235,6 +236,7 @@ TRACE_EVENT(kvm_exit,
 	),
 
 	TP_fast_assign(
+		__entry->vcpu_id	= vcpu->vcpu_id;
 		__entry->exit_reason	= exit_reason;
 		__entry->guest_rip	= kvm_rip_read(vcpu);
 		__entry->isa            = isa;
@@ -242,7 +244,8 @@ TRACE_EVENT(kvm_exit,
 					   &__entry->info2);
 	),
 
-	TP_printk("reason %s rip 0x%lx info %llx %llx",
+	TP_printk("vcpu %u reason %s rip 0x%lx info %llx %llx",
+		 __entry->vcpu_id,
 		 (__entry->isa == KVM_ISA_VMX) ?
 		 __print_symbolic(__entry->exit_reason, VMX_EXIT_REASONS) :
 		 __print_symbolic(__entry->exit_reason, SVM_EXIT_REASONS),
@@ -252,19 +255,38 @@ TRACE_EVENT(kvm_exit,
 /*
  * Tracepoint for kvm interrupt injection:
  */
-TRACE_EVENT(kvm_inj_virq,
-	TP_PROTO(unsigned int irq),
-	TP_ARGS(irq),
-
+TRACE_EVENT(kvm_inj_interrupt,
+	TP_PROTO(struct kvm_vcpu *vcpu),
+	TP_ARGS(vcpu),
 	TP_STRUCT__entry(
-		__field(	unsigned int,	irq		)
+		__field(__u32, vcpu_id)
+		__field(__u32, nr)
 	),
-
 	TP_fast_assign(
-		__entry->irq		= irq;
+		__entry->vcpu_id = vcpu->vcpu_id;
+		__entry->nr = vcpu->arch.interrupt.nr;
 	),
+	TP_printk("vcpu %u irq %u",
+		  __entry->vcpu_id,
+		  __entry->nr
+	)
+);
 
-	TP_printk("irq %u", __entry->irq)
+/*
+ * Tracepoint for kvm nmi injection:
+ */
+TRACE_EVENT(kvm_inj_nmi,
+	TP_PROTO(struct kvm_vcpu *vcpu),
+	TP_ARGS(vcpu),
+	TP_STRUCT__entry(
+		__field(__u32, vcpu_id)
+	),
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
+	),
+	TP_printk("vcpu %u",
+		  __entry->vcpu_id
+	)
 );
 
 #define EXS(x) { x##_VECTOR, "#" #x }
@@ -275,28 +297,76 @@ TRACE_EVENT(kvm_inj_virq,
 	EXS(MF), EXS(AC), EXS(MC)
 
 /*
- * Tracepoint for kvm interrupt injection:
+ * Tracepoint for kvm exception injection:
  */
-TRACE_EVENT(kvm_inj_exception,
-	TP_PROTO(unsigned exception, bool has_error, unsigned error_code),
-	TP_ARGS(exception, has_error, error_code),
-
+TRACE_EVENT(
+	kvm_inj_exception,
+	TP_PROTO(struct kvm_vcpu *vcpu),
+	TP_ARGS(vcpu),
 	TP_STRUCT__entry(
-		__field(	u8,	exception	)
-		__field(	u8,	has_error	)
-		__field(	u32,	error_code	)
+		__field(__u32, vcpu_id)
+		__field(__u8, nr)
+		__field(__u64, address)
+		__field(__u16, error_code)
+		__field(bool, has_error_code)
 	),
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
+		__entry->nr = vcpu->arch.exception.nr;
+		__entry->address = vcpu->arch.exception.nested_apf ?
+			vcpu->arch.apf.nested_apf_token : vcpu->arch.cr2;
+		__entry->error_code = vcpu->arch.exception.error_code;
+		__entry->has_error_code = vcpu->arch.exception.has_error_code;
+	),
+	TP_printk("vcpu %u %s address %llx error %x",
+		  __entry->vcpu_id,
+		  __print_symbolic(__entry->nr, kvm_trace_sym_exc),
+		  __entry->nr == PF_VECTOR ? __entry->address : 0,
+		  __entry->has_error_code ? __entry->error_code : 0
+	)
+);
 
+TRACE_EVENT(
+	kvm_inj_emul_exception,
+	TP_PROTO(struct kvm_vcpu *vcpu, struct x86_exception *fault),
+	TP_ARGS(vcpu, fault),
+	TP_STRUCT__entry(
+		__field(__u32, vcpu_id)
+		__field(__u8, vector)
+		__field(__u64, address)
+		__field(__u16, error_code)
+		__field(bool, error_code_valid)
+	),
 	TP_fast_assign(
-		__entry->exception	= exception;
-		__entry->has_error	= has_error;
-		__entry->error_code	= error_code;
+		__entry->vcpu_id = vcpu->vcpu_id;
+		__entry->vector = fault->vector;
+		__entry->address = fault->address;
+		__entry->error_code = fault->error_code;
+		__entry->error_code_valid = fault->error_code_valid;
 	),
+	TP_printk("vcpu %u %s address %llx error %x",
+		  __entry->vcpu_id,
+		  __print_symbolic(__entry->vector, kvm_trace_sym_exc),
+		  __entry->vector == PF_VECTOR ? __entry->address : 0,
+		  __entry->error_code_valid ? __entry->error_code : 0
+	)
+);
 
-	TP_printk("%s (0x%x)",
-		  __print_symbolic(__entry->exception, kvm_trace_sym_exc),
-		  /* FIXME: don't print error_code if not present */
-		  __entry->has_error ? __entry->error_code : 0)
+/*
+ * Tracepoint for kvm cancel injection:
+ */
+TRACE_EVENT(kvm_cancel_inj,
+	TP_PROTO(struct kvm_vcpu *vcpu),
+	TP_ARGS(vcpu),
+	TP_STRUCT__entry(
+		__field(__u32, vcpu_id)
+	),
+	TP_fast_assign(
+		__entry->vcpu_id = vcpu->vcpu_id;
+	),
+	TP_printk("vcpu %u",
+		  __entry->vcpu_id
+	)
 );
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 152c58b63f69..85561994661a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1494,6 +1494,8 @@ static void vmx_queue_exception(struct kvm_vcpu *vcpu)
 	u32 error_code = vcpu->arch.exception.error_code;
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
 
+	trace_kvm_inj_exception(vcpu);
+
 	kvm_deliver_exception_payload(vcpu);
 
 	if (has_error_code) {
@@ -4266,7 +4268,7 @@ static void vmx_inject_irq(struct kvm_vcpu *vcpu)
 	uint32_t intr;
 	int irq = vcpu->arch.interrupt.nr;
 
-	trace_kvm_inj_virq(irq);
+	trace_kvm_inj_interrupt(vcpu);
 
 	++vcpu->stat.irq_injections;
 	if (vmx->rmode.vm86_active) {
@@ -4293,6 +4295,8 @@ static void vmx_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	trace_kvm_inj_nmi(vcpu);
+
 	if (!enable_vnmi) {
 		/*
 		 * Tracking the NMI-blocked state in software is built upon
@@ -6452,6 +6456,8 @@ static void vmx_complete_interrupts(struct vcpu_vmx *vmx)
 
 static void vmx_cancel_injection(struct kvm_vcpu *vcpu)
 {
+	trace_kvm_cancel_inj(vcpu);
+
 	__vmx_complete_interrupts(vcpu,
 				  vmcs_read32(VM_ENTRY_INTR_INFO_FIELD),
 				  VM_ENTRY_INSTRUCTION_LEN,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3975331230b9..e09a76179c4b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6178,6 +6178,9 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 static bool inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+
+	trace_kvm_inj_emul_exception(vcpu, &ctxt->exception);
+
 	if (ctxt->exception.vector == PF_VECTOR)
 		return kvm_propagate_fault(vcpu, &ctxt->exception);
 
@@ -7487,10 +7490,6 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 
 	/* try to inject new event if pending */
 	if (vcpu->arch.exception.pending) {
-		trace_kvm_inj_exception(vcpu->arch.exception.nr,
-					vcpu->arch.exception.has_error_code,
-					vcpu->arch.exception.error_code);
-
 		WARN_ON_ONCE(vcpu->arch.exception.injected);
 		vcpu->arch.exception.pending = false;
 		vcpu->arch.exception.injected = true;
@@ -10250,7 +10249,10 @@ EXPORT_SYMBOL(kvm_arch_vcpu_intercept_desc);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_interrupt);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_nmi);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_exception);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cancel_inj);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
