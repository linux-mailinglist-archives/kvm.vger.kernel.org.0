Return-Path: <kvm+bounces-10019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A86868799
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 04:14:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B6E4B20515
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 03:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B1921CD01;
	Tue, 27 Feb 2024 03:14:20 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECD961BF24;
	Tue, 27 Feb 2024 03:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709003659; cv=none; b=CRc5UH2abuTuSXOoFaZrBnCFM6HuJTyu03lx6KyVKcMHjHDHCjFpKMze0qGbuh/QRbQ/R8/v9KQxHlRXNuVQyppXjwO29+nEdD64726Wx59uRVuRSp2eOTIdmdG+ByWKhUs+LkFiaFTT4WNiD13qYw4+pM6rLyM2WH3nX98zLo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709003659; c=relaxed/simple;
	bh=FqzHsKV7E++1r3+f9nmRVlX6daHy9V5Kk9QPAfSJO/I=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=hNowZVp73Y47OXI3j7gROaJBVedMbG/blBdwfD/r7S1i8Lfwj1R1GJUgyYh9cN5BgZI8fq7TuR/Z+BjDzcYHI/HzMFb+CLuaQGQOvcUFhrzzuoq/ys+uwUl3yqj3uAFf53XLW1bUsPV3DgCG+NjdYq7+FLxiyQt6r41gPoYOT+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8Cx2uiAU91lhtERAA--.25850S3;
	Tue, 27 Feb 2024 11:14:08 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8Bx8OR7U91l_AhHAA--.57350S3;
	Tue, 27 Feb 2024 11:14:05 +0800 (CST)
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
To: Jiaxun Yang <jiaxun.yang@flygoat.com>, Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
 Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kvm@vger.kernel.org
References: <20240222032803.2177856-1-maobibo@loongson.cn>
 <20240222032803.2177856-4-maobibo@loongson.cn>
 <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
 <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn>
 <CAAhV-H7p114hWUVrYRfKiBX3teG8sG7xmEW-Q-QT3i+xdLqDEA@mail.gmail.com>
 <06647e4a-0027-9c9f-f3bd-cd525d37b6d8@loongson.cn>
 <85781278-f3e9-4755-8715-3b9ff714fb20@app.fastmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <0d428e30-07a8-5a91-a20c-c2469adbf613@loongson.cn>
Date: Tue, 27 Feb 2024 11:14:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <85781278-f3e9-4755-8715-3b9ff714fb20@app.fastmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8Bx8OR7U91l_AhHAA--.57350S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxKFy3Jw15CF1Duw4rXFyxZwc_yoW3ArWxpr
	W8AF1DCF48JrySyw42qw1UXrnIvr4kGr1xXry3J34UAF1DKr1xJr10kr4jkFykJw18CF10
	qF4Utry3uF1UA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUUx529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUPIb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r126r1DM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxG
	rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j5o7tUUU
	UU=



On 2024/2/27 上午4:02, Jiaxun Yang wrote:
> 
> 
> 在2024年2月26日二月 上午8:04，maobibo写道：
>> On 2024/2/26 下午2:12, Huacai Chen wrote:
>>> On Mon, Feb 26, 2024 at 10:04 AM maobibo <maobibo@loongson.cn> wrote:
>>>>
>>>>
>>>>
>>>> On 2024/2/24 下午5:13, Huacai Chen wrote:
>>>>> Hi, Bibo,
>>>>>
>>>>> On Thu, Feb 22, 2024 at 11:28 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>> Instruction cpucfg can be used to get processor features. And there
>>>>>> is trap exception when it is executed in VM mode, and also it is
>>>>>> to provide cpu features to VM. On real hardware cpucfg area 0 - 20
>>>>>> is used.  Here one specified area 0x40000000 -- 0x400000ff is used
>>>>>> for KVM hypervisor to privide PV features, and the area can be extended
>>>>>> for other hypervisors in future. This area will never be used for
>>>>>> real HW, it is only used by software.
>>>>> After reading and thinking, I find that the hypercall method which is
>>>>> used in our productive kernel is better than this cpucfg method.
>>>>> Because hypercall is more simple and straightforward, plus we don't
>>>>> worry about conflicting with the real hardware.
>>>> No, I do not think so. cpucfg is simper than hypercall, hypercall can
>>>> be in effect when system runs in guest mode. In some scenario like TCG
>>>> mode, hypercall is illegal intruction, however cpucfg can work.
>>> Nearly all architectures use hypercall except x86 for its historical
>> Only x86 support multiple hypervisors and there is multiple hypervisor
>> in x86 only. It is an advantage, not historical reason.
> 
> I do believe that all those stuff should not be exposed to guest user space
> for security reasons.
Can you add PLV checking when cpucfg 0x40000000-0x400000FF is emulated? 
if it is user mode return value is zero and it is kernel mode emulated 
value will be returned. It can avoid information leaking.

