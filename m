Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD03484A41
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 22:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbiADVy6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 16:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiADVyz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 16:54:55 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56966C061784
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 13:54:55 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 196so33375026pfw.10
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 13:54:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mdIeumwlZ/umOAdPrIWfikHXzTc7jO5Go8WFxU0TTeg=;
        b=RVxajCt5XptqtjQTNUOFUS7KqxntgATGXmjB2qjnHJmtJn6IhwdCzIn9IuanXtY07F
         Vhj0EPiw20l8TbKkJe4umCfUr+MGh24HfO5Qw3DTLExiQ073vOWErd1jUJYXTH3Ntb/C
         EepHbluvFWBAWJRNIMx0C8mu7cizi/a9TPjXNK0M4/Pkycl25TNlD3kSXn5ZhFSGBdO/
         y6YkqWfZw/ab4u7JEPOcD6PA9FYInP4Z/Z27azxQcaCTE0xgx+Ml/yo12OuF+QoS6hfs
         wkYJAdXRgoyK0ZHAni6cTL/BJfnqYtH3dWEao2P85vwjXhsZY7DOpLTowIB91NzSlu5q
         Vn1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mdIeumwlZ/umOAdPrIWfikHXzTc7jO5Go8WFxU0TTeg=;
        b=QsbYE0adoNQOydB0ktLC03KLgOu+XMxWuqLgE9MqgrGakJjq4IsICJgLvpP5+KOErP
         t/fdv+Fs7XrfktZmpc6hrutpSaHiEeXLCsZjZjNsiz3AX2AFUNL/WvPyJ2NLDnSa43eU
         0HmPZWvkSGSTQGEwb6oMJQjvgKGlIanhXWPrBJBtYb2bP+6MYokQMZAp3cGrlUurh/ZR
         ps6ddE8R10/pGPbjF6zgqom8iYpPwRB1rj3HifvOLxQHHToMGOFgyPcDQUtJOAfknHEG
         Hj7zeepvZG66l0wl+Crf+dPiyLI+LhCV1D+GlZVEla8e4kLU1eQrPbmUw7YFi24XCZtT
         111w==
X-Gm-Message-State: AOAM531EYfsfygBimHbfNGiaGa/8NlSkmuP/s61I4nx1KpOGYtX6bCGF
        eAKs234l5m9zmABj69JytZ1X7w==
X-Google-Smtp-Source: ABdhPJyKgsLaJrgHPe8pMNEZ62nqTJxssYbzYOUp9zc9dy9ikJ7m1ePkfmay8OE66LjSh7cJM4pUvA==
X-Received: by 2002:a63:b544:: with SMTP id u4mr19603340pgo.160.1641333294491;
        Tue, 04 Jan 2022 13:54:54 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z2sm35219593pge.86.2022.01.04.13.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 13:54:53 -0800 (PST)
Date:   Tue, 4 Jan 2022 21:54:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH 5/6] KVM: X86: Alloc pae_root shadow page
Message-ID: <YdTCKoTgI5IgOvln@google.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
 <20211210092508.7185-6-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210092508.7185-6-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Currently pae_root is special root page, this patch adds facility to
> allow using kvm_mmu_get_page() to allocate pae_root shadow page.
> 
> When kvm_mmu_get_page() is called for level == PT32E_ROOT_LEVEL and
> vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL, it will get a
> DMA32 root page with default PAE pdptes installed.
> 
> The pae_root bit is needed in the page role because:
> 	it is required to be DMA32 page.

Please try to avoid ambiguous pronouns, "it" here does not refer to any of the
nouns that were established in the initial sentence, e.g.

        PAE roots must be allocated below 4gb (CR3 has only 32 bits).

> 	its first 4 sptes are initialized with default_pae_pdpte.
> 
> default_pae_pdpte is needed because the cpu expect PAE pdptes are
> present when VMenter.

That's incorrect.  Neither Intel nor AMD require PDPTEs to be present.  Not present
is perfectly ok, present with reserved bits is what's not allowed.

Intel SDM:
  A VM entry that checks the validity of the PDPTEs uses the same checks that are
  used when CR3 is loaded with MOV to CR3 when PAE paging is in use[7].  If MOV to CR3
  would cause a general-protection exception due to the PDPTEs that would be loaded
  (e.g., because a reserved bit is set), the VM entry fails.
  
  7. This implies that (1) bits 11:9 in each PDPTE are ignored; and (2) if bit 0
     (present) is clear in one of the PDPTEs, bits 63:1 of that PDPTE are ignored.

