Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B492663559
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 00:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbjAIXff (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 18:35:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233794AbjAIXfd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 18:35:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B9112743
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 15:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673307279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FozQ3/c6RDpTVE/6HP5M15UZWmYfpOpcHl1wdMdjQAg=;
        b=FFCO6zqSjTIL062oagPiELRXWQTGplSTQE0t2x/lZNGp0FXRQKu3uO6KzCAgdyBBR8Vrpl
        znLIIxGsS3N3yDoE8tpeUV1ydeNuls3LS8JBIU7g2szuw17mKCC8bv/6p8Y4695o2hEWUO
        G91BtgJE3TGzDcCmKprUYXTdQsu0Jtg=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-546-cC6GYK8_N-CRghPV_mFe8g-1; Mon, 09 Jan 2023 18:34:39 -0500
X-MC-Unique: cC6GYK8_N-CRghPV_mFe8g-1
Received: by mail-io1-f70.google.com with SMTP id y23-20020a056602201700b006e408c1d2a1so5903343iod.1
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 15:34:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FozQ3/c6RDpTVE/6HP5M15UZWmYfpOpcHl1wdMdjQAg=;
        b=5puu+5Y32Gt+u+A8wOBaD3OzX0xp31Vl2jHwpmctXfo2X0V4hnjFnfBynS3m5uZ9xr
         rXLgsC6nHupEkePSL1imalG1bZ6s+kmCuEtfpR21r5G7fmMvC152yjtyYrSI5DTbSWPY
         uiSM4vwlKmCuz7yGGLO+mzuRk+Ddv27EtnGzygsBJVDfmuxdRLZAfZeW6JizukITmIRC
         mF27su9RpvKbqMZhBY+g6tsSlZIlttDJsTgKI0jdxDeUoetmLZoFJ2YABC5qakzZTW5Z
         ZvnJulF6wICs3zBgLduoKTuAWsFwSRkHSGsfedgqfKn1ULG4GdBOp2nOTIrw9U7HA6C9
         sl+g==
X-Gm-Message-State: AFqh2kqr0SsOVHGe8wXrbMU0DbsM4H4PCFGRTxidjKPGH7aoXBbfV5DK
        PIaZ1hjr/FGlCwd8hLklD/uw7hHfYHtGIRra+1bu17zSdULL9Xyvt0bv+VQqfP7Iz0LKuJp4RXN
        8KW89Z4g+aCHE
X-Received: by 2002:a5d:9043:0:b0:6e0:58c:fb32 with SMTP id v3-20020a5d9043000000b006e0058cfb32mr47569112ioq.2.1673307277685;
        Mon, 09 Jan 2023 15:34:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvxxbAe0TsNAdKrk8Q3h9bNEzmrl0aiL9ZGXDzoCk4MVPzXVGkLYEdDLSITN+/8NYceFI3/Aw==
X-Received: by 2002:a5d:9043:0:b0:6e0:58c:fb32 with SMTP id v3-20020a5d9043000000b006e0058cfb32mr47569104ioq.2.1673307277329;
        Mon, 09 Jan 2023 15:34:37 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a14-20020a02734e000000b0039e90ba37e3sm707498jae.43.2023.01.09.15.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 15:34:36 -0800 (PST)
Date:   Mon, 9 Jan 2023 16:34:34 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH] vfio: Support VFIO_NOIOMMU with iommufd
Message-ID: <20230109163434.6311b4a6.alex.williamson@redhat.com>
In-Reply-To: <0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com>
References: <0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com>
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

On Mon,  9 Jan 2023 10:22:59 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> Add a small amount of emulation to vfio_compat to accept the SET_IOMMU
> to VFIO_NOIOMMU_IOMMU and have vfio just ignore iommufd if it is working
> on a no-iommu enabled device.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/Kconfig       |  2 +-
>  drivers/iommu/iommufd/vfio_compat.c | 46 ++++++++++++++++++++++++-----
>  drivers/vfio/group.c                | 13 ++++----
>  drivers/vfio/iommufd.c              | 21 ++++++++++++-
>  include/linux/iommufd.h             |  6 ++--
>  5 files changed, 70 insertions(+), 18 deletions(-)
> 
> This needs a testing confirmation with dpdk to go forward, thanks

How do we create a noiommu group w/o the vfio_noiommu flag that's
provided by container.c?  Even without dpdk, you should be able to turn
off the system IOMMU and get something bound to vfio-pci that still
taints the kernel and provides a noiommu-%d group under /dev/vfio/.
There's a rudimentary unit test for noiommu here[1].  Thanks,

Alex

