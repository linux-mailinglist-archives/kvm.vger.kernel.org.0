Return-Path: <kvm+bounces-16227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 195A88B6E3D
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 11:27:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4F722853BC
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 09:27:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73846199E8F;
	Tue, 30 Apr 2024 09:22:04 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B4AB129A72;
	Tue, 30 Apr 2024 09:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714468924; cv=none; b=uZwQfIo2RbNLQW8Vp4Z9gkLopXRo1gxEMDpMdG3gpaCk5DYXcS5MZrUgruo/1GJkMES8mKwb3TewFWSuCWYsSk/XFxrNiXO5vnuk6vhf6BDHpDQA1j/7iqShn9MZ7jp2hbvt6RPCdKlUvCSpvmsr2YYDZro5UmdcuS1CADLzLE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714468924; c=relaxed/simple;
	bh=iYhXku7HTLMjaeeyU6kofVpf2Jfk/V1AqLTcPtAZyd4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=nHc2mwPHxYI1BmtHVKAirvEclGuUP/IG0haCxjTEoKz4FQg7PUmtYTANpPILl9O1IuThvN6xCrcnaqVJBAxC4zBo8a2Rs9bo7EJw43VzCFEg538IT9LB6kxb+NhacKTXB9g9ZwUrj71A3EbUjf7AWuDAoQT7nG4mF0NuRBXKRlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxV_A1uDBm_1oFAA--.18038S3;
	Tue, 30 Apr 2024 17:21:57 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxsFUxuDBmcgILAA--.9409S3;
	Tue, 30 Apr 2024 17:21:55 +0800 (CST)
Subject: Re: [PATCH v2 2/2] LoongArch: Add steal time support in guest side
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, x86@kernel.org, virtualization@lists.linux.dev
References: <20240430014505.2102631-1-maobibo@loongson.cn>
 <20240430014505.2102631-3-maobibo@loongson.cn>
 <CAAhV-H4xN9rdBkSA4PJafr5MNqEiCbNHTgim_bj89YNaB4PFjw@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <1e64a738-5197-8bd2-5977-9d95bdf61a2d@loongson.cn>
Date: Tue, 30 Apr 2024 17:21:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4xN9rdBkSA4PJafr5MNqEiCbNHTgim_bj89YNaB4PFjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxsFUxuDBmcgILAA--.9409S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Wr4DAw4kKw48Ww45Zr15ZFc_yoW3Kr18pF
	ZrCFs3KF48GF97ArsIqrWkWF1Yqrs7Gr12vFy2ka4fAFsFvr1xAr18WryY9Fyku397GF10
	vFyrJrnI9a1Dt3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jY
	SoJUUUUU=



On 2024/4/30 下午4:23, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Tue, Apr 30, 2024 at 9:45 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Percpu struct kvm_steal_time is added here, its size is 64 bytes and
>> also defined as 64 bytes, so that the whole structure is in one physical
>> page.
>>
>> When vcpu is onlined, function pv_enable_steal_time() is called. This
>> function will pass guest physical address of struct kvm_steal_time and
>> tells hypervisor to enable steal time. When vcpu is offline, physical
>> address is set as 0 and tells hypervisor to disable steal time.
>>
>> Here is output of vmstat on guest when there is workload on both host
>> and guest. It includes steal time stat information.
>>
>> procs -----------memory---------- -----io---- -system-- ------cpu-----
>>   r  b   swpd   free  inact active   bi    bo   in   cs us sy id wa st
>> 15  1      0 7583616 184112  72208    20    0  162   52 31  6 43  0 20
>> 17  0      0 7583616 184704  72192    0     0 6318 6885  5 60  8  5 22
>> 16  0      0 7583616 185392  72144    0     0 1766 1081  0 49  0  1 50
>> 16  0      0 7583616 184816  72304    0     0 6300 6166  4 62 12  2 20
>> 18  0      0 7583632 184480  72240    0     0 2814 1754  2 58  4  1 35
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/Kconfig                |  11 +++
>>   arch/loongarch/include/asm/paravirt.h |   5 +
>>   arch/loongarch/kernel/paravirt.c      | 131 ++++++++++++++++++++++++++
>>   arch/loongarch/kernel/time.c          |   2 +
>>   4 files changed, 149 insertions(+)
>>
>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
>> index 0a1540a8853e..f3a03c33a052 100644
>> --- a/arch/loongarch/Kconfig
>> +++ b/arch/loongarch/Kconfig
>> @@ -592,6 +592,17 @@ config PARAVIRT
>>            over full virtualization.  However, when run without a hypervisor
>>            the kernel is theoretically slower and slightly larger.
>>
>> +config PARAVIRT_TIME_ACCOUNTING
>> +       bool "Paravirtual steal time accounting"
>> +       select PARAVIRT
>> +       help
>> +         Select this option to enable fine granularity task steal time
>> +         accounting. Time spent executing other tasks in parallel with
>> +         the current vCPU is discounted from the vCPU power. To account for
>> +         that, there can be a small performance impact.
>> +
>> +         If in doubt, say N here.
>> +
> Can we use a hidden selection manner, which means:
> 
> config PARAVIRT_TIME_ACCOUNTING
>         def_bool PARAVIRT
> 
> Because I think we needn't give too many choices to users (and bring
> much more effort to test).
> 
> PowerPC even hide all the PARAVIRT config options...
> see arch/powerpc/platforms/pseries/Kconfig

