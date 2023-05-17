Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB5070708E
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 20:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjEQSQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 14:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjEQSQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 14:16:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C387ED5
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 11:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684347324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vBbkfwSNfUaNRT3WQhfk4a0Uy2VKZgjYjPB926dHc6c=;
        b=F11IuCaDWrAl14pRqxCj70wUDaEK/y5bvlhcNAxKEk9ufw/TAAwg7UGBFl6iYS6dgNXNAA
        SmYYLQA6veMwFKeQ1DaZUo1fQU5Zcc+A7r0eRCsFSwRHsB6ug3fEq9kgvk2Dq/Sn9xao9C
        yDVRY78wywvkmY8h/Mnb/6rayTACC/c=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-YcCphsK-PeC9d8t--VxHVg-1; Wed, 17 May 2023 14:15:23 -0400
X-MC-Unique: YcCphsK-PeC9d8t--VxHVg-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-331828cdc2dso7397535ab.3
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 11:15:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684347323; x=1686939323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vBbkfwSNfUaNRT3WQhfk4a0Uy2VKZgjYjPB926dHc6c=;
        b=IEhaV2MQMorlsxqwc86/s3H7GaC0y11qQrOwRlKr3KKpGCwdDJDj1m4SeuagbcW8mz
         dmEH3H7pTjDhkm/NcND1lHH5gntICdlzgyjrZZqq8fJtXjxFwyk4Dzga7+GpN5cFzDKp
         pXB1Pyx4Jggjg1RJ/6Dp1Z0B+tN9QPhAc744NntM8CwnCMpZjRd5SYnUNwzj+Yo2dkdY
         PpPXfSNyGAbgdeYEQOMeKSpkQDmZhWCojvVkUCMp0+KafWYgIfTo1IqJAVZpkp4nOKiV
         kBiTMtJI/9ljL0tIGGDmZ4IJkBz7aXeFe0/e+LQlKhZjvxseA8sSMjdi6Hxl8hQjnfcF
         P6DA==
X-Gm-Message-State: AC+VfDzYkC4TzKlsW2khngHfL9fpFgnqKSAMjFOVAuXwOkBa6PLG1bLU
        do7VIPIj1ypcoB0AlzukJ6MCPTKnAohTuMAHmTy04gi2N7Kj/CfmYNTlhnB2p9nzIkaqA5yadkO
        AFbtWe+Ng356Q
X-Received: by 2002:a92:280b:0:b0:334:faa5:494 with SMTP id l11-20020a92280b000000b00334faa50494mr2434388ilf.16.1684347321339;
        Wed, 17 May 2023 11:15:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ51VpyD99hRmBsrXJMFRpCGeYsUOJ+gL3UPLw/Lj4qOOkLmuTpqYEjHcu6zyABxCd7m198oHA==
X-Received: by 2002:a92:280b:0:b0:334:faa5:494 with SMTP id l11-20020a92280b000000b00334faa50494mr2434329ilf.16.1684347319597;
        Wed, 17 May 2023 11:15:19 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f6-20020a056638112600b00411b5ea8576sm8728015jar.108.2023.05.17.11.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 11:15:19 -0700 (PDT)
Date:   Wed, 17 May 2023 12:15:17 -0600
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
Subject: Re: [PATCH v5 06/10] vfio-iommufd: Add helper to retrieve
 iommufd_ctx and devid for vfio_device
Message-ID: <20230517121517.4b7ceb52.alex.williamson@redhat.com>
In-Reply-To: <20230513132136.15021-7-yi.l.liu@intel.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-7-yi.l.liu@intel.com>
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

