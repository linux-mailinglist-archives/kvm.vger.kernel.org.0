Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571EA17A2F9
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 11:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgCEKRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 05:17:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47817 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725937AbgCEKRe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Mar 2020 05:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583403452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CzsK3zceYUk/3h6Cd/jkI4QYfVwTVQONrR1Eh0uvmok=;
        b=fadbj+M3J2VFHEURuJ+v+WJKG+Bu0D1FsjuLoNMBS8sqwNngPK/MsWv7fSsvxWiYS9nUdO
        i1n/oBsNXF9CFXmfdqoU0tzuCUSIPcy4vrpcz5t16JlpZYkViWKABmtzTd4ZjGa0BKh36E
        +6CCHBE0HgHPCnCdZb0ubhPDbAy1vZ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-ug75qkquN9W3KMaQ028lbg-1; Thu, 05 Mar 2020 05:17:26 -0500
X-MC-Unique: ug75qkquN9W3KMaQ028lbg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8D6218FF660;
        Thu,  5 Mar 2020 10:17:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-110.brq.redhat.com [10.40.204.110])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CC4CB5C1D8;
        Thu,  5 Mar 2020 10:17:18 +0000 (UTC)
Date:   Thu, 5 Mar 2020 11:17:16 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        peter.maydell@linaro.org, andrew.murray@arm.com,
        alexandru.elisei@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 9/9] arm: pmu: Test overflow interrupts
