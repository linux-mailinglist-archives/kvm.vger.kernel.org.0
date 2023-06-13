Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26F1C72E591
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 16:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242589AbjFMOTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 10:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242430AbjFMOTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 10:19:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261C9A7
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686665899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f7+SABrVLI0amKNwNw1VarYFD9JfcbmTjrTnN+EtSAI=;
        b=iyYpmcBv6tMwfVphK+acAOhUM+uhEn0EXM40CKmsNw9Tj5ngoX9yzTp1z5YgR8vC9EgKEi
        uFV0TjrtkgRibz0j54dbLdpax0KEprkCPR0R+VcPvEHoyCBwDPqnewErOn5N658kEDYOlL
        5esY7pLmM12AhSMZIxG4rZqiJZkErJQ=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-D_JvAfWUMRW67BpmIx-gMw-1; Tue, 13 Jun 2023 10:18:16 -0400
X-MC-Unique: D_JvAfWUMRW67BpmIx-gMw-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-777acdd242eso760162439f.1
        for <kvm@vger.kernel.org>; Tue, 13 Jun 2023 07:18:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686665890; x=1689257890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f7+SABrVLI0amKNwNw1VarYFD9JfcbmTjrTnN+EtSAI=;
        b=QgRZglVPl2tPBV2C0SUMw7jFyx4CImPGfFTVq9uOfgbxdlx3y464gwxCvpMNM1ILOy
         pTzpBeHXPz/UMc2yJmq9l9FeVZSI6svYsH5o4rokDMzFCT9kkcHEjKjUWGB2HRPlPcCy
         ym0EGQwjbOnW82EDULuOvh69LVHWN287S9Mv6Fn+qxQvDNSxGj/Y1A0wO5dyxrYQWcXt
         3gXiMvIVZtdjP4tkvPABG+1qgtE5TX4pNkeMT/XYYlupwJfpWLsboyODRCWOiIMSlhiP
         EHi3TJ6emN7Ff2j8IKfPC7u6slTCFoipujlNpLNXm1NQPcTwb+HhlcEAjL1pIyUerL5D
         staQ==
X-Gm-Message-State: AC+VfDxbLeB1jNOFidzPUnWNAt5g+NUJ5h09Y9/rXaUxR+DbHHBRl3jF
        vGUxPhz/3cXGdzoDvLyXzO3ucJseubh1BAZlcPTVyUis4Vw8ClYsnOr93UIsvRhu4OWBu/gn45/
        TflwFZ+jufAi7
X-Received: by 2002:a6b:e602:0:b0:777:a8f0:1fc5 with SMTP id g2-20020a6be602000000b00777a8f01fc5mr10407457ioh.5.1686665890160;
        Tue, 13 Jun 2023 07:18:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Qxd5MF9xG9Y2ZhF+JHE0l7/i45VWWs07LUNcJeZBnEYj9JwVM4ub9aLTrzGq/bx1Sqe3MHg==
X-Received: by 2002:a6b:e602:0:b0:777:a8f0:1fc5 with SMTP id g2-20020a6be602000000b00777a8f01fc5mr10407439ioh.5.1686665889883;
        Tue, 13 Jun 2023 07:18:09 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c7-20020a6bfd07000000b00760f256037dsm3841313ioi.44.2023.06.13.07.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 07:18:09 -0700 (PDT)
Date:   Tue, 13 Jun 2023 08:18:08 -0600
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
Subject: Re: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20230613081808.049b9e6d.alex.williamson@redhat.com>
In-Reply-To: <DS0PR11MB752985BA514AFF36CA3A2785C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-19-yi.l.liu@intel.com>
        <20230612162726.16f58ea4.alex.williamson@redhat.com>
        <DS0PR11MB752985BA514AFF36CA3A2785C355A@DS0PR11MB7529.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 13 Jun 2023 05:48:46 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Tuesday, June 13, 2023 6:27 AM
