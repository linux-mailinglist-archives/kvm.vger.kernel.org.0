Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2069E4352CE
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 20:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhJTSmx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 14:42:53 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:40788 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231305AbhJTSmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 14:42:46 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mdGVk-0002da-PZ; Wed, 20 Oct 2021 20:40:24 +0200
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
 <d07f07cdd545ab1a495a9a0da06e43ad97c069a2.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9Fi128rYxiF1v3@google.com> <YW9HL3FOkOk56I5g@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v5 01/13] KVM: x86: Cache total page count to avoid
 traversing the memslot array
Message-ID: <59217787-416c-fc04-f69f-61801477b2ea@maciej.szmigiero.name>
Date:   Wed, 20 Oct 2021 20:40:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YW9HL3FOkOk56I5g@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.10.2021 00:31, Sean Christopherson wrote:
> On Tue, Oct 19, 2021, Sean Christopherson wrote:
>> On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
>>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>>
>>> There is no point in recalculating from scratch the total number of pages
>>> in all memslots each time a memslot is created or deleted.
>>>
>>> Just cache the value and update it accordingly on each such operation so
>>> the code doesn't need to traverse the whole memslot array each time.
>>>
>>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>>> ---
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 28ef14155726..65fdf27b9423 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -11609,9 +11609,23 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>>   				const struct kvm_memory_slot *new,
>>>   				enum kvm_mr_change change)
>>>   {
>>> -	if (!kvm->arch.n_requested_mmu_pages)
>>> -		kvm_mmu_change_mmu_pages(kvm,
>>> -				kvm_mmu_calculate_default_mmu_pages(kvm));
>>> +	if (change == KVM_MR_CREATE)
>>> +		kvm->arch.n_memslots_pages += new->npages;
>>> +	else if (change == KVM_MR_DELETE) {
>>> +		WARN_ON(kvm->arch.n_memslots_pages < old->npages);
>>> +		kvm->arch.n_memslots_pages -= old->npages;
>>> +	}
>>> +
>>> +	if (!kvm->arch.n_requested_mmu_pages) {
>>
>> Hmm, once n_requested_mmu_pages is set it can't be unset.  That means this can be
>> further optimized to skip avoid taking mmu_lock on flags-only changes (and
>> memslot movement).  E.g.
>>
>> 	if (!kvm->arch.n_requested_mmu_pages &&
>> 	    (change == KVM_MR_CREATE || change == KVM_MR_DELETE)) {
>>
>> 	}
>>
>> It's a little risky, but kvm_vm_ioctl_set_nr_mmu_pages() would need to be modified
>> to allow clearing n_requested_mmu_pages and it already takes slots_lock, so IMO
>> it's ok to force kvm_vm_ioctl_set_nr_mmu_pages() to recalculate pages if it wants
>> to allow reverting back to the default.
> 
> Doh, and then I read patch 2...
> 
> I would swap the order of patch 2 and patch 1, that way the optimization patch is
> super simple, and you don't end up reworking a bunch of code that was added in the
> immediately preceding patch.  E.g. as a first patch
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 28ef14155726..f3b1aed08566 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -11609,7 +11609,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>                                  const struct kvm_memory_slot *new,
>                                  enum kvm_mr_change change)
>   {
> -       if (!kvm->arch.n_requested_mmu_pages)
> +       if (!kvm->arch.n_requested_mmu_pages &&
> +           (change == KVM_MR_CREATE || change == KVM_MR_DELETE))
>                  kvm_mmu_change_mmu_pages(kvm,
>                                  kvm_mmu_calculate_default_mmu_pages(kvm));
> 
> 
> 

Will do.

Thanks,
Maciej

