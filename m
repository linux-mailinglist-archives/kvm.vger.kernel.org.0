Return-Path: <kvm+bounces-49094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45176AD5DE7
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 20:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A7FB1BC5D2F
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34E62750ED;
	Wed, 11 Jun 2025 18:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cGUGCjUQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECBB23643F
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 18:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749665425; cv=none; b=I4TVgnIBfdBD+pn680PHSxzI2+cFOHUbScaJdjwHwFeEg2iHu58N3ojR+nCvh9MoPKuNO6Eo4vo2WcaVujtYt7ZzHz2DasBK6+nmbzELBSNH+AzkBG8EteVPmgdUV3waffnjRQnruBIIycyA/zUCrsxhIp30TxnVpb8ceghjA4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749665425; c=relaxed/simple;
	bh=29OXKBDZOIq0FAHFKqHxEsOG/j9kFoYJ3E2p9cubPrg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=toGIRNAlm9D1fhlPxHvz2dM0vBxKBGk93TB1WCki7a3TBiKpSq5oUi3VFJMNwR5qCb2YDFWgoySHMT+NK/idGC4HFqBs/jZNIro61lJBPDv9wpbPr2LLYJ37HjNcmkMMgTieAhC3iE1sr4vzj+GI6gJr72mEYzI6mM5BBpumjoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cGUGCjUQ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7398d70abbfso169636b3a.2
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 11:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749665423; x=1750270223; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H+n8rcN3a6Q9EmHl6qNRoA4kXtCPWon/4EaGj+uYNVA=;
        b=cGUGCjUQEOYahMKe5Rs+Ti+cUriMWczabnprGDI0sn27gYKcPE1HR82SpCXScynJr5
         y3B/YOvKoeLxHg3lVCPwJpJmVIEKuZ5Yg1GWKv05F1enX03K9QH3tR0f6wQfLL0eMgsD
         t2ydBMjf2iZu9cBk/XIWrfr8Xcqz0ESiAquN8jYlPI3GKUoVKpZGBM4OfXMW5lqDMqUl
         iSgz+4+QqG0QbuqQJYlq7qFHwAA06JAH/aBy3vGnB2hRPHUWbUKvRTOxwO2BIUOsrN87
         4u3eE/RbrdBqz28tlZljxOoPFIC5FTlIet2fO8UMrxm1Y2glRBgVgVe/z1tVoEw3YzQT
         2+NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749665423; x=1750270223;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H+n8rcN3a6Q9EmHl6qNRoA4kXtCPWon/4EaGj+uYNVA=;
        b=oYf2mndF05jVqQ1fhGgi73/1bzu3bmUqKqE8Ur0vpvBkxi9BZy1H4wPv5yDtaAHYv5
         raaDgxseLHexlniP1zmk8z5AfNE6p7jd/GkPY1hB3m55lpcqCmESsllOojX3kzF7gQLT
         R8GQBk0RdBluA5ypHfO9w6fnbmLg/TOjv0m+P5lfUl8jO58xodi1YC/rms+C0LLB35y8
         DCQegqVlE7aX5GX2bLv96xVFc48wQvbpqUGmbczpFPGAN/Gl+rcKBB2y8RXA0FsnTX8P
         T7i6TnpfYQHQKuIDpl08Y/F0fSim/ORIDKahLUR9gCfRc7aa5x9OzwmIPyy377nXqkKb
         TZTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXm1icLJcg11F362Y1fGIBEBsZRWrMp4pk6IlMV/lLgn4K9DHi3ypdU6FDb+5vnbhthB8o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRcbLjFqST4t2pu3mZP8cuHSwpAjgI5fRPHJWZU5+k/HvEc9Qm
	aMJmKJCzZbg/KP2T8brH99ixP+AMC99YNyhTtmTJcm7yocnmNmt05+SFnBpfSVWz/hfw+3N1lue
	5brVPfg==
