Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A23341DF3
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 14:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhCSNQk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 09:16:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29250 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229862AbhCSNQU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 09:16:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616159765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zB9UEU6BuHfafy+D8H0sW7LkYxmyna8jjh3ThNLf5Jc=;
        b=g6BOl+gRoN5LeJfvvp/WbWoO4KL+lz+dHgFdLljfYif4GYtp4JYFT1K0DsxMljZnHKU0L4
        cMR5PvuM/F0MN2P8UdBgZj0SDiTJjvyT5R3piEQxsvE4188ngHxZAY0oRxb0/Fud0L2k4B
        hdcNRjI//II3hce0gofabcg06G9RF9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-t0J6TXHyOP2fdb4TiXXgXg-1; Fri, 19 Mar 2021 09:16:03 -0400
X-MC-Unique: t0J6TXHyOP2fdb4TiXXgXg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9F76800D53;
        Fri, 19 Mar 2021 13:15:58 +0000 (UTC)
Received: from [10.36.113.141] (ovpn-113-141.ams2.redhat.com [10.36.113.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D57396085A;
        Fri, 19 Mar 2021 13:15:49 +0000 (UTC)
Subject: Re: [PATCH v14 05/13] iommu/smmuv3: Implement
 attach/detach_pasid_table
To:     Keqian Zhu <zhukeqian1@huawei.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will@kernel.org,
        maz@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
        alex.williamson@redhat.com, tn@semihalf.com
Cc:     jacob.jun.pan@linux.intel.com, yi.l.liu@intel.com,
        wangxingang5@huawei.com, jiangkunkun@huawei.com,
        jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, yuzenghui@huawei.com,
        nicoleotsuka@gmail.com, lushenming@huawei.com, vsethi@nvidia.com
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-6-eric.auger@redhat.com>
 <5a22a597-0fba-edcc-bcf0-50d92346af08@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <31290c71-25d9-2b49-fb4d-7250ed9f70e7@redhat.com>
Date:   Fri, 19 Mar 2021 14:15:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <5a22a597-0fba-edcc-bcf0-50d92346af08@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Keqian,

On 3/2/21 9:35 AM, Keqian Zhu wrote:
> Hi Eric,
> 
> On 2021/2/24 4:56, Eric Auger wrote:
>> On attach_pasid_table() we program STE S1 related info set
>> by the guest into the actual physical STEs. At minimum
>> we need to program the context descriptor GPA and compute
>> whether the stage1 is translated/bypassed or aborted.
>>
>> On detach, the stage 1 config is unset and the abort flag is
>> unset.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
> [...]
> 
>> +
>> +		/*
>> +		 * we currently support a single CD so s1fmt and s1dss
>> +		 * fields are also ignored
>> +		 */
>> +		if (cfg->pasid_bits)
>> +			goto out;
>> +
>> +		smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
> only the "cdtab_dma" field of "cdcfg" is set, we are not able to locate a specific cd using arm_smmu_get_cd_ptr().
> 
> Maybe we'd better use a specialized function to fill other fields of "cdcfg" or add a sanity check in arm_smmu_get_cd_ptr()
> to prevent calling it under nested mode?
> 
> As now we just call arm_smmu_get_cd_ptr() during finalise_s1(), no problem found. Just a suggestion ;-)

forgive me for the delay. yes I can indeed make sure that code is not
called in nested mode. Please could you detail why you would need to
call arm_smmu_get_cd_ptr()?

Thanks

Eric
> 
> Thanks,
> Keqian
> 
> 
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
>> +static void arm_smmu_detach_pasid_table(struct iommu_domain *domain)
>> +{
>> +	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
>> +	struct arm_smmu_master *master;
>> +	unsigned long flags;
>> +
>> +	mutex_lock(&smmu_domain->init_mutex);
>> +
>> +	if (smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
>> +		goto unlock;
>> +
>> +	smmu_domain->s1_cfg.set = false;
>> +	smmu_domain->abort = false;
>> +
>> +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
>> +	list_for_each_entry(master, &smmu_domain->devices, domain_head)
>> +		arm_smmu_install_ste_for_dev(master);
>> +	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
>> +
>> +unlock:
>> +	mutex_unlock(&smmu_domain->init_mutex);
>> +}
>> +
>>  static bool arm_smmu_dev_has_feature(struct device *dev,
>>  				     enum iommu_dev_features feat)
>>  {
>> @@ -2939,6 +3026,8 @@ static struct iommu_ops arm_smmu_ops = {
>>  	.of_xlate		= arm_smmu_of_xlate,
>>  	.get_resv_regions	= arm_smmu_get_resv_regions,
>>  	.put_resv_regions	= generic_iommu_put_resv_regions,
>> +	.attach_pasid_table	= arm_smmu_attach_pasid_table,
>> +	.detach_pasid_table	= arm_smmu_detach_pasid_table,
>>  	.dev_has_feat		= arm_smmu_dev_has_feature,
>>  	.dev_feat_enabled	= arm_smmu_dev_feature_enabled,
>>  	.dev_enable_feat	= arm_smmu_dev_enable_feature,
>>
> 

