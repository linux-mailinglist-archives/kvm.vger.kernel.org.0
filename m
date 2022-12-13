Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E903F64BDEB
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 21:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbiLMU3l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 15:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiLMU25 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 15:28:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85A9767A
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 12:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670962971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v2Dm5LnCOLTySKzdtt7rX+X8eVAkaGHG4gTN1wON7BM=;
        b=Xk8ceWIzlcJySZBY/h05msZD14/Qcb4YEC/PT//4ynUpO25s3DhBUxHpubuqLNwB7G8jXt
        xBqUiwo2k51IkaNScWUW4s7Ahfr5uWxtZ87Q71PwkRCwbDmMomrerygYf8Yf39WoJt1Dts
        duUHSsx3GtYFguTS4rEmOL16JFIdf1E=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-363-r4-eRoACNcy5ZixQkfV5lA-1; Tue, 13 Dec 2022 15:22:49 -0500
X-MC-Unique: r4-eRoACNcy5ZixQkfV5lA-1
Received: by mail-io1-f71.google.com with SMTP id r25-20020a6bfc19000000b006e002cb217fso2612665ioh.2
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 12:22:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v2Dm5LnCOLTySKzdtt7rX+X8eVAkaGHG4gTN1wON7BM=;
        b=0E73cK4o3/OYyE7nxCmP4MtjRzyURcEqkNnf95MBOsmJ3bDbaSTTFvWwgPeBVOf3nI
         diQpmO99NeXACHwRlFD0OVFGE7SfXqAx+clKIrA+aevtxwU5TXRQ6a5Ws9sMZtT1WScq
         IDtCspVblTSGDwvLTRsxUcc/kYpT5BfXZSoRNRcZuCHHVbudjHKTZWmRyJ6tw2QKTQXW
         KiSScyM3iYblrxNl45yf/VhVZnY/gIgRe8NoVNozduojrRfT2ARh7u4g8fNgZOFgMgr5
         pYk9X8BwOta1dRGqgKL/+NOROyTeHb0j/Zb9cu0tCCEjnBJJIE3IOrOn4vrEnjkhGTPf
         K/Vw==
X-Gm-Message-State: ANoB5pmu5jsPtNU/uBfHtLZPpl9d5eY83wFZuDQNCmEsI2W2ujKqp8K2
        QpKfPtqiGf+H/3RuCSE6fZY2+fDymvSDx9NjfoX0c6J/Z8HyvH4yfDZKXp8t/8B/I/B3S+ICoIq
        7Ttf1baa5dOkE
X-Received: by 2002:a92:cacf:0:b0:302:4d47:6971 with SMTP id m15-20020a92cacf000000b003024d476971mr11781004ilq.11.1670962968691;
        Tue, 13 Dec 2022 12:22:48 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5pHsdgxpqRWzyOMlv+SXJZp4Qxd+pG3DyRSrtBJiAnK70BGMeZHx2je6r3GtgnO0xVvlh/zw==
X-Received: by 2002:a92:cacf:0:b0:302:4d47:6971 with SMTP id m15-20020a92cacf000000b003024d476971mr11780998ilq.11.1670962968398;
        Tue, 13 Dec 2022 12:22:48 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t10-20020a92cc4a000000b00304aa34b405sm3003911ilq.81.2022.12.13.12.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 12:22:47 -0800 (PST)
Date:   Tue, 13 Dec 2022 13:22:45 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 1/5] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Message-ID: <20221213132245.10ef6873.alex.williamson@redhat.com>
In-Reply-To: <1670960459-415264-2-git-send-email-steven.sistare@oracle.com>
References: <1670960459-415264-1-git-send-email-steven.sistare@oracle.com>
        <1670960459-415264-2-git-send-email-steven.sistare@oracle.com>
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

On Tue, 13 Dec 2022 11:40:55 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
> Their kernel threads could be blocked indefinitely by a misbehaving
> userland while trying to pin/unpin pages while vaddrs are being updated.
> 
> Do not allow groups to be added to the container while vaddr's are invalid,
> so we never need to block user threads from pinning, and can delete the
> vaddr-waiting code in a subsequent patch.
> 


Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")


> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 31 ++++++++++++++++++++++++++++++-
>  include/uapi/linux/vfio.h       | 15 +++++++++------
>  2 files changed, 39 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 23c24fe..80bdb4d 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -859,6 +859,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>  	if (!iommu->v2)
>  		return -EACCES;
>  
> +	WARN_ON(iommu->vaddr_invalid_count);
> +

I'd expect this to abort and return -errno rather than simply trigger a
warning.

>  	mutex_lock(&iommu->lock);
>  
>  	/*
> @@ -976,6 +978,8 @@ static void vfio_iommu_type1_unpin_pages(void *iommu_data,
>  
>  	mutex_lock(&iommu->lock);
>  
> +	WARN_ON(iommu->vaddr_invalid_count);
> +

This should never happen or else I'd suggest this also make an early
exit.

>  	do_accounting = list_empty(&iommu->domain_list);
>  	for (i = 0; i < npage; i++) {
>  		dma_addr_t iova = user_iova + PAGE_SIZE * i;
> @@ -1343,6 +1347,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  
>  	mutex_lock(&iommu->lock);
>  
> +	/* Cannot update vaddr if mdev is present. */
> +	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups))
> +		goto unlock;

A different errno here to reflect that the container state is the issue
might be appropriate here.

> +
>  	pgshift = __ffs(iommu->pgsize_bitmap);
>  	pgsize = (size_t)1 << pgshift;
>  
> @@ -2189,6 +2197,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  
>  	mutex_lock(&iommu->lock);
>  
> +	/* Attach could require pinning, so disallow while vaddr is invalid. */
> +	if (iommu->vaddr_invalid_count)
> +		goto out_unlock;
> +
>  	/* Check for duplicates */
>  	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
>  		goto out_unlock;
> @@ -2660,6 +2672,16 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
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
> +
>  static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>  					    unsigned long arg)
>  {
> @@ -2668,8 +2690,13 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
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
> @@ -3080,6 +3107,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
>  	size_t offset;
>  	int ret;
>  
> +	WARN_ON(iommu->vaddr_invalid_count);
> +

Same as pinning, this should trigger -errno.  Thanks,

Alex

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

