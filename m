Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC41E789456
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 09:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjHZHfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Aug 2023 03:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbjHZHes (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Aug 2023 03:34:48 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFE52136;
        Sat, 26 Aug 2023 00:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693035286; x=1724571286;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4Nkh8xv3trB4dz36XZ8VniCHhsFapO4ri86v39Sr/X0=;
  b=VeeCBgKTcLhaFvtESe73WZJeRQSbLwOz0hbtTNpjTvIPWVu6eG51cLVO
   l4Xepyy1xzaxTqjiNMxthNJk6pm3zVSQdNXgebSHkV7d+Uscsv5McKNt2
   CAgQqQgEwHR/00wEsFKdBKTdZohol+GABOK5EuVmbwJ5/RCthfA36VbCj
   CxNEJhQapAgmBg/mbEwrpzzofxyCTL+S4XdFlNJxK8Ohe1uiAfZKit3az
   DpPzC+vbTetKKjDZkGksVBOZuzAJFsU6PZxrGgTPvFgU1bJkPWpIG1R4G
   cScLgmqzQajunkZy5bGLr2aEkFNa7FB67COYTzjXvlce+vChfg2i8kcZW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="441203816"
X-IronPort-AV: E=Sophos;i="6.02,203,1688454000"; 
   d="scan'208";a="441203816"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2023 00:34:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="687563883"
X-IronPort-AV: E=Sophos;i="6.02,203,1688454000"; 
   d="scan'208";a="687563883"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga003.jf.intel.com with ESMTP; 26 Aug 2023 00:34:42 -0700
Message-ID: <9ace23a3-ecf9-551f-1c5e-be5b6502c563@linux.intel.com>
Date:   Sat, 26 Aug 2023 15:32:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
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
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/23 4:17 PM, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Friday, August 25, 2023 10:30 AM
>>
>> +	if (fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID)
>> +		domain = iommu_get_domain_for_dev_pasid(dev, fault-
>>> prm.pasid, 0);
>> +	else
>> +		domain = iommu_get_domain_for_dev(dev);
>> +
>> +	if (!domain || !domain->iopf_handler) {
>> +		dev_warn_ratelimited(dev,
>> +			"iopf from pasid %d received without handler
>> installed\n",
> 
> "without domain attached or handler installed"

Okay.

> 
>>
>> +int iommu_sva_handle_iopf(struct iopf_group *group)
>> +{
>> +	struct iommu_fault_param *fault_param = group->dev->iommu-
>>> fault_param;
>> +
>> +	INIT_WORK(&group->work, iopf_handler);
>> +	if (!queue_work(fault_param->queue->wq, &group->work))
>> +		return -EBUSY;
>> +
>> +	return 0;
>> +}
> 
> this function is generic so the name should not tie to 'sva'.

Currently only sva uses it. It's fine to make it generic later when any
new use comes. Does it work to you?

Best regards,
baolu
