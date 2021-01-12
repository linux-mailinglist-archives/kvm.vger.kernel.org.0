Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129842F2EA0
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 13:06:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731951AbhALMFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 07:05:32 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10713 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbhALMFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 07:05:31 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DFTkD0LGDzl46q;
        Tue, 12 Jan 2021 20:03:32 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Tue, 12 Jan 2021 20:04:39 +0800
Subject: Re: [PATCH 4/5] vfio/iommu_type1: Carefully use unmap_unpin_all
 during dirty tracking
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20210107092901.19712-1-zhukeqian1@huawei.com>
 <20210107092901.19712-5-zhukeqian1@huawei.com>
 <20210111144913.3092b1b1@omen.home.shazbot.org>
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
Message-ID: <198f0afd-343a-9fbc-9556-95670ca76a2c@huawei.com>
Date:   Tue, 12 Jan 2021 20:04:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210111144913.3092b1b1@omen.home.shazbot.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/1/12 5:49, Alex Williamson wrote:
> On Thu, 7 Jan 2021 17:29:00 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> If we detach group during dirty page tracking, we shouldn't remove
>> vfio_dma, because dirty log will lose.
>>
>> But we don't prevent unmap_unpin_all in vfio_iommu_release, because
>> under normal procedure, dirty tracking has been stopped.
> 
> This looks like it's creating a larger problem than it's fixing, it's
> not our job to maintain the dirty bitmap regardless of what the user
> does.  If the user detaches the last group in a container causing the
> mappings within that container to be deconstructed before the user has
> collected dirty pages, that sounds like a user error.  A container with
> no groups is de-privileged and therefore loses all state.  Thanks,
> 
> Alex

Hi Alex,

This looks good to me ;-). That's a reasonable constraint for user behavior.

What about replacing this patch with an addition to the uapi document of
VFIO_GROUP_UNSET_CONTAINER? User should pay attention to this when call this
ioctl during dirty tracking.

And any comments on other patches? thanks.

Thanks.
Keqian

> 
>> Fixes: d6a4c185660c ("vfio iommu: Implementation of ioctl for dirty pages tracking")
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 14 ++++++++++++--
>>  1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 26b7eb2a5cfc..9776a059904d 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -2373,7 +2373,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  			if (list_empty(&iommu->external_domain->group_list)) {
>>  				vfio_sanity_check_pfn_list(iommu);
>>  
>> -				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu))
>> +				/*
>> +				 * During dirty page tracking, we can't remove
>> +				 * vfio_dma because dirty log will lose.
>> +				 */
>> +				if (!IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu) &&
>> +				    !iommu->dirty_page_tracking)
>>  					vfio_iommu_unmap_unpin_all(iommu);
>>  
>>  				kfree(iommu->external_domain);
>> @@ -2406,10 +2411,15 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
>>  		 * iommu and external domain doesn't exist, then all the
>>  		 * mappings go away too. If it's the last domain with iommu and
>>  		 * external domain exist, update accounting
>> +		 *
>> +		 * Note: During dirty page tracking, we can't remove vfio_dma
>> +		 * because dirty log will lose. Just update accounting is a good
>> +		 * choice.
>>  		 */
>>  		if (list_empty(&domain->group_list)) {
>>  			if (list_is_singular(&iommu->domain_list)) {
>> -				if (!iommu->external_domain)
>> +				if (!iommu->external_domain &&
>> +				    !iommu->dirty_page_tracking)
>>  					vfio_iommu_unmap_unpin_all(iommu);
>>  				else
>>  					vfio_iommu_unmap_unpin_reaccount(iommu);
> 
> .
> 
