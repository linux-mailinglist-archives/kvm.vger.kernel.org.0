Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4299526F77
	for <lists+kvm@lfdr.de>; Sat, 14 May 2022 09:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiENBiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 21:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiENBiI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 21:38:08 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E10E39A412
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 16:43:12 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a15-20020a17090ad80f00b001dc2e23ad84so12112803pjv.4
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 16:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=essDsTkBV8vjGqQ6Frct4rt8ISkB+0L+64Ci6wS9ufg=;
        b=YQhNNLQi6sqEDmxiuUNid6aedpmGgrbaoKfJRQlPBgTyDPBb6d27SBlDPTbNtlZm+3
         P5SbM0ywRUIaScz3fruCVg5GKaBlFgLlY+iquz0SabSbvnW4fD/o70OvV7CILEdsicPq
         bk3OufDc4XxsdVU0syLN9ZmX86fGLxAq7BsnB7tROWbsbHPVwGLI9X4MwrFCO5ue3NeO
         axar0Q1xigjUw5OoaIbmzQvZaD3kAd3dpU5CXpX8dodSk/jX4g1RBQn3siS0E4CE3I5e
         IzminO93ZFW0jjiq2PdhAmTWYxY2ixrg2oKees12hSD04yINMzHqFMXyMw5Fm0XvucSe
         0XIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=essDsTkBV8vjGqQ6Frct4rt8ISkB+0L+64Ci6wS9ufg=;
        b=XxtgZOS86QOEuHj9DNqOR/hPvfQpOGVokHQji1N+lBtOwF1QSfleLb1I085T933Xhk
         ld76HE3twDBOZKVZn0gdMhsmkmqIJxCrhfBmbZ6Cekd/pWXNoxJ9oDDS/RbyYzcO6KY0
         /MTmAV8d56tySPOgrqu6Pks+qVNy6l12yDGY2eUbNNmfMBz1p3oMFOP/3tx/d2lhWhIS
         C+g1X3enVwfxBoWEyv+glrk90k0mtqrTMV72fLSUKIUDaiMceE1EgodgXQcYYZo4ugfV
         dcjuh/CM1pLkg48hTZOt8htNNSyhEcX6aeGCRv5gRDrAzg8qTJJd7Vh5+mX1Xx9bt+Rs
         Zfog==
X-Gm-Message-State: AOAM531F5IQRsGOTaHOAkYAo+QNwhnHsKEMq6LagKL0KcoSxq2hIZ8Dc
        GlEbNMz/nbnRfG8u09mgXjntzQ==
X-Google-Smtp-Source: ABdhPJy0ryoieUUDdepG0hylKM8E0TjinL0m3Vq4dq5N5IQAMVizkYlZbsGn8Ckj/FUGFaGKkPILdg==
X-Received: by 2002:a17:90a:eb93:b0:1d9:a003:3f93 with SMTP id o19-20020a17090aeb9300b001d9a0033f93mr7220522pjy.50.1652485390989;
        Fri, 13 May 2022 16:43:10 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id 132-20020a62168a000000b0050dc7628175sm2416626pfw.79.2022.05.13.16.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 16:43:10 -0700 (PDT)
Date:   Fri, 13 May 2022 23:43:06 +0000
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
Subject: Re: [PATCH V2 2/7] KVM: X86/MMU: Add special shadow pages
Message-ID: <Yn7tCpt9s8qf3Rn/@google.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
 <20220503150735.32723-3-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503150735.32723-3-jiangshanlai@gmail.com>
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

On Tue, May 03, 2022 at 11:07:30PM +0800, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> Special pages are pages to hold PDPTEs for 32bit guest or higher
> level pages linked to special page when shadowing NPT.
> 
> Current code use mmu->pae_root, mmu->pml4_root, and mmu->pml5_root to
> setup special root.  The initialization code is complex and the roots
> are not associated with struct kvm_mmu_page which causes the code more
> complex.
> 
> Add kvm_mmu_alloc_special_page() and mmu_free_special_root_page() to
> allocate and free special shadow pages and prepare for using special
> shadow pages to replace current logic and share the most logic with
> normal shadow pages.
> 
> The code is not activated since using_special_root_page() is false in
> the place where it is inserted.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 91 +++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 90 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 7f20796af351..126f0cd07f98 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1719,6 +1719,58 @@ static bool using_special_root_page(struct kvm_mmu *mmu)
>  		return mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL;
>  }
>  
> +/*
> + * Special pages are pages to hold PAE PDPTEs for 32bit guest or higher level
> + * pages linked to special page when shadowing NPT.
> + *
> + * Special pages are specially allocated.  If sp->spt needs to be 32bit, it

I'm not sure what you mean by "If sp->spt needs to be 32bit". Do you mean
"If sp shadows a 32-bit PAE page table"?

> + * will use the preallocated mmu->pae_root.
> + *
> + * Special pages are only visible to local VCPU except through rmap from their
> + * children, so they are not in the kvm->arch.active_mmu_pages nor in the hash.
> + *
> + * And they are either accounted nor write-protected since they don't has gfn
> + * associated.

Instead of "has gfn associated", how about "shadow a guest page table"?

> + *
> + * Because of above, special pages can not be freed nor zapped like normal
> + * shadow pages.  They are freed directly when the special root is freed, see
> + * mmu_free_special_root_page().
> + *
> + * Special root page can not be put on mmu->prev_roots because the comparison
> + * must use PDPTEs instead of CR3 and mmu->pae_root can not be shared for multi
> + * root pages.
> + *
> + * Except above limitations, all the other abilities are the same as other
> + * shadow page, like link, parent rmap, sync, unsync etc.
> + *
> + * Special pages can be obsoleted but might be possibly reused later.  When
> + * the obsoleting process is done, all the obsoleted shadow pages are unlinked
> + * from the special pages by the help of the parent rmap of the children and
> + * the special pages become theoretically valid again.  If there is no other
> + * event to cause a VCPU to free the root and the VCPU is being preempted by
> + * the host during two obsoleting processes, the VCPU can reuse its special
> + * pages when it is back.

Sorry I am having a lot of trouble parsing this paragraph.

> + */

