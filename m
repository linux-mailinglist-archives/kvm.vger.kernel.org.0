Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0E44ED84A
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 13:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbiCaLSi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 07:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233641AbiCaLSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 07:18:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E314205BC3;
        Thu, 31 Mar 2022 04:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648725409; x=1680261409;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QzehnQgNR3bN/3DlO10M+yxPq8+GnRut0NN7IPvEbLw=;
  b=XuAcrnffM3PAUMKZI0X1JDmbsIcC4ekOLraqmuvia8XxMkCoFjPNHsFs
   8CH4ottrEVmgwImSZGsJqXXiJ24QiLYhtY0gCMnUcDZgoW7FVpkbdIUus
   s6Fj6fKAZ3Y/DbTrk0EyCsZTUNGQXFS1+gjSlKW3t15iXGwOVOFJmmvAD
   moZXAulzbfPUVZuVPqj9JiqFSuA9/V2pVC9BVrYmPK1C15M6ld4pTkThz
   1A2wMWODVjLlokuxcno3ixeLWbiGXvaTE21XmgeQGgKSsO8bljgwFKfkI
   8mTztN6XgDGOPv92syLjzeta/cY/9oYFpCOGDnBnKFiNb9HQaoiph+EoX
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="241950610"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="241950610"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 04:16:45 -0700
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="555038923"
Received: from fpaolini-mobl2.ger.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.53.114])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 04:16:43 -0700
Message-ID: <2b8038c17b85658a054191b362840240bd66e46b.camel@intel.com>
Subject: Re: [RFC PATCH v5 033/104] KVM: x86: Add infrastructure for stolen
 GPA bits
From:   Kai Huang <kai.huang@intel.com>
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Fri, 01 Apr 2022 00:16:41 +1300
In-Reply-To: <a21c1f9065cf27db54820b2b504db4e507835584.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
         <a21c1f9065cf27db54820b2b504db4e507835584.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-03-04 at 11:48 -0800, isaku.yamahata@intel.com wrote:
> From: Rick Edgecombe <rick.p.edgecombe@intel.com>
> 
> Add support in KVM's MMU for aliasing multiple GPAs (from a hardware
> perspective) to a single GPA (from a memslot perspective). GPA aliasing
> will be used to repurpose GPA bits as attribute bits, e.g. to expose an
> execute-only permission bit to the guest. To keep the implementation
> simple (relatively speaking), GPA aliasing is only supported via TDP.
> 
> Today KVM assumes two things that are broken by GPA aliasing.
>   1. GPAs coming from hardware can be simply shifted to get the GFNs.
>   2. GPA bits 51:MAXPHYADDR are reserved to zero.
> 
> With GPA aliasing, translating a GPA to GFN requires masking off the
> repurposed bit, and a repurposed bit may reside in 51:MAXPHYADDR.
> 
> To support GPA aliasing, introduce the concept of per-VM GPA stolen bits,
> that is, bits stolen from the GPA to act as new virtualized attribute
> bits. A bit in the mask will cause the MMU code to create aliases of the
> GPA. It can also be used to find the GFN out of a GPA coming from a tdp
> fault.
> 
> To handle case (1) from above, retain any stolen bits when passing a GPA
> in KVM's MMU code, but strip them when converting to a GFN so that the
> GFN contains only the "real" GFN, i.e. never has repurposed bits set.
> 
> GFNs (without stolen bits) continue to be used to:
>   - Specify physical memory by userspace via memslots
>   - Map GPAs to TDP PTEs via RMAP
>   - Specify dirty tracking and write protection
>   - Look up MTRR types
>   - Inject async page faults
> 
> Since there are now multiple aliases for the same aliased GPA, when
> userspace memory backing the memslots is paged out, both aliases need to be
> modified. Fortunately, this happens automatically. Since rmap supports
> multiple mappings for the same GFN for PTE shadowing based paging, by
> adding/removing each alias PTE with its GFN, kvm_handle_hva() based
> operations will be applied to both aliases.
> 
> In the case of the rmap being removed in the future, the needed
> information could be recovered by iterating over the stolen bits and
> walking the TDP page tables.
> 
> For TLB flushes that are address based, make sure to flush both aliases
> in the case of stolen bits.
> 
> Only support stolen bits in 64 bit guest paging modes (long, PAE).
> Features that use this infrastructure should restrict the stolen bits to
> exclude the other paging modes. Don't support stolen bits for shadow EPT.
> 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 ++
>  arch/x86/kvm/mmu.h              | 51 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/mmu.c          | 19 ++++++++++--
>  arch/x86/kvm/mmu/paging_tmpl.h  | 25 +++++++++-------
>  4 files changed, 84 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 208b29b0e637..d8b78d6abc10 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1235,7 +1235,9 @@ struct kvm_arch {
>  	spinlock_t hv_root_tdp_lock;
>  #endif
>  
> +#ifdef CONFIG_KVM_MMU_PRIVATE
>  	gfn_t gfn_shared_mask;
> +#endif
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index e9fbb2c8bbe2..3fb530359f81 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -365,4 +365,55 @@ static inline gpa_t kvm_translate_gpa(struct kvm_vcpu *vcpu,
>  		return gpa;
>  	return translate_nested_gpa(vcpu, gpa, access, exception);
>  }
> +
> +static inline gfn_t kvm_gfn_stolen_mask(struct kvm *kvm)
> +{
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +	return kvm->arch.gfn_shared_mask;
> +#else
> +	return 0;
> +#endif
> +}
> +
> +static inline gpa_t kvm_gpa_stolen_mask(struct kvm *kvm)
> +{
> +	return gfn_to_gpa(kvm_gfn_stolen_mask(kvm));
> +}
> +
> +static inline gpa_t kvm_gpa_unalias(struct kvm *kvm, gpa_t gpa)
> +{
> +	return gpa & ~kvm_gpa_stolen_mask(kvm);
> +}
> +
> +static inline gfn_t kvm_gfn_unalias(struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn & ~kvm_gfn_stolen_mask(kvm);
> +}
> +
> +static inline gfn_t kvm_gfn_shared(struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn | kvm_gfn_stolen_mask(kvm);
> +}
> +
> +static inline gfn_t kvm_gfn_private(struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn & ~kvm_gfn_stolen_mask(kvm);
> +}
> +
> +static inline gpa_t kvm_gpa_private(struct kvm *kvm, gpa_t gpa)
> +{
> +	return gpa & ~kvm_gpa_stolen_mask(kvm);
> +}
> +
> +static inline bool kvm_is_private_gfn(struct kvm *kvm, gfn_t gfn)
> +{
> +	gfn_t mask = kvm_gfn_stolen_mask(kvm);
> +
> +	return mask && !(gfn & mask);
> +}
> +
> +static inline bool kvm_is_private_gpa(struct kvm *kvm, gpa_t gpa)
> +{
> +	return kvm_is_private_gfn(kvm, gpa_to_gfn(gpa));
> +}

The patch title and commit message say nothing about private/shared, but only
mention stolen bits in general.  It's weird to introduce those *private* related
helpers here.

I think you can just ditch the concept of stolen bit infrastructure, but just
adopt what TDX needs.


>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 8e24f73bf60b..b68191aa39bf 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -276,11 +276,24 @@ static inline bool kvm_available_flush_tlb_with_range(void)
>  static void kvm_flush_remote_tlbs_with_range(struct kvm *kvm,
>  		struct kvm_tlb_range *range)
>  {
> -	int ret = -ENOTSUPP;
> +	int ret = -EOPNOTSUPP;

Change doesn't belong to this patch.

> +	u64 gfn_stolen_mask;
>  
> -	if (range && kvm_x86_ops.tlb_remote_flush_with_range)
> +	/*
> +	 * Fall back to the big hammer flush if there is more than one
> +	 * GPA alias that needs to be flushed.
> +	 */
> +	gfn_stolen_mask = kvm_gfn_stolen_mask(kvm);
> +	if (hweight64(gfn_stolen_mask) > 1)
> +		goto generic_flush;
> +
> +	if (range && kvm_available_flush_tlb_with_range()) {
> +		/* Callback should flush both private GFN and shared GFN. */
> +		range->start_gfn = kvm_gfn_unalias(kvm, range->start_gfn);

This seems wrong.  It seems the intention of this function is to flush TLB for
all aliases for a given GFN range.  Here it seems you are unconditionally change
to range to always exclude the stolen bits.

>  		ret = static_call(kvm_x86_tlb_remote_flush_with_range)(kvm, range);
> +	}

And you always fall through to do big hammer flush, which is obviously not
intended.

>  
> +generic_flush:
>  	if (ret)
>  		kvm_flush_remote_tlbs(kvm);
>  }
> @@ -4010,7 +4023,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
>  	unsigned long mmu_seq;
>  	int r;
>  
> -	fault->gfn = fault->addr >> PAGE_SHIFT;
> +	fault->gfn = kvm_gfn_unalias(vcpu->kvm, gpa_to_gfn(fault->addr));
>  	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
>  
>  	if (page_fault_handle_page_track(vcpu, fault))
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 5b5bdac97c7b..70aec31dee06 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -25,7 +25,8 @@
>  	#define guest_walker guest_walker64
>  	#define FNAME(name) paging##64_##name
>  	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
> -	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
> +	#define PT_LVL_ADDR_MASK(vcpu, lvl) (~kvm_gpa_stolen_mask(vcpu->kvm) & \
> +					     PT64_LVL_ADDR_MASK(lvl))
>  	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
>  	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
>  	#define PT_LEVEL_BITS PT64_LEVEL_BITS
> @@ -44,7 +45,7 @@
>  	#define guest_walker guest_walker32
>  	#define FNAME(name) paging##32_##name
>  	#define PT_BASE_ADDR_MASK PT32_BASE_ADDR_MASK
> -	#define PT_LVL_ADDR_MASK(lvl) PT32_LVL_ADDR_MASK(lvl)
> +	#define PT_LVL_ADDR_MASK(vcpu, lvl) PT32_LVL_ADDR_MASK(lvl)
>  	#define PT_LVL_OFFSET_MASK(lvl) PT32_LVL_OFFSET_MASK(lvl)
>  	#define PT_INDEX(addr, level) PT32_INDEX(addr, level)
>  	#define PT_LEVEL_BITS PT32_LEVEL_BITS
> @@ -58,7 +59,7 @@
>  	#define guest_walker guest_walkerEPT
>  	#define FNAME(name) ept_##name
>  	#define PT_BASE_ADDR_MASK GUEST_PT64_BASE_ADDR_MASK
> -	#define PT_LVL_ADDR_MASK(lvl) PT64_LVL_ADDR_MASK(lvl)
> +	#define PT_LVL_ADDR_MASK(vcpu, lvl) PT64_LVL_ADDR_MASK(lvl)
>  	#define PT_LVL_OFFSET_MASK(lvl) PT64_LVL_OFFSET_MASK(lvl)
>  	#define PT_INDEX(addr, level) PT64_INDEX(addr, level)
>  	#define PT_LEVEL_BITS PT64_LEVEL_BITS
> @@ -75,7 +76,7 @@
>  #define PT_GUEST_ACCESSED_MASK (1 << PT_GUEST_ACCESSED_SHIFT)
>  
>  #define gpte_to_gfn_lvl FNAME(gpte_to_gfn_lvl)
> -#define gpte_to_gfn(pte) gpte_to_gfn_lvl((pte), PG_LEVEL_4K)
> +#define gpte_to_gfn(vcpu, pte) gpte_to_gfn_lvl(vcpu, pte, PG_LEVEL_4K)
>  
>  /*
>   * The guest_walker structure emulates the behavior of the hardware page
> @@ -96,9 +97,9 @@ struct guest_walker {
>  	struct x86_exception fault;
>  };
>  
> -static gfn_t gpte_to_gfn_lvl(pt_element_t gpte, int lvl)
> +static gfn_t gpte_to_gfn_lvl(struct kvm_vcpu *vcpu, pt_element_t gpte, int lvl)
>  {
> -	return (gpte & PT_LVL_ADDR_MASK(lvl)) >> PAGE_SHIFT;
> +	return (gpte & PT_LVL_ADDR_MASK(vcpu, lvl)) >> PAGE_SHIFT;
>  }
>  
>  static inline void FNAME(protect_clean_gpte)(struct kvm_mmu *mmu, unsigned *access,
> @@ -395,7 +396,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  		--walker->level;
>  
>  		index = PT_INDEX(addr, walker->level);
> -		table_gfn = gpte_to_gfn(pte);
> +		table_gfn = gpte_to_gfn(vcpu, pte);
>  		offset    = index * sizeof(pt_element_t);
>  		pte_gpa   = gfn_to_gpa(table_gfn) + offset;
>  
> @@ -460,7 +461,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	if (unlikely(errcode))
>  		goto error;
>  
> -	gfn = gpte_to_gfn_lvl(pte, walker->level);
> +	gfn = gpte_to_gfn_lvl(vcpu, pte, walker->level);
>  	gfn += (addr & PT_LVL_OFFSET_MASK(walker->level)) >> PAGE_SHIFT;
>  
>  	if (PTTYPE == 32 && walker->level > PG_LEVEL_4K && is_cpuid_PSE36())
> @@ -555,12 +556,14 @@ FNAME(prefetch_gpte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	gfn_t gfn;
>  	kvm_pfn_t pfn;
>  
> +	WARN_ON(gpte & kvm_gpa_stolen_mask(vcpu->kvm));
> +
>  	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, spte, gpte))
>  		return false;
>  
>  	pgprintk("%s: gpte %llx spte %p\n", __func__, (u64)gpte, spte);
>  
> -	gfn = gpte_to_gfn(gpte);
> +	gfn = gpte_to_gfn(vcpu, gpte);
>  	pte_access = sp->role.access & FNAME(gpte_access)(gpte);
>  	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
>  
> @@ -656,6 +659,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	WARN_ON_ONCE(gw->gfn != base_gfn);
>  	direct_access = gw->pte_access;
>  
> +	WARN_ON(fault->addr & kvm_gpa_stolen_mask(vcpu->kvm));
> +
>  	top_level = vcpu->arch.mmu->root_level;
>  	if (top_level == PT32E_ROOT_LEVEL)
>  		top_level = PT32_ROOT_LEVEL;
> @@ -1080,7 +1085,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  			continue;
>  		}
>  
> -		gfn = gpte_to_gfn(gpte);
> +		gfn = gpte_to_gfn(vcpu, gpte);
>  		pte_access = sp->role.access;
>  		pte_access &= FNAME(gpte_access)(gpte);
>  		FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);

In commit message you mentioned "Don't support stolen bits for shadow EPT" (you
actually mean shadow MMU I suppose), yet there's bunch of code change to shadow
MMU.

