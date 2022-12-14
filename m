Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A2F64D027
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 20:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238844AbiLNTlL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 14:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiLNTlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 14:41:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0B42A416
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 11:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671046820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WWr2JpmaAQj4wQDdwE2Fml4T7VCi1X9I6ZfS/fOhsa4=;
        b=LbZZL+6V7p+weAUIFgxf0l0kIqe4K1YSNMinz5ATqyhYbtBCumDJkCSkm5SRxKxMylfGHa
        MXYowWsijnJAEqywAPX4/KW2t1eNT8n3EArl2YDI/mOqWkWCfPrc5Xi04IzrohlW+BYL11
        rp+gkLsyUQXDcO1XMkZxtEqRaHZXwBc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-310-nuqyfRprPcW4U3Ad5JgM_w-1; Wed, 14 Dec 2022 14:40:19 -0500
X-MC-Unique: nuqyfRprPcW4U3Ad5JgM_w-1
Received: by mail-io1-f72.google.com with SMTP id n10-20020a6b590a000000b006e03471b3eeso4446975iob.11
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 11:40:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WWr2JpmaAQj4wQDdwE2Fml4T7VCi1X9I6ZfS/fOhsa4=;
        b=A4rSnPP6DaNp2VsoEI1aGgK2LfZaALhoTqDVCNyosLOAo5kex7YnnsorbQ91vsLOtI
         LeUBa2N6vNOmJkO+pEenZGXMhP+733yt6J2vwHpakytvR5zpKLX2MYlDg3xm6jLyRDeH
         aUe4UumAmZWfolKMzui1xLQsK9unxSUHHRXJfzlH+X4tUoNoHYwDPhg92B0CM7KKI1R4
         IuPW971D4TL4UmliVI+U76G77FGCSQPs90wMVEA7kC9uereO25zljgBDZY4VCG3StNfr
         VHSuQEr0bCnLnFBiD9jgpmNVIXvzE4973PDO6Nvpppl1ojVKG7Yf7OlS/Snq+twv5tgo
         hoUg==
X-Gm-Message-State: ANoB5pkjoZEGZZ2aXxIXrLKyKK0ACeLa9qZ6rAwnnnt5y5TYDZ4YCFCi
        1v3errv7EebRPY4A7LucEFLhkFo+CREr3ET7BG6EqDsnlL79fWukXbEdezEmppDGNYOvnSgChe7
        SmS7XtDP1Sz80
X-Received: by 2002:a5e:c118:0:b0:6e3:c112:3339 with SMTP id v24-20020a5ec118000000b006e3c1123339mr4877675iol.16.1671046818252;
        Wed, 14 Dec 2022 11:40:18 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5yWz+8qN43yXBmxmZi8YTGRuVJT70fCXyblTIk2GU466no12g9buhKxiVJ3iwuy1ZAegSTtw==
X-Received: by 2002:a5e:c118:0:b0:6e3:c112:3339 with SMTP id v24-20020a5ec118000000b006e3c1123339mr4877635iol.16.1671046817889;
        Wed, 14 Dec 2022 11:40:17 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z14-20020a05660229ce00b006cf3a1c02e6sm245842ioq.15.2022.12.14.11.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 11:40:17 -0800 (PST)
Date:   Wed, 14 Dec 2022 12:40:15 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V3 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Message-ID: <20221214124015.36c1fd52.alex.williamson@redhat.com>
In-Reply-To: <1671045771-59788-2-git-send-email-steven.sistare@oracle.com>
References: <1671045771-59788-1-git-send-email-steven.sistare@oracle.com>
        <1671045771-59788-2-git-send-email-steven.sistare@oracle.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
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

On Wed, 14 Dec 2022 11:22:47 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
> Their kernel threads could be blocked indefinitely by a misbehaving
> userland while trying to pin/unpin pages while vaddrs are being updated.
> 
> Do not allow groups to be added to the container while vaddr's are invalid,
> so we never need to block user threads from pinning, and can delete the
> vaddr-waiting code in a subsequent patch.
> 
> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 41 +++++++++++++++++++++++++++++++++++++++--
>  include/uapi/linux/vfio.h       | 15 +++++++++------
>  2 files changed, 48 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 23c24fe..b04f485 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -861,6 +861,12 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  
>  	mutex_lock(&iommu->lock);
>  
> +	if (iommu->vaddr_invalid_count) {
> +		WARN_ONCE(1, "mdev not allowed with VFIO_UPDATE_VADDR\n");
> +		ret = -EIO;
> +		goto pin_done;
> +	}
> +

This simplifies to:

	if (WARN_ONCE(iommu->vaddr_invalid_count,
		      "mdev not allowed	with VFIO_UPDATE_VADDR\n")) {
		ret = -EIO;
		goto pin_done;
	}

