Return-Path: <kvm+bounces-20923-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9ABC926D15
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 03:24:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7EFDA28166F
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2024 01:24:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC14DCA64;
	Thu,  4 Jul 2024 01:24:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73ABB4C6E;
	Thu,  4 Jul 2024 01:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720056276; cv=none; b=lC0reeaCYArNf8f+cM2HIwqFSTXlX4KI8kbEkhLMN+Oyo/ZRW/2iIAl+v6rNT80iqYLdWS2C9IPiFioOWiG33nW0YKjAIX9mPIE1/vQT9VDk2A6x/fcpgK3QKOllpqYlF/UWmJYS10o8ZMT6VBQRwKovVWSmfzsyDgXD0wrHNJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720056276; c=relaxed/simple;
	bh=GU+TvkUVrTgWGtAhwcUyRQA50B33D/7lGv9sRiHYabU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=C6GrN5XaHXf7ZgKKZCVvT2SUphrnCpYfCFJEitXKEfv5T5VFn5ilIgauzzGzT2Z4wOmMJSZrPZYdae3ssKEDFzBESMRnw5WrW4J7VN1SwqTvxsewl5uf6JLF0JNDFliEgcVkiPBzvYJc1R9w07bn3eTpAANthWUGZsWMdyMuz+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxDOvL+YVmtcIAAA--.2279S3;
	Thu, 04 Jul 2024 09:24:28 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8AxDMfJ+YVmOm86AA--.4554S3;
	Thu, 04 Jul 2024 09:24:27 +0800 (CST)
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
 <7e6a1dbc-779a-4669-4541-c5952c9bdf24@loongson.cn>
 <CAAhV-H7jY8p8eY4rVLcMvVky9ZQTyZkA+0UsW2JkbKYtWvjmZg@mail.gmail.com>
 <81dded06-ad03-9aed-3f07-cf19c5538723@loongson.cn>
 <CAAhV-H520i-2N0DUPO=RJxtU8Sn+eofQAy7_e+rRsnNdgv8DTQ@mail.gmail.com>
 <0e28596c-3fe9-b716-b193-200b9b1d5516@loongson.cn>
 <CAAhV-H6vgb1D53zHoe=BJD1crB9jcdZy7RM-G0YY0UD+ubDi4g@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <aac97476-0a3a-657d-9340-c129bc710791@loongson.cn>
Date: Thu, 4 Jul 2024 09:24:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6vgb1D53zHoe=BJD1crB9jcdZy7RM-G0YY0UD+ubDi4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8AxDMfJ+YVmOm86AA--.4554S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3ZF17KF4fAF1kWryxuFy3GFX_yoW8Gry8Go
	W5Jr1xJr18Jr1UAF1UJ34DJr1UJw1UJr1UJryUJr15Jr1Utw1UAr1UJr1UJF47Jr1UGryU
	JryUJr1UAF17Jr1Ul-sFpf9Il3svdjkaLaAFLSUrUUUU1b8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUYJ7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4j6r4UJwAaw2AFwI0_Jrv_JF1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0c
	Ia020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_
	JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrw
	CYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMxCIbckI1I0E14v26r1Y6r17MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwV
	AFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv2
	0xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4
	v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AK
	xVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxU2MKZDUUUU



