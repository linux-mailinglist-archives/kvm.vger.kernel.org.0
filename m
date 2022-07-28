Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C130258469B
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 21:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiG1TmA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 15:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiG1Tl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 15:41:59 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF2E683F6
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 12:41:57 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 12so2332742pga.1
        for <kvm@vger.kernel.org>; Thu, 28 Jul 2022 12:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=OCGCkbI2DSYUg6HeHxm6nACK8W6v9vz3ryu4JaTHbCk=;
        b=LZgRdf8P7M6BSc+/Yy7gDqlxEpAL7JxmVubVQXCVV4YoGWtQe6wIO2pt8HjE1Spt4h
         ILoXizfn0ceJfSYC/wW07yLl0UnoA2YXGx5vo0RW6oXWim10jvA9UiZpJQ7K4ZL5nS7c
         8xfipt0d4srCncDb1mU+yiqwV36fet7eZjfeS2747VhMcggzb27fkunw42qwqIBxZdla
         gKICw9wY92/yed+9eefppmt/cMxRt5mBMjh1vVXDX2kawWYdFbuB+7FvtodC6vUOUCWJ
         6I7CeyF/gQop/IVsTs/5b0COu0H1eehde7ASXiWhBEskXT0CgqJ43m205CS2dSEd/7sy
         2K2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=OCGCkbI2DSYUg6HeHxm6nACK8W6v9vz3ryu4JaTHbCk=;
        b=WLKOco+fD64pT+VJDZyg0kwosoPHiXaBZHjBAD0cPK/p1RjPveG53XHRL8iK1OCpGQ
         9qHVZprZfgQgnw0l0jgoV2DkVyaReatOF2BQPX5BtHiKP5uICED0odXaJcOBT3VQKLkH
         Ptz7xUoAJXWbQTdetL8oZC3Bo3v8URMWtxD5keNih8KD7d/OLPXJG5NhAJda2S6CmGSz
         swoMMyuKu6DPpvWtjBGEXoLI+o1nKrOz3be3940lxb5q19WXBtqidRKDW2nzzvngSNCt
         RTp9Jo3JyB3b+GZeSY+OaTtPhXHyPSm/y+XWkQZ8lV267+k+bJ9qzGELCu+tCXWjnXhz
         KV+A==
X-Gm-Message-State: AJIora/pYDeH6wNNf7JI771BRNzrBS1/YNjXnhdcqDUOHbsmNuh7cj3f
        SU7VZR4Li5CslDzkOQKVZuefL8EdPz89DQ==
X-Google-Smtp-Source: AGRyM1sx8fYbn83JwRxwVH02lT9E+PWHw/kqJKITJ5+KlqTi9VT9jjjeKiygArdUCSu7Xx9poMHP5A==
X-Received: by 2002:a05:6a00:e85:b0:52b:5db8:f3df with SMTP id bo5-20020a056a000e8500b0052b5db8f3dfmr152513pfb.14.1659037317094;
        Thu, 28 Jul 2022 12:41:57 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id n4-20020a170902d2c400b0016cabb9d77dsm1752813plc.169.2022.07.28.12.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 12:41:56 -0700 (PDT)
