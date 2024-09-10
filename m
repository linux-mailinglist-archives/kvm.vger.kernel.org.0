Return-Path: <kvm+bounces-26340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CB6B9743D6
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D83D0B22E8B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 20:04:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900471AAE3B;
	Tue, 10 Sep 2024 20:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M8pG/3Ip"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0904A1AAE28
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 20:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725998646; cv=none; b=l+0BZrZb6tOyo0LuMYhcs0WdXna7vpUrfF9RHDfoH2/Z8aNCqTFzNox6Zk5EZwEaSXHE8Pm1tSb3NyoV1+2OYfKX0mCxwdkST4MpLIeSQCiEYbtOo1Id22+QIi00Q0+KbrZnpJ8WAu9/71NtgPv0J5DAzLd750HTIf6WYk+xy+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725998646; c=relaxed/simple;
	bh=ayOCfJbbjbaGGU/QbtX3RE1/lptM6Fj5qu/dt1ZJ75Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=suuzWawhcnPDn/1xSg3sVeiil3BkzQF3tblynGm8EazQr1VN01V+pdLGaxvEqbHJ4S3TjFarcuHqylSKXHi4egoOW3BelvoctqDVCkpbGJRmxt8NHqt18aNmR32QOCkkIxzArX354gMxbKNivjulhkiEnwhipFrjLxlN6LuWw1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M8pG/3Ip; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725998644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kPmYDwtae8csR+kX/Cb9MA+okEXSlun+9ETh+kgiZWA=;
	b=M8pG/3IpUn5k6ls81P+sB9GOO8IsAmYsghvKhZ/yfviA3ZeHj2oC6Th8YOVdq5msJBe4VV
	YdiVgWTwiHltZ1lugfW+c6nzwu6+KyKrBfQzgmllh9Z+cHTBtQ/aXHH5cW9AlVhLwyy1SI
	WivDypdpBcuTaD448Lx8P1gaDAMQf7w=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-504-NOmrHE1XPaGXsFW0ofK4mA-1; Tue,
 10 Sep 2024 16:04:00 -0400
X-MC-Unique: NOmrHE1XPaGXsFW0ofK4mA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 531B019560B0;
	Tue, 10 Sep 2024 20:03:57 +0000 (UTC)
Received: from starship.lan (unknown [10.22.64.235])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B93381956088;
	Tue, 10 Sep 2024 20:03:54 +0000 (UTC)
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
Subject: [PATCH v5 1/3] KVM: x86: add more information to the kvm_entry tracepoint
Date: Tue, 10 Sep 2024 16:03:48 -0400
Message-Id: <20240910200350.264245-2-mlevitsk@redhat.com>
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

Add VMX/SVM specific interrupt injection info to vm entry tracepoint.
Also add a flag showing that immediate vm exit is set to happen after
the entry.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  5 ++++-
 arch/x86/kvm/svm/svm.c             | 17 +++++++++++++++++
 arch/x86/kvm/trace.h               | 17 ++++++++++++++---
 arch/x86/kvm/vmx/main.c            |  1 +
 arch/x86/kvm/vmx/vmx.c             | 11 +++++++++++
 arch/x86/kvm/vmx/x86_ops.h         |  4 ++++
 7 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 03b7e13f15bbd..af5c4d55d47bc 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -99,6 +99,7 @@ KVM_X86_OP(get_l2_tsc_multiplier)
 KVM_X86_OP(write_tsc_offset)
 KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
