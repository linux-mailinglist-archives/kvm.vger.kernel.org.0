Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5354767A7FE
	for <lists+kvm@lfdr.de>; Wed, 25 Jan 2023 01:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbjAYAvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 19:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbjAYAvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 19:51:38 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E157113F2
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 16:51:36 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so436360pjq.0
        for <kvm@vger.kernel.org>; Tue, 24 Jan 2023 16:51:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AFMllcKPaOUgFGlC7PFrFPAm3GcrxbOJzGs8ZXDeXvU=;
        b=BkoOwFh/U9jEHG6Na327/oV/3WzYMncCvqX8rhcP5yQKCT2pOr0qCaI0FRHHLDT7zg
         lK7zZ23XY8cTkonvctJEfQrKQKwO8FgQs9FGFZGByZhvOMMOGlNiKTdeIlZRKx4RbVeo
         XZOf2qeMoovWM3frYC+GBhNGAMMRr8LVCEOybQxWnhXJVsIB4aPlaE4OAmyHEyJ8jPoK
         jGdIzL89myFa0PlIgaoIKiL23WLwOHzjICk93V+2vx14taGPkQ44G6Y2qEGJvjVzwhlE
         mOWdEs7mM4NpcISfBeSdIFX9PdzbHkYOgwB1a85t4mceRnmI3TCyKnnYRcuaBs5QXjqH
         9PFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFMllcKPaOUgFGlC7PFrFPAm3GcrxbOJzGs8ZXDeXvU=;
        b=2vL4O7ZLwMNZImUj3s/chlsG7GECD2Pf9L8pLDEG1BD15498K8bGlVeTCKJg4jQiPr
         tppfat5mY2GVLVtTZMCOcI3Ldl7Ohfih6qcc3aZnHYK68gjYQH5qt7fNU6CfD6/smW10
         Y2S9OJKrG1FSFcX1DRh5pXc8zhVvTnNhote+xBwgVCJ2MlZCNZ2vR1LMhcxSqwM/Q2RQ
         yBJ+alZCSTRvql5/ErqIis2g+7x1lkSZnC2tFZB6SqLtlslz9yUpIDbWfNGwpIEuOz/O
         SSsSLMgMDVqtCaPPNlsZopepdIguEhdWunxX1ZNd9MUweuBNsU3Ca0TmRkQDeTHoY3Uz
         Vafg==
X-Gm-Message-State: AO0yUKXTlKNICMf3nZGi7sN/9SwBgvejJ7f8ARikglsOeAjZiDoeMeYo
        jaUVaB0gUJUxGVEZ+/jygvRJJQ==
X-Google-Smtp-Source: AK7set/pxaQt8SOHI6NCbetKZIMirhstC36lViuRC9iTeQQsZ1pF4nTwnBNk0FnJxGremT5vsgPhww==
X-Received: by 2002:a05:6a20:c759:b0:9d:c38f:9bdd with SMTP id hj25-20020a056a20c75900b0009dc38f9bddmr453885pzb.2.1674607895862;
        Tue, 24 Jan 2023 16:51:35 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 17-20020aa79211000000b00575b6d7c458sm2215684pfo.21.2023.01.24.16.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 16:51:35 -0800 (PST)
Date:   Wed, 25 Jan 2023 00:51:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     John Allen <john.allen@amd.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, weijiang.yang@intel.com,
        rick.p.edgecombe@intel.com, x86@kernel.org, thomas.lendacky@amd.com
Subject: Re: [RFC PATCH 7/7] KVM: SVM: Add CET features to supported_xss
Message-ID: <Y9B9Ey1hK9A7NDVb@google.com>
References: <20221012203910.204793-1-john.allen@amd.com>
 <20221012203910.204793-8-john.allen@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012203910.204793-8-john.allen@amd.com>
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

On Wed, Oct 12, 2022, John Allen wrote:
> If the CPU supports CET, add CET XSAVES feature bits to the
> supported_xss mask.
> 
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
>  arch/x86/kvm/svm/svm.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b474c7e57139..b815865ad0fb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5026,6 +5026,11 @@ static __init void svm_set_cpu_caps(void)
>  	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
>  
> +	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {

No need for curly braces.

> +		kvm_caps.supported_xss |= XFEATURE_MASK_CET_USER |
> +					  XFEATURE_MASK_CET_KERNEL;
> +	}
> +
>  	/* AMD PMU PERFCTR_CORE CPUID */
>  	if (enable_pmu && boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
>  		kvm_cpu_cap_set(X86_FEATURE_PERFCTR_CORE);
> -- 
> 2.34.3
> 
