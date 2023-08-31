Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F9B78E95D
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 11:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjHaJ15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 05:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjHaJ14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 05:27:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29DBD194;
        Thu, 31 Aug 2023 02:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693474073; x=1725010073;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RdDc48cBbQRqzQzMzPcG7WW8BdV8myxLOLz2N8nkdHM=;
  b=Dxvmf95uxEeifBTfN4uuSc/IxhsvEKl+YUA/Oree7WV+cge5Y/mjJfko
   zVAxWwZ7onfSU8aLnHNZ1Pg3l1bVKpkNNOh0Up2kXM6HeUo9Q4RC5+vZH
   2uXm/ZQqoiBUR1OPWYmbKQxM7vo5eT8y2FfAHtRw3ZmsxcSZ6eVeDs7D5
   lnaiTjQkzvcxr/rQCmYqbNFhvt5FJ/nd+bRksKK+nCF0CfZAlkBAm4HsV
   RoFl24V/hstxFLPYQClcnxYpQ6krFfBPzBapWtLLBVB35H8wqAVjXsPmk
   DrN2fDmONSApoQSmL9NM4UWW66/w6XqgMlRIpK152+wplQFOTm/ybLbCl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="379625933"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="379625933"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 02:27:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10818"; a="739431210"
X-IronPort-AV: E=Sophos;i="6.02,216,1688454000"; 
   d="scan'208";a="739431210"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.210.87]) ([10.254.210.87])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2023 02:27:49 -0700
Message-ID: <67aa00ae-01e6-0dd8-499f-279cb6df3ddd@linux.intel.com>
Date:   Thu, 31 Aug 2023 17:27:47 +0800
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
 <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
 <BN9PR11MB52768891BC89107AD291E45C8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52768891BC89107AD291E45C8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/30 15:43, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Saturday, August 26, 2023 4:01 PM
>>
>> On 8/25/23 4:17 PM, Tian, Kevin wrote:
>>>> +
>>>>    /**
>>>>     * iopf_queue_flush_dev - Ensure that all queued faults have been
>>>> processed
>>>>     * @dev: the endpoint whose faults need to be flushed.
>>> Presumably we also need a flush callback per domain given now
>>> the use of workqueue is optional then flush_workqueue() might
>>> not be sufficient.
>>>
>>
>> The iopf_queue_flush_dev() function flushes all pending faults from the
>> IOMMU queue for a specific device. It has no means to flush fault queues
>> out of iommu core.
>>
>> The iopf_queue_flush_dev() function is typically called when a domain is
>> detaching from a PASID. Hence it's necessary to flush the pending faults
>> from top to bottom. For example, iommufd should flush pending faults in
>> its fault queues after detaching the domain from the pasid.
>>
> 
> Is there an ordering problem? The last step of intel_svm_drain_prq()
> in the detaching path issues a set of descriptors to drain page requests
> and responses in hardware. It cannot complete if not all software queues
> are drained and it's counter-intuitive to drain a software queue after
> the hardware draining has already been completed.
> 
> btw just flushing requests is probably insufficient in iommufd case since
> the responses are received asynchronously. It requires an interface to
> drain both requests and responses (presumably with timeouts in case
> of a malicious guest which never responds) in the detach path.

You are right. Good catch.

To put it simply, iopf_queue_flush_dev() is insufficient to support the
case of forwarding iopf's over iommufd. Do I understand it right?

Perhaps we should drain the partial list and the response pending list?
With these two lists drained, no more iopf's for the specific pasid will
be forwarded up, and page response from upper layer will be dropped.

> 
> it's not a problem for sva as responses are synchrounsly delivered after
> handling mm fault. So fine to not touch it in this series but certainly
> this area needs more work when moving to support iommufd. 😊

Yes, SVA is not affected. The flush_workqueue() is enough for it. As a
preparation series, I hope we can solve this in it. :-)

> 
> btw why is iopf_queue_flush_dev() called only in intel-iommu driver?
> Isn't it a common requirement for all sva-capable drivers?

Jean answered this.

Best regards,
baolu