On 2024/7/3 下午11:35, Huacai Chen wrote:
> On Wed, Jul 3, 2024 at 11:15 AM maobibo <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2024/7/2 下午11:43, Huacai Chen wrote:
>>> On Tue, Jul 2, 2024 at 4:42 PM maobibo <maobibo@loongson.cn> wrote:
>>>>
>>>>
>>>>
>>>> On 2024/7/2 下午3:28, Huacai Chen wrote:
>>>>> On Tue, Jul 2, 2024 at 12:13 PM maobibo <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2024/7/2 上午10:34, Huacai Chen wrote:
>>>>>>> On Tue, Jul 2, 2024 at 10:25 AM maobibo <maobibo@loongson.cn> wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>>
>>>>>>>> On 2024/7/2 上午9:59, Huacai Chen wrote:
>>>>>>>>> On Tue, Jul 2, 2024 at 9:51 AM maobibo <maobibo@loongson.cn> wrote:
>>>>>>>>>>
>>>>>>>>>> Huacai,
>>>>>>>>>>
>>>>>>>>>> On 2024/7/1 下午6:26, Huacai Chen wrote:
>>>>>>>>>>> On Mon, Jul 1, 2024 at 9:27 AM maobibo <maobibo@loongson.cn> wrote:
>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> Huacai,
>>>>>>>>>>>>
>>>>>>>>>>>> On 2024/6/30 上午10:07, Huacai Chen wrote:
>>>>>>>>>>>>> Hi, Bibo,
>>>>>>>>>>>>>
>>>>>>>>>>>>> On Wed, Jun 26, 2024 at 2:32 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Two kinds of LBT feature detection are added here, one is VCPU
>>>>>>>>>>>>>> feature, the other is VM feature. VCPU feature dection can only
>>>>>>>>>>>>>> work with VCPU thread itself, and requires VCPU thread is created
>>>>>>>>>>>>>> already. So LBT feature detection for VM is added also, it can
>>>>>>>>>>>>>> be done even if VM is not created, and also can be done by any
>>>>>>>>>>>>>> thread besides VCPU threads.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Loongson Binary Translation (LBT) feature is defined in register
>>>>>>>>>>>>>> cpucfg2. Here LBT capability detection for VCPU is added.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Here ioctl command KVM_HAS_DEVICE_ATTR is added for VM, and macro
>>>>>>>>>>>>>> KVM_LOONGARCH_VM_FEAT_CTRL is added to check supported feature. And
>>>>>>>>>>>>>> three sub-features relative with LBT are added as following:
>>>>>>>>>>>>>>         KVM_LOONGARCH_VM_FEAT_X86BT
>>>>>>>>>>>>>>         KVM_LOONGARCH_VM_FEAT_ARMBT
>>>>>>>>>>>>>>         KVM_LOONGARCH_VM_FEAT_MIPSBT
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>>>>>>>>>> ---
>>>>>>>>>>>>>>         arch/loongarch/include/uapi/asm/kvm.h |  6 ++++
>>>>>>>>>>>>>>         arch/loongarch/kvm/vcpu.c             |  6 ++++
>>>>>>>>>>>>>>         arch/loongarch/kvm/vm.c               | 44 ++++++++++++++++++++++++++-
>>>>>>>>>>>>>>         3 files changed, 55 insertions(+), 1 deletion(-)
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>>>>>>>>>>>>>> index ddc5cab0ffd0..c40f7d9ffe13 100644
>>>>>>>>>>>>>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>>>>>>>>>>>>>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>>>>>>>>>>>>>> @@ -82,6 +82,12 @@ struct kvm_fpu {
>>>>>>>>>>>>>>         #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
>>>>>>>>>>>>>>         #define KVM_IOC_CPUCFG(REG)            LOONGARCH_REG_64(KVM_REG_LOONGARCH_CPUCFG, REG)
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> +/* Device Control API on vm fd */
>>>>>>>>>>>>>> +#define KVM_LOONGARCH_VM_FEAT_CTRL     0
>>>>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_X86BT   0
>>>>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_ARMBT   1
>>>>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_MIPSBT  2
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>         /* Device Control API on vcpu fd */
>>>>>>>>>>>>>>         #define KVM_LOONGARCH_VCPU_CPUCFG      0
>>>>>>>>>>>>>>         #define KVM_LOONGARCH_VCPU_PVTIME_CTRL 1
>>>>>>>>>>>>> If you insist that LBT should be a vm feature, then I suggest the
>>>>>>>>>>>>> above two also be vm features. Though this is an UAPI change, but
>>>>>>>>>>>>> CPUCFG is upstream in 6.10-rc1 and 6.10-final hasn't been released. We
>>>>>>>>>>>>> have a chance to change it now.
>>>>>>>>>>>>
>>>>>>>>>>>> KVM_LOONGARCH_VCPU_PVTIME_CTRL need be attr percpu since every vcpu
>>>>>>>>>>>> has is own different gpa address.
>>>>>>>>>>> Then leave this as a vm feature.
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> For KVM_LOONGARCH_VCPU_CPUCFG attr, it will not changed. We cannot break
>>>>>>>>>>>> the API even if it is 6.10-rc1, VMM has already used this. Else there is
>>>>>>>>>>>> uapi breaking now, still will be in future if we cannot control this.
>>>>>>>>>>> UAPI changing before the first release is allowed, which means, we can
>>>>>>>>>>> change this before the 6.10-final, but cannot change it after
>>>>>>>>>>> 6.10-final.
>>>>>>>>>> Now QEMU has already synced uapi to its own directory, also I never hear
>>>>>>>>>> about this, with my experience with uapi change, there is only newly
>>>>>>>>>> added or removed deprecated years ago.
>>>>>>>>>>
>>>>>>>>>> Is there any documentation about UAPI change rules?
>>>>>>>>> No document, but learn from my more than 10 years upstream experience.
>>>>>>>> Can you show me an example about with your rich upstream experience?
>>>>>>> A simple example,
>>>>>>> e877d705704d7c8fe17b6b5ebdfdb14b84c revert
>>>>>>> 1dccdba084897443d116508a8ed71e0ac8a0 and it changes UAPI.
>>>>>>> 1dccdba084897443d116508a8ed71e0ac8a0 is upstream in 6.9-rc1, and
>>>>>>> e877d705704d7c8fe17b6b5ebdfdb14b84c can revert the behavior before
>>>>>>> 6.9-final, but not after that.
>>>>>>>
>>>>>>> Before the first release, the code status is treated as "unstable", so
>>>>>>> revert, modify is allowed. But after the first release, even if an
>>>>>>> "error" should also be treated as a "bad feature".
>>>>>> Huacai,
>>>>>>
>>>>>> Thanks for showing the example.
>>>>>>
>>>>>> For this issue, Can we adding new uapi and mark the old as deprecated?
>>>>>> so that it can be removed after years.
>>>>> Unnecessary, just remove the old one. Deprecation is for the usage
>>>>> after the first release.
>>>>>
>>>>>>
>>>>>> For me, it is too frequent to revert the old uapi, it is not bug and
>>>>>> only that we have better method now. Also QEMU has synchronized the uapi
>>>>>> to its directory already.
>>>>> QEMU also hasn't been released after synchronizing the uapi, so it is
>>>>> OK to remove the old api now.
>>>> No, I will not do such thing. It is just a joke to revert the uapi.
>>>>
>>>> So just create new world and old world on Loongarch system again?
>>> Again, code status before the first release is *unstable*, that status
>>> is not enough to be a "world".
>>>
>>> It's your responsibility to make a good design at the beginning, but
>>> you fail to do that. Fortunately we are before the first release;
>>> unfortunately you don't want to do that.
>> Yes, this is flaw at the beginning, however it can works and new abi can
>> be added.
>>
>> If there is no serious bug and it is synced to QEMU already, I am not
>> willing to revert uabi. Different projects have its own schedule plan,
>> that is one reason. The most important reason may be that different
>> peoples have different ways handling these issues.
> In another thread I found that Jiaxun said he has a solution to make
> LBT be a vcpu feature and still works well. However, that may take
> some time and is too late for 6.11.

It is welcome if Jiaxun provide patch for host machine type, I have no 
time give any feedback with suggestion of Jianxun now.

> 
> But we have another choice now: just remove the UAPI and vm.c parts in
> this series, let the LBT main parts be upstream in 6.11, and then
> solve other problems after 6.11. Even if Jiaxun's solution isn't
> usable, we can still use this old vm feature solution then.

There is not useul if only LBT main part goes upstream. VMM cannot use 
LBT if control part is not merged.

 From another side, what do you like to do? Reviewing patch of others 
and give comments whatever grammar spelling or useful suggestions, or 
Writing patch which needs much efforts rather than somethings like 
feature configuration, BSP drivers.

Regards
Bibo Mao

> 
> 
> Huacai
>>
>> Regards
>> Bibo, Mao
>>>
>>>
>>> Huacai
>>>
>>>>
>>>> Regards
>>>> Bibo, Mao
>>>>
>>>>>
>>>>> Huacai
>>>>>
>>>>>>
>>>>>> Regards
>>>>>> Bibo, Mao
>>>>>>>
>>>>>>> Huacai
>>>>>>>
>>>>>>>
>>>>>>>>>
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> How about adding new extra features capability for VM such as?
>>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LSX   3
>>>>>>>>>>>> +#define  KVM_LOONGARCH_VM_FEAT_LASX  4
>>>>>>>>>>> They should be similar as LBT, if LBT is vcpu feature, they should
>>>>>>>>>>> also be vcpu features; if LBT is vm feature, they should also be vm
>>>>>>>>>>> features.
>>>>>>>>>> On other architectures, with function kvm_vm_ioctl_check_extension()
>>>>>>>>>>          KVM_CAP_XSAVE2/KVM_CAP_PMU_CAPABILITY on x86
>>>>>>>>>>          KVM_CAP_ARM_PMU_V3/KVM_CAP_ARM_SVE on arm64
>>>>>>>>>> These features are all cpu features, at the same time they are VM features.
>>>>>>>>>>
>>>>>>>>>> If they are cpu features, how does VMM detect validity of these features
>>>>>>>>>> passing from command line? After all VCPUs are created and send bootup
>>>>>>>>>> command to these VCPUs? That is too late, VMM main thread is easy to
>>>>>>>>>> detect feature validity if they are VM features also.
>>>>>>>>>>
>>>>>>>>>> To be honest, I am not familiar with KVM still, only get further
>>>>>>>>>> understanding after actual problems solving. Welcome to give comments,
>>>>>>>>>> however please read more backgroud if you insist on, else there will be
>>>>>>>>>> endless argument again.
>>>>>>>>> I just say CPUCFG/LSX/LASX and LBT should be in the same class, I
>>>>>>>>> haven't insisted on whether they should be vcpu features or vm
>>>>>>>>> features.
>>>>>>>> It is reasonable if LSX/LASX/LBT should be in the same class, since
>>>>>>>> there is feature options such as lsx=on/off,lasx=on/off,lbt=on/off.
>>>>>>>>
>>>>>>>> What is the usage about CPUCFG capability used for VM feature? It is not
>>>>>>>> a detailed feature, it is only feature-set indicator like cpuid.
>>>>>>>>
>>>>>>>> Regards
>>>>>>>> Bibo Mao
>>>>>>>>>
>>>>>>>>> Huacai
>>>>>>>>>
>>>>>>>>>>
>>>>>>>>>> Regards
>>>>>>>>>> Bibo, Mao
>>>>>>>>>>>
>>>>>>>>>>> Huacai
>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>>> Regards
>>>>>>>>>>>> Bibo Mao
>>>>>>>>>>>>>
>>>>>>>>>>>>> Huacai
>>>>>>>>>>>>>
>>>>>>>>>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>>>>>>>>>>>> index 233d28d0e928..9734b4d8db05 100644
>>>>>>>>>>>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>>>>>>>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>>>>>>>>>>>> @@ -565,6 +565,12 @@ static int _kvm_get_cpucfg_mask(int id, u64 *v)
>>>>>>>>>>>>>>                                *v |= CPUCFG2_LSX;
>>>>>>>>>>>>>>                        if (cpu_has_lasx)
>>>>>>>>>>>>>>                                *v |= CPUCFG2_LASX;
>>>>>>>>>>>>>> +               if (cpu_has_lbt_x86)
>>>>>>>>>>>>>> +                       *v |= CPUCFG2_X86BT;
>>>>>>>>>>>>>> +               if (cpu_has_lbt_arm)
>>>>>>>>>>>>>> +                       *v |= CPUCFG2_ARMBT;
>>>>>>>>>>>>>> +               if (cpu_has_lbt_mips)
>>>>>>>>>>>>>> +                       *v |= CPUCFG2_MIPSBT;
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>                        return 0;
>>>>>>>>>>>>>>                case LOONGARCH_CPUCFG3:
>>>>>>>>>>>>>> diff --git a/arch/loongarch/kvm/vm.c b/arch/loongarch/kvm/vm.c
>>>>>>>>>>>>>> index 6b2e4f66ad26..09e05108c68b 100644
>>>>>>>>>>>>>> --- a/arch/loongarch/kvm/vm.c
>>>>>>>>>>>>>> +++ b/arch/loongarch/kvm/vm.c
>>>>>>>>>>>>>> @@ -99,7 +99,49 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>>>>>>>>>>>>>                return r;
>>>>>>>>>>>>>>         }
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> +static int kvm_vm_feature_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>> +       switch (attr->attr) {
>>>>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_X86BT:
>>>>>>>>>>>>>> +               if (cpu_has_lbt_x86)
>>>>>>>>>>>>>> +                       return 0;
>>>>>>>>>>>>>> +               return -ENXIO;
>>>>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_ARMBT:
>>>>>>>>>>>>>> +               if (cpu_has_lbt_arm)
>>>>>>>>>>>>>> +                       return 0;
>>>>>>>>>>>>>> +               return -ENXIO;
>>>>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_MIPSBT:
>>>>>>>>>>>>>> +               if (cpu_has_lbt_mips)
>>>>>>>>>>>>>> +                       return 0;
>>>>>>>>>>>>>> +               return -ENXIO;
>>>>>>>>>>>>>> +       default:
>>>>>>>>>>>>>> +               return -ENXIO;
>>>>>>>>>>>>>> +       }
>>>>>>>>>>>>>> +}
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +static int kvm_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>>>>>>>>>> +{
>>>>>>>>>>>>>> +       switch (attr->group) {
>>>>>>>>>>>>>> +       case KVM_LOONGARCH_VM_FEAT_CTRL:
>>>>>>>>>>>>>> +               return kvm_vm_feature_has_attr(kvm, attr);
>>>>>>>>>>>>>> +       default:
>>>>>>>>>>>>>> +               return -ENXIO;
>>>>>>>>>>>>>> +       }
>>>>>>>>>>>>>> +}
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>         int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>>>>>>>>>>>>>>         {
>>>>>>>>>>>>>> -       return -ENOIOCTLCMD;
>>>>>>>>>>>>>> +       struct kvm *kvm = filp->private_data;
>>>>>>>>>>>>>> +       void __user *argp = (void __user *)arg;
>>>>>>>>>>>>>> +       struct kvm_device_attr attr;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +       switch (ioctl) {
>>>>>>>>>>>>>> +       case KVM_HAS_DEVICE_ATTR:
>>>>>>>>>>>>>> +               if (copy_from_user(&attr, argp, sizeof(attr)))
>>>>>>>>>>>>>> +                       return -EFAULT;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>> +               return kvm_vm_has_attr(kvm, &attr);
>>>>>>>>>>>>>> +       default:
>>>>>>>>>>>>>> +               return -EINVAL;
>>>>>>>>>>>>>> +       }
>>>>>>>>>>>>>>         }
>>>>>>>>>>>>>> --
>>>>>>>>>>>>>> 2.39.3
>>>>>>>>>>>>>>
>>>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>
>>>>>>
>>>>
>>
>>


