Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63CC1829E4
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 08:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388146AbgCLHmD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 03:42:03 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11669 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388086AbgCLHmD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 03:42:03 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 832CF39499E54775AFE3;
        Thu, 12 Mar 2020 15:41:58 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Mar 2020
 15:41:52 +0800
Subject: Re: [PATCH v5 11/23] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
To:     Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-12-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <da2fd5bc-0fe3-df3a-090f-0b5ce378a34a@huawei.com>
Date:   Thu, 12 Mar 2020 15:41:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-12-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

Some checkpatch errors below:

On 2020/3/5 4:33, Marc Zyngier wrote:
> To implement the get/set_irqchip_state callbacks (limited to the
> PENDING state), we have to use a particular set of hacks:
> 
> - Reading the pending state is done by using a pair of new redistributor
>    registers (GICR_VSGIR, GICR_VSGIPENDR), which allow the 16 interrupts
>    state to be retrieved.
> - Setting the pending state is done by generating it as we'd otherwise do
>    for a guest (writing to GITS_SGIR).
> - Clearing the pending state is done by emiting a VSGI command with the
>    "clear" bit set.
> 
> This requires some interesting locking though:
> - When talking to the redistributor, we must make sure that the VPE
>    affinity doesn't change, hence taking the VPE lock.
> - At the same time, we must ensure that nobody accesses the same
>    redistributor's GICR_VSGI*R registers for a different VPE, which
>    would corrupt the reading of the pending bits. We thus take the
>    per-RD spinlock. Much fun.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 73 ++++++++++++++++++++++++++++++
>   include/linux/irqchip/arm-gic-v3.h | 14 ++++++
>   2 files changed, 87 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index c93f178914ee..fb2b836c31ff 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3962,11 +3962,84 @@ static int its_sgi_set_affinity(struct irq_data *d,
>   	return -EINVAL;
>   }
>   
> +static int its_sgi_set_irqchip_state(struct irq_data *d,
> +				     enum irqchip_irq_state which,
> +				     bool state)
> +{
> +	if (which != IRQCHIP_STATE_PENDING)
> +		return -EINVAL;
> +
> +	if (state) {
> +		struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +		struct its_node *its = find_4_1_its();
> +		u64 val;
> +
> +		val  = FIELD_PREP(GITS_SGIR_VPEID, vpe->vpe_id);
> +		val |= FIELD_PREP(GITS_SGIR_VINTID, d->hwirq);
> +		writeq_relaxed(val, its->sgir_base + GITS_SGIR - SZ_128K);
> +	} else {
> +		its_configure_sgi(d, true);
> +	}
> +
> +	return 0;
> +}
> +
> +static int its_sgi_get_irqchip_state(struct irq_data *d,
> +				     enum irqchip_irq_state which, bool *val)
> +{
> +	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> +	void __iomem *base;
> +	unsigned long flags;
> +	u32 count = 1000000;	/* 1s! */
> +	u32 status;
> +	int cpu;
> +
> +	if (which != IRQCHIP_STATE_PENDING)
> +		return -EINVAL;
> +
> +	/*
> +	 * Locking galore! We can race against two different events:
> +	 *
> +	 * - Concurent vPE affinity change: we must make sure it cannot
> +         *   happen, or we'll talk to the wrong redistributor. This is
> +         *   identical to what happens with vLPIs.

code indent should use tabs where possible

> +	 *
> +	 * - Concurrent VSGIPENDR access: As it involves accessing two
> +         *   MMIO registers, this must be made atomic one way or another.

The same here.

> +	 */
> +	cpu = vpe_to_cpuid_lock(vpe, &flags);
> +	raw_spin_lock(&gic_data_rdist_cpu(cpu)->rd_lock);
> +	base = gic_data_rdist_cpu(cpu)->rd_base + SZ_128K;
> +	writel_relaxed(vpe->vpe_id, base + GICR_VSGIR);
> +	do {
> +		status = readl_relaxed(base + GICR_VSGIPENDR);
> +		if (!(status & GICR_VSGIPENDR_BUSY))
> +			goto out;
> +
> +		count--;
> +		if (!count) {
> +			pr_err_ratelimited("Unable to get SGI status\n");
> +			goto out;
> +		}
> +		cpu_relax();
> +		udelay(1);
> +	} while(count);

space required before the open parenthesis '('

> +
> +out:
> +	raw_spin_unlock(&gic_data_rdist_cpu(cpu)->rd_lock);
> +	vpe_to_cpuid_unlock(vpe, flags);
> +	*val = !!(status & (1 << d->hwirq));
> +
> +	return 0;
> +}
> +
>   static struct irq_chip its_sgi_irq_chip = {
>   	.name			= "GICv4.1-sgi",
>   	.irq_mask		= its_sgi_mask_irq,
>   	.irq_unmask		= its_sgi_unmask_irq,
>   	.irq_set_affinity	= its_sgi_set_affinity,
> +	.irq_set_irqchip_state	= its_sgi_set_irqchip_state,
> +	.irq_get_irqchip_state	= its_sgi_get_irqchip_state,
>   };
>   
>   static int its_sgi_irq_domain_alloc(struct irq_domain *domain,
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index fd3be49ac9a5..830d2abf14b3 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -345,6 +345,15 @@
>   #define GICR_VPENDBASER_4_1_VGRP1EN	(1ULL << 58)
>   #define GICR_VPENDBASER_4_1_VPEID	GENMASK_ULL(15, 0)
>   
> +#define GICR_VSGIR			0x0080
> +
> +#define GICR_VSGIR_VPEID		GENMASK(15, 0)
> +
> +#define GICR_VSGIPENDR			0x0088
> +
> +#define GICR_VSGIPENDR_BUSY		(1U << 31)
> +#define GICR_VSGIPENDR_PENDING		GENMASK(15, 0)
> +
>   /*
>    * ITS registers, offsets from ITS_base
>    */
> @@ -368,6 +377,11 @@
>   
>   #define GITS_TRANSLATER			0x10040
>   
> +#define GITS_SGIR			0x20020
> +
> +#define GITS_SGIR_VPEID			GENMASK_ULL(47, 32)
> +#define GITS_SGIR_VINTID		GENMASK_ULL(7, 0)

GENMASK_ULL(3, 0), though not a problem.  Besides,

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

