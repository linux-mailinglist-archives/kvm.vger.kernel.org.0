Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016CA436CF9
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 23:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232300AbhJUVr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 17:47:27 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:56144 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231607AbhJUVrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 17:47:23 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mdfrs-0005mC-Os; Thu, 21 Oct 2021 23:44:56 +0200
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
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
        linux-kernel@vger.kernel.org
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <062df8ac9eb280440a5f0c11159616b1bbb1c2c4.1632171479.git.maciej.szmigiero@oracle.com>
 <YXCqo6XXIkyOb4IE@google.com>
 <d5c4c7da-676c-9889-6aaf-d423d408dd2d@maciej.szmigiero.name>
 <YXGVwlNxaibZAnmC@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v5 12/13] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Message-ID: <284a4fcc-3618-4ba6-dfaa-ffc4039eefcc@maciej.szmigiero.name>
Date:   Thu, 21 Oct 2021 23:44:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXGVwlNxaibZAnmC@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.10.2021 18:30, Sean Christopherson wrote:
> On Thu, Oct 21, 2021, Maciej S. Szmigiero wrote:
>> On 21.10.2021 01:47, Sean Christopherson wrote:
>>> In this case, I would honestly just drop the helper.  It's really hard to express
>>> what this function does in a name that isn't absurdly long, and there's exactly
>>> one user at the end of the series.
>>
>> The "upper bound" is a common name for a binary search operation that
>> finds the first node that has its key strictly greater than the searched key.
> 
> Ah, that I did not know (obviously).  But I suspect that detail will be lost on
> other readers as well, even if they are familiar with the terminology.
> 
>> It can be integrated into its caller but I would leave a comment there
>> describing what kind of operation that block of code does to aid in
>> understanding the code.
> 
> Yeah, completely agree a comment would be wonderful.

👍

>> Although, to be honest, I don't quite get the reason for doing this
>> considering that you want to put a single "rb_next()" call into its own
>> helper for clarity below.
> 
> The goal is to make the macro itself easy to understand, even if the reader may
> not understand the underlying details.  The bare rb_next() forces the reader to
> pause to think about exactly what "node" is, and perhaps even dive into the code
> for the other helpers.
> 
> With something like this, a reader that doesn't know the memslots details can
> get a good idea of the basic gist of the macro without having to even know the
> type of "node".  Obviously someone writing code will need to know the type, but
> for readers bouncing around code it's a detail they don't need to know.
> 
> #define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
> 	for (node = kvm_get_first_node(slots, start);			\
> 	     !kvm_is_valid_node(slots, node, end);			\
> 	     node = kvm_get_next_node(node))
> 
> Hmm, on that point, having the caller do
> 
> 	memslot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
> 
> is more than a bit odd, and as is the case with the bare rb_next(), bleeds
> implementation details into code that really doesn't care about implementation
> details.  Eww, and looking closer, the caller also needs to grab slots->node_idx.
> 
> So while I would love to avoid an opaque iterator, adding one would be a net
> positive in this case.  E.g.
> 
> /* Iterator used for walking memslots that overlap a gfn range. */
> struct kvm_memslot_iterator iter {
>          struct rb_node *node;
>          struct kvm_memory_slot *memslot;
>          struct kvm_memory_slots *slots;
> 	gfn_t start;
> 	gfn_t end;
> }
> 
> static inline void kvm_memslot_iter_start(struct kvm_memslot_iter *iter,
> 					  struct kvm_memslots *slots,
> 					  gfn_t start, gfn_t end)
> {
> 	...
> }
> 
> static inline bool kvm_memslot_iter_is_valid(struct kvm_memslot_iter *iter)
> {
> 	/*
> 	 * If this slot starts beyond or at the end of the range so does
> 	 * every next one
> 	 */
> 	return iter->node && iter->memslot->base_gfn < end;
> }
> 
> static inline void kvm_memslot_iter_next(struct kvm_memslot_iter *iter)
> {
> 	iter->node = rb_next(iter->node);
> 
> 	if (!iter->node)
> 		return;
> 
> 	iter->memslot = container_of(iter->node, struct kvm_memory_slot,
> 				     gfn_node[iter->slots->node_idx]);
> }
> 
> /* Iterate over each memslot *possibly* intersecting [start, end) range */
> #define kvm_for_each_memslot_in_gfn_range(iter, node, slots, start, end) \
> 	for (kvm_memslot_iter_start(iter, node, slots, start, end);	 \
> 	     kvm_memslot_iter_is_valid(iter);				 \
> 	     kvm_memslot_iter_next(node))				 \
> 

The iterator-based for_each implementation looks pretty nice (love the
order and consistency that higher-level abstractions bring to code) -
will change the code to use iterators instead.

It also solves the kvm_is_valid_node() naming issue below.

> Ugh, this got me looking at kvm_zap_gfn_range(), and that thing is trainwreck.
> There are three calls kvm_flush_remote_tlbs_with_address(), two of which should
> be unnecessary, but become necessary because the last one is broken.  *sigh*
> 
> That'd also be a good excuse to extract the rmap loop to a separate helper.  Then
> you don't need to constantly juggle the 80 char limit and variable collisions
> while you're modifying this mess.  I'll post the attached patches separately
> since the first one (two?) should go into 5.15.  They're compile tested only
> at this point, but hopefully I've had enough coffee and they're safe to base
> this series on top (note, they're based on kvm/queue, commit 73f122c4f06f ("KVM:
> cleanup allocation of rmaps and page tracking data").

All right, will make sure that a respin is based on a kvm tree with these
commits in.

>>> The kvm_for_each_in_gfn prefix is _really_ confusing.  I get that these are all
>>> helpers for "kvm_for_each_memslot...", but it's hard not to think these are all
>>> iterators on their own.  I would gladly sacrifice namespacing for readability in
>>> this case.
>>
>> "kvm_for_each_memslot_in_gfn_range" was your proposed name here:
>> https://lore.kernel.org/kvm/YK6GWUP107i5KAJo@google.com/
>>
>> But no problem renaming it.
> 
> Oh, I was commenting on the inner helpers.  The macro name itself is great. ;-)
> 
>>> @@ -882,12 +875,16 @@ struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t star
>>>    	return node;
>>>    }
>>>
>>> -static inline
>>> -bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *node, gfn_t end)
>>> +static inline bool kvm_is_last_node(struct kvm_memslots *slots,
>>> +				    struct rb_node *node, gfn_t end)
>>
>> kvm_is_last_node() is a bit misleading since this function is supposed
>> to return true even on the last node, only returning false one node past
>> the last one (or when the tree runs out of nodes).
> 
> Good point.  I didn't love the name when I suggested either.  What about
> kvm_is_valid_node()?

kvm_is_valid_node() sounds a bit too generic for me, but since we rewrite
the code to be iterator-based this issue goes away.

Thanks,
Maciej
