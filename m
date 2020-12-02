Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088092CBEFD
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 15:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbgLBOFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 09:05:51 -0500
Received: from foss.arm.com ([217.140.110.172]:40842 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgLBOFv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 09:05:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3EF2C1063;
        Wed,  2 Dec 2020 06:05:06 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 841C83F718;
        Wed,  2 Dec 2020 06:05:05 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 04/10] arm/arm64: gic: Remove unnecessary
 synchronization with stats_reset()
To:     Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-5-alexandru.elisei@arm.com>
 <e7bd5d3a-831a-ba47-9fe3-b820c33e5972@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <313978c4-b35e-bcb7-c698-18ad2eb2b04a@arm.com>
Date:   Wed, 2 Dec 2020 14:06:17 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <e7bd5d3a-831a-ba47-9fe3-b820c33e5972@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 12/1/20 4:48 PM, Auger Eric wrote:
> Hi Alexandru,
>
> On 11/25/20 4:51 PM, Alexandru Elisei wrote:
>> The GICv3 driver executes a DSB barrier before sending an IPI, which
>> ensures that memory accesses have completed. This removes the need to
>> enforce ordering with respect to stats_reset() in the IPI handler.
>>
>> For GICv2, we still need the DMB to ensure ordering between the read of the
>> GICC_IAR MMIO register and the read from the acked array. It also matches
>> what the Linux GICv2 driver does in gic_handle_irq().
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/gic.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index 4e947e8516a2..7befda2a8673 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -60,7 +60,6 @@ static void stats_reset(void)
>>  		bad_sender[i] = -1;
>>  		bad_irq[i] = -1;
>>  	}
>> -	smp_wmb();
> Here we are (pair removed). Still the one in check_acked still exists.

The smp_rmb() from check_acked() is there to implement the message passing pattern
wrt the writes from the ipi_handler() function, not the writes from stats_reset().
See the next patch where I try to explain how the barriers should work.

Thanks,

Alex

>>  }
>>  
>>  static void check_acked(const char *testname, cpumask_t *mask)
>> @@ -150,7 +149,13 @@ static void ipi_handler(struct pt_regs *regs __unused)
>>  
>>  	if (irqnr != GICC_INT_SPURIOUS) {
>>  		gic_write_eoir(irqstat);
>> -		smp_rmb(); /* pairs with wmb in stats_reset */
>> +		/*
>> +		 * Make sure data written before the IPI was triggered is
>> +		 * observed after the IAR is read. Pairs with the smp_wmb
>> +		 * when sending the IPI.
>> +		 */
>> +		if (gic_version() == 2)
>> +			smp_rmb();
>>  		++acked[smp_processor_id()];
>>  		check_ipi_sender(irqstat);
>>  		check_irqnr(irqnr);
>>
> Thanks
>
> Eric
>
