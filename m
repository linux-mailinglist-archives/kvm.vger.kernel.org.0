Return-Path: <kvm+bounces-66672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B52CDBC69
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 10:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0B64F302E155
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 09:17:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69A0C331237;
	Wed, 24 Dec 2025 09:17:05 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB27B2F1FDB;
	Wed, 24 Dec 2025 09:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=114.242.206.163
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766567823; cv=none; b=EREcqSyH8aaFKIeQELOPwMkJ5pEY4r+Nb4JctqaNvKHEFkmaQ7P+ODDmT7HHI+biq7RyyqngqkzLdk47vL7F46MF/s7Ni08Ku2ur1vU9jZc+rX61xiWAvnTdXgoLbzKVYQ5fHs8jQ1K43XdTE+xFSH/xZuHrcrj8egoI0eXHy7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766567823; c=relaxed/simple;
	bh=ZtWziJiqrZ0cuml3s+jrt4nWYfRTL4Qwsi5NxHwTfqc=;
	h=Subject:From:To:Cc:References:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=jt2vJDYOojhDKgtMKlI2V45PbwIXt8qO3JZlKcauZMKjVY6gkutu+/nMJ/F4ki/xLBMNrkPCiXOdoR3/ix1DuAFMfCbHL6ho3+1wcucXDV+MyPtzpbPt0jW9I8X5bPjCIDa5hOZaMTU/pl4fRJC/JErtwB8bMxN+2MlvZS3cCqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn; spf=pass smtp.mailfrom=loongson.cn; arc=none smtp.client-ip=114.242.206.163
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=loongson.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=loongson.cn
Received: from loongson.cn (unknown [10.20.42.126])
	by gateway (Coremail) with SMTP id _____8BxXcOBr0tp1rUCAA--.8779S3;
	Wed, 24 Dec 2025 17:16:49 +0800 (CST)
Received: from [10.20.42.126] (unknown [10.20.42.126])
	by front1 (Coremail) with SMTP id qMiowJBxbcJ6r0tpDzUEAA--.9953S3;
	Wed, 24 Dec 2025 17:16:45 +0800 (CST)
Subject: Re: [PATCH V2 2/2] LoongArch: KVM: fix "unreliable stack" issue
From: lixianglai <lixianglai@loongson.cn>
To: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 yangtiezhu@loongson.cn
Cc: loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, stable@vger.kernel.org, WANG Xuerui
 <kernel@xen0n.name>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Charlie Jenkins <charlie@rivosinc.com>, Thomas Gleixner <tglx@linutronix.de>
References: <20251222113409.2343711-1-lixianglai@loongson.cn>
 <20251222113409.2343711-3-lixianglai@loongson.cn>
 <e1f4b85e-0177-91b7-c422-22ed60607260@loongson.cn>
 <CAAhV-H4PehwGm-WwEuu4ZPbQutJR6m62tOSUxLcGQAxR_YX0Eg@mail.gmail.com>
 <7b8799d1-a4b2-58dc-187a-19c772612351@loongson.cn>
 <33541c5f-82ca-c86d-fcf9-437c4071c6b8@loongson.cn>
Message-ID: <9974d03b-bd07-04b0-c1e3-d76123c9cd2f@loongson.cn>
Date: Wed, 24 Dec 2025 17:13:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <33541c5f-82ca-c86d-fcf9-437c4071c6b8@loongson.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID:qMiowJBxbcJ6r0tpDzUEAA--.9953S3
X-CM-SenderInfo: 5ol0xt5qjotxo6or00hjvr0hdfq/
X-Coremail-Antispam: 1Uk129KBj93XoWxZF13WrW8Gry7WrWfWF15Awc_yoWrtFyfp3
	WFyF1DtFWDtw18Jw4Dta4DAFyUtrWkG3WDWr1xJFy8Jr1qgr1YgryUXw1q9F1DJw48GF1k
	XFy5tr9xZayUAwcCm3ZEXasCq-sJn29KB7ZKAUJUUUU7529EdanIXcx71UUUUU7KY7ZEXa
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

