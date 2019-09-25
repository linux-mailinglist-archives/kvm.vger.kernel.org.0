Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0756BBD8C0
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 09:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442468AbfIYHIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 03:08:45 -0400
Received: from mga07.intel.com ([134.134.136.100]:15199 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2442450AbfIYHIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 03:08:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Sep 2019 00:08:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,547,1559545200"; 
   d="scan'208";a="201158456"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 25 Sep 2019 00:08:40 -0700
Cc:     baolu.lu@linux.intel.com, "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC PATCH 3/4] iommu/vt-d: Map/unmap domain with mmmap/mmunmap
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-4-baolu.lu@linux.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58F0B7@SHSMSX104.ccr.corp.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <71b812c0-722c-8d8a-0c3f-58efab34f6b2@linux.intel.com>
Date:   Wed, 25 Sep 2019 15:06:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F0B7@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 9/25/19 1:00 PM, Tian, Kevin wrote:
>> From: Lu Baolu [mailto:baolu.lu@linux.intel.com]
>> Sent: Monday, September 23, 2019 8:25 PM
>>
>> If a dmar domain has DOMAIN_FLAG_FIRST_LEVEL_TRANS bit set
>> in its flags, IOMMU will use the first level page table for
>> translation. Hence, we need to map or unmap addresses in the
>> first level page table.
>>
>> Cc: Ashok Raj <ashok.raj@intel.com>
>> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
>> Cc: Kevin Tian <kevin.tian@intel.com>
>> Cc: Liu Yi L <yi.l.liu@intel.com>
>> Cc: Yi Sun <yi.y.sun@linux.intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/intel-iommu.c | 94 ++++++++++++++++++++++++++++++++-
>> ----
>>   1 file changed, 82 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
>> index 9cfe8098d993..103480016010 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -168,6 +168,11 @@ static inline unsigned long virt_to_dma_pfn(void
>> *p)
>>   	return page_to_dma_pfn(virt_to_page(p));
>>   }
>>
>> +static inline unsigned long dma_pfn_to_addr(unsigned long pfn)
>> +{
>> +	return pfn << VTD_PAGE_SHIFT;
>> +}
>> +
>>   /* global iommu list, set NULL for ignored DMAR units */
>>   static struct intel_iommu **g_iommus;
>>
>> @@ -307,6 +312,9 @@ static int hw_pass_through = 1;
>>    */
>>   #define DOMAIN_FLAG_LOSE_CHILDREN		BIT(1)
>>
>> +/* Domain uses first level translation for DMA remapping. */
>> +#define DOMAIN_FLAG_FIRST_LEVEL_TRANS		BIT(2)
>> +
>>   #define for_each_domain_iommu(idx, domain)			\
>>   	for (idx = 0; idx < g_num_of_iommus; idx++)		\
>>   		if (domain->iommu_refcnt[idx])
>> @@ -552,6 +560,11 @@ static inline int domain_type_is_si(struct
>> dmar_domain *domain)
>>   	return domain->flags & DOMAIN_FLAG_STATIC_IDENTITY;
>>   }
>>
>> +static inline int domain_type_is_flt(struct dmar_domain *domain)
>> +{
>> +	return domain->flags & DOMAIN_FLAG_FIRST_LEVEL_TRANS;
>> +}
>> +
>>   static inline int domain_pfn_supported(struct dmar_domain *domain,
>>   				       unsigned long pfn)
>>   {
>> @@ -1147,8 +1160,15 @@ static struct page *domain_unmap(struct
>> dmar_domain *domain,
>>   	BUG_ON(start_pfn > last_pfn);
>>
>>   	/* we don't need lock here; nobody else touches the iova range */
>> -	freelist = dma_pte_clear_level(domain, agaw_to_level(domain-
>>> agaw),
>> -				       domain->pgd, 0, start_pfn, last_pfn,
>> NULL);
>> +	if (domain_type_is_flt(domain))
>> +		freelist = intel_mmunmap_range(domain,
>> +					       dma_pfn_to_addr(start_pfn),
>> +					       dma_pfn_to_addr(last_pfn + 1));
>> +	else
>> +		freelist = dma_pte_clear_level(domain,
>> +					       agaw_to_level(domain->agaw),
>> +					       domain->pgd, 0, start_pfn,
>> +					       last_pfn, NULL);
> 
> what about providing an unified interface at the caller side, then having
> the level differentiated within the interface?

Good point! I ever thought about adding some ops in struct dmar_domain,
something like:

diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index ed11ef594378..1dd184f76bfb 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -489,7 +489,14 @@ struct dmar_domain {
         struct list_head auxd;          /* link to device's auxiliary 
list */
         struct iova_domain iovad;       /* iova's that belong to this 
domain */

+       /* per domain page table and manipulation ops */
         struct dma_pte  *pgd;           /* virtual address */
+       int (*map)(struct dmar_domain *domain,
+                  unsigned long addr, unsigned long end,
+                  phys_addr_t phys_addr, int dma_prot);
+       struct page *(*unmap)(struct dmar_domain *domain,
+                             unsigned long addr, unsigned long end);
+
         int             gaw;            /* max guest address width */

         /* adjusted guest address width, 0 is level 2 30-bit */

So that this code could be simply like this:

	freelist = domain->unmap(...);

Best regards,
Baolu
