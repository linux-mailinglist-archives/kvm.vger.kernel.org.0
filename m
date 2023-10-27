Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720D17D8E70
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 08:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbjJ0GIN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 02:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjJ0GIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 02:08:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8BCA1B5;
        Thu, 26 Oct 2023 23:08:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698386888; x=1729922888;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MfNBA+R8W2olLLNj9+ipO5U4qZClWyZHkbwLz8wq2w0=;
  b=hGnV1y6Z1XmWE6ad9GU1qA9NPcFQ7oNTFR7xK6N7R4m+NDnueUKFhvq/
   d/NJ4sSpAzNLRI2EoM/xMmEFHchla1HI47lF491nsBbxOxJlDaY4Qab2k
   hwYnfNQCFf5CamhqpvOkGASvjaaLgPPajoAbSgzP+KWfXGPJhOrGZxay0
   Uw0g1FR+sKIjO1mdm62dpAcho4Xo79xBH7rIOC3zmVdhNsUyIB0Ycb4OM
   9cr8Y1myGwHamQZ3MFeF2Hzh/nVKhsqriez/UgOI/VJSDVMdK57iqrdoe
   GYjwyu2gBu0eTyaci1R1rz6EWcDbUyDhJLzG4A+nl1TgwvOltqk+lhJ3r
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="418823614"
X-IronPort-AV: E=Sophos;i="6.03,255,1694761200"; 
   d="scan'208";a="418823614"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 23:08:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,255,1694761200"; 
   d="scan'208";a="707978"
Received: from jiaqingh-mobl.ccr.corp.intel.com (HELO [10.93.11.63]) ([10.93.11.63])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 23:07:29 -0700
Message-ID: <2f1ed1eb-6ac3-4af9-b328-5b62c38459a8@intel.com>
Date:   Fri, 27 Oct 2023 14:08:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] iommu/vt-d: Adopt new helper for looking up pci
 device
To:     Baolu Lu <baolu.lu@linux.intel.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux.dev
Cc:     jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org
References: <20231024084124.11155-1-jiaqing.huang@intel.com>
 <20231024084124.11155-2-jiaqing.huang@intel.com>
 <b53672fe-cad4-4aa7-94ef-59895892b75a@linux.intel.com>
Content-Language: en-US
From:   "Huang, Jiaqing" <jiaqing.huang@intel.com>
In-Reply-To: <b53672fe-cad4-4aa7-94ef-59895892b75a@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/24/2023 8:01 PM, Baolu Lu wrote:

> On 2023/10/24 16:41, Huang Jiaqing wrote:
>> Adopt the new iopf_queue_find_pdev func() to look up PCI device
>> for better efficiency and avoid the CPU stuck issue with parallel
>> heavy dsa_test.
>>
>> Signed-off-by: Huang Jiaqing <jiaqing.huang@intel.com>
>> ---
>>   drivers/iommu/intel/svm.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
>> index 659de9c16024..0f1018b76557 100644
>> --- a/drivers/iommu/intel/svm.c
>> +++ b/drivers/iommu/intel/svm.c
>> @@ -672,7 +672,7 @@ static irqreturn_t prq_event_thread(int irq, void
>> *d)
>>           if (unlikely(req->lpig && !req->rd_req && !req->wr_req))
>>               goto prq_advance;
>>   -        pdev = pci_get_domain_bus_and_slot(iommu->segment,
>> +        pdev = iopf_queue_find_pdev(iommu->iopf_queue,
>>                              PCI_BUS_NUM(req->rid),
>>                              req->rid & 0xff);
>
> Minor: align the new line with the left parenthesis.

Got it, will fix it, thanks for catching!

BRs,
Jiaqing
