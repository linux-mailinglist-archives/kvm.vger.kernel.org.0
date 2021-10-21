Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE404363E3
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 16:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbhJUOS2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 10:18:28 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:34106 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhJUOS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 10:18:27 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mdYrW-0004tt-K9; Thu, 21 Oct 2021 16:16:06 +0200
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
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v5 12/13] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Message-ID: <d5c4c7da-676c-9889-6aaf-d423d408dd2d@maciej.szmigiero.name>
Date:   Thu, 21 Oct 2021 16:16:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXCqo6XXIkyOb4IE@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.10.2021 01:47, Sean Christopherson wrote:
> On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
> 
> Some mechanical comments while they're on my mind, I'll get back to a full review
> tomorrow.
> 
>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>> index 6433efff447a..9ae5f7341cf5 100644
>> --- a/include/linux/kvm_host.h
>> +++ b/include/linux/kvm_host.h
>> @@ -833,6 +833,75 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
>>   	return NULL;
>>   }
>>   
>> +static inline
>> +struct rb_node *kvm_memslots_gfn_upper_bound(struct kvm_memslots *slots, gfn_t gfn)
> 
> Function attributes should go on the same line as the function unless there's a
> really good reason to do otherwise.

Here the reason was a long line length, which was 84 characters even with
function attributes moved to a separate line.

include/linux/kvm_host.h contains a lot of helpers written in a similar
style:
> static inline gfn_t
> hva_to_gfn_memslot(unsigned long hva, struct kvm_memory_slot *slot)

> In this case, I would honestly just drop the helper.  It's really hard to express
> what this function does in a name that isn't absurdly long, and there's exactly
> one user at the end of the series.

The "upper bound" is a common name for a binary search operation that
finds the first node that has its key strictly greater than the searched key.

It can be integrated into its caller but I would leave a comment there
describing what kind of operation that block of code does to aid in
understanding the code.

Although, to be honest, I don't quite get the reason for doing this
considering that you want to put a single "rb_next()" call into its own
helper for clarity below.

> https://lkml.kernel.org/r/20210930192417.1332877-1-keescook@chromium.org
> 
>> +{
>> +	int idx = slots->node_idx;
>> +	struct rb_node *node, *result = NULL;
>> +
>> +	for (node = slots->gfn_tree.rb_node; node; ) {
>> +		struct kvm_memory_slot *slot;
> 
> My personal preference is to put declarations outside of the for loop.  I find it
> easier to read, it's harder to have shadowing issues if all variables are declared
> at the top, especially when using relatively generic names.

Will do.

>> +
>> +		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
>> +		if (gfn < slot->base_gfn) {
>> +			result = node;
>> +			node = node->rb_left;
>> +		} else
> 
> Needs braces since the "if" has braces.

Will add them.

>> +			node = node->rb_right;
>> +	}
>> +
>> +	return result;
>> +}
>> +
>> +static inline
>> +struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t start)
> 
> The kvm_for_each_in_gfn prefix is _really_ confusing.  I get that these are all
> helpers for "kvm_for_each_memslot...", but it's hard not to think these are all
> iterators on their own.  I would gladly sacrifice namespacing for readability in
> this case.

"kvm_for_each_memslot_in_gfn_range" was your proposed name here:
https://lore.kernel.org/kvm/YK6GWUP107i5KAJo@google.com/

But no problem renaming it.

> I also wouldn't worry about capturing the details.  For most folks reading this
> code, the important part is understanding the control flow of
> kvm_for_each_memslot_in_gfn_range().  Capturing the under-the-hood details in the
> name isn't a priority since anyone modifying this code is going to have to do a
> lot of staring no matter what :-)

It's even better if somebody modifying complex code has to read it carefully
(within reason, obviously).

>> +static inline
>> +bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *node, gfn_t end)
>> +{
>> +	struct kvm_memory_slot *memslot;
>> +
>> +	memslot = container_of(node, struct kvm_memory_slot, gfn_node[slots->node_idx]);
>> +
>> +	/*
>> +	 * If this slot starts beyond or at the end of the range so does
>> +	 * every next one
>> +	 */
>> +	return memslot->base_gfn >= end;
>> +}
>> +
>> +/* Iterate over each memslot *possibly* intersecting [start, end) range */
>> +#define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
>> +	for (node = kvm_for_each_in_gfn_first(slots, start);		\
>> +	     node && !kvm_for_each_in_gfn_no_more(slots, node, end);	\
> 
> I think it makes sense to move the NULL check into the validation helper?  We had
> a similar case in KVM's legacy MMU where a "null" check was left to the caller,
> and it ended up with a bunch of redundant and confusing code.  I don't see that
> happening here, but at the same time it's odd for the validator to not sanity
> check @node.
>

Will do.
  
>> +	     node = rb_next(node))					\
> 
> It's silly, but I'd add a wrapper for this one, just to make it easy to follow
> the control flow.
> 
> Maybe this as delta?  I'm definitely not set on the names, was just trying to
> find something that's short and to the point.

