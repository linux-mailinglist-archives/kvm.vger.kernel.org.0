Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2388C6872E6
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 02:21:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjBBBVM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 20:21:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjBBBVK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 20:21:10 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8225A83E
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 17:21:08 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id j5so463364pjn.5
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 17:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S4gNTXols2zUCK+Bbf92IJ3jgKiB/hlHNVwgThgFNbY=;
        b=QLoTkpMZSuxDOrCnLlgRzlWIlCWXCX6MQGfA0dsC4W6Iqvw/enD7qJgFyOQpd69E5U
         kQvuEwUfx2vFJsc39S+GDZ9RlhWrdaxgfm+HssItPiaTwzlxkRyTf4qH9a90a/ZdtN/6
         s3cm2fXpiCYYtTOkV6tPyUd2Xc5z8h7YjgL6ixTIxZ9YVdpS6wAfCIIRHTVH9tsUNqOE
         1lWDh6o15eXzRbtilD4+Qo2lgT8VmKxtfaqLmUyeK++42l6K5oigXqQeMl6JsnPr7K/f
         AEKEdRPICR2jA0UHqvFpiSk6qzadwOh+1/Gzfpyfxv6BI1H8hdzQRoYNXVvA4GzdL+he
         OLjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4gNTXols2zUCK+Bbf92IJ3jgKiB/hlHNVwgThgFNbY=;
        b=GBZ7I+2vBYXoTDW34ceC6izOZItrnlJpq8SiTwV3OI6NISeJ67DOO84b0Xq+3BnUxq
         8/0DgwXMfGAFoAuUzLkBa1ONq1sVVN8JIfwBjgVThDNETifHln5pF6S7ACQ8i9h20Yvg
         9h3ivrVQ02CL1uP7JkiTKusSnx5rm56gUfpnGfiSI7TPQHaCtwY1tfclzgWzDVczG/8P
         fwSDKi8UeQ/ehxsmJ+BxDmUUGo465s/fjuV2gjYo7J0/ELgGzPT1qi2r3GYTg9hrH8bs
         xOTKdN+gSU2aoIeyHdmq9Bk1Tdn41K8a7CUe2A8AEK69omWk3/p0O+wfKAeKeyDHeAdL
         ishg==
X-Gm-Message-State: AO0yUKV+pR1eqdiHBxiokAV0NsBoXMMKa96d1NzTfZGjwQ9CdpMG/35C
        ur2JFMg7inxfb/pELhb2KngUAVN5Pu2/eBai1rs=
X-Google-Smtp-Source: AK7set/aBbNUWclOGQUBTunvdOQv6LWwLKUzRLjPkqixKVrkG0vf73s3NIePHMZ48fOI7r+Jkx86BQ==
X-Received: by 2002:a17:902:8347:b0:198:af4f:de09 with SMTP id z7-20020a170902834700b00198af4fde09mr148827pln.9.1675300867658;
        Wed, 01 Feb 2023 17:21:07 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w2-20020a1709027b8200b00196025a34b9sm9084724pll.159.2023.02.01.17.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 17:21:07 -0800 (PST)
Date:   Thu, 2 Feb 2023 01:21:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 1/7] kvm: x86/mmu: Use KVM_MMU_ROOT_XXX for
 kvm_mmu_invalidate_gva()
Message-ID: <Y9sP/0B8A7fx2tkf@google.com>
References: <20230105095848.6061-1-jiangshanlai@gmail.com>
 <20230105095848.6061-2-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105095848.6061-2-jiangshanlai@gmail.com>
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

On Thu, Jan 05, 2023, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> The @root_hpa for kvm_mmu_invalidate_gva() is called with @mmu->root.hpa
> or INVALID_PAGE.
> 
> Replace them with KVM_MMU_ROOT_XXX.

Please explain _why_.  I can (and did) figure it out on my own, but doing that
takes time and slows down reviews.

