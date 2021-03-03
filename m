Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABC9F32C6D2
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhCDAaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835542AbhCCSEC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 13:04:02 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B90C061756
        for <kvm@vger.kernel.org>; Wed,  3 Mar 2021 10:03:21 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id l18so4833382pji.3
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EZB5FybRq8qQJzZjsg9RL1K43u6gdJrGvoqJbzpIOAc=;
        b=GANJnuzl+xBpfT33zHPOMsOvR4RJflbUT9Y3LNZuctKjFTjUKxQA6YNZvB4c6Xne5G
         vkxjkIekkM16DqdyPX/NsuPeYd7KifCT2H+A8XrcrhCFNsqHdknBoF4WZ+WNk4Iu3Xu5
         bBHePIEy5bQJCY3cJRWdCR/TVHQ2pScActYFZkMeddBokyRgcMrmVt4DCIyWSpil43qd
         y0q86WeM6INR09Nb9hJZO8a2htWJdfz96mcoMAT7a9zfikwQy3sU3/bxnhqDEifKo2Xk
         W6VGP9eoc6QaQiD1qVmJzQD5UHb7mnGLuG/4Fr8FEO62N0qZaLK6y7GqpR/gffalUEc/
         Ql3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EZB5FybRq8qQJzZjsg9RL1K43u6gdJrGvoqJbzpIOAc=;
        b=eTb7sBwzmx0tqMyJBwgfOwd69PH7ZqKbE3sWBbv+ZV4OLmcGwr7nCEQ1WBLSp2o+9v
         MEiG/F/QXlxsUypo8Pe01A0mRf/lOxSal3nzxOx0FeYT6v/WyXb1eEiPi7vSyDlZ/tiq
         E7Jss5ut2LVk52TIn7EJj8BNq6brxP8atv9/w5MZk+CZ0wgFKPoL/q+5iFgmxCIBQ2je
         tErwUuGWzMvzUQRvMHiPgWrWeoeDRlFphYvV9g40BwYFOMQx6314C4rzk3u6XOgwhvDY
         aeqjnq5QsMsiYX79HYhPjM0j4xJoTyleszBdpifh4wznpIxIt7E9M5p7PLphgFlsBP1S
         Y4Lg==
X-Gm-Message-State: AOAM533xAZQMnmKqJ3zasA0zpm2k3uXwon0SG+Hix4e+kDdclyqWek7D
        2TDIRlG9QTPH0bVEACqNo9VXjA==
X-Google-Smtp-Source: ABdhPJxHiz9ohG6+W8dNXmMiMy9EY9e2DVip+EPXLXe1/ag47U0Nhl3U7ARwSbOllz5+QQBx4mIOyw==
X-Received: by 2002:a17:90b:4b0e:: with SMTP id lx14mr290874pjb.147.1614794601004;
        Wed, 03 Mar 2021 10:03:21 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id v14sm1438168pju.19.2021.03.03.10.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:03:20 -0800 (PST)
Date:   Wed, 3 Mar 2021 10:03:14 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 9/9] KVM: x86: Add XSAVE Support for Architectural LBRs
Message-ID: <YD/PYp0DtZaw2HYh@google.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-10-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303135756.1546253-10-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021, Like Xu wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 034708a3df20..ec4593e0ee6d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7268,6 +7268,8 @@ static __init void vmx_set_cpu_caps(void)
>  	supported_xss = 0;
>  	if (!cpu_has_vmx_xsaves())
>  		kvm_cpu_cap_clear(X86_FEATURE_XSAVES);
> +	else if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> +		supported_xss |= XFEATURE_MASK_LBR;
>  
>  	/* CPUID 0x80000001 */
>  	if (!cpu_has_vmx_rdtscp())
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d773836ceb7a..bca2e318ff24 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10433,6 +10433,8 @@ int kvm_arch_hardware_setup(void *opaque)
>  
>  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
>  		supported_xss = 0;
> +	else
> +		supported_xss &= host_xss;

Not your fault by any means, but I would prefer to have matching logic for XSS
and XCR0.  The existing clearing of supported_xss here is pointless.  E.g. I'd
prefer something like the following, though Paolo may have a different opinion.

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6d7e760fdfa0..c781034463e5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7244,12 +7244,15 @@ static __init void vmx_set_cpu_caps(void)
                kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
        if (vmx_pt_mode_is_host_guest())
                kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
+       if (!cpu_has_vmx_arch_lbr()) {
+               kvm_cpu_cap_clear(X86_FEATURE_ARCH_LBR);
+               supported_xss &= ~XFEATURE_MASK_LBR;
+       }

        if (vmx_umip_emulated())
                kvm_cpu_cap_set(X86_FEATURE_UMIP);

        /* CPUID 0xD.1 */
-       supported_xss = 0;
        if (!cpu_has_vmx_xsaves())
                kvm_cpu_cap_clear(X86_FEATURE_XSAVES);

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7b0adebec1ef..5f9eb1f5b840 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -205,6 +205,8 @@ static struct kvm_user_return_msrs __percpu *user_return_msrs;
                                | XFEATURE_MASK_BNDCSR | XFEATURE_MASK_AVX512 \
                                | XFEATURE_MASK_PKRU)

+#define KVM_SUPPORTED_XSS      XFEATURE_MASK_LBR
+
 u64 __read_mostly host_efer;
 EXPORT_SYMBOL_GPL(host_efer);

@@ -8037,6 +8039,11 @@ int kvm_arch_init(void *opaque)
                supported_xcr0 = host_xcr0 & KVM_SUPPORTED_XCR0;
        }

+       if (boot_cpu_has(X86_FEATURE_XSAVES))
+               rdmsrl(MSR_IA32_XSS, host_xss);
+               supported_xss = host_xss & KVM_SUPPORTED_XSS;
+       }
+
        if (pi_inject_timer == -1)
                pi_inject_timer = housekeeping_enabled(HK_FLAG_TIMER);
 #ifdef CONFIG_X86_64
@@ -10412,9 +10419,6 @@ int kvm_arch_hardware_setup(void *opaque)

        rdmsrl_safe(MSR_EFER, &host_efer);

-       if (boot_cpu_has(X86_FEATURE_XSAVES))
-               rdmsrl(MSR_IA32_XSS, host_xss);
-
        r = ops->hardware_setup();
        if (r != 0)
                return r;
@@ -10422,9 +10426,6 @@ int kvm_arch_hardware_setup(void *opaque)
        memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
        kvm_ops_static_call_update();

-       if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-               supported_xss = 0;
-
 #define __kvm_cpu_cap_has(UNUSED_, f) kvm_cpu_cap_has(f)
        cr4_reserved_bits = __cr4_reserved_bits(__kvm_cpu_cap_has, UNUSED_);
 #undef __kvm_cpu_cap_has

