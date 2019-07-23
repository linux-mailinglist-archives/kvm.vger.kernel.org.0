Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FE17188A
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 14:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389875AbfGWMr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 08:47:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731293AbfGWMrz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 08:47:55 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0FA4881F12;
        Tue, 23 Jul 2019 12:47:55 +0000 (UTC)
Received: from [10.36.117.239] (ovpn-117-239.ams2.redhat.com [10.36.117.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3D4A419C58;
        Tue, 23 Jul 2019 12:47:49 +0000 (UTC)
Subject: Re: [PATCH v2 4/9] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI
 translation cache on specific commands
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-5-marc.zyngier@arm.com>
 <9ff329a3-44f2-1de3-b6cc-58ed38a63665@redhat.com>
 <1a78d52c-7a31-8981-230b-abe85d11b8ec@arm.com>
 <8b5e029c-a08f-b86b-7021-5d68ec05d3bd@redhat.com>
 <ffb327bf-b05c-b7ca-d509-2a98dea37fdf@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <166921d3-39c4-d13c-bdee-dd404d468e7e@redhat.com>
Date:   Tue, 23 Jul 2019 14:47:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <ffb327bf-b05c-b7ca-d509-2a98dea37fdf@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 23 Jul 2019 12:47:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 7/23/19 2:43 PM, Marc Zyngier wrote:
> On 23/07/2019 13:25, Auger Eric wrote:
>> Hi Marc,
>>
>> On 7/22/19 12:54 PM, Marc Zyngier wrote:
>>> Hi Eric,
>>>
>>> On 01/07/2019 13:38, Auger Eric wrote:
>>>> Hi Marc,
>>>>
>>>> On 6/11/19 7:03 PM, Marc Zyngier wrote:
>>>>> The LPI translation cache needs to be discarded when an ITS command
>>>>> may affect the translation of an LPI (DISCARD and MAPD with V=0) or
>>>>> the routing of an LPI to a redistributor with disabled LPIs (MOVI,
>>>>> MOVALL).
>>>>>
>>>>> We decide to perform a full invalidation of the cache, irrespective
>>>>> of the LPI that is affected. Commands are supposed to be rare enough
>>>>> that it doesn't matter.
>>>>>
>>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>>> ---
>>>>>  virt/kvm/arm/vgic/vgic-its.c | 8 ++++++++
>>>>>  1 file changed, 8 insertions(+)
>>>>>
>>>>> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
>>>>> index 9b6b66204b97..5254bb762e1b 100644
>>>>> --- a/virt/kvm/arm/vgic/vgic-its.c
>>>>> +++ b/virt/kvm/arm/vgic/vgic-its.c
>>>>> @@ -733,6 +733,8 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
>>>>>  		 * don't bother here since we clear the ITTE anyway and the
>>>>>  		 * pending state is a property of the ITTE struct.
>>>>>  		 */
>>>>> +		vgic_its_invalidate_cache(kvm);
>>>>> +
>>>>>  		its_free_ite(kvm, ite);
>>>>>  		return 0;
>>>>>  	}
>>>>> @@ -768,6 +770,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
>>>>>  	ite->collection = collection;
>>>>>  	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
>>>>>  
>>>>> +	vgic_its_invalidate_cache(kvm);
>>>>> +
>>>>>  	return update_affinity(ite->irq, vcpu);
>>>>>  }
>>>>>  
>>>>> @@ -996,6 +1000,8 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
>>>>>  	list_for_each_entry_safe(ite, temp, &device->itt_head, ite_list)
>>>>>  		its_free_ite(kvm, ite);
>>>>>  
>>>>> +	vgic_its_invalidate_cache(kvm);
>>>>> +
>>>>>  	list_del(&device->dev_list);
>>>>>  	kfree(device);
>>>>>  }
>>>>> @@ -1249,6 +1255,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
>>>>>  		vgic_put_irq(kvm, irq);
>>>>>  	}
>>>>>  
>>>>> +	vgic_its_invalidate_cache(kvm);
>>>> All the commands are executed with the its_lock held. Now we don't take
>>>> it anymore on the fast cache injection path. Don't we have a window
>>>> where the move has been applied at table level and the cache is not yet
>>>> invalidated? Same question for vgic_its_free_device().
>>>
>>> There is definitely a race, but that race is invisible from the guest's
>>> perspective. The guest can only assume that the command has taken effect
>>> once a SYNC command has been executed, and it cannot observe that the
>>> SYNC command has been executed before we have invalidated the cache.
>>>
>>> Does this answer your question?
>>
>> OK make sense. Thank you for the clarification
>>
>> Another question, don't we need to invalidate the cache on  MAPC V=0 as
>> well? Removing the mapping of the collection results in interrupts
>> belonging to that collection being ignored. If we don't flush the
>> pending bit will be set?
> 
> Yup, that's a good point. I think i had that at some point, and ended up 
> dropping it, probably missing the point that the interrupt would be made 
> pending.
> 
> I'll add this:
> 
> @@ -1218,6 +1218,7 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
>  
>  	if (!valid) {
>  		vgic_its_free_collection(its, coll_id);
> +		vgic_its_invalidate_cache(kvm);
>  	} else {
>  		collection = find_collection(its, coll_id);
>  
Yep, with that change feel free to add my R-b

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> 
> Thanks,
> 
> 	M.
> 
