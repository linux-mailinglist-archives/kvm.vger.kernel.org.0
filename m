Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6089816A793
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 14:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgBXNtm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 08:49:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:27551 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727160AbgBXNtl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 24 Feb 2020 08:49:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582552180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tAQyvgVC9umTI3C0mE/08IO0Mq8UDdBPvvOVcWUX2u0=;
        b=JnmpdHX03d51JwRgVgy9uLW4FBdZCv4mWKNz6jfcWwoN//FFrrlvX2YLwkP4Ak6PHYFSbj
        ZAu2WdLcyzqKiZPmgICw4JBB2i2bfDk4j8sK41ncejwVN5GZH9r4uvcq0/oHao8pBGuoHR
        92tIyvMXWVH+f3DEmEXtZX/cQdehhnY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-dSALV6CsMnWUi8Uov3xt4w-1; Mon, 24 Feb 2020 08:49:36 -0500
X-MC-Unique: dSALV6CsMnWUi8Uov3xt4w-1
Received: by mail-wr1-f72.google.com with SMTP id c6so5603085wrm.18
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 05:49:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=tAQyvgVC9umTI3C0mE/08IO0Mq8UDdBPvvOVcWUX2u0=;
        b=SBDRSKm1z/w+MKyNTlwFnzNJSP4o47iAeehaIIsxdd+AmkylhudGbsP9Zsw7R9cptT
         svbYDOkaS4ypycbGq1VYtlHDXC/jWpszluUuWoQz8XMqqgtPjgZbCkjKo/LReW5SIJyT
         0UNZCeZRZiBiJJS8cRwRoqzdz5ssQFraTjXh2GFT0uuovre0Z+idITeWXA+rSSdbZaLz
         hC1J82vSycbgyAE60pToQQmXj3FcVw3Zv1pz1UD1A3Yq2r+c6CZCOxUcPyJPI/tH9Cuj
         S5+dDUTycynsFQqY9h8EtL83OtVLs7hOMUxXulaYeolaUrUC2r04WE74lpAL0iaStONM
         U2pQ==
X-Gm-Message-State: APjAAAVee5zimhIkmQUT0eVlQ25nXLheUtMhDi+5tEq6vA9KeHbGDYLd
        7IaetAyDYtargvoLftF9borKVKqzykmsFTFAwaoD5mKy5RNvXWd3/jjmEmyW7uhfiXY1Bj40LiP
        +eIfBg2RhuVHB
X-Received: by 2002:a5d:4a06:: with SMTP id m6mr67336206wrq.155.1582552175128;
        Mon, 24 Feb 2020 05:49:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqxdBw9gt33lYnR/XKzr9wDVBrAP8s0iq8iWevpyYhiw+9MMonU5wAHsUexqdA1oN+hOyWiseQ==
X-Received: by 2002:a5d:4a06:: with SMTP id m6mr67336184wrq.155.1582552174866;
        Mon, 24 Feb 2020 05:49:34 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t128sm19156199wmf.28.2020.02.24.05.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 05:49:34 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 28/61] KVM: x86: Refactor cpuid_mask() to auto-retrieve the register
