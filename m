Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6124D3A2CB8
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 15:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhFJNTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 09:19:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57618 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230230AbhFJNTv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 09:19:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623331074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2vhwrSihqYGYlZtWkj0lmFHHyDYSDD2eRXKiN4Cbrfk=;
        b=VLzMajAAniA+pILqswpA2KbYIGDtQoEOqasAiQZNISK50irY3FJlrBigqhLY9O/i5pF39a
        21qWsPrHhkInvD3S3Jnuvn+ArkKKEUdwdz3mpWi4KZNvR29qp7QppyvqOxrvYeYFF157DV
        NMcL1Rvvkht9uixHUo1zR1+5EFx9gxM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-y3gt-QdRNSOCJNnYgnAubQ-1; Thu, 10 Jun 2021 09:17:54 -0400
X-MC-Unique: y3gt-QdRNSOCJNnYgnAubQ-1
Received: by mail-wr1-f69.google.com with SMTP id u20-20020a0560001614b02901115c8f2d89so886622wrb.3
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 06:17:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2vhwrSihqYGYlZtWkj0lmFHHyDYSDD2eRXKiN4Cbrfk=;
        b=EEbparrRYmX0Jxn0nXnivjzVV8FadBkalJv9TrM3kcbFMfRX6kNqH/WjEZhjPb9/uL
         YHZUBthfPzbVL/irllexyTFskmRSXhXz2ryojnqTSpLx8Pm1DXZmEdsteybE3G5bIMEL
         D4UZBg7IFpq929EsReBLrOmDiXx1h+oQRAm51YMSZvHzS3sb8AByTcgWOf+jlJBzCVEc
         vrUXZHOCbNSEj2foUgDt1ue5QCtGb5PQ4tqPKLb1IC/5MNjPPlCtI2r4XzwnUnljeSED
         6KPwFk3TpekW4OcheBlGxhCwi8BqeZLE9ZIQstIP7Pr9rIy7UCmkg0XNHCo6wFmar9ca
         CtWQ==
X-Gm-Message-State: AOAM5338yjH2nJZh5U2yC5hl0ek1yyKbcqMjaPBAcWzey7GelMEcq1wb
        /X2svYp7RBui5fpCipAwgMqrcKGS/0zT7y8/qCt7IpNX7wQwhnEN0vpP2+qrn8T2hLymUv7Hlrj
        B31p3wTucwU4v
X-Received: by 2002:a1c:8049:: with SMTP id b70mr15194430wmd.92.1623331071710;
        Thu, 10 Jun 2021 06:17:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwai67ZmGIuLcM8D3JLrIJ6iLINKS7wlLj72Wj1UXjrhg2b3r/kxh90Z5EmW2t3rJkD6b1ytA==
X-Received: by 2002:a1c:8049:: with SMTP id b70mr15194406wmd.92.1623331071487;
        Thu, 10 Jun 2021 06:17:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id s5sm1667254wrn.38.2021.06.10.06.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 06:17:50 -0700 (PDT)
Subject: Re: [PATCH v3 0/4] KVM: x86: hyper-v: Conditionally allow SynIC with
 APICv/AVIC
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org
References: <20210609150911.1471882-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <dea0b7f2-20ff-36c4-d020-18bff8bc58e0@redhat.com>
Date:   Thu, 10 Jun 2021 15:17:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210609150911.1471882-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/21 17:09, Vitaly Kuznetsov wrote:
> Changes since v2:
> - First two patches got merged, rebase.
> - Use 'enable_apicv = avic = ...' in PATCH1 [Paolo]
> - Collect R-b tags for PATCH2 [Sean, Max]
> - Use hv_apicv_update_work() to get out of SRCU lock [Max]
> - "KVM: x86: Check for pending interrupts when APICv is getting disabled"
>    added.
> 
> Original description:
> 
> APICV_INHIBIT_REASON_HYPERV is currently unconditionally forced upon
> SynIC activation as SynIC's AutoEOI is incompatible with APICv/AVIC. It is,
> however, possible to track whether the feature was actually used by the
> guest and only inhibit APICv/AVIC when needed.
> 
> The series can be tested with the followin hack:
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 9a48f138832d..65a9974f80d9 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -147,6 +147,13 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>                                             vcpu->arch.ia32_misc_enable_msr &
>                                             MSR_IA32_MISC_ENABLE_MWAIT);
>          }
> +
> +       /* Dirty hack: force HV_DEPRECATING_AEOI_RECOMMENDED. Not to be merged! */
> +       best = kvm_find_cpuid_entry(vcpu, HYPERV_CPUID_ENLIGHTMENT_INFO, 0);
> +       if (best) {
> +               best->eax &= ~HV_X64_APIC_ACCESS_RECOMMENDED;
> +               best->eax |= HV_DEPRECATING_AEOI_RECOMMENDED;
> +       }
>   }
>   EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
>   
> Vitaly Kuznetsov (4):
>    KVM: x86: Use common 'enable_apicv' variable for both APICv and AVIC
>    KVM: x86: Drop vendor specific functions for APICv/AVIC enablement
>    KVM: x86: Check for pending interrupts when APICv is getting disabled
>    KVM: x86: hyper-v: Deactivate APICv only when AutoEOI feature is in
>      use
> 
>   arch/x86/include/asm/kvm_host.h |  9 +++++-
>   arch/x86/kvm/hyperv.c           | 51 +++++++++++++++++++++++++++++----
>   arch/x86/kvm/svm/avic.c         | 14 ++++-----
>   arch/x86/kvm/svm/svm.c          | 22 ++++++++------
>   arch/x86/kvm/svm/svm.h          |  2 --
>   arch/x86/kvm/vmx/capabilities.h |  1 -
>   arch/x86/kvm/vmx/vmx.c          |  2 --
>   arch/x86/kvm/x86.c              | 18 ++++++++++--
>   8 files changed, 86 insertions(+), 33 deletions(-)
> 

Queued, thanks.

Paolo

