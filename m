Return-Path: <kvm+bounces-10027-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BDEB86899A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 08:09:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4CF181C217B5
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 07:09:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E23653E38;
	Tue, 27 Feb 2024 07:09:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3186553E02;
	Tue, 27 Feb 2024 07:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709017741; cv=none; b=mmr9IltrFspMtP1gjfzFpIPNdjcQ0htgpZa+TPfRaGZrNucslel53X9+fygMANoZoKjHau138O6OMI0ju+fm++KJhmng/uVv7WvMjUrRHZsqkduQrSk4NOJ09IlapuxSmIya8x3tjVVCKSdVdzo34dJi7iXVuFVCTiRoenOVk7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709017741; c=relaxed/simple;
	bh=tZglC7d8hBqUGbzIh2ATwwNtFTM7TeSlFuGICt6EA04=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PMSHJb8mE1YVA6GiFUWsK9fKT1aBzT52GAtlnbT3aywxCjhAof8tt+Fncs4x1XiY9JsRc30dMWpw8vgFfi3zuEvoaKvVlLGns4b67u7qjs51djpszBQZSq2iov/4bT3Prc0hisqhxph4qBxg4W/5LPoROm5fpYhLJ8mLNpmDgBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.173])
	by gateway (Coremail) with SMTP id _____8BxnuuGit1lQdoRAA--.44900S3;
	Tue, 27 Feb 2024 15:08:54 +0800 (CST)
Received: from [10.20.42.173] (unknown [10.20.42.173])
	by localhost.localdomain (Coremail) with SMTP id AQAAf8BxVMyDit1lv2tHAA--.61830S3;
	Tue, 27 Feb 2024 15:08:51 +0800 (CST)
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
 <0d428e30-07a8-5a91-a20c-c2469adbf613@loongson.cn>
 <09c5af9b-cc79-4cf2-84f7-276bb188754a@app.fastmail.com>
From: maobibo <maobibo@loongson.cn>
Message-ID: <fc05cf09-bf53-158a-3cc9-eff6f06a220a@loongson.cn>
Date: Tue, 27 Feb 2024 15:09:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <09c5af9b-cc79-4cf2-84f7-276bb188754a@app.fastmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAf8BxVMyDit1lv2tHAA--.61830S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoW3ArWUCr43GrW8Zw43tFyDtwc_yoWftFy3pF
	WUAF1UGr48Jr1xAw1jqw1UXrnxtr4kGr1xXry5Jw1UAr1Dtr1xJr18Kr4jkFykJw18CF10
	qF1UJry3uF1UA3gCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUB2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07
	AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	AVWUtwAv7VC2z280aVAFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI4
	8JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_
	Jr0_Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
	14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU466zUUUUU



On 2024/2/27 下午1:23, Jiaxun Yang wrote:
> 
> 
> 在2024年2月27日二月 上午3:14，maobibo写道：
>> On 2024/2/27 上午4:02, Jiaxun Yang wrote:
>>>
>>>
>>> 在2024年2月26日二月 上午8:04，maobibo写道：
>>>> On 2024/2/26 下午2:12, Huacai Chen wrote:
>>>>> On Mon, Feb 26, 2024 at 10:04 AM maobibo <maobibo@loongson.cn> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2024/2/24 下午5:13, Huacai Chen wrote:
>>>>>>> Hi, Bibo,
>>>>>>>
>>>>>>> On Thu, Feb 22, 2024 at 11:28 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>>>>>
>>>>>>>> Instruction cpucfg can be used to get processor features. And there
>>>>>>>> is trap exception when it is executed in VM mode, and also it is
>>>>>>>> to provide cpu features to VM. On real hardware cpucfg area 0 - 20
>>>>>>>> is used.  Here one specified area 0x40000000 -- 0x400000ff is used
>>>>>>>> for KVM hypervisor to privide PV features, and the area can be extended
>>>>>>>> for other hypervisors in future. This area will never be used for
>>>>>>>> real HW, it is only used by software.
>>>>>>> After reading and thinking, I find that the hypercall method which is
>>>>>>> used in our productive kernel is better than this cpucfg method.
>>>>>>> Because hypercall is more simple and straightforward, plus we don't
>>>>>>> worry about conflicting with the real hardware.
>>>>>> No, I do not think so. cpucfg is simper than hypercall, hypercall can
>>>>>> be in effect when system runs in guest mode. In some scenario like TCG
>>>>>> mode, hypercall is illegal intruction, however cpucfg can work.
>>>>> Nearly all architectures use hypercall except x86 for its historical
>>>> Only x86 support multiple hypervisors and there is multiple hypervisor
>>>> in x86 only. It is an advantage, not historical reason.
>>>
>>> I do believe that all those stuff should not be exposed to guest user space
>>> for security reasons.
>> Can you add PLV checking when cpucfg 0x40000000-0x400000FF is emulated?
>> if it is user mode return value is zero and it is kernel mode emulated
>> value will be returned. It can avoid information leaking.
> 
> Please don’t do insane stuff here, applications are not expecting exception from
> cpucfg.
Sorry, I do not understand. Can you describe the behavior about cpucfg 
instruction from applications? Why is there no exception for cpucfg.
> 
>>
>>>
>>> Also for different implementations of hypervisors they may have different
>>> PV features behavior, using hypcall to perform feature detection
>>> can pass more information to help us cope with hypervisor diversity.
>> How do different hypervisors can be detected firstly?  On x86 MSR is
>> used for all hypervisors detection and on ARM64 hyperv used
>> acpi_gbl_FADT and kvm use smc forcely, host mode can execute smc
>> instruction without exception on ARM64.
> 
> That’s hypcall ABI design choices, those information can come from firmware
> or privileged CSRs on LoongArch.
Firstly the firmware or privileged CSRs is not relative with hypcall ABI 
design choices.  With CSR instruction, CSR ID is encoded in CSR 
instruction, range about CSR ID is 16K; for cpucfg instruction, cpucfg 
area is passed with register, range is UINT_MAX at least.

