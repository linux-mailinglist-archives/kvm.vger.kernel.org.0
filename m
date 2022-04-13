Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2460B500000
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 22:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238672AbiDMUbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 16:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiDMUbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 16:31:16 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E693382D2F
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 13:28:54 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id z16so3000670pfh.3
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 13:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ink5a8RlBU+CGPK1rGJ8TTvOH36zRkPSV5NyG3k0/SA=;
        b=X20UZKdA2Ugzy5g8XTyAv6sAwwhqxvqp3J/7a6Hj6rG+tpNm9e3SihDdFimv6sF8+g
         jVZQ/6FoR34kZDakwBSl1HACzu+yS7CMLIBNVf25BjTY1wobf4QXsIfEUV5mkcp6ENlV
         YVidZTyiuDNHATSW8bCX2hi2ayPXn+4XsIKZOCfT0h749Y3U+VVbUr0NRXR6gjBkofI+
         HltvztLMKx8vanji5S99tXhD8523b6VElNVTutCT9hLHQ3bBRYsZApTF/kyaChtESGO9
         0yEm0AMqEV6jOZpE7A7zv9Gh+nlMWZSyXr/g51I3dN/y00nOXMjDRwiVo/RxmMDtzPSD
         +r4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ink5a8RlBU+CGPK1rGJ8TTvOH36zRkPSV5NyG3k0/SA=;
        b=QY6b8xT7qKGq3O9eVthnzeySv3iGXbXBXuJ3z2sYHuI/KKakNkeK/wMm0GJdu41CeP
         BKhCD2LlVVI+1yK0NPaouKXjide11XnZkG7FwmYLtxsp3f4a8hLXqjsZnyCY0oQ3RYzQ
         rBED/G4kzmcVNMS44R3HMQ2tsNUAwbqB6axmkwKC+y+NkLrd3JFDCsZq5wooLoZYtv7O
         jBj9UFYbVHKbpx4nnUzKA2xRAIYIv2XumfxL/rcwFbN5hq9QYKg5yoFJe+tWwkjq5af0
         9g310zo8R19BX8MoOycDPotpuzTIXciWF8DIdIOXhpVCYygSA3gNKo+yug0iJ1tBjS+0
         vGBQ==
X-Gm-Message-State: AOAM532s7XkE0+SHriMwKN/OfO+eLkuod8aMjceKMTnTdxuCHkC1xm+Z
        /4c4yQHRjEuRq3XxrCuzLG7sYQ==
X-Google-Smtp-Source: ABdhPJzIxBAdt3A/5YRRFgKy70/DuO3rC0NDJx0XTyAW1+zAqTwOZcKMDo+thWfuRo0Gop4FgWDgdA==
X-Received: by 2002:a63:981a:0:b0:398:49ba:a65e with SMTP id q26-20020a63981a000000b0039849baa65emr36305332pgd.231.1649881734266;
        Wed, 13 Apr 2022 13:28:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a138-20020a621a90000000b00505da61496fsm8350035pfa.206.2022.04.13.13.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 13:28:53 -0700 (PDT)
Date:   Wed, 13 Apr 2022 20:28:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Manali Shukla <manali.shukla@amd.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/4] x86: nSVM: Move common
 functionality of the main() to helper run_svm_tests
Message-ID: <Ylcyghve/NZ2jlwx@google.com>
References: <20220324053046.200556-1-manali.shukla@amd.com>
 <20220324053046.200556-2-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324053046.200556-2-manali.shukla@amd.com>
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

On Thu, Mar 24, 2022, Manali Shukla wrote:
> nSVM tests are "incompatible" with usermode due to __setup_vm()
> call in main function.
> 
> If __setup_vm() is replaced with setup_vm() in main function, KUT
> will build the test with PT_USER_MASK set on all PTEs.
> 
> nNPT tests will be moved to their own file so that the tests
> don't need to fiddle with page tables midway through.
> 
> The quick and dirty approach would be to turn the current main()
> into a small helper, minus its call to __setup_vm() and call the
> helper function run_svm_tests() from main() function.
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Manali Shukla <manali.shukla@amd.com>
> ---
>  x86/svm.c | 14 +++++++++-----
>  x86/svm.h |  1 +
>  2 files changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/x86/svm.c b/x86/svm.c
> index 3f94b2a..e93e780 100644
> --- a/x86/svm.c
> +++ b/x86/svm.c
> @@ -406,17 +406,13 @@ test_wanted(const char *name, char *filters[], int filter_count)
>          }
>  }
>  
> -int main(int ac, char **av)
> +int run_svm_tests(int ac, char **av)
>  {
> -	/* Omit PT_USER_MASK to allow tested host.CR4.SMEP=1. */
> -	pteval_t opt_mask = 0;
>  	int i = 0;
>  
>  	ac--;
>  	av++;
>  
> -	__setup_vm(&opt_mask);
> -
>  	if (!this_cpu_has(X86_FEATURE_SVM)) {
>  		printf("SVM not availble\n");
>  		return report_summary();
> @@ -453,3 +449,11 @@ int main(int ac, char **av)
>  
>  	return report_summary();
>  }
> +
> +int main(int ac, char **av)
> +{
> +    pteval_t opt_mask = 0;

Please use tabs, not spaces.  Looks like this file is an unholy mess of tabs and
spaces.  And since we're riping this file apart, let's take the opportunity to
clean it up.  How about after moving code to svm_npt.c, go through and replace
all spaces with tabs and fixup indentation as appropriate in this file?

> +
> +    __setup_vm(&opt_mask);
> +    return run_svm_tests(ac, av);
> +}
> diff --git a/x86/svm.h b/x86/svm.h
> index f74b13a..9ab3aa5 100644
> --- a/x86/svm.h
> +++ b/x86/svm.h
> @@ -398,6 +398,7 @@ struct regs {
>  
>  typedef void (*test_guest_func)(struct svm_test *);
>  
> +int run_svm_tests(int ac, char **av);
>  u64 *npt_get_pte(u64 address);
>  u64 *npt_get_pde(u64 address);
>  u64 *npt_get_pdpe(void);
> -- 
> 2.30.2
> 
