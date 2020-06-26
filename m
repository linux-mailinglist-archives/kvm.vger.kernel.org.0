Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF8320B59A
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 18:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgFZQEn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 12:04:43 -0400
Received: from foss.arm.com ([217.140.110.172]:34518 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgFZQEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 12:04:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B11B91FB;
        Fri, 26 Jun 2020 09:04:41 -0700 (PDT)
Received: from [10.57.13.97] (unknown [10.57.13.97])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D98A03F6CF;
        Fri, 26 Jun 2020 09:04:36 -0700 (PDT)
Subject: Re: [PATCH v3 02/14] iommu: Report domain nesting info
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, eric.auger@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org, kevin.tian@intel.com,
        jacob.jun.pan@linux.intel.com, ashok.raj@intel.com,
        jun.j.tian@intel.com, yi.y.sun@intel.com, peterx@redhat.com,
        hao.wu@intel.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will@kernel.org>
References: <1592988927-48009-1-git-send-email-yi.l.liu@intel.com>
 <1592988927-48009-3-git-send-email-yi.l.liu@intel.com>
 <20200626074738.GA2107508@myrica>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <069bcf66-4db3-b4f1-2e09-a79d255d0850@arm.com>
Date:   Fri, 26 Jun 2020 17:04:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200626074738.GA2107508@myrica>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-06-26 08:47, Jean-Philippe Brucker wrote:
> On Wed, Jun 24, 2020 at 01:55:15AM -0700, Liu Yi L wrote:
>> IOMMUs that support nesting translation needs report the capability info
>> to userspace, e.g. the format of first level/stage paging structures.
>>
>> This patch reports nesting info by DOMAIN_ATTR_NESTING. Caller can get
>> nesting info after setting DOMAIN_ATTR_NESTING.
>>
>> v2 -> v3:
>> *) remvoe cap/ecap_mask in iommu_nesting_info.
>> *) reuse DOMAIN_ATTR_NESTING to get nesting info.
>> *) return an empty iommu_nesting_info for SMMU drivers per Jean'
>>     suggestion.
>>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Cc: Alex Williamson <alex.williamson@redhat.com>
>> Cc: Eric Auger <eric.auger@redhat.com>
>> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Cc: Joerg Roedel <joro@8bytes.org>
>> Cc: Lu Baolu <baolu.lu@linux.intel.com>
>> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> ---
>>   drivers/iommu/arm-smmu-v3.c | 29 ++++++++++++++++++++--
>>   drivers/iommu/arm-smmu.c    | 29 ++++++++++++++++++++--
> 
> Looks reasonable to me. Please move the SMMU changes to a separate patch
> and Cc the SMMU maintainers:

Cheers Jean, I'll admit I've been skipping over a lot of these patches 
lately :)

A couple of comments below...