X-Google-Smtp-Source: AGHT+IEQ2tvErCuXwF4XpAxwWaiOHRAP1nEd0kMtkoYoBOcu9+0FNyk2L0TIaqfnP+jWYbN/2qiGpMcYKyk=
X-Received: from pfsq11.prod.google.com ([2002:a05:6a00:2ab:b0:73b:bbec:17e9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e07:b0:73e:1e21:b653
 with SMTP id d2e1a72fcca58-7486cb717e9mr5564080b3a.5.1749665422800; Wed, 11
 Jun 2025 11:10:22 -0700 (PDT)
Date: Wed, 11 Jun 2025 11:10:21 -0700
In-Reply-To: <20250611001018.2179964-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
Message-ID: <aEnGjQE3AmPB3wxk@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for KVM_PRE_FAULT_MEMORY
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, rick.p.edgecombe@intel.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, reinette.chatre@intel.com, 
	kai.huang@intel.com, adrian.hunter@intel.com, isaku.yamahata@intel.com, 
	Binbin Wu <binbin.wu@linux.intel.com>, tony.lindgren@linux.intel.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Jun 10, 2025, Xiaoyao Li wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> Bug[*] reported for TDX case when enabling KVM_PRE_FAULT_MEMORY in QEMU.
> 
> It turns out that @gpa passed to kvm_mmu_do_page_fault() doesn't have
> shared bit set when the memory attribute of it is shared, and it leads
> to wrong root in tdp_mmu_get_root_for_fault().
> 
> Fix it by embedding the direct bits in the gpa that is passed to
> kvm_tdp_map_page(), when the memory of the gpa is not private.
> 
> [*] https://lore.kernel.org/qemu-devel/4a757796-11c2-47f1-ae0d-335626e818fd@intel.com/
> 
> Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Closes: https://lore.kernel.org/qemu-devel/4a757796-11c2-47f1-ae0d-335626e818fd@intel.com/
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> ---
> we have selftests enhancement for TDX case of KVM_PRE_FAULT_MEMORY, but
> the plan is to post them on top of the TDX selftests [1] when they get
> upstream.
> 
> [1] https://lore.kernel.org/all/20250414214801.2693294-1-sagis@google.com/
> ---
>  arch/x86/kvm/mmu/mmu.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index cbc84c6abc2e..a4040578b537 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4896,6 +4896,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  {
>  	u64 error_code = PFERR_GUEST_FINAL_MASK;
>  	u8 level = PG_LEVEL_4K;
> +	u64 direct_bits;
>  	u64 end;
>  	int r;
>  
> @@ -4910,15 +4911,18 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
>  	if (r)
>  		return r;
>  
> +	direct_bits = 0;
>  	if (kvm_arch_has_private_mem(vcpu->kvm) &&
>  	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
>  		error_code |= PFERR_PRIVATE_ACCESS;
> +	else
> +		direct_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));

Eww.  It's bad enough that TDX bleeds it's mirror needs into common MMU code,
but stuffing vendor specific GPA bits in common code goes too far.  Actually,
all of this goes too far.  There's zero reason any code outside of TDX needs to
*explicitly* care whether mirrors or "direct" MMUs have mandatory gfn bits.

Side topic, kvm_arch_vcpu_pre_fault_memory() should disallow aliased GFNs.  It
will "work", because kvm_mmu_do_page_fault() will strip the SHARED bit, but it's
all kinds of confusing due to KVM also forcing shared vs. private based on memory
attributes.

Back to the main topic, KVM needs to have a single source of truth when it comes
to whether a fault is private and thus mirrored (or not).  Common KVM needs to be
aware of aliased GFN bits, but absolute nothing outside of TDX (including common
VMX code) should be aware the mirror vs. "direct" (I hate that terminology; KVM
has far, far too much history and baggage with "direct") is tied to the existence
and polarity of aliased GFN bits.

What we have now does work *today* (see this bug), and it will be a complete
trainwreck if we ever want to steal GFN bits for other reasons.

To detect a mirror fault:

  static inline bool kvm_is_mirror_fault(struct kvm *kvm, u64 error_code)
  {
	return kvm_has_mirrored_tdp(kvm) &&
	       error_code & PFERR_PRIVATE_ACCESS;
  }

And for TDX, it should darn well explicitly track the shared GPA mask:

  static bool tdx_is_private_gpa(struct kvm *kvm, gpa_t gpa)
  {
	/* For TDX the direct mask is the shared mask. */
	return !(gpa & to_kvm_tdx(kvm)->shared_gpa_mask);
  }

Overloading a field in kvm_arch and bleeding TDX details into common code isn't
worth saving 8 bytes per VM.

Outside of TDX, detecting mirrors, and anti-aliasing logic, the only use of
kvm_gfn_direct_bits() is to constrain TDP MMU walks to the appropriate gfn range.
And for that, we can simply use kvm_mmu_page.gfn, with a kvm_x86_ops hook to get
the TDP MMU root GFN (root allocation is a slow path, the CALL+RET is a non-issue).

Compile tested only, and obviously needs to be split into multiple patches.

---
 arch/x86/include/asm/kvm-x86-ops.h |  3 ++
 arch/x86/include/asm/kvm_host.h    |  5 +-
 arch/x86/kvm/mmu.h                 | 21 +++++---
 arch/x86/kvm/mmu/mmu.c             |  3 ++
 arch/x86/kvm/mmu/mmu_internal.h    | 14 +-----
 arch/x86/kvm/mmu/tdp_iter.c        |  4 +-
 arch/x86/kvm/mmu/tdp_iter.h        | 12 ++---
 arch/x86/kvm/mmu/tdp_mmu.c         | 13 ++---
 arch/x86/kvm/mmu/tdp_mmu.h         |  2 +-
 arch/x86/kvm/vmx/common.h          | 17 ++++---
 arch/x86/kvm/vmx/main.c            | 11 +++++
 arch/x86/kvm/vmx/tdx.c             | 78 ++++++++++++++++++------------
 arch/x86/kvm/vmx/tdx.h             |  2 +
 arch/x86/kvm/vmx/vmx.c             |  2 +-
 arch/x86/kvm/vmx/x86_ops.h         |  1 +
 15 files changed, 112 insertions(+), 76 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 8d50e3e0a19b..f0a958ba4823 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -145,6 +145,9 @@ KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
 KVM_X86_OP_OPTIONAL(get_untagged_addr)
 KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
+#ifdef CONFIG_X86_64
+KVM_X86_OP_OPTIONAL_RET0(get_tdp_mmu_root_gfn);
+#endif
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 KVM_X86_OP_OPTIONAL_RET0(private_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 330cdcbed1a6..3a5efde1ab9d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1578,7 +1578,7 @@ struct kvm_arch {
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
 
-	gfn_t gfn_direct_bits;
+	gfn_t aliased_gfn_bits;
 
 	/*
 	 * Size of the CPU's dirty log buffer, i.e. VMX's PML buffer. A Zero
@@ -1897,6 +1897,9 @@ struct kvm_x86_ops {
 
 	gva_t (*get_untagged_addr)(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+#ifdef CONFIG_X86_64
+	gfn_t (*get_tdp_mmu_root_gfn)(struct kvm *kvm, bool is_mirror);
+#endif
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
 	int (*private_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn);
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b4b6860ab971..cef726e59f9b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -257,7 +257,7 @@ extern bool tdp_mmu_enabled;
 #define tdp_mmu_enabled false
 #endif
 
-bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
+bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa, u64 error_code);
 int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
 
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
@@ -309,20 +309,25 @@ static inline bool kvm_has_mirrored_tdp(const struct kvm *kvm)
 	return kvm->arch.vm_type == KVM_X86_TDX_VM;
 }
 
-static inline gfn_t kvm_gfn_direct_bits(const struct kvm *kvm)
+static inline bool kvm_is_mirror_fault(struct kvm *kvm, u64 error_code)
 {
-	return kvm->arch.gfn_direct_bits;
+	return kvm_has_mirrored_tdp(kvm) &&
+	       error_code & PFERR_PRIVATE_ACCESS;
 }
 
-static inline bool kvm_is_addr_direct(struct kvm *kvm, gpa_t gpa)
+static inline gfn_t kvm_aliased_gfn_bits(struct kvm *kvm)
 {
-	gpa_t gpa_direct_bits = gfn_to_gpa(kvm_gfn_direct_bits(kvm));
-
-	return !gpa_direct_bits || (gpa & gpa_direct_bits);
+	return kvm->arch.aliased_gfn_bits;
 }
 
 static inline bool kvm_is_gfn_alias(struct kvm *kvm, gfn_t gfn)
 {
-	return gfn & kvm_gfn_direct_bits(kvm);
+	return gfn & kvm_aliased_gfn_bits(kvm);
 }
+
+static inline gpa_t kvm_get_unaliased_gpa(struct kvm *kvm, gpa_t gpa)
+{
+	return gpa & ~gfn_to_gpa(kvm_aliased_gfn_bits(kvm));
+}
+
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cbc84c6abc2e..0228d49ac363 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4902,6 +4902,9 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu *vcpu,
 	if (!vcpu->kvm->arch.pre_fault_allowed)
 		return -EOPNOTSUPP;
 
+	if (kvm_is_gfn_alias(vcpu->kvm, gpa_to_gfn(range->gpa)))
+		return -EINVAL;
+
 	/*
 	 * reload is efficient when called repeatedly, so we can do it on
 	 * every iteration.
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index db8f33e4de62..7d2c53d2b0ca 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -175,18 +175,6 @@ static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_
 	sp->external_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
 }
 
-static inline gfn_t kvm_gfn_root_bits(const struct kvm *kvm, const struct kvm_mmu_page *root)
-{
-	/*
-	 * Since mirror SPs are used only for TDX, which maps private memory
-	 * at its "natural" GFN, no mask needs to be applied to them - and, dually,
-	 * we expect that the bits is only used for the shared PT.
-	 */
-	if (is_mirror_sp(root))
-		return 0;
-	return kvm_gfn_direct_bits(kvm);
-}
-
 static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm *kvm,
 						      struct kvm_mmu_page *sp)
 {
@@ -376,7 +364,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * bit. Strip it so that the GFN can be used like normal, and the
 		 * fault.addr can be used when the shared bit is needed.
 		 */
-		fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_direct_bits(vcpu->kvm);
+		fault.gfn = gpa_to_gfn(fault.addr) & ~vcpu->kvm->arch.aliased_gfn_bits;
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
diff --git a/arch/x86/kvm/mmu/tdp_iter.c b/arch/x86/kvm/mmu/tdp_iter.c
index 9e17bfa80901..c36bfb920382 100644
--- a/arch/x86/kvm/mmu/tdp_iter.c
+++ b/arch/x86/kvm/mmu/tdp_iter.c
@@ -37,8 +37,10 @@ void tdp_iter_restart(struct tdp_iter *iter)
  * rooted at root_pt, starting with the walk to translate next_last_level_gfn.
  */
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn, gfn_t gfn_bits)
+		    int min_level, gfn_t next_last_level_gfn, bool paranoid)
 {
+	gfn_t gfn_bits = paranoid ? 0 : root->gfn;
+
 	if (WARN_ON_ONCE(!root || (root->role.level < 1) ||
 			 (root->role.level > PT64_ROOT_MAX_LEVEL) ||
 			 (gfn_bits && next_last_level_gfn >= gfn_bits))) {
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index 364c5da6c499..5117d64952f7 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -120,13 +120,13 @@ struct tdp_iter {
  * Iterates over every SPTE mapping the GFN range [start, end) in a
  * preorder traversal.
  */
-#define for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end)		  \
-	for (tdp_iter_start(&iter, root, min_level, start, kvm_gfn_root_bits(kvm, root)); \
-	     iter.valid && iter.gfn < end;						  \
+#define for_each_tdp_pte_min_level(iter, kvm, root, min_level, start, end)	\
+	for (tdp_iter_start(&iter, root, min_level, start, false);		\
+	     iter.valid && iter.gfn < end;					\
 	     tdp_iter_next(&iter))
 
-#define for_each_tdp_pte_min_level_all(iter, root, min_level)		\
-	for (tdp_iter_start(&iter, root, min_level, 0, 0);		\
+#define for_each_tdp_pte_min_level_paranoid(iter, root, min_level)	\
+	for (tdp_iter_start(&iter, root, min_level, 0, true);		\
 		iter.valid && iter.gfn < tdp_mmu_max_gfn_exclusive();	\
 		tdp_iter_next(&iter))
 
@@ -136,7 +136,7 @@ struct tdp_iter {
 tdp_ptep_t spte_to_child_pt(u64 pte, int level);
 
 void tdp_iter_start(struct tdp_iter *iter, struct kvm_mmu_page *root,
-		    int min_level, gfn_t next_last_level_gfn, gfn_t gfn_bits);
+		    int min_level, gfn_t next_last_level_gfn, bool paranoid);
 void tdp_iter_next(struct tdp_iter *iter);
 void tdp_iter_restart(struct tdp_iter *iter);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1..15daf4353ccc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -257,6 +257,7 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
 	int as_id = kvm_mmu_role_as_id(role);
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
+	gfn_t gfn;
 
 	if (mirror)
 		role.is_mirror = true;
@@ -291,7 +292,8 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
 	}
 
 	root = tdp_mmu_alloc_sp(vcpu);
-	tdp_mmu_init_sp(root, NULL, 0, role);
+	gfn = kvm_x86_call(get_tdp_mmu_root_gfn)(vcpu->kvm, mirror);
+	tdp_mmu_init_sp(root, NULL, gfn, role);
 
 	/*
 	 * TDP MMU roots are kept until they are explicitly invalidated, either
@@ -860,7 +862,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	for_each_tdp_pte_min_level_all(iter, root, zap_level) {
+	for_each_tdp_pte_min_level_paranoid(iter, root, zap_level) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
@@ -1934,12 +1936,11 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, root);
 }
 
-bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
+bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa, u64 error_code)
 {
 	struct kvm *kvm = vcpu->kvm;
-	bool is_direct = kvm_is_addr_direct(kvm, gpa);
-	hpa_t root = is_direct ? vcpu->arch.mmu->root.hpa :
-				 vcpu->arch.mmu->mirror_root_hpa;
+	hpa_t root = kvm_is_mirror_fault(kvm, error_code) ? vcpu->arch.mmu->mirror_root_hpa :
+							    vcpu->arch.mmu->root.hpa;
 	u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
 	int leaf;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 52acf99d40a0..397309dfc73f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -48,7 +48,7 @@ static inline enum kvm_tdp_mmu_root_types kvm_gfn_range_filter_to_root_types(str
 static inline struct kvm_mmu_page *tdp_mmu_get_root_for_fault(struct kvm_vcpu *vcpu,
 							      struct kvm_page_fault *fault)
 {
-	if (unlikely(!kvm_is_addr_direct(vcpu->kvm, fault->addr)))
+	if (unlikely(kvm_is_mirror_fault(vcpu->kvm, fault->error_code)))
 		return root_to_sp(vcpu->arch.mmu->mirror_root_hpa);
 
 	return root_to_sp(vcpu->arch.mmu->root.hpa);
diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index a0c5e8781c33..5065fd8d41e8 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -76,14 +76,9 @@ static __always_inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
 
 #endif
 
-static inline bool vt_is_tdx_private_gpa(struct kvm *kvm, gpa_t gpa)
-{
-	/* For TDX the direct mask is the shared mask. */
-	return !kvm_is_addr_direct(kvm, gpa);
-}
-
 static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
-					     unsigned long exit_qualification)
+					     unsigned long exit_qualification,
+					     bool is_private)
 {
 	u64 error_code;
 
@@ -104,12 +99,18 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 		error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) ?
 			      PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
-	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa))
+	if (is_private)
 		error_code |= PFERR_PRIVATE_ACCESS;
 
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
+static inline int vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
+					   unsigned long exit_qualification)
+{
+	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification, false);
+}
+
 static inline void kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
 						     int pi_vec)
 {
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d1e02e567b57..6e0652ed0d22 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -855,6 +855,14 @@ static void vt_setup_mce(struct kvm_vcpu *vcpu)
 	vmx_setup_mce(vcpu);
 }
 
