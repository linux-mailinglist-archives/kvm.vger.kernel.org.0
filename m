Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB285807F2
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 01:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236905AbiGYXFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 19:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbiGYXFi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 19:05:38 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8304013F23
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:05:37 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c13so5043411pla.6
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dsyzfIxg32VvoJpFM6+63IrnxKTtUOzvq3rmFFDbmP8=;
        b=PxgkMBzLRHAfQ7B60nayCWYa9mhZ1axfflsaNINC6NCdhjoBb8XnXYHiVXBXdsFLTl
         T/oRCXBb2cqpoOGmJsxMGJYKnMxTcI1ASsnjywOYadrG96hUKouYta/7/8/I7wNHLDKZ
         mPmuh9Y5RLkV0wyjAXz6MQV2dhX5Ikx3kpmj4pamKDCNnVBBzDQ7LOzvUnojB7UEscmF
         Okeeb+IIQ16/I+P3QusE1odKz7kOl/hWStztAcUVPNWS71ANOCyYSnRGQUYYiNMRbbAI
         lPAfg1ohZ+YsPqBrrQG1P3okSuIvzbvE7N6hzTwjmwLtt7HjqACs2Uf77/SmlQdgsIyb
         OF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dsyzfIxg32VvoJpFM6+63IrnxKTtUOzvq3rmFFDbmP8=;
        b=pgIrz83qxvgaG7TjVW3AXRqPfmVTi7pKUvxYb56ohlj2Dhj7jcXQUWZZbSz0byl+Uh
         9OlorQ+iGL4fWYcu9Jrl3NGca6uUvYkRDgQiVYp+qqv2WZvFscTZ9yTDyfx7Pj6hdKLd
         YWbwpm+0KST5Igk8cd8pLu07vMb0TUhw3jKbuEr5WKaTpXJvmEjnq8VS5T+OxUCZlDbc
         qEiaWA2TVyHvGLSX8QTOnptR5zGDHl628gHzeS/3aWe9WlK4Zc6IPTqH9YmaR+tkRq9F
         YaIn55Lhd25VzsI1s+lQTVokyOp/VHps3xmEqljSlve4z2tiuSEoESaY2t8NGa1caAnc
         puYg==
X-Gm-Message-State: AJIora9Xbz/l06KbZQIOImyZjCRIop7ziyrKdQwzlgCdb6r+gOVAaEVd
        fDS3KL2L0+szNABPOIzwpRyGpw==
X-Google-Smtp-Source: AGRyM1uucwSxFARNDP3qz4oGiQRp6IdkQX1/SOtHcdgRETPdnw1LgDTDMzHXG48RHx0yk7MxtfnXpQ==
X-Received: by 2002:a17:90a:b00b:b0:1f1:6023:dacd with SMTP id x11-20020a17090ab00b00b001f16023dacdmr33521701pjq.184.1658790336675;
        Mon, 25 Jul 2022 16:05:36 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id e9-20020a170902784900b001678dcb4c5asm8425579pln.100.2022.07.25.16.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 16:05:35 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:05:31 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 2/6] KVM: x86/mmu: Properly account NX huge page
 workaround for nonpaging MMUs
Message-ID: <Yt8hu/+I8YzVckvU@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-3-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723012325.1715714-3-seanjc@google.com>
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

On Sat, Jul 23, 2022 at 01:23:21AM +0000, Sean Christopherson wrote:
> Account and track NX huge pages for nonpaging MMUs so that a future
> enhancement to precisely check if shadow page cannot be replaced by a NX
> huge page doesn't get false positives.  Without correct tracking, KVM can
> get stuck in a loop if an instruction is fetching and writing data on the
> same huge page, e.g. KVM installs a small executable page on the fetch
> fault, replaces it with an NX huge page on the write fault, and faults
> again on the fetch.
> 
> Alternatively, and perhaps ideally, KVM would simply not enforce the
> workaround for nonpaging MMUs.  The guest has no page tables to abuse
> and KVM is guaranteed to switch to a different MMU on CR0.PG being
> toggled so there's no security or performance concerns.  However, getting
> make_spte() to play nice now and in the future is unnecessarily complex.
> 
> In the current code base, make_spte() can enforce the mitigation if TDP
> is enabled or the MMU is indirect, but make_spte() may not always have a
> vCPU/MMU to work with, e.g. if KVM were to support in-line huge page
> promotion when disabling dirty logging.
> 
> Without a vCPU/MMU, KVM could either pass in the correct information
> and/or derive it from the shadow page, but the former is ugly and the
> latter subtly non-trivial due to the possitibility of direct shadow pages
> in indirect MMUs.  Given that using shadow paging with an unpaged guest
> is far from top priority _and_ has been subjected to the workaround since
> its inception, keep it simple and just fix the accounting glitch.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