> 
> Also for different implementations of hypervisors they may have different
> PV features behavior, using hypcall to perform feature detection
> can pass more information to help us cope with hypervisor diversity.
How do different hypervisors can be detected firstly?  On x86 MSR is 
used for all hypervisors detection and on ARM64 hyperv used 
acpi_gbl_FADT and kvm use smc forcely, host mode can execute smc 
instruction without exception on ARM64.

I do not know why hypercall is better than cpucfg on LoongArch, cpucfg 
is basic intruction however hypercall is not, it is part of LVZ feature.

>>
>>> reasons. If we use CPUCFG, then the hypervisor information is
>>> unnecessarily leaked to userspace, and this may be a security issue.
>>> Meanwhile, I don't think TCG mode needs PV features.
>> Besides PV features, there is other features different with real hw such
>> as virtio device, virtual interrupt controller.
> 
> Those are *device* level information, they must be passed in firmware
> interfaces to keep processor emulation sane.
File arch/x86/hyperv/hv_apic.c can be referenced, apic features comes 
from ms_hyperv.hints and HYPERV_CPUID_ENLIGHTMENT_INFO cpuid info, not 
must be passed by firmware interface.

Regards
Bibo Mao
> 
> Thanks
> 
>>
>> Regards
>> Bibo Mao
>>
>>>
>>> I consulted with Jiaxun before, and maybe he can give some more comments.
>>>
>>>>
>>>> Extioi virtualization extension will be added later, cpucfg can be used
>>>> to get extioi features. It is unlikely that extioi driver depends on
>>>> PARA_VIRT macro if hypercall is used to get features.
>>> CPUCFG is per-core information, if we really need something about
>>> extioi, it should be in iocsr (LOONGARCH_IOCSR_FEATURES).
>>>
>>>
>>> Huacai
>>>
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>
>>>>>
>>>>> Huacai
>>>>>
>>>>>>
>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>> ---
>>>>>>     arch/loongarch/include/asm/inst.h      |  1 +
>>>>>>     arch/loongarch/include/asm/loongarch.h | 10 ++++++
>>>>>>     arch/loongarch/kvm/exit.c              | 46 +++++++++++++++++---------
>>>>>>     3 files changed, 41 insertions(+), 16 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/include/asm/inst.h
>>>>>> index d8f637f9e400..ad120f924905 100644
>>>>>> --- a/arch/loongarch/include/asm/inst.h
>>>>>> +++ b/arch/loongarch/include/asm/inst.h
>>>>>> @@ -67,6 +67,7 @@ enum reg2_op {
>>>>>>            revhd_op        = 0x11,
>>>>>>            extwh_op        = 0x16,
>>>>>>            extwb_op        = 0x17,
>>>>>> +       cpucfg_op       = 0x1b,
>>>>>>            iocsrrdb_op     = 0x19200,
>>>>>>            iocsrrdh_op     = 0x19201,
>>>>>>            iocsrrdw_op     = 0x19202,
>>>>>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
>>>>>> index 46366e783c84..a1d22e8b6f94 100644
>>>>>> --- a/arch/loongarch/include/asm/loongarch.h
>>>>>> +++ b/arch/loongarch/include/asm/loongarch.h
>>>>>> @@ -158,6 +158,16 @@
>>>>>>     #define  CPUCFG48_VFPU_CG              BIT(2)
>>>>>>     #define  CPUCFG48_RAM_CG               BIT(3)
>>>>>>
>>>>>> +/*
>>>>>> + * cpucfg index area: 0x40000000 -- 0x400000ff
>>>>>> + * SW emulation for KVM hypervirsor
>>>>>> + */
>>>>>> +#define CPUCFG_KVM_BASE                        0x40000000UL
>>>>>> +#define CPUCFG_KVM_SIZE                        0x100
>>>>>> +#define CPUCFG_KVM_SIG                 CPUCFG_KVM_BASE
>>>>>> +#define  KVM_SIGNATURE                 "KVM\0"
>>>>>> +#define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
>>>>>> +
>>>>>>     #ifndef __ASSEMBLY__
>>>>>>
>>>>>>     /* CSR */
>>>>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>>>>>> index 923bbca9bd22..6a38fd59d86d 100644
>>>>>> --- a/arch/loongarch/kvm/exit.c
>>>>>> +++ b/arch/loongarch/kvm/exit.c
>>>>>> @@ -206,10 +206,37 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
>>>>>>            return EMULATE_DONE;
>>>>>>     }
>>>>>>
>>>>>> -static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>>>>>> +static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
>>>>>>     {
>>>>>>            int rd, rj;
>>>>>>            unsigned int index;
>>>>>> +
>>>>>> +       rd = inst.reg2_format.rd;
>>>>>> +       rj = inst.reg2_format.rj;
>>>>>> +       ++vcpu->stat.cpucfg_exits;
>>>>>> +       index = vcpu->arch.gprs[rj];
>>>>>> +
>>>>>> +       /*
>>>>>> +        * By LoongArch Reference Manual 2.2.10.5
>>>>>> +        * Return value is 0 for undefined cpucfg index
>>>>>> +        */
>>>>>> +       switch (index) {
>>>>>> +       case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
>>>>>> +               vcpu->arch.gprs[rd] = vcpu->arch.cpucfg[index];
>>>>>> +               break;
>>>>>> +       case CPUCFG_KVM_SIG:
>>>>>> +               vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
>>>>>> +               break;
>>>>>> +       default:
>>>>>> +               vcpu->arch.gprs[rd] = 0;
>>>>>> +               break;
>>>>>> +       }
>>>>>> +
>>>>>> +       return EMULATE_DONE;
>>>>>> +}
>>>>>> +
>>>>>> +static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>>>>>> +{
>>>>>>            unsigned long curr_pc;
>>>>>>            larch_inst inst;
>>>>>>            enum emulation_result er = EMULATE_DONE;
>>>>>> @@ -224,21 +251,8 @@ static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>>>>>>            er = EMULATE_FAIL;
>>>>>>            switch (((inst.word >> 24) & 0xff)) {
>>>>>>            case 0x0: /* CPUCFG GSPR */
>>>>>> -               if (inst.reg2_format.opcode == 0x1B) {
>>>>>> -                       rd = inst.reg2_format.rd;
>>>>>> -                       rj = inst.reg2_format.rj;
>>>>>> -                       ++vcpu->stat.cpucfg_exits;
>>>>>> -                       index = vcpu->arch.gprs[rj];
>>>>>> -                       er = EMULATE_DONE;
>>>>>> -                       /*
>>>>>> -                        * By LoongArch Reference Manual 2.2.10.5
>>>>>> -                        * return value is 0 for undefined cpucfg index
>>>>>> -                        */
>>>>>> -                       if (index < KVM_MAX_CPUCFG_REGS)
>>>>>> -                               vcpu->arch.gprs[rd] = vcpu->arch.cpucfg[index];
>>>>>> -                       else
>>>>>> -                               vcpu->arch.gprs[rd] = 0;
>>>>>> -               }
>>>>>> +               if (inst.reg2_format.opcode == cpucfg_op)
>>>>>> +                       er = kvm_emu_cpucfg(vcpu, inst);
>>>>>>                    break;
>>>>>>            case 0x4: /* CSR{RD,WR,XCHG} GSPR */
>>>>>>                    er = kvm_handle_csr(vcpu, inst);
>>>>>> --
>>>>>> 2.39.3
>>>>>>
>>>>
>>>>
> 


