Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F395A5295ED
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 02:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236269AbiEQAQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 20:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiEQAQl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 20:16:41 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D19C344C6
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 17:16:40 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id g184so15580279pgc.1
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 17:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dnz4JDxMIdsf0gXN93H4X2ISWXCOOxRSrQqaWV0HKns=;
        b=IBgJC6/BMzCtUFmrsdsWAUqe6sK2PrYrFW52F/6m7Hqpifwg6vz31Xcbnqu9p3uju9
         VlhFEet6IssNqQoeSTGgaVHllQ+KNujGGeOGyj17PPaD5P7t7qkru/AbAwcrj4xfzpWV
         MZKRtWeiu3tGHwTHxQ8QRAzmOKrou6CxDQjPk4mkM5NGh+0ug1q1NRyrb+BTTut5ues0
         whQa9+uoEsZQ6W4ZcFVTSJYpP3AVn4DHmOkMPZJjmZdoGcEvfLm2WwB8/6CmqXlzjdR1
         ni9H/apJRq9ubg/dCaVPX+h335nmeDhWyqcUX6UVQNLDFlqyvzeClP/zPxvVFUhdIyBp
         mQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dnz4JDxMIdsf0gXN93H4X2ISWXCOOxRSrQqaWV0HKns=;
        b=Pum4KVSoJh9ahkHePGUddzvdOUhOHhDqhr8jL3DrVhqo3TG8yhzolYOTh3reUaxidy
         fstTXUU4SnN/iUEHbHVju729f5KJzqmV4Bg/tWf/tBZMucHchdem+zfH8s5hOQipz0BQ
         A2B7rdSzqdTJaa3fYOX50sbtC1E+nfgA1AI2uvLuEQ+mpRRWkf9ixP4QVaaEmg3VOtOV
         JMiSR/7L9PxU+sLc0VbX7wkq9T/NYDCPJRZF0zH7eFJnF4quzTraA9OaOaUoQ5UnmqaN
         K3Zk/8Yq3dKhW1YlBHCmhwJzRWgT7EWD/CyqQhkX/itVyHhC85khJJOr5NK7f+zEovhe
         0NPQ==
X-Gm-Message-State: AOAM533WKGf5g6/gSe6h72hNSWUwlDh84A21++IoLjhGZARUriHKMOKF
        V3zEDVRBBHIs5uQRjdKjDoE1Bg==
X-Google-Smtp-Source: ABdhPJxnA37m3nScM2kIgZ/BPiwlgwrHqIzFwWSGlo9ESEcjOffs0Wm+Td4pDrac11Hq/Unpu1i7Bw==
X-Received: by 2002:a05:6a00:1391:b0:50d:e125:e3c with SMTP id t17-20020a056a00139100b0050de1250e3cmr20041155pfg.75.1652746599495;
        Mon, 16 May 2022 17:16:39 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id d13-20020a62f80d000000b0050dc7628162sm7503757pfh.60.2022.05.16.17.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 17:16:38 -0700 (PDT)
Date:   Tue, 17 May 2022 00:16:35 +0000
From:   David Matlack <dmatlack@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH V2 4/7] KVM: X86/MMU: Activate special shadow pages and
 remove old logic
