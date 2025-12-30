Return-Path: <kvm+bounces-66812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 189DACE88BE
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 03:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D34F930024BB
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 02:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234312DFF3F;
	Tue, 30 Dec 2025 02:26:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987BB2D8382;
	Tue, 30 Dec 2025 02:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767061610; cv=none; b=kQ2yvnKgJIPspR4nh3zLcKaVZmKeuAVlSbkWTM+WvdW0LOqjOjp5tvquJIn0bJP1XO6npLOoZpMvSSEndTCzT5PNfJMPckIMh+wNAl271LbRXjI01eeCmVdQD49TtI0AP1EIimd86MELvA5JycxKTjUOIlRmrjghY/zOlTaqxH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767061610; c=relaxed/simple;
	bh=KDsUS0PHP55vzXQFbZ5El33TwyxOwm6iICybKs++KvM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=aRNYTtzbYFu8KUlGpo09YFtRxxAn/wsmhvTELIAnSCYkGQR0ORCciPSQUbGFrfTYwmvVwDrWW1YoLRkmKpNFOQPJmBbapTWf1UpAL7NimPTrUjZhHki3007wVeiBdQHldWtBCMIfoWD1cJ3ruZPqefIDgyGWCUtMr62hLn7I/ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8CxqsJjOFNptEcEAA--.13206S3;
	Tue, 30 Dec 2025 10:26:43 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJAx38JeOFNpD4YGAA--.17424S3;
	Tue, 30 Dec 2025 10:26:41 +0800 (CST)
Subject: Re: [PATCH V3 2/2] LoongArch: KVM: fix "unreliable stack" issue
To: Jinyang He <hejinyang@loongson.cn>, lixianglai <lixianglai@loongson.cn>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, stable@vger.kernel.org,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Tianrui Zhao <zhaotianrui@loongson.cn>,
 Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner
 <tglx@linutronix.de>, Tiezhu Yang <yangtiezhu@loongson.cn>
References: <20251227012712.2921408-1-lixianglai@loongson.cn>
 <20251227012712.2921408-3-lixianglai@loongson.cn>
 <08143343-cb10-9376-e7df-68ad854b9275@loongson.cn>
 <9e1a8d4f-251f-f78e-01a3-5c483249fac8@loongson.cn>
 <dec5cb06-6858-20f2-facb-d5e7f44f5d16@loongson.cn>
 <df8f52e3-fea5-763a-d5fd-629308dc6fcc@loongson.cn>
 <a1009e1e-34de-68b4-7680-d2a99a06a71c@loongson.cn>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <efa4ef2d-aef7-0f64-07bc-55d0c4d1d6d2@loongson.cn>
Date: Tue, 30 Dec 2025 10:24:07 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a1009e1e-34de-68b4-7680-d2a99a06a71c@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJAx38JeOFNpD4YGAA--.17424S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj9fXoW3uw17GFW3Ar1DtrWxZw17twc_yoW8GFykuo
	Wq93W2yr1rtr1UKF1DJw4DtF45Jw18GrnrtryUGry3Gr18ta4UX3y8Gry7Kay5trn5Gr13
	J343X3s0yFy0yr18l-sFpf9Il3svdjkaLaAFLSUrUUUU8b8apTn2vfkv8UJUUUU8wcxFpf
	9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
	UjIYCTnIWjp_UUUYX7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
	8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26r1I6r4UM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8JVW8Jr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwCFI7km07C267AKxVWUtVW8ZwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jFE__UUUUU=