+static gfn_t vt_get_tdp_mmu_root_gfn(struct kvm *kvm, bool is_mirror)
+{
+	if (!is_td(kvm))
+		return 0;
+
+	return tdx_get_tdp_mmu_root_gfn(kvm, is_mirror);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -1041,6 +1049,9 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.get_untagged_addr = vmx_get_untagged_addr,
 
+#ifdef CONFIG_X86_64
+	.get_tdp_mmu_root_gfn = vt_op_tdx_only(get_tdp_mmu_root_gfn),
+#endif
 	.mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
 	.vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..1abf3c158cd5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1138,6 +1138,12 @@ static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
 	return __kvm_emulate_hypercall(vcpu, 0, complete_hypercall_exit);
 }
 
+static bool tdx_is_private_gpa(struct kvm *kvm, gpa_t gpa)
+{
+	/* For TDX the direct mask is the shared mask. */
+	return !(gpa & to_kvm_tdx(kvm)->shared_gpa_mask);
+}
+
 /*
  * Split into chunks and check interrupt pending between chunks.  This allows
  * for timely injection of interrupts to prevent issues with guest lockup
@@ -1192,9 +1198,9 @@ static void __tdx_map_gpa(struct vcpu_tdx *tdx)
 	 * vcpu->run->hypercall.ret, ensuring that it is zero to not break QEMU.
 	 */
 	tdx->vcpu.run->hypercall.ret = 0;
