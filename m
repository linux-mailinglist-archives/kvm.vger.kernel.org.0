Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31E7E7AD109
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 09:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232347AbjIYHFJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 03:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjIYHFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 03:05:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393A7BF
        for <kvm@vger.kernel.org>; Mon, 25 Sep 2023 00:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695625501; x=1727161501;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZXbuRP8uMF/FtXUwmfeiGGp0N6qyFJYfMlraGoFbES4=;
  b=Ga1QTlWKFRa1iVpTtg6XmhcLEb6D6ZrkqyObEGPBcQv+DXeqiotHz03O
   hiwjPL8XVmFSBOXo4QwiiplpOVZAgjJShIZiLe42VK8kAS4dM53hPx3V2
   V1Khf+7GNvkULZMr0Pk5XpQV6+bh/agNoZvc6OjEESJkKyR9nhmNv0wOb
   TLI+lYg20QIQ8sRzcB/BLdNcwc0HnoKX/ecevd70Zws7Xz7GYqrbER9cV
   94GAJUvzCQ/FYLw9d0zxkNBJjzjYbsPLIbP+mzzfzsQj318a88P6pAKUq
   S6IblwwtTjhZg6jmW6tQg+p+XQaR+1xVxMO1fYFkn21Nul+jLl1Z6APKJ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="366242404"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="366242404"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 00:04:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="838485062"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="838485062"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by FMSMGA003.fm.intel.com with ESMTP; 25 Sep 2023 00:04:31 -0700
Message-ID: <32ad48e2-0aa5-2c26-4e75-16e7b1460b37@linux.intel.com>
Date:   Mon, 25 Sep 2023 15:01:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20230923012511.10379-20-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/23/23 9:25 AM, Joao Martins wrote:
> IOMMU advertises Access/Dirty bits for second-stage page table if the
> extended capability DMAR register reports it (ECAP, mnemonic ECAP.SSADS).
> The first stage table is compatible with CPU page table thus A/D bits are
> implicitly supported. Relevant Intel IOMMU SDM ref for first stage table
> "3.6.2 Accessed, Extended Accessed, and Dirty Flags" and second stage table
> "3.7.2 Accessed and Dirty Flags".
> 
> First stage page table is enabled by default so it's allowed to set dirty
> tracking and no control bits needed, it just returns 0. To use SSADS, set
> bit 9 (SSADE) in the scalable-mode PASID table entry and flush the IOTLB
> via pasid_flush_caches() following the manual. Relevant SDM refs:
> 
> "3.7.2 Accessed and Dirty Flags"
> "6.5.3.3 Guidance to Software for Invalidations,
>   Table 23. Guidance to Software for Invalidations"
> 
> PTE dirty bit is located in bit 9 and it's cached in the IOTLB so flush
> IOTLB to make sure IOMMU attempts to set the dirty bit again. Note that
> iommu_dirty_bitmap_record() will add the IOVA to iotlb_gather and thus
> the caller of the iommu op will flush the IOTLB. Relevant manuals over
> the hardware translation is chapter 6 with some special mention to:
> 
> "6.2.3.1 Scalable-Mode PASID-Table Entry Programming Considerations"
> "6.2.4 IOTLB"
> 
> Signed-off-by: Joao Martins<joao.m.martins@oracle.com>
> ---
> The IOPTE walker is still a bit inneficient. Making sure the UAPI/IOMMUFD is
> solid and agreed upon.
> ---
>   drivers/iommu/intel/iommu.c | 94 +++++++++++++++++++++++++++++++++++++
>   drivers/iommu/intel/iommu.h | 15 ++++++
>   drivers/iommu/intel/pasid.c | 94 +++++++++++++++++++++++++++++++++++++
>   drivers/iommu/intel/pasid.h |  4 ++
>   4 files changed, 207 insertions(+)

The code is probably incomplete. When attaching a domain to a device,
check the domain's dirty tracking capability against the device's
capabilities. If the domain's dirty tracking capability is set but the
device does not support it, the attach callback should return -EINVAL.

Best regards,
baolu
