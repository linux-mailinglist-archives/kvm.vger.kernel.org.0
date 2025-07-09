Return-Path: <kvm+bounces-51901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 00CA9AFE3BD
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 11:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D63FA1C433DA
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 09:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A279284B49;
	Wed,  9 Jul 2025 09:11:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 886D9284687;
	Wed,  9 Jul 2025 09:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752052315; cv=none; b=pkAYzkthe5UtbQzPFbBQ+K1Y9mqYXTmiJLevB0MKMRMsZL5KjMdFgalJ+lBTCMPw7A3+1IkIsIdrJW5gi88OImYXXh1AtLNYDWCVR2jVA31npRev7HQwGrSSaGEelVcFmEeTzY6BuiDvSFi+zEgg7qXb59pzRg0VVxJN6qVMw+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752052315; c=relaxed/simple;
	bh=ZG4gEwl6Js36fqNwK1HbYzqgkKbFHoEWddM9tjniC04=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DoSsUEX49AaWhFw4bE3jGksQ/EuFpfT9A/snOp8qeKcTVBw7WUeIHYkGkKJiv8RxtqOuKhtiWTTCaadNVsoH2+Y8lse4687lBYfArmMQzramV93NckgbMaCXtzWh2QatQi7mTx93AldtXQrIC92FYQ0KfG6ENVVYvAbNTTh9TyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxjaxUMm5oczUlAQ--.46101S3;
	Wed, 09 Jul 2025 17:11:48 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAxT+ZQMm5oo7wPAA--.25184S3;
	Wed, 09 Jul 2025 17:11:46 +0800 (CST)
Subject: Re: [PATCH v2] LoongArch: KVM: INTC: Add IOCSR MISC register
 emulation
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>,
 Xianglai Li <lixianglai@loongson.cn>, kvm@vger.kernel.org,
 loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20250619071449.1714869-1-maobibo@loongson.cn>
 <CAAhV-H42wPsxNCSp-4wy1+f-2yAJ1fuWbsC57bvQkHL0E3n=-g@mail.gmail.com>
 <31541826-2802-32e0-f8f0-f717e1c02d74@loongson.cn>
 <CAAhV-H6Pzw0uuoK3DfyNz=GMzk+9od-hm2NGqGa44C+=E-cufA@mail.gmail.com>
 <2688b612-3ace-b1d2-b9d1-dd35d35919c5@loongson.cn>
 <CAAhV-H41WOLU6ae-iWKLnuUtSXgq4DogEUYS49ndmERauuPgXA@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <2a573488-34ca-24c5-f165-658964b6f897@loongson.cn>
Date: Wed, 9 Jul 2025 17:10:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H41WOLU6ae-iWKLnuUtSXgq4DogEUYS49ndmERauuPgXA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAxT+ZQMm5oo7wPAA--.25184S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3Cr4rKw48JF47Ar1xWFykWFX_yoW8GFyUZo
	W3JF1xtF18Xr1UJr15J34qqryjyw18Kr4UA34UAwsxJr1Uta47Ar1UGr15JF43K3WkJr47
	Ga47Xr18ZFW7Xwn5l-sFpf9Il3svdjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUYg7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AK
	xVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMI
	IF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2
	KfnxnUUI43ZEXa7IU8j-e5UUUUU==



On 2025/7/9 下午4:59, Huacai Chen wrote:
> On Tue, Jul 1, 2025 at 7:40 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2025/7/1 下午5:20, Huacai Chen wrote:
>>> On Mon, Jun 30, 2025 at 4:44 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>>
>>>>
>>>> On 2025/6/30 下午4:04, Huacai Chen wrote:
>>>>> Hi, Bibo,
>>>>>
>>>>> On Thu, Jun 19, 2025 at 3:15 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>> IOCSR MISC register 0x420 controlls some features of eiointc, such as
>>>>>> BIT 48 enables eiointc and BIT 49 set interrupt encoding mode.
>>>>>>
>>>>>> When kernel irqchip is set, IOCSR MISC register should be emulated in
>>>>>> kernel also. Here add IOCSR MISC register emulation in kernel side.
>>>>>>
>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>> ---
>>>>>> v1 ... v2:
>>>>>>      1. Add separate file arch/loongarch/kvm/intc/misc.c for IOCSR MISC
>>>>>>         register 0x420 emulation, since it controls feature about AVEC
>>>>>>         irqchip also.
>>>>> I found we can decouple the misc register and EIOINTC in addition:
>>>>> 1, Move misc.c out of intc directory;
>>>>> 2, Call kvm_loongarch_create_misc() in kvm_arch_init_vm();
>>>>> 3, Call kvm_loongarch_destroy_misc() in kvm_arch_destroy_vm();
>>>>> 4, Then maybe misc_created can be removed.
>>>> Now irqchip in kernel is optional, the same with misc register. Misc
>>>> register will be emulated in user VMM if kernel-irqchip option is off.
>>>>
>>>> There is no way to detect kernel-irqchip option when function
>>>> kvm_arch_init_vm() is called, and kvm_loongarch_create_misc() needs be
>>>> dynamically called from ioctl command.
>>> Can we use  kvm_arch_irqchip_in_kernel() to detect?
>> No, it can not be used. kvm_arch_irqchip_in_kernel() is usable only when
>> irqchip is created in kernel, however kvm_arch_init_vm() is called when
>> VM is created.
>>
>> VM is created always before kernel irqchip is created. So
>> kvm_arch_irqchip_in_kernel() will return false if it is called in
>> kvm_arch_init_vm().
> What will happen if call kvm_loongarch_create_misc() in
> kvm_arch_init_vm() unconditionally?
If IOCSR misc is emualted in kernel unconditionally, however eiointc is 
emulated in qemu. How does kernel misc emulate eiointc enabling command?

