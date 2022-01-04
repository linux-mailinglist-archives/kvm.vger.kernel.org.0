Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E953A484A88
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 23:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiADWOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 17:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbiADWOX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 17:14:23 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5328CC061761
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 14:14:23 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id j13so28000366plx.4
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 14:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nX/9aypnm/DPNI7I3ieDjvwxS5DVT+/2AWFKFJDXyvg=;
        b=qzmvPiw4WybP+A0bFqgfyK1T48D2PlDbz6qbCv3k8NuOiOzz4pHKnboxnadcD6x31D
         V0p1EZFAPTQwTAF15gE82imQKnz6PktJ3aazLaswiPBffWbbH788iG4D7tmyZVLhIHJa
         dTmKp2OfIJwKHXv1qwLVKJF5GvFxQYaimx0F/Xyyc1BOOAZw6dVfyVLhvepmEnA0N/Y4
         7BDmDhkeYh0FOYrm8XczJPSO+VLmFmshM2rwWNQIW7hgPqnuxYA0EcZdPZrIJXWrW4ho
         /dAmvm5CQHxljKU7ZlqHnOkfYLk+830yhWPJjlZOS9G1jqSVhOg7rGKnINx9cs5glZJE
         73ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nX/9aypnm/DPNI7I3ieDjvwxS5DVT+/2AWFKFJDXyvg=;
        b=FcIUCD3jWYpZyFWYM5TRz2AaltgQmxXUsIWPgNOw3msFfy3ey44rXSUe4mCBk8a8ts
         HEVeQvbN6Vbfm7mso+srSRuYR311Y2CTrzUsj9Cv619iyK7oKkYxnD/muhNsB8HlTUKQ
         PK+mI7u8E1Ixa/QwvKgxDK5muOpkwzj/VImS6JXcZ+koMQIVTrEjhanTowhibRqKOXSP
         EJpAbLP1oIC6fUK1sUVt8XEpcTDYjSNdeybQ9Qro1QuaZ55x3PNFoe+Il6rufRUtpKsm
         ApZS3/Qktk/wuyYrE4utacHIZ/aTFh5v49RekjJ7maR18gvB+y6mik+Axo0jLCUfAcq7
         vJew==
X-Gm-Message-State: AOAM53334Ua3TGXIplXytm6FKxB143GP87F+jpTPXdbhTQB2e2CrlH1s
        dR/ezpNVPVRVWYShzkBZlKgZ2Q==
X-Google-Smtp-Source: ABdhPJzSb0ZnvTHjy/esLNtLWTah2T1wcMfm2cxfeh9NR9hF4qRuP9j0jXUHwI5mwdiaqAVoCRqEkQ==
X-Received: by 2002:a17:903:1211:b0:149:9809:77be with SMTP id l17-20020a170903121100b00149980977bemr29923032plh.133.1641334462598;
        Tue, 04 Jan 2022 14:14:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a64sm35551485pge.72.2022.01.04.14.14.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 14:14:21 -0800 (PST)
Date:   Tue, 4 Jan 2022 22:14:18 +0000
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
Subject: Re: [RFC PATCH 4/6] KVM: X86: Introduce role.level_promoted
Message-ID: <YdTGuoh2vYPsRcu+@google.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
 <20211210092508.7185-5-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210092508.7185-5-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> Level pormotion occurs when mmu->shadow_root_level > mmu->root_level.

s/pormotion/promotion (in multiple places)

That said, I strongly prefer "passthrough" or maybe "nop" over "level_promoted".
Promoted in the context of page level usually refers to making a hugepage, which
is not the case here.

