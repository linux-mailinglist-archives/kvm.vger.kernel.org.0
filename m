Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D7A369471
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 16:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhDWONO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 10:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhDWONN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 10:13:13 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7058EC061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 07:12:37 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gq23-20020a17090b1057b0290151869af68bso1248716pjb.4
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 07:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ajVi+9Fz0ys2enjKok/N/kbmnzMuDauCUH0fs9IKEz0=;
        b=HEHFl5VeYwDsoLVSOGgYnu99ThD/fhwYVwtuoASS0BgfOPwTFVEfcPyFxLZAMprg7s
         M5nmBsOBVNbPmNoloPdhMFEPZrQIIvLjxmPlAS9V9XmAkF8oK/MdKpuvfbGsBcA/r57K
         4rRS9zp3WsgfW2VBwYPlmIvwJsJERcK8vbnox6Un3ce1rJ+I1ipv5w/uSWfmoDJrCNkJ
         jXn9Kk1+GLZUN2QmkH8bqIBSg57O5jiLdpvnJPN8amM2MkufeSVh2kWytCu6DGuvtRL7
         HZB4pbZu6+OmZ+rUscONnm/Qb/7bm4KJvq54vdtPrHcTtLfRQsNgvcuoLUD9qcT7DoZ6
         Hjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ajVi+9Fz0ys2enjKok/N/kbmnzMuDauCUH0fs9IKEz0=;
        b=lh4u7ZIyYzqavrWEJDDd0yrgp/HqqhyBtoeN4bgiwuUf9VcHMix9us1iFL3Pz03x6v
         87Fgwo2i3B2RzRicVe4rF1pgXltamOhaLJzisR10BR9kOWem7D5WsfULRLSz9qHnsDta
         glk2BAaxAZFyGIQxJPP/vU2WmumUDZ7vIwQIaMda/Hij9WolfdlpIV9ktrNhWWsI+2Ki
         lezwTjBSgJVsk5f71UA5MWEOWfm48KPycntGP3H5RJJhVTChYqWneERIz5wTOIQh9pRZ
         8Q8DYfyTZ7ik/8Y7FPrgxuXmWw4gJ7mo3SR/iS9zcxnz5DlY9s8rLb4sdlDZY9YhkiSS
         h2GQ==
X-Gm-Message-State: AOAM5313l6cymoqIPQswqA/5URdzRcRHJ8oYOeMsDHKCq8p7e+D4iJR/
        Uu+13nCjXobUGCXMB+Xa0HLFQA==
X-Google-Smtp-Source: ABdhPJxklyb/JLlpqm/k8LcKabgsrb+/ZUxF2SYRQSHaFi240wu2tEqEvL8CVFL2+P3FPeLLlGB31Q==
X-Received: by 2002:a17:90a:5b15:: with SMTP id o21mr4714274pji.193.1619187156819;
        Fri, 23 Apr 2021 07:12:36 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h18sm5059108pgj.51.2021.04.23.07.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 07:12:36 -0700 (PDT)
Date:   Fri, 23 Apr 2021 14:12:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Reiji Watanabe <reijiw@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2] KVM: SVM: Delay restoration of host MSR_TSC_AUX until
 return to userspace
Message-ID: <YILV0KrBUaESfTiY@google.com>
References: <20210422001736.3255735-1-seanjc@google.com>
 <CAAeT=FxaRV+za7yk8_9p45k4ui3QJx90gN4b8k4egrxux=QWFA@mail.gmail.com>
 <YIHYsa1+psfnszcv@google.com>
 <8cc2bb9a-167e-598c-6a9e-c23e943b1248@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cc2bb9a-167e-598c-6a9e-c23e943b1248@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021, Paolo Bonzini wrote:
> On 22/04/21 22:12, Sean Christopherson wrote:
> > 	case MSR_TSC_AUX:
> > 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
> > 			return 1;
> > 
> > 		if (!msr_info->host_initiated &&
> > 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> > 			return 1;
> > 
> > 		/*
> > 		 * TSC_AUX is usually changed only during boot and never read
> > 		 * directly.  Intercept TSC_AUX instead of exposing it to the
> > 		 * guest via direct_access_msrs, and switch it via user return.
> > 		 */
> > 		preempt_disable();
> > 		r = kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
> > 		preempt_enable();
> > 		if (r)
> > 			return 1;
> > 
> > 		/*
> > 		 * Bits 63:32 are dropped by AMD CPUs, but are reserved on
> > 		 * Intel CPUs.  AMD's APM has incomplete and conflicting info
> > 		 * on the architectural behavior; emulate current hardware as
> > 		 * doing so ensures migrating from AMD to Intel won't explode.
> > 		 */
> > 		svm->tsc_aux = (u32)data;
> > 		break;
> > 
> 
> Ok, squashed in the following:

Too fast!  The below won't compile (s/msr_info/msr and 'r' needs to be defined),
and the get_msr() path needs the guest_cpuid_has() check.  I'll spin a v3. 

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 14ff7f0963e9..00e9680969a2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2875,16 +2875,28 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>  		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
>  			return 1;
> +		if (!msr_info->host_initiated &&
> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> +			return 1;
> +
>  		/*
>  		 * TSC_AUX is usually changed only during boot and never read
>  		 * directly.  Intercept TSC_AUX instead of exposing it to the
>  		 * guest via direct_access_msrs, and switch it via user return.
>  		 */
> -		svm->tsc_aux = data;
> -
>  		preempt_disable();
> -		kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
> +		r = kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
>  		preempt_enable();
> +		if (r)
> +			return 1;
> +
> +		/*
> +		 * Bits 63:32 are dropped by AMD CPUs, but are reserved on
> +		 * Intel CPUs.  AMD's APM has incomplete and conflicting info
> +		 * on the architectural behavior; emulate current hardware as
> +		 * doing so ensures migrating from AMD to Intel won't explode.
> +		 */
> +		svm->tsc_aux = (u32)data;
>  		break;
>  	case MSR_IA32_DEBUGCTLMSR:
>  		if (!boot_cpu_has(X86_FEATURE_LBRV)) {
> 
> Paolo
> 
