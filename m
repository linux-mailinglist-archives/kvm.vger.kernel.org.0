Return-Path: <kvm+bounces-20819-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AFFDD91EDBA
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 06:14:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3E8561F23BCA
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2024 04:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1FDA76034;
	Tue,  2 Jul 2024 04:13:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69DA52BB09;
	Tue,  2 Jul 2024 04:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719893580; cv=none; b=TkLA9XC+X/T5y8SH5HMvi16q7yWDC1hsd+3Lp83GFDgJQPWDsmLemLdGuySqw3ZEmgXf8MSof3cOGqNJ0+oRoGqnCJ90w+o2cIjD6FO0vkDZ3Lbv+mzFBFlgyKnWj5tS+N9mjMTft1QFolf+KQ1YAdlRtXwvgN9Im7Lk99owyfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719893580; c=relaxed/simple;
	bh=kiZMf0J4ZlpjZ1iyNCb8PMXP1vPw6umUkHV64Ws0Bfw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JU2VUaeW+hgBiDJf0z8o72RzDecq9M/RVYvESzOaTfIXnNE7CfHvGVUHKHtL0j1E81+9g2v8htMCITDbSHgwJWLRoa/igBb2FO8wMf6EoQWOGZhzWDa5bsOHFN189M0qms0O97RtSQ/rdgVAXn/cjzZHw23AblCJQwjUf032Xpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8Cx_vBGfoNmeAYAAA--.204S3;
	Tue, 02 Jul 2024 12:12:55 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8DxPMdEfoNmODI4AA--.934S3;
	Tue, 02 Jul 2024 12:12:54 +0800 (CST)
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
 <059d66e4-dd5d-0091-01d9-11aaba9297bd@loongson.cn>
 <CAAhV-H41B3_dLgTQGwT-DRDbb=qt44A_M08-RcKfJuxOTfm3nw@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <7e6a1dbc-779a-4669-4541-c5952c9bdf24@loongson.cn>
Date: Tue, 2 Jul 2024 12:12:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H41B3_dLgTQGwT-DRDbb=qt44A_M08-RcKfJuxOTfm3nw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8DxPMdEfoNmODI4AA--.934S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3XrWkuF13Aw1rAFWrCFy5ZFc_yoWfur1kpr
	WUAF4DKr4UGr1xA3Wqqws8Gr1ayr1xAr4UXry8JryUAr1Dtr1xJr18tr4UCFyUXw18XF10
	vr1UJr17ZF15A3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWU
	AwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17
	CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0
	I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I
	8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73
	UjIFyTuYvjxU4oGQDUUUU



