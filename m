Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6E238BFBC
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 08:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbhEUGnS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 02:43:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5713 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbhEUGlI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 02:41:08 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FmcL24pFkzqVZJ;
        Fri, 21 May 2021 14:35:22 +0800 (CST)
Received: from dggpemm500022.china.huawei.com (7.185.36.162) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:38:54 +0800
Received: from [10.174.187.155] (10.174.187.155) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 21 May 2021 14:38:53 +0800
Subject: Re: [RFC PATCH v3 2/8] vfio/type1: Add a page fault handler
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
 <20210409034420.1799-3-lushenming@huawei.com>
 <20210518125837.6de73631.alex.williamson@redhat.com>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <e7e8562f-44a7-92e5-2c4c-974fa7c6cb84@huawei.com>
Date:   Fri, 21 May 2021 14:38:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20210518125837.6de73631.alex.williamson@redhat.com>
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
> On Fri, 9 Apr 2021 11:44:14 +0800
> Shenming Lu <lushenming@huawei.com> wrote:
> 
>> VFIO manages the DMA mapping itself. To support IOPF (on-demand paging)
>> for VFIO (IOMMU capable) devices, we add a VFIO page fault handler to
>> serve the reported page faults from the IOMMU driver.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 114 ++++++++++++++++++++++++++++++++
>>  1 file changed, 114 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 45cbfd4879a5..ab0ff60ee207 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -101,6 +101,7 @@ struct vfio_dma {
>>  	struct task_struct	*task;
>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>  	unsigned long		*bitmap;
>> +	unsigned long		*iopf_mapped_bitmap;
>>  };
>>  
>>  struct vfio_batch {
>> @@ -141,6 +142,16 @@ struct vfio_regions {
>>  	size_t len;
>>  };
>>  
>> +/* A global IOPF enabled group list */
>> +static struct rb_root iopf_group_list = RB_ROOT;
>> +static DEFINE_MUTEX(iopf_group_list_lock);
>> +
>> +struct vfio_iopf_group {
>> +	struct rb_node		node;
>> +	struct iommu_group	*iommu_group;
>> +	struct vfio_iommu	*iommu;
>> +};
>> +
>>  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)	\
>>  					(!list_empty(&iommu->domain_list))
>>  
>> @@ -157,6 +168,10 @@ struct vfio_regions {
>>  #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
>>  #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
>>  
>> +#define IOPF_MAPPED_BITMAP_GET(dma, i)	\
>> +			      ((dma->iopf_mapped_bitmap[(i) / BITS_PER_LONG]	\
>> +			       >> ((i) % BITS_PER_LONG)) & 0x1)
> 
> 
> Can't we just use test_bit()?

Yeah, we can use it.

> 
> 
>> +
>>  #define WAITED 1
>>  
>>  static int put_pfn(unsigned long pfn, int prot);
>> @@ -416,6 +431,34 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
>>  	return ret;
>>  }
>>  
>> +/*
>> + * Helper functions for iopf_group_list
>> + */
>> +static struct vfio_iopf_group *
>> +vfio_find_iopf_group(struct iommu_group *iommu_group)
>> +{
>> +	struct vfio_iopf_group *iopf_group;
>> +	struct rb_node *node;
>> +
>> +	mutex_lock(&iopf_group_list_lock);
>> +
>> +	node = iopf_group_list.rb_node;
>> +
>> +	while (node) {
>> +		iopf_group = rb_entry(node, struct vfio_iopf_group, node);
>> +
>> +		if (iommu_group < iopf_group->iommu_group)
>> +			node = node->rb_left;
>> +		else if (iommu_group > iopf_group->iommu_group)
>> +			node = node->rb_right;
>> +		else
>> +			break;
>> +	}
>> +
>> +	mutex_unlock(&iopf_group_list_lock);
>> +	return node ? iopf_group : NULL;
>> +}
> 
> This looks like a pretty heavy weight operation per DMA fault.
> 
> I'm also suspicious of this validity of this iopf_group after we've
> dropped the locking, the ordering of patches makes this very confusing.

My thought was to include the handling of DMA faults completely in the type1
backend by introducing the vfio_iopf_group struct. But it seems that introducing
a struct with an unknown lifecycle causes more problems...
I will use the path from vfio-core as in the v2 for simplicity and validity.

Sorry for the confusing, I will reconstruct the series later. :-)

