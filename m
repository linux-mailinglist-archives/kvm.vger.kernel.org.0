Return-Path: <kvm+bounces-52049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A2CFB00876
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 18:24:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A5C63A8625
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 16:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D59E2EFD9E;
	Thu, 10 Jul 2025 16:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bYL5dqkj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A335D2EFD96
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 16:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752164657; cv=none; b=d/lA5lp0lMjmAhDmiVze/tlgOsr0+qu1PoAvdV7lqJBbttahYQQBngzGoHqIR8apdnTqrQiH8zs6BN9eQXAuxZac36OYiwYL+MG4Y5cm7bg/XeRJY5TZIV53KciNrNqhx6M2Lpce8ReX6b55/mN2cLEkMwHPP4BLAzQzYFN0gx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752164657; c=relaxed/simple;
	bh=7htcxq6XrknTBPYYPhKsQq4U2qiSMnoMMfs6z75EYl4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P3goJwc3ZMdBugc3z9In0/2xHPt0/Qoi9Ze61FFXTuR14vc2Za+pzqRXnT7RTMP/eVftRiKXIbGxaEJi7m2GKzobpZtoQWp2/Cm6aJSMXYuzLGxOvUprtyHdpRxrb9z3tf2AUX9b40o/N6VCt1l+CD+wdo+401wkuVSoyj3UsFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bYL5dqkj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-313d6d671ffso1189372a91.2
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 09:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752164655; x=1752769455; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRYvrQrxBC58DxVhyHaBg+5Yt1iushnmgR45IacO10Y=;
        b=bYL5dqkjYY+5Gl/gyGl44za10KIU7jb9Rb7U9PHSk5NnOaZIt8ZOlFyWmBCi/Jvh4s
         ZJ8m3fk3mPdXltAL7q++eHYPgYIxx4vqmjxxqsou/yRXwsGNf3PqEkC0H96yAveHWGpO
         ciToL5eRGZayN7nDbJLlMYx9uHuNMCoCrk4K4t9sQTAH7kkHVtWhgRV+xS/GGE8FQg7s
         eN3X+8xzhE1hgV75gdb6trflKQQhZn+wyZA6Rh+hQRCu1zxQ768lz1yOnjvzhX2jB7v8
         vyXaZe8VDzJvwiSmS1qzHPryktDPBMyuk2N3J4QzK0d2G+/4xCNMPyX29LC4i3svZgr1
         EXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752164655; x=1752769455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZRYvrQrxBC58DxVhyHaBg+5Yt1iushnmgR45IacO10Y=;
        b=srz+DRhlAY2n6Xm7cu1q6UHFZxSdYyqDEDbl/IRO6dCpi3mwNR/3vuKkMNxkr8BZdT
         BQjFIceDZ0mTe0eyhkNx7mFwtxN/SjPNIo/aUTL9k17JSdr8cvHd/2K1RZwwO6cU5R10
         Xut8WpU0UpRHhEojJkMGEMLkbQ5JZamxkiaR4tWs41oPQjEuRwnq27VMY3bYWZNXR2AQ
         +1IxgdkfKRi4bYKM6SBtaQNlP2zBqfSLtmoTWTNWiBryTLhfpHNd26m4xkY+Autiz9vm
         sh4IJ/m5lCa3S4Lj4OfbsTibk/qJQfQPaVStXiVk5dQHZWegCApAbwYkmHFGeyyNizS5
         UXVg==
X-Forwarded-Encrypted: i=1; AJvYcCWcIC0GfuXE0BY00AFtHjXxo0dLCixqNDroPt/6tg0RWgXPnqfN4AEIPH4Akl37SWlowF8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqAl+quda64wygznYTZWH8gV4Uui7mGmcVfZDLVMaW6bGr2eV0
	q4DFzlpGgfdzcSoJ1zTOrHvwY6GCmRUp8XxMdMnWA9dctHV1tGjR2xTaoVeCM01w55cGrJ0+lch
	RTKm16A==
