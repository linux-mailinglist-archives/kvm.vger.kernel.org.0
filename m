Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BAD2C9E21
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 10:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgLAJjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Dec 2020 04:39:05 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8899 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgLAJjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Dec 2020 04:39:04 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ClcTc5vX0z72pS;
        Tue,  1 Dec 2020 17:37:56 +0800 (CST)
Received: from [127.0.0.1] (10.57.22.126) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Tue, 1 Dec 2020
 17:38:12 +0800
Subject: Re: [RFC PATCH v1 1/4] irqchip/gic-v4.1: Plumb get_irqchip_state VLPI
 callback
To:     Marc Zyngier <maz@kernel.org>
CC:     Shenming Lu <lushenming@huawei.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>, "Neo Jia" <cjia@nvidia.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20201123065410.1915-1-lushenming@huawei.com>
 <20201123065410.1915-2-lushenming@huawei.com>
 <869dbc36-c510-fd00-407a-b05e068537c8@huawei.com>
 <875z5p6ayp.wl-maz@kernel.org>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <316fe41d-f004-f004-4f31-6fe6e7ff64b7@huawei.com>
Date:   Tue, 1 Dec 2020 17:38:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <875z5p6ayp.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.57.22.126]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2020/11/28 18:18, Marc Zyngier wrote:
> On Sat, 28 Nov 2020 07:19:48 +0000,
> luojiaxing <luojiaxing@huawei.com> wrote:
>> Hi, shenming
>>
>>
>> I got few questions about this patch.
>>
>> Although it's a bit late and not very appropriate, I'd like to ask
>> before you send next version.
>>
>> On 2020/11/23 14:54, Shenming Lu wrote:
>>> From: Zenghui Yu <yuzenghui@huawei.com>
>>>
>>> Up to now, the irq_get_irqchip_state() callback of its_irq_chip
>>> leaves unimplemented since there is no architectural way to get
>>> the VLPI's pending state before GICv4.1. Yeah, there has one in
>>> v4.1 for VLPIs.
>>
>> I checked the invoking scenario of irq_get_irqchip_state and found no
>> scenario related to vLPI.
>>
>> For example, synchronize_irq(), it pass IRQCHIP_STATE_ACTIVE to which,
>> so in your patch, you will directly return and other is for vSGI,
>> GICD_ISPENDR, GICD_ICPENDR and so on.
> You do realise that LPIs have no active state, right?


yes, I know


> And that LPIs
> have a radically different programming interface to the rest of the GIC?


I found out that my mailbox software filtered out the other two patches, 
which led me to look at the patch alone, so it was weird. I already got 
the answer now.


>> The only one I am not sure is vgic_get_phys_line_level(), is it your
>> purpose to fill this callback, or some scenarios I don't know about
>> that use this callback.
> LPIs only offer edge signalling, so the concept of "line level" means
> absolutely nothing.
>
>>
>>> With GICv4.1, after unmapping the vPE, which cleans and invalidates
>>> any caching of the VPT, we can get the VLPI's pending state by
>>> peeking at the VPT. So we implement the irq_get_irqchip_state()
>>> callback of its_irq_chip to do it.
>>>
>>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>>> ---
>>>    drivers/irqchip/irq-gic-v3-its.c | 38 ++++++++++++++++++++++++++++++++
>>>    1 file changed, 38 insertions(+)
>>>
>>> diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
>>> index 0fec31931e11..287003cacac7 100644
>>> --- a/drivers/irqchip/irq-gic-v3-its.c
>>> +++ b/drivers/irqchip/irq-gic-v3-its.c
>>> @@ -1695,6 +1695,43 @@ static void its_irq_compose_msi_msg(struct irq_data *d, struct msi_msg *msg)
>>>    	iommu_dma_compose_msi_msg(irq_data_get_msi_desc(d), msg);
>>>    }
>>>    +static bool its_peek_vpt(struct its_vpe *vpe, irq_hw_number_t
>>> hwirq)
>>> +{
>>> +	int mask = hwirq % BITS_PER_BYTE;
>>> +	void *va;
>>> +	u8 *pt;
>>> +
>>> +	va = page_address(vpe->vpt_page);
>>> +	pt = va + hwirq / BITS_PER_BYTE;
>>> +
>>> +	return !!(*pt & (1U << mask));
>>
>> How can you confirm that the interrupt pending status is the latest?
>> Is it possible that the interrupt pending status is still cached in
>> the GICR but not synchronized to the memory.
> That's a consequence of the vPE having been unmapped:
>
> "A VMAPP with {V,Alloc}=={0,1} cleans and invalidates any caching of
> the Virtual Pending Table and Virtual Configuration Table associated
> with the vPEID held in the GIC."


Yes, in addition to that, if a vPE is scheduled out of the PE, the cache 
clearing and write-back to VPT are also performed, I think.


However, I feel a litter confusing to read this comment at first ,  
because it is not only VMAPP that causes cache clearing.

I don't know why VMAPP was mentioned here until I check the other two 
patches ("KVM: arm64: GICv4.1: Try to save hw pending state in 
save_pending_tables").


So I think may be it's better to add some background description here.


Thanks

Jiaxing


>
> An implementation that wouldn't follow this simple rule would simply
> be totally broken, and unsupported.
>
> 	M.
>

