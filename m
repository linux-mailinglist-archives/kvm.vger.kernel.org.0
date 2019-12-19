Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A03D1269F4
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 19:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfLSSmq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 13:42:46 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2029 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728722AbfLSSmp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 13:42:45 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfbc4990000>; Thu, 19 Dec 2019 10:42:34 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 19 Dec 2019 10:42:44 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 19 Dec 2019 10:42:44 -0800
Received: from [10.40.100.125] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 19 Dec
 2019 18:42:34 +0000
Subject: Re: [PATCH v10 Kernel 4/5] vfio iommu: Implementation of ioctl to for
 dirty pages tracking.
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Yan Zhao <yan.y.zhao@intel.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1576527700-21805-1-git-send-email-kwankhede@nvidia.com>
 <1576527700-21805-5-git-send-email-kwankhede@nvidia.com>
 <20191217051513.GE21868@joy-OptiPlex-7040>
 <17ac4c3b-5f7c-0e52-2c2b-d847d4d4e3b1@nvidia.com>
 <20191218143902.3c9b06df@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <6667e0b4-f3da-6283-3f27-c1cba3d13117@nvidia.com>
Date:   Fri, 20 Dec 2019 00:12:30 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191218143902.3c9b06df@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576780954; bh=yc7GPjS2kHBED4VdPZXolDx+lH4rl8plLC7emiHQM9Y=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=aDdE9X7hlKg0NJn0sJaTZNo0MTuiG4d64RSe4TPiXRIALTAxP18ZR5cYNcoZHzzvn
         OtP6OzpMX0GqyYezSK1FGttePQ80pS8M8cnHw3BfPH5mxZ4sbjZhEECbOLzFOHbiye
         /se+vcJ3rvXPYqiTJSZMTER4gm/q6YSViRZYIhAtH5HDJmTQfkrokCY1vWmaz3KIXD
         XwpKSX6J4MnX3t9bYV6a4bk3TeNVyBRGqWA1C8MYMagB6a4axgFJsI2qQAtJ0c2krZ
         Lj55MC2S5oMhGFfPxDAFZAo2n+5nMjjeQ2B1G4784UBMfSC8BxLIPnqmyqiUIuUAoF
         tGRjvXrylk5Rw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/19/2019 3:09 AM, Alex Williamson wrote:
> On Tue, 17 Dec 2019 14:54:14 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 12/17/2019 10:45 AM, Yan Zhao wrote:
>>> On Tue, Dec 17, 2019 at 04:21:39AM +0800, Kirti Wankhede wrote:
>>>> +		} else if (range.flags &
>>>> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
>>>> +			uint64_t iommu_pgmask;
>>>> +			unsigned long pgshift = __ffs(range.pgsize);
>>>> +			unsigned long *bitmap;
>>>> +			long bsize;
>>>> +
>>>> +			iommu_pgmask =
>>>> +			 ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
>>>> +
>>>> +			if (((range.pgsize - 1) & iommu_pgmask) !=
>>>> +			    (range.pgsize - 1))
>>>> +				return -EINVAL;
>>>> +
>>>> +			if (range.iova & iommu_pgmask)
>>>> +				return -EINVAL;
>>>> +			if (!range.size || range.size > SIZE_MAX)
>>>> +				return -EINVAL;
>>>> +			if (range.iova + range.size < range.iova)
>>>> +				return -EINVAL;
>>>> +
>>>> +			bsize = verify_bitmap_size(range.size >> pgshift,
>>>> +						   range.bitmap_size);
>>>> +			if (bsize)
>>>> +				return ret;
>>>> +
>>>> +			bitmap = kmalloc(bsize, GFP_KERNEL);
>>>> +			if (!bitmap)
>>>> +				return -ENOMEM;
>>>> +
>>>> +			ret = copy_from_user(bitmap,
>>>> +			     (void __user *)range.bitmap, bsize) ? -EFAULT : 0;
>>>> +			if (ret)
>>>> +				goto bitmap_exit;
>>>> +
>>>> +			iommu->dirty_page_tracking = false;
>>> why iommu->dirty_page_tracking is false here?
>>> suppose this ioctl can be called several times.
>>>    
>>
>> This ioctl can be called several times, but once this ioctl is called
>> that means vCPUs are stopped and VFIO devices are stopped (i.e. in
>> stop-and-copy phase) and dirty pages bitmap are being queried by user.
> 
> Do not assume how userspace works or its intent.  If dirty tracking is
> on, it should remain on until the user turns it off.  We cannot assume
> userspace uses a one-shot approach.  Thanks,
> 

Dirty tracking should be on until user turns it off or user reads 
bitmap, right? This ioctl is used to read bitmap.


Thanks,
Kirti



