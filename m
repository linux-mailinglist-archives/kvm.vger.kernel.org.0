Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5C4F90C3
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 14:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfKLNg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 08:36:29 -0500
Received: from foss.arm.com ([217.140.110.172]:34088 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfKLNg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 08:36:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95B7B30E;
        Tue, 12 Nov 2019 05:36:28 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A69393F6C4;
        Tue, 12 Nov 2019 05:36:27 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 05/17] arm: gic: Prepare IRQ handler for
 handling SPIs
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-6-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <2e0e6ee6-20ba-4143-a80c-62333b24bdc9@arm.com>
Date:   Tue, 12 Nov 2019 13:36:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-6-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/8/19 2:42 PM, Andre Przywara wrote:
> So far our IRQ handler routine checks that the received IRQ is actually
> the one SGI (IPI) that we are using for our testing.
>
> To make the IRQ testing routine more versatile, also allow the IRQ to be
> one test SPI (shared interrupt).
> We use the penultimate IRQ of the first SPI group for that purpose.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index eca9188..c909668 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -23,6 +23,7 @@
>  
>  #define IPI_SENDER	1
>  #define IPI_IRQ		1
> +#define SPI_IRQ		(GIC_FIRST_SPI + 30)
>  
>  struct gic {
>  	struct {
> @@ -162,8 +163,12 @@ static void irq_handler(struct pt_regs *regs __unused)
>  
>  	smp_rmb(); /* pairs with wmb in stats_reset */
>  	++acked[smp_processor_id()];
> -	check_ipi_sender(irqstat);
> -	check_irqnr(irqnr, IPI_IRQ);
> +	if (irqnr < GIC_NR_PRIVATE_IRQS) {
> +		check_ipi_sender(irqstat);
> +		check_irqnr(irqnr, IPI_IRQ);
> +	} else {
> +		check_irqnr(irqnr, SPI_IRQ);
> +	}
>  	smp_wmb(); /* pairs with rmb in check_acked */
>  }
>  

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

