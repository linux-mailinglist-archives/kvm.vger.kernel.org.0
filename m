Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4098B1D202A
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 22:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgEMU0q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 16:26:46 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:11011 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725931AbgEMU0q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 May 2020 16:26:46 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebc57ba0000>; Wed, 13 May 2020 13:25:31 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 13 May 2020 13:26:45 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 13 May 2020 13:26:45 -0700
Received: from [10.40.103.94] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 May
 2020 20:26:38 +0000
Subject: Re: [PATCH Kernel v18 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
To:     Cornelia Huck <cohuck@redhat.com>
CC:     <alex.williamson@redhat.com>, <cjia@nvidia.com>,
        <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1588607939-26441-1-git-send-email-kwankhede@nvidia.com>
 <1588607939-26441-5-git-send-email-kwankhede@nvidia.com>
 <20200506125405.745bb99e.cohuck@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <b9b97dfb-2c1a-519b-3778-7a546cda9bda@nvidia.com>
Date:   Thu, 14 May 2020 01:56:33 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506125405.745bb99e.cohuck@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589401531; bh=HUo2laP3kvjRMDt/ys/RuIxx41g9jXz1Yv3GZV+vxcc=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=T8QOOtkwiCKgA8DFUOynShk/2QiLdtkTKyFiHhIgs3kTRenPv5p0qlj/XI59MapeS
         dvQVYsJY3jE2dRaEDc42lJdtav1rBKXBP3+37pHPEvSWM15k4JiQUzQT297YOrHgxk
         f5r0VTr5fvbYb+Wx8QoNoIuUaFsM91NPEbFTloblKx0lQVDzhB2gHx8Xf2ksk1sp4v
         RlORG4bH79IQIp3erlgCm+S5i2YwnBEXPrM/K7sUF+b6u8M6ZGlEupTcjrZIM9WHgq
         StFuiwlbFJUZljQgSdAKpD5gTzOKAt4Kq0JeV7k9+Ew/F2Jh4Lx+/wMP3H3SPQ+jni
         DZtQdCGN3sVTA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/6/2020 4:24 PM, Cornelia Huck wrote:
> On Mon, 4 May 2020 21:28:56 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> VFIO_IOMMU_DIRTY_PAGES ioctl performs three operations:
>> - Start dirty pages tracking while migration is active
>> - Stop dirty pages tracking.
>> - Get dirty pages bitmap. Its user space application's responsibility to
>>    copy content of dirty pages from source to destination during migration.
>>
>> To prevent DoS attack, memory for bitmap is allocated per vfio_dma
>> structure. Bitmap size is calculated considering smallest supported page
>> size. Bitmap is allocated for all vfio_dmas when dirty logging is enabled
>>
>> Bitmap is populated for already pinned pages when bitmap is allocated for
>> a vfio_dma with the smallest supported page size. Update bitmap from
>> pinning functions when tracking is enabled. When user application queries
>> bitmap, check if requested page size is same as page size used to
>> populated bitmap. If it is equal, copy bitmap, but if not equal, return
>> error.
>>
>> Fixed below error by changing pgsize type from uint64_t to size_t.
>> Reported-by: kbuild test robot <lkp@intel.com>
>>
>> All errors:
>> drivers/vfio/vfio_iommu_type1.c:197: undefined reference to `__udivdi3'
>>
>> drivers/vfio/vfio_iommu_type1.c:225: undefined reference to `__udivdi3'
> 
> Move that below the '---' delimiter so that it does not end up in the
> commit? (Crediting the build bot is fine, but the details are not
> really useful when you look at the code later.)
> 

ok, removing errors.

>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 266 +++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 260 insertions(+), 6 deletions(-)
> 
>> @@ -2278,6 +2435,93 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>   
>>   		return copy_to_user((void __user *)arg, &unmap, minsz) ?
>>   			-EFAULT : 0;
>> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
>> +		struct vfio_iommu_type1_dirty_bitmap dirty;
>> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
>> +		int ret = 0;
>> +
>> +		if (!iommu->v2)
>> +			return -EACCES;
>> +
>> +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
>> +				    flags);
>> +
>> +		if (copy_from_user(&dirty, (void __user *)arg, minsz))
>> +			return -EFAULT;
>> +
>> +		if (dirty.argsz < minsz || dirty.flags & ~mask)
>> +			return -EINVAL;
>> +
>> +		/* only one flag should be set at a time */
>> +		if (__ffs(dirty.flags) != __fls(dirty.flags))
>> +			return -EINVAL;
>> +
> 
> Shouldn't you also check whether the flag that is set is actually
> valid? (maybe dirty.flags & ~VFIO_IOMMU_DIRTY_PAGES_FLAG_MASK and do a
> switch/case over dirty.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_MASK)
> 

There is a check above this check, dirty.flags & ~mask, which makes sure 
that flag is valid.

Thanks,
Kirti

