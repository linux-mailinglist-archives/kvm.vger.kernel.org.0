Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A18D70CB7A
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 22:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbjEVUrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 16:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234157AbjEVUrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 16:47:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02323B5
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 13:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684788382;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hXakA5zSL2GIysQW8AsHrXTSyc8tezpgqrfO24VGzEI=;
        b=H1ymuSz6EizWoI/NdJtqKiEm6v3K9bLPe3+FXfoRStypMrjJpWq1O5Wy/yqgiGQPiJOhbC
        fFkO4163C0/KDZH9JRJONZyKi5BygxCY7XjS7cVgzDq78fIOv1q2AERFc1Xudc2oy6Lo/6
        rCmGRxjaNYQq1O3wsE/m03Hgywp3bO0=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-505-sEs4ZMoWOo-n7EiDUdVWUw-1; Mon, 22 May 2023 16:46:20 -0400
X-MC-Unique: sEs4ZMoWOo-n7EiDUdVWUw-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-335a27baefbso429655ab.3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 13:46:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684788380; x=1687380380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hXakA5zSL2GIysQW8AsHrXTSyc8tezpgqrfO24VGzEI=;
        b=k+HL667EcseS+35mtc1RnWdVIA35yskMPIF1HwqkFxQ1x7XRcUSAdMbfH0vAtiPfFw
         gv0dgYym79T+0ULgtAq7PpNFjMVbW4KjZqggRaqOs1TXk85CQFGU53Pw4WYZitBxJseD
         dmdho+/XPltYggcVfueJ3LU/Rc2IawchSmccN+zCCV64QrX1GkxFEg/POUrpJXvGNNTc
         +SgNLYsSmVYOvea35SZhUfS8Ju3GRyzmFHysBSzMSeRZ2luWoG9ZKoK6UeN2wqJp3YjA
         9I7eR+N2lvAXZLQULfH6CHI05TEdJDs+tq8Ikt6Nn7RPBerqL2uPpqPWOSgWXhC8Smhq
         llTw==
X-Gm-Message-State: AC+VfDzYg4C2L3947SlgpoHpA8/ybrAmZNzWpqI/aEMMGTQ8vCDr1qWR
        3vYFXMBrqgGiEng5sxg8JW1LL9FgglDSO2bktCWrF/KiP/0FhWmGkXYD9ebj57PYZVZsgvm7B7l
        srSYjsuOtCY6k
X-Received: by 2002:a92:d2cc:0:b0:331:4f4c:6bae with SMTP id w12-20020a92d2cc000000b003314f4c6baemr7842880ilg.26.1684788380032;
        Mon, 22 May 2023 13:46:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5scIolOUHYuhSfxKCZRjcu6LV3DDr04CMA6rpDsz3y2l7h1k3roVRucOZrB8k0FA0u47DOuA==
X-Received: by 2002:a92:d2cc:0:b0:331:4f4c:6bae with SMTP id w12-20020a92d2cc000000b003314f4c6baemr7842861ilg.26.1684788379681;
        Mon, 22 May 2023 13:46:19 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id ed16-20020a056638291000b0040fa72e0b6fsm1872083jab.139.2023.05.22.13.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 13:46:19 -0700 (PDT)
