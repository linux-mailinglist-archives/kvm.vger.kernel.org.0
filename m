Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA8072D6B3
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 03:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbjFMBHf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 21:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbjFMBHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 21:07:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FBE101
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 18:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686618406;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pp2v4JGg/azUMKE4ngBrTREnGkx7OP+Tpx1fYNaDsgg=;
        b=Ib+HOPgrhe5f4n5crvAf9eYcvU+OF06J9y7XkZEifL1XLLhZNKOc0q3Ps8DTPNkV57+H21
        3mKfOhhC8wHNd5GrWfGv+Y9YALCVRYVn/r06NRHS8j4O75H3nw3kL5/yfuW86KF0V1B6KN
        qvIBW9ViERKK6ADYeR6MUY/T2p+VABE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-396-rKSvumxhOQaDYJhfz4Fpow-1; Mon, 12 Jun 2023 21:06:45 -0400
X-MC-Unique: rKSvumxhOQaDYJhfz4Fpow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3CE61C06EC2;
        Tue, 13 Jun 2023 01:06:44 +0000 (UTC)
Received: from [10.64.54.138] (vpn2-54-138.bne.redhat.com [10.64.54.138])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BA249C1604C;
        Tue, 13 Jun 2023 01:06:41 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: Avoid illegal stage2 mapping on invalid memory slot
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        oliver.upton@linux.dev, maz@kernel.org, hshuai@redhat.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20230608090348.414990-1-gshan@redhat.com>
 <ZIcujNKVosLeQEqR@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <6e335f13-01bd-2972-ead2-3081819aa151@redhat.com>
