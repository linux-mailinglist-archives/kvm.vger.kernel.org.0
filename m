Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526BD4352D6
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhJTSnv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:43:51 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:40886 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231368AbhJTSnu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:43:50 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mdGWq-0002fI-69; Wed, 20 Oct 2021 20:41:32 +0200
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
 <d0d2c6fda0a21962eefcf28b37a603caa4be1819.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9XCp3B+ogPIl7i@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v5 05/13] KVM: Integrate gfn_to_memslot_approx() into
 search_memslots()
Message-ID: <fcb2a5ce-852a-d3c1-3900-e43be1a9cf00@maciej.szmigiero.name>
Date:   Wed, 20 Oct 2021 20:41:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YW9XCp3B+ogPIl7i@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.10.2021 01:38, Sean Christopherson wrote:
> On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
>> @@ -1267,7 +1280,7 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index)
>>    * itself isn't here as an inline because that would bloat other code too much.
>>    */
>>   static inline struct kvm_memory_slot *
>> -__gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
>> +__gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn, bool approx)
> 
> This function name is a misnomer.  The helper is not an "approx" version, it's an
> inner helper that takes an @approx param.  Unless someone has a more clever name,
> the dreaded four underscores seems like the way to go.  Warning away users is a
> good thing in this case...
> 
>>   {
>>   	struct kvm_memory_slot *slot;
>>   	int slot_index = atomic_read(&slots->last_used_slot);
>> @@ -1276,7 +1289,7 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
>>   	if (slot)
>>   		return slot;
>>   
>> -	slot = search_memslots(slots, gfn, &slot_index);
>> +	slot = search_memslots(slots, gfn, &slot_index, approx);
>>   	if (slot) {
>>   		atomic_set(&slots->last_used_slot, slot_index);
>>   		return slot;
>> @@ -1285,6 +1298,12 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
>>   	return NULL;
>>   }
>>   
> 
> There's a comment that doesn't show up in this diff that should also be moved,
> and opportunistically updated.
> 
>> +static inline struct kvm_memory_slot *
>> +__gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
>> +{
>> +	return __gfn_to_memslot_approx(slots, gfn, false);
>> +}
>> +
>>   static inline unsigned long
>>   __gfn_to_hva_memslot(const struct kvm_memory_slot *slot, gfn_t gfn)
>>   {
> 
> E.g. this as fixup?
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 540fa948baa5..2964c773b36c 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1964,10 +1964,15 @@ static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
>          return 0;
>   }
> 
> +static int gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn)
> +{
> +       return ____gfn_to_memslot(slots, cur_gfn, true);
> +}
> +
>   static unsigned long kvm_s390_next_dirty_cmma(struct kvm_memslots *slots,
>                                                unsigned long cur_gfn)
>   {
> -       struct kvm_memory_slot *ms = __gfn_to_memslot_approx(slots, cur_gfn, true);
> +       struct kvm_memory_slot *ms = gfn_to_memslot_approx(slots, cur_gfn);
>          int slotidx = ms - slots->memslots;
>          unsigned long ofs = cur_gfn - ms->base_gfn;
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8fd9644f40b2..ec1a074c2f6e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1274,13 +1274,8 @@ search_memslots(struct kvm_memslots *slots, gfn_t gfn, int *index, bool approx)
>          return NULL;
>   }
> 
> -/*
> - * __gfn_to_memslot() and its descendants are here because it is called from
> - * non-modular code in arch/powerpc/kvm/book3s_64_vio{,_hv}.c. gfn_to_memslot()
> - * itself isn't here as an inline because that would bloat other code too much.
> - */
>   static inline struct kvm_memory_slot *
> -__gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn, bool approx)
> +____gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn, bool approx)
>   {
>          struct kvm_memory_slot *slot;
>          int slot_index = atomic_read(&slots->last_used_slot);
> @@ -1298,10 +1293,15 @@ __gfn_to_memslot_approx(struct kvm_memslots *slots, gfn_t gfn, bool approx)
>          return NULL;
>   }
> 
> +/*
> + * __gfn_to_memslot() and its descendants are here to allow arch code to inline
> + * the lookups in hot paths.  gfn_to_memslot() itself isn't here as an inline
> + * because that would bloat other code too much.
> + */
>   static inline struct kvm_memory_slot *
>   __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
>   {
> -       return __gfn_to_memslot_approx(slots, gfn, false);
> +       return ____gfn_to_memslot(slots, gfn, false);
>   }
> 
>   static inline unsigned long
> 

Looks sensible, will apply your proposed changes.

Thanks,
Maciej
