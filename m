Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B055B11F01A
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 04:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfLNDZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 22:25:04 -0500
Received: from mga05.intel.com ([192.55.52.43]:21940 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbfLNDZD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 22:25:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 19:25:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,312,1571727600"; 
   d="scan'208";a="226478760"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 13 Dec 2019 19:24:59 -0800
Cc:     baolu.lu@linux.intel.com, "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] iommu/vt-d: Flush PASID-based iotlb for iova over
 first level
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20191211021219.8997-1-baolu.lu@linux.intel.com>
 <20191211021219.8997-6-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A130C08@SHSMSX104.ccr.corp.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <f1e5cfea-8b11-6d72-8e57-65daea51c050@linux.intel.com>
Date:   Sat, 14 Dec 2019 11:24:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A130C08@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Liu Yi,

On 12/13/19 7:42 PM, Liu, Yi L wrote:
>> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf
>> Of Lu Baolu
>> Sent: Wednesday, December 11, 2019 10:12 AM
>> To: Joerg Roedel <joro@8bytes.org>; David Woodhouse <dwmw2@infradead.org>;
>> Subject: [PATCH v3 5/6] iommu/vt-d: Flush PASID-based iotlb for iova over first level
>>
>> When software has changed first-level tables, it should invalidate
>> the affected IOTLB and the paging-structure-caches using the PASID-
>> based-IOTLB Invalidate Descriptor defined in spec 6.5.2.4.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/dmar.c        | 41 ++++++++++++++++++++++++++++++++++
>>   drivers/iommu/intel-iommu.c | 44 ++++++++++++++++++++++++-------------
>>   include/linux/intel-iommu.h |  2 ++
>>   3 files changed, 72 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
>> index 3acfa6a25fa2..fb30d5053664 100644
>> --- a/drivers/iommu/dmar.c
>> +++ b/drivers/iommu/dmar.c
>> @@ -1371,6 +1371,47 @@ void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16
>> sid, u16 pfsid,
>>   	qi_submit_sync(&desc, iommu);
>>   }
>>
>> +/* PASID-based IOTLB invalidation */
>> +void qi_flush_piotlb(struct intel_iommu *iommu, u16 did, u32 pasid, u64 addr,
>> +		     unsigned long npages, bool ih)
>> +{
>> +	struct qi_desc desc = {.qw2 = 0, .qw3 = 0};
>> +
>> +	/*
>> +	 * npages == -1 means a PASID-selective invalidation, otherwise,
>> +	 * a positive value for Page-selective-within-PASID invalidation.
>> +	 * 0 is not a valid input.
>> +	 */
>> +	if (WARN_ON(!npages)) {
>> +		pr_err("Invalid input npages = %ld\n", npages);
>> +		return;
>> +	}
>> +
>> +	if (npages == -1) {
>> +		desc.qw0 = QI_EIOTLB_PASID(pasid) |
>> +				QI_EIOTLB_DID(did) |
>> +				QI_EIOTLB_GRAN(QI_GRAN_NONG_PASID) |
>> +				QI_EIOTLB_TYPE;
>> +		desc.qw1 = 0;
>> +	} else {
>> +		int mask = ilog2(__roundup_pow_of_two(npages));
>> +		unsigned long align = (1ULL << (VTD_PAGE_SHIFT + mask));
>> +
>> +		if (WARN_ON_ONCE(!ALIGN(addr, align)))
>> +			addr &= ~(align - 1);
>> +
>> +		desc.qw0 = QI_EIOTLB_PASID(pasid) |
>> +				QI_EIOTLB_DID(did) |
>> +				QI_EIOTLB_GRAN(QI_GRAN_PSI_PASID) |
>> +				QI_EIOTLB_TYPE;
>> +		desc.qw1 = QI_EIOTLB_ADDR(addr) |
>> +				QI_EIOTLB_IH(ih) |
>> +				QI_EIOTLB_AM(mask);
>> +	}
>> +
>> +	qi_submit_sync(&desc, iommu);
>> +}
>> +
>>   /*
>>    * Disable Queued Invalidation interface.
>>    */
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index 83a7abf0c4f0..e47f5fe37b59 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -1520,18 +1520,24 @@ static void iommu_flush_iotlb_psi(struct intel_iommu
>> *iommu,
>>
>>   	if (ih)
>>   		ih = 1 << 6;
>> -	/*
>> -	 * Fallback to domain selective flush if no PSI support or the size is
>> -	 * too big.
>> -	 * PSI requires page size to be 2 ^ x, and the base address is naturally
>> -	 * aligned to the size
>> -	 */
>> -	if (!cap_pgsel_inv(iommu->cap) || mask > cap_max_amask_val(iommu-
>>> cap))
>> -		iommu->flush.flush_iotlb(iommu, did, 0, 0,
>> -						DMA_TLB_DSI_FLUSH);
>> -	else
>> -		iommu->flush.flush_iotlb(iommu, did, addr | ih, mask,
>> -						DMA_TLB_PSI_FLUSH);
>> +
>> +	if (domain_use_first_level(domain)) {
>> +		qi_flush_piotlb(iommu, did, domain->default_pasid,
>> +				addr, pages, ih);
> 
> I'm not sure if my understanding is correct. But let me tell a story.
> Assuming we assign a mdev and a PF/VF to a single VM, then there
> will be p_iotlb tagged with PASID_RID2PASID and p_iotlb tagged with
> default_pasid. We may want to flush both... If this operation is

I assume that SRIOV and SIOV are exclusive. You can't enable both SRIOV
and SIOV on a single device. So the mdev and PF/VF are from different
devices, right?

Or, in SRIOV case, you can wrap a PF or VF as a mediated device. But
this mdev still be backed with a pasid of RID2PASID.

> invoked per-device, then need to pass in a hint to indicate whether
> to use PASID_RID2PASID or default_pasid, or you may just issue two
> flush with the two PASID values. Thoughts?

This is per-domain and each domain has specific domain id and default
pasid (assume default domain is 0 in RID2PASID case).

Best regards,
baolu
