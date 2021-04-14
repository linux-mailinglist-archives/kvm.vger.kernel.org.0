Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E48335F76B
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 17:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348313AbhDNPPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 11:15:01 -0400
Received: from foss.arm.com ([217.140.110.172]:57824 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233342AbhDNPPA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 11:15:00 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D786113E;
        Wed, 14 Apr 2021 08:14:37 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7D31F3F73B;
        Wed, 14 Apr 2021 08:14:36 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 1/8] arm/arm64: Reorganize cstart assembler
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-2-drjones@redhat.com>
 <2b647637-d307-5256-beab-c58728f60e9b@arm.com>
 <20210414085921.lazllz24o3eqts52@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <931b6bdd-c012-7666-ff79-0bf337dedfcf@arm.com>
Date:   Wed, 14 Apr 2021 16:15:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210414085921.lazllz24o3eqts52@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/14/21 9:59 AM, Andrew Jones wrote:
> On Tue, Apr 13, 2021 at 05:34:24PM +0100, Alexandru Elisei wrote:
>> Hi Drew,
>>
>> On 4/7/21 7:59 PM, Andrew Jones wrote:
>>> Move secondary_entry helper functions out of .init and into .text,
>>> since secondary_entry isn't run at "init" time.
>> The tests aren't loaded using the loader, so as far as I can tell the reason for
>> having an .init section is to make sure the code from the start label is put at
>> offset 0 in the test binary. As long as the start label is kept at the beginning
>> of the .init section, and the loader script places the section first, I don't see
>> any issues with this change.
>>
>> The only hypothetical problem that I can think of is that the code from .init
>> calls code from .text, and if the text section grows very large we might end up
>> with a PC offset larger than what can be encoded in the BL instruction. That's
>> unlikely to happen (the offset is 16MB for arm and 64MB for arm64), and the .init
>> code already calls other functions (like setup) which are in .text, so we would
>> have this problem regardless of this change. And the compiler will emit an error
>> if that happens.
>>
>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>> ---
>>>  arm/cstart.S   | 62 +++++++++++++++++++++++++++-----------------------
>>>  arm/cstart64.S | 22 +++++++++++-------
>>>  2 files changed, 48 insertions(+), 36 deletions(-)
>>>
>>> diff --git a/arm/cstart.S b/arm/cstart.S
>>> index d88a98362940..653ab1e8a141 100644
>>> --- a/arm/cstart.S
>>> +++ b/arm/cstart.S
>>> @@ -96,32 +96,7 @@ start:
>>>  	bl	exit
>>>  	b	halt
>>>  
>>> -
>>> -.macro set_mode_stack mode, stack
>>> -	add	\stack, #S_FRAME_SIZE
>>> -	msr	cpsr_c, #(\mode | PSR_I_BIT | PSR_F_BIT)
>>> -	isb
>>> -	mov	sp, \stack
>>> -.endm
>>> -
>>> -exceptions_init:
>>> -	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
>>> -	bic	r2, #CR_V		@ SCTLR.V := 0
>>> -	mcr	p15, 0, r2, c1, c0, 0	@ write SCTLR
>>> -	ldr	r2, =vector_table
>>> -	mcr	p15, 0, r2, c12, c0, 0	@ write VBAR
>>> -
>>> -	mrs	r2, cpsr
>>> -
>>> -	/* first frame reserved for svc mode */
>>> -	set_mode_stack	UND_MODE, r0
>>> -	set_mode_stack	ABT_MODE, r0
>>> -	set_mode_stack	IRQ_MODE, r0
>>> -	set_mode_stack	FIQ_MODE, r0
>>> -
>>> -	msr	cpsr_cxsf, r2		@ back to svc mode
>>> -	isb
>>> -	mov	pc, lr
>>> +.text
>> Hm... now we've moved enable_vfp from .init to .text, and enable_vfp *is* called
>> from .init code, which doesn't fully match up with the commit message. Is the
>> actual reason for this change that the linker script for EFI will discard the
>> .init section? Maybe it's worth mentioning that in the commit message, because it
>> will explain this change better.
> Right, the .init section may not exist when linking with other linker
> scripts. I'll make the commit message more clear.
>
>> Or is it to align arm with arm64, where only
>> start is in the .init section?
>>
>>>  
>>>  enable_vfp:
>>>  	/* Enable full access to CP10 and CP11: */
>>> @@ -133,8 +108,6 @@ enable_vfp:
>>>  	vmsr	fpexc, r0
>>>  	mov	pc, lr
>>>  
>>> -.text
>>> -
>>>  .global get_mmu_off
>>>  get_mmu_off:
>>>  	ldr	r0, =auxinfo
>>> @@ -235,6 +208,39 @@ asm_mmu_disable:
>>>  
>>>  	mov     pc, lr
>>>  
>>> +/*
>>> + * Vectors
>>> + */
>>> +
>>> +.macro set_mode_stack mode, stack
>>> +	add	\stack, #S_FRAME_SIZE
>>> +	msr	cpsr_c, #(\mode | PSR_I_BIT | PSR_F_BIT)
>>> +	isb
>>> +	mov	sp, \stack
>>> +.endm
>>> +
>>> +exceptions_init:
>>> +	mrc	p15, 0, r2, c1, c0, 0	@ read SCTLR
>>> +	bic	r2, #CR_V		@ SCTLR.V := 0
>>> +	mcr	p15, 0, r2, c1, c0, 0	@ write SCTLR
>>> +	ldr	r2, =vector_table
>>> +	mcr	p15, 0, r2, c12, c0, 0	@ write VBAR
>>> +
>>> +	mrs	r2, cpsr
>>> +
>>> +	/*
>>> +	 * Input r0 is the stack top, which is the exception stacks base
>>> +	 * The first frame is reserved for svc mode
>>> +	 */
>>> +	set_mode_stack	UND_MODE, r0
>>> +	set_mode_stack	ABT_MODE, r0
>>> +	set_mode_stack	IRQ_MODE, r0
>>> +	set_mode_stack	FIQ_MODE, r0
>>> +
>>> +	msr	cpsr_cxsf, r2		@ back to svc mode
>>> +	isb
>>> +	mov	pc, lr
>>> +
>>>  /*
>>>   * Vector stubs
>>>   * Simplified version of the Linux kernel implementation
>>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>>> index 0a85338bcdae..d39cf4dfb99c 100644
>>> --- a/arm/cstart64.S
>>> +++ b/arm/cstart64.S
>>> @@ -89,10 +89,12 @@ start:
>>>  	msr	cpacr_el1, x4
>>>  
>>>  	/* set up exception handling */
>>> +	mov	x4, x0				// x0 is the addr of the dtb
>> I suppose changing exceptions_init to use x0 as a scratch register instead of x4
>> makes some sense if you look at it from the perspective of it being called from
>> secondary_entry, where all the functions use x0 as a scratch register. But it's
>> still called from start, where using x4 as a scratch register is preferred because
>> of the kernel boot protocol (x0-x3 are reserved).
>>
>> Is there an actual bug that this is supposed to fix (I looked for it and couldn't
>> figure it out) or is it just a cosmetic change?
> Now that exceptions_init isn't a private function of start (actually it
> hasn't been in a long time, considering secondary_entry calls it) I would
> like it to better conform to calling conventions. I guess I should have
> used x19 here instead of x4 to be 100% correct. Or, would you rather I
> just continue using x4 in exceptions_init in order to avoid the
> save/restore?

To be honest, for this patch, I think it would be best to leave exceptions_init
unchanged:

- We switch to using x0 like the rest of the code from secondary_entry, but
because of that we need to save and restore the DTB address from x0 in start, so I
don't think we've gained anything.
- It makes the diff larger.
- It runs the risk of introducing regressions (like all changes).

Maybe this can be left for a separate patch that changes code called from C to
follow aapcs64.

Thanks,
Alex
