Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC113115E6
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 23:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhBEWon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 17:44:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229974AbhBENcF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 08:32:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612531837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vkvNzDYx2G5b+4FrrL18Wyy2xuuCwoarafrFqqqu/dA=;
        b=OFakh7f0y22SOmjPAf7+16PFURJwEvaenh4KNxnLAvrj3AEs9a+HzcynJ3Q98aMAEEJtA8
        BU+fcBMvuNDRtBCMvlJm+Lk4NK1RHK3BulMKKx8jNnNHzs1CoTgXuuW/MxZ/6/R1XqqETY
        h8ntel/HuDxGg1YXJCbLQR6Ukszv6cM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-VDtSqi4vNMSvjTWcyrFXug-1; Fri, 05 Feb 2021 08:30:33 -0500
X-MC-Unique: VDtSqi4vNMSvjTWcyrFXug-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD84D835E20;
        Fri,  5 Feb 2021 13:30:31 +0000 (UTC)
Received: from [10.36.113.43] (ovpn-113-43.ams2.redhat.com [10.36.113.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDBB010016FA;
        Fri,  5 Feb 2021 13:30:29 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 11/11] arm64: gic: Use IPI test checking
 for the LPI tests
To:     Alexandru Elisei <alexandru.elisei@arm.com>, drjones@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com
References: <20210129163647.91564-1-alexandru.elisei@arm.com>
 <20210129163647.91564-12-alexandru.elisei@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <12c8b5a8-b515-64b8-eece-d9d85fb2fe72@redhat.com>
Date:   Fri, 5 Feb 2021 14:30:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20210129163647.91564-12-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 1/29/21 5:36 PM, Alexandru Elisei wrote:
> The LPI code validates a result similarly to the IPI tests, by checking if
> the target CPU received the interrupt with the expected interrupt number.
> However, the LPI tests invent their own way of checking the test results by
> creating a global struct (lpi_stats), using a separate interrupt handler
> (lpi_handler) and test function (check_lpi_stats).
> 
> There are several areas that can be improved in the LPI code, which are
> already covered by the IPI tests:
> 
> - check_lpi_stats() doesn't take into account that the target CPU can
>   receive the correct interrupt multiple times.
> - check_lpi_stats() doesn't take into the account the scenarios where all
>   online CPUs can receive the interrupt, but the target CPU is the last CPU
>   that touches lpi_stats.observed.
> - Insufficient or missing memory synchronization.
> 
> Instead of duplicating code, let's convert the LPI tests to use
> check_acked() and the same interrupt handler as the IPI tests, which has
> been renamed to irq_handler() to avoid any confusion.
> 
> check_lpi_stats() has been replaced with check_acked() which, together with
> using irq_handler(), instantly gives us more correctness checks and proper
> memory synchronization between threads. lpi_stats.expected has been
> replaced by the CPU mask and the expected interrupt number arguments to
> check_acked(), with no change in semantics.
> 
> lpi_handler() aborted the test if the interrupt number was not an LPI. This
> was changed in favor of allowing the test to continue, as it will fail in
> check_acked(), but possibly print information useful for debugging. If the
> test receives spurious interrupts, those are reported via report_info() at
> the end of the test for consistency with the IPI tests, which don't treat
> spurious interrupts as critical errors.
> 
> In the spirit of code reuse, secondary_lpi_tests() has been replaced with
> ipi_recv() because the two are now identical; ipi_recv() has been renamed
> to irq_recv(), similarly to irq_handler(), to avoid confusion.
> 
> CC: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/gic.c | 190 +++++++++++++++++++++++++-----------------------------
>  1 file changed, 87 insertions(+), 103 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index 8bc2a35908f2..42048436c4c1 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -105,13 +105,12 @@ static bool check_acked(cpumask_t *mask, int sender, int irqnum)
>  				++missing;
>  			else if (acked[cpu] > 1)
>  				++extra;
> -		} else {
> -			if (acked[cpu])
> +		} else if (acked[cpu]) {
>  				++unexpected;
>  		}
>  		if (!acked[cpu])
>  			continue;
> -		smp_rmb(); /* pairs with smp_wmb in ipi_handler */
> +		smp_rmb(); /* pairs with smp_wmb in irq_handler */
>  
>  		if (has_gicv2 && irq_sender[cpu] != sender) {
>  			report_info("cpu%d received IPI from wrong sender %d",
> @@ -149,11 +148,12 @@ static void check_spurious(void)
>  static int gic_get_sender(int irqstat)
>  {
>  	if (gic_version() == 2)
> +		/* GICC_IAR.CPUID is RAZ for non-SGIs */
>  		return (irqstat >> 10) & 7;
>  	return -1;
>  }
>  
> -static void ipi_handler(struct pt_regs *regs __unused)
> +static void irq_handler(struct pt_regs *regs __unused)
>  {
>  	u32 irqstat = gic_read_iar();
>  	u32 irqnr = gic_iar_irqnr(irqstat);
> @@ -185,75 +185,6 @@ static void setup_irq(irq_handler_fn handler)
>  }
>  
>  #if defined(__aarch64__)
> -struct its_event {
> -	int cpu_id;
> -	int lpi_id;
> -};
> -
> -struct its_stats {
> -	struct its_event expected;
> -	struct its_event observed;
> -};
> -
> -static struct its_stats lpi_stats;
> -
> -static void lpi_handler(struct pt_regs *regs __unused)
> -{
> -	u32 irqstat = gic_read_iar();
> -	int irqnr = gic_iar_irqnr(irqstat);
> -
> -	gic_write_eoir(irqstat);
> -	assert(irqnr >= 8192);
> -	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
> -	lpi_stats.observed.cpu_id = smp_processor_id();
> -	lpi_stats.observed.lpi_id = irqnr;
> -	acked[lpi_stats.observed.cpu_id]++;
> -	smp_wmb(); /* pairs with rmb in check_lpi_stats */
> -}
> -
> -static void lpi_stats_expect(int exp_cpu_id, int exp_lpi_id)
> -{
> -	lpi_stats.expected.cpu_id = exp_cpu_id;
> -	lpi_stats.expected.lpi_id = exp_lpi_id;
> -	lpi_stats.observed.cpu_id = -1;
> -	lpi_stats.observed.lpi_id = -1;
> -	smp_wmb(); /* pairs with rmb in handler */
> -}
> -
> -static void check_lpi_stats(const char *msg)
> -{
> -	int i;
> -
> -	for (i = 0; i < 50; i++) {
> -		mdelay(100);
> -		smp_rmb(); /* pairs with wmb in lpi_handler */
> -		if (lpi_stats.observed.cpu_id == lpi_stats.expected.cpu_id &&
> -		    lpi_stats.observed.lpi_id == lpi_stats.expected.lpi_id) {
> -			report(true, "%s", msg);
> -			return;
> -		}
> -	}
> -
> -	if (lpi_stats.observed.cpu_id == -1 && lpi_stats.observed.lpi_id == -1) {
> -		report_info("No LPI received whereas (cpuid=%d, intid=%d) "
> -			    "was expected", lpi_stats.expected.cpu_id,
> -			    lpi_stats.expected.lpi_id);
> -	} else {
> -		report_info("Unexpected LPI (cpuid=%d, intid=%d)",
> -			    lpi_stats.observed.cpu_id,
> -			    lpi_stats.observed.lpi_id);
> -	}
> -	report(false, "%s", msg);
> -}
> -
> -static void secondary_lpi_test(void)
> -{
> -	setup_irq(lpi_handler);
> -	cpumask_set_cpu(smp_processor_id(), &ready);
> -	while (1)
> -		wfi();
> -}
> -
>  static void check_lpi_hits(int *expected, const char *msg)
>  {
>  	bool pass = true;
> @@ -347,7 +278,7 @@ static void ipi_test_smp(void)
>  
>  static void ipi_send(void)
>  {
> -	setup_irq(ipi_handler);
> +	setup_irq(irq_handler);
>  	wait_on_ready();
>  	ipi_test_self();
>  	ipi_test_smp();
> @@ -355,9 +286,9 @@ static void ipi_send(void)
>  	exit(report_summary());
>  }
>  
> -static void ipi_recv(void)
> +static void irq_recv(void)
>  {
> -	setup_irq(ipi_handler);
> +	setup_irq(irq_handler);
>  	cpumask_set_cpu(smp_processor_id(), &ready);
>  	while (1)
>  		wfi();
> @@ -368,7 +299,7 @@ static void ipi_test(void *data __unused)
>  	if (smp_processor_id() == IPI_SENDER)
>  		ipi_send();
>  	else
> -		ipi_recv();
> +		irq_recv();
>  }
>  
>  static struct gic gicv2 = {
> @@ -696,14 +627,12 @@ static int its_prerequisites(int nb_cpus)
>  		return -1;
>  	}
>  
> -	stats_reset();
> -
> -	setup_irq(lpi_handler);
> +	setup_irq(irq_handler);
>  
>  	for_each_present_cpu(cpu) {
>  		if (cpu == 0)
>  			continue;
> -		smp_boot_secondary(cpu, secondary_lpi_test);
> +		smp_boot_secondary(cpu, irq_recv);
>  	}
>  	wait_on_ready();
>  
> @@ -757,6 +686,7 @@ static void test_its_trigger(void)
>  {
>  	struct its_collection *col3;
>  	struct its_device *dev2, *dev7;
> +	cpumask_t mask;
>  
>  	if (its_setup1())
>  		return;
> @@ -767,13 +697,21 @@ static void test_its_trigger(void)
>  
>  	report_prefix_push("int");
>  
> -	lpi_stats_expect(3, 8195);
> +	stats_reset();
> +	cpumask_clear(&mask);
> +	cpumask_set_cpu(3, &mask);
>  	its_send_int(dev2, 20);
> -	check_lpi_stats("dev=2, eventid=20  -> lpi= 8195, col=3");
> +	wait_for_interrupts(&mask);
> +	report(check_acked(&mask, 0, 8195),
> +			"dev=2, eventid=20  -> lpi= 8195, col=3");
>  
> -	lpi_stats_expect(2, 8196);
> +	stats_reset();
> +	cpumask_clear(&mask);
> +	cpumask_set_cpu(2, &mask);
>  	its_send_int(dev7, 255);
> -	check_lpi_stats("dev=7, eventid=255 -> lpi= 8196, col=2");
> +	wait_for_interrupts(&mask);
> +	report(check_acked(&mask, 0, 8196),
> +			"dev=7, eventid=255 -> lpi= 8196, col=2");
>  
>  	report_prefix_pop();
>  
> @@ -786,9 +724,12 @@ static void test_its_trigger(void)
>  	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT & ~LPI_PROP_ENABLED);
>  	its_send_inv(dev2, 20);
>  
> -	lpi_stats_expect(-1, -1);
> +	stats_reset();
> +	cpumask_clear(&mask);
>  	its_send_int(dev2, 20);
> -	check_lpi_stats("dev2/eventid=20 does not trigger any LPI");
> +	wait_for_interrupts(&mask);
> +	report(check_acked(&mask, -1, -1),
> +			"dev2/eventid=20 does not trigger any LPI");
>  
>  	/*
>  	 * re-enable the LPI but willingly do not call invall
> @@ -796,18 +737,31 @@ static void test_its_trigger(void)
>  	 * The LPI should not hit
>  	 */
>  	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
> -	lpi_stats_expect(-1, -1);
> +	stats_reset();
> +	cpumask_clear(&mask);
>  	its_send_int(dev2, 20);
> -	check_lpi_stats("dev2/eventid=20 still does not trigger any LPI");
> +	wait_for_interrupts(&mask);
> +	report(check_acked(&mask, -1, -1),
> +			"dev2/eventid=20 still does not trigger any LPI");
>  
>  	/* Now call the invall and check the LPI hits */
> +	stats_reset();
> +	/* The barrier is from its_send_int() */
> +	wmb();
In v1 it was envisionned to add the wmb in __its_send_it but I fail to
see it. Is it implicit in some way?

Thanks

Eric
> +	cpumask_clear(&mask);
> +	cpumask_set_cpu(3, &mask);
>  	its_send_invall(col3);
> -	lpi_stats_expect(3, 8195);
> -	check_lpi_stats("dev2/eventid=20 pending LPI is received");
> +	wait_for_interrupts(&mask);
> +	report(check_acked(&mask, 0, 8195),
> +			"dev2/eventid=20 pending LPI is received");
>  
> -	lpi_stats_expect(3, 8195);
> +	stats_reset();
> +	cpumask_clear(&mask);
> +	cpumask_set_cpu(3, &mask);
>  	its_send_int(dev2, 20);
> -	check_lpi_stats("dev2/eventid=20 now triggers an LPI");
> +	wait_for_interrupts(&mask);
> +	report(check_acked(&mask, 0, 8195),
> +			"dev2/eventid=20 now triggers an LPI");
>  
>  	report_prefix_pop();
>  
> @@ -818,9 +772,13 @@ static void test_its_trigger(void)
>  	 */
>  
>  	its_send_mapd(dev2, false);
> -	lpi_stats_expect(-1, -1);
> +	stats_reset();
> +	cpumask_clear(&mask);
>  	its_send_int(dev2, 20);
> -	check_lpi_stats("no LPI after device unmap");
> +	wait_for_interrupts(&mask);
> +	report(check_acked(&mask, -1, -1), "no LPI after device unmap");
> +
> +	check_spurious();
>  	report_prefix_pop();
>  }
>  
> @@ -828,6 +786,7 @@ static void test_its_migration(void)
>  {
>  	struct its_device *dev2, *dev7;
>  	bool test_skipped = false;
> +	cpumask_t mask;
>  
>  	if (its_setup1()) {
>  		test_skipped = true;
> @@ -844,13 +803,23 @@ do_migrate:
>  	if (test_skipped)
>  		return;
>  
> -	lpi_stats_expect(3, 8195);
> +	stats_reset();
> +	cpumask_clear(&mask);
> +	cpumask_set_cpu(3, &mask);
>  	its_send_int(dev2, 20);
> -	check_lpi_stats("dev2/eventid=20 triggers LPI 8195 on PE #3 after migration");
> +	wait_for_interrupts(&mask);
> +	report(check_acked(&mask, 0, 8195),
> +			"dev2/eventid=20 triggers LPI 8195 on PE #3 after migration");
>  
> -	lpi_stats_expect(2, 8196);
> +	stats_reset();
> +	cpumask_clear(&mask);
> +	cpumask_set_cpu(2, &mask);
>  	its_send_int(dev7, 255);
> -	check_lpi_stats("dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
> +	wait_for_interrupts(&mask);
> +	report(check_acked(&mask, 0, 8196),
> +			"dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
> +
> +	check_spurious();
>  }
>  
>  #define ERRATA_UNMAPPED_COLLECTIONS "ERRATA_8c58be34494b"
> @@ -860,6 +829,7 @@ static void test_migrate_unmapped_collection(void)
>  	struct its_collection *col = NULL;
>  	struct its_device *dev2 = NULL, *dev7 = NULL;
>  	bool test_skipped = false;
> +	cpumask_t mask;
>  	int pe0 = 0;
>  	u8 config;
>  
> @@ -894,17 +864,27 @@ do_migrate:
>  	its_send_mapc(col, true);
>  	its_send_invall(col);
>  
> -	lpi_stats_expect(2, 8196);
> +	stats_reset();
> +	cpumask_clear(&mask);
> +	cpumask_set_cpu(2, &mask);
>  	its_send_int(dev7, 255);
> -	check_lpi_stats("dev7/eventid= 255 triggered LPI 8196 on PE #2");
> +	wait_for_interrupts(&mask);
> +	report(check_acked(&mask, 0, 8196),
> +			"dev7/eventid= 255 triggered LPI 8196 on PE #2");
>  
>  	config = gicv3_lpi_get_config(8192);
>  	report(config == LPI_PROP_DEFAULT,
>  	       "Config of LPI 8192 was properly migrated");
>  
> -	lpi_stats_expect(pe0, 8192);
> +	stats_reset();
> +	cpumask_clear(&mask);
> +	cpumask_set_cpu(pe0, &mask);
>  	its_send_int(dev2, 0);
> -	check_lpi_stats("dev2/eventid = 0 triggered LPI 8192 on PE0");
> +	wait_for_interrupts(&mask);
> +	report(check_acked(&mask, 0, 8192),
> +			"dev2/eventid = 0 triggered LPI 8192 on PE0");
> +
> +	check_spurious();
>  }
>  
>  static void test_its_pending_migration(void)
> @@ -961,6 +941,10 @@ static void test_its_pending_migration(void)
>  	pendbaser = readq(ptr);
>  	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
>  
> +	/*
> +	 * Reset and initialization values for acked are the same, so we don't
> +	 * need to explicitely call stats_reset().
> +	 */
>  	gicv3_lpi_rdist_enable(pe0);
>  	gicv3_lpi_rdist_enable(pe1);
>  
> 

