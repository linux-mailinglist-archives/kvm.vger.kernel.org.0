Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D27430E3E5
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 21:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhBCULo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 15:11:44 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56732 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232018AbhBCULf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:11:35 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1l7OU8-0005cn-3e; Wed, 03 Feb 2021 21:10:44 +0100
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
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
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <ceb96527b6f7bb662eec813f05b897a551ebd0b2.1612140117.git.maciej.szmigiero@oracle.com>
 <4d748e0fd50bac68ece6952129aed319502b6853.1612140117.git.maciej.szmigiero@oracle.com>
 <YBisBkSYPoaOM42F@google.com>
 <9e6ca093-35c3-7cca-443b-9f635df4891d@maciej.szmigiero.name>
 <YBnjso2OeX1/r3Ls@google.com>
 <dd76955e-710a-61b0-9739-28623f985508@maciej.szmigiero.name>
 <875z39p6z1.fsf@vitty.brq.redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 2/2] KVM: Scalable memslots implementation
Message-ID: <fdb049d9-fd06-78a3-d38b-849fc1c23e27@maciej.szmigiero.name>
Date:   Wed, 3 Feb 2021 21:10:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <875z39p6z1.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.02.2021 15:21, Vitaly Kuznetsov wrote:
> "Maciej S. Szmigiero" <mail@maciej.szmigiero.name> writes:
> 
>> On 03.02.2021 00:43, Sean Christopherson wrote:
>>> On Tue, Feb 02, 2021, Maciej S. Szmigiero wrote:
>>>> On 02.02.2021 02:33, Sean Christopherson wrote:
> 
> ...
> 
>>>>
>>>> I guess you mean to still turn id_to_index into a hash table, since
>>>> otherwise a VMM which uses just two memslots but numbered 0 and 508
>>>> will have a 509-entry id_to_index array allocated.
>>>
>>> That should be irrelevant for the purposes of optimizing hva lookups, and mostly
>>> irrelevant for optimizing memslot updates.  Using a hash table is almost a pure
>>> a memory optimization, it really only matters when the max number of memslots
>>> skyrockets, which is a separate discussion from optimizing hva lookups.
>>
>> While I agree this is a separate thing from scalable hva lookups it still
>> matters for the overall design.
>>
>> The current id_to_index array is fundamentally "pay the cost of max
>> number of memslots possible regardless how many you use".
>>
>> And it's not only that it takes more memory it also forces memslot
>> create / delete / move operations to be O(n) since the indices have to
>> be updated.
> 
> FWIW, I don't see a fundamental disagreement between you and Sean here,
> it's just that we may want to eat this elephant one bite at a time
> instead of trying to swallow it unchewed :-)
> 
> E.g. as a first step, we may want to introduce helper functions to not
> work with id_to_index directly and then suggest a better implementation
> (using rbtree, bynamically allocated array,...) for these helpers. This
> is definitely more work but it's likely worth it.

That's sound like a good idea, will have a look at it - thanks.

>>
>> By the way, I think nobody argues here for a bazillion of memslots.
>> It is is enough to simply remove the current cap and allow the maximum
>> number permitted by the existing KVM API, that is 32k as Vitaly's
>> patches recently did.
> 
> Yea, there's no immegiate need even for 32k as KVM_MAX_VCPUS is '288',
> we can get away with e.g. 1000 but id_to_index is the only thing which
> may make us consider something lower than 32k: if only a few slots are
> used, there's no penalty (of course slot *modify* operations are O(n)
> so for 32k it'll take a lot but these configurations are currently
> illegal and evem 'slow' is better :-)
> 
Yes, id_to_index has this problem of depending on the max number of
memlots allowed (current KVM code) or the ID of the highest memslot
currently present (possible alternative, dynamically resized
implementation) rather than just the total number of memslots
currently in use.
So it's a "pay all the cost upfront"-type implementation.

Each slot modify operation is O(n) for the current code due to
copying of the memslots array and possibly updating id_to_index indices
(and minor things like kvm_mmu_calculate_default_mmu_pages() for x86),
but it is O(log(n)) for the new implementation  - that's one of its
main benefits.

Thanks,
Maciej
