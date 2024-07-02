Return-Path: <kvm+bounces-20816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4637B91ECF1
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 04:25:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27941283597
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 02:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A60814293;
	Tue,  2 Jul 2024 02:25:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6F1CD30B;
	Tue,  2 Jul 2024 02:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719887120; cv=none; b=QsTivTrH9JPjzFXV0kDsdQyCu2Cs/E4Qzzy1on3OBPQEU4Bad+CQ6dE6lbz4S1l7lU0wJtHZ1EZeRH7me2m1NqSQEIbNtbDAin1XsQtcOk70kh7Fh9rvJwSL1CQg9Y4X+HI6NHQfHk8D9pxgKzLpMmB1+apG/RQdB5KClogEwak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719887120; c=relaxed/simple;
	bh=Lta32qAB7rdEtlccgYnGtZkigu29prOS0s5vpfm25Ow=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VJJ3aQXoT//igCJRetQUOi7te3bTAv/pW3tzIk7iZpodv89XQFeaLNe4xV9EJMy6HRf9Cs8WcMIXSEdPVXz5FX9GP2Uv0Fu07FIEiUeC5UwnRwZiu516CGzRX7jjSX2+BIrLU3TkcWJWN0HR6J5tuKvTN1uEJ+agAkxf1k6sYHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxP_EKZYNmDgIAAA--.68S3;
	Tue, 02 Jul 2024 10:25:15 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8CxosQHZYNmISE4AA--.54598S3;
	Tue, 02 Jul 2024 10:25:13 +0800 (CST)
Subject: Re: [PATCH v4 2/3] LoongArch: KVM: Add LBT feature detection function
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20240626063239.3722175-1-maobibo@loongson.cn>
 <20240626063239.3722175-3-maobibo@loongson.cn>
 <CAAhV-H4O8QNb61xkErd9y_1tK_70=Y=LNqzy=9Ny5EQK1XZJaQ@mail.gmail.com>
 <79dcf093-614f-2737-bb03-698b0b3abc57@loongson.cn>
 <CAAhV-H5bQutcLcVaHn-amjF6_NDnCf2BFqqnGSRT_QQ_6q6REg@mail.gmail.com>
 <9c7d242e-660b-8d39-b69e-201fd0a4bfbf@loongson.cn>
 <CAAhV-H4wwrYyMYpL1u5Z3sFp6EeW4eWhGbBv0Jn9XYJGXgwLfg@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <059d66e4-dd5d-0091-01d9-11aaba9297bd@loongson.cn>
Date: Tue, 2 Jul 2024 10:25:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4wwrYyMYpL1u5Z3sFp6EeW4eWhGbBv0Jn9XYJGXgwLfg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8CxosQHZYNmISE4AA--.54598S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3XryruFWruF4fZw17AryfXwc_yoW3Aw13pr
	WUAF4qkr4UGr1xA3ZYqws8WrsIvr1xAr4xXFyxK3yUAr1Dtr1xJr10yrZ8CFyrX348X3WI
	vF1kAr43ZF15A3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWU
	AwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_JF0_Jw1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jjwZcUUUUU=



