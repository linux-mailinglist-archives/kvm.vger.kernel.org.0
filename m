Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1C42F6F34
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 01:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbhANX7r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 18:59:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:35389 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731069AbhANX7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 18:59:47 -0500
IronPort-SDR: 7CE5V6nFMHdAiEzLlJ6xkGWDtXqqwEhA/qAL5HNUEzG2IzsNkYYMbBjtXVENOnL32XUqBCBo0q
 H9erDq/z0IWA==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="174958757"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="174958757"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 15:58:01 -0800
IronPort-SDR: JgwNpI72iKplEgLvvRFozPpdeFZ7FrlSQzR4sXrAWlVyCIIfcrp4T/FvOv4QU4UmX2WutfAakz
 6Ngk+uiv0xsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="465409009"
Received: from allen-box.sh.intel.com (HELO [10.239.159.28]) ([10.239.159.28])
  by fmsmga001.fm.intel.com with ESMTP; 14 Jan 2021 15:57:53 -0800
Cc:     baolu.lu@linux.intel.com, tglx@linutronix.de, ashok.raj@intel.com,
        kevin.tian@intel.com, dave.jiang@intel.com, megha.dey@intel.com,
        dwmw2@infradead.org, alex.williamson@redhat.com,
        bhelgaas@google.com, dan.j.williams@intel.com, will@kernel.org,
        joro@8bytes.org, dmaengine@vger.kernel.org, eric.auger@redhat.com,
        jacob.jun.pan@intel.com, jgg@mellanox.com, kvm@vger.kernel.org,
        kwankhede@nvidia.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        maz@kernel.org, mona.hossain@intel.com, netanelg@mellanox.com,
        parav@mellanox.com, pbonzini@redhat.com, rafael@kernel.org,
        samuel.ortiz@intel.com, sanjay.k.kumar@intel.com,
        shahafs@mellanox.com, tony.luck@intel.com, vkoul@kernel.org,
        yan.y.zhao@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [RFC PATCH v3 1/2] iommu: Add capability IOMMU_CAP_VIOMMU
To:     Leon Romanovsky <leon@kernel.org>
References: <20210114013003.297050-1-baolu.lu@linux.intel.com>
 <20210114013003.297050-2-baolu.lu@linux.intel.com>
 <20210114132627.GA944463@unreal>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <b0c8b260-8e23-a5bd-d2da-ca1d67cdfa8a@linux.intel.com>
Date:   Fri, 15 Jan 2021 07:49:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210114132627.GA944463@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Leon,

On 1/14/21 9:26 PM, Leon Romanovsky wrote:
> On Thu, Jan 14, 2021 at 09:30:02AM +0800, Lu Baolu wrote:
>> Some vendor IOMMU drivers are able to declare that it is running in a VM
>> context. This is very valuable for the features that only want to be
>> supported on bare metal. Add a capability bit so that it could be used.
> 
> And how is it used? Who and how will set it?

Use the existing iommu_capable(). I should add more descriptions about
who and how to use it.

> 
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/intel/iommu.c  | 20 ++++++++++++++++++++
>>   drivers/iommu/virtio-iommu.c |  9 +++++++++
>>   include/linux/iommu.h        |  1 +
>>   3 files changed, 30 insertions(+)
>>
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index cb205a04fe4c..8eb022d0e8aa 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -5738,12 +5738,32 @@ static inline bool nested_mode_support(void)
>>   	return ret;
>>   }
>>
>> +static inline bool caching_mode_enabled(void)
>> +{
> 
> Kernel coding style is not in favour of inline functions in *.c files.

Yes, agreed.

Best regards,
baolu

> 
>> +	struct dmar_drhd_unit *drhd;
>> +	struct intel_iommu *iommu;
>> +	bool ret = false;
>> +
>> +	rcu_read_lock();
>> +	for_each_active_iommu(iommu, drhd) {
>> +		if (cap_caching_mode(iommu->cap)) {
>> +			ret = true;
>> +			break;
>> +		}
>> +	}
>> +	rcu_read_unlock();
>> +
>> +	return ret;
>> +}
>> +
>>   static bool intel_iommu_capable(enum iommu_cap cap)
>>   {
>>   	if (cap == IOMMU_CAP_CACHE_COHERENCY)
>>   		return domain_update_iommu_snooping(NULL) == 1;
>>   	if (cap == IOMMU_CAP_INTR_REMAP)
>>   		return irq_remapping_enabled == 1;
>> +	if (cap == IOMMU_CAP_VIOMMU)
>> +		return caching_mode_enabled();
>>
>>   	return false;
>>   }
>> diff --git a/drivers/iommu/virtio-iommu.c b/drivers/iommu/virtio-iommu.c
>> index 2bfdd5734844..719793e103db 100644
>> --- a/drivers/iommu/virtio-iommu.c
>> +++ b/drivers/iommu/virtio-iommu.c
>> @@ -931,7 +931,16 @@ static int viommu_of_xlate(struct device *dev, struct of_phandle_args *args)
>>   	return iommu_fwspec_add_ids(dev, args->args, 1);
>>   }
>>
>> +static bool viommu_capable(enum iommu_cap cap)
>> +{
>> +	if (cap == IOMMU_CAP_VIOMMU)
>> +		return true;
>> +
>> +	return false;
>> +}
>> +
>>   static struct iommu_ops viommu_ops = {
>> +	.capable		= viommu_capable,
>>   	.domain_alloc		= viommu_domain_alloc,
>>   	.domain_free		= viommu_domain_free,
>>   	.attach_dev		= viommu_attach_dev,
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index b95a6f8db6ff..1d24be667a03 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -94,6 +94,7 @@ enum iommu_cap {
>>   					   transactions */
>>   	IOMMU_CAP_INTR_REMAP,		/* IOMMU supports interrupt isolation */
>>   	IOMMU_CAP_NOEXEC,		/* IOMMU_NOEXEC flag */
>> +	IOMMU_CAP_VIOMMU,		/* IOMMU can declar running in a VM */
>>   };
>>
>>   /*
>> --
>> 2.25.1
>>
