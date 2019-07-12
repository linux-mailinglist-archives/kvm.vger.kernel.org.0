Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19E5766921
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 10:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfGLI3Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 04:29:24 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:24138 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfGLI3Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 04:29:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1562920161; x=1594456161;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=OEmdDLvFS0lvD5vL1UH7GzmD2FbqMFbnj7N2c9BGtD4=;
  b=CZhsPuGm2N9fBUfXszHhUVdBZQ/WBVLrGZgVlsIulWem+0swqxVyijNo
   3St2tLAXTyzswGFTP1A3a9o6D6eOpdA+2DUhf0e/xkgcF+EExQ0exEi0W
   eBiHV04bAnls/BNGWb07mCdhaa0P+Zg8qhjx74m7NjdxFiFEmp+ytypMv
   4=;
X-IronPort-AV: E=Sophos;i="5.62,481,1554768000"; 
   d="scan'208";a="815799163"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 12 Jul 2019 08:29:21 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-d0be17ee.us-west-2.amazon.com (Postfix) with ESMTPS id BFA12A2554;
        Fri, 12 Jul 2019 08:29:20 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 12 Jul 2019 08:29:19 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.161.88) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 12 Jul 2019 08:29:17 +0000
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To:     Marc Zyngier <marc.zyngier@arm.com>, <kvm@vger.kernel.org>
CC:     <kvmarm@lists.cs.columbia.edu>, Paolo Bonzini <pbonzini@redhat.com>
References: <20190710132724.28350-1-graf@amazon.com>
 <212cc76d-0d67-cb75-5f7f-d707778bbeff@arm.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <d2c7d9e4-c6e2-8437-66ae-b7d221090b5f@amazon.com>
Date:   Fri, 12 Jul 2019 10:29:15 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <212cc76d-0d67-cb75-5f7f-d707778bbeff@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.161.88]
X-ClientProxiedBy: EX13P01UWA001.ant.amazon.com (10.43.160.213) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.07.19 16:25, Marc Zyngier wrote:
> Hi Alex,
> 
> I don't know much about pl031, so my comments are pretty general...
> 
> On 10/07/2019 14:27, Alexander Graf wrote:
>> This patch adds a unit test for the PL031 RTC that is used in the virt machine.
>> It just pokes basic functionality. I've mostly written it to familiarize myself
>> with the device, but I suppose having the test around does not hurt, as it also
>> exercises the GIC SPI interrupt path.
>>
>> Signed-off-by: Alexander Graf <graf@amazon.com>
>> ---
>>   arm/Makefile.common |   1 +
>>   arm/pl031.c         | 227 ++++++++++++++++++++++++++++++++++++++++++++
>>   lib/arm/asm/gic.h   |   1 +
>>   3 files changed, 229 insertions(+)
>>   create mode 100644 arm/pl031.c
>>
>> diff --git a/arm/Makefile.common b/arm/Makefile.common
>> index f0c4b5d..b8988f2 100644
>> --- a/arm/Makefile.common
>> +++ b/arm/Makefile.common
>> @@ -11,6 +11,7 @@ tests-common += $(TEST_DIR)/pmu.flat
>>   tests-common += $(TEST_DIR)/gic.flat
>>   tests-common += $(TEST_DIR)/psci.flat
>>   tests-common += $(TEST_DIR)/sieve.flat
>> +tests-common += $(TEST_DIR)/pl031.flat
>>   
>>   tests-all = $(tests-common) $(tests)
>>   all: directories $(tests-all)
>> diff --git a/arm/pl031.c b/arm/pl031.c
>> new file mode 100644
>> index 0000000..a364a1a
>> --- /dev/null
>> +++ b/arm/pl031.c
>> @@ -0,0 +1,227 @@
>> +/*
>> + * Verify PL031 functionality
>> + *
>> + * This test verifies whether the emulated PL031 behaves correctly.
>> + *
>> + * Copyright 2019 Amazon.com, Inc. or its affiliates.
>> + * Author: Alexander Graf <graf@amazon.com>
>> + *
>> + * This work is licensed under the terms of the GNU LGPL, version 2.
>> + */
>> +#include <libcflat.h>
>> +#include <asm/processor.h>
>> +#include <asm/io.h>
>> +#include <asm/gic.h>
>> +
>> +static u32 cntfrq;
>> +
>> +#define PL031_BASE 0x09010000
>> +#define PL031_IRQ 2
> 
> Does the unit test framework have a way to extract this from the firmware tables?
> That'd be much nicer...

It does, I've moved it to that now :).

