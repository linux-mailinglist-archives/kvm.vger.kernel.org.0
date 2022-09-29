Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B165EF2AE
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 11:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbiI2Juq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 05:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235055AbiI2Jub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 05:50:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3904F3F33F
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 02:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664445029;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+dNLXcSvFDZXpBKIjAw/C/YuRDnqa0+D0ZtCUfC0HwY=;
        b=DKL2RVX1uD3qD07fUiQh94fWD8rZ/FxTVfo403KRiDtpXfb8sJtHrPNadH1DEGEzoIW3ON
        66xJr+uPmjdbN9Y6SXAUV7I8naSmbsADV+kt1iRFayP3dyjWp/TJ7IipdazVpMwNXyLJlc
        PDVXBtJ2S28z0HWgA3k8dCjUqgorR8Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-FUfO9rtCOoKZIZaJKvl4Lw-1; Thu, 29 Sep 2022 05:50:23 -0400
X-MC-Unique: FUfO9rtCOoKZIZaJKvl4Lw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73F9A293248B;
        Thu, 29 Sep 2022 09:50:22 +0000 (UTC)
Received: from [10.64.54.143] (vpn2-54-143.bne.redhat.com [10.64.54.143])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 011A039D7C;
        Thu, 29 Sep 2022 09:50:14 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory
 tracking
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
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <d0beb9bd-5295-adb6-a473-c131d6102947@redhat.com>
Date:   Thu, 29 Sep 2022 19:50:12 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YzRfkBWepX2CD88h@x1n>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc and Peter,

On 9/29/22 12:52 AM, Peter Xu wrote:
> On Wed, Sep 28, 2022 at 09:25:34AM +0100, Marc Zyngier wrote:
>> On Wed, 28 Sep 2022 00:47:43 +0100,
>> Gavin Shan <gshan@redhat.com> wrote:
>>
>>> I have rough idea as below. It's appreciated if you can comment before I'm
>>> going a head for the prototype. The overall idea is to introduce another
>>> dirty ring for KVM (kvm-dirty-ring). It's updated and visited separately
>>> to dirty ring for vcpu (vcpu-dirty-ring).
>>>
>>>     - When the various VGIC/ITS table base addresses are specified, kvm-dirty-ring
>>>       entries are added to mark those pages as 'always-dirty'. In mark_page_dirty_in_slot(),
>>>       those 'always-dirty' pages will be skipped, no entries pushed to vcpu-dirty-ring.
>>>
>>>     - Similar to vcpu-dirty-ring, kvm-dirty-ring is accessed from userspace through
>>>       mmap(kvm->fd). However, there won't have similar reset interface. It means
>>>       'struct kvm_dirty_gfn::flags' won't track any information as we do for
>>>       vcpu-dirty-ring. In this regard, kvm-dirty-ring is purely shared buffer to
>>>       advertise 'always-dirty' pages from host to userspace.
>>>          - For QEMU, shutdown/suspend/resume cases won't be concerning
>>> us any more. The
>>>       only concerned case is migration. When the migration is about to complete,
>>>       kvm-dirty-ring entries are fetched and the dirty bits are updated to global
>>>       dirty page bitmap and RAMBlock's dirty page bitmap. For this, I'm still reading
>>>       the code to find the best spot to do it.
>>
>> I think it makes a lot of sense to have a way to log writes that are
>> not generated by a vpcu, such as the GIC and maybe other things in the
>> future, such as DMA traffic (some SMMUs are able to track dirty pages
>> as well).
>>
>> However, I don't really see the point in inventing a new mechanism for
>> that. Why don't we simply allow non-vpcu dirty pages to be tracked in
>> the dirty *bitmap*?
>>
>>  From a kernel perspective, this is dead easy:
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 5b064dbadaf4..ae9138f29d51 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -3305,7 +3305,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>   	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
>>   
>>   #ifdef CONFIG_HAVE_KVM_DIRTY_RING
>> -	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
>> +	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
>>   		return;
>>   #endif
>>   
>> @@ -3313,10 +3313,11 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
>>   		unsigned long rel_gfn = gfn - memslot->base_gfn;
>>   		u32 slot = (memslot->as_id << 16) | memslot->id;
>>   
>> -		if (kvm->dirty_ring_size)
>> +		if (vpcu && kvm->dirty_ring_size)
>>   			kvm_dirty_ring_push(&vcpu->dirty_ring,
>>   					    slot, rel_gfn);
>> -		else
>> +		/* non-vpcu dirtying ends up in the global bitmap */
>> +		if (!vcpu && memslot->dirty_bitmap)
>>   			set_bit_le(rel_gfn, memslot->dirty_bitmap);
>>   	}
>>   }
>>
>> though I'm sure there is a few more things to it.
> 
> Yes, currently the bitmaps are not created when rings are enabled.
> kvm_prepare_memory_region() has:
> 
> 		else if (!kvm->dirty_ring_size) {
> 			r = kvm_alloc_dirty_bitmap(new);
> 
> But I think maybe that's a solution worth considering.  Using the rings
> have a major challenge on the limitation of ring size, so that for e.g. an
> ioctl we need to make sure the pages to dirty within an ioctl procedure
> will not be more than the ring can take.  Using dirty bitmap for a last
> phase sync of constant (but still very small amount of) dirty pages does
> sound reasonable and can avoid that complexity.  The payoff is we'll need
> to allocate both the rings and the bitmaps.
> 

Ok. I was thinking of using the bitmap to convey the dirty pages for
this particular case, where we don't have running vcpu. The concern I had
is the natural difference between a ring and bitmap. The ring-buffer is
discrete, comparing to bitmap. Besides, it sounds a little strange to
have two different sets of meta-data to track the data (dirty pages).

However, bitmap is easier way than per-vm ring. The constrains with
per-vm ring is just as Peter pointed. So lets reuse the bitmap to
convey the dirty pages for this particular case. I think the payoff,
extra bitmap, is acceptable. For this, we need another capability
(KVM_CAP_DIRTY_LOG_RING_BITMAP?) so that QEMU can collects the dirty
bitmap in the last phase of migration.

If all of us agree on this, I can send another kernel patch to address
this. QEMU still need more patches so that the feature can be supported.

>>
>> To me, this is just a relaxation of an arbitrary limitation, as the
>> current assumption that only vcpus can dirty memory doesn't hold at
>> all.
> 
> The initial dirty ring proposal has a per-vm ring, but after we
> investigated x86 we found that all legal dirty paths are with a vcpu
> context (except one outlier on kvmgt which fixed within itself), so we
> dropped the per-vm ring.
> 
> One thing to mention is that DMAs should not count in this case because
> that's from device perspective, IOW either IOMMU or SMMU dirty tracking
> should be reported to the device driver that interacts with the userspace
> not from KVM interfaces (e.g. vfio with VFIO_IOMMU_DIRTY_PAGES).  That even
> includes emulated DMA like vhost (VHOST_SET_LOG_BASE).
> 

Thanks to Peter for mentioning the per-vm ring's history. As I said above,
lets use bitmap instead if all of us agree.

If I'm correct, Marc may be talking about SMMU, which is emulated in host
instead of QEMU. In this case, the DMA target pages are similar to those
pages for vgic/its tables. Both sets of pages are invisible from QEMU.

Thanks,
Gavin