X-Google-Smtp-Source: AGHT+IFcsMbGxBy7c5ZOpbZMhNSeXz32OavcHTzFLmR2WdDBV0KMin9CgtVEhZoDpR8WM4B/hAs253kWdTg=
X-Received: from pjuu13.prod.google.com ([2002:a17:90b:586d:b0:31c:2fe4:33b8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:390f:b0:311:ed2:b758
 with SMTP id 98e67ed59e1d1-31c4ca758a6mr211135a91.3.1752164655005; Thu, 10
 Jul 2025 09:24:15 -0700 (PDT)
Date: Thu, 10 Jul 2025 09:24:13 -0700
In-Reply-To: <20250709232103.zwmufocd3l7sqk7y@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250703062641.3247-1-yan.y.zhao@intel.com> <20250709232103.zwmufocd3l7sqk7y@amd.com>
Message-ID: <aG_pLUlHdYIZ2luh@google.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, binbin.wu@linux.intel.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, ira.weiny@intel.com, vannapurve@google.com, 
	david@redhat.com, ackerleytng@google.com, tabba@google.com, 
	chao.p.peng@intel.com
Content-Type: text/plain; charset="us-ascii"

On Wed, Jul 09, 2025, Michael Roth wrote:
> On Thu, Jul 03, 2025 at 02:26:41PM +0800, Yan Zhao wrote:
> > Rather than invoking kvm_gmem_populate(), allow tdx_vcpu_init_mem_region()
> > to use open code to populate the initial memory region into the mirror page
> > table, and add the region to S-EPT.
> > 
> > Background
> > ===
> > Sean initially suggested TDX to populate initial memory region in a 4-step
> > way [1]. Paolo refactored guest_memfd and introduced kvm_gmem_populate()
> > interface [2] to help TDX populate init memory region.

I wouldn't give my suggestion too much weight; I did qualify it with "Crazy idea."
after all :-)

> > tdx_vcpu_init_mem_region
> >     guard(mutex)(&kvm->slots_lock)
> >     kvm_gmem_populate
> >         filemap_invalidate_lock(file->f_mapping)
> >             __kvm_gmem_get_pfn      //1. get private PFN
> >             post_populate           //tdx_gmem_post_populate
> >                 get_user_pages_fast //2. get source page
> >                 kvm_tdp_map_page    //3. map private PFN to mirror root
> >                 tdh_mem_page_add    //4. add private PFN to S-EPT and copy
> >                                          source page to it.
> > 
> > kvm_gmem_populate() helps TDX to "get private PFN" in step 1. Its file
> > invalidate lock also helps ensure the private PFN remains valid when
> > tdh_mem_page_add() is invoked in TDX's post_populate hook.
> > 
> > Though TDX does not need the folio prepration code, kvm_gmem_populate()
> > helps on sharing common code between SEV-SNP and TDX.
> > 
> > Problem
> > ===
> > (1)
> > In Michael's series "KVM: gmem: 2MB THP support and preparedness tracking
> > changes" [4], kvm_gmem_get_pfn() was modified to rely on the filemap
> > invalidation lock for protecting its preparedness tracking. Similarly, the
> > in-place conversion version of guest_memfd series by Ackerly also requires
> > kvm_gmem_get_pfn() to acquire filemap invalidation lock [5].
> > 
> > kvm_gmem_get_pfn
> >     filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
> > 
> > However, since kvm_gmem_get_pfn() is called by kvm_tdp_map_page(), which is
> > in turn invoked within kvm_gmem_populate() in TDX, a deadlock occurs on the
> > filemap invalidation lock.
> 
> Bringing the prior discussion over to here: it seems wrong that
> kvm_gmem_get_pfn() is getting called within the kvm_gmem_populate()
> chain, because:
> 
> 1) kvm_gmem_populate() is specifically passing the gmem PFN down to
>    tdx_gmem_post_populate(), but we are throwing it away to grab it
>    again kvm_gmem_get_pfn(), which is then creating these locking issues
>    that we are trying to work around. If we could simply pass that PFN down
>    to kvm_tdp_map_page() (or some variant), then we would not trigger any
>    deadlocks in the first place.

Yes, doing kvm_mmu_faultin_pfn() in tdx_gmem_post_populate() is a major flaw.

> 2) kvm_gmem_populate() is intended for pre-boot population of guest
>    memory, and allows the post_populate callback to handle setting
>    up the architecture-specific preparation, whereas kvm_gmem_get_pfn()
>    calls kvm_arch_gmem_prepare(), which is intended to handle post-boot
>    setup of private memory. Having kvm_gmem_get_pfn() called as part of
>    kvm_gmem_populate() chain brings things 2 things in conflict with
>    each other, and TDX seems to be relying on that fact that it doesn't
>    implement a handler for kvm_arch_gmem_prepare(). 
> 
> I don't think this hurts anything in the current code, and I don't
> personally see any issue with open-coding the population path if it doesn't
> fit TDX very well, but there was some effort put into making
> kvm_gmem_populate() usable for both TDX/SNP, and if the real issue isn't the
> design of the interface itself, but instead just some inflexibility on the
> KVM MMU mapping side, then it seems more robust to address the latter if
> possible.
> 
> Would something like the below be reasonable? 

No, polluting the page fault paths is a non-starter for me.  TDX really shouldn't
be synthesizing a page fault when it has the PFN in hand.  And some of the behavior
that's desirable for pre-faults looks flat out wrong for TDX.  E.g. returning '0'
on RET_PF_WRITE_PROTECTED and RET_PF_SPURIOUS (though maybe spurious is fine?).

I would much rather special case this path, because it absolutely is a special
snowflake.  This even eliminates several exports of low level helpers that frankly
have no business being used by TDX, e.g. kvm_mmu_reload().

---
 arch/x86/kvm/mmu.h         |  2 +-
 arch/x86/kvm/mmu/mmu.c     | 78 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c |  1 -
 arch/x86/kvm/vmx/tdx.c     | 24 ++----------
 4 files changed, 78 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b4b6860ab971..9cd7a34333af 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -258,7 +258,7 @@ extern bool tdp_mmu_enabled;
 #endif
 
 bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
