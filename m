Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED0B688981
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 23:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233328AbjBBWDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 17:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbjBBWDC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 17:03:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DAB88CE3
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 14:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675375284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cg6pr3XzYpc5DL6DcC4GwSw9pOl0fUz0Wz6d212U3LY=;
        b=Auy1TWJhpeCBgfo4IA0iNhcH0BLQ0JxvKMs0SbV626Fv0p7pYPzxRZi7I9ia67eyM/GJ1a
        llcn1VuffPMBGSOTvaIXB0GPVT72AyF3S3N+KhpYMU4UCI5bxPU5pr81HOnAFuRuEO+kzk
        2u1ggq+9Y1Bhf5NakuJ1Lr51Xp5P92E=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-547-MFUaP_V1OSOYo2OaLPMeTA-1; Thu, 02 Feb 2023 17:01:13 -0500
X-MC-Unique: MFUaP_V1OSOYo2OaLPMeTA-1
Received: by mail-io1-f72.google.com with SMTP id b10-20020a5ea70a000000b0071a96a509a7so1936906iod.22
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 14:01:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cg6pr3XzYpc5DL6DcC4GwSw9pOl0fUz0Wz6d212U3LY=;
        b=oxapFzWONGebsB5DiP+LGNpdAI09Ib8m74IDdeaXlFasIaeMHXImnYzOCyNFA+KyVl
         gUGmUUmxmb4V/dQfXe8LWfax5otcshuFB83hkVM64zv2W0d0ibHlS7X3U83AAKR8JKsV
         JEfgbZ0vOPJMq3bcXCw3JBLhUyJnSDUGJ+z/RWQqhIlm3bRc3+NtbCRHE4hgtWjaWhc2
         POioRA74S8v/teLPSMPgyFyRXks8p0VlEurckk1WhSzBrO7XZCMeGs7qeJIMnOSpMTMB
         R1c3uGhLAKXUp6KBRiOCiGKzh0evtsp2f57lwglebi7lOjPmWoZ00u1Jj6O82mtVvH+J
         3r/Q==
X-Gm-Message-State: AO0yUKWewWrSikxp+Mb2cA647+80Ghz33XHemDQZxmY1IR4tryvhoEfS
        T/xlR27acsANYZAzSEStInn0EKj1VWhIdN/x8i5sRIAm2U3PxvHhzv03jFVpmTFKIYWjGjer/y9
        IB55CFQw9J72k
X-Received: by 2002:a5d:8186:0:b0:712:cf90:e3e with SMTP id u6-20020a5d8186000000b00712cf900e3emr4913975ion.2.1675375272434;
        Thu, 02 Feb 2023 14:01:12 -0800 (PST)
X-Google-Smtp-Source: AK7set+5gMlu3C4avfByIvD48JpL7JdfIsclvwHls2LZoJC1BhU6TXJPisJU5JXKf3HwY9UQB3eeUg==
X-Received: by 2002:a5d:8186:0:b0:712:cf90:e3e with SMTP id u6-20020a5d8186000000b00712cf900e3emr4913966ion.2.1675375272138;
        Thu, 02 Feb 2023 14:01:12 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id m1-20020a6b7f41000000b0070766817820sm241716ioq.20.2023.02.02.14.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 14:01:11 -0800 (PST)
Date:   Thu, 2 Feb 2023 15:01:10 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, chao.p.peng@linux.intel.com,
        eric.auger@redhat.com, yi.y.sun@linux.intel.com,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Message-ID: <20230202150110.1876c6a9.alex.williamson@redhat.com>
In-Reply-To: <20230202080201.338571-3-yi.l.liu@intel.com>
References: <20230202080201.338571-1-yi.l.liu@intel.com>
        <20230202080201.338571-3-yi.l.liu@intel.com>
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

