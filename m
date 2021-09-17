Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A5D40F446
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 10:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbhIQIlu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 04:41:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245420AbhIQIlt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Sep 2021 04:41:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631868027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uPwMqjjw/KE/1k5TJSCA0cyO58yfO/wcRwrm76t+5zo=;
        b=d3rqJR81Ae4TM62NXMoZxR0nJTla7ibJiDfJzZ3KvW4zj1o74td1ziYp7bv1BY+ytcDU3K
        Dy6dgkC8vNC4nCzaZ7LdJSPtndEvpEAo/EDi2blbkEjgGG1HnGIj9L1zzaLF3BlW8oT9sK
        U/sGvXfwoKCUkcUkdeXOM4ajF9k+VmI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-DTmpkWiNPRCSYSDfy3mD9w-1; Fri, 17 Sep 2021 04:40:24 -0400
X-MC-Unique: DTmpkWiNPRCSYSDfy3mD9w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F3648145E6;
        Fri, 17 Sep 2021 08:40:22 +0000 (UTC)
Received: from localhost (unknown [10.39.192.115])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 38D2760C9F;
        Fri, 17 Sep 2021 08:40:22 +0000 (UTC)
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
In-Reply-To: <20210916151835.4ab512b2.pasic@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210915215742.1793314-1-pasic@linux.ibm.com>
 <87pmt8hp5o.fsf@redhat.com> <20210916151835.4ab512b2.pasic@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Fri, 17 Sep 2021 10:40:20 +0200
Message-ID: <87mtobh9xn.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 16 2021, Halil Pasic <pasic@linux.ibm.com> wrote:

> On Thu, 16 Sep 2021 10:59:15 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> > Since commit 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
>> > classic notifiers") we were supposed to make sure that
>> > virtio_ccw_release_dev() completes before the ccw device, and the
>> > attached dma pool are torn down, but unfortunately we did not.
>> > Before that commit it used to be OK to delay cleaning up the memory
>> > allocated by virtio-ccw indefinitely (which isn't really intuitive for
>> > guys used to destruction happens in reverse construction order).
>> >
>> > To accomplish this let us take a reference on the ccw device before we
>> > allocate the dma_area and give it up after dma_area was freed.
>> >
>> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
>> > Fixes: 48720ba56891 ("virtio/s390: use DMA memory for ccw I/O and
>> > classic notifiers")
>> > Reported-by: bfu@redhat.com
>> > ---
>> >
>> > I'm not certain this is the only hot-unplug and teardonw related problem
>> > with virtio-ccw.
>> >
>> > Some things that are not perfectly clear to me:
>> > * What would happen if we observed an hot-unplug while we are doing
>> >   wait_event() in ccw_io_helper()? Do we get stuck? I don't thin we
>> >   are guaranteed to receive an irq for a subchannel that is gone.  
>> 
>> Hm. I think we may need to do a wake_up during remove handling.
>
> My guess is that the BQL is saving us from ever seeing this with QEMU
> as the hypervisor-userspace. Nevertheless I don't think we should rely
> on that.

I agree. Let's do that via a separate patch.

>
>> 
>> > * cdev->online seems to be manipulated under cdev->ccwlock, but
>> >   in virtio_ccw_remove() we look at it to decide should we clean up
>> >   or not. What is the idea there? I guess we want to avoid doing
>> >   if nothing is there or twice. But I don't understand how stuff
>> >   interlocks.  
>> 
>> We only created the virtio device when we onlined the ccw device. Do you
>> have a better idea how to check for that? (And yes, I'm not sure the
>> locking is correct.)
>> 
>
> Thanks, if I find time for it, I will try to understand this better and
> come back with my findings.
>
>> > * Can virtio_ccw_remove() get called while !cdev->online and 
>> >   virtio_ccw_online() is running on a different cpu? If yes, what would
>> >   happen then?  
>> 
>> All of the remove/online/... etc. callbacks are invoked via the ccw bus
>> code. We have to trust that it gets it correct :) (Or have the common
>> I/O layer maintainers double-check it.)
>> 
>
> Vineeth, what is your take on this? Are the struct ccw_driver
> virtio_ccw_remove and the virtio_ccw_online callbacks mutually
> exclusive. Please notice that we may initiate the onlining by
> calling ccw_device_set_online() from a workqueue.
>
> @Conny: I'm not sure what is your definition of 'it gets it correct'...
> I doubt CIO can make things 100% foolproof in this area.

Not 100% foolproof, but "don't online a device that is in the progress
of going away" seems pretty basic to me.

>
>> >  
>> > The main addresse of these questions is Conny ;).
>
> In any case, I think we can go step by step. I would like the issue
> this patch intends to address, addressed first. Then we can think
> about the rest.
>
>> >
>> > An alternative to this approach would be to inc and dec the refcount
>> > in ccw_device_dma_zalloc() and ccw_device_dma_free() respectively.  
>> 
>> Yeah, I also thought about that. This would give us more get/put
>> operations, but might be the safer option.
>
> My understanding is, that having the ccw device go away while in a
> middle of doing ccw stuff (about to submit, or waiting for a channel
> program, or whatever) was bad before.

What do you mean with "was bad before"?

> So my intuition tells me that
> drivers should manage explicitly. Yes virtio_ccw happens to have dma
> memory whose lifetime is more or less the lifetime of struct virtio_ccw,
> but that may not be always the case.

I'm not sure what you're getting at here. Regardless of the lifetime of
the dma memory, it depends on the presence of the ccw device to which it
is tied. This means that the ccw device must not be released while the
dma memory is alive. We can use the approach in your patch here due to
the lifetime of the dma memory that virtio-ccw allocates when we start
using the device and frees when we stop using the device, or we can use
get/put with every allocate/release dma memory pair, which should be
safe for everyone?

