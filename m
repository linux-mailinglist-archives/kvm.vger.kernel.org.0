Return-Path: <kvm+bounces-10878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 375CD871646
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 08:10:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E32A72812A2
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 07:10:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1F317D40A;
	Tue,  5 Mar 2024 07:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C1WFQn7u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1477D3F6;
	Tue,  5 Mar 2024 07:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709622596; cv=none; b=cChpQeeprB0e6BoRvlYlSseXbQaTtlHq1bWYOQLI8b4p2/Yqzn0CLY+E04FfK2cCo/2tJ6KU6CmyNQpcc2GdG2n7d3exc/G7jJTUQpcjIgaWbadcnOb+5xOmCOLtcwRRYEg2vTuTTQKDjwlnx2b9Yu/vBJGrAlRgz8HF/05B0CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709622596; c=relaxed/simple;
	bh=MnBtUSdZcoCoste9RSTFcwDFvJSGAo578I2Y/4w+c2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bUtvq6J9utfkCP6w7IcerJDgIw0h1OMH57XkPCC/xKppd7+JZn+OvVHesZLYVcqSS2KYh5UzVCYfsbzjmGOp8NNBv372xImg3pd+2gm6N6siW9bdMBymJ6oLxtB0M+1j1v1kX0vd5ih9DCa56zQ2UFOuU1zYl9/4N9CCrHFE9rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C1WFQn7u; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709622595; x=1741158595;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MnBtUSdZcoCoste9RSTFcwDFvJSGAo578I2Y/4w+c2w=;
  b=C1WFQn7ubABGdJE0gw2ql+z/MA01FZXfKvgK7qiyRDVNS6hnJ2DcknbS
   LE3uvlznpZgvtIrvtXkFvoilifajmY1jTneBRgJQhRG0VLkU17jZ+TYHD
   DcpRgQTcdNs4avs5BoLk2VwD0hnvXQtVO/+q0nuT/cwv6rJxMzZH9d+ge
   ipFBZ2g9tUXaC1tnVtrenKhoFKsPigqyuESa6Je8Guxwnu7VUSWxtMbeZ
   dXqio2XM4iMLHU9y+KCQ0ACBY90qGaQJcPZz5qOJFNZDKbyj3K6LRcWoa
   kyZcbEw+fo6sQC+DEJ7WWiC2/zCaFy2kBfUWu9EEHtEyaw+AHPlAZVekK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11003"; a="4019210"
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="4019210"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 23:09:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,205,1705392000"; 
   d="scan'208";a="13773274"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.8.218]) ([10.238.8.218])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2024 23:09:51 -0800
