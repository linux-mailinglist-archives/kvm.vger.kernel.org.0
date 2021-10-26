Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C0243B9EB
	for <lists+kvm@lfdr.de>; Tue, 26 Oct 2021 20:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236388AbhJZSs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 14:48:58 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:49342 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238414AbhJZSsz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 14:48:55 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mfRSn-0007Fb-4t; Tue, 26 Oct 2021 20:46:21 +0200
Subject: Re: [PATCH v5 09/13] KVM: Use interval tree to do fast hva lookup in
 memslots
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
 <89deea791ff7a5f4faa535edb9956e9863a564b8.1632171479.git.maciej.szmigiero@oracle.com>
 <YXhGo/FpqUAuz7Td@google.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <dcee5903-68da-094e-d3b9-c91d071c3af3@maciej.szmigiero.name>
Date:   Tue, 26 Oct 2021 20:46:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YXhGo/FpqUAuz7Td@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26.10.2021 20:19, Sean Christopherson wrote:
> On Mon, Sep 20, 2021, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> The current memslots implementation only allows quick binary search by gfn,
>> quick lookup by hva is not possible - the implementation has to do a linear
>> scan of the whole memslots array, even though the operation being performed
>> might apply just to a single memslot.
>>
>> This significantly hurts performance of per-hva operations with higher
>> memslot counts.
>>
>> Since hva ranges can overlap between memslots an interval tree is needed
>> for tracking them.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 50597608d085..7ed780996910 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -472,6 +472,12 @@ static void kvm_null_fn(void)
>>   }
>>   #define IS_KVM_NULL_FN(fn) ((fn) == (void *)kvm_null_fn)
>>   
>> +/* Iterate over each memslot intersecting [start, last] (inclusive) range */
>> +#define kvm_for_each_memslot_in_hva_range(node, slots, start, last)	     \
>> +	for (node = interval_tree_iter_first(&slots->hva_tree, start, last); \
>> +	     node;							     \
>> +	     node = interval_tree_iter_next(node, start, last))	     \
> 
> Similar to kvm_for_each_memslot_in_gfn_range(), this should use an opaque iterator
> to hide the implementation details from the caller, e.g. to avoid having to define
> a "struct interval_tree_node" and do container_of.
> 

Will convert to an iterator-based for_each implementation in the next version
of this patchset.

Thanks,
Maciej
