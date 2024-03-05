Return-Path: <kvm+bounces-10854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C94858713A2
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 03:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EDD4286AD7
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 02:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B841F286B3;
	Tue,  5 Mar 2024 02:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xc9OROup"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDA9EDE;
	Tue,  5 Mar 2024 02:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709605923; cv=none; b=DoyjGjrwYdf8ult8e96Cbn/146JdUnCjP1ke5HL+XObLGiL50KbvqsCE8qc+BxjjSN3oXqNeMf4HdryMWT5BCJGQcZbtH9ISoFqbZeb3ckhpTWb6ohhtxn/Q1nZLN7skUvysXgWijvyuJxoeBqKDJy8hN6PjKcYPhP6buHX9geM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709605923; c=relaxed/simple;
	bh=hk4ffxNQWELF0B5T5gTeWLKMNq6Hkl+1UGHQBiJSKRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YzDhXdXLjvQYzaGBgPMtvBT4UgjFQ0wvSLbRru67pHD9z9NSNmX91ZVkt73vN1jiorJnj7KVTkpRAsrPTN0KVsAo0WqL9kQwiM75MQYps7Jx67B0SOBBXesiDp5/1a46WTEoRQ8IAphQ3MWp46weZbHzJ9hO61WrfcyGL7hgVws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xc9OROup; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6e4f1660493so457186a34.0;
        Mon, 04 Mar 2024 18:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709605920; x=1710210720; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DQS78kDIQyyXIAHjahu4pRvGKqSGcVFJuYh7FUonVEM=;
        b=Xc9OROupavOHaIEzCzc/YIQVQbvXpH9KPX8BuAZ9LPwZunlt5EDLkGL44+fTQt/zUw
         tYsvjzqk3DJo/lkmFR20IVqnWOT/qhJK+RFBTsBYVOOkNMK9jf+uASwdFAoznTuyJk1F
         Q9DMFNQV7rjgUHIktvXq/br++I2f/+bq1lVEsVt/QWQsuQiHtfRkr0zudlDhS6VIH8Ea
         ps0mTg6Ss9b4qdQAuVIcEsodWDqN6dRpx1AAt9aQa3zrhCkc4BjQDwDETbLGg3fBny5X
         /+8pq10x+/gaYP43JfjJXRhNit6m+kxgS4yUEgFOtTkV6a4eyqeZBkxmu0Frp42K0eMk
         ijpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709605920; x=1710210720;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DQS78kDIQyyXIAHjahu4pRvGKqSGcVFJuYh7FUonVEM=;
        b=kJ1tuF8MP3gxP9aNuLBQXr8tVqttVw2YF3N+1/fd90UZhh9d0oMfSrRB0TJt2cp1pN
         XmgEWZfjUIXeFewjbQL286A1gBIeCSB0MynIR+BTPDrc1Zu07zw3Jj2tVunxqK6kc/Ux
         Rb4HLROatS3s9GvPTD/V41FVX6jZ0cAN0RjBRCRxPFhIBDkcZhR3Snfme88V0t2hwrrf
         9gc0wmGt5ZZfsbJjuPWczrKR5AYxn9nK80Xa7+xKLpIt/7PilbWSjx7k4u+PWlITw44g
         gvldgf+NCWW0qPQZirKo87cXAl36ZgbIIz2+ivnfKgQUsc4c6g81RpjHpvr5iKrexLZ2
         khJQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3fqaq2/dyhqThshRLoiMjdursjt8ZH6yBTeqO67mzs3rwxjhg/oCl9rnVcajDahpLlS+YwqTsWuhuzlNO0ckvyp/UJrHpgy1oCp/WldiLZjmF7YuO3rVxdE/T8hjXFu6l
X-Gm-Message-State: AOJu0YwFEo1aycKcjgGD9xOM4voXaRdRchZolGb3jwmYuP1/MyMVaKlS
	BoKmJ2sDwK6nctHDhTNlFr33/Jed356z5bEcvfdUk3puvnRl+7RdrcOBrcX0FbM=
X-Google-Smtp-Source: AGHT+IGeh/sNbtF2r85uQWZaRW1uNmHaXmFmsrApiNZFT4slLKxfnAiVMzH6gJJojerhG10rysbivg==
X-Received: by 2002:a05:6870:f6aa:b0:21e:95d9:dc7b with SMTP id el42-20020a056870f6aa00b0021e95d9dc7bmr587919oab.30.1709605920528;
        Mon, 04 Mar 2024 18:32:00 -0800 (PST)
Received: from [192.168.255.10] ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id u20-20020a62d454000000b006e468cd0a5asm8540777pfl.178.2024.03.04.18.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Mar 2024 18:31:59 -0800 (PST)
Message-ID: <8a846ba5-d346-422e-817b-e00ab9701f19@gmail.com>
Date: Tue, 5 Mar 2024 10:31:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86/svm/pmu: Set PerfMonV2 global control bits
 correctly
