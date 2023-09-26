Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDDB7AE7F9
	for <lists+kvm@lfdr.de>; Tue, 26 Sep 2023 10:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbjIZI0p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Sep 2023 04:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbjIZI0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Sep 2023 04:26:44 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Sep 2023 01:26:34 PDT
Received: from mgamail.intel.com (unknown [198.175.65.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BF4B4;
        Tue, 26 Sep 2023 01:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695716794; x=1727252794;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RzaK2ndr7+vnVbIQ7VkWAWjQc7Kpbl44AZ82PRlStIo=;
  b=DxLnIcn8spYTzqVglKo5nLp3j79SeqlIvzVQCLtWb6ueGdH9lhL08r24
   wb6FTGFlVEbY58SEjaPEmFcQqLmnNd010djymCDIFkUEK7Yw1xPBEgDdL
   UsL/DQiiVeX+FnVrQvmzZgpdUq8l/4rbVB9Ut3XvUruJT5gkKlT/KrZVw
   JILb15q/h+SkUpFKiK+6VTnSvdIB4HVaPchPg0HSOncf0BYIwphkfY2gc
   P2A3yFVp2U1SinoH0GyL7DJHKp9+GHttPyHL6a4cTm5rmc3hazV4tg47/
   /FoF+jwGxgavXGwQrnR7Z6giiJjWCZCfqjD03JLTDfadxiravedSsY3aF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="160422"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="160422"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 01:25:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="995744380"
X-IronPort-AV: E=Sophos;i="6.03,177,1694761200"; 
   d="scan'208";a="995744380"
Received: from jiaqingh-mobl.ccr.corp.intel.com (HELO [10.93.22.70]) ([10.93.22.70])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 01:25:28 -0700
Message-ID: <56cc2e4e-81dd-f2d2-f690-6d82217b9e7d@intel.com>
Date:   Tue, 26 Sep 2023 16:25:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] iommu/vt-d: Introduce a rb_tree for looking up device
Content-Language: en-US
To:     Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, will@kernel.org,
        robin.murphy@arm.com, kevin.tian@intel.com,
        baolu.lu@linux.intel.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, yi.y.sun@intel.com
References: <20230821071659.123981-1-jiaqing.huang@intel.com>
 <ZRFA3uj1-QjlXpGx@8bytes.org>
From:   "Huang, Jiaqing" <jiaqing.huang@intel.com>
In-Reply-To: <ZRFA3uj1-QjlXpGx@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RDNS_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/25/2023 4:12 PM, Joerg Roedel wrote:

> On Mon, Aug 21, 2023 at 12:16:59AM -0700, Huang Jiaqing wrote:
>> The existing IO page fault handler locates the PCI device by calling
>> pci_get_domain_bus_and_slot(), which searches the list of all PCI
>> devices until the desired PCI device is found. This is inefficient
>> because the algorithm efficiency of searching a list is O(n). In the
>> critical path of handling an IO page fault, this can cause a significant
>> performance bottleneck.
> Can you elaborate a little more on the 'significant performance
> bottleneck' part? Where do you see this as a problem?
>
> Regards,
>
> 	Joerg
While lots of dsa devices were enabled, parallel dsa_test with large 
transfer size
would be executed ineffciently and cause cpu stuck in 
pci_get_domain_bus_and_slot
by lock competition. The introduced patch could significantly improve 
the speed and
prevent the CPU from getting sutck. It maybe confusing for "significant 
performance
bottleneck" since it didn't benefit all the cases, would rephase it in 
the new patch. Thanks!

BRs,
Jiaqing
