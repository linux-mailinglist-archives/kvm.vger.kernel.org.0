Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9B25A9298
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 11:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234308AbiIAJAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 05:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234386AbiIAJAD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 05:00:03 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14862253A;
        Thu,  1 Sep 2022 01:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662022801; x=1693558801;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+wV57Ugim8e+hUHQe53ZHL64V54MVO9BVTKu14E+k3Y=;
  b=lIr4lpjVVLwgRDayiL6B1Q74GXc8N7VK0cHcN3VlysH0h+gDjZUWrrK3
   MYFu32AJFff6yTAlXBZEZQj1T2IxesyJok5q9d/9uYmAY0Ms1thFqhErG
   +grzuvRvg8AwUg+5RGn5JGY7rTB8OMT59OeIFUwFggZ+hgJXdaeh5uR43
   3cQIah5l8qNJVglP7YxzzEVy4f0IeBJWt/E/ZhMT2ca8l/5LJhhfhBEhP
   TVPJ9sDkBixsIyrU5c94rJI+g+cw3LcKO2z9GMKZm+ggqzH9lyQQhW9Lw
   w1OOmL0G10SDxrVlIpmSp49313mLAQGN+3SvJQeiKjxWR7j1CZmcAS2gS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="296943723"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="296943723"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 01:59:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="615267552"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmsmga007.fm.intel.com with ESMTP; 01 Sep 2022 01:59:55 -0700
Date:   Thu, 1 Sep 2022 16:59:54 +0800
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 042/103] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
Message-ID: <20220901085954.ykko7u6dvupuayzm@yy-desk-7060>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <a02d8e9a3c46b9627a5edccd76416abeccf45a20.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a02d8e9a3c46b9627a5edccd76416abeccf45a20.1659854790.git.isaku.yamahata@intel.com>
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

