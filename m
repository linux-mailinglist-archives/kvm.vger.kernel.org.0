Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800C417A28A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 10:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgCEJzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 04:55:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25994 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726894AbgCEJzp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 04:55:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583402144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FnaOhUEEp4ixgrxIblQ3sOZbWx4F9Y2Z3bAC6bzny3E=;
        b=fS4xt7Fyf4Ry4nrEl0+fvZGRhSJvrxv2pBYIiF7OsTlIjAYGlM+gCBMQr+BToZmgA2rGeO
        Jd3ige0hQJg9L28RqGk5RqVr7p0J4rGddthjfkTpvYsAMTApDqevb9128W8E//hRdU+bvI
        npmrfY87c/THbQzT9GdHU45p+sz5juc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-Y_1Vf6i3Psqe3E0_EoVB9Q-1; Thu, 05 Mar 2020 04:55:40 -0500
X-MC-Unique: Y_1Vf6i3Psqe3E0_EoVB9Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C584800053;
        Thu,  5 Mar 2020 09:55:38 +0000 (UTC)
Received: from kamzik.brq.redhat.com (ovpn-204-110.brq.redhat.com [10.40.204.110])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E9FDA8B75A;
        Thu,  5 Mar 2020 09:55:32 +0000 (UTC)
Date:   Thu, 5 Mar 2020 10:55:29 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        peter.maydell@linaro.org, andrew.murray@arm.com,
        alexandru.elisei@arm.com, andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 8/9] arm: gic: Provide per-IRQ helper
 functions
Message-ID: <20200305095529.hkdyhghkofquat75@kamzik.brq.redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
 <20200130112510.15154-9-eric.auger@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130112510.15154-9-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 30, 2020 at 12:25:09PM +0100, Eric Auger wrote:
> From: Andre Przywara <andre.przywara@arm.com>
> 
> A common theme when accessing per-IRQ parameters in the GIC distributor
> is to set fields of a certain bit width in a range of MMIO registers.
> Examples are the enabled status (one bit per IRQ), the level/edge
> configuration (2 bits per IRQ) or the priority (8 bits per IRQ).
> 
> Add a generic helper function which is able to mask and set the
> respective number of bits, given the IRQ number and the MMIO offset.
> Provide wrappers using this function to easily allow configuring an IRQ.
> 
> For now assume that private IRQ numbers always refer to the current CPU.
> In a GICv2 accessing the "other" private IRQs is not easily doable (the
> registers are banked per CPU on the same MMIO address), so we impose the
> same limitation on GICv3, even though those registers are not banked
> there anymore.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Missing Eric's s-b.

> 
> ---
> 
> initialize reg
> ---
>  lib/arm/asm/gic-v3.h |  2 +
>  lib/arm/asm/gic.h    |  9 +++++
>  lib/arm/gic.c        | 90 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 101 insertions(+)
> 
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index 347be2f..4a445a5 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -23,6 +23,8 @@
>  #define GICD_CTLR_ENABLE_G1A		(1U << 1)
>  #define GICD_CTLR_ENABLE_G1		(1U << 0)
>  
> +#define GICD_IROUTER			0x6000
> +
>  /* Re-Distributor registers, offsets from RD_base */
>  #define GICR_TYPER			0x0008
>  
> diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
> index 1fc10a0..21cdb58 100644
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
> @@ -73,5 +74,13 @@ extern void gic_write_eoir(u32 irqstat);
>  extern void gic_ipi_send_single(int irq, int cpu);
>  extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
>  
> +void gic_set_irq_bit(int irq, int offset);
> +void gic_enable_irq(int irq);
> +void gic_disable_irq(int irq);
> +void gic_set_irq_priority(int irq, u8 prio);
> +void gic_set_irq_target(int irq, int cpu);
> +void gic_set_irq_group(int irq, int group);
> +int gic_get_irq_group(int irq);
> +
>  #endif /* !__ASSEMBLY__ */
>  #endif /* _ASMARM_GIC_H_ */
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 9430116..aa9cb86 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -146,3 +146,93 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
>  	assert(gic_common_ops && gic_common_ops->ipi_send_mask);
>  	gic_common_ops->ipi_send_mask(irq, dest);
>  }
> +
> +enum gic_bit_access {
> +	ACCESS_READ,
> +	ACCESS_SET,
> +	ACCESS_RMW
> +};
> +
> +static u8 gic_masked_irq_bits(int irq, int offset, int bits, u8 value,
> +			      enum gic_bit_access access)
> +{
> +	void *base;
> +	int split = 32 / bits;
> +	int shift = (irq % split) * bits;
> +	u32 reg = 0, mask = ((1U << bits) - 1) << shift;
> +
> +	switch (gic_version()) {
> +	case 2:
> +		base = gicv2_dist_base();
> +		break;
> +	case 3:
> +		if (irq < 32)
> +			base = gicv3_sgi_base();
> +		else
> +			base = gicv3_dist_base();
> +		break;
> +	default:
> +		return 0;
> +	}
> +	base += offset + (irq / split) * 4;
> +
> +	switch (access) {
> +	case ACCESS_READ:
> +		return (readl(base) & mask) >> shift;
> +	case ACCESS_SET:
> +		reg = 0;
> +		break;
> +	case ACCESS_RMW:
> +		reg = readl(base) & ~mask;
> +		break;
> +	}
> +
> +	writel(reg | ((u32)value << shift), base);
> +
> +	return 0;
> +}
> +
> +void gic_set_irq_bit(int irq, int offset)
> +{
> +	gic_masked_irq_bits(irq, offset, 1, 1, ACCESS_SET);
> +}
> +
> +void gic_enable_irq(int irq)
> +{
> +	gic_set_irq_bit(irq, GICD_ISENABLER);
> +}
> +
> +void gic_disable_irq(int irq)
> +{
> +	gic_set_irq_bit(irq, GICD_ICENABLER);
> +}
> +
> +void gic_set_irq_priority(int irq, u8 prio)
> +{
> +	gic_masked_irq_bits(irq, GICD_IPRIORITYR, 8, prio, ACCESS_RMW);
> +}
> +
> +void gic_set_irq_target(int irq, int cpu)
> +{
> +	if (irq < 32)
> +		return;
> +
> +	if (gic_version() == 2) {
> +		gic_masked_irq_bits(irq, GICD_ITARGETSR, 8, 1U << cpu,
> +				    ACCESS_RMW);
> +
> +		return;
> +	}
> +
> +	writeq(cpus[cpu], gicv3_dist_base() + GICD_IROUTER + irq * 8);
> +}
> +
> +void gic_set_irq_group(int irq, int group)
> +{
> +	gic_masked_irq_bits(irq, GICD_IGROUPR, 1, group, ACCESS_RMW);
> +}
> +
> +int gic_get_irq_group(int irq)
> +{
> +	return gic_masked_irq_bits(irq, GICD_IGROUPR, 1, 0, ACCESS_READ);
> +}
> -- 
> 2.20.1
> 
>

Looks good to me.

Thanks,
drew

