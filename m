Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C188199EAD
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgCaTJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:09:03 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11526 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgCaTJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 15:09:03 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e8394ee0000>; Tue, 31 Mar 2020 12:07:26 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Tue, 31 Mar 2020 12:09:02 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Tue, 31 Mar 2020 12:09:02 -0700
Received: from [10.40.162.111] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 31 Mar
 2020 19:08:53 +0000
Subject: Re: [PATCH v17 Kernel 6/7] vfio iommu: Adds flag to indicate dirty
 pages tracking capability support
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
References: <1585587044-2408-1-git-send-email-kwankhede@nvidia.com>
 <1585587044-2408-7-git-send-email-kwankhede@nvidia.com>
 <20200330145814.32d9b652@w520.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <6c6e6625-6dfd-d885-23fe-511744816d5b@nvidia.com>
Date:   Wed, 1 Apr 2020 00:38:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200330145814.32d9b652@w520.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585681646; bh=+yRWf/dhtXvw/FAHRSSc0ZeH7kuo6HPCnZdE9zKjc0M=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=i70eDpzGIkE90JVwCF92NHeLs5KCZXzNyiNCBffWHIw5ILFL8dbHxySZwtXKoN5j0
         qPhA1SX8fIuw1UbJwdiUPkE2jY3ti4qY0FXNz0s+9aptIIwBdh1054hbl8kxOF9vME
         ICGngr/G+MkI9W77J7jbL3QJMvSsEJO4CFtqB3E7Hx6HfYm87Yvcd6eCUBo7gfx4o7
         DxPxccSQk49IAj8BG8xA/hVVlQDxM6HqZQfrQ/Xc1msSFwoARDrKWE3Pi2i+B9gq0R
         tGeD/mdUjsiYzOUA97jJ/1sX2Jg6x83OPFc8STgwgyxY8DlsG7MeE2jRHI49dc5UUS
         gF4m8C2N1QMig==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/31/2020 2:28 AM, Alex Williamson wrote:
> On Mon, 30 Mar 2020 22:20:43 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> Flag VFIO_IOMMU_INFO_DIRTY_PGS in VFIO_IOMMU_GET_INFO indicates that driver
>> support dirty pages tracking.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 3 ++-
>>   include/uapi/linux/vfio.h       | 5 +++--
>>   2 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 266550bd7307..9fe12b425976 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -2390,7 +2390,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>   			info.cap_offset = 0; /* output, no-recopy necessary */
>>   		}
>>   
>> -		info.flags = VFIO_IOMMU_INFO_PGSIZES;
>> +		info.flags = VFIO_IOMMU_INFO_PGSIZES |
>> +			     VFIO_IOMMU_INFO_DIRTY_PGS;
>>   
>>   		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
>>   
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index e3cbf8b78623..0fe7c9a6f211 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -985,8 +985,9 @@ struct vfio_device_feature {
>>   struct vfio_iommu_type1_info {
>>   	__u32	argsz;
>>   	__u32	flags;
>> -#define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
>> -#define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
>> +#define VFIO_IOMMU_INFO_PGSIZES   (1 << 0) /* supported page sizes info */
>> +#define VFIO_IOMMU_INFO_CAPS      (1 << 1) /* Info supports caps */
>> +#define VFIO_IOMMU_INFO_DIRTY_PGS (1 << 2) /* supports dirty page tracking */
>>   	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
>>   	__u32   cap_offset;	/* Offset within info struct of first cap */
>>   };
> 
> 
> As I just mentioned in my reply to Yan, I'm wondering if
> VFIO_CHECK_EXTENSION would be a better way to expose this.  The
> difference is relatively trivial, but currently the only flag
> set by VFIO_IOMMU_GET_INFO is to indicate the presence of a field in
> the returned structure.  I think this is largely true of other INFO
> ioctls within vfio as well and we're already using the
> VFIO_CHECK_EXTENSION ioctl to check supported IOMMU models, and IOMMU
> cache coherency.  We'd simply need to define a VFIO_DIRTY_PGS_IOMMU
> value (9) and return 1 for that case.  Then when we enable support for
> dirt pages that can span multiple mappings, we can add a v2 extensions,
> or "MULTI" variant of this extension, since it should be backwards
> compatible.
> 
> The v2/multi version will again require that the user provide a zero'd
> bitmap, but I don't think that should be a problem as part of the
> definition of that version (we won't know if the user is using v1 or
> v2, but a v1 user should only retrieve bitmaps that exactly match
> existing mappings, where all bits will be written).  Thanks,
> 
> Alex
> 

I look at these two ioctls as : VFIO_CHECK_EXTENSION is used to get 
IOMMU type, while VFIO_IOMMU_GET_INFO is used to get properties of a 
particular IOMMU type, right?

Then I think VFIO_IOMMU_INFO_DIRTY_PGS should be part of 
VFIO_IOMMU_GET_INFO and when we add code for v2/multi, a flag should be 
added to VFIO_IOMMU_GET_INFO.

Thanks,
Kirti
