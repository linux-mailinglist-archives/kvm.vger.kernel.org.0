Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F17B876C376
	for <lists+kvm@lfdr.de>; Wed,  2 Aug 2023 05:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjHBDUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 23:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjHBDUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 23:20:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BFAD1708;
        Tue,  1 Aug 2023 20:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690946412; x=1722482412;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=wP5cpI1WxpDaK0+2mD5lWz2GGol38mq2b5g+itsFQmM=;
  b=BNUaEWNtwA5kRtj4ge4ZZNrHo/jHg2W2Y8MR46LBD+N7RoO52sApbppv
   SbrV9gOx/Vh1pxaRLbMIdwWef1LSZEv5wBCsEaE+uOwfBwrSh+7TbdFe/
   V2e7H0TourM0SowiSSMMCpcN4aSCNtIY7a7K9kdwlI1XxXFNa+wIa9qxU
   jcBZTiomEw69XufTUBCTneDnK0UJwFNZGmY6VV9yMcooLXw51unzWPbO0
   XNvH/KlUzfT3eK8HLnCc1nTEqc36PoV6R9zVFNqHsPHiBv7fQ69FbF7sj
   ZNLz1zv8wjHAmxsdz5oI8gOuqKuIvf90Q3ZncJUPHeo0C0IQyCuZcjlsv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="433308233"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="433308233"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 20:20:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10789"; a="819020866"
X-IronPort-AV: E=Sophos;i="6.01,248,1684825200"; 
   d="scan'208";a="819020866"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.213.137]) ([10.254.213.137])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2023 20:20:08 -0700
Message-ID: <077966f0-d2fe-d85e-268a-a4f14c1870f1@linux.intel.com>
Date:   Wed, 2 Aug 2023 11:20:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] iommu: Consolidate pasid dma ownership check
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230801063125.34995-1-baolu.lu@linux.intel.com>
 <20230801063125.34995-2-baolu.lu@linux.intel.com>
 <BN9PR11MB5276D196F9BFB06D0E59AEF28C0AA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <36fb3548-7206-878e-d095-195c2feb24f1@linux.intel.com>
 <BN9PR11MB5276B0865C9D8DC9060BF1A08C0BA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276B0865C9D8DC9060BF1A08C0BA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/2 9:39, Tian, Kevin wrote:
>> From: Baolu Lu<baolu.lu@linux.intel.com>
>> Sent: Tuesday, August 1, 2023 3:44 PM
>>
>> On 2023/8/1 15:03, Tian, Kevin wrote:
>>>>    /**
>>>>     * iommu_device_use_default_domain() - Device driver wants to handle
>>>> device
>>>>     *                                     DMA through the kernel DMA API.
>>>> @@ -3052,14 +3063,14 @@ int
>> iommu_device_use_default_domain(struct
>>>> device *dev)
>>>>
>>>>    	mutex_lock(&group->mutex);
>>>>    	if (group->owner_cnt) {
>>>> -		if (group->owner || !iommu_is_default_domain(group) ||
>>>> -		    !xa_empty(&group->pasid_array)) {
>>>> +		if (group->owner || !iommu_is_default_domain(group)) {
>>>>    			ret = -EBUSY;
>>>>    			goto unlock_out;
>>>>    		}
>>>>    	}
>>>>
>>>>    	group->owner_cnt++;
>>>> +	assert_pasid_dma_ownership(group);
>>> Old code returns error if pasid_xrrary is not empty.
>>>
>>> New code continues to take ownership with a warning.
>>>
>>> this is a functional change. Is it intended or not?
>> If iommu_device_use_default_domain() is called with pasid_array not
>> empty, there must be a bug somewhere in the device driver. We should
>> WARN it instead of returning an error. Probably this is a functional
>> change? If so, I can add this in the commit message.
>>
> IMHO we should WARN*and*  return an error.

Okay, fine to me. Will make this in the next version.

Best regards,
baolu
