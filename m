Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D295B3C415F
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 05:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhGLDKo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 11 Jul 2021 23:10:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60668 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229891AbhGLDKo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 11 Jul 2021 23:10:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626059275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DigXiH/LTULD0RvNd551qqlSUUAL5xHAN7DKU/yDOVs=;
        b=QPXxG3OyZXCbZI8aUNQ0sU+1eQG2yB8FZ4MnKwvOpkJLmCfQcjiE4lTiiN4cqYlF3AoA85
        m8D8HIo0PU2TYYQ9S/5WERlc20BQrjE4aEQ2VdS3pMv/Cl8KX0Xq5aiHl9HO6889psQkdP
        sETKkWZkh9kpEfjH9tvk15k28msHAJM=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-nb-ONrHgO_aMn_hzeOf7iw-1; Sun, 11 Jul 2021 23:07:54 -0400
X-MC-Unique: nb-ONrHgO_aMn_hzeOf7iw-1
Received: by mail-pg1-f198.google.com with SMTP id 1-20020a6317410000b0290228062f22a0so13666689pgx.22
        for <kvm@vger.kernel.org>; Sun, 11 Jul 2021 20:07:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DigXiH/LTULD0RvNd551qqlSUUAL5xHAN7DKU/yDOVs=;
        b=r7jb8+giQ2D+ATDbhmIC8QSSiV1KYV6ztWLx5tCApmFOPPjdRilFHjSGHf3AedQdsY
         ooSXUnKbY5UJhHY55CcHxet7cK50eTQefdLmv6NmITAec9tQxehDvvKHm6xWp06kKFGH
         dr0lc0w8oVywSx2UvIPctRdlcLNQtKDSkd4APZDI4vbYA9nOg2PzNunH70CYFcPawcPZ
         ONT++ow/khP2YpRrq6fH9NvYfIF+97m6Lm0kU8yWIj9Hi7p/ucItrYS9Vr3boIVsPYRp
         8eq/+nxx075wq+4hB939zObE8WAVAsRRBD9866Q4sC7wJvGjd/2HBO50e8RF1gU9Bg1+
         hqBg==
X-Gm-Message-State: AOAM531j0Mn0PxmFlwuBtfVo7jtkNtXA0/yeZP1HEMSlhXyCxXFDi8Gy
        Qe+ROLnPTmjgfOJhCMFFIFctyokBfNg6WyJDIXd5KeXLQlErismcuuWVE/kgBA+/7ouxC2kFfLo
        apFhvWKSIvG3kyA8i7GIwYdIaGR4YSZu3XwyqKCAEhBumQUl1citsc7yrulh2wonj
X-Received: by 2002:a17:902:7489:b029:129:c0d3:96ca with SMTP id h9-20020a1709027489b0290129c0d396camr23766946pll.46.1626059273432;
        Sun, 11 Jul 2021 20:07:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxESf9PbVdwF/2IJoYJMIgdbQYf4I6nxhfXcDxjtsXifXfkOeknetHp4Hd3RPbbf5QVI0UF5A==
X-Received: by 2002:a17:902:7489:b029:129:c0d3:96ca with SMTP id h9-20020a1709027489b0290129c0d396camr23766914pll.46.1626059273074;
        Sun, 11 Jul 2021 20:07:53 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j15sm11693382pjl.15.2021.07.11.20.07.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jul 2021 20:07:52 -0700 (PDT)
Subject: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xieyongji@bytedance.com,
        stefanha@redhat.com, file@sect.tu-berlin.de, ashish.kalra@amd.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org
References: <20210423080942.2997-1-jasowang@redhat.com>
 <0e9d70b7-6c8a-4ff5-1fa9-3c4f04885bb8@redhat.com>
 <20210506041057-mutt-send-email-mst@kernel.org>
 <20210506123829.GA403858@infradead.org>
 <20210514063516-mutt-send-email-mst@kernel.org>
 <8bf22db2-97d4-9f88-8b6b-d685fd63ac8b@redhat.com>
 <20210711120627-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e2b4c614-746f-e81b-bb0b-d84f0efd381f@redhat.com>
Date:   Mon, 12 Jul 2021 11:07:44 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210711120627-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