I was sort of figuring this would be a -EPERM or -EBUSY, maybe even
-EAGAIN, though perhaps it's academic which errno to return if we
should never get here.

>  	/*
>  	 * Wait for all necessary vaddr's to be valid so they can be used in
>  	 * the main loop without dropping the lock, to avoid racing vs unmap.
> @@ -1343,6 +1349,12 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  
>  	mutex_lock(&iommu->lock);
>  
> +	/* Cannot update vaddr if mdev is present. */
> +	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups)) {
> +		ret = -EIO;
> +		goto unlock;
> +	}
> +

On the other hand, this errno is reachable by the user, and I'm not
sure -EIO is the best choice for a condition that's blocked due to use
configuration.

>  	pgshift = __ffs(iommu->pgsize_bitmap);
>  	pgsize = (size_t)1 << pgshift;
>  
> @@ -2185,11 +2197,16 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  	struct iommu_domain_geometry *geo;
>  	LIST_HEAD(iova_copy);
>  	LIST_HEAD(group_resv_regions);
> -	int ret = -EINVAL;
> +	int ret = -EIO;
>  
>  	mutex_lock(&iommu->lock);
>  
> +	/* Attach could require pinning, so disallow while vaddr is invalid. */
> +	if (iommu->vaddr_invalid_count)
> +		goto out_unlock;
> +

Also user reachable, so should track if we pick another errno.

>  	/* Check for duplicates */
> +	ret = -EINVAL;
>  	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
>  		goto out_unlock;
>  
> @@ -2660,6 +2677,16 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
>  	return ret;
>  }
>  
> +static int vfio_iommu_has_emulated(struct vfio_iommu *iommu)
> +{
> +	int ret;
> +
> +	mutex_lock(&iommu->lock);
> +	ret = !list_empty(&iommu->emulated_iommu_groups);
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}

Nit, this could return bool.  I suppose it doesn't because the below
returns int, but it seems we're already in the realm of creating a
boolean value there.

> +
>  static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>  					    unsigned long arg)
>  {
> @@ -2668,8 +2695,13 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>  	case VFIO_TYPE1v2_IOMMU:
>  	case VFIO_TYPE1_NESTING_IOMMU:
>  	case VFIO_UNMAP_ALL:
> -	case VFIO_UPDATE_VADDR:
>  		return 1;
> +	case VFIO_UPDATE_VADDR:
> +		/*
> +		 * Disable this feature if mdevs are present.  They cannot
> +		 * safely pin/unpin while vaddrs are being updated.
> +		 */
> +		return iommu && !vfio_iommu_has_emulated(iommu);
>  	case VFIO_DMA_CC_IOMMU:
>  		if (!iommu)
>  			return 0;
> @@ -3080,6 +3112,11 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>  	size_t offset;
>  	int ret;
>  
> +	if (iommu->vaddr_invalid_count) {
> +		WARN_ONCE(1, "mdev not allowed with VFIO_UPDATE_VADDR\n");
> +		return -EIO;
> +	}

Same optimization above, but why are we letting the code iterate this
multiple times in the _chunk function rather than testing once in the
caller?  Thanks,

Alex

> +
>  	*copied = 0;
>  
>  	ret = vfio_find_dma_valid(iommu, user_iova, 1, &dma);
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index d7d8e09..4e8d344 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -49,7 +49,11 @@
>  /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
>  #define VFIO_UNMAP_ALL			9
>  
> -/* Supports the vaddr flag for DMA map and unmap */
> +/*
> + * Supports the vaddr flag for DMA map and unmap.  Not supported for mediated
> + * devices, so this capability is subject to change as groups are added or
> + * removed.
> + */
>  #define VFIO_UPDATE_VADDR		10
>  
>  /*
> @@ -1215,8 +1219,7 @@ struct vfio_iommu_type1_info_dma_avail {
>   * Map process virtual addresses to IO virtual addresses using the
>   * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
>   *
> - * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
> - * unblock translation of host virtual addresses in the iova range.  The vaddr
> + * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova. The vaddr
>   * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
>   * maintain memory consistency within the user application, the updated vaddr
>   * must address the same memory object as originally mapped.  Failure to do so
> @@ -1267,9 +1270,9 @@ struct vfio_bitmap {
>   * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
>   *
>   * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
> - * virtual addresses in the iova range.  Tasks that attempt to translate an
> - * iova's vaddr will block.  DMA to already-mapped pages continues.  This
> - * cannot be combined with the get-dirty-bitmap flag.
> + * virtual addresses in the iova range.  DMA to already-mapped pages continues.
> + * Groups may not be added to the container while any addresses are invalid.
> + * This cannot be combined with the get-dirty-bitmap flag.
>   */
>  struct vfio_iommu_type1_dma_unmap {
>  	__u32	argsz;

