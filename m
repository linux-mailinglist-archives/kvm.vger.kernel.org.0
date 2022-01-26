Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C14549CFD3
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 17:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243173AbiAZQhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 11:37:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243174AbiAZQhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jan 2022 11:37:40 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3194C06173B
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:37:39 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id my12-20020a17090b4c8c00b001b528ba1cd7so222825pjb.1
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 08:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0lkZXVf0iO42qTs6hmWV+2+LZ5uEDOqbitDpMYhaXGE=;
        b=U35s0iOlg1H127K2jntAKAz9pNUTT4BjIPRQR3LmfMrto8XQT9oVEI8fImw584Xrhg
         Kb2Fkwx7b2BPIGTNgkGxnyoHslX+Kgt4S4aBPkqamXByT+Nimjw7/9f7Y1oY6XAbtKLW
         vEd7QNcl9vw82H+7wrUcszlx0+Al5md/yU0u38N5lyfA3rjNhSIIHTbBpW+1td5S3s5a
         S4gseYjxmHJoRJ2D5Mo32mSoAJqh9ponRVGa+mNPArgvcdBRyHY+KK5UGNNdfyRZGEzm
         sKzQFDZNBrrTi8PBzUwDu7B/j8Kg1imcXCuG5jyRFpJP93CFbp+YsiNX3X4QxH72ZZIj
         ecdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0lkZXVf0iO42qTs6hmWV+2+LZ5uEDOqbitDpMYhaXGE=;
        b=UxZf0Xgrsd1CLiWNANXZZNdqdlqUUvCWp0g8NquBBHZXTivityZIkt8FmOpjtra8Pw
         jWrw0V5+umU8lhFZpgZ2olIzo5D4dyVWXO+42lnz+0XJ7Xfz6umEksRGxOvYFbS8g5Zz
         /sjuvfTWXtG5LAyQ6w5dfb+VDHhTaAaal4qI3MVRvtoxnDG//fuOJeBrgmsczM0yhc2q
         0LrQhC408WivXffeTxvYShMpxyT+B8sFwslzREZyBTvdOaSkGr0ZPm7L9xSQicyzil2h
         OJqiX3Yd/6Uz5uycE0VrD2xkGh02MzYYS/x8EAQBnBwikrQaES/Wzpiqf0mI2fdkKcXb
         Iuiw==
X-Gm-Message-State: AOAM531fHxtb0g6RKo7FB6+2WPiG4rI6i5NeHANnjgFAPGEYzrvLTzJ1
        qVusO4YC/mMRCTmsDIURNyjHTg==
X-Google-Smtp-Source: ABdhPJx3wnTz6Lmd7CP8lDGl/you1LvrfJY9yqRtpA+GKDRZbVlp9xUtDYLSM7/YLkgGC6ty9Ba5jg==
X-Received: by 2002:a17:902:b718:b0:14a:c2ac:6ae2 with SMTP id d24-20020a170902b71800b0014ac2ac6ae2mr23555204pls.125.1643215059266;
        Wed, 26 Jan 2022 08:37:39 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ha11sm5027116pjb.3.2022.01.26.08.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 08:37:38 -0800 (PST)
Date:   Wed, 26 Jan 2022 16:37:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: x86: Sync the states size with the XCR0/IA32_XSS
 at, any time
Message-ID: <YfF4z5ye8YCfoqzJ@google.com>
References: <20220117082631.86143-1-likexu@tencent.com>
 <f9edf9b5-0f84-a424-f8e9-73cad901d993@redhat.com>
 <eacf3f83-96f5-301e-de54-8a0f6c8f9fe5@gmail.com>
 <YerUQa+SN/xWMhvB@google.com>
 <dc8c75a6-a39f-be1d-6cf3-024b88bdf5fe@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc8c75a6-a39f-be1d-6cf3-024b88bdf5fe@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Jan 23, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> XCR0 is reset to 1 by RESET but not INIT and IA32_XSS is zeroed by
> both RESET and INIT. The kvm_set_msr_common()'s handling of MSR_IA32_XSS
> also needs to update kvm_update_cpuid_runtime(). In the above cases, the
> size in bytes of the XSAVE area containing all states enabled by XCR0 or
> (XCRO | IA32_XSS) needs to be updated.
> 
> For simplicity and consistency, existing helpers are used to write values
> and call kvm_update_cpuid_runtime(), and it's not exactly a fast path.
> 
> Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
> v2 -> v3 Changelog:
> - Apply s/legacy/existing in the commit message; (Sean)
> - Invoke kvm_update_cpuid_runtime() for MSR_IA32_XSS; (Sean)
> 
>  arch/x86/kvm/x86.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 55518b7d3b96..4b509b26d9ab 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3535,6 +3535,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct
> msr_data *msr_info)
>  		if (data & ~supported_xss)
>  			return 1;
>  		vcpu->arch.ia32_xss = data;
> +		kvm_update_cpuid_runtime(vcpu);
>  		break;
>  	case MSR_SMI_COUNT:
>  		if (!msr_info->host_initiated)
> @@ -11256,7 +11257,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 
>  		vcpu->arch.msr_misc_features_enables = 0;
> 
> -		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
> +		__kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
>  	}
> 
>  	/* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
> @@ -11273,7 +11274,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
>  	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
> 
> -	vcpu->arch.ia32_xss = 0;
> +	__kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);

Heh, this now conflicts with a patch Xiaoyao just posted, turns out the SDM was
wrong.  I think there's also some whitespace change or something that prevents
this from applying cleanly.  For convenience, I'll post a miniseries with this
and Xiaoyao's patch.

[*] https://lore.kernel.org/all/20220126034750.2495371-1-xiaoyao.li@intel.com

> 
>  	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
> 
> -- 
> 2.33.1
> 
> 
