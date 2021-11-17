Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8416B45402E
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 06:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhKQF3u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 00:29:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:49283 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhKQF3t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 00:29:49 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="233717991"
X-IronPort-AV: E=Sophos;i="5.87,240,1631602800"; 
   d="scan'208";a="233717991"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 21:26:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,240,1631602800"; 
   d="scan'208";a="494772632"
Received: from allen-box.sh.intel.com (HELO [10.239.159.118]) ([10.239.159.118])
  by orsmga007.jf.intel.com with ESMTP; 16 Nov 2021 21:26:46 -0800
Cc:     baolu.lu@linux.intel.com, Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, kvm@vger.kernel.org,
        rafael@kernel.org, linux-pci@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
To:     Jason Gunthorpe <jgg@nvidia.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
 <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
 <20211116134603.GA2105516@nvidia.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <d79acc01-eeaf-e6ac-0415-af498c355a00@linux.intel.com>
Date:   Wed, 17 Nov 2021 13:22:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211116134603.GA2105516@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 11/16/21 9:46 PM, Jason Gunthorpe wrote:
> On Tue, Nov 16, 2021 at 09:57:30AM +0800, Lu Baolu wrote:
>> Hi Christoph,
>>
>> On 11/15/21 9:14 PM, Christoph Hellwig wrote:
>>> On Mon, Nov 15, 2021 at 10:05:42AM +0800, Lu Baolu wrote:
>>>> +enum iommu_dma_owner {
>>>> +	DMA_OWNER_NONE,
>>>> +	DMA_OWNER_KERNEL,
>>>> +	DMA_OWNER_USER,
>>>> +};
>>>> +
>>>
>>>> +	enum iommu_dma_owner dma_owner;
>>>> +	refcount_t owner_cnt;
>>>> +	struct file *owner_user_file;
>>>
>>> I'd just overload the ownership into owner_user_file,
>>>
>>>    NULL			-> no owner
>>>    (struct file *)1UL)	-> kernel
>>>    real pointer		-> user
>>>
>>> Which could simplify a lot of the code dealing with the owner.
>>>
>>
>> Yeah! Sounds reasonable. I will make this in the next version.
> 
> It would be good to figure out how to make iommu_attach_device()
> enforce no other driver binding as a kernel user without a file *, as
> Robin pointed to, before optimizing this.
> 
> This fixes an existing bug where iommu_attach_device() only checks the
> group size and is vunerable to a hot plug increasing the group size
> after it returns. That check should be replaced by this series's logic
> instead.

As my my understanding, the essence of this problem is that only the
user owner of the iommu_group could attach an UNMANAGED domain to it.
If I understand it right, how about introducing a new interface to
allocate a user managed domain and storing the user file pointer in it.

--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -94,6 +94,7 @@ struct iommu_domain {
         void *handler_token;
         struct iommu_domain_geometry geometry;
         struct iommu_dma_cookie *iova_cookie;
+       struct file *owner_user_file;
  };
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -1902,6 +1902,18 @@ struct iommu_domain *iommu_domain_alloc(struct 
bus_type *bus)
  }
  EXPORT_SYMBOL_GPL(iommu_domain_alloc);

+struct iommu_domain *iommu_domain_alloc_user(struct bus_type *bus,
+                                            struct file *filep)
+{
+       struct iommu_domain *domain;
+
+       domain = __iommu_domain_alloc(bus, IOMMU_DOMAIN_UNMANAGED);
+       if (domain)
+               domain->owner_user_file = filep;
+
+       return domain;
+}

When attaching a domain to an user-owned iommu_group, both group and
domain should have matched user fd.

Does above help here?

Best regards,
baolu
