Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D2F41332A
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 14:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhIUMKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 08:10:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229984AbhIUMKs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 08:10:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632226159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uHvbv5slu5+j53B9OEnLfe2TjeQRn+fomR71sUrsq60=;
        b=ERcHmBcWPIKOm82/cOZeW31AQbxzgTseL2IxKBHP98tFkDBnj0x6H4If2hcr8q1OLkMZNF
        qniZrdQqgL70jb6QJ9pHHLY6r2112jcLE8H+SBVahpMLkgjCp7OIhXQeAb6ixWubAukSW5
        ICTE32ArmXUn7OIhMyYty6NQnvKbAzI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-uQX_74s2P16wtECi_TQcbA-1; Tue, 21 Sep 2021 08:09:18 -0400
X-MC-Unique: uQX_74s2P16wtECi_TQcbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B313101AFA9;
        Tue, 21 Sep 2021 12:09:17 +0000 (UTC)
Received: from localhost (unknown [10.39.194.88])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DD181972D;
        Tue, 21 Sep 2021 12:09:16 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfu@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio/s390: fix vritio-ccw device teardown
In-Reply-To: <20210921052548.4eea231f.pasic@linux.ibm.com>
Organization: Red Hat GmbH
References: <20210915215742.1793314-1-pasic@linux.ibm.com>
 <87pmt8hp5o.fsf@redhat.com> <20210916151835.4ab512b2.pasic@linux.ibm.com>
 <87mtobh9xn.fsf@redhat.com> <20210920003935.1369f9fe.pasic@linux.ibm.com>
 <88b514a4416cf72cda53a31ad2e15c13586350e4.camel@linux.ibm.com>
 <878rzrh86c.fsf@redhat.com> <20210921052548.4eea231f.pasic@linux.ibm.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Tue, 21 Sep 2021 14:09:14 +0200
Message-ID: <87r1dif7v9.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 21 2021, Halil Pasic <pasic@linux.ibm.com> wrote:

> On Mon, 20 Sep 2021 12:07:23 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> On Mon, Sep 20 2021, Vineeth Vijayan <vneethv@linux.ibm.com> wrote:
>> 
>> > On Mon, 2021-09-20 at 00:39 +0200, Halil Pasic wrote:  
>> >> On Fri, 17 Sep 2021 10:40:20 +0200
>> >> Cornelia Huck <cohuck@redhat.com> wrote:
>> >>   
>> > ...snip...  
>> >> > > 
>> >> > > Thanks, if I find time for it, I will try to understand this
>> >> > > better and
>> >> > > come back with my findings.
>> >> > >    
>> >> > > > > * Can virtio_ccw_remove() get called while !cdev->online and 
>> >> > > > >   virtio_ccw_online() is running on a different cpu? If yes,
>> >> > > > > what would
>> >> > > > >   happen then?      
>> >> > > > 
>> >> > > > All of the remove/online/... etc. callbacks are invoked via the
>> >> > > > ccw bus
>> >> > > > code. We have to trust that it gets it correct :) (Or have the
>> >> > > > common
>> >> > > > I/O layer maintainers double-check it.)
>> >> > > >     
>> >> > > 
>> >> > > Vineeth, what is your take on this? Are the struct ccw_driver
>> >> > > virtio_ccw_remove and the virtio_ccw_online callbacks mutually
>> >> > > exclusive. Please notice that we may initiate the onlining by
>> >> > > calling ccw_device_set_online() from a workqueue.
>> >> > > 
>> >> > > @Conny: I'm not sure what is your definition of 'it gets it
>> >> > > correct'...
>> >> > > I doubt CIO can make things 100% foolproof in this area.    
>> >> > 
>> >> > Not 100% foolproof, but "don't online a device that is in the
>> >> > progress
>> >> > of going away" seems pretty basic to me.
>> >> >   
>> >> 
>> >> I hope Vineeth will chime in on this.  
>> > Considering the online/offline processing, 
>> > The ccw_device_set_offline function or the online/offline is handled
>> > inside device_lock. Also, the online_store function takes care of
>> > avoiding multiple online/offline processing. 
>> >
>> > Now, when we consider the unconditional remove of the device,
>> > I am not familiar with the virtio_ccw driver. My assumptions are based
>> > on how CIO/dasd drivers works. If i understand correctly, the dasd
>> > driver sets different flags to make sure that a device_open is getting
>> > prevented while the the device is in progress of offline-ing.   
>> 
>> Hm, if we are invoking the online/offline callbacks under the device
>> lock already, 
>
> I believe we have a misunderstanding here. I believe that Vineeth is
> trying to tell us, that online_store_handle_offline() and
> online_store_handle_offline() are called under the a device lock of
> the ccw device. Right, Vineeth?
>
> Conny, I believe, by online/offline callbacks, you mean
> virtio_ccw_online() and virtio_ccw_offline(), right?

Whatever the common I/O layer invokes.

>
> But the thing is that virtio_ccw_online() may get called (and is
> typically called, AFAICT) with no locks held via:
> virtio_ccw_probe() --> async_schedule(virtio_ccw_auto_online, cdev)
> -*-> virtio_ccw_auto_online(cdev) --> ccw_device_set_online(cdev) -->
> virtio_ccw_online()

That's the common I/O layer in there again?

>
> Furthermore after a closer look, I believe because we don't take
> a reference to the cdev in probe, we may get virtio_ccw_auto_online()
> called with an invalid pointer (the pointer is guaranteed to be valid
> in probe, but because of async we have no guarantee that it will be
> called in the context of probe).
>
> Shouldn't we take a reference to the cdev in probe? BTW what is the
> reason for the async?

I don't know.

>
>
>> how would that affect the remove callback?
>
> I believe dev->bus->remove(dev) is called by 
> bus_remove_device() with the device lock held. I.e. I believe that means
> that virtio_ccw_remove() is called with the ccw devices device lock
> held. Vineeth can you confirm that?
>
>
> The thing is, both virtio_ccw_remove() and virtio_ccw_offline() are
> very similar, with the notable exception that offline assumes we are
> online() at the moment, while remove() does the same only if it
> decides based on vcdev && cdev->online that we are online.
>
>
>> Shouldn't they
>> be serialized under the device lock already? I think we are fine.
>
> AFAICT virtio_ccw_remove() and virtio_ccw_offline() are serialized
> against each other under the device lock. And also against
> virtio_ccw_online() iff it was initiated via the sysfs, and not via
> the auto-online mechanism.
>
> Thus I don't think we are fine at the moment.

I don't understand this, sorry.

>
>> 
>> For dasd, I think they also need to deal with the block device
>> lifetimes. For virtio-ccw, we are basically a transport that does not
>> know about devices further down the chain (that are associated with the
>> virtio device, whose lifetime is tied to online/offline processing.) I'd
>> presume that the serialization above would be enough.
>> 
>
> I don't know about dasd that much. For the reasons stated above, I don't
> think the serialization we have right now is entirely sufficient.

I'm not sure it makes sense to discuss this further right now, I feel I
currently can't really provide any meaningful contribution.

