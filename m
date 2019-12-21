Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 175F612869D
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 03:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfLUC1t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 21:27:49 -0500
Received: from mga05.intel.com ([192.55.52.43]:20084 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfLUC1s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 21:27:48 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 18:27:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,338,1571727600"; 
   d="scan'208";a="228779440"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 20 Dec 2019 18:27:45 -0800
Cc:     baolu.lu@linux.intel.com, "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/7] iommu/vt-d: Setup pasid entries for iova over
 first level
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20191219031634.15168-1-baolu.lu@linux.intel.com>
 <20191219031634.15168-5-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A13A334@SHSMSX104.ccr.corp.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <84fd6b9e-0226-cc5f-b51a-884f834d4556@linux.intel.com>
Date:   Sat, 21 Dec 2019 10:26:49 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A13A334@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 12/20/19 7:44 PM, Liu, Yi L wrote:
>> From: Lu Baolu [mailto:baolu.lu@linux.intel.com]
>> Sent: Thursday, December 19, 2019 11:17 AM
>> To: Joerg Roedel <joro@8bytes.org>; David Woodhouse <dwmw2@infradead.org>;
>> Alex Williamson <alex.williamson@redhat.com>
>> Subject: [PATCH v4 4/7] iommu/vt-d: Setup pasid entries for iova over first level
>>
>> Intel VT-d in scalable mode supports two types of page tables for IOVA translation:
>> first level and second level. The IOMMU driver can choose one from both for IOVA
>> translation according to the use case. This sets up the pasid entry if a domain is
>> selected to use the first-level page table for iova translation.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/intel-iommu.c | 48 +++++++++++++++++++++++++++++++++++--
>>   include/linux/intel-iommu.h | 16 ++++++++-----
>>   2 files changed, 56 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c index
>> 2b5a47584baf..f0813997dea2 100644
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
>> +		prot |= DMA_FL_PTE_PRESENT | DMA_FL_PTE_XD;
>>
>>   	if (!sg) {
>>   		sg_res = nr_pages;
>> @@ -2515,6 +2522,36 @@ dmar_search_domain_by_dev_info(int segment, int bus,
>> int devfn)
>>   	return NULL;
>>   }
>>
>> +static int domain_setup_first_level(struct intel_iommu *iommu,
>> +				    struct dmar_domain *domain,
>> +				    struct device *dev,
>> +				    int pasid)
>> +{
>> +	int flags = PASID_FLAG_SUPERVISOR_MODE;
> 
> Hi Baolu,
> 
> Could you explain a bit why PASID_FLAG_SUPERVISOR_MODE is
> required?
> 

This flag indicates a PASID which can be used for access to kernel
addresses (static 1:1 only). Otherwise, DMA requests requesting
supervisor level privilege level will be blocked.

> Regards,
> Yi Liu
> 

Best regards,
baolu
