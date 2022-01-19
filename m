Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A32494033
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 19:53:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356917AbiASSww (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 13:52:52 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:54600 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230509AbiASSwv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 13:52:51 -0500
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nAG4U-0005cZ-P9; Wed, 19 Jan 2022 19:52:38 +0100
Message-ID: <416d8fde-9fbc-afaa-1abe-0a35fa2085c4@maciej.szmigiero.name>
Date:   Wed, 19 Jan 2022 19:52:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     "Nikunj A. Dadhania" <nikunj@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Bharata B Rao <bharata@amd.com>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-7-nikunj@amd.com>
 <010ef70c-31a2-2831-a2a7-950db14baf23@maciej.szmigiero.name>
 <0e523405-f52c-b152-1dd3-aa65a9caee3c@amd.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [RFC PATCH 6/6] KVM: SVM: Pin SEV pages in MMU during
 sev_launch_update_data()
In-Reply-To: <0e523405-f52c-b152-1dd3-aa65a9caee3c@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.01.2022 07:33, Nikunj A. Dadhania wrote:
> Hi Maciej,
> 
> On 1/18/2022 8:30 PM, Maciej S. Szmigiero wrote:
>> Hi Nikunj,
>>
>> On 18.01.2022 12:06, Nikunj A Dadhania wrote:
>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>
>>> Pin the memory for the data being passed to launch_update_data()
>>> because it gets encrypted before the guest is first run and must
>>> not be moved which would corrupt it.
>>>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> [ * Changed hva_to_gva() to take an extra argument and return gpa_t.
>>>     * Updated sev_pin_memory_in_mmu() error handling.
>>>     * As pinning/unpining pages is handled within MMU, removed
>>>       {get,put}_user(). ]
>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>> ---
>>>    arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++++++++++++++++++++++++-
>>>    1 file changed, 119 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 14aeccfc500b..1ae714e83a3c 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -22,6 +22,7 @@
>>>    #include <asm/trapnr.h>
>>>    #include <asm/fpu/xcr.h>
>>>    +#include "mmu.h"
>>>    #include "x86.h"
>>>    #include "svm.h"
>>>    #include "svm_ops.h"
>>> @@ -490,6 +491,110 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>>>        return pages;
>>>    }
>>>    +#define SEV_PFERR_RO (PFERR_USER_MASK)
>>> +#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
>>> +
>>> +static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
>>> +                          unsigned long hva)
>>> +{
>>> +    struct kvm_memslots *slots = kvm_memslots(kvm);
>>> +    struct kvm_memory_slot *memslot;
>>> +    int bkt;
>>> +
>>> +    kvm_for_each_memslot(memslot, bkt, slots) {
>>> +        if (hva >= memslot->userspace_addr &&
>>> +            hva < memslot->userspace_addr +
>>> +            (memslot->npages << PAGE_SHIFT))
>>> +            return memslot;
>>> +    }
>>> +
>>> +    return NULL;
>>> +}
>>
>> We have kvm_for_each_memslot_in_hva_range() now, please don't do a linear
>> search through memslots.
>> You might need to move the aforementioned macro from kvm_main.c to some
>> header file, though.
> 
> Sure, let me try optimizing with this newly added macro.

👍