It's odd that KVM enforced NX Huge Pages but just skipped the accounting.
In retrospect, that was bound to cause some issue.

Aside from the comment suggestion below,

Reviewed-by: David Matlack <dmatlack@google.com>

> ---
>  arch/x86/kvm/mmu/mmu.c          |  2 +-
>  arch/x86/kvm/mmu/mmu_internal.h |  8 ++++++++
>  arch/x86/kvm/mmu/spte.c         | 11 +++++++++++
>  3 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1112e3a4cf3e..493cdf1c29ff 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3135,7 +3135,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			continue;
>  
>  		link_shadow_page(vcpu, it.sptep, sp);
> -		if (fault->is_tdp && fault->huge_page_disallowed)
> +		if (fault->huge_page_disallowed)
>  			account_nx_huge_page(vcpu->kvm, sp,
>  					     fault->req_level >= it.level);
>  	}
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index ff4ca54b9dda..83644a0167ab 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -201,6 +201,14 @@ struct kvm_page_fault {
>  
>  	/* Derived from mmu and global state.  */
>  	const bool is_tdp;
> +
> +	/*
> +	 * Note, enforcing the NX huge page mitigation for nonpaging MMUs
> +	 * (shadow paging, CR0.PG=0 in the guest) is completely unnecessary.
> +	 * The guest doesn't have any page tables to abuse and is guaranteed
> +	 * to switch to a different MMU when CR0.PG is toggled on (may not
> +	 * always be guaranteed when KVM is using TDP).  See also make_spte().
> +	 */
>  	const bool nx_huge_page_workaround_enabled;
>  
>  	/*
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 7314d27d57a4..9f3e5af088a5 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -147,6 +147,17 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  	if (!prefetch)
>  		spte |= spte_shadow_accessed_mask(spte);
>  
> +	/*
> +	 * For simplicity, enforce the NX huge page mitigation even if not
> +	 * strictly necessary.  KVM could ignore if the mitigation if paging is
> +	 * disabled in the guest, but KVM would then have to ensure a new MMU
> +	 * is loaded (or all shadow pages zapped) when CR0.PG is toggled on,
> +	 * and that's a net negative for performance when TDP is enabled.  KVM
> +	 * could ignore the mitigation if TDP is disabled and CR0.PG=0, as KVM
> +	 * will always switch to a new MMU if paging is enabled in the guest,
> +	 * but that adds complexity just to optimize a mode that is anything
> +	 * but performance critical.
> +	 */

I had some trouble parsing the last sentence. How about this for slightly
better flow:

	/*
	 * For simplicity, enforce the NX huge page mitigation even if not
	 * strictly necessary.  KVM could ignore if the mitigation if paging is
	 * disabled in the guest, but KVM would then have to ensure a new MMU
	 * is loaded (or all shadow pages zapped) when CR0.PG is toggled on,
         * and that's a net negative for performance when TDP is enabled.  When
         * TDP is disabled, KVM will always switch to a new MMU when CR0.PG is
         * toggled, but that would tie make_spte() further to vCPU/MMU state
         * and add complexity just to optimize a mode that is anything but
         * performance critical.
	 */

>  	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
>  	    is_nx_huge_page_enabled(vcpu->kvm)) {
>  		pte_access &= ~ACC_EXEC_MASK;
> -- 
> 2.37.1.359.gd136c6c3e2-goog
> 
