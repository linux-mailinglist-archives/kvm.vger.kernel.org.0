Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18BE70CE6B
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 01:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjEVXF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 19:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjEVXFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 19:05:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA3FC6
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 16:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684796674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w0+n/QgjpwGDdtheHaeJfYxk19jJm9VkMNETIgTtOVc=;
        b=cfzR2fdUIxt3JqCmhap49c1ofgHQSzDH6ym8CdZZKK36j6U3aJruuvT0Nlx/lBBpI/AY3x
        ZoRE9NkxEl2Nbo/cPGyNG/6z7t8x/TyxvbB/AOnjDbrdv0shulmvHdblGXW1+F2W4IRxCq
        Mbd+cmW1Bzx4EQShGOPwXoJMbYbr1D4=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-357-_juQ7Dn6OB-lr1ZVl6WKqw-1; Mon, 22 May 2023 19:04:33 -0400
X-MC-Unique: _juQ7Dn6OB-lr1ZVl6WKqw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-763da06540aso533624739f.3
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 16:04:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684796673; x=1687388673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w0+n/QgjpwGDdtheHaeJfYxk19jJm9VkMNETIgTtOVc=;
        b=Kv/R36xPLBoA5cfJNOiZtm3DPBTHkm3tZtz7YRgtcxjc95bK3AhsHm+mp8ldadC4Cg
         mkDJHqmQ4vYO/X6a809Z+/FVTy49dvx1ZojTdNaYNWkNDVSNuQaMkHyvkiufvJIs4TQq
         orv+T/5lCv7tp9a22iNJ396wmM5EqLMYJVKkf1fLAEoLpNZ7c2EgWQ3fO7GeYfU/Sxa0
         ZqpWatYM9y/pMbrH+9OfbswlvQvS4TimgihlUZ4KNWQcgvx7oAEIiiiV8b9hpXaFUm+i
         JCJ+Jr2+XdesJ+oaLSkfLWZeI7pbWvxBQXcbZgKTLNExbXl7SujE8MhmNzC8pHrHkVbu
         1DgQ==
X-Gm-Message-State: AC+VfDyKDiqHtDecFD0r3DtY2oUrjvOV9NF1UVBWgGVJO7ewv29MYYGZ
        kpz6u/mM5qz2tHbMuqZbDDOOUaciVqOskEeK01WKFlDovtBTT2TYXR5GQ1hmUCgnlABZFprO1HX
        bhQJ95hZHDGiw
X-Received: by 2002:a5e:890f:0:b0:76e:fbc6:347d with SMTP id k15-20020a5e890f000000b0076efbc6347dmr7364585ioj.20.1684796672722;
        Mon, 22 May 2023 16:04:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6Z8CUQuCHamNsEWTaswCX9W3UzFyBF5Ko9xA67aR5uOOig0LLcu/AMeAJp5EHdL25fonvk4A==
X-Received: by 2002:a5e:890f:0:b0:76e:fbc6:347d with SMTP id k15-20020a5e890f000000b0076efbc6347dmr7364559ioj.20.1684796672395;
        Mon, 22 May 2023 16:04:32 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x26-20020a0566380cba00b00411b2414eb5sm1999079jad.94.2023.05.22.16.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 16:04:31 -0700 (PDT)
Date:   Mon, 22 May 2023 17:04:29 -0600
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
Subject: Re: [PATCH v11 21/23] vfio: Determine noiommu device in
 __vfio_register_dev()
Message-ID: <20230522170429.2d5ca274.alex.williamson@redhat.com>
In-Reply-To: <20230513132827.39066-22-yi.l.liu@intel.com>
References: <20230513132827.39066-1-yi.l.liu@intel.com>
        <20230513132827.39066-22-yi.l.liu@intel.com>
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

