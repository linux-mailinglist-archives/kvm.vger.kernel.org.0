Return-Path: <kvm+bounces-66768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EA5EDCE65BB
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 11:15:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3673E300C6C9
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 10:15:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B07F2D061D;
	Mon, 29 Dec 2025 10:15:09 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45FB1275B1A;
	Mon, 29 Dec 2025 10:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767003308; cv=none; b=TXC1CYlj3Lj6R/eHlxtlesK3pkHO8CclUUkncdD1lw6Vt1rXnIpm0D9r8zlzzN8xJh7rEjIROtC9GKN+B+vmZL0lWkWAvDmDro/zFt2m4QNm/dSuDjlcjPxjJoImV+1YSQ8f22Jx7GkpZNdFJ4D4AnM5OfD0bbq2waHKsa7F0qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767003308; c=relaxed/simple;
	bh=zbJVtcfrE76Bh7J4/8DAH9uZq82n1d+mYg91k08j2xo=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=I/C5otKFqPNv0c/zvWC4bKO6mhp1O+BkSVKVk1VKPZzOayx/pYsqzP29CwMM9QUeHdTbXwQKZApn0uWtyfEPCuBcxpBo2uBwlz229ZxyL/OgRUwN9x18cTpcB9QpuJaLEzYu0XNsymJtRR7HdvWue5ybNF28ESu44Jx6846zX7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.126])
	by gateway (Coremail) with SMTP id _____8Dx+8KiVFJp1A4EAA--.12125S3;
	Mon, 29 Dec 2025 18:14:58 +0800 (CST)
Received: from [10.20.42.126] (unknown [10.20.42.126])
	by front1 (Coremail) with SMTP id qMiowJBx78KaVFJpYygGAA--.16928S3;
	Mon, 29 Dec 2025 18:14:53 +0800 (CST)
Subject: Re: [PATCH V3 2/2] LoongArch: KVM: fix "unreliable stack" issue
To: Jinyang He <hejinyang@loongson.cn>
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, stable@vger.kernel.org,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner
 <tglx@linutronix.de>, Tiezhu Yang <yangtiezhu@loongson.cn>
References: <20251227012712.2921408-1-lixianglai@loongson.cn>
 <20251227012712.2921408-3-lixianglai@loongson.cn>
 <08143343-cb10-9376-e7df-68ad854b9275@loongson.cn>
 <9e1a8d4f-251f-f78e-01a3-5c483249fac8@loongson.cn>
 <dec5cb06-6858-20f2-facb-d5e7f44f5d16@loongson.cn>
From: lixianglai <lixianglai@loongson.cn>
Message-ID: <df8f52e3-fea5-763a-d5fd-629308dc6fcc@loongson.cn>
Date: Mon, 29 Dec 2025 18:11:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <dec5cb06-6858-20f2-facb-d5e7f44f5d16@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJBx78KaVFJpYygGAA--.16928S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoW3uw1xtF1kCr4rCw1fJrykCrX_yoWDCr4rp3
	sayFZxtrWDA34kAw1UK3WDAryIq3y8G3WDWr1xXFyrAr4qvr1Ygr48Wr1v9ryDC3y0gFyj
	qFWUt3ZrZan8ArcCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
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

