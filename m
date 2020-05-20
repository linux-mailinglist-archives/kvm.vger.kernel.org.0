Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6999A1DB80A
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 17:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgETPX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 11:23:28 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8717 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbgETPX1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 11:23:27 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec54adf0000>; Wed, 20 May 2020 08:21:03 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 20 May 2020 08:23:26 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 20 May 2020 08:23:26 -0700
Received: from [10.40.103.233] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 May
 2020 15:23:18 +0000
Subject: Re: [PATCH Kernel v22 7/8] vfio iommu: Add migration capability to
 report supported features
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
References: <1589781397-28368-1-git-send-email-kwankhede@nvidia.com>
 <1589781397-28368-8-git-send-email-kwankhede@nvidia.com>
 <20200520124200.0b4f3562.cohuck@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <58ec5324-43e5-29cb-73b1-3675444cf89b@nvidia.com>
Date:   Wed, 20 May 2020 20:53:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520124200.0b4f3562.cohuck@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589988063; bh=UMdQ/xPibCGY4nwJSkquHiL7+3P4sPKyNpcpRUS9mXw=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=YxFUbzyR8PNp5m1/hFX766bVMC/wBi1dhO64zkqKWjYMrqWX3wp+4OMNl+QCS0NC0
         H6jHFnGIaDimDYXdYmSNHFiQZYGNH5Riz2ymxMqrVKhfhwxRT+Ekj2ltlaKUIF0j3/
         XQPOQyA8TKxhARDG6tIYFrxX4M9ITYfarQADow++FLfxhmZVJO9DpikxtKfboC+8kU
         fIqybF26pvNK/p3mIHMXqmQFXGuTQDtjqnvjYTBD53tMxd8cByh/pMPXkIS0Hk5Khl
         su4eWzVgls5cjMSAup3XFUcqpWcMogBGD3saYZ9WwWl7du96tAG17so43ZPPf2JUR7
         kyfU9Eq7CA0sg==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/20/2020 4:12 PM, Cornelia Huck wrote:
> On Mon, 18 May 2020 11:26:36 +0530
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
>>   drivers/vfio/vfio_iommu_type1.c | 23 ++++++++++++++++++++++-
>>   include/uapi/linux/vfio.h       | 22 ++++++++++++++++++++++
>>   2 files changed, 44 insertions(+), 1 deletion(-)
> 
> (...)
> 
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index a1dd2150971e..aa8aa9dcf02a 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1013,6 +1013,28 @@ struct vfio_iommu_type1_info_cap_iova_range {
>>   	struct	vfio_iova_range iova_ranges[];
>>   };
>>   
>> +/*
>> + * The migration capability allows to report supported features for migration.
>> + *
>> + * The structures below define version 1 of this capability.
>> + *
>> + * The existence of this capability indicates IOMMU kernel driver supports
> 
> s/indicates/indicates that/
> 
>> + * dirty page tracking.
>> + *
>> + * pgsize_bitmap: Kernel driver returns supported page sizes bitmap for dirty
>> + * page tracking.
> 
> "bitmap of supported page sizes for dirty page tracking" ?
> 
>> + * max_dirty_bitmap_size: Kernel driver returns maximum supported dirty bitmap
>> + * size in bytes to be used by user application for ioctls to get dirty bitmap.
> 
> "maximum supported dirty bitmap size in bytes that can be used by user
> applications when getting the dirty bitmap" ?
> 

Done.

>> + */
>> +#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
>> +
>> +struct vfio_iommu_type1_info_cap_migration {
>> +	struct	vfio_info_cap_header header;
>> +	__u32	flags;
>> +	__u64	pgsize_bitmap;
>> +	__u64	max_dirty_bitmap_size;		/* in bytes */
>> +};
>> +
>>   #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>>   
>>   /**
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks.

Kirti
