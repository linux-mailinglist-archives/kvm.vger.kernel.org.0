Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A042A191A4E
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 20:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgCXTth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 15:49:37 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:16246 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbgCXTth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 15:49:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7a63f60000>; Tue, 24 Mar 2020 12:48:06 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 24 Mar 2020 12:49:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 24 Mar 2020 12:49:36 -0700
Received: from [10.40.103.72] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Mar
 2020 19:49:27 +0000
Subject: Re: [PATCH v15 Kernel 3/7] vfio iommu: Add ioctl definition for dirty
 pages tracking.
To:     Auger Eric <eric.auger@redhat.com>, <alex.williamson@redhat.com>,
        <cjia@nvidia.com>
CC:     <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1584649004-8285-1-git-send-email-kwankhede@nvidia.com>
 <1584649004-8285-4-git-send-email-kwankhede@nvidia.com>
 <6c58c249-9dc8-77bd-454e-9418216cdf92@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <f32e2007-17d6-57d1-59eb-6f3a8de83107@nvidia.com>
Date:   Wed, 25 Mar 2020 01:19:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <6c58c249-9dc8-77bd-454e-9418216cdf92@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585079286; bh=RdAy2FBF0O9VSVyz3xc8php8cO+9Bp16RiUmoATviYc=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Cg7i1KOYCqiXUN1SyINPqn7igYUL9H55sfOfYzdkwfmO1K7cASlxybC/E/kzGv5CG
         ZvLDchyaK5YX6d/jRJ6sK40l0Dp6vYz51rULdFefcp5c6m5gi6IRLRjv3e5wl90tyd
         lDoFlmnx3/Oh4oDEawSKOyjCh+d75d6/uXrNogVrli5wK5bpmgaCZuR52FE5C1shQS
         RafT8bwDQzWXlCVfNi50KxWA070hQ67+y1x6IzRR3EQn9Hi2O0GNTQGA5N40yCnUoo
         xMGy72p43IHmtC/u+XUk9ODGD1zIo8gSmW+87dtkn8GE3wKBnmeKJhUlkO2mVvcHRp
         6BRP5Np56O2aw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/24/2020 2:41 AM, Auger Eric wrote:
> Hi Kirti,
> 
> On 3/19/20 9:16 PM, Kirti Wankhede wrote:
>> IOMMU container maintains a list of all pages pinned by vfio_pin_pages API.
>> All pages pinned by vendor driver through this API should be considered as
>> dirty during migration. When container consists of IOMMU capable device and
>> all pages are pinned and mapped, then all pages are marked dirty.
>> Added support to start/stop dirtied pages tracking and to get bitmap of all
>> dirtied pages for requested IO virtual address range.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   include/uapi/linux/vfio.h | 55 +++++++++++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 55 insertions(+)
>>
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index d0021467af53..8138f94cac15 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -995,6 +995,12 @@ struct vfio_iommu_type1_dma_map {
>>   
>>   #define VFIO_IOMMU_MAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 13)
>>   
>> +struct vfio_bitmap {
>> +	__u64        pgsize;	/* page size for bitmap */
> in bytes as well

Added.

>> +	__u64        size;	/* in bytes */
>> +	__u64 __user *data;	/* one bit per page */
>> +};
>> +
>>   /**
>>    * VFIO_IOMMU_UNMAP_DMA - _IOWR(VFIO_TYPE, VFIO_BASE + 14,
>>    *							struct vfio_dma_unmap)
>> @@ -1021,6 +1027,55 @@ struct vfio_iommu_type1_dma_unmap {
>>   #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
>>   #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
>>   
>> +/**
>> + * VFIO_IOMMU_DIRTY_PAGES - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
>> + *                                     struct vfio_iommu_type1_dirty_bitmap)
>> + * IOCTL is used for dirty pages tracking. Caller sets argsz, which is size of> + * struct vfio_iommu_type1_dirty_bitmap.
> nit: This may become outdated when adding new fields. argz use mode is
> documented at the beginning of the file.
>

Ok.

>   Caller set flag depend on which
>> + * operation to perform, details as below:
>> + *
>> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_START set, indicates
>> + * migration is active and IOMMU module should track pages which are dirtied or
>> + * potentially dirtied by device.
>> + * Dirty pages are tracked until tracking is stopped by user application by
>> + * setting VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag.
>> + *
>> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP set, indicates
>> + * IOMMU should stop tracking dirtied pages.
>> + *
>> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set,
>> + * IOCTL returns dirty pages bitmap for IOMMU container during migration for
>> + * given IOVA range. User must provide data[] as the structure
>> + * vfio_iommu_type1_dirty_bitmap_get through which user provides IOVA range
> I think the fact the IOVA range must match the vfio dma_size must be
> documented.

Added.

>   and
>> + * pgsize. This interface supports to get bitmap of smallest supported pgsize
>> + * only and can be modified in future to get bitmap of specified pgsize.
>> + * User must allocate memory for bitmap, zero the bitmap memory and set size
>> + * of allocated memory in bitmap_size field. One bit is used to represent one
>> + * page consecutively starting from iova offset. User should provide page size
>> + * in 'pgsize'. Bit set in bitmap indicates page at that offset from iova is
>> + * dirty. Caller must set argsz including size of structure
>> + * vfio_iommu_type1_dirty_bitmap_get.
> nit: ditto

I think this is still needed here because vfio_bitmap is only used in 
case of this particular flag.

Thanks,
Kirti

>> + *
>> + * Only one of the flags _START, STOP and _GET may be specified at a time.
>> + *
>> + */
>> +struct vfio_iommu_type1_dirty_bitmap {
>> +	__u32        argsz;
>> +	__u32        flags;
>> +#define VFIO_IOMMU_DIRTY_PAGES_FLAG_START	(1 << 0)
>> +#define VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP	(1 << 1)
>> +#define VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP	(1 << 2)
>> +	__u8         data[];
>> +};
>> +
>> +struct vfio_iommu_type1_dirty_bitmap_get {
>> +	__u64              iova;	/* IO virtual address */
>> +	__u64              size;	/* Size of iova range */
>> +	struct vfio_bitmap bitmap;
>> +};
>> +
>> +#define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
>> +
>>   /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>>   
>>   /*
>>
> Thanks
> 
> Eric
> 
