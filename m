Return-Path: <kvm+bounces-25643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 102B8967D9D
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 03:56:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48013B21812
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 01:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6FE29422;
	Mon,  2 Sep 2024 01:56:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B81F718641;
	Mon,  2 Sep 2024 01:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725242204; cv=none; b=tdVwC1dU0IjxDi4pAXTc4Bt/a/iTyhz4GzTS+T1N26WW7oRPIZCsW65mglnVbaoTh/4Cu/UWFIULjb3hkF9XUncacqCwkG70XDhIPKitY7McVUAWG3ljM18tJgssmGYwqYkCPOquLsNk8QTSojY3igUTBxEKU8Qyp4xf+UJirnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725242204; c=relaxed/simple;
	bh=x7T9w0Nw4AMzEYdKwTxYy2qgqPNk5PTKmKM9FqTHmqY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Ef35EO+lNbVSnOrCONe6motk8elJ6Bb7Ivbshqe/DhY1WTjNnwz4I56YKqgfmSSEzXm2QQJEn/9tJwiODTECugmqLtECQ+f2twLpES2GV3Mv+ib0q8Iv38xuJq4vSfYBIEGUPkzdTf0BlIO/MyevqreAzTwjnRQ7kDLjbU8zGVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8AxHutVG9Vm_OUnAA--.13011S3;
	Mon, 02 Sep 2024 09:56:37 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front2 (Coremail) with SMTP id qciowMAxbeRUG9VmNJcDAA--.11130S3;
	Mon, 02 Sep 2024 09:56:37 +0800 (CST)
Subject: Re: [PATCH v6 3/3] LoongArch: KVM: Add vm migration support for LBT
 registers
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>
References: <20240730075744.1215856-1-maobibo@loongson.cn>
 <20240730075744.1215856-4-maobibo@loongson.cn>
 <CAAhV-H7D80huYzF6ewZqcgx8MTzWZNFXJHOahoJ33zJYX1kyAw@mail.gmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <13276416-c62b-b33d-1824-7764122ef863@loongson.cn>
Date: Mon, 2 Sep 2024 09:56:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H7D80huYzF6ewZqcgx8MTzWZNFXJHOahoJ33zJYX1kyAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qciowMAxbeRUG9VmNJcDAA--.11130S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3GF1kXr45GrWfZrWrKw15Awc_yoW7uF4xpF
	1jyF4fGr18Kr1xC3yxKF1q9r17Xr4xAr4kuFyIqay8KrZ0vr95tw48trnxGFy3Ar1kurWx
	u3Z0yw1jkF97J3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx1l5I
	8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AK
	xVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzV
	AYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1EksDUU
	UUU==


Hi Huacai,

