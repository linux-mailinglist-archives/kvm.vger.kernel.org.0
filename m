Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0494211F015
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2019 04:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLNDEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 22:04:42 -0500
Received: from mga12.intel.com ([192.55.52.136]:59120 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfLNDEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 22:04:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 19:04:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,312,1571727600"; 
   d="scan'208";a="226476032"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 13 Dec 2019 19:04:38 -0800
Cc:     baolu.lu@linux.intel.com, "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 4/6] iommu/vt-d: Setup pasid entries for iova over
 first level
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20191211021219.8997-1-baolu.lu@linux.intel.com>
 <20191211021219.8997-5-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A1309A9@SHSMSX104.ccr.corp.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <acb93807-7a78-b81a-3b27-fde9ee4d7edb@linux.intel.com>
Date:   Sat, 14 Dec 2019 11:03:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1309A9@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Liu Yi,

Thanks for reviewing my patch.

On 12/13/19 5:23 PM, Liu, Yi L wrote:
>> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On Behalf
>> Of Lu Baolu
>> Sent: Wednesday, December 11, 2019 10:12 AM
>> Subject: [PATCH v3 4/6] iommu/vt-d: Setup pasid entries for iova over first level
>>
>> Intel VT-d in scalable mode supports two types of page tables for IOVA translation:
>> first level and second level. The IOMMU driver can choose one from both for IOVA
>> translation according to the use case. This sets up the pasid entry if a domain is
>> selected to use the first-level page table for iova translation.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/intel-iommu.c | 48 +++++++++++++++++++++++++++++++++++--
>>   include/linux/intel-iommu.h | 10 ++++----
>>   2 files changed, 52 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c index
>> 2b5a47584baf..83a7abf0c4f0 100644
>> --- a/drivers/iommu/intel-iommu.c
>> +++ b/drivers/iommu/intel-iommu.c
>> @@ -571,6 +571,11 @@ static inline int domain_type_is_si(struct dmar_domain
>> *domain)
>>   	return domain->flags & DOMAIN_FLAG_STATIC_IDENTITY;  }
>>
>> +static inline bool domain_use_first_level(struct dmar_domain *domain) {
>> +	return domain->flags & DOMAIN_FLAG_USE_FIRST_LEVEL; }
>> +
>>   static inline int domain_pfn_supported(struct dmar_domain *domain,
>>   				       unsigned long pfn)
>>   {
>> @@ -2288,6 +2293,8 @@ static int __domain_mapping(struct dmar_domain
>> *domain, unsigned long iov_pfn,
>>   		return -EINVAL;
>>
>>   	prot &= DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP;
>> +	if (domain_use_first_level(domain))
>> +		prot |= DMA_FL_PTE_PRESENT;
> 
> For DMA_PTE_SNP bit, I think there needs some work. The bit 11 of prot
> should be cleared when FLPT is used for IOVA.

SNP (bit 11) is only for second level. This bit is ignored for first
level page table walk. We should clear this bit for first level anyway.

> 
> Also, we need to set bit 63 "XD" properly. e.g. If bit 11 of prot is set, it
> means snoop required, then "XD" bit is "0". If bit 11 of prot is "0", it means
> this domain is not snooping, so you may want to set "XD" bit as "1". With
> such enhancement, I think IOVA over FLPT would have as less difference
> with IOVA over SLPT.

XD (bit 63) is only for the first level, and SNP (bit 11) is only for
second level, right? I think we need to always set XD bit for IOVA over
FL case. thoughts?

Best regards,
baolu
