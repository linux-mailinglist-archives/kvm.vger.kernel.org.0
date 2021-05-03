Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C0A3713DD
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 12:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbhECKzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 06:55:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233247AbhECKzq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 06:55:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620039292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y3t+kPfLjNDbkhI03RIcjqpeyYZyaL5l/wCZp6xDiZo=;
        b=NNdNqMIZGn8tvhyFGp6OS0sbuP6DVtiVeOPNpemL+aySSTZd230mFhIMu/AkwV4QfUsNzL
        f7M4KseD89kUthGRT2GkhMs209MxdORJYqYnCWDI5s9JOKlAYWYbIfdM4O8bNcQe8n8qYj
        TYOXi09k1e/CKAJkTA0GyddvVJ0nlQA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-74LuuizoOG2gCKOmN6aoUw-1; Mon, 03 May 2021 06:54:49 -0400
X-MC-Unique: 74LuuizoOG2gCKOmN6aoUw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B450061245;
        Mon,  3 May 2021 10:54:46 +0000 (UTC)
Received: from gondolin.fritz.box (ovpn-113-109.ams2.redhat.com [10.36.113.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 265461064146;
        Mon,  3 May 2021 10:54:42 +0000 (UTC)
Date:   Mon, 3 May 2021 12:54:40 +0200
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
Subject: s390 common I/O layer locking (was: [PATCH v2 07/13] vfio/ccw:
 Convert to use vfio_register_group_dev())
Message-ID: <20210503125440.0acd7c1f.cohuck@redhat.com>
In-Reply-To: <20210430171908.GD1370958@nvidia.com>
References: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
        <7-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
        <20210428190949.4360afb7.cohuck@redhat.com>
        <20210428172008.GV1370958@nvidia.com>
        <20210429135855.443b7a1b.cohuck@redhat.com>
        <20210429181347.GA3414759@nvidia.com>
        <20210430143140.378904bf.cohuck@redhat.com>
        <20210430171908.GD1370958@nvidia.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 30 Apr 2021 14:19:08 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Apr 30, 2021 at 02:31:40PM +0200, Cornelia Huck wrote:
> > On Thu, 29 Apr 2021 15:13:47 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:

> > > All the checks for !private need some kind of locking. The driver core
> > > model is that the 'struct device_driver' callbacks are all called
> > > under the device_lock (this prevents the driver unbinding during the
> > > callback). I didn't check if ccs does this or not..  
> > 
> > probe/remove/shutdown are basically a forward of the callbacks at the
> > bus level.  
> 
> These are all covered by device_lock
> 
> > The css bus should make sure that we serialize
> > irq/sch_event/chp_event with probe/remove.  
> 
> Hum it doesn't look OK, like here:
> 
> css_process_crw()
>   css_evaluate_subchannel()
>    sch = bus_find_device()
>       -- So we have a refcount on the struct device
>    css_evaluate_known_subchannel() {
> 	if (sch->driver) {
> 		if (sch->driver->sch_event)
> 			ret = sch->driver->sch_event(sch, slow);
>    }
> 
> But the above call and touches to sch->driver (which is really just
> sch->dev.driver) are unlocked and racy.
> 
> I would hold the device_lock() over all touches to sch->driver outside
> of a driver core callback.

I think this issue did not come up much before, as most drivers on the
css bus tend to stay put during the lifetime of the device; but yes, it
seems we're missing some locking.

For the css bus, we need locking for the event callbacks; for irq, this
may interact with the subchannel lock and likely needs some care.

I also looked at the other busses in the common I/O layer: scm looks
good at a glance, ccwgroup and ccw have locking for online/offline; the
other callbacks for the ccw drivers probably need to take the device
lock as well.

Common I/O layer maintainers, does that look right?

