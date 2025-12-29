Return-Path: <kvm+bounces-66758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A427DCE5B96
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 02:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9093730019FF
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 01:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C4BF2571BE;
	Mon, 29 Dec 2025 01:56:57 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC6B17C21C;
	Mon, 29 Dec 2025 01:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766973416; cv=none; b=l+3LfifHJMBaCZ76yk9Vuve3WqNrRsGvF61G5eQftpXFBI9fJkBEXPp555ytab0x63uN5hqxqJG8u2Bhpd5K3sZ+KFFxPECYjNqAtWCkv1vLSAMgnAvfl0mb4kEn0fa3P74U8gSbatkvzqx3LrBP93lomG9qyfjS9CLbjBVoQwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766973416; c=relaxed/simple;
	bh=l3WEVU/CgJG+BdtBK3zv+iEN8UKq7g5yswrtPD8gm/4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KL+yB1dnYqxE9zxwo0MAcSHgtlr5Ae2+x49Eaw+68/AqHJwJYxLAb6ezqHd/vCWlGkxJVL4yat0SVXVV0IhOC4J72LQDd05YITx1GkilPUK7zfJm+JoAavjoy7rty14MPhrQGLlR5n94ERnW+a9eWK4uyUlGu4O384SKrg+g44k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.126])
	by gateway (Coremail) with SMTP id _____8DxHvDh31FpL_YDAA--.13078S3;
	Mon, 29 Dec 2025 09:56:49 +0800 (CST)
Received: from [10.20.42.126] (unknown [10.20.42.126])
	by front1 (Coremail) with SMTP id qMiowJCxWeDe31FpSwMGAA--.16906S3;
	Mon, 29 Dec 2025 09:56:47 +0800 (CST)
Subject: Re: [PATCH V3 2/2] LoongArch: KVM: fix "unreliable stack" issue
To: Huacai Chen <chenhuacai@kernel.org>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, stable@vger.kernel.org, WANG Xuerui
 <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Charlie Jenkins <charlie@rivosinc.com>,
 Thomas Gleixner <tglx@linutronix.de>, Tiezhu Yang <yangtiezhu@loongson.cn>,
 hejinyang@loongson.cn
References: <20251227012712.2921408-1-lixianglai@loongson.cn>
 <20251227012712.2921408-3-lixianglai@loongson.cn>
 <CAAhV-H6vxwDkBUQgY=YKnhk+3i_hW06E0UFLHK5F3VnG7tzdwA@mail.gmail.com>
From: lixianglai <lixianglai@loongson.cn>
Message-ID: <18698ea8-781e-cea0-ac1f-2f0623775fac@loongson.cn>
Date: Mon, 29 Dec 2025 09:53:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6vxwDkBUQgY=YKnhk+3i_hW06E0UFLHK5F3VnG7tzdwA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJCxWeDe31FpSwMGAA--.16906S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW3JFyUZF4xAr1kAFy8Xw4UJrc_yoWxXryrpw
	13AFs0ka1kJ3s8Zw47JFyDArZaqr4kKF1Sgrs7ArWrAw1qgr9xWFy8twsxXF9rKw18XFnY
	qFyUWr1rA3ykJagCm3ZEXasCq-sJn29KB7ZKAUJUUUUr529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Gr0_Gr1UM2kKe7AKxVWUXVWUAwAS0I0E0xvYzxvE52x082IY62kv0487Mc804VCY07AIYI
	kI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWU
	AwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMx
	k0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_
	Gr1l4IxYO2xFxVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67
	AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8I
	cVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI
	8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v2
	6r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07jepB-UUUUU=

Hi Huacai:
> Hi, Xianglai,
>
> On Sat, Dec 27, 2025 at 9:52 AM Xianglai Li <lixianglai@loongson.cn> wrote:
>> Insert the appropriate UNWIND macro definition into the kvm_exc_entry in
>> the assembly function to guide the generation of correct ORC table entries,
>> thereby solving the timeout problem of loading the livepatch-sample module
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
>>   arch/loongarch/kvm/switch.S | 28 +++++++++++++++++++---------
>>   1 file changed, 19 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
>> index 93845ce53651..a3ea9567dbe5 100644
>> --- a/arch/loongarch/kvm/switch.S
>> +++ b/arch/loongarch/kvm/switch.S
>> @@ -10,6 +10,7 @@
>>   #include <asm/loongarch.h>
>>   #include <asm/regdef.h>
>>   #include <asm/unwind_hints.h>
>> +#include <linux/kvm_types.h>
>>
>>   #define HGPR_OFFSET(x)         (PT_R0 + 8*x)
>>   #define GGPR_OFFSET(x)         (KVM_ARCH_GGPR + 8*x)
>> @@ -110,9 +111,9 @@
>>           * need to copy world switch code to DMW area.
>>           */
>>          .text
>> +       .p2align PAGE_SHIFT
>>          .cfi_sections   .debug_frame
>>   SYM_CODE_START(kvm_exc_entry)
>> -       .p2align PAGE_SHIFT
>>          UNWIND_HINT_UNDEFINED
>>          csrwr   a2,   KVM_TEMP_KS
>>          csrrd   a2,   KVM_VCPU_KS
>> @@ -170,6 +171,7 @@ SYM_CODE_START(kvm_exc_entry)
>>          /* restore per cpu register */
>>          ld.d    u0, a2, KVM_ARCH_HPERCPU
>>          addi.d  sp, sp, -PT_SIZE
>> +       UNWIND_HINT_REGS
>>
>>          /* Prepare handle exception */
>>          or      a0, s0, zero
>> @@ -200,7 +202,7 @@ ret_to_host:
>>          jr      ra
>>
>>   SYM_CODE_END(kvm_exc_entry)
>> -EXPORT_SYMBOL(kvm_exc_entry)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
> Why not use EXPORT_SYMBOL_FOR_KVM in the first patch directly?
Ok,I will put it in the first patch.

