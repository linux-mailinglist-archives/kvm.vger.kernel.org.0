Return-Path: <kvm+bounces-3504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB188050B9
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:40:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71F321F214D9
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 10:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D06059E50;
	Tue,  5 Dec 2023 10:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EEY8Zm55"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C162103
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 02:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701772610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NI1TJc8t5eL9B0jTTP9RnBbwrcKbiXY4kidmIJwOtOE=;
	b=EEY8Zm55UMUQdSHelryEPmHxxi2aqlITBQZO1JaZqFOFKdHj5nw27KFzxiG32NcSYk9xCQ
	zhYYxDOnlw9cZwI9k781hKu2vfxz5ZLzDypdbegE2FHyfjrE3mT0MfbtHUmwFGio7AI9n5
	lhm30BrigoAQaMg7/wfMIhnpAHkO6eo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-520-Jsen_j4GMU-UTPZndlto3g-1; Tue, 05 Dec 2023 05:36:47 -0500
X-MC-Unique: Jsen_j4GMU-UTPZndlto3g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BBF5101A52A;
	Tue,  5 Dec 2023 10:36:47 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.45.224.46])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3CFD92026D66;
	Tue,  5 Dec 2023 10:36:46 +0000 (UTC)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 14/16] KVM: nVMX: hyper-v: Introduce nested_vmx_evmcs() accessor
Date: Tue,  5 Dec 2023 11:36:28 +0100
Message-ID: <20231205103630.1391318-15-vkuznets@redhat.com>
In-Reply-To: <20231205103630.1391318-1-vkuznets@redhat.com>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

There's a number of 'vmx->nested.hv_evmcs' accesses in nested.c, introduce
'nested_vmx_evmcs()' accessor to hide them all in !CONFIG_KVM_HYPERV case.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/vmx/hyperv.h | 10 ++++++++++
 arch/x86/kvm/vmx/nested.c | 33 ++++++++++++++++++---------------
 2 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 71e90a16f183..a87407412615 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -37,6 +37,11 @@ static inline bool nested_vmx_is_evmptr12_set(struct vcpu_vmx *vmx)
 	return evmptr_is_set(vmx->nested.hv_evmcs_vmptr);
 }
 
+static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
+{
+	return vmx->nested.hv_evmcs;
+}
+
 static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -75,6 +80,11 @@ static inline bool nested_vmx_is_evmptr12_set(struct vcpu_vmx *vmx)
 {
 	return false;
 }
+
+static inline struct hv_enlightened_vmcs *nested_vmx_evmcs(struct vcpu_vmx *vmx)
+{
+	return NULL;
+}
 #endif
 
 #endif /* __KVM_X86_VMX_HYPERV_H */
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 0507174750e0..4e872863a0c9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -263,7 +263,7 @@ static bool nested_evmcs_handle_vmclear(struct kvm_vcpu *vcpu, gpa_t vmptr)
 	    !evmptr_is_valid(nested_get_evmptr(vcpu)))
 		return false;
 
-	if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr)
+	if (nested_vmx_evmcs(vmx) && vmptr == vmx->nested.hv_evmcs_vmptr)
 		nested_release_evmcs(vcpu);
 
 	return true;
@@ -601,7 +601,6 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	int msr;
 	unsigned long *msr_bitmap_l1;
 	unsigned long *msr_bitmap_l0 = vmx->nested.vmcs02.msr_bitmap;
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
 	struct kvm_host_map *map = &vmx->nested.msr_bitmap_map;
 
 	/* Nothing to do if the MSR bitmap is not in use.  */
@@ -617,10 +616,13 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
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
@@ -1603,7 +1605,7 @@ static void copy_enlightened_to_vmcs12(struct vcpu_vmx *vmx, u32 hv_clean_fields
 {
 #ifdef CONFIG_KVM_HYPERV
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 	struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(&vmx->vcpu);
 
 	/* HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE */
@@ -1851,7 +1853,7 @@ static void copy_vmcs12_to_enlightened(struct vcpu_vmx *vmx)
 {
 #ifdef CONFIG_KVM_HYPERV
 	struct vmcs12 *vmcs12 = vmx->nested.cached_vmcs12;
-	struct hv_enlightened_vmcs *evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 
 	/*
 	 * Should not be changed by KVM:
@@ -2438,7 +2440,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 
 static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
-	struct hv_enlightened_vmcs *hv_evmcs = vmx->nested.hv_evmcs;
+	struct hv_enlightened_vmcs *hv_evmcs = nested_vmx_evmcs(vmx);
 
 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
 			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2)) {
@@ -2570,6 +2572,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			  enum vm_entry_failure_code *entry_failure_code)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
 	bool load_guest_pdptrs_vmcs12 = false;
 
 	if (vmx->nested.dirty_vmcs12 || nested_vmx_is_evmptr12_valid(vmx)) {
@@ -2577,8 +2580,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmx->nested.dirty_vmcs12 = false;
 
 		load_guest_pdptrs_vmcs12 = !nested_vmx_is_evmptr12_valid(vmx) ||
-			!(vmx->nested.hv_evmcs->hv_clean_fields &
-			  HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
+			!(evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
 	}
 
 	if (vmx->nested.nested_run_pending &&
@@ -2700,8 +2702,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	 * here.
 	 */
 	if (nested_vmx_is_evmptr12_valid(vmx))
-		vmx->nested.hv_evmcs->hv_clean_fields |=
-			HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
+		evmcs->hv_clean_fields |= HV_VMX_ENLIGHTENED_CLEAN_FIELD_ALL;
 
 	return 0;
 }
@@ -3626,7 +3627,9 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return nested_vmx_failInvalid(vcpu);
 
 	if (nested_vmx_is_evmptr12_valid(vmx)) {
-		copy_enlightened_to_vmcs12(vmx, vmx->nested.hv_evmcs->hv_clean_fields);
+		struct hv_enlightened_vmcs *evmcs = nested_vmx_evmcs(vmx);
+
+		copy_enlightened_to_vmcs12(vmx, evmcs->hv_clean_fields);
 		/* Enlightened VMCS doesn't have launch state */
 		vmcs12->launch_state = !launch;
 	} else if (enable_shadow_vmcs) {
@@ -5428,7 +5431,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
 		/* Read the field, zero-extended to a u64 value */
-		value = evmcs_read_any(vmx->nested.hv_evmcs, field, offset);
+		value = evmcs_read_any(nested_vmx_evmcs(vmx), field, offset);
 	}
 
 	/*
-- 
2.43.0


