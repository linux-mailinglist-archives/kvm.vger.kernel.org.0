Return-Path: <kvm+bounces-42046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B94EA71F3C
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 20:37:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B739E189858E
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 19:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F9A9255E34;
	Wed, 26 Mar 2025 19:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LCRwTGxR"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D34202F92
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 19:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743017810; cv=none; b=uD5UP6RDV/bFZ+Pi8wp1zHSxEOxF3m8SSD4EnMZGGTGv/DqXuI6jOpy1bC0jNvdg/RO2yNyfZRvEBkY8E/NR8O/qW+xY/Kqd+3FJNkebdVl8skpafFKY4CumimsDhKO4S5E8Mg+HpT8TyPaqES80BKXb88i4POAUMkfCRoMKYks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743017810; c=relaxed/simple;
	bh=wS8Fj3lF0J/H8NStgvHWUEKQxBbd2Wizocq8j0bjPDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwIYisfrzAsujZM45890isTMX1en7xueqKqA+CQKotEgwtEGsJ48N375kTBZy6ToAFHc4vztKIi6dvgX7Mqm+wGXZXJyMXhT3y5ygn8WyIQ608AaQl3OFXl3qARlBvH2O8SU3DtiZKsXGXsPrmCqGcCgb6hgM51miv4k9Dr1MHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LCRwTGxR; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1743017805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ng4dj7CrWMILMbbGZtr2IN22j45SzGtlOfPPpE4xLsc=;
	b=LCRwTGxRtjMnsugJoxYbRlACNYK7BKNKIGuiSx+nkC3r/v8REZffIW/SjLJuyUtZbmnluW
	F15kkyjFwQnjwPUaaxQD8Wwnm8zqs3gOy/gtbu7o8acjOg3lRN4YmVjrbXT5rhrHcrnWU1
	dCgkAV1hrYShmrvnuqgmdjUg57a7ZrU=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Rik van Riel <riel@surriel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [RFC PATCH 01/24] KVM: VMX: Generalize VPID allocation to be vendor-neutral
Date: Wed, 26 Mar 2025 19:35:56 +0000
Message-ID: <20250326193619.3714986-2-yosry.ahmed@linux.dev>
In-Reply-To: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Generalize the VMX VPID allocation code and make move it to common code
in preparation for sharing with SVM. Create a generic struct
kvm_tlb_tags, representing a factory for VPIDs (or ASIDs later), and use
one for VPIDs.

Most of the functionality remains the same, with the following
differences:
- The enable_vpid checks are moved to the callers for allocate_vpid()
  and free_vpid(), as they are specific to VMX.
- The bitmap allocation is now dynamic (which will be required for SVM),
  so it is initialized and cleaned up in vmx_hardware_{setup/unsetup}().
- The range of valid TLB tags is expressed in terms of min/max instead
  of the number of tags to support SVM use cases.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/kvm/vmx/nested.c |  4 +--
 arch/x86/kvm/vmx/vmx.c    | 38 +++++--------------------
 arch/x86/kvm/vmx/vmx.h    |  4 +--
 arch/x86/kvm/x86.c        | 58 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h        | 13 +++++++++
 5 files changed, 82 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d06e50d9c0e79..b017bd2eb2382 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -343,7 +343,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;
 	vmx->nested.vmxon_ptr = INVALID_GPA;
-	free_vpid(vmx->nested.vpid02);
+	kvm_tlb_tags_free(&vmx_vpids, vmx->nested.vpid02);
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = INVALID_GPA;
 	if (enable_shadow_vmcs) {
@@ -5333,7 +5333,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 		     HRTIMER_MODE_ABS_PINNED);
 	vmx->nested.preemption_timer.function = vmx_preemption_timer_fn;
 
-	vmx->nested.vpid02 = allocate_vpid();
+	vmx->nested.vpid02 = enable_vpid ? kvm_tlb_tags_alloc(&vmx_vpids) : 0;
 
 	vmx->nested.vmcs02_initialized = false;
 	vmx->nested.vmxon = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b70ed72c1783d..f7ce75842fa26 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -496,8 +496,7 @@ DEFINE_PER_CPU(struct vmcs *, current_vmcs);
  */
 static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 
-static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
-static DEFINE_SPINLOCK(vmx_vpid_lock);
+struct kvm_tlb_tags vmx_vpids;
 
 struct vmcs_config vmcs_config __ro_after_init;
 struct vmx_capability vmx_capability __ro_after_init;
@@ -3972,31 +3971,6 @@ static void seg_setup(int seg)
 	vmcs_write32(sf->ar_bytes, ar);
 }
 