On Sun, Aug 07, 2022 at 03:01:27PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> For private GPA, CPU refers a private page table whose contents are
> encrypted.  The dedicated APIs to operate on it (e.g. updating/reading its
> PTE entry) are used and their cost is expensive.
>
> When KVM resolves KVM page fault, it walks the page tables.  To reuse the
> existing KVM MMU code and mitigate the heavy cost to directly walk
> protected (encrypted) page table, allocate one more page to copy the
> protected page table for KVM MMU code to directly walk.  Resolve KVM page
> fault with the existing code, and do additional operations necessary for
> the protected page table.  To distinguish such cases, the existing KVM page
> table is called a shared page table (i.e. not associated with protected
> page table), and the page table with protected page table is called a
> private page table.  The relationship is depicted below.
>
> Add a private pointer to struct kvm_mmu_page for protected page table and
> add helper functions to allocate/initialize/free a protected page table
> page.
>
>               KVM page fault                     |
>                      |                           |
>                      V                           |
>         -------------+----------                 |
>         |                      |                 |
>         V                      V                 |
>      shared GPA           private GPA            |
>         |                      |                 |
>         V                      V                 |
>     shared PT root      private PT root          |    protected PT root
>         |                      |                 |           |
>         V                      V                 |           V
>      shared PT            private PT ----propagate----> protected PT
>         |                      |                 |           |
>         |                      \-----------------+------\    |
>         |                                        |      |    |
>         V                                        |      V    V
>   shared guest page                              |    private guest page
>                                                  |
>                            non-encrypted memory  |    encrypted memory
>                                                  |
> PT: page table
> - Shared PT is visible to KVM and it is used by CPU.
> - Protected PT is used by CPU but it is invisible to KVM.
> - Private PT is visible to KVM but not used by CPU.  It is used to
>   propagate PT change to the actual protected PT which is used by CPU.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/mmu/mmu.c          |  9 ++++
>  arch/x86/kvm/mmu/mmu_internal.h | 73 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +
>  4 files changed, 85 insertions(+)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 25835b8c4c12..e4ecf6b8ea0b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -743,6 +743,7 @@ struct kvm_vcpu_arch {
>  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
>  	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
>  	struct kvm_mmu_memory_cache mmu_page_header_cache;
> +	struct kvm_mmu_memory_cache mmu_private_sp_cache;
>
>  	/*
>  	 * QEMU userspace and the guest each have their own FPU state.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0e5a6dcc4966..aa0819905874 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -669,6 +669,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
>  	struct kvm_mmu_memory_cache *mc = &vcpu->arch.mmu_shadow_page_cache;
>  	int start, end, i, r;
>
> +	if (kvm_gfn_shared_mask(vcpu->kvm)) {
> +		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_sp_cache,
> +					       PT64_ROOT_MAX_LEVEL);
> +		if (r)
> +			return r;
> +	}
> +
>  	start = kvm_mmu_memory_cache_nr_free_objects(mc);
>  	r = kvm_mmu_topup_memory_cache(mc, PT64_ROOT_MAX_LEVEL);
>
> @@ -718,6 +725,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
> +	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_sp_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
>
> @@ -2162,6 +2170,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
>  		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
>
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> +	kvm_mmu_init_private_sp(sp, NULL);
>
>  	/*
>  	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index c9446e4e16e3..d43c01e7e37b 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -82,6 +82,10 @@ struct kvm_mmu_page {
>  	 */
>  	u64 *shadowed_translation;
>
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +	/* associated private shadow page, e.g. SEPT page. */
> +	void *private_sp;
> +#endif
>  	/* Currently serving as active root */
>  	union {
>  		int root_count;
> @@ -153,6 +157,75 @@ static inline bool is_private_sptep(u64 *sptep)
>  	return is_private_sp(sptep_to_sp(sptep));
>  }
>
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +static inline void *kvm_mmu_private_sp(struct kvm_mmu_page *sp)
> +{
> +	return sp->private_sp;
> +}
> +
> +static inline void kvm_mmu_init_private_sp(struct kvm_mmu_page *sp, void *private_sp)
> +{
> +	sp->private_sp = private_sp;
> +}

How about "kvm_mmu_set_private_sp()" ? Because it just sets variable.
"init" means things more than just setting.

> +
> +static inline void kvm_mmu_alloc_private_sp(
> +	struct kvm_vcpu *vcpu, struct kvm_mmu_memory_cache *private_sp_cache,
> +	struct kvm_mmu_page *sp)
> +{
> +	/*
> +	 * vcpu == NULL means non-root SPT:
> +	 * vcpu == NULL is used to split a large SPT into smaller SPT.  Root SPT
> +	 * is not a large SPT.
> +	 */

Can we rely on sp->tdp_mmu_root_count to know it's root or not ?
Depends on vcpu looks odd, because it's often to split
huge pages in per-vcpu level, or things I missed here...

> +	bool is_root = vcpu &&
> +		vcpu->arch.root_mmu.root_role.level == sp->role.level;
> +
> +	if (vcpu)
> +		private_sp_cache = &vcpu->arch.mmu_private_sp_cache;

how about totally rely on caller for this, e.g caller to decide
uses per-vcpu cache or per-VM cache ?

> +	WARN_ON(!kvm_mmu_page_role_is_private(sp->role));

Please move to begin of this function because this should be
first step to check bad cases.

> +	if (is_root)
> +		/*
> +		 * Because TDX module assigns root Secure-EPT page and set it to
> +		 * Secure-EPTP when TD vcpu is created, secure page table for
> +		 * root isn't needed.
> +		 */
> +		sp->private_sp = NULL;
> +	else {
> +		sp->private_sp = kvm_mmu_memory_cache_alloc(private_sp_cache);
> +		/*
> +		 * Because mmu_private_sp_cache is topped up before staring kvm
> +		 * page fault resolving, the allocation above shouldn't fail.
> +		 */
> +		WARN_ON_ONCE(!sp->private_sp);
> +	}
> +}
> +
> +static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
> +{
> +	if (sp->private_sp)
> +		free_page((unsigned long)sp->private_sp);
> +}
> +#else
> +static inline void *kvm_mmu_private_sp(struct kvm_mmu_page *sp)
> +{
> +	return NULL;
> +}
> +
> +static inline void kvm_mmu_init_private_sp(struct kvm_mmu_page *sp, void *private_sp)
> +{
> +}
> +
> +static inline void kvm_mmu_alloc_private_sp(
> +	struct kvm_vcpu *vcpu, struct kvm_mmu_memory_cache *private_sp_cache,
> +	struct kvm_mmu_page *sp)
> +{
> +}
> +
> +static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
> +{
> +}
> +#endif
> +
>  static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
>  {
>  	/*
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 823c1ef807eb..3f5b019f9774 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -71,6 +71,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>
>  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
> +	kvm_mmu_free_private_sp(sp);
>  	free_page((unsigned long)sp->spt);
>  	kmem_cache_free(mmu_page_header_cache, sp);
>  }
> @@ -300,6 +301,7 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
>  	sp->gfn = gfn;
>  	sp->ptep = sptep;
>  	sp->tdp_mmu_page = true;
> +	kvm_mmu_init_private_sp(sp, NULL);

This set the private sp allocated by kvm_mmu_alloc_private_sp(), I
think it's wrong here.

>
>  	trace_kvm_mmu_get_page(sp, true);
>  }
> --
> 2.25.1
>
