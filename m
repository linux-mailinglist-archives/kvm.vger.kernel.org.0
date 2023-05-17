Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AF9706F69
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 19:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjEQR1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 13:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjEQR1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 13:27:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE34D060
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 10:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684344374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=karr8Ws2RnN8jravJ8lYfLxbPdfzQHz3dR1gc3JvIYw=;
        b=MoVoX+oL5Xf8a6RZzREAx8T9DE1a9Kfssw/j1OPPjCBGcDhY5v8eJct0QJiv9oFQWFEHYn
        v6AIdkM2gELhMBZItyZ86qIY2ci57uhJm8lAp3xhwkih5rYlHFSLFJyfnZNZdxfS4skl+m
        bNerFyNN+Lxl+SnZ0XbiP5iRKEdadLk=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-O8wgfPpyMxCLPlzZQ31qsg-1; Wed, 17 May 2023 13:26:13 -0400
X-MC-Unique: O8wgfPpyMxCLPlzZQ31qsg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3313d6bcc76so6960255ab.2
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 10:26:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684344372; x=1686936372;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=karr8Ws2RnN8jravJ8lYfLxbPdfzQHz3dR1gc3JvIYw=;
        b=bBTUfBqE9yEcGDxSg1BpTBuZMUJHyseHW9m3OyuxOl7jbyTR8W6d+G+znVPtk8T03i
         M7B5Kxrk7ThGx/2HnglBD4JinsznWHBgFpPdfHV9uz2XYtcANOMOOkYYcg32vRh2f2y+
         XwKKoRmxPk96lUZrjusGroP4CcH7c8OCzUKY5dL3XeRXY5cduHnXROG6CSETwHnJ5+gx
         WOT6qQ1V2Afx40hy6FVy1kDn/W77C/o6VuWYC9CB7AJsG3cSXYoqmam+AyBPhFULArFx
         oPn3X4FCiy9GljqaejHFijoxN3UXFpmsrgbrH7rEY8tjVNTj12dokgfk2ZVrVOPoQksc
         m6LA==
X-Gm-Message-State: AC+VfDz/ciWkdlZPalpgu9/eGOgMnTY0oKrAuK9rFV52NzQOBBR3FkVH
        7iRVo1/7CH/l9ACA+jmWQ2TsgQ0FfW/IKA3qWeufDECuxV/tObPP20PQGJuqYPC/uaa/3FPtfAE
        TkkL3oECeAgZx
X-Received: by 2002:a92:d10e:0:b0:335:5b3b:72 with SMTP id a14-20020a92d10e000000b003355b3b0072mr2403508ilb.23.1684344372357;
        Wed, 17 May 2023 10:26:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4a05JKtw3Lt/GR03Gffqm2EiKkTvP1xCEZE+Ofn8tXoudJrpGm2HfJE6E8YHrcsCVKm+MYKA==
X-Received: by 2002:a92:d10e:0:b0:335:5b3b:72 with SMTP id a14-20020a92d10e000000b003355b3b0072mr2403489ilb.23.1684344372042;
        Wed, 17 May 2023 10:26:12 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id co24-20020a0566383e1800b004187f6d4e78sm4065330jab.105.2023.05.17.10.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 10:26:11 -0700 (PDT)
Date:   Wed, 17 May 2023 11:26:09 -0600
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
Subject: Re: [PATCH v5 01/10] vfio-iommufd: Create iommufd_access for
 noiommu devices
Message-ID: <20230517112609.78a3e916.alex.williamson@redhat.com>
In-Reply-To: <20230513132136.15021-2-yi.l.liu@intel.com>
References: <20230513132136.15021-1-yi.l.liu@intel.com>
        <20230513132136.15021-2-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 13 May 2023 06:21:27 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This binds noiommu device to iommufd and creates iommufd_access for this
> bond. This is useful for adding an iommufd-based device ownership check
> for VFIO_DEVICE_PCI_HOT_RESET since this model requires all the other
> affected devices bound to the same iommufd as the device to be reset.
> For noiommu devices, there is no backend iommu, so create iommufd_access
> instead of iommufd_device.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/iommufd.c | 43 ++++++++++++++++++++++++++++++++++++++++--
>  include/linux/vfio.h   |  1 +
>  2 files changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 88b00c501015..c1379e826052 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -10,6 +10,42 @@
>  MODULE_IMPORT_NS(IOMMUFD);
>  MODULE_IMPORT_NS(IOMMUFD_VFIO);
>  
> +static void vfio_noiommu_access_unmap(void *data, unsigned long iova,
> +				      unsigned long length)
> +{

Should this WARN_ON if called?

> +}
> +
> +static const struct iommufd_access_ops vfio_user_noiommu_ops = {
> +	.needs_pin_pages = 1,

But it doesn't.

> +	.unmap = vfio_noiommu_access_unmap,
> +};
> +
> +static int vfio_iommufd_noiommu_bind(struct vfio_device *vdev,
> +				     struct iommufd_ctx *ictx,
> +				     u32 *out_device_id)
> +{
> +	struct iommufd_access *user;
> +
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	user = iommufd_access_create(ictx, &vfio_user_noiommu_ops,
> +				     vdev, out_device_id);
> +	if (IS_ERR(user))
> +		return PTR_ERR(user);
> +	vdev->noiommu_access = user;
> +	return 0;
> +}
> +
> +static void vfio_iommufd_noiommu_unbind(struct vfio_device *vdev)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (vdev->noiommu_access) {
> +		iommufd_access_destroy(vdev->noiommu_access);
> +		vdev->noiommu_access = NULL;
> +	}
> +}
> +
>  int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
>  {
>  	u32 ioas_id;
> @@ -29,7 +65,8 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
>  		 */
>  		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
>  			return -EPERM;
> -		return 0;
> +
> +		return vfio_iommufd_noiommu_bind(vdev, ictx, &device_id);
>  	}
>  
>  	ret = vdev->ops->bind_iommufd(vdev, ictx, &device_id);
> @@ -59,8 +96,10 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
>  {
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> -	if (vfio_device_is_noiommu(vdev))
> +	if (vfio_device_is_noiommu(vdev)) {
> +		vfio_iommufd_noiommu_unbind(vdev);
>  		return;
> +	}
>  
>  	if (vdev->ops->unbind_iommufd)
>  		vdev->ops->unbind_iommufd(vdev);
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 2c137ea94a3e..16fd04490550 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -57,6 +57,7 @@ struct vfio_device {
>  	struct list_head group_next;
>  	struct list_head iommu_entry;
>  	struct iommufd_access *iommufd_access;
> +	struct iommufd_access *noiommu_access;

It's not clear to me why we need a separate iommufd_access for noiommu.
Can't we add a vfio_device_is_noiommu() check to the
vfio_{un}pin_pages() and vfio_dma_rw() interfaces and reuse the
existing pointer for both emulated and noiommu cases?  Maybe even the
iommufd_access* functions should test needs_pin_pages and generate an
error/warning if an access that was registered without reporting that
it needs page pinning makes use of such an interface.  Thanks,

Alex

>  	void (*put_kvm)(struct kvm *kvm);
>  #if IS_ENABLED(CONFIG_IOMMUFD)
>  	struct iommufd_device *iommufd_device;

