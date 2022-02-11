Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C615E4B1A96
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 01:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346467AbiBKAlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 19:41:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244490AbiBKAlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 19:41:21 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876755F8B
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 16:41:21 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 9so10421784pfx.12
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 16:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dW+bRfCv8RJwHJ8OkZVK+dVTOgUffqGHTBWxZ0mIKfA=;
        b=Y/srY85IIymOg7h03a2gdsr7vuLsRre54wpmFU2Zd9ax6ou22dxG0v5zd6gdlaozPS
         TGS4akyiVjqB+VGRKhXtCB0jCCzMZGgopvyptN9cAZELAcLQ2N40Nu0ZDwVEcfUQqxBy
         jH7m7eiqGVy5dVphrvb6pOQffTYq16Po7QWh/gBVBBytfnbTLT0cJzR+2NCFyrp7WILt
         UcFqnVu+btR1PAQjJk0kB95KaMBFSXHKWOSGGf+hwi49D+Y3yIda/qZdzy/bNF2WsRBC
         +OOLDk3iUlshJXL+bOayLo8dhR6TChGOpiyKxGEvPJ2Dk1AB5K5W+heUz4jhaqLUJ6p6
         INtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dW+bRfCv8RJwHJ8OkZVK+dVTOgUffqGHTBWxZ0mIKfA=;
        b=2292gIvmqOfIGe/tqO56nC/v7QBBSyql3NuHBaEiRv0U9DmZ861V6RvzSF4EpUECYG
         WPJEf/dZiWVIzWlkpZ4GRwhYSgrw7tnUq3I9jwY7gGjtSLaK4+QLQv4vayZfimZH+K0s
         zzIfw8BUIAAqddnv7XodyLPx9b32dlv0/iS+k4wN22ii+XgGcIibH9luJm6W/40iXcPw
         hSCpk0JsEMjZR+TwNm53eOVkBQAeSdmS4f0p8H4PlwEEOxcZw65x3HQVI1hRbqCXh0DY
         dxb2NASO7zKBNLWTp9IXGEWhgQfqDJxqj/nwTbR7De48FfDwm1aDjq2jCHEawSmr8I/t
         uNgQ==
X-Gm-Message-State: AOAM530Fd9uGZiqlxfVMMTwfwlbHwliPoJRyJvb7cQi6a/QVlMavK94L
        tFD/muCmK1QcZW6i2CkC3w9EOXkkAid0OQ==
X-Google-Smtp-Source: ABdhPJxocK0iyVGWerZCsXza87hlJCkAt9IFo3/E2VHEqqO5xoMoYVQCfEUCth/MVoiTV8CI4XLFCA==
X-Received: by 2002:a63:fc65:: with SMTP id r37mr8250613pgk.123.1644540080813;
        Thu, 10 Feb 2022 16:41:20 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l21sm24881532pfu.120.2022.02.10.16.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 16:41:20 -0800 (PST)
Date:   Fri, 11 Feb 2022 00:41:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
Subject: Re: [PATCH 08/12] KVM: MMU: do not consult levels when freeing roots
Message-ID: <YgWwrG+EQgTwyt8v@google.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-9-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209170020.1775368-9-pbonzini@redhat.com>
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

On Wed, Feb 09, 2022, Paolo Bonzini wrote:
> Right now, PGD caching requires a complicated dance of first computing
> the MMU role and passing it to __kvm_mmu_new_pgd, and then separately calling

Nit, adding () after function names helps readers easily recognize when you're
taking about a specific function, e.g. as opposed to a concept or whatever.

> kvm_init_mmu.
> 
> Part of this is due to kvm_mmu_free_roots using mmu->root_level and
> mmu->shadow_root_level to distinguish whether the page table uses a single
> root or 4 PAE roots.  Because kvm_init_mmu can overwrite mmu->root_level,
> kvm_mmu_free_roots must be called before kvm_init_mmu.
> 
> However, even after kvm_init_mmu there is a way to detect whether the page table
> has a single root or four, because the pae_root does not have an associated
> struct kvm_mmu_page.

Suggest a reword on the final paragraph, because there's a discrepancy with the
code (which handles 0, 1, or 4 "roots", versus just "single or four").

  However, even after kvm_init_mmu() there is a way to detect whether the
  page table may hold PAE roots, as root.hpa isn't backed by a shadow when
  it points at PAE roots.

> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 3c3f597ea00d..95d0fa0bb876 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3219,12 +3219,15 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  	struct kvm *kvm = vcpu->kvm;
>  	int i;
>  	LIST_HEAD(invalid_list);
> -	bool free_active_root = roots_to_free & KVM_MMU_ROOT_CURRENT;
> +	bool free_active_root;
>  
>  	BUILD_BUG_ON(KVM_MMU_NUM_PREV_ROOTS >= BITS_PER_LONG);
>  
>  	/* Before acquiring the MMU lock, see if we need to do any real work. */
> -	if (!(free_active_root && VALID_PAGE(mmu->root.hpa))) {
> +	free_active_root = (roots_to_free & KVM_MMU_ROOT_CURRENT)
> +		&& VALID_PAGE(mmu->root.hpa);

	free_active_root = (roots_to_free & KVM_MMU_ROOT_CURRENT) &&
			   VALID_PAGE(mmu->root.hpa);

Isn't this a separate bug fix?  E.g. call kvm_mmu_unload() without a valid current
root, but with valid previous roots?  In which case we'd try to free garbage, no?
			   
> +
> +	if (!free_active_root) {
>  		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
>  			if ((roots_to_free & KVM_MMU_ROOT_PREVIOUS(i)) &&
>  			    VALID_PAGE(mmu->prev_roots[i].hpa))
> @@ -3242,8 +3245,7 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>  					   &invalid_list);
>  
>  	if (free_active_root) {
> -		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> -		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
> +		if (to_shadow_page(mmu->root.hpa)) {
>  			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
>  		} else if (mmu->pae_root) {
>  			for (i = 0; i < 4; ++i) {
> -- 
> 2.31.1
> 
> 
