Return-Path: <kvm+bounces-64329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 300BBC7F785
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 10:08:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F1F854E3DE3
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 09:08:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 086012F4A00;
	Mon, 24 Nov 2025 09:08:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF9A2F49E5;
	Mon, 24 Nov 2025 09:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763975315; cv=none; b=ZdC7nzF1x51pugxsZIYUBmps1hN5OZWBIMGKidmtWN5qIDyjsrRhhK+hmZGvfD9qY3xwrdjxyx0aTcMuSgn4kZwCIy2eaGGgQKazb7xZRJrSWyyHtYX+GMW7ICTzs+R2hE905OlBoCYGGS7LhOllyzC1iNp68Jq+S0wxK0o/XYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763975315; c=relaxed/simple;
	bh=kVLTErxN4THTWzbx/ZV5SLay0pE11z7SHZJm/LLeI8g=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=V4HAATnAaDxqGq+SsaEkewV6vg33WEdgT/d+PBXzz6QwOaqriNkdEGtr4xn2YutDATIT/T6k1+AYSySkOuO/96Q82Sz0PWvcZQFnRjRDQoIQFWO9XEGRonn2If5IOaJple/f0xag4cswM9kKmKKoJr/jn2hQPr030cORgDJNTlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cxbb+KICRpcnEnAA--.18206S3;
	Mon, 24 Nov 2025 17:08:26 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxVOSFICRpcYY9AQ--.43766S3;
	Mon, 24 Nov 2025 17:08:23 +0800 (CST)
Subject: Re: [PATCH v2 2/3] LoongArch: Add paravirt support with
 vcpu_is_preempted() in guest side
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>,
 Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, x86@kernel.org
References: <20251124035402.3817179-1-maobibo@loongson.cn>
 <20251124035402.3817179-3-maobibo@loongson.cn>
 <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com>
 <5d80c452-bbc3-539a-fb8d-14dbe353f8cb@loongson.cn>
 <CAAhV-H66M+GZ2kB8BKR82BUeQcNZ8ACeXLxwjh-bsVZcca1cqQ@mail.gmail.com>
 <718b5b5d-2bb1-5d59-409e-54f54516a6b7@loongson.cn>
 <CAAhV-H4X5EAgDTnSGG+1pMWywoLAis5TH_jEWkvaY8p1m8hQMg@mail.gmail.com>
 <611840bb-7f7d-3b13-dc89-b760d8eeda79@loongson.cn>
 <CAAhV-H6TWCs-tFf5HCOt9cAY01J-nirzVmu1GEAYpP=1LWznPA@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <393b2f18-c860-9d71-6d86-5a496983c3fd@loongson.cn>
Date: Mon, 24 Nov 2025 17:05:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6TWCs-tFf5HCOt9cAY01J-nirzVmu1GEAYpP=1LWznPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxVOSFICRpcYY9AQ--.43766S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxtFWDAFW7trW3tw48Jw4DZFc_yoWxXr15pr
	yUJF1kta1UGr18Aw42qr1q9r15tr1kGr1xXry7Gry5Ar1qvr17Jr1UtryjkFyUtwnrGF10
	qr1kGr4agFyUJwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Wrv_ZF1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUxYiiDU
	UUU



