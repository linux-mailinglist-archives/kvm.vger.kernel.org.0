Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C3CF8DB5
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 12:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKLLLm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 06:11:42 -0500
Received: from foss.arm.com ([217.140.110.172]:60238 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbfKLLLm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 06:11:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F390A31B;
        Tue, 12 Nov 2019 03:11:41 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0E5A23F6C4;
        Tue, 12 Nov 2019 03:11:40 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 02/17] arm: gic: Generalise function names
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-3-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d5162b00-e0c1-132c-225c-a1c16fba3c0a@arm.com>
Date:   Tue, 12 Nov 2019 11:11:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-3-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/8/19 2:42 PM, Andre Przywara wrote:
> In preparation for adding functions to test SPI interrupts, generalise
> some existing functions dealing with IPIs so far, since most of them
> are actually generic for all kind of interrupts.
> This also reformats the irq_handler() function, to later expand it
> more easily.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 40 +++++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 19 deletions(-)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index 04b3337..a114009 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -135,28 +135,30 @@ static void check_ipi_sender(u32 irqstat)
>  	}
>  }
>  
> -static void check_irqnr(u32 irqnr)
> +static void check_irqnr(u32 irqnr, int expected)
>  {
> -	if (irqnr != IPI_IRQ)
> +	if (irqnr != expected)
>  		bad_irq[smp_processor_id()] = irqnr;
>  }
>  
> -static void ipi_handler(struct pt_regs *regs __unused)
> +static void irq_handler(struct pt_regs *regs __unused)
>  {
>  	u32 irqstat = gic_read_iar();
>  	u32 irqnr = gic_iar_irqnr(irqstat);
>  
> -	if (irqnr != GICC_INT_SPURIOUS) {
> -		gic_write_eoir(irqstat);
> -		smp_rmb(); /* pairs with wmb in stats_reset */
> -		++acked[smp_processor_id()];
> -		check_ipi_sender(irqstat);
> -		check_irqnr(irqnr);
> -		smp_wmb(); /* pairs with rmb in check_acked */
> -	} else {
> +	if (irqnr == GICC_INT_SPURIOUS) {
>  		++spurious[smp_processor_id()];
>  		smp_wmb();
> +		return;
>  	}
> +
> +	gic_write_eoir(irqstat);
> +
> +	smp_rmb(); /* pairs with wmb in stats_reset */
> +	++acked[smp_processor_id()];
> +	check_ipi_sender(irqstat);
> +	check_irqnr(irqnr, IPI_IRQ);
> +	smp_wmb(); /* pairs with rmb in check_acked */
>  }

I'm not sure this change is necessary. In its current form, it is consistent with
the other irq handler, ipi_clear_active_handler, and your patches add only two
lines: an if statement to check for SPIs and call check_irqnr if true. That is
trivial to integrate in the current handler. Would you care to elaborate why you
think this change is needed?

Thanks,
Alex
>  
>  static void gicv2_ipi_send_self(void)
> @@ -216,20 +218,20 @@ static void ipi_test_smp(void)
>  	report_prefix_pop();
>  }
>  
> -static void ipi_enable(void)
> +static void irqs_enable(void)
>  {
>  	gic_enable_defaults();
>  #ifdef __arm__
> -	install_exception_handler(EXCPTN_IRQ, ipi_handler);
> +	install_exception_handler(EXCPTN_IRQ, irq_handler);
>  #else
> -	install_irq_handler(EL1H_IRQ, ipi_handler);
> +	install_irq_handler(EL1H_IRQ, irq_handler);
>  #endif
>  	local_irq_enable();
>  }
>  
>  static void ipi_send(void)
>  {
> -	ipi_enable();
> +	irqs_enable();
>  	wait_on_ready();
>  	ipi_test_self();
>  	ipi_test_smp();
> @@ -237,9 +239,9 @@ static void ipi_send(void)
>  	exit(report_summary());
>  }
>  
> -static void ipi_recv(void)
> +static void irq_recv(void)
>  {
> -	ipi_enable();
> +	irqs_enable();
>  	cpumask_set_cpu(smp_processor_id(), &ready);
>  	while (1)
>  		wfi();
> @@ -250,7 +252,7 @@ static void ipi_test(void *data __unused)
>  	if (smp_processor_id() == IPI_SENDER)
>  		ipi_send();
>  	else
> -		ipi_recv();
> +		irq_recv();
>  }
>  
>  static struct gic gicv2 = {
> @@ -285,7 +287,7 @@ static void ipi_clear_active_handler(struct pt_regs *regs __unused)
>  
>  		smp_rmb(); /* pairs with wmb in stats_reset */
>  		++acked[smp_processor_id()];
> -		check_irqnr(irqnr);
> +		check_irqnr(irqnr, IPI_IRQ);
>  		smp_wmb(); /* pairs with rmb in check_acked */
>  	} else {
>  		++spurious[smp_processor_id()];