> 
> There are several cases that can cuase level pormotion:
> 
> shadow mmu (shadow paging for 32 bit guest):
> 	case1:	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0
> 
> shadow nested NPT (for 32bit L1 hypervisor):
> 	case2:	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0,hEFER_LMA=0
> 	case3:	gCR0_PG=1,gEFER_LMA=0,hEFER_LMA=1
> 
> shadow nested NPT (for 64bit L1 hypervisor):
> 	case4:	gEFER_LMA=1,gCR4_LA57=0,hEFER_LMA=1,hCR4_LA57=1
> 
> When level pormotion occurs (32bit guest, case1-3), special roots are
> often used.  But case4 is not using special roots.  It uses shadow page
> without fully aware of the specialty.  It might work accidentally:
> 	1) The root_page (root_sp->spt) is allocated with level = 5,
> 	   and root_sp->spt[0] is allocated with the same gfn and the
> 	   same role except role.level = 4.  Luckly that they are
> 	   different shadow pages.
> 	2) FNAME(walk_addr_generic) sets walker->table_gfn[4] and
> 	   walker->pt_access[4], which are normally unused when
> 	   mmu->shadow_root_level == mmu->root_level == 4, so that
> 	   FNAME(fetch) can use them to allocate shadow page for
> 	   root_sp->spt[0] and link them when shadow_root_level == 5.
> 
> But it has problems.
> If the guest switches from gCR4_LA57=0 to gCR4_LA57=1 (or vice verse)
> and usees the same gfn as the root for the nNPT before and after
> switching gCR4_LA57.  The host (hCR4_LA57=1) wold use the same root_sp
> for guest even guest switches gCR4_LA57.  The guest will see unexpected
> page mapped and L2 can hurts L1.  It is lucky the the problem can't
> hurt L0.
> 
> The root_sp should be like role.direct=1 sometimes: its contents are
> not backed by gptes, root_sp->gfns is meaningless.  For a normal high
> level sp, sp->gfns is often unused and kept zero, but it could be
> relevant and meaningful when sp->gfns is used because they are back
> by concret gptes.  For level-promoted root_sp described before, root_sp
> is just a portal to contribute root_sp->spt[0], and root_sp should not
> have root_sp->gfns and root_sp->spt[0] should not be dropped if gpte[0]
> of the root gfn is changed.
> 
> This patch adds role.level_promoted to address the two problems.
> role.level_promoted is set when shadow paging and
> role.level > gMMU.level.
> 
> An alternative way to fix the problem of case4 is that: also using the
> special root pml5_root for it.  But it would required to change many
> other places because it is assumption that special roots is only used
> for 32bit guests.
> 
> This patch also paves the way to use level promoted shadow page for
> case1-3, but that requires the special handling or PAE paging, so the
> extensive usage of it is not included.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ++-
>  arch/x86/kvm/mmu/mmu.c          | 15 +++++++++++++--
>  arch/x86/kvm/mmu/paging_tmpl.h  |  1 +
>  3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 88ecf53f0d2b..6465c83794fc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -334,7 +334,8 @@ union kvm_mmu_page_role {
>  		unsigned smap_andnot_wp:1;
>  		unsigned ad_disabled:1;
>  		unsigned guest_mode:1;
> -		unsigned :6;
> +		unsigned level_promoted:1;
> +		unsigned :5;

The massive comment above this union needs to be updated.

>  		/*
>  		 * This is left at the top of the word so that
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 54e7cbc15380..4769253e9024 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -767,6 +767,9 @@ static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
>  
>  static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
>  {
> +	if (sp->role.level_promoted)
> +		return sp->gfn;
> +
>  	if (!sp->role.direct)
>  		return sp->gfns[index];
>  
> @@ -776,6 +779,8 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
>  static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
>  {
>  	if (!sp->role.direct) {
> +		if (WARN_ON_ONCE(sp->role.level_promoted && gfn != sp->gfn))
> +			return;
>  		sp->gfns[index] = gfn;

This is wrong, sp->gfns is NULL when sp->role.level_promoted is true.  I believe
you want something similar to the "get" flow, e.g.

	if (sp->role.passthrough) {
		WARN_ON_ONCE(gfn != sp->gfn);
		return;
	}

	if (!sp->role.direct) {
		...
	}

Alternatively, should we mark passthrough shadow pages as direct=1?  That would
naturally handle this code, and for things like reexecute_instruction()'s usage
of kvm_mmu_unprotect_page(), I don't think passthrough shadow pages should be
considered indirect, e.g. zapping them won't help and the shadow page can't become
unsync.

>  		return;
>  	}
> @@ -1702,7 +1707,7 @@ static void kvm_mmu_free_page(struct kvm_mmu_page *sp)
>  	hlist_del(&sp->hash_link);
>  	list_del(&sp->link);
>  	free_page((unsigned long)sp->spt);
> -	if (!sp->role.direct)
> +	if (!sp->role.direct && !sp->role.level_promoted)

Hmm, at this point, it may be better to just omit the check entirely.  @sp is
zero allocated and free_page() plays nice with NULL "pointers".  I believe TDX
and maybe SNP support will need to do more work here, i.e. may add back a similar
check, but if so then checking sp->gfns directly for !NULL is preferable.

>  		free_page((unsigned long)sp->gfns);
>  	kmem_cache_free(mmu_page_header_cache, sp);
>  }
> @@ -1740,7 +1745,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  
>  	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
>  	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> -	if (!role.direct)
> +	if (!(role.direct || role.level_promoted))

I personally prefer the style of the previous check, mainly because I'm horrible
at reading !(x || y).

	if (!role.direct && !role.passthrough)

>  		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
>  	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>  
> @@ -2084,6 +2089,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>  		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
>  		role.quadrant = quadrant;
>  	}
> +	if (role.level_promoted && (level <= vcpu->arch.mmu->root_level))
> +		role.level_promoted = 0;
>  
>  	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>  	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
> @@ -4836,6 +4843,8 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
>  
>  	role.base.direct = false;
>  	role.base.level = kvm_mmu_get_tdp_level(vcpu);
> +	if (role.base.level > role_regs_to_root_level(regs))
> +		role.base.level_promoted = 1;
>  
>  	return role;
>  }
> @@ -5228,6 +5237,8 @@ static void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
>  	kvm_mmu_audit(vcpu, AUDIT_PRE_PTE_WRITE);
>  
>  	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
> +		if (sp->role.level_promoted)
> +			continue;
>  		if (detect_write_misaligned(sp, gpa, bytes) ||
>  		      detect_write_flooding(sp)) {
>  			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 5c78300fc7d9..16ac276d342a 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -1043,6 +1043,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		.level = 0xf,
>  		.access = 0x7,
>  		.quadrant = 0x3,
> +		.level_promoted = 0x1,
>  	};
>  
>  	/*
> -- 
> 2.19.1.6.gb485710b
> 
