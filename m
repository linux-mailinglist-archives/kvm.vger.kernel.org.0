Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C5233E1B8
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 23:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbhCPWvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 18:51:46 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51152 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231649AbhCPWv3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Mar 2021 18:51:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615935089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BZZL8GLTNEL+TW4bhw3sQUcfDjmWLE2CRzi88LDEvEk=;
        b=PF3tSs8y3Ih7b6mM3yA0y+VIyafF9sg7MOdV1TkoefkAYEaa5E6TVLtqap5od4CO9qX0hC
        dWvVVc3OkU7LfCNxc7ZzrPy7PlGXJuno814422H10kvI/ywrGjRm/2l8N77VO2KrHQ/QST
        QFWVpZVGQJDFzzRtjTqRkzZ2FE2W0cg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-lNrcw9L5OK6FQcrQcvRfKA-1; Tue, 16 Mar 2021 18:51:24 -0400
X-MC-Unique: lNrcw9L5OK6FQcrQcvRfKA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D74D881744F;
        Tue, 16 Mar 2021 22:51:22 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0EAF85D9C0;
        Tue, 16 Mar 2021 22:51:22 +0000 (UTC)
Date:   Tue, 16 Mar 2021 16:51:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 10/14] vfio/mdev: Use
 vfio_init/register/unregister_group_dev
Message-ID: <20210316165121.3a51eade@omen.home.shazbot.org>
In-Reply-To: <MWHPR11MB18869E91B6DCC8A74A30E3B68C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <0-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <10-v2-20d933792272+4ff-vfio1_jgg@nvidia.com>
        <MWHPR11MB18869E91B6DCC8A74A30E3B68C6B9@MWHPR11MB1886.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 16 Mar 2021 08:09:19 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Saturday, March 13, 2021 8:56 AM
> > 
> > mdev gets little benefit because it doesn't actually do anything, however
> > it is the last user, so move the code here for now.  
> 
> and indicate that vfio_add/del_group_dev is removed in this patch.
> 
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Liu Yi L <yi.l.liu@intel.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/mdev/vfio_mdev.c | 24 +++++++++++++++++++--
> >  drivers/vfio/vfio.c           | 39 ++---------------------------------
> >  include/linux/vfio.h          |  5 -----
> >  3 files changed, 24 insertions(+), 44 deletions(-)
> > 
> > diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
> > index b52eea128549ee..4469aaf31b56cb 100644
> > --- a/drivers/vfio/mdev/vfio_mdev.c
> > +++ b/drivers/vfio/mdev/vfio_mdev.c
> > @@ -21,6 +21,10 @@
> >  #define DRIVER_AUTHOR   "NVIDIA Corporation"
> >  #define DRIVER_DESC     "VFIO based driver for Mediated device"
> > 
> > +struct mdev_vfio_device {
> > +	struct vfio_device vdev;
> > +};  
> 
> following other vfio_XXX_device convention, what about calling it
> vfio_mdev_device? otherwise,


Or, why actually create this structure at all?  _probe and _remove
could just use a vfio_device.  Thanks,

Alex

> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> 
> > +
> >  static int vfio_mdev_open(void *device_data)
> >  {
> >  	struct mdev_device *mdev = device_data;
> > @@ -124,13 +128,29 @@ static const struct vfio_device_ops
> > vfio_mdev_dev_ops = {
> >  static int vfio_mdev_probe(struct device *dev)
> >  {
> >  	struct mdev_device *mdev = to_mdev_device(dev);
> > +	struct mdev_vfio_device *mvdev;
> > +	int ret;
> > 
> > -	return vfio_add_group_dev(dev, &vfio_mdev_dev_ops, mdev);
> > +	mvdev = kzalloc(sizeof(*mvdev), GFP_KERNEL);
> > +	if (!mvdev)
> > +		return -ENOMEM;
> > +
> > +	vfio_init_group_dev(&mvdev->vdev, &mdev->dev,
> > &vfio_mdev_dev_ops, mdev);
> > +	ret = vfio_register_group_dev(&mvdev->vdev);
> > +	if (ret) {
> > +		kfree(mvdev);
> > +		return ret;
> > +	}
> > +	dev_set_drvdata(&mdev->dev, mvdev);
> > +	return 0;
> >  }
> > 
> >  static void vfio_mdev_remove(struct device *dev)
> >  {
> > -	vfio_del_group_dev(dev);
> > +	struct mdev_vfio_device *mvdev = dev_get_drvdata(dev);
> > +
> > +	vfio_unregister_group_dev(&mvdev->vdev);
> > +	kfree(mvdev);
> >  }
> > 
> >  static struct mdev_driver vfio_mdev_driver = {
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index cfa06ae3b9018b..2d6d7cc1d1ebf9 100644
> > --- a/drivers/vfio/vfio.c
> > +++ b/drivers/vfio/vfio.c
> > @@ -99,8 +99,8 @@
> > MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE,
> > no-IOMMU mode.  Thi
> >  /*
> >   * vfio_iommu_group_{get,put} are only intended for VFIO bus driver probe
> >   * and remove functions, any use cases other than acquiring the first
> > - * reference for the purpose of calling vfio_add_group_dev() or removing
> > - * that symmetric reference after vfio_del_group_dev() should use the raw
> > + * reference for the purpose of calling vfio_register_group_dev() or
> > removing
> > + * that symmetric reference after vfio_unregister_group_dev() should use
> > the raw
> >   * iommu_group_{get,put} functions.  In particular, vfio_iommu_group_put()
> >   * removes the device from the dummy group and cannot be nested.
> >   */
> > @@ -799,29 +799,6 @@ int vfio_register_group_dev(struct vfio_device
> > *device)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_register_group_dev);
> > 
> > -int vfio_add_group_dev(struct device *dev, const struct vfio_device_ops
> > *ops,
> > -		       void *device_data)
> > -{
> > -	struct vfio_device *device;
> > -	int ret;
> > -
> > -	device = kzalloc(sizeof(*device), GFP_KERNEL);
> > -	if (!device)
> > -		return -ENOMEM;
> > -
> > -	vfio_init_group_dev(device, dev, ops, device_data);
> > -	ret = vfio_register_group_dev(device);
> > -	if (ret)
> > -		goto err_kfree;
> > -	dev_set_drvdata(dev, device);
> > -	return 0;
> > -
> > -err_kfree:
> > -	kfree(device);
> > -	return ret;
> > -}
> > -EXPORT_SYMBOL_GPL(vfio_add_group_dev);
> > -
> >  /**
> >   * Get a reference to the vfio_device for a device.  Even if the
> >   * caller thinks they own the device, they could be racing with a
> > @@ -962,18 +939,6 @@ void vfio_unregister_group_dev(struct vfio_device
> > *device)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
> > 
> > -void *vfio_del_group_dev(struct device *dev)
> > -{
> > -	struct vfio_device *device = dev_get_drvdata(dev);
> > -	void *device_data = device->device_data;
> > -
> > -	vfio_unregister_group_dev(device);
> > -	dev_set_drvdata(dev, NULL);
> > -	kfree(device);
> > -	return device_data;
> > -}
> > -EXPORT_SYMBOL_GPL(vfio_del_group_dev);
> > -
> >  /**
> >   * VFIO base fd, /dev/vfio/vfio
> >   */
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index ad8b579d67d34a..4995faf51efeae 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -63,11 +63,6 @@ extern void vfio_iommu_group_put(struct
> > iommu_group *group, struct device *dev);
> >  void vfio_init_group_dev(struct vfio_device *device, struct device *dev,
> >  			 const struct vfio_device_ops *ops, void
> > *device_data);
> >  int vfio_register_group_dev(struct vfio_device *device);
> > -extern int vfio_add_group_dev(struct device *dev,
> > -			      const struct vfio_device_ops *ops,
> > -			      void *device_data);
> > -
> > -extern void *vfio_del_group_dev(struct device *dev);
> >  void vfio_unregister_group_dev(struct vfio_device *device);
> >  extern struct vfio_device *vfio_device_get_from_dev(struct device *dev);
> >  extern void vfio_device_put(struct vfio_device *device);
> > --
> > 2.30.2  
> 

