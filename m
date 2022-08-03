Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73072588DA6
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbiHCNr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238149AbiHCNrD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:47:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C23382B606
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659534383;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3DokUODhj3eZfBaxpH6GzboI0BcdK71eD6shRHDUxLA=;
        b=SQH8/YYWd8F68RvQbOIm/gkmvFTYMcSsZTxAEFd7Zf1r5xNdwTh8nVQz1FAi28aLvwncyl
        Bw91zgPfh4rxCU/+ATNvxv46HZkBAnfdY7Qgc0tA/Coa3b2O12pDy8nTSYjWhMyOwpK69F
        TJUCATsiK3ue33PigC3yZLFftRyMqog=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-184-uWWYvn62Mgiy1BN1Pih-SQ-1; Wed, 03 Aug 2022 09:46:20 -0400
X-MC-Unique: uWWYvn62Mgiy1BN1Pih-SQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 10E2F800DB8;
        Wed,  3 Aug 2022 13:46:19 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63E4AC04482;
        Wed,  3 Aug 2022 13:46:16 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 22/40] KVM: nSVM: hyper-v: Enable L2 TLB flush
Date:   Wed,  3 Aug 2022 15:46:15 +0200
Message-Id: <20220803134615.399372-1-vkuznets@redhat.com>
In-Reply-To: <20220803134110.397885-1-vkuznets@redhat.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement Hyper-V L2 TLB flush for nSVM. The feature needs to be enabled
both in extended 'nested controls' in VMCB and VP assist page.
According to Hyper-V TLFS, synthetic vmexit to L1 is performed with
- HV_SVM_EXITCODE_ENL exit_code.
- HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH exit_info_1.

Note: VP assist page is cached in 'struct kvm_vcpu_hv' so
recalc_intercepts() doesn't need to read from guest's memory. KVM
needs to update the case upon each VMRUN and after svm_set_nested_state
(svm_get_nested_state_pages()) to handle the case when the guest got
migrated while L2 was running.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/hyperv.c |  7 +++++++
 arch/x86/kvm/svm/hyperv.h | 30 ++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/nested.c | 36 ++++++++++++++++++++++++++++++++++--
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/hyperv.c b/arch/x86/kvm/svm/hyperv.c
index 911f51021af1..088f6429b24c 100644
--- a/arch/x86/kvm/svm/hyperv.c
+++ b/arch/x86/kvm/svm/hyperv.c
@@ -8,4 +8,11 @@
 
 void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.exit_code = HV_SVM_EXITCODE_ENL;
+	svm->vmcb->control.exit_code_hi = 0;
+	svm->vmcb->control.exit_info_1 = HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH;
+	svm->vmcb->control.exit_info_2 = 0;
+	nested_svm_vmexit(svm);
 }
diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index dd2e393f84a0..7b01722838bf 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -33,6 +33,9 @@ struct hv_enlightenments {
  */
 #define VMCB_HV_NESTED_ENLIGHTENMENTS VMCB_SW
 
+#define HV_SVM_EXITCODE_ENL 0xF0000000
+#define HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH   (1)
+
 static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -48,6 +51,33 @@ static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
 	hv_vcpu->nested.vp_id = hve->hv_vp_id;
 }
 
+static inline bool nested_svm_hv_update_vp_assist(struct kvm_vcpu *vcpu)
+{
+	if (!to_hv_vcpu(vcpu))
+		return true;
+
+	if (!kvm_hv_assist_page_enabled(vcpu))
+		return true;
+
+	return kvm_hv_get_assist_page(vcpu);
+}
+
+static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct hv_enlightenments *hve =
+		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
+	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
+
+	if (!hv_vcpu)
+		return false;
+
+	if (!hve->hv_enlightenments_control.nested_flush_hypercall)
+		return false;
+
+	return hv_vcpu->vp_assist_page.nested_control.features.directhypercall;
+}
+
 void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 
 #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d0e660252a9a..04e8d9d2ff7a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -171,8 +171,12 @@ void recalc_intercepts(struct vcpu_svm *svm)
 		vmcb_clr_intercept(c, INTERCEPT_VINTR);
 	}
 
-	/* We don't want to see VMMCALLs from a nested guest */
-	vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
+	/*
+	 * We want to see VMMCALLs from a nested guest only when Hyper-V L2 TLB
+	 * flush feature is enabled.
+	 */
+	if (!nested_svm_l2_tlb_flush_enabled(&svm->vcpu))
+		vmcb_clr_intercept(c, INTERCEPT_VMMCALL);
 
 	for (i = 0; i < MAX_INTERCEPT; i++)
 		c->intercepts[i] |= g->intercepts[i];
@@ -495,6 +499,17 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
 
 static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
+	 * L2's VP_ID upon request from the guest. Make sure we check for
+	 * pending entries for the case when the request got misplaced (e.g.
+	 * a transition from L2->L1 happened while processing L2 TLB flush
+	 * request or vice versa). kvm_hv_vcpu_flush_tlb() will not flush
+	 * anything if there are no requests in the corresponding buffer.
+	 */
+	if (to_hv_vcpu(vcpu))
+		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+
 	/*
 	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
 	 * things to fix before this can be conditional:
@@ -842,6 +857,12 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	/* This fails when VP assist page is enabled but the supplied GPA is bogus */
+	if (!nested_svm_hv_update_vp_assist(vcpu)) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
 	vmcb12_gpa = svm->vmcb->save.rax;
 	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
 	if (ret == -EINVAL) {
@@ -1419,6 +1440,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 int nested_svm_exit_special(struct vcpu_svm *svm)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	switch (exit_code) {
 	case SVM_EXIT_INTR:
@@ -1437,6 +1459,13 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 			return NESTED_EXIT_HOST;
 		break;
 	}
+	case SVM_EXIT_VMMCALL:
+		/* Hyper-V L2 TLB flush hypercall is handled by L0 */
+		if (guest_hv_cpuid_has_l2_tlb_flush(vcpu) &&
+		    nested_svm_l2_tlb_flush_enabled(vcpu) &&
+		    kvm_hv_is_tlb_flush_hcall(vcpu))
+			return NESTED_EXIT_HOST;
+		break;
 	default:
 		break;
 	}
@@ -1717,6 +1746,9 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 		return false;
 	}
 
+	if (!nested_svm_hv_update_vp_assist(vcpu))
+		return false;
+
 	return true;
 }
 
-- 
2.35.3

