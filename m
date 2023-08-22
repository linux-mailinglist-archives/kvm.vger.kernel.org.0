Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073C6783AF4
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 09:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbjHVHci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 03:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbjHVHch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 03:32:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E4A133;
        Tue, 22 Aug 2023 00:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692689556; x=1724225556;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2WDGroCf9hVRdMg3TmwFYLJHYRQhPfk99Hlw9ivghVQ=;
  b=I63MPDUfeXXWJENVAhs+7ue/zYBsxlwRsKGIN5FlOqDB8Hqch00l4f1S
   vE5BM3yt9kChiB+53Go8cTQJyDpe399WUSFilNpHRVxk7Le4VpgxQTAo7
   5Hr3VVYWak/akY7Z+MVBoxjCq9HNq9QyfJ6xyteJuhzIIiTP6DCxCdw4f
   D4y33zo1fLbKro0B8oIPEolalDpiJbdTfuzT0VMb51H3+9Mj9xvhIi6aq
   2vSMnISpAXBNTmU1Hk34h2jWgJpkW/84duv4PdQ53UvXcNYIGhgVlQlgV
   mC47kcC/UkViEW94NYSWEiEvMvZUNgrMq3ggsuQjqbaTwNVHsMZ71lqYp
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="376540902"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="376540902"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 00:32:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10809"; a="685944607"
X-IronPort-AV: E=Sophos;i="6.01,192,1684825200"; 
   d="scan'208";a="685944607"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.189.107]) ([10.252.189.107])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 00:32:30 -0700
Message-ID: <fe03b53a-c9f9-cc6b-a1fd-d6fd2f1a1ddc@linux.intel.com>
Date:   Tue, 22 Aug 2023 15:32:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Cc:     baolu.lu@linux.intel.com, kvm@vger.kernel.org,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
        kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com
Subject: Re: [PATCH] iommu/vt-d: Introduce a rb_tree for looking up device
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Huang Jiaqing <jiaqing.huang@intel.com>
References: <20230821071659.123981-1-jiaqing.huang@intel.com>
 <ZOOWMUmwG2jXOaXL@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZOOWMUmwG2jXOaXL@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/22 0:52, Jason Gunthorpe wrote:
> On Mon, Aug 21, 2023 at 12:16:59AM -0700, Huang Jiaqing wrote:
>> The existing IO page fault handler locates the PCI device by calling
>> pci_get_domain_bus_and_slot(), which searches the list of all PCI
>> devices until the desired PCI device is found. This is inefficient
>> because the algorithm efficiency of searching a list is O(n). In the
>> critical path of handling an IO page fault, this can cause a significant
>> performance bottleneck.
>>
>> To improve the performance of the IO page fault handler, replace
>> pci_get_domain_bus_and_slot() with a local red-black tree. A red-black
>> tree is a self-balancing binary search tree, which means that the
>> average time complexity of searching a red-black tree is O(log(n)). This
>> is significantly faster than O(n), so it can significantly improve the
>> performance of the IO page fault handler.
>>
>> In addition, we can only insert the affected devices (those that have IO
>> page fault enabled) into the red-black tree. This can further improve
>> the performance of the IO page fault handler.
>>
>> Signed-off-by: Huang Jiaqing<jiaqing.huang@intel.com>
>> ---
>>   drivers/iommu/intel/iommu.c | 68 +++++++++++++++++++++++++++++++++++++
>>   drivers/iommu/intel/iommu.h |  8 +++++
>>   drivers/iommu/intel/svm.c   | 13 +++----
>>   3 files changed, 81 insertions(+), 8 deletions(-)
> I feel like this should be a helper library provided by the core
> code, doesn't every PRI driver basically need the same thing?

It seems to be. pci_get_domain_bus_and_slot() is also used in the amd
driver. And the risc-v iommu driver under discussion is also proposing
this.

Best regards,
baolu