AMD APM:
  On current AMD64 processors, in native mode, these four entries are unconditionally
  loaded into the table walk cache whenever CR3 is written with the PDPT base address,
  and remain locked in. At this point they are also checked for reserved bit violations,
  and if such violations are present a general-protection exception (#GP) occurs.

  Under SVM, however, when the processor is in guest mode with PAE enabled, the
  guest PDPT entries are not cached or validated at this point, but instead are loaded
  and checked on demand in the normal course of address translation, just like page
  directory and page table entries. Any reserved bit violations are detected at the point
  of use, and result in a page-fault (#PF) exception rather than a Page Translation and
  Protection general-protection (#GP) exception.

> default_pae_pdpte is designed to have no
> SPTE_MMU_PRESENT_MASK so that it is present in the view of CPU but not
> present in the view of shadow papging, and the page fault handler will
> replace it with real present shadow page.

> 
> When changing from default_pae_pdpte to a present spte, no tlb flushing
> is requested, although both are present in the view of CPU.  The reason
> is that default_pae_pdpte points to zero page, no pte is present if the
> paging structure is cached.
> 
> No functionality changed since this code is not activated because when
> vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL, kvm_mmu_get_page()
> is only called for level == 1 or 2 now.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   4 +-
>  arch/x86/kvm/mmu/mmu.c          | 113 +++++++++++++++++++++++++++++++-
>  arch/x86/kvm/mmu/paging_tmpl.h  |   1 +
>  3 files changed, 114 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6465c83794fc..82a8844f80ac 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -335,7 +335,8 @@ union kvm_mmu_page_role {
>  		unsigned ad_disabled:1;
>  		unsigned guest_mode:1;
>  		unsigned level_promoted:1;
> -		unsigned :5;
> +		unsigned pae_root:1;
> +		unsigned :4;
>  
>  		/*
>  		 * This is left at the top of the word so that
> @@ -695,6 +696,7 @@ struct kvm_vcpu_arch {
>  	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
>  	struct kvm_mmu_memory_cache mmu_gfn_array_cache;
>  	struct kvm_mmu_memory_cache mmu_page_header_cache;
> +	unsigned long mmu_pae_root_cache;

Hmm, I think it will be easier to understand exactly what this "cache" holds if
the cache is tracked as a pointer, either the page_address() "void *" or maybe
even the original "struct page".  A "void *" is probably the way to go; less code
than tracking "struct page" and kvm_mmu_memory_cache_alloc() also returns "void *".

>  	/*
>  	 * QEMU userspace and the guest each have their own FPU state.
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4769253e9024..0d2976dad863 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -724,6 +724,67 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> +static u64 default_pae_pdpte;
> +
> +static void free_default_pae_pdpte(void)
> +{
> +	free_page((unsigned long)__va(default_pae_pdpte & PAGE_MASK));
> +	default_pae_pdpte = 0;
> +}
> +
> +static int alloc_default_pae_pdpte(void)
> +{
> +	unsigned long p = __get_free_page(GFP_KERNEL | __GFP_ZERO);
> +
> +	if (!p)
> +		return -ENOMEM;
> +	default_pae_pdpte = __pa(p) | PT_PRESENT_MASK | shadow_me_mask;
> +	if (WARN_ON(is_shadow_present_pte(default_pae_pdpte) ||
> +		    is_mmio_spte(default_pae_pdpte))) {
> +		free_default_pae_pdpte();
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +static int alloc_pae_root(struct kvm_vcpu *vcpu)

I'd prefer we name this mmu_topup_pae_root_cache().  "alloc_pae_root" implies the
helper returns the allocated root.

> +{
> +	struct page *page;
> +	unsigned long pae_root;
> +	u64* pdpte;
> +
> +	if (vcpu->arch.mmu->shadow_root_level != PT32E_ROOT_LEVEL)
> +		return 0;
> +	if (vcpu->arch.mmu_pae_root_cache)
> +		return 0;
> +
> +	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_DMA32);
> +	if (!page)
> +		return -ENOMEM;
> +
> +	pae_root = (unsigned long)page_address(page);
> +
> +	/*
> +	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
> +	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
> +	 * that KVM's writes and the CPU's reads get along.  Note, this is
> +	 * only necessary when using shadow paging, as 64-bit NPT can get at
> +	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
> +	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
> +	 */
> +	if (!tdp_enabled)
> +		set_memory_decrypted(pae_root, 1);
> +	else
> +		WARN_ON_ONCE(shadow_me_mask);
> +	vcpu->arch.mmu_pae_root_cache = pae_root;
> +	pdpte = (void *)pae_root;
> +	pdpte[0] = default_pae_pdpte;
> +	pdpte[1] = default_pae_pdpte;
> +	pdpte[2] = default_pae_pdpte;
> +	pdpte[3] = default_pae_pdpte;
> +	return 0;

Assuming I'm not missing something regarding default_pae_pdpte, this can be:

	struct page *page;

	if (vcpu->arch.mmu->shadow_root_level != PT32E_ROOT_LEVEL)
		return 0;
	if (vcpu->arch.mmu_pae_root_cache)
		return 0;

	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_DMA32);
	if (!page)
		return -ENOMEM;

	vcpu->arch.mmu_pae_root_cache = page_address(page);

	/*
	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
	 * that KVM's writes and the CPU's reads get along.  Note, this is
	 * only necessary when using shadow paging, as 64-bit NPT can get at
	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
	 */
	if (!tdp_enabled)
		set_memory_decrypted((unsigned long)vcpu->arch.mmu_pae_root_cache, 1);
	else
		WARN_ON_ONCE(shadow_me_mask);
	return 0;


> +}
> +
>  static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  {
>  	int r;
> @@ -735,6 +796,9 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>  		return r;
>  	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
>  				       PT64_ROOT_MAX_LEVEL);
> +	if (r)
> +		return r;
> +	r = alloc_pae_root(vcpu);
>  	if (r)
>  		return r;
>  	if (maybe_indirect) {
> @@ -753,6 +817,10 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_gfn_array_cache);
>  	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
> +	if (!tdp_enabled && vcpu->arch.mmu_pae_root_cache)
> +		set_memory_encrypted(vcpu->arch.mmu_pae_root_cache, 1);
> +	free_page(vcpu->arch.mmu_pae_root_cache);
> +	vcpu->arch.mmu_pae_root_cache = 0;

If this ends up being a void *, set to NULL intead of 0.

>  }
>  
>  static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_vcpu *vcpu)
> @@ -1706,6 +1774,8 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>  	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
>  	hlist_del(&sp->hash_link);
>  	list_del(&sp->link);
> +	if (!tdp_enabled && sp->role.pae_root)
> +		set_memory_encrypted((unsigned long)sp->spt, 1);

