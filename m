Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499EC30A7B6
	for <lists+kvm@lfdr.de>; Mon,  1 Feb 2021 13:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhBAMgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Feb 2021 07:36:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbhBAMgT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Feb 2021 07:36:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612182892;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cBf4pU0yhonUe/A/Ug+skhbGlNPdOQ4PTTb8R0T6PjI=;
        b=fd/JTgC1oLgwQHIYCBLlkXX2QyuGEoWEV22ZjPGDYCGXw1Qpa+m+ZjZ/r+/8IeLowJwEjk
        A0zE9/BEN6kTTq3DybZlCVea+SNkHZJL7J4UYGGywUhdGZj1a8h7CKcBrvjrmN+hDM+0Y5
        N1+BmfnQiAQpSfk4f5nbUtaCHPkd7sc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-rhsUc5ZuOLOO2u1-MlVZBg-1; Mon, 01 Feb 2021 07:34:50 -0500
X-MC-Unique: rhsUc5ZuOLOO2u1-MlVZBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7D75B192FDAA;
        Mon,  1 Feb 2021 12:34:49 +0000 (UTC)
Received: from gondolin (ovpn-113-126.ams2.redhat.com [10.36.113.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31C241F6;
        Mon,  1 Feb 2021 12:34:44 +0000 (UTC)
Date:   Mon, 1 Feb 2021 13:34:40 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH V3 7/9] vfio: iommu driver notify callback
Message-ID: <20210201133440.001850f4.cohuck@redhat.com>
In-Reply-To: <b3260683-7c45-4648-3b4b-3c81fb5ff5f7@oracle.com>
References: <1611939252-7240-1-git-send-email-steven.sistare@oracle.com>
        <1611939252-7240-8-git-send-email-steven.sistare@oracle.com>
        <20210129145719.1b6cbe9c@omen.home.shazbot.org>
        <b3260683-7c45-4648-3b4b-3c81fb5ff5f7@oracle.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 30 Jan 2021 11:51:41 -0500
Steven Sistare <steven.sistare@oracle.com> wrote:

> On 1/29/2021 4:57 PM, Alex Williamson wrote:
> > On Fri, 29 Jan 2021 08:54:10 -0800
> > Steve Sistare <steven.sistare@oracle.com> wrote:
> >   
> >> Define a vfio_iommu_driver_ops notify callback, for sending events to
> >> the driver.  Drivers are not required to provide the callback, and
> >> may ignore any events.  The handling of events is driver specific.
> >>
> >> Define the CONTAINER_CLOSE event, called when the container's file
> >> descriptor is closed.  This event signifies that no further state changes
> >> will occur via container ioctl's.
> >>
> >> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >> ---
> >>  drivers/vfio/vfio.c  | 5 +++++
> >>  include/linux/vfio.h | 5 +++++
> >>  2 files changed, 10 insertions(+)
> >>
> >> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> >> index 262ab0e..99458fc 100644
> >> --- a/drivers/vfio/vfio.c
> >> +++ b/drivers/vfio/vfio.c
> >> @@ -1220,6 +1220,11 @@ static int vfio_fops_open(struct inode *inode, struct file *filep)
> >>  static int vfio_fops_release(struct inode *inode, struct file *filep)
> >>  {
> >>  	struct vfio_container *container = filep->private_data;
> >> +	struct vfio_iommu_driver *driver = container->iommu_driver;
> >> +
> >> +	if (driver && driver->ops->notify)
> >> +		driver->ops->notify(container->iommu_data,
> >> +				    VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE, NULL);
> >>  
> >>  	filep->private_data = NULL;
> >>  
> >> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> >> index 38d3c6a..9642579 100644
> >> --- a/include/linux/vfio.h
> >> +++ b/include/linux/vfio.h
> >> @@ -57,6 +57,9 @@ extern int vfio_add_group_dev(struct device *dev,
> >>  extern void vfio_device_put(struct vfio_device *device);
> >>  extern void *vfio_device_data(struct vfio_device *device);
> >>  
> >> +/* events for the backend driver notify callback */
> >> +#define VFIO_DRIVER_NOTIFY_CONTAINER_CLOSE	1  
> > 
> > We should use an enum for type checking.  
> 
> Agreed.
> I see you changed the value to 0.  Do you want to reserve 0 for invalid-event?
> (I know, this is internal and can be changed).  Your call.

I'm not sure what we would use an invalid-event event for... the type
checking provided by the enum should be enough?

> 
> >> +
> >>  /**
> >>   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
> >>   */
> >> @@ -90,6 +93,8 @@ struct vfio_iommu_driver_ops {
> >>  					       struct notifier_block *nb);
> >>  	int		(*dma_rw)(void *iommu_data, dma_addr_t user_iova,
> >>  				  void *data, size_t count, bool write);
> >> +	void		(*notify)(void *iommu_data, unsigned int event,
> >> +				  void *data);  
> > 
> > I'm not sure why we're pre-enabling this 3rd arg, do you have some
> > short term usage in mind that we can't easily add on demand later?
> > This is an internal API, not one we need to keep stable.  Thanks,  
> 
> No short term need, just seems sensible for an event callback.  I was mimic'ing the 
> signature of the callback for vfio_register_notifier. Your call.

I'd drop *data for now, if we don't have a concrete use case.

> 
> - Steve
> 
> > 
> > Alex
> >   
> >>  };
> >>  
> >>  extern int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);  
> >   
> 

