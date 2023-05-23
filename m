Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC88E70E109
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 17:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbjEWPwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 11:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237655AbjEWPwQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 11:52:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B33132
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 08:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684857088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ffFlRnxDhkqavn7yvdBgJwj9RUS/Xk0FK9gf/ckanJU=;
        b=eOEuH9UoUuGcHTQVruF/SO/jgN2WnFSbkaN07rbetRQj72Ds8eZuiLcNzabCgV2yODjI2E
        dsC7MxWti/YKYcW1rqh83gE/VGJRwwLN5TCt23WaEclceVnhw8bMlyeMSS8oJmGw1JAwlF
        kqUMrxCHmhYwJS/fX52M5QwKHlkAa8Y=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-aRklALDLOW6aQFxSeOD45g-1; Tue, 23 May 2023 11:51:26 -0400
X-MC-Unique: aRklALDLOW6aQFxSeOD45g-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7748b05ab49so27467839f.1
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 08:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684857084; x=1687449084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffFlRnxDhkqavn7yvdBgJwj9RUS/Xk0FK9gf/ckanJU=;
        b=HqK1dbY7TwOA8nJq9xpGGLFqhDd+A17bOhuy5uCH0oOV7g1lQMg23jGmdxtPMiRVkL
         MW3ZGXuMg9T506eAeFoNe+xW3iQDXEDaf+zKNqxwkIdKsB3+o7ggnBkbjfcrmvjzo+P0
         TShiplZnWJvvPkP8F8h/vQZm73bOLalv5pPGwpHn/8PB0xlcnXTvOXILJ/dkUO4rx7IM
         GScDjXcMZMkyTdsU1aHYkxTnPqvu/bwu2vQ7D2jc3VghZAR2dqB9S3DJokTQ8ufWAsNR
         8g1Ah0oIlIZIQHpJu67S98o+JcVTb6+tuU6gVB+QD/1q7l/ytQkz2E13Ib/i3a6AezX+
         gGfw==
X-Gm-Message-State: AC+VfDyS9GBMKd+aSL7BoQhzuumuuf2ASsoTG/pjBFK/uasFfFx78XlL
        cMfuR43CX8+sPx6aw6zVPqK0pzhkCX99QjwOp2Nz/LNfyPgPJMVflNE571yrg4odxsTc6s/ohU9
        XGqFHGMJS/nJ4
X-Received: by 2002:a6b:db04:0:b0:76f:f462:34d2 with SMTP id t4-20020a6bdb04000000b0076ff46234d2mr9680011ioc.14.1684857083883;
        Tue, 23 May 2023 08:51:23 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4s2oY12m90VVYTK9dxF+HkSqm06XXvBX9tRE5XFoCNlD3yg24BUPg0oDodHHSqTpRLwPF3hg==
X-Received: by 2002:a6b:db04:0:b0:76f:f462:34d2 with SMTP id t4-20020a6bdb04000000b0076ff46234d2mr9680001ioc.14.1684857083536;
        Tue, 23 May 2023 08:51:23 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id h25-20020a056638063900b0040bbe6013d3sm2591376jar.141.2023.05.23.08.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 08:51:22 -0700 (PDT)
Date:   Tue, 23 May 2023 09:51:21 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v11 19/23] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20230523095121.1a7a255d.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB752935BF70AC95B564685DC0C3409@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-20-yi.l.liu@intel.com>
        <20230522160124.768430b4.alex.williamson@redhat.com>
        <DS0PR11MB752935BF70AC95B564685DC0C3409@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 23 May 2023 01:41:36 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, May 23, 2023 6:01 AM
