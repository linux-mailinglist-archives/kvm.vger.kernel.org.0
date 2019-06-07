Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7F9B38693
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 10:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfFGI4Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 04:56:24 -0400
Received: from foss.arm.com ([217.140.110.172]:35926 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbfFGI4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 04:56:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 526DD337;
        Fri,  7 Jun 2019 01:56:23 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 186583F246;
        Fri,  7 Jun 2019 01:56:20 -0700 (PDT)
Subject: Re: [PATCH 3/8] KVM: arm/arm64: vgic-its: Cache successful MSI->LPI
 translation
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
 <20190606165455.162478-4-marc.zyngier@arm.com>
 <d9849310-7ff9-2385-d0e2-ac1de2878517@arm.com>
 <1c81ab00-12d1-9921-e1ce-2e2233516bab@arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <2baf731f-922c-c3b8-abe5-593047a8ba00@arm.com>
Date:   Fri, 7 Jun 2019 09:56:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1c81ab00-12d1-9921-e1ce-2e2233516bab@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/06/2019 09:51, Marc Zyngier wrote:
> On 07/06/2019 09:35, Julien Thierry wrote:
>> Hi Marc,
>>
>> On 06/06/2019 17:54, Marc Zyngier wrote:
>>> On a successful translation, preserve the parameters in the LPI
>>> translation cache. Each translation is reusing the last slot
>>> in the list, naturally evincting the least recently used entry.
>>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic-its.c | 41 ++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 41 insertions(+)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 5758504fd934..bc370b6c5afa 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -538,6 +538,45 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
>>>  	return 0;
>>>  }
>>>  
>>> +static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
>>> +				       u32 devid, u32 eventid,
>>> +				       struct vgic_irq *irq)
>>> +{
>>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>>> +	struct vgic_translation_cache_entry *cte;
>>> +	unsigned long flags;
>>> +
>>> +	/* Do not cache a directly injected interrupt */
>>> +	if (irq->hw)
>>> +		return;
>>> +
>>> +	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
>>> +
>>> +	/* Always reuse the last entry (LRU policy) */
>>> +	cte = list_last_entry(&dist->lpi_translation_cache,
>>> +			      typeof(*cte), entry);
>>> +
>>> +	/*
>>> +	 * Caching the translation implies having an extra reference
>>> +	 * to the interrupt, so drop the potential reference on what
>>> +	 * was in the cache, and increment it on the new interrupt.
>>> +	 */
>>> +	if (cte->irq)
>>> +		__vgic_put_lpi_locked(kvm, cte->irq);
>>> +
>>> +	vgic_get_irq_kref(irq);
>>
>> If cte->irq == irq, can we avoid the ref putting and getting and just
>> move the list entry (and update cte)?
> But in that case, we should have hit in the cache the first place, no?
> Or is there a particular race I'm not thinking of just yet?
> 

Yes, I had not made it far enough in the series to see the cache hits
and assumed this function would also be used to update the LRU policy.

You can dismiss this comment, sorry for the noise.

Cheers,

-- 
Julien Thierry
