Return-Path: <kvm+bounces-29348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 209039A9E49
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 11:19:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A81B1C24BD9
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 09:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD06198851;
	Tue, 22 Oct 2024 09:18:47 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp84.cstnet.cn [159.226.251.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CF918593C;
	Tue, 22 Oct 2024 09:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729588727; cv=none; b=Oj7DvdA3MJh0s93sa1/GEW5+vLMgq5DHbGbJibsfhSDeZ69gQ3RZHPETPaGXC9+ufUouoEPv05FNsXxLMs9gA1iBmoloEZU+98OgIg1uNb1TstscH+Fbdv17mnRWxRUBf3dVdMb6WwXAfyrK6b5EGyOJm+b6wnZDB0QbNflwEIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729588727; c=relaxed/simple;
	bh=nmKjtqGLDf9m0AgNpWdrsl4yTckIlzdlkgxXMmEmIpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uufjU5SOKrnRoNr3rcjF3SoeV/Drd72ueaYhP85EkwLv5sq4crMi7c08vEdxiUB2dnVhDXs0AWZkeNAahOFIH9L8+n3J8M5Lw2i4SWA7uVhqorUDuBSHLD140eb7k6T20qtxRiswhWDz5s9Otno7Tdf48vLX/+SYjv+zth3Tx3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.12.114] (unknown [121.237.44.89])
	by APP-05 (Coremail) with SMTP id zQCowABHLmVubBdnKhqRCQ--.25718S2;
	Tue, 22 Oct 2024 17:12:16 +0800 (CST)
Message-ID: <a5eb1373-1935-4290-9658-3234359aebe7@iscas.ac.cn>
Date: Tue, 22 Oct 2024 17:11:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] riscv: perf: add guest vs host distinction
To: Palmer Dabbelt <palmer@dabbelt.com>, Marc Zyngier <maz@kernel.org>
Cc: anup@brainfault.org, ajones@ventanamicro.com, atishp@atishpatra.org,
 Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
 Mark Rutland <mark.rutland@arm.com>, alexander.shishkin@linux.intel.com,
 jolsa@kernel.org, linux-kernel@vger.kernel.org,
 linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-perf-users@vger.kernel.org
References: <mhng-c9ba919e-b4a4-4bb9-bdba-f4d3295a930b@palmer-ri-x1c9a>
Content-Language: en-US
From: Quan Zhou <zhouquan@iscas.ac.cn>
In-Reply-To: <mhng-c9ba919e-b4a4-4bb9-bdba-f4d3295a930b@palmer-ri-x1c9a>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABHLmVubBdnKhqRCQ--.25718S2
X-Coremail-Antispam: 1UD129KBjvJXoWxKr17GFy7XrWkCF4DtFyxKrg_yoW7XrW5pr
	4kCFZxKrWUWrn3X34ftr1UuFy5Zr1rXa17Zr10g3W5CrsFvF90qF1qgwn09r18Ar4kXFy8
	JF1jvrnruwn8tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb7Iv0xC_KF4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
	C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Cr0_Gr
	1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xK
	xwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x07UE9akUUUUU=
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiDAcSBmcXL9LhKwAAsY

