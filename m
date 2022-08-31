Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E0E75A7869
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiHaIDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiHaIDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:03:36 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8E6BFA9C;
        Wed, 31 Aug 2022 01:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661933009; x=1693469009;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Ylc6YswYmC/VauGgw+zk6429RVP5zfSEPKnqtDi+law=;
  b=hHMMZFpyUYxyb4IvJccXaFjGrQZgVfKOsI9cO/VW/27q+AW4fYQcRYE6
   Op4jEzHSbZjBygS5MLs1Y/Scf9Pee7AUGw8KOO9gNbUWld63VuggCUcRw
   PFmVbHVXL4Xe4j6Pyrx3Z0j5X5NyW6z+vop4UsYzkKm+ff1P3m20ja+Qa
   QK1NXSToXCxFTE29bbK559szr3Kim8yIdkOfx0QcPSd6VuIKDFpJFuBot
   NMLGf0W4g/0hiDYwq5bORVZweH2u4I4pvFYTjJR7eDFGFmH3lbDACisis
   vdc91MNqepVYnpOHA9XTwa9Rb6UKeJHEssfls8wb9LfRb11eajyrvd9YO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="275800990"
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="275800990"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 01:03:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,277,1654585200"; 
   d="scan'208";a="562958490"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by orsmga003.jf.intel.com with ESMTP; 31 Aug 2022 01:03:25 -0700
