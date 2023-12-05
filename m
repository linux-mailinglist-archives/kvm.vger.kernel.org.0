Return-Path: <kvm+bounces-3501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92CDA8050AF
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:39:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 496142819A2
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B9C5645E;
	Tue,  5 Dec 2023 10:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XVqy7T7y"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126BA129
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JqrUdeRCIHO7c322SPH7VrnU7d0mlWYAQF7EMV1tQ3M=;
	b=XVqy7T7yw9NUH8nKmg8v1usxmJO5i1qzFKUyPOKqRxYqAtwdbDhVXmDfH+Q+64Ip9hhFW6
	Pwbzi02PLWovK4d5AdwQNiIJop6bQk0SupdgfLM6uc7wv+0mFAyfEDOPmz8docA1YkX2Av
	PdA0RiK2v3jphxg+tf0OPjAnqYw6Lc4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-90-NkA2zqv2M_WOP4_fHwQmyg-1; Tue,
 05 Dec 2023 05:38:00 -0500
X-MC-Unique: NkA2zqv2M_WOP4_fHwQmyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 559D329AA395;
	Tue,  5 Dec 2023 10:38:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.225.152])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E109DC15E6A;
	Tue,  5 Dec 2023 10:37:57 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 4/4] KVM: x86: add new nested vmexit tracepoints
Date: Tue,  5 Dec 2023 12:37:45 +0200
Message-Id: <20231205103745.506724-5-mlevitsk@redhat.com>
In-Reply-To: <20231205103745.506724-1-mlevitsk@redhat.com>
References: <20231205103745.506724-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Add 3 new tracepoints for nested VM exits which are intended
to capture extra information to gain insights about the nested guest
behavior.

The new tracepoints are:

- kvm_nested_msr
- kvm_nested_hypercall

These tracepoints capture extra register state to be able to know
which MSR or which hypercall was done.

- kvm_nested_page_fault

This tracepoint allows to capture extra info about which host pagefault
error code caused the nested page fault.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 22 +++++++++++
 arch/x86/kvm/trace.h      | 82 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/nested.c | 27 +++++++++++++
 arch/x86/kvm/x86.c        |  3 ++
 4 files changed, 131 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3fea8c47679e689..05fc257818fc112 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -38,6 +38,8 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