On 2024/10/19 03:55, Palmer Dabbelt wrote:
> On Tue, 15 Oct 2024 01:42:50 PDT (-0700), zhouquan@iscas.ac.cn wrote:
>> From: Quan Zhou <zhouquan@iscas.ac.cn>
>>
>> Introduce basic guest support in perf, enabling it to distinguish
>> between PMU interrupts in the host or guest, and collect
>> fundamental information.
>>
>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
>> ---
>>  arch/riscv/include/asm/perf_event.h |  6 +++++
>>  arch/riscv/kernel/perf_callchain.c  | 38 +++++++++++++++++++++++++++++
>>  2 files changed, 44 insertions(+)
>>
>> diff --git a/arch/riscv/include/asm/perf_event.h 
>> b/arch/riscv/include/asm/perf_event.h
>> index 665bbc9b2f84..38926b4a902d 100644
>> --- a/arch/riscv/include/asm/perf_event.h
>> +++ b/arch/riscv/include/asm/perf_event.h
>> @@ -8,7 +8,11 @@
>>  #ifndef _ASM_RISCV_PERF_EVENT_H
>>  #define _ASM_RISCV_PERF_EVENT_H
>>
>> +#ifdef CONFIG_PERF_EVENTS
>>  #include <linux/perf_event.h>
>> +extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
>> +extern unsigned long perf_misc_flags(struct pt_regs *regs);
>> +#define perf_misc_flags(regs) perf_misc_flags(regs)
>>  #define perf_arch_bpf_user_pt_regs(regs) (struct user_regs_struct *)regs
>>
>>  #define perf_arch_fetch_caller_regs(regs, __ip) { \
>> @@ -17,4 +21,6 @@
>>      (regs)->sp = current_stack_pointer; \
>>      (regs)->status = SR_PP; \
>>  }
>> +#endif
>> +
>>  #endif /* _ASM_RISCV_PERF_EVENT_H */
>> diff --git a/arch/riscv/kernel/perf_callchain.c 
>> b/arch/riscv/kernel/perf_callchain.c
>> index c7468af77c66..c2c81a80f816 100644
>> --- a/arch/riscv/kernel/perf_callchain.c
>> +++ b/arch/riscv/kernel/perf_callchain.c
>> @@ -28,11 +28,49 @@ static bool fill_callchain(void *entry, unsigned 
>> long pc)
>>  void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>>               struct pt_regs *regs)
>>  {
>> +    if (perf_guest_state()) {
>> +        /* TODO: We don't support guest os callchain now */
>> +        return;
> 
> That seems kind of weird, but it looks like almost exactly the same 
> thing Marc did in 75e424620a4f ("arm64: perf: add guest vs host 
> discrimination").  I think it's safe, as we'll basically just silently 
> display no backtrace and we can always just fail to backtrace.
> 
> That said: I don't understand why we can't backtrace inside a guest?  If 
> we can get the registers and memory it seems like we should be able to. 
> Maybe I'm missing something?
> 

 From the community's discussion history, there are two reasons:

1) For backtracing, we must traverse the structures within the guest's 
virtual address space. These structures can change at any time while the 
guest is running. The page table data we obtain might be corrupted, 
making it impossible to complete the traversal of the page tables or 
leading to incorrect data [1].

2) For security reasons, a significant number of cloud vendors wish to 
make accessing customer data almost impossible [2].

Currently, community prefer to implement this functionality in user 
space and access the guest through the KVM API, interrupting the guest 
to perform the unwind operation.

As with the x86/ARM architectures, stubs are still retained here for 
RISC-V. If `guest os callchain` is introduced in the future, they can 
indicate that additional work needs to be done.

[1] 
https://lore.kernel.org/all/ZSlNsn-f1j2bB8pW@FVFF77S0Q05N.cambridge.arm.com/
[2] https://lore.kernel.org/all/ZXeTvCLURmwzpDkP@google.com/

Regards,
Quan

>> +    }
>> +
>>      arch_stack_walk_user(fill_callchain, entry, regs);
>>  }
>>
>>  void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>>                 struct pt_regs *regs)
>>  {
>> +    if (perf_guest_state()) {
>> +        /* TODO: We don't support guest os callchain now */
>> +        return;
>> +    }
>> +
>>      walk_stackframe(NULL, regs, fill_callchain, entry);
>>  }
>> +
>> +unsigned long perf_instruction_pointer(struct pt_regs *regs)
>> +{
>> +    if (perf_guest_state())
>> +        return perf_guest_get_ip();
>> +
>> +    return instruction_pointer(regs);
>> +}
>> +
>> +unsigned long perf_misc_flags(struct pt_regs *regs)
>> +{
>> +    unsigned int guest_state = perf_guest_state();
>> +    unsigned long misc = 0;
>> +
>> +    if (guest_state) {
>> +        if (guest_state & PERF_GUEST_USER)
>> +            misc |= PERF_RECORD_MISC_GUEST_USER;
>> +        else
>> +            misc |= PERF_RECORD_MISC_GUEST_KERNEL;
>> +    } else {
>> +        if (user_mode(regs))
>> +            misc |= PERF_RECORD_MISC_USER;
>> +        else
>> +            misc |= PERF_RECORD_MISC_KERNEL;
>> +    }
>> +
>> +    return misc;
>> +}


