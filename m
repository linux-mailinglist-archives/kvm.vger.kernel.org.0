Return-Path: <kvm+bounces-51613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1D9AF9E7D
	for <lists+kvm@lfdr.de>; Sat,  5 Jul 2025 08:41:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DC3A4A5D57
	for <lists+kvm@lfdr.de>; Sat,  5 Jul 2025 06:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 413EB204090;
	Sat,  5 Jul 2025 06:41:16 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC65218C31;
	Sat,  5 Jul 2025 06:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751697675; cv=none; b=uaRSyLxSsPFKQe7plOBI8hDw17kKss6nCV1awb5U44hrJ+/CaaOL+tUcXeTZ+jruFKxHXqUIxJQIWoY1f+tdsNikdoGEKylgXPbw/tycT+aPjlQbATiLYUnIYuLKUQMEv+ZxhIjz7rCjHfDHVHbpU5koaSbfzxaPgk1VItnJxdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751697675; c=relaxed/simple;
	bh=cJzM/yJ5AYZKDWd4yNtmu219r2Y9SniTVvJKVgZ2lSo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fNqlynNQ15pQ+8DGxByySfKJuxLkpvtRnJSlUkgY9iFnr1sG/N4Sqq7AlEPtdBmvVl4AUbShSed4eQoxBDu+AyMwwhHmFGJB2QM0JgMniIJUZ3DRAuy89zxkO1CMb2GXT51/0LvskyYThuwxZVDJ5Jwz/V1VVcdCqdkTiNpaIRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxLHIFyWho1LgiAQ--.40765S3;
	Sat, 05 Jul 2025 14:41:09 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxT+YCyWhoJUwKAA--.60616S3;
	Sat, 05 Jul 2025 14:41:08 +0800 (CST)
Subject: Re: [External] Re: [RFC] x86/kvm: Use native qspinlock by default
 when realtime hinted
To: Liangyan <liangyan.peng@bytedance.com>, pbonzini@redhat.com,
 vkuznets@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, wanpengli@tencent.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
References: <20250702064218.894-1-liangyan.peng@bytedance.com>
 <806e3449-a7b1-fa57-b220-b791428fb28b@loongson.cn>
 <8145bb17-8ba4-4d9d-a995-5f8b09db99c4@google.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <6ea07284-7bc2-ad73-21ab-78eb75a38751@loongson.cn>
Date: Sat, 5 Jul 2025 14:39:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <8145bb17-8ba4-4d9d-a995-5f8b09db99c4@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxT+YCyWhoJUwKAA--.60616S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxXFW3Aw17Ar1rtw45WFyrXwc_yoWrAF1xpr
	ykJF95tFyUXr18Zr1DJryjqryUJw4DGw1UXr1UXFyUJr1UXr1qgr1UXr1j9w1UJr4xJF1U
	tr15Jr47ZFyUJrcCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v2
	6F4UJVW0owAaw2AFwI0_JF0_Jw1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_
	Jw1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48J
	MxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r126r1DMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	WUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUcbAwUUUUU

There is big improvement with the test result. spawn test case is a 
little tricky, if forked child process is scheduled on the same CPU with 
the parent, the benefit is very huge. I doubt it is probably caused by 
scheduler rather than by spinlock itself.

1. What is cpu topology and numa information with physical machine and 
virtual machine?

2. Could you show reschedule IPI interrupt stat information when running 
  spawn test case?

3. Could you run this case on CPU over-commit scenary, such as both two 
VMs with 120 vCPUs?

Regards
Bibo Mao


On 2025/7/2 下午8:23, Liangyan wrote:
> We test that unixbench spawn has big improvement in Intel 8582c 120-CPU 
> guest vm if switch to qspinlock.
> 
> Command: ./Run -c 120 spawn
> 
> Use virt_spin_lock:
> System Benchmarks Partial Index   BASELINE       RESULT  INDEX
> Process Creation                     126.0      71878.4   5704.6
>                                                          ========
> System Benchmarks Index Score (Partial Only)              5704.6
> 
> 
> Use qspinlock:
> System Benchmarks Partial Index   BASELINE       RESULT    INDEX
> Process Creation                     126.0     173566.6  13775.1
>                                                          ========
> System Benchmarks Index Score (Partial Only              13775.1
> 
> 
> Regards,
> Liangyan
> 
> On 2025/7/2 16:19, Bibo Mao wrote:
>>
>>
>> On 2025/7/2 下午2:42, Liangyan wrote:
>>> When KVM_HINTS_REALTIME is set and KVM_FEATURE_PV_UNHALT is clear,
>>> currently guest will use virt_spin_lock.
>>> Since KVM_HINTS_REALTIME is set, use native qspinlock should be safe
>>> and have better performance than virt_spin_lock.
>> Just be curious, do you have actual data where native qspinlock has 
>> better performance than virt_spin_lock()?
>>
>> By my understanding, qspinlock is not friendly with VM. When lock is 
>> released, it is acquired with one by one order in contending queue. If 
>> the first vCPU in contending queue is preempted, the other vCPUs can 
>> not get lock. On physical machine it is almost impossible that CPU 
>> contending lock is preempted.
>>
>> Regards
>> Bibo Mao
>>>
>>> Signed-off-by: Liangyan <liangyan.peng@bytedance.com>
>>> ---
>>>   arch/x86/kernel/kvm.c | 18 +++++++++---------
>>>   1 file changed, 9 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
>>> index 921c1c783bc1..9080544a4007 100644
>>> --- a/arch/x86/kernel/kvm.c
>>> +++ b/arch/x86/kernel/kvm.c
>>> @@ -1072,6 +1072,15 @@ static void kvm_wait(u8 *ptr, u8 val)
>>>    */
>>>   void __init kvm_spinlock_init(void)
>>>   {
>>> +    /*
>>> +     * Disable PV spinlocks and use native qspinlock when dedicated 
>>> pCPUs
>>> +     * are available.
>>> +     */
>>> +    if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
>>> +        pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME 
>>> hints\n");
>>> +        goto out;
>>> +    }
>>> +
>>>       /*
>>>        * In case host doesn't support KVM_FEATURE_PV_UNHALT there is 
>>> still an
>>>        * advantage of keeping virt_spin_lock_key enabled: 
>>> virt_spin_lock() is
>>> @@ -1082,15 +1091,6 @@ void __init kvm_spinlock_init(void)
>>>           return;
>>>       }
>>> -    /*
>>> -     * Disable PV spinlocks and use native qspinlock when dedicated 
>>> pCPUs
>>> -     * are available.
>>> -     */
>>> -    if (kvm_para_has_hint(KVM_HINTS_REALTIME)) {
>>> -        pr_info("PV spinlocks disabled with KVM_HINTS_REALTIME 
>>> hints\n");
>>> -        goto out;
>>> -    }
>>> -
>>>       if (num_possible_cpus() == 1) {
>>>           pr_info("PV spinlocks disabled, single CPU\n");
>>>           goto out;
>>>
>>


