Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423A3674702
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbjASXOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjASXNa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:13:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5AEA5CE5
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674169519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3ieXRWylUfJbywyApdILTaCdyFwXDoYOp5pALy9q1DQ=;
        b=HpJgWgymivwCpgsiN5pJnEiff2DcSPWijLJpg+NA6T+UvvRVe3HFBw1ldJ+69e3hFjM2x3
        pZMgRkOvkXOt6vDSlZS7x2HPlYi1aNNAl5S7fRYJBozGG42/EtwUl4ZRIc/2GsK5jeBJN3
        s7MzZw/v2DqdK1TkZM3jIoe7Dv62guI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-433-q2XsExsjOaqQiovXR8ap7Q-1; Thu, 19 Jan 2023 18:05:18 -0500
X-MC-Unique: q2XsExsjOaqQiovXR8ap7Q-1
Received: by mail-il1-f199.google.com with SMTP id g1-20020a92cda1000000b0030c45d93884so2640869ild.16
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:05:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ieXRWylUfJbywyApdILTaCdyFwXDoYOp5pALy9q1DQ=;
        b=Jos9IeJuYGTl4bdbbdlLrELEJLylENI70lp4DUiuupoytptGT92qtnElog1xXWIBpm
         Jk7XYLcrxQwW7NM7+Ggv2VNJF8jF6Uf6RAomrMMRC1/9gncLOJTu60xqXRiaDf6OafpA
         Lmuy3iem/8+owF/UMsxb29mJPeb+Om62SiGyaQv4aJkOwz4lw3OvYBVWbPr9Dji+ltY4
         iB7RJxsfmkWrHvpMjKIs2mekgCGmPZVV301nuDhalFCPC4L+/mThKoyuC2AJAj5oQNTr
         jI0dOUNv4xgx4wnYYYL9mPsnwkkivS3S43KUBTo4Q8+S+ODI0YLZd31g2vlj07jd2LFm
         qmGQ==
X-Gm-Message-State: AFqh2kq/383Qm0wW0/sgpj+RnMMj4iR4bRzYHynR9cbLtSLAAtiAnAgf
        0eU8xnyAhCKY1Df/Jww4NBlIilS11oHT7eNEso5nyedhyWA4enGeOCvUybZx/pxvETpBSv0bSUq
        Tigqa5l+F2ZNq
X-Received: by 2002:a6b:b416:0:b0:6eb:800e:949d with SMTP id d22-20020a6bb416000000b006eb800e949dmr8648362iof.0.1674169516988;
        Thu, 19 Jan 2023 15:05:16 -0800 (PST)
X-Google-Smtp-Source: AMrXdXs6ERqE0RkAcUTBVmnid+pf8TG+Rq0HOREmHEjhG/qvjhqpFuRkThnCwFnO4FLuMYYSVy4rug==
X-Received: by 2002:a6b:b416:0:b0:6eb:800e:949d with SMTP id d22-20020a6bb416000000b006eb800e949dmr8648345iof.0.1674169516716;
        Thu, 19 Jan 2023 15:05:16 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n2-20020a027142000000b00363cce75bffsm11336805jaf.151.2023.01.19.15.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 15:05:16 -0800 (PST)
Date:   Thu, 19 Jan 2023 16:05:14 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, cohuck@redhat.com,
        eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
        mjrosato@linux.ibm.com, chao.p.peng@linux.intel.com,
        yi.y.sun@linux.intel.com, peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: Re: [PATCH 09/13] vfio: Add infrastructure for bind_iommufd and
 attach
Message-ID: <20230119160514.0642cc21.alex.williamson@redhat.com>
In-Reply-To: <20230117134942.101112-10-yi.l.liu@intel.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
        <20230117134942.101112-10-yi.l.liu@intel.com>
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

On Tue, 17 Jan 2023 05:49:38 -0800
Yi Liu <yi.l.liu@intel.com> wrote:

> This prepares to add ioctls for device cdev fd. This infrastructure includes:
>     - add vfio_iommufd_attach() to support iommufd pgtable attach after
>       bind_iommufd. A NULL pt_id indicates detach.
>     - let vfio_iommufd_bind() to accept pt_id, e.g. the comapt_ioas_id in the
>       legacy group path, and also return back dev_id if caller requires it.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c     | 12 +++++-
>  drivers/vfio/iommufd.c   | 79 ++++++++++++++++++++++++++++++----------
>  drivers/vfio/vfio.h      | 15 ++++++--
>  drivers/vfio/vfio_main.c | 10 +++--
>  4 files changed, 88 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 7200304663e5..9484bb1c54a9 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -157,6 +157,8 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
>  static int vfio_device_group_open(struct vfio_device_file *df)
>  {
>  	struct vfio_device *device = df->device;
> +	u32 ioas_id;
> +	u32 *pt_id = NULL;
>  	int ret;
>  
>  	mutex_lock(&device->group->group_lock);
> @@ -165,6 +167,14 @@ static int vfio_device_group_open(struct vfio_device_file *df)
>  		goto err_unlock_group;
>  	}
>  
> +	if (device->group->iommufd) {
> +		ret = iommufd_vfio_compat_ioas_id(device->group->iommufd,
> +						  &ioas_id);
> +		if (ret)
> +			goto err_unlock_group;
> +		pt_id = &ioas_id;
> +	}
> +
>  	mutex_lock(&device->dev_set->lock);
>  	/*
>  	 * Here we pass the KVM pointer with the group under the lock.  If the
> @@ -174,7 +184,7 @@ static int vfio_device_group_open(struct vfio_device_file *df)
>  	df->kvm = device->group->kvm;
>  	df->iommufd = device->group->iommufd;
>  
> -	ret = vfio_device_open(df);
> +	ret = vfio_device_open(df, NULL, pt_id);
>  	if (ret)
>  		goto err_unlock_device;
>  	mutex_unlock(&device->dev_set->lock);
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 4f82a6fa7c6c..412644fdbf16 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -10,9 +10,17 @@
>  MODULE_IMPORT_NS(IOMMUFD);
>  MODULE_IMPORT_NS(IOMMUFD_VFIO);
>  
> -int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
> +/* @pt_id == NULL implies detach */
> +int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
> +{
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	return vdev->ops->attach_ioas(vdev, pt_id);
> +}


I find this patch pretty confusing, I think it's rooted in all these
multiplexed interfaces, which extend all the way out to userspace with
a magic, reserved page table ID to detach a device from an IOAS.  It
seems like it would be simpler to make a 'detach' API, a detach_ioas
callback on the vfio_device_ops, and certainly not an
vfio_iommufd_attach() function that does a detach provided the correct
args while also introducing a __vfio_iommufd_detach() function.

This series is also missing an update to
Documentation/driver-api/vfio.rst, which is already behind relative to
the iommufd interfaces.  Thanks,

Alex