>>   /*
>>    * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
>> @@ -215,6 +217,14 @@ SYM_FUNC_START(kvm_enter_guest)
>>          /* Save host GPRs */
>>          kvm_save_host_gpr a2
>>
>> +       /*
>> +        * The csr_era member variable of the pt_regs structure is required
>> +        * for unwinding orc to perform stack traceback, so we need to put
>> +        * pc into csr_era member variable here.
>> +        */
>> +       pcaddi  t0, 0
>> +       st.d    t0, a2, PT_ERA
> I am still confused here, does this overwrite PT_ERA stored by
> kvm_save_host_gpr?

No, kvm_save_host_gpr does not overwrite PT_ERA. In fact,
  it is precisely because PT_ERA is not assigned a value that we need to 
add these lines of statements here.

Now the a2 register points to the structure pt_regs. Here, we are 
assigning a value to the pt_regs.csr_era member variable.
Then the function unwind_next_frame uses the pt_regs.csr_era member 
variable as a pc to do the stack traceback.

Thanks,
Xianglai.

> Huacai
>
>> +
>>          addi.d  a2, a1, KVM_VCPU_ARCH
>>          st.d    sp, a2, KVM_ARCH_HSP
>>          st.d    tp, a2, KVM_ARCH_HTP
>> @@ -225,7 +235,7 @@ SYM_FUNC_START(kvm_enter_guest)
>>          csrwr   a1, KVM_VCPU_KS
>>          kvm_switch_to_guest
>>   SYM_FUNC_END(kvm_enter_guest)
>> -EXPORT_SYMBOL(kvm_enter_guest)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_enter_guest)
>>
>>   SYM_FUNC_START(kvm_save_fpu)
>>          fpu_save_csr    a0 t1
>> @@ -233,7 +243,7 @@ SYM_FUNC_START(kvm_save_fpu)
>>          fpu_save_cc     a0 t1 t2
>>          jr              ra
>>   SYM_FUNC_END(kvm_save_fpu)
>> -EXPORT_SYMBOL(kvm_save_fpu)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_save_fpu)
>>
>>   SYM_FUNC_START(kvm_restore_fpu)
>>          fpu_restore_double a0 t1
>> @@ -241,7 +251,7 @@ SYM_FUNC_START(kvm_restore_fpu)
>>          fpu_restore_cc     a0 t1 t2
>>          jr                 ra
>>   SYM_FUNC_END(kvm_restore_fpu)
>> -EXPORT_SYMBOL(kvm_restore_fpu)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_restore_fpu)
>>
>>   #ifdef CONFIG_CPU_HAS_LSX
>>   SYM_FUNC_START(kvm_save_lsx)
>> @@ -250,7 +260,7 @@ SYM_FUNC_START(kvm_save_lsx)
>>          lsx_save_data   a0 t1
>>          jr              ra
>>   SYM_FUNC_END(kvm_save_lsx)
>> -EXPORT_SYMBOL(kvm_save_lsx)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_save_lsx)
>>
>>   SYM_FUNC_START(kvm_restore_lsx)
>>          lsx_restore_data a0 t1
>> @@ -258,7 +268,7 @@ SYM_FUNC_START(kvm_restore_lsx)
>>          fpu_restore_csr  a0 t1 t2
>>          jr               ra
>>   SYM_FUNC_END(kvm_restore_lsx)
>> -EXPORT_SYMBOL(kvm_restore_lsx)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_restore_lsx)
>>   #endif
>>
>>   #ifdef CONFIG_CPU_HAS_LASX
>> @@ -268,7 +278,7 @@ SYM_FUNC_START(kvm_save_lasx)
>>          lasx_save_data  a0 t1
>>          jr              ra
>>   SYM_FUNC_END(kvm_save_lasx)
>> -EXPORT_SYMBOL(kvm_save_lasx)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_save_lasx)
>>
>>   SYM_FUNC_START(kvm_restore_lasx)
>>          lasx_restore_data a0 t1
>> @@ -276,7 +286,7 @@ SYM_FUNC_START(kvm_restore_lasx)
>>          fpu_restore_csr   a0 t1 t2
>>          jr                ra
>>   SYM_FUNC_END(kvm_restore_lasx)
>> -EXPORT_SYMBOL(kvm_restore_lasx)
>> +EXPORT_SYMBOL_FOR_KVM(kvm_restore_lasx)
>>   #endif
>>
>>   #ifdef CONFIG_CPU_HAS_LBT
>> --
>> 2.39.1
>>


