Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF0E5A2911
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 16:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244825AbiHZOHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 10:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiHZOHN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 10:07:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8730CC123D
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 07:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661522831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z9g7blgTR2j4JF8jbteWBwRFECHGamLXwQ0qnjXrBa0=;
        b=VEYGaffZtgco/ZXvPCA2tN7kMmKZqEpZQHKraWdILwnTI7JMz9NcAvn1YFoWoqV4uoJcZl
        I4/dFAOYjcv7edV9j+0nD1T5ijPl+ZxOyBzrMAGQRHDQKr3n75ORrMhFxnaVbCD+gAclRx
        29z5XRSz8N4BYChjYWzGl5GGLXVhFAI=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-615-fPC5b44tM9KJ9ZqJyk5KHw-1; Fri, 26 Aug 2022 10:07:06 -0400
X-MC-Unique: fPC5b44tM9KJ9ZqJyk5KHw-1
Received: by mail-qt1-f199.google.com with SMTP id v5-20020ac873c5000000b003434ef0a8c7so1345425qtp.21
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 07:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=z9g7blgTR2j4JF8jbteWBwRFECHGamLXwQ0qnjXrBa0=;
        b=3EsSMa/YIL2ZQlCzpvIK3iJ8YeLtDdLp9ZNH+4p4Nx7dVmr7sy6iuZpYcfgjM/slBZ
         XvPANS+Q1OxnByQ2f/HXWj3vze3+JGFnFJ+2HE6irzlROCUzZpOX/DyhcW5JqYNvcVed
         ynPX9/0p7rBsCuVICdplHgLtyf6A6ZHmZX6jWETCi1BFc7QktwMlS32qYWMs33etQmdF
         zd95bdKPGUTNScCodpEvDDMrbnBrT65NVtUqUUvlp20Kj/sRBXRYUcjib0E6Ndtvo8R1
         M6DN+j8isuUg3zvk6ZiRx4jPJJZap/Kp3MHG/e5tUoDx+yVoQu9L1M7hZdpxDZjugY8m
         MUgw==
X-Gm-Message-State: ACgBeo10BhJo8aAMYtMJ0yYTPb1ptPgRHLebvUSJBcBzj+XPbfZRkwMK
        9koCmxqUe+AfRoQVZP/uIKntDD4arc2nvtHGS3MWKCBSsCCyNv7hovi1TkOOPm2DOCRqrqFMC3J
        v3n8EGvRFIvWb
X-Received: by 2002:ac8:5e08:0:b0:343:5f6a:783d with SMTP id h8-20020ac85e08000000b003435f6a783dmr7950334qtx.100.1661522825668;
        Fri, 26 Aug 2022 07:07:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7ctcQfPxC3SL/y0ZmFeQ7iF9Lj2xh0Wjh77sehooV6wv5wGjhc2AgP+Y93AGp6QvNSeOtHpQ==
X-Received: by 2002:ac8:5e08:0:b0:343:5f6a:783d with SMTP id h8-20020ac85e08000000b003435f6a783dmr7950308qtx.100.1661522825337;
        Fri, 26 Aug 2022 07:07:05 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id f3-20020ac84703000000b0034454aff529sm1247176qtp.80.2022.08.26.07.07.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 07:07:04 -0700 (PDT)
Message-ID: <d4601180-4c95-a952-2b40-d40fa8e55005@redhat.com>
Date:   Fri, 26 Aug 2022 16:07:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay kvm_vm_ioctl
 to the commit phase
Content-Language: en-US
To:     Peter Xu <peterx@redhat.com>,
        Leonardo Bras Soares Passos <lsoaresp@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com> <Yv6baJoNikyuZ38R@xz-m1.local>
 <CAJ6HWG6maoPjbP8T5qo=iXCbNeHu4dq3wHLKtRLahYKuJmMY-g@mail.gmail.com>
 <YwOOcC72KKABKgU+@xz-m1.local>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <YwOOcC72KKABKgU+@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 22/08/2022 um 16:10 schrieb Peter Xu:
