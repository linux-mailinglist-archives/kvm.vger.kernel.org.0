Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A70397B33
	for <lists+kvm@lfdr.de>; Tue,  1 Jun 2021 22:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbhFAU1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Jun 2021 16:27:14 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:35336 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234799AbhFAU1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Jun 2021 16:27:13 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1loAx2-0008T9-Ui; Tue, 01 Jun 2021 22:25:24 +0200
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
 <38333ef36e7812e1b9f9d24e726ca632997a8ef1.1621191552.git.maciej.szmigiero@oracle.com>
 <YK6GWUP107i5KAJo@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v3 7/8] KVM: Optimize gfn lookup in kvm_zap_gfn_range()
Message-ID: <99a961d2-d46c-ead9-1138-45f6587a60ed@maciej.szmigiero.name>
Date:   Tue, 1 Jun 2021 22:25:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YK6GWUP107i5KAJo@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.05.2021 19:33, Sean Christopherson wrote:
> On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> Introduce a memslots gfn upper bound operation and use it to optimize
>> kvm_zap_gfn_range().
>> This way this handler can do a quick lookup for intersecting gfns and won't
>> have to do a linear scan of the whole memslot set.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c   | 41 ++++++++++++++++++++++++++++++++++++++--
>>   include/linux/kvm_host.h | 22 +++++++++++++++++++++
>>   2 files changed, 61 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 7222b552d139..f23398cf0316 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -5490,14 +5490,51 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
>>   	int i;
>>   	bool flush = false;
>>   
>> +	if (gfn_end == gfn_start || WARN_ON(gfn_end < gfn_start))
>> +		return;
>> +
>>   	write_lock(&kvm->mmu_lock);
>>   	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
>> -		int ctr;
>> +		int idxactive;
>> +		struct rb_node *node;
>>   
>>   		slots = __kvm_memslots(kvm, i);
>> -		kvm_for_each_memslot(memslot, ctr, slots) {
>> +		idxactive = kvm_memslots_idx(slots);
>> +
>> +		/*
>> +		 * Find the slot with the lowest gfn that can possibly intersect with
>> +		 * the range, so we'll ideally have slot start <= range start
>> +		 */
>> +		node = kvm_memslots_gfn_upper_bound(slots, gfn_start);
>> +		if (node) {
>> +			struct rb_node *pnode;
>> +
>> +			/*
>> +			 * A NULL previous node means that the very first slot
>> +			 * already has a higher start gfn.
>> +			 * In this case slot start > range start.
>> +			 */
>> +			pnode = rb_prev(node);
>> +			if (pnode)
>> +				node = pnode;
>> +		} else {
>> +			/* a NULL node below means no slots */
>> +			node = rb_last(&slots->gfn_tree);
>> +		}
>> +
>> +		for ( ; node; node = rb_next(node)) {
>>   			gfn_t start, end;
> 
> Can this be abstracted into something like:
> 
> 		kvm_for_each_memslot_in_gfn_range(...) {
> 
> 		}
> 
> and share that implementation with kvm_check_memslot_overlap() in the next patch?
> 
> I really don't think arch code should be poking into gfn_tree, and ideally arch
> code wouldn't even be aware that gfn_tree exists.

That's a good idea, will do.

Thanks,
Maciej