Hi:
> Add yangtiezhu@loongson.cn
>
> Hi :
>>
>>
>> On 2025/12/23 上午10:46, Huacai Chen wrote:
>>> On Tue, Dec 23, 2025 at 9:27 AM Bibo Mao <maobibo@loongson.cn> wrote:
>>>>
>>>>
>>>>
>>>> On 2025/12/22 下午7:34, Xianglai Li wrote:
>>>>> Insert the appropriate UNWIND macro definition into the 
>>>>> kvm_exc_entry in
>>>>> the assembly function to guide the generation of correct ORC table 
>>>>> entries,
>>>>> thereby solving the timeout problem of loading the 
>>>>> livepatch-sample module
>>>>> on a physical machine running multiple vcpus virtual machines.
>>>>>
>>>>> While solving the above problems, we have gained an additional 
>>>>> benefit,
>>>>> that is, we can obtain more call stack information
>>>>>
>>>>> Stack information that can be obtained before the problem is fixed:
>>>>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>>>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>>>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>>>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>>>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>>>> [<0>] kvm_exc_entry+0x100/0x1e0
>>>>>
>>>>> Stack information that can be obtained after the problem is fixed:
>>>>> [<0>] kvm_vcpu_block+0x88/0x120 [kvm]
>>>>> [<0>] kvm_vcpu_halt+0x68/0x580 [kvm]
>>>>> [<0>] kvm_emu_idle+0xd4/0xf0 [kvm]
>>>>> [<0>] kvm_handle_gspr+0x7c/0x700 [kvm]
>>>>> [<0>] kvm_handle_exit+0x160/0x270 [kvm]
>>>>> [<0>] kvm_exc_entry+0x100/0x1e0
>>>>> [<0>] kvm_arch_vcpu_ioctl_run+0x260/0x488 [kvm]
>>>>> [<0>] kvm_vcpu_ioctl+0x200/0xcd8 [kvm]
>>>>> [<0>] sys_ioctl+0x498/0xf00
>>>>> [<0>] do_syscall+0x94/0x190
>>>>> [<0>] handle_syscall+0xb8/0x158
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Xianglai Li <lixianglai@loongson.cn>
>>>>> ---
>>>>> Cc: Huacai Chen <chenhuacai@kernel.org>
>>>>> Cc: WANG Xuerui <kernel@xen0n.name>
>>>>> Cc: Tianrui Zhao <zhaotianrui@loongson.cn>
>>>>> Cc: Bibo Mao <maobibo@loongson.cn>
>>>>> Cc: Charlie Jenkins <charlie@rivosinc.com>
>>>>> Cc: Xianglai Li <lixianglai@loongson.cn>
>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>>>
>>>>>    arch/loongarch/kvm/switch.S | 2 ++
>>>>>    1 file changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/arch/loongarch/kvm/switch.S 
>>>>> b/arch/loongarch/kvm/switch.S
>>>>> index 93845ce53651..e3ecb24a3bc5 100644
>>>>> --- a/arch/loongarch/kvm/switch.S
>>>>> +++ b/arch/loongarch/kvm/switch.S
>>>>> @@ -170,6 +170,7 @@ SYM_CODE_START(kvm_exc_entry)
>>>>>        /* restore per cpu register */
>>>>>        ld.d    u0, a2, KVM_ARCH_HPERCPU
>>>>>        addi.d  sp, sp, -PT_SIZE
>>>>> +     UNWIND_HINT_REGS
>>>>>
>>>>>        /* Prepare handle exception */
>>>>>        or      a0, s0, zero
>>>>> @@ -214,6 +215,7 @@ SYM_FUNC_START(kvm_enter_guest)
>>>>>        addi.d  a2, sp, -PT_SIZE
>>>>>        /* Save host GPRs */
>>>>>        kvm_save_host_gpr a2
>>>>> +     st.d    ra, a2, PT_ERA
>>>> Had better add some comments here to show that it is special for 
>>>> unwind
>>>> usage since there is "st.d ra, a2, PT_R1" already in macro
>>>> kvm_save_host_gpr().
>>> Then there is a new problem, why can unwinder not recognize the
>>> instruction in  kvm_save_host_gpr()?
>> maybe it need unwinder owner to answer this question.
>>
> kvm_save_host_gpr() is an assembler macro that has already been 
> executed and is no longer normal on the stack.
> Am I explaining correctly? @tiezhu
>
> I guess you might be wondering why unwinder didn't recognize 
> kvm_enter_guest().
>
> There's something wrong with the logic that we're implementing here 
> that we should put the current pc in era instead of ra.
> This will allow unwind to identify the symbol kvm_enter_guest.
>
> So I will fix it in the next version like this:
>
> @@ -214,6 +215,7 @@ SYM_FUNC_START(kvm_enter_guest)
>        addi.d  a2, sp, -PT_SIZE
>        /* Save host GPRs */
>        kvm_save_host_gpr a2
>
> +    /*
> +     * The csr_era member variable of the pt_regs structure is required
> +     * for unwinding orc to perform stack traceback, so we need to put
> +     * pc into csr_era member variable here.
> +     */
> +    pcaddi    t0, 0
> +    st.d    t0, a2, PT_ERA
> +
>
We discussed it with @tiezhu internally and he was OK with the change!

Thanks,
Xianglai.

> Thanks,
> Xianglai.
>>>
>>> Huacai
>>>>
>>>> Regards
>>>> Bibo Mao
>>>>>
>>>>>        addi.d  a2, a1, KVM_VCPU_ARCH
>>>>>        st.d    sp, a2, KVM_ARCH_HSP
>>>>>
>>>>
>