Message-ID: <24bd2571-852e-47e6-a08b-17e808d14fd5@linux.intel.com>
Date: Tue, 5 Mar 2024 15:09:48 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/21] KVM: x86/mmu: Replace hardcoded value 0 for the
 initial value for SPTE
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
 michael.roth@amd.com, isaku.yamahata@intel.com, thomas.lendacky@amd.com
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-4-pbonzini@redhat.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240227232100.478238-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/28/2024 7:20 AM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> The TDX support will need the "suppress #VE" bit (bit 63) set as the
> initial value for SPTE.  To reduce code change size, introduce a new macro
> SHADOW_NONPRESENT_VALUE for the initial value for the shadow page table
> entry (SPTE) and replace hard-coded value 0 for it.  Initialize shadow page
> tables with their value.
>
> The plan is to unconditionally set the "suppress #VE" bit for both AMD and
> Intel as: 1) AMD hardware uses the bit 63 as NX for present SPTE and
> ignored for non-present SPTE; 2) for conventional VMX guests, KVM never
> enables the "EPT-violation #VE" in VMCS control and "suppress #VE" bit is
> ignored by hardware.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Message-Id: <acdf09bf60cad12c495005bf3495c54f6b3069c9.1705965635.git.isaku.yamahata@intel.com>
> [Remove unnecessary CONFIG_X86_64 check. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/mmu/mmu.c         | 14 +++++++++-----
>   arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>   arch/x86/kvm/mmu/spte.h        |  2 ++
>   arch/x86/kvm/mmu/tdp_mmu.c     | 14 +++++++-------
>   4 files changed, 19 insertions(+), 13 deletions(-)

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

BTW, does it prefer to add "No functional change intended." in changelog for
a patch like this?

>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e4cc7f764980..b5baf11359ad 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -567,9 +567,9 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>   
>   	if (!is_shadow_present_pte(old_spte) ||
>   	    !spte_has_volatile_bits(old_spte))
> -		__update_clear_spte_fast(sptep, 0ull);
> +		__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
>   	else
> -		old_spte = __update_clear_spte_slow(sptep, 0ull);
> +		old_spte = __update_clear_spte_slow(sptep, SHADOW_NONPRESENT_VALUE);
>   
>   	if (!is_shadow_present_pte(old_spte))
>   		return old_spte;
> @@ -603,7 +603,7 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>    */
>   static void mmu_spte_clear_no_track(u64 *sptep)
>   {
> -	__update_clear_spte_fast(sptep, 0ull);
> +	__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
>   }
>   
>   static u64 mmu_spte_get_lockless(u64 *sptep)
> @@ -1950,7 +1950,8 @@ static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>   
>   static int kvm_sync_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
>   {
> -	if (!sp->spt[i])
> +	/* sp->spt[i] has initial value of shadow page table allocation */
> +	if (sp->spt[i] == SHADOW_NONPRESENT_VALUE)
>   		return 0;
>   
>   	return vcpu->arch.mmu->sync_spte(vcpu, sp, i);
> @@ -6173,7 +6174,10 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>   	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
>   	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>   
> -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +	vcpu->arch.mmu_shadow_page_cache.init_value =
> +		SHADOW_NONPRESENT_VALUE;
> +	if (!vcpu->arch.mmu_shadow_page_cache.init_value)
> +		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>   
>   	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>   	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 4d4e98fe4f35..bebd73cd61bb 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -911,7 +911,7 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
>   	gpa_t pte_gpa;
>   	gfn_t gfn;
>   
> -	if (WARN_ON_ONCE(!sp->spt[i]))
> +	if (WARN_ON_ONCE(sp->spt[i] == SHADOW_NONPRESENT_VALUE))
>   		return 0;
>   
>   	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index a129951c9a88..4d1799ba2bf8 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -149,6 +149,8 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
>   
>   #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
>   
> +#define SHADOW_NONPRESENT_VALUE	0ULL
> +
>   extern u64 __read_mostly shadow_host_writable_mask;
>   extern u64 __read_mostly shadow_mmu_writable_mask;
>   extern u64 __read_mostly shadow_nx_mask;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index d078157e62aa..c8a4d92497b4 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -603,7 +603,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>   	 * here since the SPTE is going from non-present to non-present.  Use
>   	 * the raw write helper to avoid an unnecessary check on volatile bits.
>   	 */
> -	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
> +	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
>   
>   	return 0;
>   }
> @@ -740,8 +740,8 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>   			continue;
>   
>   		if (!shared)
> -			tdp_mmu_iter_set_spte(kvm, &iter, 0);
> -		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
> +			tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> +		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
>   			goto retry;
>   	}
>   }
> @@ -808,8 +808,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
>   		return false;
>   
> -	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
> -			 sp->gfn, sp->role.level + 1);
> +	tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
> +			 SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1);
>   
>   	return true;
>   }
> @@ -843,7 +843,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>   		    !is_last_spte(iter.old_spte, iter.level))
>   			continue;
>   
> -		tdp_mmu_iter_set_spte(kvm, &iter, 0);
> +		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
>   
>   		/*
>   		 * Zappings SPTEs in invalid roots doesn't require a TLB flush,
> @@ -1276,7 +1276,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>   	 * invariant that the PFN of a present * leaf SPTE can never change.
>   	 * See handle_changed_spte().
>   	 */
> -	tdp_mmu_iter_set_spte(kvm, iter, 0);
> +	tdp_mmu_iter_set_spte(kvm, iter, SHADOW_NONPRESENT_VALUE);
>   
>   	if (!pte_write(range->arg.pte)) {
>   		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,


