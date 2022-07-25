Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817A958081C
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 01:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237616AbiGYXYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 19:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbiGYXX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 19:23:59 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC18422298
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:23:58 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c13so5073821pla.6
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QOC9FutRXycysZcNDNb8yY3ROXU2xsC5EASisQKUw28=;
        b=HX26puFihhU88Ii05Usra+lh8D0UTysdNaR016h0JmdhviKtRUcH2ZCbfwgZQC7APZ
         Oaw2Noa92Rxqw+hu5YDDjSd1cKFw7ajbEThpmAiNxkFcN2jHTDNXCSxdFfjGVQjc4yKn
         /jxb66jnsbAFiNlGoirxA0xEuxN3FKRSpvcFWG2XxXJFj+BoFgGaA7G97js7GpqoBf8Q
         twoCn5V/917VYazyO1nsxlqvkuct5ktRz9TPcu122uAo7dLFWh+kt6tj9DWxyh7UTNAf
         bXmXdDDQ34NxBh9G/mY5dx04+3EklNmmVN4dw99oIYy/27CJ4POG/hcRJy3ASOX5eItO
         /3jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QOC9FutRXycysZcNDNb8yY3ROXU2xsC5EASisQKUw28=;
        b=cRcMkPW6gLG3yYu92QC5/0k24M5okbXY1vAYMLWlDOdGtrYTvJjUlt8iDi7rPaVAiB
         EWcx/3hfmwRtEOgo2FJJJz18FGhiAWrW/80PTwNGR2bEHgFyHSIVkqat9UII76GXGG+U
         sE2LbtIP1u3DI2NhgrrMcVofQqgHjgu5YFd6G9ZnZAlns11P2lzAu3bcW4hq69yKhbiP
         Cq4BUKYvhuUKhP0fd1skugBZDlQ/GvmT+P195+yDGI5aEC434lgF56klemaXCqnLFPsT
         mkNXcHdaqbVLeX+rNhVujsARVMI7v7Nq+0l59/hzFzwXkp/mR1BoWyLSAxPr8A4DObXu
         lVFA==
X-Gm-Message-State: AJIora+BL7ZXOR2z34pCuebfBl7hqxDYKD/4pL2ENNS8yg1g8qyjDWmh
        ga7SaiRzLYzlhLWXZzRHU7RyGw==
X-Google-Smtp-Source: AGRyM1uHkf62M4Kz1YUCdJwqsyN+MmToRiVKxE6B+c3yrCiNxKPQTOUdJ91XRfkI8dYo+lu3WjWxGA==
X-Received: by 2002:a17:90a:4291:b0:1f2:2a19:fc95 with SMTP id p17-20020a17090a429100b001f22a19fc95mr27990421pjg.29.1658791437974;
        Mon, 25 Jul 2022 16:23:57 -0700 (PDT)
Received: from google.com (223.103.125.34.bc.googleusercontent.com. [34.125.103.223])
        by smtp.gmail.com with ESMTPSA id y20-20020a170902e19400b0016c35b21901sm9669785pla.195.2022.07.25.16.23.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 16:23:57 -0700 (PDT)
Date:   Mon, 25 Jul 2022 16:23:52 -0700
From:   David Matlack <dmatlack@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 5/6] KVM: x86/mmu: Add helper to convert SPTE value to
 its shadow page
Message-ID: <Yt8mCI7MFhZbT+5R@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220723012325.1715714-6-seanjc@google.com>
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

On Sat, Jul 23, 2022 at 01:23:24AM +0000, Sean Christopherson wrote:
> Add a helper to convert a SPTE to its shadow page to deduplicate a
> variety of flows and hopefully avoid future bugs, e.g. if KVM attempts to
> get the shadow page for a SPTE without dropping high bits.
> 
> Opportunistically add a comment in mmu_free_root_page() documenting why
> it treats the root HPA as a SPTE.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
[...]
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -207,6 +207,23 @@ static inline int spte_index(u64 *sptep)
>   */
>  extern u64 __read_mostly shadow_nonpresent_or_rsvd_lower_gfn_mask;
>  
> +static inline struct kvm_mmu_page *to_shadow_page(hpa_t shadow_page)
> +{
> +	struct page *page = pfn_to_page((shadow_page) >> PAGE_SHIFT);
> +
> +	return (struct kvm_mmu_page *)page_private(page);
> +}
> +
> +static inline struct kvm_mmu_page *spte_to_sp(u64 spte)
> +{
> +	return to_shadow_page(spte & SPTE_BASE_ADDR_MASK);
> +}

spte_to_sp() and sptep_to_sp() are a bit hard to differentiate visually.

Maybe spte_to_child_sp() or to_child_sp()?

> +
> +static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
> +{
> +	return to_shadow_page(__pa(sptep));
> +}
> +
>  static inline bool is_mmio_spte(u64 spte)
>  {
>  	return (spte & shadow_mmio_mask) == shadow_mmio_value &&
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
> index c163f7cc23ca..d3714200b932 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.h
> +++ b/arch/x86/kvm/mmu/tdp_mmu.h
> @@ -5,6 +5,8 @@
>  
>  #include <linux/kvm_host.h>
>  
> +#include "spte.h"
> +
>  hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
>  
>  __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm_mmu_page *root)
> -- 
> 2.37.1.359.gd136c6c3e2-goog
> 
