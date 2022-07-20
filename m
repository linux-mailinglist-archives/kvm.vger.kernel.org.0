Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D1357AB04
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 02:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237309AbiGTAfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 20:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236742AbiGTAfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 20:35:12 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC6C26F8
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:35:09 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id gq7so112170pjb.1
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 17:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OByqdheZnR9XQdLvmQqTklAaII3Kkp8sAPXAy0KvGyw=;
        b=N0qwoaz3pAucR8L3oPpL1AnFQ7bU/JIkPTtaTg8zh9VOovnPnIepduYBWYbIe5oW1r
         b5GF9rMlcRxaHlUvhB+xrYNtP2Jm2HYOR2jLZOOgNTrlh4/OAylRJv2JpAc9oiOqu8PW
         0qIBxwnHd73bA5IZdDHkxfJD5mZXTb9w0oIVbc9LUZvSr0qZQxjRnBYAhK4RQlFUfffm
         WnWMFyiZ4OuTWTJMkQgpTBiME8xjndhlIAyswrQjz7pOSjIkYzlMGOw4MuWZ/3rp33ah
         BB7INzkCRXftmTyP25FF4ZARf1GQ0Am4m203d3KlQDdu54i5gaj+clBm/bK3FNl5+TqS
         jjRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OByqdheZnR9XQdLvmQqTklAaII3Kkp8sAPXAy0KvGyw=;
        b=vtxcx1oL+wfxHWjmhfmiNfAvPukhWLHP4EYxVk7bzYbyh/XLo7yTlPJ1ODZfW564Sd
         y+UWiie99hI7Em7jaszD+KGfmXvGQxcDQs7BJK0rv7EXShk2U8HCf9KCjHtNz4tTM29j
         9E6djLWCtBJ3kM4JFyUusAD3CTSZ2kd+YgpY9ulzYiHptNAaGp72Zs5OM2K+mOha0gt4
         hMYVyRkPEi0w5+JepZa8m4Ip/0SPMC+yjjH9NHZCoLqDSLlG6g+CZbGvicdV1/va4OnO
         Vgu1m3gfNFMe3CHcQ7N04yepHdJ3naxZdnqTgj7goJsNZkBCC0gSVjRovJpcbfBJt/VR
         ayxA==
X-Gm-Message-State: AJIora8ZX90TGBMNzKGVCVEwpjLBS8sYqodpD+a3tA1KUM2p6R9Zg2U+
        cUDaGI/ul28EKlMAMt97j77E3w==
X-Google-Smtp-Source: AGRyM1vGHGgcXhV1k9gZ8mkvlyO+g2QmTLHKQZ5STP7nuuwVEvraANqVfmlnBgUPy29R5jXgvhFH+Q==
X-Received: by 2002:a17:903:44e:b0:16b:ee3f:86de with SMTP id iw14-20020a170903044e00b0016bee3f86demr36288078plb.44.1658277308758;
        Tue, 19 Jul 2022 17:35:08 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z128-20020a626586000000b0051c6613b5basm12076976pfb.134.2022.07.19.17.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 17:35:08 -0700 (PDT)
Date:   Wed, 20 Jul 2022 00:35:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: Re: [PATCH V3 04/12] KVM: X86/MMU: Add local shadow pages
Message-ID: <YtdNuLiGvzp7ZvoQ@google.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
 <20220521131700.3661-5-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521131700.3661-5-jiangshanlai@gmail.com>
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

On Sat, May 21, 2022, Lai Jiangshan wrote:
> +static struct kvm_mmu_page *
> +kvm_mmu_alloc_local_shadow_page(struct kvm_vcpu *vcpu, union kvm_mmu_page_role role)

Don't split the function name to a new line, even if it means running (well) over
the 80 char soft limit.

static struct kvm_mmu_page *kvm_mmu_alloc_per_vcpu_shadow_page(struct kvm_vcpu *vcpu,
							       union kvm_mmu_page_role role)

> +{
> +	struct kvm_mmu_page *sp;
> +
> +	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> +	sp->gfn = 0;

Why explicitly zero gfn but not gfns?  Either rely on __GFP_ZERO or don't, mixing
behavior is confusing.  If there's an assumption that "gfn" be zero, e.g. due to
masking, then that would be a good WARN candidate.

> +	sp->role = role;
> +	/*
> +	 * Use the preallocated mmu->pae_root when the shadow page's
> +	 * level is PT32E_ROOT_LEVEL which may need to be put in the 32 bits
> +	 * CR3 (even in x86_64) or decrypted.  The preallocated one is prepared
> +	 * for the requirements.
> +	 */
> +	if (role.level == PT32E_ROOT_LEVEL &&
> +	    !WARN_ON_ONCE(!vcpu->arch.mmu->pae_root))
> +		sp->spt = vcpu->arch.mmu->pae_root;
> +	else
> +		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +	/* sp->gfns is not used for local shadow page */

This comment isn't helpful as it doesn't provide any information as to _why_ gfns
isn't used.  For simple enforcement, a KVM_BUG_ON() is much more effective as it
documents the underlying assumption, e.g.

	KVM_BUG_ON(sp_has_gptes(sp), vcpu->kvm);

but I'm fairly confident that won't actually work, because sp_has_gptes() will
return true for pages that are backed by pae_root, i.e. are not passthrough.

In other words, this all subtly relies on the PDPTEs not being write-protected
and not being reachable through things like mmu_page_hash.  I don't know that we
need to add a dedicated flag for these pages, but we need _something_ to document
what's going on.

Hmm, but if we do add kvm_mmu_page_role.per_vcpu, it would allow for code
consolidation, and I think it will yield more intuitive code.  And sp_has_gptes()
is easy to fix.

> +	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> +	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;

I would prefer that kvm_mmu_alloc_per_vcpu_shadow_page() and kvm_mmu_alloc_page()
share common bits, and then add comments for the differences.  For example, this
path fails to invoke kvm_mod_used_mmu_pages(), which arguably it should do when
not using pae_root, i.e. when it actually "allocates" a page.

I've always found it annoying/odd that kvm_mmu_alloc_page() adds the page to
active_mmu_pages, but the caller adds the page to mmu_page_hash.  This is a good
excuse to fix that.

If role.per_vcpu is a thing, and is tracked in vcpu->arch.mmu->root_role, then
we can do:

	if (level < PT32E_ROOT_LEVEL)
		role.per_vcpu = 0;

	/* Per-vCPU roots are (obviously) not tracked in the per-VM lists. */
	if (unlikely(role.per_vcpu))
		return kvm_mmu_alloc_page(vcpu, role, true, gfn);

	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
		...
	}

	++vcpu->kvm->stat.mmu_cache_miss;

	sp = kvm_mmu_alloc_page(vcpu, role, gfn);