Hmm, I wonder if it would be better to do:

	if (sp->role.pae_root)
		mmu_free_pae_root(sp->spt);
	else
		free_page((unsigned long)sp->spt);

and then share the helper with mmu_free_memory_caches(), e.g.

	if (vcpu->arch.mmu_pae_root_cache) {
		mmu_free_pae_root(vcpu->arch.mmu_pae_root_cache);
		vcpu->arch.mmu_pae_root_cache = NULL;
	}

This is perfectly ok, but I think it would be asy for someone to misread
mmu_free_memory_caches() and think that the free_page() there could be inside the
if statement.  Having this in a helper:

	if (!tdp_enabled)
		set_memory_encrypted((unsigned long)root, 1);
	free_page((unsigned long)root);

makes it a bit more obvious that re-encrypting memory is a !TDP specific action
that's on top of the "applies to everything" free_page().

>  	free_page((unsigned long)sp->spt);
>  	if (!sp->role.direct && !sp->role.level_promoted)
>  		free_page((unsigned long)sp->gfns);
> @@ -1735,8 +1805,13 @@ static void mmu_page_remove_parent_pte(struct kvm_mmu_page *sp,
>  static void drop_parent_pte(struct kvm_mmu_page *sp,
>  			    u64 *parent_pte)
>  {
> +	struct kvm_mmu_page *parent_sp = sptep_to_sp(parent_pte);
> +
>  	mmu_page_remove_parent_pte(sp, parent_pte);
> -	mmu_spte_clear_no_track(parent_pte);
> +	if (!parent_sp->role.pae_root)
> +		mmu_spte_clear_no_track(parent_pte);
> +	else
> +		__update_clear_spte_fast(parent_pte, default_pae_pdpte);
>  }
>  
>  static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn, union kvm_mmu_page_role role)
> @@ -1744,7 +1819,12 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  	struct kvm_mmu_page *sp;
>  
>  	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +	if (!role.pae_root) {
> +		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +	} else {
> +		sp->spt = (void *)vcpu->arch.mmu_pae_root_cache;
> +		vcpu->arch.mmu_pae_root_cache = 0;
> +	}
>  	if (!(role.direct || role.level_promoted))
>  		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> @@ -2091,6 +2171,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  	}
>  	if (role.level_promoted && (level <= vcpu->arch.mmu->root_level))
>  		role.level_promoted = 0;
> +	if (role.pae_root && (level < PT32E_ROOT_LEVEL))

Hmm, for both these checks, I think it's easier to read if the first test is
dropped, i.e.

	if (level <= vcpu->arch.mmu->root_level)
		role.level_promoted = 0;
	if (level != PT32E_ROOT_LEVEL)
		role.pae_root = 0;
		
