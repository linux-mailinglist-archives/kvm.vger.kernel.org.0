Return-Path: <kvm+bounces-60006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E5C8BD84E9
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 10:56:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9A723A7606
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 08:55:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C5B42E6CA3;
	Tue, 14 Oct 2025 08:55:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6709D2D876F;
	Tue, 14 Oct 2025 08:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760432111; cv=none; b=XV6vSOp2d0dO+EOBfAOdYaq1Ilj5/Rirjl/2AbUaddKlDtroaGxW6uY/Ypqh0lTcA166eKt7gOxgwYTt4PT3Li5UGnELrSMekg/OfUKi9/TB2FwQ+W8lud6tREAquKx/7NuN6lVwKFFp2kELKcpmsh35cyDlkgsNU4RAczA1dVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760432111; c=relaxed/simple;
	bh=hWXdcQhUcFY+cvazB+qNfVIEmYDhkgnSjvLZ5J1lZvM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UUa5YEo2prx+LqcRcqnFRKE6QYhW3GDN+VvUN/6ZeNnwSy/yNz+ZjPaBFnDstt2/JnHp8b4vFHf+mI4DMoBJVZq793YQBbMmc9sHam44IHSktOV355bvutNzvdOzTpqyqKmrG+6f43S1+uNx2KhgJkcDe/n0zw/p+IfZlh66gxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.239])
	by gateway (Coremail) with SMTP id _____8AxP_DpD+5oEfIVAA--.46964S3;
	Tue, 14 Oct 2025 16:55:05 +0800 (CST)
Received: from [10.20.42.239] (unknown [10.20.42.239])
	by front1 (Coremail) with SMTP id qMiowJAxvsHiD+5oK0nhAA--.60206S3;
	Tue, 14 Oct 2025 16:55:03 +0800 (CST)
Subject: Re: [PATCH v2] LoongArch: KVM: Add AVEC support
To: Bibo Mao <maobibo@loongson.cn>, chenhuacai@kernel.org
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev, kernel@xen0n.name,
 linux-kernel@vger.kernel.org
References: <20251010064858.2392927-1-gaosong@loongson.cn>
 <39779e6d-2f09-4ee9-e5e0-97fc09efbbf5@loongson.cn>
 <a2d41419-2268-c041-9858-9287056d7f31@loongson.cn>
 <5e83f343-7da1-3235-d681-0d5b8816d1b9@loongson.cn>
From: gaosong <gaosong@loongson.cn>
Message-ID: <ec40aefd-a347-efb2-ba23-f0a88bb4f07d@loongson.cn>
Date: Tue, 14 Oct 2025 16:54:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5e83f343-7da1-3235-d681-0d5b8816d1b9@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJAxvsHiD+5oK0nhAA--.60206S3
X-CM-SenderInfo: 5jdr20tqj6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWfJFWktr4ruw15Cr1Dtry8CrX_yoWDuF4rpr
	1kAFWUXrWrGr1ktr1jqw1qvryUtr18tw1UXr1UJFy8Jr47tr1Yqr40gryqgF1UJw4rJF18
	Xr15JrnxZF15JwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU82g43UU
	UUU==

