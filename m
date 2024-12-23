Return-Path: <kvm+bounces-34336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C9919FABAC
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 09:55:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 09D7F164B32
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 08:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06F9B191F85;
	Mon, 23 Dec 2024 08:54:53 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757D818A6B5;
	Mon, 23 Dec 2024 08:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734944092; cv=none; b=qygCSzhpwQwRcFmpnOvUPzlTttJ4Mo+oBqcXnIfHZoEKla+Aah5EhxCGBc3oRLbm55J3GN7Ikqm7GM++w5QuTMhW2gddjD/yJTtuQgQPmaxf6szEwXPV/yv3UMAMMm3LCfJV3MuwDT88jkG3ilEHmJWKdTA3tDsAeCTqj5wGOS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734944092; c=relaxed/simple;
	bh=0djsH7jwFTBJOJk5SlPctnVRn6UhjqpAnSRNx+MCTm4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=msZqpEfPHBdiRVMTUS7R2kF00Ms/M1YLczCW1NzercX2Yri3VJuzBNpetC/27wbaxfV5sK79fnJ28GyiDV4caeQ1m/nGHIfdepvnuzz1/Pvb8ruzTdQQrCLggH2N8i93MV6+tQyD5nNO2JHkj6lB3Bz2f3Dou5t8ViYX3z9KDEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxyuFTJWlnPLBZAA--.47742S3;
	Mon, 23 Dec 2024 16:54:44 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowMCxYMZQJWlnrpwGAA--.36362S3;
	Mon, 23 Dec 2024 16:54:42 +0800 (CST)
Subject: Re: [PATCH] LoongArch: KVM: Add hypercall service support for
 usermode VMM
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>,
 kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20241223084212.34822-1-maobibo@loongson.cn>
 <CAAhV-H73CaNYFtgDfM+SOXYmwUhzr1w7JC4D+t2aASyUBxxTrA@mail.gmail.com>
From: bibo mao <maobibo@loongson.cn>
Message-ID: <d186408c-f083-2404-de60-2ec3c8b528cf@loongson.cn>
Date: Mon, 23 Dec 2024 16:53:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H73CaNYFtgDfM+SOXYmwUhzr1w7JC4D+t2aASyUBxxTrA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowMCxYMZQJWlnrpwGAA--.36362S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3Aw18XFyDJw1xGr13Aw47Awc_yoW7XryfpF
	yvyF4kGrW5Kr4fC3savrnI9ryUWw4kKr1Iga42kFWakF4avwn5Ar48Kr98CFy5Ja18XF1I
	gF9agw15ZF17t3cCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
	6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU88Ma5UUUUU==



On 2024/12/23 下午4:50, Huacai Chen wrote:
> Hi, Bibo,
> 
> Is this patch trying to do the same thing as "LoongArch: add hypcall
> to emulate syscall in kvm" in 4.19?
yes, it is to do so -:)