and kvm_mmu_alloc_page() becomes something like (completely untested, and I'm not
at all confident about the gfn logic).

static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu,
					       union kvm_mmu_page_role role,
					       gfn_t gfn)
{
	struct kvm_mmu_page *sp;

	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);

	/*
	 * Use the preallocated mmu->pae_root when the shadow page's level is
	 * PT32E_ROOT_LEVEL.  When using PAE paging, the backing page may need
	 * to have a 32-bit physical address (to go into a 32-bit CR3), and/or
	 * may need to be decrypted (!TDP + SME).  The preallocated pae_root
	 * is prepared for said requirements.
	 */
	if (role.per_vcpu && role.level == PT32E_ROOT_LEVEL) {
		sp->spt = vcpu->arch.mmu->pae_root;
		memset(sp->spt, 0, sizeof(u64) * 4);
	} else {
		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
	}

	if (sp_has_gptes(sp))
		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);

	WARN_ON_ONCE(role.per_vcpu && gfn);
	sp->gfn = gfn;
	sp->role = role;

	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);

	/*
	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
	 * depends on valid pages being added to the head of the list.  See
	 * comments in kvm_zap_obsolete_pages().
	 */
	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
	return sp;
}


> +
> +	return sp;
> +}
> +
>  static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
>  {
>  	struct kvm_mmu_page *sp;
> @@ -2121,6 +2191,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  	if (level <= vcpu->arch.mmu->cpu_role.base.level)
>  		role.passthrough = 0;
>  
> +	if (unlikely(level >= PT32E_ROOT_LEVEL && using_local_root_page(vcpu->arch.mmu)))
> +		return kvm_mmu_alloc_local_shadow_page(vcpu, role);
> +
>  	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>  	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
>  		if (sp->gfn != gfn) {
> @@ -3351,6 +3424,37 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
>  	*root_hpa = INVALID_PAGE;
>  }
>  
> +static void mmu_free_local_root_page(struct kvm *kvm, struct kvm_mmu *mmu)
> +{
> +	u64 spte = mmu->root.hpa;
> +	struct kvm_mmu_page *sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> +	int i;
> +
> +	/* Free level 5 or 4 roots for shadow NPT for 32 bit L1 */
> +	while (sp->role.level > PT32E_ROOT_LEVEL)

Maybe a for-loop?

	/* Free level 5 or 4 roots for shadow NPT for 32 bit L1 */
	for (sp = to_shadow_page(mmu->root.hpa & PT64_BASE_ADDR_MASK);
	     sp->role.level > PT32E_ROOT_LEVEL;
	     sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK)) {

> +	{
> +		spte = sp->spt[0];
> +		mmu_page_zap_pte(kvm, sp, sp->spt + 0, NULL);
> +		free_page((unsigned long)sp->spt);
> +		kmem_cache_free(mmu_page_header_cache, sp);

Probably worth a helper for free_page()+kmem_cache_free(), especially if the
!pae_root case is accounted.  And then we can combine with tdp_mmu_free_sp() if
we ever decide to fully account TDP MMU pages (to play nice with reclaim).

E.g.

static void __mmu_free_per_vcpu_root_page(struct kvm *kvm,
					  struct kvm_mmu_page *sp)
{
	if (sp->spt != mmu->pae_root) {
		free_page((unsigned long)sp->spt);
		kvm_mod_used_mmu_pages(kvm, -1);
	}

	kmem_cache_free(mmu_page_header_cache, sp);
}

static void mmu_free_per_vcpu_root_page(struct kvm *kvm, struct kvm_mmu *mmu)
{
	struct kvm_mmu_page *sp;
	u64 spte;
	int i;

	/* Free level 5 or 4 roots for shadow NPT for 32 bit L1 */
	for (sp = to_shadow_page(mmu->root.hpa & PT64_BASE_ADDR_MASK);
	     sp->role.level > PT32E_ROOT_LEVEL;
	     sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK)) {
		spte = sp->spt[0];
		mmu_page_zap_pte(kvm, sp, sp->spt + 0, NULL);

		__mmu_free_per_vcpu_root_page(kvm, sp);

		if (!is_shadow_present_pte(spte))
			return;
	}

	if (WARN_ON_ONCE(sp->role.level != PT32E_ROOT_LEVEL))
		return;

	/* Disconnect PAE root from the 4 PAE page directories */
	for (i = 0; i < 4; i++)
		mmu_page_zap_pte(kvm, sp, sp->spt + i, NULL);

	__mmu_free_per_vcpu_root_page(kvm, sp);
}


> +		if (!is_shadow_present_pte(spte))
> +			return;
> +		sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
> +	}