在 2025/10/13 下午12:07, Bibo Mao 写道:
>
>
> On 2025/10/13 上午11:18, gaosong wrote:
>> 在 2025/10/11 上午9:29, Bibo Mao 写道:
>>>
>>>
>>> On 2025/10/10 下午2:48, Song Gao wrote:
>>>> Add cpu_has_msgint() to check whether the host cpu supported avec,
>>>> and restore/save CSR_MSGIS0-CSR_MSGIS3.
>>>>
>>>> Signed-off-by: Song Gao <gaosong@loongson.cn>
>>>> ---
>>>> Based-on: 
>>>> https://patchew.org/linux/20250930093741.2734974-1-maobibo@loongson.cn/ 
>>>>
>>>> v2: fix build error.
>>> It is not necessary based on this patch, you can base it on master 
>>> branch. The later merged patch need based on previous version in 
>>> general.
>>>
>> Got it.
>>>>
>>>>   arch/loongarch/include/asm/kvm_host.h |  4 ++++
>>>>   arch/loongarch/include/asm/kvm_vcpu.h |  1 +
>>>>   arch/loongarch/include/uapi/asm/kvm.h |  1 +
>>>>   arch/loongarch/kvm/interrupt.c        |  3 +++
>>>>   arch/loongarch/kvm/vcpu.c             | 19 +++++++++++++++++--
>>>>   arch/loongarch/kvm/vm.c               |  4 ++++
>>>>   6 files changed, 30 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h 
>>>> b/arch/loongarch/include/asm/kvm_host.h
>>>> index 392480c9b958..446f1104d59d 100644
>>>> --- a/arch/loongarch/include/asm/kvm_host.h
>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
>>>> @@ -285,6 +285,10 @@ static inline bool kvm_guest_has_lbt(struct 
>>>> kvm_vcpu_arch *arch)
>>>>       return arch->cpucfg[2] & (CPUCFG2_X86BT | CPUCFG2_ARMBT | 
>>>> CPUCFG2_MIPSBT);
>>>>   }
>>>>   +static inline bool cpu_has_msgint(void)
>>>> +{
>>>> +    return read_cpucfg(LOONGARCH_CPUCFG1) & CPUCFG1_MSGINT;
>>>> +}
>>>>   static inline bool kvm_guest_has_pmu(struct kvm_vcpu_arch *arch)
>>>>   {
>>>>       return arch->cpucfg[6] & CPUCFG6_PMP;
>>>> diff --git a/arch/loongarch/include/asm/kvm_vcpu.h 
>>>> b/arch/loongarch/include/asm/kvm_vcpu.h
>>>> index f1efd7cfbc20..3784ab4ccdb5 100644
>>>> --- a/arch/loongarch/include/asm/kvm_vcpu.h
>>>> +++ b/arch/loongarch/include/asm/kvm_vcpu.h
>>>> @@ -15,6 +15,7 @@
>>>>   #define CPU_PMU                (_ULCAST_(1) << 10)
>>>>   #define CPU_TIMER            (_ULCAST_(1) << 11)
>>>>   #define CPU_IPI                (_ULCAST_(1) << 12)
>>>> +#define CPU_AVEC                        (_ULCAST_(1) << 14)
>>>>     /* Controlled by 0x52 guest exception VIP aligned to estat bit 
>>>> 5~12 */
>>>>   #define CPU_IP0                (_ULCAST_(1))
>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h 
>>>> b/arch/loongarch/include/uapi/asm/kvm.h
>>>> index 57ba1a563bb1..de6c3f18e40a 100644
>>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>>>> @@ -104,6 +104,7 @@ struct kvm_fpu {
>>>>   #define  KVM_LOONGARCH_VM_FEAT_PV_IPI        6
>>>>   #define  KVM_LOONGARCH_VM_FEAT_PV_STEALTIME    7
>>>>   #define  KVM_LOONGARCH_VM_FEAT_PTW        8
>>>> +#define  KVM_LOONGARCH_VM_FEAT_MSGINT        9
>>>>     /* Device Control API on vcpu fd */
>>>>   #define KVM_LOONGARCH_VCPU_CPUCFG    0
>>>> diff --git a/arch/loongarch/kvm/interrupt.c 
>>>> b/arch/loongarch/kvm/interrupt.c
>>>> index 8462083f0301..adc278fb3cb9 100644
>>>> --- a/arch/loongarch/kvm/interrupt.c
>>>> +++ b/arch/loongarch/kvm/interrupt.c
>>>> @@ -21,6 +21,7 @@ static unsigned int 
>>>> priority_to_irq[EXCCODE_INT_NUM] = {
>>>>       [INT_HWI5]    = CPU_IP5,
>>>>       [INT_HWI6]    = CPU_IP6,
>>>>       [INT_HWI7]    = CPU_IP7,
>>>> +    [INT_AVEC]    = CPU_AVEC,
>>>>   };
>>>>     static int kvm_irq_deliver(struct kvm_vcpu *vcpu, unsigned int 
>>>> priority)
>>>> @@ -36,6 +37,7 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, 
>>>> unsigned int priority)
>>>>       case INT_IPI:
>>>>       case INT_SWI0:
>>>>       case INT_SWI1:
>>>> +    case INT_AVEC:
>>>>           set_gcsr_estat(irq);
>>> Do we need cpu_has_msgint() here ? It is impossible that VMM inject 
>>> INT_AVEC interrrupt on non-msgint machine such as 3C5000.
>>>
>> yes we need , how about this?
>>
>> @@ -31,6 +32,11 @@ static int kvm_irq_deliver(struct kvm_vcpu *vcpu, 
>> unsigned int priority)
>>          if (priority < EXCCODE_INT_NUM)
>>                  irq = priority_to_irq[priority];
>>
>> +        if (cpu_has_msgint() && (priority == INT_AVEC)) {
>> +                set_gcsr_estat(irq);
>> +                return 1;
>> +        }
>> +
>>          switch (priority) {
>>          case INT_TI:
>>          case INT_IPI:
> This is workable. Another way is to add checking in irq inject root 
> source function kvm_vcpu_ioctl_interrupt(). Both works for me.
>
> BTW, I think that there should be modification with function 
> kvm_deliver_intr() also. max irq bit is *INT_IPI + 1* where there will 
> be problem with INT_AVEC. Should it be modified as *EXCCODE_INT_NUM*?
>
Yes , we should.
> void kvm_deliver_intr(struct kvm_vcpu *vcpu)
> {
>         unsigned int priority;
>         unsigned long *pending = &vcpu->arch.irq_pending;
>         unsigned long *pending_clr = &vcpu->arch.irq_clear;
>
>         for_each_set_bit(priority, pending_clr, INT_IPI + 1)
>                 kvm_irq_clear(vcpu, priority);
>
>         for_each_set_bit(priority, pending, INT_IPI + 1)
>                 kvm_irq_deliver(vcpu, priority);
> }
>
  I'll corrrect it on v3.

Thanks.
Song Gao
> Regards
> Bibo Mao
>>
>> Thanks.
>> Song Gao
>>
>>
>>>>           break;
>>>>   @@ -63,6 +65,7 @@ static int kvm_irq_clear(struct kvm_vcpu *vcpu, 
>>>> unsigned int priority)
>>>>       case INT_IPI:
>>>>       case INT_SWI0:
>>>>       case INT_SWI1:
>>>> +    case INT_AVEC:
>>>>           clear_gcsr_estat(irq);
>>> Ditto.
>>>
>>> The others look good to me.
>>>
>>> Regards
>>> Bibo Mao
>>>>           break;
>>>>   diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>> index 30e3b089a596..226c735155be 100644
>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>> @@ -657,8 +657,7 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>>>>           *v = GENMASK(31, 0);
>>>>           return 0;
>>>>       case LOONGARCH_CPUCFG1:
>>>> -        /* CPUCFG1_MSGINT is not supported by KVM */
>>>> -        *v = GENMASK(25, 0);
>>>> +        *v = GENMASK(26, 0);
>>>>           return 0;
>>>>       case LOONGARCH_CPUCFG2:
>>>>           /* CPUCFG2 features unconditionally supported by KVM */
>>>> @@ -726,6 +725,10 @@ static int kvm_check_cpucfg(int id, u64 val)
>>>>           return -EINVAL;
>>>>         switch (id) {
>>>> +    case LOONGARCH_CPUCFG1:
>>>> +        if ((val & CPUCFG1_MSGINT) && (!cpu_has_msgint()))
>>>> +            return -EINVAL;
>>>> +        return 0;
>>>>       case LOONGARCH_CPUCFG2:
>>>>           if (!(val & CPUCFG2_LLFTP))
>>>>               /* Guests must have a constant timer */
>>>> @@ -1658,6 +1661,12 @@ static int _kvm_vcpu_load(struct kvm_vcpu 
>>>> *vcpu, int cpu)
>>>>       kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
>>>>       kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
>>>>       kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_LLBCTL);
>>>> +    if (cpu_has_msgint()) {
>>>> +        kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR0);
>>>> +        kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
>>>> +        kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
>>>> +        kvm_restore_hw_gcsr(csr, LOONGARCH_CSR_ISR3);
>>>> +    }
>>>>         /* Restore Root.GINTC from unused Guest.GINTC register */
>>>>       write_csr_gintc(csr->csrs[LOONGARCH_CSR_GINTC]);
>>>> @@ -1747,6 +1756,12 @@ static int _kvm_vcpu_put(struct kvm_vcpu 
>>>> *vcpu, int cpu)
>>>>       kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN1);
>>>>       kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN2);
>>>>       kvm_save_hw_gcsr(csr, LOONGARCH_CSR_DMWIN3);
>>>> +    if (cpu_has_msgint()) {
>>>> +        kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR0);
>>>> +        kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR1);
>>>> +        kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR2);
>>>> +        kvm_save_hw_gcsr(csr, LOONGARCH_CSR_ISR3);
>>>> +    }
>>>>         vcpu->arch.aux_inuse |= KVM_LARCH_SWCSR_LATEST;
>>>>   diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>>>> index d8c813e2d72e..438885b6f2b1 100644
>>>> --- a/arch/loongarch/kvm/vm.c
>>>> +++ b/arch/loongarch/kvm/vm.c
>>>> @@ -37,6 +37,9 @@ static void kvm_vm_init_features(struct kvm *kvm)
>>>>           kvm->arch.support_features |= 
>>>> BIT(KVM_LOONGARCH_VM_FEAT_PV_STEALTIME);
>>>>       }
>>>>   +    if (cpu_has_msgint())
>>>> +        kvm->arch.support_features |= 
>>>> BIT(KVM_LOONGARCH_VM_FEAT_MSGINT);
>>>> +
>>>>       val = read_csr_gcfg();
>>>>       if (val & CSR_GCFG_GPMP)
>>>>           kvm->arch.support_features |= 
>>>> BIT(KVM_LOONGARCH_VM_FEAT_PMU);
>>>> @@ -153,6 +156,7 @@ static int kvm_vm_feature_has_attr(struct kvm 
>>>> *kvm, struct kvm_device_attr *attr
>>>>       case KVM_LOONGARCH_VM_FEAT_PMU:
>>>>       case KVM_LOONGARCH_VM_FEAT_PV_IPI:
>>>>       case KVM_LOONGARCH_VM_FEAT_PV_STEALTIME:
>>>> +        case KVM_LOONGARCH_VM_FEAT_MSGINT:
>>>>           if (kvm_vm_support(&kvm->arch, attr->attr))
>>>>               return 0;
>>>>           return -ENXIO;
>>>>
>>>
>>


