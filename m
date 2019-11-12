Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9B56F9603
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 17:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLQvH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 11:51:07 -0500
Received: from foss.arm.com ([217.140.110.172]:37380 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfKLQvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 11:51:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DDF730E;
        Tue, 12 Nov 2019 08:51:06 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9B1C83F534;
        Tue, 12 Nov 2019 08:51:05 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 10/17] arm: gic: Check for writable IGROUPR
 registers
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-11-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <30e68410-9ed4-91db-df2e-60272d4cd877@arm.com>
Date:   Tue, 12 Nov 2019 16:51:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-11-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/8/19 2:42 PM, Andre Przywara wrote:
> When both groups are avaiable to the non-secure side, the MMIO group
> registers need to be writable, so that the group that an IRQ belongs to
> can be programmed.
>
> Check that the group can be flipped, after having established that both
> groups are usable.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/arm/gic.c b/arm/gic.c
> index c882a24..485ca4f 100644
> --- a/arm/gic.c
> +++ b/arm/gic.c
> @@ -683,6 +683,7 @@ static bool gicv3_check_security(void *gicd_base)
>  static void test_irq_group(void *gicd_base)
>  {
>  	bool is_gicv3 = (gic_version() == 3);
> +	u32 reg;

The return value for gic_get_irq_group is an int, not a u32. Also, maybe it should
be named group instead, so it's clear what it represents.

>  
>  	report_prefix_push("GROUP");
>  	gic_enable_defaults();
> @@ -692,6 +693,16 @@ static void test_irq_group(void *gicd_base)
>  		if (!gicv3_check_security(gicd_base))
>  			return;
>  	}
> +
> +	/*
> +	 * On a security aware GIC in non-secure world the IGROUPR registers
> +	 * are RAZ/WI. KVM emulates a single-security-state GIC, so both
> +	 * groups are available and the IGROUPR registers are writable.
> +	 */
> +	reg = gic_get_irq_group(SPI_IRQ);
> +	gic_set_irq_group(SPI_IRQ, !reg);
> +	report("IGROUPR is writable", gic_get_irq_group(SPI_IRQ) != reg);

This is nitpicking, but from a consistency point of view, shouldn't you check that
the new group is the value that you wrote, meaning the check should be
gic_get_irq_group(SPI_IRQ) == !reg?

Thanks,
Alex
> +	gic_set_irq_group(SPI_IRQ, reg);
>  }
>  
>  static void spi_send(void)
