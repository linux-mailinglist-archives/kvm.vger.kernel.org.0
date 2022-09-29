Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A6F5EF455
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 13:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbiI2Lbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 07:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235294AbiI2Lbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 07:31:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1F913C873
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 04:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664451108;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEKfUYSB+7V62VJkV4AjzMMtYng+NhW8XBng+EdVuoU=;
        b=QOwI4A0DkhB8wuPpPhUt6z/hpY3ud/DPZ0C5/KkeIwoSxT3D2q2SrzhBfRE1Tey1N8fLWB
        xihxbzv8GzTigMWXViaqhRY6RinGp4Y3e+pUGR4l8ACJAo5CDANkf9irocmfGwZfeo8VVk
        VleWcWz2/1pSy0RjE20ERuNvmBl66iI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-nLrVoXaQOaWQY-yLIcflHQ-1; Thu, 29 Sep 2022 07:31:44 -0400
X-MC-Unique: nLrVoXaQOaWQY-yLIcflHQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71171185A7A4;
        Thu, 29 Sep 2022 11:31:43 +0000 (UTC)
Received: from [10.64.54.143] (vpn2-54-143.bne.redhat.com [10.64.54.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 12E2340C6EC2;
        Thu, 29 Sep 2022 11:31:36 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory
 tracking
From:   Gavin Shan <gshan@redhat.com>
To:     Peter Xu <peterx@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        catalin.marinas@arm.com, bgardon@google.com, shuah@kernel.org,
        andrew.jones@linux.dev, will@kernel.org, dmatlack@google.com,
        pbonzini@redhat.com, zhenyzha@redhat.com, shan.gavin@gmail.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-4-gshan@redhat.com> <YzMerD8ZvhvnprEN@x1n>
 <86sfkc7mg8.wl-maz@kernel.org> <YzM/DFV1TgtyRfCA@x1n>
 <320005d1-fe88-fd6a-be91-ddb56f1aa80f@redhat.com>
 <87y1u3hpmp.wl-maz@kernel.org> <YzRfkBWepX2CD88h@x1n>
 <d0beb9bd-5295-adb6-a473-c131d6102947@redhat.com>
Message-ID: <ddc4166c-81b6-2f7b-87a7-4af3d7db888a@redhat.com>
Date:   Thu, 29 Sep 2022 21:31:34 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <d0beb9bd-5295-adb6-a473-c131d6102947@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter and Marc,

On 9/29/22 7:50 PM, Gavin Shan wrote:
> On 9/29/22 12:52 AM, Peter Xu wrote:
>> On Wed, Sep 28, 2022 at 09:25:34AM +0100, Marc Zyngier wrote:
>>> On Wed, 28 Sep 2022 00:47:43 +0100,
>>> Gavin Shan <gshan@redhat.com> wrote:
>>>
>>>> I have rough idea as below. It's appreciated if you can comment before I'm
>>>> going a head for the prototype. The overall idea is to introduce another
>>>> dirty ring for KVM (kvm-dirty-ring). It's updated and visited separately
>>>> to dirty ring for vcpu (vcpu-dirty-ring).
>>>>
>>>>     - When the various VGIC/ITS table base addresses are specified, kvm-dirty-ring
>>>>       entries are added to mark those pages as 'always-dirty'. In mark_page_dirty_in_slot(),
>>>>       those 'always-dirty' pages will be skipped, no entries pushed to vcpu-dirty-ring.
>>>>
>>>>     - Similar to vcpu-dirty-ring, kvm-dirty-ring is accessed from userspace through
>>>>       mmap(kvm->fd). However, there won't have similar reset interface. It means
>>>>       'struct kvm_dirty_gfn::flags' won't track any information as we do for
>>>>       vcpu-dirty-ring. In this regard, kvm-dirty-ring is purely shared buffer to
>>>>       advertise 'always-dirty' pages from host to userspace.
>>>>          - For QEMU, shutdown/suspend/resume cases won't be concerning
>>>> us any more. The
>>>>       only concerned case is migration. When the migration is about to complete,
>>>>       kvm-dirty-ring entries are fetched and the dirty bits are updated to global
>>>>       dirty page bitmap and RAMBlock's dirty page bitmap. For this, I'm still reading
>>>>       the code to find the best spot to do it.
>>>
>>> I think it makes a lot of sense to have a way to log writes that are
>>> not generated by a vpcu, such as the GIC and maybe other things in the
>>> future, such as DMA traffic (some SMMUs are able to track dirty pages
>>> as well).
>>>
>>> However, I don't really see the point in inventing a new mechanism for
>>> that. Why don't we simply allow non-vpcu dirty pages to be tracked in
>>> the dirty *bitmap*?
>>>
>>>  From a kernel perspective, this is dead easy:
>>>
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index 5b064dbadaf4..ae9138f29d51 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -3305,7 +3305,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>>       struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>>>   #ifdef CONFIG_HAVE_KVM_DIRTY_RING
>>> -    if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>>> +    if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
>>>           return;
>>>   #endif
>>> @@ -3313,10 +3313,11 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>>           unsigned long rel_gfn = gfn - memslot->base_gfn;
>>>           u32 slot = (memslot->as_id << 16) | memslot->id;
>>> -        if (kvm->dirty_ring_size)
>>> +        if (vpcu && kvm->dirty_ring_size)
>>>               kvm_dirty_ring_push(&vcpu->dirty_ring,
>>>                           slot, rel_gfn);
>>> -        else
>>> +        /* non-vpcu dirtying ends up in the global bitmap */
>>> +        if (!vcpu && memslot->dirty_bitmap)
>>>               set_bit_le(rel_gfn, memslot->dirty_bitmap);
>>>       }
>>>   }
>>>
>>> though I'm sure there is a few more things to it.
>>
>> Yes, currently the bitmaps are not created when rings are enabled.
>> kvm_prepare_memory_region() has:
>>
>>         else if (!kvm->dirty_ring_size) {
>>             r = kvm_alloc_dirty_bitmap(new);
>>
>> But I think maybe that's a solution worth considering.  Using the rings
>> have a major challenge on the limitation of ring size, so that for e.g. an
>> ioctl we need to make sure the pages to dirty within an ioctl procedure
>> will not be more than the ring can take.  Using dirty bitmap for a last
>> phase sync of constant (but still very small amount of) dirty pages does
>> sound reasonable and can avoid that complexity.  The payoff is we'll need
>> to allocate both the rings and the bitmaps.
>>
> 
> Ok. I was thinking of using the bitmap to convey the dirty pages for
> this particular case, where we don't have running vcpu. The concern I had
> is the natural difference between a ring and bitmap. The ring-buffer is
> discrete, comparing to bitmap. Besides, it sounds a little strange to
> have two different sets of meta-data to track the data (dirty pages).
> 
> However, bitmap is easier way than per-vm ring. The constrains with
> per-vm ring is just as Peter pointed. So lets reuse the bitmap to
> convey the dirty pages for this particular case. I think the payoff,
> extra bitmap, is acceptable. For this, we need another capability
> (KVM_CAP_DIRTY_LOG_RING_BITMAP?) so that QEMU can collects the dirty
> bitmap in the last phase of migration.
> 
> If all of us agree on this, I can send another kernel patch to address
> this. QEMU still need more patches so that the feature can be supported.
> 

I've had the following PATCH[v5 3/7] to reuse bitmap for these particular
cases. KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG ioctls are used to visit
the bitmap. The new capability is advertised by KVM_CAP_DIRTY_LOG_RING_BITMAP.
Note those two ioctls are disabled when dirty-ring is enabled, we need to
enable them accordingly.

    PATCH[v5 3/7] KVM: x86: Use bitmap in ring-based dirty page tracking

I would like to post v5 after someone reviews or acks kvm/selftests part
of this series.

[...]

Thanks,
Gavin