Date:   Wed, 31 Aug 2022 16:03:24 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 032/103] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Message-ID: <20220831080324.jegml4csggy6cat7@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <8aa5fe0bd8b2e79634440087c32a5d32b4dbe1af.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8aa5fe0bd8b2e79634440087c32a5d32b4dbe1af.1659854790.git.isaku.yamahata@intel.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Aug 07, 2022 at 03:01:17PM -0700, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> For TD guest, the current way to emulate MMIO doesn't work any more, as KVM
> is not able to access the private memory of TD guest and do the emulation.
> Instead, TD guest expects to receive #VE when it accesses the MMIO and then
> it can explicitly makes hypercall to KVM to get the expected information.
>
> To achieve this, the TDX module always enables "EPT-violation #VE" in the
> VMCS control.  And accordingly, KVM needs to configure the MMIO spte to
> trigger EPT violation (instead of misconfiguration) and at the same time,
> also clear the "suppress #VE" bit so the TD guest can get the #VE instead
> of causing actual EPT violation to KVM.
>
> In order for KVM to be able to have chance to set up the correct SPTE for
> MMIO for TD guest, the default non-present SPTE must have the "suppress
> guest accesses the MMIO.
>
> Also, when TD guest accesses the actual shared memory, it should continue
> to trigger EPT violation to the KVM instead of receiving the #VE (the TDX
> module guarantees KVM will receive EPT violation for private memory
> access).  This means for the shared memory, the SPTE also must have the
> "suppress #VE" bit set for the non-present SPTE.
>
> Add support to allow a non-zero value for the non-present SPTE (i.e. when
> the page table is firstly allocated, and when the SPTE is zapped) to allow
> setting "suppress #VE" bit for the non-present SPTE.
>
> Introduce a new macro SHADOW_NONPRESENT_VALUE to be the "suppress #VE" bit.
> Unconditionally set the "suppress #VE" bit (which is bit 63) for both AMD
> and Intel as: 1) AMD hardware doesn't use this bit; 2) for normal VMX
> guest, KVM never enables the "EPT-violation #VE" in VMCS control and
> "suppress #VE" bit is ignored by hardware.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/vmx.h     |  1 +
>  arch/x86/kvm/mmu/mmu.c         | 77 +++++++++++++++++++++++++++++++---
>  arch/x86/kvm/mmu/paging_tmpl.h |  3 +-
>  arch/x86/kvm/mmu/spte.c        |  4 +-
>  arch/x86/kvm/mmu/spte.h        | 28 ++++++++++++-
>  arch/x86/kvm/mmu/tdp_mmu.c     | 23 ++++++----
>  6 files changed, 119 insertions(+), 17 deletions(-)
>
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index c371ef695fcc..6231ef005a50 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -511,6 +511,7 @@ enum vmcs_field {
>  #define VMX_EPT_IPAT_BIT    			(1ull << 6)
>  #define VMX_EPT_ACCESS_BIT			(1ull << 8)
>  #define VMX_EPT_DIRTY_BIT			(1ull << 9)
> +#define VMX_EPT_SUPPRESS_VE_BIT			(1ull << 63)
>  #define VMX_EPT_RWX_MASK                        (VMX_EPT_READABLE_MASK |       \
>  						 VMX_EPT_WRITABLE_MASK |       \
>  						 VMX_EPT_EXECUTABLE_MASK)
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3e1317325e1f..216708a433e7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -538,9 +538,9 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>
>  	if (!is_shadow_present_pte(old_spte) ||
>  	    !spte_has_volatile_bits(old_spte))
> -		__update_clear_spte_fast(sptep, 0ull);
> +		__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
>  	else
> -		old_spte = __update_clear_spte_slow(sptep, 0ull);
> +		old_spte = __update_clear_spte_slow(sptep, SHADOW_NONPRESENT_VALUE);
>
>  	if (!is_shadow_present_pte(old_spte))
>  		return old_spte;
> @@ -574,7 +574,7 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>   */
>  static void mmu_spte_clear_no_track(u64 *sptep)
>  {
> -	__update_clear_spte_fast(sptep, 0ull);
> +	__update_clear_spte_fast(sptep, SHADOW_NONPRESENT_VALUE);
>  }
>
>  static u64 mmu_spte_get_lockless(u64 *sptep)
> @@ -642,6 +642,55 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>  	}
>  }
>
> +#ifdef CONFIG_X86_64
> +static inline void kvm_init_shadow_page(void *page)
> +{
> +	int ign;
> +
> +	/*
> +	 * AMD: "suppress #VE" bit is ignored
> +	 * Intel non-TD(VMX): "suppress #VE" bit is ignored because
> +	 *   EPT_VIOLATION_VE isn't set.
> +	 * guest TD: TDX module sets EPT_VIOLATION_VE
> +	 *   conventional SEPT: "suppress #VE" bit must be set to get EPT violation
> +	 *   private SEPT: "suppress #VE" bit is ignored.  CPU doesn't walk it
> +	 *
> +	 * For simplicity, unconditionally initialize SPET to set "suppress #VE".
> +	 */
> +	asm volatile ("rep stosq\n\t"
> +		      : "=c"(ign), "=D"(page)
> +		      : "a"(SHADOW_NONPRESENT_VALUE), "c"(4096/8), "D"(page)
> +		      : "memory"
> +	);
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
> +	return kvm_mmu_topup_memory_cache(vcpu->arch.mmu_shadow_page_cache,
> +					  PT64_ROOT_MAX_LEVEL);
> +}
> +#endif /* CONFIG_X86_64 */
> +
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>  	int r;
> @@ -651,8 +700,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>  	if (r)
>  		return r;
> -	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> -				       PT64_ROOT_MAX_LEVEL);
> +	r = mmu_topup_shadow_page_cache(vcpu);
>  	if (r)
>  		return r;
>  	if (maybe_indirect) {
> @@ -5815,7 +5863,24 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
>  	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>
> -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +	/*
> +	 * When X86_64, initial SEPT entries are initialized with
> +	 * SHADOW_NONPRESENT_VALUE.  Otherwise zeroed.  See
> +	 * mmu_topup_shadow_page_cache().
> +	 *
> +	 * Shared EPTEs need to be initialized with SUPPRESS_VE=1, otherwise
> +	 * not-present EPT violations would be reflected into the guest by
> +	 * hardware as #VE exceptions.  This is handled by initializing page
> +	 * allocations via kvm_init_shadow_page() during cache topup.
> +	 * In that case, telling the page allocation to zero-initialize the page
> +	 * would be wasted effort.
> +	 *
> +	 * The initialization is harmless for S-EPT entries because KVM's copy
> +	 * of the S-EPT isn't consumed by hardware, and because under the hood
> +	 * S-EPT entries should never #VE.
> +	 */
> +	if (!IS_ENABLED(X86_64))
> +		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>
>  	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index f5958071220c..fe1e973dfb33 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -1036,7 +1036,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		gpa_t pte_gpa;
>  		gfn_t gfn;
>
> -		if (!sp->spt[i])
> +		/* spt[i] has initial value of shadow page table allocation */
> +		if (sp->spt[i] != SHADOW_NONPRESENT_VALUE)

Shuold this be "if (sp->spt[i] == SHADOW_NONPRESENT_VALUE)" ?
Otherwise any present shadow ptes are skipped for 32 and 64
bit KVM.

>  			continue;
>
>  		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 7314d27d57a4..24cba35570ae 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -391,7 +391,9 @@ void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only)
>  	shadow_dirty_mask	= has_ad_bits ? VMX_EPT_DIRTY_BIT : 0ull;
>  	shadow_nx_mask		= 0ull;
>  	shadow_x_mask		= VMX_EPT_EXECUTABLE_MASK;
> -	shadow_present_mask	= has_exec_only ? 0ull : VMX_EPT_READABLE_MASK;
> +	/* VMX_EPT_SUPPRESS_VE_BIT is needed for W or X violation. */
> +	shadow_present_mask	=
> +		(has_exec_only ? 0ull : VMX_EPT_READABLE_MASK) | VMX_EPT_SUPPRESS_VE_BIT;
>  	/*
>  	 * EPT overrides the host MTRRs, and so KVM must program the desired
>  	 * memtype directly into the SPTEs.  Note, this mask is just the mask
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index cabe3fbb4f39..30f456e59e58 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -136,6 +136,19 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
>
>  #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
>
> +/*
> + * non-present SPTE value for both VMX and SVM for TDP MMU.
> + * For SVM NPT, for non-present spte (bit 0 = 0), other bits are ignored.
> + * For VMX EPT, bit 63 is ignored if #VE is disabled.
> + *              bit 63 is #VE suppress if #VE is enabled.
> + */
> +#ifdef CONFIG_X86_64
> +#define SHADOW_NONPRESENT_VALUE	BIT_ULL(63)
> +static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
> +#else
> +#define SHADOW_NONPRESENT_VALUE	0ULL
> +#endif
> +
>  extern u64 __read_mostly shadow_host_writable_mask;
>  extern u64 __read_mostly shadow_mmu_writable_mask;
>  extern u64 __read_mostly shadow_nx_mask;
> @@ -175,16 +188,27 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>   * non-present intermediate value. Other threads which encounter this value
>   * should not modify the SPTE.
>   *
> + * For X86_64 case, SHADOW_NONPRESENT_VALUE, "suppress #VE" bit, is set because
> + * "EPT violation #VE" in the secondary VM execution control may be enabled.
> + * Because TDX module sets "EPT violation #VE" for TD, "suppress #VE" bit for
> + * the conventional EPT needs to be set.
> + *
>   * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
>   * bot AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
>   * vulnerability.  Use only low bits to avoid 64-bit immediates.
>   *
>   * Only used by the TDP MMU.
>   */
> -#define REMOVED_SPTE	0x5a0ULL
> +#define __REMOVED_SPTE	0x5a0ULL
>
>  /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
> -static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
> +static_assert(!(__REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
> +
> +/*
> + * See above comment around __REMOVED_SPTE.  REMOVED_SPTE is the actual
> + * intermediate value set to the removed SPET.  it sets the "suppress #VE" bit.
> + */
> +#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | __REMOVED_SPTE)
>
>  static inline bool is_removed_spte(u64 spte)
>  {
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index bf2ccf9debca..af510dd31ebc 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -682,8 +682,16 @@ static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
>  	 * overwrite the special removed SPTE value. No bookkeeping is needed
>  	 * here since the SPTE is going from non-present to non-present.  Use
>  	 * the raw write helper to avoid an unnecessary check on volatile bits.
> +	 *
> +	 * Set non-present value to SHADOW_NONPRESENT_VALUE, rather than 0.
> +	 * It is because when TDX is enabled, TDX module always
> +	 * enables "EPT-violation #VE", so KVM needs to set
> +	 * "suppress #VE" bit in EPT table entries, in order to get
> +	 * real EPT violation, rather than TDVMCALL.  KVM sets
> +	 * SHADOW_NONPRESENT_VALUE (which sets "suppress #VE" bit) so it
> +	 * can be set when EPT table entries are zapped.
>  	 */
> -	__kvm_tdp_mmu_write_spte(iter->sptep, 0);
> +	__kvm_tdp_mmu_write_spte(iter->sptep, SHADOW_NONPRESENT_VALUE);
>
>  	return 0;
>  }
> @@ -860,8 +868,8 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
>  			continue;
>
>  		if (!shared)
> -			tdp_mmu_set_spte(kvm, &iter, 0);
> -		else if (tdp_mmu_set_spte_atomic(kvm, &iter, 0))
> +			tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
> +		else if (tdp_mmu_set_spte_atomic(kvm, &iter, SHADOW_NONPRESENT_VALUE))
>  			goto retry;
>  	}
>  }
> @@ -917,8 +925,9 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
>  	if (WARN_ON_ONCE(!is_shadow_present_pte(old_spte)))
>  		return false;
>
> -	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte, 0,
> -			   sp->gfn, sp->role.level + 1, true, true);
> +	__tdp_mmu_set_spte(kvm, kvm_mmu_page_as_id(sp), sp->ptep, old_spte,
> +			   SHADOW_NONPRESENT_VALUE, sp->gfn, sp->role.level + 1,
> +			   true, true);
>
>  	return true;
>  }
> @@ -952,7 +961,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
>  		    !is_last_spte(iter.old_spte, iter.level))
>  			continue;
>
> -		tdp_mmu_set_spte(kvm, &iter, 0);
> +		tdp_mmu_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
>  		flush = true;
>  	}
>
> @@ -1316,7 +1325,7 @@ static bool set_spte_gfn(struct kvm *kvm, struct tdp_iter *iter,
>  	 * invariant that the PFN of a present * leaf SPTE can never change.
>  	 * See __handle_changed_spte().
>  	 */
> -	tdp_mmu_set_spte(kvm, iter, 0);
> +	tdp_mmu_set_spte(kvm, iter, SHADOW_NONPRESENT_VALUE);
>
>  	if (!pte_write(range->pte)) {
>  		new_spte = kvm_mmu_changed_pte_notifier_make_spte(iter->old_spte,
> --
> 2.25.1
>
