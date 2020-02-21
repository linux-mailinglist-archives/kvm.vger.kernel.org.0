Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D841681F1
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgBUPj3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:39:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20031 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727312AbgBUPj2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 10:39:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582299567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=o8eNL5pHSEEGDRXTPvdnZ+0kgLl4XLPDpXvj6Khj+a0=;
        b=XZnp/lua9xBAG7oXd9WtXB2BVVawZ7SP3tQ+RNi9REU3EBNNXBZEVIGtbco8IW24lkHv8J
        obxgBPfV3+eDHAZVyJ/VqZn5E1XRUHZIkm1LGX9a9flswMOODfZvinOcjoHiGLOT8cnsDG
        ZBqdKYxYz0FEd/oczES34Do9x0g/rfk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-BiXYNkvFM6-oVP1ApHqoEw-1; Fri, 21 Feb 2020 10:39:25 -0500
X-MC-Unique: BiXYNkvFM6-oVP1ApHqoEw-1
Received: by mail-wr1-f71.google.com with SMTP id p8so1186168wrw.5
        for <kvm@vger.kernel.org>; Fri, 21 Feb 2020 07:39:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=o8eNL5pHSEEGDRXTPvdnZ+0kgLl4XLPDpXvj6Khj+a0=;
        b=P8ONZP3eOjmJARixW1GApcX+WicDzWCoZO9nMCjN1/Tbz/rC3qvaj6K/ydZG0PK5BI
         sjl08cV7tYq0LJ/PjLR9fSRzAQdxVi4SfITD2acjnQuXYKfHtQ0OrfLoIqGbxGrIePUa
         4RIMc0QEMFcrO2vH/qsn8ceiO1hkl0RSUzWhZGeoJQbK9yCffTUJRK5IAcEeD3S1h/5P
         sIZHF76T2rdey1B1u484yU1rRxPbNKC1C7PWNNdWGHl8TF6F/1ffj3NZBHP6mlpHnP0P
         r76Iw0ropkPjGStULRM2XpUUBhuSrwRUFfmCg9yKFSDkiaQUwpc/GHIthwR4TL+5fd5k
         ktpQ==
X-Gm-Message-State: APjAAAW0UrsLvH53wi5BW2SO6zz8HytKbj4sfcJ9JalTRFZX5jPAPEZg
        gJw4kk2KJ9OfqcERG0+aKC/G7jG0rSqq9v9E2C+FWaHrDxtJMfxnBJ/OVAZu/pMTxfLFwR4KgnY
        pp/VKUMd2ujRB
X-Received: by 2002:adf:cd91:: with SMTP id q17mr49975314wrj.306.1582299564409;
        Fri, 21 Feb 2020 07:39:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqzr4F9d46+i3gYzMKNjyyzFiTVMMNlK43Z08VINv7Bk6pLxSJAJ8bWgIQKaxG7GLSB02rXS9w==
X-Received: by 2002:adf:cd91:: with SMTP id q17mr49975298wrj.306.1582299564176;
        Fri, 21 Feb 2020 07:39:24 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a135sm3948958wme.47.2020.02.21.07.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:39:23 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 24/61] KVM: x86: Drop explicit @func param from ->set_supported_cpuid()
In-Reply-To: <20200201185218.24473-25-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-25-sean.j.christopherson@intel.com>
Date:   Fri, 21 Feb 2020 16:39:22 +0100
Message-ID: <87blpsq79x.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Drop the explicit @func param from ->set_supported_cpuid() and instead
> pull the CPUID function from the relevant entry.  This sets the stage
> for hardening guest CPUID updates in future patches, e.g. allows adding
> run-time assertions that the CPUID feature being changed is actually
> a bit in the referenced CPUID entry.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 2 +-
>  arch/x86/kvm/cpuid.c            | 2 +-
>  arch/x86/kvm/svm.c              | 4 ++--
>  arch/x86/kvm/vmx/vmx.c          | 4 ++--
>  4 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 85f0d96cfeb2..a61928d5435b 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1148,7 +1148,7 @@ struct kvm_x86_ops {
>  
>  	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
>  
> -	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
> +	void (*set_supported_cpuid)(struct kvm_cpuid_entry2 *entry);
>  
>  	bool (*has_wbinvd_exit)(void);
>  
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 056faf27b14b..e3026fe638aa 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -784,7 +784,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		break;
>  	}
>  
> -	kvm_x86_ops->set_supported_cpuid(function, entry);
> +	kvm_x86_ops->set_supported_cpuid(entry);
>  
>  	r = 0;
>  
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 3c7ddaff405d..535eb746fb0f 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -6032,9 +6032,9 @@ static void svm_cpuid_update(struct kvm_vcpu *vcpu)
>  
>  #define F feature_bit
>  
> -static void svm_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> +static void svm_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  {
> -	switch (func) {
> +	switch (entry->function) {
>  	case 0x1:
>  		if (avic)
>  			entry->ecx &= ~F(X2APIC);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 98fd651f7f7e..3ff830e2258e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7104,9 +7104,9 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  	}
>  }
>  
> -static void vmx_set_supported_cpuid(u32 func, struct kvm_cpuid_entry2 *entry)
> +static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  {
> -	if (func == 1 && nested)
> +	if (entry->function == 1 && nested)
>  		entry->ecx |= feature_bit(VMX);
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

