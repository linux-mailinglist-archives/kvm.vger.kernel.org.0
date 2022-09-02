Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECB25AB549
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 17:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbiIBPc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 11:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236720AbiIBPcb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 11:32:31 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ECB32069
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 08:15:15 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mj6so2341894pjb.1
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 08:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Homh/XQpZ+In2jR8/vqW/AC2iNbM1vot2oHBjKvCuQQ=;
        b=EPFT3NDuhbIVJlt2/EAVLMfMNIs5hvQhEynJiMYPQ3cKDrSbf+mhQ5iuGBOgB0X0p+
         GzSGq9MIItTvk6sw8KvHiv8sDrYAmL7XYhRWUEJB9o1vruTzW8l8FUn7k0/rWbupcCb3
         qMTYbRjZDSdQjDe8u6LxAB1n1YFa4UHSWDOZgnwsJMkGhkIuI2N4Us+nLGErcoQZTmLZ
         BGbyWYDFVFisMW0SWsE4nTMIqgFPkkl2HNTT5gMcXxQkuNmq2Yiwjs3rTDCRVAkEgxTJ
         Vm2TSIYOOvrV9LzgjFfLq2nZK8uyRVP6rxmyjtwVnarcpyvTZmaGEl5OLaXKK53sw9qI
         MNmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Homh/XQpZ+In2jR8/vqW/AC2iNbM1vot2oHBjKvCuQQ=;
        b=MUgqJcxdmYuWiBYnT+pmksQlKKjGa6L1SXj7e40tHorXvzEQrEz7ZDdMt9h3HlHJm/
         51cR1AUgMP5Pv0JGzUDRbX386weIeyVwj2sRd9uJY7uOc8d5yyNa44qHiIv3O5pThQes
         zXsHfufTbSCJRkcxiQgqH4SPOVCrbJRU9u3hlufldnvEmRN5voBViH2RFoU3riu4DSxT
         gpyfSyraez/hwv8rwNpOxyev0XXrk33wdkstCannkEx/7/P6Qlp73E27q1ldSswP+XmJ
         +tEfDtWUXEJcmWnxRhIPQSROkMSufz7OwMW8A94bcWDPRVa0ErQIeIlBMfgVARNxkjx/
         q5pg==
X-Gm-Message-State: ACgBeo3Zz6J3PYndyVKZ9CUTNHlPKWHfY8ieeetoMQxpYvmnQWq4/vb5
        kgThaaN29f6qKGBavYv7i7Bbbg==
X-Google-Smtp-Source: AA6agR7n6lH4RupaFwBUWPMM6+aqGT9aqbinyE8VWB9OVk+lsyrUNl9X+KXwAssoytEghfBFLsP+dw==
X-Received: by 2002:a17:90a:62cc:b0:1fa:c17d:de02 with SMTP id k12-20020a17090a62cc00b001fac17dde02mr5480681pjs.26.1662131713622;
        Fri, 02 Sep 2022 08:15:13 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j14-20020a170902da8e00b0016ee328fd61sm1754765plx.198.2022.09.02.08.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 08:15:13 -0700 (PDT)
Date:   Fri, 2 Sep 2022 15:15:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zhao Liu <zhao1.liu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [PATCH] KVM: SVM: Replace kmap_atomic() with kmap_local_page()
Message-ID: <YxId/V1qZcie9eyp@google.com>
References: <20220902090811.2430228-1-zhao1.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220902090811.2430228-1-zhao1.liu@linux.intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022, Zhao Liu wrote:
> From: Zhao Liu <zhao1.liu@intel.com>
> 
> The use of kmap_atomic() is being deprecated in favor of
> kmap_local_page()[1].
> 
> In arch/x86/kvm/svm/sev.c, the function sev_clflush_pages() doesn't
> need to disable pagefaults and preemption in kmap_atomic(). It can
> simply use kmap_local_page() / kunmap_local() that can instead do the
> mapping / unmapping regardless of the context.
> 
> With kmap_local_page(), the mapping is per thread, CPU local and not
> globally visible. Therefore, sev_clflush_pages() is a function where
> the use of kmap_local_page() in place of kmap_atomic() is correctly
> suited.
> 
> Convert the calls of kmap_atomic() / kunmap_atomic() to
> kmap_local_page() / kunmap_local().
> 
> [1]: https://lore.kernel.org/all/20220813220034.806698-1-ira.weiny@intel.com
> 
> Suggested-by: Ira Weiny <ira.weiny@intel.com>
> Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
> Suggested by credits.
>         Ira: Referred to his task document and review comments.
>         Fabio: Referred to his boiler plate commit message.
> ---
>  arch/x86/kvm/svm/sev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 28064060413a..12747c7bda4e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -465,9 +465,9 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
>  		return;
>  
>  	for (i = 0; i < npages; i++) {
> -		page_virtual = kmap_atomic(pages[i]);
> +		page_virtual = kmap_local_page(pages[i]);
>  		clflush_cache_range(page_virtual, PAGE_SIZE);

SEV is 64-bit only, any reason not to go straight to page_address()?

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 28064060413a..aaf39e3c7bb5 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -457,7 +457,6 @@ static void sev_unpin_memory(struct kvm *kvm, struct page **pages,
 
 static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 {
-       uint8_t *page_virtual;
        unsigned long i;
 
        if (this_cpu_has(X86_FEATURE_SME_COHERENT) || npages == 0 ||
@@ -465,9 +464,7 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
                return;
 
        for (i = 0; i < npages; i++) {
-               page_virtual = kmap_atomic(pages[i]);
-               clflush_cache_range(page_virtual, PAGE_SIZE);
-               kunmap_atomic(page_virtual);
+               clflush_cache_range(page_address(pages[i]), PAGE_SIZE);
                cond_resched();
        }
 }


config KVM_AMD_SEV
	def_bool y
	bool "AMD Secure Encrypted Virtualization (SEV) support"
	depends on KVM_AMD && X86_64 <==================================

> -		kunmap_atomic(page_virtual);
> +		kunmap_local(page_virtual);
>  		cond_resched();
>  	}
>  }
> -- 
> 2.34.1
> 
