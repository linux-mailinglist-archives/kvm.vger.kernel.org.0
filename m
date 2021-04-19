Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFE136478C
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 17:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241396AbhDSP40 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 11:56:26 -0400
Received: from foss.arm.com ([217.140.110.172]:45322 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240347AbhDSP4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 11:56:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71C401435;
        Mon, 19 Apr 2021 08:55:54 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF1083F7D7;
        Mon, 19 Apr 2021 08:55:53 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 6/8] arm/arm64: setup: Consolidate memory
 layout assumptions
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-7-drjones@redhat.com>
 <aab892dc-6ef9-cfb5-7057-88ef7c692bba@arm.com>
 <20210415172526.msfseu2qwwb4jquc@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <49591da9-9d78-cdd8-3587-d535c148de31@arm.com>
Date:   Mon, 19 Apr 2021 16:56:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210415172526.msfseu2qwwb4jquc@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/15/21 6:25 PM, Andrew Jones wrote:
> On Thu, Apr 15, 2021 at 05:59:19PM +0100, Alexandru Elisei wrote:
>> Hi Drew,
>>
>> On 4/7/21 7:59 PM, Andrew Jones wrote:
>>> Keep as much memory layout assumptions as possible in init::start
>>> and a single setup function. This prepares us for calling setup()
>>> from different start functions which have been linked with different
>>> linker scripts. To do this, stacktop is only referenced from
>>> init::start, making freemem_start a parameter to setup(). We also
>>> split mem_init() into three parts, one that populates the mem regions
>>> per the DT, one that populates the mem regions per assumptions,
>>> and one that does the mem init. The concept of a primary region
>>> is dropped, but we add a sanity check for the absence of memory
>>> holes, because we don't know how to deal with them yet.
>>>
>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>> ---
>>>  arm/cstart.S        |   4 +-
>>>  arm/cstart64.S      |   2 +
>>>  arm/flat.lds        |  23 ++++++
>>>  lib/arm/asm/setup.h |   8 +--
>>>  lib/arm/mmu.c       |   2 -
>>>  lib/arm/setup.c     | 165 ++++++++++++++++++++++++--------------------
>>>  6 files changed, 123 insertions(+), 81 deletions(-)
>>>
>>> diff --git a/arm/cstart.S b/arm/cstart.S
>>> index 731f841695ce..14444124c43f 100644
>>> --- a/arm/cstart.S
>>> +++ b/arm/cstart.S
>>> @@ -80,7 +80,9 @@ start:
>>>  
>>>  	/* complete setup */
>>>  	pop	{r0-r1}
>>> -	bl	setup
>>> +	mov	r1, #0
>> Doesn't that mean that for arm, the second argument to setup() will be 0 instead
>> of stacktop?
> The second argument is 64-bit, but we assume the upper 32 are zero.

I didn't realize that phys_addr_t is 64bit.

According to ARM IHI 0042F, page 15:

"A double-word sized type is passed in two consecutive registers (e.g., r0 and r1,
or r2 and r3). The content of the registers is as if the value had been loaded
from memory representation with a single LDM instruction."

I think r3 should be zeroed, not r1. r2 and r3 represent the 64bit value. arm is
little endian, so the least significant 32bits will be in r2 and the most
significant bits will be in r3. I can't figure out why r3 is zero, but moving the
value 1 into r3 just before calling setup will make the assert that freemem_start
< 3GiB fail.

Thanks,

Alex

