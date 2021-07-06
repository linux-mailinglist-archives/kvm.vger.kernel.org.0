Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EBE3BD855
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbhGFOhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:37:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30437 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232244AbhGFOhl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:37:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HgpykafpViSKKg/vT0c+K8niR3uhRG40sTK1NxePChg=;
        b=OK/vLpwgFh8VsPP9lT8xi02bPe+Sq3PShK6Gnj9Jc9J/VLHIfMxJl6aRgExNCdAPUNfTFM
        FFwKyTTiXSVKHTiec5dyzv4sYZO6ugcDy6YURGHgHatxsesqk8zLgLzqJAkYLqcAl3YUlS
        FqXPmckVFM2pKenOba4xriOqdawsKpQ=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-JX13Ib2eNDOqRLyARGqqhg-1; Tue, 06 Jul 2021 10:17:58 -0400
X-MC-Unique: JX13Ib2eNDOqRLyARGqqhg-1
Received: by mail-ed1-f71.google.com with SMTP id m21-20020a50ef150000b029039c013d5b80so741175eds.7
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:17:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HgpykafpViSKKg/vT0c+K8niR3uhRG40sTK1NxePChg=;
        b=m6Fk6Hhej44jmMxTrakHuUgSJc9qe4qk1e7TFYRIEvd15PMcJFZkSeMHn/WltZk+/i
         DDekdkJlnufzYAKf8nd+WnB1Lv6ZP2bDjgTUoxVBGEH2ojlJ76zUWuLMED4YGhFHchup
         HClKgWDpLAtaRkVr/r6wwMBnhnV/W7QqBZLr23La93DaaPVlYlVakxixkwKLmm4Egfa5
         /B008lnGtTROG8KjU6BPdXxPmO90x7nx8jlyvg5xtquI5KgxJo1AODCfsiBhT54PpQMF
         YBT3oDwQicf9J4qCXJpbrUqF6hBNYW1EjeleiiLFlGgBVB/Y7N4ByG/LbgZwG/QJnvpt
         fjgA==
X-Gm-Message-State: AOAM533JABHrwpGZmaMnXVemXWQfJuccOyStJDzgSicf9P6IjnFxMNkb
        JOY7p0Ry04inwRW4I0DZ8hL7jH4L4mTCLrwgqbbNwTefv840MCU91SPysmmFj0SO3DgmPqDGX1K
        0O/0vv4zLwfnV
X-Received: by 2002:a17:907:3f93:: with SMTP id hr19mr5978918ejc.174.1625581077640;
        Tue, 06 Jul 2021 07:17:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxP8Cjndmhd1l2fvfJwWimt9VGxUlRqCL0hmiWaSy8opx1DXsrM7zvmzJ1dfy99qJTnxD2Gog==
X-Received: by 2002:a17:907:3f93:: with SMTP id hr19mr5978899ejc.174.1625581077455;
        Tue, 06 Jul 2021 07:17:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id rp5sm4136176ejb.63.2021.07.06.07.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:17:56 -0700 (PDT)
Subject: Re: [RFC PATCH v2 63/69] KVM: VMX: Move .get_interrupt_shadow()
 implementation to common VMX code
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <11a3389da6184785b238b0d5a7f60279aa0a93b1.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3343767a-f7b3-715b-8d99-9821a458a708@redhat.com>
Date:   Tue, 6 Jul 2021 16:17:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <11a3389da6184785b238b0d5a7f60279aa0a93b1.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:05, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/common.h | 14 ++++++++++++++
>   arch/x86/kvm/vmx/vmx.c    | 10 +---------
>   2 files changed, 15 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 755aaec85199..817ff3e74933 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -120,6 +120,20 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
>   	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>   }
>   
> +static inline u32 __vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
> +{
> +	u32 interruptibility;
> +	int ret = 0;
> +
> +	interruptibility = vmread32(vcpu, GUEST_INTERRUPTIBILITY_INFO);
> +	if (interruptibility & GUEST_INTR_STATE_STI)
> +		ret |= KVM_X86_SHADOW_INT_STI;
> +	if (interruptibility & GUEST_INTR_STATE_MOV_SS)
> +		ret |= KVM_X86_SHADOW_INT_MOV_SS;
> +
> +	return ret;
> +}
> +
>   static inline u32 vmx_encode_ar_bytes(struct kvm_segment *var)
>   {
>   	u32 ar;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d69d4dc7c071..d31cace67907 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1467,15 +1467,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
>   
>   u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
>   {
> -	u32 interruptibility = vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
> -	int ret = 0;
> -
> -	if (interruptibility & GUEST_INTR_STATE_STI)
> -		ret |= KVM_X86_SHADOW_INT_STI;
> -	if (interruptibility & GUEST_INTR_STATE_MOV_SS)
> -		ret |= KVM_X86_SHADOW_INT_MOV_SS;
> -
> -	return ret;
> +	return __vmx_get_interrupt_shadow(vcpu);
>   }
>   
>   void vmx_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
> 

Is there any reason to add the __ version, since at this point 
kvm_x86_ops is already pointing to vt_get_interrupt_shadow?

Paolo

