Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F105F1C8199
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 07:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgEGFhj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 01:37:39 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:14281 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgEGFhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 01:37:39 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb39e200000>; Wed, 06 May 2020 22:35:28 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Wed, 06 May 2020 22:37:38 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Wed, 06 May 2020 22:37:38 -0700
Received: from [10.40.101.152] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 May
 2020 05:37:30 +0000
Subject: Re: [PATCH Kernel v18 6/7] vfio iommu: Add migration capability to
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
References: <1588607939-26441-1-git-send-email-kwankhede@nvidia.com>
 <1588607939-26441-7-git-send-email-kwankhede@nvidia.com>
 <20200506162738.6e08dbf2@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <79f1a586-52be-ab72-493a-3a3c5ae6e252@nvidia.com>
Date:   Thu, 7 May 2020 11:07:26 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506162738.6e08dbf2@w520.home>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588829728; bh=PCZ/GyErkVmvQQTaVhthVdSrM4rEkn03vvTTvcYS51g=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=qK7k1n/XuYPWG8QTVm2YIdD3m5X0DsURRUDzMkwkyUwf3rZgPeW/aLnmXT83cemTu
         znGGEtzKX555pRrzGnA0ij+E9MirxbC66VafQC35tWanKlJq1IusH9oKkCYjCahRan
         nn2x99EWk+TEps7Z2j6YDBd283eAy4YRf3xk5entnyPh+N2HPEKEB6zxFnFQH7eyYY
         lFIMtKx3nvlJUFo25X/aSS2H59IF6h+SQ4nKATyasxCXqbgsgQX7r2LnG3Mn1vz+sy
         ejRXV8NXh/qlye+Uv6KtdKxzAa1G+stOANrmYAr4pSh9cu2iDTMKJkDSED9uZaKDVS
         EpRHE/s9D2Miw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/7/2020 3:57 AM, Alex Williamson wrote:
> On Mon, 4 May 2020 21:28:58 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> Added migration capability in IOMMU info chain.
>> User application should check IOMMU info chain for migration capability
>> to use dirty page tracking feature provided by kernel module.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 15 +++++++++++++++
>>   include/uapi/linux/vfio.h       | 14 ++++++++++++++
>>   2 files changed, 29 insertions(+)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 8b27faf1ec38..b38d278d7bff 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -2378,6 +2378,17 @@ static int vfio_iommu_iova_build_caps(struct vfio_iommu *iommu,
>>   	return ret;
>>   }
>>   
>> +static int vfio_iommu_migration_build_caps(struct vfio_info_cap *caps)
>> +{
>> +	struct vfio_iommu_type1_info_cap_migration cap_mig;
>> +
>> +	cap_mig.header.id = VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
>> +	cap_mig.header.version = 1;
>> +	cap_mig.flags = VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK;
>> +
>> +	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
>> +}
>> +
>>   static long vfio_iommu_type1_ioctl(void *iommu_data,
>>   				   unsigned int cmd, unsigned long arg)
>>   {
>> @@ -2427,6 +2438,10 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>   		if (ret)
>>   			return ret;
>>   
>> +		ret = vfio_iommu_migration_build_caps(&caps);
>> +		if (ret)
>> +			return ret;
>> +
>>   		if (caps.size) {
>>   			info.flags |= VFIO_IOMMU_INFO_CAPS;
>>   
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index e3cbf8b78623..df9ce8aaafab 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -1013,6 +1013,20 @@ struct vfio_iommu_type1_info_cap_iova_range {
>>   	struct	vfio_iova_range iova_ranges[];
>>   };
>>   
>> +/*
>> + * The migration capability allows to report supported features for migration.
>> + *
>> + * The structures below define version 1 of this capability.
>> + */
>> +#define VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION  1
>> +
>> +struct vfio_iommu_type1_info_cap_migration {
>> +	struct	vfio_info_cap_header header;
>> +	__u32	flags;
>> +	/* supports dirty page tracking */
>> +#define VFIO_IOMMU_INFO_CAPS_MIGRATION_DIRTY_PAGE_TRACK	(1 << 0)
>> +};
>> +
> 
> What about exposing the maximum supported dirty bitmap size and the
> supported page sizes?  Thanks,
> 

How should user application use that?

Thanks,
Kirti

> Alex
> 
>>   #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
>>   
>>   /**
> 
