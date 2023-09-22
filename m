Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113127AB268
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 14:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbjIVMsH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 08:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjIVMsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 08:48:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25500C2;
        Fri, 22 Sep 2023 05:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695386880; x=1726922880;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SJXKFbW5yysENzxXAszyP4/ZxPxPNmpz+BMzxHg+9d4=;
  b=D8G6NUsqFves0I1Ra9o77ZuE4f9Lfx8plJKrfSSWsGuCQjUdsIe1aDmX
   c0WPCeWCxnOYiFUfb3U8FVLt4s4qYqq7F6qDJLKLshKmcJA/9/dDD2R3c
   BfWFES6j9Xs+5qjiXkaACfXzQ6bW8ZPCyn4PgsARHvys8kw2Q0slPI5dL
   6DjAPPhLSNu7FeW/F710Su/CGnGoH8ds7eE1vI4FLR4NN0DdsFrUgiicb
   0RmIkEp5XQzOFRkHaRWHLv7vK0rnlHnSd1ly8RLXw42zMTyQNoGQCPErd
   8jyP61oV36KlqXlu3bdoP+xOMfCun7dB9kIlBxcIDAlcxyi9KOivvsRFu
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="411755281"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="411755281"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 05:47:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10841"; a="862936012"
X-IronPort-AV: E=Sophos;i="6.03,167,1694761200"; 
   d="scan'208";a="862936012"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.255.30.83]) ([10.255.30.83])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2023 05:47:37 -0700
Message-ID: <d6f6dbad-c341-fe6b-a430-7bbf4bcfba31@linux.intel.com>
Date:   Fri, 22 Sep 2023 20:47:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Cc:     baolu.lu@linux.intel.com, "Liu, Jingqi" <jingqi.liu@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 09/12] iommu: Make iommu_queue_iopf() more generic
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230914085638.17307-1-baolu.lu@linux.intel.com>
 <20230914085638.17307-10-baolu.lu@linux.intel.com>
 <f20b9e78-3a63-ca3e-6c04-1d80ec857898@intel.com>
 <20230921233402.GC13795@ziepe.ca>
 <e7c773f6-969c-0097-1bca-24d276e8a8f6@linux.intel.com>
 <20230922124303.GE13795@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230922124303.GE13795@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/9/22 20:43, Jason Gunthorpe wrote:
> On Fri, Sep 22, 2023 at 10:44:45AM +0800, Baolu Lu wrote:
> 
>>>>> @@ -112,6 +110,7 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>>>>>     {
>>>>>     	int ret;
>>>>>     	struct iopf_group *group;
>>>>> +	struct iommu_domain *domain;
>>>>>     	struct iopf_fault *iopf, *next;
>>>>>     	struct iommu_fault_param *iopf_param;
>>>>>     	struct dev_iommu *param = dev->iommu;
>>>>> @@ -143,6 +142,19 @@ int iommu_queue_iopf(struct iommu_fault *fault, struct device *dev)
>>>>>     		return 0;
>>>>>     	}
>>>>> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
>>>>> +		domain = iommu_get_domain_for_dev_pasid(dev, fault->prm.pasid, 0);
>>>>> +	else
>>>>> +		domain = iommu_get_domain_for_dev(dev);
>>>>> +
>>>>> +	if (!domain || !domain->iopf_handler) {
>>>> Does it need to check if 'domain' is error ?  Like below:
>>>>
>>>>            if (!domain || IS_ERR(domain) || !domain->iopf_handler)
>>> Urk, yes, but not like that
>>>
>>> The IF needs to be moved into the else block as each individual
>>> function has its own return convention.
>> iommu_get_domain_for_dev_pasid() returns an ERR_PTR only if the matching
>> domain type is specified (non-zero).
>>
>> Adding IS_ERR(domain) in the else block will make the code more
>> readable. Alternatively we can put a comment around above code to
>> explain that ERR_PTR is not a case here.
> You should check it because you'll probably get a static tool
> complaint otherwise

Okay, got you.

Best regards,
baolu
