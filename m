Return-Path: <kvm+bounces-7404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87768841973
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 03:42:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F3B72884CC
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 02:42:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5274C36AF0;
	Tue, 30 Jan 2024 02:42:50 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3A536137;
	Tue, 30 Jan 2024 02:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706582569; cv=none; b=LlVVn3nQ7p9tfQU/rvRrfhQrkeIkDj60b5I53nCJeJ64cjw+hUaODrBuFiOCbH8Y21ol006M3sP3J/8gHa1tb2vaf0ocBQZMltDBDJnZQtyYWV6+e6DE8+CXrxCtxjKn6ze4fc/zDumUAaSLWG0uhIxAqYU81h9n+Bz21PN5duo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706582569; c=relaxed/simple;
	bh=6/T/Ou9yv3PagUmCXfnGDxOLz73qUMFIagYLf1f7zsQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=L3TdrIqNBwArOAFJiA5nNlbfIX16umqiMBHwI8lDjHRp4Nyc8QFxPsszXOeW8LGsaUTqbHFOls9pZOYz0lOfH4d6lvRbz1xCriFiB//nah+qmEGlkw/S2YazpYuYfSdB2IIUGdLBWoRNMgNZtpasSCe7veeaIHV3LYcqW7M/9mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8CxLOsfYrhlxCYIAA--.14943S3;
	Tue, 30 Jan 2024 10:42:39 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Ax3c4bYrhl+C0nAA--.22525S3;
	Tue, 30 Jan 2024 10:42:38 +0800 (CST)
Subject: Re: [PATCH v3 1/6] LoongArch/smp: Refine ipi ops on LoongArch
 platform
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240122100313.1589372-1-maobibo@loongson.cn>
 <20240122100313.1589372-2-maobibo@loongson.cn>
 <CAAhV-H6JnfdD1D0rMgDAk7gBWeYZn3ngFsE07_76Sk0Rv7Tksg@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <34f2dce8-0cfe-7e62-bd63-6a634d1fbf31@loongson.cn>
Date: Tue, 30 Jan 2024 10:42:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6JnfdD1D0rMgDAk7gBWeYZn3ngFsE07_76Sk0Rv7Tksg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Ax3c4bYrhl+C0nAA--.22525S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3ZF47urW8tr13tF15JF48Zrc_yoW8GrW3Co
	WftF1xtw48Wry3KF90q3ZaqryUX3Wjg340kas7Ar43CF1jy34qgryxKw1Yva9rGFs5GFsx
	Ga4Sgr40k3y7XFnxl-sFpf9Il3svdjkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUYW7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_Gr1j6F4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
	xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
	xGrwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU2MKZDUUUU



