Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2870FB8F5
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 20:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfKMThg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 14:37:36 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:2572 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfKMThg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 14:37:36 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcc5b810000>; Wed, 13 Nov 2019 11:37:37 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 13 Nov 2019 11:37:34 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 13 Nov 2019 11:37:34 -0800
Received: from [10.25.73.195] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 13 Nov
 2019 19:37:25 +0000
Subject: Re: [PATCH v9 Kernel 2/5] vfio iommu: Add ioctl defination to get
 dirty pages bitmap.
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
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
 <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
 <20191112153020.71406c44@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
Date:   Thu, 14 Nov 2019 01:07:21 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191112153020.71406c44@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573673857; bh=6fNZc2mHwEswrolJj1VDa99wf4sYflIbMrzvc45iAFs=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=lINcAqrguOlRieumuvDf33LJlToXpndTmzQVE7Umbdg2fukbs/FsQuO8LG09mLMbT
         dF/mhOYz0CbIHm+Z7Fldewq+TzeeQ4uaSRSgJ2wZ+3HEteE0hYnhBcXgZwlDo384yv
         Tw723jIeUDyHfCS19eTJtlCVaBedNHi3LPT+0PUCMruh4YkMQhNSimTKBdtFuuB4nw
         JSq6cWas/z26CqW2c31HLs9fS2vWKZGW78PEp4ssVBETLzLHpG1VuY7fs0XTc8aKyY
         PpaWTWRGSanA4VBu1VUlvGmtomCLNqtMmGucf3+E0BI8TQ09EikX3n2JPWbmL/NBY8
         uN1SsDxMiLAUQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/13/2019 4:00 AM, Alex Williamson wrote:
> On Tue, 12 Nov 2019 22:33:37 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> All pages pinned by vendor driver through vfio_pin_pages API should be
>> considered as dirty during migration. IOMMU container maintains a list of
>> all such pinned pages. Added an ioctl defination to get bitmap of such
> 
> definition
> 
>> pinned pages for requested IO virtual address range.
> 
> Additionally, all mapped pages are considered dirty when physically
> mapped through to an IOMMU, modulo we discussed devices opting in to
> per page pinning to indicate finer granularity with a TBD mechanism to
> figure out if any non-opt-in devices remain.
> 

You mean, in case of device direct assignment (device pass through)?

>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   include/uapi/linux/vfio.h | 23 +++++++++++++++++++++++
>>   1 file changed, 23 insertions(+)
>>
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index 35b09427ad9f..6fd3822aa610 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -902,6 +902,29 @@ struct vfio_iommu_type1_dma_unmap {
>>   #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
>>   #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
>>   
>> +/**
>> + * VFIO_IOMMU_GET_DIRTY_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
>> + *                                     struct vfio_iommu_type1_dirty_bitmap)
>> + *
>> + * IOCTL to get dirty pages bitmap for IOMMU container during migration.
>> + * Get dirty pages bitmap of given IO virtual addresses range using
>> + * struct vfio_iommu_type1_dirty_bitmap. Caller sets argsz, which is size of
>> + * struct vfio_iommu_type1_dirty_bitmap. User should allocate memory to get
>> + * bitmap and should set size of allocated memory in bitmap_size field.
>> + * One bit is used to represent per page consecutively starting from iova
>> + * offset. Bit set indicates page at that offset from iova is dirty.
>> + */
>> +struct vfio_iommu_type1_dirty_bitmap {
>> +	__u32        argsz;
>> +	__u32        flags;
>> +	__u64        iova;                      /* IO virtual address */
>> +	__u64        size;                      /* Size of iova range */
>> +	__u64        bitmap_size;               /* in bytes */
> 
> This seems redundant.  We can calculate the size of the bitmap based on
> the iova size.
>

But in kernel space, we need to validate the size of memory allocated by 
user instead of assuming user is always correct, right?

>> +	void __user *bitmap;                    /* one bit per page */
> 
> Should we define that as a __u64* to (a) help with the size
> calculation, and (b) assure that we can use 8-byte ops on it?
> 
> However, who defines page size?  Is it necessarily the processor page
> size?  A physical IOMMU may support page sizes other than the CPU page
> size.  It might be more important to indicate the expected page size
> than the bitmap size.  Thanks,
>

I see in QEMU and in vfio_iommu_type1 module, page sizes considered for 
mapping are CPU page size, 4K. Do we still need to have such argument?

Thanks,
Kirti

> Alex
> 
>> +};
>> +
>> +#define VFIO_IOMMU_GET_DIRTY_BITMAP             _IO(VFIO_TYPE, VFIO_BASE + 17)
>> +
>>   /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>>   
>>   /*
> 