Message-ID: <20200305101716.fgh4hmzdtg7pnacy@kamzik.brq.redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-10-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130112510.15154-10-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 30, 2020 at 12:25:10PM +0100, Eric Auger wrote:
> Test overflows for MEM_ACCESS and SW_INCR events. Also tests
> overflows with 64-bit events.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - inline setup_irq() code
> ---
>  arm/pmu.c         | 137 ++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg |   6 ++
>  2 files changed, 143 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index fa77ab3..ada28a4 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -45,6 +45,11 @@ struct pmu {
>  	uint32_t pmcr_ro;
>  };
>  
> +struct pmu_stats {
> +	unsigned long bitmap;
> +	uint32_t interrupts[32];
> +};
> +
>  static struct pmu pmu;
>  
>  #if defined(__arm__)
> @@ -116,6 +121,7 @@ static void test_mem_access(void) {}
>  static void test_chained_counters(void) {}
>  static void test_chained_sw_incr(void) {}
>  static void test_chain_promotion(void) {}
> +static void test_overflow_interrupt(void) {}
>  
>  #elif defined(__aarch64__)
>  #define ID_AA64DFR0_PERFMON_SHIFT 8
> @@ -261,6 +267,44 @@ asm volatile(
>  	: "x9", "x10", "cc");
>  }
>  
> +static struct pmu_stats pmu_stats;
> +
> +static void irq_handler(struct pt_regs *regs)
> +{
> +	uint32_t irqstat, irqnr;
> +
> +	irqstat = gic_read_iar();
> +	irqnr = gic_iar_irqnr(irqstat);
> +	gic_write_eoir(irqstat);

Should we clear the overflows before EOIRing? Otherwise I think it may be
possible for another interrupt to be delivered. See

https://patchwork.kernel.org/patch/11368853/

for a similar issue.

> +
> +	if (irqnr == 23) {

Why 23? And how about a define?

> +		unsigned long overflows = read_sysreg(pmovsclr_el0);
> +		int i;
> +
> +		report_info("--> PMU overflow interrupt %d (counter bitmask 0x%lx)",
> +			    irqnr, overflows);
> +		for (i = 0; i < 32; i++) {
> +			if (test_and_clear_bit(i, &overflows)) {
> +				pmu_stats.interrupts[i]++;
> +				pmu_stats.bitmap |= 1 << i;
> +			}
> +		}
> +		write_sysreg(0xFFFFFFFF, pmovsclr_el0);
> +	} else {
> +		report_info("Unexpected interrupt: %d\n", irqnr);

We should probably avoid calling any print functions from interrupt
handlers. I see the timer test irq handler has this too, though. Also
the pl031 test has a bunch of reporting in its irq handler. We do
better with the gic tests where we only write results to arrays and
then report later.

> +	}
> +}
> +
> +static void pmu_reset_stats(void)
> +{
> +	int i;
> +
> +	for (i = 0; i < 32; i++)
> +		pmu_stats.interrupts[i] = 0;
> +
> +	pmu_stats.bitmap = 0;
> +}
> +
>  static void pmu_reset(void)
>  {
>  	/* reset all counters, counting disabled at PMCR level*/
> @@ -271,6 +315,7 @@ static void pmu_reset(void)
>  	write_sysreg(0xFFFFFFFF, pmovsclr_el0);
>  	/* disable overflow interrupts on all counters */
>  	write_sysreg(0xFFFFFFFF, pmintenclr_el1);
> +	pmu_reset_stats();
>  	isb();
>  }
>  
> @@ -713,6 +758,95 @@ static void test_chain_promotion(void)
>  			read_sysreg(pmovsclr_el0));
>  }
>  
> +static bool expect_interrupts(uint32_t bitmap)
> +{
> +	int i;
> +
> +	if (pmu_stats.bitmap ^ bitmap)
> +		return false;
> +
> +	for (i = 0; i < 32; i++) {
> +		if (test_and_clear_bit(i, &pmu_stats.bitmap))
> +			if (pmu_stats.interrupts[i] != 1)
> +				return false;
> +	}
> +	return true;
> +}
> +
> +static void test_overflow_interrupt(void)
> +{
> +	uint32_t events[] = { 0x13 /* MEM_ACCESS */, 0x00 /* SW_INCR */};
> +	void *addr = malloc(PAGE_SIZE);
> +	int i;
> +
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +		return;
> +
> +	gic_enable_defaults();
> +	install_irq_handler(EL1H_IRQ, irq_handler);
> +	local_irq_enable();
> +	gic_enable_irq(23);
> +
> +	pmu_reset();
> +
> +	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	write_regn(pmevcntr, 0, 0xFFFFFFF0);
> +	write_regn(pmevcntr, 1, 0xFFFFFFF0);
> +	isb();
> +
> +	/* interrupts are disabled */
> +
> +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> +	report(expect_interrupts(0), "no overflow interrupt received");
> +
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
> +	for (i = 0; i < 100; i++)
> +		write_sysreg(0x2, pmswinc_el0);
> +
> +	set_pmcr(pmu.pmcr_ro);
> +	report(expect_interrupts(0), "no overflow interrupt received");
> +
> +	/* enable interrupts */
> +
> +	pmu_reset_stats();
> +
> +	write_regn(pmevcntr, 0, 0xFFFFFFF0);
> +	write_regn(pmevcntr, 1, 0xFFFFFFF0);
> +	write_sysreg(0xFFFFFFFF, pmintenset_el1);
> +	isb();
> +
> +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> +	for (i = 0; i < 100; i++)
> +		write_sysreg(0x3, pmswinc_el0);
> +
> +	mem_access_loop(addr, 200, pmu.pmcr_ro);
> +	report_info("overflow=0x%lx", read_sysreg(pmovsclr_el0));
> +	report(expect_interrupts(0x3),
> +		"overflow interrupts expected on #0 and #1");
> +
> +	/* promote to 64-b */
> +
> +	pmu_reset_stats();
> +
> +	events[1] = 0x1E /* CHAIN */;
> +	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn(pmevcntr, 0, 0xFFFFFFF0);
> +	isb();
> +	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
> +	report(expect_interrupts(0),
> +		"no overflow interrupt expected on 32b boundary");
> +
> +	/* overflow on odd counter */
> +	pmu_reset_stats();
> +	write_regn(pmevcntr, 0, 0xFFFFFFF0);
> +	write_regn(pmevcntr, 1, 0xFFFFFFFF);
> +	isb();
> +	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
> +	report(expect_interrupts(0x2),
> +		"expect overflow interrupt on odd counter");
> +}
>  #endif
>  
>  /*
> @@ -921,6 +1055,9 @@ int main(int argc, char *argv[])
>  	} else if (strcmp(argv[1], "chain-promotion") == 0) {
>  		report_prefix_push(argv[1]);
>  		test_chain_promotion();
> +	} else if (strcmp(argv[1], "overflow-interrupt") == 0) {
> +		report_prefix_push(argv[1]);
> +		test_overflow_interrupt();
>  	} else {
>  		report_abort("Unknown sub-test '%s'", argv[1]);
>  	}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index eb6e87e..1d1bc27 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -108,6 +108,12 @@ groups = pmu
>  arch = arm64
>  extra_params = -append 'chain-promotion'
>  
> +[overflow-interrupt]

Need "pmu-" prefix on this name, like the others, otherwise its standalone
test won't have an appropriate name.

> +file = pmu.flat
> +groups = pmu
> +arch = arm64
> +extra_params = -append 'overflow-interrupt'
> +
>  # Test PMU support (TCG) with -icount IPC=1
>  #[pmu-tcg-icount-1]
>  #file = pmu.flat
> -- 
> 2.20.1
> 
> 

also same comments as previous patches

Thanks,
drew

