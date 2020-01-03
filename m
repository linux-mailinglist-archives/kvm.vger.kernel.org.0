Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99EAF12F8D1
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 14:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgACNg3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 08:36:29 -0500
Received: from foss.arm.com ([217.140.110.172]:55646 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727508AbgACNg3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jan 2020 08:36:29 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E6E8328;
        Fri,  3 Jan 2020 05:36:28 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E4BD3F237;
        Fri,  3 Jan 2020 05:36:27 -0800 (PST)
Date:   Fri, 3 Jan 2020 13:36:24 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        maz@kernel.org, vladimir.murzin@arm.com, mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 11/18] arm64: timer: Write to
 ICENABLER to disable timer IRQ
Message-ID: <20200103133624.42ca314c@donnerap.cambridge.arm.com>
In-Reply-To: <1577808589-31892-12-git-send-email-alexandru.elisei@arm.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
        <1577808589-31892-12-git-send-email-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 31 Dec 2019 16:09:42 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> According the Generic Interrupt Controller versions 2, 3 and 4 architecture
> specifications, a write of 0 to the GIC{D,R}_ISENABLER{,0} registers is
> ignored; this is also how KVM emulates the corresponding register. Write
> instead to the ICENABLER register when disabling the timer interrupt.
> 
> Note that fortunately for us, the timer test was still working as intended
> because KVM does the sensible thing and all interrupts are disabled by
> default when creating a VM.

Indeed, good catch!

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  lib/arm/asm/gic-v3.h |  1 +
>  lib/arm/asm/gic.h    |  1 +
>  arm/timer.c          | 22 +++++++++++-----------
>  3 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 347be2f9da17..0dc838b3ab2d 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -31,6 +31,7 @@
>  /* Re-Distributor registers, offsets from SGI_base */
>  #define GICR_IGROUPR0			GICD_IGROUPR
>  #define GICR_ISENABLER0			GICD_ISENABLER
> +#define GICR_ICENABLER0			GICD_ICENABLER
>  #define GICR_IPRIORITYR0		GICD_IPRIORITYR
>  
>  #define ICC_SGI1R_AFFINITY_1_SHIFT	16
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index 1fc10a096259..09826fd5bc29 100644
> --- a/lib/arm/asm/gic.h
> +++ b/lib/arm/asm/gic.h
> @@ -15,6 +15,7 @@
>  #define GICD_IIDR			0x0008
>  #define GICD_IGROUPR			0x0080
>  #define GICD_ISENABLER			0x0100
> +#define GICD_ICENABLER			0x0180
>  #define GICD_ISPENDR			0x0200
>  #define GICD_ICPENDR			0x0280
>  #define GICD_ISACTIVER			0x0300
> diff --git a/arm/timer.c b/arm/timer.c
> index b30fd6b6d90b..f390e8e65d31 100644
> --- a/arm/timer.c
> +++ b/arm/timer.c
> @@ -17,6 +17,9 @@
>  #define ARCH_TIMER_CTL_ISTATUS (1 << 2)
>  
>  static void *gic_ispendr;
> +static void *gic_isenabler;
> +static void *gic_icenabler;
> +
>  static bool ptimer_unsupported;
>  
>  static void ptimer_unsupported_handler(struct pt_regs *regs, unsigned int esr)
> @@ -132,19 +135,12 @@ static struct timer_info ptimer_info = {
>  
>  static void set_timer_irq_enabled(struct timer_info *info, bool enabled)
>  {
> -	u32 val = 0;
> +	u32 val = 1 << PPI(info->irq);
>  
>  	if (enabled)
> -		val = 1 << PPI(info->irq);
> -
> -	switch (gic_version()) {
> -	case 2:
> -		writel(val, gicv2_dist_base() + GICD_ISENABLER + 0);
> -		break;
> -	case 3:
> -		writel(val, gicv3_sgi_base() + GICR_ISENABLER0);
> -		break;
> -	}
> +		writel(val, gic_isenabler);
> +	else
> +		writel(val, gic_icenabler);
>  }
>  
>  static void irq_handler(struct pt_regs *regs)
> @@ -306,9 +302,13 @@ static void test_init(void)
>  	switch (gic_version()) {
>  	case 2:
>  		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
> +		gic_isenabler = gicv2_dist_base() + GICD_ISENABLER;
> +		gic_icenabler = gicv2_dist_base() + GICD_ICENABLER;
>  		break;
>  	case 3:
>  		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
> +		gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
> +		gic_icenabler = gicv3_sgi_base() + GICR_ICENABLER0;
>  		break;
>  	}
>  

