Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B362536564
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 17:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353958AbiE0P5n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 11:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353956AbiE0P5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 11:57:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 04B5F69CE8
        for <kvm@vger.kernel.org>; Fri, 27 May 2022 08:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653667012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DBrj6K8vplqOp0UwgYRkwC65VWJ6mgTBlpv51USFjc4=;
        b=BKwHjTNtqIzCfbb0VUDmuXAj13ArB9EHxzgIOvOBnIQP2QWz8OlTCXXk36J46Hitj8p9/a
        JZDw5UkyY4dLy943GiFgD8989wXfClRq96zwE5S7yUxxaIU6XEDWdgYFenRhauOlMQC4D6
        g2C/3hc/DQ5AEn8BSLx7SfNJgLv/8iI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-KH0FUXefObSKHeS-ovqGNw-1; Fri, 27 May 2022 11:56:47 -0400
X-MC-Unique: KH0FUXefObSKHeS-ovqGNw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D8A8B80088A;
        Fri, 27 May 2022 15:56:46 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.192.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98FB72166B26;
        Fri, 27 May 2022 15:56:44 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 21/37] KVM: nSVM: hyper-v: Enable L2 TLB flush
Date:   Fri, 27 May 2022 17:55:30 +0200
Message-Id: <20220527155546.1528910-22-vkuznets@redhat.com>
In-Reply-To: <20220527155546.1528910-1-vkuznets@redhat.com>
References: <20220527155546.1528910-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement Hyper-V L2 TLB flush for nSVM. The feature needs to be enabled
both in extended 'nested controls' in VMCB and partition assist page.
According to Hyper-V TLFS, synthetic vmexit to L1 is performed with
- HV_SVM_EXITCODE_ENL exit_code.
- HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH exit_info_1.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/svm/hyperv.c |  7 +++++++
 arch/x86/kvm/svm/hyperv.h | 19 +++++++++++++++++++
 arch/x86/kvm/svm/nested.c | 27 +++++++++++++++++++++++++--
 3 files changed, 51 insertions(+), 2 deletions(-)

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
index dd2e393f84a0..6ea78499e21b 100644
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
@@ -48,6 +51,22 @@ static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
 	hv_vcpu->nested.vp_id = hve->hv_vp_id;
 }
 
+static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct hv_enlightenments *hve =
+		(struct hv_enlightenments *)svm->nested.ctl.reserved_sw;
+	struct hv_vp_assist_page assist_page;
+
+	if (unlikely(!kvm_hv_get_assist_page(vcpu, &assist_page)))
+		return false;
+
+	if (!hve->hv_enlightenments_control.nested_flush_hypercall)
+		return false;
+
+	return assist_page.nested_control.features.directhypercall;
+}
+
 void svm_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 
 #endif /* __ARCH_X86_KVM_SVM_HYPERV_H__ */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b203e6cd75dc..083b95d85495 100644
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
@@ -489,6 +493,17 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
 
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
@@ -1409,6 +1424,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 int nested_svm_exit_special(struct vcpu_svm *svm)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	switch (exit_code) {
 	case SVM_EXIT_INTR:
@@ -1427,6 +1443,13 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
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
-- 
2.35.3