Hi Jinyang:
>
> On 2025-12-29 11:53, lixianglai wrote:
>> Hi Jinyang:
>>> On 2025-12-27 09:27, Xianglai Li wrote:
>>>
>>>> Insert the appropriate UNWIND macro definition into the 
>>>> kvm_exc_entry in
>>>> the assembly function to guide the generation of correct ORC table 
>>>> entries,
>>>> thereby solving the timeout problem of loading the livepatch-sample 
>>>> module
>>>> on a physical machine running multiple vcpus virtual machines.
>>>>
>>>> While solving the above problems, we have gained an additional 
>>>> benefit,
>>>> that is, we can obtain more call stack information
>>>>
>>>> Stack information that can be obtained before the problem is fixed:
>>>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>>> [<0>] kvm_exc_entry+0x100/0x1e0
>>>>
>>>> Stack information that can be obtained after the problem is fixed:
>>>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>>> [<0>] kvm_exc_entry+0x104/0x1e4
>>>> [<0>] kvm_enter_guest+0x38/0x11c
>>>> [<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
>>>> [<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
>>>> [<0>] sys_ioctl+0x498/0xf00
>>>> [<0>] do_syscall+0x98/0x1d0
>>>> [<0>] handle_syscall+0xb8/0x158
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>>>> ---
>>>> Cc: Huacai Chen <chenhuacai@kernel.org>
>>>> Cc: WANG Xuerui <kernel@xen0n.name>
>>>> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
>>>> Cc: Bibo Mao <maobibo@loongson.cn>
>>>> Cc: Charlie Jenkins <charlie@rivosinc.com>
>>>> Cc: Xianglai Li <lixianglai@loongson.cn>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
>>>>
>>>>   arch/loongarch/kvm/switch.S | 28 +++++++++++++++++++---------
>>>>   1 file changed, 19 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
>>>> index 93845ce53651..a3ea9567dbe5 100644
>>>> --- a/arch/loongarch/kvm/switch.S
>>>> +++ b/arch/loongarch/kvm/switch.S
>>>> @@ -10,6 +10,7 @@
>>>>   #include <asm/loongarch.h>
>>>>   #include <asm/regdef.h>
>>>>   #include <asm/unwind_hints.h>
>>>> +#include <linux/kvm_types.h>
>>>>     #define HGPR_OFFSET(x)        (PT_R0 + 8*x)
>>>>   #define GGPR_OFFSET(x)        (KVM_ARCH_GGPR + 8*x)
>>>> @@ -110,9 +111,9 @@
>>>>        * need to copy world switch code to DMW area.
>>>>        */
>>>>       .text
>>>> +    .p2align PAGE_SHIFT
>>>>       .cfi_sections    .debug_frame
>>>>   SYM_CODE_START(kvm_exc_entry)
>>>> -    .p2align PAGE_SHIFT
>>>>       UNWIND_HINT_UNDEFINED
>>>>       csrwr    a2,   KVM_TEMP_KS
>>>>       csrrd    a2,   KVM_VCPU_KS
>>>> @@ -170,6 +171,7 @@ SYM_CODE_START(kvm_exc_entry)
>>>>       /* restore per cpu register */
>>>>       ld.d    u0, a2, KVM_ARCH_HPERCPU
>>>>       addi.d    sp, sp, -PT_SIZE
>>>> +    UNWIND_HINT_REGS
>>>>         /* Prepare handle exception */
>>>>       or    a0, s0, zero
>>>> @@ -200,7 +202,7 @@ ret_to_host:
>>>>       jr      ra
>>>>     SYM_CODE_END(kvm_exc_entry)
>>>> -EXPORT_SYMBOL(kvm_exc_entry)
>>>> +EXPORT_SYMBOL_FOR_KVM(kvm_exc_entry)
>>>>     /*
>>>>    * int kvm_enter_guest(struct kvm_run *run, struct kvm_vcpu *vcpu)
>>>> @@ -215,6 +217,14 @@ SYM_FUNC_START(kvm_enter_guest)
>>>>       /* Save host GPRs */
>>>>       kvm_save_host_gpr a2
>>>>   +    /*
>>>> +     * The csr_era member variable of the pt_regs structure is 
>>>> required
>>>> +     * for unwinding orc to perform stack traceback, so we need to 
>>>> put
>>>> +     * pc into csr_era member variable here.
>>>> +     */
>>>> +    pcaddi    t0, 0
>>>> +    st.d    t0, a2, PT_ERA
>>> Hi, Xianglai,
>>>
>>> It should use `SYM_CODE_START` to mark the `kvm_enter_guest` rather 
>>> than
>>> `SYM_FUNC_START`, since the `SYM_FUNC_START` is used to mark "C-likely"
>>> asm functionw. 
>>
>> Ok, I will use SYM_CODE_START to mark kvm_enter_guest in the next 
>> version.
>>
>>> I guess the kvm_enter_guest is something like exception
>>> handler becuase the last instruction is "ertn". So usually it should
>>> mark UNWIND_HINT_REGS where can find last frame info by "$sp".
>>> However, all info is store to "$a2", this mark should be
>>>   `UNWIND_HINT sp_reg=ORC_REG_A2(???) type=UNWIND_HINT_TYPE_REGS`.
>>> I don't konw why save this function internal PC here by `pcaddi t0, 0`,
>>> and I think it is no meaning(, for exception handler, they save last PC
>>> by read CSR.ERA). The `kvm_enter_guest` saves registers by
>>> "$a2"("$sp" - PT_REGS) beyond stack ("$sp"), it is dangerous if IE
>>> is enable. So I wonder if there is really a stacktrace through this 
>>> function?
>>>
>> The stack backtracking issue in switch.S is rather complex because it 
>> involves the switching between cpu root-mode and guest-mode:
>> Real stack backtracking should be divided into two parts:
>> part 1:
>>     [<0>] kvm_enter_guest+0x38/0x11c
>>     [<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
>>     [<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
>>     [<0>] sys_ioctl+0x498/0xf00
>>     [<0>] do_syscall+0x98/0x1d0
>>     [<0>] handle_syscall+0xb8/0x158
>>
>> part 2:
>>     [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>     [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>     [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>     [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>     [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>     [<0>] kvm_exc_entry+0x104/0x1e4
>>
>>
>> In "part 1", after executing kvm_enter_guest, the cpu switches from 
>> root-mode to guest-mode.
>> In this case, stack backtracking is indeed very rare.
>>
>> In "part 2", the cpu switches from the guest-mode to the root-mode,
>> and most of the stack backtracking occurs during this phase.
>>
>> To obtain the longest call chain, we save pc in kvm_enter_guest to 
>> pt_regs.csr_era,
>> and after restoring the sp of the root-mode cpu in kvm_exc_entry,
>> The ORC entry was re-established using "UNWIND_HINT_REGS",
>>  and then we obtained the following stack backtrace as we wanted:
>>
>>     [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>     [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>     [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>     [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>     [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>     [<0>] kvm_exc_entry+0x104/0x1e4
> I found this might be a coincidence—correct behavior due to the incorrect
> UNWIND_HINT_REGS mark and unusual stack adjustment.
>
> First, the kvm_enter_guest contains only a single branch instruction, 
> ertn.
> It hardware-jump to the CSR.ERA address directly, jump into 
> kvm_exc_entry.
>
> At this point, the stack layout looks like this:
> -------------------------------
>   frame from call to `kvm_enter_guest`
> -------------------------------  <- $sp
>   PT_REGS
> -------------------------------  <- $a2
>
> Then kvm_exc_entry adjust stack without save any register (e.g. $ra, $sp)
> but still marked UNWIND_HINT_REGS.
> After the adjustment:
> -------------------------------
>   frame from call to `kvm_enter_guest`
> -------------------------------
>   PT_REGS
> -------------------------------  <- $a2, new $sp
>
> During unwinding, when the unwinder reaches kvm_exc_entry,
> it meets the mark of PT_REGS and correctly recovers
>  pc = regs.csr_era, sp = regs.sp, ra = regs.ra
>
Yes, here unwinder does work as you say.

> a) Can we avoid "ertn" rather than `jr reg (or jirl ra, reg, 0)`
> instead, like call?
No,  we need to rely on the 'ertn instruction return PIE to CRMD IE,
at the same time to ensure that its atomic,
there should be no other instruction than' ertn 'more appropriate here.

> The kvm_exc_entry cannot back to kvm_enter_guest
> if we use "ertn", so should the kvm_enter_guest appear on the stacktrace?
>

It is flexible. As I mentioned above, the cpu completes the switch from 
host-mode to guest mode through kvm_enter_guest,
and then the switch from guest mode to host-mode through kvm_exc_entry. 
When we ignore the details of the host-mode
and guest-mode switching in the middle, we can understand that the host 
cpu has completed kvm_enter_guest->kvm_exc_entry.
 From this perspective, I think it can exist in the call stack, and at 
the same time, we have obtained the maximum call stack information.


> b) Can we adjust $sp before entering kvm_exc_entry? Then we can mark
> UNWIND_HINT_REGS at the beginning of kvm_exc_entry, which something
> like ret_from_kernel_thread_asm.
>
The following command can be used to dump the orc entries of the kernel:
./tools/objtool/objtool --dump vmlinux

You can observe that not all orc entries are generated at the beginning 
of the function.
For example:
handle_tlb_protect
ftrace_stub
handle_reserved

So, is it unnecessary for us to modify UNWIND_HINT_REGS in order to 
place it at the beginning of the function.

If you have a better solution, could you provide an example of the 
modification?
I can test the feasibility of the solution.

Thanks!
Xianglai.

>> [<0>] kvm_enter_guest+0x38/0x11c
>>     [<0>] kvm_arch_vcpu_ioctl_run+0x26c/0x498 [kvm]
>>     [<0>] kvm_vcpu_ioctl+0x200/0xcf8 [kvm]
>>     [<0>] sys_ioctl+0x498/0xf00
>>     [<0>] do_syscall+0x98/0x1d0
>>     [<0>] handle_syscall+0xb8/0x158
>>
>> Doing so is equivalent to ignoring the details of the cpu root-mode 
>> and guest-mode switching.
>> About what you said in the IE enable phase is dangerous,
>> interrupts are always off during the cpu root-mode and guest-mode 
>> switching in kvm_enter_guest and kvm_exc_entry.
>>