On 2024/7/2 上午10:34, Huacai Chen wrote:
> On Tue, Jul 2, 2024 at 10:25 AM maobibo <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2024/7/2 上午9:59, Huacai Chen wrote:
>>> On Tue, Jul 2, 2024 at 9:51 AM maobibo <maobibo@loongson.cn> wrote:
>>>>
>>>> Huacai,
>>>>
>>>> On 2024/7/1 下午6:26, Huacai Chen wrote:
>>>>> On Mon, Jul 1, 2024 at 9:27 AM maobibo <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>>
>>>>>> Huacai,
>>>>>>
>>>>>> On 2024/6/30 上午10:07, Huacai Chen wrote:
>>>>>>> Hi, Bibo,
>>>>>>>
>>>>>>> On Wed, Jun 26, 2024 at 2:32 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>>>
>>>>>>>> Two kinds of LBT feature detection are added here, one is VCPU
>>>>>>>> feature, the other is VM feature. VCPU feature dection can only
>>>>>>>> work with VCPU thread itself, and requires VCPU thread is created
>>>>>>>> already. So LBT feature detection for VM is added also, it can
>>>>>>>> be done even if VM is not created, and also can be done by any
>>>>>>>> thread besides VCPU threads.
>>>>>>>>
>>>>>>>> Loongson Binary Translation (LBT) feature is defined in register
>>>>>>>> cpucfg2. Here LBT capability detection for VCPU is added.
>>>>>>>>
>>>>>>>> Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, and macro
>>>>>>>> KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported feature. And
>>>>>>>> three sub-features relative with LBT are added as following:
>>>>>>>>      KVM_LOONGARCH_VM_FEAT_X86BT
>>>>>>>>      KVM_LOONGARCH_VM_FEAT_ARMBT
>>>>>>>>      KVM_LOONGARCH_VM_FEAT_MIPSBT
>>>>>>>>
>>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>>>> ---
>>>>>>>>      arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
>>>>>>>>      arch/loongarch/kvm/vcpu.c             |  6 ++++
>>>>>>>>      arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++++++++++++-
>>>>>>>>      3 files changed, 55 insertions(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>>>>>>>> index ddc5cab0ffd0..c40f7d9ffe13 100644
>>>>>>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>>>>>>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>>>>>>>> @@ -82,6 +82,12 @@ struct kvm_fpu {
>>>>>>>>      #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
>>>>>>>>      #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
>>>>>>>>
>>>>>>>> +/* Device Control API on vm fd */
>>>>>>>> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
>>>>>>>> +
>>>>>>>>      /* Device Control API on vcpu fd */
>>>>>>>>      #define KVM_LOONGARCH_VCPU_CPUCFG      0
>>>>>>>>      #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
>>>>>>> If you insist that LBT should be a vm feature, then I suggest the
>>>>>>> above two also be vm features. Though this is an UAPI change, but
>>>>>>> CPUCFG is upstream in 6.10-rc1 and 6.10-final hasn't been released. We
>>>>>>> have a chance to change it now.
>>>>>>
>>>>>> KVM_LOONGARCH_VCPU_PVTIME_CTRL need be attr percpu since every vcpu
>>>>>> has is own different gpa address.
>>>>> Then leave this as a vm feature.
>>>>>
>>>>>>
>>>>>> For KVM_LOONGARCH_VCPU_CPUCFG attr, it will not changed. We cannot break
>>>>>> the API even if it is 6.10-rc1, VMM has already used this. Else there is
>>>>>> uapi breaking now, still will be in future if we cannot control this.
>>>>> UAPI changing before the first release is allowed, which means, we can
>>>>> change this before the 6.10-final, but cannot change it after
>>>>> 6.10-final.
>>>> Now QEMU has already synced uapi to its own directory, also I never hear
>>>> about this, with my experience with uapi change, there is only newly
>>>> added or removed deprecated years ago.
>>>>
>>>> Is there any documentation about UAPI change rules?
>>> No document, but learn from my more than 10 years upstream experience.
>> Can you show me an example about with your rich upstream experience?
> A simple example,
> e877d705704d7c8fe17b6b5ebdfdb14b84c revert
> 1dccdba084897443d116508a8ed71e0ac8a0 and it changes UAPI.
> 1dccdba084897443d116508a8ed71e0ac8a0 is upstream in 6.9-rc1, and
> e877d705704d7c8fe17b6b5ebdfdb14b84c can revert the behavior before
> 6.9-final, but not after that.
> 
> Before the first release, the code status is treated as "unstable", so
> revert, modify is allowed. But after the first release, even if an
> "error" should also be treated as a "bad feature".
Huacai,

Thanks for showing the example.

For this issue, Can we adding new uapi and mark the old as deprecated?
so that it can be removed after years.

For me, it is too frequent to revert the old uapi, it is not bug and
only that we have better method now. Also QEMU has synchronized the uapi
to its directory already.

Regards
Bibo, Mao
> 
> Huacai
> 
> 
>>>
>>>>>
>>>>>>
>>>>>> How about adding new extra features capability for VM such as?
>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LSX   3
>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LASX  4
>>>>> They should be similar as LBT, if LBT is vcpu feature, they should
>>>>> also be vcpu features; if LBT is vm feature, they should also be vm
>>>>> features.
>>>> On other architectures, with function kvm_vm_ioctl_check_extension()
>>>>       KVM_CAP_XSAVE2/KVM_CAP_PMU_CAPABILITY on x86
>>>>       KVM_CAP_ARM_PMU_V3/KVM_CAP_ARM_SVE on arm64
>>>> These features are all cpu features, at the same time they are VM features.
>>>>
>>>> If they are cpu features, how does VMM detect validity of these features
>>>> passing from command line? After all VCPUs are created and send bootup
>>>> command to these VCPUs? That is too late, VMM main thread is easy to
>>>> detect feature validity if they are VM features also.
>>>>
>>>> To be honest, I am not familiar with KVM still, only get further
>>>> understanding after actual problems solving. Welcome to give comments,
>>>> however please read more backgroud if you insist on, else there will be
>>>> endless argument again.
>>> I just say CPUCFG/LSX/LASX and LBT should be in the same class, I
>>> haven't insisted on whether they should be vcpu features or vm
>>> features.
>> It is reasonable if LSX/LASX/LBT should be in the same class, since
>> there is feature options such as lsx=on/off,lasx=on/off,lbt=on/off.
>>
>> What is the usage about CPUCFG capability used for VM feature? It is not
>> a detailed feature, it is only feature-set indicator like cpuid.
>>
>> Regards
>> Bibo Mao
>>>
>>> Huacai
>>>
>>>>
>>>> Regards
>>>> Bibo, Mao
>>>>>
>>>>> Huacai
>>>>>
>>>>>>
>>>>>> Regards
>>>>>> Bibo Mao
>>>>>>>
>>>>>>> Huacai
>>>>>>>
>>>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>>>>>> index 233d28d0e928..9734b4d8db05 100644
>>>>>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>>>>>> @@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>>>>>>>>                             *v |= CPUCFG2_LSX;
>>>>>>>>                     if (cpu_has_lasx)
>>>>>>>>                             *v |= CPUCFG2_LASX;
>>>>>>>> +               if (cpu_has_lbt_x86)
>>>>>>>> +                       *v |= CPUCFG2_X86BT;
>>>>>>>> +               if (cpu_has_lbt_arm)
>>>>>>>> +                       *v |= CPUCFG2_ARMBT;
>>>>>>>> +               if (cpu_has_lbt_mips)
>>>>>>>> +                       *v |= CPUCFG2_MIPSBT;
>>>>>>>>
>>>>>>>>                     return 0;
>>>>>>>>             case LOONGARCH_CPUCFG3:
>>>>>>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>>>>>>>> index 6b2e4f66ad26..09e05108c68b 100644
>>>>>>>> --- a/arch/loongarch/kvm/vm.c
>>>>>>>> +++ b/arch/loongarch/kvm/vm.c
>>>>>>>> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>>>>>>             return r;
>>>>>>>>      }
>>>>>>>>
>>>>>>>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>>>> +{
>>>>>>>> +       switch (attr->attr) {
>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
>>>>>>>> +               if (cpu_has_lbt_x86)
>>>>>>>> +                       return 0;
>>>>>>>> +               return -ENXIO;
>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
>>>>>>>> +               if (cpu_has_lbt_arm)
>>>>>>>> +                       return 0;
>>>>>>>> +               return -ENXIO;
>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
>>>>>>>> +               if (cpu_has_lbt_mips)
>>>>>>>> +                       return 0;
>>>>>>>> +               return -ENXIO;
>>>>>>>> +       default:
>>>>>>>> +               return -ENXIO;
>>>>>>>> +       }
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>>>> +{
>>>>>>>> +       switch (attr->group) {
>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
>>>>>>>> +               return kvm_vm_feature_has_attr(kvm, attr);
>>>>>>>> +       default:
>>>>>>>> +               return -ENXIO;
>>>>>>>> +       }
>>>>>>>> +}
>>>>>>>> +
>>>>>>>>      int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>>>>>>>      {
>>>>>>>> -       return -ENOIOCTLCMD;
>>>>>>>> +       struct kvm *kvm = filp->private_data;
>>>>>>>> +       void __user *argp = (void __user *)arg;
>>>>>>>> +       struct kvm_device_attr attr;
>>>>>>>> +
>>>>>>>> +       switch (ioctl) {
>>>>>>>> +       case KVM_HAS_DEVICE_ATTR:
>>>>>>>> +               if (copy_from_user(&attr, argp, sizeof(attr)))
>>>>>>>> +                       return -EFAULT;
>>>>>>>> +
>>>>>>>> +               return kvm_vm_has_attr(kvm, &attr);
>>>>>>>> +       default:
>>>>>>>> +               return -EINVAL;
>>>>>>>> +       }
>>>>>>>>      }
>>>>>>>> --
>>>>>>>> 2.39.3
>>>>>>>>
>>>>>>
>>>>
>>


