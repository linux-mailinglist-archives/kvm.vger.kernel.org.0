Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48B8A16557D
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 04:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgBTDMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 22:12:01 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10224 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727211AbgBTDMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 22:12:01 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id D666413F5CF89FEEF4BC;
        Thu, 20 Feb 2020 11:11:57 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Feb 2020
 11:11:48 +0800
Subject: Re: [PATCH v4 08/20] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        "Robert Richter" <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Eric Auger" <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Julien Thierry" <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-9-maz@kernel.org>
 <4b7f71f1-5e7f-e6af-f47d-7ed0d3a8739f@huawei.com>
 <75597af0d2373ac4d92d8162a1338cbb@kernel.org>
 <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3d725ede-6631-59fb-1a10-9fb9890f3df6@huawei.com>
Date:   Thu, 20 Feb 2020 11:11:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2020/2/18 23:31, Marc Zyngier wrote:
> diff --git a/drivers/irqchip/irq-gic-v3-its.c 
> b/drivers/irqchip/irq-gic-v3-its.c
> index 7656b353a95f..0ed286dba827 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -144,7 +144,7 @@ struct event_lpi_map {
>       u16            *col_map;
>       irq_hw_number_t        lpi_base;
>       int            nr_lpis;
> -    raw_spinlock_t        vlpi_lock;
> +    raw_spinlock_t        map_lock;

So we use map_lock to protect both LPI's and VLPI's mapping affinity of
a device, and use vpe_lock to protect vPE's affinity, OK.

>       struct its_vm        *vm;
>       struct its_vlpi_map    *vlpi_maps;
>       int            nr_vlpis;
> @@ -240,15 +240,33 @@ static struct its_vlpi_map *get_vlpi_map(struct 
> irq_data *d)
>       return NULL;
>   }
> 
> -static int irq_to_cpuid(struct irq_data *d)
> +static int irq_to_cpuid_lock(struct irq_data *d, unsigned long *flags)
>   {
> -    struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>       struct its_vlpi_map *map = get_vlpi_map(d);
> +    int cpu;
> 
> -    if (map)
> -        return map->vpe->col_idx;
> +    if (map) {
> +        raw_spin_lock_irqsave(&map->vpe->vpe_lock, *flags);
> +        cpu = map->vpe->col_idx;
> +    } else {
> +        struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +        raw_spin_lock_irqsave(&its_dev->event_map.map_lock, *flags);
> +        cpu = its_dev->event_map.col_map[its_get_event_id(d)];
> +    }
> 
> -    return its_dev->event_map.col_map[its_get_event_id(d)];
> +    return cpu;
> +}

This helper is correct for normal LPIs and VLPIs, but wrong for per-vPE
IRQ (doorbell) and vSGIs. irq_data_get_irq_chip_data() gets confused by
both of them.

> +
> +static void irq_to_cpuid_unlock(struct irq_data *d, unsigned long flags)
> +{
> +    struct its_vlpi_map *map = get_vlpi_map(d);
> +
> +    if (map) {
> +        raw_spin_unlock_irqrestore(&map->vpe->vpe_lock, flags);
> +    } else {
> +        struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +        raw_spin_unlock_irqrestore(&its_dev->event_map.map_lock, flags);
> +    }
>   }

The same problem for this helper.

