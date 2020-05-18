Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC3B1D7179
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 09:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbgERHFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 03:05:23 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55958 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726676AbgERHFW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 May 2020 03:05:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589785520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iKLG9bJEeG3dZC3d50wQc+GIQ3Y71rrHtOQFzlpx34Y=;
        b=ZZfnCEdyUqHbF2g7qPG2YJQTCpXNO4OxLvPo2GwHWB8O6zprlpcAjooLRhRUu7U2WI2n5c
        pB4h89YyCkm9uVEdXAwj6riPW4PI9TTNvMEYAYYbns2iZyXZAu+Ium/bWDKRfUNljyIrlj
        Ed5OMSbnYdbvfPZPP0YddFprG4GFmVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-dhIDb_CZOpOzENvFsNIUbQ-1; Mon, 18 May 2020 03:05:16 -0400
X-MC-Unique: dhIDb_CZOpOzENvFsNIUbQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D6D118FE861;
        Mon, 18 May 2020 07:05:15 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.150])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5C35966062;
        Mon, 18 May 2020 07:05:10 +0000 (UTC)
Date:   Mon, 18 May 2020 09:05:07 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, maz@kernel.org,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com,
        eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH 6/6] arm64: microbench: Add vtimer latency
 test
Message-ID: <20200518070507.pvs4iol34wc2zjkz@kamzik.brq.redhat.com>
References: <20200517100900.30792-1-wangjingyi11@huawei.com>
 <20200517100900.30792-7-wangjingyi11@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517100900.30792-7-wangjingyi11@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, May 17, 2020 at 06:09:00PM +0800, Jingyi Wang wrote:
> Triggers PPIs by setting up a 10msec timer and test the latency.
> For this test can be time consuming, we add time limit for loop_test
> to make sure each test should be done in a certain time(5 sec here).

Having a time limit for the micro-bench tests might be a good idea, as
the overall unit test timeout configured by unittests.cfg can't measure
each individual micro-bench test separately, but it seems what we're
really doing here is saying that we can't do 65536 10ms long vtimer-ppi
tests, so let's do 500 instead -- however by using time to dictate the
count.

I think I'd rather see NTIMES be changed to a micro-bench test parameter
that defaults to 65536, but for the vtimer-ppi test it can be set to
something much smaller.

Also, please create a separate patch for the loop_test()/ntimes changes.
If you'd still like to do a per micro-bench test timeout as well, then
please create a separate patch for that too.

Thanks,
drew

> 
> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
> ---
>  arm/micro-bench.c | 81 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 70 insertions(+), 11 deletions(-)
> 
> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
> index 91af1f7..dbe8e54 100644
> --- a/arm/micro-bench.c
> +++ b/arm/micro-bench.c
> @@ -23,6 +23,11 @@
>  #include <asm/gic-v3-its.h>
>  
>  #define NTIMES (1U << 16)
> +#define MAX_NS (5 * 1000 * 1000 * 1000UL)
> +
> +#define IRQ_VTIMER		27
> +#define ARCH_TIMER_CTL_ENABLE	(1 << 0)
> +#define ARCH_TIMER_CTL_IMASK	(1 << 1)
>  
>  static u32 cntfrq;
>  
> @@ -33,9 +38,16 @@ static bool ipi_hw;
>  
>  static void gic_irq_handler(struct pt_regs *regs)
>  {
> +	u32 irqstat = gic_read_iar();
>  	irq_ready = false;
>  	irq_received = true;
> -	gic_write_eoir(gic_read_iar());
> +	gic_write_eoir(irqstat);
> +
> +	if (irqstat == IRQ_VTIMER) {
> +		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
> +				cntv_ctl_el0);
> +		isb();
> +	}
>  	irq_ready = true;
>  }
>  
> @@ -195,6 +207,47 @@ static void lpi_exec(void)
>  	assert_msg(irq_received, "failed to receive LPI in time, but received %d successfully\n", received);
>  }
>  
> +static bool timer_prep(void)
> +{
> +	static void *gic_isenabler;
> +
> +	gic_enable_defaults();
> +	install_irq_handler(EL1H_IRQ, gic_irq_handler);
> +	local_irq_enable();
> +
> +	gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
> +	writel(1 << IRQ_VTIMER, gic_isenabler);
> +	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
> +	isb();
> +
> +	gic_prep_common();
> +	return true;
> +}
> +
> +static void timer_exec(void)
> +{
> +	u64 before_timer;
> +	u64 timer_10ms;
> +	unsigned tries = 1 << 28;
> +	static int received = 0;
> +
> +	irq_received = false;
> +
> +	before_timer = read_sysreg(cntvct_el0);
> +	timer_10ms = cntfrq / 100;
> +	write_sysreg(before_timer + timer_10ms, cntv_cval_el0);
> +	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
> +	isb();
> +
> +	while (!irq_received && tries--)
> +		cpu_relax();
> +
> +	if (irq_received)
> +		++received;
> +
> +	assert_msg(irq_received, "failed to receive PPI in time, but received %d successfully\n", received);
> +}
> +
>  static void hvc_exec(void)
>  {
>  	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
> @@ -241,6 +294,7 @@ static struct exit_test tests[] = {
>  	{"ipi",			ipi_prep,	ipi_exec,		true},
>  	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
>  	{"lpi",			lpi_prep,	lpi_exec,		true},
> +	{"timer_10ms",		timer_prep,	timer_exec,		true},
>  };
>  
>  struct ns_time {
> @@ -261,27 +315,32 @@ static void ticks_to_ns_time(uint64_t ticks, struct ns_time *ns_time)
>  
>  static void loop_test(struct exit_test *test)
>  {
> -	uint64_t start, end, total_ticks, ntimes = NTIMES;
> +	uint64_t start, end, total_ticks, ntimes = 0;
>  	struct ns_time total_ns, avg_ns;
>  
> +	total_ticks = 0;
>  	if (test->prep) {
>  		if(!test->prep()) {
> -
>  			printf("%s test skipped\n", test->name);
>  			return;
>  		}
>  	}
> -	isb();
> -	start = read_sysreg(cntpct_el0);
> -	while (ntimes--)
> +
> +	while (ntimes < NTIMES && total_ns.ns < MAX_NS) {
> +		isb();
> +		start = read_sysreg(cntpct_el0);
>  		test->exec();
> -	isb();
> -	end = read_sysreg(cntpct_el0);
> +		isb();
> +		end = read_sysreg(cntpct_el0);
> +
> +		ntimes++;
> +		total_ticks += (end - start);
> +		ticks_to_ns_time(total_ticks, &total_ns);
> +	}
>  
> -	total_ticks = end - start;
>  	ticks_to_ns_time(total_ticks, &total_ns);
> -	avg_ns.ns = total_ns.ns / NTIMES;
> -	avg_ns.ns_frac = total_ns.ns_frac / NTIMES;
> +	avg_ns.ns = total_ns.ns / ntimes;
> +	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
>  
>  	printf("%-30s%15" PRId64 ".%-15" PRId64 "%15" PRId64 ".%-15" PRId64 "\n",
>  		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
> -- 
> 2.19.1
> 
> 

