Return-Path: <kvm+bounces-66893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B636CEAFC2
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 02:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C8B1E301A72B
	for <lists+kvm@lfdr.de>; Wed, 31 Dec 2025 01:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A5A31F130B;
	Wed, 31 Dec 2025 01:14:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF3341A2392;
	Wed, 31 Dec 2025 01:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767143697; cv=none; b=BrKFBlPo0O+ZQZFWVfKFo4YGeYGkdBByntNo5NxqAkHTEgB+0eBOwMlXGIkGDtrlBQafAiNU/qCP4TkA2jKagnHrkeuXsYbhRavkwWlwXts7ek0yyjcZDU62Fq3T5IsAM3EQ6nxNFgiYi4gLREf+BNdWnbNQ1uveVL1NZKY2mos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767143697; c=relaxed/simple;
	bh=ZV1ZWXso45FXh2ISWY0xpY7LIrC5943/+WBvhvx3Bzs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TqJpilxqVtRvSYUSa133aJaMT5fGhtvHmctMJ4sY+jPWDUmNu/eEGLt9Q8lofVSnsrXVS0Ow56GLpfLDlfsfVwEQhkry/iRjtHT0BL4KNewv5KX81lp55gj7Sb5HV9BZ6/K2lSJVHmQfL0tdQ+uj6VHMW6sfinhbgmDaOr2Xez0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.126])
	by gateway (Coremail) with SMTP id _____8Cx68IKeVRp4YwEAA--.14148S3;
	Wed, 31 Dec 2025 09:14:50 +0800 (CST)
Received: from [10.20.42.126] (unknown [10.20.42.126])
	by front1 (Coremail) with SMTP id qMiowJDxaeAEeVRptmIHAA--.19189S3;
	Wed, 31 Dec 2025 09:14:47 +0800 (CST)
Subject: Re: [PATCH V3 2/2] LoongArch: KVM: fix "unreliable stack" issue
To: Bibo Mao <maobibo@loongson.cn>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: stable@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner
 <tglx@linutronix.de>, Tiezhu Yang <yangtiezhu@loongson.cn>
References: <20251227012712.2921408-1-lixianglai@loongson.cn>
 <20251227012712.2921408-3-lixianglai@loongson.cn>
 <2ab951d8-f039-af36-bfe5-afc0f2c93a9a@loongson.cn>
From: lixianglai <lixianglai@loongson.cn>
Message-ID: <6eb528bd-adc5-983a-3725-ff95cab85a72@loongson.cn>
Date: Wed, 31 Dec 2025 09:11:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <2ab951d8-f039-af36-bfe5-afc0f2c93a9a@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJDxaeAEeVRptmIHAA--.19189S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW3Gw1fKFW3AF4UKFyxKFyUurX_yoWxZFWxpw
	nYyFZ0yFWDCwn5Xr4UJF1DAryfJr4kt3W5Xr1kAFyrJr1DGryYgF18Xw1q9Fy7Xw48JFn5
	XF1UXr13ZrWUJagCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUAVWU
	twAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07j5xhLUUUUU=

