Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 534752CDAA7
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 17:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389256AbgLCQDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 11:03:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387964AbgLCQDq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 11:03:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607011339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gwFT/at38qnWnV6ALWueYTdB/e9xeSjOOzsCIelui5c=;
        b=J077cbwkt0N+gbVQ/zN3V4NwntwIwk0njyxbsah2feICeNHidYidvM9RfjktwwbEvUb31Y
        wM8tHQDYKvmpE+pYfzIyX3Cy+h6q5YXcV+jkF1be21OkHgvCCR726NXxiO6J5mzOTD+elX
        l6rme2VgZXvxXMqMJNiV+zfdnUxc8/g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-uSXkKsj0OB6QOXi442mkng-1; Thu, 03 Dec 2020 11:02:17 -0500
X-MC-Unique: uSXkKsj0OB6QOXi442mkng-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51A461086607;
        Thu,  3 Dec 2020 16:01:35 +0000 (UTC)
Received: from [10.36.113.250] (ovpn-113-250.ams2.redhat.com [10.36.113.250])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 972265D6BA;
        Thu,  3 Dec 2020 16:01:33 +0000 (UTC)
Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
To:     Peter Xu <peterx@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Justin He <Justin.He@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201119142737.17574-1-justin.he@arm.com>
 <20201124181228.GA276043@xz-x1>
 <AM6PR08MB32245E7F990955395B44CE6BF7FA0@AM6PR08MB3224.eurprd08.prod.outlook.com>
 <20201125155711.GA6489@xz-x1>
 <20201202143356.GK655829@stefanha-x1.localdomain>
 <20201202154511.GI3277@xz-x1>
 <20201203112002.GE689053@stefanha-x1.localdomain>
 <20201203154322.GH108496@xz-x1>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <6a33e908-17ff-7a26-7341-4bcf7bbefe28@redhat.com>
Date:   Thu, 3 Dec 2020 17:01:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201203154322.GH108496@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03.12.20 16:43, Peter Xu wrote:
> On Thu, Dec 03, 2020 at 11:20:02AM +0000, Stefan Hajnoczi wrote:
>> On Wed, Dec 02, 2020 at 10:45:11AM -0500, Peter Xu wrote:
>>> On Wed, Dec 02, 2020 at 02:33:56PM +0000, Stefan Hajnoczi wrote:
>>>> On Wed, Nov 25, 2020 at 10:57:11AM -0500, Peter Xu wrote:
>>>>> On Wed, Nov 25, 2020 at 01:05:25AM +0000, Justin He wrote:
>>>>>>> I'd appreciate if you could explain why vfio needs to dma map some
>>>>>>> PROT_NONE
>>>>>>
>>>>>> Virtiofs will map a PROT_NONE cache window region firstly, then remap the sub
>>>>>> region of that cache window with read or write permission. I guess this might
>>>>>> be an security concern. Just CC virtiofs expert Stefan to answer it more accurately.
>>>>>
>>>>> Yep.  Since my previous sentence was cut off, I'll rephrase: I was thinking
>>>>> whether qemu can do vfio maps only until it remaps the PROT_NONE regions into
>>>>> PROT_READ|PROT_WRITE ones, rather than trying to map dma pages upon PROT_NONE.
>>>>
>>>> Userspace processes sometimes use PROT_NONE to reserve virtual address
>>>> space. That way future mmap(NULL, ...) calls will not accidentally
>>>> allocate an address from the reserved range.
>>>>
>>>> virtio-fs needs to do this because the DAX window mappings change at
>>>> runtime. Initially the entire DAX window is just reserved using
>>>> PROT_NONE. When it's time to mmap a portion of a file into the DAX
>>>> window an mmap(fixed_addr, ...) call will be made.
>>>
>>> Yes I can understand the rational on why the region is reserved.  However IMHO
>>> the real question is why such reservation behavior should affect qemu memory
>>> layout, and even further to VFIO mappings.
>>>
>>> Note that PROT_NONE should likely mean that there's no backing page at all in
>>> this case.  Since vfio will pin all the pages before mapping the DMAs, it also
>>> means that it's at least inefficient, because when we try to map all the
>>> PROT_NONE pages we'll try to fault in every single page of it, even if they may
>>> not ever be used.
>>>
>>> So I still think this patch is not doing the right thing.  Instead we should
>>> somehow teach qemu that the virtiofs memory region should only be the size of
>>> enabled regions (with PROT_READ|PROT_WRITE), rather than the whole reserved
>>> PROT_NONE region.
>>
>> virtio-fs was not implemented with IOMMUs in mind. The idea is just to
>> install a kvm.ko memory region that exposes the DAX window.
>>
>> Perhaps we need to treat the DAX window like an IOMMU? That way the
>> virtio-fs code can send map/unmap notifications and hw/vfio/ can
>> propagate them to the host kernel.
> 
> Sounds right.  One more thing to mention is that we may need to avoid tearing
> down the whole old DMA region when resizing the PROT_READ|PROT_WRITE region
> into e.g. a bigger one to cover some of the previusly PROT_NONE part, as long
> as if the before-resizing region is still possible to be accessed from any
> hardware.  It smells like something David is working with virtio-mem, not sure
> whether there's any common infrastructure that could be shared.

"somehow teach qemu that the virtiofs memory region should only be the
size of enabled regions" - for virtio-mem, I'm working on resizeable RAM
blocks/RAM memory regions. Fairly complicated, that's why I deferred
upstreaming it and still need to implement plenty of special cases for
atomic resizes (e.g., vhost-user).

But it's only one part of the puzzle for virtio-fs. AFAIU, it's not only
about resizing the region for virtio-fs - we can have PROT_NONE holes
anywhere inside there.

In vfio, you cannot shrink mappings atomically. Growing works, but
requires additional mappings (-> bad). So assume you mapped a file with
size X and want to resize it. You first have to unmap + remap with the
new size. This is not atomic, thus problematic.

For virtio-mem, we have a fix block size and can map/unmap in that
granularity whenever we populate/discard memory within the
device-managed region. I don't think that applies for files in case of
virtio-fs.


The real question is: do we even *need* DMA from vfio devices to
virtio-fs regions? If not (do guests rely on it? what does the spec
state?), just don't care about vfio at all and don't map anything.

But maybe I am missing something important

Q1: Is the virtio-fs region mapped into system address space, so we have
to map everything without a vIOMMU?

Q2: Is DMA from vfio devices to virtio-fs regions a valid use case?

-- 
Thanks,

David / dhildenb

