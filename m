Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A047778521
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 03:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjHKBxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 21:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjHKBxu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 21:53:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45E662D56;
        Thu, 10 Aug 2023 18:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691718830; x=1723254830;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J9wNibjtWigosqMiqT6RlANIRotnabaMtEYiNz739Ic=;
  b=RIjUsXX5cZ+T/2W5UBxzd5xpkOs1tTT7/7v6p9v1CYvOD6ba51H923L1
   mz3iuRFxDnb9Q18csBetFKZ4HRuBs5P54orbVtpsgk4+vrhEPpgY5JJzN
   A+AUYzMmXTLCvwyzP86pTtBqCIMrrUq9vX1okX2lzWwgWaLP3wL36bD6m
   i69lOGJ7795WAyYKji/iicAdiz7Wsh9vP0ch6hII0RJqGFWoBRMGEqKoj
   hFu9NhCUad//rWPfPW+qiZbF3rEfM+MaEeu1SWJs6iqvvYV9MvcAbtWmW
   +813deOztl6cy5wcIUjAF7JCU+uhD4zEEiVqN0zukx2vwjGVVKRJEo10o
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="369041737"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="369041737"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:53:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="846618196"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="846618196"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.214.70]) ([10.254.214.70])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:53:46 -0700
Message-ID: <f1dbfb6a-5a53-f440-5d3a-25772c67547f@linux.intel.com>
Date:   Fri, 11 Aug 2023 09:53:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
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
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-9-baolu.lu@linux.intel.com>
 <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZNKMz04uhzL9T7ya@ziepe.ca>
 <BN9PR11MB527629949E7D44BED080400C8C12A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <0771c28d-1b31-003e-7659-4f3f3cbf5546@linux.intel.com>
 <BN9PR11MB527686C925E33E0DCDF261CB8C13A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZNUUjXMrLyU3g5KM@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZNUUjXMrLyU3g5KM@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/11 0:47, Jason Gunthorpe wrote:
> On Thu, Aug 10, 2023 at 02:35:40AM +0000, Tian, Kevin wrote:
>>> From: Baolu Lu<baolu.lu@linux.intel.com>
>>> Sent: Wednesday, August 9, 2023 6:41 PM
>>>
>>> On 2023/8/9 8:02, Tian, Kevin wrote:
>>>>> From: Jason Gunthorpe<jgg@ziepe.ca>
>>>>> Sent: Wednesday, August 9, 2023 2:43 AM
>>>>>
>>>>> On Thu, Aug 03, 2023 at 08:16:47AM +0000, Tian, Kevin wrote:
>>>>>
>>>>>> Is there plan to introduce further error in the future? otherwise this
>>> should
>>>>>> be void.
>>>>>>
>>>>>> btw the work queue is only for sva. If there is no other caller this can be
>>>>>> just kept in iommu-sva.c. No need to create a helper.
>>>>> I think more than just SVA will need a work queue context to process
>>>>> their faults.
>>>>>
>>>> then this series needs more work. Currently the abstraction doesn't
>>>> include workqueue in the common fault reporting layer.
>>> Do you mind elaborate a bit here? workqueue is a basic infrastructure in
>>> the fault handling framework, but it lets the consumers choose to use
>>> it, or not to.
>>>
>> My understanding of Jason's comment was to make the workqueue the
>> default path instead of being opted by the consumer.. that is my 1st
>> impression but might be wrong...
> Yeah, that is one path. Do we have anyone that uses this that doesn't
> want the WQ? (actually who even uses this besides SVA?)

I am still confused. When we forward iopf's to user space through the
iommufd, we don't need to schedule a WQ, right? Or I misunderstood here?

Best regards,
baolu