> 
> Cc: Will Deacon <will@kernel.org>
> Cc: Robin Murphy <robin.murphy@arm.com>
> 
> Thanks,
> Jean
> 
>>   include/uapi/linux/iommu.h  | 59 +++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 113 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
>> index f578677..0c45d4d 100644
>> --- a/drivers/iommu/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm-smmu-v3.c
>> @@ -3019,6 +3019,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>>   	return group;
>>   }
>>   
>> +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
>> +					void *data)
>> +{
>> +	struct iommu_nesting_info *info = (struct iommu_nesting_info *) data;
>> +	u32 size;
>> +
>> +	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
>> +		return -ENODEV;
>> +
>> +	size = sizeof(struct iommu_nesting_info);
>> +
>> +	/*
>> +	 * if provided buffer size is not equal to the size, should
>> +	 * return 0 and also the expected buffer size to caller.
>> +	 */
>> +	if (info->size != size) {
>> +		info->size = size;
>> +		return 0;
>> +	}
>> +
>> +	/* report an empty iommu_nesting_info for now */
>> +	memset(info, 0x0, size);
>> +	info->size = size;
>> +	return 0;
>> +}
>> +
>>   static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>>   				    enum iommu_attr attr, void *data)
>>   {
>> @@ -3028,8 +3054,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>>   	case IOMMU_DOMAIN_UNMANAGED:
>>   		switch (attr) {
>>   		case DOMAIN_ATTR_NESTING:
>> -			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
>> -			return 0;
>> +			return arm_smmu_domain_nesting_info(smmu_domain, data);
>>   		default:
>>   			return -ENODEV;
>>   		}
>> diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
>> index 243bc4c..908607d 100644
>> --- a/drivers/iommu/arm-smmu.c
>> +++ b/drivers/iommu/arm-smmu.c
>> @@ -1506,6 +1506,32 @@ static struct iommu_group *arm_smmu_device_group(struct device *dev)
>>   	return group;
>>   }
>>   
>> +static int arm_smmu_domain_nesting_info(struct arm_smmu_domain *smmu_domain,
>> +					void *data)
>> +{
>> +	struct iommu_nesting_info *info = (struct iommu_nesting_info *) data;
>> +	u32 size;
>> +
>> +	if (!info || smmu_domain->stage != ARM_SMMU_DOMAIN_NESTED)
>> +		return -ENODEV;
>> +
>> +	size = sizeof(struct iommu_nesting_info);
>> +
>> +	/*
>> +	 * if provided buffer size is not equal to the size, should
>> +	 * return 0 and also the expected buffer size to caller.
>> +	 */
>> +	if (info->size != size) {
>> +		info->size = size;
>> +		return 0;
>> +	}
>> +
>> +	/* report an empty iommu_nesting_info for now */
>> +	memset(info, 0x0, size);
>> +	info->size = size;
>> +	return 0;
>> +}
>> +
>>   static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>>   				    enum iommu_attr attr, void *data)
>>   {
>> @@ -1515,8 +1541,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
>>   	case IOMMU_DOMAIN_UNMANAGED:
>>   		switch (attr) {
>>   		case DOMAIN_ATTR_NESTING:
>> -			*(int *)data = (smmu_domain->stage == ARM_SMMU_DOMAIN_NESTED);
>> -			return 0;
>> +			return arm_smmu_domain_nesting_info(smmu_domain, data);
>>   		default:
>>   			return -ENODEV;
>>   		}
>> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
>> index 1afc661..898c99a 100644
>> --- a/include/uapi/linux/iommu.h
>> +++ b/include/uapi/linux/iommu.h
>> @@ -332,4 +332,63 @@ struct iommu_gpasid_bind_data {
>>   	} vendor;
>>   };
>>   
>> +/*
>> + * struct iommu_nesting_info - Information for nesting-capable IOMMU.
>> + *				user space should check it before using
>> + *				nesting capability.
>> + *
>> + * @size:	size of the whole structure
>> + * @format:	PASID table entry format, the same definition with
>> + *		@format of struct iommu_gpasid_bind_data.
>> + * @features:	supported nesting features.
>> + * @flags:	currently reserved for future extension.
>> + * @data:	vendor specific cap info.
>> + *
>> + * +---------------+----------------------------------------------------+
>> + * | feature       |  Notes                                             |
>> + * +===============+====================================================+
>> + * | SYSWIDE_PASID |  Kernel manages PASID in system wide, PASIDs used  |
>> + * |               |  in the system should be allocated by host kernel  |
>> + * +---------------+----------------------------------------------------+
>> + * | BIND_PGTBL    |  bind page tables to host PASID, the PASID could   |
>> + * |               |  either be a host PASID passed in bind request or  |
>> + * |               |  default PASIDs (e.g. default PASID of aux-domain) |
>> + * +---------------+----------------------------------------------------+
>> + * | CACHE_INVLD   |  mandatory feature for nesting capable IOMMU       |
>> + * +---------------+----------------------------------------------------+
>> + *
>> + */
>> +struct iommu_nesting_info {
>> +	__u32	size;
>> +	__u32	format;
>> +	__u32	features;
>> +#define IOMMU_NESTING_FEAT_SYSWIDE_PASID	(1 << 0)
>> +#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 1)
>> +#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 2)
>> +	__u32	flags;
>> +	__u8	data[];
>> +};
>> +
>> +/*
>> + * struct iommu_nesting_info_vtd - Intel VT-d specific nesting info
>> + *
>> + *
>> + * @flags:	VT-d specific flags. Currently reserved for future
>> + *		extension.
>> + * @addr_width:	The output addr width of first level/stage translation
>> + * @pasid_bits:	Maximum supported PASID bits, 0 represents no PASID
>> + *		support.
>> + * @cap_reg:	Describe basic capabilities as defined in VT-d capability
>> + *		register.
>> + * @ecap_reg:	Describe the extended capabilities as defined in VT-d
>> + *		extended capability register.
>> + */
>> +struct iommu_nesting_info_vtd {
>> +	__u32	flags;
>> +	__u16	addr_width;

I think this might be worth promoting to a generic feature - Arm has the 
same notion of intermediate address size, and I'd imagine that pretty 
much any other two-stage translation system would as well (either 
explicitly or implicitly). It also comes close to something the DPDK 
folks raised where they wanted parity with a feature that currently 
scrapes AGAW out of some VT-d-specific place, so abstracting it to 
completely generic code, in a way that could eventually be generalised 
to reporting info for non-nested domains too, would be really nice.

What would also be cool is if the user was able to pass in a structure 
with preferred values for the address size and other capabilities when 
they request nesting in the first place. Right now we'll always set up 
the maximum possible sized page table for any domain, but if we knew 
ahead of time how many bits the user actually cared about then we could 
potentially be more efficient (e.g. use fewer levels of pagetable or a 
different translation granule).

Robin.

>> +	__u16	pasid_bits;
>> +	__u64	cap_reg;
>> +	__u64	ecap_reg;
>> +};
>> +
>>   #endif /* _UAPI_IOMMU_H */
>> -- 
>> 2.7.4
>>
