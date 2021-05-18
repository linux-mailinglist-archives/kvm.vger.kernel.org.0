Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094AF388031
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 20:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351817AbhERTAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 15:00:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351750AbhERTA0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 May 2021 15:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621364347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ax4CDb+Sd6mNQ6JnBMbZp3JYaJV2pPRPTkaJj0ycGsA=;
        b=AfPrrVBfhFRf/KZTncGlGkLomscCYegUiuzPt6ILj+7Fphv4gs+5tkE8uCyOpAXkjWCNY4
        eyV4L3QLSficxwGVDRnQzmvB+llgWquz1G0sspLwBFIB+NdkcKw+5fZC8VfGdEvDVJXqS+
        rk3b+zZY8E9iLuC5bluV5NqEFrwr4cM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-LSvapAV8PQWv0YsaYRwixg-1; Tue, 18 May 2021 14:59:03 -0400
X-MC-Unique: LSvapAV8PQWv0YsaYRwixg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00050100C61D;
        Tue, 18 May 2021 18:59:00 +0000 (UTC)
Received: from redhat.com (ovpn-113-225.phx2.redhat.com [10.3.113.225])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A0F6100F49F;
        Tue, 18 May 2021 18:59:00 +0000 (UTC)
Date:   Tue, 18 May 2021 12:58:31 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shenming Lu <lushenming@huawei.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH v3 3/8] vfio/type1: Add an MMU notifier to avoid
 pinning
Message-ID: <20210518125831.153e039c.alex.williamson@redhat.com>
In-Reply-To: <20210409034420.1799-4-lushenming@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
        <20210409034420.1799-4-lushenming@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Apr 2021 11:44:15 +0800
Shenming Lu <lushenming@huawei.com> wrote:

