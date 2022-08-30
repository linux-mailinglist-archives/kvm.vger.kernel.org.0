Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE275A6147
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 13:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbiH3LAF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 07:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiH3K74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 06:59:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB761CD4
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 03:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661857191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6zYu4Rswu3fgZ8KgLqAlhfqI/MTWsVxlsGOUdPxztzk=;
        b=IsnZn+TVdrRiQ+wr9++82xemCjofNPxit9R0tdYFSYd/VoKltjOZ6o4bJ0bYgHyHSi7Lw5
        wQS4JW/NUkgvyn7rVpwlCoH38157LkNFDYR75Z2YiDqrZixwQlDWvUxQYeX97MH5UrH87R
        UwRMSfwH8IjR3loh0ULsjvr/RWRUTTo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-412-JHe-PuOhNiqG_pb75xFM5Q-1; Tue, 30 Aug 2022 06:59:50 -0400
X-MC-Unique: JHe-PuOhNiqG_pb75xFM5Q-1
Received: by mail-wm1-f70.google.com with SMTP id p19-20020a05600c1d9300b003a5c3141365so9902136wms.9
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 03:59:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=6zYu4Rswu3fgZ8KgLqAlhfqI/MTWsVxlsGOUdPxztzk=;
        b=eh0erub4g6ISAPd2hH0uwkX9acKZTkJlFpdPzHyofVvFwVIxJZAHmXF0bqZbQU8kTx
         yhkh7N44sCHMXN50PLKAPzQyx0ItaNsALtWiTFs/ckkSpEEGpvhzsGh3eXn9iB49Qlh8
         IQTXndHR7fvIp2GosBwT+kx/YUFc9xr+MZt5/ub/LdWGnXQeVsLxHRF6V+a4L/hJzoTr
         KBLXNEHa6B4hFYqKsxC1BTcwN3pMUO4H87CI+ANeNAYFKPJWJ7/yOTmy4Ts8n4BiDJWz
         x70nWCKwkffL47kCmFFaLo53an/DVcQT+oxuVyw2DW6ip+b1SEOXpofCkixF02yCYEKt
         5rKg==
X-Gm-Message-State: ACgBeo0HH2Tva7IOSfqJHKTuydMIwVDkmYY6i4Ko4aYeA35mTwlP2KXA
        uKDf+OFe7bn5egQUiEn0pcufFPtRnrvTLFeU9W+CYaWEVmZx3S1FO2e2BWsEt9yVCaeKawXS0mM
        MHuRVXa96fKi+
X-Received: by 2002:a5d:6e8e:0:b0:220:5fa1:d508 with SMTP id k14-20020a5d6e8e000000b002205fa1d508mr9202666wrz.337.1661857189307;
        Tue, 30 Aug 2022 03:59:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5lGsBox+69uaFFHcIdly3TYMqybdSHUIVTFKVN7rX9IGVZwxq/KmA65ehoeZ3QPWeXU7uIGQ==
X-Received: by 2002:a5d:6e8e:0:b0:220:5fa1:d508 with SMTP id k14-20020a5d6e8e000000b002205fa1d508mr9202649wrz.337.1661857188931;
        Tue, 30 Aug 2022 03:59:48 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:1000:ecb4:919b:e3d3:e20b? (p200300cbc70a1000ecb4919be3d3e20b.dip0.t-ipconnect.de. [2003:cb:c70a:1000:ecb4:919b:e3d3:e20b])
        by smtp.gmail.com with ESMTPSA id j9-20020a05600c190900b003a2e92edeccsm13792728wmq.46.2022.08.30.03.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 03:59:48 -0700 (PDT)
Message-ID: <d02d6a6e-637e-48f9-9acc-811344712cd3@redhat.com>
Date:   Tue, 30 Aug 2022 12:59:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>
Cc:     Leonardo Bras Soares Passos <lsoaresp@redhat.com>,
        qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com> <Yv6baJoNikyuZ38R@xz-m1.local>
 <CAJ6HWG6maoPjbP8T5qo=iXCbNeHu4dq3wHLKtRLahYKuJmMY-g@mail.gmail.com>
 <YwOOcC72KKABKgU+@xz-m1.local>
 <d4601180-4c95-a952-2b40-d40fa8e55005@redhat.com>
 <YwqFfyZ1fMA9knnK@xz-m1.local>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay kvm_vm_ioctl
 to the commit phase