-	tdx->vcpu.run->hypercall.args[0] = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(tdx->vcpu.kvm));
+	tdx->vcpu.run->hypercall.args[0] = gfn_to_gpa(kvm_get_unaliased_gpa(tdx->vcpu.kvm, gpa));
 	tdx->vcpu.run->hypercall.args[1] = size / PAGE_SIZE;
-	tdx->vcpu.run->hypercall.args[2] = vt_is_tdx_private_gpa(tdx->vcpu.kvm, gpa) ?
+	tdx->vcpu.run->hypercall.args[2] = tdx_is_private_gpa(tdx->vcpu.kvm, gpa) ?
 					   KVM_MAP_GPA_RANGE_ENCRYPTED :
 					   KVM_MAP_GPA_RANGE_DECRYPTED;
 	tdx->vcpu.run->hypercall.flags   = KVM_EXIT_HYPERCALL_LONG_MODE;
@@ -1222,8 +1228,8 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
 
 	if (gpa + size <= gpa || !kvm_vcpu_is_legal_gpa(vcpu, gpa) ||
 	    !kvm_vcpu_is_legal_gpa(vcpu, gpa + size - 1) ||
-	    (vt_is_tdx_private_gpa(vcpu->kvm, gpa) !=
-	     vt_is_tdx_private_gpa(vcpu->kvm, gpa + size - 1))) {
+	    (tdx_is_private_gpa(vcpu->kvm, gpa) !=
+	     tdx_is_private_gpa(vcpu->kvm, gpa + size - 1))) {
 		ret = TDVMCALL_STATUS_INVALID_OPERAND;
 		goto error;
 	}