I really doubt whether you really understand KVM, please do not give 
comments so easily if you do not understand.

Regards
Bibo Mao
> 
> Huacai
>>
>> Regards
>> Bibo Mao
>>>
>>>
>>> Huacai
>>>
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>>
>>>>> At last you can make this patch and others from another series to be a
>>>>> new series.
>>>>>
>>>>>
>>>>> Huacai
>>>>>
>>>>>>
>>>>>>      2. Define macro MISC_BASE as LOONGARCH_IOCSR_MISC_FUNC rather than
>>>>>>         hard coded 0x420
>>>>>> ---
>>>>>>     arch/loongarch/include/asm/kvm_eiointc.h |   2 +
>>>>>>     arch/loongarch/include/asm/kvm_host.h    |   2 +
>>>>>>     arch/loongarch/include/asm/kvm_misc.h    |  17 +++
>>>>>>     arch/loongarch/include/asm/loongarch.h   |   1 +
>>>>>>     arch/loongarch/kvm/Makefile              |   1 +
>>>>>>     arch/loongarch/kvm/intc/eiointc.c        |  61 +++++++++++
>>>>>>     arch/loongarch/kvm/intc/misc.c           | 125 +++++++++++++++++++++++
>>>>>>     7 files changed, 209 insertions(+)
>>>>>>     create mode 100644 arch/loongarch/include/asm/kvm_misc.h
>>>>>>     create mode 100644 arch/loongarch/kvm/intc/misc.c
>>>>>>
>>>>>> diff --git a/arch/loongarch/include/asm/kvm_eiointc.h b/arch/loongarch/include/asm/kvm_eiointc.h
>>>>>> index a3a40aba8acf..2d1c183f2b1b 100644
>>>>>> --- a/arch/loongarch/include/asm/kvm_eiointc.h
>>>>>> +++ b/arch/loongarch/include/asm/kvm_eiointc.h
>>>>>> @@ -119,5 +119,7 @@ struct loongarch_eiointc {
>>>>>>
>>>>>>     int kvm_loongarch_register_eiointc_device(void);
>>>>>>     void eiointc_set_irq(struct loongarch_eiointc *s, int irq, int level);
>>>>>> +int kvm_eiointc_get_status(struct kvm_vcpu *vcpu, unsigned long *value);
>>>>>> +int kvm_eiointc_update_status(struct kvm_vcpu *vcpu, unsigned long value, unsigned long mask);
>>>>>>
>>>>>>     #endif /* __ASM_KVM_EIOINTC_H */
>>>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>>>>>> index a3c4cc46c892..f463ec52d86c 100644
>>>>>> --- a/arch/loongarch/include/asm/kvm_host.h
>>>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
>>>>>> @@ -132,6 +132,8 @@ struct kvm_arch {
>>>>>>            struct loongarch_ipi *ipi;
>>>>>>            struct loongarch_eiointc *eiointc;
>>>>>>            struct loongarch_pch_pic *pch_pic;
>>>>>> +       struct kvm_io_device misc;
>>>>>> +       bool   misc_created;
>>>>>>     };
>>>>>>
>>>>>>     #define CSR_MAX_NUMS           0x800
>>>>>> diff --git a/arch/loongarch/include/asm/kvm_misc.h b/arch/loongarch/include/asm/kvm_misc.h
>>>>>> new file mode 100644
>>>>>> index 000000000000..621e4228dea2
>>>>>> --- /dev/null
>>>>>> +++ b/arch/loongarch/include/asm/kvm_misc.h
>>>>>> @@ -0,0 +1,17 @@
>>>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>>>> +/*
>>>>>> + * Copyright (C) 2025 Loongson Technology Corporation Limited
>>>>>> + */
>>>>>> +
>>>>>> +#ifndef __ASM_KVM_MISC_H
>>>>>> +#define __ASM_KVM_MISC_H
>>>>>> +
>>>>>> +#include <asm/loongarch.h>
>>>>>> +
>>>>>> +#define MISC_BASE              LOONGARCH_IOCSR_MISC_FUNC
>>>>>> +#define MISC_SIZE              0x8
>>>>>> +
>>>>>> +int kvm_loongarch_create_misc(struct kvm *kvm);
>>>>>> +void kvm_loongarch_destroy_misc(struct kvm *kvm);
>>>>>> +
>>>>>> +#endif /* __ASM_KVM_MISC_H */
>>>>>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
>>>>>> index d84dac88a584..e30d330d497e 100644
>>>>>> --- a/arch/loongarch/include/asm/loongarch.h
>>>>>> +++ b/arch/loongarch/include/asm/loongarch.h
>>>>>> @@ -1141,6 +1141,7 @@
>>>>>>     #define  IOCSR_MISC_FUNC_SOFT_INT      BIT_ULL(10)
>>>>>>     #define  IOCSR_MISC_FUNC_TIMER_RESET   BIT_ULL(21)
>>>>>>     #define  IOCSR_MISC_FUNC_EXT_IOI_EN    BIT_ULL(48)
>>>>>> +#define  IOCSR_MISC_FUNC_INT_ENCODE    BIT_ULL(49)
>>>>>>     #define  IOCSR_MISC_FUNC_AVEC_EN       BIT_ULL(51)
>>>>>>
>>>>>>     #define LOONGARCH_IOCSR_CPUTEMP                0x428
>>>>>> diff --git a/arch/loongarch/kvm/Makefile b/arch/loongarch/kvm/Makefile
>>>>>> index cb41d9265662..25fa3866613d 100644
>>>>>> --- a/arch/loongarch/kvm/Makefile
>>>>>> +++ b/arch/loongarch/kvm/Makefile
>>>>>> @@ -18,6 +18,7 @@ kvm-y += vcpu.o
>>>>>>     kvm-y += vm.o
>>>>>>     kvm-y += intc/ipi.o
>>>>>>     kvm-y += intc/eiointc.o
>>>>>> +kvm-y += intc/misc.o
>>>>>>     kvm-y += intc/pch_pic.o
>>>>>>     kvm-y += irqfd.o
>>>>>>
>>>>>> diff --git a/arch/loongarch/kvm/intc/eiointc.c b/arch/loongarch/kvm/intc/eiointc.c
>>>>>> index f39929d7bf8a..87d01521e92f 100644
>>>>>> --- a/arch/loongarch/kvm/intc/eiointc.c
>>>>>> +++ b/arch/loongarch/kvm/intc/eiointc.c
>>>>>> @@ -4,6 +4,7 @@
>>>>>>      */
>>>>>>
>>>>>>     #include <asm/kvm_eiointc.h>
>>>>>> +#include <asm/kvm_misc.h>
>>>>>>     #include <asm/kvm_vcpu.h>
>>>>>>     #include <linux/count_zeros.h>
>>>>>>
>>>>>> @@ -708,6 +709,56 @@ static const struct kvm_io_device_ops kvm_eiointc_ops = {
>>>>>>            .write  = kvm_eiointc_write,
>>>>>>     };
>>>>>>
>>>>>> +int kvm_eiointc_get_status(struct kvm_vcpu *vcpu, unsigned long *value)
>>>>>> +{
>>>>>> +       unsigned long data, flags;
>>>>>> +       struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
>>>>>> +
>>>>>> +       if (!eiointc) {
>>>>>> +               kvm_err("%s: eiointc irqchip not valid!\n", __func__);
>>>>>> +               return -EINVAL;
>>>>>> +       }
>>>>>> +
>>>>>> +       data = 0;
>>>>>> +       spin_lock_irqsave(&eiointc->lock, flags);
>>>>>> +       if (eiointc->status & BIT(EIOINTC_ENABLE))
>>>>>> +               data |= IOCSR_MISC_FUNC_EXT_IOI_EN;
>>>>>> +
>>>>>> +       if (eiointc->status & BIT(EIOINTC_ENABLE_INT_ENCODE))
>>>>>> +               data |= IOCSR_MISC_FUNC_INT_ENCODE;
>>>>>> +       spin_unlock_irqrestore(&eiointc->lock, flags);
>>>>>> +
>>>>>> +       *value = data;
>>>>>> +       return 0;
>>>>>> +}
>>>>>> +
>>>>>> +int kvm_eiointc_update_status(struct kvm_vcpu *vcpu, unsigned long value, unsigned long mask)
>>>>>> +{
>>>>>> +       struct loongarch_eiointc *eiointc = vcpu->kvm->arch.eiointc;
>>>>>> +       unsigned long old, flags;
>>>>>> +
>>>>>> +       if (!eiointc) {
>>>>>> +               kvm_err("%s: eiointc irqchip not valid!\n", __func__);
>>>>>> +               return -EINVAL;
>>>>>> +       }
>>>>>> +
>>>>>> +       old = 0;
>>>>>> +       spin_lock_irqsave(&eiointc->lock, flags);
>>>>>> +       if (eiointc->status & BIT(EIOINTC_ENABLE))
>>>>>> +               old |= IOCSR_MISC_FUNC_EXT_IOI_EN;
>>>>>> +       if (eiointc->status & BIT(EIOINTC_ENABLE_INT_ENCODE))
>>>>>> +               old |= IOCSR_MISC_FUNC_INT_ENCODE;
>>>>>> +
>>>>>> +       value |= (old & ~mask);
>>>>>> +       eiointc->status &= ~(BIT(EIOINTC_ENABLE_INT_ENCODE) | BIT(EIOINTC_ENABLE));
>>>>>> +       if (value & IOCSR_MISC_FUNC_INT_ENCODE)
>>>>>> +               eiointc->status |= BIT(EIOINTC_ENABLE_INT_ENCODE);
>>>>>> +       if (value & IOCSR_MISC_FUNC_EXT_IOI_EN)
>>>>>> +               eiointc->status |= BIT(EIOINTC_ENABLE);
>>>>>> +       spin_unlock_irqrestore(&eiointc->lock, flags);
>>>>>> +       return 0;
>>>>>> +}
>>>>>> +
>>>>>>     static int kvm_eiointc_virt_read(struct kvm_vcpu *vcpu,
>>>>>>                                    struct kvm_io_device *dev,
>>>>>>                                    gpa_t addr, int len, void *val)
>>>>>> @@ -993,6 +1044,15 @@ static int kvm_eiointc_create(struct kvm_device *dev, u32 type)
>>>>>>                    kfree(s);
>>>>>>                    return ret;
>>>>>>            }
>>>>>> +
>>>>>> +       ret = kvm_loongarch_create_misc(kvm);
>>>>>> +       if (ret < 0) {
>>>>>> +               kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device);
>>>>>> +               kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &s->device_vext);
>>>>>> +               kfree(s);
>>>>>> +               return ret;
>>>>>> +       }
>>>>>> +
>>>>>>            kvm->arch.eiointc = s;
>>>>>>
>>>>>>            return 0;
>>>>>> @@ -1010,6 +1070,7 @@ static void kvm_eiointc_destroy(struct kvm_device *dev)
>>>>>>            eiointc = kvm->arch.eiointc;
>>>>>>            kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device);
>>>>>>            kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, &eiointc->device_vext);
>>>>>> +       kvm_loongarch_destroy_misc(kvm);
>>>>>>            kfree(eiointc);
>>>>>>     }
>>>>>>
>>>>>> diff --git a/arch/loongarch/kvm/intc/misc.c b/arch/loongarch/kvm/intc/misc.c
>>>>>> new file mode 100644
>>>>>> index 000000000000..edee66afa36e
>>>>>> --- /dev/null
>>>>>> +++ b/arch/loongarch/kvm/intc/misc.c
>>>>>> @@ -0,0 +1,125 @@
>>>>>> +// SPDX-License-Identifier: GPL-2.0
>>>>>> +/*
>>>>>> + * Copyright (C) 2025 Loongson Technology Corporation Limited
>>>>>> + */
>>>>>> +#include <asm/kvm_vcpu.h>
>>>>>> +#include <asm/kvm_eiointc.h>
>>>>>> +#include <asm/kvm_misc.h>
>>>>>> +
>>>>>> +static int kvm_misc_read(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>>>>> +                       gpa_t addr, int len, void *val)
>>>>>> +{
>>>>>> +       unsigned long data;
>>>>>> +       unsigned int ret;
>>>>>> +
>>>>>> +       addr -= MISC_BASE;
>>>>>> +       if (addr & (len - 1)) {
>>>>>> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
>>>>>> +               return -EINVAL;
>>>>>> +       }
>>>>>> +
>>>>>> +       ret = kvm_eiointc_get_status(vcpu, &data);
>>>>>> +       if (ret)
>>>>>> +               return ret;
>>>>>> +
>>>>>> +       data = data >> ((addr & 7) * 8);
>>>>>> +       switch (len) {
>>>>>> +       case 1:
>>>>>> +               *(unsigned char *)val = (unsigned char)data;
>>>>>> +               break;
>>>>>> +
>>>>>> +       case 2:
>>>>>> +               *(unsigned short *)val = (unsigned short)data;
>>>>>> +               break;
>>>>>> +
>>>>>> +       case 4:
>>>>>> +               *(unsigned int *)val = (unsigned int)data;
>>>>>> +               break;
>>>>>> +
>>>>>> +       default:
>>>>>> +               *(unsigned long *)val = data;
>>>>>> +               break;
>>>>>> +       }
>>>>>> +
>>>>>> +       return 0;
>>>>>> +}
>>>>>> +
>>>>>> +static int kvm_misc_write(struct kvm_vcpu *vcpu, struct kvm_io_device *dev,
>>>>>> +               gpa_t addr, int len, const void *val)
>>>>>> +{
>>>>>> +       unsigned long data, mask;
>>>>>> +       unsigned int shift;
>>>>>> +
>>>>>> +       addr -= MISC_BASE;
>>>>>> +       if (addr & (len - 1)) {
>>>>>> +               kvm_err("%s: eiointc not aligned addr %llx len %d\n", __func__, addr, len);
>>>>>> +               return -EINVAL;
>>>>>> +       }
>>>>>> +
>>>>>> +       shift = (addr & 7) * 8;
>>>>>> +       switch (len) {
>>>>>> +       case 1:
>>>>>> +               data = *(unsigned char *)val;
>>>>>> +               mask = 0xFF;
>>>>>> +               mask = mask << shift;
>>>>>> +               data = data << shift;
>>>>>> +               break;
>>>>>> +
>>>>>> +       case 2:
>>>>>> +               data = *(unsigned short *)val;
>>>>>> +               mask = 0xFFFF;
>>>>>> +               mask = mask << shift;
>>>>>> +               data = data << shift;
>>>>>> +               break;
>>>>>> +
>>>>>> +       case 4:
>>>>>> +               data = *(unsigned int *)val;
>>>>>> +               mask = UINT_MAX;
>>>>>> +               mask = mask << shift;
>>>>>> +               data = data << shift;
>>>>>> +               break;
>>>>>> +
>>>>>> +       default:
>>>>>> +               data = *(unsigned long *)val;
>>>>>> +               mask = ULONG_MAX;
>>>>>> +               mask = mask << shift;
>>>>>> +               data = data << shift;
>>>>>> +               break;
>>>>>> +       }
>>>>>> +
>>>>>> +       return kvm_eiointc_update_status(vcpu, data, mask);
>>>>>> +}
>>>>>> +
>>>>>> +static const struct kvm_io_device_ops kvm_misc_ops = {
>>>>>> +       .read   = kvm_misc_read,
>>>>>> +       .write  = kvm_misc_write,
>>>>>> +};
>>>>>> +
>>>>>> +int kvm_loongarch_create_misc(struct kvm *kvm)
>>>>>> +{
>>>>>> +       struct kvm_io_device *device;
>>>>>> +       int ret;
>>>>>> +
>>>>>> +       if (kvm->arch.misc_created)
>>>>>> +               return 0;
>>>>>> +
>>>>>> +       device = &kvm->arch.misc;
>>>>>> +       kvm_iodevice_init(device, &kvm_misc_ops);
>>>>>> +       ret = kvm_io_bus_register_dev(kvm, KVM_IOCSR_BUS, MISC_BASE, MISC_SIZE, device);
>>>>>> +       if (ret < 0)
>>>>>> +               return ret;
>>>>>> +
>>>>>> +       kvm->arch.misc_created = true;
>>>>>> +       return 0;
>>>>>> +}
>>>>>> +
>>>>>> +void kvm_loongarch_destroy_misc(struct kvm *kvm)
>>>>>> +{
>>>>>> +       struct kvm_io_device *device;
>>>>>> +
>>>>>> +       if (kvm->arch.misc_created) {
>>>>>> +               device = &kvm->arch.misc;
>>>>>> +               kvm_io_bus_unregister_dev(kvm, KVM_IOCSR_BUS, device);
>>>>>> +               kvm->arch.misc_created = false;
>>>>>> +       }
>>>>>> +}
>>>>>>
>>>>>> base-commit: 52da431bf03b5506203bca27fe14a97895c80faf
>>>>>> --
>>>>>> 2.39.3
>>>>>>
>>>>
>>


