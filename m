Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60457D70DA
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 17:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344752AbjJYP0l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 11:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbjJYP0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 11:26:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814E818D
        for <kvm@vger.kernel.org>; Wed, 25 Oct 2023 08:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698247465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zI/VC2yoZ+8K7qGGJ85RQKZAwgK3E15b0Oz0tzA9/aw=;
        b=bbTFX5QUoQAxDalouodhQXekQ/cVkHCBFHSAX1lwui3cNMYlV6QJfnR4ok/UNXLZ1gE2yo
        wOYpOxIdGjVFzECtj2ia01RxBdcvmdEhtBD4VIvBlN1eWF/KQ4xZp7qVjx737u6oWEN+zA
        0Es8anZAuVVBT9tKS5msdLv86euACU4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-qovSDM--Mu-PB8uum3NH1Q-1; Wed, 25 Oct 2023 11:24:22 -0400
X-MC-Unique: qovSDM--Mu-PB8uum3NH1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 04021101A53B;
        Wed, 25 Oct 2023 15:24:22 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.226.101])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 174102166B26;
        Wed, 25 Oct 2023 15:24:20 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH 12/14] KVM: nVMX: hyper-v: Introduce nested_vmx_evmcs() accessor
Date:   Wed, 25 Oct 2023 17:24:04 +0200
Message-ID: <20231025152406.1879274-13-vkuznets@redhat.com>
In-Reply-To: <20231025152406.1879274-1-vkuznets@redhat.com>
References: <20231025152406.1879274-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's a number of 'vmx->nested.hv_evmcs' accesses in nested.c, introduce
'nested_vmx_evmcs()' accessor to hide them all in !CONFIG_KVM_HYPERV case.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/hyperv.h |  8 ++++++++
 arch/x86/kvm/vmx/nested.c | 33 ++++++++++++++++++---------------
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index ba1a95ea72b7..92bde3b75ca0 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -29,6 +29,10 @@ static inline bool nested_vmx_is_evmptr12_valid(struct vcpu_vmx *vmx)
 {
 	return evmptr_is_valid(vmx->nested.hv_evmcs_vmptr);
 }
+static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
+{
+	return vmx->nested.hv_evmcs;
+}
 u64 nested_get_evmptr(struct kvm_vcpu *vcpu);
 uint16_t nested_get_evmcs_version(struct kvm_vcpu *vcpu);
 int nested_enable_evmcs(struct kvm_vcpu *vcpu,
@@ -40,6 +44,10 @@ void vmx_hv_inject_synthetic_vmexit_post_tlb_flush(struct kvm_vcpu *vcpu);
 #else
 static inline gpa_t nested_vmx_evmptr12(struct vcpu_vmx *vmx) { return EVMPTR_INVALID; }
 static inline bool nested_vmx_is_evmptr12_valid(struct vcpu_vmx *vmx) { return false; }
+static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
+{
+	return NULL;
+}
 static inline u64 nested_get_evmptr(struct kvm_vcpu *vcpu) { return EVMPTR_INVALID; }
 static inline void nested_evmcs_filter_control_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 *pdata) {}
 static inline bool nested_evmcs_l2_tlb_flush_enabled(struct kvm_vcpu *vcpu) { return false; }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b45586588bae..fa04aa38ad52 100644
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
@@ -1576,7 +1578,7 @@ static void copy_vmcs12_to_shadow(struct vcpu_vmx *vmx)
 static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields)
 {
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
 
 	/* HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE */
@@ -1820,7 +1822,7 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 {
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 
 	/*
 	 * Should not be changed by KVM:
@@ -2404,7 +2406,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 
 static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
-	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
 			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
@@ -2536,6 +2538,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			  enum vm_entry_failure_code *entry_failure_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 	bool load_guest_pdptrs_vmcs12 = false;
 
 	if (vmx->nested.dirty_vmcs12 || nested_vmx_is_evmptr12_valid(vmx)) {
@@ -2543,8 +2546,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmx->nested.dirty_vmcs12 = false;
 
 		load_guest_pdptrs_vmcs12 = !nested_vmx_is_evmptr12_valid(vmx) ||
-			!(vmx->nested.hv_evmcs->hv_clean_fields &
-			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
+			!(evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
 	}
 
 	if (vmx->nested.nested_run_pending &&
@@ -2666,8 +2668,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * here.
 	 */
 	if (nested_vmx_is_evmptr12_valid(vmx))
-		vmx->nested.hv_evmcs->hv_clean_fields |=
-			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
+		evmcs->hv_clean_fields |= HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
 	return 0;
 }
@@ -3592,7 +3593,9 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return nested_vmx_failInvalid(vcpu);
 
 	if (nested_vmx_is_evmptr12_valid(vmx)) {
-		copy_enlightened_to_vmcs12(vmx, vmx->nested.hv_evmcs->hv_clean_fields);
+		struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
+
+		copy_enlightened_to_vmcs12(vmx, evmcs->hv_clean_fields);
 		/* Enlightened VMCS doesn't have launch state */
 		vmcs12->launch_state = !launch;
 	} else if (enable_shadow_vmcs) {
@@ -5327,7 +5330,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 					   vmptr + offsetof(struct vmcs12,
 							    launch_state),
 					   &zero, sizeof(zero));
-	} else if (vmx->nested.hv_evmcs && vmptr == nested_vmx_evmptr12(vmx)) {
+	} else if (nested_vmx_evmcs(vmx) && vmptr == nested_vmx_evmptr12(vmx)) {
 		nested_release_evmcs(vcpu);
 	}
 
@@ -5405,7 +5408,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
 		/* Read the field, zero-extended to a u64 value */
-		value = evmcs_read_any(vmx->nested.hv_evmcs, field, offset);
+		value = evmcs_read_any(nested_vmx_evmcs(vmx), field, offset);
 	}
 
 	/*
-- 
2.41.0

