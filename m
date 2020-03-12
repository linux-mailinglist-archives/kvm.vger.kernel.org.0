Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB53F18298A
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 08:12:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388049AbgCLHMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 03:12:01 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11668 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387767AbgCLHMB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 03:12:01 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 8B7B1AEEF5DC05480B47;
        Thu, 12 Mar 2020 15:11:45 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Mar 2020
 15:11:38 +0800
Subject: Re: [PATCH v5 05/23] irqchip/gic-v4.1: Ensure mutual exclusion betwen
 invalidations on the same RD
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
 <20200304203330.4967-6-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <477e0d45-3ad2-1aee-dd8e-0a771d9cc313@huawei.com>
Date:   Thu, 12 Mar 2020 15:11:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200304203330.4967-6-maz@kernel.org>
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
> The GICv4.1 spec says that it is CONTRAINED UNPREDICTABLE to write to

s/CONTRAINED/CONSTRAINED/

> any of the GICR_INV{LPI,ALL}R registers if GICR_SYNCR.Busy == 1.
> 
> To deal with it, we must ensure that only a single invalidation can
> happen at a time for a given redistributor. Add a per-RD lock to that
> effect and take it around the invalidation/syncr-read to deal with this.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

> ---
>   drivers/irqchip/irq-gic-v3-its.c   | 6 ++++++
>   drivers/irqchip/irq-gic-v3.c       | 1 +
>   include/linux/irqchip/arm-gic-v3.h | 1 +
>   3 files changed, 8 insertions(+)
> 
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index c84370245bea..fc5788584df7 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1373,10 +1373,12 @@ static void direct_lpi_inv(struct irq_data *d)
>   
>   	/* Target the redistributor this LPI is currently routed to */
>   	cpu = irq_to_cpuid_lock(d, &flags);
> +	raw_spin_lock(&gic_data_rdist_cpu(cpu)->rd_lock);
>   	rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
>   	gic_write_lpir(val, rdbase + GICR_INVLPIR);
>   
>   	wait_for_syncr(rdbase);
> +	raw_spin_unlock(&gic_data_rdist_cpu(cpu)->rd_lock);
>   	irq_to_cpuid_unlock(d, flags);
>   }
>   
> @@ -3662,9 +3664,11 @@ static void its_vpe_send_inv(struct irq_data *d)
>   		void __iomem *rdbase;
>   
>   		/* Target the redistributor this VPE is currently known on */
> +		raw_spin_lock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
>   		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
>   		gic_write_lpir(d->parent_data->hwirq, rdbase + GICR_INVLPIR);
>   		wait_for_syncr(rdbase);
> +		raw_spin_unlock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
>   	} else {
>   		its_vpe_send_cmd(vpe, its_send_inv);
>   	}
> @@ -3825,10 +3829,12 @@ static void its_vpe_4_1_invall(struct its_vpe *vpe)
>   	val |= FIELD_PREP(GICR_INVALLR_VPEID, vpe->vpe_id);
>   
>   	/* Target the redistributor this vPE is currently known on */
> +	raw_spin_lock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
>   	rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
>   	gic_write_lpir(val, rdbase + GICR_INVALLR);
>   
>   	wait_for_syncr(rdbase);
> +	raw_spin_unlock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
>   }
>   
>   static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void *vcpu_info)
> diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
> index 73e87e176d76..ba405becab53 100644
> --- a/drivers/irqchip/irq-gic-v3.c
> +++ b/drivers/irqchip/irq-gic-v3.c
> @@ -835,6 +835,7 @@ static int __gic_populate_rdist(struct redist_region *region, void __iomem *ptr)
>   	typer = gic_read_typer(ptr + GICR_TYPER);
>   	if ((typer >> 32) == aff) {
>   		u64 offset = ptr - region->redist_base;
> +		raw_spin_lock_init(&gic_data_rdist()->rd_lock);
>   		gic_data_rdist_rd_base() = ptr;
>   		gic_data_rdist()->phys_base = region->phys_base + offset;
>   
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index c29a02678a6f..b28acfa71f82 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -652,6 +652,7 @@
>   
>   struct rdists {
>   	struct {
> +		raw_spinlock_t	rd_lock;
>   		void __iomem	*rd_base;
>   		struct page	*pend_page;
>   		phys_addr_t	phys_base;
> 