> 
>> +
>> +struct pl031_regs {
>> +	uint32_t dr;	/* Data Register */
>> +	uint32_t mr;	/* Match Register */
>> +	uint32_t lr;	/* Load Register */
>> +	union {
>> +		uint8_t cr;	/* Control Register */
>> +		uint32_t cr32;
>> +	};
>> +	union {
>> +		uint8_t imsc;	/* Interrupt Mask Set or Clear register */
>> +		uint32_t imsc32;
>> +	};
>> +	union {
>> +		uint8_t ris;	/* Raw Interrupt Status */
>> +		uint32_t ris32;
>> +	};
>> +	union {
>> +		uint8_t mis;	/* Masked Interrupt Status */
>> +		uint32_t mis32;
>> +	};
>> +	union {
>> +		uint8_t icr;	/* Interrupt Clear Register */
>> +		uint32_t icr32;
>> +	};
>> +	uint32_t reserved[1008];
>> +	uint32_t periph_id[4];
>> +	uint32_t pcell_id[4];
>> +};
>> +
>> +static struct pl031_regs *pl031 = (void*)PL031_BASE;
>> +static void *gic_ispendr;
>> +static void *gic_isenabler;
>> +static bool irq_triggered;
>> +
>> +static int check_id(void)
>> +{
>> +	uint32_t id[] = { 0x31, 0x10, 0x14, 0x00, 0x0d, 0xf0, 0x05, 0xb1 };
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(id); i++)
>> +		if (id[i] != readl(&pl031->periph_id[i]))
>> +			return 1;
>> +
>> +	return 0;
>> +}
>> +
>> +static int check_ro(void)
>> +{
>> +	uint32_t offs[] = { offsetof(struct pl031_regs, ris),
>> +			    offsetof(struct pl031_regs, mis),
>> +			    offsetof(struct pl031_regs, periph_id[0]),
>> +			    offsetof(struct pl031_regs, periph_id[1]),
>> +			    offsetof(struct pl031_regs, periph_id[2]),
>> +			    offsetof(struct pl031_regs, periph_id[3]),
>> +			    offsetof(struct pl031_regs, pcell_id[0]),
>> +			    offsetof(struct pl031_regs, pcell_id[1]),
>> +			    offsetof(struct pl031_regs, pcell_id[2]),
>> +			    offsetof(struct pl031_regs, pcell_id[3]) };
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(offs); i++) {
>> +		uint32_t before32;
>> +		uint16_t before16;
>> +		uint8_t before8;
>> +		void *addr = (void*)pl031 + offs[i];
>> +		uint32_t poison = 0xdeadbeefULL;
>> +
>> +		before8 = readb(addr);
>> +		before16 = readw(addr);
>> +		before32 = readl(addr);
>> +
>> +		writeb(poison, addr);
>> +		writew(poison, addr);
>> +		writel(poison, addr);
>> +
>> +		if (before8 != readb(addr))
>> +			return 1;
>> +		if (before16 != readw(addr))
>> +			return 1;
>> +		if (before32 != readl(addr))
>> +			return 1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int check_rtc_freq(void)
>> +{
>> +	uint32_t seconds_to_wait = 2;
>> +	uint32_t before = readl(&pl031->dr);
>> +	uint64_t before_tick = read_sysreg(cntpct_el0);
> 
> Hmmm. See below.
> 
>> +	uint64_t target_tick = before_tick + (cntfrq * seconds_to_wait);
>> +
>> +	/* Wait for 2 seconds */
>> +	while (read_sysreg(cntpct_el0) < target_tick) ;
> 
> Careful here. The control dependency saves you, but in general we want
> to guarantee some stronger ordering when it comes to the counter. The
> Linux kernel has the following:
> 
> /*
>   * Ensure that reads of the counter are treated the same as memory reads
>   * for the purposes of ordering by subsequent memory barriers.
>   *
>   * This insanity brought to you by speculative system register reads,
>   * out-of-order memory accesses, sequence locks and Thomas Gleixner.
>   *
>   * http://lists.infradead.org/pipermail/linux-arm-kernel/2019-February/631195.html
>   */
> #define arch_counter_enforce_ordering(val) do {                         \
>          u64 tmp, _val = (val);                                          \
>                                                                          \
>          asm volatile(                                                   \
>          "       eor     %0, %1, %1\n"                                   \
>          "       add     %0, sp, %0\n"                                   \
>          "       ldr     xzr, [%0]"                                      \
>          : "=r" (tmp) : "r" (_val));                                     \
> } while (0)
> 
> static __always_inline u64 __arch_counter_get_cntpct_stable(void)
> {
>          u64 cnt;
> 
>          isb();
>          cnt = arch_timer_reg_read_stable(cntpct_el0);
>          arch_counter_enforce_ordering(cnt);
>          return cnt;
> }
> 
> The initial ISB prevents the counter read from being reordered with earlier
> instructions, while the fake memory dependency enforces ordering with
> subsequent memory accesses. You're welcome ;-).

Do we really care enough in this case? It seems a bit overkill. The 
worst thing that happens is that we wiggle around the 2 second mark a 
bit and don't hit it right on the spot, no?

> 
>> +
>> +	if (readl(&pl031->dr) != before + seconds_to_wait)
>> +		return 1;
>> +
>> +	return 0;
>> +}
>> +
>> +static bool gic_irq_pending(void)
>> +{
>> +	return readl(gic_ispendr + 4) & (1 << (SPI(PL031_IRQ) - 32));
> 
> nit: you may want to make the offset depend on the interrupt itself...

Yes, definitely :).

