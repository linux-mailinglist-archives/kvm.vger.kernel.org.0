Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1899E486AE8
	for <lists+kvm@lfdr.de>; Thu,  6 Jan 2022 21:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbiAFUMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jan 2022 15:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiAFUMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jan 2022 15:12:21 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31647C061245
        for <kvm@vger.kernel.org>; Thu,  6 Jan 2022 12:12:21 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p14so3267328plf.3
        for <kvm@vger.kernel.org>; Thu, 06 Jan 2022 12:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hjndkdtcJ3txIF09rbXJpkYUGVSXV8uGMtpeENuQrnY=;
        b=gYbKCt2yNjXJXa3PUXLGwpKiXzDe/CBfWMfanWqoB5IBYW2bW82gWrOJpxnMbShCLY
         Pfer5dbmXGSz0x5R4qJi49ThKIG1vQ42ILUcGXD7mJN6sakZd72ZAHdMwmOZGARTMlDh
         pho18ZuJI81Eta3KXiwSSlS5sNTMxBsYCpB5NJWxQj16OWGrav0s5CZRHXT8zsJc/BYS
         f7Pk6sLSrrwhCSyJxTYgrokEPTQFhf3vGlM2Jej1x6vOHDngyJkIMi4hz7igIgN1VvNV
         fNAIi4DgC4fonzvK23a2JOMN/+fpERkD94sUBKML0ZqVueSMLt0xelK6tYSXUuhUQ0GP
         JILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hjndkdtcJ3txIF09rbXJpkYUGVSXV8uGMtpeENuQrnY=;
        b=h7l8vX4EmNY+GcCvAoYsNHstAgs2qRnDNAS7C+uYglaincIpx+mD6BEdEIjvjLsKZV
         l+GRnm6n+Qma1BQac8iHoAALXE7v0eM9Jke0uPmqZu3EQoaKQsVobq46qxEW3YbMnpjW
         In1m6KctG4pmQtcYBeWwofiBXMfja5gMALFivRf8ccmPlUQRmphVseuq9tBN6BH7paZG
         awbI/idNSmcMXnUAru/fJTr3dtnj626apXGldaKcHd/6cn3m/tWNGH4vN4pEjvp4NNF3
         +pRPthoMllsUvRffTrQcP8a014GLKdN0tQ6/9bR8kOghauoSdWOos73P5zIL/57CYbcI
         ZwYw==
X-Gm-Message-State: AOAM5309G1EzemBdP5hbNfCzn/GMS0Uq+8H+s1JiNTkpb6NrrFihmILF
        aW8Ds0zouigsoZMGCigGaqMpSQ==
X-Google-Smtp-Source: ABdhPJxQCZyvzereDL7vBhiA5ORf9vvMfUyE778crvkefHaY2qjPpn780Ug3wvjQdN1GSgWJeLbT8A==
X-Received: by 2002:a17:90b:3810:: with SMTP id mq16mr11761814pjb.190.1641499940412;
        Thu, 06 Jan 2022 12:12:20 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d4sm3288588pfu.50.2022.01.06.12.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 12:12:19 -0800 (PST)
Date:   Thu, 6 Jan 2022 20:12:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>
Subject: Re: [PATCH v1 04/13] KVM: x86/mmu: Factor out logic to atomically
 install a new page table
Message-ID: <YddNIMWaARotqOSZ@google.com>
References: <20211213225918.672507-1-dmatlack@google.com>
 <20211213225918.672507-5-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213225918.672507-5-dmatlack@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 13, 2021, David Matlack wrote:
> Factor out the logic to atomically replace an SPTE with an SPTE that
> points to a new page table. This will be used in a follow-up commit to
> split a large page SPTE into one level lower.
> 
> Opportunistically drop the kvm_mmu_get_page tracepoint in
> kvm_tdp_mmu_map() since it is redundant with the identical tracepoint in
> alloc_tdp_mmu_page().
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 48 +++++++++++++++++++++++++++-----------
>  1 file changed, 34 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 656ebf5b20dc..dbd07c10d11a 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -950,6 +950,36 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>  	return ret;
>  }
>  
> +/*
> + * tdp_mmu_install_sp_atomic - Atomically replace the given spte with an
> + * spte pointing to the provided page table.
> + *
> + * @kvm: kvm instance
> + * @iter: a tdp_iter instance currently on the SPTE that should be set
> + * @sp: The new TDP page table to install.
> + * @account_nx: True if this page table is being installed to split a
> + *              non-executable huge page.
> + *
> + * Returns: True if the new page table was installed. False if spte being
> + *          replaced changed, causing the atomic compare-exchange to fail.

I'd prefer to return an int with 0/-EBUSY on success/fail.  Ditto for the existing
tdp_mmu_set_spte_atomic().  Actually, if you add a prep patch to make that happen,
then this can be:

	u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
	int ret;

	ret = tdp_mmu_set_spte_atomic(kvm, iter, spte);
	if (ret)
		return ret;

	tdp_mmu_link_page(kvm, sp, account_nx);
	return 0;



> + *          If this function returns false the sp will be freed before
> + *          returning.

Uh, no it's not?  The call to tdp_mmu_free_sp() is still done by kvm_tdp_mmu_map().

> + */
> +static bool tdp_mmu_install_sp_atomic(struct kvm *kvm,

Hmm, so this helper is the only user of tdp_mmu_link_page(), and _that_ helper
is rather tiny.  And this would also be a good opportunity to clean up the
"(un)link_page" verbiage, as the bare "page" doesn't communicate to the reader
that it's for linking shadow pages, e.g. not struct page.

So, what about folding in tdp_mmu_link_page(), naming this helper either
tdp_mmu_link_sp_atomic() or tdp_mmu_link_shadow_page_atomic(), and then renaming
tdp_mmu_unlink_page() accordingly?  And for bonus points, add a blurb in the
function comment like:

	* Note the lack of a non-atomic variant!  The TDP MMU always builds its
	* page tables while holding mmu_lock for read.

> +				      struct tdp_iter *iter,
> +				      struct kvm_mmu_page *sp,
> +				      bool account_nx)
> +{
> +	u64 spte = make_nonleaf_spte(sp->spt, !shadow_accessed_mask);
> +
> +	if (!tdp_mmu_set_spte_atomic(kvm, iter, spte))
> +		return false;
> +
> +	tdp_mmu_link_page(kvm, sp, account_nx);
> +
> +	return true;
> +}
> +
>  /*
>   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
>   * page tables and SPTEs to translate the faulting guest physical address.
> @@ -959,8 +989,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  	struct tdp_iter iter;
>  	struct kvm_mmu_page *sp;
> -	u64 *child_pt;
> -	u64 new_spte;
>  	int ret;
>  
>  	kvm_mmu_hugepage_adjust(vcpu, fault);
> @@ -996,6 +1024,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		}
>  
>  		if (!is_shadow_present_pte(iter.old_spte)) {
> +			bool account_nx = fault->huge_page_disallowed &&
> +					  fault->req_level >= iter.level;
> +
>  			/*
>  			 * If SPTE has been frozen by another thread, just
>  			 * give up and retry, avoiding unnecessary page table
> @@ -1005,18 +1036,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  				break;
>  
>  			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
> -			child_pt = sp->spt;
> -
> -			new_spte = make_nonleaf_spte(child_pt,
> -						     !shadow_accessed_mask);
> -
> -			if (tdp_mmu_set_spte_atomic(vcpu->kvm, &iter, new_spte)) {
> -				tdp_mmu_link_page(vcpu->kvm, sp,
> -						  fault->huge_page_disallowed &&
> -						  fault->req_level >= iter.level);
> -
> -				trace_kvm_mmu_get_page(sp, true);
> -			} else {
> +			if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx)) {
>  				tdp_mmu_free_sp(sp);
>  				break;
>  			}
> -- 
> 2.34.1.173.g76aa8bc2d0-goog
> 
