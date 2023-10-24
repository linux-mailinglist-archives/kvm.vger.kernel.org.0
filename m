Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB4F7D4F4E
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 13:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233000AbjJXL67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 07:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbjJXL66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 07:58:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B2510C3;
        Tue, 24 Oct 2023 04:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698148736; x=1729684736;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pnGRnp7vVwZkr643r1FTOWjeVjSHpkg1wCabNnnRz1c=;
  b=eI42qC9xxW9le2qbJRZ68okZz0idtCni5i7vydUlNQZm+kYz+C34fYKh
   OImE1KOxrAj7HpFl3HevNGdf2ljq6hsy0Z2xLwaCbCqgqQcEgPIfxojb7
   IDdEVEk3uy1Rjo50oQXP1iYtMOmXPyP9ogiqw+fCx4heJ0/2x5AhCdoit
   bpzldo6yFgLA8avObmgZsGnSXQhTxaoTvzRmZCQn4uQW7tTMw8ZP5b7Dj
   +AgpEZVN8o75uwjMgK38xIYEy/DdrbWsuibw9SfZwyECOyd4Nwvf9KOt2
   vihzYlZhFfF4KPe7pSp033Ywj+lnjuv4r9qxMloN0UYzoF5TQOJgkD1we
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="384239196"
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="384239196"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 04:58:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,247,1694761200"; 
   d="scan'208";a="6153680"
Received: from qiangfu1-mobl1.ccr.corp.intel.com (HELO [10.254.212.47]) ([10.254.212.47])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 04:57:35 -0700
Message-ID: <5a4c169d-8e42-4609-87db-8b68f04bb0fe@linux.intel.com>
Date:   Tue, 24 Oct 2023 19:58:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc:     baolu.lu@linux.intel.com, jacob.jun.pan@linux.intel.com,
        kevin.tian@intel.com, yi.y.sun@intel.com, kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] iommu: Introduce a rb_tree for looking up device
Content-Language: en-US
To:     Huang Jiaqing <jiaqing.huang@intel.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux.dev
References: <20231024084124.11155-1-jiaqing.huang@intel.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231024084124.11155-1-jiaqing.huang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/24 16:41, Huang Jiaqing wrote:
> The existing IO page fault handler locates the PCI device by calling
> pci_get_domain_bus_and_slot(), which searches the list of all PCI
> devices until the desired PCI device is found. This is inefficient
> because the algorithm efficiency of searching a list is O(n). In the
> critical path of handling an IO page fault, this is not performance
> friendly given that I/O page fault handling patch is performance
> critical, and parallel heavy dsa_test may cause cpu stuck due to
> the low efficiency and lock competition in current path.
> 
> To improve the performance of the IO page fault handler, replace
> pci_get_domain_bus_and_slot() with a local red-black tree. A red-black
> tree is a self-balancing binary search tree, which means that the
> average time complexity of searching a red-black tree is O(log(n)). This
> is significantly faster than O(n), so it can significantly improve the
> performance of the IO page fault handler.
> 
> In addition, we can only insert the affected devices (those that have IO
> page fault enabled) into the red-black tree. This can further improve
> the performance of the IO page fault handler.
> 
> This series depends on "deliver page faults to user space" patch-set:
> https://lore.kernel.org/linux-iommu/20230928042734.16134-1-baolu.lu@linux.intel.com/

The note above is not part of the commit message, and should be placed
below the tear line or in the cover letter, if there is one.

> 
> Signed-off-by: Huang Jiaqing <jiaqing.huang@intel.com>
> ---
>   drivers/iommu/io-pgfault.c | 104 ++++++++++++++++++++++++++++++++++++-
>   include/linux/iommu.h      |  16 ++++++
>   2 files changed, 118 insertions(+), 2 deletions(-)

Best regards,
baolu
