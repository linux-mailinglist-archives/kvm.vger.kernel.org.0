Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C002A0CEE
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 19:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgJ3SAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 14:00:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53330 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725808AbgJ3SAI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 14:00:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604080807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JkuYIJjBvvMNpp2hH0r/NiGmFlM8ieP/Q1YQB95KJ/s=;
        b=arf1lf/mun6ftfFn4PnWoacM1SlOp0IGiJ+Q8YzJxRayO3cSmEoKvoP5LuFUmB5ouhuOib
        eaaQMr9MUFuj9EHW4EeHSgrbqi1lF2tBARQ/9Y9fEC6LeQ7uezgfuwQk0sVgE2xGi38I5g
        eyDsqyRsvXnCwS+aw7iHQScN1PuWQK0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-402-U0KaCnWyOX2-eEf_YBiNew-1; Fri, 30 Oct 2020 14:00:04 -0400
X-MC-Unique: U0KaCnWyOX2-eEf_YBiNew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A8C08DF086;
        Fri, 30 Oct 2020 18:00:03 +0000 (UTC)
Received: from [10.36.114.125] (ovpn-114-125.ams2.redhat.com [10.36.114.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B968673660;
        Fri, 30 Oct 2020 18:00:01 +0000 (UTC)
From:   Auger Eric <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests RFC PATCH v2 5/5] am64: spe: Add buffer test
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-6-alexandru.elisei@arm.com>
Message-ID: <a5c56e5d-a031-b5a2-1e35-934188482826@redhat.com>
Date:   Fri, 30 Oct 2020 18:59:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201027171944.13933-6-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,
On 10/27/20 6:19 PM, Alexandru Elisei wrote:
> According to ARM DDI 0487F.b, a profiling buffer management event occurs:
> 
> * On a fault.
> * On an external abort.
> * When the buffer fills.
> * When software sets the service bit, PMBSR_EL1.S.
Compared to v1 this patch adds 3 new valuable tests. Thank you for that.
Please find technical comments in-line. General comments to be sent
along with the cover letter.
> 
> Set up the buffer to trigger the events and check that they are reported
> correctly.
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/spe.c         | 342 +++++++++++++++++++++++++++++++++++++++++++++-
>  arm/unittests.cfg |   8 ++
>  2 files changed, 346 insertions(+), 4 deletions(-)
> 
> diff --git a/arm/spe.c b/arm/spe.c
> index c199cd239194..c185883d079a 100644
> --- a/arm/spe.c
> +++ b/arm/spe.c
> @@ -15,8 +15,10 @@
>  #include <bitops.h>
>  #include <devicetree.h>
>  #include <libcflat.h>
> +#include <vmalloc.h>
>  
>  #include <asm/gic.h>
> +#include <asm/mmu.h>
>  #include <asm/processor.h>
>  #include <asm/sysreg.h>
>  
> @@ -41,6 +43,44 @@
>  #define SYS_PMSIDR_EL1_COUNTSIZE_SHIFT	16
>  #define SYS_PMSIDR_EL1_COUNTSIZE_MASK	0xfUL
>  
> +#define SYS_PMSCR_EL1			sys_reg(3, 0, 9, 9, 0)
> +#define SYS_PMSCR_EL1_E1SPE_SHIFT	1
> +#define SYS_PMSCR_EL1_PA_SHIFT		4
> +#define SYS_PMSCR_EL1_TS_SHIFT		5
> +
> +#define SYS_PMSICR_EL1			sys_reg(3, 0, 9, 9, 2)
> +
> +#define SYS_PMSIRR_EL1			sys_reg(3, 0, 9, 9, 3)
> +#define SYS_PMSIRR_EL1_INTERVAL_SHIFT	8
> +#define SYS_PMSIRR_EL1_INTERVAL_MASK	0xffffffUL
> +
> +#define SYS_PMSFCR_EL1			sys_reg(3, 0, 9, 9, 4)
> +#define SYS_PMSFCR_EL1_FE_SHIFT		0
> +#define SYS_PMSFCR_EL1_FT_SHIFT		1
> +#define SYS_PMSFCR_EL1_FL_SHIFT		2
> +#define SYS_PMSFCR_EL1_B_SHIFT		16
> +#define SYS_PMSFCR_EL1_LD_SHIFT		17
> +#define SYS_PMSFCR_EL1_ST_SHIFT		18
> +
> +#define SYS_PMSEVFR_EL1			sys_reg(3, 0, 9, 9, 5)
> +#define SYS_PMSLATFR_EL1		sys_reg(3, 0, 9, 9, 6)
> +
> +#define SYS_PMBLIMITR_EL1		sys_reg(3, 0, 9, 10, 0)
> +#define SYS_PMBLIMITR_EL1_E_SHIFT	0
> +
> +#define SYS_PMBPTR_EL1			sys_reg(3, 0, 9, 10, 1)
> +
> +#define SYS_PMBSR_EL1			sys_reg(3, 0, 9, 10, 3)
> +#define SYS_PMBSR_EL1_S_SHIFT		17
> +#define SYS_PMBSR_EL1_EA_SHIFT		18
> +#define SYS_PMBSR_EL1_BSC_BUF_FULL	1
> +#define SYS_PMBSR_EL1_EC_SHIFT		26
> +#define SYS_PMBSR_EL1_EC_MASK		0x3fUL
> +#define SYS_PMBSR_EL1_EC_FAULT_S1	0x24
> +#define SYS_PMBSR_EL1_RES0		0x00000000fc0fffffUL
> +
> +#define psb_csync()			asm volatile("hint #17" : : : "memory")
> +
>  struct spe {
>  	uint32_t intid;
>  	int min_interval;
> @@ -53,6 +93,15 @@ struct spe {
>  };
>  static struct spe spe;
>  
> +struct spe_buffer {
> +	uint64_t base;
> +	uint64_t limit;
> +};
> +static struct spe_buffer buffer;
> +
> +static volatile bool pmbirq_asserted, reassert_irq;
> +static volatile uint64_t irq_pmbsr;
> +
>  static int spe_min_interval(uint8_t interval)
>  {
>  	switch (interval) {
> @@ -131,6 +180,273 @@ static bool spe_probe(void)
>  	return true;
>  }
>  
> +/*
> + * Resets and starts a profiling session. Must be called with sampling and
> + * buffer disabled.
> + */
> +static void spe_reset_and_start(struct spe_buffer *spe_buffer)
> +{
> +	uint64_t pmscr;
> +
> +	assert(spe_buffer->base);
> +	assert(spe_buffer->limit > spe_buffer->base);
as you pointed in our discussion, shouldn't we have:
spe_buffer->limit > spe_buffer->base - 2^PMSIDR_EL1.MaxSize
> +
> +	write_sysreg_s(spe_buffer->base, SYS_PMBPTR_EL1);
> +	/* Change the buffer pointer before PMBLIMITR_EL1. */
has become SYS_PMBLIMITR_EL1
> +	isb();
> +
> +	write_sysreg_s(spe_buffer->limit | BIT(SYS_PMBLIMITR_EL1_E_SHIFT),
> +		       SYS_PMBLIMITR_EL1);
> +	write_sysreg_s(0, SYS_PMBSR_EL1);
> +	write_sysreg_s(0, SYS_PMSICR_EL1);
> +	/* PMSICR_EL1 must be written to zero before a new sampling session. */
> +	isb();
> +
> +	pmscr = BIT(SYS_PMSCR_EL1_E1SPE_SHIFT) |
> +		BIT(SYS_PMSCR_EL1_PA_SHIFT) |
> +		BIT(SYS_PMSCR_EL1_TS_SHIFT);
> +	write_sysreg_s(pmscr, SYS_PMSCR_EL1);
> +	isb();
> +}
this helper somehow matches the reset() function in v1 with variations
- no interval reload reg setting to min value
- you do not set the PCT bit (any reason, no timestamp sampling in the
test?). Anyway could remain as a default, does not hurt.
- isb added inbetween the SYS_PMBPTR_EL1 and PMBLIMITR_EL1 which sounds
like a fix
> +
> +static void spe_stop_and_drain(void)
matches the v1 drain() helper except you also stop the profiling.
This was done in my profiling loop function earlier. In my case I reset
PMBLIMITR_EL1.E (I understand from 3.2.1 that either method, reset PMSC
or this bit is ok).
> +{
> +	write_sysreg_s(0, SYS_PMSCR_EL1);
> +	isb();
> +
> +	psb_csync();
> +	dsb(nsh);
> +	write_sysreg_s(0, SYS_PMBLIMITR_EL1);
> +	isb();
> +}
> +
> +static void spe_irq_handler(struct pt_regs *regs)
> +{
> +	uint32_t intid = gic_read_iar();
> +
> +	spe_stop_and_drain();
why do you need to stop the SPE in the handler? This does not look
standard as a behavior?
> +
> +	irq_pmbsr = read_sysreg_s(SYS_PMBSR_EL1);
> +
> +	if (intid != PPI(spe.intid)) {
> +		report_info("Unexpected interrupt: %u", intid);
> +		/*
> +		 * When we get the interrupt, at least one bit, PMBSR_EL1.S,
> +		 * will be set. We can the value zero for an error.
last sentence needs some reword. But anyway the comment looks stale as
here we are handling the case here this is not an SPE IRQ. Maybe put it
below but then also check the PMBSR_EL1.S
> +		 */
> +		irq_pmbsr = 0;
> +		goto out;
> +	}
> +
> +	if (irq_pmbsr && reassert_irq) {
> +		/*
> +		 * Don't clear the service bit now, but ack the interrupt so it
> +		 * can be handled again.
> +		 */
> +		gic_write_eoir(intid);
> +		reassert_irq = false;
> +		irq_pmbsr = 0;
irq_pmbsr = 0 here and above? Looks strange. Don't you want to record
it. in V1 I was decoding the syndrome register with
decode_syndrome_register(), resetting the syndrome reg here and then
post-analyzed the SR. Why did you change that?
> +		return;
> +	}
> +
> +out:
> +	write_sysreg_s(0, SYS_PMBSR_EL1);
> +	/* Clear PMBSR_EL1 before EOI'ing the interrupt */
> +	isb();
> +	gic_write_eoir(intid);
> +
> +	pmbirq_asserted = true;
> +}
> +
> +static void spe_enable_interrupt(void)
gic_enable_irq() helper can be used instead (see v1)
> +{
> +	void *gic_isenabler;
> +
> +	switch (gic_version()) {
> +	case 2:
> +		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
> +		break;
> +	case 3:
> +		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
> +		break;
> +	default:
> +		report_abort("Unknown GIC version %d", gic_version());
> +	}
> +
> +	writel(1 << PPI(spe.intid), gic_isenabler);

> +}
> +
> +static void spe_init(void)
> +{
> +	uint64_t pmsfcr, pmsirr;
> +
> +	/*
> +	 * PMSCR_EL1.E1SPE resets to UNKNOWN value, make sure sampling is
> +	 * disabled.
> +	 */
> +	write_sysreg_s(0, SYS_PMSCR_EL1);
> +	isb();
> +
> +	install_irq_handler(EL1H_IRQ, spe_irq_handler);
> +
> +	gic_enable_defaults();
> +	spe_enable_interrupt();
> +	local_irq_enable();
> +
> +	buffer.base = (u64)memalign(PAGE_SIZE, PAGE_SIZE);
> +	assert_msg(buffer.base, "Cannot allocate profiling buffer");
> +	buffer.limit = buffer.base + PAGE_SIZE;
> +
> +	/* Select all operations for sampling */
> +	pmsfcr = BIT(SYS_PMSFCR_EL1_FT_SHIFT) |
> +		 BIT(SYS_PMSFCR_EL1_B_SHIFT) |
> +		 BIT(SYS_PMSFCR_EL1_LD_SHIFT) |
> +		 BIT(SYS_PMSFCR_EL1_ST_SHIFT);
> +	write_sysreg_s(pmsfcr, SYS_PMSFCR_EL1);

Besides the buffer allocation, some stuff are already done in the init()
routine so that's a bit a pity to duplicate. That's why I dissociated
the reset from the start in v1.
> +
> +	/*
> +	 * From ARM DDI 0487F.b: "[..] Software should set this to a value
> +	 * greater than the minimum indicated by PMSIDR_EL1.Interval"
> +	 */
> +	pmsirr = (spe.min_interval + 1) & SYS_PMSIRR_EL1_INTERVAL_MASK;
> +	pmsirr <<= SYS_PMSIRR_EL1_INTERVAL_SHIFT;
> +	write_sysreg_s(pmsirr, SYS_PMSIRR_EL1);
> +	isb();
> +}
> +
> +static bool spe_test_buffer_service(void)
> +{
> +	uint64_t expected_pmbsr;
> +	int i;
> +
> +	spe_stop_and_drain();
> +
> +	reassert_irq = true;
> +	pmbirq_asserted = false;
> +
> +	expected_pmbsr = 0x12345678 | BIT(SYS_PMBSR_EL1_S_SHIFT);
what is the point of 0x12345678?
> +	expected_pmbsr &= SYS_PMBSR_EL1_RES0;
> +
> +	/*
> +	 * ARM DDI 0487F.b, page D9-2803:
> +	 *
> +	 * "PMBIRQ is a level-sensitive interrupt request driven by PMBSR_EL1.S.
> +	 * This means that a direct write that sets PMBSR_EL1.S to 1 causes the
> +	 * interrupt to be asserted, and PMBIRQ remains asserted until software
> +	 * clears PMBSR_EL1.S to 0."
> +	 */
> +	 write_sysreg_s(expected_pmbsr, SYS_PMBSR_EL1);
> +	 isb();
> +
> +	/* Wait for up to 1 second for the GIC to assert the interrupt. */
> +	for (i = 0; i < 10; i++) {
> +		if (pmbirq_asserted)
> +			break;
> +		mdelay(100);
> +	}
> +	reassert_irq = false;
> +
> +	return irq_pmbsr == expected_pmbsr;
> +}
> +
> +static bool spe_test_buffer_full(void)
> +{
> +	volatile uint64_t cnt = 0;
> +	uint64_t expected_pmbsr, pmbptr;
> +
> +	spe_stop_and_drain();
> +
> +	pmbirq_asserted = false;
> +	expected_pmbsr = BIT(SYS_PMBSR_EL1_S_SHIFT) | SYS_PMBSR_EL1_BSC_BUF_FULL;
> +
> +	spe_reset_and_start(&buffer);
> +	for (;;) {
> +		cnt++;
> +		if (pmbirq_asserted)
> +			break;
> +	}
what if the interrupt does not occur as expected. You end up relying on
the kut timeout mechanism. Whereas on my test you stop at the end of the
mem_access_loop whatever the occurence of the event.
> +
> +	pmbptr = read_sysreg_s(SYS_PMBPTR_EL1);
> +	/*
> +	 * ARM DDI 0487F.b, page D9-2804:
> +	 *
> +	 * "[..] the Profiling Buffer management event is generated when the PE
> +	 * writes past the write limit pointer minus 2^(PMSIDR_EL1.MaxSize)."
> +	 */
> +	return (pmbptr >= buffer.limit - spe.max_record_size) &&
> +		(irq_pmbsr == expected_pmbsr);
> +}
> +
> +static bool spe_test_buffer_stage1_dabt(void)
> +{
> +	volatile uint64_t cnt = 0;
> +	struct spe_buffer dabt_buffer;
> +	uint8_t pmbsr_ec;
> +
> +	spe_stop_and_drain();
> +
> +	dabt_buffer.base = (u64)memalign(PAGE_SIZE, PAGE_SIZE);
> +	assert_msg(dabt_buffer.base, "Cannot allocate profiling buffer");
> +	dabt_buffer.limit = dabt_buffer.base + PAGE_SIZE;
> +	mmu_unmap_page(current_thread_info()->pgtable, dabt_buffer.base);
> +
> +	pmbirq_asserted = false;
> +
> +	spe_reset_and_start(&dabt_buffer);
> +	for (;;) {
> +		cnt++;
> +		if (pmbirq_asserted)
> +			break;
> +	}
can't you have the 1s timeout as for the service test. Isn't the fault
supposed to happen immediately.
> +
> +	pmbsr_ec = (irq_pmbsr >> SYS_PMBSR_EL1_EC_SHIFT) & SYS_PMBSR_EL1_EC_MASK;
> +	return (irq_pmbsr & BIT(SYS_PMBSR_EL1_S_SHIFT)) &&
> +		(pmbsr_ec == SYS_PMBSR_EL1_EC_FAULT_S1);
> +}
> +
> +static bool spe_test_buffer_extabt(void)
> +{
> +	struct spe_buffer extabt_buffer;
> +	volatile uint64_t cnt = 0;
> +	phys_addr_t highest_end = 0;
> +	struct mem_region *r;
> +
> +	spe_stop_and_drain();
> +
> +	/*
> +	 * Find a physical address most likely to be absent from the stage 2
> +	 * tables. Full explanation in arm/selftest.c, in check_pabt_init().
> +	 */
> +	for (r = mem_regions; r->end; r++) {
> +		if (r->flags & MR_F_IO)
> +			continue;
> +		if (r->end > highest_end)
> +			highest_end = PAGE_ALIGN(r->end);
> +	}
> +
> +	if (mem_region_get_flags(highest_end) != MR_F_UNKNOWN)
> +		return false;
> +
> +	extabt_buffer.base = (u64)vmap(highest_end, PAGE_SIZE);
> +	extabt_buffer.limit = extabt_buffer.base + PAGE_SIZE;
> +
> +	pmbirq_asserted = false;
> +
> +	report_info("Expecting KVM Stage 2 Data Abort at pmbptr=0x%lx",
> +			extabt_buffer.base);
> +
> +	spe_reset_and_start(&extabt_buffer);
> +	for (;;) {
> +		cnt++;
> +		if (pmbirq_asserted)
> +			break;
> +	}
> +
> +	return (irq_pmbsr & BIT(SYS_PMBSR_EL1_S_SHIFT)) &&
> +		(irq_pmbsr & BIT(SYS_PMBSR_EL1_EA_SHIFT));
I still think the decode_syndrome_register I introduced in v1 is useful.
It matches what we have in the PMU tests. Also in the verbose mode it
allows to see what does happen. Then you can post-process the collected
info.
> +
> +}
> +
>  static void spe_test_introspection(void)
>  {
>  	report_prefix_push("spe-introspection");
> @@ -146,8 +462,22 @@ static void spe_test_introspection(void)
>  	report_prefix_pop();
>  }
>  
> +static void spe_test_buffer(void)
> +{
> +	report_prefix_push("spe-buffer");
this rather test buffer events so the name of the test may be updated.
Also this single test may be split into several ones. This may be easier
to analyze upon failures.
> +
> +	report(spe_test_buffer_service(), "Service management event");
> +	report(spe_test_buffer_full(), "Buffer full management event");
> +	report(spe_test_buffer_stage1_dabt(), "Stage 1 data abort management event");
> +	report(spe_test_buffer_extabt(), "Buffer external abort management event");
> +
> +	report_prefix_pop();
> +}
> +
>  int main(int argc, char *argv[])
>  {
> +	int i;
> +
>  	if (!spe_probe()) {
>  		report_skip("SPE not supported");
>  		return report_summary();
> @@ -161,12 +491,16 @@ int main(int argc, char *argv[])
>  	if (argc < 2)
>  		report_abort("no test specified");
>  
> +	spe_init();
> +
>  	report_prefix_push("spe");
>  
> -	if (strcmp(argv[1], "spe-introspection") == 0)
> -		spe_test_introspection();
> -	else
> -		report_abort("Unknown subtest '%s'", argv[1]);
> +	for (i = 1; i < argc; i++) {
> +		if (strcmp(argv[i], "spe-introspection") == 0)
> +			spe_test_introspection();
> +		if (strcmp(argv[i], "spe-buffer") == 0)
> +			spe_test_buffer();
> +	}
>  
>  	return report_summary();
>  }
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index ad10be123774..ba21421e81aa 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -141,6 +141,14 @@ arch = arm64
>  accel = kvm
>  extra_params = -append 'spe-introspection'
>  
> +[spe-buffer]
> +file = spe.flat
> +groups = spe
> +arch = arm64
> +timeout = 10s
so this is the time we will wait if service interrupt or buffer fullness
interrupt does not hit.
> +accel = kvm
> +extra_params = -append 'spe-buffer'
> +
>  # Test GIC emulation
>  [gicv2-ipi]
>  file = gic.flat
> 
Thanks

Eric