> 
>> +
>>  static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>>  {
>>  	struct mm_struct *mm;
>> @@ -3106,6 +3149,77 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>>  	return -EINVAL;
>>  }
>>  
>> +/* VFIO I/O Page Fault handler */
>> +static int vfio_iommu_type1_dma_map_iopf(struct iommu_fault *fault, void *data)
> 
>>From the comment, this seems like the IOMMU fault handler (the
> construction of this series makes this difficult to follow) and
> eventually it handles more than DMA mapping, for example transferring
> faults to the device driver.  "dma_map_iopf" seems like a poorly scoped
> name.

Maybe just call it dev_fault_handler?

> 
>> +{
>> +	struct device *dev = (struct device *)data;
>> +	struct iommu_group *iommu_group;
>> +	struct vfio_iopf_group *iopf_group;
>> +	struct vfio_iommu *iommu;
>> +	struct vfio_dma *dma;
>> +	dma_addr_t iova = ALIGN_DOWN(fault->prm.addr, PAGE_SIZE);
>> +	int access_flags = 0;
>> +	unsigned long bit_offset, vaddr, pfn;
>> +	int ret;
>> +	enum iommu_page_response_code status = IOMMU_PAGE_RESP_INVALID;
>> +	struct iommu_page_response resp = {0};
>> +
>> +	if (fault->type != IOMMU_FAULT_PAGE_REQ)
>> +		return -EOPNOTSUPP;
>> +
>> +	iommu_group = iommu_group_get(dev);
>> +	if (!iommu_group)
>> +		return -ENODEV;
>> +
>> +	iopf_group = vfio_find_iopf_group(iommu_group);
>> +	iommu_group_put(iommu_group);
>> +	if (!iopf_group)
>> +		return -ENODEV;
>> +
>> +	iommu = iopf_group->iommu;
>> +
>> +	mutex_lock(&iommu->lock);
> 
> Again, I'm dubious of our ability to grab this lock from an object with
> an unknown lifecycle and races we might have with that group being
> detached or DMA unmapped.  Also, how effective is enabling IOMMU page
> faulting if we're serializing all faults within a container context?

Did you mean "efficient"?
I also worry about this as the mapping and unmapping of the faulting pages
are all with the same lock...
Is there a way to parallel them? Or could we have more fine grained lock
control?

> 
>> +
>> +	ret = vfio_find_dma_valid(iommu, iova, PAGE_SIZE, &dma);
>> +	if (ret < 0)
>> +		goto out_invalid;
>> +
>> +	if (fault->prm.perm & IOMMU_FAULT_PERM_READ)
>> +		access_flags |= IOMMU_READ;
>> +	if (fault->prm.perm & IOMMU_FAULT_PERM_WRITE)
>> +		access_flags |= IOMMU_WRITE;
>> +	if ((dma->prot & access_flags) != access_flags)
>> +		goto out_invalid;
>> +
>> +	bit_offset = (iova - dma->iova) >> PAGE_SHIFT;
>> +	if (IOPF_MAPPED_BITMAP_GET(dma, bit_offset))
>> +		goto out_success;
> 
> If the page is mapped, why did we get a fault?  Should we be returning
> success for a fault we shouldn't have received and did nothing to
> resolve?  We're also referencing a bitmap that has only been declared
> and never allocated at this point in the patch series.

Image that we have two inflight page faults which target the same iova,
shouldn't the later one just return SUCCESS since the previous one has
been handled and the mapping has been established?

I will allocate the bitmap first.

Thanks,
Shenming

> 
>> +
>> +	vaddr = iova - dma->iova + dma->vaddr;
>> +
>> +	if (vfio_pin_page_external(dma, vaddr, &pfn, true))
>> +		goto out_invalid;
>> +
>> +	if (vfio_iommu_map(iommu, iova, pfn, 1, dma->prot)) {
>> +		if (put_pfn(pfn, dma->prot))
>> +			vfio_lock_acct(dma, -1, true);
>> +		goto out_invalid;
>> +	}
>> +
>> +	bitmap_set(dma->iopf_mapped_bitmap, bit_offset, 1);
>> +
>> +out_success:
>> +	status = IOMMU_PAGE_RESP_SUCCESS;
>> +
>> +out_invalid:
>> +	mutex_unlock(&iommu->lock);
>> +	resp.version		= IOMMU_PAGE_RESP_VERSION_1;
>> +	resp.grpid		= fault->prm.grpid;
>> +	resp.code		= status;
>> +	iommu_page_response(dev, &resp);
>> +	return 0;
>> +}
>> +
>>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>>  				   unsigned int cmd, unsigned long arg)
>>  {
> 
> .
> 
