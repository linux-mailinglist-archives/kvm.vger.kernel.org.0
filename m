Return-Path: <kvm+bounces-34421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CEE79FEE55
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 10:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 440201882EDF
	for <lists+kvm@lfdr.de>; Tue, 31 Dec 2024 09:27:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22C331925AC;
	Tue, 31 Dec 2024 09:27:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC6713B7AE;
	Tue, 31 Dec 2024 09:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735637254; cv=none; b=B7jKhylsPsoQk9sNWzWpuXh9e7cSNjL5FbmoEMbjPur9ORFtnREY5nKMfC/B4SoYerM4yBkj0ui4j2m1mAhZdjK7UGpWMyxvcBqfKcrqgn7l2T8j2Mj5DIxBP3JzQr08GgIXxuAZcnpv2DtIORLVvzRK7xuu2d9+B4Nv2BBfWgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735637254; c=relaxed/simple;
	bh=i+k0L0ERlbesviZh4TGK//WLuRSAFR5Uk+lko+wyJf4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VVRveMf5z132tR+iM60WlMh5hnbSQRRxdYbYmVoG7iGfDmcUb7GGhW0BQyauYASJWu7gJkKI9RWZfotinxQuWnAeQ7T5UqxNulCxag3wIdaLfYYWIudKg/hEoNWIQwK2DNGtGf95lzzRM3Na5ba14OQTYllqPpJL+Hknh+ZbatI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxquH7uHNno1tcAA--.54486S3;
	Tue, 31 Dec 2024 17:27:23 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMBxzsX6uHNnkTgPAA--.65144S3;
	Tue, 31 Dec 2024 17:27:22 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Add hypercall service support for
 usermode VMM
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241223084212.34822-1-maobibo@loongson.cn>
 <CAAhV-H73CaNYFtgDfM+SOXYmwUhzr1w7JC4D+t2aASyUBxxTrA@mail.gmail.com>
 <d186408c-f083-2404-de60-2ec3c8b528cf@loongson.cn>
 <CAAhV-H42D4Rybzkc9YVsjo+GEQwiq4LTdjtmWyOzaqmuW6x8CQ@mail.gmail.com>
 <521ca7c6-64a2-53fa-5cff-b366ae73f600@loongson.cn>
 <CAAhV-H5TVwX2T=ccT4o0btJEbL+gwBESBD6Y_Z2BEqNuhom3iw@mail.gmail.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <8814cf39-0842-ec48-c578-e5e6eeda2295@loongson.cn>
Date: Tue, 31 Dec 2024 17:26:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H5TVwX2T=ccT4o0btJEbL+gwBESBD6Y_Z2BEqNuhom3iw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMBxzsX6uHNnkTgPAA--.65144S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3XFyDuw4rZF1fuF4ruFWfZwc_yoW3Zw4fpr
	yUAF4kGrWUKr4SkwnFqwn0gr9Fgr4kKr1IgF1UGFWayrnIv3Z3Jr48tr98CF98Jw1rJF18
	ZF95tw13uF15J3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw
	1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8I3
	8UUUUUU==



On 2024/12/31 下午4:41, Huacai Chen wrote:
> On Mon, Dec 30, 2024 at 10:13 AM bibo mao <maobibo@loongson.cn> wrote:
>>
>> Hi Huacai,
>>
>> On 2024/12/23 下午5:05, Huacai Chen wrote:
>>> I also tried to port an untested version, but I think your version is
>>> a tested one.
>>> https://github.com/chenhuacai/linux/commit/e6596b0e45c80756794aba74ac086c5c0e0306eb
>>>
>>> And I have some questions:
>>> 1, "user service" is not only for syscall, so you rename it?
>>> 2, Why 4.19 doesn't need something like "vcpu->run->hypercall.args[0]
>>> = kvm_read_reg(vcpu, LOONGARCH_GPR_A0);"
>>> 3, I think my version about "vcpu->run->exit_reason =
>>> KVM_EXIT_HYPERCALL;" and "update_pc()" is a little better than yours,
>>> so you can improve them.
>> After a second thought, update_pc() before return to user may be not
>> strictly right, since user VMM can dump registers including pc which is
>> advanced already.
> Agree, and we can see how others do.
> 
>>
>> How about adding function kvm_complete_hypercall() like
>> kvm_complete_mmio_read(), such as:
>   kvm_complete_user_service() maybe better? Since the "classic
> hypercall" doesn't come here.
sure, will do rename it with kvm_complete_user_service.

