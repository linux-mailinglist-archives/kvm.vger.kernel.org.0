Return-Path: <kvm+bounces-16604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B117E8BC5C4
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 04:29:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66E282827EA
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 02:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7D741766;
	Mon,  6 May 2024 02:29:37 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B81033D966;
	Mon,  6 May 2024 02:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714962577; cv=none; b=O3zcWYymZewlgsq/IljNdaWkO07KB5Zydgpwx2xuXxzPLnJEinpU7Ms1VkAQO6xipkF3olfaKwfiaR+2FQx7ZWbKHmRZKTpR05bv//TPzeMxSJB3HOcp7A15ctaQo4Ejb7TJA+KEgn/0Rq6Ovf7EZwOfmPidv80cFcbPOqFzv1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714962577; c=relaxed/simple;
	bh=rALx5ZyemA/N+xr1uWu683eQJXtbQp/MRRKTw79+hRM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=a+BocNlAlqHbIc0RmGg8dQDxvVVLG2tWo8WGDO56Ou+isO4jmVBvkJImjlh/HoylttTpVoEtJSDXKO0e4DWRgITtzxoQpKKo3Ll8S3Q78UUAF1YscDL/bGCDsIC2iAO2jAJ09INteAmDMgpp3YjUjLAuQhTa/jBHOrVcm3FVupw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8CxR+mFQDhmKt4HAA--.10036S3;
	Mon, 06 May 2024 10:29:25 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxBleAQDhmQvERAA--.19855S3;
	Mon, 06 May 2024 10:29:22 +0800 (CST)
Subject: Re: [PATCH v8 4/6] LoongArch: KVM: Add vcpu search support from
 physical cpuid
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org
References: <20240428100518.1642324-1-maobibo@loongson.cn>
 <20240428100518.1642324-5-maobibo@loongson.cn>
 <CAAhV-H6kBO_RTTHoLfKdAtLO1Aqb0KmAJ6wn0wZrvbCkzMszDQ@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <8395bb25-b01b-7751-cdca-8979ad3d0a87@loongson.cn>
Date: Mon, 6 May 2024 10:29:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6kBO_RTTHoLfKdAtLO1Aqb0KmAJ6wn0wZrvbCkzMszDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxBleAQDhmQvERAA--.19855S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3WrWrKry8KFWrCF4rGFyxtFc_yoWfAF4DpF
	WqkanxWr4rJr12kw1jqw1q9r9IvrWvgw1a9asrKay5ArnFvr95ZrZYkrWUuF98Jw1rWFs2
	vF1UA3W3uFZYyacCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l
	4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUUUU=

Huacai,

Many thanks for reviewing pv ipi patchset.
And I reply inline.

On 2024/5/6 上午9:49, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Sun, Apr 28, 2024 at 6:05 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Physical cpuid is used for interrupt routing for irqchips such as
>> ipi/msi/extioi interrupt controller. And physical cpuid is stored
>> at CSR register LOONGARCH_CSR_CPUID, it can not be changed once vcpu
>> is created and physical cpuid of two vcpus cannot be the same.
>>
>> Different irqchips have different size declaration about physical cpuid,
>> max cpuid value for CSR LOONGARCH_CSR_CPUID on 3A5000 is 512, max cpuid
>> supported by IPI hardware is 1024, 256 for extioi irqchip, and 65536
>> for MSI irqchip.
>>
>> The smallest value from all interrupt controllers is selected now,
>> and the max cpuid size is defines as 256 by KVM which comes from
>> extioi irqchip.
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
>> index 2d62f7b0d377..3ba16ef1fe69 100644
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
>> +       spinlock_t    phyid_map_lock;
>> +       struct kvm_phyid_map  *phyid_map;
>>
>>          s64 time_offset;
>>          struct kvm_context __percpu *vmcs;
>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h b/arch/loongarch/include/asm/kvm_vcpu.h
>> index 0cb4fdb8a9b5..9f53950959da 100644
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
>> index 3a8779065f73..b633fd28b8db 100644
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
>> +       spin_lock(&vcpu->kvm->arch.phyid_map_lock);
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
>> +                               spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>> +                               return -EINVAL;
>> +                       }
>> +               } else {
>> +                        /* Discard duplicated cpuid set */
>> +                       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>> +                       return 0;
>> +               }
>> +       }
> I have changed the logic and comments when I apply, you can double
> check whether it is correct.
Will do.

> 
>> +
>> +       if (map->phys_map[val].enabled) {
>> +               /*
>> +                * New cpuid is already set with other vcpu
>> +                * Forbid sharing the same cpuid between different vcpus
>> +                */
>> +               if (map->phys_map[val].vcpu != vcpu) {
>> +                       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>> +                       return -EINVAL;
>> +               }
>> +
>> +               /* Discard duplicated cpuid set operation*/
>> +               spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
>> +               return 0;
>> +       }
>> +
>> +       kvm_write_sw_gcsr(csr, LOONGARCH_CSR_CPUID, val);
>> +       map->phys_map[val].enabled      = true;
>> +       map->phys_map[val].vcpu         = vcpu;
>> +       if (map->max_phyid < val)
>> +               map->max_phyid = val;
>> +       spin_unlock(&vcpu->kvm->arch.phyid_map_lock);
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
> While kvm_set_cpuid() is protected by a spinlock, do kvm_drop_cpuid()
> and kvm_get_vcpu_by_cpuid() also need it?
When VM is power-on, vcpu thread can run at the same time, so there is
spinlock for kvm_set_cpuid(). And kvm_drop_cpuid() is called when vcpu 
is destroyed, such VM destroy or vcpu hot removed.

I think that it is impossible to send IPI to hot removed cpu, guest 
kernel should assure this.

Need double check whether it is possible that cpu hot-add can be in 
parallel with hot-removed. We can investigate and add this after 
LoongArch cpu hotplug is supported.

> 
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
>> @@ -943,6 +1033,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
>>          hrtimer_cancel(&vcpu->arch.swtimer);
>>          kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>>          kfree(vcpu->arch.csr);
>> +       kvm_drop_cpuid(vcpu);
> I think this line should be before the above kfree(), otherwise you
> get a "use after free".
yes, that is a problem. kvm_drop_cpuid() should be put before kfree.

Regards
Bibo Mao
> 
> Huacai
> 
>>
>>          /*
>>           * If the vCPU is freed and reused as another vCPU, we don't want the
>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>> index 0a37f6fa8f2d..6006a28653ad 100644
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
>> +       spin_lock_init(&kvm->arch.phyid_map_lock);
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