Regards
Bibo Mao
> 
> Huacai
> 
> On Mon, Dec 23, 2024 at 4:42 PM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>> Some VMMs provides special hypercall service in usermode, KVM need
>> not handle the usermode hypercall service and pass it to VMM and
>> let VMM handle it.
>>
>> Here new code KVM_HCALL_CODE_USER is added for user-mode hypercall
>> service, KVM loads all six registers to VMM.
>>
>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>> ---
>>   arch/loongarch/include/asm/kvm_host.h      |  1 +
>>   arch/loongarch/include/asm/kvm_para.h      |  2 ++
>>   arch/loongarch/include/uapi/asm/kvm_para.h |  1 +
>>   arch/loongarch/kvm/exit.c                  | 22 ++++++++++++++++++++++
>>   arch/loongarch/kvm/vcpu.c                  |  3 +++
>>   5 files changed, 29 insertions(+)
>>
>> diff --git a/arch/loongarch/include/asm/kvm_host.h b/arch/loongarch/include/asm/kvm_host.h
>> index 7b8367c39da8..590982cd986e 100644
>> --- a/arch/loongarch/include/asm/kvm_host.h
>> +++ b/arch/loongarch/include/asm/kvm_host.h
>> @@ -162,6 +162,7 @@ enum emulation_result {
>>   #define LOONGARCH_PV_FEAT_UPDATED      BIT_ULL(63)
>>   #define LOONGARCH_PV_FEAT_MASK         (BIT(KVM_FEATURE_IPI) |         \
>>                                           BIT(KVM_FEATURE_STEAL_TIME) |  \
>> +                                        BIT(KVM_FEATURE_USER_HCALL) |  \
>>                                           BIT(KVM_FEATURE_VIRT_EXTIOI))
>>
>>   struct kvm_vcpu_arch {
>> diff --git a/arch/loongarch/include/asm/kvm_para.h b/arch/loongarch/include/asm/kvm_para.h
>> index c4e84227280d..d3c00de484f6 100644
>> --- a/arch/loongarch/include/asm/kvm_para.h
>> +++ b/arch/loongarch/include/asm/kvm_para.h
>> @@ -13,12 +13,14 @@
>>
>>   #define KVM_HCALL_CODE_SERVICE         0
>>   #define KVM_HCALL_CODE_SWDBG           1
>> +#define KVM_HCALL_CODE_USER            2
>>
>>   #define KVM_HCALL_SERVICE              HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SERVICE)
>>   #define  KVM_HCALL_FUNC_IPI            1
>>   #define  KVM_HCALL_FUNC_NOTIFY         2
>>
>>   #define KVM_HCALL_SWDBG                        HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_SWDBG)
>> +#define KVM_HCALL_USER_SERVICE         HYPERCALL_ENCODE(HYPERVISOR_KVM, KVM_HCALL_CODE_USER)
>>
>>   /*
>>    * LoongArch hypercall return code
>> diff --git a/arch/loongarch/include/uapi/asm/kvm_para.h b/arch/loongarch/include/uapi/asm/kvm_para.h
>> index b0604aa9b4bb..76d802ef01ce 100644
>> --- a/arch/loongarch/include/uapi/asm/kvm_para.h
>> +++ b/arch/loongarch/include/uapi/asm/kvm_para.h
>> @@ -17,5 +17,6 @@
>>   #define  KVM_FEATURE_STEAL_TIME                2
>>   /* BIT 24 - 31 are features configurable by user space vmm */
>>   #define  KVM_FEATURE_VIRT_EXTIOI       24
>> +#define  KVM_FEATURE_USER_HCALL                25
>>
>>   #endif /* _UAPI_ASM_KVM_PARA_H */
>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>> index a7893bd01e73..1a85cd4fb6a5 100644
>> --- a/arch/loongarch/kvm/exit.c
>> +++ b/arch/loongarch/kvm/exit.c
>> @@ -873,6 +873,28 @@ static int kvm_handle_hypercall(struct kvm_vcpu *vcpu)
>>                  vcpu->stat.hypercall_exits++;
>>                  kvm_handle_service(vcpu);
>>                  break;
>> +       case KVM_HCALL_USER_SERVICE:
>> +               if (!kvm_guest_has_pv_feature(vcpu, KVM_FEATURE_USER_HCALL)) {
>> +                       kvm_write_reg(vcpu, LOONGARCH_GPR_A0, KVM_HCALL_INVALID_CODE);
>> +                       break;
>> +               }
>> +
>> +               vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
>> +               vcpu->run->hypercall.nr = KVM_HCALL_USER_SERVICE;
>> +               vcpu->run->hypercall.args[0] = kvm_read_reg(vcpu, LOONGARCH_GPR_A0);
>> +               vcpu->run->hypercall.args[1] = kvm_read_reg(vcpu, LOONGARCH_GPR_A1);
>> +               vcpu->run->hypercall.args[2] = kvm_read_reg(vcpu, LOONGARCH_GPR_A2);
>> +               vcpu->run->hypercall.args[3] = kvm_read_reg(vcpu, LOONGARCH_GPR_A3);
>> +               vcpu->run->hypercall.args[4] = kvm_read_reg(vcpu, LOONGARCH_GPR_A4);
>> +               vcpu->run->hypercall.args[5] = kvm_read_reg(vcpu, LOONGARCH_GPR_A5);
>> +               vcpu->run->hypercall.flags = 0;
>> +               /*
>> +                * Set invalid return value by default
>> +                * Need user-mode VMM modify it
>> +                */
>> +               vcpu->run->hypercall.ret = KVM_HCALL_INVALID_CODE;
>> +               ret = RESUME_HOST;
>> +               break;
>>          case KVM_HCALL_SWDBG:
>>                  /* KVM_HCALL_SWDBG only in effective when SW_BP is enabled */
>>                  if (vcpu->guest_debug & KVM_GUESTDBG_SW_BP_MASK) {
>> diff --git a/arch/loongarch/kvm/vcpu.c b/arch/loongarch/kvm/vcpu.c
>> index d18a4a270415..8c46ad1872ee 100644
>> --- a/arch/loongarch/kvm/vcpu.c
>> +++ b/arch/loongarch/kvm/vcpu.c
>> @@ -1735,6 +1735,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>          if (run->exit_reason == KVM_EXIT_LOONGARCH_IOCSR) {
>>                  if (!run->iocsr_io.is_write)
>>                          kvm_complete_iocsr_read(vcpu, run);
>> +       } else if (run->exit_reason == KVM_EXIT_HYPERCALL) {
>> +               kvm_write_reg(vcpu, LOONGARCH_GPR_A0, run->hypercall.ret);
>> +               update_pc(&vcpu->arch);
>>          }
>>
>>          if (!vcpu->wants_to_run)
>>
>> base-commit: 48f506ad0b683d3e7e794efa60c5785c4fdc86fa
>> --
>> 2.39.3
>>


