Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD1850073C
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 09:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240474AbiDNHnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 03:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240450AbiDNHm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 03:42:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD7634DF65
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 00:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649922003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P80Pne9jp9o6r6k3/2ox1p81M67beNS4dcD0WFC8ITI=;
        b=EE/4WZkFWQUlVczQbflGJVUCILW40/JFMlhBlXrPnwxNgG1qesbcGYgLI2nPHuG0sAacgd
        YLuJF2fe5qqti6Uj+rodDfPdC5Xon10fX7qEutzWCnttsoVHQ6NCySZp8DqQ4c9qwwWok/
        B2k57o/tcaDABXgPvM+7IgSEbHblUOQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-135-OCHe_ZO-OKO6yawyC_SS1Q-1; Thu, 14 Apr 2022 03:40:02 -0400
X-MC-Unique: OCHe_ZO-OKO6yawyC_SS1Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1148B803F3A;
        Thu, 14 Apr 2022 07:40:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E885E41D40E;
        Thu, 14 Apr 2022 07:40:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 05/22] KVM: x86: Clean up and document nested #PF workaround
Date:   Thu, 14 Apr 2022 03:39:43 -0400
Message-Id: <20220414074000.31438-6-pbonzini@redhat.com>
In-Reply-To: <20220414074000.31438-1-pbonzini@redhat.com>
References: <20220414074000.31438-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Replace the per-vendor hack-a-fix for KVM's #PF => #PF => #DF workaround
with an explicit, common workaround in kvm_inject_emulated_page_fault().
Aside from being a hack, the current approach is brittle and incomplete,
e.g. nSVM's KVM_SET_NESTED_STATE fails to set ->inject_page_fault(),
and nVMX fails to apply the workaround when VMX is intercepting #PF due
to allow_smaller_maxphyaddr=1.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/nested.c       | 18 +++++++++---------
 arch/x86/kvm/vmx/nested.c       | 15 ++++++---------
 arch/x86/kvm/x86.c              | 21 ++++++++++++++++++++-
 4 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e1c695f72b8b..e46bd289e5df 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1516,6 +1516,8 @@ struct kvm_x86_ops {
 struct kvm_x86_nested_ops {
 	void (*leave_nested)(struct kvm_vcpu *vcpu);
 	int (*check_events)(struct kvm_vcpu *vcpu);
+	bool (*handle_page_fault_workaround)(struct kvm_vcpu *vcpu,
+					     struct x86_exception *fault);
 	bool (*hv_timer_pending)(struct kvm_vcpu *vcpu);
 	void (*triple_fault)(struct kvm_vcpu *vcpu);
 	int (*get_state)(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index caa691229b71..bed5e1692cef 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -55,24 +55,26 @@ static void nested_svm_inject_npf_exit(struct kvm_vcpu *vcpu,
 	nested_svm_vmexit(svm);
 }
 
-static void svm_inject_page_fault_nested(struct kvm_vcpu *vcpu, struct x86_exception *fault)
+static bool nested_svm_handle_page_fault_workaround(struct kvm_vcpu *vcpu,
+						    struct x86_exception *fault)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
 
-	WARN_ON(!is_guest_mode(vcpu));
+ 	WARN_ON(!is_guest_mode(vcpu));
 
 	if (vmcb12_is_intercept(&svm->nested.ctl,
 				INTERCEPT_EXCEPTION_OFFSET + PF_VECTOR) &&
-				!svm->nested.nested_run_pending) {
-		vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
+	    !WARN_ON_ONCE(svm->nested.nested_run_pending)) {
+	     	vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + PF_VECTOR;
 		vmcb->control.exit_code_hi = 0;
 		vmcb->control.exit_info_1 = fault->error_code;
 		vmcb->control.exit_info_2 = fault->address;
 		nested_svm_vmexit(svm);
-	} else {
-		kvm_inject_page_fault(vcpu, fault);
+		return true;
 	}
+
+	return false;
 }
 
 static u64 nested_svm_get_tdp_pdptr(struct kvm_vcpu *vcpu, int index)
@@ -751,9 +753,6 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	if (ret)
 		return ret;
 
-	if (!npt_enabled)
-		vcpu->arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
-
 	if (!from_vmrun)
 		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
@@ -1659,6 +1658,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 struct kvm_x86_nested_ops svm_nested_ops = {
 	.leave_nested = svm_leave_nested,
 	.check_events = svm_check_nested_events,
+	.handle_page_fault_workaround = nested_svm_handle_page_fault_workaround,
 	.triple_fault = nested_svm_triple_fault,
 	.get_nested_state_pages = svm_get_nested_state_pages,
 	.get_state = svm_get_nested_state,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 838ac7ab5950..a6688663da4d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -476,24 +476,23 @@ static int nested_vmx_check_exception(struct kvm_vcpu *vcpu, unsigned long *exit
 	return 0;
 }
 
-
-static void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
-		struct x86_exception *fault)
+static bool nested_vmx_handle_page_fault_workaround(struct kvm_vcpu *vcpu,
+						    struct x86_exception *fault)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
 	WARN_ON(!is_guest_mode(vcpu));
 
 	if (nested_vmx_is_page_fault_vmexit(vmcs12, fault->error_code) &&
-		!to_vmx(vcpu)->nested.nested_run_pending) {
+	    !WARN_ON_ONCE(to_vmx(vcpu)->nested.nested_run_pending)) {
 		vmcs12->vm_exit_intr_error_code = fault->error_code;
 		nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI,
 				  PF_VECTOR | INTR_TYPE_HARD_EXCEPTION |
 				  INTR_INFO_DELIVER_CODE_MASK | INTR_INFO_VALID_MASK,
 				  fault->address);
-	} else {
-		kvm_inject_page_fault(vcpu, fault);
+		return true;
 	}
+	return false;
 }
 
 static int nested_vmx_check_io_bitmap_controls(struct kvm_vcpu *vcpu,
@@ -2614,9 +2613,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
 	}
 
