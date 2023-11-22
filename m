Return-Path: <kvm+bounces-2248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 74BF67F3DBD
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 06:46:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF459B20FF3
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 05:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A0114263;
	Wed, 22 Nov 2023 05:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jaeeb/h2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3970185;
	Tue, 21 Nov 2023 21:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700631960; x=1732167960;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zbu2jPNAJCJoTcvYCqsIzf59jhjUHMCNCUZVzkS116I=;
  b=jaeeb/h2my4sDgBIQwD1wz+UV67fuVqijfbHCVjuizkCiW8Eh6Q2l2Yl
   X/Q+CXDrz6MqAqtxzQjyEYX7o1XteeMVuzkAcFXX0AMDLcxMIULQ13VbH
   M76lyeXPQP+naSZxBs+sftqw83aqpfhcGon9DsqxJWK8B3zqoxYVM3M7U
   pKPX8dbBd0q8dd+/ghbebTdtcT3uZT3eWnvi2LB6TVqYf/mLr7N4X6KkC
   ydK2+76MJTsLS8CcgvTnxkPYVEwvRiRB1LHqeSYc9iVpPLRXEnaMTmJJI
   UG4kWTW0A1mvGLgXEAE77LDN6zVH+0WRLlETZU0lxTi7IMYEzp60Lhfci
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="5126007"
X-IronPort-AV: E=Sophos;i="6.04,217,1695711600"; 
   d="scan'208";a="5126007"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 21:45:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,217,1695711600"; 
   d="scan'208";a="14776664"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.126]) ([10.238.10.126])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 21:45:49 -0800
Message-ID: <e789b9f5-a7cb-479d-8678-76cfb7bb946e@linux.intel.com>
Date: Wed, 22 Nov 2023 13:45:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/16] KVM: x86/tdp_mmu, TDX: Split a large page when
 4KB page within it converted to shared
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, David Matlack <dmatlack@google.com>,
 Kai Huang <kai.huang@intel.com>, Zhi Wang <zhi.wang.linux@gmail.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1699368363.git.isaku.yamahata@intel.com>
 <051d18f03ff70a66387ec37988d1ffd29f43f4f5.1699368363.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <051d18f03ff70a66387ec37988d1ffd29f43f4f5.1699368363.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/7/2023 11:00 PM, isaku.yamahata@intel.com wrote:
