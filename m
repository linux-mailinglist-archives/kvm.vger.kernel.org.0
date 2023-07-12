Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0477E74FD41
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 04:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbjGLCou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 22:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbjGLCot (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 22:44:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676BD1993;
        Tue, 11 Jul 2023 19:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689129881; x=1720665881;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=iWj+6wrVCX+Ik7s49Gkyi64YGWWOKVozpQXtsPYZBfA=;
  b=Xbve3BMKnyxpZRrsgvG1nZ+XYB2SS6CPEB+SLvZmfXnMxmT2Y7ZU2rus
   gYyBxcLE1QNP+6SY2TXg7h4pN1vI8xZ640YDz7dcSofD/5xzOl11qteuB
   3892SOk32cBShh0tNS47txqhd+TPtF1pzphGDS08ZZpp/vE3RQwwv8dTC
   ElZo/ZTNt9/w3yB3HYnEDcdGxiB+tUHOnJtwIpX4+Y0k9IsK+baItN078
   eBPQNT+Ht+PqFBPauZA4YEYoujfTdFsjeoi0WZ42oPYpJw7pU2hjo9lUN
   py0GEgJimiAjs6l9Ti/Fw0IqVsjCcd+RuXyfQvv2a2O2wDbW7DMK/DnPJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="451149380"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="451149380"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 19:43:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10768"; a="756592673"
X-IronPort-AV: E=Sophos;i="6.01,198,1684825200"; 
   d="scan'208";a="756592673"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.187.60]) ([10.252.187.60])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 19:43:49 -0700
Message-ID: <c815fa2b-00df-91e1-8353-8258773957e4@linux.intel.com>
Date:   Wed, 12 Jul 2023 10:43:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/9] iommu: Make fault_param generic
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-6-baolu.lu@linux.intel.com>
 <BN9PR11MB52763F7A1433C73CF6589F2E8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52763F7A1433C73CF6589F2E8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On 2023/7/11 14:14, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Tuesday, July 11, 2023 9:07 AM
>>
>> @@ -299,7 +299,15 @@ static int dev_iommu_get(struct device *dev)
>>   		return -ENOMEM;
>>
>>   	mutex_init(&param->lock);
>> +	param->fault_param = kzalloc(sizeof(*param->fault_param),
>> GFP_KERNEL);
>> +	if (!param->fault_param) {
>> +		kfree(param);
>> +		return -ENOMEM;
>> +	}
>> +	mutex_init(&param->fault_param->lock);
>> +	INIT_LIST_HEAD(&param->fault_param->faults);
>>   	dev->iommu = param;
>> +
>>   	return 0;
>>   }
> 
> Upon above changes is it slightly cleaner to call it dev_iommu_init()
> to better pair with dev_iommu_free()?

dev_iommu_init() was introduced in Jason's series. It's not landed yet.

https://lore.kernel.org/linux-iommu/0-v3-328044aa278c+45e49-iommu_probe_jgg@nvidia.com/

Sure. Should refine this code after above patches are landed.

Best regards,
baolu
