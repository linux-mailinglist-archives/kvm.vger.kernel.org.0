Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 456FA5618BB
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 13:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234395AbiF3LIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 07:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiF3LIt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 07:08:49 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1BD0320F66
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 04:08:46 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D236B1042;
        Thu, 30 Jun 2022 04:08:46 -0700 (PDT)
Received: from [10.57.42.161] (unknown [10.57.42.161])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E09D3F5A1;
        Thu, 30 Jun 2022 04:08:44 -0700 (PDT)
Message-ID: <16eda3c9-ec36-cd45-5c1a-0307f60dbc5f@arm.com>
Date:   Thu, 30 Jun 2022 12:08:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [kvm-unit-tests PATCH v3 15/27] arm/arm64: mmu_disable: Clean and
 invalidate before disabling
Content-Language: en-GB
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        andrew.jones@linux.dev, pbonzini@redhat.com, jade.alglave@arm.com,
        ricarkol@google.com
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-16-nikos.nikoleris@arm.com>
 <Yr1480um3Blh078q@monolith.localdoman>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <Yr1480um3Blh078q@monolith.localdoman>
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

Hi Alex,

On 30/06/2022 11:20, Alexandru Elisei wrote:
> Hi,
> 
> On Thu, Jun 30, 2022 at 11:03:12AM +0100, Nikos Nikoleris wrote:
>> From: Andrew Jones <drjones@redhat.com>
>>
>> The commit message of commit 410b3bf09e76 ("arm/arm64: Perform dcache
>> clean + invalidate after turning MMU off") justifies cleaning and
>> invalidating the dcache after disabling the MMU by saying it's nice
>> not to rely on the current page tables and that it should still work
>> (per the spec), as long as there's an identity map in the current
>> tables. Doing the invalidation after also somewhat helped with
>> reenabling the MMU without seeing stale data, but the real problem
>> with reenabling was because the cache needs to be disabled with
>> the MMU, but it wasn't.
>>
>> Since we have to trust/validate that the current page tables have an
>> identity map anyway, then there's no harm in doing the clean
>> and invalidate first (it feels a little better to do so, anyway,
>> considering the cache maintenance instructions take virtual
>> addresses). Then, also disable the cache with the MMU to avoid
>> problems when reenabling. We invalidate the Icache and disable
>> that too for good measure. And, a final TLB invalidation ensures
>> we're crystal clean when we return from asm_mmu_disable().
> 
> I'll point you to my previous reply [1] to this exact patch which explains
> why it's incorrect and is only papering over another problem.
> 
> [1] https://lore.kernel.org/all/Yn5Z6Kyj62cUNgRN@monolith.localdoman/
> 

Apologies, I didn't mean to ignore your feedback on this. There was a 
parallel discussion in [2] which I thought makes the problem more concrete.

This is Drew's patch as soon as he confirms he's also happy with the 
change you suggested in the patch description I am happy to make it.

Generally, a test will start off with the MMU enabled. At this point, we 
access code, use and modify data (EfiLoaderData, EfiLoaderCode). Any of 
the two regions could be mapped as any type of memory (I need to have 
another look to confirm if it's Normal Memory). Then we want to take 
over control of the page tables and for that reason we have to switch 
off the MMU. And any access to code or data will be with Device-nGnRnE 
as you pointed out. If we don't clean and invalidate, instructions and 
data might be in the cache and we will be mixing memory attributes, 
won't we?

[2]: 
https://lore.kernel.org/all/6c5a3ef7-3742-c4e9-5a94-c702a5b3ebca@arm.com/

Thanks,

Nikos

> Thanks,
> Alex
> 
>>
>> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   arm/cstart.S   | 28 +++++++++++++++++++++-------
>>   arm/cstart64.S | 21 ++++++++++++++++-----
>>   2 files changed, 37 insertions(+), 12 deletions(-)
>>
>> diff --git a/arm/cstart.S b/arm/cstart.S
>> index 7036e67..dc324c5 100644
>> --- a/arm/cstart.S
>> +++ b/arm/cstart.S
>> @@ -179,6 +179,7 @@ halt:
>>   .globl asm_mmu_enable
>>   asm_mmu_enable:
>>   	/* TLBIALL */
>> +	mov	r2, #0
>>   	mcr	p15, 0, r2, c8, c7, 0
>>   	dsb	nsh
>>   
>> @@ -211,12 +212,7 @@ asm_mmu_enable:
>>   
>>   .globl asm_mmu_disable
>>   asm_mmu_disable:
>> -	/* SCTLR */
>> -	mrc	p15, 0, r0, c1, c0, 0
>> -	bic	r0, #CR_M
>> -	mcr	p15, 0, r0, c1, c0, 0
>> -	isb
>> -
>> +	/* Clean + invalidate the entire memory */
>>   	ldr	r0, =__phys_offset
>>   	ldr	r0, [r0]
>>   	ldr	r1, =__phys_end
>> @@ -224,7 +220,25 @@ asm_mmu_disable:
>>   	sub	r1, r1, r0
>>   	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
>>   
>> -	mov     pc, lr
>> +	/* Invalidate Icache */
>> +	mov	r0, #0
>> +	mcr	p15, 0, r0, c7, c5, 0
>> +	isb
>> +
>> +	/*  Disable cache, Icache and MMU */
>> +	mrc	p15, 0, r0, c1, c0, 0
>> +	bic	r0, #CR_C
>> +	bic	r0, #CR_I
>> +	bic	r0, #CR_M
>> +	mcr	p15, 0, r0, c1, c0, 0
>> +	isb
>> +
>> +	/* Invalidate TLB */
>> +	mov	r0, #0
>> +	mcr	p15, 0, r0, c8, c7, 0
>> +	dsb	nsh
>> +
>> +	mov	pc, lr
>>   
>>   /*
>>    * Vectors
>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>> index e4ab7d0..390feb9 100644
>> --- a/arm/cstart64.S
>> +++ b/arm/cstart64.S
>> @@ -246,11 +246,6 @@ asm_mmu_enable:
>>   
>>   .globl asm_mmu_disable
>>   asm_mmu_disable:
>> -	mrs	x0, sctlr_el1
>> -	bic	x0, x0, SCTLR_EL1_M
>> -	msr	sctlr_el1, x0
>> -	isb
>> -
>>   	/* Clean + invalidate the entire memory */
>>   	adrp	x0, __phys_offset
>>   	ldr	x0, [x0, :lo12:__phys_offset]
>> @@ -259,6 +254,22 @@ asm_mmu_disable:
>>   	sub	x1, x1, x0
>>   	dcache_by_line_op civac, sy, x0, x1, x2, x3
>>   
>> +	/* Invalidate Icache */
>> +	ic	iallu
>> +	isb
>> +
>> +	/* Disable cache, Icache and MMU */
>> +	mrs	x0, sctlr_el1
>> +	bic	x0, x0, SCTLR_EL1_C
>> +	bic	x0, x0, SCTLR_EL1_I
>> +	bic	x0, x0, SCTLR_EL1_M
>> +	msr	sctlr_el1, x0
>> +	isb
>> +
>> +	/* Invalidate TLB */
>> +	tlbi	vmalle1
>> +	dsb	nsh
>> +
>>   	ret
>>   
>>   /*
>> -- 
>> 2.25.1
>>
