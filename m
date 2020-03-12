Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23408182964
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 07:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388016AbgCLG51 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 02:57:27 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11667 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387831AbgCLG50 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 02:57:26 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0A42B9EC5D086AEAD8DE;
        Thu, 12 Mar 2020 14:57:08 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Mar 2020
 14:56:58 +0800
Subject: Re: [PATCH v5 03/23] irqchip/gic-v4.1: Ensure mutual exclusion
 between vPE affinity change and RD access
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
 <20200304203330.4967-4-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <b2c9b596-29b9-d785-3a60-9814d1c35655@huawei.com>
Date:   Thu, 12 Mar 2020 14:56:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-4-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/3/5 4:33, Marc Zyngier wrote:
> Before GICv4.1, all operations would be serialized with the affinity
> changes by virtue of using the same ITS command queue. With v4.1, things
> change, as invalidations (and a number of other operations) are issued
> using the redistributor MMIO frame.
> 
> We must thus make sure that these redistributor accesses cannot race
> against aginst the affinity change, or we may end-up talking to the
          ^^^^^^
> wrong redistributor.
> 
> To ensure this, we expand the irq_to_cpuid() helper to take a spinlock
> when the LPI is mapped to a vLPI (a new per-VPE lock) on each operation
> that requires mutual exclusion.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 56 +++++++++++++++++++++++++-----
>   include/linux/irqchip/arm-gic-v4.h |  5 +++
>   2 files changed, 53 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index da883a691028..1af713990123 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -239,15 +239,41 @@ static struct its_vlpi_map *get_vlpi_map(struct irq_data *d)
>   	return NULL;
>   }
>   
> -static int irq_to_cpuid(struct irq_data *d)
> +static int vpe_to_cpuid_lock(struct its_vpe *vpe, unsigned long *flags)
> +{
> +	raw_spin_lock_irqsave(&vpe->vpe_lock, *flags);
> +	return vpe->col_idx;
> +}
> +
> +static void vpe_to_cpuid_unlock(struct its_vpe *vpe, unsigned long flags)
> +{
> +	raw_spin_unlock_irqrestore(&vpe->vpe_lock, flags);
> +}
> +
> +static int irq_to_cpuid_lock(struct irq_data *d, unsigned long *flags)
>   {
> -	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>   	struct its_vlpi_map *map = get_vlpi_map(d);
> +	int cpu;
>   
> -	if (map)
> -		return map->vpe->col_idx;
> +	if (map) {
> +		cpu = vpe_to_cpuid_lock(map->vpe, flags);
> +	} else {
> +		/* Physical LPIs are already locked via the irq_desc lock */
> +		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +		cpu = its_dev->event_map.col_map[its_get_event_id(d)];
> +		/* Keep GCC quiet... */
> +		*flags = 0;
> +	}
>   
> -	return its_dev->event_map.col_map[its_get_event_id(d)];
> +	return cpu;
> +}
> +
> +static void irq_to_cpuid_unlock(struct irq_data *d, unsigned long flags)
> +{
> +	struct its_vlpi_map *map = get_vlpi_map(d);
> +
> +	if (map)
> +		vpe_to_cpuid_unlock(map->vpe, flags);
>   }
>   
>   static struct its_collection *valid_col(struct its_collection *col)
> @@ -1329,7 +1355,9 @@ static void direct_lpi_inv(struct irq_data *d)
>   {
>   	struct its_vlpi_map *map = get_vlpi_map(d);
>   	void __iomem *rdbase;
> +	unsigned long flags;
>   	u64 val;
> +	int cpu;
>   
>   	if (map) {
>   		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> @@ -1344,10 +1372,12 @@ static void direct_lpi_inv(struct irq_data *d)
>   	}
>   
>   	/* Target the redistributor this LPI is currently routed to */
> -	rdbase = per_cpu_ptr(gic_rdists->rdist, irq_to_cpuid(d))->rd_base;
> +	cpu = irq_to_cpuid_lock(d, &flags);
> +	rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
>   	gic_write_lpir(val, rdbase + GICR_INVLPIR);
>   
>   	wait_for_syncr(rdbase);
> +	irq_to_cpuid_unlock(d, flags);
>   }
>   
>   static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
> @@ -3486,17 +3516,25 @@ static int its_vpe_set_affinity(struct irq_data *d,
>   {
>   	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>   	int from, cpu = cpumask_first(mask_val);
> +	unsigned long flags;
>   
>   	/*
>   	 * Changing affinity is mega expensive, so let's be as lazy as
>   	 * we can and only do it if we really have to. Also, if mapped
>   	 * into the proxy device, we need to move the doorbell
>   	 * interrupt to its new location.
> +	 *
> +	 * Another thing is that changing the affinity of a vPE affects
> +	 * *other interrupts* such as all the vLPIs that are routed to
> +	 * this vPE. This means that the irq_desc lock is not enough to
> +	 * protect us, and that we must ensure nobody samples vpe->col_idx
> +	 * during the update, hence the lock below which must also be
> +	 * taken on any vLPI handling path that evaluates vpe->col_idx.
>   	 */
> -	if (vpe->col_idx == cpu)
> +	from = vpe_to_cpuid_lock(vpe, &flags);
> +	if (from == cpu)
>   		goto out;
>   
> -	from = vpe->col_idx;
>   	vpe->col_idx = cpu;
>   
>   	/*
> @@ -3512,6 +3550,7 @@ static int its_vpe_set_affinity(struct irq_data *d,
>   
>   out:
>   	irq_data_update_effective_affinity(d, cpumask_of(cpu));
> +	vpe_to_cpuid_unlock(vpe, flags);
>   
>   	return IRQ_SET_MASK_OK_DONE;
>   }
> @@ -3855,6 +3894,7 @@ static int its_vpe_init(struct its_vpe *vpe)
>   		return -ENOMEM;
>   	}
>   
> +	raw_spin_lock_init(&vpe->vpe_lock);
>   	vpe->vpe_id = vpe_id;
>   	vpe->vpt_page = vpt_page;
>   	if (gic_rdists->has_rvpeid)
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> index d9c34968467a..439963f4c66a 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -53,6 +53,11 @@ struct its_vpe {
>   		};
>   	};
>   
> +	/*
> +	 * Ensures mutual exclusion between affinity setting of the
> +	 * vPE and vLPI operations using vpe->col_idx.
> +	 */
> +	raw_spinlock_t		vpe_lock;
>   	/*
>   	 * This collection ID is used to indirect the target
>   	 * redistributor for this VPE. The ID itself isn't involved in
> 