> +		role.pae_root = 0;
>  
>  	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>  	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
> @@ -2226,14 +2308,27 @@ static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
>  	__shadow_walk_next(iterator, *iterator->sptep);
>  }
>  
> +static u64 make_pae_pdpte(u64 *child_pt)
> +{
> +	u64 spte = __pa(child_pt) | PT_PRESENT_MASK;
> +
> +	/* The only ignore bits in PDPTE are 11:9. */

Yeah, stupid PAE paging. :-/

> +	BUILD_BUG_ON(!(GENMASK(11,9) & SPTE_MMU_PRESENT_MASK));
> +	return spte | SPTE_MMU_PRESENT_MASK | shadow_me_mask;

I'd say drop "spte" and just do:

	return __pa(child_pt) | PT_PRESENT_MASK | SPTE_MMU_PRESENT_MASK |
	       shadow_me_mask;

> +}
> +
>  static void link_shadow_page(struct kvm_vcpu *vcpu, u64 *sptep,
>  			     struct kvm_mmu_page *sp)
>  {
> +	struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
>  	u64 spte;
>  
>  	BUILD_BUG_ON(VMX_EPT_WRITABLE_MASK != PT_WRITABLE_MASK);
>  
> -	spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
> +	if (!parent_sp->role.pae_root)
> +		spte = make_nonleaf_spte(sp->spt, sp_ad_disabled(sp));
> +	else
> +		spte = make_pae_pdpte(sp->spt);
>  
>  	mmu_spte_set(sptep, spte);
>  
> @@ -4733,6 +4828,8 @@ kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  	role.base.level = kvm_mmu_get_tdp_level(vcpu);
>  	role.base.direct = true;
>  	role.base.has_4_byte_gpte = false;
> +	if (role.base.level == PT32E_ROOT_LEVEL)
> +		role.base.pae_root = 1;
>  
>  	return role;
>  }
> @@ -4798,6 +4895,9 @@ kvm_calc_shadow_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  	else
>  		role.base.level = PT64_ROOT_4LEVEL;
>  
> +	if (!____is_cr0_pg(regs) || !____is_efer_lma(regs))

The CR0.PG check is redundant as EFER.LMA cannot be '1' if CR0.PG=0.  It's confusing
because the role.base.level calculation above omits the CR0.PG check.  Speaking of
which, I think this would be clearer:

	if (role.base.level == PT32E_ROOT_LEVEL)
		role.base.pae_root = 1;

Alternatively, it could be folded in to the level calcuation, e.g.

	if (!____is_efer_lma(regs)) {
		role.base.level = PT32E_ROOT_LEVEL;
		role.base.pae_root = 1;
		if (____is_cr0_pg(regs) && !____is_cr4_pse(regs))
			role.base.level_promoted = 1;
	} else if (____is_cr4_la57(regs)) {
		role.base.level = PT64_ROOT_5LEVEL;
	} else {
		role.base.level = PT64_ROOT_4LEVEL;
	}

though I think I prefer to keep that purely a level calcuation.

> +		role.base.pae_root = 1;
> +
>  	return role;
>  }
>  
> @@ -4845,6 +4945,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
>  	role.base.level = kvm_mmu_get_tdp_level(vcpu);
>  	if (role.base.level > role_regs_to_root_level(regs))
>  		role.base.level_promoted = 1;
> +	if (role.base.level == PT32E_ROOT_LEVEL)
> +		role.base.pae_root = 1;

I almost wonder if we'd be better off having a "root" flag, and then a helper:

  static bool is_pae_root(union kvm_mmu_page_role role)
  {
  	return role.root && role.level == PT32E_ROOT_LEVEL;
  }

I believe the only collateral damage would be that it'd prevent reusing a 4-level
root in a 5-level paging structure, but that's not necessarily a bad thing.

>  
>  	return role;
>  }
> @@ -6133,6 +6235,10 @@ int kvm_mmu_module_init(void)
>  	if (ret)
>  		goto out;
>  
> +	ret = alloc_default_pae_pdpte();
> +	if (ret)
> +		goto out;
> +
>  	return 0;
>  
>  out:
> @@ -6174,6 +6280,7 @@ void kvm_mmu_destroy(struct kvm_vcpu *vcpu)
>  
>  void kvm_mmu_module_exit(void)
>  {
> +	free_default_pae_pdpte();
>  	mmu_destroy_caches();
>  	percpu_counter_destroy(&kvm_total_used_mmu_pages);
>  	unregister_shrinker(&mmu_shrinker);
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 16ac276d342a..014136e15b26 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -1044,6 +1044,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		.access = 0x7,
>  		.quadrant = 0x3,
>  		.level_promoted = 0x1,
> +		.pae_root = 0x1,
>  	};
>  
>  	/*
> -- 
> 2.19.1.6.gb485710b
> 
