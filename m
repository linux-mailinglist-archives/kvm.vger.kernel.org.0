Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FEE649623C
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 16:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381663AbiAUPmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 10:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381646AbiAUPl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 10:41:59 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8698DC06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:41:58 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i65so9194218pfc.9
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 07:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lyK32zM2izSK4P0aL4gxFB18kbHnmVnDUuq0JwdVPYY=;
        b=ckTZmjZCfIb3J6zjMXEjd67zyrMG36bJ8Rv+j91t6RkmfPKWQffI8U+IRitYQ3Mh3R
         s3QBG5oqvg/UHoAPK5Uc2ggG1GhdKJjSnoSl039YEUqyuQBpxnH4gfCMHCWVzEKWsUmO
         EGuqQszORrkoyTeUtfPPrvdFPO5qBCTsQ2JeIJ3ocDw+U7BrIb1wX/DlURlx7vpG27vd
         qB+CSxterbZACf7lOf8MFVwUw1HKSL4DzSuaf03iuRrK7hwxn5OBUO5DyUVKxJlElCf1
         WdZdjBYE/fFpIkRIPVcYPpz/7nQu2AfoST5nqqkhAyqy2htd2W77bYwE/88bY0/cE13f
         sCIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lyK32zM2izSK4P0aL4gxFB18kbHnmVnDUuq0JwdVPYY=;
        b=CebDC6a2bjbNrQEtLXRh81dyyIbzmsUE+3UhjugMzDMYmv2xP729yK74akIM9EpX+o
         NgoVCukMOJtzht9Aj4sQavGWyNK9V+60n7i5DXhpnW936CZUOVIOSaeg5k+pOoy5ClKm
         5YkzgnenN68jE9AyVhILe3ctySexBYW5EWegsf5uDdJoCl1bPMCYOQCI7tMzFa5nDjhr
         4KLZM/IeT+kM2rHVLm8W3GnwpiHY23CP0RY0+cqLv80UoGazO83lSZ1a0HRAwvOMSVi+
         ci0Lm1Z+e/DDa0UrkDBGS0VDKBn5flOqSRIfDyRldYc0oTA7jct9HnJhBb4YfSCRoBM2
         6V6w==
X-Gm-Message-State: AOAM530EP1eDek+31gQ+rwAZjY4PHnT5N0noZDqaJuQDe9Q/C5Pgi90R
        j1XZpPbwUhQNWExTZjPZRsDvAA==
X-Google-Smtp-Source: ABdhPJwQcPMUi4sTNNdCSaZw3Smg39rjuSRn8Lvzy21iXv4eb6eQQ+bcPOfc1hd0LlGlK/M6uS7mZw==
X-Received: by 2002:a63:8341:: with SMTP id h62mr3345650pge.357.1642779717846;
        Fri, 21 Jan 2022 07:41:57 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l13sm5532829pgs.16.2022.01.21.07.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jan 2022 07:41:57 -0800 (PST)
Date:   Fri, 21 Jan 2022 15:41:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: Sync the states size with the XCR0/IA32_XSS
 at any time
Message-ID: <YerUQa+SN/xWMhvB@google.com>
References: <20220117082631.86143-1-likexu@tencent.com>
 <f9edf9b5-0f84-a424-f8e9-73cad901d993@redhat.com>
 <eacf3f83-96f5-301e-de54-8a0f6c8f9fe5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eacf3f83-96f5-301e-de54-8a0f6c8f9fe5@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 21, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> XCR0 is reset to 1 by RESET but not INIT and IA32_XSS is zeroed by
> both RESET and INIT. The kvm_set_msr_common()'s handling of MSR_IA32_XSS
> also needs to update kvm_update_cpuid_runtime(). In the above cases, the
> size in bytes of the XSAVE area containing all states enabled by XCR0 or
> (XCRO | IA32_XSS) needs to be updated.
> 
> For simplicity and consistency, legacy helpers are used to write values

s/legacy/existing

"legacy" refers to something that is outdated/deprecated, which isn't what you
intend here.

> and call kvm_update_cpuid_runtime(), and it's not exactly a fast path.
> 
> Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> v1 -> v2 Changelog:
> - Strongly prefer that use the helpers to write the values; (Sean)
> - Postpone IA32_XSS test cases once non-zero values are supported; (Paolo)
> - User space may call SET_CPUID2 after kvm_vcpu_reset(init_event=false); (Paolo)
> 
>  arch/x86/kvm/x86.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 55518b7d3b96..22d4b1d15e94 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11256,7 +11256,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 
>  		vcpu->arch.msr_misc_features_enables = 0;
> 
> -		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
> +		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
>  	}
> 
>  	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
> @@ -11273,7 +11273,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
>  	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
> 
> -	vcpu->arch.ia32_xss = 0;
> +	__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);

This relies on a prep patch to invoke kvm_update_cpuid_runtime() in kvm_set_msr_common()
for MSR_IA32_XSS, no?

>  	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
> 
> -- 
> 2.33.1
> 
> 
