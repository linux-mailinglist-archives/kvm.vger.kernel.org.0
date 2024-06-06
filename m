Return-Path: <kvm+bounces-19011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F23B68FE608
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 14:05:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7A391C24977
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 12:05:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E69419596C;
	Thu,  6 Jun 2024 12:05:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F0C1FAA;
	Thu,  6 Jun 2024 12:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717675523; cv=none; b=FKYEqsfQslK9Wh6raZFRX23L1nkDIBui5dDNdMdSjjo/Kp5+rvh/WgKynYHXYR2/9c1uH6AOcfC/NuY1/akVVgsDON1/VBJslxajhkaBwPm4BHobe9HetX94jQtggYGznpwxhDdoRABo13QhEmG8PjwfYKyONzQottqnFRzJVjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717675523; c=relaxed/simple;
	bh=vfyoX5kteCRR1xD8K7FFTepZ0enm4dufLuYIW1N4V9E=;
	h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=t5/Y+cEjFgRVphosky0x+C/QmNICkZFfMrV9m66JHEncGgFor1cc4Qr5K6MXilhGQ6ud+bq+HpLGydMEhPrM3vIoF4Q4X60CbJtPQ/c1mysXR6Ip52fR4UGzF2dxBBcyyVogDFNZeyYzST78ySv6qLG+XIDPIYMVj+QsV0hEG4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxyOn9pWFmqDcEAA--.4986S3;
	Thu, 06 Jun 2024 20:05:17 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Dxusb7pWFmauAWAA--.57600S3;
	Thu, 06 Jun 2024 20:05:17 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Add feature passing from user space
From: maobibo <maobibo@loongson.cn>
To: WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Huacai Chen <chenhuacai@kernel.org>
Cc: kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20240606074850.2651896-1-maobibo@loongson.cn>
 <9bb552c8-fe86-43dc-9c4e-0b95c99fb25c@xen0n.name>
 <2774b010-8033-2167-474a-cb1b29b27d2b@loongson.cn>
Message-ID: <ca286a23-f22b-092c-20d0-6ab20fd0883f@loongson.cn>
Date: Thu, 6 Jun 2024 20:05:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2774b010-8033-2167-474a-cb1b29b27d2b@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Dxusb7pWFmauAWAA--.57600S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKFykXFyfuw15Aw4rXw1fAFc_yoW7ZF47pr
	yvyFs8GrWUGr1fCr1kta4DXryUJr1xGw12qF17X3W8JF47Kr12gr1vgryqgF1DJw48X3W0
	qF1Yqw13ZF1YqwcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Sb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07
	AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C2
	67AKxVWUAVWUtwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI
	8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWU
	CwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r
	1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBI
	daVFxhVjvjDU0xZFpf9x07jY38nUUUUU=



