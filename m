Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8493F6C4D
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 01:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbhHXXli (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 19:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbhHXXlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 19:41:37 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CADC061757
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:40:52 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id f22so15508766qkm.5
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 16:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cSw9pGQyUYhWxlcvuM/0tJvHPxuWhOeAMXzM04yjym0=;
        b=JgUgRlPzvwgGSSOBzdN8g0qmH5LQblYgelLtZ0jmQyOb1uEVlS5f7XecoinvzT39UH
         /dPLTpZSvdj3/MjPjNNz3WgLMdnRbQND9tlxa/h2SEKdUP5KRCWQiU7z+evrshkdHH4j
         14OInaNZzwNF5QrbTUAgi9vrG2DOJmI3kh39+Z6qWWcsiowmWqnq0IGqTnBkYIpcB84a
         QRed/6aEn9Wf0lIw4E5lTrUdtGBRFeXMcVbpYoWVcSZQIud0/PcWOtA7oDzMgnzPjg6L
         /2m4AMW+us7fNFON/r5GuOP+cbcYSSdYtoktapwTWCqps+rKsmxACjKEc7pRRHHEw0gl
         EDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cSw9pGQyUYhWxlcvuM/0tJvHPxuWhOeAMXzM04yjym0=;
        b=QiOSXqiUkDVn7Q/XEgjH8E/O8uCf9wm2iv708I/+TD86oDXsDNSgZrBKCyo5M3w0N4
         Q4MiGq5jvOHtcY2oZmaCkAx/bXrOr+2KG0RJss+vNltjo5tMfukv+jDsRqyh02UHFXOf
         4r5qOreqED7yspH+Fi9IGaKiUmngLhP9ebriaSy5IdRsccnoyE8z5EBiCgE9Dd8LwTyR
         mbDe85W1+PhRVczKDrVDzD+wtQloUtiqZDMwvf/XAzwtGO5KQeqZiVFjVb4g0Js+N2yP
         MJ2yVyYHlrIUZDcHe6SNS8gkHS8GGcP6V/W7PKn+3LQfnEAyVX6ULwmFneyy2mIWcxCd
         etYg==
X-Gm-Message-State: AOAM5308BkzXeuBoJ17i8canVlse4gMUW9ZXmew24oT1lmdLramCSbRW
        0PonMUi4GlpGqLKQwKOvUnY72w==
X-Google-Smtp-Source: ABdhPJw1sArZaLL8TanhUPSB78fJVQQgkbaBW5hjnO+OzqVrWOXWnDkzSJLA47HO42qEIQzIIcmu7Q==
X-Received: by 2002:a05:620a:1082:: with SMTP id g2mr29809498qkk.138.1629848451729;
        Tue, 24 Aug 2021 16:40:51 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id e5sm8601291qts.0.2021.08.24.16.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 16:40:51 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mIg2E-004iRu-Eh; Tue, 24 Aug 2021 20:40:50 -0300
Date:   Tue, 24 Aug 2021 20:40:50 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Message-ID: <20210824234050.GK543798@ziepe.ca>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-5-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824144649.1488190-5-hch@lst.de>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 04:46:39PM +0200, Christoph Hellwig wrote:
> Factor out a helper to find or allocate the vfio_group to reduce the
> spagetthi code in vfio_register_group_dev a little.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
>  drivers/vfio/vfio.c | 49 ++++++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 00aeef5bb29abd..9e97ad36a1c052 100644
> +++ b/drivers/vfio/vfio.c
> @@ -833,10 +833,32 @@ void vfio_uninit_group_dev(struct vfio_device *device)
>  }
>  EXPORT_SYMBOL_GPL(vfio_uninit_group_dev);
>  
> +struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> +{
> +	struct iommu_group *iommu_group;
> +	struct vfio_group *group;
> +
> +	iommu_group = vfio_iommu_group_get(dev);
> +	if (!iommu_group)
> +		return ERR_PTR(-EINVAL);
> +
> +	/*
> +	 * A found vfio_group already holds a reference to the iommu_group.
> +	 * A created vfio_group keeps the reference.
> +	 */
> +	group = vfio_group_get_from_iommu(iommu_group);
> +	if (!group) {
> +		group = vfio_create_group(iommu_group);
> +		if (!IS_ERR(group))
> +			return group;
> +	}
> +	vfio_iommu_group_put(iommu_group, dev);
> +	return group;

I think the non-"success oriented flow" is less readable than what was
before. It is jarring to see, and I was about to say this is not
logically the same having missed the !...

How about:

        /* If found group already holds the iommu_group reference */
	group = vfio_group_get_from_iommu(iommu_group);
	if (group)
            goto out_put;

	group = vfio_create_group(iommu_group);
	if (IS_ERR(group))
	     goto out_put;
        /* If created our iommu_group reference was moved to group, keep it */
	return group;

out_put:
	vfio_iommu_group_put(iommu_group, dev);
	return group;

Jason
