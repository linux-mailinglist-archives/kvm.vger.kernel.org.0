Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7305D4352D8
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbhJTSoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:44:20 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:40920 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231180AbhJTSoS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:44:18 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mdGXD-0002gH-9Z; Wed, 20 Oct 2021 20:41:55 +0200
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
 <311810ebd1111bed50d931d424297384171afc36.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9a2s8wHXzf8Xqw@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v5 07/13] KVM: Just resync arch fields when
 slots_arch_lock gets reacquired
Message-ID: <b9ffb6cf-d59b-3bb5-a9b0-71e32c81135a@maciej.szmigiero.name>
Date:   Wed, 20 Oct 2021 20:41:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YW9a2s8wHXzf8Xqw@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.10.2021 01:55, Sean Christopherson wrote:
> On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> There is no need to copy the whole memslot data after releasing
>> slots_arch_lock for a moment to install temporary memslots copy in
>> kvm_set_memslot() since this lock only protects the arch field of each
>> memslot.
>>
>> Just resync this particular field after reacquiring slots_arch_lock.
> 
> I assume this needed to avoid having a mess when introducing the r-b tree?  If so,
> please call that out.  Iterating over the slots might actually be slower than the
> full memcpy, i.e. as a standalone patch this may or may not be make sense.

Yes, it's an intermediate state of the code to not break bisecting.
The code changed by this patch is then completely replaced later by the
patch 11 of this patchset.

Will add a note about this to the commit message.

>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>>   virt/kvm/kvm_main.c | 17 ++++++++++++-----
>>   1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 348fae880189..48d182840060 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1482,6 +1482,15 @@ static void kvm_copy_memslots(struct kvm_memslots *to,
>>   	memcpy(to, from, kvm_memslots_size(from->used_slots));
>>   }
>>   
>> +static void kvm_copy_memslots_arch(struct kvm_memslots *to,
>> +				   struct kvm_memslots *from)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < from->used_slots; i++)
>> +		to->memslots[i].arch = from->memslots[i].arch;
> 
> This should probably be a memcpy(), I don't know what all shenanigans the compiler
> can throw at us if it gets to copy a struct by value.

Normally, copy-assignment of a struct is a safe operation (this is purely
an internal kernel struct, so there are no worries about padding leakage
to the userspace), but can replace this with a memcpy().

>> +}
>> +
>>   /*
>>    * Note, at a minimum, the current number of used slots must be allocated, even
>>    * when deleting a memslot, as we need a complete duplicate of the memslots for
> 
> There's an out-of-sight comment that's now stale, can you revert to the
> pre-slots_arch_lock comment?
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 48d182840060..ef3345428047 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1555,9 +1555,10 @@ static int kvm_set_memslot(struct kvm *kvm,
>                  slot->flags |= KVM_MEMSLOT_INVALID;
> 
>                  /*
> -                * We can re-use the memory from the old memslots.
> -                * It will be overwritten with a copy of the new memslots
> -                * after reacquiring the slots_arch_lock below.
> +                * We can re-use the old memslots, the only difference from the
> +                * newly installed memslots is the invalid flag, which will get
> +                * dropped by update_memslots anyway.  We'll also revert to the
> +                * old memslots if preparing the new memory region fails.
>                   */
>                  slots = install_new_memslots(kvm, as_id, slots);
> 

Will do.

>> @@ -1567,10 +1576,10 @@ static int kvm_set_memslot(struct kvm *kvm,
>>   		/*
>>   		 * The arch-specific fields of the memslots could have changed
>>   		 * between releasing the slots_arch_lock in
>> -		 * install_new_memslots and here, so get a fresh copy of the
>> -		 * slots.
>> +		 * install_new_memslots and here, so get a fresh copy of these
>> +		 * fields.
>>   		 */
>> -		kvm_copy_memslots(slots, __kvm_memslots(kvm, as_id));
>> +		kvm_copy_memslots_arch(slots, __kvm_memslots(kvm, as_id));
>>   	}
>>   
>>   	r = kvm_arch_prepare_memory_region(kvm, old, new, mem, change);
>> @@ -1587,8 +1596,6 @@ static int kvm_set_memslot(struct kvm *kvm,
>>   
>>   out_slots:
>>   	if (change == KVM_MR_DELETE || change == KVM_MR_MOVE) {
>> -		slot = id_to_memslot(slots, old->id);
>> -		slot->flags &= ~KVM_MEMSLOT_INVALID;
>>   		slots = install_new_memslots(kvm, as_id, slots);
>>   	} else {
> 
> The braces can be dropped since both branches are now single lines.
> 
>>   		mutex_unlock(&kvm->slots_arch_lock);

Will drop them.

Thanks,
Maciej
