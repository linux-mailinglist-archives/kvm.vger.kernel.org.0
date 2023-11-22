Return-Path: <kvm+bounces-2259-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0F257F4131
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 10:06:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F5621C20A1D
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 09:06:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE6A3C6A9;
	Wed, 22 Nov 2023 09:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B55z53qs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0940F359B;
	Wed, 22 Nov 2023 01:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700643951; x=1732179951;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZV4v3ZL1hjdt47vWaLz2wx1T0ywHDaLvuBT2yNfWDQU=;
  b=B55z53qskeOkgCwg6Bw5mcIQFYNiDa43QuBq+YT7J2QP0fxFggsUtHVk
   qijMPn1Xl0WwWcxds5zQ6EfibyDXmAtEPkJhN90H8zu3O5oPBQu80Xm9m
   WWw84ZYyuKV/NUgHfh39xlVvfZ4Ry1ojcsVAWsjnJb+LcDXGEGYsPv7ns
   ZplRFp3KohJ9g7FkqhWXEs68Ex1uQ11TTd21ShJlfIXvr0tHFgX/kw6w7
   NstUrpUO2L3aHy5LmkHQwIIDNHzqwa7EZCKG9zbc8n5CspmNgT1LgbDbL
   lP8K7EB5Luh91pLPEXSj+pChcMdIIAiwNTHYt7tKco9raDiv9Xly5fP7g
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="10678097"
X-IronPort-AV: E=Sophos;i="6.04,218,1695711600"; 
   d="scan'208";a="10678097"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 01:05:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="832946770"
X-IronPort-AV: E=Sophos;i="6.04,218,1695711600"; 
   d="scan'208";a="832946770"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.0.129]) ([10.238.0.129])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2023 01:05:45 -0800
Message-ID: <376511f8-1d84-41fc-84ad-73d2f0ed3af1@linux.intel.com>
Date: Wed, 22 Nov 2023 17:05:43 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 15/16] KVM: x86/mmu: Make kvm fault handler aware of
 large page of private memslot
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <075de567893a2b09bdfb203ae7ecd1867e5c3d8e.1699368363.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <075de567893a2b09bdfb203ae7ecd1867e5c3d8e.1699368363.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> struct kvm_page_fault.req_level is the page level which takes care of the
> faulted-in page size.  For now its calculation is only for the conventional
> kvm memslot by host_pfn_mapping_level() that traverses page table.
>
> However, host_pfn_mapping_level() cannot be used for private kvm memslot
> because pages of private kvm memlost aren't mapped into user virtual
> address space.

The description here is not accurate.  A memslot can be private doesn't mean
all pages of the memslot can't be mapped into user virtual address space.

> Instead page order is given when getting pfn.  Remember it
> in struct kvm_page_fault and use it.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c          | 34 +++++++++++++++++----------------
>   arch/x86/kvm/mmu/mmu_internal.h | 12 +++++++++++-
>   arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>   3 files changed, 30 insertions(+), 18 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0bf043812644..0aec7c11f4e2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3158,10 +3158,10 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn,
>   
>   static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>   				       const struct kvm_memory_slot *slot,
> -				       gfn_t gfn, int max_level, bool is_private)
> +				       gfn_t gfn, int max_level, int host_level,
> +				       bool is_private)
>   {
>   	struct kvm_lpage_info *linfo;
> -	int host_level;
>   
>   	max_level = min(max_level, max_huge_page_level);
>   	for ( ; max_level > PG_LEVEL_4K; max_level--) {
> @@ -3170,24 +3170,23 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
>   			break;
>   	}
>   
> -	if (is_private)
> -		return max_level;
> -
>   	if (max_level == PG_LEVEL_4K)
>   		return PG_LEVEL_4K;
>   
> -	host_level = host_pfn_mapping_level(kvm, gfn, slot);
> +	if (!is_private) {
> +		WARN_ON_ONCE(host_level != PG_LEVEL_NONE);
> +		host_level = host_pfn_mapping_level(kvm, gfn, slot);
> +	}
> +	WARN_ON_ONCE(host_level == PG_LEVEL_NONE);
>   	return min(host_level, max_level);
>   }
>   
>   int kvm_mmu_max_mapping_level(struct kvm *kvm,
>   			      const struct kvm_memory_slot *slot, gfn_t gfn,
> -			      int max_level)
> +			      int max_level, bool faultin_private)

