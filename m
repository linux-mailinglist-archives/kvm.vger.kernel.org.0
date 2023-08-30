Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1764378D95F
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbjH3SdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244193AbjH3Mnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 08:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38569CC5
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 05:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693399376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cXmGRleFgxAJpob9+MyMwqaQ6p2zsPjd+uLwoaCoCBo=;
        b=SbMfEnnKvyvoe2wqtKK8nrYXFlIAJMh/6NdYAaMGcGrDVtd0eds77uWU86IlU17tp47JPl
        SGH7ZwicX1t8tY+WGJNUVgTFvSLEYIuTE9voV9/04ICOqECQyoHQY9pfAtO8YeYjx+VCyj
        n2Tmhts/Zh57/iBDPnXJ7UGXxz+lGTA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-63-e4BA0LOoNSePE1uuIFVhQQ-1; Wed, 30 Aug 2023 08:42:54 -0400
X-MC-Unique: e4BA0LOoNSePE1uuIFVhQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A694E800CAB;
        Wed, 30 Aug 2023 12:42:53 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.224.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 429ED2026D35;
        Wed, 30 Aug 2023 12:42:51 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/4] KVM: x86: add more information to the kvm_entry tracepoint
Date:   Wed, 30 Aug 2023 15:42:41 +0300
Message-Id: <20230830124243.671152-3-mlevitsk@redhat.com>
In-Reply-To: <20230830124243.671152-1-mlevitsk@redhat.com>
References: <20230830124243.671152-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add:
  - Flag showing that VM is in a guest mode on entry.
  - Flag showing that immediate vm exit is set to happen after the entry.
  - VMX/SVM specific interrupt injection info (like in a vm exit).

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  5 ++++-
 arch/x86/kvm/svm/svm.c             | 17 +++++++++++++++++
 arch/x86/kvm/trace.h               | 19 +++++++++++++++++--
 arch/x86/kvm/vmx/vmx.c             | 12 ++++++++++++
 5 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index f654a7f4cc8c0c..346fed6e3c33aa 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -99,6 +99,7 @@ KVM_X86_OP(get_l2_tsc_multiplier)
 KVM_X86_OP(write_tsc_offset)
 KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
+KVM_X86_OP(get_entry_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
 KVM_X86_OP(sched_in)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5f2a93f92a3df7..9cc5ac420f4052 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1661,13 +1661,16 @@ struct kvm_x86_ops {
 	void (*write_tsc_multiplier)(struct kvm_vcpu *vcpu, u64 multiplier);
 
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
index 18d0895975dfd8..dd09cb8d7eaebf 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3405,6 +3405,22 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
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
@@ -4866,6 +4882,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.required_apicv_inhibits = AVIC_REQUIRED_APICV_INHIBITS,
 
 	.get_exit_info = svm_get_exit_info,
+	.get_entry_info = svm_get_entry_info,
 
 	.vcpu_after_set_cpuid = svm_vcpu_after_set_cpuid,
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 83843379813ee3..f4c56f59f5c11b 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -21,14 +21,29 @@ TRACE_EVENT(kvm_entry,
 	TP_STRUCT__entry(
 		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned long,	rip		)
-	),
+		__field(	u32,		inj_info	)
+		__field(	u32,		inj_info_err	)
+		__field(	bool,		guest_mode	)
+		__field(	bool,		req_imm_exit	)
+		),
 
 	TP_fast_assign(
 		__entry->vcpu_id        = vcpu->vcpu_id;
 		__entry->rip		= kvm_rip_read(vcpu);
+
+		static_call(kvm_x86_get_entry_info)(vcpu,
+					  &__entry->inj_info,
+					  &__entry->inj_info_err);
+
+		__entry->req_imm_exit   = vcpu->arch.req_immediate_exit;
+		__entry->guest_mode = is_guest_mode(vcpu);
 	),
 
-	TP_printk("vcpu %u, rip 0x%lx", __entry->vcpu_id, __entry->rip)
+	TP_printk("vcpu %u, rip 0x%lx inj 0x%08x inj_error_code 0x%08x%s%s",
+			__entry->vcpu_id, __entry->rip,
+			__entry->inj_info, __entry->inj_info_err,
+			__entry->req_imm_exit ? " [imm exit]" : "",
+			__entry->guest_mode ? " [guest]" : "")
 );
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 77ef6f02b3f42f..d662d546232171 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6157,6 +6157,17 @@ static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 	}
 }
 
+static void vmx_get_entry_info(struct kvm_vcpu *vcpu,
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
@@ -8287,6 +8298,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
+	.get_entry_info = vmx_get_entry_info,
 
 	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
 
-- 
2.26.3