To: Sean Christopherson <seanjc@google.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Sandipan Das <sandipan.das@amd.com>, pbonzini@redhat.com,
 mizhang@google.com, jmattson@google.com, ravi.bangoria@amd.com,
 nikunj.dadhania@amd.com, santosh.shukla@amd.com, manali.shukla@amd.com,
 babu.moger@amd.com, kvm list <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20240301075007.644152-1-sandipan.das@amd.com>
 <06061a28-88c0-404b-98a6-83cc6cc8c796@gmail.com>
 <cc8699be-3aae-42aa-9c70-f8b6a9728ee3@amd.com>
 <f5bbe9ac-ca35-4c3e-8cd7-249839fbb8b8@linux.intel.com>
 <ZeYlEGORqeTPLK2_@google.com>
Content-Language: en-US
From: Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZeYlEGORqeTPLK2_@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/3/2024 3:46 am, Sean Christopherson wrote:
> On Mon, Mar 04, 2024, Dapeng Mi wrote:
>>
>> On 3/1/2024 5:00 PM, Sandipan Das wrote:
>>> On 3/1/2024 2:07 PM, Like Xu wrote:
>>>> On 1/3/2024 3:50 pm, Sandipan Das wrote:
>>>>> With PerfMonV2, a performance monitoring counter will start operating
>>>>> only when both the PERF_CTLx enable bit as well as the corresponding
>>>>> PerfCntrGlobalCtl enable bit are set.
>>>>>
>>>>> When the PerfMonV2 CPUID feature bit (leaf 0x80000022 EAX bit 0) is set
>>>>> for a guest but the guest kernel does not support PerfMonV2 (such as
>>>>> kernels older than v5.19), the guest counters do not count since the
>>>>> PerfCntrGlobalCtl MSR is initialized to zero and the guest kernel never
>>>>> writes to it.
>>>> If the vcpu has the PerfMonV2 feature, it should not work the way legacy
>>>> PMU does. Users need to use the new driver to operate the new hardware,
>>>> don't they ? One practical approach is that the hypervisor should not set
>>>> the PerfMonV2 bit for this unpatched 'v5.19' guest.
>>>>
>>> My understanding is that the legacy method of managing the counters should
>>> still work because the enable bits in PerfCntrGlobalCtl are expected to be
>>> set. The AMD PPR does mention that the PerfCntrEn bitfield of PerfCntrGlobalCtl
>>> is set to 0x3f after a system reset. That way, the guest kernel can use either
>>
>> If so, please add the PPR description here as comments.
> 
> Or even better, make that architectural behavior that's documented in the APM.

On the AMD side, we can't even reason that "PerfMonV3" will be compatible with
"PerfMonV2" w/o APM clarification which is a concern for both driver/virt impl.

> 
>>>>> ---
>>>>>     arch/x86/kvm/svm/pmu.c | 1 +
>>>>>     1 file changed, 1 insertion(+)
>>>>>
>>>>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>>>>> index b6a7ad4d6914..14709c564d6a 100644
>>>>> --- a/arch/x86/kvm/svm/pmu.c
>>>>> +++ b/arch/x86/kvm/svm/pmu.c
>>>>> @@ -205,6 +205,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>>>>>         if (pmu->version > 1) {
>>>>>             pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters) - 1);
>>>>>             pmu->global_status_mask = pmu->global_ctrl_mask;
>>>>> +        pmu->global_ctrl = ~pmu->global_ctrl_mask;
>>
>> It seems to be more easily understand to calculate global_ctrl firstly and
>> then derive the globol_ctrl_mask (negative logic).
> 
> Hrm, I'm torn.  On one hand, awful name aside (global_ctrl_mask should really be
> something like global_ctrl_rsvd_bits), the computation of the reserved bits should
> come from the capabilities of the PMU, not from the RESET value.
> 
> On the other hand, setting _all_ non-reserved bits will likely do the wrong thing
> if AMD ever adds bits in PerfCntGlobalCtl that aren't tied to general purpose
> counters.  But, that's a future theoretical problem, so I'm inclined to vote for
> Sandipan's approach.

I suspect that Intel hardware also has this behaviour [*] although guest
kernels using Intel pmu version 1 are pretty much non-existent.

[*] Table 10-1. IA-32 and Intel® 64 Processor States Following Power-up, Reset, 
or INIT (Contd.)

We need to update the selftest to guard this.

> 
>> diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
>> index e886300f0f97..7ac9b080aba6 100644
>> --- a/arch/x86/kvm/svm/pmu.c
>> +++ b/arch/x86/kvm/svm/pmu.c
>> @@ -199,7 +199,8 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
>> kvm_pmu_cap.num_counters_gp);
>>
>>          if (pmu->version > 1) {
>> -               pmu->global_ctrl_mask = ~((1ull << pmu->nr_arch_gp_counters)
>> - 1);
>> +               pmu->global_ctrl = (1ull << pmu->nr_arch_gp_counters) - 1;
>> +               pmu->global_ctrl_mask = ~pmu->global_ctrl;
>>                  pmu->global_status_mask = pmu->global_ctrl_mask;
>>          }
>>
>>>>>         }
>>>>>           pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
>>>
> 