In-Reply-To: <20200201185218.24473-29-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-29-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 14:49:33 +0100
Message-ID: <87d0a4p02a.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Use the recently introduced cpuid_entry_get_reg() to automatically get
> the appropriate register when masking a CPUID entry.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 195f4dcc8c6a..cb5870a323cc 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -254,10 +254,12 @@ int kvm_vcpu_ioctl_get_cpuid2(struct kvm_vcpu *vcpu,
>  	return r;
>  }
>  
> -static __always_inline void cpuid_mask(u32 *word, int wordnum)
> +static __always_inline void cpuid_entry_mask(struct kvm_cpuid_entry2 *entry,
> +					     enum cpuid_leafs leaf)
>  {
> -	reverse_cpuid_check(wordnum);
> -	*word &= boot_cpu_data.x86_capability[wordnum];
> +	u32 *reg = cpuid_entry_get_reg(entry, leaf * 32);
> +
> +	*reg &= boot_cpu_data.x86_capability[leaf];
>  }
>  
>  struct kvm_cpuid_array {
> @@ -373,13 +375,13 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  	case 0:
>  		entry->eax = min(entry->eax, 1u);
>  		entry->ebx &= kvm_cpuid_7_0_ebx_x86_features;
> -		cpuid_mask(&entry->ebx, CPUID_7_0_EBX);
> +		cpuid_entry_mask(entry, CPUID_7_0_EBX);
>  		/* TSC_ADJUST is emulated */
>  		cpuid_entry_set(entry, X86_FEATURE_TSC_ADJUST);
>  
>  		entry->ecx &= kvm_cpuid_7_0_ecx_x86_features;
>  		f_la57 = cpuid_entry_get(entry, X86_FEATURE_LA57);
> -		cpuid_mask(&entry->ecx, CPUID_7_ECX);
> +		cpuid_entry_mask(entry, CPUID_7_ECX);
>  		/* Set LA57 based on hardware capability. */
>  		entry->ecx |= f_la57;
>  		entry->ecx |= f_umip;
> @@ -389,7 +391,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  			cpuid_entry_clear(entry, X86_FEATURE_PKU);
>  
>  		entry->edx &= kvm_cpuid_7_0_edx_x86_features;
> -		cpuid_mask(&entry->edx, CPUID_7_EDX);
> +		cpuid_entry_mask(entry, CPUID_7_EDX);
>  		if (boot_cpu_has(X86_FEATURE_IBPB) && boot_cpu_has(X86_FEATURE_IBRS))
>  			cpuid_entry_set(entry, X86_FEATURE_SPEC_CTRL);
>  		if (boot_cpu_has(X86_FEATURE_STIBP))
> @@ -507,9 +509,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		break;
>  	case 1:
>  		entry->edx &= kvm_cpuid_1_edx_x86_features;
> -		cpuid_mask(&entry->edx, CPUID_1_EDX);
> +		cpuid_entry_mask(entry, CPUID_1_EDX);
>  		entry->ecx &= kvm_cpuid_1_ecx_x86_features;
> -		cpuid_mask(&entry->ecx, CPUID_1_ECX);
> +		cpuid_entry_mask(entry, CPUID_1_ECX);
>  		/* we support x2apic emulation even if host does not support
>  		 * it since we emulate x2apic in software */
>  		cpuid_entry_set(entry, X86_FEATURE_X2APIC);
> @@ -619,7 +621,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  			goto out;
>  
>  		entry->eax &= kvm_cpuid_D_1_eax_x86_features;
> -		cpuid_mask(&entry->eax, CPUID_D_1_EAX);
> +		cpuid_entry_mask(entry, CPUID_D_1_EAX);
>  		if (entry->eax & (F(XSAVES)|F(XSAVEC)))
>  			entry->ebx = xstate_required_size(supported_xcr0, true);
>  		else
> @@ -699,9 +701,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		break;
>  	case 0x80000001:
>  		entry->edx &= kvm_cpuid_8000_0001_edx_x86_features;
> -		cpuid_mask(&entry->edx, CPUID_8000_0001_EDX);
> +		cpuid_entry_mask(entry, CPUID_8000_0001_EDX);
>  		entry->ecx &= kvm_cpuid_8000_0001_ecx_x86_features;
> -		cpuid_mask(&entry->ecx, CPUID_8000_0001_ECX);
> +		cpuid_entry_mask(entry, CPUID_8000_0001_ECX);
>  		break;
>  	case 0x80000007: /* Advanced power management */
>  		/* invariant TSC is CPUID.80000007H:EDX[8] */
> @@ -720,7 +722,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->eax = g_phys_as | (virt_as << 8);
>  		entry->edx = 0;
>  		entry->ebx &= kvm_cpuid_8000_0008_ebx_x86_features;
> -		cpuid_mask(&entry->ebx, CPUID_8000_0008_EBX);
> +		cpuid_entry_mask(entry, CPUID_8000_0008_EBX);
>  		/*
>  		 * AMD has separate bits for each SPEC_CTRL bit.
>  		 * arch/x86/kernel/cpu/bugs.c is kind enough to
> @@ -763,7 +765,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		break;
>  	case 0xC0000001:
>  		entry->edx &= kvm_cpuid_C000_0001_edx_x86_features;
> -		cpuid_mask(&entry->edx, CPUID_C000_0001_EDX);
> +		cpuid_entry_mask(entry, CPUID_C000_0001_EDX);
>  		break;
>  	case 3: /* Processor serial number */
>  	case 5: /* MONITOR/MWAIT */


Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