> > 
> > On Fri,  2 Jun 2023 05:16:47 -0700
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
> > > Tested-by: Terrence Xu <terrence.xu@intel.com>
> > > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > > ---
> > >  drivers/vfio/device_cdev.c | 123 +++++++++++++++++++++++++++++++++++++
> > >  drivers/vfio/vfio.h        |  13 ++++
> > >  drivers/vfio/vfio_main.c   |   5 ++
> > >  include/linux/vfio.h       |   3 +-
> > >  include/uapi/linux/vfio.h  |  27 ++++++++
> > >  5 files changed, 170 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > > index 1c640016a824..a4498ddbe774 100644
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
> > > @@ -44,6 +45,128 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct  
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
> > > +void vfio_df_cdev_close(struct vfio_device_file *df)
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
> > > +	vfio_df_close(df);
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
> > > +long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +				struct vfio_device_bind_iommufd __user *arg)
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
> > > +	ret = vfio_df_open(df);
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
> > > +	return 0;
> > > +
> > > +out_close_device:
> > > +	vfio_df_close(df);
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
> > > index d12b5b524bfc..42de40d2cd4d 100644
> > > --- a/drivers/vfio/vfio.h
> > > +++ b/drivers/vfio/vfio.h
> > > @@ -287,6 +287,9 @@ static inline void vfio_device_del(struct vfio_device *device)
> > >  }
> > >
> > >  int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep);
> > > +void vfio_df_cdev_close(struct vfio_device_file *df);
> > > +long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +				struct vfio_device_bind_iommufd __user *arg);
> > >  int vfio_cdev_init(struct class *device_class);
> > >  void vfio_cdev_cleanup(void);
> > >  #else
> > > @@ -310,6 +313,16 @@ static inline int vfio_device_fops_cdev_open(struct inode  
> > *inode,  
> > >  	return 0;
> > >  }
> > >
> > > +static inline void vfio_df_cdev_close(struct vfio_device_file *df)
> > > +{
> > > +}
> > > +
> > > +static inline long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
> > > +					      struct vfio_device_bind_iommufd __user  
> > *arg)  
> > > +{
> > > +	return -EOPNOTSUPP;
> > > +}
> > > +
> > >  static inline int vfio_cdev_init(struct class *device_class)
> > >  {
> > >  	return 0;
> > > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > > index ef55af75f459..9ba4d420eda2 100644
> > > --- a/drivers/vfio/vfio_main.c
> > > +++ b/drivers/vfio/vfio_main.c
> > > @@ -572,6 +572,8 @@ static int vfio_device_fops_release(struct inode *inode, struct  
> > file *filep)  
> > >
> > >  	if (df->group)
> > >  		vfio_df_group_close(df);
> > > +	else
> > > +		vfio_df_cdev_close(df);
> > >
> > >  	vfio_device_put_registration(device);
> > >
> > > @@ -1145,6 +1147,9 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
> > >  	struct vfio_device *device = df->device;
> > >  	int ret;
> > >
> > > +	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
> > > +		return vfio_df_ioctl_bind_iommufd(df, (void __user *)arg);
> > > +
> > >  	/* Paired with smp_store_release() following vfio_df_open() */
> > >  	if (!smp_load_acquire(&df->access_granted))
> > >  		return -EINVAL;
> > > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > > index 83cc5dc28b7a..e80a8ac86e46 100644
> > > --- a/include/linux/vfio.h
> > > +++ b/include/linux/vfio.h
> > > @@ -66,6 +66,7 @@ struct vfio_device {
> > >  	struct iommufd_device *iommufd_device;
> > >  	bool iommufd_attached;
> > >  #endif
> > > +	bool cdev_opened:1;  
> > 
> > Perhaps a more strongly defined data type here as well and roll
> > iommufd_attached into the same bit field scheme.  
> 
> Ok, then needs to make iommufd_attached always defined.

That does not follow.  Thanks,

Alex

