Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906857D8E78
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 08:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbjJ0GJR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 02:09:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjJ0GJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 02:09:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EB41B2;
        Thu, 26 Oct 2023 23:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698386954; x=1729922954;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+DrVyO/lmmzNiD355grMg157EiJ4H0MKLPJHIYM0VSM=;
  b=Hekwgo6jRGDrzcq2saqRM+zqvUIqGMPoYzpyIbMmqbpVLIgLeWr1H5nr
   pneDqZWAWgR/r6D5BxyPFCRNB0tlu+CDx+k/0mvOBusG46FR7rX9IQelS
   FS3D1zLWTuVU9wJ55oDA62BLVaDJeaZXbYAfC7XmoCQtcX4nV50xljYLV
   yhs0aDd961PgIKs4vrp8iV6XkI0+yIGrm/wS5aDe+Lta26qzT0jD1wv5Q
   CxWEWNOkZjFV/+tWedHMKCY4Pl8PRCaeruxzQPEMR2ITfgS7Nwd65TzBr
   YgBsctdovK7a2+zU7M0goKeJUtRUugRR5SN6K4NI6A0NYve70ytf1Xxme
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="418823669"
X-IronPort-AV: E=Sophos;i="6.03,255,1694761200"; 
   d="scan'208";a="418823669"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 23:09:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,255,1694761200"; 
   d="scan'208";a="708126"
Received: from jiaqingh-mobl.ccr.corp.intel.com (HELO [10.93.11.63]) ([10.93.11.63])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 23:08:35 -0700
Message-ID: <bf2dbc64-a6b6-4763-b497-80f0f1675366@intel.com>
Date:   Fri, 27 Oct 2023 14:09:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] iommu: Introduce a rb_tree for looking up device
Content-Language: en-US
To:     Baolu Lu <baolu.lu@linux.intel.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux.dev
Cc:     jacob.jun.pan@linux.intel.com, kevin.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org
References: <20231024084124.11155-1-jiaqing.huang@intel.com>
 <5a4c169d-8e42-4609-87db-8b68f04bb0fe@linux.intel.com>
From:   "Huang, Jiaqing" <jiaqing.huang@intel.com>
In-Reply-To: <5a4c169d-8e42-4609-87db-8b68f04bb0fe@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
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

On 10/24/2023 7:58 PM, Baolu Lu wrote:

> On 2023/10/24 16:41, Huang Jiaqing wrote:
>> The existing IO page fault handler locates the PCI device by calling
>> pci_get_domain_bus_and_slot(), which searches the list of all PCI
>> devices until the desired PCI device is found. This is inefficient
>> because the algorithm efficiency of searching a list is O(n). In the
>> critical path of handling an IO page fault, this is not performance
>> friendly given that I/O page fault handling patch is performance
>> critical, and parallel heavy dsa_test may cause cpu stuck due to
>> the low efficiency and lock competition in current path.
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
>> This series depends on "deliver page faults to user space" patch-set:
>> https://lore.kernel.org/linux-iommu/20230928042734.16134-1-baolu.lu@linux.intel.com/
>>
>
> The note above is not part of the commit message, and should be placed
> below the tear line or in the cover letter, if there is one.

Will fix, thanks for catching!

BRs,
Jiaqing
