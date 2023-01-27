Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE86167F09F
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 22:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbjA0VqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 16:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbjA0VqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 16:46:10 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E8E5C0F7
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:46:09 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id h5-20020a17090a9c0500b0022bb85eb35dso5960641pjp.3
        for <kvm@vger.kernel.org>; Fri, 27 Jan 2023 13:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SBxu6NyOPQfAm5//jHY28N93ngYshh04Hp/ryNSbhA8=;
        b=YHx+mWiOKFC4L7dYRxw7hJUNYN9atrXUf4k07CzfquThLD9OMz/BpnPo1FOFVZgU8X
         QLkVp8TkBwq5ttTUQMdFiqfbFKITeZwFhfxaoVZKSNbeH8+nxgZO2WfqEEvLfnAKkkVL
         AZTYo7GEGy4RqPTVgr02P2HnY4pzeijTGS/BCIPrMwa5LVDcck5BNGvw6yT1ZCm1vFT0
         Z6M8djfk9DfaFcQTW99cXI4wsZ2ed5ji+1xpwPy1j86Em87rkoOFU3jkpq0Kip/Cl9+H
         es7svuvlZYfLdpl90TaBgOJDReZL9C+nLd0phbYmaTK8GQGhG947TiuLKaseeS04K9Cb
         /msw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SBxu6NyOPQfAm5//jHY28N93ngYshh04Hp/ryNSbhA8=;
        b=myw/PDrNO6sB6qXl33Lxc1cAJfsNbSjp3S6cyigjt25tZX+t6gIZoxxyg/y0SBOUqW
         TXMG8TPD9HLcafcyiyo5V1Us4b8ZfJ7B4DbFwlJ1uahphHPJC7Jb6Q32KoBl84QAEwyO
         fXXskgsskapZOMoo8CntocV64GVWjcr0Q80OyBzFZHvx088mAmf7MnRJ25aOsN5FgNM2
         xYZl72CDVAHsE6BkX1/OROVgikqNNqf508wZlY8jywKOs2EUiSeeju7GEKKsOGmuh5Xy
         fw0j8ntg8EbOm3n22avMOYfE1DnI8C5JBA9LzQEhvWqHQv4B+w1/iLws1qcxNzDWpdEX
         R6Uw==
X-Gm-Message-State: AO0yUKVmSynFtXlzwU3SXzEifPrgbE7Z6D9KqmtGRDmaoi9R2kcQ6tKk
        S/A3g7UnDgZALT/lULjQELDUEXea+d4Fv2VSOm0=
X-Google-Smtp-Source: AK7set/LnUiebqUBd2kCESfTmkIx0pP8zJ0/XA1EwRyWLSaDm4LIvJcFTJwKMKGP38z4u4gX5WokDg==
X-Received: by 2002:a17:902:b686:b0:191:4367:7fde with SMTP id c6-20020a170902b68600b0019143677fdemr162137pls.0.1674855969031;
        Fri, 27 Jan 2023 13:46:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a14-20020a170902ecce00b001960792dfe9sm3319119plh.135.2023.01.27.13.46.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 13:46:08 -0800 (PST)
Date:   Fri, 27 Jan 2023 21:46:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com
Subject: Re: [PATCH v2 09/15] KVM: x86: Refine the matching and clearing
 logic for supported_xss
Message-ID: <Y9RGHeXUVsQCpYBF@google.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-10-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125040604.5051-10-weijiang.yang@intel.com>
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

On Thu, Nov 24, 2022, Yang Weijiang wrote:
> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> Refine the code path of the existing clearing of supported_xss in this way:
> initialize the supported_xss with the filter of KVM_SUPPORTED_XSS mask and
> update its value in a bit clear manner (rather than bit setting).
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 5 +++--
>  arch/x86/kvm/x86.c     | 6 +++++-
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 9bd52ad3bbf4..2ab4c33b5008 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7738,9 +7738,10 @@ static __init void vmx_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_UMIP);
>  
>  	/* CPUID 0xD.1 */
> -	kvm_caps.supported_xss = 0;

This needs to stay until VMX actually supports something.

> -	if (!cpu_has_vmx_xsaves())
> +	if (!cpu_has_vmx_xsaves()) {
>  		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
> +		kvm_caps.supported_xss = 0;

This is already handled in common KVM.

> +	}
>  
>  	/* CPUID 0x80000001 and 0x7 (RDPID) */
>  	if (!cpu_has_vmx_rdtscp()) {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 74c858eaa1ea..889be0c9176d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -217,6 +217,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
>  				| XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
>  				| XFEATURE_MASK_PKRU | XFEATURE_MASK_XTILE)
>  
> +#define KVM_SUPPORTED_XSS     0
> +
>  u64 __read_mostly host_efer;
>  EXPORT_SYMBOL_GPL(host_efer);
>  
> @@ -11999,8 +12001,10 @@ int kvm_arch_hardware_setup(void *opaque)
>  
>  	rdmsrl_safe(MSR_EFER, &host_efer);
>  
> -	if (boot_cpu_has(X86_FEATURE_XSAVES))
> +	if (boot_cpu_has(X86_FEATURE_XSAVES)) {
>  		rdmsrl(MSR_IA32_XSS, host_xss);
> +		kvm_caps.supported_xss = host_xss & KVM_SUPPORTED_XSS;
> +	}
>  
>  	kvm_init_pmu_capability();
>  
> -- 
> 2.27.0
> 
