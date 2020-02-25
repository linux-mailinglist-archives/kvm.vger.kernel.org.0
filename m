Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F63E16C31A
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 14:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgBYN7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 08:59:32 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:43376 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729386AbgBYN7c (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 08:59:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582639170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y3IBwje837IyONOoLtNsymFYKPCGbjc1mWh+UydCIPE=;
        b=AHZjaVU07fXKChCP5eTqnCWeaLWZ2l9jFSRhOfVktxEN3avBnXN0bDkn7otDvvh6dSj46Y
        LZRQCznZZQQFfPcg4Uopjw3dZj7TDnhzBq/zr7VfcNs/z18P/h1+SMMaE2nibBsJKtNwCT
        9CxtCi6F1Q5JgbUIEnFSKQNPrZlXpWs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-hCTUsPC5M4i4_klYPVVyHw-1; Tue, 25 Feb 2020 08:59:29 -0500
X-MC-Unique: hCTUsPC5M4i4_klYPVVyHw-1
Received: by mail-wm1-f70.google.com with SMTP id p2so1055952wmi.8
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 05:59:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=y3IBwje837IyONOoLtNsymFYKPCGbjc1mWh+UydCIPE=;
        b=QoX4JHCeRayW16w6nALpeD+RfIDsQ4qW13BG2ZeI0Zc3F5IEYDez5jNiEr+Ba2mMCq
         eAm5Gj526tSbTPzONS1rzBqLTpzawOkq1QDuJXdEHu2AOuO26FjD+9vj/A4gIixOWF3H
         0BxGkJxHKEMfjryj/tfJSl31HBnPpEWHusnInLELXltVWeAGEeiVDhUc9LGfD684IsZs
         kdVHI/1spXjWAXeRahKfCjT6+LjZxOzSyOaZLghdY/K1IejQh8NFJRU2I9KrSC6s8bjN
         b2+JneTzVkqA+vEBPogi2r9FfnmBM31p9E0S2EA7M5u1FMsg2CHijF6stD4NAoOhQXgf
         KdHg==
X-Gm-Message-State: APjAAAWQArRCj9srgjEnkrLmMTPO6EkOXE9M9O/p4/oG6hbwo+37k5co
        ac1Vd4WRSJPcEItTUf9f8i8TZfCZziLID1EoutFxIC0g0pXr1kiwpTtVGYhXeMyiSJd/iH/5EMh
        3mGsxR/xqUCfH
X-Received: by 2002:a7b:c416:: with SMTP id k22mr5738396wmi.10.1582639167981;
        Tue, 25 Feb 2020 05:59:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqxmJ9qM0rhSH+CtvgaqXuX7teBSwrKccTsQFRql6zCJnMnH4wZcIMQJI2Ywf5PV9lQoBxvlng==
X-Received: by 2002:a7b:c416:: with SMTP id k22mr5738375wmi.10.1582639167715;
        Tue, 25 Feb 2020 05:59:27 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id z25sm4334882wmf.14.2020.02.25.05.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:59:27 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 50/61] KVM: x86: Set emulated/transmuted feature bits via kvm_cpu_caps
