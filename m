Return-Path: <kvm+bounces-51291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 178C0AF1582
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 470C73ABC29
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 12:23:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D338426E17F;
	Wed,  2 Jul 2025 12:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="QyATK5xu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28781DF27F
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 12:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751459049; cv=none; b=gYFXUCCwW0QzICgcjZeA/DLqYpsHrIryZt/T5DXjRm8zFClb9hvHl47bBRyELT7WcrWCFxmAzdOTiP88ZxrzAvGDFTrpi3PTt1WXoQnIJA+zRljfcn/L/LVyzcwnMVsUkw25DPSftafxn+CULxhTlU0B+8ozhduUM1ebT4uZxDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751459049; c=relaxed/simple;
	bh=O1QOsfQKfSBvWRmSVxSzFdhWW+0snVjTcsBpLdZpgOo=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=UoM+J4YNz4abVIL4Vg7ttm0BETnBxZncF6m7v7wYxoh/GFrxYonCuWzHOsB+W5sO99Px266eJGDzZywGZvv2lvhux1avxrydRWxrdzs/e5AdSAuwU/rtdMA6KgofxRANDhls7Gl9RIdMj3eWbc7+l0vPCBFRhnCBlJSgGo5XrL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=QyATK5xu; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-748feca4a61so2494515b3a.3
        for <kvm@vger.kernel.org>; Wed, 02 Jul 2025 05:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751459046; x=1752063846; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aZZQ0b9PR4kHg3DyEsxDVtoWqZbIHgud0yNfUX8vIa0=;
        b=QyATK5xuvBU8dCSgFiYMeERp70YYyC4IIGC7+PHi7bYltCoNCdaogk68pLRG8jEtr/
         4J3agww+4THUTs9qVsFKZKTzhfu8Z9kBXa5glKAz7Q0d/Mfn7RfTQzdBfojBz45N4nCu
         aDAx/7wuVMC2rDhX2ur0uLntwdELLrGB2YrOcdRiuHAohwogv66KAyHc3HFvD20CIzyP
         nzqPyFE5vWvthpKTxPQizgvMFOQUvbQOfIvYpeazzstn5THEqcqJufM7+tcB59fvGz0d
         Sa5A/dZn7eIpGoJ+G4x8nkIaKuz8dPKOTx/2BwyJ/MGwpLdwSqNfys9lDpLgEyABM6EM
         ZSEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751459046; x=1752063846;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aZZQ0b9PR4kHg3DyEsxDVtoWqZbIHgud0yNfUX8vIa0=;
        b=GLLla+ZErAzWzdyzgzsUc3mHMQEr7uKeWYSpejZ+12j3wJ3OXMSvvYJsPe7rMY6U5S
         Ov0oI+IitS39nTn4i0B0LEWeCpSfZLFzmsp1faoxoTDYe4MjK0XT1zKfzUTG/9HkuFNz
         rePhHA0HlUFoDY1P9nPVmyEjnY2aw5yvP0rbAIaeYbhPKMIk8ydp3Cqyy9lyNdHUxq5N
         oX6n6PJaFbmzqPvjx5PYjwmHOwgPw00GDmyVkVjwVSaXVKJXlwMtWy07wsSWDzVMHTVK
         VRmB2YH64lGiNDhIHW8lSdXffRMims+Yjb4vVVciMaPbBHW9ChIx8sl287Skn/O30CV5
         W/wg==
X-Forwarded-Encrypted: i=1; AJvYcCXLvOtO2uERlvrVQUUv3zVaEmzQGORThupezKUk4eQAEECxZfqjYgteJNdy4m/Qko0jqLI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaZc3VBquOvDbvfXZUvNxMiiY6S8JQMi6Tw2LyJ3kvIvTFXfHk
	zIfNAmQJkAVL3+UEdthFgTgqR0kIud20Ic5P5UPLHL/UQXaWdxmOgux36yWkiY40RZY=
X-Gm-Gg: ASbGncs6PVriuLev3dUChVn2BbJw0czScSavpP/elBmye/Kigg9mMj9GY3qr/8nzXVn
	JoNIrc2YMZSqwn3hKTGmJjBHBpU92ydgJPE8xEg1hNlMKonQtHUxC0JO8XiW6W2MnHGg1a7diuS
	OgtK4MNDMllZCuDhEG7x16H2aLmen84ui5pxNv8+eGTXE7NRzTwALfNz4clqbgRGoj4297FW1wB
	YqLiVzakjILV8himCfTJsTzr7KUcy/hvZt3Esi7KF4jZIn+HXhVarmOjTf2PK6BX8ynfg1xoYTO
	XD/LxIUKdZE8nvg8xaXodUf7Du8gA2TneR2fyVEePjctyUsYcez3E6DMvn2VMh5qkEXSs/ukNVo
	bB0eTiUtaldaAM9QipVJNbUDx+x8y0VRiETKg
