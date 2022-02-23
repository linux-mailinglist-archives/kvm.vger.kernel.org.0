Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8354C158E
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 15:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241673AbiBWOjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 09:39:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235883AbiBWOjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 09:39:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5FF0CB45A5
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 06:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645627149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OtcTfEweslwAeaW6qEWNCrO6NxqLu/rZRSkJV8vIPrA=;
        b=Lllv4N7yCekBFOjG5qYINcN7SFGFPjCkLDQeHGFdKQcyUDHXgYanie1XHiyJe8qB/fCLu7
        nrOSly1gt153t+kJswU8RGlnQwdvi4G7am8/pitd8nx8H2IV7bBBtwTFFHVGQJio/uUpXL
        E8hIyj6Q0O2A3f6xRpfNmgW3rEMfLZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-OmC-bwDVMVm7Qwuql7d4Gg-1; Wed, 23 Feb 2022 09:39:08 -0500
X-MC-Unique: OmC-bwDVMVm7Qwuql7d4Gg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1C720180FD71;
        Wed, 23 Feb 2022 14:39:07 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C5797DE4A;
        Wed, 23 Feb 2022 14:39:05 +0000 (UTC)
Message-ID: <cb338203d9abf040fc1b68763ce60369cc8342a6.camel@redhat.com>
Subject: Re: [PATCH v2 05/18] KVM: x86/mmu: use struct kvm_mmu_root_info for
 mmu->root
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     seanjc@google.com
Date:   Wed, 23 Feb 2022 16:39:04 +0200
In-Reply-To: <20220217210340.312449-6-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
         <20220217210340.312449-6-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-02-17 at 16:03 -0500, Paolo Bonzini wrote:
