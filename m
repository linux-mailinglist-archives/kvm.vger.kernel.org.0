Return-Path: <kvm+bounces-69650-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AGZAMXoIfGnqKAIAu9opvQ
	(envelope-from <kvm+bounces-69650-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 02:25:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7063CB625B
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 02:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9762E301DAD1
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 01:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA78D330320;
	Fri, 30 Jan 2026 01:24:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC0530F7E2;
	Fri, 30 Jan 2026 01:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769736287; cv=none; b=Eep6TCiw9R9EZz5oxjfV9Y0RTPD5p6ARyEsQFvx4MP/dZeOkmHdt2X0TiZiGXfkQbXn5nh1qv51J4ISKo+Gf04UinZxroggjDPWL3aXDCO33bXwaBhsuKwFY4N8z8rn21d4dpwq00+r/QaFB9ir/VvrLCmcim+1lHav4lE5h/C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769736287; c=relaxed/simple;
	bh=+/YP9xBL//FAZcBWX1nSK8KrUC7hfGfloYZQ0w3mkZs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AAZeVDLT0pOuXAZgzFwLRWLnf50HVbjHyyhnirbzswcA81lLd6pMvripusfFw8K+9B+0XtdmOit7cZ1h0a00O768zvq8Qttcs7myolJHp+nOe2oWkvl0XW0VT7RzsdCZ9yjBy8F94uy9YAuRGRQFX9OscJggexZn1mcpEbd79qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxisJYCHxpkh0OAA--.46175S3;
	Fri, 30 Jan 2026 09:24:40 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxGMFUCHxpV985AA--.30825S3;
	Fri, 30 Jan 2026 09:24:39 +0800 (CST)
Subject: Re: [PATCH v4 2/2] LoongArch: Add paravirt support with
 vcpu_is_preempted() in guest side
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Juergen Gross <jgross@suse.com>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 WANG Xuerui <kernel@xen0n.name>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20251219063021.1778659-1-maobibo@loongson.cn>
 <20251219063021.1778659-3-maobibo@loongson.cn>
 <CAAhV-H7N1uXzK6Fu4x4Mrq4j1P95119HP87_spxU_E6WLxN6TQ@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <f0d2671a-1ce7-d499-47cf-8dc9163f1e17@loongson.cn>
Date: Fri, 30 Jan 2026 09:22:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7N1uXzK6Fu4x4Mrq4j1P95119HP87_spxU_E6WLxN6TQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxGMFUCHxpV985AA--.30825S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxGFWUtw47Kr1DKw47AF4rCrX_yoWrAw13pF
	yDAFnYva1xGayxC39Fqr48ur15Jr4kG3WIqF9rWa4rAa1DXrnFyr18K34Y9Fyvv3s7Wa4I
	qrn5WF4aganrAagCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UU
	UUU==
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[loongson.cn:mid,loongson.cn:email,suse.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	DMARC_NA(0.00)[loongson.cn];
	FROM_NEQ_ENVFROM(0.00)[maobibo@loongson.cn,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-69650-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: 7063CB625B
X-Rspamd-Action: no action



On 2026/1/29 下午8:55, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Fri, Dec 19, 2025 at 2:30 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Function vcpu_is_preempted() is used to check whether vCPU is preempted
>> or not. Here add implementation with vcpu_is_preempted() when option
>> CONFIG_PARAVIRT is enabled.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> Acked-by: Juergen Gross <jgross@suse.com>
>> ---
>>   arch/loongarch/include/asm/qspinlock.h |  3 +++
>>   arch/loongarch/kernel/paravirt.c       | 21 ++++++++++++++++++++-
>>   2 files changed, 23 insertions(+), 1 deletion(-)
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
>> index b1b51f920b23..a81a3e871dd1 100644
>> --- a/arch/loongarch/kernel/paravirt.c
>> +++ b/arch/loongarch/kernel/paravirt.c
>> @@ -12,6 +12,7 @@ static int has_steal_clock;
>>   struct static_key paravirt_steal_enabled;
>>   struct static_key paravirt_steal_rq_enabled;
>>   static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
>> +static DEFINE_STATIC_KEY_FALSE(virt_preempt_key);
>>   DEFINE_STATIC_KEY_FALSE(virt_spin_lock_key);
>>
>>   static u64 native_steal_clock(int cpu)
>> @@ -267,6 +268,18 @@ static int pv_time_cpu_down_prepare(unsigned int cpu)
>>
>>          return 0;
>>   }
>> +
>> +bool notrace vcpu_is_preempted(int cpu)
> Is "notrace" really needed? Only S390 do this.

The prefix "notrace" is copied from S390, it is inline function on x86.

Here is git log information with arch/s390/kernel/smp.c
commit 8ebf6da9db1b2a20bb86cc1bee2552e894d03308
Author: Philipp Rudo <prudo@linux.ibm.com>
Date:   Mon Apr 6 20:47:48 2020

     s390/ftrace: fix potential crashes when switching tracers

     Switching tracers include instruction patching. To prevent that a
     instruction is patched while it's read the instruction patching is done
     in stop_machine 'context'. This also means that any function called
     during stop_machine must not be traced. Thus add 'notrace' to all
     functions called within stop_machine.

     Fixes: 1ec2772e0c3c ("s390/diag: add a statistic for diagnose calls")
     Fixes: 38f2c691a4b3 ("s390: improve wait logic of stop_machine")
     Fixes: 4ecf0a43e729 ("processor: get rid of cpu_relax_yield")
     Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
     Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

However I am not familiar with tracer and have no idea about this, that 
is both OK to me. You are Linux kernel expert, what is your opinion 
about notrace prefix?

Regards
Bibo Mao
> 
> Huacai
> 
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
>> @@ -318,7 +334,10 @@ int __init pv_time_init(void)
>>                  static_key_slow_inc(&paravirt_steal_rq_enabled);
>>   #endif
>>
>> -       pr_info("Using paravirt steal-time\n");
>> +       if (static_key_enabled(&virt_preempt_key))
>> +               pr_info("Using paravirt steal-time with preempt enabled\n");
>> +       else
>> +               pr_info("Using paravirt steal-time with preempt disabled\n");
>>
>>          return 0;
>>   }
>> --
>> 2.39.3
>>