-	if (!enable_ept)
-		vcpu->arch.walk_mmu->inject_page_fault = vmx_inject_page_fault_nested;
-
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl))) {
@@ -6830,6 +6826,7 @@ __init int nested_vmx_hardware_setup(int (*exit_handlers[])(struct kvm_vcpu *))
 struct kvm_x86_nested_ops vmx_nested_ops = {
 	.leave_nested = vmx_leave_nested,
 	.check_events = vmx_check_nested_events,
+	.handle_page_fault_workaround = nested_vmx_handle_page_fault_workaround,
 	.hv_timer_pending = nested_vmx_preemption_timer_pending,
 	.triple_fault = nested_vmx_triple_fault,
 	.get_state = vmx_get_nested_state,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4e7f3a8da16a..9866853ca320 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -748,6 +748,7 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, struct x86_exception *fault)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_page_fault);
 
+/* Returns true if the page fault was immediately morphed into a VM-Exit. */
 bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 				    struct x86_exception *fault)
 {
@@ -766,8 +767,26 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 		kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
 				       fault_mmu->root.hpa);
 
+	/*
+	 * A workaround for KVM's bad exception handling.  If KVM injected an
+	 * exception into L2, and L2 encountered a #PF while vectoring the
+	 * injected exception, manually check to see if L1 wants to intercept
+	 * #PF, otherwise queuing the #PF will lead to #DF or a lost exception.
+	 * In all other cases, defer the check to nested_ops->check_events(),
+	 * which will correctly handle priority (this does not).  Note, other
+	 * exceptions, e.g. #GP, are theoretically affected, #PF is simply the
+	 * most problematic, e.g. when L0 and L1 are both intercepting #PF for
+	 * shadow paging.
+	 *
+	 * TODO: Rewrite exception handling to track injected and pending
+	 *       (VM-Exit) exceptions separately.
+	 */
+	if (unlikely(vcpu->arch.exception.injected && is_guest_mode(vcpu)) &&
+	    kvm_x86_ops.nested_ops->handle_page_fault_workaround(vcpu, fault))
+		return true;
+
 	fault_mmu->inject_page_fault(vcpu, fault);
-	return fault->nested_page_fault;
+	return false;
 }
 EXPORT_SYMBOL_GPL(kvm_inject_emulated_page_fault);
 
-- 
2.31.1


