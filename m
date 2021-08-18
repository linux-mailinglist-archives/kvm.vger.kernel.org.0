Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB593F0D9E
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 23:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbhHRVoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 17:44:09 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:34654 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234140AbhHRVoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 17:44:09 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mGTLL-000665-Kq; Wed, 18 Aug 2021 23:43:27 +0200
To:     David Hildenbrand <david@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
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
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <cover.1628871411.git.maciej.szmigiero@oracle.com>
 <8db0f1d1901768b5de1417caa425e62d1118e5e8.1628871413.git.maciej.szmigiero@oracle.com>
 <957c6b3d-9621-a5a5-418c-f61f87a32ee0@redhat.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH v4 06/13] KVM: Move WARN on invalid memslot index to
 update_memslots()
Message-ID: <fa71d652-8b7f-e0d7-5617-8958e3e78f6e@maciej.szmigiero.name>
Date:   Wed, 18 Aug 2021 23:43:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <957c6b3d-9621-a5a5-418c-f61f87a32ee0@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.08.2021 16:35, David Hildenbrand wrote:
> On 13.08.21 21:33, Maciej S. Szmigiero wrote:
>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>
>> Since kvm_memslot_move_forward() can theoretically return a negative
>> memslot index even when kvm_memslot_move_backward() returned a positive one
>> (and so did not WARN) let's just move the warning to the common code.
>>
>> Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
>> ---
>>   virt/kvm/kvm_main.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 03ef42d2e421..7000efff1425 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1293,8 +1293,7 @@ static inline int kvm_memslot_move_backward(struct kvm_memslots *slots,
>>       struct kvm_memory_slot *mslots = slots->memslots;
>>       int i;
>> -    if (WARN_ON_ONCE(slots->id_to_index[memslot->id] == -1) ||
>> -        WARN_ON_ONCE(!slots->used_slots))
>> +    if (slots->id_to_index[memslot->id] == -1 || !slots->used_slots)
>>           return -1;
>>       /*
>> @@ -1398,6 +1397,9 @@ static void update_memslots(struct kvm_memslots *slots,
>>               i = kvm_memslot_move_backward(slots, memslot);
>>           i = kvm_memslot_move_forward(slots, memslot, i);
>> +        if (WARN_ON_ONCE(i < 0))
>> +            return;
>> +
>>           /*
>>            * Copy the memslot to its new position in memslots and update
>>            * its index accordingly.
>>
> 
> 
> Note that WARN_ON_* is frowned upon, because it can result in crashes with panic_on_warn enabled, which is what some distributions do enable.
> 
> We tend to work around that by using pr_warn()/pr_warn_once(), avoiding eventually crashing the system when there is a way to continue.
> 

This patch uses WARN_ON_ONCE because:
1) It was used in the old code and the patch merely moves the check
from kvm_memslot_move_backward() to its caller,

2) This chunk of code is wholly replaced by patch 11 from this series
anyway ("Keep memslots in tree-based structures instead of array-based ones").

Thanks,
Maciej