Date:   Thu, 28 Jul 2022 12:41:51 -0700
From:   David Matlack <dmatlack@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 044/102] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
Message-ID: <YuLmf+dovudTbjqh@google.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <392839e09c48ff4e14a598ff6ed8bd56429bf17b.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <392839e09c48ff4e14a598ff6ed8bd56429bf17b.1656366338.git.isaku.yamahata@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 27, 2022 at 02:53:36PM -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> For private GPA, CPU refers a private page table whose contents are
> encrypted.  The dedicated APIs to operate on it (e.g. updating/reading its
> PTE entry) are used and their cost is expensive.
> 
> When KVM resolves KVM page fault, it walks the page tables.  To reuse the
> existing KVM MMU code and mitigate the heavy cost to directly walk
> encrypted private page table, allocate a more page to mirror the existing
> KVM page table.  Resolve KVM page fault with the existing code, and do
> additional operations necessary for the mirrored private page table.  To
> distinguish such cases, the existing KVM page table is called a shared page
> table (i.e. no mirrored private page table), and the KVM page table with
> mirrored private page table is called a private page table.  The
> relationship is depicted below.
> 
> Add private pointer to struct kvm_mmu_page for mirrored private page table
> and add helper functions to allocate/initialize/free a mirrored private
> page table page.  Also, add helper functions to check if a given
> kvm_mmu_page is private.  The later patch introduces hooks to operate on
> the mirrored private page table.
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
>  CPU/KVM shared PT root  KVM private PT root     |  CPU private PT root
>         |                      |                 |           |
>         V                      V                 |           V
>      shared PT            private PT <----mirror----> mirrored private PT
>         |                      |                 |           |
>         |                      \-----------------+------\    |
>         |                                        |      |    |
>         V                                        |      V    V
>   shared guest page                              |    private guest page
>                                                  |
>                            non-encrypted memory  |    encrypted memory
>                                                  |
> PT: page table
> 
> Both CPU and KVM refer to CPU/KVM shared page table.  Private page table
> is used only by KVM.  CPU refers to mirrored private page table.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/mmu/mmu.c          |  9 ++++
>  arch/x86/kvm/mmu/mmu_internal.h | 84 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/mmu/tdp_mmu.c      |  3 ++
>  4 files changed, 97 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index f4d4ed41641b..bfc934dc9a33 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -716,6 +716,7 @@ struct kvm_vcpu_arch {
>  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
>  	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
>  	struct kvm_mmu_memory_cache mmu_page_header_cache;
> +	struct kvm_mmu_memory_cache mmu_private_sp_cache;

I notice that mmu_private_sp_cache.gfp_zero is left unset so these pages
may contain garbage. Is this by design because the TDX module can't rely
on the contents being zero and has to take care of initializing the page
itself? i.e. GFP_ZERO would be a waste of cycles?

If I'm correct please include a comment here in the next revision to
explain why GFP_ZERO is not necessary.

>  
>  	/*
>  	 * QEMU userspace and the guest each have their own FPU state.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c517c7bca105..a5bf3e40e209 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -691,6 +691,13 @@ static int mmu_topup_shadow_page_cache(struct kvm_vcpu *vcpu)
>  	int start, end, i, r;
>  	bool is_tdp_mmu = is_tdp_mmu_enabled(vcpu->kvm);
>  
> +	if (kvm_gfn_shared_mask(vcpu->kvm)) {
> +		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_private_sp_cache,
> +					       PT64_ROOT_MAX_LEVEL);
> +		if (r)
> +			return r;
> +	}
> +
>  	if (is_tdp_mmu && shadow_nonpresent_value)
>  		start = kvm_mmu_memory_cache_nr_free_objects(mc);
>  
> @@ -732,6 +739,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_private_sp_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>  }
> @@ -1736,6 +1744,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct
>  	if (!direct)
>  		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> +	kvm_mmu_init_private_sp(sp, NULL);

This is unnecessary. kvm_mmu_page structs are zero-initialized so
private_sp will already be NULL.

>  
>  	/*
>  	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 44a04fad4bed..9f3a6bea60a3 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -55,6 +55,10 @@ struct kvm_mmu_page {
>  	u64 *spt;
>  	/* hold the gfn of each spte inside spt */
>  	gfn_t *gfns;
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +	/* associated private shadow page, e.g. SEPT page. */

Can we use "Secure EPT" instead of SEPT in KVM code and comments? (i.e.
also including variable names like sept_page -> secure_ept_page)

"SEPT" looks like a mispelling of SPTE, which is used all over KVM. It
will be difficult to read code that contains both acronyms.

> +	void *private_sp;

Please name this "private_spt" and move it up next to "spt".

sp" or "shadow page" is used to refer to kvm_mmu_page structs. For
example, look at all the code in KVM that uses `struct kvm_mmu_page *sp`.

"spt" is "shadow page table", i.e. the actual page table memory. See
kvm_mmu_page.spt. Calling this field "private_spt" makes it obvious that
this pointer is pointing to a page table.

Also please update the language in the comment accordingly to "private
shadow page table".

> +#endif
>  	/* Currently serving as active root */
>  	union {
>  		int root_count;
> @@ -115,6 +119,86 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
>  	return kvm_mmu_role_as_id(sp->role);
>  }
>  
> +/*
> + * TDX vcpu allocates page for root Secure EPT page and assigns to CPU secure
> + * EPT pointer.  KVM doesn't need to allocate and link to the secure EPT.
> + * Dummy value to make is_pivate_sp() return true.
> + */
> +#define KVM_MMU_PRIVATE_SP_ROOT	((void *)1)
> +
> +#ifdef CONFIG_KVM_MMU_PRIVATE
> +static inline bool is_private_sp(struct kvm_mmu_page *sp)
> +{
> +	return !!sp->private_sp;
> +}
> +
> +static inline bool is_private_sptep(u64 *sptep)
> +{
> +	WARN_ON(!sptep);
> +	return is_private_sp(sptep_to_sp(sptep));
> +}
> +
> +static inline void *kvm_mmu_private_sp(struct kvm_mmu_page *sp)
> +{
> +	return sp->private_sp;
> +}
> +
> +static inline void kvm_mmu_init_private_sp(struct kvm_mmu_page *sp, void *private_sp)
> +{
> +	sp->private_sp = private_sp;
> +}
> +
> +/* Valid sp->role.level is required. */
> +static inline void kvm_mmu_alloc_private_sp(
> +	struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, bool is_root)
> +{
> +	if (is_root)
> +		sp->private_sp = KVM_MMU_PRIVATE_SP_ROOT;
> +	else
> +		sp->private_sp = kvm_mmu_memory_cache_alloc(
> +			&vcpu->arch.mmu_private_sp_cache);
> +	/*
> +	 * Because mmu_private_sp_cache is topped up before staring kvm page
> +	 * fault resolving, the allocation above shouldn't fail.
> +	 */
> +	WARN_ON_ONCE(!sp->private_sp);
> +}
> +
> +static inline void kvm_mmu_free_private_sp(struct kvm_mmu_page *sp)
> +{
> +	if (sp->private_sp != KVM_MMU_PRIVATE_SP_ROOT)
> +		free_page((unsigned long)sp->private_sp);
> +}
> +#else
> +static inline bool is_private_sp(struct kvm_mmu_page *sp)
> +{
> +	return false;
> +}
> +
> +static inline bool is_private_sptep(u64 *sptep)
> +{
> +	return false;
> +}
> +
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
> +	struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, bool is_root)
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
> index 7eb41b176d1e..b2568b062faa 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -72,6 +72,8 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
>  
>  static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
>  {
> +	if (is_private_sp(sp))
> +		kvm_mmu_free_private_sp(sp);
>  	free_page((unsigned long)sp->spt);
>  	kmem_cache_free(mmu_page_header_cache, sp);
>  }
> @@ -295,6 +297,7 @@ static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, tdp_ptep_t sptep,
>  	sp->gfn = gfn;
>  	sp->ptep = sptep;
>  	sp->tdp_mmu_page = true;
> +	kvm_mmu_init_private_sp(sp);
>  
>  	trace_kvm_mmu_get_page(sp, true);
>  }
> -- 
> 2.25.1
> 
