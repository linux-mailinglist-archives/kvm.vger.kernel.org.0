Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1783582D9
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 14:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhDHMGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 08:06:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53806 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231255AbhDHMGK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 08:06:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617883559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eWJUzLuz50FUt+ImUQDHaMIAG0aReYXQygXZr8zlKMM=;
        b=BFSnrYhc2hBmkqMcX7oBR6lJsKmf+I41Qk0b6YygKErI7kVEeiPfOtPw24etWxsvI8Nwr6
        0m7Ov++UqsAkmwJxoVqBfLp52WswSJvlQeChJgU+DzSMxQ4pjAL9u6Ca3sndeXKhfO6Oy/
        tQOFYtQ4B5t+XzW1IC/s8Cn91LcVDmo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-VQYwxvvSPb6aawTBGSUxsQ-1; Thu, 08 Apr 2021 08:05:56 -0400
X-MC-Unique: VQYwxvvSPb6aawTBGSUxsQ-1
Received: by mail-ed1-f71.google.com with SMTP id f9so915391edd.13
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 05:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=eWJUzLuz50FUt+ImUQDHaMIAG0aReYXQygXZr8zlKMM=;
        b=dhUzUzCi3ImHMWHW2/BiuDbO7UlD1VDUGn2ObxlMsr/UOcV0MmqFUCTNTgij3jHKIp
         W02N6Jv3BljUGDbS1Ywn1MsgXDoC4EdEMXX+dHCUHk0f/k77e0tXyDKJaLi1wS7bIW8/
         5oPwS5ndevezPa/kSjywLiCNpFVdV+TQFsyTvtoy5AOL8fSQfwTjE4jddNiFy7e/YVFP
         egryP7aLZYhTxj5f3FnoA41S5Qpndlr6Oa40IVqTki5J4DjPnWWRY2cxEJMPxEkmJlZb
         cl7lXZ6xAwoEmNWLvUhltPEQU7ujlF13UNVXcXwex1y2xylBJlhEc/FGjzFRWYEjdfpY
         1XEw==
X-Gm-Message-State: AOAM531iEC5hfwFDmD+xZF/ISBzHLafJHNHk5AA91kxV/Qc/OwjEPyuN
        J2eUD+zblB8DFzmYan+EAa8PoxfffS9OPOp9cJb5eg+LpjOIqxwJmPXtzsErpggmHWPgj7kcMa1
        d8xVnbbytJ2uC
X-Received: by 2002:aa7:c983:: with SMTP id c3mr10931258edt.185.1617883555600;
        Thu, 08 Apr 2021 05:05:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwhkUm5kBzngNh7+NALwEQCBHQoPbgDTqKumZWUBoMFU98rV+GaTwHrgwr7jiW8o/TjTsGC5w==
X-Received: by 2002:aa7:c983:: with SMTP id c3mr10931236edt.185.1617883555399;
        Thu, 08 Apr 2021 05:05:55 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id gq9sm14465571ejb.62.2021.04.08.05.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 05:05:55 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Siddharth Chandrasekaran <sidcha@amazon.de>
Cc:     Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 4/4] KVM: hyper-v: Advertise support for fast XMM
 hypercalls
In-Reply-To: <20210407211954.32755-5-sidcha@amazon.de>
References: <20210407211954.32755-1-sidcha@amazon.de>
 <20210407211954.32755-5-sidcha@amazon.de>
Date:   Thu, 08 Apr 2021 14:05:53 +0200
Message-ID: <87blap7zha.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Siddharth Chandrasekaran <sidcha@amazon.de> writes:

> Now that all extant hypercalls that can use XMM registers (based on
> spec) for input/outputs are patched to support them, we can start
> advertising this feature to guests.
>
> Cc: Alexander Graf <graf@amazon.com>
> Cc: Evgeny Iakovlev <eyakovl@amazon.de>
> Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
> ---
>  arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
>  arch/x86/kvm/hyperv.c              | 1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
> index e6cd3fee562b..1f160ef60509 100644
> --- a/arch/x86/include/asm/hyperv-tlfs.h
> +++ b/arch/x86/include/asm/hyperv-tlfs.h
> @@ -49,10 +49,10 @@
>  /* Support for physical CPU dynamic partitioning events is available*/
>  #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE	BIT(3)
>  /*
> - * Support for passing hypercall input parameter block via XMM
> + * Support for passing hypercall input and output parameter block via XMM
>   * registers is available
>   */
> -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE		BIT(4)
> +#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE		BIT(4) | BIT(15)

TLFS 6.0b states that there are two distinct bits for input and output:

CPUID Leaf 0x40000003.EDX:
Bit 4: support for passing hypercall input via XMM registers is available.
Bit 15: support for returning hypercall output via XMM registers is available.

and HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE is not currently used
anywhere, I'd suggest we just rename 

HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE to HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE
and add HV_X64_HYPERCALL_XMM_OUTPUT_AVAILABLE (bit 15).

>  /* Support for a virtual guest idle state is available */
>  #define HV_X64_GUEST_IDLE_STATE_AVAILABLE		BIT(5)
>  /* Frequency MSRs available */
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index bf2f86f263f1..dd462c1d641d 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -2254,6 +2254,7 @@ int kvm_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  			ent->ebx |= HV_POST_MESSAGES;
>  			ent->ebx |= HV_SIGNAL_EVENTS;
>  
> +			ent->edx |= HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE;
>  			ent->edx |= HV_FEATURE_FREQUENCY_MSRS_AVAILABLE;
>  			ent->edx |= HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE;

-- 
Vitaly

