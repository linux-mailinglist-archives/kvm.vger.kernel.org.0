Return-Path: <kvm+bounces-26342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC619743DB
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:05:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50DAD1C20B3F
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 20:05:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B181ABECB;
	Tue, 10 Sep 2024 20:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UrJpIciq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E221AB52A
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 20:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725998650; cv=none; b=s6XGQ1zbPskFJwtTsKjcF2TyNwmFDeCkXUpvrVq7E8ZIX0XNm+uZ7nU6AV2i6Qk+9Nq2SZ4IN5hy9Cqen3Clvwuq+V7cdshr5bTeoHk2Zge5Wh6MTftZkrRK9ebQHNR5dvFixhZQTXrX4rf6QcHxknBbZwob82c4KsZM/IFmntU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725998650; c=relaxed/simple;
	bh=o1oABd9aLUXxcV1DQ/QsEHpcPb9GJF7E8NMrYpkXuro=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bjuat8mpI1Eb5fjlHp6tZaMxV98y185hP2tXzJ5jK76Hf7tnPAc1vP+crizcebGVIV8ewa+NtaqWZfwS/7oH7pN7WGVKO1hLt643+IirUrp3RUyp/Q24U1cwbrbRDOpUYlhU9k2AQ0NmfqNhrkjDNHMn1RV1749yDGpO9sAyfks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UrJpIciq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725998648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8/sD2LsSSzBO9zfwEwUI+IvEBIWqw3/8kbtVj9dPpIQ=;
	b=UrJpIciqe4xhDfBEhiyvJ39KZTmybmlJJs8XipCe/N3h+5uotZAmlc5kJ2ZXYoTUagiDIu
	/C8aH9u4GQ6eY8WiEln47VVW6gncaqfZG4wBFudw51XSTG7V1MJbzYAhdzcdLp2vtv6Ezt
	1aw46nXA5FsIcJGLdHhWBFasAbp8HqQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-301-K3cEogO0OiKYMtCAfRNfpQ-1; Tue,
 10 Sep 2024 16:04:04 -0400
X-MC-Unique: K3cEogO0OiKYMtCAfRNfpQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 634A91955D4B;
	Tue, 10 Sep 2024 20:04:02 +0000 (UTC)
Received: from starship.lan (unknown [10.22.64.235])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D85681956088;
	Tue, 10 Sep 2024 20:03:59 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: x86@kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v5 3/3] KVM: x86: add new nested vmexit tracepoints
Date: Tue, 10 Sep 2024 16:03:50 -0400
Message-Id: <20240910200350.264245-4-mlevitsk@redhat.com>
In-Reply-To: <20240910200350.264245-1-mlevitsk@redhat.com>
References: <20240910200350.264245-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

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

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 22 +++++++++++
 arch/x86/kvm/trace.h      | 82 +++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/nested.c | 27 +++++++++++++
 arch/x86/kvm/x86.c        |  3 ++
 4 files changed, 131 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 6f704c1037e51..2020307481553 100644
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
 
@@ -1126,6 +1132,22 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
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
index 5a5b7757e8456..6074b4f85d5e2 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -613,7 +613,7 @@ TRACE_EVENT(kvm_pv_eoi,
 );
 
 /*
- * Tracepoint for nested VMRUN
+ * Tracepoint for nested VMRUN/VMENTER
  */
 TRACE_EVENT(kvm_nested_vmenter,
 	    TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
@@ -746,8 +746,84 @@ TRACE_EVENT(kvm_nested_intr_vmexit,
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
 	    TP_PROTO(__u64 rip, unsigned int asid, u64 address),
@@ -770,7 +846,7 @@ TRACE_EVENT(kvm_invlpga,
 );
 
 /*
- * Tracepoint for nested #vmexit because of interrupt pending
+ * Tracepoint for skinit
  */
 TRACE_EVENT(kvm_skinit,
 	    TP_PROTO(__u64 rip, __u32 slb),
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2392a7ef254df..3881a02694fc2 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -454,6 +454,16 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
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
@@ -4985,6 +4995,23 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
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
index f72e5d89e942d..cb01cf2ad6ac9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14032,6 +14032,9 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter);
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