Date:   Mon, 22 May 2023 14:46:17 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v11 13/23] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Message-ID: <20230522144617.63dcfead.alex.williamson@redhat.com>
In-Reply-To: <20230513132827.39066-14-yi.l.liu@intel.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-14-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 13 May 2023 06:28:17 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> this prepares for adding DETACH ioctl for physical VFIO devices.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  Documentation/driver-api/vfio.rst             |  8 +++++---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c             |  1 +
>  drivers/vfio/iommufd.c                        | 20 +++++++++++++++++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  2 ++
>  drivers/vfio/pci/mlx5/main.c                  |  1 +
>  drivers/vfio/pci/vfio_pci.c                   |  1 +
>  drivers/vfio/platform/vfio_amba.c             |  1 +
>  drivers/vfio/platform/vfio_platform.c         |  1 +
>  drivers/vfio/vfio_main.c                      |  3 ++-
>  include/linux/vfio.h                          |  8 +++++++-
>  10 files changed, 41 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
> index 68abc089d6dd..363e12c90b87 100644
> --- a/Documentation/driver-api/vfio.rst
> +++ b/Documentation/driver-api/vfio.rst
> @@ -279,6 +279,7 @@ similar to a file operations structure::
>  					struct iommufd_ctx *ictx, u32 *out_device_id);
>  		void	(*unbind_iommufd)(struct vfio_device *vdev);
>  		int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
> +		void	(*detach_ioas)(struct vfio_device *vdev);
>  		int	(*open_device)(struct vfio_device *vdev);
>  		void	(*close_device)(struct vfio_device *vdev);
>  		ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
> @@ -315,9 +316,10 @@ container_of().
>  	- The [un]bind_iommufd callbacks are issued when the device is bound to
>  	  and unbound from iommufd.
>  
> -	- The attach_ioas callback is issued when the device is attached to an
> -	  IOAS managed by the bound iommufd. The attached IOAS is automatically
> -	  detached when the device is unbound from iommufd.
> +	- The [de]attach_ioas callback is issued when the device is attached to
> +	  and detached from an IOAS managed by the bound iommufd. However, the
> +	  attached IOAS can also be automatically detached when the device is
> +	  unbound from iommufd.
>  
>  	- The read/write/mmap callbacks implement the device region access defined
>  	  by the device's own VFIO_DEVICE_GET_REGION_INFO ioctl.
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index c89a047a4cd8..d540cf683d93 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -594,6 +594,7 @@ static const struct vfio_device_ops vfio_fsl_mc_ops = {
>  	.bind_iommufd	= vfio_iommufd_physical_bind,
>  	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>  	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
>  };
>  
>  static struct fsl_mc_driver vfio_fsl_mc_driver = {
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 07b58c4625b5..e3953e1617a5 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -167,6 +167,14 @@ int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
>  {
>  	int rc;
>  
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (WARN_ON(!vdev->iommufd_device))
> +		return -EINVAL;
> +
> +	if (vdev->iommufd_attached)
> +		return -EBUSY;
> +
>  	rc = iommufd_device_attach(vdev->iommufd_device, pt_id);
>  	if (rc)
>  		return rc;
> @@ -175,6 +183,18 @@ int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id)
>  }
>  EXPORT_SYMBOL_GPL(vfio_iommufd_physical_attach_ioas);
>  
> +void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (WARN_ON(!vdev->iommufd_device) || !vdev->iommufd_attached)
> +		return;
> +
> +	iommufd_device_detach(vdev->iommufd_device);
> +	vdev->iommufd_attached = false;
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_detach_ioas);

Can't a user trigger this WARN_ON by simply repeatedly calling the
to-be-added detach ioctl?  Thanks,

Alex