It is difficult to find an area unused by HW for CSR method since the 
small CSR ID range. However it is easy for cpucfg. Here I doubt whether 
you really know about LoongArch LVZ.

> 
>>
>> I do not know why hypercall is better than cpucfg on LoongArch, cpucfg
>> is basic intruction however hypercall is not, it is part of LVZ feature.
> 
> KVM can only work with LVZ right?
Linux kernel need boot well with TCG and KVM mode, hypercall is illegal 
instruction with TCG mode.

Regards
Bibo Mao
> 
>>
>>>>
>>>>> reasons. If we use CPUCFG, then the hypervisor information is
>>>>> unnecessarily leaked to userspace, and this may be a security issue.
>>>>> Meanwhile, I don't think TCG mode needs PV features.
>>>> Besides PV features, there is other features different with real hw such
>>>> as virtio device, virtual interrupt controller.
>>>
>>> Those are *device* level information, they must be passed in firmware
>>> interfaces to keep processor emulation sane.
>> File arch/x86/hyperv/hv_apic.c can be referenced, apic features comes
>> from ms_hyperv.hints and HYPERV_CPUID_ENLIGHTMENT_INFO cpuid info, not
>> must be passed by firmware interface.
> 
> That’s not KVM, that’s Hyper V. At Linux Kernel we enjoy the benefits of better
> modularity on device abstractions, please don’t break it.
> 
> Thanks
> 
>>
>> Regards
>> Bibo Mao
>>>
>>> Thanks
>>>
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>
>>>>>
>>>>> I consulted with Jiaxun before, and maybe he can give some more comments.
>>>>>
>>>>>>
>>>>>> Extioi virtualization extension will be added later, cpucfg can be used
>>>>>> to get extioi features. It is unlikely that extioi driver depends on
>>>>>> PARA_VIRT macro if hypercall is used to get features.
>>>>> CPUCFG is per-core information, if we really need something about
>>>>> extioi, it should be in iocsr (LOONGARCH_IOCSR_FEATURES).
>>>>>
>>>>>
>>>>> Huacai
>>>>>
>>>>>>
>>>>>> Regards
>>>>>> Bibo Mao
>>>>>>
>>>>>>>
>>>>>>> Huacai
>>>>>>>
>>>>>>>>
>>>>>>>> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
>>>>>>>> ---
>>>>>>>>      arch/loongarch/include/asm/inst.h      |  1 +
>>>>>>>>      arch/loongarch/include/asm/loongarch.h | 10 ++++++
>>>>>>>>      arch/loongarch/kvm/exit.c              | 46 +++++++++++++++++---------
>>>>>>>>      3 files changed, 41 insertions(+), 16 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/loongarch/include/asm/inst.h b/arch/loongarch/include/asm/inst.h
>>>>>>>> index d8f637f9e400..ad120f924905 100644
>>>>>>>> --- a/arch/loongarch/include/asm/inst.h
>>>>>>>> +++ b/arch/loongarch/include/asm/inst.h
>>>>>>>> @@ -67,6 +67,7 @@ enum reg2_op {
>>>>>>>>             revhd_op        = 0x11,
>>>>>>>>             extwh_op        = 0x16,
>>>>>>>>             extwb_op        = 0x17,
>>>>>>>> +       cpucfg_op       = 0x1b,
>>>>>>>>             iocsrrdb_op     = 0x19200,
>>>>>>>>             iocsrrdh_op     = 0x19201,
>>>>>>>>             iocsrrdw_op     = 0x19202,
>>>>>>>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
>>>>>>>> index 46366e783c84..a1d22e8b6f94 100644
>>>>>>>> --- a/arch/loongarch/include/asm/loongarch.h
>>>>>>>> +++ b/arch/loongarch/include/asm/loongarch.h
>>>>>>>> @@ -158,6 +158,16 @@
>>>>>>>>      #define  CPUCFG48_VFPU_CG              BIT(2)
>>>>>>>>      #define  CPUCFG48_RAM_CG               BIT(3)
>>>>>>>>
>>>>>>>> +/*
>>>>>>>> + * cpucfg index area: 0x40000000 -- 0x400000ff
>>>>>>>> + * SW emulation for KVM hypervirsor
>>>>>>>> + */
>>>>>>>> +#define CPUCFG_KVM_BASE                        0x40000000UL
>>>>>>>> +#define CPUCFG_KVM_SIZE                        0x100
>>>>>>>> +#define CPUCFG_KVM_SIG                 CPUCFG_KVM_BASE
>>>>>>>> +#define  KVM_SIGNATURE                 "KVM\0"
>>>>>>>> +#define CPUCFG_KVM_FEATURE             (CPUCFG_KVM_BASE + 4)
>>>>>>>> +
>>>>>>>>      #ifndef __ASSEMBLY__
>>>>>>>>
>>>>>>>>      /* CSR */
>>>>>>>> diff --git a/arch/loongarch/kvm/exit.c b/arch/loongarch/kvm/exit.c
>>>>>>>> index 923bbca9bd22..6a38fd59d86d 100644
>>>>>>>> --- a/arch/loongarch/kvm/exit.c
>>>>>>>> +++ b/arch/loongarch/kvm/exit.c
>>>>>>>> @@ -206,10 +206,37 @@ int kvm_emu_idle(struct kvm_vcpu *vcpu)
>>>>>>>>             return EMULATE_DONE;
>>>>>>>>      }
>>>>>>>>
>>>>>>>> -static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>>>>>>>> +static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
>>>>>>>>      {
>>>>>>>>             int rd, rj;
>>>>>>>>             unsigned int index;
>>>>>>>> +
>>>>>>>> +       rd = inst.reg2_format.rd;
>>>>>>>> +       rj = inst.reg2_format.rj;
>>>>>>>> +       ++vcpu->stat.cpucfg_exits;
>>>>>>>> +       index = vcpu->arch.gprs[rj];
>>>>>>>> +
>>>>>>>> +       /*
>>>>>>>> +        * By LoongArch Reference Manual 2.2.10.5
>>>>>>>> +        * Return value is 0 for undefined cpucfg index
>>>>>>>> +        */
>>>>>>>> +       switch (index) {
>>>>>>>> +       case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
>>>>>>>> +               vcpu->arch.gprs[rd] = vcpu->arch.cpucfg[index];
>>>>>>>> +               break;
>>>>>>>> +       case CPUCFG_KVM_SIG:
>>>>>>>> +               vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
>>>>>>>> +               break;
>>>>>>>> +       default:
>>>>>>>> +               vcpu->arch.gprs[rd] = 0;
>>>>>>>> +               break;
>>>>>>>> +       }
>>>>>>>> +
>>>>>>>> +       return EMULATE_DONE;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>>>>>>>> +{
>>>>>>>>             unsigned long curr_pc;
>>>>>>>>             larch_inst inst;
>>>>>>>>             enum emulation_result er = EMULATE_DONE;
>>>>>>>> @@ -224,21 +251,8 @@ static int kvm_trap_handle_gspr(struct kvm_vcpu *vcpu)
>>>>>>>>             er = EMULATE_FAIL;
>>>>>>>>             switch (((inst.word >> 24) & 0xff)) {
>>>>>>>>             case 0x0: /* CPUCFG GSPR */
>>>>>>>> -               if (inst.reg2_format.opcode == 0x1B) {
>>>>>>>> -                       rd = inst.reg2_format.rd;
>>>>>>>> -                       rj = inst.reg2_format.rj;
>>>>>>>> -                       ++vcpu->stat.cpucfg_exits;
>>>>>>>> -                       index = vcpu->arch.gprs[rj];
>>>>>>>> -                       er = EMULATE_DONE;
>>>>>>>> -                       /*
>>>>>>>> -                        * By LoongArch Reference Manual 2.2.10.5
>>>>>>>> -                        * return value is 0 for undefined cpucfg index
>>>>>>>> -                        */
>>>>>>>> -                       if (index < KVM_MAX_CPUCFG_REGS)
>>>>>>>> -                               vcpu->arch.gprs[rd] = vcpu->arch.cpucfg[index];
>>>>>>>> -                       else
>>>>>>>> -                               vcpu->arch.gprs[rd] = 0;
>>>>>>>> -               }
>>>>>>>> +               if (inst.reg2_format.opcode == cpucfg_op)
>>>>>>>> +                       er = kvm_emu_cpucfg(vcpu, inst);
>>>>>>>>                     break;
>>>>>>>>             case 0x4: /* CSR{RD,WR,XCHG} GSPR */
>>>>>>>>                     er = kvm_handle_csr(vcpu, inst);
>>>>>>>> --
>>>>>>>> 2.39.3
>>>>>>>>
>>>>>>
>>>>>>
>>>
> 


