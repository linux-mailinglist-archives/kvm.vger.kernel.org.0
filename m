Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE8D26DB49
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 14:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgIQMPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 08:15:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43287 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726819AbgIQMPW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 17 Sep 2020 08:15:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600344901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EP9WEZ46YHNtdW0HPtYLcHBIcBFzJYSz8/bOvDElUN4=;
        b=Msg5PtmIpowcwmZBGPSYoAYdwcPKiDuyUtKFG0olR/FxerbUI2Lh/g3wlHuJqMZXPpFCad
        8vI3bjUuqgdlPC8KPt3iLT7641adSJcCKJ4pXWzPOVwIwuoEAEF+vhPgtfNdYcaDKcgqCY
        l8Az6VHS1wcXl5Y/eUZ9BGzpSoOHaeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-239-5Tm4eSR-P1qnKjmrHrE4Rw-1; Thu, 17 Sep 2020 08:14:57 -0400
X-MC-Unique: 5Tm4eSR-P1qnKjmrHrE4Rw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 140D41084C81;
        Thu, 17 Sep 2020 12:14:55 +0000 (UTC)
Received: from gondolin (ovpn-113-19.ams2.redhat.com [10.36.113.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D24B75261;
        Thu, 17 Sep 2020 12:14:45 +0000 (UTC)
Date:   Thu, 17 Sep 2020 14:14:42 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v10 04/16] s390/zcrypt: driver callback to indicate
 resource in use
Message-ID: <20200917141442.6e531799.cohuck@redhat.com>
In-Reply-To: <fe3ba715-8ea7-45df-4144-d1f5dec38a45@linux.ibm.com>
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
        <20200821195616.13554-5-akrowiak@linux.ibm.com>
        <20200914172947.533ddf56.cohuck@redhat.com>
        <fe3ba715-8ea7-45df-4144-d1f5dec38a45@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Sep 2020 15:32:35 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 9/14/20 11:29 AM, Cornelia Huck wrote:
> > On Fri, 21 Aug 2020 15:56:04 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> Introduces a new driver callback to prevent a root user from unbinding
> >> an AP queue from its device driver if the queue is in use. The intent of
> >> this callback is to provide a driver with the means to prevent a root user
> >> from inadvertently taking a queue away from a matrix mdev and giving it to
> >> the host while it is assigned to the matrix mdev. The callback will
> >> be invoked whenever a change to the AP bus's sysfs apmask or aqmask
> >> attributes would result in one or more AP queues being removed from its
> >> driver. If the callback responds in the affirmative for any driver
> >> queried, the change to the apmask or aqmask will be rejected with a device
> >> in use error.
> >>
> >> For this patch, only non-default drivers will be queried. Currently,
> >> there is only one non-default driver, the vfio_ap device driver. The
> >> vfio_ap device driver facilitates pass-through of an AP queue to a
> >> guest. The idea here is that a guest may be administered by a different
> >> sysadmin than the host and we don't want AP resources to unexpectedly
> >> disappear from a guest's AP configuration (i.e., adapters, domains and
> >> control domains assigned to the matrix mdev). This will enforce the proper
> >> procedure for removing AP resources intended for guest usage which is to
> >> first unassign them from the matrix mdev, then unbind them from the
> >> vfio_ap device driver.
> >>
> >> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> >> Reported-by: kernel test robot <lkp@intel.com>  
> > This looks a bit odd...  
> 
> I've removed all of those. These kernel test robot errors were flagged
> in the last series. The review comments from the robot suggested
> the reported-by, but I assume that was for patches intended to
> fix those errors, so I am removing these as per Christian's comments.

Yes, I think the Reported-by: mostly makes sense if you include a patch
to fix something on top.

> 
> >  
> >> ---
> >>   drivers/s390/crypto/ap_bus.c | 148 ++++++++++++++++++++++++++++++++---
> >>   drivers/s390/crypto/ap_bus.h |   4 +
> >>   2 files changed, 142 insertions(+), 10 deletions(-)
> >>  
> > (...)
> >  
> >> @@ -1107,12 +1118,70 @@ static ssize_t apmask_show(struct bus_type *bus, char *buf)
> >>   	return rc;
> >>   }
> >>   
> >> +static int __verify_card_reservations(struct device_driver *drv, void *data)
> >> +{
> >> +	int rc = 0;
> >> +	struct ap_driver *ap_drv = to_ap_drv(drv);
> >> +	unsigned long *newapm = (unsigned long *)data;
> >> +
> >> +	/*
> >> +	 * No need to verify whether the driver is using the queues if it is the
> >> +	 * default driver.
> >> +	 */
> >> +	if (ap_drv->flags & AP_DRIVER_FLAG_DEFAULT)
> >> +		return 0;
> >> +
> >> +	/* The non-default driver's module must be loaded */
> >> +	if (!try_module_get(drv->owner))
> >> +		return 0;
> >> +
> >> +	if (ap_drv->in_use)
> >> +		if (ap_drv->in_use(newapm, ap_perms.aqm))
> >> +			rc = -EADDRINUSE;  
> > ISTR that Christian suggested -EBUSY in a past revision of this series?
> > I think that would be more appropriate.  
> 
> I went back and looked and sure enough, he did recommend that.
> You have a great memory! I didn't respond to that comment, so I
> must have missed it at the time.
> 
> I personally prefer EADDRINUSE because I think it is more indicative
> of the reason an AP resource can not be assigned back to the host
> drivers is because it is in use by a guest or, at the very least, reserved
> for use by a guest (i.e., assigned to an mdev). To say it is busy implies
> that the device is busy performing encryption services which may or
> may not be true at a given moment. Even if so, that is not the reason
> for refusing to allow reassignment of the device.

I have a different understanding of these error codes: EADDRINUSE is
something used in the networking context when an actual address is
already used elsewhere. EBUSY is more of a generic error that indicates
that a certain resource is not free to perform the requested operation;
it does not necessarily mean that the resource is currently actively
doing something. Kind of when you get EBUSY when trying to eject
something another program holds a reference on: that other program
might not actually be doing anything, but it potentially could.

