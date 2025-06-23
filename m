Return-Path: <kvm+bounces-50390-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C1DABAE4B4A
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 18:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 405417A95D4
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 16:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B260274FE3;
	Mon, 23 Jun 2025 16:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sHrbiGG8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C794A27A12C
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 16:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750697095; cv=none; b=LAZXSiHR1/yywttIkVY1MWeYD6LDP8vSupGptjSx8jTx+z4uGNA6T5ruSkibvLe2Y8lUr40wQhhqNGEnri9DLWIrIWYpmVaIvf4yNjWIOHRJ7lHWAs8maQiuy+z7psSU+i8wAh/lLFrQtDidpzydH++lu3AvFD9buwNaCXsNTsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750697095; c=relaxed/simple;
	bh=R9K4m09udi+0sMcSNQK1kQmf4YD66o0JqyIRS0dQpK0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EgFpQQJwWv+ZV0QF1i7KjLrJ7i1MEBNwOjH2m24+jY8Ufo8QdWH7hIENTju7DY8kq5WFB2ikNeNApzcVNB3l24jmSycj/QLE/pZd9GTIHTOYKx/IW/25RpNHKqUHjceGNnu2Kq+w7IQxJZMYLRrdCDfpY1cdm4tZxYFXgQPQxKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sHrbiGG8; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3122368d82bso6410398a91.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 09:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750697093; x=1751301893; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EtqRjZBGHHt/HAYBxBNK67aTSi+qEb7ysAn9P7r+YL4=;
        b=sHrbiGG8/zPtPikSJja90IQvXAFyWDwztNIRXQJsdgpC/Xc5QJNoQfSGOfyJzEt4qM
         V572BKNb1+bt1/G5wQ5d0t8ZUoTkShwumFXrcuLbaihxIzlvm/k3qatlRZrX+uhyAM/H
         iqXDbyU1mOBkICpGLX2A8UdoTcLyrvw+hyINdtsLBEgbNSJYXaoV2SdGRvrWnF5FbAWw
         M7tKOxnv+79Oyg8C+TI2qySfXmHTKSKqv39bqQU/DndPSROztMsUeWk1Pi4EpxE3Ea9A
         WhJ/U2rqrTX9u3pMGzqZkmIUbH1pWZS6CGDFIGIlzSdnGnkzSorVe2AOoqVF84a87JJC
         hhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750697093; x=1751301893;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EtqRjZBGHHt/HAYBxBNK67aTSi+qEb7ysAn9P7r+YL4=;
        b=BfL0BT0yDqjLnoE1Rq5Bi6yjq3ol5uXcWaIy/a2YoA6L+7yofOLIMhhZfSUIc2Nnhb
         xTOzmnzildnG3EDbfIOg9lzUJju/TLEPHuUU/MbKA+dnxX6XTV8OE9KPjJG5w0yGQTWH
         5qlD+X0yDo26DQzOyA+gC67OHvjLnXaFjftsDHejtE19D6ozfnR7f8zJXRFwNVCyrZt6
         31m45UhDAjZiET28LFpmISHJrqVj4E4jEu39QarLNhS3rV6nbgAx3rz9Kgc73Y6qTWWB
         IdiRL/tBTKAXCWzByJoBUJhJU5JBiMiaEt8H5f7sSdU90bFpjnoKhAhnNmXtWMKhEqZT
         he6A==
X-Forwarded-Encrypted: i=1; AJvYcCUUKuIyXi9SLgO8CNV3OLYhhZWXEHS8QxbxgOulyzvn6SQD5wSFxawdEo1I3HtD2cF47B4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0RpGNCmFZOY21Sl81cRyGwD9hmIGhcwGVRQen/aZG4EH4nK0R
	4p5pQ/AIfE9Mmc2GeNgW2tPify52tLJzzKkM2mOeeagCDJiui37jQehqcgW87ud0dlLfM+YRJhO
	SNGTxGQ==
X-Google-Smtp-Source: AGHT+IFGE7oloPpGbkkEZNZWS1a26xilhGzB63CfGjKyoBorkc/mB5YwBvxpZAKN5jqQR+Na0fc+PsM0cj4=
X-Received: from pjn14.prod.google.com ([2002:a17:90b:570e:b0:312:1e70:e233])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3cd0:b0:311:fde5:c4b6
 with SMTP id 98e67ed59e1d1-3159d6260admr16331009a91.6.1750697093101; Mon, 23
 Jun 2025 09:44:53 -0700 (PDT)
