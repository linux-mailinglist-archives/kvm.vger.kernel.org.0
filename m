Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4075E704F
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 01:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiIVXrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 19:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiIVXrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 19:47:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE51EEBBFA
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663890430;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JNeVq+wGsryjN6c4r6dUHWC2q43V8h7EZ89EqqZp5hk=;
        b=b9MmXxFl5/m4sywDCQ5tfZM1BzfzBMi69MJQ6AIDOqu5hjfmR2LrYa5LXmdPikcb4fAr4z
        G2UUwh2H5ZJYkpX9CNMlCdslwO8DHue7iDH96O1gJIqntF0VKFPU/pXzBTAM4h9/nc2Ayg
        Z8LxdhfKxH/Wmhcg34CcBXeA6FQCOhI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-172-lOs1RUxLNIaFO_ztvXyOdQ-1; Thu, 22 Sep 2022 19:47:07 -0400
X-MC-Unique: lOs1RUxLNIaFO_ztvXyOdQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E94A23C0D1A6;
        Thu, 22 Sep 2022 23:47:06 +0000 (UTC)
Received: from [10.64.54.126] (vpn2-54-126.bne.redhat.com [10.64.54.126])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2EF940C6EC2;
        Thu, 22 Sep 2022 23:47:00 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 1/6] KVM: Use acquire/release semantics when accessing
 dirty ring GFN state
To:     Peter Xu <peterx@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>
References: <20220922170133.2617189-1-maz@kernel.org>
 <20220922170133.2617189-2-maz@kernel.org> <YyzV2Q/PZHPFMD6y@xz-m1.local>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <e8ddf130-c5e1-d872-c7c8-675d40742b1e@redhat.com>
Date:   Fri, 23 Sep 2022 09:46:58 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YyzV2Q/PZHPFMD6y@xz-m1.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 9/23/22 7:38 AM, Peter Xu wrote:
> On Thu, Sep 22, 2022 at 06:01:28PM +0100, Marc Zyngier wrote:
>> The current implementation of the dirty ring has an implicit requirement
>> that stores to the dirty ring from userspace must be:
>>
>> - be ordered with one another
>>
>> - visible from another CPU executing a ring reset
>>
>> While these implicit requirements work well for x86 (and any other
>> TSO-like architecture), they do not work for more relaxed architectures
>> such as arm64 where stores to different addresses can be freely
>> reordered, and loads from these addresses not observing writes from
>> another CPU unless the required barriers (or acquire/release semantics)
>> are used.
>>
>> In order to start fixing this, upgrade the ring reset accesses:
>>
>> - the kvm_dirty_gfn_harvested() helper now uses acquire semantics
>>    so it is ordered after all previous writes, including that from
>>    userspace
>>
>> - the kvm_dirty_gfn_set_invalid() helper now uses release semantics
>>    so that the next_slot and next_offset reads don't drift past
>>    the entry invalidation
>>
>> This is only a partial fix as the userspace side also need upgrading.
> 
> Paolo has one fix 4802bf910e ("KVM: dirty ring: add missing memory
> barrier", 2022-09-01) which has already landed.
> 
> I think the other one to reset it was lost too.  I just posted a patch.
> 
> https://lore.kernel.org/qemu-devel/20220922213522.68861-1-peterx@redhat.com/
> (link still not yet available so far, but should be)
> 
>>
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   virt/kvm/dirty_ring.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
>> index f4c2a6eb1666..784bed80221d 100644
>> --- a/virt/kvm/dirty_ring.c
>> +++ b/virt/kvm/dirty_ring.c
>> @@ -79,12 +79,12 @@ static inline void kvm_dirty_gfn_set_invalid(struct kvm_dirty_gfn *gfn)
>>   
>>   static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
>>   {
>> -	gfn->flags = KVM_DIRTY_GFN_F_DIRTY;
>> +	smp_store_release(&gfn->flags, KVM_DIRTY_GFN_F_DIRTY);
> 
> IIUC you meant kvm_dirty_gfn_set_invalid as the comment says?
> 
> kvm_dirty_gfn_set_dirtied() has been guarded by smp_wmb() and AFAICT that's
> already safe.  Otherwise looks good to me.
> 

If I'm understanding the full context, smp_store_release() also enforces
guard on 'gfn->flags' itself. It is needed by user space for the synchronization.

>>   }
>>   
>>   static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
>>   {
>> -	return gfn->flags & KVM_DIRTY_GFN_F_RESET;
>> +	return smp_load_acquire(&gfn->flags) & KVM_DIRTY_GFN_F_RESET;
>>   }
>>   
>>   int kvm_dirty_ring_reset(struct kvm *kvm, struct kvm_dirty_ring *ring)
>> -- 
>> 2.34.1
>>

Thanks,
Gavin

