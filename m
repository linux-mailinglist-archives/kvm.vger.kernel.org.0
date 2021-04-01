Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A60351D02
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237791AbhDASXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:23:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239382AbhDASQT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:16:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617300979;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iYT4yJTC86HCuhZrmDLNovfzTFC4qveUrUuvrfHdzTQ=;
        b=DtkuOsCO9oNGi2TnzZxRx7VpPzZlwqqqs4XZJiijbzlbl1UTmm0FqIeL7vicBy2zE0F6DP
        wQipoEODt8z4RDWQbGwBsyzcI3GLNw3oAZ1Xf6sAglksj+ueZnC78xAzSWWgDuOzK761nr
        1HnUzLXlFT8CyaJs9CfafqGFnIwe9Zk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-wLIrvw3yMeqg6KUvwwbuZw-1; Thu, 01 Apr 2021 07:48:58 -0400
X-MC-Unique: wLIrvw3yMeqg6KUvwwbuZw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4BC36107ACCD;
        Thu,  1 Apr 2021 11:48:55 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B7DC19C46;
        Thu,  1 Apr 2021 11:48:46 +0000 (UTC)
Subject: Re: [PATCH v14 13/13] iommu/smmuv3: Accept configs with more than one
 context descriptor
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, will@kernel.org, maz@kernel.org,
        robin.murphy@arm.com, joro@8bytes.org, alex.williamson@redhat.com,
        tn@semihalf.com, zhukeqian1@huawei.com,
        jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jiangkunkun@huawei.com,
        jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, nicoleotsuka@gmail.com,
        lushenming@huawei.com, vsethi@nvidia.com,
        wanghaibin.wang@huawei.com
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-14-eric.auger@redhat.com>
 <86614466-3c74-3a38-5f2e-6ac2f55c309a@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <bf928484-b9da-a4bc-b761-e73483cb2323@redhat.com>
Date:   Thu, 1 Apr 2021 13:48:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <86614466-3c74-3a38-5f2e-6ac2f55c309a@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 3/30/21 11:23 AM, Zenghui Yu wrote:
> Hi Eric,
> 
> On 2021/2/24 4:56, Eric Auger wrote:
>> In preparation for vSVA, let's accept userspace provided configs
>> with more than one CD. We check the max CD against the host iommu
>> capability and also the format (linear versus 2 level).
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>> ---
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 13 ++++++++-----
>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 332d31c0680f..ab74a0289893 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -3038,14 +3038,17 @@ static int arm_smmu_attach_pasid_table(struct
>> iommu_domain *domain,
>>           if (smmu_domain->s1_cfg.set)
>>               goto out;
>>   -        /*
>> -         * we currently support a single CD so s1fmt and s1dss
>> -         * fields are also ignored
>> -         */
>> -        if (cfg->pasid_bits)
>> +        list_for_each_entry(master, &smmu_domain->devices,
>> domain_head) {
>> +            if (cfg->pasid_bits > master->ssid_bits)
>> +                goto out;
>> +        }
>> +        if (cfg->vendor_data.smmuv3.s1fmt ==
>> STRTAB_STE_0_S1FMT_64K_L2 &&
>> +                !(smmu->features & ARM_SMMU_FEAT_2_LVL_CDTAB))
>>               goto out;
>>             smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
>> +        smmu_domain->s1_cfg.s1cdmax = cfg->pasid_bits;
>> +        smmu_domain->s1_cfg.s1fmt = cfg->vendor_data.smmuv3.s1fmt;
> 
> And what about the SIDSS field?
> 
I added this patch upon Shameer's request, to be more vSVA friendly.
Hower this series does not really target multiple CD support. At the
moment the driver only supports STRTAB_STE_1_S1DSS_SSID0 (0x2) I think.
At this moment maybe I can only check the s1dss field is 0x2. Or simply
removes this patch?

Thoughts?

Eric

