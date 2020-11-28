Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6152B2C706D
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 19:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731780AbgK1R67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 12:58:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8525 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733142AbgK1R4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Nov 2020 12:56:40 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CjjYP0G0Lzhgks;
        Sat, 28 Nov 2020 15:19:37 +0800 (CST)
Received: from [127.0.0.1] (10.57.22.126) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.487.0; Sat, 28 Nov 2020
 15:19:49 +0800
Subject: Re: [RFC PATCH v1 1/4] irqchip/gic-v4.1: Plumb get_irqchip_state VLPI
 callback
To:     Shenming Lu <lushenming@huawei.com>, Marc Zyngier <maz@kernel.org>,
        "James Morse" <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-2-lushenming@huawei.com>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <869dbc36-c510-fd00-407a-b05e068537c8@huawei.com>
Date:   Sat, 28 Nov 2020 15:19:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20201123065410.1915-2-lushenming@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.57.22.126]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, shenming


I got few questions about this patch.

Although it's a bit late and not very appropriate, I'd like to ask 
before you send next version.

On 2020/11/23 14:54, Shenming Lu wrote:
> From: Zenghui Yu <yuzenghui@huawei.com>
>
> Up to now, the irq_get_irqchip_state() callback of its_irq_chip
> leaves unimplemented since there is no architectural way to get
> the VLPI's pending state before GICv4.1. Yeah, there has one in
> v4.1 for VLPIs.


I checked the invoking scenario of irq_get_irqchip_state and found no 
scenario related to vLPI.

For example, synchronize_irq(), it pass IRQCHIP_STATE_ACTIVE to which, 
so in your patch, you will directly return and other is for vSGI, 
GICD_ISPENDR, GICD_ICPENDR and so on.

The only one I am not sure is vgic_get_phys_line_level(), is it your 
purpose to fill this callback, or some scenarios I don't know about that 
use this callback.


>
> With GICv4.1, after unmapping the vPE, which cleans and invalidates
> any caching of the VPT, we can get the VLPI's pending state by
> peeking at the VPT. So we implement the irq_get_irqchip_state()
> callback of its_irq_chip to do it.
>
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>   drivers/irqchip/irq-gic-v3-its.c | 38 ++++++++++++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
>
> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
> index 0fec31931e11..287003cacac7 100644
> --- a/drivers/irqchip/irq-gic-v3-its.c
> +++ b/drivers/irqchip/irq-gic-v3-its.c
> @@ -1695,6 +1695,43 @@ static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
>   	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(d), msg);
>   }
>   
> +static bool its_peek_vpt(struct its_vpe *vpe, irq_hw_number_t hwirq)
> +{
> +	int mask = hwirq % BITS_PER_BYTE;
> +	void *va;
> +	u8 *pt;
> +
> +	va = page_address(vpe->vpt_page);
> +	pt = va + hwirq / BITS_PER_BYTE;
> +
> +	return !!(*pt & (1U << mask));


How can you confirm that the interrupt pending status is the latest? Is 
it possible that the interrupt pending status is still cached in the 
GICR but not synchronized to the memory.


Thanks

Jiaxing


> +}
> +
> +static int its_irq_get_irqchip_state(struct irq_data *d,
> +				     enum irqchip_irq_state which, bool *val)
> +{
> +	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
> +	struct its_vlpi_map *map = get_vlpi_map(d);
> +
> +	if (which != IRQCHIP_STATE_PENDING)
> +		return -EINVAL;
> +
> +	/* not intended for physical LPI's pending state */
> +	if (!map)
> +		return -EINVAL;
> +
> +	/*
> +	 * In GICv4.1, a VMAPP with {V,Alloc}=={0,1} cleans and invalidates
> +	 * any caching of the VPT associated with the vPEID held in the GIC.
> +	 */
> +	if (!is_v4_1(its_dev->its) || atomic_read(&map->vpe->vmapp_count))
> +		return -EACCES;
> +
> +	*val = its_peek_vpt(map->vpe, map->vintid);
> +
> +	return 0;
> +}
> +
>   static int its_irq_set_irqchip_state(struct irq_data *d,
>   				     enum irqchip_irq_state which,
>   				     bool state)
> @@ -1975,6 +2012,7 @@ static struct irq_chip its_irq_chip = {
>   	.irq_eoi		= irq_chip_eoi_parent,
>   	.irq_set_affinity	= its_set_affinity,
>   	.irq_compose_msi_msg	= its_irq_compose_msi_msg,
> +	.irq_get_irqchip_state	= its_irq_get_irqchip_state,
>   	.irq_set_irqchip_state	= its_irq_set_irqchip_state,
>   	.irq_retrigger		= its_irq_retrigger,
>   	.irq_set_vcpu_affinity	= its_irq_set_vcpu_affinity,