> To avoid pinning pages when they are mapped in IOMMU page tables, we
> add an MMU notifier to tell the addresses which are no longer valid
> and try to unmap them.
> 
> Signed-off-by: Shenming Lu <lushenming@huawei.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 112 +++++++++++++++++++++++++++++++-
>  1 file changed, 109 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index ab0ff60ee207..1cb9d1f2717b 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -40,6 +40,7 @@
>  #include <linux/notifier.h>
>  #include <linux/dma-iommu.h>
>  #include <linux/irqdomain.h>
> +#include <linux/mmu_notifier.h>
>  
>  #define DRIVER_VERSION  "0.2"
>  #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
> @@ -69,6 +70,7 @@ struct vfio_iommu {
>  	struct mutex		lock;
>  	struct rb_root		dma_list;
>  	struct blocking_notifier_head notifier;
> +	struct mmu_notifier	mn;
>  	unsigned int		dma_avail;
>  	unsigned int		vaddr_invalid_count;
>  	uint64_t		pgsize_bitmap;
> @@ -1204,6 +1206,72 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>  	return unlocked;
>  }
>  
> +/* Unmap the IOPF mapped pages in the specified range. */
> +static void vfio_unmap_partial_iopf(struct vfio_iommu *iommu,
> +				    struct vfio_dma *dma,
> +				    dma_addr_t start, dma_addr_t end)
> +{
> +	struct iommu_iotlb_gather *gathers;
> +	struct vfio_domain *d;
> +	int i, num_domains = 0;
> +
> +	list_for_each_entry(d, &iommu->domain_list, next)
> +		num_domains++;
> +
> +	gathers = kzalloc(sizeof(*gathers) * num_domains, GFP_KERNEL);
> +	if (gathers) {
> +		for (i = 0; i < num_domains; i++)
> +			iommu_iotlb_gather_init(&gathers[i]);
> +	}


If we're always serialized on iommu->lock, would it make sense to have
gathers pre-allocated on the vfio_iommu object?

> +
> +	while (start < end) {
> +		unsigned long bit_offset;
> +		size_t len;
> +
> +		bit_offset = (start - dma->iova) >> PAGE_SHIFT;
> +
> +		for (len = 0; start + len < end; len += PAGE_SIZE) {
> +			if (!IOPF_MAPPED_BITMAP_GET(dma,
> +					bit_offset + (len >> PAGE_SHIFT)))
> +				break;


There are bitmap helpers for this, find_first_bit(),
find_next_zero_bit().


> +		}
> +
> +		if (len) {
> +			i = 0;
> +			list_for_each_entry(d, &iommu->domain_list, next) {
> +				size_t unmapped;
> +
> +				if (gathers)
> +					unmapped = iommu_unmap_fast(d->domain,
> +								    start, len,
> +								    &gathers[i++]);
> +				else
> +					unmapped = iommu_unmap(d->domain,
> +							       start, len);
> +
> +				if (WARN_ON(unmapped != len))

The IOMMU API does not guarantee arbitrary unmap sizes, this will
trigger and this exit path is wrong.  If we've already unmapped the
IOMMU, shouldn't we proceed with @unmapped rather than @len so the
device can re-fault the extra mappings?  Otherwise the IOMMU state
doesn't match the iopf bitmap state.

> +					goto out;
> +			}
> +
> +			bitmap_clear(dma->iopf_mapped_bitmap,
> +				     bit_offset, len >> PAGE_SHIFT);
> +
> +			cond_resched();
> +		}
> +
> +		start += (len + PAGE_SIZE);
> +	}
> +
> +out:
> +	if (gathers) {
> +		i = 0;
> +		list_for_each_entry(d, &iommu->domain_list, next)
> +			iommu_iotlb_sync(d->domain, &gathers[i++]);
> +
> +		kfree(gathers);
> +	}
> +}
> +
>  static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>  {
>  	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
> @@ -3197,17 +3265,18 @@ static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
>  
>  	vaddr = iova - dma->iova + dma->vaddr;
>  
> -	if (vfio_pin_page_external(dma, vaddr, &pfn, true))
> +	if (vfio_pin_page_external(dma, vaddr, &pfn, false))
>  		goto out_invalid;
>  
>  	if (vfio_iommu_map(iommu, iova, pfn, 1, dma->prot)) {
> -		if (put_pfn(pfn, dma->prot))
> -			vfio_lock_acct(dma, -1, true);
> +		put_pfn(pfn, dma->prot);
>  		goto out_invalid;
>  	}
>  
>  	bitmap_set(dma->iopf_mapped_bitmap, bit_offset, 1);
>  
> +	put_pfn(pfn, dma->prot);
> +
>  out_success:
>  	status = IOMMU_PAGE_RESP_SUCCESS;
>  
> @@ -3220,6 +3289,43 @@ static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
>  	return 0;
>  }
>  
> +static void mn_invalidate_range(struct mmu_notifier *mn, struct mm_struct *mm,
> +				unsigned long start, unsigned long end)
> +{
> +	struct vfio_iommu *iommu = container_of(mn, struct vfio_iommu, mn);
> +	struct rb_node *n;
> +	int ret;
> +
> +	mutex_lock(&iommu->lock);
> +
> +	ret = vfio_wait_all_valid(iommu);
> +	if (WARN_ON(ret < 0))
> +		return;

Is WARN_ON sufficient for this error condition?  We've been told to
evacuate a range of mm, the device still has DMA access, we've removed
page pinning.  This seems like a BUG_ON condition to me, we can't allow
the system to continue in any way with pages getting unmapped from
under the device.

> +
> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> +		unsigned long start_n, end_n;
> +
> +		if (end <= dma->vaddr || start >= dma->vaddr + dma->size)
> +			continue;
> +
> +		start_n = ALIGN_DOWN(max_t(unsigned long, start, dma->vaddr),
> +				     PAGE_SIZE);
> +		end_n = ALIGN(min_t(unsigned long, end, dma->vaddr + dma->size),
> +			      PAGE_SIZE);
> +
> +		vfio_unmap_partial_iopf(iommu, dma,
> +					start_n - dma->vaddr + dma->iova,
> +					end_n - dma->vaddr + dma->iova);
> +	}
> +
> +	mutex_unlock(&iommu->lock);
> +}
> +
> +static const struct mmu_notifier_ops vfio_iommu_type1_mn_ops = {
> +	.invalidate_range	= mn_invalidate_range,
> +};
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {

Again, this patch series is difficult to follow because we're
introducing dead code until the mmu notifier actually has a path to be
registered.  We shouldn't be taking any faults until iopf is enabled,
so it seems like we can add more of the core support alongside this
code.