> From: Xiaoyao Li <xiaoyao.li@intel.com>
>
> When mapping the shared page for TDX, it needs to zap private alias.
>
> In the case that private page is mapped as large page (2MB), it can be
> removed directly only when the whole 2MB is converted to shared.
> Otherwise, it has to split 2MB page into 512 4KB page, and only remove
> the pages that converted to shared.
>
> When a present large leaf spte switches to present non-leaf spte, TDX needs
> to split the corresponding SEPT page to reflect it.
>
> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm-x86-ops.h |  1 +
>   arch/x86/include/asm/kvm_host.h    |  2 ++
>   arch/x86/kvm/mmu/tdp_mmu.c         | 21 ++++++++++++++++-----
>   arch/x86/kvm/vmx/tdx.c             | 25 +++++++++++++++++++++++--
>   arch/x86/kvm/vmx/tdx_arch.h        |  1 +
>   arch/x86/kvm/vmx/tdx_ops.h         |  7 +++++++
>   6 files changed, 50 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 8ef0ed217f6e..3deb6ab4f291 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -103,6 +103,7 @@ KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>   KVM_X86_OP(load_mmu_pgd)
>   KVM_X86_OP_OPTIONAL(link_private_spt)
>   KVM_X86_OP_OPTIONAL(free_private_spt)
> +KVM_X86_OP_OPTIONAL(split_private_spt)
>   KVM_X86_OP_OPTIONAL(set_private_spte)
>   KVM_X86_OP_OPTIONAL(remove_private_spte)
>   KVM_X86_OP_OPTIONAL(zap_private_spte)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c16823f3326e..e75a461bdea7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1753,6 +1753,8 @@ struct kvm_x86_ops {
>   				void *private_spt);
>   	int (*free_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>   				void *private_spt);
> +	int (*split_private_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> +				  void *private_spt);
>   	int (*set_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>   				 kvm_pfn_t pfn);
>   	int (*remove_private_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index a209a67decae..734ee822b43c 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -599,23 +599,34 @@ static int __must_check __set_private_spte_present(struct kvm *kvm, tdp_ptep_t s
>   {
>   	bool was_present = is_shadow_present_pte(old_spte);
>   	bool is_present = is_shadow_present_pte(new_spte);
> +	bool was_leaf = was_present && is_last_spte(old_spte, level);
>   	bool is_leaf = is_present && is_last_spte(new_spte, level);
>   	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
> +	void *private_spt;
>   	int ret = 0;
>   
>   	lockdep_assert_held(&kvm->mmu_lock);
> -	/* TDP MMU doesn't change present -> present */
> -	KVM_BUG_ON(was_present, kvm);
>   
>   	/*
>   	 * Use different call to either set up middle level
>   	 * private page table, or leaf.
>   	 */
> -	if (is_leaf)
> +	if (level > PG_LEVEL_4K && was_leaf && !is_leaf) {
> +		/*
> +		 * splitting large page into 4KB.
> +		 * tdp_mmu_split_huage_page() => tdp_mmu_link_sp()
Typo, tdp_mmu_split_huage_page -> tdp_mmu_split_huge_page

> +		 */
> +		private_spt = get_private_spt(gfn, new_spte, level);
> +		KVM_BUG_ON(!private_spt, kvm);
> +		ret = static_call(kvm_x86_zap_private_spte)(kvm, gfn, level);
> +		kvm_flush_remote_tlbs(kvm);
> +		if (!ret)
> +			ret = static_call(kvm_x86_split_private_spt)(kvm, gfn,
> +								     level, private_spt);
> +	} else if (is_leaf)
>   		ret = static_call(kvm_x86_set_private_spte)(kvm, gfn, level, new_pfn);
>   	else {
> -		void *private_spt = get_private_spt(gfn, new_spte, level);
> -
> +		private_spt = get_private_spt(gfn, new_spte, level);
>   		KVM_BUG_ON(!private_spt, kvm);
>   		ret = static_call(kvm_x86_link_private_spt)(kvm, gfn, level, private_spt);
>   	}
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c614ab20c191..91eca578a7da 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1662,6 +1662,28 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
>   	return 0;
>   }
>   
> +static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
> +				      enum pg_level level, void *private_spt)
> +{
> +	int tdx_level = pg_level_to_tdx_sept_level(level);
> +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
> +	hpa_t hpa = __pa(private_spt);
> +	struct tdx_module_args out;
> +	u64 err;
> +
> +	/* See comment in tdx_sept_set_private_spte() */
Do you mean the comment about the pages are pinned to prevent migration 
part?
Can you add some specific short information in this comment, in case
tdx_sept_set_private_spte() is extended to have more comments in the future?

> +	err = tdh_mem_page_demote(kvm_tdx->tdr_pa, gpa, tdx_level, hpa, &out);
> +	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
> +		return -EAGAIN;
> +	if (KVM_BUG_ON(err, kvm)) {
> +		pr_tdx_error(TDH_MEM_PAGE_DEMOTE, err, &out);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
>   static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>   				      enum pg_level level)
>   {
> @@ -1675,8 +1697,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>   	if (unlikely(!is_hkid_assigned(kvm_tdx)))
>   		return 0;
>   
> -	/* For now large page isn't supported yet. */
> -	WARN_ON_ONCE(level != PG_LEVEL_4K);
>   	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &out);
>   	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
>   		return -EAGAIN;
> @@ -3183,6 +3203,7 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
>   
>   	x86_ops->link_private_spt = tdx_sept_link_private_spt;
>   	x86_ops->free_private_spt = tdx_sept_free_private_spt;
> +	x86_ops->split_private_spt = tdx_sept_split_private_spt;
>   	x86_ops->set_private_spte = tdx_sept_set_private_spte;
>   	x86_ops->remove_private_spte = tdx_sept_remove_private_spte;
>   	x86_ops->zap_private_spte = tdx_sept_zap_private_spte;
> diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
> index ba41fefa47ee..cab6a74446a0 100644
> --- a/arch/x86/kvm/vmx/tdx_arch.h
> +++ b/arch/x86/kvm/vmx/tdx_arch.h
> @@ -21,6 +21,7 @@
>   #define TDH_MNG_CREATE			9
>   #define TDH_VP_CREATE			10
>   #define TDH_MNG_RD			11
> +#define TDH_MEM_PAGE_DEMOTE		15
>   #define TDH_MR_EXTEND			16
>   #define TDH_MR_FINALIZE			17
>   #define TDH_VP_FLUSH			18
> diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
> index 0f2df7198bde..38ab0ab1509c 100644
> --- a/arch/x86/kvm/vmx/tdx_ops.h
> +++ b/arch/x86/kvm/vmx/tdx_ops.h
> @@ -183,6 +183,13 @@ static inline u64 tdh_mng_rd(hpa_t tdr, u64 field, struct tdx_module_args *out)
>   	return tdx_seamcall(TDH_MNG_RD, tdr, field, 0, 0, out);
>   }
>   
> +static inline u64 tdh_mem_page_demote(hpa_t tdr, gpa_t gpa, int level, hpa_t page,
> +				      struct tdx_module_args *out)
> +{
> +	tdx_clflush_page(page, PG_LEVEL_4K);
> +	return tdx_seamcall_sept(TDH_MEM_PAGE_DEMOTE, gpa | level, tdr, page, 0, out);
> +}
> +
>   static inline u64 tdh_mr_extend(hpa_t tdr, gpa_t gpa,
>   				struct tdx_module_args *out)
>   {


