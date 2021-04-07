Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D02357560
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 22:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355856AbhDGUDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 16:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355841AbhDGUDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 16:03:23 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B356C061760
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 13:03:13 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d8so9894914plh.11
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 13:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B41V4oqYaXi3FydWXE4zvPEfZIelBL661YH0Myuz09E=;
        b=boEMul6rkTXaZYoyXAY/38c3XvmUdzsNOME7Pzj2W5uWd10bc3FDMud+mt3Bb2ksCA
         zKBFXnRwWhQ5qDx5U/o/bk0hoSgZD/0GcDJWk6wdAWYnlFbN62lq5K5cpr2jtosbvqYr
         RSdnkQk5IUS2uLTlmrS1PrUGcsuqpH+HT2guha3qC72E8eDdUUhwywIxtcFxlvCES8Ix
         zgKPqaOo+4e4mNerI5oTd3u2xcbm9fqH4vkjDcgpkhqLRiijXFLgTzkZyG7PZ+8hV8hZ
         Cg3CiM14sQ2PvhmX4r8NcZURs1bjpXLoB31KEdAIaYSJuBAgnbxDIOpRokXX3LavT8Wx
         /Ubw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B41V4oqYaXi3FydWXE4zvPEfZIelBL661YH0Myuz09E=;
        b=hunZFxUz80iPWqog3/A20LaZ0eO4JECImVT9P4TRhX/lHYUpHqVDJl0h2mYZD6wpTc
         nEgIhXWm9dUfbl/QkSPPS/D8ikgofYslcRgK3638iiwDcIbyvGKVix6pIQJc3RKvkx33
         47oAzxYRovyi/d3HuD4OzEalg9GGi+Fe4H/rJ/YtpVQRkuiWZyo18+oOYLqRAVvpu3Xz
         0Ixq7SyVaMFCV50ZhNoDX8uJXwPHxfy4r6p98qQxYNr18DV0NugNAHz575NogQ0cQ4vz
         0JXnUgqkXXFlzXC8T9E4BKr2qkxIgNb/fRtFuGs6ocdWK0N/FeiZ1Jc2Tfgg7SPdROO/
         /bFg==
X-Gm-Message-State: AOAM533bUc3QJ4XBP9p8jdUBZ0Xz9AI3zB8eFF52GOSDgvt+fNkl/g3m
        5C571C8wn0N7MpVnKHqGPO3iAg==
X-Google-Smtp-Source: ABdhPJxCyQUB6B2HBH0gDU3LGzEyNg31SjFIXXSlM53qGjpJxYdf1nDQly8G1HFpKGscZcFsr8siig==
X-Received: by 2002:a17:90a:cb0a:: with SMTP id z10mr5047517pjt.20.1617825792766;
        Wed, 07 Apr 2021 13:03:12 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id u17sm5786219pfm.113.2021.04.07.13.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 13:03:12 -0700 (PDT)
Date:   Wed, 7 Apr 2021 20:03:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ramakrishna Saripalli <rsaripal@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/kvm/svm: Implement support for PSFD
Message-ID: <YG4P/EdPN4qGpYUq@google.com>
References: <20210407194512.6922-1-rsaripal@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210407194512.6922-1-rsaripal@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021, Ramakrishna Saripalli wrote:
> From: Ramakrishna Saripalli <rk.saripalli@amd.com>
> 
> Expose Predictive Store Forwarding capability to guests.

Technically KVM is advertising the capability to userspace, e.g. userspace can
expose the feature to the guest without this patch.

> Guests enable or disable PSF via SPEC_CTRL MSR.

At a (very) quick glance, this requires extra enabling in guest_has_spec_ctrl_msr(),
otherwise a vCPU with PSF but not the existing features will not be able to set
MSR_IA32_SPEC_CTRL.PSFD.

That raises a question: should KVM do extra checks for PSFD on top of the "throw
noodles at the wall and see what sticks" approach of kvm_spec_ctrl_test_value()?
The noodle approach is there to handle the mess of cross-vendor features/bits,
but that doesn't seem to apply to PSFD.

> Signed-off-by: Ramakrishna Saripalli <rk.saripalli@amd.com>
> ---
>  arch/x86/kvm/cpuid.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 6bd2f8b830e4..9c4af0fef6d7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -448,6 +448,8 @@ void kvm_set_cpu_caps(void)
>  		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
>  	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
>  		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
> +	if (boot_cpu_has(X86_FEATURE_AMD_PSFD))
> +		kvm_cpu_cap_set(X86_FEATURE_AMD_PSFD);

This is unnecessary, it's handled by the F(AMD_PSFD).  The above features have
special handling to enumerate their Intel equivalent.

>  	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>  		F(AVX_VNNI) | F(AVX512_BF16)
> @@ -482,7 +484,7 @@ void kvm_set_cpu_caps(void)
>  	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
>  		F(CLZERO) | F(XSAVEERPTR) |
>  		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> -		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON)
> +		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) | F(AMD_PSFD)
>  	);
>  
>  	/*
> -- 
> 2.25.1
> 
