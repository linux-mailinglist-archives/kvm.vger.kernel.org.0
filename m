Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25902FA11A
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 14:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392103AbhARNRW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 08:17:22 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11555 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392072AbhARNRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 08:17:15 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DKC1r5CHCzMLqq;
        Mon, 18 Jan 2021 21:14:56 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.498.0; Mon, 18 Jan 2021 21:16:09 +0800
Subject: Re: [PATCH v2 2/2] vfio/iommu_type1: Sanity check pfn_list when
 remove vfio_dma
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20210115092643.728-1-zhukeqian1@huawei.com>
 <20210115092643.728-3-zhukeqian1@huawei.com>
 <20210115121447.54c96857@omen.home.shazbot.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, "Marc Zyngier" <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        "Robin Murphy" <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <32f8b347-587a-1a9a-bee8-569f09a03a15@huawei.com>
Date:   Mon, 18 Jan 2021 21:16:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210115121447.54c96857@omen.home.shazbot.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/1/16 3:14, Alex Williamson wrote:
> On Fri, 15 Jan 2021 17:26:43 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> vfio_sanity_check_pfn_list() is used to check whether pfn_list of
>> vfio_dma is empty when remove the external domain, so it makes a
>> wrong assumption that only external domain will add pfn to dma pfn_list.
>>
>> Now we apply this check when remove a specific vfio_dma and extract
>> the notifier check just for external domain.
> 
> The page pinning interface is gated by having a notifier registered for
> unmaps, therefore non-external domains would also need to register a
> notifier.  There's currently no other way to add entries to the
> pfn_list.  So if we allow pinning for such domains, then it's wrong to
> WARN_ON() when the notifier list is not-empty when removing an external
> domain.  Long term we should probably extend page {un}pinning for the
> caller to pass their notifier to be validated against the notifier list
> rather than just allowing page pinning if *any* notifier is registered.
> Thanks,
I was misled by the code comments. So when the commit a54eb55045ae is added, the only
user of pin interface is mdev vendor driver, but now we also allow iommu backed group
to use this interface to constraint dirty scope. Is vfio_iommu_unmap_unpin_all() a
proper place to put this WARN()?

Thanks,
Keqian

> 
> Alex
>  
>> Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 24 +++++-------------------
>>  1 file changed, 5 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 4e82b9a3440f..a9bc15e84a4e 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -958,6 +958,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>>  
>>  static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>  {
>> +	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list);
>>  	vfio_unmap_unpin(iommu, dma, true);
>>  	vfio_unlink_dma(iommu, dma);
>>  	put_task_struct(dma->task);
>> @@ -2251,23 +2252,6 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
>>  	}
>>  }
>>  
>> -static void vfio_sanity_check_pfn_list(struct vfio_iommu *iommu)
>> -{
>> -	struct rb_node *n;
>> -
>> -	n = rb_first(&iommu->dma_list);
>> -	for (; n; n = rb_next(n)) {
>> -		struct vfio_dma *dma;
>> -
>> -		dma = rb_entry(n, struct vfio_dma, node);
>> -
>> -		if (WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list)))
>> -			break;
>> -	}
>> -	/* mdev vendor driver must unregister notifier */
>> -	WARN_ON(iommu->notifier.head);
>> -}
>> -
>>  /*
>>   * Called when a domain is removed in detach. It is possible that
>>   * the removed domain decided the iova aperture window. Modify the
>> @@ -2367,7 +2351,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  			kfree(group);
>>  
>>  			if (list_empty(&iommu->external_domain->group_list)) {
>> -				vfio_sanity_check_pfn_list(iommu);
>> +				/* mdev vendor driver must unregister notifier */
>> +				WARN_ON(iommu->notifier.head);
>>  
>>  				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
>>  					vfio_iommu_unmap_unpin_all(iommu);
>> @@ -2491,7 +2476,8 @@ static void vfio_iommu_type1_release(void *iommu_data)
>>  
>>  	if (iommu->external_domain) {
>>  		vfio_release_domain(iommu->external_domain, true);
>> -		vfio_sanity_check_pfn_list(iommu);
>> +		/* mdev vendor driver must unregister notifier */
>> +		WARN_ON(iommu->notifier.head);
>>  		kfree(iommu->external_domain);
>>  	}
>>  
> 
> .
> 