I do not know neither :(  It is just used at beginning, maybe there is
negative effect or potential issue, I just think that it can be selected 
by user for easily debugging. After it is matured, hidden selection 
manner can be used.

Regards
Bibo Mao
> 
> Huacai
> 
>>   config ARCH_SUPPORTS_KEXEC
>>          def_bool y
>>
>> diff --git a/arch/loongarch/include/asm/paravirt.h b/arch/loongarch/include/asm/paravirt.h
>> index 58f7b7b89f2c..fe27fb5e82b8 100644
>> --- a/arch/loongarch/include/asm/paravirt.h
>> +++ b/arch/loongarch/include/asm/paravirt.h
>> @@ -17,11 +17,16 @@ static inline u64 paravirt_steal_clock(int cpu)
>>   }
>>
>>   int pv_ipi_init(void);
>> +int __init pv_time_init(void);
>>   #else
>>   static inline int pv_ipi_init(void)
>>   {
>>          return 0;
>>   }
>>
>> +static inline int pv_time_init(void)
>> +{
>> +       return 0;
>> +}
>>   #endif // CONFIG_PARAVIRT
>>   #endif
>> diff --git a/arch/loongarch/kernel/paravirt.c b/arch/loongarch/kernel/paravirt.c
>> index 9044ed62045c..3f83afc7e2d2 100644
>> --- a/arch/loongarch/kernel/paravirt.c
>> +++ b/arch/loongarch/kernel/paravirt.c
>> @@ -5,10 +5,13 @@
>>   #include <linux/jump_label.h>
>>   #include <linux/kvm_para.h>
>>   #include <asm/paravirt.h>
>> +#include <linux/reboot.h>
>>   #include <linux/static_call.h>
>>
>>   struct static_key paravirt_steal_enabled;
>>   struct static_key paravirt_steal_rq_enabled;
>> +static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
>> +static int has_steal_clock;
>>
>>   static u64 native_steal_clock(int cpu)
>>   {
>> @@ -17,6 +20,57 @@ static u64 native_steal_clock(int cpu)
>>
>>   DEFINE_STATIC_CALL(pv_steal_clock, native_steal_clock);
>>
>> +static bool steal_acc = true;
>> +static int __init parse_no_stealacc(char *arg)
>> +{
>> +       steal_acc = false;
>> +       return 0;
>> +}
>> +early_param("no-steal-acc", parse_no_stealacc);
>> +
>> +static u64 para_steal_clock(int cpu)
>> +{
>> +       u64 steal;
>> +       struct kvm_steal_time *src;
>> +       int version;
>> +
>> +       src = &per_cpu(steal_time, cpu);
>> +       do {
>> +
>> +               version = src->version;
>> +               /* Make sure that the version is read before the steal */
>> +               virt_rmb();
>> +               steal = src->steal;
>> +               /* Make sure that the steal is read before the next version */
>> +               virt_rmb();
>> +
>> +       } while ((version & 1) || (version != src->version));
>> +       return steal;
>> +}
>> +
>> +static int pv_enable_steal_time(void)
>> +{
>> +       int cpu = smp_processor_id();
>> +       struct kvm_steal_time *st;
>> +       unsigned long addr;
>> +
>> +       if (!has_steal_clock)
>> +               return -EPERM;
>> +
>> +       st = &per_cpu(steal_time, cpu);
>> +       addr = per_cpu_ptr_to_phys(st);
>> +
>> +       /* The whole structure kvm_steal_time should be one page */
>> +       if (PFN_DOWN(addr) != PFN_DOWN(addr + sizeof(*st))) {
>> +               pr_warn("Illegal PV steal time addr %lx\n", addr);
>> +               return -EFAULT;
>> +       }
>> +
>> +       addr |= KVM_STEAL_PHYS_VALID;
>> +       kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEAL_TIME, addr);
>> +       return 0;
>> +}
>> +
>>   #ifdef CONFIG_SMP
>>   static void pv_send_ipi_single(int cpu, unsigned int action)
>>   {
>> @@ -110,6 +164,32 @@ static void pv_init_ipi(void)
>>          if (r < 0)
>>                  panic("SWI0 IRQ request failed\n");
>>   }
>> +
>> +static void pv_disable_steal_time(void)
>> +{
>> +       if (has_steal_clock)
>> +               kvm_hypercall2(KVM_HCALL_FUNC_NOTIFY, KVM_FEATURE_STEAL_TIME, 0);
>> +}
>> +
>> +static int pv_time_cpu_online(unsigned int cpu)
>> +{
>> +       unsigned long flags;
>> +
>> +       local_irq_save(flags);
>> +       pv_enable_steal_time();
>> +       local_irq_restore(flags);
>> +       return 0;
>> +}
>> +
>> +static int pv_time_cpu_down_prepare(unsigned int cpu)
>> +{
>> +       unsigned long flags;
>> +
>> +       local_irq_save(flags);
>> +       pv_disable_steal_time();
>> +       local_irq_restore(flags);
>> +       return 0;
>> +}
>>   #endif
>>
>>   static bool kvm_para_available(void)
>> @@ -149,3 +229,54 @@ int __init pv_ipi_init(void)
>>
>>          return 1;
>>   }
>> +
>> +static void pv_cpu_reboot(void *unused)
>> +{
>> +       pv_disable_steal_time();
>> +}
>> +
>> +static int pv_reboot_notify(struct notifier_block *nb, unsigned long code,
>> +               void *unused)
>> +{
>> +       on_each_cpu(pv_cpu_reboot, NULL, 1);
>> +       return NOTIFY_DONE;
>> +}
>> +
>> +static struct notifier_block pv_reboot_nb = {
>> +       .notifier_call  = pv_reboot_notify,
>> +};
>> +
>> +int __init pv_time_init(void)
>> +{
>> +       int feature;
>> +
>> +       if (!cpu_has_hypervisor)
>> +               return 0;
>> +       if (!kvm_para_available())
>> +               return 0;
>> +
>> +       feature = read_cpucfg(CPUCFG_KVM_FEATURE);
>> +       if (!(feature & KVM_FEATURE_STEAL_TIME))
>> +               return 0;
>> +
>> +       has_steal_clock = 1;
>> +       if (pv_enable_steal_time()) {
>> +               has_steal_clock = 0;
>> +               return 0;
>> +       }
>> +
>> +       register_reboot_notifier(&pv_reboot_nb);
>> +       static_call_update(pv_steal_clock, para_steal_clock);
>> +       static_key_slow_inc(&paravirt_steal_enabled);
>> +       if (steal_acc)
>> +               static_key_slow_inc(&paravirt_steal_rq_enabled);
>> +
>> +#ifdef CONFIG_SMP
>> +       if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
>> +                       "loongarch/pvi_time:online",
>> +                       pv_time_cpu_online, pv_time_cpu_down_prepare) < 0)
>> +               pr_err("Failed to install cpu hotplug callbacks\n");
>> +#endif
>> +       pr_info("Using stolen time PV\n");
>> +       return 0;
>> +}
>> diff --git a/arch/loongarch/kernel/time.c b/arch/loongarch/kernel/time.c
>> index fd5354f9be7c..46d7d40c87e3 100644
>> --- a/arch/loongarch/kernel/time.c
>> +++ b/arch/loongarch/kernel/time.c
>> @@ -15,6 +15,7 @@
>>
>>   #include <asm/cpu-features.h>
>>   #include <asm/loongarch.h>
>> +#include <asm/paravirt.h>
>>   #include <asm/time.h>
>>
>>   u64 cpu_clock_freq;
>> @@ -214,4 +215,5 @@ void __init time_init(void)
>>
>>          constant_clockevent_init();
>>          constant_clocksource_init();
>> +       pv_time_init();
>>   }
>> --
>> 2.39.3
>>
>>


