Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D057542326
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 12:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfFLK6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 06:58:38 -0400
Received: from foss.arm.com ([217.140.110.172]:50230 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726584AbfFLK6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 06:58:38 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 173C828;
        Wed, 12 Jun 2019 03:58:37 -0700 (PDT)
Received: from [10.1.197.45] (e112298-lin.cambridge.arm.com [10.1.197.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 54C143F246;
        Wed, 12 Jun 2019 04:00:14 -0700 (PDT)
Subject: Re: [PATCH v2 1/9] KVM: arm/arm64: vgic: Add LPI translation cache
 definition
To:     Marc Zyngier <marc.zyngier@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-2-marc.zyngier@arm.com>
 <54c8547a-51fb-8ae5-975f-261d3934221a@arm.com>
 <86ef3zgmg6.wl-marc.zyngier@arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <13655730-165b-d67b-a1da-11c8869c7053@arm.com>
Date:   Wed, 12 Jun 2019 11:58:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <86ef3zgmg6.wl-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/06/2019 10:52, Marc Zyngier wrote:
> Hi Julien,
> 
> On Wed, 12 Jun 2019 09:16:21 +0100,
> Julien Thierry <julien.thierry@arm.com> wrote:
>>
>> Hi Marc,
>>
>> On 11/06/2019 18:03, Marc Zyngier wrote:
>>> Add the basic data structure that expresses an MSI to LPI
>>> translation as well as the allocation/release hooks.
>>>
>>> THe size of the cache is arbitrarily defined as 4*nr_vcpus.
>>>
>>
>> The size has been arbitrarily changed to 16*nr_vcpus :) .
> 
> Well spotted! ;-)
> 
>>
>> Nit: The*
> 
> Ah, usual lazy finger on the Shift key... One day I'll learn to type.
> 
>>
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  include/kvm/arm_vgic.h        |  3 +++
>>>  virt/kvm/arm/vgic/vgic-init.c |  5 ++++
>>>  virt/kvm/arm/vgic/vgic-its.c  | 49 +++++++++++++++++++++++++++++++++++
>>>  virt/kvm/arm/vgic/vgic.h      |  2 ++
>>>  4 files changed, 59 insertions(+)
>>>

[...]

>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>> index 44ceaccb18cf..ce9bcddeb7f1 100644
>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>> @@ -149,6 +149,14 @@ struct its_ite {
>>>  	u32 event_id;
>>>  };
>>>  
>>> +struct vgic_translation_cache_entry {
>>> +	struct list_head	entry;
>>> +	phys_addr_t		db;
>>> +	u32			devid;
>>> +	u32			eventid;
>>> +	struct vgic_irq		*irq;
>>> +};
>>> +
>>>  /**
>>>   * struct vgic_its_abi - ITS abi ops and settings
>>>   * @cte_esz: collection table entry size
>>> @@ -1668,6 +1676,45 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
>>>  	return ret;
>>>  }
>>>  
>>> +/* Default is 16 cached LPIs per vcpu */
>>> +#define LPI_DEFAULT_PCPU_CACHE_SIZE	16
>>> +
>>> +void vgic_lpi_translation_cache_init(struct kvm *kvm)
>>> +{
>>> +	struct vgic_dist *dist = &kvm->arch.vgic;
>>> +	unsigned int sz;
>>> +	int i;
>>> +
>>> +	if (!list_empty(&dist->lpi_translation_cache))
>>> +		return;
>>> +
>>> +	sz = atomic_read(&kvm->online_vcpus) * LPI_DEFAULT_PCPU_CACHE_SIZE;
>>> +
>>> +	for (i = 0; i < sz; i++) {
>>> +		struct vgic_translation_cache_entry *cte;
>>> +
>>> +		/* An allocation failure is not fatal */
>>> +		cte = kzalloc(sizeof(*cte), GFP_KERNEL);
>>> +		if (WARN_ON(!cte))
>>> +			break;
>>> +
>>> +		INIT_LIST_HEAD(&cte->entry);
>>> +		list_add(&cte->entry, &dist->lpi_translation_cache);
>>
>> Going through the series, it looks like this list is either empty
>> (before the cache init) or has a fixed number
>> (LPI_DEFAULT_PCPU_CACHE_SIZE * nr_cpus) of entries.
> 
> Well, it could also fail when allocating one of the entry, meaning we
> can have an allocation ranging from 0 to (LPI_DEFAULT_PCPU_CACHE_SIZE
> * nr_cpus) entries.
> 
>> And the list never grows nor shrinks throughout the series, so it
>> seems odd to be using a list here.
>>
>> Is there a reason for not using a dynamically allocated array instead of
>> the list? (does list_move() provide a big perf advantage over swapping
>> the data from one array entry to another? Or is there some other
>> facility I am missing?
> 
> The idea was to make the LRU policy cheap, on the assumption that
> list_move (which is only a couple of pointer updates) is cheaper than
> a memmove if you want to keep the array ordered. If we exclude the
> list head, we end-up with 24 bytes per entry to move down to make room
> for the new entry at the head of the array. For large caches that miss
> very often, this will hurt badly. But is that really a problem? I
> don't know.
> 

Yes, I realized afterwards that the LRU uses the fact you can easily
move list entries without modifying the rest of the list.

> We could allocate an array as you suggest, and use a linked list
> inside the array. Or something else. I'm definitely open to
> suggestion!

If it there turns out to be some benefit to just you a fixed array, we
could use a simple ring buffer. Have one pointer on the most recently
inserted entry (and we know the next insertion will take place on the
entry "just before" it) and one pointer on the least recently used entry
(which gets moved when the most recently inserted catches up to it) so
we know where to stop when looping. We don't really have to worry about
the "ring buffer" full case since that means we just overwrite the LRU
and move the pointer.

This might prove a bit more efficient when looping over the cache
entries compared to the list. However, I have no certainty of actual
performance gain from that and the current implementation has the
benefit of being simple.

Let me know if you decide to give the ring buffer approach a try.

Otherwise there's always the option to add even more complex structure
with a hashtable + linked list using hashes and tags to lookup the
entries. But keeping things simple for now seems reasonable (also, it
avoids having to think about what to use as hash and tag :D ).

Cheers,

-- 
Julien Thierry
