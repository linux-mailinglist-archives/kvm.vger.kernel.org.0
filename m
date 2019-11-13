Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35839FAE47
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 11:14:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfKMKOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 05:14:25 -0500
Received: from foss.arm.com ([217.140.110.172]:49920 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727598AbfKMKOZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 05:14:25 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA7BD7A7;
        Wed, 13 Nov 2019 02:14:24 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC2B83F534;
        Wed, 13 Nov 2019 02:14:23 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 15/17] arm: gic: Provide FIQ handler
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-16-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <efbf58a2-9f9d-b3b6-626f-e7bb3b5707a2@arm.com>
Date:   Wed, 13 Nov 2019 10:14:22 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-16-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/8/19 2:42 PM, Andre Przywara wrote:
> When configuring an interrupt as Group 0, we can ask the GIC to deliver
> them as a FIQ. For this we need a separate exception handler.
>
> Provide this to be used later.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index c68b5b5..6756850 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -178,6 +178,30 @@ static void irq_handler(struct pt_regs *regs __unused)
>  	smp_wmb(); /* pairs with rmb in check_acked */
>  }
>  
> +static inline void fiq_handler(struct pt_regs *regs __unused)
> +{
> +	u32 irqstat = gic_read_iar(0);
> +	u32 irqnr = gic_iar_irqnr(irqstat);
> +
> +	if (irqnr == GICC_INT_SPURIOUS) {
> +		++spurious[smp_processor_id()];
> +		smp_wmb();
> +		return;
> +	}
> +
> +	gic_write_eoir(irqstat, 0);
> +
> +	smp_rmb(); /* pairs with wmb in stats_reset */
> +	++acked[smp_processor_id()];
> +	if (irqnr < GIC_NR_PRIVATE_IRQS) {
> +		check_ipi_sender(irqstat);
> +		check_irqnr(irqnr, IPI_IRQ);
> +	} else {
> +		check_irqnr(irqnr, SPI_IRQ);
> +	}
> +	smp_wmb(); /* pairs with rmb in check_acked */
> +}

If I'm not mistaken, this is identical to irq_handler, with the exception that
gic_read_iar and gic_write_eoir take group 0 as argument here. Maybe we can
abstract the common code into a function that takes the group as the argument?
What do you think?

Thanks,
Alex
> +
>  static void gicv2_ipi_send_self(void)
>  {
>  	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
