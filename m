Return-Path: <kvm+bounces-10886-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CBA3E87184B
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 09:36:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F03161C2116E
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 08:36:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E744DA0C;
	Tue,  5 Mar 2024 08:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RGlpUwJ+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBA2249F1;
	Tue,  5 Mar 2024 08:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709627741; cv=none; b=K6tbzyXmzTFIbzIq4YP/4lX3gTtRnTGwfMMU9jHGdsUlurn7T0gWZ3guQSjzZFrcQtE3a06Rxz/98P/JGOJNdUfXanUNmt440DGIBWWQxZEB2Sm+vSX0mjt2LR/wLkZRN7XZuS0q7JWIrMDe1XRflqZaEm4qISUwzDGSmwy9gzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709627741; c=relaxed/simple;
	bh=LPw3A2szBAoVVtalkXlJFKeMTfTKY/oEBwCzke2iCdE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DGPvdcZI1DL0B4o1OsLwG40ymNitH1movXfh3zur08F2O5FOVqDuq5CRFg4Wgr719qyjeQuFnM3lnlqyxQ/3luUCAf7YvjkkQCu7iaQOiVcTv0XwdftNnOumnIb/nddjIdQkMX03M4POZDywZuXahKOGtNwPFcXP1Zz1KeyAIdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RGlpUwJ+; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709627739; x=1741163739;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LPw3A2szBAoVVtalkXlJFKeMTfTKY/oEBwCzke2iCdE=;
  b=RGlpUwJ+q/N4H+mop2HpXgJHcT/sCGI5xUGe3hEcYZ+GGGpFEUtT0RMk
   jvI5XLGjmSEtkTDUwrSAu5K/b8lejmiZo0qFiJQ1NoLVwD+meecSeNOmB
   SqRvZsoX278/U89KFJuw4j5j0VqoPzfVv4ua4x+qxE0FXxkPLO3m1fibC
   1IzBL9AOHdrQbQvfbCRsytsqj1e73zeRY5BJNaf+Po3QXRNahI1zrFve6
   PWhqIOKSF8IE76Sd6pgOx0Oe5lHwxtRQNi7WCqJDhnpsW2TKaTYZJglS/
   T6m9h+MisU/QKkP0Gtf8E6JurSVlL/XUotkl0PNk+fXXEXdMumILs4Bf3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="14746449"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="14746449"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 00:35:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="9238207"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.218]) ([10.238.8.218])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 00:35:36 -0800
Message-ID: <02794f06-1da7-4ea0-8c31-6a09aeadbcea@linux.intel.com>
Date: Tue, 5 Mar 2024 16:35:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/21] KVM: x86/mmu: Track shadow MMIO value on a per-VM
 basis
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-7-pbonzini@redhat.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240227232100.478238-7-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> TDX will use a different shadow PTE entry value for MMIO from VMX.  Add
> members to kvm_arch and track value for MMIO per-VM instead of global

Nit: members -> a member, since only 'shadow_mmio_value' is added.

