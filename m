Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67DB578EBE9
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 13:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343698AbjHaLYu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 07:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbjHaLYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 07:24:49 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69ADECE4;
        Thu, 31 Aug 2023 04:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693481086; x=1725017086;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4rqbmzPeLwpZ36uQPiLAzAn3sRKRt2FDC24MP4o0xkM=;
  b=fEG4ZRjRLZ3v3IZ7JyadZj+/5vYIk8SZcEYDsIdiF50GyQuw6oRWjzG9
   aIbjWUsXiB4P9LGJgHTMZr2mdLNjzoyu6ji89hiNBnwYgos8T9OjjL6m3
   HWn6nPilI1xnOgmCad+AaVZ+5+9BdWl3LYMkAlJOiIAudm/ogggx3lJbX
   8O//qrZ9Nm9rFPKwldbsOai/cpNds64bmNP7RcQfECGDxoP0vSCVr/u/H
   1x5xo0o6M2cK1kSYAF9o/v5PvBSmgKy12wk/UXweT58l1d1qJVKwcQVic
   jepPyNiiRF/X3ukN1WK5KvjNRxDgCCd53Duo5SsV8PuGCdbrY4l4hvoRv
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="462280834"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="462280834"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 04:24:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="689286681"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="689286681"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.210.87]) ([10.254.210.87])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 04:24:42 -0700
Message-ID: <ed11a5c4-7256-e6ea-e94e-0dfceba6ddbf@linux.intel.com>
Date:   Thu, 31 Aug 2023 19:24:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
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
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276926066CC3A8FCCFD3DB08CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/30 15:55, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Saturday, August 26, 2023 4:04 PM
>>
>> On 8/25/23 4:17 PM, Tian, Kevin wrote:
>>>> +static void assert_no_pending_iopf(struct device *dev, ioasid_t pasid)
>>>> +{
>>>> +	struct iommu_fault_param *iopf_param = dev->iommu-
>>>>> fault_param;
>>>> +	struct iopf_fault *iopf;
>>>> +
>>>> +	if (!iopf_param)
>>>> +		return;
>>>> +
>>>> +	mutex_lock(&iopf_param->lock);
>>>> +	list_for_each_entry(iopf, &iopf_param->partial, list) {
>>>> +		if (WARN_ON(iopf->fault.prm.pasid == pasid))
>>>> +			break;
>>>> +	}
>>> partial list is protected by dev_iommu lock.
>>>
>>
>> Ah, do you mind elaborating a bit more? In my mind, partial list is
>> protected by dev_iommu->fault_param->lock.
>>
> 
> well, it's not how the code is currently written. iommu_queue_iopf()
> doesn't hold dev_iommu->fault_param->lock to update the partial
> list.
> 
> while at it looks there is also a mislocking in iopf_queue_discard_partial()
> which only acquires queue->lock.
> 
> So we have three places touching the partial list all with different locks:
> 
> - iommu_queue_iopf() relies on dev_iommu->lock
> - iopf_queue_discard_partial() relies on queue->lock
> - this new assert function uses dev_iommu->fault_param->lock

Yeah, I see your point now. Thanks for the explanation.

So, my understanding is that dev_iommu->lock protects the whole
pointer of dev_iommu->fault_param, while dev_iommu->fault_param->lock
protects the lists inside it.

Is this locking mechanism different from what you think?

Best regards,
baolu
