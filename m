Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A37716213F
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 08:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgBRHBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 02:01:07 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:49720 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726072AbgBRHBG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 02:01:06 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4669D921C802E35843D2;
        Tue, 18 Feb 2020 15:01:03 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Tue, 18 Feb 2020
 15:00:55 +0800
Subject: Re: [PATCH v4 08/20] irqchip/gic-v4.1: Plumb get/set_irqchip_state
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
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-9-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <4b7f71f1-5e7f-e6af-f47d-7ed0d3a8739f@huawei.com>
Date:   Tue, 18 Feb 2020 15:00:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200214145736.18550-9-maz@kernel.org>
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

On 2020/2/14 22:57, Marc Zyngier wrote:
> To implement the get/set_irqchip_state callbacks (limited to the
> PENDING state), we have to use a particular set of hacks:
> 
> - Reading the pending state is done by using a pair of new redistributor
>    registers (GICR_VSGIR, GICR_VSGIPENDR), which allow the 16 interrupts
>    state to be retrieved.
> - Setting the pending state is done by generating it as we'd otherwise do
>    for a guest (writing to GITS_SGIR)
> - Clearing the pending state is done by emiting a VSGI command with the
>    "clear" bit set.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 56 ++++++++++++++++++++++++++++++
>   include/linux/irqchip/arm-gic-v3.h | 14 ++++++++
>   2 files changed, 70 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 1e448d9a16ea..a9753435c4ff 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -3915,11 +3915,67 @@ static int its_sgi_set_affinity(struct irq_data *d,
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
> +	void __iomem *base = gic_data_rdist_cpu(vpe->col_idx)->rd_base + SZ_128K;

There might be a race on reading the 'vpe->col_idx' against a concurrent
vPE schedule (col_idx will be modified in its_vpe_set_affinity)? Will we
end up accessing the GICR_VSGI* registers of the old redistributor,
while the vPE is now resident on the new one? Or is it harmful?

The same question for direct_lpi_inv(), where 'vpe->col_idx' will be
used in irq_to_cpuid().

> +	u32 count = 1000000;	/* 1s! */
> +	u32 status;
> +
> +	if (which != IRQCHIP_STATE_PENDING)
> +		return -EINVAL;
> +
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
> +
> +out:
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
> index a89578884263..64da945486ac 100644
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

The spec says vINTID field is [3:0] of the GITS_SGIR.


Thanks,
Zenghui

> +
>   #define GITS_CTLR_ENABLE		(1U << 0)
>   #define GITS_CTLR_ImDe			(1U << 1)
>   #define	GITS_CTLR_ITS_NUMBER_SHIFT	4
> 

