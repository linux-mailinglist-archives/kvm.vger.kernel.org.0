Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49A57AC820
	for <lists+kvm@lfdr.de>; Sun, 24 Sep 2023 14:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjIXMqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 08:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjIXMp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 08:45:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80DF10A
        for <kvm@vger.kernel.org>; Sun, 24 Sep 2023 05:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695559464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fFJC83yFEMh96Rc1m+ZUEAQuB1+TZDtoy8648SDKRR8=;
        b=MAOTpLV83nl8IX50Pu2bVhC0U9/MR9hXL/ldf2eWd0lOVv3U3hrD6IY4F9RA50ZiCSezeW
        Ld745VzO+TL4ygG78Tl9fimHtVWWtc1I6Pfsb+9lapZK6HGsPf3yeNayvjLwNfPn+INimG
        QHtULKwamxh47aHK9dHbAJa0/O7BpgU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-SsqCgeoXM32n1LVmv9vs9w-1; Sun, 24 Sep 2023 08:44:20 -0400
X-MC-Unique: SsqCgeoXM32n1LVmv9vs9w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 262241C0514F;
        Sun, 24 Sep 2023 12:44:20 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.45.226.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D103140C6EA8;
        Sun, 24 Sep 2023 12:44:17 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/4] KVM: x86: add more information to the kvm_entry tracepoint
Date:   Sun, 24 Sep 2023 15:44:08 +0300
Message-Id: <20230924124410.897646-3-mlevitsk@redhat.com>
In-Reply-To: <20230924124410.897646-1-mlevitsk@redhat.com>
References: <20230924124410.897646-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
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
index 383a1d0cc0743b..321721813474f7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1679,13 +1679,16 @@ struct kvm_x86_ops {
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
index 60b130b7f9d510..cd65c04be3d0e2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3504,6 +3504,22 @@ static void svm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
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
@@ -4992,6 +5008,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
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
index eb7e42235e8811..9dd13f52d4999c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6156,6 +6156,17 @@ static void vmx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
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
@@ -8297,6 +8308,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
+	.get_entry_info = vmx_get_entry_info,
 
 	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
 
-- 
2.26.3