@@ -1411,11 +1417,11 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
 	 * TDG.VP.VMCALL<MMIO> allows only shared GPA, it makes no sense to
 	 * do MMIO emulation for private GPA.
 	 */
-	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa) ||
-	    vt_is_tdx_private_gpa(vcpu->kvm, gpa + size - 1))
+	if (tdx_is_private_gpa(vcpu->kvm, gpa) ||
+	    tdx_is_private_gpa(vcpu->kvm, gpa + size - 1))
 		goto error;
 
-	gpa = gpa & ~gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
+	gpa = kvm_get_unaliased_gpa(vcpu->kvm, gpa);
 
 	if (write)
 		r = tdx_mmio_write(vcpu, gpa, size, val);
@@ -1480,12 +1486,17 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+gfn_t tdx_get_tdp_mmu_root_gfn(struct kvm *kvm, bool is_mirror)
+{
+	return is_mirror ? 0 : gpa_to_gfn(to_kvm_tdx(kvm)->shared_gpa_mask);
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	u64 shared_bit = (pgd_level == 5) ? TDX_SHARED_BIT_PWL_5 :
 			  TDX_SHARED_BIT_PWL_4;
 
-	if (KVM_BUG_ON(shared_bit != kvm_gfn_direct_bits(vcpu->kvm), vcpu->kvm))
+	if (KVM_BUG_ON(tdx_is_private_gpa(vcpu->kvm, shared_bit), vcpu->kvm))
 		return;
 
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
@@ -1837,10 +1848,10 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 {
 	unsigned long exit_qual;
 	gpa_t gpa = to_tdx(vcpu)->exit_gpa;
-	bool local_retry = false;
+	bool is_private = tdx_is_private_gpa(vcpu->kvm, gpa);
 	int ret;
 
-	if (vt_is_tdx_private_gpa(vcpu->kvm, gpa)) {
+	if (is_private) {
 		if (tdx_is_sept_violation_unexpected_pending(vcpu)) {
 			pr_warn("Guest access before accepting 0x%llx on vCPU %d\n",
 				gpa, vcpu->vcpu_id);
@@ -1857,9 +1868,6 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 		 * due to aliasing a single HPA to multiple GPAs.
 		 */
 		exit_qual = EPT_VIOLATION_ACC_WRITE;
-
-		/* Only private GPA triggers zero-step mitigation */
-		local_retry = true;
 	} else {
 		exit_qual = vmx_get_exit_qual(vcpu);
 		/*
@@ -1907,9 +1915,10 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	 * handle retries locally in their EPT violation handlers.
 	 */
 	while (1) {
-		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
+		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual, is_private);
 
-		if (ret != RET_PF_RETRY || !local_retry)
+		/* Only private GPA triggers zero-step mitigation */
+		if (ret != RET_PF_RETRY || !is_private)
 			break;
 
 		if (kvm_vcpu_has_events(vcpu) || signal_pending(current))
@@ -2620,12 +2629,11 @@ static int tdx_read_cpuid(struct kvm_vcpu *vcpu, u32 leaf, u32 sub_leaf,
 	out->flags |= sub_leaf_set ? KVM_CPUID_FLAG_SIGNIFCANT_INDEX : 0;
 
 	/*
-	 * Work around missing support on old TDX modules, fetch
-	 * guest maxpa from gfn_direct_bits.
+	 * Work around missing support on old TDX modules, derive the guest
+	 * MAXPA from the shared bit.
 	 */
 	if (leaf == 0x80000008) {
-		gpa_t gpa_bits = gfn_to_gpa(kvm_gfn_direct_bits(vcpu->kvm));
-		unsigned int g_maxpa = __ffs(gpa_bits) + 1;
+		unsigned int g_maxpa = __ffs(kvm_tdx->shared_gpa_mask) + 1;
 
 		out->eax = tdx_set_guest_phys_addr_bits(out->eax, g_maxpa);
 	}
@@ -2648,6 +2656,7 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct kvm_tdx_init_vm *init_vm;
 	struct td_params *td_params = NULL;
+	gpa_t shared_bit;
 	int ret;
 
 	BUILD_BUG_ON(sizeof(*init_vm) != 256 + sizeof_field(struct kvm_tdx_init_vm, cpuid));
@@ -2712,9 +2721,12 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 	kvm_tdx->xfam = td_params->xfam;
 
 	if (td_params->config_flags & TDX_CONFIG_FLAGS_MAX_GPAW)
-		kvm->arch.gfn_direct_bits = TDX_SHARED_BIT_PWL_5;
+		shared_bit = TDX_SHARED_BIT_PWL_5;
 	else
-		kvm->arch.gfn_direct_bits = TDX_SHARED_BIT_PWL_4;
+		shared_bit = TDX_SHARED_BIT_PWL_4;
+
+	kvm_tdx->shared_gpa_mask = shared_bit;
+	kvm->arch.aliased_gfn_bits = gpa_to_gfn(shared_bit);
 
 	kvm_tdx->state = TD_STATE_INITIALIZED;
 out:
@@ -3052,6 +3064,16 @@ struct tdx_gmem_post_populate_arg {
 	__u32 flags;
 };
 
+static int tdx_is_private_mapping_valid(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	if (!IS_ENABLED(CONFIG_KVM_PROVE_MMU))
+		return 0;
+
+	guard(read_lock)(&vcpu->kvm->mmu_lock);
+
+	return kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa, PFERR_PRIVATE_ACCESS);
+}
+
 static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 				  void __user *src, int order, void *_arg)
 {
@@ -3084,14 +3106,8 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 * because all paths are covered by slots_lock and the
 	 * filemap invalidate lock.  Check that they are indeed enough.
 	 */
-	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
-		scoped_guard(read_lock, &kvm->mmu_lock) {
-			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
-				ret = -EIO;
-				goto out;
-			}
-		}
-	}
+	if (KVM_BUG_ON(!tdx_is_private_mapping_valid(vcpu, gpa), kvm))
+		return -EIO;
 
 	ret = 0;
 	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
@@ -3148,8 +3164,8 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 	if (!PAGE_ALIGNED(region.source_addr) || !PAGE_ALIGNED(region.gpa) ||
 	    !region.nr_pages ||
 	    region.gpa + (region.nr_pages << PAGE_SHIFT) <= region.gpa ||
-	    !vt_is_tdx_private_gpa(kvm, region.gpa) ||
-	    !vt_is_tdx_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
+	    !tdx_is_private_gpa(kvm, region.gpa) ||
+	    !tdx_is_private_gpa(kvm, region.gpa + (region.nr_pages << PAGE_SHIFT) - 1))
 		return -EINVAL;
 
 	kvm_mmu_reload(vcpu);
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 51f98443e8a2..3807562d5b48 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -27,6 +27,8 @@ struct kvm_tdx {
 	int hkid;
 	enum kvm_tdx_state state;
 
+	gpa_t shared_gpa_mask;
+
 	u64 attributes;
 	u64 xfam;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9ff00ae9f05a..38103efe2f47 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5775,7 +5775,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 	if (unlikely(allow_smaller_maxphyaddr && !kvm_vcpu_is_legal_gpa(vcpu, gpa)))
 		return kvm_emulate_instruction(vcpu, 0);
 
-	return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
+	return vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
 }
 
 static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index b4596f651232..ee56e96b4db3 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -151,6 +151,7 @@ int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
+gfn_t tdx_get_tdp_mmu_root_gfn(struct kvm *kvm, bool is_mirror);
 int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 			      enum pg_level level, void *private_spt);
 int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,

base-commit: 61374cc145f4a56377eaf87c7409a97ec7a34041
--

