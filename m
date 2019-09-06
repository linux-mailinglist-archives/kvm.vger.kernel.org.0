Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6B2AB297
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 08:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390522AbfIFGsm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 02:48:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48384 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731817AbfIFGsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 02:48:41 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22894190C032;
        Fri,  6 Sep 2019 06:48:41 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 102BA60A97;
        Fri,  6 Sep 2019 06:48:39 +0000 (UTC)
Date:   Fri, 6 Sep 2019 08:48:37 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH kvm-unit-tests] arm: gic: enable GIC MMIO tests for GICv3
 as well
Message-ID: <20190906064837.6afynobk3p6a64hv@kamzik.brq.redhat.com>
References: <20190905172114.215380-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905172114.215380-1-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Fri, 06 Sep 2019 06:48:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 05, 2019 at 06:21:14PM +0100, Andre Przywara wrote:
> So far the GIC MMIO tests were only enabled for a GICv2 guest. Modern
> machines tend to have a GICv3-only GIC, so can't run those guests.
> It turns out that most GIC distributor registers we test in the unit
> tests are actually the same in GICv3, so we can just enable those tests
> for GICv3 guests as well.
> The only exception is the CPU number in the TYPER register, which we
> just protect against running on a GICv3 guest.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c         | 13 +++++++++++--
>  arm/unittests.cfg | 16 +++++++++++-----
>  lib/arm/asm/gic.h |  2 ++
>  3 files changed, 24 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/gic.c b/arm/gic.c
> index ed5642e..bd3c027 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -6,6 +6,7 @@
>   *   + MMIO access tests
>   * GICv3
>   *   + test sending/receiving IPIs
> + *   + MMIO access tests
>   *
>   * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
>   *
> @@ -483,7 +484,14 @@ static void gic_test_mmio(void)
>  		idreg = gic_dist_base + GICD_ICPIDR2;
>  		break;
>  	case 0x3:
> -		report_abort("GICv3 MMIO tests NYI");
> +		/*
> +		 * We only test generic registers or those affecting
> +		 * SPIs, so don't need to consider the SGI base in
> +		 * the redistributor here.
> +		 */
> +		gic_dist_base = gicv3_dist_base();
> +		idreg = gic_dist_base + GICD_PIDR2;
> +		break;
>  	default:
>  		report_abort("GIC version %d not supported", gic_version());
>  	}
> @@ -492,7 +500,8 @@ static void gic_test_mmio(void)
>  	nr_irqs = GICD_TYPER_IRQS(reg);
>  	report_info("number of implemented SPIs: %d", nr_irqs - GIC_FIRST_SPI);
>  
> -	test_typer_v2(reg);
> +	if (gic_version() == 0x2)
> +		test_typer_v2(reg);
>  
>  	report_info("IIDR: 0x%08x", readl(gic_dist_base + GICD_IIDR));
>  
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 6d3df92..3fd5b04 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -86,22 +86,28 @@ smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params = -machine gic-version=2 -append 'ipi'
>  groups = gic
>  
> -[gicv2-mmio]
> +[gicv2-max-mmio]
>  file = gic.flat
>  smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params = -machine gic-version=2 -append 'mmio'
>  groups = gic
>  
> -[gicv2-mmio-up]
> +[gicv3-max-mmio]
> +file = gic.flat
> +smp = $MAX_SMP
> +extra_params = -machine gic-version=3 -append 'mmio'
> +groups = gic
> +
> +[gic-mmio-up]
>  file = gic.flat
>  smp = 1
> -extra_params = -machine gic-version=2 -append 'mmio'
> +extra_params = -append 'mmio'
>  groups = gic
>  
> -[gicv2-mmio-3p]
> +[gic-mmio-3p]
>  file = gic.flat
>  smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
> -extra_params = -machine gic-version=2 -append 'mmio'
> +extra_params = -append 'mmio'
>  groups = gic
>  
>  [gicv3-ipi]
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index f6dfb90..ffed025 100644
> --- a/lib/arm/asm/gic.h
> +++ b/lib/arm/asm/gic.h
> @@ -23,6 +23,8 @@
>  #define GICD_ITARGETSR			0x0800
>  #define GICD_SGIR			0x0f00
>  #define GICD_ICPIDR2			0x0fe8
> +/* only in GICv3 */
> +#define GICD_PIDR2			0xffe8

If this is gicv3-only, then shouldn't it go to lib/arm/asm/gic-v3.h ?

>  
>  #define GICD_TYPER_IRQS(typer)		((((typer) & 0x1f) + 1) * 32)
>  #define GICD_INT_EN_SET_SGI		0x0000ffff
> -- 
> 2.17.1
> 

Otherwise

Reviewed-by: Andrew Jones <drjones@redhat.com>
