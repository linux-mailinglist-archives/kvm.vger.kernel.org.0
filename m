Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E5172D4AC
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 00:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238098AbjFLWrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 18:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjFLWrI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 18:47:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83BB110
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 15:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686609979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uw96ygv6BCbN8RZaCmP8x2EvtrfsPem903iDK/5hEsA=;
        b=QNphLH8DZwXK4eJkRi+zHpB3AC9RVS8LfyEu9rOmFrO6BCM5xMIdaWhPMYP+oXyRZJ/Cu3
        wIa/gTMdcqqUVOlt/bLodS64ZiS1sD96hWSwwGpQYRLY26VtpcC7Gdtb9oh3nOGctcsknl
        PchTx48Jt3WNj1lVFfsjWw4nHlLiuJ0=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-R0NRCpvuNl6OIICK2Tt5Bg-1; Mon, 12 Jun 2023 18:46:18 -0400
X-MC-Unique: R0NRCpvuNl6OIICK2Tt5Bg-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-33b7a468d14so54044245ab.3
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 15:46:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686609978; x=1689201978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uw96ygv6BCbN8RZaCmP8x2EvtrfsPem903iDK/5hEsA=;
        b=lcf5W7ifJc5nlcN9B0QdshgzzOuUUt9xCoTn6e+VH2GWJUjJ8suk8eA2gUyuvmLxqp
         GRW6yOjAsPly/wWwatbGpybHBlr4E/s0SyndLvnSw3gv0OEFmcnpSeJFAslEqrsqEhsP
         lt90z2lgjy5th5FR/t92MEhVyFA2+5Av8tWcj8OlA6Yj1h+gh+8wx8UMTGg15nmQc2Ff
         4YxssFa2aful7/nZFpeHDw8/g3NAVbfiPzxky9pEtE0J0OC2R8bNBIyVu+41ZFXiwkuz
         X5avDn3W23FS/osryGXcpinV5L91zBXV5M0zPBt6qHGt2Ot2migrJIa6Plyit5ZbBs7P
         HuGA==
X-Gm-Message-State: AC+VfDwRNMZ4GYOw6Ilp+h1BLcXctO3ZoY63YrobNSWpi4VvFnQRt9i3
        Ew98nLyKySEBKc+KrxBoI7ed3wKwZeoMxc/ZXyfDj1/Ww/69mYWi4v7ozq2b4Y1xh7crZ4NR871
        ubL+kRrAnYDRl
X-Received: by 2002:a92:dd90:0:b0:331:5aec:5a34 with SMTP id g16-20020a92dd90000000b003315aec5a34mr8338488iln.0.1686609977872;
        Mon, 12 Jun 2023 15:46:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5dfG+PFJ0UiXdi0OXecGMIBW8zpmfJBKJn2JyVoW6iOVg2ooM2fOd7rcUv+x9jNJiSnAAEng==
X-Received: by 2002:a92:dd90:0:b0:331:5aec:5a34 with SMTP id g16-20020a92dd90000000b003315aec5a34mr8338469iln.0.1686609977671;
        Mon, 12 Jun 2023 15:46:17 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id l5-20020a92d8c5000000b00338a1272ce1sm3454418ilo.52.2023.06.12.15.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 15:46:17 -0700 (PDT)
Date:   Mon, 12 Jun 2023 16:46:15 -0600
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
Subject: Re: [PATCH v12 22/24] vfio: Remove vfio_device_is_noiommu()
Message-ID: <20230612164615.71a9211c.alex.williamson@redhat.com>
In-Reply-To: <20230602121653.80017-23-yi.l.liu@intel.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
        <20230602121653.80017-23-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Jun 2023 05:16:51 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This converts noiommu test to use vfio_device->noiommu flag. Per this
> change, vfio_device_is_noiommu() is removed.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c   | 2 +-
>  drivers/vfio/iommufd.c | 4 ++--
>  drivers/vfio/vfio.h    | 9 ++-------
>  3 files changed, 5 insertions(+), 10 deletions(-)

Drop this as well.  You can see here all the code paths that wouldn't
have even been compiled with CONFIG_VFIO_NOIOMMU unset.  Thanks,

Alex
 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 64cdd0ea8825..08d37811507e 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -191,7 +191,7 @@ static int vfio_df_group_open(struct vfio_device_file *df)
>  		vfio_device_group_get_kvm_safe(device);
>  
>  	df->iommufd = device->group->iommufd;
> -	if (df->iommufd && vfio_device_is_noiommu(device) && device->open_count == 0) {
> +	if (df->iommufd && device->noiommu && device->open_count == 0) {
>  		/*
>  		 * Require no compat ioas to be assigned to proceed.  The basic
>  		 * statement is that the user cannot have done something that
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index a59ed4f881aa..fac8ca74ec85 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -37,7 +37,7 @@ int vfio_iommufd_compat_attach_ioas(struct vfio_device *vdev,
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
>  	/* compat noiommu does not need to do ioas attach */
> -	if (vfio_device_is_noiommu(vdev))
> +	if (vdev->noiommu)
>  		return 0;
>  
>  	ret = iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
> @@ -54,7 +54,7 @@ void vfio_df_iommufd_unbind(struct vfio_device_file *df)
>  
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> -	if (vfio_device_is_noiommu(vdev))
> +	if (vdev->noiommu)
>  		return;
>  
>  	if (vdev->ops->unbind_iommufd)
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 1b89e8bc8571..b138b8334fe0 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -106,11 +106,6 @@ bool vfio_device_has_container(struct vfio_device *device);
>  int __init vfio_group_init(void);
>  void vfio_group_cleanup(void);
>  
> -static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> -{
> -	return vdev->group->type == VFIO_NO_IOMMU;
> -}
> -
>  #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
>  /**
>   * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
> @@ -271,7 +266,7 @@ void vfio_init_device_cdev(struct vfio_device *device);
>  static inline int vfio_device_add(struct vfio_device *device)
>  {
>  	/* cdev does not support noiommu device */
> -	if (vfio_device_is_noiommu(device))
> +	if (device->noiommu)
>  		return device_add(&device->device);
>  	vfio_init_device_cdev(device);
>  	return cdev_device_add(&device->cdev, &device->device);
> @@ -279,7 +274,7 @@ static inline int vfio_device_add(struct vfio_device *device)
>  
>  static inline void vfio_device_del(struct vfio_device *device)
>  {
> -	if (vfio_device_is_noiommu(device))
> +	if (device->noiommu)
>  		device_del(&device->device);
>  	else
>  		cdev_device_del(&device->cdev, &device->device);