> 
>   static struct its_collection *valid_col(struct its_collection *col)
> @@ -1384,6 +1402,8 @@ static void direct_lpi_inv(struct irq_data *d)
>   {
>       struct its_vlpi_map *map = get_vlpi_map(d);
>       void __iomem *rdbase;
> +    unsigned long flags;
> +    int cpu;
>       u64 val;
> 
>       if (map) {
> @@ -1399,10 +1419,12 @@ static void direct_lpi_inv(struct irq_data *d)
>       }
> 
>       /* Target the redistributor this LPI is currently routed to */
> -    rdbase = per_cpu_ptr(gic_rdists->rdist, irq_to_cpuid(d))->rd_base;
> +    cpu = irq_to_cpuid_lock(d, &flags);
> +    rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
>       gic_write_lpir(val, rdbase + GICR_INVLPIR);
> 
>       wait_for_syncr(rdbase);
> +    irq_to_cpuid_unlock(d, flags);
>   }
> 
>   static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
> @@ -1471,11 +1493,11 @@ static void its_unmask_irq(struct irq_data *d)
>   static int its_set_affinity(struct irq_data *d, const struct cpumask 
> *mask_val,
>                   bool force)
>   {
> -    unsigned int cpu;
>       const struct cpumask *cpu_mask = cpu_online_mask;
>       struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>       struct its_collection *target_col;
> -    u32 id = its_get_event_id(d);
> +    unsigned int from, cpu;
> +    unsigned long flags;
> 
>       /* A forwarded interrupt should use irq_set_vcpu_affinity */
>       if (irqd_is_forwarded_to_vcpu(d))
> @@ -1496,12 +1518,16 @@ static int its_set_affinity(struct irq_data *d, 
> const struct cpumask *mask_val,
>           return -EINVAL;
> 
>       /* don't set the affinity when the target cpu is same as current 
> one */
> -    if (cpu != its_dev->event_map.col_map[id]) {
> +    from = irq_to_cpuid_lock(d, &flags);
> +    if (cpu != from) {
> +        u32 id = its_get_event_id(d);
> +
>           target_col = &its_dev->its->collections[cpu];
>           its_send_movi(its_dev, target_col, id);
>           its_dev->event_map.col_map[id] = cpu;
>           irq_data_update_effective_affinity(d, cpumask_of(cpu));
>       }
> +    irq_to_cpuid_unlock(d, flags);
> 
>       return IRQ_SET_MASK_OK_DONE;
>   }
> @@ -1636,7 +1662,7 @@ static int its_vlpi_map(struct irq_data *d, struct 
> its_cmd_info *info)
>       if (!info->map)
>           return -EINVAL;
> 
> -    raw_spin_lock(&its_dev->event_map.vlpi_lock);
> +    raw_spin_lock(&its_dev->event_map.map_lock);
> 
>       if (!its_dev->event_map.vm) {
>           struct its_vlpi_map *maps;
> @@ -1685,7 +1711,7 @@ static int its_vlpi_map(struct irq_data *d, struct 
> its_cmd_info *info)
>       }
> 
>   out:
> -    raw_spin_unlock(&its_dev->event_map.vlpi_lock);
> +    raw_spin_unlock(&its_dev->event_map.map_lock);
>       return ret;
>   }
> 
> @@ -1695,7 +1721,7 @@ static int its_vlpi_get(struct irq_data *d, struct 
> its_cmd_info *info)
>       struct its_vlpi_map *map;
>       int ret = 0;
> 
> -    raw_spin_lock(&its_dev->event_map.vlpi_lock);
> +    raw_spin_lock(&its_dev->event_map.map_lock);
> 
>       map = get_vlpi_map(d);
> 
> @@ -1708,7 +1734,7 @@ static int its_vlpi_get(struct irq_data *d, struct 
> its_cmd_info *info)
>       *info->map = *map;
> 
>   out:
> -    raw_spin_unlock(&its_dev->event_map.vlpi_lock);
> +    raw_spin_unlock(&its_dev->event_map.map_lock);
>       return ret;
>   }
> 
> @@ -1718,7 +1744,7 @@ static int its_vlpi_unmap(struct irq_data *d)
>       u32 event = its_get_event_id(d);
>       int ret = 0;
> 
> -    raw_spin_lock(&its_dev->event_map.vlpi_lock);
> +    raw_spin_lock(&its_dev->event_map.map_lock);
> 
>       if (!its_dev->event_map.vm || !irqd_is_forwarded_to_vcpu(d)) {
>           ret = -EINVAL;
> @@ -1748,7 +1774,7 @@ static int its_vlpi_unmap(struct irq_data *d)
>       }
> 
>   out:
> -    raw_spin_unlock(&its_dev->event_map.vlpi_lock);
> +    raw_spin_unlock(&its_dev->event_map.map_lock);
>       return ret;
>   }
> 
> @@ -3193,7 +3219,7 @@ static struct its_device *its_create_device(struct 
> its_node *its, u32 dev_id,
>       dev->event_map.col_map = col_map;
>       dev->event_map.lpi_base = lpi_base;
>       dev->event_map.nr_lpis = nr_lpis;
> -    raw_spin_lock_init(&dev->event_map.vlpi_lock);
> +    raw_spin_lock_init(&dev->event_map.map_lock);
>       dev->device_id = dev_id;
>       INIT_LIST_HEAD(&dev->entry);
> 
> @@ -3560,6 +3586,7 @@ static int its_vpe_set_affinity(struct irq_data *d,
>   {
>       struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
>       int from, cpu = cpumask_first(mask_val);
> +    unsigned long flags;
> 
>       /*
>        * Changing affinity is mega expensive, so let's be as lazy as
> @@ -3567,6 +3594,7 @@ static int its_vpe_set_affinity(struct irq_data *d,
>        * into the proxy device, we need to move the doorbell
>        * interrupt to its new location.
>        */
> +    raw_spin_lock_irqsave(&vpe->vpe_lock, flags);
>       if (vpe->col_idx == cpu)
>           goto out;
> 
> @@ -3586,6 +3614,7 @@ static int its_vpe_set_affinity(struct irq_data *d,
> 
>   out:
>       irq_data_update_effective_affinity(d, cpumask_of(cpu));
> +    raw_spin_unlock_irqrestore(&vpe->vpe_lock, flags);
> 
>       return IRQ_SET_MASK_OK_DONE;
>   }
> @@ -3695,11 +3724,15 @@ static void its_vpe_send_inv(struct irq_data *d)
> 
>       if (gic_rdists->has_direct_lpi) {
>           void __iomem *rdbase;
> +        unsigned long flags;
> +        int cpu;
> 
>           /* Target the redistributor this VPE is currently known on */
> -        rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
> +        cpu = irq_to_cpuid_lock(d, &flags);
> +        rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
>           gic_write_lpir(d->parent_data->hwirq, rdbase + GICR_INVLPIR);
>           wait_for_syncr(rdbase);
> +        irq_to_cpuid_unlock(d, flags);
>       } else {
>           its_vpe_send_cmd(vpe, its_send_inv);
>       }

Do we really need to grab the vpe_lock for those which are belong to
the same irqchip with its_vpe_set_affinity()? The IRQ core code should
already ensure the mutual exclusion among them, wrong?

> @@ -3735,14 +3768,18 @@ static int its_vpe_set_irqchip_state(struct 
> irq_data *d,
> 
>       if (gic_rdists->has_direct_lpi) {
>           void __iomem *rdbase;
> +        unsigned long flags;
> +        int cpu;
> 
> -        rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
> +        cpu = irq_to_cpuid_lock(d, &flags);
> +        rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
>           if (state) {
>               gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_SETLPIR);
>           } else {
>               gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_CLRLPIR);
>               wait_for_syncr(rdbase);
>           }
> +        irq_to_cpuid_unlock(d, flags);
>       } else {
>           if (state)
>               its_vpe_send_cmd(vpe, its_send_int);
> @@ -3854,14 +3891,17 @@ static void its_vpe_4_1_deschedule(struct 
> its_vpe *vpe,
>   static void its_vpe_4_1_invall(struct its_vpe *vpe)
>   {
>       void __iomem *rdbase;
> +    unsigned long flags;
>       u64 val;
> 
>       val  = GICR_INVALLR_V;
>       val |= FIELD_PREP(GICR_INVALLR_VPEID, vpe->vpe_id);
> 
>       /* Target the redistributor this vPE is currently known on */
> +    raw_spin_lock_irqsave(&vpe->vpe_lock, flags);
>       rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
>       gic_write_lpir(val, rdbase + GICR_INVALLR);
> +    raw_spin_unlock_irqrestore(&vpe->vpe_lock, flags);
>   }
> 
>   static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void 
> *vcpu_info)
> @@ -3960,13 +4000,17 @@ static int its_sgi_get_irqchip_state(struct 
> irq_data *d,
>                        enum irqchip_irq_state which, bool *val)
>   {
>       struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
> -    void __iomem *base = gic_data_rdist_cpu(vpe->col_idx)->rd_base + 
> SZ_128K;
> +    void __iomem *base;
> +    unsigned long flags;
>       u32 count = 1000000;    /* 1s! */
>       u32 status;
> +    int cpu;
> 
>       if (which != IRQCHIP_STATE_PENDING)
>           return -EINVAL;
> 
> +    cpu = irq_to_cpuid_lock(d, &flags);
> +    base = gic_data_rdist_cpu(cpu)->rd_base + SZ_128K;
>       writel_relaxed(vpe->vpe_id, base + GICR_VSGIR);
>       do {
>           status = readl_relaxed(base + GICR_VSGIPENDR);
> @@ -3983,6 +4027,7 @@ static int its_sgi_get_irqchip_state(struct 
> irq_data *d,
>       } while(count);
> 
>   out:
> +    irq_to_cpuid_unlock(d, flags);
>       *val = !!(status & (1 << d->hwirq));
> 
>       return 0;
> @@ -4102,6 +4147,7 @@ static int its_vpe_init(struct its_vpe *vpe)
>           return -ENOMEM;
>       }
> 
> +    raw_spin_lock_init(&vpe->vpe_lock);
>       vpe->vpe_id = vpe_id;
>       vpe->vpt_page = vpt_page;
>       if (gic_rdists->has_rvpeid)
> diff --git a/include/linux/irqchip/arm-gic-v4.h 
> b/include/linux/irqchip/arm-gic-v4.h
> index 46c167a6349f..fc43a63875a3 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -60,6 +60,7 @@ struct its_vpe {
>           };
>       };
> 
> +    raw_spinlock_t        vpe_lock;
>       /*
>        * This collection ID is used to indirect the target
>        * redistributor for this VPE. The ID itself isn't involved in

I'm not sure if it's good enough, it may gets much clearer after
splitting.


Thanks,
Zenghui

