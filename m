Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0887516E5
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 05:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbjGMDtF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 23:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbjGMDtE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 23:49:04 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F69BE70;
        Wed, 12 Jul 2023 20:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689220143; x=1720756143;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hSv0ZhAHohd3J6QHRMr2vmInOR8hk9yANyQFAYJSxIQ=;
  b=JlMRnvQoTvyQwQEBGXb5C13voYstinoO6O7zGC6q2CDzeAAMybVtVCWG
   d7yAq9HpWPDq6uBKJNcp/LGhb/UwaC5wLpNv7Yw9arW8tv+6Qnfn2HnkP
   fF4dKqXH3rf4hPyw/WZzpSm8PD94Ywp1ohz9fUWv7AhBzEgNpmLVbnBC3
   jF4B9REpU8EPvZg5Q2BUGbWxobxzC4ZGJHopfi2EkhVjBcLf08G5jiFjG
   OZL7yA3kRMJVtS5viEqAN1mY99ya6dSK7GR5LdO5f6V9Hlvnb54/47oYm
   i4uQXQtSwYZfkIzwy/BNL9XUJbNJjc7kG5sBbG2XC66Aw8hgPmQX9FOSr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="367705081"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="367705081"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 20:49:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="791867064"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="791867064"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.187.96]) ([10.252.187.96])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 20:48:58 -0700
Message-ID: <cde137d4-df2e-7974-3092-970e63482768@linux.intel.com>
Date:   Thu, 13 Jul 2023 11:48:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] iommu: Move iommu fault data to linux/iommu.h
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-2-baolu.lu@linux.intel.com>
 <BN9PR11MB5276859ED6825C0A496C9C5E8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <38c31fb0-1068-4855-c896-27d6a2bca747@linux.intel.com>
 <20230712093344.GA507884@myrica>
 <BN9PR11MB5276C09E743E99D92BB5C1B28C37A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276C09E743E99D92BB5C1B28C37A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/7/13 11:22, Tian, Kevin wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Sent: Wednesday, July 12, 2023 5:34 PM
>>
>> On Wed, Jul 12, 2023 at 10:07:22AM +0800, Baolu Lu wrote:
>>>>> +/**
>>>>> + * struct iommu_fault_unrecoverable - Unrecoverable fault data
>>>>> + * @reason: reason of the fault, from &enum iommu_fault_reason
>>>>> + * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_*
>> values)
>>>>> + * @pasid: Process Address Space ID
>>>>> + * @perm: requested permission access using by the incoming
>> transaction
>>>>> + *        (IOMMU_FAULT_PERM_* values)
>>>>> + * @addr: offending page address
>>>>> + * @fetch_addr: address that caused a fetch abort, if any
>>>>> + */
>>>>> +struct iommu_fault_unrecoverable {
>>>>> +	__u32	reason;
>>>>> +#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 <<
>> 0)
>>>>> +#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 <<
>> 1)
>>>>> +#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 <<
>> 2)
>>>>> +	__u32	flags;
>>>>> +	__u32	pasid;
>>>>> +	__u32	perm;
>>>>> +	__u64	addr;
>>>>> +	__u64	fetch_addr;
>>>>> +};
>>>>
>>>> Currently there is no handler for unrecoverable faults.
>>
>> Yes those were meant for guest injection. Another goal was to replace
>> report_iommu_fault(), which also passes unrecoverable faults to host
>> drivers. Three drivers use that API:
>> * usnic just prints the error, which could be done by the IOMMU driver,
>> * remoteproc attempts to recover from the crash,
>> * msm attempts to handle the fault, or at least recover from the crash.
> 
> I was not aware of them. Thanks for pointing out.
> 
>>
>> So the first one can be removed, and the others could move over to IOPF
>> (which may need to indicate that the fault is not actually recoverable by
>> the IOMMU) and return IOMMU_PAGE_RESP_INVALID.
> 
> Yep, presumably we should have just one interface to handle fault.
> 
>>
>>>>
>>>> Both Intel/ARM register iommu_queue_iopf() as the device fault handler.
>>>> It returns -EOPNOTSUPP for unrecoverable faults.
>>>>
>>>> In your series the common iommu_handle_io_pgfault() also only works
>>>> for PRQ.
>>>>
>>>> It kinds of suggest above definitions are dead code, though arm-smmu-v3
>>>> does attempt to set them.
>>>>
>>>> Probably it's right time to remove them.
>>>>
>>>> In the future even if there might be a need of forwarding unrecoverable
>>>> faults to the user via iommufd, fault reasons reported by the physical
>>>> IOMMU doesn't make any sense to the guest.
>>
>> I guess it depends on the architecture?  The SMMU driver can report only
>> stage-1 faults through iommu_report_device_fault(), which are faults due
>> to a guest misconfiguring the tables assigned to it. At the moment
>> arm_smmu_handle_evt() only passes down stage-1 page table errors, the
>> rest
>> is printed by the host.
> 
> In that case the kernel just needs to notify the vIOMMU an error happened
> along with access permissions (r/w/e/p). vIOMMU can figure out the reason
> itself by walking the stage-1 page table. Likely it will find the same reason
> as host reports, but that sounds a clearer path in concept.
> 
>>
>>>> Presumably the vIOMMU
>>>> should walk guest configurations to set a fault reason which makes sense
>>>> from guest p.o.v.
>>>
>>> I am fine to remove unrecoverable faults data. But it was added by Jean,
>>> so I'd like to know his opinion on this.
>>
>> Passing errors to the guest could be a useful diagnostics tool for
>> debugging, once the guest gets more controls over the IOMMU hardware,
>> but
>> it doesn't have a purpose beyond that. It could be the only tool
>> available, though: to avoid a guest voluntarily flooding the host logs by
>> misconfiguring its tables, we may have to disable printing in the host
>> errors that come from guest misconfiguration, in which case there won't be
>> any diagnostics available for guest bugs.
>>
>> For now I don't mind if they're removed, if there is an easy way to
>> reintroduce them later.
>>
> 
> We can keep whatever is required to satisfy the kernel drivers which
> want to know the fault.
> 
> But for anything invented for old uAPI (e.g. fault_reason) let's remove
> them and redefine later when introducing the support to the user.

Okay, I will do this in the next version.

Best regards,
baolu
