Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC0F33E017
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 22:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhCPVNh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 17:13:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231460AbhCPVNP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 17:13:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615929194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mdowvEkJ8P/U6Lm1Fbd74yNjySwIfdTY6FFlx2Kgs+o=;
        b=JYlG/rhmvENVb8YpmzmEu0VahkmfGDN8uYCq2Mip6w7zepV7CXVcFm21MNFNedbsgAQ1A/
        GRPZBI5EQqvMsRj9LH8Z7vVTlDYKhfuitn4vnm034bFADX6iDjwAoStuYq04itQZFPNRYF
        WWiPDqRmRg+k3S3IYjWrs41MkeNbtA4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-1wpZkmmNOuWkvUVdSIdRzA-1; Tue, 16 Mar 2021 17:13:10 -0400
X-MC-Unique: 1wpZkmmNOuWkvUVdSIdRzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E38E760C4;
        Tue, 16 Mar 2021 21:13:07 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 94CDB5D9DC;
        Tue, 16 Mar 2021 21:13:06 +0000 (UTC)
Date:   Tue, 16 Mar 2021 15:13:06 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 03/14] vfio: Split creation of a vfio_device into
 init and register ops
Message-ID: <20210316151306.3829ef82@omen.home.shazbot.org>
In-Reply-To: <20210316132559.6e6bc79a.cohuck@redhat.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <3-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <20210316132559.6e6bc79a.cohuck@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Mar 2021 13:25:59 +0100
Cornelia Huck <cohuck@redhat.com> wrote:

> On Fri, 12 Mar 2021 20:55:55 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > This makes the struct vfio_pci_device part of the public interface so it

s/_pci//

> > can be used with container_of and so forth, as is typical for a Linux
> > subystem.
> > 
> > This is the first step to bring some type-safety to the vfio interface by
> > allowing the replacement of 'void *' and 'struct device *' inputs with a
> > simple and clear 'struct vfio_pci_device *'

s/_pci//

> > 
> > For now the self-allocating vfio_add_group_dev() interface is kept so each
> > user can be updated as a separate patch.
> > 
> > The expected usage pattern is
> > 
> >   driver core probe() function:
> >      my_device = kzalloc(sizeof(*mydevice));
> >      vfio_init_group_dev(&my_device->vdev, dev, ops, mydevice);
> >      /* other driver specific prep */
> >      vfio_register_group_dev(&my_device->vdev);
> >      dev_set_drvdata(my_device);
> > 
> >   driver core remove() function:
> >      my_device = dev_get_drvdata(dev);
> >      vfio_unregister_group_dev(&my_device->vdev);
> >      /* other driver specific tear down */
> >      kfree(my_device);
> > 
> > Allowing the driver to be able to use the drvdata and vifo_device to go  
> 
> s/vifo_device/vfio_device/
> 
> > to/from its own data.
> > 
> > The pattern also makes it clear that vfio_register_group_dev() must be
> > last in the sequence, as once it is called the core code can immediately
> > start calling ops. The init/register gap is provided to allow for the
> > driver to do setup before ops can be called and thus avoid races.
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  Documentation/driver-api/vfio.rst |  31 ++++----
> >  drivers/vfio/vfio.c               | 123 ++++++++++++++++--------------
> >  include/linux/vfio.h              |  16 ++++
> >  3 files changed, 98 insertions(+), 72 deletions(-)
> > 
> > diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> > index f1a4d3c3ba0bb1..d3a02300913a7f 100644
> > --- a/Documentation/driver-api/vfio.rst
> > +++ b/Documentation/driver-api/vfio.rst
> > @@ -249,18 +249,23 @@ VFIO bus driver API
> >  
> >  VFIO bus drivers, such as vfio-pci make use of only a few interfaces
> >  into VFIO core.  When devices are bound and unbound to the driver,
> > -the driver should call vfio_add_group_dev() and vfio_del_group_dev()
> > -respectively::
> > -
> > -	extern int vfio_add_group_dev(struct device *dev,
> > -				      const struct vfio_device_ops *ops,
> > -				      void *device_data);
> > -
> > -	extern void *vfio_del_group_dev(struct device *dev);
> > -
> > -vfio_add_group_dev() indicates to the core to begin tracking the
> > -iommu_group of the specified dev and register the dev as owned by
> > -a VFIO bus driver.  The driver provides an ops structure for callbacks
> > +the driver should call vfio_register_group_dev() and
> > +vfio_unregister_group_dev() respectively::
> > +
> > +	void vfio_init_group_dev(struct vfio_device *device,
> > +				struct device *dev,
> > +				const struct vfio_device_ops *ops,
> > +				void *device_data);
> > +	int vfio_register_group_dev(struct vfio_device *device);
> > +	void vfio_unregister_group_dev(struct vfio_device *device);
> > +
> > +The driver should embed the vfio_device in its own structure and call
> > +vfio_init_group_dev() to pre-configure it before going to registration.  
> 
> s/it/that structure/ (I guess?)

Seems less clear actually, is the object of "that structure" the
"vfio_device" or "its own structure".  Phrasing somewhat suggests the
latter.  s/it/the vfio_device structure/ seems excessively verbose.  I
think "it" is probably sufficient here.  Thanks,

Alex

 
> > +vfio_register_group_dev() indicates to the core to begin tracking the
> > +iommu_group of the specified dev and register the dev as owned by a VFIO bus
> > +driver. Once vfio_register_group_dev() returns it is possible for userspace to
> > +start accessing the driver, thus the driver should ensure it is completely
> > +ready before calling it. The driver provides an ops structure for callbacks
> >  similar to a file operations structure::
> >  
> >  	struct vfio_device_ops {  
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

