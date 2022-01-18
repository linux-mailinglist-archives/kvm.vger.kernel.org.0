Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD00E492D4F
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 19:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348039AbiARSaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 13:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347989AbiARSaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 13:30:08 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7458DC06173E
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 10:30:08 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id m21so124840pfd.3
        for <kvm@vger.kernel.org>; Tue, 18 Jan 2022 10:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SWbb1UZG/b7k7Lx9na6HLCxa4UWNr2RlfPnFhxjraRg=;
        b=f4H5WNnaCHNp+d7K0qMWtzUU7JrzZgs2CLPbFeWIrzTmQ6AMxAts/LARYEPMhhz9Zc
         traIcym/lekeL97Ouynm24SqNqQCno5Ywn91tcLRTQmH8+1t+uCSNFmdk0XG7ggGQf0b
         E3BqfQ76zWGS0fP6df+/+yOJ9YceO2F55ZO9NSuIymy19+50eBaEjhFkSNAhrIP5ViBG
         +LNc3Ahf3r8lf05WZVzaP/BwscV13WDc13OmQ/Z2865qx+CZnpyJKGVOzmMiSiDuJ5sn
         k0CSsQZqjJd75q9+/AMS0k5w8p+r4KN95wvOGN3cGIv15/i0MhwvnMckr5NDjSiAxwmO
         YYmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SWbb1UZG/b7k7Lx9na6HLCxa4UWNr2RlfPnFhxjraRg=;
        b=npwAsS4pw1eMTB5s4XjcEqDrk7x6UwDjN2VFxvnaOeIrubVJSxPlboTOxbx0B3JO00
         1XAnsniVofCli3kHAMOBsIVn4xZnY7sHnPeuU9xQpvobowyxQ5uSdob5zTZqc/g6GNOC
         lOEFqotMRrjDVOv6ElXzKyqAdvHlWmmwr4BVjcmdMYC1/nyabD21ETQCPUkgzqN52RPX
         EVfXrpZp/GQRxe4DMCwRIJxLRamnInhPZNn4HtWUb5wtomeBwCxj/i+b7qDnm08Tb4pA
         6/n0KkLSRRS+6+k+4XhPeRh24dlnQ/LL2lMwmOym9DVvNrK+quo9s1s4Pg/3aFlGzJ2L
         8Npg==
X-Gm-Message-State: AOAM532mKMLW2wJJ6/3Si/uXkzaiTlvMP1W9yAkBqS/ro1n4bsQfRZAj
        88UQCbg4Ayvaeb0VQXdmqJO36Q==
X-Google-Smtp-Source: ABdhPJzB5DUKJcstTUBwBMK55nhluUUChAkq6wKa4PRFr915fyjn1nQYdkdR4oLzUnWTydBXCZaixA==
X-Received: by 2002:a63:84c8:: with SMTP id k191mr16893333pgd.562.1642530607662;
        Tue, 18 Jan 2022 10:30:07 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t5sm12971739pfl.6.2022.01.18.10.30.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 10:30:07 -0800 (PST)
Date:   Tue, 18 Jan 2022 18:30:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Update the states size cpuid even if
 XCR0/IA32_XSS is reset
Message-ID: <YecHK2DmooVlMr2U@google.com>
References: <20220117082631.86143-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117082631.86143-1-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 17, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> XCR0 is reset to 1 by RESET but not INIT and IA32_XSS is zeroed by
> both RESET and INIT. In both cases, the size in bytes of the XSAVE
> area containing all states enabled by XCR0 or (XCRO | IA32_XSS)
> needs to be updated.
> 
> Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/x86.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 76b4803dd3bd..5748a57e1cb7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11134,6 +11134,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	struct kvm_cpuid_entry2 *cpuid_0x1;
>  	unsigned long old_cr0 = kvm_read_cr0(vcpu);
>  	unsigned long new_cr0;
> +	bool need_update_cpuid = false;
>  
>  	/*
>  	 * Several of the "set" flows, e.g. ->set_cr0(), read other registers
> @@ -11199,6 +11200,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  
>  		vcpu->arch.msr_misc_features_enables = 0;
>  
> +		if (vcpu->arch.xcr0 != XFEATURE_MASK_FP)
> +			need_update_cpuid = true;
>  		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
>  	}
>  
> @@ -11216,6 +11219,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
>  	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
>  
> +	if (vcpu->arch.ia32_xss)
> +		need_update_cpuid = true;

This means that kvm_set_msr_common()'s handling of MSR_IA32_XSS also needs to
update kvm_update_cpuid_runtime().  And then for bnoth XCR0 and XSS, I would very
strongly prefer that use the helpers to write the values and let the helpers call
kvm_update_cpuid_runtime().  Yes, that will mean kvm_update_cpuid_runtime() may be
called multiple times during INIT, but that's already true (CR4), and this isn't
exactly a fast path.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 55518b7d3b96..22d4b1d15e94 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11256,7 +11256,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)

                vcpu->arch.msr_misc_features_enables = 0;

-               vcpu->arch.xcr0 = XFEATURE_MASK_FP;
+               __kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
        }

        /* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
@@ -11273,7 +11273,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
        cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
        kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);

-       vcpu->arch.ia32_xss = 0;
+       __kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);

        static_call(kvm_x86_vcpu_reset)(vcpu, init_event);


