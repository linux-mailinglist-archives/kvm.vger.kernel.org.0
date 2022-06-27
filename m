Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6035655CB2B
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 14:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbiF0RK1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 13:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237931AbiF0RKZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 13:10:25 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6926E1E0
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 10:10:24 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5CCC71758;
        Mon, 27 Jun 2022 10:10:24 -0700 (PDT)
Received: from [10.57.40.121] (unknown [10.57.40.121])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DDA33F792;
        Mon, 27 Jun 2022 10:10:22 -0700 (PDT)
Message-ID: <3c501902-ba3d-209e-b563-a20547c3fe26@arm.com>
Date:   Mon, 27 Jun 2022 18:10:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH v2 19/23] arm64: Use code from the gnu-efi
 when booting with EFI
Content-Language: en-GB
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com,
        Andrew Jones <andrew.jones@linux.dev>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-20-nikos.nikoleris@arm.com>
 <YrJHDBeTGgd+dpDP@google.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <YrJHDBeTGgd+dpDP@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

Thanks for this, let me go through the idea I had. Please let me know if 
I am missing something.

On 21/06/2022 23:32, Ricardo Koller wrote:
> On Fri, May 06, 2022 at 09:56:01PM +0100, Nikos Nikoleris wrote:
>> arm/efi/crt0-efi-aarch64.S defines the header and the handover
>> sequence from EFI to a efi_main. This change includes the whole file
>> in arm/cstart64.S when we compile with EFI support.
>>
>> In addition, we change the handover code in arm/efi/crt0-efi-aarch64.S
>> to align the stack pointer. This alignment is necessary because we
>> make assumptions about cpu0's stack alignment and most importantly we
>> place its thread_info at the bottom of this stack.
>>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   arm/cstart64.S             |  6 ++++++
>>   arm/efi/crt0-efi-aarch64.S | 17 +++++++++++++++--
>>   2 files changed, 21 insertions(+), 2 deletions(-)
>>
>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>> index 55b41ea..08cf02f 100644
>> --- a/arm/cstart64.S
>> +++ b/arm/cstart64.S
>> @@ -15,6 +15,10 @@
>>   #include <asm/thread_info.h>
>>   #include <asm/sysreg.h>
>>   
>> +#ifdef CONFIG_EFI
>> +#include "efi/crt0-efi-aarch64.S"
>> +#else
>> +
>>   .macro zero_range, tmp1, tmp2
>>   9998:	cmp	\tmp1, \tmp2
>>   	b.eq	9997f
>> @@ -107,6 +111,8 @@ start:
>>   	bl	exit
>>   	b	halt
>>   
>> +#endif
>> +
>>   .text
>>   
>>   /*
>> diff --git a/arm/efi/crt0-efi-aarch64.S b/arm/efi/crt0-efi-aarch64.S
>> index d50e78d..11a062d 100644
>> --- a/arm/efi/crt0-efi-aarch64.S
>> +++ b/arm/efi/crt0-efi-aarch64.S
>> @@ -111,10 +111,19 @@ section_table:
>>   
>>   	.align		12
>>   _start:
>> -	stp		x29, x30, [sp, #-32]!
>> +	stp		x29, x30, [sp, #-16]!
> 
> Is this and the "ldp x29, x30, [sp], #16" change below needed?
> why is #-32 not good?
> 

The stack is full-descending. Here we make space for x29 and x30 in the 
stack (16bytes) and save the two registers

>> +
>> +	// Align sp; this is necessary due to way we store cpu0's thread_info
> 
> /* */ comment style
> 

ack

>>   	mov		x29, sp
>> +	and		x29, x29, #THREAD_MASK
>> +	mov		x30, sp
>> +	mov		sp, x29
>> +	str		x30, [sp, #-32]!
>> +

Here we're making space in the stack for the old sp (x30), x0 and x1 but 
we have to also ensure that the sp is aligned (32bytes). The we store x30.

(As a side note, I could also change this to

+	str		x30, [sp, #-16]!

and change the next stp to do pre-incrementing mode. This might make 
things simpler.)

>> +	mov             x29, sp
>>   
>>   	stp		x0, x1, [sp, #16]
>> +

Here, we use the space we made before to store x0 and x1.

I think, the stack now should look like:

        |   ...  |
        |   x30  |
        |   x29  |
        |   x1   |
        |   x0   |
        |   pad  |
sp ->  | old_sp |


>>   	mov		x2, x0
>>   	mov		x3, x1
>>   	adr		x0, ImageBase
>> @@ -126,5 +135,9 @@ _start:
>>   	ldp		x0, x1, [sp, #16]
>>   	bl		efi_main
>>   
>> -0:	ldp		x29, x30, [sp], #32
>> +	// Restore sp
> 
> /* */ comment style

ack

> 
>> +	ldr		x30, [sp]

I think this should have been:

+	ldr		x30, [sp], #32

Restore x30 from the current sp and free up space in the stack (all 
32bytes).

> 
> I'm not able to understand this. Is this ldr restoring the value pushed
> with "str x30, [sp, #-32]!" above? in that case, shouldn't this be at
> [sp - 32]? But, given that this code is unreachable when efi_main is
> called, do you even need to restore the sp?
> 
>> +	mov             sp, x30
>> +
>> +0:	ldp		x29, x30, [sp], #16

Then, this restores x29 and x30 and frees up the the corresponding space 
in the stack.


I am not sure we shouldn't get to this point and I wanted to properly 
save and restore the register state. I haven't really found what's the 
right/best way to exit from an EFI app and I wanted to allow for 
graceful return from this point. But I am happy to change all this.

Thanks,

Nikos

>>   	ret
>> -- 
>> 2.25.1
>>
