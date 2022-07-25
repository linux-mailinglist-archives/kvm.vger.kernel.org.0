Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32C258080B
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 01:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbiGYXQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 19:16:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiGYXQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 19:16:10 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2158B25EBB
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:16:09 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id r8so3403025plh.8
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zXrD0XfSPKahmDrSf74MEl6lfENsuuP1HaDWaHeJatM=;
        b=OfVw64PzTiDyT7wzu2M1CFwX5oOEo8g1EKJ6VDOanqVFkzZpIseXlWg/ShT5Z6YQMH
         6GU1++eXfmdXqrDIaZdPZOb/Am1VBRQGy9XHRJi0znsxa7njbdLGQf609f3icyynd8Gn
         1PnpjrFTS6W6roJcx/xzgTX5h0q34docZ6poLHn8BIOlhq5R0KL81B8kqlRtmOmSxxnb
         onq0SmBQC7zGWkfa1+3jNrnkMzaWeD1GUVGjs/dGhKis3DpQGVXRdl6q7y89kJ+h3zvY
         lgxTknIVKx7ZBJg4mgH5SkUcelT7s+nzr6H811RrruasVf+2QzlHRi5lN9evFfwTibRI
         oyuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zXrD0XfSPKahmDrSf74MEl6lfENsuuP1HaDWaHeJatM=;
        b=jJM0iFpWA5ICnR6bCm+IKyqeivcQF9MIZ4wMQtSGqM13L5z1QQF9wOvPYm6I9lC8mY
         /UgUqOcHPm6zn7wxYpPxVR+otQ+gxUjat9xzrcnfDwQNSiH2VgOdiBIzz5l/G2MGeOiC
         fy/8geAPrn9bVnE47SpBrOTXGITqPL0a16W5r+FYhun+XN8YwxWh5Q503DpPoOesje/z
         6oEjnFQEuQyYd9Y/uMkgXIgkCCgpLQM5j0TgbxPabJcJPPWj8oMbp8U0Uh/ahXtZqewg
         IN3ShFOjNThzsDo0HZIFLBJEFakkdZnOqQQiYK53DGGDMCmTzca/rBNPPy79smxAicyy
         quJg==
X-Gm-Message-State: AJIora9HGl0okXxSlFGninEOg2cGacuQSmoyghkboHicdE6DgVl31UIN
        DCCsVGXdwBb8L7B38ehlDjPh4JIESJX5nQ==
X-Google-Smtp-Source: AGRyM1vpPC31w3NHdSKt/5fFHKpKZP5Lx+cThZjdx57UUjbRfvpAYvgjgcVD9KFoVD10mAp8rMLvBA==
X-Received: by 2002:a17:90a:678a:b0:1f2:1caa:6416 with SMTP id o10-20020a17090a678a00b001f21caa6416mr16537162pjj.115.1658790968391;
        Mon, 25 Jul 2022 16:16:08 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id y28-20020aa7943c000000b0052b94e757ecsm10104781pfo.213.2022.07.25.16.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 16:16:07 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:16:02 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 3/6] KVM: x86/mmu: Set disallowed_nx_huge_page in TDP
 MMU before setting SPTE
Message-ID: <Yt8kMsz02wsjFRS6@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723012325.1715714-4-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jul 23, 2022 at 01:23:22AM +0000, Sean Christopherson wrote:
> Set nx_huge_page_disallowed in TDP MMU shadow pages before making the SP
> visible to other readers, i.e. before setting its SPTE.  This will allow
> KVM to query the flag when determining if a shadow page can be replaced
> by a NX huge page without violating the rules of the mitigation.

