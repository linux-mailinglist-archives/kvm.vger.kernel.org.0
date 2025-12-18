Return-Path: <kvm+bounces-66255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C330CCBC09
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 13:15:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DA71830A6B17
	for <lists+kvm@lfdr.de>; Thu, 18 Dec 2025 12:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E26132E72C;
	Thu, 18 Dec 2025 12:12:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74D532E157;
	Thu, 18 Dec 2025 12:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766059976; cv=none; b=R0A5Fl1Vo6KF7yEqKUwcXGZL4X4KErFbUqFmiuPfgd2ncuY1q+FamfqQmTFFli5eCg2loKiDaSelV/YmLEjV49TS5nM4DyAkELGdNcIYzo5Dlk2rtDgAaLY9QomnW9DajhFyKx1Xsw/PcqpA+KGftmr1IWSf5gzIXTyrQQxbM7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766059976; c=relaxed/simple;
	bh=/Lag984MhuskRtOVAooSzdmrvbrlYsL+tVPR06diles=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NcYMkEuIFwkMBTQVe2gaHvMv7FIel2Ygk4lmMN+Ps4fALnWfBaOeGh4+l3CXlsjshylqIubPi59Jf6sT485GQuKxpJt6+etuR/76Gpue5bHRDWQMqON/+GL+69+GvrhsYp1CoSyL3UeIO5xnGc9QI6H+evE+Lak0X+kXP1c9I6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxMvG770Np33UAAA--.2059S3;
	Thu, 18 Dec 2025 20:12:43 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxLMK370NpSFIBAA--.2641S3;
	Thu, 18 Dec 2025 20:12:41 +0800 (CST)
Subject: Re: [PATCH v3 2/2] LoongArch: Add paravirt support with
 vcpu_is_preempted() in guest side
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, WANG Xuerui <kernel@xen0n.name>,
 Juergen Gross <jgross@suse.com>, Ajay Kaher <ajay.kaher@broadcom.com>,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, x86@kernel.org
References: <20251202024833.1714363-1-maobibo@loongson.cn>
 <20251202024833.1714363-3-maobibo@loongson.cn>
 <CAAhV-H6D_XxGTgWjzO26JtBcNeaouqrzH1wTaCn7xK3HGtZ55w@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <c9e3cd01-0c88-adc2-fdd1-ed85414c7550@loongson.cn>
Date: Thu, 18 Dec 2025 20:10:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6D_XxGTgWjzO26JtBcNeaouqrzH1wTaCn7xK3HGtZ55w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxLMK370NpSFIBAA--.2641S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxJw4xGryfCFy5ury7Ar1kWFX_yoW5tF1fpa
	4DAFs5Ka1xG34xC39xtr4Durn8tryvg3WIva47ua45A34DZwnrJr10gryY9FykXwn7WF4I
	qFn3WFsI9F42yagCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8
	JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcpBTUU
	UUU



On 2025/12/6 下午9:04, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Tue, Dec 2, 2025 at 10:48 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Function vcpu_is_preempted() is used to check whether vCPU is preempted
>> or not. Here add implementation with vcpu_is_preempted() when option
>> CONFIG_PARAVIRT is enabled.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/qspinlock.h |  3 +++
>>   arch/loongarch/kernel/paravirt.c       | 23 ++++++++++++++++++++++-
>>   2 files changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/loongarch/include/asm/qspinlock.h b/arch/loongarch/include/asm/qspinlock.h
>> index e76d3aa1e1eb..fa3eaf7e48f2 100644
>> --- a/arch/loongarch/include/asm/qspinlock.h
>> +++ b/arch/loongarch/include/asm/qspinlock.h
>> @@ -34,6 +34,9 @@ static inline bool virt_spin_lock(struct qspinlock *lock)
>>          return true;
>>   }
>>
>> +#define vcpu_is_preempted      vcpu_is_preempted
>> +bool vcpu_is_preempted(int cpu);
>> +
>>   #endif /* CONFIG_PARAVIRT */
>>
>>   #include <asm-generic/qspinlock.h>
>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
>> index b1b51f920b23..b61a93c6aec8 100644
>> --- a/arch/loongarch/kernel/paravirt.c
>> +++ b/arch/loongarch/kernel/paravirt.c
>> @@ -246,6 +246,7 @@ static void pv_disable_steal_time(void)
>>   }
>>
>>   #ifdef CONFIG_SMP
>> +static DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
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
>> @@ -318,7 +334,12 @@ int __init pv_time_init(void)
>>                  static_key_slow_inc(&paravirt_steal_rq_enabled);
>>   #endif
>>
>> -       pr_info("Using paravirt steal-time\n");
>> +#ifdef CONFIG_SMP
> 
> Linux kernel is removing non-SMP step by step [1].
> https://kernelnewbies.org/Linux_6.17#Unconditionally_compile_task_scheduler_with_SMP_support
> 
> Though we cannot remove all "#ifdef CONFIG_SMP" at present, we can at
> least stop adding more.
> 
> So I prefer to make this whole patch out of CONFIG_SMP. But if you
> don't like this, you can at least move the virt_preempt_key
> declaration out of "#ifdef CONFIG_SMP", then the #ifdefs here can be
> removed.
Sorry, I just notice this mail.
Will move virt_preempt_key out of CONFIG_SMP in next version.

Regards
Bibo Mao
> 
> Huacai
> 
>> +       if (static_key_enabled(&virt_preempt_key))
>> +               pr_info("Using paravirt steal-time with preempt enabled\n");
>> +       else
>> +#endif
>> +               pr_info("Using paravirt steal-time with preempt disabled\n");
>>
>>          return 0;
>>   }
>> --
>> 2.39.3
>>
>>


