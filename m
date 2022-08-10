Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95AB58EA2C
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 12:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbiHJKBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 06:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiHJKBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 06:01:03 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 254C756BBB
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 03:01:01 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82C711FB;
        Wed, 10 Aug 2022 03:01:01 -0700 (PDT)
Received: from [192.168.12.23] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6295B3F70D;
        Wed, 10 Aug 2022 03:00:59 -0700 (PDT)
Message-ID: <976c1d7b-a95d-cb5f-3602-55573e40289a@arm.com>
Date:   Wed, 10 Aug 2022 11:00:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests RFC PATCH 09/19] arm/arm64: Zero secondary CPUs'
 stack
Content-Language: en-GB
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
 <20220809091558.14379-10-alexandru.elisei@arm.com>
 <38ec5559-7c2a-9820-724d-6a192ea83ecb@arm.com>
 <YvN9oLwmCESQoFun@monolith.localdoman>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <YvN9oLwmCESQoFun@monolith.localdoman>
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

On 10/08/2022 10:42, Alexandru Elisei wrote:
> Hi Nikos,
> 
> On Tue, Aug 09, 2022 at 01:56:13PM +0100, Nikos Nikoleris wrote:
>> On 09/08/2022 10:15, Alexandru Elisei wrote:
>>> For the boot CPU, the entire stack is zeroed in the entry code. For the
>>> secondaries, only struct thread_info, which lives at the bottom of the
>>> stack, is zeroed in thread_info_init().
>>>
>>
>> That's a good point.
>>
>>> Be consistent and zero the entire stack for the secondaries. This should
>>> also improve reproducibility of the testsuite, as all the stacks now start
>>> with the same contents, which is zero. And now that all the stacks are
>>> zeroed in the entry code, there is no need to explicitely zero struct
>>> thread_info in thread_info_init().
>>>
>>
>> Wouldn't it make more sense to call memset(sp, 0, THREAD_SIZE); from
>> thread_stack_alloc() instead and avoid doing this in assembly? Do we expect
> 
> I prefer to do the zero'ing in assembly because:
> 
> 1. For consistency, which is one of the main reasons this patch exists.
> 
> 2. I don't want to deal with all the cache maintenance that is required for
> inter-CPU communication. Let's keep it simple.
> 

I see that's a very good point. For this reason, I agree initializing to 
0 is better done locally.

Since you brought this up, we might have to worry about the thread_info 
fields we initialize in __thread_info_init(). But this is a problem for 
another patch.

Reviewed-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Thanks,

Nikos

>> anyone to jump to secondary_entry without calling thread_stack_alloc()
>> first?
> 
> It's impossible to jump to secondary_data.entry without allocating the
> stack first, because it's impossible to run C code without a valid stack.
>  > Thanks,
> Alex
> 
>>
>> Thanks,
>>
>> Nikos
>>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>    arm/cstart.S          | 6 ++++++
>>>    arm/cstart64.S        | 3 +++
>>>    lib/arm/processor.c   | 1 -
>>>    lib/arm64/processor.c | 1 -
>>>    4 files changed, 9 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arm/cstart.S b/arm/cstart.S
>>> index 39260e0fa470..39e70f40986a 100644
>>> --- a/arm/cstart.S
>>> +++ b/arm/cstart.S
>>> @@ -151,7 +151,13 @@ secondary_entry:
>>>    	 */
>>>    	ldr	r1, =secondary_data
>>>    	ldr	r0, [r1]
>>> +	mov	r2, r0
>>> +	lsr	r2, #THREAD_SHIFT
>>> +	lsl	r2, #THREAD_SHIFT
>>> +	add	r3, r2, #THREAD_SIZE
>>> +	zero_range r2, r3, r4, r5
>>>    	mov	sp, r0
>>> +
>>>    	bl	exceptions_init
>>>    	bl	enable_vfp
>>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>>> index d62360cf3859..54773676d1d5 100644
>>> --- a/arm/cstart64.S
>>> +++ b/arm/cstart64.S
>>> @@ -156,6 +156,9 @@ secondary_entry:
>>>    	/* set the stack */
>>>    	adrp	x0, secondary_data
>>>    	ldr	x0, [x0, :lo12:secondary_data]
>>> +	and	x1, x0, #THREAD_MASK
>>> +	add	x2, x1, #THREAD_SIZE
>>> +	zero_range x1, x2
>>>    	mov	sp, x0
>>>    	/* finish init in C code */
>>> diff --git a/lib/arm/processor.c b/lib/arm/processor.c
>>> index 9d5759686b73..ceff1c0a1bd2 100644
>>> --- a/lib/arm/processor.c
>>> +++ b/lib/arm/processor.c
>>> @@ -117,7 +117,6 @@ void do_handle_exception(enum vector v, struct pt_regs *regs)
>>>    void thread_info_init(struct thread_info *ti, unsigned int flags)
>>>    {
>>> -	memset(ti, 0, sizeof(struct thread_info));
>>>    	ti->cpu = mpidr_to_cpu(get_mpidr());
>>>    	ti->flags = flags;
>>>    }
>>> diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
>>> index 831207c16587..268b2858f0be 100644
>>> --- a/lib/arm64/processor.c
>>> +++ b/lib/arm64/processor.c
>>> @@ -232,7 +232,6 @@ void install_vector_handler(enum vector v, vector_fn fn)
>>>    static void __thread_info_init(struct thread_info *ti, unsigned int flags)
>>>    {
>>> -	memset(ti, 0, sizeof(struct thread_info));
>>>    	ti->cpu = mpidr_to_cpu(get_mpidr());
>>>    	ti->flags = flags;
>>>    }