> The root_hpa and root_pgd fields form essentially a struct kvm_mmu_root_info.
> Use the struct to have more consistency between mmu->root and
> mmu->prev_roots.
> 
> The patch is entirely search and replace except for cached_root_available,
> which does not need a temporary struct kvm_mmu_root_info anymore.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +-
>  arch/x86/kvm/mmu.h              |  4 +-
>  arch/x86/kvm/mmu/mmu.c          | 69 +++++++++++++++------------------
>  arch/x86/kvm/mmu/mmu_audit.c    |  4 +-
>  arch/x86/kvm/mmu/paging_tmpl.h  |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.h      |  2 +-
>  arch/x86/kvm/vmx/nested.c       |  2 +-
>  arch/x86/kvm/vmx/vmx.c          |  2 +-
>  arch/x86/kvm/x86.c              |  2 +-
>  10 files changed, 42 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 8e512f25a930..6442facfd5c0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -432,8 +432,7 @@ struct kvm_mmu {
>  	int (*sync_page)(struct kvm_vcpu *vcpu,
>  			 struct kvm_mmu_page *sp);
>  	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
> -	hpa_t root_hpa;
> -	gpa_t root_pgd;
> +	struct kvm_mmu_root_info root;
>  	union kvm_mmu_role mmu_role;
>  	u8 root_level;
>  	u8 shadow_root_level;
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index a5a50cfeffff..1d0c1904d69a 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -85,7 +85,7 @@ void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
>  
>  static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
>  {
> -	if (likely(vcpu->arch.mmu->root_hpa != INVALID_PAGE))
> +	if (likely(vcpu->arch.mmu->root.hpa != INVALID_PAGE))
>  		return 0;
>  
>  	return kvm_mmu_load(vcpu);
> @@ -107,7 +107,7 @@ static inline unsigned long kvm_get_active_pcid(struct kvm_vcpu *vcpu)
>  
>  static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
>  {
> -	u64 root_hpa = vcpu->arch.mmu->root_hpa;
> +	u64 root_hpa = vcpu->arch.mmu->root.hpa;
>  
>  	if (!VALID_PAGE(root_hpa))
>  		return;
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6ea423b00824..a478667d7561 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2162,7 +2162,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
>  		 * prev_root is currently only used for 64-bit hosts. So only
>  		 * the active root_hpa is valid here.
>  		 */
> -		BUG_ON(root != vcpu->arch.mmu->root_hpa);
> +		BUG_ON(root != vcpu->arch.mmu->root.hpa);
>  
>  		iterator->shadow_addr
>  			= vcpu->arch.mmu->pae_root[(addr >> 30) & 3];
> @@ -2176,7 +2176,7 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
>  static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
>  			     struct kvm_vcpu *vcpu, u64 addr)
>  {
> -	shadow_walk_init_using_root(iterator, vcpu, vcpu->arch.mmu->root_hpa,
> +	shadow_walk_init_using_root(iterator, vcpu, vcpu->arch.mmu->root.hpa,
>  				    addr);
>  }
>  
> @@ -3245,7 +3245,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	BUILD_BUG_ON(KVM_MMU_NUM_PREV_ROOTS >= BITS_PER_LONG);
>  
>  	/* Before acquiring the MMU lock, see if we need to do any real work. */
> -	if (!(free_active_root && VALID_PAGE(mmu->root_hpa))) {
> +	if (!(free_active_root && VALID_PAGE(mmu->root.hpa))) {
>  		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>  			if ((roots_to_free & KVM_MMU_ROOT_PREVIOUS(i)) &&
>  			    VALID_PAGE(mmu->prev_roots[i].hpa))
> @@ -3265,7 +3265,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	if (free_active_root) {
>  		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
>  		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
> -			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
> +			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
>  		} else if (mmu->pae_root) {
>  			for (i = 0; i < 4; ++i) {
>  				if (!IS_VALID_PAE_ROOT(mmu->pae_root[i]))
> @@ -3276,8 +3276,8 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  				mmu->pae_root[i] = INVALID_PAE_ROOT;
>  			}
>  		}
> -		mmu->root_hpa = INVALID_PAGE;
> -		mmu->root_pgd = 0;
> +		mmu->root.hpa = INVALID_PAGE;
> +		mmu->root.pgd = 0;
>  	}
>  
>  	kvm_mmu_commit_zap_page(kvm, &invalid_list);
> @@ -3350,10 +3350,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  
>  	if (is_tdp_mmu_enabled(vcpu->kvm)) {
>  		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> -		mmu->root_hpa = root;
> +		mmu->root.hpa = root;
>  	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
>  		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
> -		mmu->root_hpa = root;
> +		mmu->root.hpa = root;
>  	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
>  		if (WARN_ON_ONCE(!mmu->pae_root)) {
>  			r = -EIO;
> @@ -3368,15 +3368,15 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  			mmu->pae_root[i] = root | PT_PRESENT_MASK |
>  					   shadow_me_mask;
>  		}
> -		mmu->root_hpa = __pa(mmu->pae_root);
> +		mmu->root.hpa = __pa(mmu->pae_root);
>  	} else {
>  		WARN_ONCE(1, "Bad TDP root level = %d\n", shadow_root_level);
>  		r = -EIO;
>  		goto out_unlock;
>  	}
>  
> -	/* root_pgd is ignored for direct MMUs. */
> -	mmu->root_pgd = 0;
> +	/* root.pgd is ignored for direct MMUs. */
> +	mmu->root.pgd = 0;
>  out_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  	return r;
> @@ -3489,7 +3489,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
>  		root = mmu_alloc_root(vcpu, root_gfn, 0,
>  				      mmu->shadow_root_level, false);
> -		mmu->root_hpa = root;
> +		mmu->root.hpa = root;
>  		goto set_root_pgd;
>  	}
>  
> @@ -3539,14 +3539,14 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	}
>  
>  	if (mmu->shadow_root_level == PT64_ROOT_5LEVEL)
> -		mmu->root_hpa = __pa(mmu->pml5_root);
> +		mmu->root.hpa = __pa(mmu->pml5_root);
>  	else if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
> -		mmu->root_hpa = __pa(mmu->pml4_root);
> +		mmu->root.hpa = __pa(mmu->pml4_root);
>  	else
> -		mmu->root_hpa = __pa(mmu->pae_root);
> +		mmu->root.hpa = __pa(mmu->pae_root);
>  
>  set_root_pgd:
> -	mmu->root_pgd = root_pgd;
> +	mmu->root.pgd = root_pgd;
>  out_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  
> @@ -3659,13 +3659,13 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  	if (vcpu->arch.mmu->direct_map)
>  		return;
>  
> -	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
> +	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
>  		return;
>  
>  	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
>  
>  	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
> -		hpa_t root = vcpu->arch.mmu->root_hpa;
> +		hpa_t root = vcpu->arch.mmu->root.hpa;
>  		sp = to_shadow_page(root);
>  
>  		if (!is_unsync_root(root))
> @@ -3956,7 +3956,7 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  static bool is_page_fault_stale(struct kvm_vcpu *vcpu,
>  				struct kvm_page_fault *fault, int mmu_seq)
>  {
> -	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root_hpa);
> +	struct kvm_mmu_page *sp = to_shadow_page(vcpu->arch.mmu->root.hpa);
>  
>  	/* Special roots, e.g. pae_root, are not backed by shadow pages. */
>  	if (sp && is_obsolete_sp(vcpu->kvm, sp))
> @@ -4113,34 +4113,27 @@ static inline bool is_root_usable(struct kvm_mmu_root_info *root, gpa_t pgd,
>  /*
>   * Find out if a previously cached root matching the new pgd/role is available.
>   * The current root is also inserted into the cache.
> - * If a matching root was found, it is assigned to kvm_mmu->root_hpa and true is
> + * If a matching root was found, it is assigned to kvm_mmu->root.hpa and true is
>   * returned.
> - * Otherwise, the LRU root from the cache is assigned to kvm_mmu->root_hpa and
> + * Otherwise, the LRU root from the cache is assigned to kvm_mmu->root.hpa and
>   * false is returned. This root should now be freed by the caller.
>   */
>  static bool cached_root_available(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  				  union kvm_mmu_page_role new_role)
>  {
>  	uint i;
> -	struct kvm_mmu_root_info root;
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  
> -	root.pgd = mmu->root_pgd;
> -	root.hpa = mmu->root_hpa;
> -
> -	if (is_root_usable(&root, new_pgd, new_role))
> +	if (is_root_usable(&mmu->root, new_pgd, new_role))
>  		return true;
>  
>  	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
> -		swap(root, mmu->prev_roots[i]);
> +		swap(mmu->root, mmu->prev_roots[i]);
>  
> -		if (is_root_usable(&root, new_pgd, new_role))
> +		if (is_root_usable(&mmu->root, new_pgd, new_role))
>  			break;
>  	}
>  
> -	mmu->root_hpa = root.hpa;
> -	mmu->root_pgd = root.pgd;
> -
>  	return i < KVM_MMU_NUM_PREV_ROOTS;
>  }
>  
> @@ -4196,7 +4189,7 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>  	 */
>  	if (!new_role.direct)
>  		__clear_sp_write_flooding_count(
> -				to_shadow_page(vcpu->arch.mmu->root_hpa));
> +				to_shadow_page(vcpu->arch.mmu->root.hpa));
>  }
>  
>  void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
> @@ -5092,7 +5085,7 @@ static void __kvm_mmu_unload(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>  {
>  	int i;
>  	kvm_mmu_free_roots(vcpu, mmu, KVM_MMU_ROOTS_ALL);
> -	WARN_ON(VALID_PAGE(mmu->root_hpa));
> +	WARN_ON(VALID_PAGE(mmu->root.hpa));
>  	if (mmu->pae_root) {
>  		for (i = 0; i < 4; ++i)
>  			WARN_ON(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
> @@ -5287,7 +5280,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  	int r, emulation_type = EMULTYPE_PF;
>  	bool direct = vcpu->arch.mmu->direct_map;
>  
> -	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
> +	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>  		return RET_PF_RETRY;
>  
>  	r = RET_PF_INVALID;
> @@ -5359,7 +5352,7 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  		return;
>  
>  	if (root_hpa == INVALID_PAGE) {
> -		mmu->invlpg(vcpu, gva, mmu->root_hpa);
> +		mmu->invlpg(vcpu, gva, mmu->root.hpa);
>  
>  		/*
>  		 * INVLPG is required to invalidate any global mappings for the VA,
> @@ -5395,7 +5388,7 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
>  	uint i;
>  
>  	if (pcid == kvm_get_active_pcid(vcpu)) {
> -		mmu->invlpg(vcpu, gva, mmu->root_hpa);
> +		mmu->invlpg(vcpu, gva, mmu->root.hpa);
>  		tlb_flush = true;
>  	}
>  
> @@ -5508,8 +5501,8 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
>  	struct page *page;
>  	int i;
>  
> -	mmu->root_hpa = INVALID_PAGE;
> -	mmu->root_pgd = 0;
> +	mmu->root.hpa = INVALID_PAGE;
> +	mmu->root.pgd = 0;
>  	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>  		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
>  
> diff --git a/arch/x86/kvm/mmu/mmu_audit.c b/arch/x86/kvm/mmu/mmu_audit.c
> index f31fdb874f1f..3e5d62a25350 100644
> --- a/arch/x86/kvm/mmu/mmu_audit.c
> +++ b/arch/x86/kvm/mmu/mmu_audit.c
> @@ -56,11 +56,11 @@ static void mmu_spte_walk(struct kvm_vcpu *vcpu, inspect_spte_fn fn)
>  	int i;
>  	struct kvm_mmu_page *sp;
>  
> -	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
> +	if (!VALID_PAGE(vcpu->arch.mmu->root.hpa))
>  		return;
>  
>  	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
> -		hpa_t root = vcpu->arch.mmu->root_hpa;
> +		hpa_t root = vcpu->arch.mmu->root.hpa;
>  
>  		sp = to_shadow_page(root);
>  		__mmu_spte_walk(vcpu, sp, fn, vcpu->arch.mmu->root_level);
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 5b5bdac97c7b..346f3bad3cb9 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -668,7 +668,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	if (FNAME(gpte_changed)(vcpu, gw, top_level))
>  		goto out_gpte_changed;
>  
> -	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
> +	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
>  		goto out_gpte_changed;
>  
>  	for (shadow_walk_init(&it, vcpu, fault->addr);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 8def8f810cb0..debf08212f12 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -657,7 +657,7 @@ static inline void tdp_mmu_set_spte_no_dirty_log(struct kvm *kvm,
>  		else
>  
>  #define tdp_mmu_for_each_pte(_iter, _mmu, _start, _end)		\
> -	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root_hpa), _start, _end)
> +	for_each_tdp_pte(_iter, to_shadow_page(_mmu->root.hpa), _start, _end)
>  
>  /*
>   * Yield if the MMU lock is contended or this thread needs to return control
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index 3f987785702a..57c73d8f76ce 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -95,7 +95,7 @@ static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu
>  static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
>  {
>  	struct kvm_mmu_page *sp;
> -	hpa_t hpa = mmu->root_hpa;
> +	hpa_t hpa = mmu->root.hpa;
>  
>  	if (WARN_ON(!VALID_PAGE(hpa)))
>  		return false;
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index c73e4d938ddc..29289ecca223 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5466,7 +5466,7 @@ static int handle_invept(struct kvm_vcpu *vcpu)
>  				VMXERR_INVALID_OPERAND_TO_INVEPT_INVVPID);
>  
>  		roots_to_free = 0;
> -		if (nested_ept_root_matches(mmu->root_hpa, mmu->root_pgd,
> +		if (nested_ept_root_matches(mmu->root.hpa, mmu->root.pgd,
>  					    operand.eptp))
>  			roots_to_free |= KVM_MMU_ROOT_CURRENT;
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d8547144d3b7..b183dfc41d74 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2952,7 +2952,7 @@ static inline int vmx_get_current_vpid(struct kvm_vcpu *vcpu)
>  static void vmx_flush_tlb_current(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> -	u64 root_hpa = mmu->root_hpa;
> +	u64 root_hpa = mmu->root.hpa;
>  
>  	/* No flush required if the current context is invalid. */
>  	if (!VALID_PAGE(root_hpa))
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b912eef5dc1a..c0d7256e3a78 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -762,7 +762,7 @@ bool kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
>  	if ((fault->error_code & PFERR_PRESENT_MASK) &&
>  	    !(fault->error_code & PFERR_RSVD_MASK))
>  		kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
> -				       fault_mmu->root_hpa);
> +				       fault_mmu->root.hpa);
>  
>  	fault_mmu->inject_page_fault(vcpu, fault);
>  	return fault->nested_page_fault;


As a follow up to this patch I suggest that we should also rename pgd to just 'gpa'.

This also brings a question, what pgd acronym actually means? 
I guess paging guest directory?

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

