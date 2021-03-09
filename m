Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9510F332ADE
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 16:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231604AbhCIPp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 10:45:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:52569 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231673AbhCIPpW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 10:45:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615304722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Te+OQSjfv0vY3+sUjOA7y5iasOCiA3WZDlj3UlBzKPY=;
        b=GJRSgDJKKKWxnnbc/ItFQWPzB7uBEceHeHZ3VdBw0pR8MWthpUW2OX+h/e0ZxIbl6nkDpc
        6fiSRxcunhwcip0MLtw2CCV9PcCu/3b/Q4ohKDfupkogb+FpOfuSVvmshQBlqSJR1QY9PE
        E+9et82nxntf6QzoTFe+u3cXTkGGFuM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-598-MuAluCWHM1O_fwqQeQ4KXg-1; Tue, 09 Mar 2021 10:45:18 -0500
X-MC-Unique: MuAluCWHM1O_fwqQeQ4KXg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D75510866A0;
        Tue,  9 Mar 2021 15:45:17 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7EEB75D9CD;
        Tue,  9 Mar 2021 15:45:13 +0000 (UTC)
Date:   Tue, 9 Mar 2021 08:45:13 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH v1 07/14] vfio: Add a device notifier interface
Message-ID: <20210309084513.51fd2a97@x1.home.shazbot.org>
In-Reply-To: <20210309004627.GD4247@nvidia.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
        <161524010999.3480.14282676267275402685.stgit@gimli.home>
        <20210309004627.GD4247@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 8 Mar 2021 20:46:27 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Mar 08, 2021 at 02:48:30PM -0700, Alex Williamson wrote:
> > Using a vfio device, a notifier block can be registered to receive
> > select device events.  Notifiers can only be registered for contained
> > devices, ie. they are available through a user context.  Registration
> > of a notifier increments the reference to that container context
> > therefore notifiers must minimally respond to the release event by
> > asynchronously removing notifiers.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >  drivers/vfio/Kconfig |    1 +
> >  drivers/vfio/vfio.c  |   35 +++++++++++++++++++++++++++++++++++
> >  include/linux/vfio.h |    9 +++++++++
> >  3 files changed, 45 insertions(+)
> > 
> > diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> > index 90c0525b1e0c..9a67675c9b6c 100644
> > +++ b/drivers/vfio/Kconfig
> > @@ -23,6 +23,7 @@ menuconfig VFIO
> >  	tristate "VFIO Non-Privileged userspace driver framework"
> >  	select IOMMU_API
> >  	select VFIO_IOMMU_TYPE1 if (X86 || S390 || ARM || ARM64)
> > +	select SRCU
> >  	help
> >  	  VFIO provides a framework for secure userspace device drivers.
> >  	  See Documentation/driver-api/vfio.rst for more details.
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index c47895539a1a..7f6d00e54e83 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -105,6 +105,7 @@ struct vfio_device {
> >  	struct list_head		group_next;
> >  	void				*device_data;
> >  	struct inode			*inode;
> > +	struct srcu_notifier_head	notifier;
> >  };
> >  
> >  #ifdef CONFIG_VFIO_NOIOMMU
> > @@ -601,6 +602,7 @@ struct vfio_device *vfio_group_create_device(struct vfio_group *group,
> >  	device->ops = ops;
> >  	device->device_data = device_data;
> >  	dev_set_drvdata(dev, device);
> > +	srcu_init_notifier_head(&device->notifier);
> >  
> >  	/* No need to get group_lock, caller has group reference */
> >  	vfio_group_get(group);
> > @@ -1785,6 +1787,39 @@ static const struct file_operations vfio_device_fops = {
> >  	.mmap		= vfio_device_fops_mmap,
> >  };
> >  
> > +int vfio_device_register_notifier(struct vfio_device *device,
> > +				  struct notifier_block *nb)
> > +{
> > +	int ret;
> > +
> > +	/* Container ref persists until unregister on success */
> > +	ret =  vfio_group_add_container_user(device->group);  
> 
> I'm having trouble guessing why we need to refcount the group to add a
> notifier to the device's notifier chain? 
> 
> I suppose it actually has to do with the MMIO mapping? But I don't
> know what the relation is between MMIO mappings in the IOMMU and the
> container? This could deserve a comment?

Sure, I can add a comment.  We want to make sure the device remains
within an IOMMU context so long as we have a DMA mapping to the device
MMIO, which could potentially manipulate the device.  IOMMU context is
managed a the group level.
 
> > +void vfio_device_unregister_notifier(struct vfio_device *device,
> > +				    struct notifier_block *nb)
> > +{
> > +	if (!srcu_notifier_chain_unregister(&device->notifier, nb))
> > +		vfio_group_try_dissolve_container(device->group);
> > +}
> > +EXPORT_SYMBOL_GPL(vfio_device_unregister_notifier);  
> 
> Is the SRCU still needed with the new locking? With a cursory look I
> only noticed this called under the reflck->lock ?

When registering the notifier, the iommu->lock is held.  During the
callback, the same lock is acquired, so we'd have AB-BA otherwise.
Thanks,

Alex

