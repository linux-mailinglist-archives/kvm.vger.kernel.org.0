Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECE1B314E20
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 12:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhBILTR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 06:19:17 -0500
Received: from foss.arm.com ([217.140.110.172]:49894 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230133AbhBILRA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 06:17:00 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E7FC8ED1;
        Tue,  9 Feb 2021 03:16:12 -0800 (PST)
Received: from [10.57.49.26] (unknown [10.57.49.26])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CBE543F73B;
        Tue,  9 Feb 2021 03:16:09 -0800 (PST)
Subject: Re: [RFC PATCH 10/11] vfio/iommu_type1: Optimize dirty bitmap
 population based on iommu HWDBM
To:     Yi Sun <yi.y.sun@linux.intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Cc:     Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>, jiangkunkun@huawei.com,
        wanghaibin.wang@huawei.com, kevin.tian@intel.com,
        yan.y.zhao@intel.com, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, lushenming@huawei.com,
        iommu@lists.linux-foundation.org, James Morse <james.morse@arm.com>
References: <20210128151742.18840-1-zhukeqian1@huawei.com>
 <20210128151742.18840-11-zhukeqian1@huawei.com>
 <20210207095630.GA28580@yi.y.sun>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <8150bd3a-dbb9-2e2b-386b-04e66f4b68dc@arm.com>
Date:   Tue, 9 Feb 2021 11:16:08 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210207095630.GA28580@yi.y.sun>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021-02-07 09:56, Yi Sun wrote:
> Hi,
> 
> On 21-01-28 23:17:41, Keqian Zhu wrote:
> 
> [...]
> 
>> +static void vfio_dma_dirty_log_start(struct vfio_iommu *iommu,
>> +				     struct vfio_dma *dma)
>> +{
>> +	struct vfio_domain *d;
>> +
>> +	list_for_each_entry(d, &iommu->domain_list, next) {
>> +		/* Go through all domain anyway even if we fail */
>> +		iommu_split_block(d->domain, dma->iova, dma->size);
>> +	}
>> +}
> 
> This should be a switch to prepare for dirty log start. Per Intel
> Vtd spec, there is SLADE defined in Scalable-Mode PASID Table Entry.
> It enables Accessed/Dirty Flags in second-level paging entries.
> So, a generic iommu interface here is better. For Intel iommu, it
> enables SLADE. For ARM, it splits block.

 From a quick look, VT-D's SLADE and SMMU's HTTU appear to be the exact 
same thing. This step isn't about enabling or disabling that feature 
itself (the proposal for SMMU is to simply leave HTTU enabled all the 
time), it's about controlling the granularity at which the dirty status 
can be detected/reported at all, since that's tied to the pagetable 
structure.

However, if an IOMMU were to come along with some other way of reporting 
dirty status that didn't depend on the granularity of individual 
mappings, then indeed it wouldn't need this operation.

Robin.

>> +
>> +static void vfio_dma_dirty_log_stop(struct vfio_iommu *iommu,
>> +				    struct vfio_dma *dma)
>> +{
>> +	struct vfio_domain *d;
>> +
>> +	list_for_each_entry(d, &iommu->domain_list, next) {
>> +		/* Go through all domain anyway even if we fail */
>> +		iommu_merge_page(d->domain, dma->iova, dma->size,
>> +				 d->prot | dma->prot);
>> +	}
>> +}
> 
> Same as above comment, a generic interface is required here.
> 
>> +
>> +static void vfio_iommu_dirty_log_switch(struct vfio_iommu *iommu, bool start)
>> +{
>> +	struct rb_node *n;
>> +
>> +	/* Split and merge even if all iommu don't support HWDBM now */
>> +	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
>> +		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
>> +
>> +		if (!dma->iommu_mapped)
>> +			continue;
>> +
>> +		/* Go through all dma range anyway even if we fail */
>> +		if (start)
>> +			vfio_dma_dirty_log_start(iommu, dma);
>> +		else
>> +			vfio_dma_dirty_log_stop(iommu, dma);
>> +	}
>> +}
>> +
>>   static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>>   					unsigned long arg)
>>   {
>> @@ -2812,8 +2900,10 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>>   		pgsize = 1 << __ffs(iommu->pgsize_bitmap);
>>   		if (!iommu->dirty_page_tracking) {
>>   			ret = vfio_dma_bitmap_alloc_all(iommu, pgsize);
>> -			if (!ret)
>> +			if (!ret) {
>>   				iommu->dirty_page_tracking = true;
>> +				vfio_iommu_dirty_log_switch(iommu, true);
>> +			}
>>   		}
>>   		mutex_unlock(&iommu->lock);
>>   		return ret;
>> @@ -2822,6 +2912,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>>   		if (iommu->dirty_page_tracking) {
>>   			iommu->dirty_page_tracking = false;
>>   			vfio_dma_bitmap_free_all(iommu);
>> +			vfio_iommu_dirty_log_switch(iommu, false);
>>   		}
>>   		mutex_unlock(&iommu->lock);
>>   		return 0;
>> -- 
>> 2.19.1
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
> 
