Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF3477A625
	for <lists+kvm@lfdr.de>; Sun, 13 Aug 2023 13:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjHMLT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Aug 2023 07:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjHMLTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Aug 2023 07:19:54 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD1B10DE;
        Sun, 13 Aug 2023 04:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691925597; x=1723461597;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+CUXVj1jmKu9wNFCyhaP7miPAmbIeMOb158GcXhBV/M=;
  b=hA1Q1p/hm6h3s62Vd79DvDaGCDb6sa3JPG2pXwIXUO7C9ZbE4w2yHH+k
   zSk7FKFMLH0vcycOjaZlfMMl+9rfqXoWyW3aB1kVqEM8NWMJQAgQ6NDIy
   bjilzJwXXJ+0rbwNAwYVYc2s7fM5tnJp+Lh+FW5WfM2hJAsQ709kRE8M3
   8bXxq9T4TjwKc9gyUW1Xle29CRFWepkyDj8SCyB5rpBHnHu+qN8a/c9a4
   CTIhVDAckv1KNR3IIMCs/BGO59FUDsxXkdYTdQtFB11qFNkfNGM03opwy
   M/KP4OHHxm6CzgIfloM2cv9+r5M4j0G4MBHc+ogQlXD/iNZBWfXyVQhlw
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10800"; a="438222205"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="438222205"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 04:19:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10800"; a="683016422"
X-IronPort-AV: E=Sophos;i="6.01,170,1684825200"; 
   d="scan'208";a="683016422"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.215.185]) ([10.254.215.185])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2023 04:19:53 -0700
Message-ID: <08ef3338-535a-751e-0cc2-5f5af8107194@linux.intel.com>
Date:   Sun, 13 Aug 2023 19:19:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Cc:     baolu.lu@linux.intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 08/12] iommu: Prepare for separating SVA and IOPF
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-9-baolu.lu@linux.intel.com>
 <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZNKMz04uhzL9T7ya@ziepe.ca>
 <BN9PR11MB527629949E7D44BED080400C8C12A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <0771c28d-1b31-003e-7659-4f3f3cbf5546@linux.intel.com>
 <BN9PR11MB527686C925E33E0DCDF261CB8C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZNUUjXMrLyU3g5KM@ziepe.ca>
 <f1dbfb6a-5a53-f440-5d3a-25772c67547f@linux.intel.com>
 <ZNY3LuW+FMAhK2xf@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZNY3LuW+FMAhK2xf@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/11 21:27, Jason Gunthorpe wrote:
> On Fri, Aug 11, 2023 at 09:53:41AM +0800, Baolu Lu wrote:
>> On 2023/8/11 0:47, Jason Gunthorpe wrote:
>>> On Thu, Aug 10, 2023 at 02:35:40AM +0000, Tian, Kevin wrote:
>>>>> From: Baolu Lu<baolu.lu@linux.intel.com>
>>>>> Sent: Wednesday, August 9, 2023 6:41 PM
>>>>>
>>>>> On 2023/8/9 8:02, Tian, Kevin wrote:
>>>>>>> From: Jason Gunthorpe<jgg@ziepe.ca>
>>>>>>> Sent: Wednesday, August 9, 2023 2:43 AM
>>>>>>>
>>>>>>> On Thu, Aug 03, 2023 at 08:16:47AM +0000, Tian, Kevin wrote:
>>>>>>>
>>>>>>>> Is there plan to introduce further error in the future? otherwise this
>>>>> should
>>>>>>>> be void.
>>>>>>>>
>>>>>>>> btw the work queue is only for sva. If there is no other caller this can be
>>>>>>>> just kept in iommu-sva.c. No need to create a helper.
>>>>>>> I think more than just SVA will need a work queue context to process
>>>>>>> their faults.
>>>>>>>
>>>>>> then this series needs more work. Currently the abstraction doesn't
>>>>>> include workqueue in the common fault reporting layer.
>>>>> Do you mind elaborate a bit here? workqueue is a basic infrastructure in
>>>>> the fault handling framework, but it lets the consumers choose to use
>>>>> it, or not to.
>>>>>
>>>> My understanding of Jason's comment was to make the workqueue the
>>>> default path instead of being opted by the consumer.. that is my 1st
>>>> impression but might be wrong...
>>> Yeah, that is one path. Do we have anyone that uses this that doesn't
>>> want the WQ? (actually who even uses this besides SVA?)
>> I am still confused. When we forward iopf's to user space through the
>> iommufd, we don't need to schedule a WQ, right? Or I misunderstood
>> here?
> Yes, that could be true, iommufd could just queue it from the
> interrupt context and trigger a wakeup.
> 
> But other iommufd modes would want to invoke hmm_range_fault() which
> would need the work queue.

Yes. That's the reason why I added below helper

int iopf_queue_work(struct iopf_group *group, work_func_t func)

in the patch 09/12.

Best regards,
baolu
