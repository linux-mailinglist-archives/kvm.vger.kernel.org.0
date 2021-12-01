Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA174659A6
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 00:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353763AbhLAXMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 18:12:13 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:37386 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353740AbhLAXMJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 18:12:09 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msYiL-0000vW-5F; Thu, 02 Dec 2021 00:08:37 +0100
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <a39db04edcacfe955c660e2f139f948cf29362f5.1638304316.git.maciej.szmigiero@oracle.com>
 <YabvBW90COsfdoYx@google.com>
 <7119b08c-e82a-8b81-7f9e-2e79f8276d51@maciej.szmigiero.name>
 <Yaekjrr1OVrgwUic@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v6 26/29] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Message-ID: <ea99b9ba-ea30-f0fc-8c08-34d0aabf57a1@maciej.szmigiero.name>
Date:   Thu, 2 Dec 2021 00:08:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <Yaekjrr1OVrgwUic@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.12.2021 17:36, Sean Christopherson wrote:
> On Wed, Dec 01, 2021, Maciej S. Szmigiero wrote:
>> On 01.12.2021 04:41, Sean Christopherson wrote:
>>> On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
>>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>>> index 41efe53cf150..6fce6eb797a7 100644
>>>> --- a/include/linux/kvm_host.h
>>>> +++ b/include/linux/kvm_host.h
>>>> @@ -848,6 +848,105 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
>>>>    	return NULL;
>>>>    }
>>>> +/* Iterator used for walking memslots that overlap a gfn range. */
>>>> +struct kvm_memslot_iter {
>>>> +	struct kvm_memslots *slots;
>>>> +	gfn_t end;
>>>> +	struct rb_node *node;
>>>> +};
>>>
>>> ...
>>>
>>>> +static inline struct kvm_memory_slot *kvm_memslot_iter_slot(struct kvm_memslot_iter *iter)
>>>> +{
>>>> +	return container_of(iter->node, struct kvm_memory_slot, gfn_node[iter->slots->node_idx]);
>>>
>>> Having to use a helper in callers of kvm_for_each_memslot_in_gfn_range() is a bit
>>> ugly, any reason not to grab @slot as well?  Then the callers just do iter.slot,
>>> which IMO is much more readable.
>>
>> "slot" can be easily calculated from "node" together with either "slots" or
>> "node_idx" (the code above just adjusts a pointer) so storing it in the
>> iterator makes little sense if the later are already stored there.
> 
> I don't want the callers to have to calculate the slot.  It's mostly syntatic
> sugar, but I really do think it improves readability.  And since the first thing
> every caller will do is retrieve the slot, I see no benefit in forcing the caller
> to do the work.
> 
> E.g. in the simple kvm_check_memslot_overlap() usage, iter.slot->id is intuitive
> and easy to parse, whereas kvm_memslot_iter_slot(&iter)->id is slightly more
> difficult to parse and raises questions about why a function call is necessary
> and what the function might be doing.

Personally, I don't think it's that much less readable, but I will change
the code to store "slots" instead (as you wish) since it's the last remaining
change - other than Paolo's call whether we should keep or drop the
kvm_arch_flush_shadow_memslot()-related patch 25.

Thanks,
Maciej