On 2024/8/31 下午10:49, Huacai Chen wrote:
> Hi, Bibo,
> 
> On Tue, Jul 30, 2024 at 3:57 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Every vcpu has separate LBT registers. And there are four scr registers,
>> one flags and ftop register for LBT extension. When VM migrates, VMM
>> needs to get LBT registers for every vcpu.
>>
>> Here macro KVM_REG_LOONGARCH_LBT is added for new vcpu lbt register type,
>> the following macro is added to get/put LBT registers.
>>    KVM_REG_LOONGARCH_LBT_SCR0
>>    KVM_REG_LOONGARCH_LBT_SCR1
>>    KVM_REG_LOONGARCH_LBT_SCR2
>>    KVM_REG_LOONGARCH_LBT_SCR3
>>    KVM_REG_LOONGARCH_LBT_EFLAGS
>>    KVM_REG_LOONGARCH_LBT_FTOP
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/uapi/asm/kvm.h |  9 +++++
>>   arch/loongarch/kvm/vcpu.c             | 56 +++++++++++++++++++++++++++
>>   2 files changed, 65 insertions(+)
>>
>> diff --git a/arch/loongarch/include/uapi/asm/kvm.h b/arch/loongarch/include/uapi/asm/kvm.h
>> index 49bafac8b22d..003fb766c93f 100644
>> --- a/arch/loongarch/include/uapi/asm/kvm.h
>> +++ b/arch/loongarch/include/uapi/asm/kvm.h
>> @@ -64,6 +64,7 @@ struct kvm_fpu {
>>   #define KVM_REG_LOONGARCH_KVM          (KVM_REG_LOONGARCH | 0x20000ULL)
>>   #define KVM_REG_LOONGARCH_FPSIMD       (KVM_REG_LOONGARCH | 0x30000ULL)
>>   #define KVM_REG_LOONGARCH_CPUCFG       (KVM_REG_LOONGARCH | 0x40000ULL)
>> +#define KVM_REG_LOONGARCH_LBT          (KVM_REG_LOONGARCH | 0x50000ULL)
>>   #define KVM_REG_LOONGARCH_MASK         (KVM_REG_LOONGARCH | 0x70000ULL)
> I think KVM_REG_LOONGARCH_MASK should contain all above register
> classes, so should it be  (KVM_REG_LOONGARCH | 0x370000ULL)?
Sorry, maybe I miss something. What is the meaning of 0x370000ULL? How 
does the value come from?

> 
>>   #define KVM_CSR_IDX_MASK               0x7fff
>>   #define KVM_CPUCFG_IDX_MASK            0x7fff
>> @@ -77,6 +78,14 @@ struct kvm_fpu {
>>   /* Debugging: Special instruction for software breakpoint */
>>   #define KVM_REG_LOONGARCH_DEBUG_INST   (KVM_REG_LOONGARCH_KVM | KVM_REG_SIZE_U64 | 3)
>>
>> +/* LBT registers */
>> +#define KVM_REG_LOONGARCH_LBT_SCR0     (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 1)
>> +#define KVM_REG_LOONGARCH_LBT_SCR1     (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 2)
>> +#define KVM_REG_LOONGARCH_LBT_SCR2     (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 3)
>> +#define KVM_REG_LOONGARCH_LBT_SCR3     (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 4)
>> +#define KVM_REG_LOONGARCH_LBT_EFLAGS   (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 5)
>> +#define KVM_REG_LOONGARCH_LBT_FTOP     (KVM_REG_LOONGARCH_LBT | KVM_REG_SIZE_U64 | 6)
> FTOP is a 32bit register in other place of the kernel, is it correct
> to use U64 here?
It is deliberate and there is no 32bit compat requirement for kvm. ALL 
regiester interfaces are defined as 64-bit.
On kernel and qemu side, ftop can be defined as 32bit still, however the 
interface is 64-bit. So there is forced type conversion between u32 and 
u64. There is no problem here.

> 
>> +
>>   #define LOONGARCH_REG_SHIFT            3
>>   #define LOONGARCH_REG_64(TYPE, REG)    (TYPE | KVM_REG_SIZE_U64 | (REG << LOONGARCH_REG_SHIFT))
>>   #define KVM_IOC_CSRID(REG)             LOONGARCH_REG_64(KVM_REG_LOONGARCH_CSR, REG)
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index b5324885a81a..b2500d4fa729 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -597,6 +597,34 @@ static int kvm_get_one_reg(struct kvm_vcpu *vcpu,
>>                          break;
>>                  }
>>                  break;
>> +       case KVM_REG_LOONGARCH_LBT:
> What about adding FPU/LSX/LASX registers (if needed for migration) in
> kvm_{get, set}_one_reg() here?
If there is 512bit SIMD or other requirement, it will be added in 
kvm_{get, set}_one_reg(). For FPU/LSX/LASX registers, there is common 
API KVM_GET_FPU/KVM_SET_FPU here. The impmentation of QEMU only gets 
FPU, the upper LSX/LASX is lost, we will submit a patch in qemu side, 
the kvm kernel side is ok.

/*
  * for KVM_GET_FPU and KVM_SET_FPU
  */
struct kvm_fpu {
         __u32 fcsr;
         __u64 fcc;    /* 8x8 */
         struct kvm_fpureg {
                 __u64 val64[4];
         } fpr[32];
};

Regards
Bibo Mao
> 
> Huacai
> 
>> +               if (!kvm_guest_has_lbt(&vcpu->arch))
>> +                       return -ENXIO;
>> +
>> +               switch (reg->id) {
>> +               case KVM_REG_LOONGARCH_LBT_SCR0:
>> +                       *v = vcpu->arch.lbt.scr0;
>> +                       break;
>> +               case KVM_REG_LOONGARCH_LBT_SCR1:
>> +                       *v = vcpu->arch.lbt.scr1;
>> +                       break;
>> +               case KVM_REG_LOONGARCH_LBT_SCR2:
>> +                       *v = vcpu->arch.lbt.scr2;
>> +                       break;
>> +               case KVM_REG_LOONGARCH_LBT_SCR3:
>> +                       *v = vcpu->arch.lbt.scr3;
>> +                       break;
>> +               case KVM_REG_LOONGARCH_LBT_EFLAGS:
>> +                       *v = vcpu->arch.lbt.eflags;
>> +                       break;
>> +               case KVM_REG_LOONGARCH_LBT_FTOP:
>> +                       *v = vcpu->arch.fpu.ftop;
>> +                       break;
>> +               default:
>> +                       ret = -EINVAL;
>> +                       break;
>> +               }
>> +               break;
>>          default:
>>                  ret = -EINVAL;
>>                  break;
>> @@ -663,6 +691,34 @@ static int kvm_set_one_reg(struct kvm_vcpu *vcpu,
>>                          break;
>>                  }
>>                  break;
>> +       case KVM_REG_LOONGARCH_LBT:
>> +               if (!kvm_guest_has_lbt(&vcpu->arch))
>> +                       return -ENXIO;
>> +
>> +               switch (reg->id) {
>> +               case KVM_REG_LOONGARCH_LBT_SCR0:
>> +                       vcpu->arch.lbt.scr0 = v;
>> +                       break;
>> +               case KVM_REG_LOONGARCH_LBT_SCR1:
>> +                       vcpu->arch.lbt.scr1 = v;
>> +                       break;
>> +               case KVM_REG_LOONGARCH_LBT_SCR2:
>> +                       vcpu->arch.lbt.scr2 = v;
>> +                       break;
>> +               case KVM_REG_LOONGARCH_LBT_SCR3:
>> +                       vcpu->arch.lbt.scr3 = v;
>> +                       break;
>> +               case KVM_REG_LOONGARCH_LBT_EFLAGS:
>> +                       vcpu->arch.lbt.eflags = v;
>> +                       break;
>> +               case KVM_REG_LOONGARCH_LBT_FTOP:
>> +                       vcpu->arch.fpu.ftop = v;
>> +                       break;
>> +               default:
>> +                       ret = -EINVAL;
>> +                       break;
>> +               }
>> +               break;
>>          default:
>>                  ret = -EINVAL;
>>                  break;
>> --
>> 2.39.3
>>