> > 
> > On Sat, 13 May 2023 06:28:23 -0700
> > Yi Liu <yi.l.liu@intel.com> wrote:
> >   
> > > This adds ioctl for userspace to bind device cdev fd to iommufd.
> > >
> > >     VFIO_DEVICE_BIND_IOMMUFD: bind device to an iommufd, hence gain DMA
> > > 			      control provided by the iommufd. open_device
> > > 			      op is called after bind_iommufd op.
> > >
> > > Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> > > Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/device_cdev.c | 130 +++++++++++++++++++++++++++++++++++++
> > >  drivers/vfio/vfio.h        |  13 ++++
> > >  drivers/vfio/vfio_main.c   |   5 ++
> > >  include/linux/vfio.h       |   3 +-
> > >  include/uapi/linux/vfio.h  |  28 ++++++++
> > >  5 files changed, 178 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > > index 1c640016a824..291cc678a18b 100644
> > > --- a/drivers/vfio/device_cdev.c
> > > +++ b/drivers/vfio/device_cdev.c
> > > @@ -3,6 +3,7 @@
> > >   * Copyright (c) 2023 Intel Corporation.
> > >   */
> > >  #include <linux/vfio.h>
> > > +#include <linux/iommufd.h>
> > >
> > >  #include "vfio.h"
> > >
> > > @@ -44,6 +45,135 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct  
> > file *filep)  
> > >  	return ret;
> > >  }
> > >
> > > +static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
> > > +{
> > > +	spin_lock(&df->kvm_ref_lock);
> > > +	if (df->kvm)
> > > +		_vfio_device_get_kvm_safe(df->device, df->kvm);
> > > +	spin_unlock(&df->kvm_ref_lock);
> > > +}
> > > +
> > > +void vfio_device_cdev_close(struct vfio_device_file *df)
> > > +{
> > > +	struct vfio_device *device = df->device;
> > > +
> > > +	/*
> > > +	 * In the time of close, there is no contention with another one
> > > +	 * changing this flag.  So read df->access_granted without lock
> > > +	 * and no smp_load_acquire() is ok.
> > > +	 */
> > > +	if (!df->access_granted)
> > > +		return;
> > > +
> > > +	mutex_lock(&device->dev_set->lock);
> > > +	vfio_device_close(df);
> > > +	vfio_device_put_kvm(device);
> > > +	iommufd_ctx_put(df->iommufd);
> > > +	device->cdev_opened = false;
> > > +	mutex_unlock(&device->dev_set->lock);
> > > +	vfio_device_unblock_group(device);
> > > +}
> > > +
> > > +static struct iommufd_ctx *vfio_get_iommufd_from_fd(int fd)
> > > +{
> > > +	struct iommufd_ctx *iommufd;
> > > +	struct fd f;
> > > +
> > > +	f = fdget(fd);
> > > +	if (!f.file)
> > > +		return ERR_PTR(-EBADF);
> > > +
> > > +	iommufd = iommufd_ctx_from_file(f.file);
> > > +
> > > +	fdput(f);
> > > +	return iommufd;
> > > +}
> > > +
> > > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +				    struct vfio_device_bind_iommufd __user *arg)
> > > +{
> > > +	struct vfio_device *device = df->device;
> > > +	struct vfio_device_bind_iommufd bind;
> > > +	unsigned long minsz;
> > > +	int ret;
> > > +
> > > +	static_assert(__same_type(arg->out_devid, df->devid));
> > > +
> > > +	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
> > > +
> > > +	if (copy_from_user(&bind, arg, minsz))
> > > +		return -EFAULT;
> > > +
> > > +	if (bind.argsz < minsz || bind.flags || bind.iommufd < 0)
> > > +		return -EINVAL;
> > > +
> > > +	/* BIND_IOMMUFD only allowed for cdev fds */
> > > +	if (df->group)
> > > +		return -EINVAL;
> > > +
> > > +	if (vfio_device_is_noiommu(device) && !capable(CAP_SYS_RAWIO))
> > > +		return -EPERM;
> > > +
> > > +	ret = vfio_device_block_group(device);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	mutex_lock(&device->dev_set->lock);
> > > +	/* one device cannot be bound twice */
> > > +	if (df->access_granted) {
> > > +		ret = -EINVAL;
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	df->iommufd = vfio_get_iommufd_from_fd(bind.iommufd);
> > > +	if (IS_ERR(df->iommufd)) {
> > > +		ret = PTR_ERR(df->iommufd);
> > > +		df->iommufd = NULL;
> > > +		goto out_unlock;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Before the device open, get the KVM pointer currently
> > > +	 * associated with the device file (if there is) and obtain
> > > +	 * a reference.  This reference is held until device closed.
> > > +	 * Save the pointer in the device for use by drivers.
> > > +	 */
> > > +	vfio_device_get_kvm_safe(df);
> > > +
> > > +	ret = vfio_device_open(df);
> > > +	if (ret)
> > > +		goto out_put_kvm;
> > > +
> > > +	ret = copy_to_user(&arg->out_devid, &df->devid,
> > > +			   sizeof(df->devid)) ? -EFAULT : 0;
> > > +	if (ret)
> > > +		goto out_close_device;
> > > +
> > > +	/*
> > > +	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
> > > +	 * read/write/mmap
> > > +	 */
> > > +	smp_store_release(&df->access_granted, true);
> > > +	device->cdev_opened = true;
> > > +	mutex_unlock(&device->dev_set->lock);
> > > +
> > > +	if (vfio_device_is_noiommu(device))
> > > +		dev_warn(device->dev, "noiommu device is bound to iommufd by user  
> > "  
> > > +			 "(%s:%d)\n", current->comm, task_pid_nr(current));  
> > 
> > The noiommu kernel taint only happens in vfio_group_find_or_alloc(), so
> > how does noiommu taint the kernel when !CONFIG_VFIO_GROUP?  
> 
> Yeah, in the cdev path, no taint. I add this just in order to par with the below
> message in the group path.
> 
> vfio_device_open_file()
> {
> 	dev_warn(device->dev, "vfio-noiommu device opened by user "
> 		   "(%s:%d)\n", current->comm, task_pid_nr(current));
> }

There needs to be a taint when VFIO_GROUP is disabled.  Thanks,

Alex
 
> > > +	return 0;
> > > +
> > > +out_close_device:
> > > +	vfio_device_close(df);
> > > +out_put_kvm:
> > > +	vfio_device_put_kvm(device);
> > > +	iommufd_ctx_put(df->iommufd);
> > > +	df->iommufd = NULL;
> > > +out_unlock:
> > > +	mutex_unlock(&device->dev_set->lock);
> > > +	vfio_device_unblock_group(device);
> > > +	return ret;
> > > +}
> > > +
> > >  static char *vfio_device_devnode(const struct device *dev, umode_t *mode)
> > >  {
> > >  	return kasprintf(GFP_KERNEL, "vfio/devices/%s", dev_name(dev));
> > > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > > index 6861f8ebb64d..8b359a7794be 100644
> > > --- a/drivers/vfio/vfio.h
> > > +++ b/drivers/vfio/vfio.h
> > > @@ -279,6 +279,9 @@ static inline void vfio_device_del(struct vfio_device *device)
> > >
> > >  void vfio_init_device_cdev(struct vfio_device *device);
> > >  int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
> > > +void vfio_device_cdev_close(struct vfio_device_file *df);
> > > +long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +				    struct vfio_device_bind_iommufd __user *arg);
> > >  int vfio_cdev_init(struct class *device_class);
> > >  void vfio_cdev_cleanup(void);
> > >  #else
> > > @@ -302,6 +305,16 @@ static inline int vfio_device_fops_cdev_open(struct inode  
> > *inode,  
> > >  	return 0;
> > >  }
> > >
> > > +static inline void vfio_device_cdev_close(struct vfio_device_file *df)
> > > +{
> > > +}
> > > +
> > > +static inline long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +						  struct vfio_device_bind_iommufd  
> > __user *arg)  
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +
> > >  static inline int vfio_cdev_init(struct class *device_class)
> > >  {
> > >  	return 0;
> > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > index c87cc7afe92c..c9fa39ac4b02 100644
> > > --- a/drivers/vfio/vfio_main.c
> > > +++ b/drivers/vfio/vfio_main.c
> > > @@ -574,6 +574,8 @@ static int vfio_device_fops_release(struct inode *inode, struct  
> > file *filep)  
> > >
> > >  	if (df->group)
> > >  		vfio_device_group_close(df);
> > > +	else
> > > +		vfio_device_cdev_close(df);
> > >
> > >  	vfio_device_put_registration(device);
> > >
> > > @@ -1147,6 +1149,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
> > >  	struct vfio_device *device = df->device;
> > >  	int ret;
> > >
> > > +	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
> > > +		return vfio_device_ioctl_bind_iommufd(df, (void __user *)arg);
> > > +
> > >  	/* Paired with smp_store_release() following vfio_device_open() */
> > >  	if (!smp_load_acquire(&df->access_granted))
> > >  		return -EINVAL;
> > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > index 873275419f13..cf9d082a623c 100644
> > > --- a/include/linux/vfio.h
> > > +++ b/include/linux/vfio.h
> > > @@ -67,6 +67,7 @@ struct vfio_device {
> > >  	struct iommufd_device *iommufd_device;
> > >  	bool iommufd_attached;
> > >  #endif
> > > +	bool cdev_opened:1;
> > >  };
> > >
> > >  /**
> > > @@ -169,7 +170,7 @@ vfio_iommufd_physical_devid(struct vfio_device *vdev)
> > >
> > >  static inline bool vfio_device_cdev_opened(struct vfio_device *device)
> > >  {
> > > -	return false;
> > > +	return device->cdev_opened;
> > >  }
> > >
> > >  /**
> > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > index 24858b650562..07c917de31e9 100644
> > > --- a/include/uapi/linux/vfio.h
> > > +++ b/include/uapi/linux/vfio.h
> > > @@ -194,6 +194,34 @@ struct vfio_group_status {
> > >
> > >  /* --------------- IOCTLs for DEVICE file descriptors --------------- */
> > >
> > > +/*
> > > + * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 19,
> > > + *				   struct vfio_device_bind_iommufd)
> > > + *
> > > + * Bind a vfio_device to the specified iommufd.
> > > + *
> > > + * User is restricted from accessing the device before the binding operation
> > > + * is completed.
> > > + *
> > > + * Unbind is automatically conducted when device fd is closed.
> > > + *
> > > + * @argsz:	 User filled size of this data.
> > > + * @flags:	 Must be 0.
> > > + * @iommufd:	 iommufd to bind.
> > > + * @out_devid:	 The device id generated by this bind. devid is a handle for
> > > + *		 this device/iommufd bond and can be used in IOMMUFD commands.
> > > + *
> > > + * Return: 0 on success, -errno on failure.
> > > + */
> > > +struct vfio_device_bind_iommufd {
> > > +	__u32		argsz;
> > > +	__u32		flags;
> > > +	__s32		iommufd;
> > > +	__u32		out_devid;
> > > +};
> > > +
> > > +#define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
> > > +  
> > 
> > Why is this preempting the first device ioctl below rather than being
> > added in sequential order?  I'm also not sure what's at device ioctl 18
> > that we started at 19.  VFIO_DEVICE_FEATURE is at 17.  Yes, they're
> > hard to keep track of.  Thanks,  
> 
> yes, 17 is the last occupied ioctl offset on device fd. Will correct
> it.
> 
> Regards,
> Yi Liu
> 

