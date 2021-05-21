Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BA338BFA3
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 08:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233283AbhEUGlF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 02:41:05 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3459 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbhEUGjO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 02:39:14 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FmcKc3VJHzCvPs;
        Fri, 21 May 2021 14:35:00 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:37:48 +0800
Received: from [10.174.187.155] (10.174.187.155) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:37:47 +0800
Subject: Re: [RFC PATCH v3 3/8] vfio/type1: Add an MMU notifier to avoid
 pinning
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>, Will Deacon <will@kernel.org>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Jean-Philippe Brucker" <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <linux-api@vger.kernel.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        "Barry Song" <song.bao.hua@hisilicon.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210409034420.1799-1-lushenming@huawei.com>
 <20210409034420.1799-4-lushenming@huawei.com>
 <20210518125831.153e039c.alex.williamson@redhat.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <6a914c05-fbd6-8555-1a1d-a21e5fa40a37@huawei.com>
Date:   Fri, 21 May 2021 14:37:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20210518125831.153e039c.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.155]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/19 2:58, Alex Williamson wrote:
> On Fri, 9 Apr 2021 11:44:15 +0800
> Shenming Lu <lushenming@huawei.com> wrote:
> 
>> To avoid pinning pages when they are mapped in IOMMU page tables, we
>> add an MMU notifier to tell the addresses which are no longer valid
>> and try to unmap them.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 112 +++++++++++++++++++++++++++++++-
>>  1 file changed, 109 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index ab0ff60ee207..1cb9d1f2717b 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -40,6 +40,7 @@
>>  #include <linux/notifier.h>
>>  #include <linux/dma-iommu.h>
>>  #include <linux/irqdomain.h>
>> +#include <linux/mmu_notifier.h>
>>  
>>  #define DRIVER_VERSION  "0.2"
>>  #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
>> @@ -69,6 +70,7 @@ struct vfio_iommu {
>>  	struct mutex		lock;
>>  	struct rb_root		dma_list;
>>  	struct blocking_notifier_head notifier;
>> +	struct mmu_notifier	mn;
>>  	unsigned int		dma_avail;
>>  	unsigned int		vaddr_invalid_count;
>>  	uint64_t		pgsize_bitmap;
>> @@ -1204,6 +1206,72 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>>  	return unlocked;
>>  }
>>  
>> +/* Unmap the IOPF mapped pages in the specified range. */
>> +static void vfio_unmap_partial_iopf(struct vfio_iommu *iommu,
>> +				    struct vfio_dma *dma,
>> +				    dma_addr_t start, dma_addr_t end)
>> +{
>> +	struct iommu_iotlb_gather *gathers;
>> +	struct vfio_domain *d;
>> +	int i, num_domains = 0;
>> +
>> +	list_for_each_entry(d, &iommu->domain_list, next)
>> +		num_domains++;
>> +
>> +	gathers = kzalloc(sizeof(*gathers) * num_domains, GFP_KERNEL);
>> +	if (gathers) {
>> +		for (i = 0; i < num_domains; i++)
>> +			iommu_iotlb_gather_init(&gathers[i]);
>> +	}
> 
> 
> If we're always serialized on iommu->lock, would it make sense to have
> gathers pre-allocated on the vfio_iommu object?

Yeah, we can do it.

> 
>> +
>> +	while (start < end) {
>> +		unsigned long bit_offset;
>> +		size_t len;
>> +
>> +		bit_offset = (start - dma->iova) >> PAGE_SHIFT;
>> +
>> +		for (len = 0; start + len < end; len += PAGE_SIZE) {
>> +			if (!IOPF_MAPPED_BITMAP_GET(dma,
>> +					bit_offset + (len >> PAGE_SHIFT)))
>> +				break;
> 
> 
> There are bitmap helpers for this, find_first_bit(),
> find_next_zero_bit().

Thanks for the hint. :-)

> 
> 
>> +		}
>> +
>> +		if (len) {
>> +			i = 0;
>> +			list_for_each_entry(d, &iommu->domain_list, next) {
>> +				size_t unmapped;
>> +
>> +				if (gathers)
>> +					unmapped = iommu_unmap_fast(d->domain,
>> +								    start, len,
>> +								    &gathers[i++]);
>> +				else
>> +					unmapped = iommu_unmap(d->domain,
>> +							       start, len);
>> +
>> +				if (WARN_ON(unmapped != len))
> 
> The IOMMU API does not guarantee arbitrary unmap sizes, this will
> trigger and this exit path is wrong.  If we've already unmapped the
> IOMMU, shouldn't we proceed with @unmapped rather than @len so the
> device can re-fault the extra mappings?  Otherwise the IOMMU state
> doesn't match the iopf bitmap state.

OK, I will correct it.

And can we assume that the @unmapped values (returned from iommu_unmap)
of all domains are the same (since all domains share the same iopf_mapped_bitmap)?

> 
>> +					goto out;
>> +			}
>> +
>> +			bitmap_clear(dma->iopf_mapped_bitmap,
>> +				     bit_offset, len >> PAGE_SHIFT);
>> +
>> +			cond_resched();
>> +		}
>> +
>> +		start += (len + PAGE_SIZE);
>> +	}
>> +
>> +out:
>> +	if (gathers) {
>> +		i = 0;
>> +		list_for_each_entry(d, &iommu->domain_list, next)
>> +			iommu_iotlb_sync(d->domain, &gathers[i++]);
>> +
>> +		kfree(gathers);
>> +	}
>> +}
>> +
>>  static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>  {
>>  	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
>> @@ -3197,17 +3265,18 @@ static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
>>  
>>  	vaddr = iova - dma->iova + dma->vaddr;
>>  
>> -	if (vfio_pin_page_external(dma, vaddr, &pfn, true))
>> +	if (vfio_pin_page_external(dma, vaddr, &pfn, false))
>>  		goto out_invalid;
>>  
>>  	if (vfio_iommu_map(iommu, iova, pfn, 1, dma->prot)) {
>> -		if (put_pfn(pfn, dma->prot))
>> -			vfio_lock_acct(dma, -1, true);
>> +		put_pfn(pfn, dma->prot);
>>  		goto out_invalid;
>>  	}
>>  
>>  	bitmap_set(dma->iopf_mapped_bitmap, bit_offset, 1);
>>  
>> +	put_pfn(pfn, dma->prot);
>> +
>>  out_success:
>>  	status = IOMMU_PAGE_RESP_SUCCESS;
>>  
>> @@ -3220,6 +3289,43 @@ static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
>>  	return 0;
>>  }
>>  
>> +static void mn_invalidate_range(struct mmu_notifier *mn, struct mm_struct *mm,
>> +				unsigned long start, unsigned long end)
>> +{
>> +	struct vfio_iommu *iommu = container_of(mn, struct vfio_iommu, mn);
>> +	struct rb_node *n;
>> +	int ret;
>> +
>> +	mutex_lock(&iommu->lock);
>> +
>> +	ret = vfio_wait_all_valid(iommu);
>> +	if (WARN_ON(ret < 0))
>> +		return;
> 
> Is WARN_ON sufficient for this error condition?  We've been told to
> evacuate a range of mm, the device still has DMA access, we've removed
> page pinning.  This seems like a BUG_ON condition to me, we can't allow
> the system to continue in any way with pages getting unmapped from
> under the device.

Make sense.

> 
>> +
>> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>> +		unsigned long start_n, end_n;
>> +
>> +		if (end <= dma->vaddr || start >= dma->vaddr + dma->size)
>> +			continue;
>> +
>> +		start_n = ALIGN_DOWN(max_t(unsigned long, start, dma->vaddr),
>> +				     PAGE_SIZE);
>> +		end_n = ALIGN(min_t(unsigned long, end, dma->vaddr + dma->size),
>> +			      PAGE_SIZE);
>> +
>> +		vfio_unmap_partial_iopf(iommu, dma,
>> +					start_n - dma->vaddr + dma->iova,
>> +					end_n - dma->vaddr + dma->iova);
>> +	}
>> +
>> +	mutex_unlock(&iommu->lock);
>> +}
>> +
>> +static const struct mmu_notifier_ops vfio_iommu_type1_mn_ops = {
>> +	.invalidate_range	= mn_invalidate_range,
>> +};
>> +
>>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>>  				   unsigned int cmd, unsigned long arg)
>>  {
> 
> Again, this patch series is difficult to follow because we're
> introducing dead code until the mmu notifier actually has a path to be
> registered.

Sorry again for this, I will be careful for the sequence of the series later.

> We shouldn't be taking any faults until iopf is enabled,
> so it seems like we can add more of the core support alongside this
> code.

Could you be more specific about this? :-)

We can add a requirement that the VFIO_IOMMU_ENABLE_IOPF ioctl (in Patch 5)
must be called right after VFIO_SET_IOMMU, so that IOPF is enabled before
setting up any DMA mapping. Is this sufficient?

Thanks,
Shenming

> 
> .
> 
