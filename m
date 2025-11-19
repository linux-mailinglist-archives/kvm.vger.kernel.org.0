Return-Path: <kvm+bounces-63664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 10709C6C870
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 04:11:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C3CEF4E7516
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 03:11:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A04D2D9EF2;
	Wed, 19 Nov 2025 03:10:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32C415A86D;
	Wed, 19 Nov 2025 03:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763521854; cv=none; b=JNiV7qY5vavVPPIFUr/S648pv/rxfKq+OMWjzfCTfVmuKBV2D1mznJSkRFi9LIBHPhj0uccPAHiJlWynfBCG5PDePQl3Yc1584qrkXiNG0wFvwLJ3Crv9HKKqfY0cbCHSxWtB6csLZV8PiGLC8TrylVffj4O+VuoBV2gtLZauK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763521854; c=relaxed/simple;
	bh=47LJCfN08bkIm00LG9Iy9e+3EfRwh03jcljG5dejSqY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=kEEO4BPNMysdP2n8yl/B2uPqnu557vCj/j5yd7UTLlqfGZ7llLYOpWtsPgzGKpBGzRxWBzjgFAiOwTeJ0z8W4lyL7tmEg/SETpINRd49bZAtjUfhOwZdoTswJu9utKpE+oMa0ltEaAMUNUu2YOkkkMzUNbGBh1vN8Ljoz+OY25A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cxf9M4NR1pxFMlAA--.14336S3;
	Wed, 19 Nov 2025 11:10:48 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxicAzNR1pKgU4AQ--.3066S3;
	Wed, 19 Nov 2025 11:10:46 +0800 (CST)
Subject: Re: [PATCH 2/3] LoongArch: Add paravirt support with
 vcpu_is_preempted()
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Waiman Long <longman@redhat.com>, Juergen Gross <jgross@suse.com>,
 Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, x86@kernel.org
References: <20251118080656.2012805-1-maobibo@loongson.cn>
 <20251118080656.2012805-3-maobibo@loongson.cn>
 <CAAhV-H4hoS0Wo3TS+FdikXMkb7qjWNFSPDoajQr0bzdeROJwGw@mail.gmail.com>
 <db8a26ca-8430-9e7d-4ad1-9b7743c4cfd1@loongson.cn>
 <CAAhV-H7uU6U9okJKqkUEXRT9OATpdMRgzZ8a7x0Xr6_bzD-x4A@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <c14346a5-37ec-0fef-f143-c18227fec635@loongson.cn>
Date: Wed, 19 Nov 2025 11:08:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7uU6U9okJKqkUEXRT9OATpdMRgzZ8a7x0Xr6_bzD-x4A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxicAzNR1pKgU4AQ--.3066S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3JF4UAr1DuFWfGFWxtrWkuFX_yoWfXr18pF
	ykAFWv9a18Ww1xAw4aqFyj9r98tr95C3WIqa4agFyYyrnFgrnrJr1qyryY9Fy09w4UW3W0
	qr97Gan3KF1aywcCm3ZEXasCq-sJn29KB7ZKAUJUUUU3529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
	6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVW8ZVWrXwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jr9NsUUU
	UU=



On 2025/11/19 上午10:58, Huacai Chen wrote:
> On Wed, Nov 19, 2025 at 10:01 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2025/11/18 下午8:48, Huacai Chen wrote:
>>> Hi, Bibo,
>>>
>>> On Tue, Nov 18, 2025 at 4:07 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>> Function vcpu_is_preempted() is used to check whether vCPU is preempted
>>>> or not. Here add implementation with vcpu_is_preempted() when option
>>>> CONFIG_PARAVIRT is enabled.
>>>>
>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>> ---
>>>>    arch/loongarch/include/asm/smp.h      |  1 +
>>>>    arch/loongarch/include/asm/spinlock.h |  5 +++++
>>>>    arch/loongarch/kernel/paravirt.c      | 16 ++++++++++++++++
>>>>    arch/loongarch/kernel/smp.c           |  6 ++++++
>>>>    4 files changed, 28 insertions(+)
>>>>
>>>> diff --git a/arch/loongarch/include/asm/smp.h b/arch/loongarch/include/asm/smp.h
>>>> index 3a47f52959a8..5b37f7bf2060 100644
>>>> --- a/arch/loongarch/include/asm/smp.h
>>>> +++ b/arch/loongarch/include/asm/smp.h
>>>> @@ -18,6 +18,7 @@ struct smp_ops {
>>>>           void (*init_ipi)(void);
>>>>           void (*send_ipi_single)(int cpu, unsigned int action);
>>>>           void (*send_ipi_mask)(const struct cpumask *mask, unsigned int action);
>>>> +       bool (*vcpu_is_preempted)(int cpu);
>>>>    };
>>>>    extern struct smp_ops mp_ops;
>>>>
>>>> diff --git a/arch/loongarch/include/asm/spinlock.h b/arch/loongarch/include/asm/spinlock.h
>>>> index 7cb3476999be..c001cef893aa 100644
>>>> --- a/arch/loongarch/include/asm/spinlock.h
>>>> +++ b/arch/loongarch/include/asm/spinlock.h
>>>> @@ -5,6 +5,11 @@
>>>>    #ifndef _ASM_SPINLOCK_H
>>>>    #define _ASM_SPINLOCK_H
>>>>
>>>> +#ifdef CONFIG_PARAVIRT
>>>> +#define vcpu_is_preempted      vcpu_is_preempted
>>>> +bool vcpu_is_preempted(int cpu);
>>>> +#endif
>>> Maybe paravirt.h is a better place?
>>
>> It is actually a little strange to add macro CONFIG_PARAVIRT in file
>> asm/spinlock.h
>>
>> vcpu_is_preempted is originally defined in header file
>> include/linux/sched.h like this
>> #ifndef vcpu_is_preempted
>> static inline bool vcpu_is_preempted(int cpu)
>> {
>>           return false;
>> }
>> #endif
>>
>> that requires that header file is included before sched.h, file
>> asm/spinlock.h can meet this requirement, however header file paravirt.h
>> maybe it is not included before sched.h in generic.
>>
>> Here vcpu_is_preempted definition is added before the following including.
>>      #include <asm/processor.h>
>>      #include <asm/qspinlock.h>
>>      #include <asm/qrwlock.h>
>> Maybe it is better to be added after the above header files including
>> sentences, but need further investigation.
> powerpc put it in paravirt.h, so I think it is possible.
paravirt.h is included by header file asm/qspinlock.h on powerpc, 
however it is not so on loongarch :)

