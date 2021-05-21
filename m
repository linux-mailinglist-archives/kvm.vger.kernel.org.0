Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 678B838C04B
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 09:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbhEUHFB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 03:05:01 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:46894 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232634AbhEUHFA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 03:05:00 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1ljzBw-00053m-OA; Fri, 21 May 2021 09:03:28 +0200
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
References: <cover.1621191549.git.maciej.szmigiero@oracle.com>
 <eb1c881ce814705c83813f02a1a13ced96f1b1d1.1621191551.git.maciej.szmigiero@oracle.com>
 <YKV8hHDS489g9JBS@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v3 1/8] KVM: x86: Cache total page count to avoid
 traversing the memslot array
Message-ID: <e3769513-d2d8-e3fb-7887-3c8872b0f00c@maciej.szmigiero.name>
Date:   Fri, 21 May 2021 09:03:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YKV8hHDS489g9JBS@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.05.2021 23:00, Sean Christopherson wrote:
> On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> There is no point in recalculating from scratch the total number of pages
>> in all memslots each time a memslot is created or deleted.
>>
>> Just cache the value and update it accordingly on each such operation so
>> the code doesn't need to traverse the whole memslot array each time.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 5bd550eaf683..8c7738b75393 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -11112,9 +11112,21 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>>   				const struct kvm_memory_slot *new,
>>   				enum kvm_mr_change change)
>>   {
>> -	if (!kvm->arch.n_requested_mmu_pages)
>> -		kvm_mmu_change_mmu_pages(kvm,
>> -				kvm_mmu_calculate_default_mmu_pages(kvm));
>> +	if (change == KVM_MR_CREATE)
>> +		kvm->arch.n_memslots_pages += new->npages;
>> +	else if (change == KVM_MR_DELETE) {
>> +		WARN_ON(kvm->arch.n_memslots_pages < old->npages);
> 
> Heh, so I think this WARN can be triggered at will by userspace on 32-bit KVM by
> causing the running count to wrap.  KVM artificially caps the size of a single
> memslot at ((1UL << 31) - 1), but userspace could create multiple gigantic slots
> to overflow arch.n_memslots_pages.
> 
> I _think_ changing it to a u64 would fix the problem since KVM forbids overlapping
> memslots in the GPA space.

You are right, n_memslots_pages needs to be u64 so it does not overflow
on 32-bit KVM.

The memslot count is limited to 32k in each of 2 address spaces, so in
the worst case the variable should hold 15-bits + 1 bit + 31-bits = 47 bit number.

> Also, what about moving the check-and-WARN to prepare_memory_region() so that
> KVM can error out if the check fails?  Doesn't really matter, but an explicit
> error for userspace is preferable to underflowing the number of pages and getting
> weird MMU errors/behavior down the line.

In principle this seems like a possibility, however, it is a more
regression-risky option, in case something has (perhaps unintentionally)
relied on the fact that kvm_mmu_zap_oldest_mmu_pages() call from
kvm_mmu_change_mmu_pages() was being done only in the memslot commit
function.

>> +		kvm->arch.n_memslots_pages -= old->npages;
>> +	}
>> +
>> +	if (!kvm->arch.n_requested_mmu_pages) {
> 
> If we're going to bother caching the number of pages then we should also skip
> the update when the number pages isn't changing, e.g.
> 
> 	if (change == KVM_MR_CREATE || change == KVM_MR_DELETE) {
> 		if (change == KVM_MR_CREATE)
> 			kvm->arch.n_memslots_pages += new->npages;
> 		else
> 			kvm->arch.n_memslots_pages -= old->npages;
> 
> 		if (!kvm->arch.n_requested_mmu_pages) {
> 			unsigned long nr_mmu_pages;
> 
> 			nr_mmu_pages = kvm->arch.n_memslots_pages *
> 				       KVM_PERMILLE_MMU_PAGES / 1000;
> 			nr_mmu_pages = max(nr_mmu_pages, KVM_MIN_ALLOC_MMU_PAGES);
> 			kvm_mmu_change_mmu_pages(kvm, nr_mmu_pages);
> 		}
> 	}

The old code did it that way (unconditionally) and, as in the case above,
I didn't want to risk an regression.
If we are going to change this fact then I think it should happen in a
separate patch.

Thanks,
Maciej