On Sat, 13 May 2023 06:28:25 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This is to make the cdev path and group path consistent for the noiommu
> devices registration. If vfio_noiommu is disabled, such registration
> should fail. However, this check is vfio_device_set_group() which is part
> of the vfio_group code. If the vfio_group code is compiled out, noiommu
> devices would be registered even vfio_noiommu is disabled.
> 
> This adds vfio_device_set_noiommu() which can fail and calls it in the
> device registration. For now, it never fails as long as
> vfio_device_set_group() is successful. But when the vfio_group code is
> compiled out, vfio_device_set_noiommu() would fail the noiommu devices
> when vfio_noiommu is disabled.

I'm lost.  After the next patch we end up with the following when
CONFIG_VFIO_GROUP is set:

static inline int vfio_device_set_noiommu(struct vfio_device *device)
{
        device->noiommu = IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
                          device->group->type == VFIO_NO_IOMMU;
        return 0;
}

I think this is relying on the fact that vfio_device_set_group() which
is called immediately prior to this function would have performed the
testing for noiommu and failed prior to this function being called and
therefore there is no error return here.

Note also here that I think CONFIG_VFIO_NOIOMMU was only being tested
here previously so that a smart enough compiler would optimize out the
entire function, we can never set a VFIO_NO_IOMMU type when
!CONFIG_VFIO_NOIOMMU.  That's no longer the case if the function is
refactored like this.

When !CONFIG_VFIO_GROUP:

static inline int vfio_device_set_noiommu(struct vfio_device *device)
{
        struct iommu_group *iommu_group;

        iommu_group = iommu_group_get(device->dev);
        if (!iommu_group) {
                if (!IS_ENABLED(CONFIG_VFIO_NOIOMMU) || !vfio_noiommu)
                        return -EINVAL;
                device->noiommu = true;
        } else {
                iommu_group_put(iommu_group);
                device->noiommu = false;
        }

        return 0;
}

Here again, the NOIOMMU config option is irrelevant, vfio_noiommu can
only be true if the config option is enabled.  Therefore if there's no
IOMMU group and the module option to enable noiommu is not set, return
an error.

It's really quite ugly that in one mode we rely on this function to
generate the error and in the other mode it happens prior to getting
here.

The above could be simplified to something like:

	iommu_group = iommu_group_get(device->dev);
	if (!iommu_group && !vfio_iommu)
		return -EINVAL;

	device->noiommu = !iommu_group;
	iommu_group_put(iommu_group); /* Accepts NULL */
	return 0;

