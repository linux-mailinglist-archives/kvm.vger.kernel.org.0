Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89458670B9A
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 23:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjAQW0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Jan 2023 17:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjAQWZ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Jan 2023 17:25:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126274FCF9
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 14:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673992982;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6atE962YqCerk5PJ1CdBBLah7Xf1FhfgLosmRVXdXDQ=;
        b=AYI2ApgliDXjbNf7mYyYYhqv0UAi7D0uMFA/C7YC0nu+dQFL04x4/rjoowBlO1aqapL9uS
        3AOzTOT/v85FnAIpFD92/KHL4pimDrGESWMMmXavVlTQbdwfNWfD96lOlaGZA/QPP5Njbi
        QFY/92RHeMm16cuQZ+3dw9alHXkFTWA=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-353-4QhlnrWyPf6mC7DvCJjJsw-1; Tue, 17 Jan 2023 17:03:00 -0500
X-MC-Unique: 4QhlnrWyPf6mC7DvCJjJsw-1
Received: by mail-il1-f200.google.com with SMTP id i14-20020a056e020d8e00b003034b93bd07so23882985ilj.14
        for <kvm@vger.kernel.org>; Tue, 17 Jan 2023 14:02:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6atE962YqCerk5PJ1CdBBLah7Xf1FhfgLosmRVXdXDQ=;
        b=O4tb4IBTUoxsbWqAEywrXvbk3v4iNHNEoNyLH5Bzp0vHqwFGaIzIe7mJjfhq2QO6bk
         yYFVbvD3heRRVuW6uEpJf0IBSwKr18PziG9o3KijaBzu5rz4AOnrRVBTvn+GuK+r4Dun
         ZrzPAsKRaLpRlpTqpa5bIOEtYFPVE+SKey/C9tO98pafKuiE53+8VgjG1ID6I4DKX32Y
         GpQwmt2zeB4G4ynC3JcgR/eyRBFx1e3Zx0921IPP5rvejhIqJVeJLcVGBvhb4N+HoiWV
         Cla/nkQOCTWZwXvJLgUSArwxzlndRdx7tLYYTy57ZuAEiNg0qTFnSEz7ctmbVOLLXN5H
         LpLA==
X-Gm-Message-State: AFqh2koLiH/gmIVDDJcD3NW0kNA+yabk3boS0cQ2EsP6y+RhL8i3kHJf
        faMIvidIjVa1ew3bXM3KMhYFK/Kes29itnbTyr0ixS3hoaRai5Pcn+VrI/Gim+8J7wI8xaiL3uj
        bwI7Ga+6MRMSl
X-Received: by 2002:a05:6602:2489:b0:6df:9d01:3376 with SMTP id g9-20020a056602248900b006df9d013376mr3023811ioe.21.1673992978537;
        Tue, 17 Jan 2023 14:02:58 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsOqQ6T6RyX8VidoB4oC7CWvQzhCf/NlCQw+A6v6XcRPeYjU2ETi68fBg6eqGsGtMCT5JY+pg==
X-Received: by 2002:a05:6602:2489:b0:6df:9d01:3376 with SMTP id g9-20020a056602248900b006df9d013376mr3023797ioe.21.1673992978101;
        Tue, 17 Jan 2023 14:02:58 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w14-20020a02b0ce000000b003a5eae30e55sm955831jah.75.2023.01.17.14.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 14:02:57 -0800 (PST)
Date:   Tue, 17 Jan 2023 15:02:56 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2] vfio: Support VFIO_NOIOMMU with iommufd
Message-ID: <20230117150256.1937d343.alex.williamson@redhat.com>
In-Reply-To: <0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com>
References: <0-v2-568c93fef076+5a-iommufd_noiommu_jgg@nvidia.com>
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