On 2024/1/29 下午8:38, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Mon, Jan 22, 2024 at 6:03 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> This patch refines ipi handling on LoongArch platform, there are
>> three changes with this patch.
>> 1. Add generic get_percpu_irq api, replace some percpu irq function
>> such as get_ipi_irq/get_pmc_irq/get_timer_irq with get_percpu_irq.
>>
>> 2. Change parameter action definition with function
>> loongson_send_ipi_single and loongson_send_ipi_mask. Code encoding is used
>> here rather than bitmap encoding for ipi action, ipi hw sender uses action
>> code, and ipi receiver will get action bitmap encoding, the ipi hw will
>> convert it into bitmap in ipi message buffer.
>>
>> 3. Add smp_ops on LoongArch platform so that pv ipi can be used later.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/hardirq.h |  4 ++
>>   arch/loongarch/include/asm/irq.h     | 10 ++++-
>>   arch/loongarch/include/asm/smp.h     | 31 +++++++--------
>>   arch/loongarch/kernel/irq.c          | 22 +----------
>>   arch/loongarch/kernel/perf_event.c   | 14 +------
>>   arch/loongarch/kernel/smp.c          | 58 +++++++++++++++++++---------
>>   arch/loongarch/kernel/time.c         | 12 +-----
>>   7 files changed, 71 insertions(+), 80 deletions(-)
>>
>> diff --git a/arch/loongarch/include/asm/hardirq.h b/arch/loongarch/include/asm/hardirq.h
>> index 0ef3b18f8980..9f0038e19c7f 100644
>> --- a/arch/loongarch/include/asm/hardirq.h
>> +++ b/arch/loongarch/include/asm/hardirq.h
>> @@ -12,6 +12,10 @@
>>   extern void ack_bad_irq(unsigned int irq);
>>   #define ack_bad_irq ack_bad_irq
>>
>> +enum ipi_msg_type {
>> +       IPI_RESCHEDULE,
>> +       IPI_CALL_FUNCTION,
>> +};
>>   #define NR_IPI 2
>>
>>   typedef struct {
>> diff --git a/arch/loongarch/include/asm/irq.h b/arch/loongarch/include/asm/irq.h
>> index 218b4da0ea90..00101b6d601e 100644
>> --- a/arch/loongarch/include/asm/irq.h
>> +++ b/arch/loongarch/include/asm/irq.h
>> @@ -117,8 +117,16 @@ extern struct fwnode_handle *liointc_handle;
>>   extern struct fwnode_handle *pch_lpc_handle;
>>   extern struct fwnode_handle *pch_pic_handle[MAX_IO_PICS];
>>
>> -extern irqreturn_t loongson_ipi_interrupt(int irq, void *dev);
>> +static inline int get_percpu_irq(int vector)
>> +{
>> +       struct irq_domain *d;
>> +
>> +       d = irq_find_matching_fwnode(cpuintc_handle, DOMAIN_BUS_ANY);
>> +       if (d)
>> +               return irq_create_mapping(d, vector);
>>
>> +       return -EINVAL;
>> +}
>>   #include <asm-generic/irq.h>
>>
>>   #endif /* _ASM_IRQ_H */
>> diff --git a/arch/loongarch/include/asm/smp.h b/arch/loongarch/include/asm/smp.h
>> index f81e5f01d619..330f1cb3741c 100644
>> --- a/arch/loongarch/include/asm/smp.h
>> +++ b/arch/loongarch/include/asm/smp.h
>> @@ -12,6 +12,13 @@
>>   #include <linux/threads.h>
>>   #include <linux/cpumask.h>
>>
>> +struct smp_ops {
>> +       void (*call_func_ipi)(const struct cpumask *mask, unsigned int action);
>> +       void (*call_func_single_ipi)(int cpu, unsigned int action);
> To keep consistency, it is better to use call_func_ipi_single and
> call_func_ipi_mask.
yes, how about using send_ipi_single/send_ipi_mask here? since both 
function arch_smp_send_reschedule() and 
arch_send_call_function_single_ipi use smp_ops.

> 
>> +       void (*ipi_init)(void);
>> +};
>> +
>> +extern struct smp_ops smp_ops;
>>   extern int smp_num_siblings;
>>   extern int num_processors;
>>   extern int disabled_cpus;
>> @@ -24,8 +31,6 @@ void loongson_prepare_cpus(unsigned int max_cpus);
>>   void loongson_boot_secondary(int cpu, struct task_struct *idle);
>>   void loongson_init_secondary(void);
>>   void loongson_smp_finish(void);
>> -void loongson_send_ipi_single(int cpu, unsigned int action);
>> -void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int action);
>>   #ifdef CONFIG_HOTPLUG_CPU
>>   int loongson_cpu_disable(void);
>>   void loongson_cpu_die(unsigned int cpu);
>> @@ -59,9 +64,12 @@ extern int __cpu_logical_map[NR_CPUS];
>>
>>   #define cpu_physical_id(cpu)   cpu_logical_map(cpu)
>>
>> -#define SMP_BOOT_CPU           0x1
>> -#define SMP_RESCHEDULE         0x2
>> -#define SMP_CALL_FUNCTION      0x4
>> +#define ACTTION_BOOT_CPU       0
>> +#define ACTTION_RESCHEDULE     1
>> +#define ACTTION_CALL_FUNCTION  2
>> +#define SMP_BOOT_CPU           BIT(ACTTION_BOOT_CPU)
>> +#define SMP_RESCHEDULE         BIT(ACTTION_RESCHEDULE)
>> +#define SMP_CALL_FUNCTION      BIT(ACTTION_CALL_FUNCTION)
>>
>>   struct secondary_data {
>>          unsigned long stack;
>> @@ -71,7 +79,8 @@ extern struct secondary_data cpuboot_data;
>>
>>   extern asmlinkage void smpboot_entry(void);
>>   extern asmlinkage void start_secondary(void);
>> -
>> +extern void arch_send_call_function_single_ipi(int cpu);
>> +extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
> Similarly, to keep consistency, it is better to use
> arch_send_function_ipi_single and arch_send_function_ipi_mask.
These two functions are used by all architectures and called in commcon 
code send_call_function_single_ipi(). It is the same with removed static 
inline function as follows:

  -static inline void arch_send_call_function_single_ipi(int cpu)
  -{
  -       loongson_send_ipi_single(cpu, SMP_CALL_FUNCTION);
  -}
  -
  -static inline void arch_send_call_function_ipi_mask(const struct 
cpumask *mask)
  -{
  -       loongson_send_ipi_mask(mask, SMP_CALL_FUNCTION);
  -}
  -

Regards
Bibo Mao

> 
> Huacai
> 
>>   extern void calculate_cpu_foreign_map(void);
>>
>>   /*
>> @@ -79,16 +88,6 @@ extern void calculate_cpu_foreign_map(void);
>>    */
>>   extern void show_ipi_list(struct seq_file *p, int prec);
>>
>> -static inline void arch_send_call_function_single_ipi(int cpu)
>> -{
>> -       loongson_send_ipi_single(cpu, SMP_CALL_FUNCTION);
>> -}
>> -
>> -static inline void arch_send_call_function_ipi_mask(const struct cpumask *mask)
>> -{
>> -       loongson_send_ipi_mask(mask, SMP_CALL_FUNCTION);
>> -}
>> -
>>   #ifdef CONFIG_HOTPLUG_CPU
>>   static inline int __cpu_disable(void)
>>   {
>> diff --git a/arch/loongarch/kernel/irq.c b/arch/loongarch/kernel/irq.c
>> index 883e5066ae44..1b58f7c3eed9 100644
>> --- a/arch/loongarch/kernel/irq.c
>> +++ b/arch/loongarch/kernel/irq.c
>> @@ -87,23 +87,9 @@ static void __init init_vec_parent_group(void)
>>          acpi_table_parse(ACPI_SIG_MCFG, early_pci_mcfg_parse);
>>   }
>>
>> -static int __init get_ipi_irq(void)
>> -{
>> -       struct irq_domain *d = irq_find_matching_fwnode(cpuintc_handle, DOMAIN_BUS_ANY);
>> -
>> -       if (d)
>> -               return irq_create_mapping(d, INT_IPI);
>> -
>> -       return -EINVAL;
>> -}
>> -
>>   void __init init_IRQ(void)
>>   {
>>          int i;
>> -#ifdef CONFIG_SMP
>> -       int r, ipi_irq;
>> -       static int ipi_dummy_dev;
>> -#endif
>>          unsigned int order = get_order(IRQ_STACK_SIZE);
>>          struct page *page;
>>
>> @@ -113,13 +99,7 @@ void __init init_IRQ(void)
>>          init_vec_parent_group();
>>          irqchip_init();
>>   #ifdef CONFIG_SMP
>> -       ipi_irq = get_ipi_irq();
>> -       if (ipi_irq < 0)
>> -               panic("IPI IRQ mapping failed\n");
>> -       irq_set_percpu_devid(ipi_irq);
>> -       r = request_percpu_irq(ipi_irq, loongson_ipi_interrupt, "IPI", &ipi_dummy_dev);
>> -       if (r < 0)
>> -               panic("IPI IRQ request failed\n");
>> +       smp_ops.ipi_init();
>>   #endif
>>
>>          for (i = 0; i < NR_IRQS; i++)
>> diff --git a/arch/loongarch/kernel/perf_event.c b/arch/loongarch/kernel/perf_event.c
>> index 0491bf453cd4..3265c8f33223 100644
>> --- a/arch/loongarch/kernel/perf_event.c
>> +++ b/arch/loongarch/kernel/perf_event.c
>> @@ -456,16 +456,6 @@ static void loongarch_pmu_disable(struct pmu *pmu)
>>   static DEFINE_MUTEX(pmu_reserve_mutex);
>>   static atomic_t active_events = ATOMIC_INIT(0);
>>
>> -static int get_pmc_irq(void)
>> -{
>> -       struct irq_domain *d = irq_find_matching_fwnode(cpuintc_handle, DOMAIN_BUS_ANY);
>> -
>> -       if (d)
>> -               return irq_create_mapping(d, INT_PCOV);
>> -
>> -       return -EINVAL;
>> -}
>> -
>>   static void reset_counters(void *arg);
>>   static int __hw_perf_event_init(struct perf_event *event);
>>
>> @@ -473,7 +463,7 @@ static void hw_perf_event_destroy(struct perf_event *event)
>>   {
>>          if (atomic_dec_and_mutex_lock(&active_events, &pmu_reserve_mutex)) {
>>                  on_each_cpu(reset_counters, NULL, 1);
>> -               free_irq(get_pmc_irq(), &loongarch_pmu);
>> +               free_irq(get_percpu_irq(INT_PCOV), &loongarch_pmu);
>>                  mutex_unlock(&pmu_reserve_mutex);
>>          }
>>   }
>> @@ -562,7 +552,7 @@ static int loongarch_pmu_event_init(struct perf_event *event)
>>          if (event->cpu >= 0 && !cpu_online(event->cpu))
>>                  return -ENODEV;
>>
>> -       irq = get_pmc_irq();
>> +       irq = get_percpu_irq(INT_PCOV);
>>          flags = IRQF_PERCPU | IRQF_NOBALANCING | IRQF_NO_THREAD | IRQF_NO_SUSPEND | IRQF_SHARED;
>>          if (!atomic_inc_not_zero(&active_events)) {
>>                  mutex_lock(&pmu_reserve_mutex);
>> diff --git a/arch/loongarch/kernel/smp.c b/arch/loongarch/kernel/smp.c
>> index a16e3dbe9f09..46735ba49815 100644
>> --- a/arch/loongarch/kernel/smp.c
>> +++ b/arch/loongarch/kernel/smp.c
>> @@ -66,11 +66,6 @@ static cpumask_t cpu_core_setup_map;
>>   struct secondary_data cpuboot_data;
>>   static DEFINE_PER_CPU(int, cpu_state);
>>
>> -enum ipi_msg_type {
>> -       IPI_RESCHEDULE,
>> -       IPI_CALL_FUNCTION,
>> -};
>> -
>>   static const char *ipi_types[NR_IPI] __tracepoint_string = {
>>          [IPI_RESCHEDULE] = "Rescheduling interrupts",
>>          [IPI_CALL_FUNCTION] = "Function call interrupts",
>> @@ -123,24 +118,19 @@ static u32 ipi_read_clear(int cpu)
>>
>>   static void ipi_write_action(int cpu, u32 action)
>>   {
>> -       unsigned int irq = 0;
>> -
>> -       while ((irq = ffs(action))) {
>> -               uint32_t val = IOCSR_IPI_SEND_BLOCKING;
>> +       uint32_t val;
>>
>> -               val |= (irq - 1);
>> -               val |= (cpu << IOCSR_IPI_SEND_CPU_SHIFT);
>> -               iocsr_write32(val, LOONGARCH_IOCSR_IPI_SEND);
>> -               action &= ~BIT(irq - 1);
>> -       }
>> +       val = IOCSR_IPI_SEND_BLOCKING | action;
>> +       val |= (cpu << IOCSR_IPI_SEND_CPU_SHIFT);
>> +       iocsr_write32(val, LOONGARCH_IOCSR_IPI_SEND);
>>   }
>>
>> -void loongson_send_ipi_single(int cpu, unsigned int action)
>> +static void loongson_send_ipi_single(int cpu, unsigned int action)
>>   {
>>          ipi_write_action(cpu_logical_map(cpu), (u32)action);
>>   }
>>
>> -void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int action)
>> +static void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int action)
>>   {
>>          unsigned int i;
>>
>> @@ -148,6 +138,16 @@ void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int action)
>>                  ipi_write_action(cpu_logical_map(i), (u32)action);
>>   }
>>
>> +void arch_send_call_function_single_ipi(int cpu)
>> +{
>> +       smp_ops.call_func_single_ipi(cpu, ACTTION_CALL_FUNCTION);
>> +}
>> +
>> +void arch_send_call_function_ipi_mask(const struct cpumask *mask)
>> +{
>> +       smp_ops.call_func_ipi(mask, ACTTION_CALL_FUNCTION);
>> +}
>> +
>>   /*
>>    * This function sends a 'reschedule' IPI to another CPU.
>>    * it goes straight through and wastes no time serializing
>> @@ -155,11 +155,11 @@ void loongson_send_ipi_mask(const struct cpumask *mask, unsigned int action)
>>    */
>>   void arch_smp_send_reschedule(int cpu)
>>   {
>> -       loongson_send_ipi_single(cpu, SMP_RESCHEDULE);
>> +       smp_ops.call_func_single_ipi(cpu, ACTTION_RESCHEDULE);
>>   }
>>   EXPORT_SYMBOL_GPL(arch_smp_send_reschedule);
>>
>> -irqreturn_t loongson_ipi_interrupt(int irq, void *dev)
>> +static irqreturn_t loongson_ipi_interrupt(int irq, void *dev)
>>   {
>>          unsigned int action;
>>          unsigned int cpu = smp_processor_id();
>> @@ -179,6 +179,26 @@ irqreturn_t loongson_ipi_interrupt(int irq, void *dev)
>>          return IRQ_HANDLED;
>>   }
>>
>> +static void loongson_ipi_init(void)
>> +{
>> +       int r, ipi_irq;
>> +
>> +       ipi_irq = get_percpu_irq(INT_IPI);
>> +       if (ipi_irq < 0)
>> +               panic("IPI IRQ mapping failed\n");
>> +
>> +       irq_set_percpu_devid(ipi_irq);
>> +       r = request_percpu_irq(ipi_irq, loongson_ipi_interrupt, "IPI", &irq_stat);
>> +       if (r < 0)
>> +               panic("IPI IRQ request failed\n");
>> +}
>> +
>> +struct smp_ops smp_ops = {
>> +       .call_func_single_ipi   = loongson_send_ipi_single,
>> +       .call_func_ipi          = loongson_send_ipi_mask,
>> +       .ipi_init               = loongson_ipi_init,
>> +};
>> +
>>   static void __init fdt_smp_setup(void)
>>   {
>>   #ifdef CONFIG_OF
>> @@ -256,7 +276,7 @@ void loongson_boot_secondary(int cpu, struct task_struct *idle)
>>
>>          csr_mail_send(entry, cpu_logical_map(cpu), 0);
>>
>> -       loongson_send_ipi_single(cpu, SMP_BOOT_CPU);
>> +       loongson_send_ipi_single(cpu, ACTTION_BOOT_CPU);
>>   }
>>
>>   /*
>> diff --git a/arch/loongarch/kernel/time.c b/arch/loongarch/kernel/time.c
>> index e7015f7b70e3..fd5354f9be7c 100644
>> --- a/arch/loongarch/kernel/time.c
>> +++ b/arch/loongarch/kernel/time.c
>> @@ -123,16 +123,6 @@ void sync_counter(void)
>>          csr_write64(init_offset, LOONGARCH_CSR_CNTC);
>>   }
>>
>> -static int get_timer_irq(void)
>> -{
>> -       struct irq_domain *d = irq_find_matching_fwnode(cpuintc_handle, DOMAIN_BUS_ANY);
>> -
>> -       if (d)
>> -               return irq_create_mapping(d, INT_TI);
>> -
>> -       return -EINVAL;
>> -}
>> -
>>   int constant_clockevent_init(void)
>>   {
>>          unsigned int cpu = smp_processor_id();
>> @@ -142,7 +132,7 @@ int constant_clockevent_init(void)
>>          static int irq = 0, timer_irq_installed = 0;
>>
>>          if (!timer_irq_installed) {
>> -               irq = get_timer_irq();
>> +               irq = get_percpu_irq(INT_TI);
>>                  if (irq < 0)
>>                          pr_err("Failed to map irq %d (timer)\n", irq);
>>          }
>> --
>> 2.39.3
>>


