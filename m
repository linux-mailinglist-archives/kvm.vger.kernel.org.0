Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D52F242C5E0
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 18:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhJMQLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 12:11:16 -0400
Received: from verein.lst.de ([213.95.11.211]:46437 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhJMQLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 12:11:16 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id E5B8F68B05; Wed, 13 Oct 2021 18:09:10 +0200 (CEST)
Date:   Wed, 13 Oct 2021 18:09:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 3/5] vfio: Don't leak a group reference if the group
 already exists
Message-ID: <20211013160910.GC1327@lst.de>
References: <0-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com> <3-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3-v2-fd9627d27b2b+26c-vfio_group_cdev_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> @@ -775,12 +776,7 @@ static struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
>  	if (group)
>  		goto out_put;
>  
> -	/* a newly created vfio_group keeps the reference. */
>  	group = vfio_create_group(iommu_group, VFIO_IOMMU);
> -	if (IS_ERR(group))
> -		goto out_put;
> -	return group;
> -
>  out_put:
>  	iommu_group_put(iommu_group);
>  	return group;

I'd simplify this down to:

	group = vfio_group_get_from_iommu(iommu_group);
	if (!group)
		group = vfio_create_group(iommu_group, VFIO_IOMMU);

but otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
