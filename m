Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3847894A7
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 10:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjHZIHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Aug 2023 04:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbjHZIGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Aug 2023 04:06:54 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383321FD7;
        Sat, 26 Aug 2023 01:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693037212; x=1724573212;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=UhARcOy9YMTwuaxIShQFvNQvOf5srjiw1fqZq+/wgA0=;
  b=Ecb7Aj1j7+9BEclYK7Dmd4wjS9RlKYUJSgoaTt+DltBXH1ELsUglVO1F
   MZWqd8iorgvfsRtIqKTYxybtLvT+b8sytV56721Ed3SuFqYGLWLBDX5w7
   rl0AMJdiJeFwBEpds5NgIoIEFmFmC9yq11T2d2cDg7SNHl3t3BvegCDnd
   WV26MjF+l6PDFVTezsRyx1q0SoRfoQ4IkSnOGJLPt2OZufot17jtXVbcx
   xwySl2Z+UbdTaIWg9x3x+Nns/qSelbm22HxCGN1oW+CAjASRXHylhhh2h
   MXi+6VlRaght80QIB0Go/fMzS9wbPMGH0SLBH/e1VS81DuQwRzvBVsN1R
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="441205045"
X-IronPort-AV: E=Sophos;i="6.02,203,1688454000"; 
   d="scan'208";a="441205045"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2023 01:06:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="731286368"
X-IronPort-AV: E=Sophos;i="6.02,203,1688454000"; 
   d="scan'208";a="731286368"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga007.jf.intel.com with ESMTP; 26 Aug 2023 01:06:48 -0700
Message-ID: <cfd9e0b8-167e-a79b-9ef1-b3bfa38c9199@linux.intel.com>
Date:   Sat, 26 Aug 2023 16:04:12 +0800
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
>> +static void assert_no_pending_iopf(struct device *dev, ioasid_t pasid)
>> +{
>> +	struct iommu_fault_param *iopf_param = dev->iommu-
>>> fault_param;
>> +	struct iopf_fault *iopf;
>> +
>> +	if (!iopf_param)
>> +		return;
>> +
>> +	mutex_lock(&iopf_param->lock);
>> +	list_for_each_entry(iopf, &iopf_param->partial, list) {
>> +		if (WARN_ON(iopf->fault.prm.pasid == pasid))
>> +			break;
>> +	}
> partial list is protected by dev_iommu lock.
> 

Ah, do you mind elaborating a bit more? In my mind, partial list is
protected by dev_iommu->fault_param->lock.

Best regards,
baolu
