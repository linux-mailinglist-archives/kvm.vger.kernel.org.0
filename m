Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6811678D31
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 02:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbjAXBR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 20:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbjAXBR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 20:17:56 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF3C8A7A
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 17:17:55 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id 7so10351794pga.1
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 17:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VdIkKw85QyqR8RnovAWlaOqWkJ4x/84JU+MCLeNY4/w=;
        b=XnuUpXBYmcbXYIl/WUVnKUIF0/iOyYXTFdKQ6MhIGZ+lSxA6obVt/YUk6NcVR6bE98
         2wngsfbss+Q+B/nvpCog6BkcM4EPVNC1c5M+nqGvlw9HQrFsOUhSd8NCEDGWv7pgqsW8
         cxJY4aYJ+NYeaZ/uxsxZYNDYAR0gqL0smN+BmlSQ55RamWuHnZfw0cD6H0tJMVXBxFL5
         ZDmYesfFMwWm1TWbakB2jCQy9GRGNn1/BvXjU5QBdgiPHJLNQ8nvBSg7/KXWoU6nR6MY
         rFD06x0IwB3JtsoPmH9fYEDrP3o9ahBgjbJz/zH9LKRDEiiqQXS3B4MWV/e8byXKOXKT
         H3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VdIkKw85QyqR8RnovAWlaOqWkJ4x/84JU+MCLeNY4/w=;
        b=DhJSX4L3oeeef65mONFOjp4XeCDlIe7V/HZT+StzMkh1VBgJUTAquoR0p17/QH4rP5
         bB99tIq625vEzJBj4YmVqHu6QdYrPqxGvc/kBZskPR201Rj3rEnu8QHE4lXkQZXUGhMR
         dN+nhL6v25PNybiiHyBWHNSul29oSrl2ng6oSuaAVW+i9jbNfbii4oTLuuROr24ZUamR
         RYTfyzPHgOVZn2xyby2NrlOP47AaXy4HpUTrdt9uXnbC9H/nkGgnI6KQ0B1PYTaCBc2m
         3cgQUSYzrNxwgj9RxUZ0QTO7y+MOrSVWpEou4AzD1g6ySbZDd2RJkru0hHQOhL8sWt0u
         xmOw==
X-Gm-Message-State: AO0yUKU9qsuw3efJgBI+Y9XDxqP9bswCjdgFVRf49607oE52Dt7H6rj3
        RpUh/xaRQHtUVcRgI+Odvzb1Kw==
X-Google-Smtp-Source: AK7set8fB2T3Yp6e7oXLpQvSuy5QdNrLHtwCWOp1643ps5CardXQOKYuldF9Mty3bq1ODsD5Zz9PEg==
X-Received: by 2002:a05:6a00:288b:b0:582:13b5:d735 with SMTP id ch11-20020a056a00288b00b0058213b5d735mr12876pfb.0.1674523074825;
        Mon, 23 Jan 2023 17:17:54 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f9-20020a623809000000b0056c2e497b02sm220593pfa.173.2023.01.23.17.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 17:17:54 -0800 (PST)
Date:   Tue, 24 Jan 2023 01:17:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kim Phillips <kim.phillips@amd.com>
Cc:     x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 4/8] x86/cpu, kvm: Move X86_FEATURE_LFENCE_RDTSC to
 its native leaf
Message-ID: <Y88xvq8vpH7Vz5Ac@google.com>
References: <20230123225700.2224063-1-kim.phillips@amd.com>
 <20230123225700.2224063-5-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123225700.2224063-5-kim.phillips@amd.com>
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

On Mon, Jan 23, 2023, Kim Phillips wrote:
> The LFENCE always serializing feature bit was defined as scattered
> LFENCE_RDTSC and its native leaf bit position open-coded for KVM.
> Add it to its newly added CPUID leaf 0x80000021 EAX proper.
> 
> Drop the bit description comments now it's more self-describing.
> 
> Also, in amd_init(), don't bother setting DE_CFG[1] any more.
> 
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h | 3 ++-
>  arch/x86/kernel/cpu/amd.c          | 2 +-
>  arch/x86/kvm/cpuid.c               | 4 ++--
>  3 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 7f0fb894e432..4f22d828c753 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -97,7 +97,7 @@
>  #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
>  #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
>  #define X86_FEATURE_AMD_LBR_V2		( 3*32+17) /* AMD Last Branch Record Extension Version 2 */
> -#define X86_FEATURE_LFENCE_RDTSC	( 3*32+18) /* "" LFENCE synchronizes RDTSC */
> +/* FREE, was #define X86_FEATURE_LFENCE_RDTSC		( 3*32+18) "" LFENCE synchronizes RDTSC */
>  #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
>  #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
>  #define X86_FEATURE_ALWAYS		( 3*32+21) /* "" Always-present feature */
> @@ -430,6 +430,7 @@
>  
>  /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
>  #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
> +#define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
>  
>  /*
>   * BUG word(s)
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index f769d6d08b43..208c2ce8598a 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -956,7 +956,7 @@ static void init_amd(struct cpuinfo_x86 *c)
>  
>  	init_amd_cacheinfo(c);
>  
> -	if (cpu_has(c, X86_FEATURE_XMM2)) {
> +	if (!cpu_has(c, X86_FEATURE_LFENCE_RDTSC) && cpu_has(c, X86_FEATURE_XMM2)) {
>  		/*
>  		 * Use LFENCE for execution serialization.  On families which
>  		 * don't have that MSR, LFENCE is already serializing.
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 13bd2769fa5a..601eeb03ebc9 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -742,11 +742,11 @@ void kvm_set_cpu_caps(void)
>  		F(SME_COHERENT));
>  
>  	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
> -		F(NO_NESTED_DATA_BP) | 0 /* SmmPgCfgLock */ |
> +		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
>  		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
>  	);
>  	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
> -		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(2) /* LFENCE Always serializing */;
> +		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);

Now that LFENCE_RDTSC is in its proper place, the kernel's set_cpu_cap() will
effectively sythesize the feature for KVM.  I.e. this patch can simply delete the
synthesis of the feature.

>  	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
>  		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(6) /* NULL_SEL_CLR_BASE */;
>  	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;
> -- 
> 2.34.1
> 
