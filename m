Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D59A4EE7A9
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 07:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245001AbiDAFO7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 01:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235699AbiDAFO5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 01:14:57 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A762260C7A;
        Thu, 31 Mar 2022 22:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648789988; x=1680325988;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MrWlulRGy9T6T21HhUXXCgKEFeu1p2W99NaSEdLXmzA=;
  b=P8wbuHQOqt6CEPuHnzpMOXixLsmq4CzjlzkhJJy5PeacRObsOewxenal
   OzURHcyFj/YsQRvoIt6BSqLymvA3/SceM7tMV899MfCNcAgIJ5OOZ6vsb
   pZr10ILJM4XJyUFEtaWH9bO7kJJEWRgVH3HoOqpqlJ/WlN4OVq3dePPNd
   lCY4v+GOjHm7vUpLglrU/YSbQc/WTDLo0amSUrvodnEoSp3r1CdEmMdYj
   0zIq6B4W7avbn2p5sGWX/p4ooWj/9zEhTiBuyq3QcdpASSOp8rfg8igTc
   H684iFEw+woEuW4ka9UZf1CoVlizMD40SiOqRq/SDKdwgNkhtayVYHuWm
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="260223631"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="260223631"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 22:13:08 -0700
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="720748140"
Received: from tswork-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.29.39])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 22:13:05 -0700
Message-ID: <968de4765e63d8255ae1b3ac7062ffdca64706e4.camel@intel.com>
Subject: Re: [RFC PATCH v5 037/104] KVM: x86/mmu: Allow non-zero init value
 for shadow PTE
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 01 Apr 2022 18:13:03 +1300
In-Reply-To: <b74b3660f9d16deafe83f2670539a8287bef988f.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <b74b3660f9d16deafe83f2670539a8287bef988f.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> TDX will run with EPT violation #VEs enabled for shared EPT, which means
> KVM needs to set the "suppress #VE" bit in unused PTEs to avoid
> unintentionally reflecting not-present EPT violations into the guest.

