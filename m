Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E88319140
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 18:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhBKRj2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 12:39:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40665 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232426AbhBKRhK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Feb 2021 12:37:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613064938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ovn4XLZrYHU/jHtxdQ18Zp83BU5l3A71xzjYtmAEsIM=;
        b=QlVNQ1zbudj41TTLdw1mN9a68JpT94/tRDCO1g3rQTTYAW9pKV6rKW6lqGI6gGUtJnyY+3
        T1OOie/HgrBqY+HmJdC1YuAYmzDNDirB9WNz5KkN+5qnrjdDLiOatSNVKWYuWOgVWRoxwR
        kiDD56P0Vu2+Hfcj52SjaxYpLM2IFi8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-Vcg4Znx-N2muzaI-yOl0lQ-1; Thu, 11 Feb 2021 12:35:34 -0500
X-MC-Unique: Vcg4Znx-N2muzaI-yOl0lQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04833100A8EA;
        Thu, 11 Feb 2021 17:35:32 +0000 (UTC)
Received: from [10.36.114.34] (ovpn-114-34.ams2.redhat.com [10.36.114.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CFEA45D9D2;
        Thu, 11 Feb 2021 17:35:24 +0000 (UTC)
Subject: Re: [PATCH v13 06/15] iommu/smmuv3: Implement
 attach/detach_pasid_table
To:     Keqian Zhu <zhukeqian1@huawei.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        joro@8bytes.org, maz@kernel.org, robin.murphy@arm.com,
        alex.williamson@redhat.com
Cc:     jean-philippe@linaro.org, jacob.jun.pan@linux.intel.com,
        nicoleotsuka@gmail.com, vivek.gautam@arm.com, yi.l.liu@intel.com,
        zhangfei.gao@linaro.org
References: <20201118112151.25412-1-eric.auger@redhat.com>
 <20201118112151.25412-7-eric.auger@redhat.com>
 <4c3dded7-8b60-a303-3bdf-fa610f0e1a73@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <da89ce83-f27f-3b81-9d06-085eb9c4c046@redhat.com>
Date:   Thu, 11 Feb 2021 18:35:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <4c3dded7-8b60-a303-3bdf-fa610f0e1a73@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Keqian,

On 2/2/21 9:03 AM, Keqian Zhu wrote:
> Hi Eric,
> 
> On 2020/11/18 19:21, Eric Auger wrote:
>> On attach_pasid_table() we program STE S1 related info set
>> by the guest into the actual physical STEs. At minimum
>> we need to program the context descriptor GPA and compute
>> whether the stage1 is translated/bypassed or aborted.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>> v7 -> v8:
>> - remove smmu->features check, now done on domain finalize
>>
>> v6 -> v7:
>> - check versions and comment the fact we don't need to take
>>   into account s1dss and s1fmt
>> v3 -> v4:
>> - adapt to changes in iommu_pasid_table_config
>> - different programming convention at s1_cfg/s2_cfg/ste.abort
>>
>> v2 -> v3:
>> - callback now is named set_pasid_table and struct fields
>>   are laid out differently.
>>
>> v1 -> v2:
>> - invalidate the STE before changing them
>> - hold init_mutex
>> - handle new fields
>> ---
>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 89 +++++++++++++++++++++
>>  1 file changed, 89 insertions(+)
>>
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 412ea1bafa50..805acdc18a3a 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -2661,6 +2661,93 @@ static void arm_smmu_get_resv_regions(struct device *dev,
>>  	iommu_dma_get_resv_regions(dev, head);
>>  }
>>  
>> +static int arm_smmu_attach_pasid_table(struct iommu_domain *domain,
>> +				       struct iommu_pasid_table_config *cfg)
>> +{
>> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>> +	struct arm_smmu_master *master;
>> +	struct arm_smmu_device *smmu;
>> +	unsigned long flags;
>> +	int ret = -EINVAL;
>> +
>> +	if (cfg->format != IOMMU_PASID_FORMAT_SMMUV3)
>> +		return -EINVAL;
>> +
>> +	if (cfg->version != PASID_TABLE_CFG_VERSION_1 ||
>> +	    cfg->vendor_data.smmuv3.version != PASID_TABLE_SMMUV3_CFG_VERSION_1)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&smmu_domain->init_mutex);
>> +
>> +	smmu = smmu_domain->smmu;
>> +
>> +	if (!smmu)
>> +		goto out;
>> +
>> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
>> +		goto out;
>> +
>> +	switch (cfg->config) {
>> +	case IOMMU_PASID_CONFIG_ABORT:
>> +		smmu_domain->s1_cfg.set = false;
>> +		smmu_domain->abort = true;
>> +		break;
>> +	case IOMMU_PASID_CONFIG_BYPASS:
>> +		smmu_domain->s1_cfg.set = false;
>> +		smmu_domain->abort = false;
> I didn't test it, but it seems that this will cause BUG() in arm_smmu_write_strtab_ent().
> At the line "BUG_ON(ste_live && !nested);". Maybe I miss something?

No you are fully correct. Shammeer hit the BUG_ON() when booting the
guest with iommu.passthrough = 1. So I removed the BUG_ON(). The legacy
BUG_ON(ste_live) still is there under the form of BUG_ON(s1_live).

Thanks!

Eric


> 
>> +		break;
>> +	case IOMMU_PASID_CONFIG_TRANSLATE:
>> +		/* we do not support S1 <-> S1 transitions */
>> +		if (smmu_domain->s1_cfg.set)
>> +			goto out;
>> +
>> +		/*
>> +		 * we currently support a single CD so s1fmt and s1dss
>> +		 * fields are also ignored
>> +		 */
>> +		if (cfg->pasid_bits)
>> +			goto out;
>> +
>> +		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
>> +		smmu_domain->s1_cfg.set = true;
>> +		smmu_domain->abort = false;
>> +		break;
>> +	default:
>> +		goto out;
>> +	}
>> +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>> +	list_for_each_entry(master, &smmu_domain->devices, domain_head)
>> +		arm_smmu_install_ste_for_dev(master);
>> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>> +	ret = 0;
>> +out:
>> +	mutex_unlock(&smmu_domain->init_mutex);
>> +	return ret;
>> +}
>> +
> [...]
> 
> Thanks,
> Keqian
> 