On Thu,  2 Feb 2023 00:02:01 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> this imports the latest vfio_device_ops definition to vfio.rst.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  Documentation/driver-api/vfio.rst | 71 +++++++++++++++++++++----------
>  1 file changed, 48 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index c663b6f97825..10d84f01fda1 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -249,19 +249,22 @@ VFIO bus driver API
>  
>  VFIO bus drivers, such as vfio-pci make use of only a few interfaces
>  into VFIO core.  When devices are bound and unbound to the driver,
> -the driver should call vfio_register_group_dev() and
> -vfio_unregister_group_dev() respectively::
> +the driver should call vfio_register_group_dev() or
> +vfio_register_emulated_iommu_dev() and vfio_unregister_group_dev()
> +respectively::
>  
> -	void vfio_init_group_dev(struct vfio_device *device,
> -				struct device *dev,
> -				const struct vfio_device_ops *ops);
> -	void vfio_uninit_group_dev(struct vfio_device *device);
>  	int vfio_register_group_dev(struct vfio_device *device);
> +	int vfio_register_emulated_iommu_dev(struct vfio_device *device);
>  	void vfio_unregister_group_dev(struct vfio_device *device);
>  
>  The driver should embed the vfio_device in its own structure and call
> -vfio_init_group_dev() to pre-configure it before going to registration
> -and call vfio_uninit_group_dev() after completing the un-registration.
> +vfio_alloc_device() or _vfio_alloc_device() to allocate the structure,

AIUI, _vfio_alloc_device() is only exported because it's used by
vfio_alloc_device() which is a macro.  I don't think we want to list
_vfio_alloc_device() as an equal alternative, if anything we should
discourage any direct use.

> +and can register @init/@release callbacks to manage any private state
> +wrapping the vfio_device.
> +
> +	vfio_alloc_device(dev_struct, member, dev, ops);
> +	void vfio_put_device(struct vfio_device *device);
> +
>  vfio_register_group_dev() indicates to the core to begin tracking the
>  iommu_group of the specified dev and register the dev as owned by a VFIO bus
>  driver. Once vfio_register_group_dev() returns it is possible for userspace to
> @@ -270,28 +273,50 @@ ready before calling it. The driver provides an ops structure for callbacks
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
> -	};
> +		int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
> +		void	(*request)(struct vfio_device *vdev, unsigned int count);
> +		int	(*match)(struct vfio_device *vdev, char *buf);
> +		void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
> +		int	(*device_feature)(struct vfio_device *device, u32 flags,
> +					  void __user *arg, size_t argsz);
> +};
>  
>  Each function is passed the vdev that was originally registered
> -in the vfio_register_group_dev() call above.  This allows the bus driver
> -to obtain its private data using container_of().  The open/release
> -callbacks are issued when a new file descriptor is created for a
> -device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
> -a direct pass through for VFIO_DEVICE_* ioctls.  The read/write/mmap
> -interfaces implement the device region access defined by the device's
> -own VFIO_DEVICE_GET_REGION_INFO ioctl.
> -
> +in the vfio_register_group_dev() or vfio_register_emulated_iommu_dev()
> +call above.  This allows the bus driver to obtain its private data using
> +container_of().
> +- The init/release callbacks are issued in the drivers's structure allocation

drivers' is the possessive of plural drivers.  Thanks,

Alex

> +  and put.
> +- The open/close_device callbacks are issued when a new file descriptor is
> +  created for a device (via VFIO_GROUP_GET_DEVICE_FD).
> +- The ioctl interface provides a direct pass through for VFIO_DEVICE_* ioctls.
> +- The [un]bind_iommufd callbacks are issued when the device is bound to iommufd.
> +  'unbound' is implied if iommufd is being used.
> +- The attach_ioas callback is issued when the device is attached to an IOAS
> +  managed by the bound iommufd. The attached IOAS is automatically detached
> +  when the device is unbound from the iommufd.
> +- The read/write/mmap interfaces implement the device region access defined by
> +  the device's own VFIO_DEVICE_GET_REGION_INFO ioctl.
> +- The request callback is issued when device is going to be unregistered.
> +- The dma_unmap callback is issued when a range of iova's are unmapped in
> +  the container or IOAS attached by the device. Drivers which care about
> +  DMA unmap can implement this callback and must tolerate receiving unmap
> +  notifications before the device is opened.
>  
>  PPC64 sPAPR implementation note
>  -------------------------------

