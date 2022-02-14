Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D0A4B4F15
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 12:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352499AbiBNLpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 06:45:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352730AbiBNLoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 06:44:44 -0500
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6E7CFD;
        Mon, 14 Feb 2022 03:39:39 -0800 (PST)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 727E836D; Mon, 14 Feb 2022 12:39:37 +0100 (CET)
Date:   Mon, 14 Feb 2022 12:39:36 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v1 3/8] iommu: Extend iommu_at[de]tach_device() for
 multi-device groups
Message-ID: <Ygo/eCRFnraY01WA@8bytes.org>
References: <20220106022053.2406748-1-baolu.lu@linux.intel.com>
 <20220106022053.2406748-4-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220106022053.2406748-4-baolu.lu@linux.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 06, 2022 at 10:20:48AM +0800, Lu Baolu wrote:
>  int iommu_attach_device(struct iommu_domain *domain, struct device *dev)
>  {
>  	struct iommu_group *group;
> -	int ret;
> +	int ret = 0;
> +
> +	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
> +		return -EINVAL;
>  
>  	group = iommu_group_get(dev);
>  	if (!group)
>  		return -ENODEV;
>  
> -	/*
> -	 * Lock the group to make sure the device-count doesn't
> -	 * change while we are attaching
> -	 */
>  	mutex_lock(&group->mutex);
> -	ret = -EINVAL;
> -	if (iommu_group_device_count(group) != 1)
> -		goto out_unlock;
> +	if (group->owner_cnt) {
> +		/*
> +		 * Group has been used for kernel-api dma or claimed explicitly
> +		 * for exclusive occupation. For backward compatibility, device
> +		 * in a singleton group is allowed to ignore setting the
> +		 * drv.no_kernel_api_dma field.
> +		 */
> +		if ((group->domain == group->default_domain &&
> +		     iommu_group_device_count(group) != 1) ||
> +		    group->owner) {
> +			ret = -EBUSY;
> +			goto unlock_out;
> +		}
> +	}
>  
> -	ret = __iommu_attach_group(domain, group);
> +	if (!group->attach_cnt) {
> +		ret = __iommu_attach_group(domain, group);
> +		if (ret)
> +			goto unlock_out;
> +	} else {
> +		if (group->domain != domain) {
> +			ret = -EPERM;
> +			goto unlock_out;
> +		}
> +	}
>  
> -out_unlock:
> +	group->owner_cnt++;
> +	group->attach_cnt++;
> +
> +unlock_out:
>  	mutex_unlock(&group->mutex);
>  	iommu_group_put(group);

This extends iommu_attach_device() to behave as iommu_attach_group(),
changing the domain for the whole group. Wouldn't it be better to scrap
the iommu_attach_device() interface instead and only rely on
iommu_attach_group()? This way it is clear that a call changes the whole
group.

IIUC this work is heading towards allowing multiple domains in one group
as long as the group is owned by one entity. That is a valid
requirement, but the way to get there is in my eyes:

	1) Introduce a concept of a sub-group (or whatever we want to
	   call it), which groups devices together which must be in the
	   same domain because they use the same request ID and thus
	   look all the same to the IOMMU.

	2) Keep todays IOMMU groups to group devices together which can
	   bypass the IOMMU when talking to each other, like
	   multi-function devices and devices behind a no-ACS bridge.

	3) Rework group->domain and group->default_domain, eventually
	   moving them to sub-groups.

This is an important distinction to make and also the reason the
iommu_attach/detach_device() interface will always be misleading. Item
1) in this list will also be beneficial to other parts of the iommu
code, namely iommu-dma code which can have finer-grained DMA-API domains
with sub-groups instead of groups.

Regards,

	Joerg

