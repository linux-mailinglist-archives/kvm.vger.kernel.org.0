Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF41B607B15
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiJUPiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiJUPg4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:36:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8051526FFB2
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KFc1S2IlLQOyGIVO5iuPe0nlFEgjP4Bt7b+Tr05r4u8=;
        b=Fw4YNy2OdbqXj7FD/rRIHTeDM2AQxql57fYQqTPKoiwuR1BxPTV7ByDI6KrIvpMUhBFPoz
        nVkjK6GW2UjVkx8EkmBb52OKyN8RgpHc/d4g9MZFKo1yqU+P7vNqXJJcItuDo3SivWzGfK
        fUN5BnmRhtZF3+d4aGxni+fWqCJ9p+8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-LSFCs4-cNDOkChU_UuBoAg-1; Fri, 21 Oct 2022 11:36:35 -0400
X-MC-Unique: LSFCs4-cNDOkChU_UuBoAg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E78C101A52A;
        Fri, 21 Oct 2022 15:36:34 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1340640CA41F;
        Fri, 21 Oct 2022 15:36:31 +0000 (UTC)
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
Subject: [PATCH v12 28/46] KVM: nSVM: hyper-v: Enable L2 TLB flush
Date:   Fri, 21 Oct 2022 17:35:03 +0200
Message-Id: <20221021153521.1216911-29-vkuznets@redhat.com>
In-Reply-To: <20221021153521.1216911-1-vkuznets@redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/hyperv-tlfs.h |  4 ++++
 arch/x86/kvm/hyperv.h              | 11 ++++++++++
 arch/x86/kvm/svm/hyperv.c          |  7 ++++++
 arch/x86/kvm/svm/hyperv.h          | 15 +++++++++++++
 arch/x86/kvm/svm/nested.c          | 35 ++++++++++++++++++++++++++++--
 5 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index b25c6792d409..e3efaf6e6b62 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -631,6 +631,10 @@ struct hv_vmcb_enlightenments {
  */
 #define HV_VMCB_NESTED_ENLIGHTENMENTS		31
 
+/* Synthetic VM-Exit */
+#define HV_SVM_EXITCODE_ENL			0xf0000000
+#define HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH	(1)
+
 struct hv_partition_assist_pg {
 	u32 tlb_lock_count;
 };
diff --git a/arch/x86/kvm/hyperv.h b/arch/x86/kvm/hyperv.h
index 5157622c2fb3..9f96414a31c5 100644
--- a/arch/x86/kvm/hyperv.h
+++ b/arch/x86/kvm/hyperv.h
@@ -198,6 +198,17 @@ static inline bool kvm_hv_is_tlb_flush_hcall(struct kvm_vcpu *vcpu)
 		code == HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX);
 }
 
+static inline int kvm_hv_verify_vp_assist(struct kvm_vcpu *vcpu)
+{
+	if (!to_hv_vcpu(vcpu))
+		return 0;
+
+	if (!kvm_hv_assist_page_enabled(vcpu))
+		return 0;
+
+	return kvm_hv_get_assist_page(vcpu);
+}
+
 int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu);
 
 #endif
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
index 7564bdf652e4..02f4784b5d44 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -25,6 +25,21 @@ static inline void nested_svm_hv_update_vm_vp_ids(struct kvm_vcpu *vcpu)
 	hv_vcpu->nested.vp_id = hve->hv_vp_id;
 }
 
+static inline bool nested_svm_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct hv_vmcb_enlightenments *hve = &svm->nested.ctl.hv_enlightenments;
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
index 05889d5a8629..8f67b8fb3c1f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -149,8 +149,12 @@ void recalc_intercepts(struct vcpu_svm *svm)
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
@@ -472,6 +476,15 @@ static void nested_save_pending_event_to_vmcb12(struct vcpu_svm *svm,
 
 static void nested_svm_transition_tlb_flush(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * KVM_REQ_HV_TLB_FLUSH flushes entries from either L1's VP_ID or
+	 * L2's VP_ID upon request from the guest. Make sure we check for
+	 * pending entries in the right FIFO upon L1/L2 transition as these
+	 * requests are put by other vCPUs asynchronously.
+	 */
+	if (to_hv_vcpu(vcpu) && npt_enabled)
+		kvm_make_request(KVM_REQ_HV_TLB_FLUSH, vcpu);
+
 	/*
 	 * TODO: optimize unconditional TLB flush/MMU sync.  A partial list of
 	 * things to fix before this can be conditional:
@@ -823,6 +836,13 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
+	/* This fails when VP assist page is enabled but the supplied GPA is bogus */
+	ret = kvm_hv_verify_vp_assist(vcpu);
+	if (ret) {
+		kvm_inject_gp(vcpu, 0);
+		return ret;
+	}
+
 	vmcb12_gpa = svm->vmcb->save.rax;
 	ret = kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map);
 	if (ret == -EINVAL) {
@@ -1412,6 +1432,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 int nested_svm_exit_special(struct vcpu_svm *svm)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	switch (exit_code) {
 	case SVM_EXIT_INTR:
@@ -1430,6 +1451,13 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
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
@@ -1710,6 +1738,9 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 		return false;
 	}
 
+	if (kvm_hv_verify_vp_assist(vcpu))
+		return false;
+
 	return true;
 }
 
-- 
2.37.3

