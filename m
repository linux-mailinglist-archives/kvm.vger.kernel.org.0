Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4E7449A95
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 18:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241434AbhKHRQa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 12:16:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240556AbhKHRQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 12:16:29 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35811C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 09:13:45 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id e65so15723766pgc.5
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 09:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UVBRwM2ywmCSM5TwIcqwKRvKzslFcfi0YeZ+8cTRmV0=;
        b=NX+ve8Dn5OA9eOLlStVTIVoE5zibeGgWI5YaJs3GJWXIQjzmt9eFAuSj1s+NeqfqrI
         1ZLUBgoGU/uSPjO1Up+zpKGsLYXGki1f+eJ3MntR+gS7e5ksRjULfJ/Drj+daopgt8wt
         ZNKBUc50MSPmzD8O/MgEyXuoiMjjMf+T/S4pXF2UXo0ABTN7kTYUe/DnZehztKXDDI29
         q6HZZbqmrU71x3OwzSJR43f/HN9UtzxNCbXkz6KnKBo8c3vvIauf2z6Fuy5W5huwwtep
         IvT7OSv/saYA2MnSPKDOogW7sX/CNg6v9IK2BnpB+fc2177J4K0h7N/SP9tUbMdRI21K
         U2aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UVBRwM2ywmCSM5TwIcqwKRvKzslFcfi0YeZ+8cTRmV0=;
        b=HRr97GPYvM6wkdGKkxjzp/s8sTcImFlsNUzKRDUBR6801EAqpahrNNyDJUOC+K8v8s
         Oi021RZsSlR2wFcFe1qYRjqCYoe6wFWywTf2KSKVIKKeuCfJ32qlvpqjqcXFXOtwYUq+
         JQOdRgOl1hYX1zREMjq/CRj//oyrEl1KoXz8S/DgSVN+tcMZdGn1Hk+PtsTvfXj5kWEz
         fBnECEG5WvcQRxeWXIM6ijYrEuXjx1sllUX8Iw5O+YnNBqZyVFTeGyFneLtyvyqITUxN
         5u1q5163WCVCnadI2MGRjx0Po7Ol7s7mksgeU3zJfeviCZ6HI56VJyW8jIwL8ETutUIX
         bDOQ==
X-Gm-Message-State: AOAM532ZcjNPSzpjrD2O2TweNGc0ZO3snGPoXqxSRdtty59VuWrl0+oR
        tEx9vXnUmey6+VODAQTVXq7TMg==
X-Google-Smtp-Source: ABdhPJxwT8IV8PF5RHJgKjcEdkyOSI67ELP/ghLY1sgbRlnMe/Y/rEztbFjItedVZKuU/VcWzFtaAw==
X-Received: by 2002:a63:db4d:: with SMTP id x13mr705077pgi.147.1636391624426;
        Mon, 08 Nov 2021 09:13:44 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d7sm17344672pfj.91.2021.11.08.09.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 09:13:43 -0800 (PST)
Date:   Mon, 8 Nov 2021 17:13:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/7] KVM: VMX: Add proper cache tracking for PKRS
Message-ID: <YYlaw6v6GOgFUQ/Z@google.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
 <20210811101126.8973-3-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811101126.8973-3-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021, Chenyi Qiang wrote:
> Add PKRS caching into the standard register caching mechanism in order
> to take advantage of the availability checks provided by regs_avail.
> 
> This is because vcpu->arch.pkrs will be rarely acceesed by KVM, only in
> the case of host userspace MSR reads and GVA->GPA translation in
> following patches. It is unnecessary to keep it up-to-date at all times.
> 
> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 ++
>  arch/x86/kvm/kvm_cache_regs.h   | 7 +++++++
>  arch/x86/kvm/vmx/vmx.c          | 4 ++++
>  arch/x86/kvm/vmx/vmx.h          | 3 ++-
>  4 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 974cbfb1eefe..c2bcb88781b3 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -173,6 +173,7 @@ enum kvm_reg {
>  	VCPU_EXREG_SEGMENTS,
>  	VCPU_EXREG_EXIT_INFO_1,
>  	VCPU_EXREG_EXIT_INFO_2,
> +	VCPU_EXREG_PKRS,
>  };
>  
>  enum {
> @@ -620,6 +621,7 @@ struct kvm_vcpu_arch {
>  	unsigned long cr8;
>  	u32 host_pkru;
>  	u32 pkru;
> +	u32 pkrs;
>  	u32 hflags;
>  	u64 efer;
>  	u64 apic_base;
> diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
> index 90e1ffdc05b7..da014b1be874 100644
> --- a/arch/x86/kvm/kvm_cache_regs.h
> +++ b/arch/x86/kvm/kvm_cache_regs.h
> @@ -171,6 +171,13 @@ static inline u64 kvm_read_edx_eax(struct kvm_vcpu *vcpu)
>  		| ((u64)(kvm_rdx_read(vcpu) & -1u) << 32);
>  }
>  
> +static inline ulong kvm_read_pkrs(struct kvm_vcpu *vcpu)

Return value should be u32 (or u64 if we decide to track PKRS as a 64-bit value).

> +{
> +	if (!kvm_register_is_available(vcpu, VCPU_EXREG_PKRS))
> +		static_call(kvm_x86_cache_reg)(vcpu, VCPU_EXREG_PKRS);
> +	return vcpu->arch.pkrs;
> +}
> +
>  static inline void enter_guest_mode(struct kvm_vcpu *vcpu)
>  {
>  	vcpu->arch.hflags |= HF_GUEST_MASK;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 927a552393b9..bf911029aa35 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2273,6 +2273,10 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
>  		vcpu->arch.cr4 &= ~guest_owned_bits;
>  		vcpu->arch.cr4 |= vmcs_readl(GUEST_CR4) & guest_owned_bits;
>  		break;
> +	case VCPU_EXREG_PKRS:
> +		if (kvm_cpu_cap_has(X86_FEATURE_PKS))

Peeking ahead, the next patch rejects RDMSR(MSR_IA32_PKRS) if X86_FEATURE_PKS isn't
supported in KVM, i.e. this is WARN-worthy as KVM should PKRS if and only if PKS is
supported.  Since KVM will WARN if VMREAD fails, just omit this check and let VMREAD
handle any errors.  That won't detect the scenario where PKRS is supported in hardware
but disabled by the kernel/KVM, but that's an acceptable risk since any buggy path is
all but guaranteed to be reachable if PKRS isn't supported at all, i.e. the WARN will
fire and detect any bug in the more common case.

> +			vcpu->arch.pkrs = vmcs_read64(GUEST_IA32_PKRS);

Hrm.  I agree that it's extremely unlikely that IA32_PKRS will ever allow software
to set bits 63:32, but at the same time there's no real advantage to KVM it as a u32,
e.g. the extra 4 bytes per vCPU is a non-issue, and could be avoided by shuffling
kvm_vcpu_arch to get a more efficient layout.  On the flip side, using a 32 means
code like this _looks_ buggy because it's silently dropping bits 63:32, and if the
architecture ever does get updated, we'll have to modify a bunch of KVM code.

TL;DR: I vote to track PRKS as a u64 even though the kernel tracks it as a u32.

> +		break;
>  	default:
>  		WARN_ON_ONCE(1);
>  		break;
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index db88ed4f2121..18039eb6efb0 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -447,7 +447,8 @@ static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
>  				  | (1 << VCPU_EXREG_CR3)
>  				  | (1 << VCPU_EXREG_CR4)
>  				  | (1 << VCPU_EXREG_EXIT_INFO_1)
> -				  | (1 << VCPU_EXREG_EXIT_INFO_2));
> +				  | (1 << VCPU_EXREG_EXIT_INFO_2)
> +				  | (1 << VCPU_EXREG_PKRS));
>  	vcpu->arch.regs_dirty = 0;
>  }
>  
> -- 
> 2.17.1
> 
