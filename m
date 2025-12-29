Return-Path: <kvm+bounces-66760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 944D5CE5E5A
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 04:57:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5FBC0300B9A4
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 03:56:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B852749E0;
	Mon, 29 Dec 2025 03:56:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73EB91F1315;
	Mon, 29 Dec 2025 03:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766980614; cv=none; b=pPRjcThKuvFPNmrJgjG7g/3yU7bnuqdaIFF8x3uzcruYCbUUSBByBC/be9BqmpxprBRyQtz5m8h/Ft7SQApI0C6OqFHhwVufK90B9PvPOChpIdQC44pyKgWKcJCEkm0mgROWnWq5seOMFi3XeCUP1AuqtyodFaOUr/kmo9X/Jc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766980614; c=relaxed/simple;
	bh=auME+iOUeBLbnYL2aNtxKWeY0Dek3Zio5HMa2rdq8bc=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=IZ0wLbSlGAW0ou76AZo2Moe4WtDktp2TVuG3G2Oke+mVeXkbzeR4EQZDsXnoikrdNMJIiJPPJYxE1eCFyjKRXu746+XcifiNwfM/hK+PNYVuhDEPik5mvL59fcLppcOUzYs8nb9lSXsDv6OsoCbW2JBY7aSXuf91pupknnc8euE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.126])
	by gateway (Coremail) with SMTP id _____8DxPMP_+1FpzPsDAA--.12339S3;
	Mon, 29 Dec 2025 11:56:47 +0800 (CST)
Received: from [10.20.42.126] (unknown [10.20.42.126])
	by front1 (Coremail) with SMTP id qMiowJCxPML5+1FpyQ0GAA--.14067S3;
	Mon, 29 Dec 2025 11:56:43 +0800 (CST)
Subject: Re: [PATCH V3 2/2] LoongArch: KVM: fix "unreliable stack" issue
To: Jinyang He <hejinyang@loongson.cn>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: stable@vger.kernel.org, Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Charlie Jenkins <charlie@rivosinc.com>,
 Thomas Gleixner <tglx@linutronix.de>, Tiezhu Yang <yangtiezhu@loongson.cn>
References: <20251227012712.2921408-1-lixianglai@loongson.cn>
 <20251227012712.2921408-3-lixianglai@loongson.cn>
 <08143343-cb10-9376-e7df-68ad854b9275@loongson.cn>
From: lixianglai <lixianglai@loongson.cn>
Message-ID: <9e1a8d4f-251f-f78e-01a3-5c483249fac8@loongson.cn>
Date: Mon, 29 Dec 2025 11:53:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <08143343-cb10-9376-e7df-68ad854b9275@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJCxPML5+1FpyQ0GAA--.14067S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW3JFyUZF4xAr1kAFy8Xw4UJrc_yoWDJw1Upw
	nayFs0yFWDC3s5Xw4UGFyDAryftF4kJ3WUWrn7JFyrJr1UGryYqF18Xw1q9r9rXw48JFyk
	Xa4UXrn8ZrWDJagCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwCFI7km07C267AKxVWUXVWUAwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jFE__UUUUU=

Hi Jinyang:
> On 2025-12-27 09:27, Xianglai Li wrote:
>
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
> Hi, Xianglai,
>
> It should use `SYM_CODE_START` to mark the `kvm_enter_guest` rather than
> `SYM_FUNC_START`, since the `SYM_FUNC_START` is used to mark "C-likely"
> asm functionw. 

Ok, I will use SYM_CODE_START to mark kvm_enter_guest in the next version.

> I guess the kvm_enter_guest is something like exception
> handler becuase the last instruction is "ertn". So usually it should
> mark UNWIND_HINT_REGS where can find last frame info by "$sp".
> However, all info is store to "$a2", this mark should be
>   `UNWIND_HINT sp_reg=ORC_REG_A2(???) type=UNWIND_HINT_TYPE_REGS`.
> I don't konw why save this function internal PC here by `pcaddi t0, 0`,
> and I think it is no meaning(, for exception handler, they save last PC
> by read CSR.ERA). The `kvm_enter_guest` saves registers by
> "$a2"("$sp" - PT_REGS) beyond stack ("$sp"), it is dangerous if IE
> is enable. So I wonder if there is really a stacktrace through this 
> function?
>
The stack backtracking issue in switch.S is rather complex because it 
involves the switching between cpu root-mode and guest-mode:
Real stack backtracking should be divided into two parts:
part 1:
     [<0>] kvm_enter_guest+0x38/0x11c
     [<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
     [<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
     [<0>] sys_ioctl+0x498/0xf00
     [<0>] do_syscall+0x98/0x1d0
     [<0>] handle_syscall+0xb8/0x158

part 2:
     [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
     [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
     [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
     [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
     [<0>] kvm_handle_exit+0x160/0x270 [kvm]
     [<0>] kvm_exc_entry+0x104/0x1e4


In "part 1", after executing kvm_enter_guest, the cpu switches from 
root-mode to guest-mode.
In this case, stack backtracking is indeed very rare.

In "part 2", the cpu switches from the guest-mode to the root-mode,
and most of the stack backtracking occurs during this phase.

To obtain the longest call chain, we save pc in kvm_enter_guest to 
pt_regs.csr_era,
and after restoring the sp of the root-mode cpu in kvm_exc_entry,
The ORC entry was re-established using "UNWIND_HINT_REGS",
  and then we obtained the following stack backtrace as we wanted:

     [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
     [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
     [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
     [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
     [<0>] kvm_handle_exit+0x160/0x270 [kvm]
     [<0>] kvm_exc_entry+0x104/0x1e4
     [<0>] kvm_enter_guest+0x38/0x11c
     [<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
     [<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
     [<0>] sys_ioctl+0x498/0xf00
     [<0>] do_syscall+0x98/0x1d0
     [<0>] handle_syscall+0xb8/0x158

Doing so is equivalent to ignoring the details of the cpu root-mode and 
guest-mode switching.
About what you said in the IE enable phase is dangerous,
interrupts are always off during the cpu root-mode and guest-mode 
switching in kvm_enter_guest and kvm_exc_entry.

Thanks!
Xianglai.

> Jinyang
>
>
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


