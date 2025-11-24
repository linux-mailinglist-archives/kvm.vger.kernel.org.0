Return-Path: <kvm+bounces-64320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D72D4C7F24B
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 08:03:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1C25434544E
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 07:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4522E173B;
	Mon, 24 Nov 2025 07:03:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17DA52DEA93;
	Mon, 24 Nov 2025 07:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763967807; cv=none; b=fWJs6XlHVDFdtonUs8PNEjNZnOSNV5ypimVG/Yl5hNwNtvHc9RKhC5fEHyYfGx6dzdxXMDcwOIGWnPNtaYliasbqEQB0uZcJ9xZLUKgTQoqmFHZJqPanp7SnQ/Iqm6cyJKZVIk3CUrD7qBqEqAUIyoZZOQizJYkfM+L0xe5cE5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763967807; c=relaxed/simple;
	bh=nNKlhslL58Mk3Km4cfnD+sRsBwRSueImuegT0waTnoA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gU3Sr1ezRssVzZjJldGTB/DB4iBcD07x+QK9Jz6AJj6gYLpskSj1plX7zVW1XSYMmtyL3OhHe1FSEDvgcptN7CFluZIKus8RI6EtHF507ZkPvLVex2+OUEts12NK+Pg0Jtopf/qNR0ORylWD1YdSaVaP3XwE3QaLe2UxAw8Pe80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Axjr81AyRpKGgnAA--.17367S3;
	Mon, 24 Nov 2025 15:03:17 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxfcEqAyRpKnc9AQ--.46352S3;
	Mon, 24 Nov 2025 15:03:15 +0800 (CST)
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
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <5d80c452-bbc3-539a-fb8d-14dbe353f8cb@loongson.cn>
Date: Mon, 24 Nov 2025 15:00:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5Oag+mDp0CfZ1VDeapeKas354j68JZN9bN42=D4huowA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxfcEqAyRpKnc9AQ--.46352S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJF1ktFyUur48KF4DCF17Arc_yoW5uF4UpF
	ykCFnYva1xGw1xA39Ivr1DCrn8tr4kW3WIqa42ka4rAF4qvr1DJr4v934q9Fy0gwn29a10
	qF93GFsIkFn7t3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUtVW8ZwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j7BMNUUU
	UU=



On 2025/11/24 下午2:33, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Mon, Nov 24, 2025 at 11:54 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Function vcpu_is_preempted() is used to check whether vCPU is preempted
>> or not. Here add implementation with vcpu_is_preempted() when option
>> CONFIG_PARAVIRT is enabled.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/qspinlock.h |  5 +++++
>>   arch/loongarch/kernel/paravirt.c       | 16 ++++++++++++++++
>>   2 files changed, 21 insertions(+)
>>
>> diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch/include/asm/qspinlock.h
>> index e76d3aa1e1eb..9a5b7ba1f4cb 100644
>> --- a/arch/loongarch/include/asm/qspinlock.h
>> +++ b/arch/loongarch/include/asm/qspinlock.h
>> @@ -34,6 +34,11 @@ static inline bool virt_spin_lock(struct qspinlock *lock)
>>          return true;
>>   }
>>
>> +#ifdef CONFIG_SMP
>> +#define vcpu_is_preempted      vcpu_is_preempted
>> +bool vcpu_is_preempted(int cpu);
> In V1 there is a build error because you reference mp_ops, so in V2
> you needn't put it in CONFIG_SMP.
The compile failure problem is that vcpu_is_preempted() is redefined in 
both arch/loongarch/kernel/paravirt.c and include/linux/sched.h

The problem is that <asm/spinlock.h> is not included by sched.h, if 
CONFIG_SMP is disabled. Here is part of file include/linux/spinlock.h
#ifdef CONFIG_SMP
# include <asm/spinlock.h>
#else
# include <linux/spinlock_up.h>
#endif

> On the other hand, even if you really build a UP guest kernel, when
> multiple guests run together, you probably need vcpu_is_preemtped.
It is not relative with multiple VMs. When vcpu_is_preempted() is 
called, it is to detect whether dest CPU is preempted or not, the cpu 
from smp_processor_id() should not be preempted. So in generic 
vcpu_is_preempted() works on multiple vCPUs.

Regards
Bibo Mao
> 
> 
> Huacai
> 
>> +#endif
>> +
>>   #endif /* CONFIG_PARAVIRT */
>>
>>   #include <asm-generic/qspinlock.h>
>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
>> index b1b51f920b23..d4163679adc4 100644
>> --- a/arch/loongarch/kernel/paravirt.c
>> +++ b/arch/loongarch/kernel/paravirt.c
>> @@ -246,6 +246,7 @@ static void pv_disable_steal_time(void)
>>   }
>>
>>   #ifdef CONFIG_SMP
>> +DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
>>   static int pv_time_cpu_online(unsigned int cpu)
>>   {
>>          unsigned long flags;
>> @@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigned int cpu)
>>
>>          return 0;
>>   }
>> +
>> +bool notrace vcpu_is_preempted(int cpu)
>> +{
>> +       struct kvm_steal_time *src;
>> +
>> +       if (!static_branch_unlikely(&virt_preempt_key))
>> +               return false;
>> +
>> +       src = &per_cpu(steal_time, cpu);
>> +       return !!(src->preempted & KVM_VCPU_PREEMPTED);
>> +}
>> +EXPORT_SYMBOL(vcpu_is_preempted);
>>   #endif
>>
>>   static void pv_cpu_reboot(void *unused)
>> @@ -308,6 +321,9 @@ int __init pv_time_init(void)
>>                  pr_err("Failed to install cpu hotplug callbacks\n");
>>                  return r;
>>          }
>> +
>> +       if (kvm_para_has_feature(KVM_FEATURE_PREEMPT))
>> +               static_branch_enable(&virt_preempt_key);
>>   #endif
>>
>>          static_call_update(pv_steal_clock, paravt_steal_clock);
>> --
>> 2.39.3
>>