> 
> And we may also need to set vcpu->run->exit_reason for all cases,
> which is done in my version.
By my understanding, exit_reason need be set only for RESUME_HOST.
it is unnecessary for RESUME_GUEST.

Regards
Bibo Mao
> 
> Huacai
> 
>> --- a/arch/loongarch/kvm/exit.c
>> +++ b/arch/loongarch/kvm/exit.c
>> +int kvm_complete_hypercall(struct kvm_vcpu *vcpu, struct kvm_run *run)
>> +{
>> +       update_pc(&vcpu->arch);
>> +       kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.ret);
>> +}
>> +
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -1736,8 +1736,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>                   if (!run->iocsr_io.is_write)
>>                           kvm_complete_iocsr_read(vcpu, run);
>>           } else if (run->exit_reason == KVM_EXIT_HYPERCALL) {
>> -               kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.ret);
>> -               update_pc(&vcpu->arch);
>> +               kvm_complete_hypercall(vcpu, run);
>> +               run->exit_reason = KVM_EXIT_UNKNOWN;
>>           }
>>
>> Regards
>> Bibo Mao
>>>
>>> Huacai
>>>
>>> On Mon, Dec 23, 2024 at 4:54 PM bibo mao <maobibo@loongson.cn> wrote:
>>>>
>>>>
>>>>
>>>> On 2024/12/23 下午4:50, Huacai Chen wrote:
>>>>> Hi, Bibo,
>>>>>
>>>>> Is this patch trying to do the same thing as "LoongArch: add hypcall
>>>>> to emulate syscall in kvm" in 4.19?
>>>> yes, it is to do so -:)
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>>
>>>>> Huacai
>>>>>
>>>>> On Mon, Dec 23, 2024 at 4:42 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>> Some VMMs provides special hypercall service in usermode, KVM need
>>>>>> not handle the usermode hypercall service and pass it to VMM and
>>>>>> let VMM handle it.
>>>>>>
>>>>>> Here new code KVM_HCALL_CODE_USER is added for user-mode hypercall
>>>>>> service, KVM loads all six registers to VMM.
>>>>>>
>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>> ---
>>>>>>     arch/loongarch/include/asm/kvm_host.h      |  1 +
>>>>>>     arch/loongarch/include/asm/kvm_para.h      |  2 ++
>>>>>>     arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
>>>>>>     arch/loongarch/kvm/exit.c                  | 22 ++++++++++++++++++++++
>>>>>>     arch/loongarch/kvm/vcpu.c                  |  3 +++
>>>>>>     5 files changed, 29 insertions(+)
>>>>>>
>>>>>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>>>>>> index 7b8367c39da8..590982cd986e 100644
>>>>>> --- a/arch/loongarch/include/asm/kvm_host.h
>>>>>> +++ b/arch/loongarch/include/asm/kvm_host.h
>>>>>> @@ -162,6 +162,7 @@ enum emulation_result {
>>>>>>     #define LOONGARCH_PV_FEAT_UPDATED      BIT_ULL(63)
>>>>>>     #define LOONGARCH_PV_FEAT_MASK         (BIT(KVM_FEATURE_IPI) |         \
>>>>>>                                             BIT(KVM_FEATURE_STEAL_TIME) |  \
>>>>>> +                                        BIT(KVM_FEATURE_USER_HCALL) |  \
>>>>>>                                             BIT(KVM_FEATURE_VIRT_EXTIOI))
>>>>>>
>>>>>>     struct kvm_vcpu_arch {
>>>>>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
>>>>>> index c4e84227280d..d3c00de484f6 100644
>>>>>> --- a/arch/loongarch/include/asm/kvm_para.h
>>>>>> +++ b/arch/loongarch/include/asm/kvm_para.h
>>>>>> @@ -13,12 +13,14 @@
>>>>>>
>>>>>>     #define KVM_HCALL_CODE_SERVICE         0
>>>>>>     #define KVM_HCALL_CODE_SWDBG           1
>>>>>> +#define KVM_HCALL_CODE_USER            2
>>>>>>
>>>>>>     #define KVM_HCALL_SERVICE              HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SERVICE)
>>>>>>     #define  KVM_HCALL_FUNC_IPI            1
>>>>>>     #define  KVM_HCALL_FUNC_NOTIFY         2
>>>>>>
>>>>>>     #define KVM_HCALL_SWDBG                        HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SWDBG)
>>>>>> +#define KVM_HCALL_USER_SERVICE         HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_USER)
>>>>>>
>>>>>>     /*
>>>>>>      * LoongArch hypercall return code
>>>>>> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongarch/include/uapi/asm/kvm_para.h
>>>>>> index b0604aa9b4bb..76d802ef01ce 100644
>>>>>> --- a/arch/loongarch/include/uapi/asm/kvm_para.h
>>>>>> +++ b/arch/loongarch/include/uapi/asm/kvm_para.h
>>>>>> @@ -17,5 +17,6 @@
>>>>>>     #define  KVM_FEATURE_STEAL_TIME                2
>>>>>>     /* BIT 24 - 31 are features configurable by user space vmm */
>>>>>>     #define  KVM_FEATURE_VIRT_EXTIOI       24
>>>>>> +#define  KVM_FEATURE_USER_HCALL                25
>>>>>>
>>>>>>     #endif /* _UAPI_ASM_KVM_PARA_H */
>>>>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>>>>>> index a7893bd01e73..1a85cd4fb6a5 100644
>>>>>> --- a/arch/loongarch/kvm/exit.c
>>>>>> +++ b/arch/loongarch/kvm/exit.c
>>>>>> @@ -873,6 +873,28 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
>>>>>>                    vcpu->stat.hypercall_exits++;
>>>>>>                    kvm_handle_service(vcpu);
>>>>>>                    break;
>>>>>> +       case KVM_HCALL_USER_SERVICE:
>>>>>> +               if (!kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_USER_HCALL)) {
>>>>>> +                       kvm_write_reg(vcpu, LOONGARCH_GPR_A0, KVM_HCALL_INVALID_CODE);
>>>>>> +                       break;
>>>>>> +               }
>>>>>> +
>>>>>> +               vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
>>>>>> +               vcpu->run->hypercall.nr = KVM_HCALL_USER_SERVICE;
>>>>>> +               vcpu->run->hypercall.args[0] = kvm_read_reg(vcpu, LOONGARCH_GPR_A0);
>>>>>> +               vcpu->run->hypercall.args[1] = kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
>>>>>> +               vcpu->run->hypercall.args[2] = kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
>>>>>> +               vcpu->run->hypercall.args[3] = kvm_read_reg(vcpu, LOONGARCH_GPR_A3);
>>>>>> +               vcpu->run->hypercall.args[4] = kvm_read_reg(vcpu, LOONGARCH_GPR_A4);
>>>>>> +               vcpu->run->hypercall.args[5] = kvm_read_reg(vcpu, LOONGARCH_GPR_A5);
>>>>>> +               vcpu->run->hypercall.flags = 0;
>>>>>> +               /*
>>>>>> +                * Set invalid return value by default
>>>>>> +                * Need user-mode VMM modify it
>>>>>> +                */
>>>>>> +               vcpu->run->hypercall.ret = KVM_HCALL_INVALID_CODE;
>>>>>> +               ret = RESUME_HOST;
>>>>>> +               break;
>>>>>>            case KVM_HCALL_SWDBG:
>>>>>>                    /* KVM_HCALL_SWDBG only in effective when SW_BP is enabled */
>>>>>>                    if (vcpu->guest_debug & KVM_GUESTDBG_SW_BP_MASK) {
>>>>>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>>>>>> index d18a4a270415..8c46ad1872ee 100644
>>>>>> --- a/arch/loongarch/kvm/vcpu.c
>>>>>> +++ b/arch/loongarch/kvm/vcpu.c
>>>>>> @@ -1735,6 +1735,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>>>>>            if (run->exit_reason == KVM_EXIT_LOONGARCH_IOCSR) {
>>>>>>                    if (!run->iocsr_io.is_write)
>>>>>>                            kvm_complete_iocsr_read(vcpu, run);
>>>>>> +       } else if (run->exit_reason == KVM_EXIT_HYPERCALL) {
>>>>>> +               kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.ret);
>>>>>> +               update_pc(&vcpu->arch);
>>>>>>            }
>>>>>>
>>>>>>            if (!vcpu->wants_to_run)
>>>>>>
>>>>>> base-commit: 48f506ad0b683d3e7e794efa60c5785c4fdc86fa
>>>>>> --
>>>>>> 2.39.3
>>>>>>
>>>>
>>>>
>>


