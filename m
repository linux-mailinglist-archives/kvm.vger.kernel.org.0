Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7504F2CA9D6
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 18:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbgLARgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 12:36:51 -0500
Received: from foss.arm.com ([217.140.110.172]:47030 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgLARgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 12:36:50 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 078E2101E;
        Tue,  1 Dec 2020 09:36:05 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E5F03F575;
        Tue,  1 Dec 2020 09:36:04 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 01/10] lib: arm/arm64: gicv3: Add missing
 barrier when sending IPIs
To:     Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-2-alexandru.elisei@arm.com>
 <c92e0793-d204-0a84-2f6e-8cbd6c455da2@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d4ea93b8-e275-11db-4c97-a697caa39516@arm.com>
Date:   Tue, 1 Dec 2020 17:37:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <c92e0793-d204-0a84-2f6e-8cbd6c455da2@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

Thank you so much for having a look at the patches!

On 12/1/20 4:37 PM, Auger Eric wrote:
> Hi Alexandru,
>
> On 11/25/20 4:51 PM, Alexandru Elisei wrote:
>> One common usage for IPIs is for one CPU to write to a shared memory
>> location, send the IPI to kick another CPU, and the receiver to read from
>> the same location. Proper synchronization is needed to make sure that the
>> IPI receiver reads the most recent value and not stale data (for example,
>> the write from the sender CPU might still be in a store buffer).
>>
>> For GICv3, IPIs are generated with a write to the ICC_SGI1R_EL1 register.
>> To make sure the memory stores are observable by other CPUs, we need a
>> wmb() barrier (DSB ST), which waits for stores to complete.
>>
>> From the definition of DSB from ARM DDI 0487F.b, page B2-139:
>>
>> "In addition, no instruction that appears in program order after the DSB
>> instruction can alter any state of the system or perform any part of its
>> functionality until the DSB completes other than:
>>
>> - Being fetched from memory and decoded.
>> - Reading the general-purpose, SIMD and floating-point, Special-purpose, or
>> System registers that are directly or indirectly read without causing
>> side-effects."
>>
>> Similar definition for armv7 (ARM DDI 0406C.d, page A3-150).
>>
>> The DSB instruction is enough to prevent reordering of the GIC register
>> write which comes in program order after the memory access.
>>
>> This also matches what the Linux GICv3 irqchip driver does (commit
>> 21ec30c0ef52 ("irqchip/gic-v3: Use wmb() instead of smb_wmb() in
>> gic_raise_softirq()")).
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  lib/arm/gic-v3.c | 3 +++
>>  arm/gic.c        | 2 ++
>>  2 files changed, 5 insertions(+)
>>
>> diff --git a/lib/arm/gic-v3.c b/lib/arm/gic-v3.c
>> index a7e2cb819746..a6afa42d5fbe 100644
>> --- a/lib/arm/gic-v3.c
>> +++ b/lib/arm/gic-v3.c
>> @@ -77,6 +77,9 @@ void gicv3_ipi_send_mask(int irq, const cpumask_t *dest)
>>  
>>  	assert(irq < 16);
>>  
>> +	/* Ensure stores are visible to other CPUs before sending the IPI */
> nit: stores to normal memory ...

Yes, you are completely right. Specifying that it affects only stores to normal
memory would match the comment in the Linux irqchip driver and also what the
architecture specifies for device memory (page B2-158):

"Data accesses to memory locations are coherent for all observers in the system,
and correspondingly are treated as being Outer Shareable.
A memory location with any Device memory attribute cannot be allocated into a cache".

Same thing below, will change.

Thanks,

Alex

>> +	wmb();
>> +
>>  	/*
>>  	 * For each cpu in the mask collect its peers, which are also in
>>  	 * the mask, in order to form target lists.
>> diff --git a/arm/gic.c b/arm/gic.c
>> index acb060585fae..512c83636a2e 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -275,6 +275,8 @@ static void gicv3_ipi_send_self(void)
>>  
>>  static void gicv3_ipi_send_broadcast(void)
>>  {
>> +	/* Ensure stores are visible to other CPUs before sending the IPI */
> same
>> +	wmb();
>>  	gicv3_write_sgi1r(1ULL << 40 | IPI_IRQ << 24);
>>  	isb();
>>  }
>>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>
> Thanks
>
> Eric
>