Hi Bibo Mao:
>
>
> On 2025/12/27 上午9:27, Xianglai Li wrote:
>> Insert the appropriate UNWIND macro definition into the kvm_exc_entry in
>> the assembly function to guide the generation of correct ORC table 
>> entries,
>> thereby solving the timeout problem of loading the livepatch-sample 
>> module
>> on a physical machine running multiple vcpus virtual machines.
>>
>> While solving the above problems, we have gained an additional benefit,
>> that is, we can obtain more call stack information
>>
>> Stack information that can be obtained before the problem is fixed:
>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>> [<0>] kvm_exc_entry+0x100/0x1e0
>>
>> Stack information that can be obtained after the problem is fixed:
>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>> [<0>] kvm_exc_entry+0x104/0x1e4
>> [<0>] kvm_enter_guest+0x38/0x11c
>> [<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
>> [<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
>> [<0>] sys_ioctl+0x498/0xf00
>> [<0>] do_syscall+0x98/0x1d0
>> [<0>] handle_syscall+0xb8/0x158
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>> ---
>> Cc: Huacai Chen <chenhuacai@kernel.org>
>> Cc: WANG Xuerui <kernel@xen0n.name>
>> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
>> Cc: Bibo Mao <maobibo@loongson.cn>
>> Cc: Charlie Jenkins <charlie@rivosinc.com>
>> Cc: Xianglai Li <lixianglai@loongson.cn>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
>>
>>   arch/loongarch/kvm/switch.S | 28 +++++++++++++++++++---------
>>   1 file changed, 19 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
>> index 93845ce53651..a3ea9567dbe5 100644
>> --- a/arch/loongarch/kvm/switch.S
>> +++ b/arch/loongarch/kvm/switch.S
>> @@ -10,6 +10,7 @@
>>   #include <asm/loongarch.h>
>>   #include <asm/regdef.h>
>>   #include <asm/unwind_hints.h>
>> +#include <linux/kvm_types.h>
>>     #define HGPR_OFFSET(x)        (PT_R0 + 8*x)
>>   #define GGPR_OFFSET(x)        (KVM_ARCH_GGPR + 8*x)
>> @@ -110,9 +111,9 @@
>>        * need to copy world switch code to DMW area.
>>        */
>>       .text
>> +    .p2align PAGE_SHIFT
>>       .cfi_sections    .debug_frame
>>   SYM_CODE_START(kvm_exc_entry)
>> -    .p2align PAGE_SHIFT
>>       UNWIND_HINT_UNDEFINED
>>       csrwr    a2,   KVM_TEMP_KS
>>       csrrd    a2,   KVM_VCPU_KS
>> @@ -170,6 +171,7 @@ SYM_CODE_START(kvm_exc_entry)
>>       /* restore per cpu register */
>>       ld.d    u0, a2, KVM_ARCH_HPERCPU
>>       addi.d    sp, sp, -PT_SIZE
>> +    UNWIND_HINT_REGS
>>         /* Prepare handle exception */
>>       or    a0, s0, zero
>> @@ -200,7 +202,7 @@ ret_to_host:
>>       jr      ra
>>     SYM_CODE_END(kvm_exc_entry)
>> -EXPORT_SYMBOL(kvm_exc_entry)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
>>     /*
>>    * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
>> @@ -215,6 +217,14 @@ SYM_FUNC_START(kvm_enter_guest)
>>       /* Save host GPRs */
>>       kvm_save_host_gpr a2
>>   +    /*
>> +     * The csr_era member variable of the pt_regs structure is required
>> +     * for unwinding orc to perform stack traceback, so we need to put
>> +     * pc into csr_era member variable here.
>> +     */
>> +    pcaddi    t0, 0
>> +    st.d    t0, a2, PT_ERA
> maybe PRMD need be set with fake pt_regs also, something like this:
>         ori     t0, zero, CSR_PRMD_PIE
>         st.d    t0, a2, PT_PRMD
>
Ok, I will fix it in the next version

Thanks,
Xianglai.
> Regards
> Bibo Mao
>> +
>>       addi.d    a2, a1, KVM_VCPU_ARCH
>>       st.d    sp, a2, KVM_ARCH_HSP
>>       st.d    tp, a2, KVM_ARCH_HTP
>> @@ -225,7 +235,7 @@ SYM_FUNC_START(kvm_enter_guest)
>>       csrwr    a1, KVM_VCPU_KS
>>       kvm_switch_to_guest
>>   SYM_FUNC_END(kvm_enter_guest)
>> -EXPORT_SYMBOL(kvm_enter_guest)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_enter_guest)
>>     SYM_FUNC_START(kvm_save_fpu)
>>       fpu_save_csr    a0 t1
>> @@ -233,7 +243,7 @@ SYM_FUNC_START(kvm_save_fpu)
>>       fpu_save_cc    a0 t1 t2
>>       jr              ra
>>   SYM_FUNC_END(kvm_save_fpu)
>> -EXPORT_SYMBOL(kvm_save_fpu)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_save_fpu)
>>     SYM_FUNC_START(kvm_restore_fpu)
>>       fpu_restore_double a0 t1
>> @@ -241,7 +251,7 @@ SYM_FUNC_START(kvm_restore_fpu)
>>       fpu_restore_cc       a0 t1 t2
>>       jr                 ra
>>   SYM_FUNC_END(kvm_restore_fpu)
>> -EXPORT_SYMBOL(kvm_restore_fpu)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_restore_fpu)
>>     #ifdef CONFIG_CPU_HAS_LSX
>>   SYM_FUNC_START(kvm_save_lsx)
>> @@ -250,7 +260,7 @@ SYM_FUNC_START(kvm_save_lsx)
>>       lsx_save_data   a0 t1
>>       jr              ra
>>   SYM_FUNC_END(kvm_save_lsx)
>> -EXPORT_SYMBOL(kvm_save_lsx)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_save_lsx)
>>     SYM_FUNC_START(kvm_restore_lsx)
>>       lsx_restore_data a0 t1
>> @@ -258,7 +268,7 @@ SYM_FUNC_START(kvm_restore_lsx)
>>       fpu_restore_csr  a0 t1 t2
>>       jr               ra
>>   SYM_FUNC_END(kvm_restore_lsx)
>> -EXPORT_SYMBOL(kvm_restore_lsx)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_restore_lsx)
>>   #endif
>>     #ifdef CONFIG_CPU_HAS_LASX
>> @@ -268,7 +278,7 @@ SYM_FUNC_START(kvm_save_lasx)
>>       lasx_save_data  a0 t1
>>       jr              ra
>>   SYM_FUNC_END(kvm_save_lasx)
>> -EXPORT_SYMBOL(kvm_save_lasx)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_save_lasx)
>>     SYM_FUNC_START(kvm_restore_lasx)
>>       lasx_restore_data a0 t1
>> @@ -276,7 +286,7 @@ SYM_FUNC_START(kvm_restore_lasx)
>>       fpu_restore_csr   a0 t1 t2
>>       jr                ra
>>   SYM_FUNC_END(kvm_restore_lasx)
>> -EXPORT_SYMBOL(kvm_restore_lasx)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_restore_lasx)
>>   #endif
>>     #ifdef CONFIG_CPU_HAS_LBT
>>


