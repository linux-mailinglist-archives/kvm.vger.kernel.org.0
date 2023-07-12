Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763E474FD13
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 04:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjGLCcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 22:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjGLCcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 22:32:23 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2663BE5;
        Tue, 11 Jul 2023 19:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689129142; x=1720665142;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fgGXijljthsRzhXyBfltqRAFXvj8vZTDzfPou8adOFY=;
  b=XW5sSjGtH/1KXL9df+MecbIw2Oy9WJxwdlr/L9r3IXdI69whK4g9uEcq
   Khx8yhALgzSgRFq7HXshAxp2Lzk6QEMuteXqqJg5aVgNCtOS0cZYVrV31
   lBuLVSgz7gfg6ZsG7eGz4F4wAROuQRh/QS4ikCDx2z+l6ht+Tp116F5+a
   iSOFdsHgxgQQ3k6wrOGMCPJEAJXWOin9k+jbIBylQiNWGGEf5h4aavC4X
   TR1yAsn84s1q4ELAv5dvWKlx7V2rLoYffdKsV90+1XU1lHuRRUe+3iree
   uI9f9LII0I3Q5KQg5BrJx4d09XviZxEkkr7FVJtFCSjSGiZurIiwyhBX5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="345097242"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="345097242"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 19:32:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="811415713"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="811415713"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.187.60]) ([10.252.187.60])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 19:32:17 -0700
Message-ID: <cbbe1175-40f3-805e-02c2-f887b3289f04@linux.intel.com>
Date:   Wed, 12 Jul 2023 10:32:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] iommu: Add common code to handle IO page faults
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-4-baolu.lu@linux.intel.com>
 <BN9PR11MB52761F71BA509501C1766E9A8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52761F71BA509501C1766E9A8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/7/11 14:12, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Tuesday, July 11, 2023 9:07 AM
>>
>> +static int iommu_handle_io_pgfault(struct device *dev,
>> +				   struct iommu_fault *fault)
>> +{
>> +	struct iommu_domain *domain;
>> +
>> +	if (fault->type != IOMMU_FAULT_PAGE_REQ)
>> +		return -EINVAL;
>> +
>> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
>> +		domain = iommu_get_domain_for_dev_pasid(dev, fault-
>>> prm.pasid, 0);
>> +	else
>> +		domain = iommu_get_domain_for_dev(dev);
>> +
>> +	if (!domain || !domain->iopf_handler)
>> +		return -ENODEV;
>> +
>> +	if (domain->iopf_handler == iommu_sva_handle_iopf)
>> +		return iommu_queue_iopf(fault, dev);
> 
> You can avoid the special check by directly making iommu_queue_iopf
> as the iopf_handler for sva domain.

Yeah, good catch!

> 
>> +
>> +	return domain->iopf_handler(fault, dev, domain->fault_data);
>> +}
> 
> btw is there value of moving the group handling logic from
> iommu_queue_iopf() to this common function?
> 
> I wonder whether there is any correctness issue if not forwarding
> partial request to iommufd. If not this can also help reduce
> notifications to the user until the group is ready.

I don't think there's any correctness issue. But it should be better if
we can inject the page faults to vm guests as soon as possible. There's
no requirement to put page requests to vIOMMU's hardware page request
queue at the granularity of a fault group. Thoughts?

Best regards,
baolu