Date: Mon, 23 Jun 2025 09:44:51 -0700
In-Reply-To: <20250326193619.3714986-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250326193619.3714986-1-yosry.ahmed@linux.dev> <20250326193619.3714986-2-yosry.ahmed@linux.dev>
Message-ID: <aFmEgxB7EWvEOixP@google.com>
Subject: Re: [RFC PATCH 01/24] KVM: VMX: Generalize VPID allocation to be vendor-neutral
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Rik van Riel <riel@surriel.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Mar 26, 2025, Yosry Ahmed wrote:
> Generalize the VMX VPID allocation code and make move it to common code
> in preparation for sharing with SVM. Create a generic struct
> kvm_tlb_tags, representing a factory for VPIDs (or ASIDs later), and use
> one for VPIDs.

I don't see any reason in creating a factory, just have common KVM provide the
structure.


> Most of the functionality remains the same, with the following
> differences:
> - The enable_vpid checks are moved to the callers for allocate_vpid()
>   and free_vpid(), as they are specific to VMX.
> - The bitmap allocation is now dynamic (which will be required for SVM),
>   so it is initialized and cleaned up in vmx_hardware_{setup/unsetup}().
> - The range of valid TLB tags is expressed in terms of min/max instead
>   of the number of tags to support SVM use cases.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/vmx/nested.c |  4 +--
>  arch/x86/kvm/vmx/vmx.c    | 38 +++++--------------------
>  arch/x86/kvm/vmx/vmx.h    |  4 +--
>  arch/x86/kvm/x86.c        | 58 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.h        | 13 +++++++++
>  5 files changed, 82 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d06e50d9c0e79..b017bd2eb2382 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -343,7 +343,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
>  	vmx->nested.vmxon = false;
>  	vmx->nested.smm.vmxon = false;
>  	vmx->nested.vmxon_ptr = INVALID_GPA;
> -	free_vpid(vmx->nested.vpid02);
> +	kvm_tlb_tags_free(&vmx_vpids, vmx->nested.vpid02);
>  	vmx->nested.posted_intr_nv = -1;
>  	vmx->nested.current_vmptr = INVALID_GPA;
>  	if (enable_shadow_vmcs) {
> @@ -5333,7 +5333,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
>  		     HRTIMER_MODE_ABS_PINNED);
>  	vmx->nested.preemption_timer.function = vmx_preemption_timer_fn;
>  
> -	vmx->nested.vpid02 = allocate_vpid();
> +	vmx->nested.vpid02 = enable_vpid ? kvm_tlb_tags_alloc(&vmx_vpids) : 0;

Since the tag allocator already needs to handle "no tag available", it should also
handle the "tagging" not enabled scenario.  That way this can simply be:

	vmx->nested.vpid02 = kvm_tlb_tags_alloc(&vmx_vpids);

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 69c20a68a3f01..182f18ebc62f3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13992,6 +13992,64 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>  
> +int kvm_tlb_tags_init(struct kvm_tlb_tags *tlb_tags, unsigned int min,
> +		      unsigned int max)

I'd much prefer we don't create a "kvm_tlb_tags" namespace, and insteaad go with:

  kvm_init_tlb_tags()
  kvm_alloc_tlb_tag()
  kvm_free_tlb_tag()

Because kvm_tlb_tags_alloc() in particular reads like it allocates *multiple*
tags.

I also think it's probably worth a typedef for the tag, mostly to help with
understanding what's being pased around, e.g.

typedef unsigned int kvm_tlb_tag_t;

void kvm_init_tlb_tags(kvm_tlb_tag_t min, kvm_tlb_tag_t max);
kvm_tlb_tag_t kvm_alloc_tlb_tag(void);
void kvm_free_tlb_tag(kvm_tlb_tag_t tag);

