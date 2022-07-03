Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463A4564377
	for <lists+kvm@lfdr.de>; Sun,  3 Jul 2022 02:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiGCA0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Jul 2022 20:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiGCA0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 2 Jul 2022 20:26:10 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA65BC27
        for <kvm@vger.kernel.org>; Sat,  2 Jul 2022 17:26:08 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id b125so4419579qkg.11
        for <kvm@vger.kernel.org>; Sat, 02 Jul 2022 17:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K3vSxbxl3lm2+DTao4eU6rwROl43oXRaDxo+o6ITx1U=;
        b=OeeUBKcg8jeqn1sISLjJiWuqgB43jbX0+5RsRX6f8fhvJUU49quxS2dEjkzDxMa1Vh
         SwUu20VQ0Nzi0l+hlSg73oxntjyJUXOwHFfmSmStgACNHaoiyk2lolkLujD3FazQJ+DJ
         IWQmjiYhGKqRzC2iQZjQ01Ro8rcWbMS6jqeoK7djzxPxwhj39o2TOPmE3+1GQI/PkZF5
         /ucoz5p0VWbS0TB4vsBYszc7SUlQuIkJ6y0R2cmZYFBCMy6fYM2UvI/vp6AKv4MJpqbb
         3yFwimVGqRFMwJumke+OrXYKLm9uOWv4oOG8sG/YsqKznALfVIiPRtAfnefcI9O0XkzT
         FiMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K3vSxbxl3lm2+DTao4eU6rwROl43oXRaDxo+o6ITx1U=;
        b=DgKmF2dfwkYCbxQGsMlxGKridMWdkOdyJ+pHHEw81xJSYc7m13lLxod0Qae8tQhtUy
         qzGMzivgP3/12kyNl9/GSgS80JxuOWt7s/6OA6H5MI/9zKWsyR1lbRhLz/QyPqPNbNlb
         InlV74oRmBgBpJxJnSCbZ/lQLICHsCU2nanlXnHp/CQ1O0eXnZz9tZYBMR+ITzGqAHE/
         5tEB1Q8hXZ+3OW3XZRGOXvyYcr/Uv/oj7+FRtum+14hKG5QJUK8k8ins3HsmKFg/VVqT
         tUdDRMb+MvEW7tQnMousDO7qyjkUVzEFY94ORTs2nRl6AxAW3nimyq6lxNJrX9aFQG/g
         FNmg==
X-Gm-Message-State: AJIora+iXx2FwfJsjStsrI5vvVrGcopAupk4O2WP6FHy3XyYtsLvsG8f
        TG8frntJRt4ePGrGqTGA3bJS8Q==
X-Google-Smtp-Source: AGRyM1vCYzpxXTzOTcbe6JdZdBfIXU6kQ6zz5pdmBpvlmSQjX56oBU9gDbhPHokw+gxGPxLUoDYLAw==
X-Received: by 2002:a05:620a:2456:b0:6af:31c6:c1af with SMTP id h22-20020a05620a245600b006af31c6c1afmr15370196qkn.25.1656807967980;
        Sat, 02 Jul 2022 17:26:07 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id i14-20020a05620a248e00b006a6b374d8bbsm25052949qkn.69.2022.07.02.17.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 17:26:07 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1o7nR8-005DKm-Nt; Sat, 02 Jul 2022 21:26:06 -0300
Date:   Sat, 2 Jul 2022 21:26:06 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     kvm@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm-ppc@vger.kernel.org
Subject: Re: [RFC PATCH kernel] vfio: Skip checking for
 IOMMU_CAP_CACHE_COHERENCY on POWER and more
Message-ID: <20220703002606.GZ23621@ziepe.ca>
References: <20220701061751.1955857-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701061751.1955857-1-aik@ozlabs.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 01, 2022 at 04:17:51PM +1000, Alexey Kardashevskiy wrote:
> VFIO on POWER does not implement iommu_ops and therefore iommu_capable()
> always returns false and __iommu_group_alloc_blocking_domain() always
> fails.
> 
> iommu_group_claim_dma_owner() in setting container fails for the same
> reason - it cannot allocate a domain.
> 
> This skips the check for platforms supporting VFIO without implementing
> iommu_ops which to my best knowledge is POWER only.
> 
> This also allows setting container in absence of iommu_ops.
> 
> Fixes: 70693f470848 ("vfio: Set DMA ownership for VFIO devices")
> Fixes: e8ae0e140c05 ("vfio: Require that devices support DMA cache coherence")
> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> ---
> 
> Not quite sure what the proper small fix is and implementing iommu_ops
> on POWER is not going to happen any time soon or ever :-/
> 
> ---
>  drivers/vfio/vfio.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..71408ab26cd0 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -605,7 +605,8 @@ int vfio_register_group_dev(struct vfio_device *device)
>  	 * VFIO always sets IOMMU_CACHE because we offer no way for userspace to
>  	 * restore cache coherency.
>  	 */
> -	if (!iommu_capable(device->dev->bus, IOMMU_CAP_CACHE_COHERENCY))
> +	if (device->dev->bus->iommu_ops &&
> +	    !iommu_capable(device->dev->bus, IOMMU_CAP_CACHE_COHERENCY))
>  		return -EINVAL;

This change should be guarded by some
IS_ENABLED(CONFIG_VFIO_IOMMU_SPAPR_TCE)

We want to do the this check here on every other
configuration. Rejecting null iommu_ops is actually a desired side
effect.

>  	return __vfio_register_dev(device,
> @@ -934,7 +935,7 @@ static void __vfio_group_unset_container(struct vfio_group *group)
>  		driver->ops->detach_group(container->iommu_data,
>  					  group->iommu_group);
>  
> -	if (group->type == VFIO_IOMMU)
> +	if (group->type == VFIO_IOMMU && iommu_group_dma_owner_claimed(group->iommu_group))
>  		iommu_group_release_dma_owner(group->iommu_group);
>  
>  	group->container = NULL;
> @@ -1010,9 +1011,8 @@ static int vfio_group_set_container(struct vfio_group *group, int container_fd)
>  	}
>  
>  	if (group->type == VFIO_IOMMU) {
> -		ret = iommu_group_claim_dma_owner(group->iommu_group, f.file);
> -		if (ret)
> -			goto unlock_out;
> +		if (iommu_group_claim_dma_owner(group->iommu_group, f.file))
> +			pr_warn("Failed to claim DMA owner");

We certainly cannot ignore this. As my other email you should make
this succeed inside the iommu subsystem even though the ops are null.

Thanks,
Jason
