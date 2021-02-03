Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF84230E3E0
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 21:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbhBCUKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 15:10:36 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:56606 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231321AbhBCUK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 15:10:29 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps (TLS1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.93.0.4)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1l7OT4-0005c4-67; Wed, 03 Feb 2021 21:09:38 +0100
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
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
 <4bdcb44c-c35d-45b2-c0c1-e857e0fd383e@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 2/2] KVM: Scalable memslots implementation
Message-ID: <b3b1a203-f492-1a7a-a486-b84590a03c11@maciej.szmigiero.name>
Date:   Wed, 3 Feb 2021 21:09:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <4bdcb44c-c35d-45b2-c0c1-e857e0fd383e@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.02.2021 14:41, Paolo Bonzini wrote:
> On 02/02/21 23:42, Maciej S. Szmigiero wrote:
>>> I'm not opposed to using more sophisticated storage for the gfn lookups, but only if there's a good reason for doing so.  IMO, the
>>> rbtree isn't simpler, just different.
> 
> And it also has worse cache utilization than an array, due to memory footprint (as you point out below) but also pointer chasing.

The best data structure here would probably be something like a dense
B-tree.

Unfortunately, there seems to be no such thing currently in the kernel,
and designing a good generic implementation would be a major challenge on
its own.

However, even an ordinary rbtree still gets a decent performance here.

But nothing stops us from switching the underlying tree implementation
in the future.

>>> Memslot modifications are
>>> unlikely to be a hot path (and if it is, x86's "zap everything"
>>> implementation is a far bigger problem), and it's hard to beat the
>>> memory footprint of a raw array.  That doesn't leave much motivation for such a big change to some of KVM's scariest (for me)
>>> code.
>>>
>>
>> Improvements can be done step-by-step, kvm_mmu_invalidate_zap_pages_in_memslot() can be rewritten, too in
>> the future, if necessary. After all, complains are that this change
>> alone is too big.
>>
>> I think that if you look not at the patch itself but at the
>> resulting code the new implementation looks rather straightforward,
>> there are comments at every step in kvm_set_memslot() to explain
>> exactly what is being done. Not only it already scales well, but it
>> is also flexible to accommodate further improvements or even new
>> operations.
>>
>> The new implementation also uses standard kernel {rb,interval}-tree
>> and hash table implementation as its basic data structures, so it automatically benefits from any generic improvements to these.
>>
>> All for the low price of just 174 net lines of code added.
> 
> I think the best thing to do here is to provide a patch series that splits the individual changes so that they can be reviewed and their separate merits evaluated.

Yes, I will split the series into separate patches.

> Another thing that I dislike about KVM_SET_USER_MEMORY_REGION is that
> IMO userspace should provide all memslots at once, for an atomic switch 
> of the whole memory array. (Or at least I would like to see the code;
> it might be a bit tricky because you'll need code to compute the
> difference between the old and new arrays and invoke
> kvm_arch_prepare/commit_memory_region).
>> I'm not sure how that would interact with the active/inactive pair that
> you introduce here.

That was my observation too, but since that's an API change it will
require a careful upfront design discussion since it will be hard or
even impossible to change in the future.

I guess you are thinking about something like KVM_SET_USER_MEMORY_REGIONS
that atomically switches the current memslot set (or array) with the
provided one.

For this, the implementation will need to do a diff since we want to
keep things like arch data for the existing memslots that are also in
the new set.

Doing a diff is necessarily O(k + n), where is k is the total number of
memslots in the system and n is the number of memslots in the request.

So if one wants to change flags on 10 memslots with 100 memslots in the
system he will still pay the price of going through all the 100
memslots in the system and in the request.

I had actually something like KVM_CHANGE_USER_MEMORY_REGIONS in mind
where the caller asks KVM to atomically perform the requested changes to
the current set.
That's just O(n), where is n is the number of memslots (or changes) in
the request.

I'm assuming the new memslots implementation here, in the old
array-based implementation this is still O(k + n) as the memslot array
will have to be copied anyway.

In any case, with the new implementation, the two memslot sets are
enough to implement any number of atomic changes with maximum two
active <-> inactive set swaps per the whole call, just as the code
currently does.

The exception here might be multiple conflicting changes in one
changeset (like: add a memslot, then move it, then delete).

But that's a simple thing to solve: we can allow just one operation
per memslot per changeset - I don't see a reason why anybody would
need more.

> 
> Paolo
> 

Thanks,
Maciej