# grep paravirt.h arch/powerpc/* -r
arch/powerpc/include/asm/paravirt_api_clock.h:#include <asm/paravirt.h>
arch/powerpc/include/asm/qspinlock.h:#include <asm/paravirt.h>
arch/powerpc/include/asm/simple_spinlock.h:#include <asm/paravirt.h>

$ grep paravirt.h arch/loongarch/* -r
arch/loongarch/include/asm/paravirt_api_clock.h:#include <asm/paravirt.h>
> 
>>>
>>>> +
>>>>    #include <asm/processor.h>
>>>>    #include <asm/qspinlock.h>
>>>>    #include <asm/qrwlock.h>
>>>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
>>>> index b1b51f920b23..b99404b6b13f 100644
>>>> --- a/arch/loongarch/kernel/paravirt.c
>>>> +++ b/arch/loongarch/kernel/paravirt.c
>>>> @@ -52,6 +52,13 @@ static u64 paravt_steal_clock(int cpu)
>>>>    #ifdef CONFIG_SMP
>>>>    static struct smp_ops native_ops;
>>>>
>>>> +static bool pv_vcpu_is_preempted(int cpu)
>>>> +{
>>>> +       struct kvm_steal_time *src = &per_cpu(steal_time, cpu);
>>>> +
>>>> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
>>>> +}
>>>> +
>>>>    static void pv_send_ipi_single(int cpu, unsigned int action)
>>>>    {
>>>>           int min, old;
>>>> @@ -308,6 +315,9 @@ int __init pv_time_init(void)
>>>>                   pr_err("Failed to install cpu hotplug callbacks\n");
>>>>                   return r;
>>>>           }
>>>> +
>>>> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT_HINT))
>>>> +               mp_ops.vcpu_is_preempted = pv_vcpu_is_preempted;
>>>>    #endif
>>>>
>>>>           static_call_update(pv_steal_clock, paravt_steal_clock);
>>>> @@ -332,3 +342,9 @@ int __init pv_spinlock_init(void)
>>>>
>>>>           return 0;
>>>>    }
>>>> +
>>>> +bool notrace vcpu_is_preempted(int cpu)
>>>> +{
>>>> +       return mp_ops.vcpu_is_preempted(cpu);
>>>> +}
>>>
>>> We can simplify the whole patch like this, then we don't need to touch
>>> smp.c, and we can merge Patch-2/3.
>>>
>>> +bool notrace vcpu_is_preempted(int cpu)
>>> +{
>>> +  if (!kvm_para_has_feature(KVM_FEATURE_PREEMPT_HINT))
>>> +     return false;
>>> + else {
>>> +     struct kvm_steal_time *src = &per_cpu(steal_time, cpu);
>>> +     return !!(src->preempted & KVM_VCPU_PREEMPTED);
>>> + }
>>> +}
>> 1. there is assembly output about relative vcpu_is_preempted
>>    <loongson_vcpu_is_preempted>:
>>                  move    $r4,$r0
>>                  jirl    $r0,$r1,0
>>
>>    <pv_vcpu_is_preempted>:
>>           pcalau12i       $r13,8759(0x2237)
>>           slli.d  $r4,$r4,0x3
>>           addi.d  $r13,$r13,-1000(0xc18)
>>           ldx.d   $r13,$r13,$r4
>>           pcalau12i       $r12,5462(0x1556)
>>           addi.d  $r12,$r12,384(0x180)
>>           add.d   $r12,$r13,$r12
>>           ld.bu   $r4,$r12,16(0x10)
>>           andi    $r4,$r4,0x1
>>           jirl    $r0,$r1,0
>>
>>    <vcpu_is_preempted>:
>>           pcalau12i       $r12,8775(0x2247)
>>           ld.d    $r12,$r12,-472(0xe28)
>>           jirl    $r0,$r12,0
>>           andi    $r0,$r0,0x0
>>
>>    <vcpu_is_preempted_new>:
>>           pcalau12i       $r12,8151(0x1fd7)
>>           ld.d    $r12,$r12,-1008(0xc10)
>>           bstrpick.d      $r12,$r12,0x1a,0x1a
>>           beqz    $r12,188(0xbc) # 900000000024ec60
>>           pcalau12i       $r12,11802(0x2e1a)
>>           addi.d  $r12,$r12,-1400(0xa88)
>>           ldptr.w $r14,$r12,36(0x24)
>>           beqz    $r14,108(0x6c) # 900000000024ec20
>>           addi.w  $r13,$r0,1(0x1)
>>           bne     $r14,$r13,164(0xa4) # 900000000024ec60
>>           ldptr.w $r13,$r12,40(0x28)
>>           bnez    $r13,24(0x18) # 900000000024ebdc
>>           lu12i.w $r14,262144(0x40000)
>>           ori     $r14,$r14,0x4
>>           cpucfg  $r14,$r14
>>           slli.w  $r13,$r14,0x0
>>           st.w    $r14,$r12,40(0x28)
>>           bstrpick.d      $r13,$r13,0x3,0x3
>>           beqz    $r13,128(0x80) # 900000000024ec60
>>           pcalau12i       $r13,8759(0x2237)
>>           slli.d  $r4,$r4,0x3
>>           addi.d  $r13,$r13,-1000(0xc18)
>>           ldx.d   $r13,$r13,$r4
>>           pcalau12i       $r12,5462(0x1556)
>>           addi.d  $r12,$r12,384(0x180)
>>           add.d   $r12,$r13,$r12
>>           ld.bu   $r4,$r12,16(0x10)
>>           andi    $r4,$r4,0x1
>>           jirl    $r0,$r1,0
>>           andi    $r0,$r0,0x0
>>           andi    $r0,$r0,0x0
>>           andi    $r0,$r0,0x0
>>           andi    $r0,$r0,0x0
>>           andi    $r0,$r0,0x0
>>           lu12i.w $r13,262144(0x40000)
>>           cpucfg  $r13,$r13
>>           lu12i.w $r15,1237(0x4d5)
>>           ori     $r15,$r15,0x64b
>>           slli.w  $r13,$r13,0x0
>>           bne     $r13,$r15,-124(0x3ff84) # 900000000024ebb8
>>           addi.w  $r13,$r0,1(0x1)
>>           st.w    $r13,$r12,36(0x24)
>>           b       -128(0xfffff80) # 900000000024ebc0
>>           andi    $r0,$r0,0x0
>>           andi    $r0,$r0,0x0
>>           andi    $r0,$r0,0x0
>>           andi    $r0,$r0,0x0
>>           andi    $r0,$r0,0x0
>>           andi    $r0,$r0,0x0
>>           andi    $r0,$r0,0x0
>>           move    $r4,$r0
>>           jirl    $r0,$r1,0
>>
>> With vcpu_is_preempted(), there is one memory load and one jirl jump,
>> with vcpu_is_preempted_new(), there is two memory load and two beq
>> compare instructions.
> Is vcpu_is_preempted() performance critical (we need performance data
> here)? It seems the powerpc version is also complex.
> 
>>
>> 2. In some scenery such nr_cpus == 1, loongson_vcpu_is_preempted() is
>> better than pv_vcpu_is_preempted() even if the preempt feature is enabled.
> In your original patch, "mp_ops.vcpu_is_preempted =
> pv_vcpu_is_preempted" if the preempt feature is enabled. Why is
> loongson_vcpu_is_preempted() called when nr_cpus=1?
> 
> Huacai
> 
>>
>> Regards
>> Bibo Mao
>>> Huacai
>>>
>>>> +EXPORT_SYMBOL(vcpu_is_preempted);
>>>> diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
>>>> index 46036d98da75..f04192fedf8d 100644
>>>> --- a/arch/loongarch/kernel/smp.c
>>>> +++ b/arch/loongarch/kernel/smp.c
>>>> @@ -307,10 +307,16 @@ static void loongson_init_ipi(void)
>>>>                   panic("IPI IRQ request failed\n");
>>>>    }
>>>>
>>>> +static bool loongson_vcpu_is_preempted(int cpu)
>>>> +{
>>>> +       return false;
>>>> +}
>>>> +
>>>>    struct smp_ops mp_ops = {
>>>>           .init_ipi               = loongson_init_ipi,
>>>>           .send_ipi_single        = loongson_send_ipi_single,
>>>>           .send_ipi_mask          = loongson_send_ipi_mask,
>>>> +       .vcpu_is_preempted      = loongson_vcpu_is_preempted,
>>>>    };
>>>>
>>>>    static void __init fdt_smp_setup(void)
>>>> --
>>>> 2.39.3
>>>>
>>>>
>>
>>


