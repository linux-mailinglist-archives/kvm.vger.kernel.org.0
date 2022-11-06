Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE9561E673
	for <lists+kvm@lfdr.de>; Sun,  6 Nov 2022 22:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiKFVY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Nov 2022 16:24:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbiKFVYZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Nov 2022 16:24:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100397648
        for <kvm@vger.kernel.org>; Sun,  6 Nov 2022 13:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667769809;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=932CM+Z2BMMsr5dfSZkj2UOmThaqpFk3u/BlHChDQHQ=;
        b=GKOukhVjj3JDWVNVQ345gTsTrAkqqqee3TdbKaon64x/LbCMtulpklUXTmhKAwlPt1Gvn9
        S8pNgAHjXXcHnREqTnDMM95h7frH/1zH242Esp1mURYQsDouzPLzlhU+LRjGipYXjMRNov
        N/p0W1C8HtDWYBUJMnDJezdlmh3ANOQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-xhDpxWsBNDumgL_O6jcmkQ-1; Sun, 06 Nov 2022 16:23:23 -0500
X-MC-Unique: xhDpxWsBNDumgL_O6jcmkQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDF5D29AA3A5;
        Sun,  6 Nov 2022 21:23:22 +0000 (UTC)
Received: from [10.64.54.78] (vpn2-54-78.bne.redhat.com [10.64.54.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A9892027063;
        Sun,  6 Nov 2022 21:23:15 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v8 3/7] KVM: Support dirty ring in conjunction with bitmap
To:     Peter Xu <peterx@redhat.com>, Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, shuah@kernel.org, catalin.marinas@arm.com,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, dmatlack@google.com, will@kernel.org,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, seanjc@google.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221104234049.25103-1-gshan@redhat.com>
 <20221104234049.25103-4-gshan@redhat.com> <87o7tkf5re.wl-maz@kernel.org>
 <Y2ffRYoqlQOxgVtk@x1n> <87iljrg7vd.wl-maz@kernel.org> <Y2gh4x4MD8BJvogH@x1n>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <35d005f3-655a-88f5-2de3-848576a26e42@redhat.com>
Date:   Mon, 7 Nov 2022 05:23:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y2gh4x4MD8BJvogH@x1n>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter and Marc,

On 11/7/22 5:06 AM, Peter Xu wrote:
> On Sun, Nov 06, 2022 at 08:12:22PM +0000, Marc Zyngier wrote:
>> On Sun, 06 Nov 2022 16:22:29 +0000,
>> Peter Xu <peterx@redhat.com> wrote:
>>> On Sun, Nov 06, 2022 at 03:43:17PM +0000, Marc Zyngier wrote:
>>>>> +Note that the bitmap here is only a backup of the ring structure, and
>>>>> +normally should only contain a very small amount of dirty pages, which
>>>>
>>>> I don't think we can claim this. It is whatever amount of memory is
>>>> dirtied outside of a vcpu context, and we shouldn't make any claim
>>>> regarding the number of dirty pages.
>>>
>>> The thing is the current with-bitmap design assumes that the two logs are
>>> collected in different windows of migration, while the dirty log is only
>>> collected after the VM is stopped.  So collecting dirty bitmap and sending
>>> the dirty pages within the bitmap will be part of the VM downtime.
>>>
>>> It will stop to make sense if the dirty bitmap can contain a large portion
>>> of the guest memory, because then it'll be simpler to just stop the VM,
>>> transfer pages, and restart on dest node without any tracking mechanism.
>>
>> Oh, I absolutely agree that the whole vcpu dirty ring makes zero sense
>> in general. It only makes sense if the source of the dirty pages is
>> limited to the vcpus, which is literally a corner case. Look at any
>> real machine, and you'll quickly realise that this isn't the case, and
>> that DMA *is* a huge source of dirty pages.
>>
>> Here, we're just lucky enough not to have much DMA tracking yet. Once
>> that happens (and I have it from people doing the actual work that it
>> *is* happening), you'll realise that the dirty ring story is of very
>> limited use. So I'd rather drop anything quantitative here, as this is
>> likely to be wrong.
> 
> Is it a must that arm64 needs to track device DMAs using the same dirty
> tracking interface rather than VFIO or any other interface?  It's
> definitely not the case for x86, but if it's true for arm64, then could the
> DMA be spread across all the guest pages?  If it's also true, I really
> don't know how this will work..
> 
> We're only syncing the dirty bitmap once right now with the protocol.  If
> that can cover most of the guest mem, it's same as non-live.  If we sync it
> periodically, then it's the same as enabling dirty-log alone and the rings
> are useless.
> 

For vgic/its tables, the number of dirty pages can be huge in theory. However,
they're limited in practice. So I intend to agree with Peter that dirty-ring
should be avoided and dirty-log needs to be used instead when the DMA case
is supported in future. As Peter said, the small amount of dirty pages in
the bitmap is the condition to use it here. I think it makes sense to mention
it in the document.

>>
>>>
>>> [1]
>>>
>>>>
>>>>> +needs to be transferred during VM downtime. Collecting the dirty bitmap
>>>>> +should be the very last thing that the VMM does before transmitting state
>>>>> +to the target VM. VMM needs to ensure that the dirty state is final and
>>>>> +avoid missing dirty pages from another ioctl ordered after the bitmap
>>>>> +collection.
>>>>> +
>>>>> +To collect dirty bits in the backup bitmap, the userspace can use the
>>>>> +same KVM_GET_DIRTY_LOG ioctl. KVM_CLEAR_DIRTY_LOG shouldn't be needed
>>>>> +and its behavior is undefined since collecting the dirty bitmap always
>>>>> +happens in the last phase of VM's migration.
>>>>
>>>> It isn't clear to me why KVM_CLEAR_DIRTY_LOG should be called out. If
>>>> you have multiple devices that dirty the memory, such as multiple
>>>> ITSs, why shouldn't userspace be allowed to snapshot the dirty state
>>>> multiple time? This doesn't seem like a reasonable restriction, and I
>>>> really dislike the idea of undefined behaviour here.
>>>
>>> I suggested the paragraph because it's very natural to ask whether we'd
>>> need to CLEAR_LOG for this special GET_LOG phase, so I thought this could
>>> be helpful as a reference to answer that.
>>>
>>> I wanted to make it clear that we don't need CLEAR_LOG at all in this case,
>>> as fundamentally clear log is about re-protect the guest pages, but if
>>> we're with the restriction of above (having the dirty bmap the last to
>>> collect and once and for all) then it'll make no sense to protect the guest
>>> page at all at this stage since src host shouldn't run after the GET_LOG
>>> then the CLEAR_LOG will be a vain effort.
>>
>> That's not for you to decide, but userspace. I can perfectly expect
>> userspace saving an ITS, getting the bitmap, saving the pages and then
>> *clearing the log* before processing the next ITS. Or anything else.
> 
> I think I can get your point on why you're not happy with the document, but
> IMHO how we document is one thing, how it'll work is another.  I preferred
> explicit documentation because it'll help the app developer to support the
> interface, also more docs to reference in the future; no strong opinion,
> though.
> 
> However if there's fundamental statement that was literally wrong, then
> it's another thing, and we may need to rethink.
> 

How about to avoid mentioning KVM_CLEAR_DIRTY_LOG here? I don't expect QEMU
to clear the dirty bitmap after it's collected in this particular case.

Thanks,
Gavin

