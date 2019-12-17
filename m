Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBEFD1224B2
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2019 07:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfLQGce (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Dec 2019 01:32:34 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:10738 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbfLQGce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Dec 2019 01:32:34 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5df876660000>; Mon, 16 Dec 2019 22:32:06 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 16 Dec 2019 22:32:33 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 16 Dec 2019 22:32:33 -0800
Received: from [10.40.102.133] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Dec
 2019 06:32:22 +0000
Subject: Re: [PATCH v10 Kernel 2/5] vfio iommu: Adds flag to indicate dirty
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
References: <1576527700-21805-1-git-send-email-kwankhede@nvidia.com>
 <1576527700-21805-3-git-send-email-kwankhede@nvidia.com>
 <20191216161652.30681b05@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <c235ab32-0343-9ef9-a08b-ca46f6d59a99@nvidia.com>
Date:   Tue, 17 Dec 2019 12:02:18 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191216161652.30681b05@x1.home>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576564326; bh=A5QjnAkDzWKyT82IOaf5AQpyfjWRFLeindcNAQorwSU=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=BZK2QEOneDhLAWCupNOc+G//i2LMgl7QvFpqRHncVpFrFrEN3k5j5HX3BiJOUCKgn
         fwNZogb10y409UGrVsvzOQHa9F7saTZcifw5b3OvmGc2kQbimcorlomzwd+sSwZK0j
         JlNlN/lw3XzgRblxIvVSpN76Mc0ieWEoJMoERCwyGF9kglIu1yhQlocKhin/KM0Z47
         ZuHO75BbdVo56oPpe2S23bFegW9r2YdnkHWTT+68yg04re8++p+ApEtL8fJVfQFzSp
         pchjLfuftWqywqxlMpdFhc+QgvHY3SAwkcAtJtehIwklc4kQGWGvsk7rphf7KqOG3O
         f1rEXhQqGNlGw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/17/2019 4:46 AM, Alex Williamson wrote:
> On Tue, 17 Dec 2019 01:51:37 +0530
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
>> index 2ada8e6cdb88..3f6b04f2334f 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -2234,7 +2234,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>>   			info.cap_offset = 0; /* output, no-recopy necessary */
>>   		}
>>   
>> -		info.flags = VFIO_IOMMU_INFO_PGSIZES;
>> +		info.flags = VFIO_IOMMU_INFO_PGSIZES |
>> +			     VFIO_IOMMU_INFO_DIRTY_PGS;
> 
> Type1 shouldn't advertise it until it's supported though, right?
> Thanks,
> 

Should this be merged with last patch where VFIO_IOMMU_UNMAP_DMA ioctl 
is updated?

Thanks,
Kirti

> Alex
> 
>>   
>>   		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
>>   
>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>> index a0817ba267c1..81847ed54eb7 100644
>> --- a/include/uapi/linux/vfio.h
>> +++ b/include/uapi/linux/vfio.h
>> @@ -900,8 +900,9 @@ struct vfio_device_ioeventfd {
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
