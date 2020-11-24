Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D968B2C1EFC
	for <lists+kvm@lfdr.de>; Tue, 24 Nov 2020 08:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730094AbgKXHir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 02:38:47 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7973 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728934AbgKXHiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Nov 2020 02:38:46 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CgG90577CzhfY3;
        Tue, 24 Nov 2020 15:38:28 +0800 (CST)
Received: from [10.174.187.74] (10.174.187.74) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 15:38:32 +0800
Subject: Re: [RFC PATCH v1 1/4] irqchip/gic-v4.1: Plumb get_irqchip_state VLPI
 callback
To:     Marc Zyngier <maz@kernel.org>
CC:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, Neo Jia <cjia@nvidia.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-2-lushenming@huawei.com>
 <f64703b618a2ebc6c6f5c423e2b779c6@kernel.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <7bc7e428-cfd5-6171-dc1e-4be097c46690@huawei.com>
Date:   Tue, 24 Nov 2020 15:38:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <f64703b618a2ebc6c6f5c423e2b779c6@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.74]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/11/23 17:01, Marc Zyngier wrote:
> On 2020-11-23 06:54, Shenming Lu wrote:
>> From: Zenghui Yu <yuzenghui@huawei.com>
>>
>> Up to now, the irq_get_irqchip_state() callback of its_irq_chip
>> leaves unimplemented since there is no architectural way to get
>> the VLPI's pending state before GICv4.1. Yeah, there has one in
>> v4.1 for VLPIs.
>>
>> With GICv4.1, after unmapping the vPE, which cleans and invalidates
>> any caching of the VPT, we can get the VLPI's pending state by
> 
> This is a crucial note: without this unmapping and invalidation,
> the pending bits are not generally accessible (they could be cached
> in a GIC private structure, cache or otherwise).
> 
>> peeking at the VPT. So we implement the irq_get_irqchip_state()
>> callback of its_irq_chip to do it.
>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  drivers/irqchip/irq-gic-v3-its.c | 38 ++++++++++++++++++++++++++++++++
>>  1 file changed, 38 insertions(+)
>>
>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>> index 0fec31931e11..287003cacac7 100644
>> --- a/drivers/irqchip/irq-gic-v3-its.c
>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>> @@ -1695,6 +1695,43 @@ static void its_irq_compose_msi_msg(struct
>> irq_data *d, struct msi_msg *msg)
>>      iommu_dma_compose_msi_msg(irq_data_get_msi_desc(d), msg);
>>  }
>>
>> +static bool its_peek_vpt(struct its_vpe *vpe, irq_hw_number_t hwirq)
>> +{
>> +    int mask = hwirq % BITS_PER_BYTE;
> 
> nit: this isn't a mask, but a shift instead. BIT(hwirq % BPB) would give
> you a mask.

Ok, I will correct it.

> 
>> +    void *va;
>> +    u8 *pt;
>> +
>> +    va = page_address(vpe->vpt_page);
>> +    pt = va + hwirq / BITS_PER_BYTE;
>> +
>> +    return !!(*pt & (1U << mask));
>> +}
>> +
>> +static int its_irq_get_irqchip_state(struct irq_data *d,
>> +                     enum irqchip_irq_state which, bool *val)
>> +{
>> +    struct its_device *its_dev = irq_data_get_irq_chip_data(d);
>> +    struct its_vlpi_map *map = get_vlpi_map(d);
>> +
>> +    if (which != IRQCHIP_STATE_PENDING)
>> +        return -EINVAL;
>> +
>> +    /* not intended for physical LPI's pending state */
>> +    if (!map)
>> +        return -EINVAL;
>> +
>> +    /*
>> +     * In GICv4.1, a VMAPP with {V,Alloc}=={0,1} cleans and invalidates
>> +     * any caching of the VPT associated with the vPEID held in the GIC.
>> +     */
>> +    if (!is_v4_1(its_dev->its) || atomic_read(&map->vpe->vmapp_count))
> 
> It isn't clear to me what prevents this from racing against a mapping of
> the VPE. Actually, since we only hold the LPI irqdesc lock, I'm pretty sure
> nothing prevents it.

Yes, should have the vmovp_lock held?
And is it necessary to also hold this lock in its_vpe_irq_domain_activate/deactivate?

> 
>> +        return -EACCES;
> 
> I can sort of buy EACCESS for a VPE that is currently mapped, but a non-4.1
> ITS should definitely return EINVAL.

Alright, EINVAL looks better.

> 
>> +
>> +    *val = its_peek_vpt(map->vpe, map->vintid);
>> +
>> +    return 0;
>> +}
>> +
>>  static int its_irq_set_irqchip_state(struct irq_data *d,
>>                       enum irqchip_irq_state which,
>>                       bool state)
>> @@ -1975,6 +2012,7 @@ static struct irq_chip its_irq_chip = {
>>      .irq_eoi        = irq_chip_eoi_parent,
>>      .irq_set_affinity    = its_set_affinity,
>>      .irq_compose_msi_msg    = its_irq_compose_msi_msg,
>> +    .irq_get_irqchip_state    = its_irq_get_irqchip_state,
> 
> My biggest issue with this is that it isn't a reliable interface.
> It happens to work in the context of KVM, because you make sure it
> is called at the right time, but that doesn't make it safe in general
> (anyone with the interrupt number is allowed to call this at any time).

We check the vmapp_count in it to ensure the unmapping of the vPE, and
let the caller do the unmapping (they should know whether it is the right
time). If the unmapping is not done, just return a failure.

> 
> Is there a problem with poking at the VPT page from the KVM side?
> The code should be exactly the same (maybe simpler even), and at least
> you'd be guaranteed to be in the correct context.

Yeah, that also seems a good choice.
If you prefer it, we can try to realize it in v2.

> 
>>      .irq_set_irqchip_state    = its_irq_set_irqchip_state,
>>      .irq_retrigger        = its_irq_retrigger,
>>      .irq_set_vcpu_affinity    = its_irq_set_vcpu_affinity,
> 
> Thanks,
> 
>         M.
