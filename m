Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52208553E4
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732533AbfFYQBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 12:01:55 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40346 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732498AbfFYQBz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 12:01:55 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 5CF3AEA899F81CF85AC9;
        Wed, 26 Jun 2019 00:01:53 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Wed, 26 Jun 2019
 00:01:45 +0800
Subject: Re: [PATCH v2 7/9] KVM: arm/arm64: vgic-its: Cache successful
 MSI->LPI translation
To:     Marc Zyngier <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Christoffer Dall" <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-8-marc.zyngier@arm.com>
 <53de88e9-3550-bd7f-8266-35c5e75fae4e@huawei.com>
 <169cc847-ebfa-44b6-00e7-c69dccdbbd62@arm.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <7af32ebf-91a8-ef63-6108-4ca506fd364e@huawei.com>
Date:   Wed, 26 Jun 2019 00:00:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <169cc847-ebfa-44b6-00e7-c69dccdbbd62@arm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2019/6/25 20:31, Marc Zyngier wrote:
> Hi Zenghui,
> 
> On 25/06/2019 12:50, Zenghui Yu wrote:
>> Hi Marc,
>>
>> On 2019/6/12 1:03, Marc Zyngier wrote:
>>> On a successful translation, preserve the parameters in the LPI
>>> translation cache. Each translation is reusing the last slot
>>> in the list, naturally evincting the least recently used entry.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>    virt/kvm/arm/vgic/vgic-its.c | 86 ++++++++++++++++++++++++++++++++++++
>>>    1 file changed, 86 insertions(+)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 0aa0cbbc3af6..62932458476a 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -546,6 +546,90 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
>>>    	return 0;
>>>    }
>>>    
>>> +static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
>>> +					       phys_addr_t db,
>>> +					       u32 devid, u32 eventid)
>>> +{
>>> +	struct vgic_translation_cache_entry *cte;
>>> +	struct vgic_irq *irq = NULL;
>>> +
>>> +	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
>>> +		/*
>>> +		 * If we hit a NULL entry, there is nothing after this
>>> +		 * point.
>>> +		 */
>>> +		if (!cte->irq)
>>> +			break;
>>> +
>>> +		if (cte->db == db &&
>>> +		    cte->devid == devid &&
>>> +		    cte->eventid == eventid) {
>>> +			/*
>>> +			 * Move this entry to the head, as it is the
>>> +			 * most recently used.
>>> +			 */
>>> +			list_move(&cte->entry, &dist->lpi_translation_cache);
>>
>> Only for performance reasons: if we hit at the "head" of the list, we
>> don't need to do a list_move().
>> In our tests, we found that a single list_move() takes nearly (sometimes
>> even more than) one microsecond, for some unknown reason...
> 
> Huh... That's odd.
> 
> Can you narrow down under which conditions this happens? I'm not sure if
> checking for the list head would be more efficient, as you end-up
> fetching the head anyway. Can you try replacing this line with:
> 
> 	if (!list_is_first(&cte->entry, &dist->lpi_translation_cache))
> 		list_move(&cte->entry, &dist->lpi_translation_cache);
> 
> and let me know whether it helps?

It helps. With this change, the overhead of list_move() is gone.

We run 16 4-vcpu VMs on the host, each with a vhost-user nic, and run
"iperf" in pairs between them.  It's likely to hit at the head of the
cache list in our tests.
With this change, the sys% utilization of vhostdpfwd threads will
decrease by about 10%.  But I don't know the reason exactly (I haven't
found any clues in code yet, in implementation of list_move...).


Thanks,
zenghui



