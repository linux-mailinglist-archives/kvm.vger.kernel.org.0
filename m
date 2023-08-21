Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8828A782345
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 07:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbjHUFoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 01:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjHUFoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 01:44:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499EFA3;
        Sun, 20 Aug 2023 22:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692596683; x=1724132683;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Gx3SgnfGV8hbt3rcGhG27+mleRZghv8tlf8VVTaLsFI=;
  b=St3fGZgDt35K6o0A5vhsqFZS4yttSqTXI5D0I8E+En60k16RlkhD6tVP
   4/GRCgCav5cVU6+taKLUEUlFbnL8tmpW6VuPiTHeV9duy57gxD+NUy3dA
   VEROw2i96fBNezT8WvzS131HneVak8PnKUy3u6mVkIVEWgcru6bQNkOd2
   Oz68qdquyZDY3iiSavNhYB5md2kEDIJzV8lQy/17/i/XwbbM2NLY5XH7h
   N1SSgrEC9g2R1i/U+KhbBXXi+HGxejqjJ6uzkETT7KCuyRI67OIuc8Ur9
   ZvbbC8rz64O64pFr9DMo8CwSFtHXQmPK8wG+X/n+ZT4ZwwPuLmturYXiP
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="459869110"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="459869110"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2023 22:44:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="738780305"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="738780305"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.185.204]) ([10.252.185.204])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2023 22:44:37 -0700
Message-ID: <51dfc143-aafd-fea2-26fe-e2e9025fcd21@linux.intel.com>
Date:   Mon, 21 Aug 2023 13:44:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] iommu: Make single-device group for PASID explicit
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230814011759.102089-1-baolu.lu@linux.intel.com>
 <20230814011759.102089-2-baolu.lu@linux.intel.com>
 <BN9PR11MB5276E3C3D99C2DFA963805C98C1BA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276E3C3D99C2DFA963805C98C1BA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/18 11:56, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Monday, August 14, 2023 9:18 AM
>>
>> The PASID interfaces have always supported only single-device groups.
>> This was first introduced in commit 26b25a2b98e45 ("iommu: Bind process
>> address spaces to devices"), and has been kept consistent in subsequent
>> commits.
>>
>> However, the core code doesn't explicitly check for this requirement
>> after commit 201007ef707a8 ("PCI: Enable PASID only when ACS RR & UF
>> enabled on upstream path"), which made this requirement implicit.
>>
>> Restore the check to make it explicit that the PASID interfaces only
>> support devices belonging to single-device groups.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   drivers/iommu/iommu.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 71b9c41f2a9e..f1eba60e573f 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -3408,6 +3408,11 @@ int iommu_attach_device_pasid(struct
>> iommu_domain *domain,
>>   		return -ENODEV;
>>
>>   	mutex_lock(&group->mutex);
>> +	if (list_count_nodes(&group->devices) != 1) {
>> +		ret = -EINVAL;
>> +		goto out_unlock;
>> +	}
>> +
> 
> I wonder whether we should also block adding new device to this
> group once the single-device has pasid enabled. Otherwise the

This has been guaranteed by pci_enable_pasid():

         if (!pci_acs_path_enabled(pdev, NULL, PCI_ACS_RR | PCI_ACS_UF))
                 return -EINVAL;

> check alone at attach time doesn't mean this group won't be
> expanded to have multiple devices later.

Best regards,
baolu
