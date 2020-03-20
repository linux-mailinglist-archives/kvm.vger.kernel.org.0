Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E5E18D77F
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 19:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCTSmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 14:42:20 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:14495 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCTSmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 14:42:20 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e750e7d0001>; Fri, 20 Mar 2020 11:42:06 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 20 Mar 2020 11:42:19 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 20 Mar 2020 11:42:19 -0700
Received: from [10.40.103.10] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Mar
 2020 18:42:09 +0000
Subject: Re: [PATCH v15 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1584649004-8285-1-git-send-email-kwankhede@nvidia.com>
 <1584649004-8285-5-git-send-email-kwankhede@nvidia.com>
 <20200319165704.1f4eb36a@w520.home>
 <bc48ae5c-67f9-d95e-5d60-6c42359bb790@nvidia.com>
 <20200320120137.6acd89ee@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <cf0ee134-c1c7-f60c-afc2-8948268d8880@nvidia.com>
Date:   Sat, 21 Mar 2020 00:12:04 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200320120137.6acd89ee@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1584729726; bh=hWqEMqGjcjLbX1dudD5jfb/W5JW8uQKkE5TYekIBFFs=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=jkYZVcTIRXZJ2TlcNLaDDZzURzyQC3Ed07iBXv8NPBU8wu2+pSvV5j8/p0/SUnXED
         Ap/kTUh1gx41kfezG5vb1TQc3vf9Da1HVUA8up3daKw5ot4J37fnXGYj2rjcx2IYkE
         IMe545G2jYUrkOvYPXiVHu+z5CMhNjjgKyh47Ct6eecb4x36rXjpTJeimBFCR7kXn0
         57wlRg1nIDa8BfgVcTWduoAlK31c2V5Q9fhC+PrY1dmeUZcWM/D1rbCX1O30EgCSrS
         gmiIpWpiJfKzmf2lC8a7svO79PQTCiFWEQ2luHMMCyVWgFtMuKo5weKtgMyCsUmSHw
         Zex3jh4TV0vVQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/20/2020 11:31 PM, Alex Williamson wrote:
> On Fri, 20 Mar 2020 23:19:14 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 3/20/2020 4:27 AM, Alex Williamson wrote:
>>> On Fri, 20 Mar 2020 01:46:41 +0530
>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>    

<snip>

>>>> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
>>>> +				  size_t size, uint64_t pgsize,
>>>> +				  u64 __user *bitmap)
>>>> +{
>>>> +	struct vfio_dma *dma;
>>>> +	unsigned long pgshift = __ffs(pgsize);
>>>> +	unsigned int npages, bitmap_size;
>>>> +
>>>> +	dma = vfio_find_dma(iommu, iova, 1);
>>>> +
>>>> +	if (!dma)
>>>> +		return -EINVAL;
>>>> +
>>>> +	if (dma->iova != iova || dma->size != size)
>>>> +		return -EINVAL;
>>>> +
>>>> +	npages = dma->size >> pgshift;
>>>> +	bitmap_size = DIRTY_BITMAP_BYTES(npages);
>>>> +
>>>> +	/* mark all pages dirty if all pages are pinned and mapped. */
>>>> +	if (dma->iommu_mapped)
>>>> +		bitmap_set(dma->bitmap, 0, npages);
>>>> +
>>>> +	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
>>>> +		return -EFAULT;
>>>
>>> We still need to reset the bitmap here, clearing and re-adding the
>>> pages that are still pinned.
>>>
>>> https://lore.kernel.org/kvm/20200319070635.2ff5db56@x1.home/
>>>    
>>
>> I thought you agreed on my reply to it
>> https://lore.kernel.org/kvm/31621b70-02a9-2ea5-045f-f72b671fe703@nvidia.com/
>>
>>   > Why re-populate when there will be no change since
>>   > vfio_iova_dirty_bitmap() is called holding iommu->lock? If there is any
>>   > pin request while vfio_iova_dirty_bitmap() is still working, it will
>>   > wait till iommu->lock is released. Bitmap will be populated when page is
>>   > pinned.
> 
> As coded, dirty bits are only ever set in the bitmap, never cleared.
> If a page is unpinned between iterations of the user recording the
> dirty bitmap, it should be marked dirty in the iteration immediately
> after the unpinning and not marked dirty in the following iteration.
> That doesn't happen here.  We're reporting cumulative dirty pages since
> logging was enabled, we need to be reporting dirty pages since the user
> last retrieved the dirty bitmap.  The bitmap should be cleared and
> currently pinned pages re-added after copying to the user.  Thanks,
> 

Does that mean, we have to track every iteration? do we really need that 
tracking?

Generally the flow is:
- vendor driver pin x pages
- Enter pre-copy-phase where vCPUs are running - user starts dirty pages 
tracking, then user asks dirty bitmap, x pages reported dirty by 
VFIO_IOMMU_DIRTY_PAGES ioctl with _GET flag
- In pre-copy phase, vendor driver pins y more pages, now bitmap 
consists of x+y bits set
- In pre-copy phase, vendor driver unpins z pages, but bitmap is not 
updated, so again bitmap consists of x+y bits set.
- Enter in stop-and-copy phase, vCPUs are stopped, mdev devices are stopped
- user asks dirty bitmap - Since here vCPU and mdev devices are stopped, 
pages should not get dirty by guest driver or the physical device. 
Hence, x+y dirty pages would be reported.

I don't think we need to track every iteration of bitmap reporting.

Thanks,
Kirti



