Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000F868FB17
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 00:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjBHXW1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Feb 2023 18:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjBHXW0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Feb 2023 18:22:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE7BEB59
        for <kvm@vger.kernel.org>; Wed,  8 Feb 2023 15:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675898496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1kKJhjKrfZcdBHyLZPZxn8O65B5xaAmBUKV4KGRFsgQ=;
        b=WwnDklhwbNqNBBsVbYkL/B570rstPN8bgPH5S5IwjyOvaF7NXoHnB0dDcGIuYhQ4pdUCSB
        bKD7oQruhRI6m9fMCmsyQJXH1HmqzODRVMlaUYuKHQe3Ve+jTX01nYr7NYXQwghKZWJXSn
        +D+c+HJ9AOrdHuslVwEWJD2hDTPkJzU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-DGyNuen8OTSKCt_Dx-oVgQ-1; Wed, 08 Feb 2023 18:21:35 -0500
X-MC-Unique: DGyNuen8OTSKCt_Dx-oVgQ-1
Received: by mail-io1-f69.google.com with SMTP id d73-20020a6bb44c000000b0072805fbd06aso61539iof.17
        for <kvm@vger.kernel.org>; Wed, 08 Feb 2023 15:21:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1kKJhjKrfZcdBHyLZPZxn8O65B5xaAmBUKV4KGRFsgQ=;
        b=n5Sq/zu8n1H7f9xcTaR3/rllgFkbK3rUb/vnpwHShxV3XXkG/Lwr5jE+QpMjpIbRJK
         Q/TzLSRILXLDN08GifuiU6q6fziLMd84Mn3+9rdeMWOgcKZ38eKWVMyU1Gdq5sP6w5tf
         WI4QuIpns5WtSw3q2TUhN7juThPQHk7s49dP+30RvSiUIAG7mOL8vW0q82tWNlhEpjj5
         gs/3z3WjTPmn5R7SxzUeD32nutE2LXtg/g7dg/jdhNUuA/fKe5KvzC27YEAbMhQcWQWP
         rM9BRXJ+3ent+P3LlsBEmBjcaKVYnD7m7ilLxYq9omgtoeZeRM3msWYcJHYXwBI60Ei+
         IWHA==
X-Gm-Message-State: AO0yUKXE7ohoZrRWn46wWvzXy7uLD1873Fx1kkBnCbQ3mrpCH7/GiEZl
        sbyKXqkpBgOZTbhl5J77iCDxOU4mjaUtwoL9g18LCDZRP6RFtbXX00enOFFKw64D7ZnLkhirMsV
        A41Lug6VANOk9
X-Received: by 2002:a05:6e02:114f:b0:313:bfb4:b468 with SMTP id o15-20020a056e02114f00b00313bfb4b468mr2914374ill.13.1675898494202;
        Wed, 08 Feb 2023 15:21:34 -0800 (PST)
X-Google-Smtp-Source: AK7set+sCg71o+9qLfvIZeDTQH7pIxvvQ/nYCa5T/hZC2RfMyP7JsIg8AC1uHLBxPvC/wkyFzggP6Q==
X-Received: by 2002:a05:6e02:114f:b0:313:bfb4:b468 with SMTP id o15-20020a056e02114f00b00313bfb4b468mr2914355ill.13.1675898493907;
        Wed, 08 Feb 2023 15:21:33 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id k14-20020a056e02156e00b00313c109f49asm3334705ilu.43.2023.02.08.15.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 15:21:33 -0800 (PST)
Date:   Wed, 8 Feb 2023 16:21:32 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, chao.p.peng@linux.intel.com,
        eric.auger@redhat.com, yi.y.sun@linux.intel.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/2] docs: vfio: Update vfio.rst per latest
 interfaces
Message-ID: <20230208162132.0c3f573c.alex.williamson@redhat.com>
In-Reply-To: <20230204144208.727696-3-yi.l.liu@intel.com>
References: <20230204144208.727696-1-yi.l.liu@intel.com>
        <20230204144208.727696-3-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat,  4 Feb 2023 06:42:08 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> this imports the latest vfio_device_ops definition to vfio.rst.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  Documentation/driver-api/vfio.rst | 79 ++++++++++++++++++++++---------
