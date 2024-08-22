Return-Path: <kvm+bounces-24809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D00C95ADD7
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 08:45:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED0971F23130
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 06:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78DDD13BC3D;
	Thu, 22 Aug 2024 06:44:51 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A6F77102;
	Thu, 22 Aug 2024 06:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724309091; cv=none; b=fkeVWNCZ65CG4io5AXCQ5hHhED/e4sM6E4VbyHa8q5Titfg8zbiKB4Hhkb1yWO8iQRC651E3FqlzGnGLWYyCat16IzNFfyNJkTVL2BXHvWrPynfmrX8zFtfjewsmCCFFW58xB+HxOjx6wKmJ+qhDlP0oF1A57+7cNvuX7FXpvY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724309091; c=relaxed/simple;
	bh=QWd4VYItfI7dD93haV8ggZqkpix8WqqevnYGTPX5RF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dIBfQJWDDP+n478amT8PHwvxORjpWOzPcvZP1UyhX9vLBOXVhFkEHBQxayK8kKr03hpXQ/wtRdZHSw3EyaVwUtrlWOxAAEehmQfGv426oyQSv+LmYAZCWtqMHmNfx1zeGtb3rvUqVxrQgaanlPeXyxaLkqiMeqW3iLwDV+UPKFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from [192.168.12.218] (unknown [121.237.44.107])
	by APP-01 (Coremail) with SMTP id qwCowAD3_kr03MZmj2gfCQ--.15682S2;
	Thu, 22 Aug 2024 14:38:44 +0800 (CST)
Message-ID: <430f3d38-b12e-4ac8-8040-33bab40380ab@iscas.ac.cn>
Date: Thu, 22 Aug 2024 14:38:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] riscv: perf: add guest vs host distinction
To: Andrew Jones <ajones@ventanamicro.com>
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, mark.rutland@arm.com,
 alexander.shishkin@linux.intel.com, jolsa@kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
 kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-perf-users@vger.kernel.org
References: <cover.1723518282.git.zhouquan@iscas.ac.cn>
 <3729354b59658535c4370d3c1c7e2f162433807b.1723518282.git.zhouquan@iscas.ac.cn>
 <20240821-f5e1d6afb0d2230c1256a75b@orel>
Content-Language: en-US
From: Quan Zhou <zhouquan@iscas.ac.cn>
In-Reply-To: <20240821-f5e1d6afb0d2230c1256a75b@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:qwCowAD3_kr03MZmj2gfCQ--.15682S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw47uF4UtF4kuF47Xw1UKFg_yoWrAw43pF
	4DCFnxKFWDXr4Ig34SqF15Wr1Y9r1rXF47ury29345Cr9FqF95JF1kKw15CryrArykXFy0
	y3WavFnxCwn8ta7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9qb7Iv0xC_Zr1lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwV
	C2z280aVCY1x0267AKxVWxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xK
	xwCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE14v_GF1l42xK82IYc2Ij64vIr41l4I8I3I
	0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWU
	GVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI
	0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0
	rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r
	4UJbIYCTnIWIevJa73UjIFyTuYvjxUIfHUUUUUU
X-CM-SenderInfo: 52kr31xxdqqxpvfd2hldfou0/1tbiCQ8RBmbGimj9IwAAsN


