Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32C336E9E0
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 13:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhD2L74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 07:59:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233643AbhD2L7z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 07:59:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619697548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qk+Z523FZXAJhd7+e1hz9bUYPc0iQ4gL6t75sH996V0=;
        b=UIyI84YURfY24HWv/bwKx/Buc+swvwE0iZU12xbPhkn1GirMsqNFH8DhKPK+vZpJmWaKDU
        u0FpqxMDeRd1YBhq9Jsjloz9iskB9u9WH3bP4gWP5shFP4+6N8tKZQ4b3wEZ9tahgoDbNa
        fPs0pYSJGgQGIpuZ12LxEnxXI4j+xow=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-pGXuF9rLMbyZRC1IOhWJwg-1; Thu, 29 Apr 2021 07:59:04 -0400
X-MC-Unique: pGXuF9rLMbyZRC1IOhWJwg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A54E019253C5;
        Thu, 29 Apr 2021 11:59:01 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-129.ams2.redhat.com [10.36.113.129])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0032710016FE;
        Thu, 29 Apr 2021 11:58:57 +0000 (UTC)
Date:   Thu, 29 Apr 2021 13:58:55 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Eric Farman <farman@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
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
Message-ID: <20210429135855.443b7a1b.cohuck@redhat.com>
In-Reply-To: <20210428172008.GV1370958@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
        <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
        <20210428190949.4360afb7.cohuck@redhat.com>
        <20210428172008.GV1370958@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 28 Apr 2021 14:20:08 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Apr 28, 2021 at 07:09:49PM +0200, Cornelia Huck wrote:
> > On Mon, 26 Apr 2021 17:00:09 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > This is more complicated because vfio_ccw is sharing the vfio_device
> > > between both the mdev_device and its vfio_device and the css_driver.
> > > 
> > > The mdev is a singleton, and the reason for this sharing appears to be to
> > > allow the extra css_driver function callbacks to be delivered to the
> > > vfio_device.
> > > 
> > > This keeps things as they were, with the css_driver allocating the
> > > singleton, not the mdev_driver, this is pretty confusing. I'm also
> > > uncertain how the lifetime model for the mdev works in the css_driver
> > > callbacks.
> > > 
> > > At this point embed the vfio_device in the vfio_ccw_private and
> > > instantiate it as a vfio_device when the mdev probes. The drvdata of both
> > > the css_device and the mdev_device point at the private, and container_of
> > > is used to get it back from the vfio_device.  
> > 
> > I've been staring at this for some time, and I'm not sure whether this
> > is a good approach.
> > 
> > We allow at most one mdev per subchannel (slicing it up does not make
> > sense), so we can be sure that there's a 1:1 relationship between mdev
> > and parent device, and we can track it via a single pointer.  
> 
> This seems like one of these cases where using the mdev GUID API was not a
> great fit. The ccs_driver should have just directly created a
> vfio_device and not gone into the mdev guid lifecycle world.

I don't remember much of the discussion back then, but I don't think
the explicit generation of devices was the part we needed, but rather
some other kind of mediation -- probably iommu related, as subchannels
don't have that concept on their own. Anyway, too late to change now.

> 
> > The vfio_ccw_private driver data is allocated during probe (same as for
> > other css_drivers.) Embedding a vfio_device here means that we have a
> > structure tied into it that is operating with different lifetime rules.
> > 
> > What about creating a second structure instead that can embed the
> > vfio_device, is allocated during mdev probing, and is linked up with
> > the vfio_ccw_private structure? That would follow the pattern of other
> > drivers more closely.  
> 
> IIRC we still end up with pointers crossing between the two
> structs. If you can't convince yourself that is correct (and I could
> not) then it is already buggy today.
> 
> It is as I said to Eric, either there is no concurrency when there is
> no mdev and everything is correct today, or there is concurrency and
> it seems buggy today too.
> 
> The right answer it to move the allocations out of the css_driver
> probe and put them only in the mdev driver probe because they can only
> make sense when the mdev driver is instantiated. Then everything is
> clear and very understandable how it should work.
> 
> I almost did this, but couldn't figure out how the lifetime of the
> ccs_driver callbacks are working relative to the lifetime of the mdev
> device since they also reach into these structs. Maybe they can't be
> called for some css related reason?

Moving allocations to the mdev driver probe makes sense, I guess. We
should also move enabling the subchannel to that point in time (I don't
remember why we enable it in the css probe function, and can't think of
a good reason for that; obviously needs to be paired with quiescing and
disabling the subchannel in the mdev driver remove function); that
leaves the uevent dance (which can hopefully also be removed, if some
discussed changes are implemented in the common I/O layer) and fencing
QDIO.

Regarding the other callbacks,
- vfio_ccw_sch_irq should not be invoked if the subchannel is not
  enabled; maybe log a message before returning for !private.
- vfio_ccw_sch_remove should be able to return 0 for !private (nothing
  to quiesce, if the subchannel is not enabled).
- vfio_ccw_sch_shutdown has nothing to do for !private (same reason.)
- In vfio_ccw_sch_event, we should either skip the fsm_event and the
  state change for !private, or return 0 in that case.
- vfio_ccw_chp_event already checks for !private. Not sure whether we
  should try to update some control blocks and return -ENODEV if the
  subchannel is not operational, but it's probably not needed.

Eric, what do you think?

