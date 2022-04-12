Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA01B4FE273
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 15:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355816AbiDLNYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 09:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356214AbiDLNXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 09:23:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AD3FE1
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 06:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649769212; x=1681305212;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XR4HOYE6zeHEFBL28l2IpgxCfioOEDYmeQaZWokwHR8=;
  b=dONPTX/jxeyhFLUJ5peqEULtG/bv1sNisEzomZNz4hTHNi3uwsZ6PvDD
   +/ePv7mAuIUtlIDyEFPzheW9EpgRiEAZ7qGuSLVYB6rODD7CPOJYWS9/z
   PN4P3oOtUPT1vNm12zuIXDR/VfRUCj7ZZ7aASZPnuG6IyHoDE9BmF5m0Z
   6eyAECiXzp39LrIwVylKfVQ1oCPT96tG59Z1efo2hh4+Bp768R7V4St74
   hDZOLYWQ1Uz9w9B4JQe2C/pq1MJmQ2zz7qBNFBllT+gJdGsTHAX1aAKty
   XOQdFRi4Q7AvKXvdndB4iXkKSsydvrbrDOAXEZ2MFbI12aJxH/RPEHDqW
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10314"; a="322814362"
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="322814362"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 06:13:32 -0700
X-IronPort-AV: E=Sophos;i="5.90,253,1643702400"; 
   d="scan'208";a="572759914"
Received: from blu2-mobl3.ccr.corp.intel.com (HELO [10.254.210.174]) ([10.254.210.174])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 06:13:29 -0700
Message-ID: <a3b9d7f0-b7b9-ffdf-90c3-b216e1e19b35@linux.intel.com>
Date:   Tue, 12 Apr 2022 21:13:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Cc:     baolu.lu@linux.intel.com, Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v2 2/4] vfio: Move the Intel no-snoop control off of
 IOMMU_CACHE
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <2-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <BN9PR11MB5276796235136C1E6C50A5AF8CE99@BN9PR11MB5276.namprd11.prod.outlook.com>
 <8df77a0f-55ee-bbc3-8ada-ab109d9323eb@linux.intel.com>
 <BN9PR11MB5276FD53286C0181B4987C958CED9@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276FD53286C0181B4987C958CED9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/4/12 15:44, Tian, Kevin wrote:
>> From: Lu Baolu<baolu.lu@linux.intel.com>
>> Sent: Saturday, April 9, 2022 8:51 PM
>>
>> On 2022/4/8 16:16, Tian, Kevin wrote:
>>>> From: Jason Gunthorpe<jgg@nvidia.com>
>>>> Sent: Thursday, April 7, 2022 11:24 PM
>>>>
>>>> IOMMU_CACHE means "normal DMA to this iommu_domain's IOVA
>> should
>>>> be cache
>>>> coherent" and is used by the DMA API. The definition allows for special
>>>> non-coherent DMA to exist - ie processing of the no-snoop flag in PCIe
>>>> TLPs - so long as this behavior is opt-in by the device driver.
>>>>
>>>> The flag is mainly used by the DMA API to synchronize the IOMMU setting
>>>> with the expected cache behavior of the DMA master. eg based on
>>>> dev_is_dma_coherent() in some case.
>>>>
>>>> For Intel IOMMU IOMMU_CACHE was redefined to mean 'force all DMA
>> to
>>>> be
>>>> cache coherent' which has the practical effect of causing the IOMMU to
>>>> ignore the no-snoop bit in a PCIe TLP.
>>>>
>>>> x86 platforms are always IOMMU_CACHE, so Intel should ignore this flag.
>>>>
>>>> Instead use the new domain op enforce_cache_coherency() which causes
>>>> every
>>>> IOPTE created in the domain to have the no-snoop blocking behavior.
>>>>
>>>> Reconfigure VFIO to always use IOMMU_CACHE and call
>>>> enforce_cache_coherency() to operate the special Intel behavior.
>>>>
>>>> Remove the IOMMU_CACHE test from Intel IOMMU.
>>>>
>>>> Ultimately VFIO plumbs the result of enforce_cache_coherency() back into
>>>> the x86 platform code through kvm_arch_register_noncoherent_dma()
>>>> which
>>>> controls if the WBINVD instruction is available in the guest. No other
>>>> arch implements kvm_arch_register_noncoherent_dma().
>>>>
>>>> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
>>> Reviewed-by: Kevin Tian<kevin.tian@intel.com>
>>>
>>> btw as discussed in last version it is not necessarily to recalculate
>>> snoop control globally with this new approach. Will follow up to
>>> clean it up after this series is merged.
>> Agreed. But it also requires the enforce_cache_coherency() to be called
>> only after domain being attached to a device just as VFIO is doing.
> that actually makes sense, right? w/o device attached it's pointless to
> call that interface on a domain...

Agreed. Return -EOPNOTSUPP or -EINVAL to tell the caller that this
operation is invalid before any device attachment.

Best regards,
baolu