Message-ID: <YoLpY9MFxNTBidqB@google.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-5-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503150735.32723-5-jiangshanlai@gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 03, 2022 at 11:07:32PM +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Activate special shadow pages by allocate special shadow pages in
> mmu_alloc_direct_roots() and mmu_alloc_shadow_roots().
> 
> Make shadow walkings walk from the topmost shadow page even it is
> special shadow page so that they can be walked like normal root
> and shadowed PDPTEs can be made and installed on-demand.
> 
> Walking from the topmost causes FNAME(fetch) needs to visit high level
> special shadow pages and allocate special shadow pages when shadowing
> NPT for 32bit L1 in 64bit host, so change FNAME(fetch) and
> FNAME(walk_addr_generic) to handle it for affected code.
> 
> Do sync from the topmost in kvm_mmu_sync_roots() and simplifies
> the code.
> 
> Now all the root pages and pagetable pointed by a present spte in
> struct kvm_mmu are associated by struct kvm_mmu_page, and
> to_shadow_page() is guaranteed to be not NULL.
> 
> Affect cases are those that using_special_root_page() return true.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c         | 168 +++------------------------------
>  arch/x86/kvm/mmu/paging_tmpl.h |  14 ++-
>  2 files changed, 24 insertions(+), 158 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3fe70ad3bda2..6f626d7e8ebb 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2214,26 +2214,6 @@ static void shadow_walk_init_using_root(struct kvm_shadow_walk_iterator *iterato
>  	iterator->addr = addr;
>  	iterator->shadow_addr = root;
>  	iterator->level = vcpu->arch.mmu->root_role.level;
> -
> -	if (iterator->level >= PT64_ROOT_4LEVEL &&
> -	    vcpu->arch.mmu->cpu_role.base.level < PT64_ROOT_4LEVEL &&
> -	    !vcpu->arch.mmu->root_role.direct)
> -		iterator->level = PT32E_ROOT_LEVEL;
> -
> -	if (iterator->level == PT32E_ROOT_LEVEL) {
> -		/*
> -		 * prev_root is currently only used for 64-bit hosts. So only
> -		 * the active root_hpa is valid here.
> -		 */
> -		BUG_ON(root != vcpu->arch.mmu->root.hpa);
> -
> -		iterator->shadow_addr
> -			= vcpu->arch.mmu->pae_root[(addr >> 30) & 3];
> -		iterator->shadow_addr &= PT64_BASE_ADDR_MASK;
> -		--iterator->level;
> -		if (!iterator->shadow_addr)
> -			iterator->level = 0;
> -	}
>  }
>  
>  static void shadow_walk_init(struct kvm_shadow_walk_iterator *iterator,
> @@ -3412,21 +3392,10 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
>  					   &invalid_list);
>  
>  	if (free_active_root) {
> -		if (to_shadow_page(mmu->root.hpa)) {
> -			if (using_special_root_page(mmu))
> -				mmu_free_special_root_page(kvm, mmu);
> -			else
> -				mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
> -		} else if (mmu->pae_root) {
> -			for (i = 0; i < 4; ++i) {
> -				if (!IS_VALID_PAE_ROOT(mmu->pae_root[i]))
> -					continue;
> -
> -				mmu_free_root_page(kvm, &mmu->pae_root[i],
> -						   &invalid_list);
> -				mmu->pae_root[i] = INVALID_PAE_ROOT;
> -			}
> -		}
> +		if (using_special_root_page(mmu))
> +			mmu_free_special_root_page(kvm, mmu);
> +		else
> +			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
>  		mmu->root.hpa = INVALID_PAGE;
>  		mmu->root.pgd = 0;
>  	}
> @@ -3491,7 +3460,6 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  	u8 shadow_root_level = mmu->root_role.level;
>  	hpa_t root;
> -	unsigned i;
>  	int r;
>  
>  	write_lock(&vcpu->kvm->mmu_lock);
> @@ -3502,24 +3470,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  	if (is_tdp_mmu_enabled(vcpu->kvm)) {
>  		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
>  		mmu->root.hpa = root;
> -	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> +	} else if (shadow_root_level >= PT32E_ROOT_LEVEL) {
>  		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
>  		mmu->root.hpa = root;
> -	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
> -		if (WARN_ON_ONCE(!mmu->pae_root)) {
> -			r = -EIO;
> -			goto out_unlock;
> -		}
> -
> -		for (i = 0; i < 4; ++i) {
> -			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
> -
> -			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
> -					      i << 30, PT32_ROOT_LEVEL, true);
> -			mmu->pae_root[i] = root | PT_PRESENT_MASK |
> -					   shadow_me_mask;
> -		}
> -		mmu->root.hpa = __pa(mmu->pae_root);
>  	} else {
>  		WARN_ONCE(1, "Bad TDP root level = %d\n", shadow_root_level);
>  		r = -EIO;
> @@ -3597,10 +3550,8 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
>  static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> -	u64 pdptrs[4], pm_mask;
>  	gfn_t root_gfn, root_pgd;
>  	hpa_t root;
> -	unsigned i;
>  	int r;
>  
>  	root_pgd = mmu->get_guest_pgd(vcpu);
> @@ -3609,21 +3560,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	if (mmu_check_root(vcpu, root_gfn))
>  		return 1;
>  
> -	/*
> -	 * On SVM, reading PDPTRs might access guest memory, which might fault
> -	 * and thus might sleep.  Grab the PDPTRs before acquiring mmu_lock.
> -	 */
> -	if (mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
> -		for (i = 0; i < 4; ++i) {
> -			pdptrs[i] = mmu->get_pdptr(vcpu, i);
> -			if (!(pdptrs[i] & PT_PRESENT_MASK))
> -				continue;
> -
> -			if (mmu_check_root(vcpu, pdptrs[i] >> PAGE_SHIFT))
> -				return 1;
> -		}
> -	}
> -
>  	r = mmu_first_shadow_root_alloc(vcpu->kvm);
>  	if (r)
>  		return r;
> @@ -3633,70 +3569,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	if (r < 0)
>  		goto out_unlock;
>  
> -	/*
> -	 * Do we shadow a long mode page table? If so we need to
> -	 * write-protect the guests page table root.
> -	 */
> -	if (mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
> -		root = mmu_alloc_root(vcpu, root_gfn, 0,
> -				      mmu->root_role.level, false);
> -		mmu->root.hpa = root;
> -		goto set_root_pgd;
> -	}
> -
> -	if (WARN_ON_ONCE(!mmu->pae_root)) {
> -		r = -EIO;
> -		goto out_unlock;
> -	}
> -
> -	/*
> -	 * We shadow a 32 bit page table. This may be a legacy 2-level
> -	 * or a PAE 3-level page table. In either case we need to be aware that
> -	 * the shadow page table may be a PAE or a long mode page table.
> -	 */
> -	pm_mask = PT_PRESENT_MASK | shadow_me_value;
> -	if (mmu->root_role.level >= PT64_ROOT_4LEVEL) {
> -		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
> -
> -		if (WARN_ON_ONCE(!mmu->pml4_root)) {
> -			r = -EIO;
> -			goto out_unlock;
> -		}
> -		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
> -
> -		if (mmu->root_role.level == PT64_ROOT_5LEVEL) {
> -			if (WARN_ON_ONCE(!mmu->pml5_root)) {
> -				r = -EIO;
> -				goto out_unlock;
> -			}
> -			mmu->pml5_root[0] = __pa(mmu->pml4_root) | pm_mask;
> -		}
> -	}
> -
> -	for (i = 0; i < 4; ++i) {
> -		WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
> -
> -		if (mmu->cpu_role.base.level == PT32E_ROOT_LEVEL) {
> -			if (!(pdptrs[i] & PT_PRESENT_MASK)) {
> -				mmu->pae_root[i] = INVALID_PAE_ROOT;
> -				continue;
> -			}
> -			root_gfn = pdptrs[i] >> PAGE_SHIFT;
> -		}
> -
> -		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
> -				      PT32_ROOT_LEVEL, false);
> -		mmu->pae_root[i] = root | pm_mask;
> -	}
> -
> -	if (mmu->root_role.level == PT64_ROOT_5LEVEL)
> -		mmu->root.hpa = __pa(mmu->pml5_root);
> -	else if (mmu->root_role.level == PT64_ROOT_4LEVEL)
> -		mmu->root.hpa = __pa(mmu->pml4_root);
> -	else
> -		mmu->root.hpa = __pa(mmu->pae_root);
> -
> -set_root_pgd:
> +	root = mmu_alloc_root(vcpu, root_gfn, 0,
> +			      mmu->root_role.level, false);
> +	mmu->root.hpa = root;
>  	mmu->root.pgd = root_pgd;
>  out_unlock:
>  	write_unlock(&vcpu->kvm->mmu_lock);
> @@ -3813,8 +3688,7 @@ static bool is_unsync_root(hpa_t root)
>  
>  void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  {
> -	int i;
> -	struct kvm_mmu_page *sp;
> +	hpa_t root = vcpu->arch.mmu->root.hpa;
>  
>  	if (vcpu->arch.mmu->root_role.direct)
>  		return;
> @@ -3824,31 +3698,11 @@ void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
>  
>  	vcpu_clear_mmio_info(vcpu, MMIO_GVA_ANY);
>  
> -	if (vcpu->arch.mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL) {
> -		hpa_t root = vcpu->arch.mmu->root.hpa;
> -		sp = to_shadow_page(root);
> -
> -		if (!is_unsync_root(root))
> -			return;
> -
> -		write_lock(&vcpu->kvm->mmu_lock);
> -		mmu_sync_children(vcpu, sp, true);
> -		write_unlock(&vcpu->kvm->mmu_lock);
> +	if (!is_unsync_root(root))
>  		return;
> -	}
>  
>  	write_lock(&vcpu->kvm->mmu_lock);
> -
> -	for (i = 0; i < 4; ++i) {
> -		hpa_t root = vcpu->arch.mmu->pae_root[i];
> -
> -		if (IS_VALID_PAE_ROOT(root)) {
> -			root &= PT64_BASE_ADDR_MASK;
> -			sp = to_shadow_page(root);
> -			mmu_sync_children(vcpu, sp, true);
> -		}
> -	}
> -
> +	mmu_sync_children(vcpu, to_shadow_page(root), true);
>  	write_unlock(&vcpu->kvm->mmu_lock);
>  }
>  
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index b025decf610d..19ef31a078fa 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -316,6 +316,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	u16 errcode = 0;
>  	gpa_t real_gpa;
>  	gfn_t gfn;
> +	int i;
>  
>  	trace_kvm_mmu_pagetable_walk(addr, access);
>  retry_walk:
> @@ -323,6 +324,16 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
>  	pte           = mmu->get_guest_pgd(vcpu);
>  	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
>  
> +	/*
> +	 * FNAME(fetch) might pass these values to allocate special shadow
> +	 * page.  Although the gfn is not used at the end, it is better not
> +	 * to pass an uninitialized value to kvm_mmu_get_page().
> +	 */