>>
>>> +static gpa_t hva_to_gpa(struct kvm *kvm, unsigned long hva, bool *ro)
>>> +{
>>> +    struct kvm_memory_slot *memslot;
>>> +    gpa_t gpa_offset;
>>> +
>>> +    memslot = hva_to_memslot(kvm, hva);
>>> +    if (!memslot)
>>> +        return UNMAPPED_GVA;
>>> +
>>> +    *ro = !!(memslot->flags & KVM_MEM_READONLY);
>>> +    gpa_offset = hva - memslot->userspace_addr;
>>> +    return ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset);
>>> +}
>>> +
>>> +static struct page **sev_pin_memory_in_mmu(struct kvm *kvm, unsigned long addr,
>>> +                       unsigned long size,
>>> +                       unsigned long *npages)
>>> +{
>>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>> +    struct kvm_vcpu *vcpu;
>>> +    struct page **pages;
>>> +    unsigned long i;
>>> +    u32 error_code;
>>> +    kvm_pfn_t pfn;
>>> +    int idx, ret = 0;
>>> +    gpa_t gpa;
>>> +    bool ro;
>>> +
>>> +    pages = sev_alloc_pages(sev, addr, size, npages);
>>> +    if (IS_ERR(pages))
>>> +        return pages;
>>> +
>>> +    vcpu = kvm_get_vcpu(kvm, 0);
>>> +    if (mutex_lock_killable(&vcpu->mutex)) {
>>> +        kvfree(pages);
>>> +        return ERR_PTR(-EINTR);
>>> +    }
>>> +
>>> +    vcpu_load(vcpu);
>>> +    idx = srcu_read_lock(&kvm->srcu);
>>> +
>>> +    kvm_mmu_load(vcpu);
>>> +
>>> +    for (i = 0; i < *npages; i++, addr += PAGE_SIZE) {
>>> +        if (signal_pending(current)) {
>>> +            ret = -ERESTARTSYS;
>>> +            break;
>>> +        }
>>> +
>>> +        if (need_resched())
>>> +            cond_resched();
>>> +
>>> +        gpa = hva_to_gpa(kvm, addr, &ro);
>>> +        if (gpa == UNMAPPED_GVA) {
>>> +            ret = -EFAULT;
>>> +            break;
>>> +        }
>>
>> This function is going to have worst case O(n²) complexity if called with
>> the whole VM memory (or O(n * log(n)) when hva_to_memslot() is modified
>> to use kvm_for_each_memslot_in_hva_range()).
> 
> I understand your concern and will address it. BTW, this is called for a small
> fragment of VM memory( <10MB), that needs to be pinned before the guest execution
> starts.

I understand it is a relatively small memory area now, but a rewrite of
this patch that makes use of kvm_for_each_memslot_in_hva_range() while
taking care of other considerations (like overlapping hva) will also
solve the performance issue.

>> That's really bad for something that can be done in O(n) time - look how
>> kvm_for_each_memslot_in_gfn_range() does it over gfns.
>>
> 
> I saw one use of kvm_for_each_memslot_in_gfn_range() in __kvm_zap_rmaps(), and
> that too calls slot_handle_level_range() which has a for_each_slot_rmap_range().
> How would that be O(n) ?
> 
> kvm_for_each_memslot_in_gfn_range() {
> 	...
> 	slot_handle_level_range()
> 	...
> }
> 
> slot_handle_level_range() {
> 	...
> 	for_each_slot_rmap_range() {
> 		...
> 	}
> 	...
> }

kvm_for_each_memslot_in_gfn_range() iterates over gfns, which are unique,
so at most one memslot is returned per gfn (and if a memslot covers
multiple gfns in the requested range it will be returned just once).

for_each_slot_rmap_range() then iterates over rmaps covering that
*single* memslot: look at slot_rmap_walk_next() - the memslot under
iteration is not advanced.

So each memslot returned by kvm_for_each_memslot_in_gfn_range() is
iterated over just once by the aforementioned macro.

>> Besides performance considerations I can't see the code here taking into
>> account the fact that a hva can map to multiple memslots (they an overlap
>> in the host address space).
> 
> You are right I was returning at the first match, looks like if I switch to using 
> kvm_for_each_memslot_in_hva_range() it should take care of overlapping hva, 
> is this understanding correct ?

Let's say that the requested range of hva for sev_pin_memory_in_mmu() to
handle is 0x1000 - 0x2000.

If there are three memslots:
1: hva 0x1000 - 0x2000 -> gpa 0x1000 - 0x2000
2: hva 0x1000 - 0x2000 -> gpa 0x2000 - 0x3000
3: hva 0x2000 - 0x3000 -> gpa 0x3000 - 0x4000

then kvm_for_each_memslot_in_hva_range() will return the first two,
essentially covering the hva range of 0x1000 - 0x2000 twice.

If such hva aliases are permitted the code has to be ready for this case
and handle it sensibly:
If you need to return just a single struct page per a hva AND / OR pin
operations aren't idempotent then it has to keep track which hva were
already processed.

Another, and probably the easiest option would be to simply disallow
such overlapping memslots in the requested range and make
KVM_SEV_LAUNCH_UPDATE_DATA ioctl return something like EINVAL in this
case - if that would be acceptable semantics for this ioctl.

In any case, the main loop in sev_pin_memory_in_mmu() will probably
need to be build around a kvm_for_each_memslot_in_hva_range() call,
which will then solve the performance issue, too.

> Regards,
> Nikunj

Thanks,
Maciej
