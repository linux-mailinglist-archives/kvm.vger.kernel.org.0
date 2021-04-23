Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF493369480
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 16:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhDWOTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 10:19:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48489 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229454AbhDWOTb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Apr 2021 10:19:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619187534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UsLHXkZihTU6VaR2mOY6eO9xp9LBBo1wxPeRGitgkmA=;
        b=WDnZSRbN0sjuUNXTchZjvv6sgtpJCR41QDcbN65Moybrr8tyTFB1ixMiCRsDO+XzxoEFuj
        sc0QRr2HK+1xN1zqGurPZ7oFSKJSyGo4rz8mi0abbE8Ks1k908lEm4hZDuErZ8wfw0R9TJ
        P7ueznGxEXhh9DAj4bs0nEOXwEt6Fvg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-i58HJWv8O4CrI8vJGm_z0A-1; Fri, 23 Apr 2021 10:18:52 -0400
X-MC-Unique: i58HJWv8O4CrI8vJGm_z0A-1
Received: by mail-ed1-f69.google.com with SMTP id f9-20020a50fe090000b02903839889635cso16712937edt.14
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 07:18:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UsLHXkZihTU6VaR2mOY6eO9xp9LBBo1wxPeRGitgkmA=;
        b=EMXj6Xnn5hnuX26ugzrDbra04MPgtaJdlthSDwrLcYNgUvTMlxtwSi6MtsUEmFkkP+
         EcuoTC6Z11/4RZSFSNauVsSY3HN+gvdPPa3jbuJK1spj9WNFshLDkGEcpSq1+vft4jON
         swHK1fbFyDo5czfx6VH+KYjvR7GJD34ooeB5+rmc5qJIp62vZA9UesVzC8TP9xJS9qOz
         jgEVirZmI2mPmWJBqlYPvxn1wdgTLrjF/aL4OS3+Mv1tnUs6UwIPmdlSjcMs0pmfSCJC
         Z+rih4nItugHX6ZIUQ9DK+7R8l/rAkL4xUgGG6P8RJvHpUehWfbJ3q3AupZBCPifsjAw
         0GzA==
X-Gm-Message-State: AOAM531rdiI3Xyq4isyF4blWSSCtaEMfFMrcYy3P8TM9LWom8C2RcKVA
        wplBeLBqLWoEmNOGvqyeVunJkMlJyIZBtne0F8SfWf8vkBG+kZQznCT95jzAEAy7hSzCRNcSDNb
        43e3WGuHZZzOI
X-Received: by 2002:a05:6402:698:: with SMTP id f24mr4742292edy.217.1619187531220;
        Fri, 23 Apr 2021 07:18:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwKLjJjrrGECre0642SldNRMLenv6iwnHRnZcPIfUd/61v7M7C6kwxIVHZzjKvod2PvLFIBNg==
X-Received: by 2002:a05:6402:698:: with SMTP id f24mr4742264edy.217.1619187530997;
        Fri, 23 Apr 2021 07:18:50 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id q25sm4992019edt.51.2021.04.23.07.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 07:18:50 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: SVM: Delay restoration of host MSR_TSC_AUX until
 return to userspace
To:     Sean Christopherson <seanjc@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20210422001736.3255735-1-seanjc@google.com>
 <CAAeT=FxaRV+za7yk8_9p45k4ui3QJx90gN4b8k4egrxux=QWFA@mail.gmail.com>
 <YIHYsa1+psfnszcv@google.com>
 <8cc2bb9a-167e-598c-6a9e-c23e943b1248@redhat.com>
 <YILV0KrBUaESfTiY@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fe66cff5-4b20-2c8b-8b2c-0eca6bf14b2d@redhat.com>
Date:   Fri, 23 Apr 2021 16:18:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YILV0KrBUaESfTiY@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/04/21 16:12, Sean Christopherson wrote:
> On Fri, Apr 23, 2021, Paolo Bonzini wrote:
>> On 22/04/21 22:12, Sean Christopherson wrote:
>>> 	case MSR_TSC_AUX:
>>> 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
>>> 			return 1;
>>>
>>> 		if (!msr_info->host_initiated &&
>>> 		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
>>> 			return 1;
>>>
>>> 		/*
>>> 		 * TSC_AUX is usually changed only during boot and never read
>>> 		 * directly.  Intercept TSC_AUX instead of exposing it to the
>>> 		 * guest via direct_access_msrs, and switch it via user return.
>>> 		 */
>>> 		preempt_disable();
>>> 		r = kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
>>> 		preempt_enable();
>>> 		if (r)
>>> 			return 1;
>>>
>>> 		/*
>>> 		 * Bits 63:32 are dropped by AMD CPUs, but are reserved on
>>> 		 * Intel CPUs.  AMD's APM has incomplete and conflicting info
>>> 		 * on the architectural behavior; emulate current hardware as
>>> 		 * doing so ensures migrating from AMD to Intel won't explode.
>>> 		 */
>>> 		svm->tsc_aux = (u32)data;
>>> 		break;
>>>
>>
>> Ok, squashed in the following:
> 
> Too fast!  The below won't compile (s/msr_info/msr and 'r' needs to be defined),
> and the get_msr() path needs the guest_cpuid_has() check.

Oops I missed the get_msr().  (I modify my local tree very aggressively, 
often without even compiling, so that I can use "git range-diff 
kvm/next..kvm/queue kvm/next.." as a reminder of things that are pending).

Paolo

   I'll spin a v3.
> 
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 14ff7f0963e9..00e9680969a2 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -2875,16 +2875,28 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
>>   		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
>>   			return 1;
>> +		if (!msr_info->host_initiated &&
>> +		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
>> +			return 1;
>> +
>>   		/*
>>   		 * TSC_AUX is usually changed only during boot and never read
>>   		 * directly.  Intercept TSC_AUX instead of exposing it to the
>>   		 * guest via direct_access_msrs, and switch it via user return.
>>   		 */
>> -		svm->tsc_aux = data;
>> -
>>   		preempt_disable();
>> -		kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
>> +		r = kvm_set_user_return_msr(TSC_AUX_URET_SLOT, data, -1ull);
>>   		preempt_enable();
>> +		if (r)
>> +			return 1;
>> +
>> +		/*
>> +		 * Bits 63:32 are dropped by AMD CPUs, but are reserved on
>> +		 * Intel CPUs.  AMD's APM has incomplete and conflicting info
>> +		 * on the architectural behavior; emulate current hardware as
>> +		 * doing so ensures migrating from AMD to Intel won't explode.
>> +		 */
>> +		svm->tsc_aux = (u32)data;
>>   		break;
>>   	case MSR_IA32_DEBUGCTLMSR:
>>   		if (!boot_cpu_has(X86_FEATURE_LBRV)) {
>>
>> Paolo
>>
> 