-int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
+int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn);
 
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6e838cb6c9e1..bc937f8ed5a0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4900,7 +4900,8 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return direct_page_fault(vcpu, fault);
 }
 
-int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level)
+static int kvm_tdp_prefault_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+				 u64 error_code, u8 *level)
 {
 	int r;
 
@@ -4942,7 +4943,6 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
 		return -EIO;
 	}
 }
-EXPORT_SYMBOL_GPL(kvm_tdp_map_page);
 
 long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 				    struct kvm_pre_fault_memory *range)
@@ -4978,7 +4978,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	 * Shadow paging uses GVA for kvm page fault, so restrict to
 	 * two-dimensional paging.
 	 */
-	r = kvm_tdp_map_page(vcpu, range->gpa | direct_bits, error_code, &level);
+	r = kvm_tdp_prefault_page(vcpu, range->gpa | direct_bits, error_code, &level);
 	if (r < 0)
 		return r;
 
@@ -4990,6 +4990,77 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	return min(range->size, end - range->gpa);
 }
 
+int kvm_tdp_mmu_map_private_pfn(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
+{
+	struct kvm_page_fault fault = {
+		.addr = gfn_to_gpa(gfn),
+		.error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS,
+		.prefetch = true,
+		.is_tdp = true,
+		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(vcpu->kvm),
+
+		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
+		.req_level = PG_LEVEL_4K,
+		.goal_level = PG_LEVEL_4K,
+		.is_private = true,
+
+		.gfn = gfn,
+		.slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn),
+		.pfn = pfn,
+		.map_writable = true,
+	};
+	struct kvm *kvm = vcpu->kvm;
+	int r;
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	if (KVM_BUG_ON(!tdp_mmu_enabled, kvm))
+		return -EIO;
+
+	if (kvm_gfn_is_write_tracked(kvm, fault.slot, fault.gfn))
+		return -EPERM;
+
+	r = kvm_mmu_reload(vcpu);
+	if (r)
+		return r;
+
+	r = mmu_topup_memory_caches(vcpu, false);
+	if (r)
+		return r;
+
+	do {
+		if (signal_pending(current))
+			return -EINTR;
+
+		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
+			return -EIO;
+
+		cond_resched();
+
+		guard(read_lock)(&kvm->mmu_lock);
+
+		r = kvm_tdp_mmu_map(vcpu, &fault);
+	} while (r == RET_PF_RETRY);
+
+	if (r != RET_PF_FIXED)
+		return -EIO;
+
+	/*
+	 * The caller is responsible for ensuring that no MMU invalidations can
+	 * occur.  Sanity check that the mapping hasn't been zapped.
+	 */
+	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
+		cond_resched();
+
+		scoped_guard(read_lock, &kvm->mmu_lock) {
+			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, fault.addr), kvm))
+				return -EIO;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_tdp_mmu_map_private_pfn);
+
 static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
@@ -5973,7 +6044,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 out:
 	return r;
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_load);
 
 void kvm_mmu_unload(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1..4f73d5341ebe 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1953,7 +1953,6 @@ bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
 	spte = sptes[leaf];
 	return is_shadow_present_pte(spte) && is_last_spte(spte, leaf);
 }
-EXPORT_SYMBOL_GPL(kvm_tdp_mmu_gpa_is_mapped);
 
 /*
  * Returns the last level spte pointer of the shadow page walk for the given
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f4d4fd5cc6e8..02142496754f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3170,15 +3170,12 @@ struct tdx_gmem_post_populate_arg {
 static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 				  void __user *src, int order, void *_arg)
 {
-	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct tdx_gmem_post_populate_arg *arg = _arg;
-	struct kvm_vcpu *vcpu = arg->vcpu;
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	u64 err, entry, level_state;
 	gpa_t gpa = gfn_to_gpa(gfn);
-	u8 level = PG_LEVEL_4K;
 	struct page *src_page;
 	int ret, i;
-	u64 err, entry, level_state;
 
 	/*
 	 * Get the source page if it has been faulted in. Return failure if the
@@ -3190,24 +3187,10 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (ret != 1)
 		return -ENOMEM;
 
-	ret = kvm_tdp_map_page(vcpu, gpa, error_code, &level);
+	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
 	if (ret < 0)
 		goto out;
 
-	/*
-	 * The private mem cannot be zapped after kvm_tdp_map_page()
-	 * because all paths are covered by slots_lock and the
-	 * filemap invalidate lock.  Check that they are indeed enough.
-	 */
-	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
-		scoped_guard(read_lock, &kvm->mmu_lock) {
-			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
-				ret = -EIO;
-				goto out;
-			}
-		}
-	}
-
 	ret = 0;
 	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
 			       src_page, &entry, &level_state);
@@ -3267,7 +3250,6 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 	    !vt_is_tdx_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
 		return -EINVAL;
 
-	kvm_mmu_reload(vcpu);
 	ret = 0;
 	while (region.nr_pages) {
 		if (signal_pending(current)) {

base-commit: 6c7ecd725e503bf2ca69ff52c6cc48bb650b1f11
--

