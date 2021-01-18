Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 912682FA25B
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 15:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392368AbhARNvU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 08:51:20 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:11403 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392338AbhARNf3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jan 2021 08:35:29 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DKCRT3Mnqz7Wql;
        Mon, 18 Jan 2021 21:33:41 +0800 (CST)
Received: from [10.174.184.42] (10.174.184.42) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Mon, 18 Jan 2021 21:34:38 +0800
Subject: Re: [PATCH 3/6] vfio/iommu_type1: Initially set the
 pinned_page_dirty_scope
To:     Alex Williamson <alex.williamson@redhat.com>
References: <20210107044401.19828-1-zhukeqian1@huawei.com>
 <20210107044401.19828-4-zhukeqian1@huawei.com>
 <20210115163041.704a4e9d@omen.home.shazbot.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <iommu@lists.linux-foundation.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, Cornelia Huck <cohuck@redhat.com>,
        "Will Deacon" <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexios Zavras <alexios.zavras@intel.com>,
        <wanghaibin.wang@huawei.com>, <jiangkunkun@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <bc343f12-e9be-7d67-f220-5da1d02038fa@huawei.com>
Date:   Mon, 18 Jan 2021 21:34:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210115163041.704a4e9d@omen.home.shazbot.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.42]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2021/1/16 7:30, Alex Williamson wrote:
> On Thu, 7 Jan 2021 12:43:58 +0800
> Keqian Zhu <zhukeqian1@huawei.com> wrote:
> 
>> For now there are 3 ways to promote the pinned_page_dirty_scope
>> status of vfio_iommu:
>>
>> 1. Through vfio pin interface.
>> 2. Detach a group without pinned_dirty_scope.
>> 3. Attach a group with pinned_dirty_scope.
>>
>> For point 3, the only chance to promote the pinned_page_dirty_scope
>> status is when vfio_iommu is newly created. As we can safely set
>> empty vfio_iommu to be at pinned status, then the point 3 can be
>> removed to reduce operations.
>>
>> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 110ada24ee91..b596c482487b 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -2045,11 +2045,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>>  			 * Non-iommu backed group cannot dirty memory directly,
>>  			 * it can only use interfaces that provide dirty
>>  			 * tracking.
>> -			 * The iommu scope can only be promoted with the
>> -			 * addition of a dirty tracking group.
>>  			 */
>>  			group->pinned_page_dirty_scope = true;
>> -			promote_pinned_page_dirty_scope(iommu);
>>  			mutex_unlock(&iommu->lock);
>>  
>>  			return 0;
>> @@ -2436,6 +2433,7 @@ static void *vfio_iommu_type1_open(unsigned long arg)
>>  	INIT_LIST_HEAD(&iommu->iova_list);
>>  	iommu->dma_list = RB_ROOT;
>>  	iommu->dma_avail = dma_entry_limit;
>> +	iommu->pinned_page_dirty_scope = true;
>>  	mutex_init(&iommu->lock);
>>  	BLOCKING_INIT_NOTIFIER_HEAD(&iommu->notifier);
>>  
> 
> This would be resolved automatically if we used the counter approach I
> mentioned on the previous patch, adding a pinned-page scope group simply
> wouldn't increment the iommu counter, which would initially be zero
> indicating no "all-dma" groups.  Thanks,
> 
Sure, I will do that, thanks.

Keqian.

> Alex
> 
> .
> 
