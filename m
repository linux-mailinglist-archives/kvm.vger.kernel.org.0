Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CC3C4112DE
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 12:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbhITKcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 06:32:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235934AbhITKcX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 06:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632133856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1BLbF8fgwdSepKVHmy9R4pCc/IGNczGe4x4tKE6dFJ0=;
        b=HxhwF8yHPlXGAd0er+WlGhL6A4yyk065mHBk72vAVuouDlLELj61A1x2y1LKmDRidJSHDa
        xLRT7/R6A+FF83fk/+Ydu5z3XTuc73HH+qoMFpuSKNg3mSaipl2ypaHfTOD/BQwiNxczKm
        XRve0n8gZvUC2HxVTwaCbpZ1dkg2+sw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-mdPR8X8TMxaQujtnVsMysg-1; Mon, 20 Sep 2021 06:30:52 -0400
X-MC-Unique: mdPR8X8TMxaQujtnVsMysg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C4401808308;
        Mon, 20 Sep 2021 10:30:51 +0000 (UTC)
Received: from localhost (unknown [10.39.193.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88A61196E2;
        Mon, 20 Sep 2021 10:30:41 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfu@redhat.com,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio/s390: fix vritio-ccw device teardown
In-Reply-To: <20210920003935.1369f9fe.pasic@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210915215742.1793314-1-pasic@linux.ibm.com>
 <87pmt8hp5o.fsf@redhat.com> <20210916151835.4ab512b2.pasic@linux.ibm.com>
 <87mtobh9xn.fsf@redhat.com> <20210920003935.1369f9fe.pasic@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Mon, 20 Sep 2021 12:30:39 +0200
Message-ID: <875yuvh73k.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 20 2021, Halil Pasic <pasic@linux.ibm.com> wrote:

> On Fri, 17 Sep 2021 10:40:20 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> On Thu, Sep 16 2021, Halil Pasic <pasic@linux.ibm.com> wrote:
>> 
>> > On Thu, 16 Sep 2021 10:59:15 +0200
>> > Cornelia Huck <cohuck@redhat.com> wrote:
>> >  
>> >> > Since commit 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
>> >> > classic notifiers") we were supposed to make sure that
>> >> > virtio_ccw_release_dev() completes before the ccw device, and the
>> >> > attached dma pool are torn down, but unfortunately we did not.
>> >> > Before that commit it used to be OK to delay cleaning up the memory
>> >> > allocated by virtio-ccw indefinitely (which isn't really intuitive for
>> >> > guys used to destruction happens in reverse construction order).
>> >> >
>> >> > To accomplish this let us take a reference on the ccw device before we
>> >> > allocate the dma_area and give it up after dma_area was freed.
>> >> >
>> >> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>> >> > Fixes: 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
>> >> > classic notifiers")
>> >> > Reported-by: bfu@redhat.com
>> >> > ---
>> >> >
>> >> > I'm not certain this is the only hot-unplug and teardonw related problem
>> >> > with virtio-ccw.
>> >> >
>> >> > Some things that are not perfectly clear to me:
>> >> > * What would happen if we observed an hot-unplug while we are doing
>> >> >   wait_event() in ccw_io_helper()? Do we get stuck? I don't thin we
>> >> >   are guaranteed to receive an irq for a subchannel that is gone.    
>> >> 
>> >> Hm. I think we may need to do a wake_up during remove handling.  
>> >
>> > My guess is that the BQL is saving us from ever seeing this with QEMU
>> > as the hypervisor-userspace. Nevertheless I don't think we should rely
>> > on that.  
>> 
>> I agree. Let's do that via a separate patch.
>> 
>
> I understand you would like us to finish the discussion on the alternate
> approach before giving an r-b for this patch, right?

Yes, exactly.

(...)

>> >> > An alternative to this approach would be to inc and dec the refcount
>> >> > in ccw_device_dma_zalloc() and ccw_device_dma_free() respectively.    
>> >> 
>> >> Yeah, I also thought about that. This would give us more get/put
>> >> operations, but might be the safer option.  
>> >
>> > My understanding is, that having the ccw device go away while in a
>> > middle of doing ccw stuff (about to submit, or waiting for a channel
>> > program, or whatever) was bad before.  
>> 
>> What do you mean with "was bad before"?
>
> Using an already invalid pointer to the ccw device is always bad. I'm
> not sure what prevented this from happening before commit 48720ba56891.
> I'm aware of the fact that virtio_ccw_release_dev() didn't use to
> deference the vcdev->cdev before that commit, so we didn't have this
> exact problem. Can you tell me, how did we use to ensure that all
> dereferences of vcdev->cdev are legit, i.e. happened while the
> ccw device is still fully alive before commit 48720ba56891?

I'm not sure what that commit is having to do with lifetimes, it did not
change anything, only added the extra interaction for the dma buffer.

Basically, the vcdev is supposed to be around while the ccw device is
online (with a tail end until references have been given up, of course.)
It embeds a virtio device that has the ccw device as a parent, which
will give us a reference on the ccw device as long as the virtio device
is alive. Any interactions with the ccw device (except freeing the dma
buffer) are limited to the time where we still have a reference to it
via the virtio device.

>
>> 
>> > So my intuition tells me that
>> > drivers should manage explicitly. Yes virtio_ccw happens to have dma
>> > memory whose lifetime is more or less the lifetime of struct virtio_ccw,
>> > but that may not be always the case.  
>> 
>> I'm not sure what you're getting at here. Regardless of the lifetime of
>> the dma memory, it depends on the presence of the ccw device to which it
>> is tied. This means that the ccw device must not be released while the
>> dma memory is alive. We can use the approach in your patch here due to
>> the lifetime of the dma memory that virtio-ccw allocates when we start
>> using the device and frees when we stop using the device, or we can use
>> get/put with every allocate/release dma memory pair, which should be
>> safe for everyone?
>> 
>
> What I mean is that ccw_device_dma_[zalloc,free]() take a pointer to the
> ccw_device. If we get/put in those we can ensure that, provided the
> alloc and the free calls are properly paired, the device will be still
> alive (and the pointer valid) for the free, if it was valid for the
> alloc. But it does not ensure that each and every call to alloc is with
> a valid pointer, or that other uses of the pointer are OK. So I don't
> think it is completely safe for everyone, because we could try to use
> a pointer to a ccw device when not having any dma memory allocated from
> its pool.

But the problem is the dma memory, right? Also, it is the same issue for
any potential caller of the ccw_device_dma_* interfaces.

>
> This patch takes reference to cdev before the pointer is published via
> vcdev->cdev and drops the reference after *vcdev is freed. The idea is
> that the pointee basically outlives the pointer. (Without having a full
> understanding of how things are synchronized).

I don't think we have to care about accessing ->cdev (see above.) Plus,
as we give up the dma memory at the very last point, we would also give
up the reference via that memory at the very last point, so I'm not sure
what additional problems could come up.

