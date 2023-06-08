Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BBA728BA6
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 01:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbjFHXSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 19:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjFHXSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 19:18:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D85E62
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 16:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686266264;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xyxzeABtDpUjd4aUorGFVDH/JAIOf/41ofdKx6mHfbc=;
        b=BX6qLev2hqplNKBkZTC3b4R0fg3hIb51cUtX/ptRjH8RojS23vTIMNnRaE24tUFPkgm+fe
        Y5gGnJDsX51ukwoPyhicn2JvYWGJSJvxPYJMcVGxuEa/PWAp1JOy+w60mMj/gfp7xS6kDe
        Nq9oUfdkosMSKjmRsUreDEmtSxoeDl0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-75kja7RTMBGyRdF6lzT-ow-1; Thu, 08 Jun 2023 19:17:42 -0400
X-MC-Unique: 75kja7RTMBGyRdF6lzT-ow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C59EA2A59544;
        Thu,  8 Jun 2023 23:17:41 +0000 (UTC)
Received: from [10.64.54.168] (vpn2-54-168.bne.redhat.com [10.64.54.168])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 126FC2166B25;
        Thu,  8 Jun 2023 23:17:37 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] KVM: Avoid illegal stage2 mapping on invalid memory slot
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        seanjc@google.com, oliver.upton@linux.dev, hshuai@redhat.com,
        zhenyzha@redhat.com, shan.gavin@gmail.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>
References: <20230608090348.414990-1-gshan@redhat.com>
 <87bkhqnhzm.wl-maz@kernel.org>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <695fe5a2-a295-4105-b31b-4cc92b089659@redhat.com>
Date:   Fri, 9 Jun 2023 09:17:34 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87bkhqnhzm.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
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

Hi Marc,

[Cc Andrea/David/Peter Xu]

On 6/9/23 12:31 AM, Marc Zyngier wrote:
> On Thu, 08 Jun 2023 10:03:48 +0100,
> Gavin Shan <gshan@redhat.com> wrote:
>>
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
> 
> Huh, nice one :-(.
> 

Yeah, it's a sneaky one :)

>>
>> Cc: stable@vger.kernel.org # v5.13+
>> Fixes: 3039bcc74498 ("KVM: Move x86's MMU notifier memslot walkers to generic code")
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
>> +
>>   			hva_start = max(range->start, slot->userspace_addr);
>>   			hva_end = min(range->end, slot->userspace_addr +
>>   						  (slot->npages << PAGE_SHIFT));
> 
> I don't immediately see what makes it safer. If we're not holding one
> of slots_{,arch_}lock in the notifier, we can still race against the
> update, can't we?  I don't think holding the srcu lock helps us here.
> 

The dead-lock will be triggered if we're holding @slots_lock in
__kvm_handle_hva_range() when we have call site like below. There is
similar reason why we can't hold @slots_arch_lock in the function.

   CPU-A                                CPU-B
   -----                                ------
   invalidate_range_start()
     kvm->mn_active_invalidate_count++
     __kvm_handle_hva_range
                                        ioctl(kvm, KVM_SET_USER_MEMORY_REGION)   // Delete
                                        kvm_vm_ioctl_set_memory_region
                                        mutex_lock(&kvm->slots_lock);
                                        __kvm_set_memory_region
                                          kvm_set_memslot(..., KVM_MR_DELETE)
                                            kvm_invalidate_memslot
                                              kvm_replace_memslot
                                              kvm_swap_active_memslots          // infinite wait until
                                        mutex_unlock(&kvm->slots_lock);         // kvm->mn_active_invalidate_count is 0
   invalidate_range_end
     __kvm_handle_hva_range
       mutex_lock(&kvm->slots_lock);   // lock taken by CPU-B
       mutex_unlock(&kvm->slots_lock);
     --kvm->mn_active_invalidate_count

change_pte() is always surrounded by invalidate_range_start and
invalidate_range_end(). It means kvm->mn_active_invalidate_count is always
larger than zero when change_pte() is called. With this condition
(kvm->mn_active_invalidate_count > 0), The swapping between the inactive
and active memory slots by kvm_swap_active_memslots() can't be done.
So there are two cases for one memory slot when change_pte() is called:
(a) it has been marked as KVM_MEMSLOT_INVALID in the active memory slots
by kvm_invalidate_memslot(), called before invalidate_range_start();
(b) the memory slot has been deleted from the active memory slots. We're
only concerned by (a) when the active memory slots are iterated in
__kvm_handle_hva_range().

static void kvm_mmu_notifier_change_pte(...)
{
         :
         /*
          * .change_pte() must be surrounded by .invalidate_range_{start,end}().
          * If mmu_invalidate_in_progress is zero, then no in-progress
          * invalidations, including this one, found a relevant memslot at
          * start(); rechecking memslots here is unnecessary.  Note, a false
          * positive (count elevated by a different invalidation) is sub-optimal
          * but functionally ok.
          */
         WARN_ON_ONCE(!READ_ONCE(kvm->mn_active_invalidate_count));
         if (!READ_ONCE(kvm->mmu_invalidate_in_progress))
                 return;
         :
}


The srcu lock in __kvm_handle_hva_range() prevents the swapping of
the active and inactive memory slots by kvm_swap_active_memslots(). For
this particular case, it's not relevant because the swapping between
the inactive and active memory slots has been done for once, before
invalidate_range_start() is called.

Thanks,
Gavin

