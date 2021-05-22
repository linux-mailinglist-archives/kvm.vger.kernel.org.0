Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9198D38D591
	for <lists+kvm@lfdr.de>; Sat, 22 May 2021 13:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhEVLNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 May 2021 07:13:11 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:37668 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbhEVLNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 May 2021 07:13:10 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1lkPXb-0001P8-S3; Sat, 22 May 2021 13:11:35 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
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
 <4a4867419344338e1419436af1e1b0b8f2405517.1621191551.git.maciej.szmigiero@oracle.com>
 <YKWRyvyyO5UAHv4U@google.com>
 <c7ba42ee-dc70-a86c-aeb2-d410c136a5ec@maciej.szmigiero.name>
Subject: Re: [PATCH v3 3/8] KVM: Resolve memslot ID via a hash table instead
 of via a static array
Message-ID: <5887de10-c615-175b-e491-86f94e542425@maciej.szmigiero.name>
Date:   Sat, 22 May 2021 13:11:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <c7ba42ee-dc70-a86c-aeb2-d410c136a5ec@maciej.szmigiero.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.05.2021 09:05, Maciej S. Szmigiero wrote:
> On 20.05.2021 00:31, Sean Christopherson wrote:
>> On Sun, May 16, 2021, Maciej S. Szmigiero wrote:
(..)
>>>           new_size = old_size;
>>>       slots = kvzalloc(new_size, GFP_KERNEL_ACCOUNT);
>>> -    if (likely(slots))
>>> -        memcpy(slots, old, old_size);
>>> +    if (unlikely(!slots))
>>> +        return NULL;
>>> +
>>> +    memcpy(slots, old, old_size);
>>> +
>>> +    hash_init(slots->id_hash);
>>> +    kvm_for_each_memslot(memslot, slots)
>>> +        hash_add(slots->id_hash, &memslot->id_node, memslot->id);
>>
>> What's the perf penalty if the number of memslots gets large?  I ask because the
>> lazy rmap allocation is adding multiple calls to kvm_dup_memslots().
> 
> I would expect the "move inactive" benchmark to be closest to measuring
> the performance of just a memslot array copy operation but the results
> suggest that the performance stays within ~10% window from 10 to 509
> memslots on the old code (it then climbs 13x for 32k case).
> 
> That suggests that something else is dominating this benchmark for these
> memslot counts (probably zapping of shadow pages).
> 
> At the same time, the tree-based memslots implementation is clearly
> faster in this benchmark, even for smaller memslot counts, so apparently
> copying of the memslot array has some performance impact, too.
> 
> Measuring just kvm_dup_memslots() performance would probably be done
> best by benchmarking KVM_MR_FLAGS_ONLY operation - will try to add this
> operation to my set of benchmarks and see how it performs with different
> memslot counts.

Update:
I've implemented a simple KVM_MR_FLAGS_ONLY benchmark, that repeatably
sets and unsets KVM_MEM_LOG_DIRTY_PAGES flag on a memslot with a single
page of memory in it. [1]

Since on the current code with higher memslot counts the "set flags"
operation spends a significant time in kvm_mmu_calculate_default_mmu_pages()
a second set of measurements was done with patch [2] applied.

In this case, the top functions in the perf trace are "memcpy" and
"clear_page" (called from kvm_set_memslot(), most likely from inlined
kvm_dup_memslots()).

For reference, a set of measurements with the whole patch series
(patches 1 - 8) applied was also done, as "new code".
In this case, SRCU-related functions dominate the perf trace.

32k memslots:
Current code:             0.00130s
Current code + patch [2]: 0.00104s (13x 4k result)
New code:                 0.0000144s

4k memslots:
Current code:             0.0000899s
Current code + patch [2]: 0.0000799s (+78% 2k result)
New code:                 0.0000144s

2k memslots:
Current code:             0.0000495s
Current code + patch [2]: 0.0000447s (+54% 509 result)
New code:                 0.0000143s

509 memslots:
Current code:             0.0000305s
Current code + patch [2]: 0.0000290s (+5% 100 result)
New code:                 0.0000141s

100 memslots:
Current code:             0.0000280s
Current code + patch [2]: 0.0000275s (same as for 10 slots)
New code:                 0.0000142s

10 memslots:
Current code:             0.0000272s
Current code + patch [2]: 0.0000272s
New code:                 0.0000141s

Thanks,
Maciej

[1]: The patch against memslot_perf_test.c is available here:
https://github.com/maciejsszmigiero/linux/commit/841e94898a55ff79af9d20a08205aa80808bd2a8

[2]: "[PATCH v3 1/8] KVM: x86: Cache total page count to avoid traversing the memslot array"