In-Reply-To: <20200201185218.24473-51-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-51-sean.j.christopherson@intel.com>
Date:   Tue, 25 Feb 2020 14:59:26 +0100
Message-ID: <87y2sqlqdd.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Set emulated and transmuted (set based on other features) feature bits
> via kvm_cpu_caps now that the CPUID output for KVM_GET_SUPPORTED_CPUID
> is direcly overidden with kvm_cpu_caps.
>
> Note, VMX emulation of UMIP already sets kvm_cpu_caps.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c   | 72 +++++++++++++++++++++---------------------
>  arch/x86/kvm/svm.c     | 10 +++---
>  arch/x86/kvm/vmx/vmx.c | 13 +-------
>  3 files changed, 42 insertions(+), 53 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 871c0bd04e19..a37cb6fda979 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -341,6 +341,8 @@ void kvm_set_cpu_caps(void)
>  		0 /* Reserved*/ | F(AES) | F(XSAVE) | 0 /* OSXSAVE */ | F(AVX) |
>  		F(F16C) | F(RDRAND)
>  	);
> +	/* KVM emulates x2apic in software irrespective of host support. */
> +	kvm_cpu_cap_set(X86_FEATURE_X2APIC);
>  
>  	kvm_cpu_cap_mask(CPUID_7_0_EBX,
>  		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
> @@ -366,6 +368,17 @@ void kvm_set_cpu_caps(void)
>  		F(MD_CLEAR)
>  	);
>  
> +	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> +	kvm_cpu_cap_set(X86_FEATURE_TSC_ADJUST);
> +	kvm_cpu_cap_set(X86_FEATURE_ARCH_CAPABILITIES);
> +
> +	if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
> +		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL);
> +	if (boot_cpu_has(X86_FEATURE_STIBP))
> +		kvm_cpu_cap_set(X86_FEATURE_INTEL_STIBP);
> +	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
> +		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
> +
>  	kvm_cpu_cap_mask(CPUID_7_1_EAX,
>  		F(AVX512_BF16)
>  	);
> @@ -388,6 +401,29 @@ void kvm_set_cpu_caps(void)
>  		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON)
>  	);
>  
> +	/*
> +	 * AMD has separate bits for each SPEC_CTRL bit.
> +	 * arch/x86/kernel/cpu/bugs.c is kind enough to
> +	 * record that in cpufeatures so use them.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_IBPB))
> +		kvm_cpu_cap_set(X86_FEATURE_AMD_IBPB);
> +	if (boot_cpu_has(X86_FEATURE_IBRS))
> +		kvm_cpu_cap_set(X86_FEATURE_AMD_IBRS);
> +	if (boot_cpu_has(X86_FEATURE_STIBP))
> +		kvm_cpu_cap_set(X86_FEATURE_AMD_STIBP);
> +	if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD))
> +		kvm_cpu_cap_set(X86_FEATURE_AMD_SSBD);
> +	if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
> +		kvm_cpu_cap_set(X86_FEATURE_AMD_SSB_NO);
> +	/*
> +	 * The preference is to use SPEC CTRL MSR instead of the
> +	 * VIRT_SPEC MSR.
> +	 */
> +	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
> +	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
> +		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
> +
>  	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
>  		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
>  		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
> @@ -490,9 +526,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	case 1:
>  		cpuid_entry_override(entry, CPUID_1_EDX);
>  		cpuid_entry_override(entry, CPUID_1_ECX);
> -		/* we support x2apic emulation even if host does not support
> -		 * it since we emulate x2apic in software */
> -		cpuid_entry_set(entry, X86_FEATURE_X2APIC);
>  		break;
>  	case 2:
>  		/*
> @@ -547,17 +580,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		cpuid_entry_override(entry, CPUID_7_ECX);
>  		cpuid_entry_override(entry, CPUID_7_EDX);
>  
> -		/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> -		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
> -		cpuid_entry_set(entry, X86_FEATURE_ARCH_CAPABILITIES);
> -
> -		if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
> -			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL);
> -		if (boot_cpu_has(X86_FEATURE_STIBP))
> -			cpuid_entry_set(entry, X86_FEATURE_INTEL_STIBP);
> -		if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
> -			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL_SSBD);
> -
>  		/* KVM only supports 0x7.0 and 0x7.1, capped above via min(). */
>  		if (entry->eax == 1) {
>  			entry = do_host_cpuid(array, function, 1);
> @@ -729,28 +751,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->eax = g_phys_as | (virt_as << 8);
>  		entry->edx = 0;
>  		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
> -		/*
> -		 * AMD has separate bits for each SPEC_CTRL bit.
> -		 * arch/x86/kernel/cpu/bugs.c is kind enough to
> -		 * record that in cpufeatures so use them.
> -		 */
> -		if (boot_cpu_has(X86_FEATURE_IBPB))
> -			cpuid_entry_set(entry, X86_FEATURE_AMD_IBPB);
> -		if (boot_cpu_has(X86_FEATURE_IBRS))
> -			cpuid_entry_set(entry, X86_FEATURE_AMD_IBRS);
> -		if (boot_cpu_has(X86_FEATURE_STIBP))
> -			cpuid_entry_set(entry, X86_FEATURE_AMD_STIBP);
> -		if (boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD))
> -			cpuid_entry_set(entry, X86_FEATURE_AMD_SSBD);
> -		if (!boot_cpu_has_bug(X86_BUG_SPEC_STORE_BYPASS))
> -			cpuid_entry_set(entry, X86_FEATURE_AMD_SSB_NO);
> -		/*
> -		 * The preference is to use SPEC CTRL MSR instead of the
> -		 * VIRT_SPEC MSR.
> -		 */
> -		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) &&
> -		    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
> -			cpuid_entry_set(entry, X86_FEATURE_VIRT_SSBD);
>  		break;
>  	}
>  	case 0x80000019:
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index e1ed5726964c..f4434816dcdf 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1360,6 +1360,11 @@ static __init void svm_set_cpu_caps(void)
>  	if (nested)
>  		kvm_cpu_cap_set(X86_FEATURE_SVM);
>  
> +	/* CPUID 0x80000008 */
> +	if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
> +	    boot_cpu_has(X86_FEATURE_AMD_SSBD))
> +		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
> +
>  	/* CPUID 0x8000000A */
>  	/* Support next_rip if host supports it */
>  	kvm_cpu_cap_check_and_set(X86_FEATURE_NRIPS);
> @@ -6053,11 +6058,6 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
>  static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  {
>  	switch (entry->function) {
> -	case 0x80000008:
> -		if (boot_cpu_has(X86_FEATURE_LS_CFG_SSBD) ||
> -		    boot_cpu_has(X86_FEATURE_AMD_SSBD))
> -			cpuid_entry_set(entry, X86_FEATURE_VIRT_SSBD);
> -		break;
>  	case 0x8000000A:
>  		entry->eax = 1; /* SVM revision 1 */
>  		entry->ebx = 8; /* Lets support 8 ASIDs in case we add proper
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index cd5a624610c9..2a1df1b714db 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7101,18 +7101,7 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  
>  static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  {
> -	switch (entry->function) {
> -	case 0x7:
> -		/*
> -		 * UMIP needs to be manually set even though vmx_set_cpu_caps()
> -		 * also sets UMIP since do_host_cpuid() will drop it.
> -		 */
> -		if (vmx_umip_emulated())
> -			cpuid_entry_set(entry, X86_FEATURE_UMIP);
> -		break;
> -	default:
> -		break;
> -	}
> +
>  }

Ok, feel free to ignore my previous comment about the need to document
what goes to caps and what to vmx_supported_cpuid() as the answer is
simple: everything goes to caps (at least on VMX) :-)

>  
>  static __init void vmx_set_cpu_caps(void)

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

