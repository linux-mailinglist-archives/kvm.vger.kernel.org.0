Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE49D30EE4A
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 09:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbhBDI0a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 03:26:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233305AbhBDI01 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 03:26:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612427101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Agalob5eH11KcCncI5ANijYagbVsZf9dz5lRtY7dI2Y=;
        b=cG2cveMPpKkTn2WC2YD7inU1nnphvPKaufkRjuXwft8V/TtVRZkhjoLXmUq+6QqC4tqB6n
        CfzQWudzZSg5hJIIrKhiq1wJntc8VUXlXhPIlQIG50usVF4aqNbYoq/fe3vFLKJtFem2h6
        vGSdqIjQwYDS3JFJc79ABsGdovuOMMk=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-CtIphCOMOXqdgEhcPN57og-1; Thu, 04 Feb 2021 03:24:59 -0500
X-MC-Unique: CtIphCOMOXqdgEhcPN57og-1
Received: by mail-ej1-f70.google.com with SMTP id aq28so2025517ejc.20
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 00:24:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Agalob5eH11KcCncI5ANijYagbVsZf9dz5lRtY7dI2Y=;
        b=tk+QZF1whXK8cAOGZKL5bCeQkT/3o+yLq1YlqNbvMwBps6pzB7Kx1+6tEaKigD/pW1
         Aw2c3/Uk5BnTOiK0TiwLZfTcRCtQkpgEgUafOjsY/S76tAhkjP0YOr+IZdvZYvbN1pZm
         MW7IpYfWxFqYVsQFRX1kRsxvIOkLJMPIyuxZGOdWZgdJwQYs8C1oHbHFkcQLJc0usj83
         wUvq3zQkoKOUFSFfMcuPeHbtiJnW/XC9587zFpI9KdYke+JbB1XUNEEEA75MQVbSxECD
         eAHlu9Ttdvbq2UuL5FDGFpIW8N8O+CioWK76nnTr5xIdNfRInFBc5r1Hxg4ZTJaAPD14
         PFyA==
X-Gm-Message-State: AOAM531AraqC3XiRqyE9TU4i91SftuXMU5W5HbYcE+YI7p7RND8UQaui
        ThkDrj8QCkXl4Qhtt+Q3111U7V1boXZLKC1bTvnLdvP931fueYoOfDwcFXrR5NWY5vzwYyBcv1S
        Kbb9hLuQabr6A
X-Received: by 2002:a17:906:2583:: with SMTP id m3mr6857471ejb.499.1612427097592;
        Thu, 04 Feb 2021 00:24:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzkBsKd0x1+29QtLLCUtiLfJ0rT3W7EMCqt70rGR6r6kWVYSj6J+x9/P+2cL4zFLhIyoC3J/w==
X-Received: by 2002:a17:906:2583:: with SMTP id m3mr6857462ejb.499.1612427097363;
        Thu, 04 Feb 2021 00:24:57 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x25sm1776375ejc.33.2021.02.04.00.24.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 00:24:56 -0800 (PST)
Subject: Re: [PATCH v15 04/14] KVM: x86: Add #CP support in guest exception
 dispatch
To:     Sean Christopherson <seanjc@google.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Cc:     jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yu.c.zhang@linux.intel.com
References: <20210203113421.5759-1-weijiang.yang@intel.com>
 <20210203113421.5759-5-weijiang.yang@intel.com> <YBsZwvwhshw+s7yQ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5b822165-9eff-bfa9-000f-ae51add59320@redhat.com>
Date:   Thu, 4 Feb 2021 09:24:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBsZwvwhshw+s7yQ@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/02/21 22:46, Sean Christopherson wrote:
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index dbca1687ae8e..0b6dab6915a3 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2811,7 +2811,7 @@ static int nested_check_vm_entry_controls(struct kvm_vcpu *vcpu,
>                 /* VM-entry interruption-info field: deliver error code */
>                 should_have_error_code =
>                         intr_type == INTR_TYPE_HARD_EXCEPTION && prot_mode &&
> -                       x86_exception_has_error_code(vector);
> +                       x86_exception_has_error_code(vcpu, vector);
>                 if (CC(has_error_code != should_have_error_code))
>                         return -EINVAL;
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 28fea7ff7a86..0288d6a364bd 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -437,17 +437,20 @@ EXPORT_SYMBOL_GPL(kvm_spurious_fault);
>  #define EXCPT_CONTRIBUTORY     1
>  #define EXCPT_PF               2
> 
> -static int exception_class(int vector)
> +static int exception_class(struct kvm_vcpu *vcpu, int vector)
>  {
>         switch (vector) {
>         case PF_VECTOR:
>                 return EXCPT_PF;
> +       case CP_VECTOR:
> +               if (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET)
> +                       return EXCPT_BENIGN;
> +               return EXCPT_CONTRIBUTORY;
>         case DE_VECTOR:
>         case TS_VECTOR:
>         case NP_VECTOR:
>         case SS_VECTOR:
>         case GP_VECTOR:
> -       case CP_VECTOR:
>                 return EXCPT_CONTRIBUTORY;
>         default:
>                 break;
> @@ -588,8 +591,8 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
>                 kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
>                 return;
>         }
> -       class1 = exception_class(prev_nr);
> -       class2 = exception_class(nr);
> +       class1 = exception_class(vcpu, prev_nr);
> +       class2 = exception_class(vcpu, nr);
>         if ((class1 == EXCPT_CONTRIBUTORY && class2 == EXCPT_CONTRIBUTORY)
>                 || (class1 == EXCPT_PF && class2 != EXCPT_BENIGN)) {
>                 /*
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index a14da36a30ed..dce756ffb577 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -120,12 +120,16 @@ static inline bool is_la57_mode(struct kvm_vcpu *vcpu)
>  #endif
>  }
> 
> -static inline bool x86_exception_has_error_code(unsigned int vector)
> +static inline bool x86_exception_has_error_code(struct kvm_vcpu *vcpu,
> +                                               unsigned int vector)
>  {
>         static u32 exception_has_error_code = BIT(DF_VECTOR) | BIT(TS_VECTOR) |
>                         BIT(NP_VECTOR) | BIT(SS_VECTOR) | BIT(GP_VECTOR) |
>                         BIT(PF_VECTOR) | BIT(AC_VECTOR) | BIT(CP_VECTOR);
> 
> +       if (vector == CP_VECTOR && (vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET))
> +               return false;
> +
>         return (1U << vector) & exception_has_error_code;
>  }
> 
> 
> 
> 

Squashed, thanks.  I made a small change to the last hunk:

         if (!((1U << vector) & exception_has_error_code))
                 return false;

         if (vector == CP_VECTOR)
                 return !(vcpu->arch.cr4_guest_rsvd_bits & X86_CR4_CET);

         return true;

