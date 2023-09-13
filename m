Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F0C79DF26
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 06:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237183AbjIME0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 00:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbjIME0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 00:26:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6159DA0;
        Tue, 12 Sep 2023 21:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694579193; x=1726115193;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=KgyPr+Cgj+GJvemhLB38JTJgS0QW58VqrqaihkXJdmU=;
  b=GI6fa4YBwV/BAfvErgHVVJF3B21JZg5lHtCKX2ujYbVVVa4Z7YFKfEKe
   4f6vlAX7LOMSNKbrWwZQNNhrGhyoRxlRwWDyojzAvLO96O34Mgpj4FFYr
   1BYIIhHyCoY4lowujZuDysC/6BDLbZJpPEDsqzwvroL6SYaR0gtmKM+1m
   /9HGbUYiOW5jST69BxG+sOkUJTWHY5hjIfgAfXA9t9ri/LNu/BFbX8Oi/
   3k9w8XciMnzt8wCtowrkRI3GLkW8rc73Lkde4rFPRidv8ZyZFq7MUzdjW
   CKWtkoibkbCB3OiHexrujL/Koz+GcGKimgAcPzfZXmNU5wu/o6r3RyhVM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="382368650"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="382368650"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2023 21:26:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="743969821"
X-IronPort-AV: E=Sophos;i="6.02,142,1688454000"; 
   d="scan'208";a="743969821"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga002.jf.intel.com with ESMTP; 12 Sep 2023 21:26:29 -0700
Message-ID: <b48e14ed-693a-8c88-3391-76cacb0850b9@linux.intel.com>
Date:   Wed, 13 Sep 2023 12:23:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cfd9e0b8-167e-a79b-9ef1-b3bfa38c9199@linux.intel.com>
 <BN9PR11MB5276926066CC3A8FCCFD3DB08CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ed11a5c4-7256-e6ea-e94e-0dfceba6ddbf@linux.intel.com>
 <BN9PR11MB5276622C8271402487FA44708CE4A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c9228377-0a5c-adf8-d0ef-9a791226603d@linux.intel.com>
 <BN9PR11MB52764790D53DF8AB4ED417098CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <eca39154-bc45-3c7d-88a9-b377f4d248f9@linux.intel.com>
 <BN9PR11MB52769C830A65FCE6CBA037278CF0A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52769C830A65FCE6CBA037278CF0A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/13/23 10:34 AM, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Monday, September 11, 2023 8:46 PM
>>
>> On 2023/9/11 14:57, Tian, Kevin wrote:
>>>> From: Baolu Lu <baolu.lu@linux.intel.com>
>>>> Sent: Tuesday, September 5, 2023 1:24 PM
>>>>
>>>> Hi Kevin,
>>>>
>>>> I am trying to address this issue in below patch. Does it looks sane to
>>>> you?
>>>>
>>>> iommu: Consolidate per-device fault data management
>>>>
>>>> The per-device fault data is a data structure that is used to store
>>>> information about faults that occur on a device. This data is allocated
>>>> when IOPF is enabled on the device and freed when IOPF is disabled. The
>>>> data is used in the paths of iopf reporting, handling, responding, and
>>>> draining.
>>>>
>>>> The fault data is protected by two locks:
>>>>
>>>> - dev->iommu->lock: This lock is used to protect the allocation and
>>>>      freeing of the fault data.
>>>> - dev->iommu->fault_parameter->lock: This lock is used to protect the
>>>>      fault data itself.
>>>>
>>>> Improve the iopf code to enforce this lock mechanism and add a
>> reference
>>>> counter in the fault data to avoid use-after-free issue.
>>>>
>>>
>>> Can you elaborate the use-after-free issue and why a new user count
>>> is required?
>>
>> I was concerned that when iommufd uses iopf, page fault report/response
>> may occur simultaneously with enable/disable PRI.
>>
>> Currently, this is not an issue as the enable/disable PRI is in its own
>> path. In the future, we may discard this interface and enable PRI when
>> attaching the first PRI-capable domain, and disable it when detaching
>> the last PRI-capable domain.
> 
> Then let's not do it now until there is a real need after you have a
> thorough design for iommufd.

Okay, fair enough.

> 
>>
>>>
>>> btw a Fix tag is required given this mislocking issue has been there for
>>> quite some time...
>>
>> I don't see any real issue fixed by this change. It's only a lock
>> refactoring after the code refactoring and preparing it for iommufd use.
>> Perhaps I missed anything?
>>
> 
> mislocking already exists today for the partial list:
> 
>    - iommu_queue_iopf() uses dev->iommu->lock;
>    - iopf_queue_discard_partial() uses queue->lock;

So, if it's worth it, let me try splitting a fix patch.

Best regards,
baolu
