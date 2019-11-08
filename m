Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A649DF528C
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 18:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbfKHR2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 12:28:42 -0500
Received: from foss.arm.com ([217.140.110.172]:47402 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbfKHR2m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 12:28:42 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D278A31B;
        Fri,  8 Nov 2019 09:28:41 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8A0F63F6C4;
        Fri,  8 Nov 2019 09:28:40 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 01/17] arm: gic: Enable GIC MMIO tests for
 GICv3 as well
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-2-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <cc2a6815-89f7-4a3a-1d7f-9b834c064486@arm.com>
Date:   Fri, 8 Nov 2019 17:28:38 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-2-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 11/8/19 2:42 PM, Andre Przywara wrote:
> So far the GIC MMIO tests were only enabled for a GICv2 guest. Modern
> machines tend to have a GICv3-only GIC, so can't run those tests.
> It turns out that most GIC distributor registers we test in the unit
> tests are actually the same in GICv3, so we can just enable those tests
> for GICv3 guests as well.
> The only exception is the CPU number in the TYPER register, which is
> only valid in the GICv2 compat mode (ARE=0), which KVM does not support.
> So we protect this test against running on a GICv3 guest.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c            | 13 +++++++++++--
>  arm/unittests.cfg    | 26 ++++++++++++++++++++++----
>  lib/arm/asm/gic-v3.h |  2 ++
>  3 files changed, 35 insertions(+), 6 deletions(-)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index adb6aa4..04b3337 100644
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
> @@ -496,7 +497,14 @@ static void gic_test_mmio(void)
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
> @@ -505,7 +513,8 @@ static void gic_test_mmio(void)
>  	nr_irqs = GICD_TYPER_IRQS(reg);
>  	report_info("number of implemented SPIs: %d", nr_irqs - GIC_FIRST_SPI);
>  
> -	test_typer_v2(reg);
> +	if (gic_version() == 0x2)
> +		test_typer_v2(reg);
>  
>  	report_info("IIDR: 0x%08x", readl(gic_dist_base + GICD_IIDR));

More context:

@@ -489,30 +490,38 @@ static void gic_test_mmio(void)
        u32 reg;
        int nr_irqs;
        void *gic_dist_base, *idreg;
 
        switch(gic_version()) {
        case 0x2:
                gic_dist_base = gicv2_dist_base();
                idreg = gic_dist_base + GICD_ICPIDR2;
                break;
        case 0x3:
-               report_abort("GICv3 MMIO tests NYI");
+               /*
+                * We only test generic registers or those affecting
+                * SPIs, so don't need to consider the SGI base in
+                * the redistributor here.
+                */
+               gic_dist_base = gicv3_dist_base();
+               idreg = gic_dist_base + GICD_PIDR2;
+               break;
        default:
                report_abort("GIC version %d not supported", gic_version());
        }
 
        reg = readl(gic_dist_base + GICD_TYPER);
        nr_irqs = GICD_TYPER_IRQS(reg);
        report_info("number of implemented SPIs: %d", nr_irqs - GIC_FIRST_SPI);
 
-       test_typer_v2(reg);
+       if (gic_version() == 0x2)
+               test_typer_v2(reg);
 
        report_info("IIDR: 0x%08x", readl(gic_dist_base + GICD_IIDR));
 
        report("GICD_TYPER is read-only",
               test_readonly_32(gic_dist_base + GICD_TYPER, false));
        report("GICD_IIDR is read-only",
               test_readonly_32(gic_dist_base + GICD_IIDR, false));
 
        reg = readl(idreg);
        report("ICPIDR2 is read-only", test_readonly_32(idreg, false));

In the case of GICv3, the register is GICD_PIDR2, not ICPIDR2. You can probably
use a different variable to store the identification register name.

>  
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index daeb5a0..12ac142 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -86,28 +86,46 @@ smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params = -machine gic-version=2 -append 'ipi'
>  groups = gic
>  
> -[gicv2-mmio]
> +[gicv3-ipi]
> +file = gic.flat
> +smp = $MAX_SMP
> +extra_params = -machine gic-version=3 -append 'ipi'
> +groups = gic
> +
> +[gicv2-max-mmio]

The renaming is not mentioned in the commit message. If you want to rename these
tests, can you rename them to gic{v2,v3}-mmio-max so they're consistent with the
other test names?

Thanks,
Alex
>  file = gic.flat
>  smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
>  extra_params = -machine gic-version=2 -append 'mmio'
>  groups = gic
>  
> +[gicv3-max-mmio]
> +file = gic.flat
> +smp = $MAX_SMP
> +extra_params = -machine gic-version=3 -append 'mmio'
> +groups = gic
> +
>  [gicv2-mmio-up]
>  file = gic.flat
>  smp = 1
>  extra_params = -machine gic-version=2 -append 'mmio'
>  groups = gic
>  
> +[gicv3-mmio-up]
> +file = gic.flat
> +smp = 1
> +extra_params = -machine gic-version=3 -append 'mmio'
> +groups = gic
> +
>  [gicv2-mmio-3p]
>  file = gic.flat
>  smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
>  extra_params = -machine gic-version=2 -append 'mmio'
>  groups = gic
>  
> -[gicv3-ipi]
> +[gicv3-mmio-3p]
>  file = gic.flat
> -smp = $MAX_SMP
> -extra_params = -machine gic-version=3 -append 'ipi'
> +smp = $((($MAX_SMP < 3)?$MAX_SMP:3))
> +extra_params = -machine gic-version=2 -append 'mmio'
>  groups = gic
>  
>  [gicv2-active]
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 347be2f..ed6a5ad 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -23,6 +23,8 @@
>  #define GICD_CTLR_ENABLE_G1A		(1U << 1)
>  #define GICD_CTLR_ENABLE_G1		(1U << 0)
>  
> +#define GICD_PIDR2			0xffe8
> +
>  /* Re-Distributor registers, offsets from RD_base */
>  #define GICR_TYPER			0x0008
>  
