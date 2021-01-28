Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA1E307998
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 16:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbhA1PYC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 10:24:02 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:11530 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbhA1PWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 10:22:15 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DRPKs1ZVgzjFdr;
        Thu, 28 Jan 2021 23:20:17 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 28 Jan 2021 23:21:20 +0800
Subject: Re: [PATCH v3 2/2] vfio/iommu_type1: Fix some sanity checks in detach
 group
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20210122092635.19900-1-zhukeqian1@huawei.com>
 <20210122092635.19900-3-zhukeqian1@huawei.com>
 <20210127164641.36e17bf5@omen.home.shazbot.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <iommu@lists.linux-foundation.org>,
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
Message-ID: <5093dace-4b8a-d455-ba16-d0c2da755573@huawei.com>
Date:   Thu, 28 Jan 2021 23:21:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210127164641.36e17bf5@omen.home.shazbot.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/1/28 7:46, Alex Williamson wrote:
> On Fri, 22 Jan 2021 17:26:35 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> vfio_sanity_check_pfn_list() is used to check whether pfn_list and
>> notifier are empty when remove the external domain, so it makes a
>> wrong assumption that only external domain will use the pinning
>> interface.
>>
>> Now we apply the pfn_list check when a vfio_dma is removed and apply
>> the notifier check when all domains are removed.
>>
>> Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 33 ++++++++++-----------------------
>>  1 file changed, 10 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 161725395f2f..d8c10f508321 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -957,6 +957,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>>  
>>  static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>  {
>> +	WARN_ON(!RB_EMPTY_ROOT(&dma->pfn_list));
>>  	vfio_unmap_unpin(iommu, dma, true);
>>  	vfio_unlink_dma(iommu, dma);
>>  	put_task_struct(dma->task);
>> @@ -2250,23 +2251,6 @@ static void vfio_iommu_unmap_unpin_reaccount(struct vfio_iommu *iommu)
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
>> @@ -2366,10 +2350,10 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  			kfree(group);
>>  
>>  			if (list_empty(&iommu->external_domain->group_list)) {
>> -				vfio_sanity_check_pfn_list(iommu);
>> -
>> -				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
>> +				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)) {
>> +					WARN_ON(iommu->notifier.head);
>>  					vfio_iommu_unmap_unpin_all(iommu);
>> +				}
>>  
>>  				kfree(iommu->external_domain);
>>  				iommu->external_domain = NULL;
>> @@ -2403,10 +2387,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  		 */
>>  		if (list_empty(&domain->group_list)) {
>>  			if (list_is_singular(&iommu->domain_list)) {
>> -				if (!iommu->external_domain)
>> +				if (!iommu->external_domain) {
>> +					WARN_ON(iommu->notifier.head);
>>  					vfio_iommu_unmap_unpin_all(iommu);
>> -				else
>> +				} else {
>>  					vfio_iommu_unmap_unpin_reaccount(iommu);
>> +				}
>>  			}
>>  			iommu_domain_free(domain->domain);
>>  			list_del(&domain->next);
>> @@ -2488,9 +2474,10 @@ static void vfio_iommu_type1_release(void *iommu_data)
>>  	struct vfio_iommu *iommu = iommu_data;
>>  	struct vfio_domain *domain, *domain_tmp;
>>  
>> +	WARN_ON(iommu->notifier.head);
> 
> I don't see that this does any harm, but isn't it actually redundant?
> It seems vfio-core only calls the iommu backend release function after
> removing all the groups, so the tests in _detach_group should catch all
> cases.  We're expecting the vfio bus/mdev driver to remove the notifier
> when a device is closed, which necessarily occurs before detaching the
> group.  Thanks,
> 
> Alex
Hi Alex,

Sorry that today I was busy at sending the smmu HTTU based dma dirty log tracking.
I will reply you tomorrow. Thanks!

Keqian.

> 
>> +
>>  	if (iommu->external_domain) {
>>  		vfio_release_domain(iommu->external_domain, true);
>> -		vfio_sanity_check_pfn_list(iommu);
>>  		kfree(iommu->external_domain);
>>  	}
>>  
> 
> .
> 