On 2024/8/21 20:48, Andrew Jones wrote:
> On Tue, Aug 13, 2024 at 09:23:54PM GMT, zhouquan@iscas.ac.cn wrote:
>> From: Quan Zhou <zhouquan@iscas.ac.cn>
>>
>> Introduce basic guest support in perf, enabling it to distinguish
>> between PMU interrupts in the host or guest, and collect
>> fundamental information.
>>
>> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
>> ---
>>   arch/riscv/include/asm/perf_event.h |  7 ++++++
>>   arch/riscv/kernel/perf_callchain.c  | 38 +++++++++++++++++++++++++++++
>>   2 files changed, 45 insertions(+)
>>
>> diff --git a/arch/riscv/include/asm/perf_event.h b/arch/riscv/include/asm/perf_event.h
>> index 665bbc9b2f84..c2b73c3aefe4 100644
>> --- a/arch/riscv/include/asm/perf_event.h
>> +++ b/arch/riscv/include/asm/perf_event.h
>> @@ -8,13 +8,20 @@
>>   #ifndef _ASM_RISCV_PERF_EVENT_H
>>   #define _ASM_RISCV_PERF_EVENT_H
>>   
>> +#ifdef CONFIG_PERF_EVENTS
>>   #include <linux/perf_event.h>
>>   #define perf_arch_bpf_user_pt_regs(regs) (struct user_regs_struct *)regs
>>   
>> +extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
>> +extern unsigned short perf_misc_flags(struct pt_regs *regs);
>> +#define perf_misc_flags(regs) perf_misc_flags(regs)
>> +
>>   #define perf_arch_fetch_caller_regs(regs, __ip) { \
>>   	(regs)->epc = (__ip); \
>>   	(regs)->s0 = (unsigned long) __builtin_frame_address(0); \
>>   	(regs)->sp = current_stack_pointer; \
>>   	(regs)->status = SR_PP; \
>>   }
>> +#endif
>> +
>>   #endif /* _ASM_RISCV_PERF_EVENT_H */
>> diff --git a/arch/riscv/kernel/perf_callchain.c b/arch/riscv/kernel/perf_callchain.c
>> index 3348a61de7d9..7af90a3bb373 100644
>> --- a/arch/riscv/kernel/perf_callchain.c
>> +++ b/arch/riscv/kernel/perf_callchain.c
>> @@ -58,6 +58,11 @@ void perf_callchain_user(struct perf_callchain_entry_ctx *entry,
>>   {
>>   	unsigned long fp = 0;
>>   
>> +	if (perf_guest_state()) {
>> +		/* TODO: We don't support guest os callchain now */
>> +		return;
>> +	}
>> +
>>   	fp = regs->s0;
>>   	perf_callchain_store(entry, regs->epc);
>>   
>> @@ -74,5 +79,38 @@ static bool fill_callchain(void *entry, unsigned long pc)
>>   void perf_callchain_kernel(struct perf_callchain_entry_ctx *entry,
>>   			   struct pt_regs *regs)
>>   {
>> +	if (perf_guest_state()) {
>> +		/* TODO: We don't support guest os callchain now */
>> +		return;
>> +	}
>> +
>>   	walk_stackframe(NULL, regs, fill_callchain, entry);
>>   }
>> +
>> +unsigned long perf_instruction_pointer(struct pt_regs *regs)
>> +{
>> +	if (perf_guest_state())
>> +		return perf_guest_get_ip();
>> +
>> +	return instruction_pointer(regs);
>> +}
>> +
>> +unsigned short perf_misc_flags(struct pt_regs *regs)
> 
> I see that the consumer of perf_misc_flags is only a u16, but all other
> architectures define this function as returning an unsigned long, and
> your last version did as well. My comment in the last version was that
> we should use an unsigned long for the 'misc' variable to match the
> return type of the function. I still think we should do that instead
> since the function should be consistent with the other architectures.
> 

I agree with your point that the type of `misc` should be consistent 
with other architectures.

However, one thing confuses me. The return value of perf_misc_flags
is assigned to the `misc` field of the perf_event_header structure,
and the field is defined as `u16`. I checked the return type of 
`perf_misc_flags` in other architectures, and I found that for 
x86/arm/s390, the type is `unsigned long`, while for powerpc, it is `u32`.
These do not match `u16`, which seems to pose a risk of type truncation 
and feels a bit unconventional. Or is there some other reasonable 
consideration behind this?

Thanks a lot!
Quan

>> +{
>> +	unsigned int guest_state = perf_guest_state();
>> +	unsigned short misc = 0;
>> +
>> +	if (guest_state) {
>> +		if (guest_state & PERF_GUEST_USER)
>> +			misc |= PERF_RECORD_MISC_GUEST_USER;
>> +		else
>> +			misc |= PERF_RECORD_MISC_GUEST_KERNEL;
>> +	} else {
>> +		if (user_mode(regs))
>> +			misc |= PERF_RECORD_MISC_USER;
>> +		else
>> +			misc |= PERF_RECORD_MISC_KERNEL;
>> +	}
>> +
>> +	return misc;
>> +}
>> -- 
>> 2.34.1
>>
> 
> Thanks,
> drew


