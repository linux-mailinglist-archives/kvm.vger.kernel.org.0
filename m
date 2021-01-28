Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E356307C8A
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 18:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbhA1RcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 12:32:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50090 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233114AbhA1R0h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Jan 2021 12:26:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611854710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EvzLnQV83UjGmhjL45DZ7eCVOKze42prwXNVTupzJKM=;
        b=HcsBfYe623c15HepCig8A8XxyCDvQZjhIVgv40XfpYkslz85jMC39JJsnljzbYWuldY3tu
        qZrf+LdjhMvpqug+UosljW1K4UaICzv2hiGS3YUCVbv23ch31sCHstNAPYpVVDIMLTRvk2
        votJ6jGU8ovmgV6O/MQGCfZ1ZIP1fgE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-5cRMZ_c0PcG9AHreO9_3yA-1; Thu, 28 Jan 2021 12:25:07 -0500
X-MC-Unique: 5cRMZ_c0PcG9AHreO9_3yA-1
Received: by mail-ej1-f69.google.com with SMTP id rl8so2523781ejb.8
        for <kvm@vger.kernel.org>; Thu, 28 Jan 2021 09:25:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EvzLnQV83UjGmhjL45DZ7eCVOKze42prwXNVTupzJKM=;
        b=As90xezRwJlWJXjSsEbApRW+CcFnv6zXXQ7NldpBfNY8NlPhM98Z4ZlJxftSjU9hHn
         UutuGE0iOS5q7kQNZsI33kKjer7rk7p8jXlEBSmLRIjVnEysA4LYac5Wevz/nmO1pMMC
         9Gje1XRtThyw56Kd0T00sNcgoAFJJ+vCoaCfBXEHYUHslwcW1PS7fRxstLPgt9NjZnml
         Eglq3kZnyqkidjDX0UZe4zji5fmJq7z1utl01fNqS2a8jxK3mqDohPfsQfyqbCsOP++m
         hzP1tHTaWzVSZElaGpgWRaYnmiAOara2E37HKAOGz3ZnFwLkMJWfY6tmfl5U3MA9hJWT
         cpxw==
X-Gm-Message-State: AOAM5330/xewqiFfGZedwX2NY4/nPHc7uFpRQyaULqTy3cdmXfacfDJU
        ET+FvcOaw+5mOneDpNsrKXlawzNOWXcDx5/30uvnle9upJIImdPNgh9vHsrCMCVW+KeMXhFmNN7
        5Q/OJJlPoUiDO
X-Received: by 2002:a05:6402:26d3:: with SMTP id x19mr703865edd.0.1611854706494;
        Thu, 28 Jan 2021 09:25:06 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxtOL/S/cD3z5oCNOg2PKmdtIyy9IJN3TBOI+ONGmeMo6ik2bjQtL6XiRo14sQPPNELnEDn5g==
X-Received: by 2002:a05:6402:26d3:: with SMTP id x19mr703832edd.0.1611854706290;
        Thu, 28 Jan 2021 09:25:06 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h12sm3180823edb.16.2021.01.28.09.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jan 2021 09:25:05 -0800 (PST)
Subject: Re: [PATCH v2 05/14] KVM: x86: Override reported SME/SEV feature
 flags with host mask
To:     Sean Christopherson <seanjc@google.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20210114003708.3798992-1-seanjc@google.com>
 <20210114003708.3798992-6-seanjc@google.com>
 <74642db3-14dc-4e13-3130-dc8abe1a2b6e@redhat.com>
 <YBLvvpeEORjVd2IP@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8fa5e165-6f93-572f-81d5-07cdeb23b590@redhat.com>
Date:   Thu, 28 Jan 2021 18:25:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YBLvvpeEORjVd2IP@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/01/21 18:09, Sean Christopherson wrote:
> On Thu, Jan 28, 2021, Paolo Bonzini wrote:
>> On 14/01/21 01:36, Sean Christopherson wrote:
>>> Add a reverse-CPUID entry for the memory encryption word, 0x8000001F.EAX,
>>> and use it to override the supported CPUID flags reported to userspace.
>>> Masking the reported CPUID flags avoids over-reporting KVM support, e.g.
>>> without the mask a SEV-SNP capable CPU may incorrectly advertise SNP
>>> support to userspace.
>>>
>>> Cc: Brijesh Singh <brijesh.singh@amd.com>
>>> Cc: Tom Lendacky <thomas.lendacky@amd.com>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    arch/x86/kvm/cpuid.c | 2 ++
>>>    arch/x86/kvm/cpuid.h | 1 +
>>>    2 files changed, 3 insertions(+)
>>>
>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>>> index 13036cf0b912..b7618cdd06b5 100644
>>> --- a/arch/x86/kvm/cpuid.c
>>> +++ b/arch/x86/kvm/cpuid.c
>>> @@ -855,6 +855,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>>    	case 0x8000001F:
>>>    		if (!boot_cpu_has(X86_FEATURE_SEV))
>>>    			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>>> +		else
>>> +			cpuid_entry_override(entry, CPUID_8000_001F_EAX);
>>>    		break;
>>>    	/*Add support for Centaur's CPUID instruction*/
>>>    	case 0xC0000000:
>>> diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
>>> index dc921d76e42e..8b6fc9bde248 100644
>>> --- a/arch/x86/kvm/cpuid.h
>>> +++ b/arch/x86/kvm/cpuid.h
>>> @@ -63,6 +63,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
>>>    	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
>>>    	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
>>>    	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
>>> +	[CPUID_8000_001F_EAX] = {0x8000001f, 1, CPUID_EAX},
>>>    };
>>>    /*
>>>
>>
>> I don't understand, wouldn't this also need a kvm_cpu_cap_mask call
>> somewhere else?  As it is, it doesn't do anything.
> 
> Ugh, yes, apparently I thought the kernel would magically clear bits it doesn't
> care about.
> 
> Looking at this again, I think the kvm_cpu_cap_mask() invocation should always
> mask off X86_FEATURE_SME.  SME cannot be virtualized, and AFAIK it's not
> emulated by KVM.  This would fix an oddity where SME would be advertised if SEV
> is also supported.
> 
> Boris has queue the kernel change to tip/x86/cpu, I'll spin v4 against that.

You can send it after the 5.12 merge window.

Paolo

