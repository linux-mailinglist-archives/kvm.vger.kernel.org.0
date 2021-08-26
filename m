Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAAA3F8F44
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 21:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbhHZTzH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 15:55:07 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230139AbhHZTzH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Aug 2021 15:55:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630007658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YQASZe6jv6CkGpW/AHY0OIUwjMaRITfuMcGr6jWHu8M=;
        b=h/+UmXh2yHahBqMtSRnyhoU/k0N0x1U/VWmHOUQxupR1Tc0wb84cRwO67cMP9G9OiishwZ
        8JcdkU/yignUxArout+VoaLXesHEcXGAXlPOhMaerw79lhpvBAP6YB1HEjwl9sOMLo2Kj9
        1rvjn8xh7tVZbP5SBuCfDONH58XKqT0=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-buXvY5QYPIqNBf47ghn5Rw-1; Thu, 26 Aug 2021 15:54:17 -0400
X-MC-Unique: buXvY5QYPIqNBf47ghn5Rw-1
Received: by mail-ot1-f69.google.com with SMTP id v23-20020a9d6057000000b00518b08df4d2so46705otj.13
        for <kvm@vger.kernel.org>; Thu, 26 Aug 2021 12:54:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YQASZe6jv6CkGpW/AHY0OIUwjMaRITfuMcGr6jWHu8M=;
        b=itEQb206OweXeD2+sYAiDWTQZESdJtllcg8gU1mFdEI/4dthdeYprPtTts5UKz39gh
         23wVOzTzeadTZXifSmFk/EDUMUl9VY/PKIY8zj1ii9m5cHV9vIj81CGBvlUnwwI5Gu51
         UAEoQAedtDcZSsWn6tfl+06pSNxc7ap/KvHHaQGi3C4sdnOHrgLAAWo4DDiCBzdsPP6S
         Bdyr2ntUPbDd7cqFtvGHcNMBrddholtuwAm1nArWTmlNqYoObp78bGiYQ0U1Ng7fuhQh
         6kV2K0j+ElFP6bososnMMkuDMzQNCcKL2lnRNYcW67pVY3YMTm5HtFf/fnsiviPgozH/
         Tp8Q==
X-Gm-Message-State: AOAM532OtFI7B1o0r8a9jQNwR8idtftBNaRe7guMWc8+ZsjyYX+bgxPs
        4lVMSGL4PPqcCSZsZjv7ZZn1v8sMmrk8BKQOVRka9FjKmC4NY1kgyiBUsYPWS0F0I79rHC5wekS
        RBLCOwqc6PnQK
X-Received: by 2002:aca:1b19:: with SMTP id b25mr12247678oib.138.1630007656698;
        Thu, 26 Aug 2021 12:54:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw4HlXsI53Cfn+a1XXXHvBVuWbFdRgv+QFS1FRDoBwR4TAKWGRHYu/t11p1Fjnf1/BASlC44Q==
X-Received: by 2002:aca:1b19:: with SMTP id b25mr12247666oib.138.1630007656447;
        Thu, 26 Aug 2021 12:54:16 -0700 (PDT)
Received: from redhat.com ([198.99.80.109])
        by smtp.gmail.com with ESMTPSA id g62sm871599oif.14.2021.08.26.12.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 12:54:15 -0700 (PDT)
Date:   Thu, 26 Aug 2021 13:54:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc
 helper
Message-ID: <20210826135413.239e6d4e.alex.williamson@redhat.com>
In-Reply-To: <20210826133424.3362-5-hch@lst.de>
References: <20210826133424.3362-1-hch@lst.de>
        <20210826133424.3362-5-hch@lst.de>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 26 Aug 2021 15:34:14 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Factor out a helper to find or allocate the vfio_group to reduce the
> spagetthi code in vfio_register_group_dev a little.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 59 ++++++++++++++++++++++++++-------------------
>  1 file changed, 34 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 18e4c7906d1b3f..852fe22125520d 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -823,10 +823,38 @@ void vfio_uninit_group_dev(struct vfio_device *device)
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
> +	/* a found vfio_group already holds a reference to the iommu_group */
> +	group = vfio_group_get_from_iommu(iommu_group);
> +	if (group)
> +		goto out_put;
> +
> +	/* a newly created vfio_group keeps the reference. */
> +	group = vfio_create_group(iommu_group);
> +	if (IS_ERR(group))
> +		goto out_put;
> +	return group;
> +
> +out_put:
> +#ifdef CONFIG_VFIO_NOIOMMU
> +	if (iommu_group_get_iommudata(iommu_group) == &noiommu)
> +		iommu_group_remove_device(dev);
> +#endif

When we get here via the first goto above, it doesn't match the code
we're removing below.  I stared at the below logic from patch 01 for a
while and came to the conclusion that the only way we take that else
branch is if the iommu_group already existed and was not created
because how else could we find a vfio group for that iommu group
otherwise?  Therefore we only put the iommu group reference without
removing the device, because we didn't add the device.

The above assumes we created the iommu group and added the device.  So
I think there needs to be a separate goto target below that's reached in
place of the first goto above.  Thanks,

Alex

> +	iommu_group_put(iommu_group);
> +	return group;
> +}
> +
>  int vfio_register_group_dev(struct vfio_device *device)
>  {
>  	struct vfio_device *existing_device;
> -	struct iommu_group *iommu_group;
>  	struct vfio_group *group;
>  
>  	/*
> @@ -836,36 +864,17 @@ int vfio_register_group_dev(struct vfio_device *device)
>  	if (!device->dev_set)
>  		vfio_assign_device_set(device, device);
>  
> -	iommu_group = vfio_iommu_group_get(device->dev);
> -	if (!iommu_group)
> -		return -EINVAL;
> -
> -	group = vfio_group_get_from_iommu(iommu_group);
> -	if (!group) {
> -		group = vfio_create_group(iommu_group);
> -		if (IS_ERR(group)) {
> -#ifdef CONFIG_VFIO_NOIOMMU
> -			if (iommu_group_get_iommudata(iommu_group) == &noiommu)
> -				iommu_group_remove_device(device->dev);
> -#endif
> -			iommu_group_put(iommu_group);
> -			return PTR_ERR(group);
> -		}
> -	} else {
> -		/*
> -		 * A found vfio_group already holds a reference to the
> -		 * iommu_group.  A created vfio_group keeps the reference.
> -		 */
> -		iommu_group_put(iommu_group);
> -	}
> +	group = vfio_group_find_or_alloc(device->dev);
> +	if (IS_ERR(group))
> +		return PTR_ERR(group);
>  
>  	existing_device = vfio_group_get_device(group, device->dev);
>  	if (existing_device) {
>  		dev_WARN(device->dev, "Device already exists on group %d\n",
> -			 iommu_group_id(iommu_group));
> +			 iommu_group_id(group->iommu_group));
>  		vfio_device_put(existing_device);
>  #ifdef CONFIG_VFIO_NOIOMMU
> -		if (iommu_group_get_iommudata(iommu_group) == &noiommu)
> +		if (iommu_group_get_iommudata(group->iommu_group) == &noiommu)
>  			iommu_group_remove_device(device->dev);
>  #endif
>  		vfio_group_put(group);