X-Google-Smtp-Source: AGHT+IETkeRfDcmNB9+WEm2yGsnJ6OgHgpRfUmc69FAO+OZBAHjIaiAqF+dsmTgGpCmrfOlIUgPTQA==
X-Received: by 2002:a05:6a21:48d:b0:21f:5aa1:3124 with SMTP id adf61e73a8af0-222d7df0870mr5638079637.13.1751459046175;
        Wed, 02 Jul 2025 05:24:06 -0700 (PDT)
Received: from ?IPV6:fdbd:ff1:ce00:1d76:cc0:e1b1:8778:e58c? ([2001:c10:ff04:0:1000::8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e31beab2sm13027706a12.47.2025.07.02.05.24.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 05:24:05 -0700 (PDT)
From: Liangyan <liangyan.peng@bytedance.com>
X-Google-Original-From: Liangyan <liangyan.peng@google.com>
Message-ID: <8145bb17-8ba4-4d9d-a995-5f8b09db99c4@google.com>
Date: Wed, 2 Jul 2025 20:23:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [RFC] x86/kvm: Use native qspinlock by default
 when realtime hinted
To: Bibo Mao <maobibo@loongson.cn>, Liangyan <liangyan.peng@bytedance.com>,
 pbonzini@redhat.com, vkuznets@redhat.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 wanpengli@tencent.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
References: <20250702064218.894-1-liangyan.peng@bytedance.com>
 <806e3449-a7b1-fa57-b220-b791428fb28b@loongson.cn>
Content-Language: en-US
In-Reply-To: <806e3449-a7b1-fa57-b220-b791428fb28b@loongson.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

We test that unixbench spawn has big improvement in Intel 8582c 120-CPU 
guest vm if switch to qspinlock.

Command: ./Run -c 120 spawn

Use virt_spin_lock:
System Benchmarks Partial Index   BASELINE       RESULT  INDEX
Process Creation                     126.0      71878.4   5704.6
                                                         ========
System Benchmarks Index Score (Partial Only)              5704.6


Use qspinlock:
System Benchmarks Partial Index   BASELINE       RESULT    INDEX
Process Creation                     126.0     173566.6  13775.1
                                                         ========
System Benchmarks Index Score (Partial Only              13775.1


Regards,
Liangyan

On 2025/7/2 16:19, Bibo Mao wrote:
> 
> 
> On 2025/7/2 下午2:42, Liangyan wrote:
>> When KVM_HINTS_REALTIME is set and KVM_FEATURE_PV_UNHALT is clear,
>> currently guest will use virt_spin_lock.
>> Since KVM_HINTS_REALTIME is set, use native qspinlock should be safe
>> and have better performance than virt_spin_lock.
> Just be curious, do you have actual data where native qspinlock has 
> better performance than virt_spin_lock()?
> 
> By my understanding, qspinlock is not friendly with VM. When lock is 
> released, it is acquired with one by one order in contending queue. If 
> the first vCPU in contending queue is preempted, the other vCPUs can not 
> get lock. On physical machine it is almost impossible that CPU 
> contending lock is preempted.
> 
> Regards
> Bibo Mao
>>
>> Signed-off-by: Liangyan <liangyan.peng@bytedance.com>
>> ---
>>   arch/x86/kernel/kvm.c | 18 +++++++++---------
>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>> index 921c1c783bc1..9080544a4007 100644
>> --- a/arch/x86/kernel/kvm.c
>> +++ b/arch/x86/kernel/kvm.c
>> @@ -1072,6 +1072,15 @@ static void kvm_wait(u8 *ptr, u8 val)
>>    */
>>   void __init kvm_spinlock_init(void)
>>   {
>> +    /*
>> +     * Disable PV spinlocks and use native qspinlock when dedicated 
>> pCPUs
>> +     * are available.
>> +     */
>> +    if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
>> +        pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME 
>> hints\n");
>> +        goto out;
>> +    }
>> +
>>       /*
>>        * In case host doesn't support KVM_FEATURE_PV_UNHALT there is 
>> still an
>>        * advantage of keeping virt_spin_lock_key enabled: 
>> virt_spin_lock() is
>> @@ -1082,15 +1091,6 @@ void __init kvm_spinlock_init(void)
>>           return;
>>       }
>> -    /*
>> -     * Disable PV spinlocks and use native qspinlock when dedicated 
>> pCPUs
>> -     * are available.
>> -     */
>> -    if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
>> -        pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME 
>> hints\n");
>> -        goto out;
>> -    }
>> -
>>       if (num_possible_cpus() == 1) {
>>           pr_info("PV spinlocks disabled, single CPU\n");
>>           goto out;
>>
> 