> +
>  /*
>   * The emulated standard ops mean that vfio_device is going to use the
>   * "mdev path" and will call vfio_pin_pages()/vfio_dma_rw(). Drivers using this
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index a117eaf21c14..b2f9778c8366 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1373,6 +1373,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_migrn_ops = {
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas = vfio_iommufd_physical_detach_ioas,
>  };
>  
>  static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
> @@ -1391,6 +1392,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas = vfio_iommufd_physical_detach_ioas,
>  };
>  
>  static int hisi_acc_vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index d95fd382814c..42ec574a8622 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -1320,6 +1320,7 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas = vfio_iommufd_physical_detach_ioas,
>  };
>  
>  static int mlx5vf_pci_probe(struct pci_dev *pdev,
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 29091ee2e984..cb5b7f865d58 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -141,6 +141,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
>  	.bind_iommufd	= vfio_iommufd_physical_bind,
>  	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>  	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
>  };
>  
>  static int vfio_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> diff --git a/drivers/vfio/platform/vfio_amba.c b/drivers/vfio/platform/vfio_amba.c
> index 83fe54015595..6464b3939ebc 100644
> --- a/drivers/vfio/platform/vfio_amba.c
> +++ b/drivers/vfio/platform/vfio_amba.c
> @@ -119,6 +119,7 @@ static const struct vfio_device_ops vfio_amba_ops = {
>  	.bind_iommufd	= vfio_iommufd_physical_bind,
>  	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>  	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
>  };
>  
>  static const struct amba_id pl330_ids[] = {
> diff --git a/drivers/vfio/platform/vfio_platform.c b/drivers/vfio/platform/vfio_platform.c
> index 22a1efca32a8..8cf22fa65baa 100644
> --- a/drivers/vfio/platform/vfio_platform.c
> +++ b/drivers/vfio/platform/vfio_platform.c
> @@ -108,6 +108,7 @@ static const struct vfio_device_ops vfio_platform_ops = {
>  	.bind_iommufd	= vfio_iommufd_physical_bind,
>  	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>  	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> +	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
>  };
>  
>  static struct platform_driver vfio_platform_driver = {
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 39d552e5160b..599d551fc4b5 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -273,7 +273,8 @@ static int __vfio_register_dev(struct vfio_device *device,
>  	if (WARN_ON(IS_ENABLED(CONFIG_IOMMUFD) &&
>  		    (!device->ops->bind_iommufd ||
>  		     !device->ops->unbind_iommufd ||
> -		     !device->ops->attach_ioas)))
> +		     !device->ops->attach_ioas ||
> +		     !device->ops->detach_ioas)))
>  		return -EINVAL;
>  
>  	/*
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 431eb82e0595..f446f5901e46 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -74,7 +74,9 @@ struct vfio_device {
>   * @bind_iommufd: Called when binding the device to an iommufd
>   * @unbind_iommufd: Opposite of bind_iommufd
>   * @attach_ioas: Called when attaching device to an IOAS/HWPT managed by the
> - *		 bound iommufd. Undo in unbind_iommufd.
> + *		 bound iommufd. Undo in unbind_iommufd if @detach_ioas is not
> + *		 called.
> + * @detach_ioas: Opposite of attach_ioas
>   * @open_device: Called when the first file descriptor is opened for this device
>   * @close_device: Opposite of open_device
>   * @read: Perform read(2) on device file descriptor
> @@ -98,6 +100,7 @@ struct vfio_device_ops {
>  				struct iommufd_ctx *ictx, u32 *out_device_id);
>  	void	(*unbind_iommufd)(struct vfio_device *vdev);
>  	int	(*attach_ioas)(struct vfio_device *vdev, u32 *pt_id);
> +	void	(*detach_ioas)(struct vfio_device *vdev);
>  	int	(*open_device)(struct vfio_device *vdev);
>  	void	(*close_device)(struct vfio_device *vdev);
>  	ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
> @@ -121,6 +124,7 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
>  			       struct iommufd_ctx *ictx, u32 *out_device_id);
>  void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
>  int vfio_iommufd_physical_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
> +void vfio_iommufd_physical_detach_ioas(struct vfio_device *vdev);
>  int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
>  			       struct iommufd_ctx *ictx, u32 *out_device_id);
>  void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
> @@ -145,6 +149,8 @@ vfio_iommufd_physical_devid(struct vfio_device *vdev)
>  	((void (*)(struct vfio_device *vdev)) NULL)
>  #define vfio_iommufd_physical_attach_ioas \
>  	((int (*)(struct vfio_device *vdev, u32 *pt_id)) NULL)
> +#define vfio_iommufd_physical_detach_ioas \
> +	((void (*)(struct vfio_device *vdev)) NULL)
>  #define vfio_iommufd_emulated_bind                                      \
>  	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
>  		  u32 *out_device_id)) NULL)

