Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D622191A10
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 20:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgCXTfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 15:35:04 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11779 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727969AbgCXTfD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 15:35:03 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5e7a608c0000>; Tue, 24 Mar 2020 12:33:32 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 24 Mar 2020 12:35:03 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 24 Mar 2020 12:35:03 -0700
Received: from [10.40.103.72] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Mar
 2020 19:34:54 +0000
Subject: Re: [PATCH v15 Kernel 2/7] vfio iommu: Remove atomicity of ref_count
 of pinned pages
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
 <1584649004-8285-3-git-send-email-kwankhede@nvidia.com>
 <b2e791ee-e55a-3142-119c-c2f4300fabd5@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <ae258072-89db-8c88-ad6a-8084781a0205@nvidia.com>
Date:   Wed, 25 Mar 2020 01:04:50 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <b2e791ee-e55a-3142-119c-c2f4300fabd5@redhat.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1585078412; bh=40wVc0Yor8YTosJnEQ2TGgBM6wIvNiRWDsFVZ7Q/Fjg=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=gbO5PwjkX/gKB+EUSCsbtRqYcPexTnIjStcBsnRgvqlKBBhAReRViuGL9KGrip2k0
         alwsjRbBM3RM08beJomQv/L1sQqapeflSlKBP2U+VkH9scY8iV7pdV6urcQ4Go+bww
         MW62nZnfwjKBCykW750YUNfwjjAl3bVvAQvxYERWtHJhJzidFA2u49f4x/DRHET9sx
         Cb6MFYQRuZA+XurNLS8nB5k5kbhTNXqsADBAQ4nHW8jRIm24QmAKjYKmD7VUJsYDtb
         vdd5yOFWZSRBADJA/J85Z9VxOpuJ/6GHI4uaOEzp6BBGykCT7ekkE0uXNqYw3AsezB
         WmNRW9IEqjy8w==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/24/2020 2:00 AM, Auger Eric wrote:
> Hi Kirti,
> 
> On 3/19/20 9:16 PM, Kirti Wankhede wrote:
>> vfio_pfn.ref_count is always updated by holding iommu->lock, using atomic
>> variable is overkill.
>>
>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> 

Thanks.

Kirti.

> Thanks
> 
> Eric
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 9fdfae1cb17a..70aeab921d0f 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -112,7 +112,7 @@ struct vfio_pfn {
>>   	struct rb_node		node;
>>   	dma_addr_t		iova;		/* Device address */
>>   	unsigned long		pfn;		/* Host pfn */
>> -	atomic_t		ref_count;
>> +	unsigned int		ref_count;
>>   };
>>   
>>   struct vfio_regions {
>> @@ -233,7 +233,7 @@ static int vfio_add_to_pfn_list(struct vfio_dma *dma, dma_addr_t iova,
>>   
>>   	vpfn->iova = iova;
>>   	vpfn->pfn = pfn;
>> -	atomic_set(&vpfn->ref_count, 1);
>> +	vpfn->ref_count = 1;
>>   	vfio_link_pfn(dma, vpfn);
>>   	return 0;
>>   }
>> @@ -251,7 +251,7 @@ static struct vfio_pfn *vfio_iova_get_vfio_pfn(struct vfio_dma *dma,
>>   	struct vfio_pfn *vpfn = vfio_find_vpfn(dma, iova);
>>   
>>   	if (vpfn)
>> -		atomic_inc(&vpfn->ref_count);
>> +		vpfn->ref_count++;
>>   	return vpfn;
>>   }
>>   
>> @@ -259,7 +259,8 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
>>   {
>>   	int ret = 0;
>>   
>> -	if (atomic_dec_and_test(&vpfn->ref_count)) {
>> +	vpfn->ref_count--;
>> +	if (!vpfn->ref_count) {
>>   		ret = put_pfn(vpfn->pfn, dma->prot);
>>   		vfio_remove_from_pfn_list(dma, vpfn);
>>   	}
>>
> 