Which would actually work regardless of CONFIG_VFIO_GROUP, where maybe
this could then be moved before vfio_device_set_group() and become the
de facto exit point for invalid noiommu configurations and maybe we
could remove the test from the group code (with a comment to note that
it's been tested prior)?  Thanks,

Alex

> As noiommu devices is checked and there are multiple places which needs
> to test noiommu devices, this also adds a flag to mark noiommu devices.
> Hence the callers of vfio_device_is_noiommu() can be converted to test
> vfio_device->noiommu.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/device_cdev.c |  4 ++--
>  drivers/vfio/group.c       |  2 +-
>  drivers/vfio/iommufd.c     | 10 +++++-----
>  drivers/vfio/vfio.h        |  7 ++++---
>  drivers/vfio/vfio_main.c   |  6 +++++-
>  include/linux/vfio.h       |  1 +
>  6 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 3f14edb80a93..6d7f50ee535d 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -111,7 +111,7 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
>  	if (df->group)
>  		return -EINVAL;
>  
> -	if (vfio_device_is_noiommu(device) && !capable(CAP_SYS_RAWIO))
> +	if (device->noiommu && !capable(CAP_SYS_RAWIO))
>  		return -EPERM;
>  
>  	ret = vfio_device_block_group(device);
> @@ -157,7 +157,7 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
>  	device->cdev_opened = true;
>  	mutex_unlock(&device->dev_set->lock);
>  
> -	if (vfio_device_is_noiommu(device))
> +	if (device->noiommu)
>  		dev_warn(device->dev, "noiommu device is bound to iommufd by user "
>  			 "(%s:%d)\n", current->comm, task_pid_nr(current));
>  	return 0;
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index 7aacbd9d08c9..bf4335bce892 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -192,7 +192,7 @@ static int vfio_device_group_open(struct vfio_device_file *df)
>  		vfio_device_group_get_kvm_safe(device);
>  
>  	df->iommufd = device->group->iommufd;
> -	if (df->iommufd && vfio_device_is_noiommu(device) && device->open_count == 0) {
> +	if (df->iommufd && device->noiommu && device->open_count == 0) {
>  		ret = vfio_iommufd_compat_probe_noiommu(device,
>  							df->iommufd);
>  		if (ret)
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 799ea322a7d4..dfe706f1e952 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -71,7 +71,7 @@ int vfio_iommufd_bind(struct vfio_device_file *df)
>  
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> -	if (vfio_device_is_noiommu(vdev))
> +	if (vdev->noiommu)
>  		return vfio_iommufd_noiommu_bind(vdev, ictx, &df->devid);
>  
>  	return vdev->ops->bind_iommufd(vdev, ictx, &df->devid);
> @@ -86,7 +86,7 @@ int vfio_iommufd_compat_attach_ioas(struct vfio_device *vdev,
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
>  	/* compat noiommu does not need to do ioas attach */
> -	if (vfio_device_is_noiommu(vdev))
> +	if (vdev->noiommu)
>  		return 0;
>  
>  	ret = iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
> @@ -103,7 +103,7 @@ void vfio_iommufd_unbind(struct vfio_device_file *df)
>  
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> -	if (vfio_device_is_noiommu(vdev)) {
> +	if (vdev->noiommu) {
>  		vfio_iommufd_noiommu_unbind(vdev);
>  		return;
>  	}
> @@ -116,7 +116,7 @@ int vfio_iommufd_attach(struct vfio_device *vdev, u32 *pt_id)
>  {
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> -	if (vfio_device_is_noiommu(vdev))
> +	if (vdev->noiommu)
>  		return 0;
>  
>  	return vdev->ops->attach_ioas(vdev, pt_id);
> @@ -126,7 +126,7 @@ void vfio_iommufd_detach(struct vfio_device *vdev)
>  {
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> -	if (!vfio_device_is_noiommu(vdev))
> +	if (!vdev->noiommu)
>  		vdev->ops->detach_ioas(vdev);
>  }
>  
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 50553f67600f..c8579d63b2b9 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -106,10 +106,11 @@ bool vfio_device_has_container(struct vfio_device *device);
>  int __init vfio_group_init(void);
>  void vfio_group_cleanup(void);
>  
> -static inline bool vfio_device_is_noiommu(struct vfio_device *vdev)
> +static inline int vfio_device_set_noiommu(struct vfio_device *device)
>  {
> -	return IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> -	       vdev->group->type == VFIO_NO_IOMMU;
> +	device->noiommu = IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> +			  device->group->type == VFIO_NO_IOMMU;
> +	return 0;
>  }
>  
>  #if IS_ENABLED(CONFIG_VFIO_CONTAINER)
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 8c3f26b4929b..8979f320d620 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -289,8 +289,12 @@ static int __vfio_register_dev(struct vfio_device *device,
>  	if (ret)
>  		return ret;
>  
> +	ret = vfio_device_set_noiommu(device);
> +	if (ret)
> +		goto err_out;
> +
>  	ret = dev_set_name(&device->device, "%svfio%d",
> -			   vfio_device_is_noiommu(device) ? "noiommu-" : "", device->index);
> +			   device->noiommu ? "noiommu-" : "", device->index);
>  	if (ret)
>  		goto err_out;
>  
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index cf9d082a623c..fa13889e763f 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -68,6 +68,7 @@ struct vfio_device {
>  	bool iommufd_attached;
>  #endif
>  	bool cdev_opened:1;
> +	bool noiommu:1;
>  };
>  
>  /**

