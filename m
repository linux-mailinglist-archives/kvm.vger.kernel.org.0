Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC484775734
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 12:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbjHIKlG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 06:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbjHIKlF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 06:41:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EAA1702;
        Wed,  9 Aug 2023 03:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691577663; x=1723113663;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JJghwIXXHT4UB5NHzHlq8b7Yl1CvVOGiPlOyugRhpog=;
  b=aQhUMNqWoA7P6fYbhtT55WnLNX15sgzlS2w8eBLp1MbSO2niGPZTk5OU
   fK/TEqxrtLCVXievPdspuC/OCl8YlZPIKsb839VYYaYKhEI5HLWLrA+kL
   5S0O5TO1tqLmGBtvJUwxWYgXCqOhFsJknyZLNcKgjnq4IIh+nqTP0DFIz
   MeiCpmE06AmL/wGmU8XonJle/VfGKkhrAh5LzE2b9PYy11oysKl0hBzyA
   aJbvodeFYmYUdkou08WTTmD31YF9Xh1vXL4bv2XJPv7Q0WT9Pjtxo1fc/
   x6NjqJD0uYULjiRztCjji9UcxKD5bEpAVEUumyM6TnEo6wgPrsaYscGU/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="371078321"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="371078321"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 03:41:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="761335613"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="761335613"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.210.171]) ([10.254.210.171])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 03:40:59 -0700
Message-ID: <0771c28d-1b31-003e-7659-4f3f3cbf5546@linux.intel.com>
Date:   Wed, 9 Aug 2023 18:40:56 +0800
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
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-9-baolu.lu@linux.intel.com>
 <BN9PR11MB52769D22490BB09BB25E0C2E8C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZNKMz04uhzL9T7ya@ziepe.ca>
 <BN9PR11MB527629949E7D44BED080400C8C12A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB527629949E7D44BED080400C8C12A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/9 8:02, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@ziepe.ca>
>> Sent: Wednesday, August 9, 2023 2:43 AM
>>
>> On Thu, Aug 03, 2023 at 08:16:47AM +0000, Tian, Kevin wrote:
>>
>>> Is there plan to introduce further error in the future? otherwise this should
>>> be void.
>>>
>>> btw the work queue is only for sva. If there is no other caller this can be
>>> just kept in iommu-sva.c. No need to create a helper.
>>
>> I think more than just SVA will need a work queue context to process
>> their faults.
>>
> 
> then this series needs more work. Currently the abstraction doesn't
> include workqueue in the common fault reporting layer.

Do you mind elaborate a bit here? workqueue is a basic infrastructure in
the fault handling framework, but it lets the consumers choose to use
it, or not to.

Best regards,
baolu