> 
>> +}
>> +
>> +static void gic_irq_unmask(void)
>> +{
>> +	writel(1 << (SPI(PL031_IRQ) - 32), gic_isenabler + 4);
>> +}
>> +
>> +static void irq_handler(struct pt_regs *regs)
>> +{
>> +	u32 irqstat = gic_read_iar();
> 
> GICv3 requires a DSB SY after reading IAR. Is that included in gic_read_iar()?

Looks like it:

static inline u32 gicv3_read_iar(void)
{
         u64 irqstat;
         asm volatile("mrs_s %0, " xstr(ICC_IAR1_EL1) : "=r" (irqstat));
         dsb(sy);
         return (u64)irqstat;
}

Looks like Andre reviewed the code that introduced the GIC logic well :).

> 
>> +	u32 irqnr = gic_iar_irqnr(irqstat);
>> +
>> +	if (irqnr != GICC_INT_SPURIOUS)
>> +		gic_write_eoir(irqstat);
> 
> You can always EOI spurious. Are you guaranteed to be in EOImode==0?
> If not, you'd need an extra write to DIR. Also, this needs an ISB

I copied that bit from the timer test. I'll be happy to remove the 
spurious check though.

We have the following in gicv3_enable_defaults() which IIUC clears the 
EOImode bit, right?

         writel(GICD_CTLR_ARE_NS | GICD_CTLR_ENABLE_G1A | 
GICD_CTLR_ENABLE_G1,
                dist + GICD_CTLR);

> for GICv3.

The ISB is there already:

static inline void gicv3_write_eoir(u32 irq)
{
         asm volatile("msr_s " xstr(ICC_EOIR1_EL1) ", %0" : : "r" 
((u64)irq));
         isb();
}

> 
>> +
>> +	if (irqnr == SPI(PL031_IRQ)) {
>> +		report("  RTC RIS == 1", readl(&pl031->ris) == 1);
>> +		report("  RTC MIS == 1", readl(&pl031->mis) == 1);
>> +
>> +		/* Writing any value should clear IRQ status */
>> +		writel(0x80000000ULL, &pl031->icr);
>> +
>> +		report("  RTC RIS == 0", readl(&pl031->ris) == 0);
>> +		report("  RTC MIS == 0", readl(&pl031->mis) == 0);
>> +		irq_triggered = true;
>> +	} else {
>> +		report_info("Unexpected interrupt: %d\n", irqnr);
>> +		return;
>> +	}
>> +}
>> +
>> +static int check_rtc_irq(void)
>> +{
>> +	uint32_t seconds_to_wait = 1;
>> +	uint32_t before = readl(&pl031->dr);
>> +	uint64_t before_tick = read_sysreg(cntpct_el0);
> 
> Same problem as above.
> 
>> +	uint64_t target_tick = before_tick + (cntfrq * (seconds_to_wait + 1));
>> +
>> +	report_info("Checking IRQ trigger (MR)");
>> +
>> +	irq_triggered = false;
>> +
>> +	/* Fire IRQ in 1 second */
>> +	writel(before + seconds_to_wait, &pl031->mr);
>> +
>> +	install_irq_handler(EL1H_IRQ, irq_handler);
>> +
>> +	/* Wait until 2 seconds are over */
>> +	while (read_sysreg(cntpct_el0) < target_tick) ;
>> +
>> +	report("  RTC IRQ not delivered without mask", !gic_irq_pending());
>> +
>> +	/* Mask the IRQ so that it gets delivered */
>> +	writel(1, &pl031->imsc);
>> +	report("  RTC IRQ pending now", gic_irq_pending());
>> +
>> +	/* Enable retrieval of IRQ */
>> +	gic_irq_unmask();
>> +	local_irq_enable();
>> +
>> +	report("  IRQ triggered", irq_triggered);
>> +	report("  RTC IRQ not pending anymore", !gic_irq_pending());
>> +	if (!irq_triggered) {
>> +		report_info("  RTC RIS: %x", readl(&pl031->ris));
>> +		report_info("  RTC MIS: %x", readl(&pl031->mis));
>> +		report_info("  RTC IMSC: %x", readl(&pl031->imsc));
>> +		report_info("  GIC IRQs pending: %08x %08x", readl(gic_ispendr), readl(gic_ispendr + 4));
>> +	}
>> +
>> +	local_irq_disable();
>> +	return 0;
>> +}
>> +
>> +static void rtc_irq_init(void)
>> +{
>> +	gic_enable_defaults();
>> +
>> +	switch (gic_version()) {
>> +	case 2:
>> +		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
>> +		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
>> +		break;
>> +	case 3:
>> +		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
>> +		gic_isenabler = gicv3_sgi_base() + GICD_ISENABLER;
> 
> This only points to SGIs and PPIs. How does it work on GICv3?
> Let me guess: you haven't tested it... ;-)

I tested it, then it failed, then I forgot about it :)

I take it that on GICv3, SPIs live somewhere else?


Alex