When the parameter "faultin_private" is added, the only valid value is
"false".  If the caller passes in "faultin_private = true", then it 
would be a
problem based on this patch.
It seems meaningless and confusing to introduce the parameter 
"faultin_private"
here.

>   {
> -	bool is_private = kvm_slot_can_be_private(slot) &&
> -			  kvm_mem_is_private(kvm, gfn);
> -
> -	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, max_level, is_private);
> +	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, max_level,
> +					   PG_LEVEL_NONE, faultin_private);
>   }
>   
>   void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> @@ -3212,7 +3211,8 @@ void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>   	 */
>   	fault->req_level = __kvm_mmu_max_mapping_level(vcpu->kvm, slot,
>   						       fault->gfn, fault->max_level,
> -						       fault->is_private);
> +						       fault->host_level,
> +						       kvm_is_faultin_private(fault));
>   	if (fault->req_level == PG_LEVEL_4K || fault->huge_page_disallowed)
>   		return;
>   
> @@ -4336,6 +4336,7 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>   				   struct kvm_page_fault *fault)
>   {
>   	int max_order, r;
> +	u8 max_level;
>   
>   	if (!kvm_slot_can_be_private(fault->slot)) {
>   		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> @@ -4349,8 +4350,9 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
>   		return r;
>   	}
>   
> -	fault->max_level = min(kvm_max_level_for_order(max_order),
> -			       fault->max_level);
> +	max_level = kvm_max_level_for_order(max_order);
> +	fault->host_level = max_level;
> +	fault->max_level = min(max_level, fault->max_level);
>   	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
>   
>   	return RET_PF_CONTINUE;
> @@ -4400,7 +4402,7 @@ static int __kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>   		return -EFAULT;
>   	}
>   
> -	if (fault->is_private)
> +	if (kvm_is_faultin_private(fault))
>   		return kvm_faultin_pfn_private(vcpu, fault);
>   
>   	async = false;
> @@ -6809,7 +6811,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>   		 */
>   		if (sp->role.direct &&
>   		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
> -							       PG_LEVEL_NUM)) {
> +							       PG_LEVEL_NUM, false)) {
>   			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
>   
>   			if (kvm_available_flush_remote_tlbs_range())
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 653e96769956..6b540a10fd67 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -357,6 +357,9 @@ struct kvm_page_fault {
>   	 * is changing its own translation in the guest page tables.
>   	 */
>   	bool write_fault_to_shadow_pgtable;
> +
> +	/* valid only for private memslot && private gfn */
> +	enum pg_level host_level;
>   };
>   
>   int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
> @@ -451,7 +454,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   
>   int kvm_mmu_max_mapping_level(struct kvm *kvm,
>   			      const struct kvm_memory_slot *slot, gfn_t gfn,
> -			      int max_level);
> +			      int max_level, bool faultin_private);
>   void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
>   void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
>   
> @@ -469,4 +472,11 @@ static inline bool kvm_hugepage_test_mixed(struct kvm_memory_slot *slot, gfn_t g
>   }
>   #endif
>   
> +static inline bool kvm_is_faultin_private(const struct kvm_page_fault *fault)
> +{
> +	if (IS_ENABLED(CONFIG_KVM_GENERIC_PRIVATE_MEM))
> +		return fault->is_private && kvm_slot_can_be_private(fault->slot);
> +	return false;
> +}
> +
>   #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index c8a4bd052c71..173e4e9053fc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -2179,7 +2179,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
>   			continue;
>   
>   		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
> -							      iter.gfn, PG_LEVEL_NUM);
> +							      iter.gfn, PG_LEVEL_NUM, false);
>   		if (max_mapping_level < iter.level)
>   			continue;
>   


