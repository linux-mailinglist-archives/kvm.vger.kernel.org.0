Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1277784D1
	for <lists+kvm@lfdr.de>; Fri, 11 Aug 2023 03:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjHKBPx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 21:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjHKBPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 21:15:51 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3B79F;
        Thu, 10 Aug 2023 18:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691716550; x=1723252550;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+cNkmSq4sbVg58xl/B6iCnxVPlGtuyl7BHTC5IrVJmg=;
  b=jnhzXmrBaKRvjdNrqIxxDRxH6kWRwy4z1r8GzmuVN7n82Xd+8ZmgUzrr
   JpZtRqbm+xA+7EuMYGnHcmg1nXLoVn53YdXxhDUk3s+B5fsNLc6ErGZXe
   fnxlL6oWUroIIE2X/lDyPUqjdh/r5PWxM2PWlou4MmHI8+Wk4uSBl65ap
   mCCFHDKb0bcMVCiyBIKJ0ZHGSOc4WpdpFLqNvFK+LObpirdOLehmZm9ec
   hddE6nMDDkw9/ykpiSQAxSz/NyWxBVfDfxwX31VsrxnmKfyITppbGyPp6
   80r7Kep+y/uOmU8CpMjtMVAhiZwpbVuRq3zJPlmcS3RucnmBV88Io3zbq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="356530276"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="356530276"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:15:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10798"; a="735608564"
X-IronPort-AV: E=Sophos;i="6.01,163,1684825200"; 
   d="scan'208";a="735608564"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.214.70]) ([10.254.214.70])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 18:15:47 -0700
Message-ID: <7694a4ea-4a08-2296-cd3a-593004de8718@linux.intel.com>
Date:   Fri, 11 Aug 2023 09:15:44 +0800
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
Subject: Re: [PATCH v2 03/12] iommu: Remove unrecoverable fault data
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-4-baolu.lu@linux.intel.com>
 <ZNPF/nA2JdqHMM10@ziepe.ca>
 <28d86414-d684-b468-d0a9-5c429260e081@linux.intel.com>
 <ZNUUYR9WGf475Q4L@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZNUUYR9WGf475Q4L@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/11 0:46, Jason Gunthorpe wrote:
> On Thu, Aug 10, 2023 at 10:27:21AM +0800, Baolu Lu wrote:
>> On 2023/8/10 0:59, Jason Gunthorpe wrote:
>>> On Thu, Jul 27, 2023 at 01:48:28PM +0800, Lu Baolu wrote:
>>>> The unrecoverable fault data is not used anywhere. Remove it to avoid
>>>> dead code.
>>>>
>>>> Suggested-by: Kevin Tian<kevin.tian@intel.com>
>>>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>>>> ---
>>>>    include/linux/iommu.h | 70 +------------------------------------------
>>>>    1 file changed, 1 insertion(+), 69 deletions(-)
>>> Do we plan to bring this back in some form? A driver specific fault
>>> report via iommufd?
>> I can hardly see the possibility.
>>
>> The only necessary dma fault messages are the offending address and the
>> permissions. With these, the user space device model software knows that
>> "a DMA fault was generated when the IOMMU hardware tried to translate
>> the offending address with the given permissions".
>>
>> And then, the device model software will walk the page table and figure
>> out what is missed before injecting the vendor-specific fault messages
>> to the VM guest.
> Avoiding walking the page table sounds like a pretty big win if we
> could manage it by forwarding more event data..

Fair enough. We can discuss what kind of extra event data could be
included later when we have real code for dma fault forwarding support
in iommufd.

Best regards,
baolu