> +{
> +	/*
> +	 * 0 is assumed to be the host's TLB tag and is returned on failed

Not assumed, *is*.

> +	 * allocations.
> +	 */
> +	if (WARN_ON_ONCE(min == 0))
> +		return -1;
> +
> +	/*
> +	 * Allocate enough bits to index the bitmap directly by the tag,
> +	 * potentially wasting a bit of memory.
> +	 */
> +	tlb_tags->bitmap = bitmap_zalloc(max + 1, GFP_KERNEL);

Rather than blindly allocate SVM's theoretical max of 4 *billion* tags, I think
we should statically reserve space for 65k tags, i.e. for the max possible VMX
VPID.

As mentioned in a different reply, current AMD CPUs support 32k ASIDs, so in
practice it's not even a meaningful limit.  And I strongly suspect that pushing
past ~4k active vCPUs, let alone 32k vCPUs, will run into other bottlenecks long
before the number of ASIDs becomes problematic.

That way KVM doesn't need to bail on failure, or as is done for VMX, silently
disable VPID usage.

Untested, but this is what I'm thinking:

---
 arch/x86/kvm/mmu.h        |  6 ++++
 arch/x86/kvm/mmu/mmu.c    | 61 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/nested.c |  4 +--
 arch/x86/kvm/vmx/vmx.c    | 38 +++++-------------------
 arch/x86/kvm/vmx/vmx.h    |  2 --
 5 files changed, 76 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b4b6860ab971..9e7343722530 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -78,6 +78,12 @@ static inline gfn_t kvm_mmu_max_gfn(void)
 
 u8 kvm_mmu_get_max_tdp_level(void);
 
+typedef unsigned int kvm_tlb_tag_t;
+
+void kvm_init_tlb_tags(kvm_tlb_tag_t min, kvm_tlb_tag_t max);
+kvm_tlb_tag_t kvm_alloc_tlb_tag(void);
+void kvm_free_tlb_tag(kvm_tlb_tag_t tag);
+
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
 void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
 void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e06e2e89a8f..e58d998ed10a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -121,6 +121,63 @@ static int max_tdp_level __read_mostly;
 
 #include <trace/events/kvm.h>
 
+#define KVM_MAX_TLB_TAG			0xffff
+
+struct kvm_tlb_tags {
+	spinlock_t	lock;
+	DECLARE_BITMAP(used, KVM_MAX_TLB_TAG + 1);
+	kvm_tlb_tag_t	min;
+	kvm_tlb_tag_t	max;
+};
+
+struct kvm_tlb_tags kvm_tlb_tags;
+
+void kvm_init_tlb_tags(kvm_tlb_tag_t min, kvm_tlb_tag_t max)
+{
+	/*
+	 * 0 is the host's TLB tag for both VMX's VPID and SVM's ASID, and is
+	 * returned on failed allocations, e.g. if there are no more tags left.
+	 */
+	if (WARN_ON_ONCE(!min || max < min))
+		return;
+
+	kvm_tlb_tags.min = min;
+	kvm_tlb_tags.max = min(max, KVM_MAX_TLB_TAG);
+}
+EXPORT_SYMBOL_GPL(kvm_init_tlb_tags);
+
+kvm_tlb_tag_t kvm_alloc_tlb_tag(void)
+{
+	struct kvm_tlb_tags *tags = &kvm_tlb_tags;
+	kvm_tlb_tag_t tag;
+
+	if (!kvm_tlb_tags.min)
+		return 0;
+
+	guard(spinlock)(&kvm_tlb_tags.lock);
+
+	tag = find_next_zero_bit(tags->used, tags->max + 1, tags->min);
+	if (tag > tags->max)
+		return 0;
+
+	__set_bit(tag, tags->used);
+	return tag;
+}
+EXPORT_SYMBOL_GPL(kvm_alloc_tlb_tag);
+
+void kvm_free_tlb_tag(kvm_tlb_tag_t tag)
+{
+	struct kvm_tlb_tags *tags = &kvm_tlb_tags;
+
+	if (!tag || WARN_ON_ONCE(tag < tags->min || tag > tags->max))
+		return;
+
+	guard(spinlock)(&tags->lock);
+
+	__clear_bit(tag, tags->used);
+}
+EXPORT_SYMBOL_GPL(kvm_free_tlb_tag);
+
 /* make pte_list_desc fit well in cache lines */
 #define PTE_LIST_EXT 14
 
@@ -7426,6 +7483,10 @@ int kvm_mmu_vendor_module_init(void)
 
 	kvm_mmu_reset_all_pte_masks();
 
+	kvm_tlb_tags.min = 0;
+	kvm_tlb_tags.max = 0;
+	bitmap_zero(kvm_tlb_tags.used, KVM_MAX_TLB_TAG + 1);
+
 	pte_list_desc_cache = KMEM_CACHE(pte_list_desc, SLAB_ACCOUNT);
 	if (!pte_list_desc_cache)
 		goto out;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 7211c71d4241..7f02dbe196e3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -344,7 +344,7 @@ static void free_nested(struct kvm_vcpu *vcpu)
 	vmx->nested.vmxon = false;
 	vmx->nested.smm.vmxon = false;
 	vmx->nested.vmxon_ptr = INVALID_GPA;
-	free_vpid(vmx->nested.vpid02);
+	kvm_tlb_tags_free(&vmx_vpids, vmx->nested.vpid02);
 	vmx->nested.posted_intr_nv = -1;
 	vmx->nested.current_vmptr = INVALID_GPA;
 	if (enable_shadow_vmcs) {
@@ -5333,7 +5333,7 @@ static int enter_vmx_operation(struct kvm_vcpu *vcpu)
 	hrtimer_setup(&vmx->nested.preemption_timer, vmx_preemption_timer_fn, CLOCK_MONOTONIC,
 		      HRTIMER_MODE_ABS_PINNED);
 
-	vmx->nested.vpid02 = allocate_vpid();
+	vmx->nested.vpid02 = kvm_alloc_tlb_tag();
 
 	vmx->nested.vmcs02_initialized = false;
 	vmx->nested.vmxon = true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4953846cb30d..4f3d78e71461 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -501,8 +501,7 @@ DEFINE_PER_CPU(struct vmcs *, current_vmcs);
  */
 static DEFINE_PER_CPU(struct list_head, loaded_vmcss_on_cpu);
 
-static DECLARE_BITMAP(vmx_vpid_bitmap, VMX_NR_VPIDS);
-static DEFINE_SPINLOCK(vmx_vpid_lock);
+struct kvm_tlb_tags vmx_vpids;
 
 struct vmcs_config vmcs_config __ro_after_init;
 struct vmx_capability vmx_capability __ro_after_init;
@@ -3970,31 +3969,6 @@ static void seg_setup(int seg)
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
@@ -7480,7 +7454,7 @@ void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 
 	if (enable_pml)
 		vmx_destroy_pml_buffer(vmx);
-	free_vpid(vmx->vpid);
+	kvm_tlb_tags_free(&vmx_vpids, vmx->vpid);
 	nested_vmx_free_vcpu(vcpu);
 	free_loaded_vmcs(vmx->loaded_vmcs);
 	free_page((unsigned long)vmx->ve_info);
@@ -7499,7 +7473,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	err = -ENOMEM;
 
-	vmx->vpid = allocate_vpid();
+	vmx->vpid = kvm_alloc_tlb_tag();
 
 	/*
 	 * If PML is turned on, failure on enabling PML just results in failure
@@ -7602,7 +7576,7 @@ int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 free_pml:
 	vmx_destroy_pml_buffer(vmx);
 free_vpid:
-	free_vpid(vmx->vpid);
+	kvm_tlb_tags_free(&vmx_vpids, vmx->vpid);
 	return err;
 }
 
@@ -8522,7 +8496,9 @@ __init int vmx_hardware_setup(void)
 	kvm_caps.has_bus_lock_exit = cpu_has_vmx_bus_lock_detection();
 	kvm_caps.has_notify_vmexit = cpu_has_notify_vmexit();
 
-	set_bit(0, vmx_vpid_bitmap); /* 0 is reserved for host */
+	/* VPID 0 is reserved for host, so min=1  */
+	if (enable_vpid)
+		kvm_init_tlb_tags(1, VMX_NR_VPIDS - 1);
 
 	if (enable_ept)
 		kvm_mmu_set_ept_masks(enable_ept_ad_bits,
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index b5758c33c60f..5feec05de9b4 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -355,8 +355,6 @@ static __always_inline u32 vmx_get_intr_info(struct kvm_vcpu *vcpu)
 }
 
 void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu);
-int allocate_vpid(void);
-void free_vpid(int vpid);
 void vmx_set_constant_host_state(struct vcpu_vmx *vmx);
 void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void vmx_set_host_fs_gs(struct vmcs_host_state *host, u16 fs_sel, u16 gs_sel,

base-commit: ecff148f29dade8416abee4d492d2a7a6d7cd610
--

