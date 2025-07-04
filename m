Return-Path: <kvm+bounces-51543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B0FAF87C5
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:13:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 341B1543497
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 06:12:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6F7232392;
	Fri,  4 Jul 2025 06:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="Gjp7FOC3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704E2223DDA
	for <kvm@vger.kernel.org>; Fri,  4 Jul 2025 06:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751609534; cv=none; b=JrDjnja6++K08zQ3vcJniGHWT02ee46hNlzGtqLTHVU3IhpKx+ftJtQ2tCqeSEaQIVkAgAlb/wLH6PCXxaATuBHUhxwmTj+Yd653MnsU4q6q51FnYOl7VY9+5Uloq1t2sgsV/BytT9jpExhRxSa3aCPOh+4C5G02I/HGLUeVEYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751609534; c=relaxed/simple;
	bh=/uogvdvXfYqm/roohIkQvB+ClcSIM1FXcy29Xo6qXa8=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=OjMIyoQ8n2SE3+Oo2IiaN40LZ63e9Y7n4HHmjdaRqw6cZasUFljlGFD5yczx/b/WemPh40Nu8IgKLWwpZb5ClMDo5GcH43/u3iAKPHOTGmllqtCyFqR+sysp83Jh3MEdniUGK6y2wDSclqE0wW4UxiDI3VvLtjjqAJWzSz5LrBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=Gjp7FOC3; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-74ad4533ac5so1438776b3a.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 23:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1751609532; x=1752214332; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iLc719GJ905zueoaF4JxOKSxawRWbkyYr3NzbMVW2kQ=;
        b=Gjp7FOC3bMT0cxIVlzHyx8ZHoD5e0YtBeIXoKUgCJpKLdsQnw4q1jwOmSSAYyOmHVx
         yZWi7d+g3Zmac1LztnVKfbhzAZZm3cS2mJrSqcCZjbCEIFW1pIklIFZDxZhXMabGflqV
         AqkDyDADdSZ0/fmX/MiWrxR0SqikljF8LtzQ/KZakn+YA/Wgtajk8UnMJwospiJ1Queu
         Vt2lbiG/E3JoyizqzKd7+7mecIQ+ZP05rVUmc34irMyb3VUdiZnxE/REYWRZFKpnd9eT
         +L0kDd85UL/EXSOs48GnkDFmMoKJ9xqO8sfGIGeh2sSUKwcqll5X0mCWnxXvfD6B5uSX
         7+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751609532; x=1752214332;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iLc719GJ905zueoaF4JxOKSxawRWbkyYr3NzbMVW2kQ=;
        b=TTxbIp3/Fkjj/slh1PHsufKLMW1QLfQKWyUDXJDpIaEyk3ld43PSAqqHFNJ+XENexy
         4YsRr5URCYy8eMBpbec4bdsxrD3PS8IA8//0VZz3BUJE1P/YlvnJpxZIh4FScpdFWZVi
         LLgReTF8GW6JAp23O1xHA1fCvVrYJHsaqphyEfvg12/0NfIt8JJyFySVegKXTlkqp4AJ
         6c9y+ORszGYGhtMoKUSv718vYLI8jqHrVLmdnBpFGruXVDr8qqlD84++39xsC7Y9RVwK
         cy74IRNiT0iTbxNPE42NcCWrogd1Y0dP1MjMzqUqMm0u+f3S+/MLZ+tjOvM/H2waC8sE
         QqpQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/okmh23IltOmleHSCzloMtJ0EO7o3YFd4F3o/BabjSZhpBKA+zUn0yKHiLwLNB+/+XOQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBxUjLoX40tMtf7JF0u5U1u0bSKu76cofdQ1hPEOYfmQyWOH6a
	nQ0OR7yCiTNs9AEUbgh7pUMZqOhpP5Ro5vuW9bLokbH4j+3DFbropwu/OI6xRkOCr/Y=
X-Gm-Gg: ASbGncsmhG5oKLoGaucj9jAkqrCB8lGrI84U9W4oL0+aNqQlMIUz3eZTR9e78ojDFkX
	eURgEd0IqaxB85oTGcdmlQXOfaLFSpMOzrMKYlOLtVoKouY3g/ywJuL9D8gKdFQEvKyLTUAshFI
	6Qruq6R5D/fHakikOFI2WeGk4WpD4ehyYW0iOPEm0DwxBIP/zti8wVf/h8u3aGkPvhZ3FCHp73u
	d8ODnYk5knzvYpEkpMASh6iL7NFqyL1l1ZNMGP2ksIWnGS4XreqTK2/JCAeOnU/fxDiTJwVyltB
	eM7eBbr8Zq4TODkIDTN6DQmunZ1OUUMP7ueyJES2hjqUG150iymew+MwXONaQ05sreeLOvlXrlA
	TclozjP0k586nAG/Y/fR6W8NOqBAg+xfKchQe
X-Google-Smtp-Source: AGHT+IExD7KOIwp60ABVvZC51KGJUxkHICCIp6gpdohdZCSEaIoU6l2h4wvSvhZGHVi8H+Fsq8KURw==
X-Received: by 2002:a05:6a20:430f:b0:220:88f2:51a5 with SMTP id adf61e73a8af0-22597d0563bmr3567125637.18.1751609531468;
        Thu, 03 Jul 2025 23:12:11 -0700 (PDT)
