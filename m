Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5022789427
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 09:06:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjHZHFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Aug 2023 03:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjHZHFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Aug 2023 03:05:08 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF11133;
        Sat, 26 Aug 2023 00:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693033504; x=1724569504;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mhlcGuQVeMpelWJSHYtiMjji6VrBxAVhVDBLt5DLy0k=;
  b=b59GRMwwc7pmzewuYaxZRUJA3L19s1Yw4CHiVVp0MH2cELPBitK6JMA0
   OEbCz9XIlVLcCEOjTBxvCHfQVYH4D3hw/uuN+TfSXAL2/ifczWPbHNgbY
   2w6FhA8LCzbVoJ6Po8vIfaELDLHz7a04j5MZDq9DA5dBG8/PoreovtLf6
   zV+yazy6ci4AZuFr7ip3hYdPzz2MeoaMOd0emcnpRzLhGMzrIDVGdZo1D
   WAk4sS8ggZEpT+uxVvkaloWzFYUomuvkwvSlTOWZmGRXvGE2bKE06AJxC
   +yYzlp4d5l4U5rpBxebyYmjzHVflHYojQlHpw1htBSanXxck8jJ6rMM69
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="461218396"
X-IronPort-AV: E=Sophos;i="6.02,203,1688454000"; 
   d="scan'208";a="461218396"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2023 00:05:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="803180456"
X-IronPort-AV: E=Sophos;i="6.02,203,1688454000"; 
   d="scan'208";a="803180456"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmsmga008.fm.intel.com with ESMTP; 26 Aug 2023 00:05:01 -0700
Message-ID: <7985c942-0cdb-7637-6610-fa5a8963f2ae@linux.intel.com>
Date:   Sat, 26 Aug 2023 15:02:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 07/10] iommu: Merge iommu_fault_event and iopf_fault
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-8-baolu.lu@linux.intel.com>
 <BN9PR11MB5276E342E0E774CABA484B258CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276E342E0E774CABA484B258CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/23 4:03 PM, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Friday, August 25, 2023 10:30 AM
>>
>> -/**
>> - * struct iommu_fault_event - Generic fault event
>> - *
>> - * Can represent recoverable faults such as a page requests or
>> - * unrecoverable faults such as DMA or IRQ remapping faults.
>> - *
>> - * @fault: fault descriptor
>> - * @list: pending fault event list, used for tracking responses
>> - */
>> -struct iommu_fault_event {
>> -	struct iommu_fault fault;
>> -	struct list_head list;
>> -};
>> -
> 
> iommu_fault_event is more forward-looking if unrecoverable fault
> will be supported in future. From this angle it might make more
> sense to keep it to replace iopf_fault.

Currently IOMMU drivers use

int report_iommu_fault(struct iommu_domain *domain, struct device *dev,
                        unsigned long iova, int flags)

to report unrecoverable faults. There is no need for a generic fault
event structure.

So alternatively, we can use iopf_fault for now and consolidate a
generic fault data structure when there is a real need.

Best regards,
baolu