This comment (and more broadly, this series) mixes "special page",
"special root", "special root page", and "special shadow page". Can you
be more consistent with the terminology?

> +static struct kvm_mmu_page *kvm_mmu_alloc_special_page(struct kvm_vcpu *vcpu,
> +		union kvm_mmu_page_role role)
> +{
> +	struct kvm_mmu_page *sp;
> +
> +	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> +	sp->gfn = 0;
> +	sp->role = role;
> +	if (role.level == PT32E_ROOT_LEVEL &&
> +	    vcpu->arch.mmu->root_role.level == PT32E_ROOT_LEVEL)
> +		sp->spt = vcpu->arch.mmu->pae_root;

Why use pae_root here instead of allocating from the cache?

> +	else
> +		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +	/* sp->gfns is not used for special shadow page */
> +	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> +	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> +
> +	return sp;
> +}
> +
>  static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
>  {
>  	struct kvm_mmu_page *sp;
> @@ -2076,6 +2128,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  	if (level <= vcpu->arch.mmu->cpu_role.base.level)
>  		role.passthrough = 0;
>  
> +	if (unlikely(level >= PT32E_ROOT_LEVEL && using_special_root_page(vcpu->arch.mmu)))
> +		return kvm_mmu_alloc_special_page(vcpu, role);
> +
>  	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>  	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
>  		if (sp->gfn != gfn) {
> @@ -3290,6 +3345,37 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  	*root_hpa = INVALID_PAGE;
>  }
>  
> +static void mmu_free_special_root_page(struct kvm *kvm, struct kvm_mmu *mmu)
> +{
> +	u64 spte = mmu->root.hpa;
> +	struct kvm_mmu_page *sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> +	int i;
> +
> +	/* Free level 5 or 4 roots for shadow NPT for 32 bit L1 */
> +	while (sp->role.level > PT32E_ROOT_LEVEL)
> +	{
> +		spte = sp->spt[0];
> +		mmu_page_zap_pte(kvm, sp, sp->spt + 0, NULL);

Instead of using mmu_page_zap_pte(..., NULL) what about creating a new
helper that just does drop_parent_pte(), since that's all you really
want?

> +		free_page((unsigned long)sp->spt);
> +		kmem_cache_free(mmu_page_header_cache, sp);
> +		if (!is_shadow_present_pte(spte))
> +			return;
> +		sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> +	}
> +
> +	if (WARN_ON_ONCE(sp->role.level != PT32E_ROOT_LEVEL))
> +		return;
> +
> +	/* Free PAE roots */

nit: This loop does not do any freeing, it just disconnets the PAE root
table from the 4 PAE page directories. So how about:

/* Disconnect PAE root from the 4 PAE page directories */

> +	for (i = 0; i < 4; i++)
> +		mmu_page_zap_pte(kvm, sp, sp->spt + i, NULL);
> +
> +	if (sp->spt != mmu->pae_root)
> +		free_page((unsigned long)sp->spt);
> +
> +	kmem_cache_free(mmu_page_header_cache, sp);
> +}
> +
>  /* roots_to_free must be some combination of the KVM_MMU_ROOT_* flags */
>  void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
>  			ulong roots_to_free)
> @@ -3323,7 +3409,10 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
>  
>  	if (free_active_root) {
>  		if (to_shadow_page(mmu->root.hpa)) {
> -			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
> +			if (using_special_root_page(mmu))
> +				mmu_free_special_root_page(kvm, mmu);
> +			else
> +				mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
>  		} else if (mmu->pae_root) {
>  			for (i = 0; i < 4; ++i) {
>  				if (!IS_VALID_PAE_ROOT(mmu->pae_root[i]))
> -- 
> 2.19.1.6.gb485710b
> 
