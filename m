Return-Path: <kvm+bounces-66569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C820CD7F4A
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:19:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4574C3032A84
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 03:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DA842D3A80;
	Tue, 23 Dec 2025 03:19:30 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919C712CDA5;
	Tue, 23 Dec 2025 03:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766459969; cv=none; b=sQoa/1hWMVyqNsBe6BizpmeU8X//dFILFctPT5qI+oPKAU4dBNt+MZlyH+wFOB3R9/2EQi09C0JBxhTRWEU6bqISap/OfsEtDJ4OLGFOStUwbJ0wXrkQZSX4meec/UAbchFWT6+j+BuoTfGoL/CCsxMsJmExsUh7rLe4DlsQZ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766459969; c=relaxed/simple;
	bh=G1WFTYPhwexaOSM/l1xE9HiH8QJR/Nb1UrBT6/bmX9c=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=MpmLQAm/cDJHSDYYHw9QHMV/h0V0GsR823RK477kfsP0e7ZsteEGpLcDnEVPIbiE6uHhFCFifZCuEWxQogdmgsY8D5O2Sw3uJ641flgvqJ+87Tx4gyZtqREdwxja1XBzJRueQaOeyG5FVUL574rGtw4JhGzO2tCnFlZWtGL/NDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.62])
	by gateway (Coremail) with SMTP id _____8BxHMM6CkppykMCAA--.6971S3;
	Tue, 23 Dec 2025 11:19:22 +0800 (CST)
Received: from [10.20.42.62] (unknown [10.20.42.62])
	by front1 (Coremail) with SMTP id qMiowJBxSeA2CkppPrADAA--.11231S3;
	Tue, 23 Dec 2025 11:19:20 +0800 (CST)
Subject: Re: [PATCH V2 2/2] LoongArch: KVM: fix "unreliable stack" issue
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Xianglai Li <lixianglai@loongson.cn>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org,
 WANG Xuerui <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20251222113409.2343711-1-lixianglai@loongson.cn>
 <20251222113409.2343711-3-lixianglai@loongson.cn>
 <e1f4b85e-0177-91b7-c422-22ed60607260@loongson.cn>
 <CAAhV-H4PehwGm-WwEuu4ZPbQutJR6m62tOSUxLcGQAxR_YX0Eg@mail.gmail.com>
From: Bibo Mao <maobibo@loongson.cn>
Message-ID: <7b8799d1-a4b2-58dc-187a-19c772612351@loongson.cn>
Date: Tue, 23 Dec 2025 11:16:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAAhV-H4PehwGm-WwEuu4ZPbQutJR6m62tOSUxLcGQAxR_YX0Eg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxSeA2CkppPrADAA--.11231S3
X-CM-SenderInfo: xpdruxter6z05rqj20fqof0/
X-Coremail-Antispam: 1Uk129KBj93XoWxZF13WrW8Gry7GFW3Jr4DKFX_yoW5CFyfpa
	ySyF1q9F4DK340yw4qq34qkrWIq3ykKry3Wrn3try8Ar1vgryrWa4xGw43CFyDXw4xGF4k
	XFy5KasIqayUAwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUBFb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1ln4kS14v26r1Y6r17M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
	xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r12
	6r1DMcIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
	1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwCFI7km07C267AKxVW8ZVWrXwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
	vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
	x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
	xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAF
	wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jFE__UUUUU=



On 2025/12/23 上午10:46, Huacai Chen wrote:
> On Tue, Dec 23, 2025 at 9:27 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>
>>
>>
>> On 2025/12/22 下午7:34, Xianglai Li wrote:
>>> Insert the appropriate UNWIND macro definition into the kvm_exc_entry in
>>> the assembly function to guide the generation of correct ORC table entries,
>>> thereby solving the timeout problem of loading the livepatch-sample module
>>> on a physical machine running multiple vcpus virtual machines.
>>>
>>> While solving the above problems, we have gained an additional benefit,
>>> that is, we can obtain more call stack information
>>>
>>> Stack information that can be obtained before the problem is fixed:
>>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>> [<0>] kvm_exc_entry+0x100/0x1e0
>>>
>>> Stack information that can be obtained after the problem is fixed:
>>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>> [<0>] kvm_exc_entry+0x100/0x1e0
>>> [<0>] kvm_arch_vcpu_ioctl_run+0x260/0x488 [kvm]
>>> [<0>] kvm_vcpu_ioctl+0x200/0xcd8 [kvm]
>>> [<0>] sys_ioctl+0x498/0xf00
>>> [<0>] do_syscall+0x94/0x190
>>> [<0>] handle_syscall+0xb8/0x158
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>>> ---
>>> Cc: Huacai Chen <chenhuacai@kernel.org>
>>> Cc: WANG Xuerui <kernel@xen0n.name>
>>> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
>>> Cc: Bibo Mao <maobibo@loongson.cn>
>>> Cc: Charlie Jenkins <charlie@rivosinc.com>
>>> Cc: Xianglai Li <lixianglai@loongson.cn>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>
>>>    arch/loongarch/kvm/switch.S | 2 ++
>>>    1 file changed, 2 insertions(+)
>>>
>>> diff --git a/arch/loongarch/kvm/switch.S b/arch/loongarch/kvm/switch.S
>>> index 93845ce53651..e3ecb24a3bc5 100644
>>> --- a/arch/loongarch/kvm/switch.S
>>> +++ b/arch/loongarch/kvm/switch.S
>>> @@ -170,6 +170,7 @@ SYM_CODE_START(kvm_exc_entry)
>>>        /* restore per cpu register */
>>>        ld.d    u0, a2, KVM_ARCH_HPERCPU
>>>        addi.d  sp, sp, -PT_SIZE
>>> +     UNWIND_HINT_REGS
>>>
>>>        /* Prepare handle exception */
>>>        or      a0, s0, zero
>>> @@ -214,6 +215,7 @@ SYM_FUNC_START(kvm_enter_guest)
>>>        addi.d  a2, sp, -PT_SIZE
>>>        /* Save host GPRs */
>>>        kvm_save_host_gpr a2
>>> +     st.d    ra, a2, PT_ERA
>> Had better add some comments here to show that it is special for unwind
>> usage since there is "st.d ra, a2, PT_R1" already in macro
>> kvm_save_host_gpr().
> Then there is a new problem, why can unwinder not recognize the
> instruction in  kvm_save_host_gpr()?
maybe it need unwinder owner to answer this question.

> 
> Huacai
>>
>> Regards
>> Bibo Mao
>>>
>>>        addi.d  a2, a1, KVM_VCPU_ARCH
>>>        st.d    sp, a2, KVM_ARCH_HSP
>>>
>>


