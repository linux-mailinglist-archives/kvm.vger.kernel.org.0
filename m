Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A305F16B31F
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 22:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgBXVsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 16:48:04 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21610 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726980AbgBXVsE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 16:48:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582580883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y3mparikf9DdIUeIjvvwXQ1Z1K4Cli1iz2ALnY2BpjQ=;
        b=HkBQr0otB4RqnoFrvpfjpvjUkEEJPzMN365uudLApcJHpfwClGlO1Z3xCIS9xY2jwCCi7S
        w1WhX9qirItfhzhHx24Ecd+3EMyuoyBQS7gqCmoXBN1ULowgCT2R+TUyeZYpYLdHRT7q5j
        FcGFOSsYJzMmJmJYBRzIhn8GSR0NJXw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-i36nwEhSN7Ok3klkweMl0A-1; Mon, 24 Feb 2020 16:48:01 -0500
X-MC-Unique: i36nwEhSN7Ok3klkweMl0A-1
Received: by mail-wr1-f71.google.com with SMTP id p5so686067wrj.17
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 13:48:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=y3mparikf9DdIUeIjvvwXQ1Z1K4Cli1iz2ALnY2BpjQ=;
        b=Y6ExVGYiF4zjBPNz2zH/3UuS6QGpMy8J6sIRlOcPebiR96sZN/JGs5PWbmQPoKcHTb
         obrLW2x+8KY6KKgfrdjGF7g4KJdBEgplRPFtoFDrvvJw0GkFtxxJ17Izn2Ltn3Sau5CA
         0nGldn6mKEMHMIhCm7AH/2kUEO4iHMioVxTZI6Z5vKBmYdxUnMxHbe8tSeEl6SfsI/zg
         3NSpJZiKXp/fcz5HITwxEKPrTMYRDESCCqkjbLw+1McTPPz0v0m3QR3bRXRenOQTxOys
         +SdwxV8JWmIFMiwUYMpaX8FgsF6tLEfbRmPgTcCCImp5rwg5PFqNEGF3qO1f4gzzQrbE
         pGwg==
X-Gm-Message-State: APjAAAUcrRWK+/TwvnkY9cqsmyOk4612b+pnZD8gO5eTMOPL/ItMgUxB
        aHadAgFQ5V0qp/R6SxwefRL2pc+Sg3/dGvU/L1Yvv47xIiQlDYq2er8NE0WSk4f6sndoxelPP8w
        5nUPvhB6132VJ
X-Received: by 2002:a1c:5419:: with SMTP id i25mr1036342wmb.150.1582580880344;
        Mon, 24 Feb 2020 13:48:00 -0800 (PST)
X-Google-Smtp-Source: APXvYqxcGJyPEiNp1nOJTpE1947zCHRS0Mdf/QuU39ULake55oSamxvw9KPNbmzyW5qp2oa0/4ydHA==
X-Received: by 2002:a1c:5419:: with SMTP id i25mr1036324wmb.150.1582580880079;
        Mon, 24 Feb 2020 13:48:00 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id z21sm1026315wml.5.2020.02.24.13.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:47:59 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 42/61] KVM: x86: Add a helper to check kernel support when setting cpu cap
In-Reply-To: <20200201185218.24473-43-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-43-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 22:47:58 +0100
Message-ID: <875zfvodwx.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Add a helper, kvm_cpu_cap_check_and_set(), to query boot_cpu_has() as
> part of setting a KVM cpu capability.  VMX in particular has a number of
> features that are dependent on both a VMCS capability and kernel
> support.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.h   |  6 ++++++
>  arch/x86/kvm/svm.c     |  3 +--
>  arch/x86/kvm/vmx/vmx.c | 18 ++++++++----------
>  3 files changed, 15 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
> index c64283582d96..7b71ae0ca05e 100644
> --- a/arch/x86/kvm/cpuid.h
> +++ b/arch/x86/kvm/cpuid.h
> @@ -274,4 +274,10 @@ static __always_inline void kvm_cpu_cap_set(unsigned x86_feature)
>  	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
>  }
>  
> +static __always_inline void kvm_cpu_cap_check_and_set(unsigned x86_feature)
> +{
> +	if (boot_cpu_has(x86_feature))
> +		kvm_cpu_cap_set(x86_feature);
> +}
> +
>  #endif
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 7cb05945162e..defb2c0dbf8a 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1362,8 +1362,7 @@ static __init void svm_set_cpu_caps(void)
>  
>  	/* CPUID 0x8000000A */
>  	/* Support next_rip if host supports it */
> -	if (boot_cpu_has(X86_FEATURE_NRIPS))
> -		kvm_cpu_cap_set(X86_FEATURE_NRIPS);
> +	kvm_cpu_cap_check_and_set(X86_FEATURE_NRIPS);
>  
>  	if (npt_enabled)
>  		kvm_cpu_cap_set(X86_FEATURE_NPT);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cfd0ef314176..cecf59225136 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7118,18 +7118,16 @@ static __init void vmx_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_VMX);
>  
>  	/* CPUID 0x7 */
> -	if (boot_cpu_has(X86_FEATURE_MPX) && kvm_mpx_supported())
> -		kvm_cpu_cap_set(X86_FEATURE_MPX);
> -	if (boot_cpu_has(X86_FEATURE_INVPCID) && cpu_has_vmx_invpcid())
> -		kvm_cpu_cap_set(X86_FEATURE_INVPCID);
> -	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
> -	    vmx_pt_mode_is_host_guest())
> -		kvm_cpu_cap_set(X86_FEATURE_INTEL_PT);
> +	if (kvm_mpx_supported())
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_MPX);
> +	if (cpu_has_vmx_invpcid())
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_INVPCID);
> +	if (vmx_pt_mode_is_host_guest())
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
>  
>  	/* PKU is not yet implemented for shadow paging. */
> -	if (enable_ept && boot_cpu_has(X86_FEATURE_PKU) &&
> -	    boot_cpu_has(X86_FEATURE_OSPKE))
> -		kvm_cpu_cap_set(X86_FEATURE_PKU);
> +	if (enable_ept && boot_cpu_has(X86_FEATURE_OSPKE))
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_PKU);
>  
>  	/* CPUID 0xD.1 */
>  	if (!vmx_xsaves_supported())

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