>  1 file changed, 57 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index c663b6f97825..0bfa7261f991 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -249,19 +249,21 @@ VFIO bus driver API
>  
>  VFIO bus drivers, such as vfio-pci make use of only a few interfaces
>  into VFIO core.  When devices are bound and unbound to the driver,
> -the driver should call vfio_register_group_dev() and
> -vfio_unregister_group_dev() respectively::
> +Following interfaces are called when devices are bound to and
> +unbound from the driver::
>  
> -	void vfio_init_group_dev(struct vfio_device *device,
> -				struct device *dev,
> -				const struct vfio_device_ops *ops);
> -	void vfio_uninit_group_dev(struct vfio_device *device);
>  	int vfio_register_group_dev(struct vfio_device *device);
> +	int vfio_register_emulated_iommu_dev(struct vfio_device *device);
>  	void vfio_unregister_group_dev(struct vfio_device *device);
>  
> -The driver should embed the vfio_device in its own structure and call
> -vfio_init_group_dev() to pre-configure it before going to registration
> -and call vfio_uninit_group_dev() after completing the un-registration.
> +The driver should embed the vfio_device in its own structure and use
> +vfio_alloc_device() to allocate the structure, and can register
> +@init/@release callbacks to manage any private state wrapping the
> +vfio_device::
> +
> +	vfio_alloc_device(dev_struct, member, dev, ops);
> +	void vfio_put_device(struct vfio_device *device);
> +
>  vfio_register_group_dev() indicates to the core to begin tracking the
>  iommu_group of the specified dev and register the dev as owned by a VFIO bus
>  driver. Once vfio_register_group_dev() returns it is possible for userspace to
> @@ -270,28 +272,61 @@ ready before calling it. The driver provides an ops structure for callbacks
>  similar to a file operations structure::
>  
>  	struct vfio_device_ops {
> -		int	(*open)(struct vfio_device *vdev);
> +		char	*name;
> +		int	(*init)(struct vfio_device *vdev);
>  		void	(*release)(struct vfio_device *vdev);
> +		int	(*bind_iommufd)(struct vfio_device *vdev,
> +					struct iommufd_ctx *ictx, u32 *out_device_id);
> +		void	(*unbind_iommufd)(struct vfio_device *vdev);
> +		int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
> +		int	(*open_device)(struct vfio_device *vdev);
> +		void	(*close_device)(struct vfio_device *vdev);
>  		ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
>  				size_t count, loff_t *ppos);
> -		ssize_t	(*write)(struct vfio_device *vdev,
> -				 const char __user *buf,
> -				 size_t size, loff_t *ppos);
> +		ssize_t	(*write)(struct vfio_device *vdev, const char __user *buf,
> +			 size_t count, loff_t *size);
>  		long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
>  				 unsigned long arg);
> -		int	(*mmap)(struct vfio_device *vdev,
> -				struct vm_area_struct *vma);
> +		int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
> +		void	(*request)(struct vfio_device *vdev, unsigned int count);
> +		int	(*match)(struct vfio_device *vdev, char *buf);
> +		void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
> +		int	(*device_feature)(struct vfio_device *device, u32 flags,
> +					  void __user *arg, size_t argsz);
>  	};
>  
>  Each function is passed the vdev that was originally registered
> -in the vfio_register_group_dev() call above.  This allows the bus driver
> -to obtain its private data using container_of().  The open/release
> -callbacks are issued when a new file descriptor is created for a
> -device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
> -a direct pass through for VFIO_DEVICE_* ioctls.  The read/write/mmap
> -interfaces implement the device region access defined by the device's
> -own VFIO_DEVICE_GET_REGION_INFO ioctl.
> +in the vfio_register_group_dev() or vfio_register_emulated_iommu_dev()
> +call above. This allows the bus driver to obtain its private data using
> +container_of().
> +
> +::
> +
> +	- The init/release callbacks are issued when vfio_device is initialized
> +	  and released.
> +
> +	- The open/close_device callbacks are issued when a new file descriptor
> +	  is created for a device (e.g. via VFIO_GROUP_GET_DEVICE_FD).

Each call to VFIO_GROUP_GET_DEVICE_FD gives a "new" file descriptor,
does this intend to say something along the lines of:

	The open/close device callbacks are issued when the first
	instance of a file descriptor for the device is created (eg.
	via VFIO_GROUP_GET_DEVICE_FD) for a user session.

> +
> +	- The ioctl callback provides a direct pass through for some VFIO_DEVICE_*
> +	  ioctls.
> +
> +	- The [un]bind_iommufd callbacks are issued when the device is bound to
> +	  and unbound from iommufd.
> +
> +	- The attach_ioas callback is issued when the device is attached to an
> +	  IOAS managed by the bound iommufd. The attached IOAS is automatically
> +	  detached when the device is unbound from iommufd.
> +
> +	- The read/write/mmap callbacks implement the device region access defined
> +	  by the device's own VFIO_DEVICE_GET_REGION_INFO ioctl.
> +
> +	- The request callback is issued when device is going to be unregistered.

Perhaps add ", such as when trying to unbind the device from the vfio
bus driver."

>  
> +	- The dma_unmap callback is issued when a range of iova's are unmapped
> +	  in the container or IOAS attached by the device. Drivers which care
> +	  about iova unmap can implement this callback and must tolerate receiving
> +	  unmap notifications before the device is opened.

Rather than the last sentence, "Drivers which make use of the vfio page
pinning interface must implement this callback in order to unpin pages
within the dma_unmap range.  Drivers must tolerate this callback even
before calls to open_device()."  Thanks,

Alex