This comment does not explain why FNAME(fetch) might pass these values
to allocate special shadow pages. How about adjust it to something like
this:

  /*
   * Initialize the guest walker with default values.  These values will
   * be used in cases where KVM shadows a guest page table structure
   * with more levels than what the guest. For example, KVM shadows
   * 2-level non-PAE guests with 3-level PAE paging.
   *
   * Note, the gfn is technically ignored for these special shadow
   * pages, but it's more consistent to always pass 0 to
   * kvm_mmu_get_page().
   */

> +	for (i = 2; i < PT_MAX_FULL_LEVELS; i++) {

s/2/PT32_ROOT_LEVEL/

> +		walker->table_gfn[i] = 0;
> +		walker->pt_access[i] = ACC_ALL;
> +	}
> +
>  #if PTTYPE == 64
>  	walk_nx_mask = 1ULL << PT64_NX_SHIFT;
>  	if (walker->level == PT32E_ROOT_LEVEL) {
> @@ -675,7 +686,8 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  		 * Verify that the gpte in the page we've just write
>  		 * protected is still there.
>  		 */
> -		if (FNAME(gpte_changed)(vcpu, gw, it.level - 1))
> +		if (it.level - 1 < top_level &&
> +		    FNAME(gpte_changed)(vcpu, gw, it.level - 1))
>  			goto out_gpte_changed;
>  
>  		if (sp)
> -- 
> 2.19.1.6.gb485710b
> 
