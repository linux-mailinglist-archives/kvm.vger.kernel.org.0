Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0B736FA4B
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbhD3Mcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:32:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232217AbhD3Mcl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Apr 2021 08:32:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619785913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yvMuorDlscxiG4i5zcw7FhUWWnKbz+SwE2UUQvhUPv0=;
        b=bLYT2j1qOzK+3kmrlw8DcZ/2HcIKaCpWLSwl/2QmI5PZZrNuMHC08Xam8EXwGHO+z4flsn
        y+eyT50toqaMQfzELScqFrlrqxZWv0K4/JtM+uLNCzJH8J5CvYhYLD3BHamZHAl9G189Mh
        p/NE3hcGER++I9rqsKfQwXTs5peXfSo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-k6qVaeEHOEyiK_-rRS7uBw-1; Fri, 30 Apr 2021 08:31:49 -0400
X-MC-Unique: k6qVaeEHOEyiK_-rRS7uBw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD4E51008060;
        Fri, 30 Apr 2021 12:31:46 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-220.ams2.redhat.com [10.36.113.220])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 538C370580;
        Fri, 30 Apr 2021 12:31:43 +0000 (UTC)
Date:   Fri, 30 Apr 2021 14:31:40 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 07/13] vfio/ccw: Convert to use
 vfio_register_group_dev()
Message-ID: <20210430143140.378904bf.cohuck@redhat.com>
In-Reply-To: <20210429181347.GA3414759@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
        <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
        <20210428190949.4360afb7.cohuck@redhat.com>
        <20210428172008.GV1370958@nvidia.com>
        <20210429135855.443b7a1b.cohuck@redhat.com>
        <20210429181347.GA3414759@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Apr 2021 15:13:47 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Apr 29, 2021 at 01:58:55PM +0200, Cornelia Huck wrote:
> 
> > > This seems like one of these cases where using the mdev GUID API
> > > was not a great fit. The ccs_driver should have just directly
> > > created a vfio_device and not gone into the mdev guid lifecycle
> > > world.  
> > 
> > I don't remember much of the discussion back then, but I don't think
> > the explicit generation of devices was the part we needed, but rather
> > some other kind of mediation -- probably iommu related, as subchannels
> > don't have that concept on their own. Anyway, too late to change now.  
> 
> The mdev part does three significant things:
>  - Provide a lifecycle model based on sysfs and the GUIDs
>  - Hackily inject itself into the VFIO IOMMU code as a special case
>  - Force the creation of a unique iommu group as the group FD is
>    mandatory to get the device FD.
> 
> This is why PASID is such a mess for mdev because it requires even
> more special hacky stuff to link up the dummy IOMMU but still operate
> within the iommu group of the parent device.
> 
> I can see an alternative arrangement using the /dev/ioasid idea that
> is a lot less hacky and does not force the mdev guid lifecycle on
> everyone that wants to create vfio_device.

I have not followed that discussion -- do you have a summary or a
pointer?

> 
> > > I almost did this, but couldn't figure out how the lifetime of the
> > > ccs_driver callbacks are working relative to the lifetime of the mdev
> > > device since they also reach into these structs. Maybe they can't be
> > > called for some css related reason?  
> > 
> > Moving allocations to the mdev driver probe makes sense, I guess. We
> > should also move enabling the subchannel to that point in time (I don't
> > remember why we enable it in the css probe function, and can't think of
> > a good reason for that; obviously needs to be paired with quiescing and
> > disabling the subchannel in the mdev driver remove function); that
> > leaves the uevent dance (which can hopefully also be removed, if some
> > discussed changes are implemented in the common I/O layer) and fencing
> > QDIO.
> > 
> > Regarding the other callbacks,
> > - vfio_ccw_sch_irq should not be invoked if the subchannel is not
> >   enabled; maybe log a message before returning for !private.
> > - vfio_ccw_sch_remove should be able to return 0 for !private (nothing
> >   to quiesce, if the subchannel is not enabled).
> > - vfio_ccw_sch_shutdown has nothing to do for !private (same reason.)
> > - In vfio_ccw_sch_event, we should either skip the fsm_event and the
> >   state change for !private, or return 0 in that case.
> > - vfio_ccw_chp_event already checks for !private. Not sure whether we
> >   should try to update some control blocks and return -ENODEV if the
> >   subchannel is not operational, but it's probably not needed.  
> 
> All the checks for !private need some kind of locking. The driver core
> model is that the 'struct device_driver' callbacks are all called
> under the device_lock (this prevents the driver unbinding during the
> callback). I didn't check if ccs does this or not..

probe/remove/shutdown are basically a forward of the callbacks at the
bus level. The css bus should make sure that we serialize
irq/sch_event/chp_event with probe/remove.

> 
> So if we NULL drvdata under the device_lock everything can be
> quite simple here.
> 
> Jason
> 