[1]https://github.com/awilliam/tests/blob/master/vfio-noiommu-pci-device-open.c

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
> diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
> index 3ceca0e8311c39..6c8e5dc1c221f4 100644
> --- a/drivers/iommu/iommufd/vfio_compat.c
> +++ b/drivers/iommu/iommufd/vfio_compat.c
> @@ -26,16 +26,35 @@ static struct iommufd_ioas *get_compat_ioas(struct iommufd_ctx *ictx)
>  }
>  
>  /**
> - * iommufd_vfio_compat_ioas_id - Return the IOAS ID that vfio should use
> + * iommufd_vfio_compat_ioas_get_id - Ensure a comat IOAS exists
> + * @ictx: Context to operate on
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
> + * iommufd_vfio_compat_ioas_create_id - Return the IOAS ID that vfio should use
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
> +int iommufd_vfio_compat_ioas_create_id(struct iommufd_ctx *ictx)
>  {
>  	struct iommufd_ioas *ioas = NULL;
>  	struct iommufd_ioas *out_ioas;
> @@ -53,7 +72,6 @@ int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
>  	}
>  	xa_unlock(&ictx->objects);
>  
> -	*out_ioas_id = out_ioas->obj.id;
>  	if (out_ioas != ioas) {
>  		iommufd_put_object(&out_ioas->obj);
>  		iommufd_object_abort(ictx, &ioas->obj);
> @@ -68,7 +86,7 @@ int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id)
>  	iommufd_object_finalize(ictx, &ioas->obj);
>  	return 0;
>  }
> -EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_id, IOMMUFD_VFIO);
> +EXPORT_SYMBOL_NS_GPL(iommufd_vfio_compat_ioas_create_id, IOMMUFD_VFIO);
>  
>  int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd)
>  {
> @@ -235,6 +253,9 @@ static int iommufd_vfio_check_extension(struct iommufd_ctx *ictx,
>  	case VFIO_UNMAP_ALL:
>  		return 1;
>  
> +	case VFIO_NOIOMMU_IOMMU:
> +	return IS_ENABLED(CONFIG_VFIO_NOIOMMU);
> +
>  	case VFIO_DMA_CC_IOMMU:
>  		return iommufd_vfio_cc_iommu(ictx);
>  
> @@ -264,6 +285,17 @@ static int iommufd_vfio_set_iommu(struct iommufd_ctx *ictx, unsigned long type)
>  	struct iommufd_ioas *ioas = NULL;
>  	int rc = 0;
>  
> +	/*
> +	 * Emulation for NOIMMU is imperfect in that VFIO blocks almost all
> +	 * other ioctls. We let them keep working but they mostly fail since no
> +	 * IOAS should exist.
> +	 */
> +	if (IS_ENABLED(CONFIG_VFIO_NOIOMMU) && type == VFIO_NOIOMMU_IOMMU) {
> +		if (!capable(CAP_SYS_RAWIO))
> +			return -EPERM;
> +		return 0;
> +	}
> +
>  	if (type != VFIO_TYPE1_IOMMU && type != VFIO_TYPE1v2_IOMMU)
>  		return -EINVAL;
>  
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index bb24b2f0271e03..0f2a483a1f3bdb 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -133,12 +133,13 @@ static int vfio_group_ioctl_set_container(struct vfio_group *group,
>  
>  	iommufd = iommufd_ctx_from_file(f.file);
>  	if (!IS_ERR(iommufd)) {
> -		u32 ioas_id;
> -
> -		ret = iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
> -		if (ret) {
> -			iommufd_ctx_put(group->iommufd);
> -			goto out_unlock;
> +		if (!IS_ENABLED(CONFIG_VFIO_NO_IOMMU) ||
> +		    group->type != VFIO_NO_IOMMU) {
> +			ret = iommufd_vfio_compat_ioas_create_id(iommufd);
> +			if (ret) {
> +				iommufd_ctx_put(group->iommufd);
> +				goto out_unlock;
> +			}
>  		}
>  
>  		group->iommufd = iommufd;
> diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
> index 4f82a6fa7c6c7f..da50feb24b6e1d 100644
> --- a/drivers/vfio/iommufd.c
> +++ b/drivers/vfio/iommufd.c
> @@ -18,6 +18,21 @@ int vfio_iommufd_bind(struct vfio_device *vdev, struct iommufd_ctx *ictx)
>  
>  	lockdep_assert_held(&vdev->dev_set->lock);
>  
> +	if (IS_ENABLED(CONFIG_VFIO_NO_IOMMU) &&
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
> +	if (IS_ENABLED(CONFIG_VFIO_NO_IOMMU) &&
> +	    vdev->group->type == VFIO_NO_IOMMU)
> +		return;
> +
>  	if (vdev->ops->unbind_iommufd)
>  		vdev->ops->unbind_iommufd(vdev);
>  }
> diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
> index 650d45629647a7..9d1afd417215d0 100644
> --- a/include/linux/iommufd.h
> +++ b/include/linux/iommufd.h
> @@ -57,7 +57,8 @@ void iommufd_access_unpin_pages(struct iommufd_access *access,
>  				unsigned long iova, unsigned long length);
>  int iommufd_access_rw(struct iommufd_access *access, unsigned long iova,
>  		      void *data, size_t len, unsigned int flags);
> -int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx, u32 *out_ioas_id);
> +int iommufd_vfio_compat_ioas_get_id(struct iommufd_ctx *ictx, u32 *out_ioas_id);
> +int iommufd_vfio_compat_ioas_create_id(struct iommufd_ctx *ictx);
>  #else /* !CONFIG_IOMMUFD */
>  static inline struct iommufd_ctx *iommufd_ctx_from_file(struct file *file)
>  {
> @@ -89,8 +90,7 @@ static inline int iommufd_access_rw(struct iommufd_access *access, unsigned long
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline int iommufd_vfio_compat_ioas_id(struct iommufd_ctx *ictx,
> -					      u32 *out_ioas_id)
> +static inline int iommufd_vfio_compat_ioas_create_id(struct iommufd_ctx *ictx)
>  {
>  	return -EOPNOTSUPP;
>  }
> 
> base-commit: 88603b6dc419445847923fcb7fe5080067a30f98