> On Thu, Aug 18, 2022 at 09:55:20PM -0300, Leonardo Bras Soares Passos wrote:
>> On Thu, Aug 18, 2022 at 5:05 PM Peter Xu <peterx@redhat.com> wrote:
>>>
>>> On Tue, Aug 16, 2022 at 06:12:50AM -0400, Emanuele Giuseppe Esposito wrote:
>>>> +static void kvm_memory_region_node_add(KVMMemoryListener *kml,
>>>> +                                       struct kvm_userspace_memory_region *mem)
>>>> +{
>>>> +    MemoryRegionNode *node;
>>>> +
>>>> +    node = g_malloc(sizeof(MemoryRegionNode));
>>>> +    *node = (MemoryRegionNode) {
>>>> +        .mem = mem,
>>>> +    };
>>>
>>> Nit: direct assignment of struct looks okay, but maybe pointer assignment
>>> is clearer (with g_malloc0?  Or iirc we're suggested to always use g_new0):
>>>
>>>   node = g_new0(MemoryRegionNode, 1);
>>>   node->mem = mem;
>>>
>>> [...]

Makes sense

>>>
>>>> +/* for KVM_SET_USER_MEMORY_REGION_LIST */
>>>> +struct kvm_userspace_memory_region_list {
>>>> +     __u32 nent;
>>>> +     __u32 flags;
>>>> +     struct kvm_userspace_memory_region entries[0];
>>>> +};
>>>> +
>>>>  /*
>>>>   * The bit 0 ~ bit 15 of kvm_memory_region::flags are visible for userspace,
>>>>   * other bits are reserved for kvm internal use which are defined in
>>>> @@ -1426,6 +1433,8 @@ struct kvm_vfio_spapr_tce {
>>>>                                       struct kvm_userspace_memory_region)
>>>>  #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
>>>>  #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
>>>> +#define KVM_SET_USER_MEMORY_REGION_LIST _IOW(KVMIO, 0x49, \
>>>> +                                     struct kvm_userspace_memory_region_list)
>>>
>>> I think this is probably good enough, but just to provide the other small
>>> (but may not be important) piece of puzzle here.  I wanted to think through
>>> to understand better but I never did..
>>>
>>> For a quick look, please read the comment in kvm_set_phys_mem().
>>>
>>>                 /*
>>>                  * NOTE: We should be aware of the fact that here we're only
>>>                  * doing a best effort to sync dirty bits.  No matter whether
>>>                  * we're using dirty log or dirty ring, we ignored two facts:
>>>                  *
>>>                  * (1) dirty bits can reside in hardware buffers (PML)
>>>                  *
>>>                  * (2) after we collected dirty bits here, pages can be dirtied
>>>                  * again before we do the final KVM_SET_USER_MEMORY_REGION to
>>>                  * remove the slot.
>>>                  *
>>>                  * Not easy.  Let's cross the fingers until it's fixed.
>>>                  */
>>>
>>> One example is if we have 16G mem, we enable dirty tracking and we punch a
>>> hole of 1G at offset 1G, it'll change from this:
>>>
>>>                      (a)
>>>   |----------------- 16G -------------------|
>>>
>>> To this:
>>>
>>>      (b)    (c)              (d)
>>>   |--1G--|XXXXXX|------------14G------------|
>>>
>>> Here (c) will be a 1G hole.
>>>
>>> With current code, the hole punching will del region (a) and add back
>>> region (b) and (d).  After the new _LIST ioctl it'll be atomic and nicer.
>>>
>>> Here the question is if we're with dirty tracking it means for each region
>>> we have a dirty bitmap.  Currently we do the best effort of doing below
>>> sequence:
>>>
>>>   (1) fetching dirty bmap of (a)
>>>   (2) delete region (a)
>>>   (3) add region (b) (d)
>>>
>>> Here (a)'s dirty bmap is mostly kept as best effort, but still we'll lose
>>> dirty pages written between step (1) and (2) (and actually if the write
>>> comes within (2) and (3) I think it'll crash qemu, and iiuc that's what
>>> we're going to fix..).
>>>
>>> So ideally the atomic op can be:
>>>
>>>   "atomically fetch dirty bmap for removed regions, remove regions, and add
>>>    new regions"
>>>
>>> Rather than only:
>>>
>>>   "atomically remove regions, and add new regions"
>>>
>>> as what the new _LIST ioctl do.
>>>
>>> But... maybe that's not a real problem, at least I didn't know any report
>>> showing issue with current code yet caused by losing of dirty bits during
>>> step (1) and (2).  Neither do I know how to trigger an issue with it.
>>>
>>> I'm just trying to still provide this information so that you should be
>>> aware of this problem too, at the meantime when proposing the new ioctl
>>> change for qemu we should also keep in mind that we won't easily lose the
>>> dirty bmap of (a) here, which I think this patch does the right thing.
>>>
>>
>> Thanks for bringing these details Peter!
>>
>> What do you think of adding?
>> (4) Copy the corresponding part of (a)'s dirty bitmap to (b) and (d)'s
>> dirty bitmaps.
> 
> Sounds good to me, but may not cover dirty ring?  Maybe we could move on
> with the simple but clean scheme first and think about a comprehensive
> option only if very necessary.  The worst case is we need one more kvm cap
> but we should still have enough.

Ok then, I will not consider this for now.

Might or might not be relevant, but I was also considering to
pre-process the list of memslots passed to the ioctl and merge
operations when necessary, to avoid unnecessary operations.

For example, if we are creating an area and punching a hole (assuming
this is a valid example), we would have

transaction_begin()
CREATE(offset=0, memory area)
DELETE(memory area)
CREATE(offset=0, memory area / 2 - 1)
CREATE(offset=memory_area/2, memory area / 2)
transaction_commmit()

Instead, if we pre-process the memory regions and detect overlaps with
an interval tree, we could simplify the above with:
CREATE(offset=0, memory area / 2 - 1)
CREATE(offset=memory_area/2, memory area / 2)

In addition, I was thinking to also provide the operation type (called
enum kvm_mr_change) from userspace directly, and not "figure" it
ourselves in KVM.

The reason for these two changes come from KVM implementation. I know
this is no KVM place, but a background explanation might be necessary.
Basically KVM 1) figures the request type by looking at the fields
passed by userspace (for example mem_size == 0 means DELETE) and the
current status of the memslot (id not found means CREATE, found means
MOVE/UPDATE_FLAGS), and 2) has 2 memslot lists per address space: the
active (visible) and inactive. Any operation is performed in the
inactive list, then we "swap" the two so that the change is visible.

The "atomic" goal of this serie just means that we want to apply
multiple memslot operation and then perform a single "swap".
The problem is that each DELETE and MOVE request perform 2 swaps: first
substitute current memslot with an invalid one (so that page faults are
retried), and then remove the invalid one (in case of MOVE, substitute
with new memslot).

Therefore:
- KVM should ideally pre-process all DELETE/MOVE memslots and perform a
first swap(s) to replace the current memslot with an invalid one, and
then perform all other operations in order (deletion/move included).
This is why QEMU should just send pre-merged MR, so that we don't have
CREATE(x)- DELETE(x). Otherwise we would process a DELETE on a MR that
doesn't exist yet.

- Doing the above is still not enough, as KVM figures what operation to
do depending on the current state of the memslots.
Assuming we already have an already existing MR y, and now we get the
list DELETE(y) CREATE(y/2) (ie reducing y to half its size).
In this case the interval tree can't do anything, but it's very hard to
understand that the second request in the list is a CREATE, because when
KVM performs the check to understand which type of operation it is
(before doing any modification at all in the memslot list), it finds
that y (memslot with same id) exist, but has a different size than what
provided from userspace, therefore it could either fail, or misinterpret
it as another operation (currently fails -EINVALID).
If we instead already provide the labels, then we can:
	1. substitute the memslots pointed by DELETE/MOVE with invalid & swap
(so it is visible, non-atomic. But we don't care, as we are not deleting
anything)
	2. delete the invalid memslot (in the inactive memslot list)
	3. process the other requests (in the inactive memslot list)
	4. single and atomic swap (step 2 and 3 are now visible).

What do you think?

Bonus question: with this atomic operation, do we really need the
invalid memslot logic for MOVE/DELETE?

Thank you,
Emanuele