On 2024/6/6 下午7:54, maobibo wrote:
> Xuerui,
> 
> Thanks for your reviewing.
> I reply inline.
> 
> On 2024/6/6 下午7:20, WANG Xuerui wrote:
>> Hi,
>>
>> On 6/6/24 15:48, Bibo Mao wrote:
>>> Currently features defined in cpucfg CPUCFG_KVM_FEATURE comes from
>>> kvm kernel mode only. Some features are defined in user space VMM,
>>
>> "come from kernel side only. But currently KVM is not aware of 
>> user-space VMM features which makes it hard to employ optimizations 
>> that are both (1) specific to the VM use case and (2) requiring 
>> cooperation from user space."
> Will modify in next version.
>>
>>> however KVM module does not know. Here interface is added to update
>>> register CPUCFG_KVM_FEATURE from user space, only bit 24 - 31 is valid.
>>>
>>> Feature KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI is added from user mdoe.
>>> FEAT_VIRT_EXTIOI is virt EXTIOI extension which can route interrupt
>>> to 256 VCPUs rather than 4 CPUs like real hw.
>>
>> "A new feature bit ... is added which can be set from user space. 
>> FEAT_... indicates that the VM EXTIOI can route interrupts to 256 
>> vCPUs, rather than 4 like with real HW."
> will modify in next version.
> 
>>
>> (Am I right in paraphrasing the "EXTIOI" part?)
>>
>>>
>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>> ---
>>>   arch/loongarch/include/asm/kvm_host.h  |  4 +++
>>>   arch/loongarch/include/asm/loongarch.h |  5 ++++
>>>   arch/loongarch/include/uapi/asm/kvm.h  |  2 ++
>>>   arch/loongarch/kvm/exit.c              |  1 +
>>>   arch/loongarch/kvm/vcpu.c              | 36 +++++++++++++++++++++++---
>>>   5 files changed, 44 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/arch/loongarch/include/asm/kvm_host.h 
>>> b/arch/loongarch/include/asm/kvm_host.h
>>> index 88023ab59486..8fa50d757247 100644
>>> --- a/arch/loongarch/include/asm/kvm_host.h
>>> +++ b/arch/loongarch/include/asm/kvm_host.h
>>> @@ -135,6 +135,9 @@ enum emulation_result {
>>>   #define KVM_LARCH_HWCSR_USABLE    (0x1 << 4)
>>>   #define KVM_LARCH_LBT        (0x1 << 5)
>>> +#define KVM_LOONGARCH_USR_FEAT_MASK            \
>>> +    BIT(KVM_LOONGARCH_VCPU_FEAT_VIRT_EXTIOI)
>>> +
>>>   struct kvm_vcpu_arch {
>>>       /*
>>>        * Switch pointer-to-function type to unsigned long
>>> @@ -210,6 +213,7 @@ struct kvm_vcpu_arch {
>>>           u64 last_steal;
>>>           struct gfn_to_hva_cache cache;
>>>       } st;
>>> +    unsigned int usr_features;
>>>   };
>>>   static inline unsigned long readl_sw_gcsr(struct loongarch_csrs 
>>> *csr, int reg)
>>> diff --git a/arch/loongarch/include/asm/loongarch.h 
>>> b/arch/loongarch/include/asm/loongarch.h
>>> index 7a4633ef284b..4d9837512c19 100644
>>> --- a/arch/loongarch/include/asm/loongarch.h
>>> +++ b/arch/loongarch/include/asm/loongarch.h
>>> @@ -167,9 +167,14 @@
>>>   #define CPUCFG_KVM_SIG            (CPUCFG_KVM_BASE + 0)
>>>   #define  KVM_SIGNATURE            "KVM\0"
>>> +/*
>>> + * BIT 24 - 31 is features configurable by user space vmm
>>> + */
>>>   #define CPUCFG_KVM_FEATURE        (CPUCFG_KVM_BASE + 4)
>>>   #define  KVM_FEATURE_IPI        BIT(1)
>>>   #define  KVM_FEATURE_STEAL_TIME        BIT(2)
>>> +/* With VIRT_EXTIOI feature, interrupt can route to 256 VCPUs */
>>> +#define  KVM_FEATURE_VIRT_EXTIOI    BIT(24)
>>>   #ifndef __ASSEMBLY__
>>
>> What about assigning a new CPUCFG leaf ID for separating the two kinds 
>> of feature flags very cleanly?
> For compatible issue like new kernel on old KVM host, to add a new
> CPUCFG leaf ID, a new feature need be defined on existing 
> CPUCFG_KVM_FEATURE register. Such as:
>     #define  KVM_FEATURE_EXTEND_CPUCFG        BIT(3)
> 
> VM need check feature KVM_FEATURE_EXTEND_CPUCFG at first, and then read 
> the new CPUCFG leaf ID if feature EXTEND_CPUCFG is enabled.
> 
> That maybe makes it complicated since feature bit is enough now.
The default return value is zero with old kvm host, it is possible to
use a new CPUCFG leaf ID. Both methods are ok for me.

Huacai,
What is your optnion about this?

Regards
Bibo Mao
>>
>>> @@ -896,7 +907,24 @@ static int kvm_loongarch_vcpu_get_attr(struct 
>>> kvm_vcpu *vcpu,
>>>   static int kvm_loongarch_cpucfg_set_attr(struct kvm_vcpu *vcpu,
>>>                        struct kvm_device_attr *attr)
>>>   {
>>> -    return -ENXIO;
>>> +    u64 __user *user = (u64 __user *)attr->addr;
>>> +    u64 val, valid_flags;
>>> +
>>> +    switch (attr->attr) {
>>> +    case CPUCFG_KVM_FEATURE:
>>> +        if (get_user(val, user))
>>> +            return -EFAULT;
>>> +
>>> +        valid_flags = KVM_LOONGARCH_USR_FEAT_MASK;
>>> +        if (val & ~valid_flags)
>>> +            return -EINVAL;
>>> +
>>> +        vcpu->arch.usr_features |= val;
>>
>> Isn't this usage of "|=" instead of "=" implying that the feature bits 
>> could not get disabled after being enabled earlier, for whatever reason?
> yes, "=" is better. Will modify in next version.
> 
> Regards
> Bibo Mao
>>
>>> +        return 0;
>>> +
>>> +    default:
>>> +        return -ENXIO;
>>> +    }
>>>   }
>>>   static int kvm_loongarch_vcpu_set_attr(struct kvm_vcpu *vcpu,
>>>
>>> base-commit: 2df0193e62cf887f373995fb8a91068562784adc
>>
> 


