Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B8F54D597
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346656AbiFOX6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348838AbiFOX6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:58:15 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884192C673
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:58:07 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 187so6434pfu.9
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3XKRkTtCOTUQmqld7Doz/GZjWuHP88X6HDWaYjQQI98=;
        b=JOYFWojK5XXRYg49KzoJXDe3OF4mUgGZGe9TqN5P95B6Atf/ytiD4UQVvnJx6JEc3u
         qh8Dq95nCCjKsUnxZ47ZqpWfnb6L9XiE6Om5t2Cni6sw+RYV0VjW7JtoSMOBi2t1sFCT
         Bxw6FZ2h6Phu2yCVKmy23HlfKyHMPgBj6SBx4k9F8BbrK8/yWgoO3LMYUx4cqpJJTugo
         cc37fdR9hAW4G6BisTxxuOjJ29+x2ma1lZfpUmiLWaRrWt22e+PavncIiW+TCen2L4ST
         TcAJb5NGbpSnBBnnFdhZNYFTjZzmPzMMZvbJ1Yw0jJXdETL72l5xDOmGp0uzBOQvc6uR
         gleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3XKRkTtCOTUQmqld7Doz/GZjWuHP88X6HDWaYjQQI98=;
        b=o4WETrZD10uSDhor9vONEXG9+EZKfgpDnRNiZ04muEVTPbyFZHdvDbPhATieNdpyMJ
         NwNJnxc6JvQsZSKLHRO167TDZNrk99akxHra+pzC0mkBkzilgx37IunBDleqxyG2D2QV
         ThJGgZ+FHDi/LTF39u6KWZvztKBD5RLduXAMGxLfMMvMUwD0uSO26RN0P3D+QxLVLhS0
         iPjugSizBh93q0At5GA7QLtCg5T9cU+0exI3347a5mtN+yRYeeIOjUskqe81AQ/oU0HQ
         o/5FeW1/5QO7yrGwPL7zxt45MAyoImJHIdMXe4rQwF52f4dsJykmX79hfJrQxAk000FU
         XwkQ==
X-Gm-Message-State: AJIora9dzxNLye2EjksBUhYqtu6a2dHqQH57Jcu0nDdeguQOb1cUbKAG
        WvloyQQECjcALLv4FKriyDNdkzQTZwVmIg==
X-Google-Smtp-Source: AGRyM1u1k3p32dEJa5ULejZ87d6LTOhWvNRScZ4GBgUhHz7J8aR95lr/wr7VsONKoHa8Gi5mMuA9VA==
X-Received: by 2002:aa7:999c:0:b0:51c:1a04:5b79 with SMTP id k28-20020aa7999c000000b0051c1a045b79mr1845700pfh.77.1655337486872;
        Wed, 15 Jun 2022 16:58:06 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id s5-20020a170903200500b001689e31ff9dsm225186pla.9.2022.06.15.16.58.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 16:58:06 -0700 (PDT)
Date:   Wed, 15 Jun 2022 23:58:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v4 4/8] x86: Improve set_mmu_range() to
 implement npt
Message-ID: <YqpyC1HmsFBSXedh@google.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
 <20220428070851.21985-5-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220428070851.21985-5-manali.shukla@amd.com>
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

On Thu, Apr 28, 2022, Manali Shukla wrote:
> If U/S bit is "0" for all page table entries, all these pages are
> considered as supervisor pages. By default, pte_opt_mask is set to "0"
> for all npt test cases, which sets U/S bit in all PTEs to "0".
> 
> Any nested page table accesses performed by the MMU are treated as user
> acesses. So while implementing a nested page table dynamically, PT_USER_MASK
> needs to be enabled for all npt entries.

Bits in PTEs aren't really "enabled".

> set_mmu_range() function is improved based on above analysis.

Same comments.  Don't provide analysis and then say "do that", just state what
the patch does.  Background details are great, but first and foremost the reader
needs to know what the patch actually does.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  lib/x86/vm.c | 37 +++++++++++++++++++++++++++----------
>  lib/x86/vm.h |  3 +++
>  2 files changed, 30 insertions(+), 10 deletions(-)
> 
> diff --git a/lib/x86/vm.c b/lib/x86/vm.c
> index 25a4f5f..b555d5b 100644
> --- a/lib/x86/vm.c
> +++ b/lib/x86/vm.c
> @@ -4,7 +4,7 @@
>  #include "alloc_page.h"
>  #include "smp.h"
>  
> -static pteval_t pte_opt_mask;
> +static pteval_t pte_opt_mask, prev_pte_opt_mask;
>  
>  pteval_t *install_pte(pgd_t *cr3,
>  		      int pte_level,
> @@ -140,16 +140,33 @@ bool any_present_pages(pgd_t *cr3, void *virt, size_t len)
>  	return false;
>  }
>  
> -static void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len)
> +void set_pte_opt_mask()
> +{
> +        prev_pte_opt_mask = pte_opt_mask;
> +        pte_opt_mask = PT_USER_MASK;
> +}
> +
> +void reset_pte_opt_mask()

These should have "void" parameters.  I'm surprised gcc doesn't complain.  But
that's a moot point, because these don't need to exist, just to the save/mod/restore
on the stack in setup_mmu_range().

> +{
> +        pte_opt_mask = prev_pte_opt_mask;
> +}
> +
> +void setup_mmu_range(pgd_t *cr3, phys_addr_t start, size_t len, bool nested_mmu)
>  {
>  	u64 max = (u64)len + (u64)start;
>  	u64 phys = start;
>  
> -	while (phys + LARGE_PAGE_SIZE <= max) {
> -		install_large_page(cr3, phys, (void *)(ulong)phys);
> -		phys += LARGE_PAGE_SIZE;
> -	}
> -	install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
> +        if (nested_mmu == false) {
> +                while (phys + LARGE_PAGE_SIZE <= max) {
> +                        install_large_page(cr3, phys, (void *)(ulong)phys);
> +		        phys += LARGE_PAGE_SIZE;
> +	        }
> +	        install_pages(cr3, phys, max - phys, (void *)(ulong)phys);
> +        } else {
> +                set_pte_opt_mask();
> +                install_pages(cr3, phys, len, (void *)(ulong)phys);
> +                reset_pte_opt_mask();
> +        }

Why can't a nested_mmu use large pages?
