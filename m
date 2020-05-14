Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E7D1D2EE8
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 13:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgENLzY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 07:55:24 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10065 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbgENLzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 07:55:24 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ebd31210000>; Thu, 14 May 2020 04:53:05 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 14 May 2020 04:55:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 14 May 2020 04:55:23 -0700
Received: from [10.40.103.94] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 May
 2020 11:55:14 +0000
Subject: Re: [PATCH Kernel v19 7/8] vfio iommu: Add migration capability to
 report supported features
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
References: <1589400279-28522-1-git-send-email-kwankhede@nvidia.com>
 <1589400279-28522-8-git-send-email-kwankhede@nvidia.com>
 <20200513230153.0b5f3729@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <23cb6aae-5212-2bce-6bec-fd893ea84d09@nvidia.com>
Date:   Thu, 14 May 2020 17:25:10 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200513230153.0b5f3729@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589457185; bh=TC4Hs3akve1qrbifB6Q8+iRwZPlpROjU3NnwvRvVTTE=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=KDnc5vLBGvp5lwZsMjSoL2LmpJ0WmlnHwcH2wZTpAKTcNJXofSqQrZAzmuCJ0r8po
         5fFD7/lSMpHXY5rtTjhP+q3anjq1GpZbihwYii2diE30Xp0Q87eEde4PFcl/wENeax
         RBWJxI2nFwoj+ueShCNBddnYrK+el/Co0wv5u2Mb3uobwYmzlSd//jvGnNF6oW4hIf
         md5l2T9bo8y+45Gq/Oz0q5MnVJIDV5ksUmGtcBo+IAvFzHd2nphrGYxtFk6br+Fj3b
         36lTmsGb4ELeOl9OaSPukBLjatuA+J36uYpBKhSAYOuDCbx5r/wLR0jjsurMBI6H2v
         5AV2awy52JNRg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/14/2020 10:31 AM, Alex Williamson wrote:
> On Thu, 14 May 2020 01:34:38 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> Added migration capability in IOMMU info chain.
>> User application should check IOMMU info chain for migration capability
>> to use dirty page tracking feature provided by kernel module.
>> User application must check page sizes supported and maximum dirty
>> bitmap size returned by this capability structure for ioctls used to get
>> dirty bitmap.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 24 +++++++++++++++++++++++-
>>   include/uapi/linux/vfio.h       | 21 +++++++++++++++++++++
>>   2 files changed, 44 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 4358be26ff80..77351497a9c2 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -2389,6 +2389,22 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
>>   	return ret;
>>   }
>>   
>> +static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
>> +					   struct vfio_info_cap *caps)
>> +{
>> +	struct vfio_iommu_type1_info_cap_migration cap_mig;
>> +
>> +	cap_mig.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
>> +	cap_mig.header.version = 1;
>> +	cap_mig.flags = VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK;
>> +
>> +	/* support minimum pgsize */
>> +	cap_mig.pgsize_bitmap = (size_t)1 << __ffs(iommu->pgsize_bitmap);
>> +	cap_mig.max_dirty_bitmap_size = DIRTY_BITMAP_SIZE_MAX;
>> +
>> +	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
>> +}
>> +
>>   static long vfio_iommu_type1_ioctl(void *iommu_data,
>>   				   unsigned int cmd, unsigned long arg)
>>   {
>> @@ -2433,10 +2449,16 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>   		mutex_lock(&iommu->lock);
>>   		info.flags = VFIO_IOMMU_INFO_PGSIZES;
>>   
>> +		vfio_pgsize_bitmap(iommu);
> 
> 
> Why is it necessary to rebuild the bitmap here?  The user can't get to
> this ioctl until they've added a group to the container and set the
> IOMMU model.
> 
> 
For mdev device, domain is not added to domain_list so 
vfio_pgsize_bitmap() doesn't get called when there is only mdev device 
attached.
Your concern is right though, vfio_pgsize_bitmap() should get populated 
with attach_group,so fixing it by calling vfio_pgsize_bitmap() for mdev 
device when iommu->external_domain is set.

>>   		info.iova_pgsizes = iommu->pgsize_bitmap;
>>   
>> -		ret = vfio_iommu_iova_build_caps(iommu, &caps);
>> +		ret = vfio_iommu_migration_build_caps(iommu, &caps);
>> +
>> +		if (!ret)
>> +			ret = vfio_iommu_iova_build_caps(iommu, &caps);
>> +
>>   		mutex_unlock(&iommu->lock);
>> +
>>   		if (ret)
>>   			return ret;
>>   
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index e3cbf8b78623..c90604322798 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1013,6 +1013,27 @@ struct vfio_iommu_type1_info_cap_iova_range {
>>   	struct	vfio_iova_range iova_ranges[];
>>   };
>>   
>> +/*
>> + * The migration capability allows to report supported features for migration.
>> + *
>> + * The structures below define version 1 of this capability.
>> + *
>> + * pgsize_bitmap: Kernel driver returns supported page sizes bitmap for dirty
>> + * page tracking.
>> + * max_dirty_bitmap_size: Kernel driver returns maximum supported dirty bitmap
>> + * size in bytes to be used by user application for ioctls to get dirty bitmap.
>> + */
>> +#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
>> +
>> +struct vfio_iommu_type1_info_cap_migration {
>> +	struct	vfio_info_cap_header header;
>> +	__u32	flags;
>> +	/* supports dirty page tracking */
>> +#define VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK	(1 << 0)
> 
> This flag is a bit redundant to the purpose of this capability, isn't
> it?  I think exposing the capability itself is indicating support for
> dirty page tracking.  We should probably be explicit in the comment
> about exactly what interface this capability implies.  Thanks,
>

Capability is added to provide provision for feature flags that kernel 
driver support, that's where we started right?
Later added pgsize_bitmap and max supported bitmap size as you suggested.
I'm confused now, should I keep this flag here?
Even if the flag is removed, 'flags' field is still required so that 
whenever new feature is added, new flag will be added. That's the whole 
purpose we added this capability. Can we add a field which is not used? 
and we don't know when it will be used in future?

Thanks,
Kirti

> Alex
> 
>> +	__u64	pgsize_bitmap;
>> +	__u64	max_dirty_bitmap_size;		/* in bytes */
>> +};
>> +
>>   #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>>   
>>   /**
> 
