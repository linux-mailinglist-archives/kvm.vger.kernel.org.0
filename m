Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785C61DB753
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 16:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgETOqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 10:46:30 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:10800 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgETOq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 10:46:29 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ec542760001>; Wed, 20 May 2020 07:45:10 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 20 May 2020 07:46:29 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 20 May 2020 07:46:29 -0700
Received: from [10.40.103.233] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 20 May
 2020 14:46:21 +0000
Subject: Re: [PATCH Kernel v22 3/8] vfio iommu: Cache pgsize_bitmap in struct
 vfio_iommu
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
 <1589781397-28368-4-git-send-email-kwankhede@nvidia.com>
 <20200520120825.7d8144ba.cohuck@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <b43ac210-56da-26ea-7235-0416c7b7ff84@nvidia.com>
Date:   Wed, 20 May 2020 20:16:16 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520120825.7d8144ba.cohuck@redhat.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1589985910; bh=FPbxFOmi6KNOFTvuFioGxQQrtp4OZVgphsmww96nZ8E=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=V9H/ib1Au1lVVa1VZ5Z0T34YbYRV9fAjEKGJSp1HKcefK8zmpgi8JyqstyjV/OABY
         CRFaMlP8PsvHpnDYtLkNcnBho6zjHsbzG5uaQKtvjkrpyl2+mdcojlzmGg3MtIY76G
         BADbAkU2APNe7Kcsu3s6Di8LDGN+9B+91eZwvO9+YXPsTr5aKBv6Vt4kzlPVzEmyQ0
         jLrtup9Xt8E+wIejSykJaPrlFJQa2iUKk3M+tzdIrWdEwt866lF06JtIRBxbINO8oU
         V01N4Of+xk8um+rvx2brsYmor7hYOdNV4+/ziFuyqFeLQQFrvT+pyj3UtT2X5JOjJb
         FBDYFMNtnMhmQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/20/2020 3:38 PM, Cornelia Huck wrote:
> On Mon, 18 May 2020 11:26:32 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> Calculate and cache pgsize_bitmap when iommu->domain_list is updated
>> and iommu->external_domain is set for mdev device.
>> Add iommu->lock protection when cached pgsize_bitmap is accessed.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 88 +++++++++++++++++++++++------------------
>>   1 file changed, 49 insertions(+), 39 deletions(-)
>>
> 
> (...)
> 
>> @@ -805,15 +806,14 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
>>   	iommu->dma_avail++;
>>   }
>>   
>> -static unsigned long vfio_pgsize_bitmap(struct vfio_iommu *iommu)
>> +static void vfio_pgsize_bitmap(struct vfio_iommu *iommu)
> 
> Minor nit: I'd have renamed this function to
> vfio_update_pgsize_bitmap().
> 

Done.

>>   {
>>   	struct vfio_domain *domain;
>> -	unsigned long bitmap = ULONG_MAX;
>>   
>> -	mutex_lock(&iommu->lock);
>> +	iommu->pgsize_bitmap = ULONG_MAX;
>> +
>>   	list_for_each_entry(domain, &iommu->domain_list, next)
>> -		bitmap &= domain->domain->pgsize_bitmap;
>> -	mutex_unlock(&iommu->lock);
>> +		iommu->pgsize_bitmap &= domain->domain->pgsize_bitmap;
>>   
>>   	/*
>>   	 * In case the IOMMU supports page sizes smaller than PAGE_SIZE
> 
> (...)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks.

Kirti