> No fuctionalities changed.
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 39 ++++++++++++++++-----------------
>  arch/x86/kvm/x86.c              |  2 +-
>  3 files changed, 21 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 2f5bf581d00a..dbea616bccce 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2026,7 +2026,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
>  		       void *insn, int insn_len);
>  void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
>  void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> -			    gva_t gva, hpa_t root_hpa);
> +			    gva_t gva, ulong roots_to_invalidate);
>  void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
>  void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
>  
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5407649de547..90339b71bd56 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5693,8 +5693,9 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
>  }
>  EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
>  
> +/* roots_to_invalidte must be some combination of the KVM_MMU_ROOT_* flags */

Typo, though I would just drop this comment.  If we want some form of sanity check,
it should be totally doable to add a WARN_ON_ONCE() that verifies the parameter
is a subset of all possible root flags.

>  void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
> -			    gva_t gva, hpa_t root_hpa)
> +			    gva_t gva, ulong roots_to_invalidate)

s/ulong/unsigned long

And I got confused by "roots_to_invalidate"; I thought it meant "invalidate these
entire trees" as opposed to "invalidate the gva in these trees".  Best I can come
up with is simply "roots".

>  {
>  	int i;
>  
> @@ -5710,31 +5711,29 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	if (!mmu->invlpg)
>  		return;
>  
> -	if (root_hpa == INVALID_PAGE) {
> +	if ((roots_to_invalidate & KVM_MMU_ROOT_CURRENT) && VALID_PAGE(mmu->root.hpa))
>  		mmu->invlpg(vcpu, gva, mmu->root.hpa);
>  
> -		/*
> -		 * INVLPG is required to invalidate any global mappings for the VA,
> -		 * irrespective of PCID. Since it would take us roughly similar amount
> -		 * of work to determine whether any of the prev_root mappings of the VA
> -		 * is marked global, or to just sync it blindly, so we might as well
> -		 * just always sync it.
> -		 *
> -		 * Mappings not reachable via the current cr3 or the prev_roots will be
> -		 * synced when switching to that cr3, so nothing needs to be done here
> -		 * for them.
> -		 */
> -		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
> -			if (VALID_PAGE(mmu->prev_roots[i].hpa))
> -				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
> -	} else {
> -		mmu->invlpg(vcpu, gva, root_hpa);
> -	}
> +	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)

for-loop needs curly braces.

> +		if ((roots_to_invalidate & KVM_MMU_ROOT_PREVIOUS(i)) &&
> +		    VALID_PAGE(mmu->prev_roots[i].hpa))
> +			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);

I think it has to go at the end of this series, but please add a patch somewhere
to move the VALID_PAGE() check into __kvm_mmu_invalidate_gva(), e.g. end up with

	if (roots & KVM_MMU_ROOT_CURRENT)
		__kvm_mmu_invalidate_gva(vcpu, mmu, gva, mmu->root.hpa);

	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
		if (roots & KVM_MMU_ROOT_PREVIOUS(i))
			__kvm_mmu_invalidate_gva(vcpu, mmu, gva,
						 mmu->prev_roots[i].hpa);
	}

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c936f8d28a53..4696cbb40545 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -799,7 +799,7 @@ void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
>  	if ((fault->error_code & PFERR_PRESENT_MASK) &&
>  	    !(fault->error_code & PFERR_RSVD_MASK))
>  		kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
> -				       fault_mmu->root.hpa);
> +				       KVM_MMU_ROOT_CURRENT);

This is logically correct, but there's potential (weird) functional change here.
If this is called with an invalid root, then KVM will invalidate the GVA in all
roots prior to this patch, but in no roots after this patch.

I _think_ it should be impossible get here with an invalid root.  Can you try
adding a prep patch to assert that the root is valid so that this patch can
reasonably assert that there's no functional change?


diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 508074e47bc0..fffd9b610196 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -792,6 +792,8 @@ void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
        fault_mmu = fault->nested_page_fault ? vcpu->arch.mmu :
                                               vcpu->arch.walk_mmu;
 
+       WARN_ON_ONCE(!VALID_PAGE(fault_mmu->root.hpa));
+
        /*
         * Invalidate the TLB entry for the faulting address, if it exists,
         * else the access will fault indefinitely (and to emulate hardware).

