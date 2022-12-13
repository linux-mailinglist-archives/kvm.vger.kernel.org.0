Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661F964B9A2
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 17:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235977AbiLMQ1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 11:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235718AbiLMQ1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 11:27:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682252BCE
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 08:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670948775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+baNleV2eMc0Cr3ZgvbexVQAFU9ATo/cmcUQl0ZD3Uo=;
        b=iSf1AgkVI8AwYyEwEEgQwH7Xht1yuKAgE1NrDpHST9zj3M9fDSexrbWgewAHh09qw97Kzn
        BpcvziWpKAgOkuMiOxMEiA1ZQ06/7jZ9aBGj2sxB56y3ZG3yrqFS8cNk1MZkjooFTzIynl
        BR5C5FZeucBqPeTwlW/Q/Lzm3CuIcAI=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-108-syw_KAAuM_uE1zWW0uQDzw-1; Tue, 13 Dec 2022 11:26:14 -0500
X-MC-Unique: syw_KAAuM_uE1zWW0uQDzw-1
Received: by mail-il1-f199.google.com with SMTP id i14-20020a056e020d8e00b003034b93bd07so7811129ilj.14
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 08:26:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+baNleV2eMc0Cr3ZgvbexVQAFU9ATo/cmcUQl0ZD3Uo=;
        b=xuI6Ee4iL1+99nCkff8FgFAIYAKzHeh0kY0EbHoeyr18MtmeM2R1LZeKJ3VBTWw/Jl
         XoWBrth1a2ZHLc/VRcBPtIfwgAyfL2Rux9ZHN7413wrST/Ic6U97AyD6PIXf1ShRFkyC
         Dnf/5+NKG3wv4lvyoXbVXv7bmS5Nk+BvC+dnVhIYMm9io1fENNFMw/WtJl0kHcsJtCi8
         NA4ZVkj96UfFMHfBJuWJxhOu/r5ovzuiI4Z81CA2ADjrFIYSyIySozhW8/ktb14DJ2Ms
         mSfvWilgep+lS/6RyKsVe2f6ZFaBbr45zJavcJzvyQBIKwKiK/wu4GqTsUukLrYBGKyU
         47oA==
X-Gm-Message-State: ANoB5pmZFWc2q1BVLYADJnbyfjrFEbfszwYwr8c+Et2jPZX/cC46hKH4
        IUBxucoG2nZ8LUbp4K+awgLVOo352uIR/CkbPrtdvGf09ALHR+3Vsf/3tC/VjBCuqb6pQoyydLR
        JBzi0jtUkpwtr
X-Received: by 2002:a92:db49:0:b0:302:cb18:b127 with SMTP id w9-20020a92db49000000b00302cb18b127mr11770481ilq.7.1670948772926;
        Tue, 13 Dec 2022 08:26:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7Q+oa5Dow30jTbZUH80x+Df1NY0cnQpiEjV05lNUUBZ4H9UsgmlF/gFsMXAQQqDIB4CyIP/w==
X-Received: by 2002:a92:db49:0:b0:302:cb18:b127 with SMTP id w9-20020a92db49000000b00302cb18b127mr11770466ilq.7.1670948772608;
        Tue, 13 Dec 2022 08:26:12 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id n23-20020a027157000000b00389e42ac620sm983055jaf.129.2022.12.13.08.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 08:26:11 -0800 (PST)
Date:   Tue, 13 Dec 2022 09:26:10 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH V1 1/2] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Message-ID: <20221213092610.636686fc.alex.williamson@redhat.com>
In-Reply-To: <1670946416-155307-2-git-send-email-steven.sistare@oracle.com>
References: <1670946416-155307-1-git-send-email-steven.sistare@oracle.com>
        <1670946416-155307-2-git-send-email-steven.sistare@oracle.com>
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

On Tue, 13 Dec 2022 07:46:55 -0800
Steve Sistare <steven.sistare@oracle.com> wrote:

> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
> Their kernel threads could be blocked indefinitely by a misbehaving
> userland while trying to pin/unpin pages while vaddrs are being updated.

Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")

> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 25 ++++++++++++++++++++++++-
>  include/uapi/linux/vfio.h       |  6 +++++-
>  2 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 23c24fe..f81e925 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1343,6 +1343,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>  
>  	mutex_lock(&iommu->lock);
>  
> +	/* Cannot update vaddr if mdev is present. */
> +	if (invalidate_vaddr && !list_empty(&iommu->emulated_iommu_groups))
> +		goto unlock;
> +
>  	pgshift = __ffs(iommu->pgsize_bitmap);
>  	pgsize = (size_t)1 << pgshift;
>  
> @@ -2189,6 +2193,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>  
>  	mutex_lock(&iommu->lock);
>  
> +	/* Prevent an mdev from sneaking in while vaddr flags are used. */
> +	if (iommu->vaddr_invalid_count && type == VFIO_EMULATED_IOMMU)
> +		goto out_unlock;

Why only mdev devices?  If we restrict that the user cannot attach a
group while there are invalid vaddrs, and the pin/unpin pages and
dma_rw interfaces are restricted to cases where vaddr_invalid_count is
zero, then we can get rid of all the code to handle waiting for vaddrs.
ie. we could still revert:

898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
487ace134053 ("vfio/type1: implement notify callback")
ec5e32940cc9 ("vfio: iommu driver notify callback")

It appears to me it might be easiest to lead with a clean revert of
these, then follow-up imposing the usage restrictions, and I'd go ahead
and add WARN_ON error paths to the pin/unpin/dma_rw paths to make sure
nobody enters those paths with an elevated invalid count.  Thanks,

Alex

> +
>  	/* Check for duplicates */
>  	if (vfio_iommu_find_iommu_group(iommu, iommu_group))
>  		goto out_unlock;
> @@ -2660,6 +2668,20 @@ static int vfio_domains_have_enforce_cache_coherency(struct vfio_iommu *iommu)
>  	return ret;
>  }
>  
> +/*
> + * Disable this feature if mdevs are present.  They cannot safely pin/unpin
> + * while vaddrs are being updated.
> + */
> +static int vfio_iommu_can_update_vaddr(struct vfio_iommu *iommu)
> +{
> +	int ret;
> +
> +	mutex_lock(&iommu->lock);
> +	ret = list_empty(&iommu->emulated_iommu_groups);
> +	mutex_unlock(&iommu->lock);
> +	return ret;
> +}
> +
>  static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>  					    unsigned long arg)
>  {
> @@ -2668,8 +2690,9 @@ static int vfio_iommu_type1_check_extension(struct vfio_iommu *iommu,
>  	case VFIO_TYPE1v2_IOMMU:
>  	case VFIO_TYPE1_NESTING_IOMMU:
>  	case VFIO_UNMAP_ALL:
> -	case VFIO_UPDATE_VADDR:
>  		return 1;
> +	case VFIO_UPDATE_VADDR:
> +		return iommu && vfio_iommu_can_update_vaddr(iommu);
>  	case VFIO_DMA_CC_IOMMU:
>  		if (!iommu)
>  			return 0;
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index d7d8e09..6d36b84 100644
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

