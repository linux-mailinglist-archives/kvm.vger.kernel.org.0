Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB1F0F8FF9
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 13:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfKLMv7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Nov 2019 07:51:59 -0500
Received: from foss.arm.com ([217.140.110.172]:33364 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfKLMv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Nov 2019 07:51:59 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3375C30E;
        Tue, 12 Nov 2019 04:51:58 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 433503F6C4;
        Tue, 12 Nov 2019 04:51:57 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH 03/17] arm: gic: Provide per-IRQ helper
 functions
To:     Andre Przywara <andre.przywara@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>
References: <20191108144240.204202-1-andre.przywara@arm.com>
 <20191108144240.204202-4-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9cc460d1-c01f-6b0a-c6be-292a63174d68@arm.com>
Date:   Tue, 12 Nov 2019 12:51:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191108144240.204202-4-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/8/19 2:42 PM, Andre Przywara wrote:
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
> ---
>  lib/arm/asm/gic-v3.h |  1 +
>  lib/arm/asm/gic.h    |  9 +++++
>  lib/arm/gic.c        | 90 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 100 insertions(+)
>
> diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
> index ed6a5ad..8cfaed1 100644
> --- a/lib/arm/asm/gic-v3.h
> +++ b/lib/arm/asm/gic-v3.h
> @@ -23,6 +23,7 @@
>  #define GICD_CTLR_ENABLE_G1A		(1U << 1)
>  #define GICD_CTLR_ENABLE_G1		(1U << 0)
>  
> +#define GICD_IROUTER			0x6000
>  #define GICD_PIDR2			0xffe8
>  
>  /* Re-Distributor registers, offsets from RD_base */
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
> index 9430116..cf4e811 100644
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
> +	u32 reg, mask = ((1U << bits) - 1) << shift;
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

This is probably not what you intended, if irq = 4 and split = 8, (irq / split) *
4 = 0. On the other hand, irq * 4 / split = 2.

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
This function looks a bit out of place:
- the function name has a verb in the past tense ('masked'), which makes me think
it should return a bool, but the function actually performs an access to a GIC
register.
- the return value is an u8, but it returns an u32 on a read, because readl
returns an u32.
- the semantics of the function and the return value change based on the access
parameter; worse yet, the return value on a write is completely ignored by the
callers and the value parameter is ignored on reads.

You could split it into separate functions - see below.

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

The pattern for the public functions in this file is to check that the GIC has
been initialized (assert(gic_common_ops)).

I propose we rewrite the functions like this (compile tested only):

diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 94301169215c..1f5aa7b48828 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -146,3 +146,89 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
        assert(gic_common_ops && gic_common_ops->ipi_send_mask);
        gic_common_ops->ipi_send_mask(irq, dest);
 }
+
+static void *gic_get_irq_reg(int irq, int offset, int width)
+{
+       void *base;
+
+       switch (gic_version()) {
+       case 2:
+               base = gicv2_dist_base();
+               break;
+       case 3:
+               if (irq < 32)
+                       base = gicv3_sgi_base();
+               else
+                       base = gicv3_dist_base();
+               break;
+       default:
+               return 0;
+       }
+
+       return base + offset + (irq * width / 32);
+}
+
+static void gic_set_irq_field(int irq, int offset, int width, u32 value)
+{
+       void *reg;
+       u32 val;
+       int shift = (irq * width) % 32;
+       u32 mask = ((1U << width) - 1) << shift;
+
+       reg = gic_get_irq_reg(irq, offset, width);
+       val = readl(reg);
+       val = (val & ~mask) | (value << shift);
+       writel(val, reg);
+}
+
+void gic_enable_irq(int irq)
+{
+       assert(gic_common_ops);
+       gic_set_irq_field(irq, GICD_ISENABLER, 1, 1);
+}
+
+void gic_disable_irq(int irq)
+{
+       assert(gic_common_ops);
+       gic_set_irq_field(irq, GICD_ICENABLER, 1, 1);
+}
+
+void gic_set_irq_priority(int irq, u8 prio)
+{
+       assert(gic_common_ops);
+       gic_set_irq_field(irq, GICD_IPRIORITYR, 8, prio);
+}
+
+void gic_set_irq_target(int irq, int cpu)
+{
+       assert(gic_common_ops);
+
+       if (irq < 32)
+               return;
+
+       if (gic_version() == 2) {
+               gic_set_irq_field(irq, GICD_ITARGETSR, 8, 1U << cpu);
+               return;
+       }
+
+       writeq(cpus[cpu], gicv3_dist_base() + GICD_IROUTER + irq * 8);
+}
+
+void gic_set_irq_group(int irq, int group)
+{
+       assert(gic_common_ops);
+       gic_set_irq_field(irq, GICD_IGROUPR, 1, 1);
+}
+
+int gic_get_irq_group(int irq)
+{
+       void *reg;
+       u32 val;
+       int shift = irq % 32;
+
+       assert(gic_common_ops);
+       reg = gic_get_irq_reg(irq, GICD_IGROUPR, 1);
+       val = readl(reg);
+
+       return (val >> shift) & 0x1;
+}

A bit more lines of code, but to me more readable. What do you think?