On 2024/7/2 上午9:59, Huacai Chen wrote:
> On Tue, Jul 2, 2024 at 9:51 AM maobibo <maobibo@loongson.cn> wrote:
>>
>> Huacai,
>>
>> On 2024/7/1 下午6:26, Huacai Chen wrote:
>>> On Mon, Jul 1, 2024 at 9:27 AM maobibo <maobibo@loongson.cn> wrote:
>>>>
>>>>
>>>> Huacai,
>>>>
>>>> On 2024/6/30 上午10:07, Huacai Chen wrote:
>>>>> Hi, Bibo,
>>>>>
>>>>> On Wed, Jun 26, 2024 at 2:32 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>> Two kinds of LBT feature detection are added here, one is VCPU
>>>>>> feature, the other is VM feature. VCPU feature dection can only
>>>>>> work with VCPU thread itself, and requires VCPU thread is created
>>>>>> already. So LBT feature detection for VM is added also, it can
>>>>>> be done even if VM is not created, and also can be done by any
>>>>>> thread besides VCPU threads.
>>>>>>
>>>>>> Loongson Binary Translation (LBT) feature is defined in register
>>>>>> cpucfg2. Here LBT capability detection for VCPU is added.
>>>>>>
>>>>>> Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, and macro
>>>>>> KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported feature. And
>>>>>> three sub-features relative with LBT are added as following:
>>>>>>     KVM_LOONGARCH_VM_FEAT_X86BT
>>>>>>     KVM_LOONGARCH_VM_FEAT_ARMBT
>>>>>>     KVM_LOONGARCH_VM_FEAT_MIPSBT
>>>>>>
>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>> ---
>>>>>>     arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
>>>>>>     arch/loongarch/kvm/vcpu.c             |  6 ++++
>>>>>>     arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++++++++++++-
>>>>>>     3 files changed, 55 insertions(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>>>>>> index ddc5cab0ffd0..c40f7d9ffe13 100644
>>>>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>>>>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>>>>>> @@ -82,6 +82,12 @@ struct kvm_fpu {
>>>>>>     #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
>>>>>>     #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
>>>>>>
>>>>>> +/* Device Control API on vm fd */
>>>>>> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
>>>>>> +
>>>>>>     /* Device Control API on vcpu fd */
>>>>>>     #define KVM_LOONGARCH_VCPU_CPUCFG      0
>>>>>>     #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
>>>>> If you insist that LBT should be a vm feature, then I suggest the
>>>>> above two also be vm features. Though this is an UAPI change, but
>>>>> CPUCFG is upstream in 6.10-rc1 and 6.10-final hasn't been released. We
>>>>> have a chance to change it now.
>>>>
>>>> KVM_LOONGARCH_VCPU_PVTIME_CTRL need be attr percpu since every vcpu
>>>> has is own different gpa address.
>>> Then leave this as a vm feature.
>>>
>>>>
>>>> For KVM_LOONGARCH_VCPU_CPUCFG attr, it will not changed. We cannot break
>>>> the API even if it is 6.10-rc1, VMM has already used this. Else there is
>>>> uapi breaking now, still will be in future if we cannot control this.
>>> UAPI changing before the first release is allowed, which means, we can
>>> change this before the 6.10-final, but cannot change it after
>>> 6.10-final.
>> Now QEMU has already synced uapi to its own directory, also I never hear
>> about this, with my experience with uapi change, there is only newly
>> added or removed deprecated years ago.
>>
>> Is there any documentation about UAPI change rules?
> No document, but learn from my more than 10 years upstream experience.
Can you show me an example about with your rich upstream experience?
> 
>>>
>>>>
>>>> How about adding new extra features capability for VM such as?
>>>> +#define  KVM_LOONGARCH_VM_FEAT_LSX   3
>>>> +#define  KVM_LOONGARCH_VM_FEAT_LASX  4
>>> They should be similar as LBT, if LBT is vcpu feature, they should
>>> also be vcpu features; if LBT is vm feature, they should also be vm
>>> features.
>> On other architectures, with function kvm_vm_ioctl_check_extension()
>>      KVM_CAP_XSAVE2/KVM_CAP_PMU_CAPABILITY on x86
>>      KVM_CAP_ARM_PMU_V3/KVM_CAP_ARM_SVE on arm64
>> These features are all cpu features, at the same time they are VM features.
>>
>> If they are cpu features, how does VMM detect validity of these features
>> passing from command line? After all VCPUs are created and send bootup
>> command to these VCPUs? That is too late, VMM main thread is easy to
>> detect feature validity if they are VM features also.
>>
>> To be honest, I am not familiar with KVM still, only get further
>> understanding after actual problems solving. Welcome to give comments,
>> however please read more backgroud if you insist on, else there will be
>> endless argument again.
> I just say CPUCFG/LSX/LASX and LBT should be in the same class, I
> haven't insisted on whether they should be vcpu features or vm
> features.
It is reasonable if LSX/LASX/LBT should be in the same class, since 
there is feature options such as lsx=on/off,lasx=on/off,lbt=on/off.

What is the usage about CPUCFG capability used for VM feature? It is not 
a detailed feature, it is only feature-set indicator like cpuid.

Regards
Bibo Mao
> 
> Huacai
> 
>>
>> Regards
>> Bibo, Mao
>>>
>>> Huacai
>>>
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>>
>>>>> Huacai
>>>>>
>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>>>> index 233d28d0e928..9734b4d8db05 100644
>>>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>>>> @@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>>>>>>                            *v |= CPUCFG2_LSX;
>>>>>>                    if (cpu_has_lasx)
>>>>>>                            *v |= CPUCFG2_LASX;
>>>>>> +               if (cpu_has_lbt_x86)
>>>>>> +                       *v |= CPUCFG2_X86BT;
>>>>>> +               if (cpu_has_lbt_arm)
>>>>>> +                       *v |= CPUCFG2_ARMBT;
>>>>>> +               if (cpu_has_lbt_mips)
>>>>>> +                       *v |= CPUCFG2_MIPSBT;
>>>>>>
>>>>>>                    return 0;
>>>>>>            case LOONGARCH_CPUCFG3:
>>>>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>>>>>> index 6b2e4f66ad26..09e05108c68b 100644
>>>>>> --- a/arch/loongarch/kvm/vm.c
>>>>>> +++ b/arch/loongarch/kvm/vm.c
>>>>>> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>>>>            return r;
>>>>>>     }
>>>>>>
>>>>>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>> +{
>>>>>> +       switch (attr->attr) {
>>>>>> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
>>>>>> +               if (cpu_has_lbt_x86)
>>>>>> +                       return 0;
>>>>>> +               return -ENXIO;
>>>>>> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
>>>>>> +               if (cpu_has_lbt_arm)
>>>>>> +                       return 0;
>>>>>> +               return -ENXIO;
>>>>>> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
>>>>>> +               if (cpu_has_lbt_mips)
>>>>>> +                       return 0;
>>>>>> +               return -ENXIO;
>>>>>> +       default:
>>>>>> +               return -ENXIO;
>>>>>> +       }
>>>>>> +}
>>>>>> +
>>>>>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>> +{
>>>>>> +       switch (attr->group) {
>>>>>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
>>>>>> +               return kvm_vm_feature_has_attr(kvm, attr);
>>>>>> +       default:
>>>>>> +               return -ENXIO;
>>>>>> +       }
>>>>>> +}
>>>>>> +
>>>>>>     int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>>>>>     {
>>>>>> -       return -ENOIOCTLCMD;
>>>>>> +       struct kvm *kvm = filp->private_data;
>>>>>> +       void __user *argp = (void __user *)arg;
>>>>>> +       struct kvm_device_attr attr;
>>>>>> +
>>>>>> +       switch (ioctl) {
>>>>>> +       case KVM_HAS_DEVICE_ATTR:
>>>>>> +               if (copy_from_user(&attr, argp, sizeof(attr)))
>>>>>> +                       return -EFAULT;
>>>>>> +
>>>>>> +               return kvm_vm_has_attr(kvm, &attr);
>>>>>> +       default:
>>>>>> +               return -EINVAL;
>>>>>> +       }
>>>>>>     }
>>>>>> --
>>>>>> 2.39.3
>>>>>>
>>>>
>>