It took me a minute to figure out why the same change isn't needed in
the shadow MMU (it always holds the write-lock so it's impossible for
another CPU to see an SP without a correct nx_huge_page_disallowed.
If you send a v2 can you add a short blurb to that effect here?

Otherwise,

Reviewed-by: David Matlack <dmatlack@google.com>

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c          | 12 +++++-------
>  arch/x86/kvm/mmu/mmu_internal.h |  5 ++---
>  arch/x86/kvm/mmu/tdp_mmu.c      | 30 +++++++++++++++++-------------
>  3 files changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 493cdf1c29ff..e9252e7cd5a2 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -802,8 +802,7 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
>  }
>  
> -static void untrack_possible_nx_huge_page(struct kvm *kvm,
> -					  struct kvm_mmu_page *sp)
> +void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	if (list_empty(&sp->possible_nx_huge_page_link))
>  		return;
> @@ -812,15 +811,14 @@ static void untrack_possible_nx_huge_page(struct kvm *kvm,
>  	list_del_init(&sp->possible_nx_huge_page_link);
>  }
>  
> -void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> +static void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	sp->nx_huge_page_disallowed = false;
>  
>  	untrack_possible_nx_huge_page(kvm, sp);
>  }
>  
> -static void track_possible_nx_huge_page(struct kvm *kvm,
> -					struct kvm_mmu_page *sp)
> +void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp)
>  {
>  	if (!list_empty(&sp->possible_nx_huge_page_link))
>  		return;
> @@ -830,8 +828,8 @@ static void track_possible_nx_huge_page(struct kvm *kvm,
>  		      &kvm->arch.possible_nx_huge_pages);
>  }
>  
> -void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> -			  bool nx_huge_page_possible)
> +static void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> +				 bool nx_huge_page_possible)
>  {
>  	sp->nx_huge_page_disallowed = true;
>  
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 83644a0167ab..2a887d08b722 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -336,8 +336,7 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
>  
>  void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
>  
> -void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> -			  bool nx_huge_page_possible);
> -void unaccount_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> +void track_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
> +void untrack_possible_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp);
>  
>  #endif /* __KVM_X86_MMU_INTERNAL_H */
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index a30983947fee..626c40ec2af9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -392,8 +392,10 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp,
>  		lockdep_assert_held_write(&kvm->mmu_lock);
>  
>  	list_del(&sp->link);
> -	if (sp->nx_huge_page_disallowed)
> -		unaccount_nx_huge_page(kvm, sp);
> +	if (sp->nx_huge_page_disallowed) {
> +		sp->nx_huge_page_disallowed = false;
> +		untrack_possible_nx_huge_page(kvm, sp);
> +	}
>  
>  	if (shared)
>  		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> @@ -1111,16 +1113,13 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>   * @kvm: kvm instance
>   * @iter: a tdp_iter instance currently on the SPTE that should be set
>   * @sp: The new TDP page table to install.
> - * @account_nx: True if this page table is being installed to split a
> - *              non-executable huge page.
>   * @shared: This operation is running under the MMU lock in read mode.
>   *
>   * Returns: 0 if the new page table was installed. Non-0 if the page table
>   *          could not be installed (e.g. the atomic compare-exchange failed).
>   */
>  static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
> -			   struct kvm_mmu_page *sp, bool account_nx,
> -			   bool shared)
> +			   struct kvm_mmu_page *sp, bool shared)
>  {
>  	u64 spte = make_nonleaf_spte(sp->spt, !kvm_ad_enabled());
>  	int ret = 0;
> @@ -1135,8 +1134,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  
>  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>  	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
> -	if (account_nx)
> -		account_nx_huge_page(kvm, sp, true);
>  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  
>  	return 0;
> @@ -1149,6 +1146,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> +	struct kvm *kvm = vcpu->kvm;
>  	struct tdp_iter iter;
>  	struct kvm_mmu_page *sp;
>  	int ret;
> @@ -1185,9 +1183,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		}
>  
>  		if (!is_shadow_present_pte(iter.old_spte)) {
> -			bool account_nx = fault->huge_page_disallowed &&
> -					  fault->req_level >= iter.level;
> -
>  			/*
>  			 * If SPTE has been frozen by another thread, just
>  			 * give up and retry, avoiding unnecessary page table
> @@ -1199,10 +1194,19 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			sp = tdp_mmu_alloc_sp(vcpu);
>  			tdp_mmu_init_child_sp(sp, &iter);
>  
> -			if (tdp_mmu_link_sp(vcpu->kvm, &iter, sp, account_nx, true)) {
> +			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
> +
> +			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
>  				tdp_mmu_free_sp(sp);
>  				break;
>  			}
> +
> +			if (fault->huge_page_disallowed &&
> +			    fault->req_level >= iter.level) {
> +				spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> +				track_possible_nx_huge_page(kvm, sp);
> +				spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> +			}
>  		}
>  	}
>  
> @@ -1490,7 +1494,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  	 * correctness standpoint since the translation will be the same either
>  	 * way.
>  	 */
> -	ret = tdp_mmu_link_sp(kvm, iter, sp, false, shared);
> +	ret = tdp_mmu_link_sp(kvm, iter, sp, shared);
>  	if (ret)
>  		goto out;
>  
> -- 
> 2.37.1.359.gd136c6c3e2-goog
> 
