Return-Path: <kvm+bounces-7409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 320508419A6
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 03:53:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 86223B22777
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 02:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A088537147;
	Tue, 30 Jan 2024 02:53:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7F3B36AE5;
	Tue, 30 Jan 2024 02:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706583220; cv=none; b=e1oaZGaCCFRP32LjZzHPmMY01gG1IJvSQQl5rkllkCdYKpmckVvTApum7oQm4Wojeif/Y2jjE6tMgxVZsjghwZiMXCbm5asizMx/wa4lxmU1keuV3GbUjt4xn3v2jrOHoT7Ji691lqKdl3+tpmoXoYShH4yEnaDZgpXHoBekP3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706583220; c=relaxed/simple;
	bh=YrbQdD+eo9d7Jj5fQMIFOCeXuMJDBSdXMrjxAhVvvNg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=l57klFn7Ny926K1vdQWjSExgpeNd6IPS7IStjHc4qE1Huqrh6nR09cBAZ8MtTla5X9uH+cm3xsgZNzbs7x1aKit8E8uOJ2bHzvJzLlpvhrxGV0YLp+8XE35uWj9YWDqaQZ1YZX1G3OxGsjvKZmsSO8EH06RdPqIsRP2f5WkKVVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8DxJ+iuZLhlsScIAA--.5503S3;
	Tue, 30 Jan 2024 10:53:34 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxfs2rZLhllzEnAA--.20893S3;
	Tue, 30 Jan 2024 10:53:33 +0800 (CST)
Subject: Re: [PATCH v3 5/6] LoongArch: KVM: Add physical cpuid map support
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240122100313.1589372-1-maobibo@loongson.cn>
 <20240122100313.1589372-6-maobibo@loongson.cn>
 <CAAhV-H78HiRRsdsVHxYBYOEWew9FKDSF++bK_=g=UbBKc46d2Q@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <c1b96019-43b6-1d1e-127d-0e52f18d36ff@loongson.cn>
Date: Tue, 30 Jan 2024 10:53:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H78HiRRsdsVHxYBYOEWew9FKDSF++bK_=g=UbBKc46d2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dxfs2rZLhllzEnAA--.20893S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3XryDWFyfWw43KrW8Ar43Jwc_yoW3tFyUpF
	yq9an8WrWrJr17Kw10qw1Dur9IvrWvgr1a9asrtay5Ar1qvryrZrZYkrW5uF98Jw1rWFs2
	vF1UJ3W5uF4FyacCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	tVWrXwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU4AhLUUUUU



On 2024/1/29 下午9:11, Huacai Chen wrote:
> Hi, Bibo,
> 
> Without this patch I can also create a SMP VM, so what problem does
> this patch want to solve?
With ipi irqchip, physical cpuid is used for dest cpu rather than 
logical cpuid. And if ipi device is emulated in qemu side, there is 
find_cpu_by_archid to get dest vcpu in file hw/intc/loongarch_ipi.c

Here with hypercall method, ipi is emulated in kvm kernel side, there
should be the same physical cpuid searching logic. And function 
kvm_get_vcpu_by_cpuid is used with pv_ipi backend.

Regards
Bibo Mao