In-Reply-To: <YwqFfyZ1fMA9knnK@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.08.22 22:58, Peter Xu wrote:
> Hi, Emanuele,
> 
> On Fri, Aug 26, 2022 at 04:07:01PM +0200, Emanuele Giuseppe Esposito wrote:
>>
>>
>> Am 22/08/2022 um 16:10 schrieb Peter Xu:
>>> On Thu, Aug 18, 2022 at 09:55:20PM -0300, Leonardo Bras Soares Passos wrote:
>>>> On Thu, Aug 18, 2022 at 5:05 PM Peter Xu <peterx@redhat.com> wrote:
>>>>>
>>>>> On Tue, Aug 16, 2022 at 06:12:50AM -0400, Emanuele Giuseppe Esposito wrote:
>>>>>> +static void kvm_memory_region_node_add(KVMMemoryListener *kml,
>>>>>> +                                       struct kvm_userspace_memory_region *mem)
>>>>>> +{
>>>>>> +    MemoryRegionNode *node;
>>>>>> +
>>>>>> +    node = g_malloc(sizeof(MemoryRegionNode));
>>>>>> +    *node = (MemoryRegionNode) {
>>>>>> +        .mem = mem,
>>>>>> +    };
>>>>>
>>>>> Nit: direct assignment of struct looks okay, but maybe pointer assignment
>>>>> is clearer (with g_malloc0?  Or iirc we're suggested to always use g_new0):
>>>>>
>>>>>   node = g_new0(MemoryRegionNode, 1);
>>>>>   node->mem = mem;
>>>>>
>>>>> [...]
>>
>> Makes sense
>>
>>>>>
>>>>>> +/* for KVM_SET_USER_MEMORY_REGION_LIST */
>>>>>> +struct kvm_userspace_memory_region_list {
>>>>>> +     __u32 nent;
>>>>>> +     __u32 flags;
>>>>>> +     struct kvm_userspace_memory_region entries[0];
>>>>>> +};
>>>>>> +
>>>>>>  /*
>>>>>>   * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
>>>>>>   * other bits are reserved for kvm internal use which are defined in
>>>>>> @@ -1426,6 +1433,8 @@ struct kvm_vfio_spapr_tce {
>>>>>>                                       struct kvm_userspace_memory_region)
>>>>>>  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
>>>>>>  #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
>>>>>> +#define KVM_SET_USER_MEMORY_REGION_LIST _IOW(KVMIO, 0x49, \
>>>>>> +                                     struct kvm_userspace_memory_region_list)
>>>>>
>>>>> I think this is probably good enough, but just to provide the other small
>>>>> (but may not be important) piece of puzzle here.  I wanted to think through
>>>>> to understand better but I never did..
>>>>>
>>>>> For a quick look, please read the comment in kvm_set_phys_mem().
>>>>>
>>>>>                 /*
>>>>>                  * NOTE: We should be aware of the fact that here we're only
>>>>>                  * doing a best effort to sync dirty bits.  No matter whether
>>>>>                  * we're using dirty log or dirty ring, we ignored two facts:
>>>>>                  *
>>>>>                  * (1) dirty bits can reside in hardware buffers (PML)
>>>>>                  *
>>>>>                  * (2) after we collected dirty bits here, pages can be dirtied
>>>>>                  * again before we do the final KVM_SET_USER_MEMORY_REGION to
>>>>>                  * remove the slot.
>>>>>                  *
>>>>>                  * Not easy.  Let's cross the fingers until it's fixed.
>>>>>                  */
>>>>>
>>>>> One example is if we have 16G mem, we enable dirty tracking and we punch a
>>>>> hole of 1G at offset 1G, it'll change from this:
>>>>>
>>>>>                      (a)
>>>>>   |----------------- 16G -------------------|
>>>>>
>>>>> To this:
>>>>>
>>>>>      (b)    (c)              (d)
>>>>>   |--1G--|XXXXXX|------------14G------------|
>>>>>
>>>>> Here (c) will be a 1G hole.
>>>>>
>>>>> With current code, the hole punching will del region (a) and add back
>>>>> region (b) and (d).  After the new _LIST ioctl it'll be atomic and nicer.
>>>>>
>>>>> Here the question is if we're with dirty tracking it means for each region
>>>>> we have a dirty bitmap.  Currently we do the best effort of doing below
>>>>> sequence:
>>>>>
>>>>>   (1) fetching dirty bmap of (a)
>>>>>   (2) delete region (a)
>>>>>   (3) add region (b) (d)
>>>>>
>>>>> Here (a)'s dirty bmap is mostly kept as best effort, but still we'll lose
>>>>> dirty pages written between step (1) and (2) (and actually if the write
>>>>> comes within (2) and (3) I think it'll crash qemu, and iiuc that's what
>>>>> we're going to fix..).
>>>>>
>>>>> So ideally the atomic op can be:
>>>>>
>>>>>   "atomically fetch dirty bmap for removed regions, remove regions, and add
>>>>>    new regions"
>>>>>
>>>>> Rather than only:
>>>>>
>>>>>   "atomically remove regions, and add new regions"
>>>>>
>>>>> as what the new _LIST ioctl do.
>>>>>
>>>>> But... maybe that's not a real problem, at least I didn't know any report
>>>>> showing issue with current code yet caused by losing of dirty bits during
>>>>> step (1) and (2).  Neither do I know how to trigger an issue with it.
>>>>>
>>>>> I'm just trying to still provide this information so that you should be
>>>>> aware of this problem too, at the meantime when proposing the new ioctl
>>>>> change for qemu we should also keep in mind that we won't easily lose the
>>>>> dirty bmap of (a) here, which I think this patch does the right thing.
>>>>>
>>>>
>>>> Thanks for bringing these details Peter!
>>>>
>>>> What do you think of adding?
>>>> (4) Copy the corresponding part of (a)'s dirty bitmap to (b) and (d)'s
>>>> dirty bitmaps.
>>>
>>> Sounds good to me, but may not cover dirty ring?  Maybe we could move on
>>> with the simple but clean scheme first and think about a comprehensive
>>> option only if very necessary.  The worst case is we need one more kvm cap
>>> but we should still have enough.
>>
>> Ok then, I will not consider this for now.
>>
>> Might or might not be relevant, but I was also considering to
>> pre-process the list of memslots passed to the ioctl and merge
>> operations when necessary, to avoid unnecessary operations.
>>
>> For example, if we are creating an area and punching a hole (assuming
>> this is a valid example), we would have
>>
>> transaction_begin()
>> CREATE(offset=0, memory area)
>> DELETE(memory area)
>> CREATE(offset=0, memory area / 2 - 1)
>> CREATE(offset=memory_area/2, memory area / 2)
>> transaction_commmit()
>>
>> Instead, if we pre-process the memory regions and detect overlaps with
>> an interval tree, we could simplify the above with:
>> CREATE(offset=0, memory area / 2 - 1)
>> CREATE(offset=memory_area/2, memory area / 2)
> 
> As I replied in the private email, I don't think the pre-process here is
> needed, because afaict flat views already handle that.
> 
> See generate_memory_topology() and especially render_memory_region().
> 
> In above example, the 1st CREATE + DELETE shouldn't reach any of the memory
> listners, including the KVM one, because the flatview only contains the
> final layout of the address space when commit() happens.
> 
>>
>> In addition, I was thinking to also provide the operation type (called
>> enum kvm_mr_change) from userspace directly, and not "figure" it
>> ourselves in KVM.
>>
>> The reason for these two changes come from KVM implementation. I know
>> this is no KVM place, but a background explanation might be necessary.
>> Basically KVM 1) figures the request type by looking at the fields
>> passed by userspace (for example mem_size == 0 means DELETE) and the
>> current status of the memslot (id not found means CREATE, found means
>> MOVE/UPDATE_FLAGS), and 2) has 2 memslot lists per address space: the
>> active (visible) and inactive. Any operation is performed in the
>> inactive list, then we "swap" the two so that the change is visible.
>>
>> The "atomic" goal of this serie just means that we want to apply
>> multiple memslot operation and then perform a single "swap".
>> The problem is that each DELETE and MOVE request perform 2 swaps: first
>> substitute current memslot with an invalid one (so that page faults are
>> retried), and then remove the invalid one (in case of MOVE, substitute
>> with new memslot).
>>
>> Therefore:
>> - KVM should ideally pre-process all DELETE/MOVE memslots and perform a
>> first swap(s) to replace the current memslot with an invalid one, and
>> then perform all other operations in order (deletion/move included).
> 
> This sounds correct.
> 
>> This is why QEMU should just send pre-merged MR, so that we don't have
>> CREATE(x)- DELETE(x). Otherwise we would process a DELETE on a MR that
>> doesn't exist yet.
> 
> As discussed above, IMHO pre-merge isn't an issue here and I think the
> sequence in your example won't happen.  But you raised a great question on
> whether we should allow the new ioctl (if there's going to be one) to do
> whatever it wants by batching any sequence of memslot operations.
> 
> More below.
> 
>>
>> - Doing the above is still not enough, as KVM figures what operation to
>> do depending on the current state of the memslots.
>> Assuming we already have an already existing MR y, and now we get the
>> list DELETE(y) CREATE(y/2) (ie reducing y to half its size).
>> In this case the interval tree can't do anything, but it's very hard to
>> understand that the second request in the list is a CREATE, because when
>> KVM performs the check to understand which type of operation it is
>> (before doing any modification at all in the memslot list), it finds
>> that y (memslot with same id) exist, but has a different size than what
>> provided from userspace, therefore it could either fail, or misinterpret
>> it as another operation (currently fails -EINVALID).
> 
> Another good question..  I think that can be partly solved by not allowing
> ID duplication in the same batched ioctl, or maybe we can fail it.  From
> qemu perspective, we may need to change the memslot id allocation to not
> reuse IDs of being-deleted memslots until the batch is processed.
> 
> Something like adding similar INVALID tags to kvm memslots in QEMU when we
> are preparing the batch, then we should only reset memory_size==0 and clear
> INVALID tag after the ioctl returns.  Then during the batch, any new slots
> to be added from kvm_get_free_slot() will not return any duplication of a
> deleting one.
> 
>> If we instead already provide the labels, then we can:
>> 	1. substitute the memslots pointed by DELETE/MOVE with invalid & swap
>> (so it is visible, non-atomic. But we don't care, as we are not deleting
>> anything)
>> 	2. delete the invalid memslot (in the inactive memslot list)
>> 	3. process the other requests (in the inactive memslot list)
>> 	4. single and atomic swap (step 2 and 3 are now visible).
>>
>> What do you think?
> 
> Adding some limitation to the new ioctl makes sense to me, especially
> moving the DELETE/MOVE to be handled earlier, rather than a complete
> mixture of all of them.
> 
> I'm wondering whether the batch ioctl can be layed out separately on the
> operations, then it can be clearly documented on the sequence of handling
> each op:
> 
>   struct kvm_userspace_memory_region_batch {
>          struct kvm_userspace_memory_region deletes[];
>          struct kvm_userspace_memory_region moves[];
>          struct kvm_userspace_memory_region creates[];
>          struct kvm_userspace_memory_region flags_only[];
>   };
> 
> So that the ordering can be very obvious.  But I didn't really think deeper
> than that.
> 
> Side note: do we use MOVE at all in QEMU?
> 
>>
>> Bonus question: with this atomic operation, do we really need the
>> invalid memslot logic for MOVE/DELETE?
> 
> I think so.  Not an expert on that, but iiuc that's to make sure we'll zap
> all shadow paging that maps to the slots being deleted/moved.
> 
> Paolo can always help to keep me honest above.
> 
> One thing I forgot to ask: iirc we used to have a workaround to kick all
> vcpus out, update memory slots, then continue all vcpus.  Would that work
> for us too for the problem you're working on?

As reference, here is one such approach for region resizes only:

https://lore.kernel.org/qemu-devel/20200312161217.3590-1-david@redhat.com/

which notes:

"Instead of inhibiting during the region_resize(), we could inhibit for
the hole memory transaction (from begin() to commit()). This could be
nice, because also splitting of memory regions would be atomic (I
remember there was a BUG report regarding that), however, I am not sure
if that might impact any RT users."


-- 
Thanks,

David / dhildenb

