Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A88D0565094
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 11:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233510AbiGDJTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 05:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiGDJTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 05:19:02 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29A8A1A8
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 02:19:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34BB323A;
        Mon,  4 Jul 2022 02:19:01 -0700 (PDT)
Received: from [10.57.41.161] (unknown [10.57.41.161])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FEA33F792;
        Mon,  4 Jul 2022 02:18:59 -0700 (PDT)
Message-ID: <85cd533a-019a-aa8f-c18d-6d2e02026467@arm.com>
Date:   Mon, 4 Jul 2022 10:18:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v3 22/27] arm64: Use code from the gnu-efi
 when booting with EFI
Content-Language: en-GB
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, andrew.jones@linux.dev, drjones@redhat.com,
        pbonzini@redhat.com, jade.alglave@arm.com, alexandru.elisei@arm.com
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-23-nikos.nikoleris@arm.com>
 <Yr5DRYxK65G4R8Zh@google.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <Yr5DRYxK65G4R8Zh@google.com>
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

On 01/07/2022 01:43, Ricardo Koller wrote:
> On Thu, Jun 30, 2022 at 11:03:19AM +0100, Nikos Nikoleris wrote:
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
>>   arm/efi/crt0-efi-aarch64.S | 21 +++++++++++++++++----
>>   2 files changed, 23 insertions(+), 4 deletions(-)
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
>> index d50e78d..03d29b0 100644
>> --- a/arm/efi/crt0-efi-aarch64.S
>> +++ b/arm/efi/crt0-efi-aarch64.S
>> @@ -111,10 +111,19 @@ section_table:
>>   
>>   	.align		12
>>   _start:
>> -	stp		x29, x30, [sp, #-32]!
>> +	stp		x29, x30, [sp, #-16]!
>> +
>> +	/* Align sp; this is necessary due to way we store cpu0's thread_info */
>>   	mov		x29, sp
>> +	and		x29, x29, #THREAD_MASK
>> +	mov		x30, sp
>> +	mov		sp, x29
>> +	str		x30, [sp, #-16]!
>> +
>> +	mov             x29, sp
> 
> I wasn't sure what was this x29 for. But after some googling, this is
> what I found [0]:
> 
> 	The frame pointer (X29) should point to the previous frame pointer saved
> 	on stack, with the saved LR (X30) stored after it.
> 
> The old code ended up with x29 pointing to the right place: the previous
> (x29,x30).
> 
> 	|   ...  |
> 	|   x1   |
> 	|   x0   |
> 	|   x30  |
> x29 ->	|   x29  |
> 
> In the new code x29 is pointing to:
> 
> 	|   ...  |
> 	|   x30  |
> old_sp->|   x29  |
> 	|   ...  |
> 	|   x1   |
> 	|   x0   |
> 	|   pad  |
> x29 ->	| old_sp |
> 
> I think the new version can be fixed by setting x29 to the old_sp,
> conveniently stored in x30:

That's a good point, I'll swap x29 with x30 (x29 saves the old sp and 
x30 is used to calculate the new value for sp) to make sure that x29 
points to the right location in the stack.

Thanks,

Nikos

> 
> +	mov             x30, sp
> 
>> +
>> +	stp		x0, x1, [sp, #-16]!
>>   
>> -	stp		x0, x1, [sp, #16]
>>   	mov		x2, x0
>>   	mov		x3, x1
>>   	adr		x0, ImageBase
>> @@ -123,8 +132,12 @@ _start:
>>   	bl		_relocate
>>   	cbnz		x0, 0f
>>   
>> -	ldp		x0, x1, [sp, #16]
>> +	ldp		x0, x1, [sp], #16
>>   	bl		efi_main
>>   
>> -0:	ldp		x29, x30, [sp], #32
>> +	/* Restore sp */
>> +	ldr		x30, [sp], #16
>> +	mov             sp, x30
>> +
>> +0:	ldp		x29, x30, [sp], #16
>>   	ret
>> -- 
>> 2.25.1
>>
> 
> [0] https://developer.arm.com/documentation/den0024/a/The-ABI-for-ARM-64-bit-Architecture/Register-use-in-the-AArch64-Procedure-Call-Standard/Indirect-result-location
