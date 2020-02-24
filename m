Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7A7F16B4AE
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 23:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbgBXW5V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 17:57:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49809 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727843AbgBXW5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 17:57:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582585035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dl/EWQcwWbPxV6rjpwT5kK4NlKxvsnqGRr2MBtCijQI=;
        b=LvDDjNy2pwkm94EP4ZiQc9tS9Ttldj3kpcRc0K8GOZ+2jKuzqjeJdAyCUHAWsO4UBkXBYQ
        65LmYylpPcGj8n8TUXswZPWphRM4t2PX2ZWvqLCic6or5xnEPynmnd4/vR3VdU/Psc6irC
        6c4r5wy0vHBT0VuhSp1T2gRjlTKvNqg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-tXXfPDv2NZurbWdl4n1Rnw-1; Mon, 24 Feb 2020 17:57:14 -0500
X-MC-Unique: tXXfPDv2NZurbWdl4n1Rnw-1
Received: by mail-wm1-f71.google.com with SMTP id u11so344513wmb.4
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 14:57:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dl/EWQcwWbPxV6rjpwT5kK4NlKxvsnqGRr2MBtCijQI=;
        b=HChymJqiRO2vz0AhwHKOv8appKluwY+uiQFHiDwO3yr1nGh1XfF6LVy1XQ/BzkaYP+
         OesydxxXdQe5VJeto8WrBcvb/s5xsJqcBW9+RGD4EiiUizyTF+R3X9wAexRpUBs1+STy
         shh0+CCgIFujrIdSDMDzA/rqbyKX1zXSnqJDom9dIKiPNMJ1Nme0x9lKnaX5q5YlTqn4
         Dg8VP75Fvg63XMFNkoLeO1rvKBKhpDp1X2+4kOfN1BHXqMm50V4+eczplSPvk7QrntqP
         un9VI579H/MsRdWIvxNxZ3RC8LlmbwqaEuzRy+6sWmUnGKHB2+R+Ph8PIn2a1lr0+LrN
         Ddhw==
X-Gm-Message-State: APjAAAWVTWXz6YsBCH61yMzLSUkckeODR4rcncZbpGeoR4wt7aRG3yIV
        /6GVykzRWheK9KbqJ6BV4/CkWPrGYixyKDPIYdZxyxwzZiK+2X4hYN9SNf/bexuTXuSrosFGZbu
        QS9CVrShTnxgR
X-Received: by 2002:a1c:5684:: with SMTP id k126mr1222022wmb.181.1582585032885;
        Mon, 24 Feb 2020 14:57:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqyhYoZfPObV4TwNBxFiZc2/dDu6YlnrxE+jZSdy6KTzpMMP1+GKn17zhGLWiZGkRKnFudBNiw==
X-Received: by 2002:a1c:5684:: with SMTP id k126mr1222003wmb.181.1582585032577;
        Mon, 24 Feb 2020 14:57:12 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m3sm21181060wrs.53.2020.02.24.14.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 14:57:12 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 49/61] KVM: x86: Override host CPUID results with kvm_cpu_caps
In-Reply-To: <20200201185218.24473-50-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-50-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 23:57:10 +0100
Message-ID: <87lformw55.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Override CPUID entries with kvm_cpu_caps during KVM_GET_SUPPORTED_CPUID
> instead of masking the host CPUID result, which is redundant now that
> the host CPUID is incorporated into kvm_cpu_caps at runtime.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 4416f2422321..871c0bd04e19 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -261,13 +261,13 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>  	return r;
>  }
>  
> -static __always_inline void cpuid_entry_mask(struct kvm_cpuid_entry2 *entry,
> -					     enum cpuid_leafs leaf)
> +static __always_inline void cpuid_entry_override(struct kvm_cpuid_entry2 *entry,
> +						 enum cpuid_leafs leaf)
>  {
>  	u32 *reg = cpuid_entry_get_reg(entry, leaf * 32);
>  
>  	BUILD_BUG_ON(leaf > ARRAY_SIZE(kvm_cpu_caps));
> -	*reg &= kvm_cpu_caps[leaf];
> +	*reg = kvm_cpu_caps[leaf];
>  }
>  
>  static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
> @@ -488,8 +488,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->eax = min(entry->eax, 0x1fU);
>  		break;
>  	case 1:
> -		cpuid_entry_mask(entry, CPUID_1_EDX);
> -		cpuid_entry_mask(entry, CPUID_1_ECX);
> +		cpuid_entry_override(entry, CPUID_1_EDX);
> +		cpuid_entry_override(entry, CPUID_1_ECX);
>  		/* we support x2apic emulation even if host does not support
>  		 * it since we emulate x2apic in software */
>  		cpuid_entry_set(entry, X86_FEATURE_X2APIC);
> @@ -543,9 +543,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  	/* function 7 has additional index. */
>  	case 7:
>  		entry->eax = min(entry->eax, 1u);
> -		cpuid_entry_mask(entry, CPUID_7_0_EBX);
> -		cpuid_entry_mask(entry, CPUID_7_ECX);
> -		cpuid_entry_mask(entry, CPUID_7_EDX);
> +		cpuid_entry_override(entry, CPUID_7_0_EBX);
> +		cpuid_entry_override(entry, CPUID_7_ECX);
> +		cpuid_entry_override(entry, CPUID_7_EDX);
>  
>  		/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
>  		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
> @@ -564,7 +564,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  			if (!entry)
>  				goto out;
>  
> -			cpuid_entry_mask(entry, CPUID_7_1_EAX);
> +			cpuid_entry_override(entry, CPUID_7_1_EAX);
>  			entry->ebx = 0;
>  			entry->ecx = 0;
>  			entry->edx = 0;
> @@ -630,7 +630,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		if (!entry)
>  			goto out;
>  
> -		cpuid_entry_mask(entry, CPUID_D_1_EAX);
> +		cpuid_entry_override(entry, CPUID_D_1_EAX);
>  		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
>  			entry->ebx = xstate_required_size(supported_xcr0, true);
>  		else
> @@ -709,8 +709,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->eax = min(entry->eax, 0x8000001f);
>  		break;
>  	case 0x80000001:
> -		cpuid_entry_mask(entry, CPUID_8000_0001_EDX);
> -		cpuid_entry_mask(entry, CPUID_8000_0001_ECX);
> +		cpuid_entry_override(entry, CPUID_8000_0001_EDX);
> +		cpuid_entry_override(entry, CPUID_8000_0001_ECX);
>  		break;
>  	case 0x80000007: /* Advanced power management */
>  		/* invariant TSC is CPUID.80000007H:EDX[8] */
> @@ -728,7 +728,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  			g_phys_as = phys_as;
>  		entry->eax = g_phys_as | (virt_as << 8);
>  		entry->edx = 0;
> -		cpuid_entry_mask(entry, CPUID_8000_0008_EBX);
> +		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
>  		/*
>  		 * AMD has separate bits for each SPEC_CTRL bit.
>  		 * arch/x86/kernel/cpu/bugs.c is kind enough to
> @@ -770,7 +770,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->eax = min(entry->eax, 0xC0000004);
>  		break;
>  	case 0xC0000001:
> -		cpuid_entry_mask(entry, CPUID_C000_0001_EDX);
> +		cpuid_entry_override(entry, CPUID_C000_0001_EDX);
>  		break;
>  	case 3: /* Processor serial number */
>  	case 5: /* MONITOR/MWAIT */

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

