Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D3446520A
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 16:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351220AbhLAPv0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Dec 2021 10:51:26 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:46482 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351133AbhLAPtd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Dec 2021 10:49:33 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1msRo4-0008Ik-Ke; Wed, 01 Dec 2021 16:46:04 +0100
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
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
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
 <a39db04edcacfe955c660e2f139f948cf29362f5.1638304316.git.maciej.szmigiero@oracle.com>
 <YabvBW90COsfdoYx@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v6 26/29] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Message-ID: <7119b08c-e82a-8b81-7f9e-2e79f8276d51@maciej.szmigiero.name>
Date:   Wed, 1 Dec 2021 16:45:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YabvBW90COsfdoYx@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.12.2021 04:41, Sean Christopherson wrote:
> On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 41efe53cf150..6fce6eb797a7 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -848,6 +848,105 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
>>   	return NULL;
>>   }
>>   
>> +/* Iterator used for walking memslots that overlap a gfn range. */
>> +struct kvm_memslot_iter {
>> +	struct kvm_memslots *slots;
>> +	gfn_t end;
>> +	struct rb_node *node;
>> +};
> 
> ...
> 
>> +static inline struct kvm_memory_slot *kvm_memslot_iter_slot(struct kvm_memslot_iter *iter)
>> +{
>> +	return container_of(iter->node, struct kvm_memory_slot, gfn_node[iter->slots->node_idx]);
> 
> Having to use a helper in callers of kvm_for_each_memslot_in_gfn_range() is a bit
> ugly, any reason not to grab @slot as well?  Then the callers just do iter.slot,
> which IMO is much more readable.

"slot" can be easily calculated from "node" together with either "slots" or
"node_idx" (the code above just adjusts a pointer) so storing it in the
iterator makes little sense if the later are already stored there.

> And if we do that, I'd also vote to omit slots and end from the iterator.  It would
> mean passing in slots and end to kvm_memslot_iter_is_valid() and kvm_memslot_iter_next(),
> but that's more idiomatic in a for-loop if iter is considered to be _just_ the iterator
> part.  "slots" is arguable, but "end" really shouldn't be part of the iterator.

You're right that we can get away with not storing "end", will remove it.

Thanks,
Maciej