On Tue, 10 Jan 2023 16:07:02 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Add a small amount of emulation to vfio_compat to accept the SET_IOMMU to
> VFIO_NOIOMMU_IOMMU and have vfio just ignore iommufd if it is working on a
> no-iommu enabled device.
> 
> Move the enable_unsafe_noiommu_mode module out of container.c into
> vfio_main.c so that it is always available even if VFIO_CONTAINER=n.
> 
> This passes Alex's mini-test:
> 
> https://github.com/awilliam/tests/blob/master/vfio-noiommu-pci-device-open.c
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/Kconfig           |   2 +-
>  drivers/iommu/iommufd/iommufd_private.h |   2 +
>  drivers/iommu/iommufd/vfio_compat.c     | 104 +++++++++++++++++++-----
>  drivers/vfio/Kconfig                    |   2 +-
>  drivers/vfio/container.c                |   7 --
>  drivers/vfio/group.c                    |   7 +-
>  drivers/vfio/iommufd.c                  |  21 ++++-
>  drivers/vfio/vfio_main.c                |   7 ++
>  include/linux/iommufd.h                 |  12 ++-
>  9 files changed, 130 insertions(+), 34 deletions(-)
> 
> v2:
>  - Passes Alex's test
>  - Fix a spelling error for s/CONFIG_VFIO_NO_IOMMU/CONFIG_VFIO_NOIOMMU/
>  - Prevent type1 mode from being requested and prevent a compat IOAS from being
>    auto created with an additional context global trap door flag
>  - Make it so VFIO_CONTAINER=n still creates the module option and related machinery
>  - Comment updates
> v1: https://lore.kernel.org/all/0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com
> 
> 
> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
> index 8306616b6d8198..ada693ea51a78e 100644
> --- a/drivers/iommu/iommufd/Kconfig
> +++ b/drivers/iommu/iommufd/Kconfig
> @@ -23,7 +23,7 @@ config IOMMUFD_VFIO_CONTAINER
>  	  removed.
>  
>  	  IOMMUFD VFIO container emulation is known to lack certain features
> -	  of the native VFIO container, such as no-IOMMU support, peer-to-peer
> +	  of the native VFIO container, such as peer-to-peer
>  	  DMA mapping, PPC IOMMU support, as well as other potentially
>  	  undiscovered gaps.  This option is currently intended for the
>  	  purpose of testing IOMMUFD with unmodified userspace supporting VFIO
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index 222e86591f8ac9..9d7f71510ca1bc 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -18,6 +18,8 @@ struct iommufd_ctx {
>  	struct xarray objects;
>  
>  	u8 account_mode;
> +	/* Compatibility with VFIO no iommu */
> +	u8 no_iommu_mode;
>  	struct iommufd_ioas *vfio_ioas;
>  };
>  
> diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
> index 3ceca0e8311c39..2c9db251a351e6 100644
> --- a/drivers/iommu/iommufd/vfio_compat.c
> +++ b/drivers/iommu/iommufd/vfio_compat.c
> @@ -26,39 +26,83 @@ static struct iommufd_ioas *get_compat_ioas(struct iommufd_ctx *ictx)
>  }
>  
>  /**
> - * iommufd_vfio_compat_ioas_id - Return the IOAS ID that vfio should use
> + * iommufd_vfio_compat_ioas_get_id - Ensure a compat IOAS exists
> + * @ictx: Context to operate on


Nit, @out_ioas_id should be explicitly documented here rather than
inferred from the comments.


> + *
> + * Return the ID of the current compatibility ioas. The ID can be passed into
> + * other functions that take an ioas_id.
> + */
> +int iommufd_vfio_compat_ioas_get_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
> +{
> +	struct iommufd_ioas *ioas;
> +
> +	ioas = get_compat_ioas(ictx);
> +	if (IS_ERR(ioas))
> +		return PTR_ERR(ioas);
> +	*out_ioas_id = ioas->obj.id;
> +	iommufd_put_object(&ioas->obj);
> +	return 0;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_get_id, IOMMUFD_VFIO);
> +
> +/**
> + * iommufd_vfio_compat_set_no_iommu - Called when a no-iommu device is attached
> + * @ictx: Context to operate on
> + *
> + * This allows selecting the VFIO_NOIOMMU_IOMMU and blocks normal types.
> + */
> +int iommufd_vfio_compat_set_no_iommu(struct iommufd_ctx *ictx)
> +{
> +	int ret;
> +
> +	xa_lock(&ictx->objects);
> +	if (!ictx->vfio_ioas) {
> +		ictx->no_iommu_mode = 1;
> +		ret = 0;
> +	} else {
> +		ret = -EINVAL;
> +	}
> +	xa_unlock(&ictx->objects);
> +	return ret;
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_set_no_iommu, IOMMUFD_VFIO);
> +
> +/**
> + * iommufd_vfio_compat_ioas_create - Ensure the compat IOAS is created
>   * @ictx: Context to operate on
> - * @out_ioas_id: The ioas_id the caller should use
>   *
>   * The compatibility IOAS is the IOAS that the vfio compatibility ioctls operate
>   * on since they do not have an IOAS ID input in their ABI. Only attaching a
> - * group should cause a default creation of the internal ioas, this returns the
> - * existing ioas if it has already been assigned somehow.
> + * group should cause a default creation of the internal ioas, this does nothing
> + * if an existing ioas has already been assigned somehow.
>   */
> -int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
> +int iommufd_vfio_compat_ioas_create(struct iommufd_ctx *ictx)
>  {
>  	struct iommufd_ioas *ioas = NULL;
> -	struct iommufd_ioas *out_ioas;
> +	int ret;
>  
>  	ioas = iommufd_ioas_alloc(ictx);
>  	if (IS_ERR(ioas))
>  		return PTR_ERR(ioas);
>  
>  	xa_lock(&ictx->objects);
> -	if (ictx->vfio_ioas && iommufd_lock_obj(&ictx->vfio_ioas->obj))
> -		out_ioas = ictx->vfio_ioas;
> -	else {
> -		out_ioas = ioas;
> -		ictx->vfio_ioas = ioas;
> +	/*
> +	 * VFIO won't allow attaching a container to both iommu and no iommu
> +	 * operation
> +	 */
> +	if (ictx->no_iommu_mode) {
> +		ret = -EINVAL;
> +		goto out_abort;
>  	}
> -	xa_unlock(&ictx->objects);
>  
> -	*out_ioas_id = out_ioas->obj.id;
> -	if (out_ioas != ioas) {
> -		iommufd_put_object(&out_ioas->obj);
> -		iommufd_object_abort(ictx, &ioas->obj);
> -		return 0;
> +	if (ictx->vfio_ioas && iommufd_lock_obj(&ictx->vfio_ioas->obj)) {
> +		ret = 0;
> +		iommufd_put_object(&ictx->vfio_ioas->obj);
> +		goto out_abort;
>  	}
> +	ictx->vfio_ioas = ioas;
> +	xa_unlock(&ictx->objects);
> +
>  	/*
>  	 * An automatically created compat IOAS is treated as a userspace
>  	 * created object. Userspace can learn the ID via IOMMU_VFIO_IOAS_GET,
> @@ -67,8 +111,13 @@ int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
>  	 */
>  	iommufd_object_finalize(ictx, &ioas->obj);
>  	return 0;
> +
> +out_abort:
> +	xa_unlock(&ictx->objects);
> +	iommufd_object_abort(ictx, &ioas->obj);
> +	return ret;
>  }
> -EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_id, IOMMUFD_VFIO);
> +EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_create, IOMMUFD_VFIO);
>  
>  int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd)
>  {
> @@ -235,6 +284,9 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
>  	case VFIO_UNMAP_ALL:
>  		return 1;
>  
> +	case VFIO_NOIOMMU_IOMMU:
> +	return IS_ENABLED(CONFIG_VFIO_NOIOMMU);


Whitespace


> +
>  	case VFIO_DMA_CC_IOMMU:
>  		return iommufd_vfio_cc_iommu(ictx);
>  
> @@ -261,10 +313,24 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
>  
>  static int iommufd_vfio_set_iommu(struct iommufd_ctx *ictx, unsigned long type)
>  {
> +	bool no_iommu_mode = READ_ONCE(ictx->no_iommu_mode);
>  	struct iommufd_ioas *ioas = NULL;
>  	int rc = 0;
>  
> -	if (type != VFIO_TYPE1_IOMMU && type != VFIO_TYPE1v2_IOMMU)
> +	/*
> +	 * Emulation for NOIOMMU is imperfect in that VFIO blocks almost all
> +	 * other ioctls. We let them keep working but they mostly fail since no
> +	 * IOAS should exist.
> +	 */
> +	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) && type == VFIO_NOIOMMU_IOMMU &&
> +	    no_iommu_mode) {
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +		return 0;
> +	}
> +
> +	if ((type != VFIO_TYPE1_IOMMU && type != VFIO_TYPE1v2_IOMMU) ||
> +	    no_iommu_mode)
>  		return -EINVAL;
>  
>  	/* VFIO fails the set_iommu if there is no group */
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index a8f54462946742..89e06c981e435d 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -32,6 +32,7 @@ config VFIO_IOMMU_SPAPR_TCE
>  	tristate
>  	depends on SPAPR_TCE_IOMMU
>  	default VFIO
> +endif
>  
>  config VFIO_NOIOMMU
>  	bool "VFIO No-IOMMU support"
> @@ -46,7 +47,6 @@ config VFIO_NOIOMMU
>  	  this mode since there is no IOMMU to provide DMA translation.
>  
>  	  If you don't know what to do here, say N.
> -endif
>  
>  config VFIO_VIRQFD
>  	bool
> diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
> index b7a9560ab25e48..89f10becf96255 100644
> --- a/drivers/vfio/container.c
> +++ b/drivers/vfio/container.c
> @@ -29,13 +29,6 @@ static struct vfio {
>  	struct mutex			iommu_drivers_lock;
>  } vfio;
>  
> -#ifdef CONFIG_VFIO_NOIOMMU
> -bool vfio_noiommu __read_mostly;
> -module_param_named(enable_unsafe_noiommu_mode,
> -		   vfio_noiommu, bool, S_IRUGO | S_IWUSR);
> -MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
> -#endif
> -
>  static void *vfio_noiommu_open(unsigned long arg)
>  {
>  	if (arg != VFIO_NOIOMMU_IOMMU)
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index bb24b2f0271e03..e166ad7ce6e755 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -133,9 +133,12 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
>  
>  	iommufd = iommufd_ctx_from_file(f.file);
>  	if (!IS_ERR(iommufd)) {
> -		u32 ioas_id;
> +		if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> +		    group->type == VFIO_NO_IOMMU)


We can't have type == VFIO_NO_IOMMU without CONFIG_VFIO_NOIOMMU in any
of these cases, so I'm assuming the IS_ENABLED() is just a
micro-optimization for the compiler here.  It's repeated enough that
maybe it deserves a macro though.  Thanks,

Alex


> +			ret = iommufd_vfio_compat_set_no_iommu(iommufd);
> +		else
> +			ret = iommufd_vfio_compat_ioas_create(iommufd);
>  
> -		ret = iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
>  		if (ret) {
>  			iommufd_ctx_put(group->iommufd);
>  			goto out_unlock;
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 4f82a6fa7c6c7f..79a781a4e74c09 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -18,6 +18,21 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
>  
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> +	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> +	    vdev->group->type == VFIO_NO_IOMMU) {
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +
> +		/*
> +		 * Require no compat ioas to be assigned to proceed. The basic
> +		 * statement is that the user cannot have done something that
> +		 * implies they expected translation to exist
> +		 */
> +		if (!iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id))
> +			return -EPERM;
> +		return 0;
> +	}
> +
>  	/*
>  	 * If the driver doesn't provide this op then it means the device does
>  	 * not do DMA at all. So nothing to do.
> @@ -29,7 +44,7 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
>  	if (ret)
>  		return ret;
>  
> -	ret = iommufd_vfio_compat_ioas_id(ictx, &ioas_id);
> +	ret = iommufd_vfio_compat_ioas_get_id(ictx, &ioas_id);
>  	if (ret)
>  		goto err_unbind;
>  	ret = vdev->ops->attach_ioas(vdev, &ioas_id);
> @@ -52,6 +67,10 @@ void vfio_iommufd_unbind(struct vfio_device *vdev)
>  {
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> +	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) &&
> +	    vdev->group->type == VFIO_NO_IOMMU)
> +		return;
> +
>  	if (vdev->ops->unbind_iommufd)
>  		vdev->ops->unbind_iommufd(vdev);
>  }
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 5177bb061b17b5..90541fc949888c 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -45,6 +45,13 @@ static struct vfio {
>  	struct ida			device_ida;
>  } vfio;
>  
> +#ifdef CONFIG_VFIO_NOIOMMU
> +bool vfio_noiommu __read_mostly;
> +module_param_named(enable_unsafe_noiommu_mode,
> +		   vfio_noiommu, bool, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(enable_unsafe_noiommu_mode, "Enable UNSAFE, no-IOMMU mode.  This mode provides no device isolation, no DMA translation, no host kernel protection, cannot be used for device assignment to virtual machines, requires RAWIO permissions, and will taint the kernel.  If you do not know what this is for, step away. (default: false)");
> +#endif
> +
>  static DEFINE_XARRAY(vfio_device_set_xa);
>  
>  int vfio_assign_device_set(struct vfio_device *device, void *set_id)
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index 650d45629647a7..c0b5b3ac34f1e0 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -57,7 +57,9 @@ void iommufd_access_unpin_pages(struct iommufd_access *access,
>  				unsigned long iova, unsigned long length);
>  int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
>  		      void *data, size_t len, unsigned int flags);
> -int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id);
> +int iommufd_vfio_compat_ioas_get_id(struct iommufd_ctx *ictx, u32 *out_ioas_id);
> +int iommufd_vfio_compat_ioas_create(struct iommufd_ctx *ictx);
> +int iommufd_vfio_compat_set_no_iommu(struct iommufd_ctx *ictx);
>  #else /* !CONFIG_IOMMUFD */
>  static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
>  {
> @@ -89,8 +91,12 @@ static inline int iommufd_access_rw(struct iommufd_access *access, unsigned long
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx,
> -					      u32 *out_ioas_id)
> +static inline int iommufd_vfio_compat_ioas_create(struct iommufd_ctx *ictx)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline int iommufd_vfio_compat_set_no_iommu(struct iommufd_ctx *ictx)
>  {
>  	return -EOPNOTSUPP;
>  }
> 
> base-commit: b7bfaa761d760e72a969d116517eaa12e404c262