This sentence is hard to interpret.  Please add more sentences to elaborate "TDX
will run with EPT violation #VEs enabled for shared EPT".  Also, this patch is
the first time to introduce "shared EPT", perhaps you should also explain it
here.  Or even you can move patch 43 ("KVM: TDX: Add load_mmu_pgd method for
TDX") before this one.

"reflecting non-present EPT violations into the guest" could be hard to
interpret.  Perhaps you can be more explicit to say VMM wants to get EPT
violation for normal (shared) memory access rather than to cause #VE to guest.  

Mentioning you want EPT violation instead of #VE for normal (shared) memory
access also completes your statement of wanting #VE for MMIO below, so that
people can have a clear picture when to get a #VE when not.

> 
> Because guest memory is protected with TDX, VMM can't parse instructions
> in the guest memory.  Instead, MMIO hypercall is used to pass necessary
> information to VMM.
> 
> To make unmodified device driver work, guest TD expects #VE on accessing
> shared GPA.  The #VE handler converts MMIO access into MMIO hypercall with
> the EPT entry of enabled "#VE" by clearing "suppress #VE" bit.  Before VMM
> enabling #VE, it needs to figure out the given GPA is for MMIO by EPT
> violation.  So the execution flow looks like
> 
> - allocate unused shared EPT entry with suppress #VE bit set.

allocate -> Allocate

> - EPT violation on that GPA.
> - VMM figures out the faulted GPA is for MMIO.
> - VMM clears the suppress #VE bit.
> - Guest TD gets #VE, and converts MMIO access into MMIO hypercall.

Here you have described both normal memory access and MMIO, it's good time to
summarize the purpose of this patch: For both cases you want PTE with "suppress
#VE" bit set initially when it is allocated, therefore allow non-zero init value
for PTE.

> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/kvm/mmu.h      |  1 +
>  arch/x86/kvm/mmu/mmu.c  | 50 +++++++++++++++++++++++++++++++++++------
>  arch/x86/kvm/mmu/spte.c | 10 +++++++++
>  arch/x86/kvm/mmu/spte.h |  2 ++
>  4 files changed, 56 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 3fb530359f81..0ae91b8b25df 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -66,6 +66,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
>  
>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
>  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> +void kvm_mmu_set_spte_init_value(u64 init_value);
>  
>  void kvm_init_mmu(struct kvm_vcpu *vcpu);
>  void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9907cb759fd1..a474f2e76d78 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -617,9 +617,9 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>  	int level = sptep_to_sp(sptep)->role.level;
>  
>  	if (!spte_has_volatile_bits(old_spte))
> -		__update_clear_spte_fast(sptep, 0ull);
> +		__update_clear_spte_fast(sptep, shadow_init_value);
>  	else
> -		old_spte = __update_clear_spte_slow(sptep, 0ull);
> +		old_spte = __update_clear_spte_slow(sptep, shadow_init_value);

I guess it's better to have some comment here.  Allow non-zero init value for
shadow PTE doesn't necessarily mean the initial value should be used when one
PTE is zapped.  I think mmu_spte_clear_track_bits() is only called for mapping
of normal (shared) memory but not MMIO? Then perhaps it's better to have a
comment to explain we want "suppress #VE" set to get a real EPT violation for
normal memory access from guest?

>  
>  	if (!is_shadow_present_pte(old_spte))
>  		return old_spte;
> @@ -651,7 +651,7 @@ static int mmu_spte_clear_track_bits(struct kvm *kvm, u64 *sptep)
>   */
>  static void mmu_spte_clear_no_track(u64 *sptep)
>  {
> -	__update_clear_spte_fast(sptep, 0ull);
> +	__update_clear_spte_fast(sptep, shadow_init_value);
>  }

Similar here.  Seems mmu_spte_clear_no_track() is used to zap non-leaf PTE which
doesn't require state tracking, so theoretically it can be set to 0.  But this
seems is also called to zap MMIO PTE so looks need to set to shadow_init_value.
Anyway looks deserve a comment?

Btw, Above two changes to mmu_spte_clear_track_bits() and
mmu_spte_clear_track_bits() seems a little bit out-of-scope of what this patch
claims to do.  Allow non-zero init value for shadow PTE doesn't necessarily mean
the initial value should be used when one PTE is zapped. Maybe we can further
improve the patch title and commit message a little bit.  Such as: Allow non-
zero value for empty (or invalid?) PTE? Non-present seems doesn't fit here.

>  
>  static u64 mmu_spte_get_lockless(u64 *sptep)
> @@ -737,6 +737,42 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static inline void kvm_init_shadow_page(void *page)
> +{
> +#ifdef CONFIG_X86_64
> +	int ign;
> +
> +	asm volatile (
> +		"rep stosq\n\t"
> +		: "=c"(ign), "=D"(page)
> +		: "a"(shadow_init_value), "c"(4096/8), "D"(page)
> +		: "memory"
> +	);
> +#else
> +	BUG();
> +#endif
> +}
> +
> +static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
> +	int start, end, i, r;
> +
> +	if (shadow_init_value)
> +		start = kvm_mmu_memory_cache_nr_free_objects(mc);
> +
> +	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
> +	if (r)
> +		return r;
> +
> +	if (shadow_init_value) {
> +		end = kvm_mmu_memory_cache_nr_free_objects(mc);
> +		for (i = start; i < end; i++)
> +			kvm_init_shadow_page(mc->objects[i]);
> +	}
> +	return 0;
> +}
> +
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>  	int r;
> @@ -746,8 +782,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
>  	if (r)
>  		return r;
> -	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
> -				       PT64_ROOT_MAX_LEVEL);
> +	r = mmu_topup_shadow_page_cache(vcpu);
>  	if (r)
>  		return r;
>  	if (maybe_indirect) {
> @@ -3146,7 +3181,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_mmu_page *sp;
>  	int ret = RET_PF_INVALID;
> -	u64 spte = 0ull;
> +	u64 spte = shadow_init_value;

I don't quite understand this change.  'spte' is set to the last level PTE of
the given GFN if mapping is found.  Otherwise fast_page_fault() returns
RET_PF_INVALID.  In both cases, the initial value doesn't matter.

Am I wrong?

>  	u64 *sptep = NULL;
>  	uint retry_count = 0;
>  
> @@ -5598,7 +5633,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
>  	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>  
> -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> +	if (!shadow_init_value)
> +		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>  
>  	vcpu->arch.mmu = &vcpu->arch.root_mmu;
>  	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 73cfe62fdad1..5071e8332db2 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -35,6 +35,7 @@ u64 __read_mostly shadow_mmio_access_mask;
>  u64 __read_mostly shadow_present_mask;
>  u64 __read_mostly shadow_me_mask;
>  u64 __read_mostly shadow_acc_track_mask;
> +u64 __read_mostly shadow_init_value;
>  
>  u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>  u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
> @@ -223,6 +224,14 @@ u64 kvm_mmu_changed_pte_notifier_make_spte(u64 old_spte, kvm_pfn_t new_pfn)
>  	return new_spte;
>  }
>  
> +void kvm_mmu_set_spte_init_value(u64 init_value)
> +{
> +	if (WARN_ON(!IS_ENABLED(CONFIG_X86_64) && init_value))
> +		init_value = 0;
> +	shadow_init_value = init_value;
> +}
> +EXPORT_SYMBOL_GPL(kvm_mmu_set_spte_init_value);
> +
>  static u8 kvm_get_shadow_phys_bits(void)
>  {
>  	/*
> @@ -367,6 +376,7 @@ void kvm_mmu_reset_all_pte_masks(void)
>  	shadow_present_mask	= PT_PRESENT_MASK;
>  	shadow_acc_track_mask	= 0;
>  	shadow_me_mask		= sme_me_mask;
> +	shadow_init_value	= 0;
>  
>  	shadow_host_writable_mask = DEFAULT_SPTE_HOST_WRITEABLE;
>  	shadow_mmu_writable_mask  = DEFAULT_SPTE_MMU_WRITEABLE;
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index be6a007a4af3..8e13a35ab8c9 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -171,6 +171,8 @@ extern u64 __read_mostly shadow_mmio_access_mask;
>  extern u64 __read_mostly shadow_present_mask;
>  extern u64 __read_mostly shadow_me_mask;
>  
> +extern u64 __read_mostly shadow_init_value;
> +
>  /*
>   * SPTEs in MMUs without A/D bits are marked with SPTE_TDP_AD_DISABLED_MASK;
>   * shadow_acc_track_mask is the set of bits to be cleared in non-accessed

