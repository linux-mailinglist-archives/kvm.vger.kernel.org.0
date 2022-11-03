Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB108617777
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 08:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230396AbiKCHRg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 03:17:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbiKCHRf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 03:17:35 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E3BF40;
        Thu,  3 Nov 2022 00:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667459854; x=1698995854;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9YF94baTRanLdOq1DDZqkrIryF2twS98gmdRT2l0G9k=;
  b=ZHI8xMTCLoaQkU0JDLRRzzf0IAiqqVlnuhPiurnPzNgT2rECW4QnalcG
   Ci0SMguOefwHb15itf9bj1HAFU+O1+9x8/kZwra/72LNWwv8skujlchti
   LAPe+eGscgntqgXjcm4uSQtPWHA0QLICfYzfFiYyUNpqUlS9PHRjF8t6V
   MwJz9vWObeDlOwEtI5Pli1PW8QVGuAqEfMD33YxyurVwISKbRGtj3TymM
   H9rAs7p36CxQ0Gjv91EIIyD5sDprB83EeGQF1e6+hoqGg7ByzzM8YLadQ
   1IsPFb+wuEVT9FSYbNIEFgNSOSw7dM0/ivN+CEGw16mDUIVF/3exEbCOt
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="395913623"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="395913623"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 00:17:33 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="634564175"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="634564175"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.255.28.201]) ([10.255.28.201])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 00:17:30 -0700
Message-ID: <4865ef9b-8b51-107b-d6c4-40db55bcbe06@linux.intel.com>
Date:   Thu, 3 Nov 2022 15:17:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v10 031/108] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <0de1d5dfbce49b5e9d4f93289296b726180b8dd0.1667110240.git.isaku.yamahata@intel.com>
From:   Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <0de1d5dfbce49b5e9d4f93289296b726180b8dd0.1667110240.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2022/10/30 14:22, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> The TDX support will need the "suppress #VE" bit (bit 63) set as the
> initial value for SPTE.  To reduce code change size, introduce a new macro
> SHADOW_NONPRESENT_VALUE for the initial value for the shadow page table
> entry (SPTE) and replace hard-coded value 0 for it.  Initialize shadow page
> tables with their value.
>
> The plan is to unconditionally set the "suppress #VE" bit for both AMD and
> Intel as: 1) AMD hardware doesn't use this bit; 2) for conventional VMX
> guests, KVM never enables the "EPT-violation #VE" in VMCS control and
> "suppress #VE" bit is ignored by hardware.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c     | 50 +++++++++++++++++++++++++++++++++-----
>   arch/x86/kvm/mmu/spte.h    |  2 ++
>   arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++++------
>   3 files changed, 54 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 10017a9f26ee..e7e11f51f8b4 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -538,9 +538,9 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
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
> @@ -574,7 +574,7 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>    */
>   static void mmu_spte_clear_no_track(u64 *sptep)
>   {
> -	__update_clear_spte_fast(sptep, 0ull);
> +	__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
>   }
>   
>   static u64 mmu_spte_get_lockless(u64 *sptep)
> @@ -642,6 +642,39 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>   	}
>   }
>   

Why the changes in mmu_spte_clear_track_bits and mmu_spte_clear_no_track 
are not handled differently for X86_64 and non X86_64 as the shadow page 
init below?
It seems the two functions are the common code.


> +#ifdef CONFIG_X86_64
> +static inline void kvm_init_shadow_page(void *page)
> +{
> +	memset64(page, SHADOW_NONPRESENT_VALUE, 4096 / 8);
> +}
> +
> +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
> +	int start, end, i, r;
> +
> +	start = kvm_mmu_memory_cache_nr_free_objects(mc);
> +	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
> +
> +	/*
> +	 * Note, topup may have allocated objects even if it failed to allocate
> +	 * the minimum number of objects required to make forward progress _at
> +	 * this time_.  Initialize newly allocated objects even on failure, as
> +	 * userspace can free memory and rerun the vCPU in response to -ENOMEM.
> +	 */
> +	end = kvm_mmu_memory_cache_nr_free_objects(mc);
> +	for (i = start; i < end; i++)
> +		kvm_init_shadow_page(mc->objects[i]);
> +	return r;
> +}
> +#else
> +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> +					  PT64_ROOT_MAX_LEVEL);
> +}
> +#endif /* CONFIG_X86_64 */
> +
>   static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>   {
>   	int r;
> @@ -651,8 +684,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>   				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>   	if (r)
>   		return r;
> -	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> -				       PT64_ROOT_MAX_LEVEL);
> +	r = mmu_topup_shadow_page_cache(vcpu);
>   	if (r)
>   		return r;
>   	if (maybe_indirect) {
> @@ -5870,7 +5902,13 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>   	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
>   	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>   
> -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +	/*
> +	 * When X86_64, initial SEPT entries are initialized with
> +	 * SHADOW_NONPRESENT_VALUE.  Otherwise zeroed.  See
> +	 * mmu_topup_shadow_page_cache().
> +	 */
> +	if (!IS_ENABLED(CONFIG_X86_64))
> +		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>   
>   	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>   	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 7670c13ce251..42ecaa75da15 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -148,6 +148,8 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
>   
>   #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
>   
> +#define SHADOW_NONPRESENT_VALUE	0ULL
> +
>   extern u64 __read_mostly shadow_host_writable_mask;
>   extern u64 __read_mostly shadow_mmu_writable_mask;
>   extern u64 __read_mostly shadow_nx_mask;
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index eab765442d0b..38bc4c2f0f1f 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -694,7 +694,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>   	 * here since the SPTE is going from non-present to non-present.  Use
>   	 * the raw write helper to avoid an unnecessary check on volatile bits.
>   	 */
> -	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
> +	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
>   
>   	return 0;
>   }
> @@ -871,8 +871,8 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>   			continue;
>   
>   		if (!shared)
> -			tdp_mmu_set_spte(kvm, &iter, 0);
> -		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
> +			tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> +		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
>   			goto retry;
>   	}
>   }
> @@ -928,8 +928,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>   	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
>   		return false;
>   
> -	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
> -			   sp->gfn, sp->role.level + 1, true, true);
> +	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
> +			   SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1,
> +			   true, true);
>   
>   	return true;
>   }
> @@ -963,7 +964,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>   		    !is_last_spte(iter.old_spte, iter.level))
>   			continue;
>   
> -		tdp_mmu_set_spte(kvm, &iter, 0);
> +		tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
>   		flush = true;
>   	}
>   
> @@ -1328,7 +1329,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>   	 * invariant that the PFN of a present * leaf SPTE can never change.
>   	 * See __handle_changed_spte().
>   	 */
> -	tdp_mmu_set_spte(kvm, iter, 0);
> +	tdp_mmu_set_spte(kvm, iter, SHADOW_NONPRESENT_VALUE);
>   
>   	if (!pte_write(range->pte)) {
>   		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