+KVM_X86_OP(get_entry_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
 KVM_X86_OP_OPTIONAL(update_cpu_dirty_logging)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 52443ccda320f..8118f75a8a35d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1756,13 +1756,16 @@ struct kvm_x86_ops {
 	void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu);
 
 	/*
-	 * Retrieve somewhat arbitrary exit information.  Intended to
+	 * Retrieve somewhat arbitrary exit/entry information.  Intended to
 	 * be used only from within tracepoints or error paths.
 	 */
 	void (*get_exit_info)(struct kvm_vcpu *vcpu, u32 *reason,
 			      u64 *info1, u64 *info2,
 			      u32 *exit_int_info, u32 *exit_int_info_err_code);
 
+	void (*get_entry_info)(struct kvm_vcpu *vcpu,
+				u32 *inj_info, u32 *inj_info_error_code);
+
 	int (*check_intercept)(struct kvm_vcpu *vcpu,
 			       struct x86_instruction_info *info,
 			       enum x86_intercept_stage stage,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9a0506ef87dfb..485f3c2826312 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3525,6 +3525,22 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		*error_code = 0;
 }
 
+static void svm_get_entry_info(struct kvm_vcpu *vcpu,
+			u32 *inj_info,
+			u32 *inj_info_error_code)
+{
+	struct vmcb_control_area *control = &to_svm(vcpu)->vmcb->control;
+
+	*inj_info = control->event_inj;
+
+	if ((*inj_info & SVM_EXITINTINFO_VALID) &&
+	    (*inj_info & SVM_EXITINTINFO_VALID_ERR))
+		*inj_info_error_code = control->event_inj_err;
+	else
+		*inj_info_error_code = 0;
+
+}
+
 static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -5057,6 +5073,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.required_apicv_inhibits = AVIC_REQUIRED_APICV_INHIBITS,
 
 	.get_exit_info = svm_get_exit_info,
+	.get_entry_info = svm_get_entry_info,
 
 	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index d3aeffd6ae753..b4c014b1aa9a1 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -22,16 +22,27 @@ TRACE_EVENT(kvm_entry,
 		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned long,	rip		)
 		__field(	bool,		immediate_exit	)
+		__field(	u32,		inj_info	)
+		__field(	u32,		inj_info_err	)
+		__field(	bool,		guest_mode	)
 	),
 
 	TP_fast_assign(
 		__entry->vcpu_id        = vcpu->vcpu_id;
 		__entry->rip		= kvm_rip_read(vcpu);
-		__entry->immediate_exit	= force_immediate_exit;
+		__entry->immediate_exit = force_immediate_exit;
+		__entry->guest_mode     = is_guest_mode(vcpu);
+
+		static_call(kvm_x86_get_entry_info)(vcpu,
+					  &__entry->inj_info,
+					  &__entry->inj_info_err);
 	),
 
-	TP_printk("vcpu %u, rip 0x%lx%s", __entry->vcpu_id, __entry->rip,
-		  __entry->immediate_exit ? "[immediate exit]" : "")
+	TP_printk("vcpu %u, rip 0x%lx inj 0x%08x inj_error_code 0x%08x%s%s",
+		  __entry->vcpu_id, __entry->rip,
+		  __entry->inj_info, __entry->inj_info_err,
+		  __entry->immediate_exit ? "[immediate exit]" : "",
+		  __entry->guest_mode ? "[guest]" : "")
 );
 
 /*
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7e2e78a142574..769a7ca06f59b 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -108,6 +108,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
+	.get_entry_info = vmx_get_entry_info,
 
 	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 89682832dded7..af18174cc4a20 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6180,6 +6180,17 @@ void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 	}
 }
 
+void vmx_get_entry_info(struct kvm_vcpu *vcpu,
+			      u32 *inj_info,
+			      u32 *inj_info_error_code)
+{
+	*inj_info = vmcs_read32(VM_ENTRY_INTR_INFO_FIELD);
+	if (is_exception_with_error_code(*inj_info))
+		*inj_info_error_code = vmcs_read32(VM_ENTRY_EXCEPTION_ERROR_CODE);
+	else
+		*inj_info_error_code = 0;
+}
+
 static void vmx_destroy_pml_buffer(struct vcpu_vmx *vmx)
 {
 	if (vmx->pml_pg) {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b6a7cfc6ae317..124425997ec15 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -104,8 +104,12 @@ void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap);
 int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
 int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr);
 u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
+
 void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		       u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
+void vmx_get_entry_info(struct kvm_vcpu *vcpu, u32 *inj_info,
+			   u32 *inj_info_error_code);
+
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 void vmx_write_tsc_offset(struct kvm_vcpu *vcpu);
-- 
2.26.3