Thanks for the proposed patch, I added some comments inline below.

> ---
>   include/linux/kvm_host.h | 60 +++++++++++++++++++++-------------------
>   1 file changed, 31 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9ae5f7341cf5..a88bd5d9e4aa 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -833,36 +833,29 @@ struct kvm_memory_slot *id_to_memslot(struct kvm_memslots *slots, int id)
>   	return NULL;
>   }
> 
> -static inline
> -struct rb_node *kvm_memslots_gfn_upper_bound(struct kvm_memslots *slots, gfn_t gfn)
> +static inline struct rb_node *kvm_get_first_node(struct kvm_memslots *slots,
> +						 gfn_t start)
>   {
> +	struct kvm_memory_slot *slot;
> +	struct rb_node *node, *tmp;
>   	int idx = slots->node_idx;
> -	struct rb_node *node, *result = NULL;
> -
> -	for (node = slots->gfn_tree.rb_node; node; ) {
> -		struct kvm_memory_slot *slot;
> -
> -		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);
> -		if (gfn < slot->base_gfn) {
> -			result = node;
> -			node = node->rb_left;
> -		} else
> -			node = node->rb_right;
> -	}
> -
> -	return result;
> -}
> -
> -static inline
> -struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t start)
> -{
> -	struct rb_node *node;
> 
>   	/*
>   	 * Find the slot with the lowest gfn that can possibly intersect with
>   	 * the range, so we'll ideally have slot start <= range start
>   	 */
> -	node = kvm_memslots_gfn_upper_bound(slots, start);
> +	node = NULL;
> +	for (tmp = slots->gfn_tree.rb_node; tmp; ) {
> +
> +		slot = container_of(node, struct kvm_memory_slot, gfn_node[idx]);

Here -------------------------------^ should be "tmp", not "node" since
you renamed "node" into "tmp" and "result" into "node" while integrating
this function into its caller.

> +		if (gfn < slot->base_gfn) {
> +			node = tmp;
> +			tmp = tmp->rb_left;
> +		} else {
> +			tmp = tmp->rb_right;
> +		}
> +	}
> +
>   	if (node) {
>   		struct rb_node *pnode;
> 
> @@ -882,12 +875,16 @@ struct rb_node *kvm_for_each_in_gfn_first(struct kvm_memslots *slots, gfn_t star
>   	return node;
>   }
> 
> -static inline
> -bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *node, gfn_t end)
> +static inline bool kvm_is_last_node(struct kvm_memslots *slots,
> +				    struct rb_node *node, gfn_t end)

kvm_is_last_node() is a bit misleading since this function is supposed
to return true even on the last node, only returning false one node past
the last one (or when the tree runs out of nodes).

>   {
>   	struct kvm_memory_slot *memslot;
> 
> -	memslot = container_of(node, struct kvm_memory_slot, gfn_node[slots->node_idx]);
> +	if (!node)
> +		return true;
> +
> +	memslot = container_of(node, struct kvm_memory_slot,
> +			       gfn_node[slots->node_idx]);

You previously un-wrapped such lines, like for example in
https://lore.kernel.org/kvm/YK2GjzkWvjBcCFxn@google.com/ :
>> +		slot = container_of(node, struct kvm_memory_slot,
>> +				    gfn_node[idxactive]);
> 
> With 'idx', this can go on a single line.  It runs over by two chars, but the 80
> char limit is a soft limit, and IMO avoiding line breaks for things like this
> improves readability.


> 
>   	/*
>   	 * If this slot starts beyond or at the end of the range so does
> @@ -896,11 +893,16 @@ bool kvm_for_each_in_gfn_no_more(struct kvm_memslots *slots, struct rb_node *nod
>   	return memslot->base_gfn >= end;
>   }
> 
> +static inline bool kvm_get_next_node(struct rb_node *node)
> +{
> +	return rb_next(node)
> +}
> +
>   /* Iterate over each memslot *possibly* intersecting [start, end) range */
>   #define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
> -	for (node = kvm_for_each_in_gfn_first(slots, start);		\
> -	     node && !kvm_for_each_in_gfn_no_more(slots, node, end);	\
> -	     node = rb_next(node))					\
> +	for (node = kvm_get_first_node(slots, start);			\
> +	     !kvm_is_last_node(slots, node, end);			\
> +	     node = kvm_get_next_node(node))				\
> 
>   /*
>    * KVM_SET_USER_MEMORY_REGION ioctl allows the following operations:
> --
> 

Thanks,
Maciej