On 2025/12/29 下午6:41, Jinyang He wrote:
> On 2025-12-29 18:11, lixianglai wrote:
> 
>> Hi Jinyang:
>>>
>>> On 2025-12-29 11:53, lixianglai wrote:
>>>> Hi Jinyang:
>>>>> On 2025-12-27 09:27, Xianglai Li wrote:
>>>>>
>>>>>> Insert the appropriate UNWIND macro definition into the 
>>>>>> kvm_exc_entry in
>>>>>> the assembly function to guide the generation of correct ORC table 
>>>>>> entries,
>>>>>> thereby solving the timeout problem of loading the 
>>>>>> livepatch-sample module
>>>>>> on a physical machine running multiple vcpus virtual machines.
>>>>>>
>>>>>> While solving the above problems, we have gained an additional 
>>>>>> benefit,
>>>>>> that is, we can obtain more call stack information
>>>>>>
>>>>>> Stack information that can be obtained before the problem is fixed:
>>>>>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>>>>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>>>>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>>>>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>>>>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>>>>> [<0>] kvm_exc_entry+0x100/0x1e0
>>>>>>
>>>>>> Stack information that can be obtained after the problem is fixed:
>>>>>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>>>>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>>>>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>>>>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>>>>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>>>>> [<0>] kvm_exc_entry+0x104/0x1e4
>>>>>> [<0>] kvm_enter_guest+0x38/0x11c
>>>>>> [<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
>>>>>> [<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
>>>>>> [<0>] sys_ioctl+0x498/0xf00
>>>>>> [<0>] do_syscall+0x98/0x1d0
>>>>>> [<0>] handle_syscall+0xb8/0x158
>>>>>>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>>>>>> ---
>>>>>> Cc: Huacai Chen <chenhuacai@kernel.org>
>>>>>> Cc: WANG Xuerui <kernel@xen0n.name>
>>>>>> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
>>>>>> Cc: Bibo Mao <maobibo@loongson.cn>
>>>>>> Cc: Charlie Jenkins <charlie@rivosinc.com>
>>>>>> Cc: Xianglai Li <lixianglai@loongson.cn>
>>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>>>> Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
>>>>>>
>>>>>>   arch/loongarch/kvm/switch.S | 28 +++++++++++++++++++---------
>>>>>>   1 file changed, 19 insertions(+), 9 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/loongarch/kvm/switch.S 
>>>>>> b/arch/loongarch/kvm/switch.S
>>>>>> index 93845ce53651..a3ea9567dbe5 100644
>>>>>> --- a/arch/loongarch/kvm/switch.S
>>>>>> +++ b/arch/loongarch/kvm/switch.S
>>>>>> @@ -10,6 +10,7 @@
>>>>>>   #include <asm/loongarch.h>
>>>>>>   #include <asm/regdef.h>
>>>>>>   #include <asm/unwind_hints.h>
>>>>>> +#include <linux/kvm_types.h>
>>>>>>     #define HGPR_OFFSET(x)        (PT_R0 + 8*x)
>>>>>>   #define GGPR_OFFSET(x)        (KVM_ARCH_GGPR + 8*x)
>>>>>> @@ -110,9 +111,9 @@
>>>>>>        * need to copy world switch code to DMW area.
>>>>>>        */
>>>>>>       .text
>>>>>> +    .p2align PAGE_SHIFT
>>>>>>       .cfi_sections    .debug_frame
>>>>>>   SYM_CODE_START(kvm_exc_entry)
>>>>>> -    .p2align PAGE_SHIFT
>>>>>>       UNWIND_HINT_UNDEFINED
>>>>>>       csrwr    a2,   KVM_TEMP_KS
>>>>>>       csrrd    a2,   KVM_VCPU_KS
>>>>>> @@ -170,6 +171,7 @@ SYM_CODE_START(kvm_exc_entry)
>>>>>>       /* restore per cpu register */
>>>>>>       ld.d    u0, a2, KVM_ARCH_HPERCPU
>>>>>>       addi.d    sp, sp, -PT_SIZE
>>>>>> +    UNWIND_HINT_REGS
>>>>>>         /* Prepare handle exception */
>>>>>>       or    a0, s0, zero
>>>>>> @@ -200,7 +202,7 @@ ret_to_host:
>>>>>>       jr      ra
>>>>>>     SYM_CODE_END(kvm_exc_entry)
>>>>>> -EXPORT_SYMBOL(kvm_exc_entry)
>>>>>> +EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
>>>>>>     /*
>>>>>>    * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
>>>>>> @@ -215,6 +217,14 @@ SYM_FUNC_START(kvm_enter_guest)
>>>>>>       /* Save host GPRs */
>>>>>>       kvm_save_host_gpr a2
>>>>>>   +    /*
>>>>>> +     * The csr_era member variable of the pt_regs structure is 
>>>>>> required
>>>>>> +     * for unwinding orc to perform stack traceback, so we need 
>>>>>> to put
>>>>>> +     * pc into csr_era member variable here.
>>>>>> +     */
>>>>>> +    pcaddi    t0, 0
>>>>>> +    st.d    t0, a2, PT_ERA
>>>>> Hi, Xianglai,
>>>>>
>>>>> It should use `SYM_CODE_START` to mark the `kvm_enter_guest` rather 
>>>>> than
>>>>> `SYM_FUNC_START`, since the `SYM_FUNC_START` is used to mark 
>>>>> "C-likely"
>>>>> asm functionw. 
>>>>
>>>> Ok, I will use SYM_CODE_START to mark kvm_enter_guest in the next 
>>>> version.
>>>>
>>>>> I guess the kvm_enter_guest is something like exception
>>>>> handler becuase the last instruction is "ertn". So usually it should
>>>>> mark UNWIND_HINT_REGS where can find last frame info by "$sp".
>>>>> However, all info is store to "$a2", this mark should be
>>>>>   `UNWIND_HINT sp_reg=ORC_REG_A2(???) type=UNWIND_HINT_TYPE_REGS`.
>>>>> I don't konw why save this function internal PC here by `pcaddi t0, 
>>>>> 0`,
>>>>> and I think it is no meaning(, for exception handler, they save 
>>>>> last PC
>>>>> by read CSR.ERA). The `kvm_enter_guest` saves registers by
>>>>> "$a2"("$sp" - PT_REGS) beyond stack ("$sp"), it is dangerous if IE
>>>>> is enable. So I wonder if there is really a stacktrace through this 
>>>>> function?
>>>>>
>>>> The stack backtracking issue in switch.S is rather complex because 
>>>> it involves the switching between cpu root-mode and guest-mode:
>>>> Real stack backtracking should be divided into two parts:
>>>> part 1:
>>>>     [<0>] kvm_enter_guest+0x38/0x11c
>>>>     [<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
>>>>     [<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
>>>>     [<0>] sys_ioctl+0x498/0xf00
>>>>     [<0>] do_syscall+0x98/0x1d0
>>>>     [<0>] handle_syscall+0xb8/0x158
>>>>
>>>> part 2:
>>>>     [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>>>     [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>>>     [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>>>     [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>>>     [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>>>     [<0>] kvm_exc_entry+0x104/0x1e4
>>>>
>>>>
>>>> In "part 1", after executing kvm_enter_guest, the cpu switches from 
>>>> root-mode to guest-mode.
>>>> In this case, stack backtracking is indeed very rare.
>>>>
>>>> In "part 2", the cpu switches from the guest-mode to the root-mode,
>>>> and most of the stack backtracking occurs during this phase.
>>>>
>>>> To obtain the longest call chain, we save pc in kvm_enter_guest to 
>>>> pt_regs.csr_era,
>>>> and after restoring the sp of the root-mode cpu in kvm_exc_entry,
>>>> The ORC entry was re-established using "UNWIND_HINT_REGS",
>>>>  and then we obtained the following stack backtrace as we wanted:
>>>>
>>>>     [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>>>     [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>>>     [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>>>     [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>>>     [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>>>     [<0>] kvm_exc_entry+0x104/0x1e4
>>> I found this might be a coincidence—correct behavior due to the 
>>> incorrect
>>> UNWIND_HINT_REGS mark and unusual stack adjustment.
>>>
>>> First, the kvm_enter_guest contains only a single branch instruction, 
>>> ertn.
>>> It hardware-jump to the CSR.ERA address directly, jump into 
>>> kvm_exc_entry.
>>>
>>> At this point, the stack layout looks like this:
>>> -------------------------------
>>>   frame from call to `kvm_enter_guest`
>>> -------------------------------  <- $sp
>>>   PT_REGS
>>> -------------------------------  <- $a2
>>>
>>> Then kvm_exc_entry adjust stack without save any register (e.g. $ra, 
>>> $sp)
>>> but still marked UNWIND_HINT_REGS.
>>> After the adjustment:
>>> -------------------------------
>>>   frame from call to `kvm_enter_guest`
>>> -------------------------------
>>>   PT_REGS
>>> -------------------------------  <- $a2, new $sp
>>>
>>> During unwinding, when the unwinder reaches kvm_exc_entry,
>>> it meets the mark of PT_REGS and correctly recovers
>>>  pc = regs.csr_era, sp = regs.sp, ra = regs.ra
>>>
>> Yes, here unwinder does work as you say.
>>
>>> a) Can we avoid "ertn" rather than `jr reg (or jirl ra, reg, 0)`
>>> instead, like call?
>> No,  we need to rely on the 'ertn instruction return PIE to CRMD IE,
>> at the same time to ensure that its atomic,
>> there should be no other instruction than' ertn 'more appropriate here.
> You are right! I got it.
>>
>>> The kvm_exc_entry cannot back to kvm_enter_guest
>>> if we use "ertn", so should the kvm_enter_guest appear on the 
>>> stacktrace?
>>>
>>
>> It is flexible. As I mentioned above, the cpu completes the switch 
>> from host-mode to guest mode through kvm_enter_guest,
>> and then the switch from guest mode to host-mode through 
>> kvm_exc_entry. When we ignore the details of the host-mode
>> and guest-mode switching in the middle, we can understand that the 
>> host cpu has completed kvm_enter_guest->kvm_exc_entry.
>> From this perspective, I think it can exist in the call stack, and at 
>> the same time, we have obtained the maximum call stack information.
>>
>>
>>> b) Can we adjust $sp before entering kvm_exc_entry? Then we can mark
>>> UNWIND_HINT_REGS at the beginning of kvm_exc_entry, which something
>>> like ret_from_kernel_thread_asm.
>>>
>> The following command can be used to dump the orc entries of the kernel:
>> ./tools/objtool/objtool --dump vmlinux
>>
>> You can observe that not all orc entries are generated at the 
>> beginning of the function.
>> For example:
>> handle_tlb_protect
>> ftrace_stub
>> handle_reserved
>>
>> So, is it unnecessary for us to modify UNWIND_HINT_REGS in order to 
>> place it at the beginning of the function.
>>
>> If you have a better solution, could you provide an example of the 
>> modification?
>> I can test the feasibility of the solution.
>>
> The expression at the beginning of the function is incorrect (feeling 
> sorry).
> It should be marked where have all stacktrace info.
> Thanks for all the explaining, since I'm unfamiliar with kvm, I need 
> these to help my understanding.
> 
> Can you try with follows, with save regs by $sp, set more precise era to 
> pt_regs, and more unwind hint.
> 
> 
> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
> index f1768b7a6194..8ed1d7b72c54 100644
> --- a/arch/loongarch/kvm/switch.S
> +++ b/arch/loongarch/kvm/switch.S
> @@ -14,13 +14,13 @@
>   #define GGPR_OFFSET(x)        (KVM_ARCH_GGPR + 8*x)
> 
>   .macro kvm_save_host_gpr base
> -    .irp n,1,2,3,22,23,24,25,26,27,28,29,30,31
> +    .irp n,1,2,22,23,24,25,26,27,28,29,30,31
>       st.d    $r\n, \base, HGPR_OFFSET(\n)
>       .endr
>   .endm
> 
>   .macro kvm_restore_host_gpr base
> -    .irp n,1,2,3,22,23,24,25,26,27,28,29,30,31
> +    .irp n,1,2,22,23,24,25,26,27,28,29,30,31
>       ld.d    $r\n, \base, HGPR_OFFSET(\n)
>       .endr
>   .endm
> @@ -88,6 +88,7 @@
>       /* Load KVM_ARCH register */
>       ld.d    a2, a2,    (KVM_ARCH_GGPR + 8 * REG_A2)
> 
> +111:
>       ertn /* Switch to guest: GSTAT.PGM = 1, ERRCTL.ISERR = 0, 
> TLBRPRMD.ISTLBR = 0 */
>   .endm
> 
> @@ -158,9 +159,10 @@ SYM_CODE_START(kvm_exc_entry)
>       csrwr    t0, LOONGARCH_CSR_GTLBC
>       ld.d    tp, a2, KVM_ARCH_HTP
>       ld.d    sp, a2, KVM_ARCH_HSP
> +    UNWIND_HINT_REGS
> +
>       /* restore per cpu register */
>       ld.d    u0, a2, KVM_ARCH_HPERCPU
> -    addi.d    sp, sp, -PT_SIZE
> 
>       /* Prepare handle exception */
>       or    a0, s0, zero
> @@ -184,10 +186,11 @@ SYM_CODE_START(kvm_exc_entry)
>       csrwr    s1, KVM_VCPU_KS
>       kvm_switch_to_guest
> 
> +    UNWIND_HINT_UNDEFINED
>   ret_to_host:
> -    ld.d    a2, a2, KVM_ARCH_HSP
> -    addi.d  a2, a2, -PT_SIZE
> -    kvm_restore_host_gpr    a2
> +    ld.d    sp, a2, KVM_ARCH_HSP
> +    kvm_restore_host_gpr    sp
> +    addi.d    sp, sp, PT_SIZE
>       jr      ra
> 
>   SYM_INNER_LABEL(kvm_exc_entry_end, SYM_L_LOCAL)
> @@ -200,11 +203,15 @@ SYM_CODE_END(kvm_exc_entry)
>    *  a0: kvm_run* run
>    *  a1: kvm_vcpu* vcpu
>    */
> -SYM_FUNC_START(kvm_enter_guest)
> +SYM_CODE_START(kvm_enter_guest)
> +    UNWIND_HINT_UNDEFINED
>       /* Allocate space in stack bottom */
> -    addi.d    a2, sp, -PT_SIZE
> +    addi.d    sp, sp, -PT_SIZE
>       /* Save host GPRs */
> -    kvm_save_host_gpr a2
> +    kvm_save_host_gpr sp
> +    la.pcrel a2, 111f
> +    st.d     a2, sp, PT_ERA
> +    UNWIND_HINT_REGS
> 
why the label 111f is more accurate?  Supposing there is hw breakpoint 
here and backtrace is called, what is the call trace stack then? obvious 
label 111f is not executed instead.

UNWIND_HINT_REGS is used for nested kernel stack, is that right?
With nested interrupt and exception handlers on LoongArch kernel, is 
UNWIND_HINT_REGS used?

SYM_CODE_START(ret_from_fork_asm)
         UNWIND_HINT_REGS
         move            a1, sp
         bl              ret_from_fork
         STACKLEAK_ERASE
         RESTORE_STATIC
         RESTORE_SOME
         RESTORE_SP_AND_RET
SYM_CODE_END(ret_from_fork_asm)
With this piece of code, what is contents of pt_regs? In generic it is 
called from sys_clone, era is user PC address, is that right? If so,
what is detailed usage in the beginning of ret_from_fork_asm?

Regards
Bibo Mao

>       addi.d    a2, a1, KVM_VCPU_ARCH
>       st.d    sp, a2, KVM_ARCH_HSP
> 
> Jinyang
> 


