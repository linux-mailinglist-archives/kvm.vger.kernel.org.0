Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8691B450566
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbhKONay (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhKONaV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 08:30:21 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6097AC061570;
        Mon, 15 Nov 2021 05:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gFbWnaEtnneFXpm4hKQq3b4yTcblOu4hKmE8Ex8W9zI=; b=2m/s8W8TC+G0NpSZq+mSN4ls+u
        jV9qfuS8az9wfjy2pVWkwDVeiceuojC/T8scEElAX0J7CUDqKb7OfLTCVc13YjjP+ZZnu2isOfMw6
        mwbQbgDvrRCaLOpWBxfmuVGQKPyLp2n8pYtWQReF5cpBHOrUYMqWXH8LSNoVkm9XSjRc2jykB8qms
        viVHUX3JSwg3hvKlBpec892YIh04mRxh9JJpIEgjHyfVGOwgPrweK5Ssq/N4T/hql4goL//Vv82uV
        0xGZgDANBRCCT+IU7KIJYYhZess7GRMfJtJdYSXftYlNOGtc+Mx9gKw3Mn9vttbsipmdHTwkQpWeu
        RxXTtqZQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mmc0y-00FeyR-00; Mon, 15 Nov 2021 13:27:16 +0000
Date:   Mon, 15 Nov 2021 05:27:15 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 06/11] iommu: Expose group variants of dma ownership
 interfaces
Message-ID: <YZJgMzYzuxjJpWIC@infradead.org>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-7-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115020552.2378167-7-baolu.lu@linux.intel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 10:05:47AM +0800, Lu Baolu wrote:
> The vfio needs to set DMA_OWNER_USER for the entire group when attaching

The vfio subsystem?  driver?

> it to a vfio container. So expose group variants of setting/releasing dma
> ownership for this purpose.
> 
> This also exposes the helper iommu_group_dma_owner_unclaimed() for vfio
> report to userspace if the group is viable to user assignment, for

.. for vfio to report .. ?

>  void iommu_device_release_dma_owner(struct device *dev, enum iommu_dma_owner owner);
> +int iommu_group_set_dma_owner(struct iommu_group *group, enum iommu_dma_owner owner,
> +			      struct file *user_file);
> +void iommu_group_release_dma_owner(struct iommu_group *group, enum iommu_dma_owner owner);

Pleae avoid all these overly long lines.

> +static inline int iommu_group_set_dma_owner(struct iommu_group *group,
> +					    enum iommu_dma_owner owner,
> +					    struct file *user_file)
> +{
> +	return -EINVAL;
> +}
> +
> +static inline void iommu_group_release_dma_owner(struct iommu_group *group,
> +						 enum iommu_dma_owner owner)
> +{
> +}
> +
> +static inline bool iommu_group_dma_owner_unclaimed(struct iommu_group *group)
> +{
> +	return false;
> +}

Why do we need these stubs?  All potential callers should already
require CONFIG_IOMMU_API?  Same for the helpers added in patch 1, btw.

> +	mutex_lock(&group->mutex);
> +	ret = __iommu_group_set_dma_owner(group, owner, user_file);
> +	mutex_unlock(&group->mutex);

> +	mutex_lock(&group->mutex);
> +	__iommu_group_release_dma_owner(group, owner);
> +	mutex_unlock(&group->mutex);

Unless I'm missing something (just skipping over the patches),
the existing callers also take the lock just around these calls,
so we don't really need the __-prefixed lowlevel helpers.

> +	mutex_lock(&group->mutex);
> +	owner = group->dma_owner;
> +	mutex_unlock(&group->mutex);

No need for a lock to read a single scalar.

> +
> +	return owner == DMA_OWNER_NONE;
> +}
> +EXPORT_SYMBOL_GPL(iommu_group_dma_owner_unclaimed);