On Sat, 13 May 2023 06:21:32 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This is needed by the vfio-pci driver to report affected devices in the
> hot reset for a given device.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/device.c | 24 ++++++++++++++++++++++++
>  drivers/vfio/iommufd.c         | 20 ++++++++++++++++++++
>  include/linux/iommufd.h        |  6 ++++++
>  include/linux/vfio.h           | 14 ++++++++++++++
>  4 files changed, 64 insertions(+)
> 
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index 4f9b2142274c..81466b97023f 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -116,6 +116,18 @@ void iommufd_device_unbind(struct iommufd_device *idev)
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_device_unbind, IOMMUFD);
>  
> +struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev)
> +{
> +	return idev->ictx;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_ictx, IOMMUFD);
> +
> +u32 iommufd_device_to_id(struct iommufd_device *idev)
> +{
> +	return idev->obj.id;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_device_to_id, IOMMUFD);
> +
>  static int iommufd_device_setup_msi(struct iommufd_device *idev,
>  				    struct iommufd_hw_pagetable *hwpt,
>  				    phys_addr_t sw_msi_start)
> @@ -463,6 +475,18 @@ void iommufd_access_destroy(struct iommufd_access *access)
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_access_destroy, IOMMUFD);
>  
> +struct iommufd_ctx *iommufd_access_to_ictx(struct iommufd_access *access)
> +{
> +	return access->ictx;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_access_to_ictx, IOMMUFD);
> +
> +u32 iommufd_access_to_id(struct iommufd_access *access)
> +{
> +	return access->obj.id;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_access_to_id, IOMMUFD);
> +
>  int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
>  {
>  	struct iommufd_ioas *new_ioas;
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index c1379e826052..a18e920be164 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -105,6 +105,26 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
>  		vdev->ops->unbind_iommufd(vdev);
>  }
>  
> +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev)
> +{
> +	if (vdev->iommufd_device)
> +		return iommufd_device_to_ictx(vdev->iommufd_device);
> +	if (vdev->noiommu_access)
> +		return iommufd_access_to_ictx(vdev->noiommu_access);
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_ictx);
> +
> +int vfio_iommufd_physical_devid(struct vfio_device *vdev)
> +{
> +	if (vdev->iommufd_device)
> +		return iommufd_device_to_id(vdev->iommufd_device);
> +	if (vdev->noiommu_access)
> +		return iommufd_access_to_id(vdev->noiommu_access);
> +	return -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(vfio_iommufd_physical_devid);

I think these exemplify that it would be better if both emulated and
noiommu use the same iommufd_access pointer.  Thanks,

Alex

> +
>  /*
>   * The physical standard ops mean that the iommufd_device is bound to the
>   * physical device vdev->dev that was provided to vfio_init_group_dev(). Drivers
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index 1129a36a74c4..68cd65274e28 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -24,6 +24,9 @@ void iommufd_device_unbind(struct iommufd_device *idev);
>  int iommufd_device_attach(struct iommufd_device *idev, u32 *pt_id);
>  void iommufd_device_detach(struct iommufd_device *idev);
>  
> +struct iommufd_ctx *iommufd_device_to_ictx(struct iommufd_device *idev);
> +u32 iommufd_device_to_id(struct iommufd_device *idev);
> +
>  struct iommufd_access_ops {
>  	u8 needs_pin_pages : 1;
>  	void (*unmap)(void *data, unsigned long iova, unsigned long length);
> @@ -45,6 +48,9 @@ iommufd_access_create(struct iommufd_ctx *ictx,
>  void iommufd_access_destroy(struct iommufd_access *access);
>  int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id);
>  
> +struct iommufd_ctx *iommufd_access_to_ictx(struct iommufd_access *access);
> +u32 iommufd_access_to_id(struct iommufd_access *access);
> +
>  void iommufd_ctx_get(struct iommufd_ctx *ictx);
>  
>  #if IS_ENABLED(CONFIG_IOMMUFD)
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index a61130bc06a2..fcbe084b18c8 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -115,6 +115,8 @@ struct vfio_device_ops {
>  };
>  
>  #if IS_ENABLED(CONFIG_IOMMUFD)
> +struct iommufd_ctx *vfio_iommufd_physical_ictx(struct vfio_device *vdev);
> +int vfio_iommufd_physical_devid(struct vfio_device *vdev);
>  int vfio_iommufd_physical_bind(struct vfio_device *vdev,
>  			       struct iommufd_ctx *ictx, u32 *out_device_id);
>  void vfio_iommufd_physical_unbind(struct vfio_device *vdev);
> @@ -124,6 +126,18 @@ int vfio_iommufd_emulated_bind(struct vfio_device *vdev,
>  void vfio_iommufd_emulated_unbind(struct vfio_device *vdev);
>  int vfio_iommufd_emulated_attach_ioas(struct vfio_device *vdev, u32 *pt_id);
>  #else
> +static inline struct iommufd_ctx *
> +vfio_iommufd_physical_ictx(struct vfio_device *vdev)
> +{
> +	return NULL;
> +}
> +
> +static inline int
> +vfio_iommufd_physical_devid(struct vfio_device *vdev)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
>  #define vfio_iommufd_physical_bind                                      \
>  	((int (*)(struct vfio_device *vdev, struct iommufd_ctx *ictx,   \
>  		  u32 *out_device_id)) NULL)

