Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99CE47236D5
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 07:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbjFFFbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 01:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjFFFbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 01:31:16 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2373D1B1;
        Mon,  5 Jun 2023 22:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686029475; x=1717565475;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6XLjfDvI/7YAdozf3uM1i/r0+n9p2mhEWmLgE3TeBTE=;
  b=Y1RFvSLW7KU5W4uSutDP/m3JIbucumr4fdzRCnVmUOIxkrAh8tufKG5U
   xsTuD7wzeKlZPmv2CJyWAuZxw8y9c+a5aO9b0Bp3d3yaQrevw/X/ublf4
   R8AD/+EwfC7aSrgC2QbRZGieq3KY1yZMqA+Fp+Xp1p3MYfN+dNZxvbqbT
   JIXZWA2lGzbKQoWE1R40L8Yo3tLNQ3im+fP0aSRCo50MOIFYhWBDCW9vJ
   +eEY+/cKCyjzjDHuObzNIGoUoU1SB9eJDgkDU/Iotn7RHZfTigEGUijo+
   Bh0Mk8VflrTxquF4/6pl+VaFOrTg3G/5SCLFElSoVDy89o029Ary4wWpz
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="420115709"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="420115709"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 22:31:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="798687338"
X-IronPort-AV: E=Sophos;i="6.00,219,1681196400"; 
   d="scan'208";a="798687338"
Received: from danwu1-mobl.ccr.corp.intel.com (HELO [10.238.6.21]) ([10.238.6.21])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 22:31:11 -0700
Message-ID: <2710f9c8-cddc-1441-f2b6-7d0616880f1d@intel.com>
Date:   Tue, 6 Jun 2023 13:31:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v14 031/113] KVM: x86/mmu: Replace hardcoded value 0 for
 the initial value for SPTE
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <8b4f21e2fada944d041ffee0f27d527e0e447cbb.1685333727.git.isaku.yamahata@intel.com>
From:   "Wu, Dan1" <dan1.wu@intel.com>
In-Reply-To: <8b4f21e2fada944d041ffee0f27d527e0e447cbb.1685333727.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/29/2023 12:19 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
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
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/mmu.c         | 20 +++++++++++++++-----
>   arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
>   arch/x86/kvm/mmu/spte.h        |  2 ++
>   arch/x86/kvm/mmu/tdp_mmu.c     | 14 +++++++-------
>   4 files changed, 25 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index dc2b9a2f717c..1b6fd4434e96 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -576,9 +576,9 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
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
> @@ -612,7 +612,7 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>    */
>   static void mmu_spte_clear_no_track(u64 *sptep)
>   {
> -	__update_clear_spte_fast(sptep, 0ull);
> +	__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
>   }
>   
>   static u64 mmu_spte_get_lockless(u64 *sptep)
> @@ -1969,7 +1969,8 @@ static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>   
>   static int kvm_sync_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
>   {
> -	if (!sp->spt[i])
> +	/* sp->spt[i] has initial value of shadow page table allocation */
> +	if (sp->spt[i] != SHADOW_NONPRESENT_VALUE)

this condition should be "sp->spt[i] == SHADOW_NONPRESENT_VALUE"?

I found this cause the bug of  "guest launch failure with EPT disable".

>   		return 0;
>   
>   	return vcpu->arch.mmu->sync_spte(vcpu, sp, i);
> @@ -6120,7 +6121,16 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>   	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
>   	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>   
> -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +	/*
> +	 * When X86_64, initial SEPT entries are initialized with
> +	 * SHADOW_NONPRESENT_VALUE.  Otherwise zeroed.  See
> +	 * mmu_memory_cache_alloc_obj().
> +	 */
> +	if (IS_ENABLED(CONFIG_X86_64))
> +		vcpu->arch.mmu_shadow_page_cache.init_value =
> +			SHADOW_NONPRESENT_VALUE;
> +	if (!vcpu->arch.mmu_shadow_page_cache.init_value)
> +		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>   
>   	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>   	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 0662e0278e70..ef8124bd2f11 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -892,7 +892,7 @@ static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int
>   	gpa_t pte_gpa;
>   	gfn_t gfn;
>   
> -	if (WARN_ON_ONCE(!sp->spt[i]))
> +	if (WARN_ON_ONCE(sp->spt[i] == SHADOW_NONPRESENT_VALUE))
>   		return 0;
>   
>   	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 1279db2eab44..a99eb7d4ae5d 100644
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
> index 3000ef6d79ea..ddd995885dd3 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -627,7 +627,7 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>   	 * here since the SPTE is going from non-present to non-present.  Use
>   	 * the raw write helper to avoid an unnecessary check on volatile bits.
>   	 */
> -	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
> +	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
>   
>   	return 0;
>   }
> @@ -764,8 +764,8 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
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
> @@ -821,8 +821,8 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
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
> @@ -856,7 +856,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>   		    !is_last_spte(iter.old_spte, iter.level))
>   			continue;
>   
> -		tdp_mmu_iter_set_spte(kvm, &iter, 0);
> +		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
>   		flush = true;
>   	}
>   
> @@ -1250,7 +1250,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>   	 * invariant that the PFN of a present * leaf SPTE can never change.
>   	 * See handle_changed_spte().
>   	 */
> -	tdp_mmu_iter_set_spte(kvm, iter, 0);
> +	tdp_mmu_iter_set_spte(kvm, iter, SHADOW_NONPRESENT_VALUE);
>   
>   	if (!pte_write(range->pte)) {
>   		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