On 2025/11/24 下午5:03, Huacai Chen wrote:
> On Mon, Nov 24, 2025 at 4:35 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2025/11/24 下午4:03, Huacai Chen wrote:
>>> On Mon, Nov 24, 2025 at 3:50 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>>
>>>>
>>>> On 2025/11/24 下午3:13, Huacai Chen wrote:
>>>>> On Mon, Nov 24, 2025 at 3:03 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2025/11/24 下午2:33, Huacai Chen wrote:
>>>>>>> Hi, Bibo,
>>>>>>>
>>>>>>> On Mon, Nov 24, 2025 at 11:54 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>>>
>>>>>>>> Function vcpu_is_preempted() is used to check whether vCPU is preempted
>>>>>>>> or not. Here add implementation with vcpu_is_preempted() when option
>>>>>>>> CONFIG_PARAVIRT is enabled.
>>>>>>>>
>>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>steal_time
>>>>>>>> ---
>>>>>>>>      arch/loongarch/include/asm/qspinlock.h |  5 +++++
>>>>>>>>      arch/loongarch/kernel/paravirt.c       | 16 ++++++++++++++++
>>>>>>>>      2 files changed, 21 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch/include/asm/qspinlock.h
>>>>>>>> index e76d3aa1e1eb..9a5b7ba1f4cb 100644
>>>>>>>> --- a/arch/loongarch/include/asm/qspinlock.h
>>>>>>>> +++ b/arch/loongarch/include/asm/qspinlock.h
>>>>>>>> @@ -34,6 +34,11 @@ static inline bool virt_spin_lock(struct qspinlock *lock)
>>>>>>>>             return true;
>>>>>>>>      }
>>>>>>>>
>>>>>>>> +#ifdef CONFIG_SMP
>>>>>>>> +#define vcpu_is_preempted      vcpu_is_preempted
>>>>>>>> +bool vcpu_is_preempted(int cpu);
>>>>>>> In V1 there is a build error because you reference mp_ops, so in V2
>>>>>>> you needn't put it in CONFIG_SMP.
>>>>>> The compile failure problem is that vcpu_is_preempted() is redefined in
>>>>>> both arch/loongarch/kernel/paravirt.c and include/linux/sched.h
>>>>> But other archs don't define vcpu_is_preempted() under CONFIG_SMP, and
>>>> so what is advantage to implement this function if CONFIG_SMP is disabled?
>>> 1. Keep consistency with other architectures.
>>> 2. Keep it simple to reduce #ifdefs (and !SMP is just for build, not
>>> very useful in practice).
>> It seems that CONFIG_SMP can be removed in header file
>> include/asm/qspinlock.h, since asm/spinlock.h and asm/qspinlock.h is
>> only included when CONFIG_SMP is set, otherwise only linux/spinlock_up.h
>> is included.
>>
>>>
>>>>
>>>>> you can consider to inline the whole vcpu_is_preempted() here.
>>>> Defining the function vcpu_is_preempted() as inlined is not so easy for
>>>> me, it beyond my ability now :(
>>>>
>>>> With static key method, the static key need be exported, all modules
>>>> need apply the jump label, that is dangerous and I doubt whether it is
>>>> deserved.
>>> No, you have already done similar things in virt_spin_lock(), it is an
>>> inline function and uses virt_spin_lock_key.
>> virt_spin_lock is only called qspinlock in function
>> queued_spin_lock_slowpath(). Function vcpu_is_preempted() is defined
>> header file linux/sched.h, kernel module may use it.
> Yes, if modules want to use it we need to EXPORT_SYMBOL. But don't
> worry, static key infrastructure can handle this. Please see
> cpu_feature_keys defined and used in
> arch/powerpc/include/asm/cpu_has_feature.h, which is exported in
> arch/powerpc/kernel/cputable.c.
No, I do not want to do so. export static key and percpu steal_time 
structure, just in order to implement one inline function.

> 
> Huacai
> 
>>
>>
>>>
>>> Huacai
>>>
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>>
>>>>>>
>>>>>> The problem is that <asm/spinlock.h> is not included by sched.h, if
>>>>>> CONFIG_SMP is disabled. Here is part of file include/linux/spinlock.h
>>>>>> #ifdef CONFIG_SMP
>>>>>> # include <asm/spinlock.h>
>>>>>> #else
>>>>>> # include <linux/spinlock_up.h>
>>>>>> #endif
>>>>>>
>>>>>>> On the other hand, even if you really build a UP guest kernel, when
>>>>>>> multiple guests run together, you probably need vcpu_is_preemtped.
>>>>>> It is not relative with multiple VMs. When vcpu_is_preempted() is
>>>>>> called, it is to detect whether dest CPU is preempted or not, the cpu
>>>>>> from smp_processor_id() should not be preempted. So in generic
>>>>>> vcpu_is_preempted() works on multiple vCPUs.
>>>>> OK, I'm wrong here.
>>>>>
>>>>>
>>>>> Huacai
>>>>>
>>>>>>
>>>>>> Regards
>>>>>> Bibo Mao
>>>>>>>
>>>>>>>
>>>>>>> Huacai
>>>>>>>
>>>>>>>> +#endif
>>>>>>>> +
>>>>>>>>      #endif /* CONFIG_PARAVIRT */
>>>>>>>>
>>>>>>>>      #include <asm-generic/qspinlock.h>
>>>>>>>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
>>>>>>>> index b1b51f920b23..d4163679adc4 100644
>>>>>>>> --- a/arch/loongarch/kernel/paravirt.c
>>>>>>>> +++ b/arch/loongarch/kernel/paravirt.c
>>>>>>>> @@ -246,6 +246,7 @@ static void pv_disable_steal_time(void)
>>>>>>>>      }
>>>>>>>>
>>>>>>>>      #ifdef CONFIG_SMP
>>>>>>>> +DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
>>>>>>>>      static int pv_time_cpu_online(unsigned int cpu)
>>>>>>>>      {
>>>>>>>>             unsigned long flags;
>>>>>>>> @@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigned int cpu)
>>>>>>>>
>>>>>>>>             return 0;
>>>>>>>>      }
>>>>>>>> +
>>>>>>>> +bool notrace vcpu_is_preempted(int cpu)
>>>>>>>> +{
>>>>>>>> +       struct kvm_steal_time *src;
>>>>>>>> +
>>>>>>>> +       if (!static_branch_unlikely(&virt_preempt_key))
>>>>>>>> +               return false;
>>>>>>>> +
>>>>>>>> +       src = &per_cpu(steal_time, cpu);
>>>>>>>> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
>>>>>>>> +}
>>>>>>>> +EXPORT_SYMBOL(vcpu_is_preempted);
>>>>>>>>      #endif
>>>>>>>>
>>>>>>>>      static void pv_cpu_reboot(void *unused)
>>>>>>>> @@ -308,6 +321,9 @@ int __init pv_time_init(void)
>>>>>>>>                     pr_err("Failed to install cpu hotplug callbacks\n");
>>>>>>>>                     return r;
>>>>>>>>             }
>>>>>>>> +
>>>>>>>> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT))
>>>>>>>> +               static_branch_enable(&virt_preempt_key);
>>>>>>>>      #endif
>>>>>>>>
>>>>>>>>             static_call_update(pv_steal_clock, paravt_steal_clock);
>>>>>>>> --
>>>>>>>> 2.39.3
>>>>>>>>
>>>>>>
>>>>>>
>>>>
>>>>
>>
>>


