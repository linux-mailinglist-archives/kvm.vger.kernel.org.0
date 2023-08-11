Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF640778591
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 04:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231603AbjHKCkb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 22:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbjHKCk2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 22:40:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1592D48;
        Thu, 10 Aug 2023 19:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691721626; x=1723257626;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aqqOTgbaDxU7YQXJKJJ6d5riUgAVtDn0mUBNSHHE+e4=;
  b=VFmIs+aIL/FESojyr9acFpHYlG0qmMmJ3TZ+Q7LjQ3Y3KYf/F3oI7+2d
   GSOoX8uc2JS/pPAQsVK3iaiwRhJOZ/1H6KE9UAbjw3lxLjswBDakJlJtQ
   CGGz3YagwPYV36EVkjTCvx11OU9d2TnvnpUwSn36Bsat7lDcyY6XKY9Py
   qN/swbafze/IbwGJOjFGj/8c9xEQwDbKpvDV6skmcrSYJDQYpf2WURXzc
   CzHSfXfe7sB1A6Jb/KG+4ZKBoljy5FAIobmNgDetaBmFxSbUXIDbvuWci
   AvvL58B/VCZYVp042QdV9bEuSLExFZHxkP+J6jGeDv1+VTxS0ixp2lIbZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="370477443"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="370477443"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 19:40:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="1063148644"
X-IronPort-AV: E=Sophos;i="6.01,164,1684825200"; 
   d="scan'208";a="1063148644"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.214.65]) ([10.254.214.65])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 19:40:17 -0700
Message-ID: <b154c6d4-45db-0f4c-d704-fe1ab8e4d6a5@linux.intel.com>
Date:   Fri, 11 Aug 2023 10:40:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/12] iommu: Add helper to set iopf handler for domain
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-13-baolu.lu@linux.intel.com>
 <ZNU4Hio8oAHH8RLn@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZNU4Hio8oAHH8RLn@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/11 3:18, Jason Gunthorpe wrote:
> On Thu, Jul 27, 2023 at 01:48:37PM +0800, Lu Baolu wrote:
>> To avoid open code everywhere.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>   include/linux/iommu.h | 11 ++++++++++-
>>   drivers/iommu/iommu.c | 20 ++++++++++++++++++--
>>   2 files changed, 28 insertions(+), 3 deletions(-)
> 
> Seems like overkill at this point..
> 
> Also, I think this is probably upside down.
> 
> We want to create the domains as fault enabled in the first place.
> 
> A fault enabled domain should never be attached to something that
> cannot support faults. It should also not support changing the fault
> handler while it exists.
> 
> Thus at the creation point would be the time to supply the fault handler
> as part of requesting faulting.
> 
> Taking an existing domain and making it faulting enabled is going to
> be really messy in all the corner cases.

Yes. Agreed.

> 
> My advice (and Robin will probably hate me), is to define a new op:
> 
> struct domain_alloc_paging_args {
>         struct fault_handler *fault_handler;
>         void *fault_data
> };
> 
> struct iommu_domain *domain_alloc_paging2(struct device *dev, struct
>         domain_alloc_paging_args *args)
> 
> The point would be to leave the majority of drivers using the
> simplified, core assisted, domain_alloc_paging() interface and they
> just don't have to touch any of this stuff at all.
> 
> Obviously if handler is given then the domain will be initialized as
> faulting.

Perhaps we also need an internal helper for iommu drivers to check the
iopf capability of the domain.

Best regards,
baolu
