Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4918775171A
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 06:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbjGMECk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 00:02:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233777AbjGMECU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 00:02:20 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EA02694;
        Wed, 12 Jul 2023 21:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689220938; x=1720756938;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=O39lNRRLEZrxdCfFdPTtwQM5foocmidb2nO67vHXx6E=;
  b=PWAv5Bqa7N+y+/2rjbT48I6zfzQZfawYL8mDUBU0fct8V1mdBNnEdKLz
   SR7nOvoqgXsuIIcqiA/Qr0Qo/3g3jk5SGTSkyhbCF01ODWD3wIDgY7f1h
   yiWQCiK79LX3ToTu53lRn3yc1lGNNiTL+FfwwyRlcF1URLeVHABWhAuRq
   aetDd/BL7wXKj6kg6COvv+Uq4aHUQDKhzUtqjgJtz8z2nWa8pag5PzuTr
   pER2J5WzbCrokyvPtcSPANyZlaYAiaZhbRZBc45QzABCvwEei069xcl2Q
   PoCWUGCWh/Y26NDWX8JRG3toAoP2/wkQXbarzcofNBdF2pTCLLMSk1iVn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="367706901"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="367706901"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 21:02:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10769"; a="791871498"
X-IronPort-AV: E=Sophos;i="6.01,201,1684825200"; 
   d="scan'208";a="791871498"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.187.96]) ([10.252.187.96])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2023 21:02:13 -0700
Message-ID: <155838f4-eac0-4e8c-adc6-e4efa2a786e2@linux.intel.com>
Date:   Thu, 13 Jul 2023 12:02:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] iommu: Add common code to handle IO page faults
Content-Language: en-US
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20230711010642.19707-1-baolu.lu@linux.intel.com>
 <20230711010642.19707-4-baolu.lu@linux.intel.com>
 <BN9PR11MB52761F71BA509501C1766E9A8C31A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cbbe1175-40f3-805e-02c2-f887b3289f04@linux.intel.com>
 <20230712094522.GB507884@myrica>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230712094522.GB507884@myrica>
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

On 2023/7/12 17:45, Jean-Philippe Brucker wrote:
> On Wed, Jul 12, 2023 at 10:32:13AM +0800, Baolu Lu wrote:
>>> btw is there value of moving the group handling logic from
>>> iommu_queue_iopf() to this common function?
>>>
>>> I wonder whether there is any correctness issue if not forwarding
>>> partial request to iommufd. If not this can also help reduce
>>> notifications to the user until the group is ready.
>>
>> I don't think there's any correctness issue. But it should be better if
>> we can inject the page faults to vm guests as soon as possible. There's
>> no requirement to put page requests to vIOMMU's hardware page request
>> queue at the granularity of a fault group. Thoughts?
> 
> Not sure I understand you correctly, but we can't inject partial fault
> groups: if the HW PRI queue overflows, the last fault in a group may be
> lost, so the non-last faults in that group already injected won't be
> completed (until PRGI reuse), leaking PRI request credits and guest
> resources.

Yeah, that's how vIOMMU injects the faults. On host/hypervisor side, my
understanding is that faults should be uploaded as soon as possible.

Best regards,
baolu
