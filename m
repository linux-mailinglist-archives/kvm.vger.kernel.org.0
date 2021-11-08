Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EC3449E41
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 22:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240390AbhKHVec (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 16:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238057AbhKHVea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 16:34:30 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6656BC061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 13:31:45 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id p8so15038433pgh.11
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 13:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IoCUy0ckLTOFUid7Iy+BX/Hk13faaLcXTZhF2jkBuiI=;
        b=sPc/XZpVz19bKX0gCpMfnJqHnHPZTZQoluFvw3APki3n2cKwA1Ge8GfHYO8w9Ke7WH
         01LCzn86g4nTjJQTMYv/gCAAQtYP9X5hy8VmAqT9qqWY68Vgl+DFDXz97UchzAt/oKP0
         JQYFADxNuPhY1brHfNwCNEsLwJIwJQVjRvCNmP8xruoW7x2kgL31W98KnHCu0g69PKQy
         tvANGY/wEJwuJscViJg159D0+7LNRuxxOqyssLzWjNq0D8UvmKuZaM2vL3Fu0AMDaRIi
         0GRTOQO2z7jh23YyjSAdfYxYyXDrS5ti4LA8wr0Tm1O0AB74VyDKUhPuK3z+g/nRJIg7
         h/TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IoCUy0ckLTOFUid7Iy+BX/Hk13faaLcXTZhF2jkBuiI=;
        b=ftS9UJpi11SIUyQbG7Pzipcv1S7S0CmJOaPqwv3cn2ZJPtP4icsK9Q3f3rgziXSJY7
         XDQCN+xI0ytN5kJVnz+1DBulnhAKcbjscYDUUI1gGjJbo2BL3jGDHn6quzutboXj0G6x
         ULb9ZD5ijomoPFCm99xVMbJjhNexQQXjQB/Qj3uWJ+pSVbl+CfHKHxT+2VS1vCPw1XwB
         Ci/e72cii17eWlUYZbZAFSeVZ9jQQrk3oIHLBGK92DZop2QvhuqKGAtFtphKNVSOoYoE
         qG78PYMrE2ljZFz80qa9BNPqILme7NJvfCZablT83el2hWQ+DuYwtbB9/EhaRhyzdVYy
         Ujog==
X-Gm-Message-State: AOAM531Zf8s8sEe6/e+d0TyM7lVQCoAHTa6EsDwnbxYXC2FKRfMxpeso
        Qw7xtlGeU5MmwZjRdGwWorRZiQ==
X-Google-Smtp-Source: ABdhPJykBxJsO3lt/l2H3w3eMF0RzDf+q/D8UKOuN74GOHiY+muFWNxDtsMWZtXqU+QdDq9XNTq/dg==
X-Received: by 2002:a05:6a00:70e:b0:480:be26:6240 with SMTP id 14-20020a056a00070e00b00480be266240mr2107586pfl.30.1636407104668;
        Mon, 08 Nov 2021 13:31:44 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v10sm4657125pfg.162.2021.11.08.13.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 13:31:43 -0800 (PST)
Date:   Mon, 8 Nov 2021 21:31:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 6/7] KVM: VMX: Expose PKS to guest
Message-ID: <YYmXO2WQpydWVro0@google.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
 <20210811101126.8973-7-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811101126.8973-7-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021, Chenyi Qiang wrote:
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 739be5da3bca..dbee0d639db3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -458,7 +458,7 @@ void kvm_set_cpu_caps(void)
>  		F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
>  		F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
>  		F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
> -		F(SGX_LC) | F(BUS_LOCK_DETECT)
> +		F(SGX_LC) | F(BUS_LOCK_DETECT) | 0 /*PKS*/

...

>  	);
>  	/* Set LA57 based on hardware capability. */
>  	if (cpuid_ecx(7) & F(LA57))

...

> @@ -7311,6 +7312,14 @@ static __init void vmx_set_cpu_caps(void)
>  
>  	if (cpu_has_vmx_waitpkg())
>  		kvm_cpu_cap_check_and_set(X86_FEATURE_WAITPKG);
> +
> +	/*
> +	 * PKS is not yet implemented for shadow paging.
> +	 * If not support VM_{ENTRY, EXIT}_LOAD_IA32_PKRS,
> +	 * don't expose the PKS as well.
> +	 */
> +	if (enable_ept && cpu_has_load_ia32_pkrs())
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_PKS);

I would rather handle the !TDP case in cpuid.c alongside the PKU.  The decision
to not support Protection Keys with legacy shadow paging is an x86 decision, not
a VMX decision.

And VMX's extra restriction on the VMCS support should not bleed into common x86.

Can you also opportunistically update the comment (see below) to explain _why_
OSPKE needs to be enabled in order to advertise PKU?

Thanks!

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 2d70edb0f323..c4ed6881857c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -439,18 +439,23 @@ void kvm_set_cpu_caps(void)
                F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
                F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
                F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/ |
-               F(SGX_LC) | F(BUS_LOCK_DETECT)
+               F(SGX_LC) | F(BUS_LOCK_DETECT) | F(PKS)
        );
        /* Set LA57 based on hardware capability. */
        if (cpuid_ecx(7) & F(LA57))
                kvm_cpu_cap_set(X86_FEATURE_LA57);

        /*
-        * PKU not yet implemented for shadow paging and requires OSPKE
-        * to be set on the host. Clear it if that is not the case
+        * Protection Keys are not supported for shadow paging.  PKU further
+        * requires OSPKE to be set on the host in order to use {RD,WR}PKRU to
+        * save/restore the guests PKRU.
         */
-       if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
+       if (!tdp_enabled) {
                kvm_cpu_cap_clear(X86_FEATURE_PKU);
+               kvm_cpu_cap_clear(X86_FEATURE_PKS);
+       } else if (!boot_cpu_has(X86_FEATURE_OSPKE)) {
+               kvm_cpu_cap_clear(X86_FEATURE_PKU);
+       }

        kvm_cpu_cap_mask(CPUID_7_EDX,
                F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |


and then vmx.c only needs to handle clearing PKS when the VMCS controls aren't
available.
