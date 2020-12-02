Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC732CBEF1
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 15:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgLBOB5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 09:01:57 -0500
Received: from foss.arm.com ([217.140.110.172]:40694 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgLBOB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 09:01:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16D8F1063;
        Wed,  2 Dec 2020 06:01:11 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D0F83F718;
        Wed,  2 Dec 2020 06:01:10 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 03/10] arm/arm64: gic: Remove memory
 synchronization from ipi_clear_active_handler()
To:     Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-4-alexandru.elisei@arm.com>
 <038402be-a119-c162-04f2-d32db26e8a96@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <df9e2243-008b-3f93-e499-98b887b6c848@arm.com>
Date:   Wed, 2 Dec 2020 14:02:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <038402be-a119-c162-04f2-d32db26e8a96@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 12/1/20 4:37 PM, Auger Eric wrote:
> Hi Alexandru,
>
> On 11/25/20 4:51 PM, Alexandru Elisei wrote:
>> The gicv{2,3}-active test sends an IPI from the boot CPU to itself, then
>> checks that the interrupt has been received as expected. There is no need
>> to use inter-processor memory synchronization primitives on code that runs
>> on the same CPU, so remove the unneeded memory barriers.
>>
>> The arrays are modified asynchronously (in the interrupt handler) and it is
>> possible for the compiler to infer that they won't be changed during normal
>> program flow and try to perform harmful optimizations (like stashing a
>> previous read in a register and reusing it). To prevent this, for GICv2,
>> the smp_wmb() in gicv2_ipi_send_self() is replaced with a compiler barrier.
>> For GICv3, the wmb() barrier in gic_ipi_send_single() already implies a
>> compiler barrier.
>>
>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> ---
>>  arm/gic.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arm/gic.c b/arm/gic.c
>> index 401ffafe4299..4e947e8516a2 100644
>> --- a/arm/gic.c
>> +++ b/arm/gic.c
>> @@ -12,6 +12,7 @@
>>   * This work is licensed under the terms of the GNU LGPL, version 2.
>>   */
>>  #include <libcflat.h>
>> +#include <linux/compiler.h>
>>  #include <errata.h>
>>  #include <asm/setup.h>
>>  #include <asm/processor.h>
>> @@ -260,7 +261,8 @@ static void check_lpi_hits(int *expected, const char *msg)
>>  
>>  static void gicv2_ipi_send_self(void)
>>  {> -	smp_wmb();
> nit: previous patch added it and this patch removes it. maybe squash the
> modifs into the previous patch saying only a barrier() is needed for self()?
You're right, this does look out of place. I'll merge this change into the
previous patch.
>> +	/* Prevent the compiler from optimizing memory accesses */
>> +	barrier();
>>  	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
>>  }
>>  
>> @@ -359,6 +361,7 @@ static struct gic gicv3 = {
>>  	},
>>  };
>>  
>> +/* Runs on the same CPU as the sender, no need for memory synchronization */
>>  static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>>  {
>>  	u32 irqstat = gic_read_iar();
>> @@ -375,13 +378,10 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>>  
>>  		writel(val, base + GICD_ICACTIVER);
>>  
>> -		smp_rmb(); /* pairs with wmb in stats_reset */
> the comment says it is paired with wmd in stats_reset. So is it OK to
> leave the associated wmb?

This patch removes multi-processor synchronization from the functions that run on
the same CPU. stats_reset() can be called from one CPU (the IPI_SENDER CPU) and
the variables it modifies accessed by the interrupt handlers running on different
CPUs, like it happens for the IPI tests. In that case we do need the proper
barriers in place.

Thanks,

Alex

>>  		++acked[smp_processor_id()];
>>  		check_irqnr(irqnr);
>> -		smp_wmb(); /* pairs with rmb in check_acked */
> same here.
>>  	} else {
>>  		++spurious[smp_processor_id()];
>> -		smp_wmb();
>>  	}
>>  }
>>  
>>
> Thanks
>
> Eric
>
