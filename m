Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D849333C193
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 17:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhCOQW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 12:22:58 -0400
Received: from foss.arm.com ([217.140.110.172]:53522 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232328AbhCOQW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 12:22:26 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DBCD1FB;
        Mon, 15 Mar 2021 09:22:25 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 235C43F718;
        Mon, 15 Mar 2021 09:22:25 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 3/6] arm/arm64: Remove unnecessary ISB when
 doing dcache maintenance
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
 <20210227104201.14403-4-alexandru.elisei@arm.com>
 <20210312145950.whq7ofrhbklwhprx@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <2b6cd31a-ae8d-0fd6-dc82-583d73f79a9b@arm.com>
Date:   Mon, 15 Mar 2021 16:22:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210312145950.whq7ofrhbklwhprx@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 3/12/21 2:59 PM, Andrew Jones wrote:
> On Sat, Feb 27, 2021 at 10:41:58AM +0000, Alexandru Elisei wrote:
>> The dcache_by_line_op macro executes a DSB to complete the cache
>> maintenance operations. According to ARM DDI 0487G.a, page B2-150:
>>
>> "In addition, no instruction that appears in program order after the DSB
>> instruction can alter any state of the system or perform any part of its
>> functionality until the DSB completes other than:
>>
>> - Being fetched from memory and decoded.
>> - Reading the general-purpose, SIMD and floating-point, Special-purpose, or
>>   System registers that are directly or indirectly read without causing
>>   side-effects."
>>
>> Similar definition for ARM in ARM DDI 0406C.d, page A3-150:
>>
>> "In addition, no instruction that appears in program order after the DSB
>> instruction can execute until the DSB completes."
>>
>> This means that we don't need the ISB to prevent reordering of the cache
>> maintenance instructions.
>>
>> We are also not doing icache maintenance, where an ISB would be required
>> for the PE to discard instructions speculated before the invalidation.
>>
>> In conclusion, the ISB is unnecessary, so remove it.
> Hi Alexandru,
>
> We can go ahead and take this patch, since you've written quite a
> convincing commit message, but in general I'd prefer we be overly cautious
> in our common code. We'd like to ensure we don't introduce difficult to
> debug issues there, and we don't care about optimizations, let alone
> micro-optimizations. Testing barrier needs to the letter of the spec is a
> good idea, but it's probably better to do that in the test cases.

You are correct, the intention of this patch was to do the minimum necessary to
ensure correctness.

Thank you for the explanation, I will keep this in mind for future patches.

Thanks,

Alex

>
> Thanks,
> drew
>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/cstart.S   | 1 -
>>  arm/cstart64.S | 1 -
>>  2 files changed, 2 deletions(-)
>>
>> diff --git a/arm/cstart.S b/arm/cstart.S
>> index 954748b00f64..2d62c1e6d40d 100644
>> --- a/arm/cstart.S
>> +++ b/arm/cstart.S
>> @@ -212,7 +212,6 @@ asm_mmu_disable:
>>  	ldr	r1, [r1]
>>  	sub	r1, r1, r0
>>  	dcache_by_line_op dccimvac, sy, r0, r1, r2, r3
>> -	isb
>>  
>>  	mov     pc, lr
>>  
>> diff --git a/arm/cstart64.S b/arm/cstart64.S
>> index 046bd3914098..c1deff842f03 100644
>> --- a/arm/cstart64.S
>> +++ b/arm/cstart64.S
>> @@ -219,7 +219,6 @@ asm_mmu_disable:
>>  	ldr	x1, [x1, :lo12:__phys_end]
>>  	sub	x1, x1, x0
>>  	dcache_by_line_op civac, sy, x0, x1, x2, x3
>> -	isb
>>  
>>  	ret
>>  
>> -- 
>> 2.30.1
>>