+	u64 host_error_code = vmcb->control.exit_info_1;
+
 
 	if (vmcb->control.exit_code != SVM_EXIT_NPF) {
 		/*
@@ -48,11 +50,15 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 		vmcb->control.exit_code_hi = 0;
 		vmcb->control.exit_info_1 = (1ULL << 32);
 		vmcb->control.exit_info_2 = fault->address;
+		host_error_code = 0;
 	}
 
 	vmcb->control.exit_info_1 &= ~0xffffffffULL;
 	vmcb->control.exit_info_1 |= fault->error_code;
 
+	trace_kvm_nested_page_fault(fault->address, host_error_code,
+				    fault->error_code);
+
 	nested_svm_vmexit(svm);
 }
 
@@ -1139,6 +1145,22 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 				       vmcb12->control.exit_int_info_err,
 				       KVM_ISA_SVM);
 
+	/* Collect some info about nested VM exits */
+	switch (vmcb12->control.exit_code) {
+	case SVM_EXIT_MSR:
+		trace_kvm_nested_msr(vmcb12->control.exit_info_1 == 1,
+				     kvm_rcx_read(vcpu),
+				     (vmcb12->save.rax & 0xFFFFFFFFull) |
+				     (((u64)kvm_rdx_read(vcpu) << 32)));
+		break;
+	case SVM_EXIT_VMMCALL:
+		trace_kvm_nested_hypercall(vmcb12->save.rax,
+					   kvm_rbx_read(vcpu),
+					   kvm_rcx_read(vcpu),
+					   kvm_rdx_read(vcpu));
+		break;
+	}
+
 	kvm_vcpu_unmap(vcpu, &map, true);
 
 	nested_svm_transition_tlb_flush(vcpu);
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index e275a02a21e5233..782c435bddfd454 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -610,7 +610,7 @@ TRACE_EVENT(kvm_pv_eoi,
 );
 
 /*
- * Tracepoint for nested VMRUN
+ * Tracepoint for nested VMRUN/VMENTER
  */
 TRACE_EVENT(kvm_nested_vmenter,
 	    TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
@@ -743,8 +743,84 @@ TRACE_EVENT(kvm_nested_intr_vmexit,
 	TP_printk("rip: 0x%016llx", __entry->rip)
 );
 
+
 /*
- * Tracepoint for nested #vmexit because of interrupt pending
+ * Tracepoint for nested guest MSR access.
+ */
+TRACE_EVENT(kvm_nested_msr,
+	TP_PROTO(bool write, u32 ecx, u64 data),
+	TP_ARGS(write, ecx, data),
+
+	TP_STRUCT__entry(
+		__field(	bool,		write		)
+		__field(	u32,		ecx		)
+		__field(	u64,		data		)
+	),
+
+	TP_fast_assign(
+		__entry->write		= write;
+		__entry->ecx		= ecx;
+		__entry->data		= data;
+	),
+
+	TP_printk("msr_%s %x = 0x%llx",
+		  __entry->write ? "write" : "read",
+		  __entry->ecx, __entry->data)
+);
+
+/*
+ * Tracepoint for nested hypercalls, capturing generic info about the
+ * hypercall
+ */
+
+TRACE_EVENT(kvm_nested_hypercall,
+	TP_PROTO(u64 rax, u64 rbx, u64 rcx, u64 rdx),
+	TP_ARGS(rax, rbx, rcx, rdx),
+
+	TP_STRUCT__entry(
+		__field(	u64, 	rax	)
+		__field(	u64,	rbx	)
+		__field(	u64,	rcx	)
+		__field(	u64,	rdx	)
+	),
+
+	TP_fast_assign(
+		__entry->rax		= rax;
+		__entry->rbx		= rbx;
+		__entry->rcx		= rcx;
+		__entry->rdx		= rdx;
+	),
+
+	TP_printk("rax 0x%llx rbx 0x%llx rcx 0x%llx rdx 0x%llx",
+		 __entry->rax, __entry->rbx, __entry->rcx,  __entry->rdx)
+);
+
+
+TRACE_EVENT(kvm_nested_page_fault,
+	TP_PROTO(u64 gpa, u64 host_error_code, u64 guest_error_code),
+	TP_ARGS(gpa, host_error_code, guest_error_code),
+
+	TP_STRUCT__entry(
+			__field(	u64,		gpa	)
+		__field(	u64,		host_error_code		)
+		__field(	u64,		guest_errror_code	)
+	),
+
+	TP_fast_assign(
+		__entry->gpa			= gpa;
+		__entry->host_error_code	= host_error_code;
+		__entry->guest_errror_code	= guest_error_code;
+	),
+
+	TP_printk("gpa 0x%llx host err 0x%llx guest err 0x%llx",
+		  __entry->gpa,
+		  __entry->host_error_code,
+		  __entry->guest_errror_code)
+);
+
+
+/*
+ * Tracepoint for invlpga
  */
 TRACE_EVENT(kvm_invlpga,
 	    TP_PROTO(__u64 rip, int asid, u64 address),
@@ -767,7 +843,7 @@ TRACE_EVENT(kvm_invlpga,
 );
 
 /*
- * Tracepoint for nested #vmexit because of interrupt pending
+ * Tracepoint for skinit
  */
 TRACE_EVENT(kvm_skinit,
 	    TP_PROTO(__u64 rip, __u32 slb),
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff78fa..23325a7af8fc2ab 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -402,6 +402,16 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 		 */
 		nested_ept_invalidate_addr(vcpu, vmcs12->ept_pointer,
 					   fault->address);
+
+		/*
+		 * vmx_get_exit_qual() returns the original exit qualification,
+		 * before it was overridden with exit qualification that
+		 * is about to be injected to the guest.
+		 */
+
+		trace_kvm_nested_page_fault(fault->address,
+				vmx_get_exit_qual(vcpu),
+				exit_qualification);
 	}
 
 	nested_vmx_vmexit(vcpu, vm_exit_reason, 0, exit_qualification);
@@ -4877,6 +4887,23 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 						       vmcs12->vm_exit_intr_error_code,
 						       KVM_ISA_VMX);
 
+		switch ((u16)vmcs12->vm_exit_reason) {
+		case EXIT_REASON_MSR_READ:
+		case EXIT_REASON_MSR_WRITE:
+			trace_kvm_nested_msr(vmcs12->vm_exit_reason == EXIT_REASON_MSR_WRITE,
+					     kvm_rcx_read(vcpu),
+					     (kvm_rax_read(vcpu) & 0xFFFFFFFFull) |
+					     (((u64)kvm_rdx_read(vcpu)) << 32));
+			break;
+		case EXIT_REASON_VMCALL:
+			trace_kvm_nested_hypercall(kvm_rax_read(vcpu),
+						   kvm_rbx_read(vcpu),
+						   kvm_rcx_read(vcpu),
+						   kvm_rdx_read(vcpu));
+			break;
+
+		}
+
 		load_vmcs12_host_state(vcpu, vmcs12);
 
 		return;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2089a0b08ce08c0..c75001abca8e835 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13787,6 +13787,9 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_hypercall);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_page_fault);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter_failed);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
-- 
2.26.3


