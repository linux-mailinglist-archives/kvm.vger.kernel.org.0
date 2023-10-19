Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A96B7CEDB2
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 03:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjJSBtM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 21:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSBtL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 21:49:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D4E9F
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 18:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697680150; x=1729216150;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=agPyMKfKXNrTWaZ39rFKgn0cJ6sTEBJIiI0nmmv1Vos=;
  b=T5/uU4uKTirxFbyRTfbXNFuuu3ktfTq8nHZkLrY65iwFCTVNMI2UjAid
   rg3yKKSA7Ln1FYs5s6kBqPaGwVMThMQ4GAOVzT4fUh/6MoylFjjlQcpX+
   xfrxgezyLEmI56+yOW9CBiHr8/yQ6LGbegeLxmQNXOzxIU0EvvzBW81GZ
   GZRGFMlVogo9Gk9t5YvI7g8Z2iBFA1jN601Tz2sqRyt9D4xYzwE1OvWnd
   ej/1FcmoxmXBO/TlVQKdl+c0VSpp2PBRhxJJBliwMgmgITrxholBUGo7E
   jPDegJQ9SYWiKC0Yrxr9pziBoMFkeJ+dqvRSNjqK5tXOh88njsaVu0E6J
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="4746162"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="4746162"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 18:49:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10867"; a="706679301"
X-IronPort-AV: E=Sophos;i="6.03,236,1694761200"; 
   d="scan'208";a="706679301"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by orsmga003.jf.intel.com with ESMTP; 18 Oct 2023 18:49:05 -0700
Message-ID: <de816c4d-98a4-4af2-8940-c4508d442e61@linux.intel.com>
Date:   Thu, 19 Oct 2023 09:45:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc:     baolu.lu@linux.intel.com, Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 04/18] iommu: Add iommu_domain ops for dirty tracking
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-5-joao.m.martins@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231018202715.69734-5-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/23 4:27 AM, Joao Martins wrote:
> Add to iommu domain operations a set of callbacks to perform dirty
> tracking, particulary to start and stop tracking and to read and clear the
> dirty data.
> 
> Drivers are generally expected to dynamically change its translation
> structures to toggle the tracking and flush some form of control state
> structure that stands in the IOVA translation path. Though it's not
> mandatory, as drivers can also enable dirty tracking at boot, and just
> clear the dirty bits before setting dirty tracking. For each of the newly
> added IOMMU core APIs:
> 
> iommu_cap::IOMMU_CAP_DIRTY: new device iommu_capable value when probing for
> capabilities of the device.
> 
> .set_dirty_tracking(): an iommu driver is expected to change its
> translation structures and enable dirty tracking for the devices in the
> iommu_domain. For drivers making dirty tracking always-enabled, it should
> just return 0.
> 
> .read_and_clear_dirty(): an iommu driver is expected to walk the pagetables
> for the iova range passed in and use iommu_dirty_bitmap_record() to record
> dirty info per IOVA. When detecting that a given IOVA is dirty it should
> also clear its dirty state from the PTE, *unless* the flag
> IOMMU_DIRTY_NO_CLEAR is passed in -- flushing is steered from the caller of
> the domain_op via iotlb_gather. The iommu core APIs use the same data
> structure in use for dirty tracking for VFIO device dirty (struct
> iova_bitmap) abstracted by iommu_dirty_bitmap_record() helper function.
> 
> domain::dirty_ops: IOMMU domains will store the dirty ops depending on
> whether the iommu device supports dirty tracking or not. iommu drivers can
> then use this field to figure if the dirty tracking is supported+enforced
> on attach. The enforcement is enable via domain_alloc_user() which is done
> via IOMMUFD hwpt flag introduced later.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   include/linux/io-pgtable.h |  4 +++
>   include/linux/iommu.h      | 56 ++++++++++++++++++++++++++++++++++++++
>   2 files changed, 60 insertions(+)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
