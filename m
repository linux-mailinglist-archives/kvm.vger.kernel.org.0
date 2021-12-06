Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D1946973C
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 14:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244465AbhLFNja (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 08:39:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbhLFNja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 08:39:30 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849DEC061746;
        Mon,  6 Dec 2021 05:36:01 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id A88E1396; Mon,  6 Dec 2021 14:35:58 +0100 (CET)
Date:   Mon, 6 Dec 2021 14:35:55 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/18] iommu: Add device dma ownership set/release
 interfaces
Message-ID: <Ya4Ru/GtILJYzI6j@8bytes.org>
References: <20211206015903.88687-1-baolu.lu@linux.intel.com>
 <20211206015903.88687-2-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206015903.88687-2-baolu.lu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 06, 2021 at 09:58:46AM +0800, Lu Baolu wrote:
> >From the perspective of who is initiating the device to do DMA, device
> DMA could be divided into the following types:
> 
>         DMA_OWNER_DMA_API: Device DMAs are initiated by a kernel driver
> 			through the kernel DMA API.
>         DMA_OWNER_PRIVATE_DOMAIN: Device DMAs are initiated by a kernel
> 			driver with its own PRIVATE domain.
> 	DMA_OWNER_PRIVATE_DOMAIN_USER: Device DMAs are initiated by
> 			userspace.

I have looked at the other iommu patches in this series, but I still
don't quite get what the difference in the code flow is between
DMA_OWNER_PRIVATE_DOMAIN and DMA_OWNER_PRIVATE_DOMAIN_USER. What are the
differences in the iommu core behavior based on this setting?

>         int iommu_device_set_dma_owner(struct device *dev,
>                 enum iommu_dma_owner type, void *owner_cookie);
>         void iommu_device_release_dma_owner(struct device *dev,
>                 enum iommu_dma_owner type);

It the owner is a group-wide setting, it should be called with the group
instead of the device. I have seen the group-specific funcitons are
added later, but that leaves the question why the device-specific ones
are needed at all.

> +	enum iommu_dma_owner dma_owner;
> +	refcount_t owner_cnt;
> +	void *owner_cookie;
>  };

I am also not quite happy yet with calling this dma_owner, but can't
come up with a better name yet.

>  
>  struct group_device {
> @@ -621,6 +624,7 @@ struct iommu_group *iommu_group_alloc(void)
>  	INIT_LIST_HEAD(&group->devices);
>  	INIT_LIST_HEAD(&group->entry);
>  	BLOCKING_INIT_NOTIFIER_HEAD(&group->notifier);
> +	group->dma_owner = DMA_OWNER_NONE;


DMA_OWNER_NONE is also questionable. All devices are always in one
domain, and the default domain is always the one used for DMA-API, so
why isn't the initial value DMA_OWNER_DMA_API?

Regards,

	Joerg
