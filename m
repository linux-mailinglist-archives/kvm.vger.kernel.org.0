Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F73238BFB5
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 08:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhEUGnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 02:43:10 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4712 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbhEUGlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 02:41:08 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmcM51bgBz16QcY;
        Fri, 21 May 2021 14:36:17 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:39:04 +0800
Received: from [10.174.187.155] (10.174.187.155) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:39:03 +0800
Subject: Re: [RFC PATCH v3 6/8] vfio/type1: No need to statically pin and map
 if IOPF enabled
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
 <20210409034420.1799-7-lushenming@huawei.com>
 <20210518125818.2282941f.alex.williamson@redhat.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <f0b64de4-adda-1dc2-464b-00de5a8279cb@huawei.com>
Date:   Fri, 21 May 2021 14:39:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20210518125818.2282941f.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.155]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500022.china.huawei.com (7.185.36.162)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/19 2:58, Alex Williamson wrote:
> On Fri, 9 Apr 2021 11:44:18 +0800
> Shenming Lu <lushenming@huawei.com> wrote:
> 
>> If IOPF enabled for the VFIO container, there is no need to statically
>> pin and map the entire DMA range, we can do it on demand. And unmap
>> according to the IOPF mapped bitmap when removing vfio_dma.
>>
>> Note that we still mark all pages dirty even if IOPF enabled, we may
>> add IOPF-based fine grained dirty tracking support in the future.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 38 +++++++++++++++++++++++++++------
>>  1 file changed, 32 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 7df5711e743a..dcc93c3b258c 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -175,6 +175,7 @@ struct vfio_iopf_group {
>>  #define IOPF_MAPPED_BITMAP_GET(dma, i)	\
>>  			      ((dma->iopf_mapped_bitmap[(i) / BITS_PER_LONG]	\
>>  			       >> ((i) % BITS_PER_LONG)) & 0x1)  
>> +#define IOPF_MAPPED_BITMAP_BYTES(n)	DIRTY_BITMAP_BYTES(n)
>>  
>>  #define WAITED 1
>>  
>> @@ -959,7 +960,8 @@ static int vfio_iommu_type1_pin_pages(void *iommu_data,
>>  	 * already pinned and accounted. Accouting should be done if there is no
>>  	 * iommu capable domain in the container.
>>  	 */
>> -	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
>> +	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) ||
>> +			iommu->iopf_enabled;
>>  
>>  	for (i = 0; i < npage; i++) {
>>  		struct vfio_pfn *vpfn;
>> @@ -1048,7 +1050,8 @@ static int vfio_iommu_type1_unpin_pages(void *iommu_data,
>>  
>>  	mutex_lock(&iommu->lock);
>>  
>> -	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu);
>> +	do_accounting = !IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) ||
>> +			iommu->iopf_enabled;
> 
> pin/unpin are actually still pinning pages, why does iopf exempt them
> from accounting?

If iopf_enabled is true, do_accounting will be true too, we will account
the external pinned pages?

> 
> 
>>  	for (i = 0; i < npage; i++) {
>>  		struct vfio_dma *dma;
>>  		dma_addr_t iova;
>> @@ -1169,7 +1172,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>>  	if (!dma->size)
>>  		return 0;
>>  
>> -	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
>> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) || iommu->iopf_enabled)
>>  		return 0;
>>  
>>  	/*
>> @@ -1306,11 +1309,20 @@ static void vfio_unmap_partial_iopf(struct vfio_iommu *iommu,
>>  	}
>>  }
>>  
>> +static void vfio_dma_clean_iopf(struct vfio_iommu *iommu, struct vfio_dma *dma)
>> +{
>> +	vfio_unmap_partial_iopf(iommu, dma, dma->iova, dma->iova + dma->size);
>> +
>> +	kfree(dma->iopf_mapped_bitmap);
>> +}
>> +
>>  static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>  {
>>  	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
>>  	vfio_unmap_unpin(iommu, dma, true);
>>  	vfio_unlink_dma(iommu, dma);
>> +	if (iommu->iopf_enabled)
>> +		vfio_dma_clean_iopf(iommu, dma);
>>  	put_task_struct(dma->task);
>>  	vfio_dma_bitmap_free(dma);
>>  	if (dma->vaddr_invalid) {
>> @@ -1359,7 +1371,8 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>>  	 * mark all pages dirty if any IOMMU capable device is not able
>>  	 * to report dirty pages and all pages are pinned and mapped.
>>  	 */
>> -	if (iommu->num_non_pinned_groups && dma->iommu_mapped)
>> +	if (iommu->num_non_pinned_groups &&
>> +	    (dma->iommu_mapped || iommu->iopf_enabled))
>>  		bitmap_set(dma->bitmap, 0, nbits);
> 
> This seems like really poor integration of iopf into dirty page
> tracking.  I'd expect dirty logging to flush the mapped pages and
> write faults to mark pages dirty.  Shouldn't the fault handler also
> provide only the access faulted, so for example a read fault wouldn't
> mark the page dirty?
I just want to keep the behavior here as before, if IOPF enabled, we
will still mark all pages dirty.

We can distinguish between write and read faults in the fault handler,
so there is a way to add IOPF-based fine grained dirty tracking support...
But I am not sure whether there is a need to implement this, we can
consider this in the future?

> 
>>  
>>  	if (shift) {
>> @@ -1772,6 +1785,16 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  		goto out_unlock;
>>  	}
>>  
>> +	if (iommu->iopf_enabled) {
>> +		dma->iopf_mapped_bitmap = kvzalloc(IOPF_MAPPED_BITMAP_BYTES(
>> +						size >> PAGE_SHIFT), GFP_KERNEL);
>> +		if (!dma->iopf_mapped_bitmap) {
>> +			ret = -ENOMEM;
>> +			kfree(dma);
>> +			goto out_unlock;
>> +		}
> 
> 
> So we're assuming nothing can fault and therefore nothing can reference
> the iopf_mapped_bitmap until this point in the series?

I will move this to the front of this series.

Thanks,
Shenming

> 
> 
>> +	}
>> +
>>  	iommu->dma_avail--;
>>  	dma->iova = iova;
>>  	dma->vaddr = vaddr;
>> @@ -1811,8 +1834,11 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  	/* Insert zero-sized and grow as we map chunks of it */
>>  	vfio_link_dma(iommu, dma);
>>  
>> -	/* Don't pin and map if container doesn't contain IOMMU capable domain*/
>> -	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
>> +	/*
>> +	 * Don't pin and map if container doesn't contain IOMMU capable domain,
>> +	 * or IOPF enabled for the container.
>> +	 */
>> +	if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) || iommu->iopf_enabled)
>>  		dma->size = size;
>>  	else
>>  		ret = vfio_pin_map_dma(iommu, dma, size);
> 
> .
> 
