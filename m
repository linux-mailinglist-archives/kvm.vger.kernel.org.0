Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A8D3D99AE
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 01:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbhG1Xou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 19:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhG1Xot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 19:44:49 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A15C061765
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 16:44:46 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d1so4735837pll.1
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 16:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tIEw59iHMBzrooy5tG/1kAgE22g/jH7CuuEHVuy1wr0=;
        b=CZ+DOXfSsm3oEh7nXvRFTxtMIbn7wy96G39QAKLMn+tFkZbCR33xFDaz2qiBxtaoS1
         L69zU8I9Oi7MrQY1IPd+GjhYJ0gTnMZVKx8iTpfxpdRqnvRVnFkxtYzF/3hOPtylw7af
         BmLi95cxc34OieRCmUTxztcn8eYjHOc1cbOBROItVMecgAf1IxYpogsisztyZFHyF4OO
         PhCRHUkg/hVbCgapT6m4bpyG5Wnq+p1j0GJuBLRpzn/7HvYlXumAVhHzCyQd4mfDb1E+
         Fs2cW3PesqbBr11WWuPwniuUcdQElKpZ9yiqjo+AewzlTVW9uzEyV3jbBxpO9P1aFUwb
         gDuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tIEw59iHMBzrooy5tG/1kAgE22g/jH7CuuEHVuy1wr0=;
        b=lyK9UJ+nZyzpF69mJ69OKcv5gZbS9STlLIBfd3TPo6kZ/6Atw26eMNW6dAAa4U+9O2
         pCIrwSn8lqrjstLdUxQKUiFMUiMckaZ9/0BJCKSuzPNI37YRB4r87tl0kcKau94BJpxM
         O2g1OzzPsg8HYvjS5RYmP3hRPEljAh/I9VCWPkHfR4gdgAJpJUacuja12OhmYAscbfRs
         1h/o1KUeFVDneVI8RWbJALTq2RVHB392C+mi3+RYLdNHPiiK1+UUFmEiy5pEenWTbQMl
         o+uU15BU/bZn8FRpoxphZqt2wUpDPh9si2XD7gFa9uRy52HpI09A0fOeqqxqsFIdKeF8
         1/6w==
X-Gm-Message-State: AOAM533LC2PqcEWjUHnpxO3qKVRyu3xuxg0mP1JswuxNJSdaMrr/mRbo
        BvoOoM3AssN7ZobgwDTthlL93A==
X-Google-Smtp-Source: ABdhPJxplMSU5vtmBx2c12v3bc5j35rRpRrJTDuiWezzamAXnUfgUXTYhNwuBZ4T2/pRSdbsc5MsWQ==
X-Received: by 2002:a17:90a:8c01:: with SMTP id a1mr2209266pjo.42.1627515885443;
        Wed, 28 Jul 2021 16:44:45 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f31sm1131486pgm.1.2021.07.28.16.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 16:44:44 -0700 (PDT)
Date:   Wed, 28 Jul 2021 23:44:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH 1/6] x86/feat_ctl: Add new VMX feature, Tertiary
 VM-Execution control
Message-ID: <YQHr6VvNOQclolfc@google.com>
References: <20210716064808.14757-1-guang.zeng@intel.com>
 <20210716064808.14757-2-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716064808.14757-2-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021, Zeng Guang wrote:
> From: Robert Hoo <robert.hu@linux.intel.com>
> 
> New VMX capability MSR IA32_VMX_PROCBASED_CTLS3 conresponse to this new
> VM-Execution control field. And it is 64bit allow-1 semantics, not like
> previous capability MSRs 32bit allow-0 and 32bit allow-1. So with Tertiary
> VM-Execution control field introduced, 2 vmx_feature leaves are introduced,
> TERTIARY_CTLS_LOW and TERTIARY_CTLS_HIGH.

...

>  /*
>   * Note: If the comment begins with a quoted string, that string is used
> @@ -43,6 +43,7 @@
>  #define VMX_FEATURE_RDTSC_EXITING	( 1*32+ 12) /* "" VM-Exit on RDTSC */
>  #define VMX_FEATURE_CR3_LOAD_EXITING	( 1*32+ 15) /* "" VM-Exit on writes to CR3 */
>  #define VMX_FEATURE_CR3_STORE_EXITING	( 1*32+ 16) /* "" VM-Exit on reads from CR3 */
> +#define VMX_FEATURE_TER_CONTROLS	(1*32 + 17) /* "" Enable Tertiary VM-Execution Controls */

Maybe spell out TERTIARY?   SEC_CONTROLS is at least somewhat guessable, I doubt
TERTIARY is the first thing that comes to mind for most people when seeing "TER" :-)

>  #define VMX_FEATURE_CR8_LOAD_EXITING	( 1*32+ 19) /* "" VM-Exit on writes to CR8 */
>  #define VMX_FEATURE_CR8_STORE_EXITING	( 1*32+ 20) /* "" VM-Exit on reads from CR8 */
>  #define VMX_FEATURE_VIRTUAL_TPR		( 1*32+ 21) /* "vtpr" TPR virtualization, a.k.a. TPR shadow */
> diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
> index da696eb4821a..2e0272d127e4 100644
> --- a/arch/x86/kernel/cpu/feat_ctl.c
> +++ b/arch/x86/kernel/cpu/feat_ctl.c
> @@ -15,6 +15,8 @@ enum vmx_feature_leafs {
>  	MISC_FEATURES = 0,
>  	PRIMARY_CTLS,
>  	SECONDARY_CTLS,
> +	TERTIARY_CTLS_LOW,
> +	TERTIARY_CTLS_HIGH,
>  	NR_VMX_FEATURE_WORDS,
>  };
>  
> @@ -42,6 +44,13 @@ static void init_vmx_capabilities(struct cpuinfo_x86 *c)
>  	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS2, &ign, &supported);
>  	c->vmx_capability[SECONDARY_CTLS] = supported;
>  
> +	/*
> +	 * For tertiary execution controls MSR, it's actually a 64bit allowed-1.
> +	 */
> +	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &ign, &supported);
> +	c->vmx_capability[TERTIARY_CTLS_LOW] = ign;
> +	c->vmx_capability[TERTIARY_CTLS_HIGH] = supported;

Assuming only the lower 32 bits are going to be used for the near future (next
few years), what about defining just TERTIARY_CTLS_LOW and then doing:

	/*
	 * Tertiary controls are 64-bit allowed-1, so unlikely other MSRs, the
	 * upper bits are ignored (because they're not used, yet...).
	 */
	rdmsr_safe(MSR_IA32_VMX_PROCBASED_CTLS3, &supported, &ign);
	c->vmx_capability[TERTIARY_CTLS_LOW] = supported;

I.e. punt the ugliness issue down the road a few years.

> +
>  	rdmsr(MSR_IA32_VMX_PINBASED_CTLS, ign, supported);
>  	rdmsr_safe(MSR_IA32_VMX_VMFUNC, &ign, &funcs);
>  
> -- 
> 2.25.1
> 
