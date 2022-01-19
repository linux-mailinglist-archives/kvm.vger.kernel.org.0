Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B16493575
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 08:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346481AbiASHZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 02:25:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245723AbiASHZg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 02:25:36 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251C8C061574;
        Tue, 18 Jan 2022 23:25:36 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id s2-20020a17090ad48200b001b501977b23so483708pju.2;
        Tue, 18 Jan 2022 23:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=vfGaApu8wQmCPciFtkN6NAlobrxb1oXN8EoIi5l8GHQ=;
        b=QppLXnIWB7RadcAP+fi1YRTqLnzMr67TF9r3sq5WSGiN0VOcDfUeeRRYu8T4vFhmEo
         WHnD/3qhnFFJoascXBiYQLnqTKMK1k6onos0kS+o8pRCdErlbaD6KTxlG2BiricXI3mc
         3yU7nmr9lqJV+9kDKS7WdiMpEeWsxET4QC2NK/FCQeKJp66NmNTRWDhbsiV+F+5evnKa
         ATxu9MU6gA63cMGXuvTNOUa8xjQJpGdagYxkBwiThWxTWD+M9lU/RYmqPMy8yy8FotT0
         0Gj1Jp/GmpJLvVkvpsG7XUD6Aok+W9vra/WC98H4IKI3tLZbgaWriM8CN04hThkHT5z6
         1q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=vfGaApu8wQmCPciFtkN6NAlobrxb1oXN8EoIi5l8GHQ=;
        b=7CDRbz6/rbCQRcF/rLB/K7P0rMlYDVBJhhPu2Wmp/z/SGMVm9g6JPuGbtlrUXxijTU
         3FgHka+qleuAjXsNtTOfmxCPk6xnj1xEf/Ich7bHokwPOnSTXk1pchTctxijX0f4/Kbr
         Jqx2ExD2jW+/YdIMTeA29Hx/CDRM1spoXjilP/n8YSh5TMlhTfbP3CQdtYQk6NQ3Zazs
         +ic9ZpHssR6SP8l+F7Jf1LV7aoFp85gC0qPYiV3rZ5wVlXcF5XMKoWe26F5G41gCyU2g
         PxUhQm86l71FNKRB9Mc64uc8F7m15dLsnVzMtr7U4kNdPN/Egamu419yQ7qIOMbhWvO5
         M6UA==
X-Gm-Message-State: AOAM5316cAFOokp/96bF+e5MpdtiP/qWTbAwIu82nS+Ss7e0n6LA7zhY
        LENI6w4QPxGNxJX8xVq0IMsgGmtjFIB8zMzs
X-Google-Smtp-Source: ABdhPJxW/8NadmfPxqAtIs1ydmNWawR4Z0lXbnP3vjln6ZY4FIm+JyuhopJ00Gin+2IGL4v3kMt4FQ==
X-Received: by 2002:a17:90b:4c52:: with SMTP id np18mr2826931pjb.192.1642577135517;
        Tue, 18 Jan 2022 23:25:35 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id t126sm10541138pfd.143.2022.01.18.23.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 23:25:35 -0800 (PST)
Message-ID: <a847ba90-7f15-4e79-b42b-75be0d6cf9fe@gmail.com>
Date:   Wed, 19 Jan 2022 15:25:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86: Update the states size cpuid even if
 XCR0/IA32_XSS is reset
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220117082631.86143-1-likexu@tencent.com>
 <YecHK2DmooVlMr2U@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <YecHK2DmooVlMr2U@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/1/2022 2:30 am, Sean Christopherson wrote:
> On Mon, Jan 17, 2022, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> XCR0 is reset to 1 by RESET but not INIT and IA32_XSS is zeroed by
>> both RESET and INIT. In both cases, the size in bytes of the XSAVE
>> area containing all states enabled by XCR0 or (XCRO | IA32_XSS)
>> needs to be updated.
>>
>> Fixes: a554d207dc46 ("KVM: X86: Processor States following Reset or INIT")
>> Signed-off-by: Like Xu <likexu@tencent.com>
>> ---
>>   arch/x86/kvm/x86.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 76b4803dd3bd..5748a57e1cb7 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11134,6 +11134,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   	struct kvm_cpuid_entry2 *cpuid_0x1;
>>   	unsigned long old_cr0 = kvm_read_cr0(vcpu);
>>   	unsigned long new_cr0;
>> +	bool need_update_cpuid = false;
>>   
>>   	/*
>>   	 * Several of the "set" flows, e.g. ->set_cr0(), read other registers
>> @@ -11199,6 +11200,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   
>>   		vcpu->arch.msr_misc_features_enables = 0;
>>   
>> +		if (vcpu->arch.xcr0 != XFEATURE_MASK_FP)
>> +			need_update_cpuid = true;
>>   		vcpu->arch.xcr0 = XFEATURE_MASK_FP;
>>   	}
>>   
>> @@ -11216,6 +11219,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>>   	cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
>>   	kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
>>   
>> +	if (vcpu->arch.ia32_xss)
>> +		need_update_cpuid = true;
> 
> This means that kvm_set_msr_common()'s handling of MSR_IA32_XSS also needs to
> update kvm_update_cpuid_runtime().  And then for bnoth XCR0 and XSS, I would very
> strongly prefer that use the helpers to write the values and let the helpers call

Looks good to me and let me apply it in the next version.

> kvm_update_cpuid_runtime().  Yes, that will mean kvm_update_cpuid_runtime() may be
> called multiple times during INIT, but that's already true (CR4), and this isn't
> exactly a fast path.

An undisclosed lazy mechanism is under analyzed for performance gains.

> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 55518b7d3b96..22d4b1d15e94 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11256,7 +11256,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> 
>                  vcpu->arch.msr_misc_features_enables = 0;
> 
> -               vcpu->arch.xcr0 = XFEATURE_MASK_FP;
> +               __kvm_set_xcr(vcpu, 0, XFEATURE_MASK_FP);
>          }
> 
>          /* All GPRs except RDX (handled below) are zeroed on RESET/INIT. */
> @@ -11273,7 +11273,7 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>          cpuid_0x1 = kvm_find_cpuid_entry(vcpu, 1, 0);
>          kvm_rdx_write(vcpu, cpuid_0x1 ? cpuid_0x1->eax : 0x600);
> 
> -       vcpu->arch.ia32_xss = 0;
> +       __kvm_set_msr(vcpu, MSR_IA32_XSS, 0, true);
> 
>          static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
> 
> 
