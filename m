Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DAD2CD9BE
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 16:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730978AbgLCPA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 10:00:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726912AbgLCPAz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 10:00:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607007568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/jV8rDC6NOVaLd8/c3i/yNh9laTUl2h94ANl+cpf9sQ=;
        b=gd9XlhgNZM3Qu/8Cfq4tne1yh9khROqng9jMKDL+Ttp7mrXm2dARbY4Wp4T7gMinjurgEY
        xIs+GenF+7Q+eSABKs/ny4q7VQFnN1RUlk/L/s3shPHA27J7Ab0xmMmR2IUv8nkXZM090k
        CJhLfevT+5tqUaBp3cTe2OlC9NtxiaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-KL_vZvSDNIiHTCIUm98q6A-1; Thu, 03 Dec 2020 09:59:23 -0500
X-MC-Unique: KL_vZvSDNIiHTCIUm98q6A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66D531966320;
        Thu,  3 Dec 2020 14:59:22 +0000 (UTC)
Received: from [10.36.112.89] (ovpn-112-89.ams2.redhat.com [10.36.112.89])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D23C510016FB;
        Thu,  3 Dec 2020 14:59:20 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 09/10] arm/arm64: gic: Make check_acked()
 more generic
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-10-alexandru.elisei@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <d187299c-de94-bb1b-496a-0d552a3ae601@redhat.com>
Date:   Thu, 3 Dec 2020 15:59:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201125155113.192079-10-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/25/20 4:51 PM, Alexandru Elisei wrote:
> Testing that an interrupt is received as expected is done in three places:
> in check_ipi_sender(), check_irqnr() and check_acked(). check_irqnr()
> compares the interrupt ID with IPI_IRQ and records a failure in bad_irq,
> and check_ipi_sender() compares the sender with IPI_SENDER and writes to
> bad_sender when they don't match.
> 
> Let's move all the checks to check_acked() by renaming
> bad_sender->irq_sender and bad_irq->irq_number and changing their semantics
> so they record the interrupt sender, respectively the irq number.
> check_acked() now takes two new parameters: the expected interrupt number
> and sender.
> 
> This has two distinct advantages:
> 
> 1. check_acked() and ipi_handler() can now be used for interrupts other
>    than IPIs.
> 2. Correctness checks are consolidated in one function.
> 
> CC: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
>  arm/gic.c | 68 +++++++++++++++++++++++++++----------------------------
>  1 file changed, 33 insertions(+), 35 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index dcdab7d5f39a..da7b42da5449 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -35,7 +35,7 @@ struct gic {
>  
>  static struct gic *gic;
>  static int acked[NR_CPUS], spurious[NR_CPUS];
> -static int bad_sender[NR_CPUS], bad_irq[NR_CPUS];
> +static int irq_sender[NR_CPUS], irq_number[NR_CPUS];
>  static cpumask_t ready;
>  
>  static void nr_cpu_check(int nr)
> @@ -57,8 +57,8 @@ static void stats_reset(void)
>  
>  	for (i = 0; i < nr_cpus; ++i) {
>  		acked[i] = 0;
> -		bad_sender[i] = -1;
> -		bad_irq[i] = -1;
> +		irq_sender[i] = -1;
> +		irq_number[i] = -1;
>  	}
>  }
>  
> @@ -92,9 +92,10 @@ static void wait_for_interrupts(cpumask_t *mask)
>  	report_info("interrupts timed-out (5s)");
>  }
>  
> -static bool check_acked(cpumask_t *mask)
> +static bool check_acked(cpumask_t *mask, int sender, int irqnum)
>  {
>  	int missing = 0, extra = 0, unexpected = 0;
> +	bool has_gicv2 = (gic_version() == 2);
>  	bool pass = true;
>  	int cpu;
>  
> @@ -108,17 +109,19 @@ static bool check_acked(cpumask_t *mask)
>  			if (acked[cpu])
>  				++unexpected;
>  		}
> +		if (!acked[cpu])
> +			continue;
>  		smp_rmb(); /* pairs with smp_wmb in ipi_handler */
>  
> -		if (bad_sender[cpu] != -1) {
> +		if (has_gicv2 && irq_sender[cpu] != sender) {
>  			report_info("cpu%d received IPI from wrong sender %d",
> -					cpu, bad_sender[cpu]);
> +					cpu, irq_sender[cpu]);
>  			pass = false;
>  		}
>  
> -		if (bad_irq[cpu] != -1) {
> +		if (irq_number[cpu] != irqnum) {
>  			report_info("cpu%d received wrong irq %d",
> -					cpu, bad_irq[cpu]);
> +					cpu, irq_number[cpu]);
>  			pass = false;
>  		}
>  	}
> @@ -143,26 +146,18 @@ static void check_spurious(void)
>  	}
>  }
>  
> -static void check_ipi_sender(u32 irqstat, int sender)
> +static int gic_get_sender(int irqstat)
>  {
> -	if (gic_version() == 2) {
> -		int src = (irqstat >> 10) & 7;
> -
> -		if (src != sender)
> -			bad_sender[smp_processor_id()] = src;
> -	}
> -}
> -
> -static void check_irqnr(u32 irqnr)
> -{
> -	if (irqnr != IPI_IRQ)
> -		bad_irq[smp_processor_id()] = irqnr;
> +	if (gic_version() == 2)
> +		return (irqstat >> 10) & 7;
> +	return -1;
>  }
>  
>  static void ipi_handler(struct pt_regs *regs __unused)
>  {
>  	u32 irqstat = gic_read_iar();
>  	u32 irqnr = gic_iar_irqnr(irqstat);
> +	int this_cpu = smp_processor_id();
>  
>  	if (irqnr != GICC_INT_SPURIOUS) {
>  		gic_write_eoir(irqstat);
> @@ -173,12 +168,12 @@ static void ipi_handler(struct pt_regs *regs __unused)
>  		 */
>  		if (gic_version() == 2)
>  			smp_rmb();
> -		check_ipi_sender(irqstat, IPI_SENDER);
> -		check_irqnr(irqnr);
> +		irq_sender[this_cpu] = gic_get_sender(irqstat);
> +		irq_number[this_cpu] = irqnr;
>  		smp_wmb(); /* pairs with smp_rmb in check_acked */
> -		++acked[smp_processor_id()];
> +		++acked[this_cpu];
>  	} else {
> -		++spurious[smp_processor_id()];
> +		++spurious[this_cpu];
>  	}
>  
>  	/* Wait for writes to acked/spurious to complete */
> @@ -311,40 +306,42 @@ static void gicv3_ipi_send_broadcast(void)
>  
>  static void ipi_test_self(void)
>  {
> +	int this_cpu = smp_processor_id();
>  	cpumask_t mask;
>  
>  	report_prefix_push("self");
>  	stats_reset();
>  	cpumask_clear(&mask);
> -	cpumask_set_cpu(smp_processor_id(), &mask);
> +	cpumask_set_cpu(this_cpu, &mask);
>  	gic->ipi.send_self();
>  	wait_for_interrupts(&mask);
> -	report(check_acked(&mask), "Interrupts received");
> +	report(check_acked(&mask, this_cpu, IPI_IRQ), "Interrupts received");
>  	report_prefix_pop();
>  }
>  
>  static void ipi_test_smp(void)
>  {
> +	int this_cpu = smp_processor_id();
>  	cpumask_t mask;
>  	int i;
>  
>  	report_prefix_push("target-list");
>  	stats_reset();
>  	cpumask_copy(&mask, &cpu_present_mask);
> -	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
> +	for (i = this_cpu & 1; i < nr_cpus; i += 2)
>  		cpumask_clear_cpu(i, &mask);
>  	gic_ipi_send_mask(IPI_IRQ, &mask);
>  	wait_for_interrupts(&mask);
> -	report(check_acked(&mask), "Interrupts received");
> +	report(check_acked(&mask, this_cpu, IPI_IRQ), "Interrupts received");
>  	report_prefix_pop();
>  
>  	report_prefix_push("broadcast");
>  	stats_reset();
>  	cpumask_copy(&mask, &cpu_present_mask);
> -	cpumask_clear_cpu(smp_processor_id(), &mask);
> +	cpumask_clear_cpu(this_cpu, &mask);
>  	gic->ipi.send_broadcast();
>  	wait_for_interrupts(&mask);
> -	report(check_acked(&mask), "Interrupts received");
> +	report(check_acked(&mask, this_cpu, IPI_IRQ), "Interrupts received");
>  	report_prefix_pop();
>  }
>  
> @@ -393,6 +390,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  {
>  	u32 irqstat = gic_read_iar();
>  	u32 irqnr = gic_iar_irqnr(irqstat);
> +	int this_cpu = smp_processor_id();
>  
>  	if (irqnr != GICC_INT_SPURIOUS) {
>  		void *base;
> @@ -405,11 +403,11 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  
>  		writel(val, base + GICD_ICACTIVER);
>  
> -		check_ipi_sender(irqstat, smp_processor_id());
> -		check_irqnr(irqnr);
> -		++acked[smp_processor_id()];
> +		irq_sender[this_cpu] = gic_get_sender(irqstat);
> +		irq_number[this_cpu] = irqnr;
> +		++acked[this_cpu];
>  	} else {
> -		++spurious[smp_processor_id()];
> +		++spurious[this_cpu];
>  	}
>  }
>  
> 