Date:   Tue, 13 Jun 2023 11:06:39 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <ZIcujNKVosLeQEqR@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 6/13/23 12:41 AM, Sean Christopherson wrote:
> On Thu, Jun 08, 2023, Gavin Shan wrote:
>> We run into guest hang in edk2 firmware when KSM is kept as running
>> on the host. The edk2 firmware is waiting for status 0x80 from QEMU's
>> pflash device (TYPE_PFLASH_CFI01) during the operation for sector
>> erasing or buffered write. The status is returned by reading the
>> memory region of the pflash device and the read request should
>> have been forwarded to QEMU and emulated by it. Unfortunately, the
>> read request is covered by an illegal stage2 mapping when the guest
>> hang issue occurs. The read request is completed with QEMU bypassed and
>> wrong status is fetched.
>>
>> The illegal stage2 mapping is populated due to same page mering by
>> KSM at (C) even the associated memory slot has been marked as invalid
>> at (B).
>>
>>    CPU-A                    CPU-B
>>    -----                    -----
>>                             ioctl(kvm_fd, KVM_SET_USER_MEMORY_REGION)
>>                             kvm_vm_ioctl_set_memory_region
>>                             kvm_set_memory_region
>>                             __kvm_set_memory_region
>>                             kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE)
>>                               kvm_invalidate_memslot
>>                                 kvm_copy_memslot
>>                                 kvm_replace_memslot
>>                                 kvm_swap_active_memslots        (A)
>>                                 kvm_arch_flush_shadow_memslot   (B)
>>    same page merging by KSM
>>    kvm_mmu_notifier_change_pte
>>    kvm_handle_hva_range
>>    __kvm_handle_hva_range       (C)
>>
>> Fix the issue by skipping the invalid memory slot at (C) to avoid the
>> illegal stage2 mapping. Without the illegal stage2 mapping, the read
>> request for the pflash's status is forwarded to QEMU and emulated by
>> it. The correct pflash's status can be returned from QEMU to break
>> the infinite wait in edk2 firmware.
>>
>> Cc: stable@vger.kernel.org # v5.13+
>> Fixes: 3039bcc74498 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
> 
> This Fixes isn't correct.  That change only affected x86, which doesn't have this
> bug.  And looking at commit cd4c71835228 ("KVM: arm64: Convert to the gfn-based MMU
> notifier callbacks"), arm64 did NOT skip invalid slots
> 
>          slots = kvm_memslots(kvm);
> 
>          /* we only care about the pages that the guest sees */
>          kvm_for_each_memslot(memslot, slots) {
>                  unsigned long hva_start, hva_end;
>                  gfn_t gpa;
> 
>                  hva_start = max(start, memslot->userspace_addr);
>                  hva_end = min(end, memslot->userspace_addr +
>                                          (memslot->npages << PAGE_SHIFT));
>                  if (hva_start >= hva_end)
>                          continue;
> 
>                  gpa = hva_to_gfn_memslot(hva_start, memslot) << PAGE_SHIFT;
>                  ret |= handler(kvm, gpa, (u64)(hva_end - hva_start), data);
>          }
> 
> #define kvm_for_each_memslot(memslot, slots)                            \
>          for (memslot = &slots->memslots[0];                             \
>               memslot < slots->memslots + slots->used_slots; memslot++)  \
>                  if (WARN_ON_ONCE(!memslot->npages)) {                   \
>                  } else
> 
> Unless I'm missing something, this goes all the way back to initial arm64 support
> added by commit d5d8184d35c9 ("KVM: ARM: Memory virtualization setup").
> 

The fixes tag was sorted out based on 'git-bisect', not static code analysis. I
agree it should be d5d8184d35c9 ("KVM: ARM: Memory virtualization setup") from
the code. From the 'git-bisect', we found the issue disappears when the head is
commit 3039bcc74498 ("KVM: Move x86's MMU notifier memslot walkers to generic code").
And yes, the fixes tag should be cd4c71835228 ("KVM: arm64: Convert to the gfn-based
MMU notifier callbacks").

I'm declined to fix the issue only for ARM64, more details are given below. If we're
going to limit the issue to ARM64 and fix it for ARM64 only, the fixes tag should be
the one as you pointed. Lets correct it in next revision with:

   Cc: stable@vger.kernel.org # v3.9+
   Fixes: d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")

>> Reported-by: Shuai Hu <hshuai@redhat.com>
>> Reported-by: Zhenyu Zhang <zhenyzha@redhat.com>
>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>> ---
>>   virt/kvm/kvm_main.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 479802a892d4..7f81a3a209b6 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -598,6 +598,9 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
>>   			unsigned long hva_start, hva_end;
>>   
>>   			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
>> +			if (slot->flags & KVM_MEMSLOT_INVALID)
>> +				continue;
> 
> Skipping the memslot will lead to use-after-free.  E.g. if an invalidate_range_start()
> comes along between installing the invalid slot and zapping SPTEs, KVM will
> return from kvm_mmu_notifier_invalidate_range_start() without having dropped all
> references to the range.
> 
> I.e.
> 
> 	kvm_copy_memslot(invalid_slot, old);
> 	invalid_slot->flags |= KVM_MEMSLOT_INVALID;
> 	kvm_replace_memslot(kvm, old, invalid_slot);
> 
> 	/*
> 	 * Activate the slot that is now marked INVALID, but don't propagate
> 	 * the slot to the now inactive slots. The slot is either going to be
> 	 * deleted or recreated as a new slot.
> 	 */
> 	kvm_swap_active_memslots(kvm, old->as_id);
> 
> 
> ==> invalidate_range_start()
> 
> 	/*
> 	 * From this point no new shadow pages pointing to a deleted, or moved,
> 	 * memslot will be created.  Validation of sp->gfn happens in:
> 	 *	- gfn_to_hva (kvm_read_guest, gfn_to_pfn)
> 	 *	- kvm_is_visible_gfn (mmu_check_root)
> 	 */
> 	kvm_arch_flush_shadow_memslot(kvm, old);
> 
> And even for change_pte(), skipping the memslot is wrong, as KVM would then fail
> unmap the prior SPTE.  Of course, that can't happen in the current code base
> because change_pte() is wrapped with invalidate_range_{start,end}(), but that's
> more of a bug than a design choice (see c13fda237f08 "KVM: Assert that notifier
> count is elevated in .change_pte()" for details).  That's also why this doesn't
> show up on x86; x86 installs a SPTE for the change_pte() notifier iff an existing
> SPTE is present, which is never true due to the invalidation.
> 

Right, those architectural dependencies are really something I worried about.
It's safe to skip the invalid memory slots for ARM64, but it may be unsafe to
do so for other architectures. You've listed the potential risks to do so for
x86. It might be risky with PowerPC's reverse mapping stuff either. I didn't
look into the code for the left architectures. In order to escape from the
architectural conflicts, I would move the check and skip the invalid memory
slot in arch/arm64/kvm/mmu.c::kvm_set_spte_gfn(), something like below. In
this way, the guest hang issue in ARM64 guest is fixed. We may have similar
issue on other architectures, but we can figure out the fix when we have to.
Sean, please let me know if you're happy with this?

arch/arm64/kvm/mmu.c::kvm_set_spte_gfn()
----------------------------------------

bool kvm_set_spte_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
{
         kvm_pfn_t pfn = pte_pfn(range->pte);

         if (!kvm->arch.mmu.pgt)
                 return false;

         /*
          * The memory slot can become invalid temporarily or permanently
          * when it's being moved or deleted. Avoid the stage2 mapping so
          * that all the read and write requests to the region of the memory
          * slot can be forwarded to VMM and emulated there.
          */
          if (range->slot->flags & KVM_MEMSLOT_INVALID)
              return false;

          WARN_ON(range->end - range->start != 1);

          :
}

> I'd honestly love to just delete the change_pte() callback, but my opinion is more
> than a bit biased since we don't use KSM.  Assuming we keep change_pte(), the best
> option is probably to provide a wrapper around kvm_set_spte_gfn() to skip the
> memslot, but with a sanity check and comment explaining the dependency on there
> being no SPTEs due to the invalidation.  E.g.
> 

It's good idea, but I'm afraid other architectures like PowerPC will still be
affected. So I would like to limit this issue to ARM64 and fix it in its
kvm_set_spte_gfn() variant, as above. One question about "we don't use KSM":
could you please share more information about this? I'm blindly guessing you're
saying KSM isn't used in google cloud?

[...]

Thanks,
Gavin

