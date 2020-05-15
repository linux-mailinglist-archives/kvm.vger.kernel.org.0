Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA551D580B
	for <lists+kvm@lfdr.de>; Fri, 15 May 2020 19:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgEORfh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 May 2020 13:35:37 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10522 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbgEORfh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 May 2020 13:35:37 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebed25d0002>; Fri, 15 May 2020 10:33:18 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 15 May 2020 10:35:36 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 15 May 2020 10:35:36 -0700
Received: from [10.40.103.94] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 15 May
 2020 17:35:28 +0000
Subject: Re: [PATCH Kernel v20 4/8] vfio iommu: Add ioctl definition for dirty
 pages tracking
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
References: <1589488667-9683-1-git-send-email-kwankhede@nvidia.com>
 <1589488667-9683-5-git-send-email-kwankhede@nvidia.com>
 <20200515125916.78723321.cohuck@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <bdb9c1d3-e673-5bb1-aced-f7443f4dfe58@nvidia.com>
Date:   Fri, 15 May 2020 23:05:24 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200515125916.78723321.cohuck@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589563998; bh=ayKJyENVWVq+++eaQa/RNQ3Hiaj6T+Ugv63pCGUuAUE=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=dtlAvlT38WGDkPjIhiGYjrh5KgLWYJC+TPqVNjivA9id56PtMEKtLV31xSol22Jjw
         A5Y1JwbXU1prlK1vZqwvKhu/dH2dPUFaMRJyvxpnxMKaRuX1kDDg6GfcNOk67lGDYh
         XgnDFNC8Viw8PvVKEBMAMVPv1Ng/xeCiScx65T5ZuWnoTrMLnvtrIm27tHNHUqtkNL
         /N8h5RQrI/FYWRimkDkJhwvbcB6DHU5Cd/tl9Ote37R3wNWdz7Yvqx3Jgjv5yRIlsu
         scqteeHZd40SDRd9xUcrpXYXt7CQ6Du4CdQirzu+OwyFzFXnNDTCL6KOJ7Ni7qJbDc
         0AZpFuStfaepA==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/15/2020 4:29 PM, Cornelia Huck wrote:
> On Fri, 15 May 2020 02:07:43 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
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
>> index ad9bb5af3463..123de3bc2dce 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1033,6 +1033,12 @@ struct vfio_iommu_type1_dma_map {
>>   
>>   #define VFIO_IOMMU_MAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 13)
>>   
>> +struct vfio_bitmap {
>> +	__u64        pgsize;	/* page size for bitmap in bytes */
>> +	__u64        size;	/* in bytes */
>> +	__u64 __user *data;	/* one bit per page */
>> +};
>> +
>>   /**
>>    * VFIO_IOMMU_UNMAP_DMA - _IOWR(VFIO_TYPE, VFIO_BASE + 14,
>>    *							struct vfio_dma_unmap)
>> @@ -1059,6 +1065,55 @@ struct vfio_iommu_type1_dma_unmap {
>>   #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
>>   #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
>>   
>> +/**
>> + * VFIO_IOMMU_DIRTY_PAGES - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
>> + *                                     struct vfio_iommu_type1_dirty_bitmap)
>> + * IOCTL is used for dirty pages tracking.
>> + * Caller should set flag depending on which operation to perform, details as
>> + * below:
>> + *
>> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_START set, indicates
>> + * migration is active and IOMMU module should track pages which are dirtied or
>> + * potentially dirtied by device.
> 
> "Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_START instructs the
> IOMMU driver to track pages that are dirtied or potentially dirtied by
> the device; designed to be used when a migration is in progress."
> 
> ?
> 

Ok, updating.

>> + * Dirty pages are tracked until tracking is stopped by user application by
>> + * setting VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP flag.
> 
> "...by calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP." ?
> 
>> + *
>> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP set, indicates
>> + * IOMMU should stop tracking dirtied pages.
> 
> "Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP instructs the
> IOMMU driver to stop tracking dirtied pages."
> 
> ?
> 

Ok.

>> + *
>> + * When IOCTL is called with VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP flag set,
>> + * IOCTL returns dirty pages bitmap for IOMMU container during migration for
>> + * given IOVA range.
> 
> "Calling the IOCTL with VFIO_IOMMU_DIRTY_PAGES_GET_BITMAP returns the
> dirty pages bitmap for the IOMMU container for a given IOVA range." ?
> 
> Q: How does this interact with the two other operations? I imagine
> getting an empty bitmap before _START 

No, if dirty page tracking is not started, get_bitmap IOCTL will fail 
with -EINVAL.

> and a bitmap-in-progress between
> _START and _STOP. > After _STOP, will subsequent calls always give the
> same bitmap?
>

No, return -EINVAL.


>> User must provide data[] as the structure
>> + * vfio_iommu_type1_dirty_bitmap_get through which user provides IOVA range and
>> + * pgsize.
> 
> "The user must specify the IOVA range and the pgsize through the
> vfio_iommu_type1_dirty_bitmap_get structure in the data[] portion."
> 
> ?
> 
>> This interface supports to get bitmap of smallest supported pgsize
>> + * only and can be modified in future to get bitmap of specified pgsize.
> 
> That's a current restriction? How can the user find out whether it has
> been lifted (or, more generally, find out which pgsize values are
> supported)?

Migration capability is added to IOMMU info chain. That gives supported 
pgsize bitmap by IOMMU driver.

> 
>> + * User must allocate memory for bitmap, zero the bitmap memory  and set size
>> + * of allocated memory in bitmap.size field.
> 
> "The user must provide a zeroed memory area for the bitmap memory and
> specify its size in bitmap.size."
> 
> ?
> 
>> One bit is used to represent one
>> + * page consecutively starting from iova offset. User should provide page size
>> + * in bitmap.pgsize field.
> 
> s/User/The user/
> 
> Is that the 'pgsize' the comment above talks about?
> 

By specifying pgsize here user can ask for bitmap of specific pgsize.

>> Bit set in bitmap indicates page at that offset from
>> + * iova is dirty.
> 
> "A bit set in the bitmap indicates that the page at that offset from
> iova is dirty." ?
> 
>> Caller must set argsz including size of structure
>> + * vfio_iommu_type1_dirty_bitmap_get.
> 
> s/Caller/The caller/
> 
> Does argz also include the size of the bitmap?

No.

> 
>> + *
>> + * Only one of the flags _START, STOP and _GET may be specified at a time.
> 
> s/STOP/_STOP/
> 
> (just to be consistent)
> 
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
> 
> That's for type1 only, right?
>

Yes.

Thanks,
Kirti

>> +
>> +#define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
>> +
>>   /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>>   
>>   /*
> 
