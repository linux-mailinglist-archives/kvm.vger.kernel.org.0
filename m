Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67EB2492C5F
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 18:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347314AbiARRaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 12:30:09 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:43150 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347244AbiARRaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 12:30:08 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1n9sIu-0000RU-G7; Tue, 18 Jan 2022 18:29:56 +0100
Message-ID: <28a005b7-9ae3-fe0d-b003-9aedba27dc85@maciej.szmigiero.name>
Date:   Tue, 18 Jan 2022 18:29:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Nikunj A Dadhania <nikunj@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-7-nikunj@amd.com>
 <010ef70c-31a2-2831-a2a7-950db14baf23@maciej.szmigiero.name>
Subject: Re: [RFC PATCH 6/6] KVM: SVM: Pin SEV pages in MMU during
 sev_launch_update_data()
In-Reply-To: <010ef70c-31a2-2831-a2a7-950db14baf23@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.01.2022 16:00, Maciej S. Szmigiero wrote:
> Hi Nikunj,
> 
> On 18.01.2022 12:06, Nikunj A Dadhania wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Pin the memory for the data being passed to launch_update_data()
>> because it gets encrypted before the guest is first run and must
>> not be moved which would corrupt it.
>>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> [ * Changed hva_to_gva() to take an extra argument and return gpa_t.
>>    * Updated sev_pin_memory_in_mmu() error handling.
>>    * As pinning/unpining pages is handled within MMU, removed
>>      {get,put}_user(). ]
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>   arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 119 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 14aeccfc500b..1ae714e83a3c 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -22,6 +22,7 @@
>>   #include <asm/trapnr.h>
>>   #include <asm/fpu/xcr.h>
>> +#include "mmu.h"
>>   #include "x86.h"
>>   #include "svm.h"
>>   #include "svm_ops.h"
>> @@ -490,6 +491,110 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>>       return pages;
>>   }
>> +#define SEV_PFERR_RO (PFERR_USER_MASK)
>> +#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
>> +
>> +static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
>> +                          unsigned long hva)
>> +{
>> +    struct kvm_memslots *slots = kvm_memslots(kvm);
>> +    struct kvm_memory_slot *memslot;
>> +    int bkt;
>> +
>> +    kvm_for_each_memslot(memslot, bkt, slots) {
>> +        if (hva >= memslot->userspace_addr &&
>> +            hva < memslot->userspace_addr +
>> +            (memslot->npages << PAGE_SHIFT))
>> +            return memslot;
>> +    }
>> +
>> +    return NULL;
>> +}
> 
> We have kvm_for_each_memslot_in_hva_range() now, please don't do a linear
> search through memslots.
> You might need to move the aforementioned macro from kvm_main.c to some
> header file, though.

Besides performance considerations I can't see the code here taking into
account the fact that a hva can map to multiple memslots (they an overlap
in the host address space).

Thanks,
Maciej
