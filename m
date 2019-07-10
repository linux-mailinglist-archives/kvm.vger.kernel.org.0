Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0F3764882
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 16:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfGJOhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 10:37:21 -0400
Received: from foss.arm.com ([217.140.110.172]:34672 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbfGJOhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 10:37:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7250E2B;
        Wed, 10 Jul 2019 07:37:20 -0700 (PDT)
Received: from [10.1.196.217] (e121566-lin.cambridge.arm.com [10.1.196.217])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BB7823F71F;
        Wed, 10 Jul 2019 07:37:19 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] arm: Add PL031 test
To:     Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190710132724.28350-1-graf@amazon.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <02d19c57-a9d1-bef8-8a57-e289156c9f8a@arm.com>
Date:   Wed, 10 Jul 2019 15:37:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190710132724.28350-1-graf@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/10/19 2:27 PM, Alexander Graf wrote:
> This patch adds a unit test for the PL031 RTC that is used in the virt machine.
> It just pokes basic functionality. I've mostly written it to familiarize myself
> with the device, but I suppose having the test around does not hurt, as it also
> exercises the GIC SPI interrupt path.
>
> Signed-off-by: Alexander Graf <graf@amazon.com>
> ---
>  arm/Makefile.common |   1 +
>  arm/pl031.c         | 227 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/arm/asm/gic.h   |   1 +
>  3 files changed, 229 insertions(+)
>  create mode 100644 arm/pl031.c
>
> diff --git a/arm/Makefile.common b/arm/Makefile.common
> index f0c4b5d..b8988f2 100644
> --- a/arm/Makefile.common
> +++ b/arm/Makefile.common
> @@ -11,6 +11,7 @@ tests-common += $(TEST_DIR)/pmu.flat
>  tests-common += $(TEST_DIR)/gic.flat
>  tests-common += $(TEST_DIR)/psci.flat
>  tests-common += $(TEST_DIR)/sieve.flat
> +tests-common += $(TEST_DIR)/pl031.flat
>  
>  tests-all = $(tests-common) $(tests)
>  all: directories $(tests-all)
> diff --git a/arm/pl031.c b/arm/pl031.c
> new file mode 100644
> index 0000000..a364a1a
> --- /dev/null
> +++ b/arm/pl031.c
> @@ -0,0 +1,227 @@
> +/*
> + * Verify PL031 functionality
> + *
> + * This test verifies whether the emulated PL031 behaves correctly.
> + *
> + * Copyright 2019 Amazon.com, Inc. or its affiliates.
> + * Author: Alexander Graf <graf@amazon.com>
> + *
> + * This work is licensed under the terms of the GNU LGPL, version 2.
> + */
> +#include <libcflat.h>
> +#include <asm/processor.h>
> +#include <asm/io.h>
> +#include <asm/gic.h>
> +
> +static u32 cntfrq;
> +
> +#define PL031_BASE 0x09010000
> +#define PL031_IRQ 2
> +
> +struct pl031_regs {
> +	uint32_t dr;	/* Data Register */
> +	uint32_t mr;	/* Match Register */
> +	uint32_t lr;	/* Load Register */
> +	union {
> +		uint8_t cr;	/* Control Register */
> +		uint32_t cr32;
> +	};
> +	union {
> +		uint8_t imsc;	/* Interrupt Mask Set or Clear register */
> +		uint32_t imsc32;
> +	};
> +	union {
> +		uint8_t ris;	/* Raw Interrupt Status */
> +		uint32_t ris32;
> +	};
> +	union {
> +		uint8_t mis;	/* Masked Interrupt Status */
> +		uint32_t mis32;
> +	};
> +	union {
> +		uint8_t icr;	/* Interrupt Clear Register */
> +		uint32_t icr32;
> +	};
> +	uint32_t reserved[1008];
> +	uint32_t periph_id[4];
> +	uint32_t pcell_id[4];
> +};
> +
> +static struct pl031_regs *pl031 = (void*)PL031_BASE;
> +static void *gic_ispendr;
> +static void *gic_isenabler;
> +static bool irq_triggered;
> +
> +static int check_id(void)
> +{
> +	uint32_t id[] = { 0x31, 0x10, 0x14, 0x00, 0x0d, 0xf0, 0x05, 0xb1 };
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(id); i++)
> +		if (id[i] != readl(&pl031->periph_id[i]))
> +			return 1;
> +
> +	return 0;
> +}
> +
> +static int check_ro(void)
> +{
> +	uint32_t offs[] = { offsetof(struct pl031_regs, ris),
> +			    offsetof(struct pl031_regs, mis),
> +			    offsetof(struct pl031_regs, periph_id[0]),
> +			    offsetof(struct pl031_regs, periph_id[1]),
> +			    offsetof(struct pl031_regs, periph_id[2]),
> +			    offsetof(struct pl031_regs, periph_id[3]),
> +			    offsetof(struct pl031_regs, pcell_id[0]),
> +			    offsetof(struct pl031_regs, pcell_id[1]),
> +			    offsetof(struct pl031_regs, pcell_id[2]),
> +			    offsetof(struct pl031_regs, pcell_id[3]) };
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(offs); i++) {
> +		uint32_t before32;
> +		uint16_t before16;
> +		uint8_t before8;
> +		void *addr = (void*)pl031 + offs[i];
> +		uint32_t poison = 0xdeadbeefULL;
> +
> +		before8 = readb(addr);
> +		before16 = readw(addr);
> +		before32 = readl(addr);
> +
> +		writeb(poison, addr);
> +		writew(poison, addr);
> +		writel(poison, addr);
> +
> +		if (before8 != readb(addr))
> +			return 1;
> +		if (before16 != readw(addr))
> +			return 1;
> +		if (before32 != readl(addr))
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int check_rtc_freq(void)
> +{
> +	uint32_t seconds_to_wait = 2;
> +	uint32_t before = readl(&pl031->dr);
> +	uint64_t before_tick = read_sysreg(cntpct_el0);
> +	uint64_t target_tick = before_tick + (cntfrq * seconds_to_wait);
> +
> +	/* Wait for 2 seconds */
> +	while (read_sysreg(cntpct_el0) < target_tick) ;
> +
> +	if (readl(&pl031->dr) != before + seconds_to_wait)
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static bool gic_irq_pending(void)
> +{
> +	return readl(gic_ispendr + 4) & (1 << (SPI(PL031_IRQ) - 32));
> +}
> +
> +static void gic_irq_unmask(void)
> +{
> +	writel(1 << (SPI(PL031_IRQ) - 32), gic_isenabler + 4);
> +}
> +
> +static void irq_handler(struct pt_regs *regs)
> +{
> +	u32 irqstat = gic_read_iar();
> +	u32 irqnr = gic_iar_irqnr(irqstat);
> +
> +	if (irqnr != GICC_INT_SPURIOUS)
> +		gic_write_eoir(irqstat);
> +
> +	if (irqnr == SPI(PL031_IRQ)) {
> +		report("  RTC RIS == 1", readl(&pl031->ris) == 1);
> +		report("  RTC MIS == 1", readl(&pl031->mis) == 1);
> +
> +		/* Writing any value should clear IRQ status */
> +		writel(0x80000000ULL, &pl031->icr);
> +
> +		report("  RTC RIS == 0", readl(&pl031->ris) == 0);
> +		report("  RTC MIS == 0", readl(&pl031->mis) == 0);
> +		irq_triggered = true;
> +	} else {
> +		report_info("Unexpected interrupt: %d\n", irqnr);
> +		return;
> +	}
> +}
> +
> +static int check_rtc_irq(void)
> +{
> +	uint32_t seconds_to_wait = 1;
> +	uint32_t before = readl(&pl031->dr);
> +	uint64_t before_tick = read_sysreg(cntpct_el0);
> +	uint64_t target_tick = before_tick + (cntfrq * (seconds_to_wait + 1));
> +
> +	report_info("Checking IRQ trigger (MR)");
> +
> +	irq_triggered = false;
> +
> +	/* Fire IRQ in 1 second */
> +	writel(before + seconds_to_wait, &pl031->mr);
> +
> +	install_irq_handler(EL1H_IRQ, irq_handler);
> +
> +	/* Wait until 2 seconds are over */
> +	while (read_sysreg(cntpct_el0) < target_tick) ;
> +
> +	report("  RTC IRQ not delivered without mask", !gic_irq_pending());
> +
> +	/* Mask the IRQ so that it gets delivered */
> +	writel(1, &pl031->imsc);
> +	report("  RTC IRQ pending now", gic_irq_pending());
> +
> +	/* Enable retrieval of IRQ */
> +	gic_irq_unmask();
> +	local_irq_enable();
> +
> +	report("  IRQ triggered", irq_triggered);
> +	report("  RTC IRQ not pending anymore", !gic_irq_pending());
> +	if (!irq_triggered) {
> +		report_info("  RTC RIS: %x", readl(&pl031->ris));
> +		report_info("  RTC MIS: %x", readl(&pl031->mis));
> +		report_info("  RTC IMSC: %x", readl(&pl031->imsc));
> +		report_info("  GIC IRQs pending: %08x %08x", readl(gic_ispendr), readl(gic_ispendr + 4));
> +	}
> +
> +	local_irq_disable();
> +	return 0;
> +}
> +
> +static void rtc_irq_init(void)
> +{
> +	gic_enable_defaults();
> +
> +	switch (gic_version()) {
> +	case 2:
> +		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
> +		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
> +		break;
> +	case 3:
> +		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
> +		gic_isenabler = gicv3_sgi_base() + GICD_ISENABLER;
> +		break;
> +	}
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	cntfrq = get_cntfrq();
> +	rtc_irq_init();

The PL031 device might be generated by QEMU by default, but KVM-unit-tests can
also be run under kvmtool, which doesn't include such a device.

I suggest that you first check that the device is in the fdt, and skip the tests
entirely if it's not present. There's an example in the timer.c test about how
to find a device by using its compatible string. And as Marc suggested, you can
also use the fdt to get the device properties.

Thanks,
Alex
> +
> +	report("Periph/PCell IDs match", !check_id());
> +	report("R/O fields are R/O", !check_ro());
> +	report("RTC ticks at 1HZ", !check_rtc_freq());
> +	report("RTC IRQ not pending yet", !gic_irq_pending());
> +	check_rtc_irq();
> +
> +	return report_summary();
> +}
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index f6dfb90..1fc10a0 100644
> --- a/lib/arm/asm/gic.h
> +++ b/lib/arm/asm/gic.h
> @@ -41,6 +41,7 @@
>  #include <asm/gic-v3.h>
>  
>  #define PPI(irq)			((irq) + 16)
> +#define SPI(irq)			((irq) + GIC_FIRST_SPI)
>  
>  #ifndef __ASSEMBLY__
>  #include <asm/cpumask.h>