-int allocate_vpid(void)
-{
-	int vpid;
-
-	if (!enable_vpid)
-		return 0;
-	spin_lock(&vmx_vpid_lock);
-	vpid = find_first_zero_bit(vmx_vpid_bitmap, VMX_NR_VPIDS);
-	if (vpid < VMX_NR_VPIDS)
-		__set_bit(vpid, vmx_vpid_bitmap);
-	else
-		vpid = 0;
-	spin_unlock(&vmx_vpid_lock);
-	return vpid;
-}
-
-void free_vpid(int vpid)
-{
-	if (!enable_vpid || vpid == 0)
-		return;
-	spin_lock(&vmx_vpid_lock);
-	__clear_bit(vpid, vmx_vpid_bitmap);
-	spin_unlock(&vmx_vpid_lock);
-}
-
 static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
 {
 	/*
@@ -7559,7 +7533,7 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 
 	if (enable_pml)
 		vmx_destroy_pml_buffer(vmx);
-	free_vpid(vmx->vpid);
+	kvm_tlb_tags_free(&vmx_vpids, vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
 	free_page((unsigned long)vmx->ve_info);
@@ -7578,7 +7552,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	err = -ENOMEM;
 
-	vmx->vpid = allocate_vpid();
+	vmx->vpid = enable_vpid ? kvm_tlb_tags_alloc(&vmx_vpids) : 0;
 
 	/*
 	 * If PML is turned on, failure on enabling PML just results in failure
@@ -7681,7 +7655,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 free_pml:
 	vmx_destroy_pml_buffer(vmx);
 free_vpid:
-	free_vpid(vmx->vpid);
+	kvm_tlb_tags_free(&vmx_vpids, vmx->vpid);
 	return err;
 }
 
@@ -8373,6 +8347,7 @@ void vmx_hardware_unsetup(void)
 		nested_vmx_hardware_unsetup();
 
 	free_kvm_area();
+	kvm_tlb_tags_destroy(&vmx_vpids);
 }
 
 void vmx_vm_destroy(struct kvm *kvm)
@@ -8591,7 +8566,8 @@ __init int vmx_hardware_setup(void)
 	kvm_caps.has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
 	kvm_caps.has_notify_vmexit = cpu_has_notify_vmexit();
 
-	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
+	/* VPID 0 is reserved for host, so min=1  */
+	kvm_tlb_tags_init(&vmx_vpids, 1, VMX_NR_VPIDS - 1);
 
 	if (enable_ept)
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 951e44dc9d0ea..9bece3ea63eaa 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -376,10 +376,10 @@ struct kvm_vmx {
 	u64 *pid_table;
 };
 
+extern struct kvm_tlb_tags vmx_vpids;
+
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
 			struct loaded_vmcs *buddy);
-int allocate_vpid(void);
-void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 69c20a68a3f01..182f18ebc62f3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13992,6 +13992,64 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+int kvm_tlb_tags_init(struct kvm_tlb_tags *tlb_tags, unsigned int min,
+		      unsigned int max)
+{
+	/*
+	 * 0 is assumed to be the host's TLB tag and is returned on failed
+	 * allocations.
+	 */
+	if (WARN_ON_ONCE(min == 0))
+		return -1;
+
+	/*
+	 * Allocate enough bits to index the bitmap directly by the tag,
+	 * potentially wasting a bit of memory.
+	 */
+	tlb_tags->bitmap = bitmap_zalloc(max + 1, GFP_KERNEL);
+	if (!tlb_tags->bitmap)
+		return -1;
+
+	tlb_tags->min = min;
+	tlb_tags->max = max;
+	spin_lock_init(&tlb_tags->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_tlb_tags_init);
+
+void kvm_tlb_tags_destroy(struct kvm_tlb_tags *tlb_tags)
+{
+	bitmap_free(tlb_tags->bitmap);
+}
+EXPORT_SYMBOL_GPL(kvm_tlb_tags_destroy);
+
+unsigned int kvm_tlb_tags_alloc(struct kvm_tlb_tags *tlb_tags)
+{
+	unsigned int tag;
+
+	spin_lock(&tlb_tags->lock);
+	tag = find_next_zero_bit(tlb_tags->bitmap, tlb_tags->max + 1,
+				 tlb_tags->min);
+	if (tag <= tlb_tags->max)
+		__set_bit(tag, tlb_tags->bitmap);
+	else
+		tag = 0;
+	spin_unlock(&tlb_tags->lock);
+	return tag;
+}
+EXPORT_SYMBOL_GPL(kvm_tlb_tags_alloc);
+
+void kvm_tlb_tags_free(struct kvm_tlb_tags *tlb_tags, unsigned int tag)
+{
+	if (tag < tlb_tags->min || WARN_ON_ONCE(tag > tlb_tags->max))
+		return;
+
+	spin_lock(&tlb_tags->lock);
+	__clear_bit(tag, tlb_tags->bitmap);
+	spin_unlock(&tlb_tags->lock);
+}
+EXPORT_SYMBOL_GPL(kvm_tlb_tags_free);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9dc32a4090761..9f84e933d189b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -652,4 +652,17 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
+struct kvm_tlb_tags {
+	spinlock_t	lock;
+	unsigned long	*bitmap;
+	unsigned int	min;
+	unsigned int	max;
+};
+
+int kvm_tlb_tags_init(struct kvm_tlb_tags *tlb_tags, unsigned int min,
+		      unsigned int max);
+void kvm_tlb_tags_destroy(struct kvm_tlb_tags *tlb_tags);
+unsigned int kvm_tlb_tags_alloc(struct kvm_tlb_tags *tlb_tags);
+void kvm_tlb_tags_free(struct kvm_tlb_tags *tlb_tags, unsigned int tag);
+
 #endif
-- 
2.49.0.395.g12beb8f557-goog