Received: from ?IPV6:fdbd:ff1:ce00:1d76:cc0:e1b1:8778:e58c? ([2001:c10:ff04:0:1000::a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b38f879d040sm91749a12.44.2025.07.03.23.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 23:12:11 -0700 (PDT)
From: Liangyan <liangyan.peng@bytedance.com>
X-Google-Original-From: Liangyan <liangyan.peng@google.com>
Message-ID: <dc4d14c5-1f04-47d7-b314-e4db62f57665@google.com>
Date: Fri, 4 Jul 2025 14:12:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH RFC] x86/kvm: Use native qspinlock by
 default when realtime hinted
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Bibo Mao <maobibo@loongson.cn>, pbonzini@redhat.com, vkuznets@redhat.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, wanpengli@tencent.com,
 linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
References: <20250702064218.894-1-liangyan.peng@bytedance.com>
 <806e3449-a7b1-fa57-b220-b791428fb28b@loongson.cn>
 <8145bb17-8ba4-4d9d-a995-5f8b09db99c4@google.com>
 <aGVdykqnaUnPBkW-@char.us.oracle.com>
Content-Language: en-US
In-Reply-To: <aGVdykqnaUnPBkW-@char.us.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


Find one AMD guest(AMD EPYC 9Y24 128-vCPU) to test, it seems about 9% 
improvement.

Command: ./Run -c 128 spawn

With virt spin lock:
System Benchmarks Partial Index   BASELINE       RESULT    INDEX
Process Creation                      126.0     120449.8   9559.5
                                                           ========
System Benchmarks Index Score (Partial Only                9559.5


With qspinlock:
System Benchmarks Partial Index   BASELINE       RESULT    INDEX
Process Creation                      126.0     131566.8  10441.8
                                                           ========
System Benchmarks Index Score (Partial Only)              10441.8



Regards,
Liangyan


On 2025/7/3 00:26, Konrad Rzeszutek Wilk wrote:
> On Wed, Jul 02, 2025 at 08:23:58PM +0800, Liangyan wrote:
>> We test that unixbench spawn has big improvement in Intel 8582c 120-CPU
>> guest vm if switch to qspinlock.
> 
> And ARM or AMD?
> 
>>
>> Command: ./Run -c 120 spawn
>>
>> Use virt_spin_lock:
>> System Benchmarks Partial Index   BASELINE       RESULT  INDEX
>> Process Creation                     126.0      71878.4   5704.6
>>                                                          ========
>> System Benchmarks Index Score (Partial Only)              5704.6
>>
>>
>> Use qspinlock:
>> System Benchmarks Partial Index   BASELINE       RESULT    INDEX
>> Process Creation                     126.0     173566.6  13775.1
>>                                                          ========
>> System Benchmarks Index Score (Partial Only              13775.1
>>
>>
>> Regards,
>> Liangyan
>>
>> On 2025/7/2 16:19, Bibo Mao wrote:
>>>
>>>
>>> On 2025/7/2 下午2:42, Liangyan wrote:
>>>> When KVM_HINTS_REALTIME is set and KVM_FEATURE_PV_UNHALT is clear,
>>>> currently guest will use virt_spin_lock.
>>>> Since KVM_HINTS_REALTIME is set, use native qspinlock should be safe
>>>> and have better performance than virt_spin_lock.
>>> Just be curious, do you have actual data where native qspinlock has
>>> better performance than virt_spin_lock()?
>>>
>>> By my understanding, qspinlock is not friendly with VM. When lock is
>>> released, it is acquired with one by one order in contending queue. If
>>> the first vCPU in contending queue is preempted, the other vCPUs can not
>>> get lock. On physical machine it is almost impossible that CPU
>>> contending lock is preempted.
>>>
>>> Regards
>>> Bibo Mao
>>>>
>>>> Signed-off-by: Liangyan <liangyan.peng@bytedance.com>
>>>> ---
>>>>    arch/x86/kernel/kvm.c | 18 +++++++++---------
>>>>    1 file changed, 9 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>>> index 921c1c783bc1..9080544a4007 100644
>>>> --- a/arch/x86/kernel/kvm.c
>>>> +++ b/arch/x86/kernel/kvm.c
>>>> @@ -1072,6 +1072,15 @@ static void kvm_wait(u8 *ptr, u8 val)
>>>>     */
>>>>    void __init kvm_spinlock_init(void)
>>>>    {
>>>> +    /*
>>>> +     * Disable PV spinlocks and use native qspinlock when dedicated
>>>> pCPUs
>>>> +     * are available.
>>>> +     */
>>>> +    if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
>>>> +        pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME
>>>> hints\n");
>>>> +        goto out;
>>>> +    }
>>>> +
>>>>        /*
>>>>         * In case host doesn't support KVM_FEATURE_PV_UNHALT there is
>>>> still an
>>>>         * advantage of keeping virt_spin_lock_key enabled:
>>>> virt_spin_lock() is
>>>> @@ -1082,15 +1091,6 @@ void __init kvm_spinlock_init(void)
>>>>            return;
>>>>        }
>>>> -    /*
>>>> -     * Disable PV spinlocks and use native qspinlock when dedicated
>>>> pCPUs
>>>> -     * are available.
>>>> -     */
>>>> -    if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
>>>> -        pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME
>>>> hints\n");
>>>> -        goto out;
>>>> -    }
>>>> -
>>>>        if (num_possible_cpus() == 1) {
>>>>            pr_info("PV spinlocks disabled, single CPU\n");
>>>>            goto out;
>>>>
>>>
>>
>>


