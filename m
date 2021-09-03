Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03811400251
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 17:30:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349658AbhICPbD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 11:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349599AbhICPbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 11:31:02 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0767C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 08:30:02 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 17so5877122pgp.4
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 08:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LHKYiZn1enaTL529IiH4EK/EtyfMkn7nwZWISrjiVhY=;
        b=M1hmIwSk2NFKnJOJ4Vgu+iHShzORT6dJIsRIp8JdNkhiOnx2AJdQ1bkLFvHmd8erXR
         KkANKbXwH/nLCgfjJR+XdN4Jcz7MNqpUzimseDcRtOhZ1dRfny7IUbMDN5inYeqVeSIf
         SFZ+Bn9jZYos1uBn7NfjX+9IVYRANzhTkx/CkkBbPMZ/PBTYfC6m7LCrUXZLfytVM1ZE
         bLYhwqg93Sn4s3Dv4Qu8R6gz96gztgR9EaYlTl1E4ZXcpjy73MQtMev4u0mXTg0cqNAp
         cehbFesspteHPSp9wOB8WwJZ+ucJqg3z7PQbmAIbsBMxBb49ku5JDs226YWY7WOPbaVs
         Q4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LHKYiZn1enaTL529IiH4EK/EtyfMkn7nwZWISrjiVhY=;
        b=J+CLgWZMnepjwwBARrQnxo0wkyKkZdJJxQw/8jSgdyOYYf29aeNqia8e81/7FW0pyI
         FeUGAROYmFdytDkTsOJQyRxAaFtlps8wsrv1pyqd1AMAslHNhGM520DgE4gwqsHoiC9s
         2JmE4SnelQ/oDeYitwvJidQq8CVCCIo7T+CnCLsdO+QO50Y/Xbrjq45s9l3HaTmzB4eU
         nLj2fB9MNMBLt+i6m6/2PLh0HQBSRlHFuxpe+rvbtM0/6a3C1LxNIC/5n+byRsrKDGO4
         eRuXQ8aOXGi9Wb2PTw5KexEmMFerKc0P0mav4e1aVNktAywbVTbLxrgZ6twlH6tBF/rd
         /b0Q==
X-Gm-Message-State: AOAM533f5xJKj+e4TkB4vK1N1VlfcFpAoNzi+jyR7viypLdunlj7qwoe
        MFGb+ZeOzdMn416+5vUEdZt3IQ==
X-Google-Smtp-Source: ABdhPJwMBaYVLR8cXvB6Z+9aj4+MXUcCaIeCuQlghLG74c5rWCjeRc3NgQRo85XQweiL3iOtRfcUEg==
X-Received: by 2002:a65:6a46:: with SMTP id o6mr4043496pgu.139.1630683002030;
        Fri, 03 Sep 2021 08:30:02 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h7sm619948pfe.125.2021.09.03.08.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 08:30:01 -0700 (PDT)
Date:   Fri, 3 Sep 2021 15:29:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tony Luck <tony.luck@intel.com>, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Declare sgx_set_attribute() for !CONFIG_X86_SGX
Message-ID: <YTI/dTORBZEmGgux@google.com>
References: <20210903064156.387979-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903064156.387979-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021, Jarkko Sakkinen wrote:
> Simplify sgx_set_attribute() usage by declaring a fallback
> implementation for it rather than requiring to have compilation
> flag checks in the call site. The fallback unconditionally returns
> -EINVAL.
> 
> Refactor the call site in kvm_vm_ioctl_enable_cap() accordingly.
> The net result is the same: KVM_CAP_SGX_ATTRIBUTE causes -EINVAL
> when kernel is compiled without CONFIG_X86_SGX_KVM.

Eh, it doesn't really simplify the usage.  If anything it makes it more convoluted
because the capability check in kvm_vm_ioctl_check_extension() still needs an
#ifdef, e.g. readers will wonder why the check is conditional but the usage is not.

> Cc: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  arch/x86/include/asm/sgx.h | 8 ++++++++
>  arch/x86/kvm/x86.c         | 2 --
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 05f3e21f01a7..31ee106c0f4b 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -372,7 +372,15 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
>  		   void __user *secs, u64 *lepubkeyhash, int *trapnr);
>  #endif
>  
> +#ifdef CONFIG_X86_SGX
>  int sgx_set_attribute(unsigned long *allowed_attributes,
>  		      unsigned int attribute_fd);
> +#else
> +static inline int sgx_set_attribute(unsigned long *allowed_attributes,
> +				    unsigned int attribute_fd)
> +{
> +	return -EINVAL;
> +}
> +#endif
>  
>  #endif /* _ASM_X86_SGX_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5d5c5ed7dd4..a6a27a8f41eb 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5633,7 +5633,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			kvm->arch.bus_lock_detection_enabled = true;
>  		r = 0;
>  		break;
> -#ifdef CONFIG_X86_SGX_KVM
>  	case KVM_CAP_SGX_ATTRIBUTE: {
>  		unsigned long allowed_attributes = 0;
>  
> @@ -5649,7 +5648,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  			r = -EINVAL;
>  		break;
>  	}
> -#endif
>  	case KVM_CAP_VM_COPY_ENC_CONTEXT_FROM:
>  		r = -EINVAL;
>  		if (kvm_x86_ops.vm_copy_enc_context_from)
> -- 
> 2.25.1
> 