> 
> Huacai
> 
> On Mon, Jan 22, 2024 at 6:03 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Physical cpuid is used to irq routing for irqchips such as ipi/msi/
>> extioi interrupt controller. And physical cpuid is stored at CSR
>> register LOONGARCH_CSR_CPUID, it can not be changed once vcpu is
>> created. Since different irqchips have different size definition
>> about physical cpuid, KVM uses the smallest cpuid from extioi, and
>> the max cpuid size is defines as 256.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_host.h | 26 ++++++++
>>   arch/loongarch/include/asm/kvm_vcpu.h |  1 +
>>   arch/loongarch/kvm/vcpu.c             | 93 ++++++++++++++++++++++++++-
>>   arch/loongarch/kvm/vm.c               | 11 ++++
>>   4 files changed, 130 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> index 2d62f7b0d377..57399d7cf8b7 100644
>> --- a/arch/loongarch/include/asm/kvm_host.h
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -64,6 +64,30 @@ struct kvm_world_switch {
>>
>>   #define MAX_PGTABLE_LEVELS     4
>>
>> +/*
>> + * Physical cpu id is used for interrupt routing, there are different
>> + * definitions about physical cpuid on different hardwares.
>> + *  For LOONGARCH_CSR_CPUID register, max cpuid size if 512
>> + *  For IPI HW, max dest CPUID size 1024
>> + *  For extioi interrupt controller, max dest CPUID size is 256
>> + *  For MSI interrupt controller, max supported CPUID size is 65536
>> + *
>> + * Currently max CPUID is defined as 256 for KVM hypervisor, in future
>> + * it will be expanded to 4096, including 16 packages at most. And every
>> + * package supports at most 256 vcpus
>> + */
>> +#define KVM_MAX_PHYID          256
>> +
>> +struct kvm_phyid_info {
>> +       struct kvm_vcpu *vcpu;
>> +       bool            enabled;
>> +};
>> +
>> +struct kvm_phyid_map {
>> +       int max_phyid;
>> +       struct kvm_phyid_info phys_map[KVM_MAX_PHYID];
>> +};
>> +
>>   struct kvm_arch {
>>          /* Guest physical mm */
>>          kvm_pte_t *pgd;
>> @@ -71,6 +95,8 @@ struct kvm_arch {
>>          unsigned long invalid_ptes[MAX_PGTABLE_LEVELS];
>>          unsigned int  pte_shifts[MAX_PGTABLE_LEVELS];
>>          unsigned int  root_level;
>> +       struct mutex  phyid_map_lock;
>> +       struct kvm_phyid_map  *phyid_map;
>>
>>          s64 time_offset;
>>          struct kvm_context __percpu *vmcs;
>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
>> index e71ceb88f29e..2402129ee955 100644
>> --- a/arch/loongarch/include/asm/kvm_vcpu.h
>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
>> @@ -81,6 +81,7 @@ void kvm_save_timer(struct kvm_vcpu *vcpu);
>>   void kvm_restore_timer(struct kvm_vcpu *vcpu);
>>
>>   int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, struct kvm_interrupt *irq);
>> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpuid);
>>
>>   /*
>>    * Loongarch KVM guest interrupt handling
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index 27701991886d..97ca9c7160e6 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -274,6 +274,95 @@ static int _kvm_getcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 *val)
>>          return 0;
>>   }
>>
>> +static inline int kvm_set_cpuid(struct kvm_vcpu *vcpu, u64 val)
>> +{
>> +       int cpuid;
>> +       struct loongarch_csrs *csr = vcpu->arch.csr;
>> +       struct kvm_phyid_map  *map;
>> +
>> +       if (val >= KVM_MAX_PHYID)
>> +               return -EINVAL;
>> +
>> +       cpuid = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
>> +       map = vcpu->kvm->arch.phyid_map;
>> +       mutex_lock(&vcpu->kvm->arch.phyid_map_lock);
>> +       if (map->phys_map[cpuid].enabled) {
>> +               /*
>> +                * Cpuid is already set before
>> +                * Forbid changing different cpuid at runtime
>> +                */
>> +               if (cpuid != val) {
>> +                       /*
>> +                        * Cpuid 0 is initial value for vcpu, maybe invalid
>> +                        * unset value for vcpu
>> +                        */
>> +                       if (cpuid) {
>> +                               mutex_unlock(&vcpu->kvm->arch.phyid_map_lock);
>> +                               return -EINVAL;
>> +                       }
>> +               } else {
>> +                        /* Discard duplicated cpuid set */
>> +                       mutex_unlock(&vcpu->kvm->arch.phyid_map_lock);
>> +                       return 0;
>> +               }
>> +       }
>> +
>> +       if (map->phys_map[val].enabled) {
>> +               /*
>> +                * New cpuid is already set with other vcpu
>> +                * Forbid sharing the same cpuid between different vcpus
>> +                */
>> +               if (map->phys_map[val].vcpu != vcpu) {
>> +                       mutex_unlock(&vcpu->kvm->arch.phyid_map_lock);
>> +                       return -EINVAL;
>> +               }
>> +
>> +               /* Discard duplicated cpuid set operation*/
>> +               mutex_unlock(&vcpu->kvm->arch.phyid_map_lock);
>> +               return 0;
>> +       }
>> +
>> +       kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, val);
>> +       map->phys_map[val].enabled      = true;
>> +       map->phys_map[val].vcpu         = vcpu;
>> +       if (map->max_phyid < val)
>> +               map->max_phyid = val;
>> +       mutex_unlock(&vcpu->kvm->arch.phyid_map_lock);
>> +       return 0;
>> +}
>> +
>> +struct kvm_vcpu *kvm_get_vcpu_by_cpuid(struct kvm *kvm, int cpuid)
>> +{
>> +       struct kvm_phyid_map  *map;
>> +
>> +       if (cpuid >= KVM_MAX_PHYID)
>> +               return NULL;
>> +
>> +       map = kvm->arch.phyid_map;
>> +       if (map->phys_map[cpuid].enabled)
>> +               return map->phys_map[cpuid].vcpu;
>> +
>> +       return NULL;
>> +}
>> +
>> +static inline void kvm_drop_cpuid(struct kvm_vcpu *vcpu)
>> +{
>> +       int cpuid;
>> +       struct loongarch_csrs *csr = vcpu->arch.csr;
>> +       struct kvm_phyid_map  *map;
>> +
>> +       map = vcpu->kvm->arch.phyid_map;
>> +       cpuid = kvm_read_sw_gcsr(csr, LOONGARCH_CSR_ESTAT);
>> +       if (cpuid >= KVM_MAX_PHYID)
>> +               return;
>> +
>> +       if (map->phys_map[cpuid].enabled) {
>> +               map->phys_map[cpuid].vcpu = NULL;
>> +               map->phys_map[cpuid].enabled = false;
>> +               kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, 0);
>> +       }
>> +}
>> +
>>   static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>>   {
>>          int ret = 0, gintc;
>> @@ -291,7 +380,8 @@ static int _kvm_setcsr(struct kvm_vcpu *vcpu, unsigned int id, u64 val)
>>                  kvm_set_sw_gcsr(csr, LOONGARCH_CSR_ESTAT, gintc);
>>
>>                  return ret;
>> -       }
>> +       } else if (id == LOONGARCH_CSR_CPUID)
>> +               return kvm_set_cpuid(vcpu, val);
>>
>>          kvm_write_sw_gcsr(csr, id, val);
>>
>> @@ -925,6 +1015,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>          hrtimer_cancel(&vcpu->arch.swtimer);
>>          kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>>          kfree(vcpu->arch.csr);
>> +       kvm_drop_cpuid(vcpu);
>>
>>          /*
>>           * If the vCPU is freed and reused as another vCPU, we don't want the
>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>> index 0a37f6fa8f2d..6fd5916ebef3 100644
>> --- a/arch/loongarch/kvm/vm.c
>> +++ b/arch/loongarch/kvm/vm.c
>> @@ -30,6 +30,14 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>          if (!kvm->arch.pgd)
>>                  return -ENOMEM;
>>
>> +       kvm->arch.phyid_map = kvzalloc(sizeof(struct kvm_phyid_map),
>> +                               GFP_KERNEL_ACCOUNT);
>> +       if (!kvm->arch.phyid_map) {
>> +               free_page((unsigned long)kvm->arch.pgd);
>> +               kvm->arch.pgd = NULL;
>> +               return -ENOMEM;
>> +       }
>> +
>>          kvm_init_vmcs(kvm);
>>          kvm->arch.gpa_size = BIT(cpu_vabits - 1);
>>          kvm->arch.root_level = CONFIG_PGTABLE_LEVELS - 1;
>> @@ -44,6 +52,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>>          for (i = 0; i <= kvm->arch.root_level; i++)
>>                  kvm->arch.pte_shifts[i] = PAGE_SHIFT + i * (PAGE_SHIFT - 3);
>>
>> +       mutex_init(&kvm->arch.phyid_map_lock);
>>          return 0;
>>   }
>>
>> @@ -51,7 +60,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>>   {
>>          kvm_destroy_vcpus(kvm);
>>          free_page((unsigned long)kvm->arch.pgd);
>> +       kvfree(kvm->arch.phyid_map);
>>          kvm->arch.pgd = NULL;
>> +       kvm->arch.phyid_map = NULL;
>>   }
>>
>>   int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>> --
>> 2.39.3
>>


