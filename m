Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B092E30936D
	for <lists+kvm@lfdr.de>; Sat, 30 Jan 2021 10:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhA3Jdh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 30 Jan 2021 04:33:37 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12053 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhA3JcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 30 Jan 2021 04:32:10 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DSTSW2hVVzMS5j;
        Sat, 30 Jan 2021 17:29:47 +0800 (CST)
Received: from [10.174.184.214] (10.174.184.214) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Sat, 30 Jan 2021 17:31:15 +0800
Subject: Re: [RFC PATCH v1 1/4] vfio/type1: Add a bitmap to track IOPF mapped
 pages
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210125090402.1429-2-lushenming@huawei.com>
 <20210129155812.384cc56e@omen.home.shazbot.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <06cacae1-0baa-1533-561b-10abee3efee3@huawei.com>
Date:   Sat, 30 Jan 2021 17:31:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20210129155812.384cc56e@omen.home.shazbot.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.214]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/30 6:58, Alex Williamson wrote:
> On Mon, 25 Jan 2021 17:03:59 +0800
> Shenming Lu <lushenming@huawei.com> wrote:
> 
>> When IOPF enabled, the pages are pinned and mapped on demand, we add
>> a bitmap to track them.
>>
>> Signed-off-by: Shenming Lu <lushenming@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 0b4dedaa9128..f1d4de5ab094 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -95,6 +95,7 @@ struct vfio_dma {
>>  	struct task_struct	*task;
>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>  	unsigned long		*bitmap;
>> +	unsigned long		*iommu_mapped_bitmap;	/* IOPF mapped bitmap */
>>  };
>>  
>>  struct vfio_group {
>> @@ -143,6 +144,8 @@ struct vfio_regions {
>>  #define DIRTY_BITMAP_PAGES_MAX	 ((u64)INT_MAX)
>>  #define DIRTY_BITMAP_SIZE_MAX	 DIRTY_BITMAP_BYTES(DIRTY_BITMAP_PAGES_MAX)
>>  
>> +#define IOMMU_MAPPED_BITMAP_BYTES(n) DIRTY_BITMAP_BYTES(n)
>> +
>>  static int put_pfn(unsigned long pfn, int prot);
>>  
>>  static struct vfio_group *vfio_iommu_find_iommu_group(struct vfio_iommu *iommu,
>> @@ -949,6 +952,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>  	vfio_unlink_dma(iommu, dma);
>>  	put_task_struct(dma->task);
>>  	vfio_dma_bitmap_free(dma);
>> +	kfree(dma->iommu_mapped_bitmap);
>>  	kfree(dma);
>>  	iommu->dma_avail++;
>>  }
>> @@ -1354,6 +1358,14 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>>  		goto out_unlock;
>>  	}
>>  
>> +	dma->iommu_mapped_bitmap = kvzalloc(IOMMU_MAPPED_BITMAP_BYTES(size / PAGE_SIZE),
>> +					    GFP_KERNEL);
> 
> This is a lot of bloat for all the platforms that don't support this
> feature.  Thanks,

Yes, I will make this dedicated to IOPF.

Thanks,
Shenming

> 
> Alex
> 
>> +	if (!dma->iommu_mapped_bitmap) {
>> +		ret = -ENOMEM;
>> +		kfree(dma);
>> +		goto out_unlock;
>> +	}
>> +
>>  	iommu->dma_avail--;
>>  	dma->iova = iova;
>>  	dma->vaddr = vaddr;
> 
> .
> 