在 2021/7/12 上午12:08, Michael S. Tsirkin 写道:
> On Fri, Jun 04, 2021 at 01:38:01PM +0800, Jason Wang wrote:
>> 在 2021/5/14 下午7:13, Michael S. Tsirkin 写道:
>>> On Thu, May 06, 2021 at 01:38:29PM +0100, Christoph Hellwig wrote:
>>>> On Thu, May 06, 2021 at 04:12:17AM -0400, Michael S. Tsirkin wrote:
>>>>> Let's try for just a bit, won't make this window anyway:
>>>>>
>>>>> I have an old idea. Add a way to find out that unmap is a nop
>>>>> (or more exactly does not use the address/length).
>>>>> Then in that case even with DMA API we do not need
>>>>> the extra data. Hmm?
>>>> So we actually do have a check for that from the early days of the DMA
>>>> API, but it only works at compile time: CONFIG_NEED_DMA_MAP_STATE.
>>>>
>>>> But given how rare configs without an iommu or swiotlb are these days
>>>> it has stopped to be very useful.  Unfortunately a runtime-version is
>>>> not entirely trivial, but maybe if we allow for false positives we
>>>> could do something like this
>>>>
>>>> bool dma_direct_need_state(struct device *dev)
>>>> {
>>>> 	/* some areas could not be covered by any map at all */
>>>> 	if (dev->dma_range_map)
>>>> 		return false;
>>>> 	if (force_dma_unencrypted(dev))
>>>> 		return false;
>>>> 	if (dma_direct_need_sync(dev))
>>>> 		return false;
>>>> 	return *dev->dma_mask == DMA_BIT_MASK(64);
>>>> }
>>>>
>>>> bool dma_need_state(struct device *dev)
>>>> {
>>>> 	const struct dma_map_ops *ops = get_dma_ops(dev);
>>>>
>>>> 	if (dma_map_direct(dev, ops))
>>>> 		return dma_direct_need_state(dev);
>>>> 	return ops->unmap_page ||
>>>> 		ops->sync_single_for_cpu || ops->sync_single_for_device;
>>>> }
>>> Yea that sounds like a good idea. We will need to document that.
>>>
>>>
>>> Something like:
>>>
>>> /*
>>>    * dma_need_state - report whether unmap calls use the address and length
>>>    * @dev: device to guery
>>>    *
>>>    * This is a runtime version of CONFIG_NEED_DMA_MAP_STATE.
>>>    *
>>>    * Return the value indicating whether dma_unmap_* and dma_sync_* calls for the device
>>>    * use the DMA state parameters passed to them.
>>>    * The DMA state parameters are: scatter/gather list/table, address and
>>>    * length.
>>>    *
>>>    * If dma_need_state returns false then DMA state parameters are
>>>    * ignored by all dma_unmap_* and dma_sync_* calls, so it is safe to pass 0 for
>>>    * address and length, and DMA_UNMAP_SG_TABLE_INVALID and
>>>    * DMA_UNMAP_SG_LIST_INVALID for s/g table and length respectively.
>>>    * If dma_need_state returns true then DMA state might
>>>    * be used and so the actual values are required.
>>>    */
>>>
>>> And we will need DMA_UNMAP_SG_TABLE_INVALID and
>>> DMA_UNMAP_SG_LIST_INVALID as pointers to an empty global table and list
>>> for calls such as dma_unmap_sgtable that dereference pointers before checking
>>> they are used.
>>>
>>>
>>> Does this look good?
>>>
>>> The table/length variants are for consistency, virtio specifically does
>>> not use s/g at the moment, but it seems nicer than leaving
>>> users wonder what to do about these.
>>>
>>> Thoughts? Jason want to try implementing?
>>
>> I can add it in my todo list other if other people are interested in this,
>> please let us know.
>>
>> But this is just about saving the efforts of unmap and it doesn't eliminate
>> the necessary of using private memory (addr, length) for the metadata for
>> validating the device inputs.
>
> Besides unmap, why do we need to validate address?


Sorry, it's not validating actually, the driver doesn't do any 
validation. As the subject, the driver will just use the metadata stored 
in the desc_state instead of the one stored in the descriptor ring.


>   length can be
> typically validated by specific drivers - not all of them even use it ..
>
>> And just to clarify, the slight regression we see is testing without
>> VIRTIO_F_ACCESS_PLATFORM which means DMA API is not used.
> I guess this is due to extra cache pressure?


Yes.


> Maybe create yet another
> array just for DMA state ...


I'm not sure I get this, we use this basically:

struct vring_desc_extra {
         dma_addr_t addr;                /* Buffer DMA addr. */
         u32 len;                        /* Buffer length. */
         u16 flags;                      /* Descriptor flags. */
         u16 next;                       /* The next desc state in a 
list. */
};

Except for the "next" the rest are all DMA state.

Thanks


>
>> So I will go to post a formal version of this series and we can start from
>> there.
>>
>> Thanks
>>
>>