> variables.  By using the per-VM EPT entry value for MMIO, the existing VMX
> logic is kept working.  Introduce a separate setter function so that guest
> TD can override later.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-Id: <229a18434e5d83f45b1fcd7bf1544d79db1becb6.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h |  2 ++
>   arch/x86/kvm/mmu.h              |  1 +
>   arch/x86/kvm/mmu/mmu.c          |  8 +++++---
>   arch/x86/kvm/mmu/spte.c         | 10 ++++++++--
>   arch/x86/kvm/mmu/spte.h         |  4 ++--
>   arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++---
>   6 files changed, 21 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 85dc0f7d09e3..a4514c2ef0ec 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1313,6 +1313,8 @@ struct kvm_arch {
>   	 */
>   	spinlock_t mmu_unsync_pages_lock;
>   
> +	u64 shadow_mmio_value;
> +
>   	struct iommu_domain *iommu_domain;
>   	bool iommu_noncoherent;
>   #define __KVM_HAVE_ARCH_NONCOHERENT_DMA
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..2c54ba5b0a28 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -101,6 +101,7 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>   }
>   
>   void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
> +void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value);
>   void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>   void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
>   
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b5baf11359ad..195e46a1f00f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2515,7 +2515,7 @@ static int mmu_page_zap_pte(struct kvm *kvm, struct kvm_mmu_page *sp,
>   				return kvm_mmu_prepare_zap_page(kvm, child,
>   								invalid_list);
>   		}
> -	} else if (is_mmio_spte(pte)) {
> +	} else if (is_mmio_spte(kvm, pte)) {
>   		mmu_spte_clear_no_track(spte);
>   	}
>   	return 0;
> @@ -4197,7 +4197,7 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
>   	if (WARN_ON_ONCE(reserved))
>   		return -EINVAL;
>   
> -	if (is_mmio_spte(spte)) {
> +	if (is_mmio_spte(vcpu->kvm, spte)) {
>   		gfn_t gfn = get_mmio_spte_gfn(spte);
>   		unsigned int access = get_mmio_spte_access(spte);
>   
> @@ -4813,7 +4813,7 @@ EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
>   static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
>   			   unsigned int access)
>   {
> -	if (unlikely(is_mmio_spte(*sptep))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, *sptep))) {
>   		if (gfn != get_mmio_spte_gfn(*sptep)) {
>   			mmu_spte_clear_no_track(sptep);
>   			return true;
> @@ -6320,6 +6320,8 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
>   
>   void kvm_mmu_init_vm(struct kvm *kvm)
>   {
> +
> +	kvm->arch.shadow_mmio_value = shadow_mmio_value;
>   	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
>   	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
>   	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 02a466de2991..318135daf685 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -74,10 +74,10 @@ u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access)
>   	u64 spte = generation_mmio_spte_mask(gen);
>   	u64 gpa = gfn << PAGE_SHIFT;
>   
> -	WARN_ON_ONCE(!shadow_mmio_value);
> +	WARN_ON_ONCE(!vcpu->kvm->arch.shadow_mmio_value);
>   
>   	access &= shadow_mmio_access_mask;
> -	spte |= shadow_mmio_value | access;
> +	spte |= vcpu->kvm->arch.shadow_mmio_value | access;
>   	spte |= gpa | shadow_nonpresent_or_rsvd_mask;
>   	spte |= (gpa & shadow_nonpresent_or_rsvd_mask)
>   		<< SHADOW_NONPRESENT_OR_RSVD_MASK_LEN;
> @@ -411,6 +411,12 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
>   }
>   EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_mask);
>   
> +void kvm_mmu_set_mmio_spte_value(struct kvm *kvm, u64 mmio_value)
> +{
> +	kvm->arch.shadow_mmio_value = mmio_value;
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_set_mmio_spte_value);
> +
>   void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask)
>   {
>   	/* shadow_me_value must be a subset of shadow_me_mask */
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 26bc95bbc962..1a163aee9ec6 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -264,9 +264,9 @@ static inline struct kvm_mmu_page *root_to_sp(hpa_t root)
>   	return spte_to_child_sp(root);
>   }
>   
> -static inline bool is_mmio_spte(u64 spte)
> +static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
>   {
> -	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
> +	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
>   	       likely(enable_mmio_caching);
>   }
>   
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c8a4d92497b4..d15c44a8e123 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -495,8 +495,8 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
>   		 * impact the guest since both the former and current SPTEs
>   		 * are nonpresent.
>   		 */
> -		if (WARN_ON_ONCE(!is_mmio_spte(old_spte) &&
> -				 !is_mmio_spte(new_spte) &&
> +		if (WARN_ON_ONCE(!is_mmio_spte(kvm, old_spte) &&
> +				 !is_mmio_spte(kvm, new_spte) &&
>   				 !is_removed_spte(new_spte)))
>   			pr_err("Unexpected SPTE change! Nonpresent SPTEs\n"
>   			       "should not be replaced with another,\n"
> @@ -1028,7 +1028,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   	}
>   
>   	/* If a MMIO SPTE is installed, the MMIO will need to be emulated. */
> -	if (unlikely(is_mmio_spte(new_spte))) {
> +	if (unlikely(is_mmio_spte(vcpu->kvm, new_spte))) {
>   		vcpu->stat.pf_mmio_spte_created++;
>   		trace_mark_mmio_spte(rcu_dereference(iter->sptep), iter->gfn,
>   				     new_spte);


