Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD5D7C0120
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 18:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbjJJQEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 12:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233826AbjJJQEI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 12:04:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB34C4
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 09:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696953794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DBhV11EAxX1BNBBhRLLQCznIsmIxdCkFw+7VBwqB4SE=;
        b=dLVX1j2IgnwdYb8GyIiMZKLkZ1J7LBQimnMqqQr6XlH6vmCu21n+cujoQvtdfQiq+asERk
        gcVFcfns8fyBECvACbMAN+CcpZcyQ0NwO+aPgWLtVCpkbAIv4vPM+htkg+EPbv9Nk2I6Sl
        1xlZ8mQ+ku9h6v37ZtMK4jl0rChuf8I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-BBe08SjHNwy3w5MeRmvBjA-1; Tue, 10 Oct 2023 12:03:12 -0400
X-MC-Unique: BBe08SjHNwy3w5MeRmvBjA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5E23185A7B3;
        Tue, 10 Oct 2023 16:03:11 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.166])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 221251B94;
        Tue, 10 Oct 2023 16:03:11 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH RFC 09/11] KVM: nVMX: hyper-v: Introduce nested_vmx_evmcs() accessor
Date:   Tue, 10 Oct 2023 18:02:58 +0200
Message-ID: <20231010160300.1136799-10-vkuznets@redhat.com>
In-Reply-To: <20231010160300.1136799-1-vkuznets@redhat.com>
References: <20231010160300.1136799-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's a number of 'vmx->nested.hv_evmcs' accesses in nested.c, introduce
'nested_vmx_evmcs()' accessor to hide them all in !CONFIG_KVM_HYPERV case.

No functional change intended.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/hyperv.h |  8 ++++++++
 arch/x86/kvm/vmx/nested.c | 33 ++++++++++++++++++---------------
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 6ca5c8c5be9c..b07131a23250 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -25,6 +25,10 @@ struct vcpu_vmx;
 
 #ifdef CONFIG_KVM_HYPERV
 static inline gpa_t nested_vmx_evmptr(struct vcpu_vmx *vmx) { return vmx->nested.hv_evmcs_vmptr; }
+static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
+{
+	return vmx->nested.hv_evmcs;
+}
 u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
@@ -35,6 +39,10 @@ bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu);
 void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 #else
 static inline gpa_t nested_vmx_evmptr(struct vcpu_vmx *vmx) { return EVMPTR_INVALID; };
+static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
+{
+	return NULL;
+}
 static inline u64 nested_get_evmptr(struct kvm_vcpu *vcpu) { return EVMPTR_INVALID; }
 static inline void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata) {}
 static inline bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu) { return false; }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e6476f8e2ccd..d539904d8f1e 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -574,7 +574,6 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	int msr;
 	unsigned long *msr_bitmap_l1;
 	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
 	struct kvm_host_map *map = &vmx->nested.msr_bitmap_map;
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
@@ -590,10 +589,13 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	 * - Nested hypervisor (L1) has enabled 'Enlightened MSR Bitmap' feature
 	 *   and tells KVM (L0) there were no changes in MSR bitmap for L2.
 	 */
-	if (!vmx->nested.force_msr_bitmap_recalc && evmcs &&
-	    evmcs->hv_enlightenments_control.msr_bitmap &&
-	    evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP)
-		return true;
+	if (!vmx->nested.force_msr_bitmap_recalc) {
+		struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
+
+		if (evmcs && evmcs->hv_enlightenments_control.msr_bitmap &&
+		    evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP)
+			return true;
+	}
 
 	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcs12->msr_bitmap), map))
 		return false;
@@ -1584,7 +1586,7 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
 {
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
 
 	/* HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE */
@@ -1828,7 +1830,7 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 {
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 
 	/*
 	 * Should not be changed by KVM:
@@ -2412,7 +2414,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 
 static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
-	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
 			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
@@ -2544,6 +2546,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			  enum vm_entry_failure_code *entry_failure_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 	bool load_guest_pdptrs_vmcs12 = false;
 
 	if (vmx->nested.dirty_vmcs12 || evmptr_is_valid(nested_vmx_evmptr(vmx))) {
@@ -2551,8 +2554,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmx->nested.dirty_vmcs12 = false;
 
 		load_guest_pdptrs_vmcs12 = !evmptr_is_valid(nested_vmx_evmptr(vmx)) ||
-			!(vmx->nested.hv_evmcs->hv_clean_fields &
-			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
+			!(evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
 	}
 
 	if (vmx->nested.nested_run_pending &&
@@ -2674,8 +2676,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * here.
 	 */
 	if (evmptr_is_valid(nested_vmx_evmptr(vmx)))
-		vmx->nested.hv_evmcs->hv_clean_fields |=
-			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
+		evmcs->hv_clean_fields |= HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
 	return 0;
 }
@@ -3600,7 +3601,9 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return nested_vmx_failInvalid(vcpu);
 
 	if (evmptr_is_valid(nested_vmx_evmptr(vmx))) {
-		copy_enlightened_to_vmcs12(vmx, vmx->nested.hv_evmcs->hv_clean_fields);
+		struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
+
+		copy_enlightened_to_vmcs12(vmx, evmcs->hv_clean_fields);
 		/* Enlightened VMCS doesn't have launch state */
 		vmcs12->launch_state = !launch;
 	} else if (enable_shadow_vmcs) {
@@ -5335,7 +5338,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 					   vmptr + offsetof(struct vmcs12,
 							    launch_state),
 					   &zero, sizeof(zero));
-	} else if (vmx->nested.hv_evmcs && vmptr == nested_vmx_evmptr(vmx)) {
+	} else if (nested_vmx_evmcs(vmx) && vmptr == nested_vmx_evmptr(vmx)) {
 		nested_release_evmcs(vcpu);
 	}
 
@@ -5413,7 +5416,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
 		/* Read the field, zero-extended to a u64 value */
-		value = evmcs_read_any(vmx->nested.hv_evmcs, field, offset);
+		value = evmcs_read_any(nested_vmx_evmcs(vmx), field, offset);
 	}
 
 	/*
-- 
2.41.0

