Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420D57CB840
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 04:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjJQCMl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 22:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjJQCMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 22:12:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FC99B
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 19:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697508758; x=1729044758;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9r7TvSUocLpq3Lg382G+iJaeI1HhRtaUjULozWB9NEI=;
  b=OzOFCE5Gjl6cxOxJ6rL960UkympeGP2cYwq4HM0KVtQ8nf77YoJ9x4Fx
   pSq7Ck7n3UZUY6+lD5oUgmy3bhKCXbx8Z4XsLfqSh9CU1xoKUmQgzzHvs
   kfILADkleQsV0FPXDYItBWmtnfcnzMmN/kuQlGQURpofCphzxFd2h4MiT
   0IYw3xP5kKWYxATHkYToNwBuS/3Czj3Ye+Y1bCRHKiA+zkydrTjzmRQJX
   lh85OhWrtQXYc0QQRsHb7u8eJXfKZmvxAPkYpNTxF7pOGVVpo65ASphRh
   ovVPCuGLpFLI4DK8I+RMh7Cu6OjoxActcWGloBI/HM3XIRpo7Dr1Lbxt6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="384556008"
X-IronPort-AV: E=Sophos;i="6.03,230,1694761200"; 
   d="scan'208";a="384556008"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 19:12:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,230,1694761200"; 
   d="scan'208";a="3884179"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmviesa001.fm.intel.com with ESMTP; 16 Oct 2023 19:12:40 -0700
Message-ID: <a83cb9a7-88de-41af-8ef0-1e739eab12c2@linux.intel.com>
Date:   Tue, 17 Oct 2023 10:08:55 +0800
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <d8553024-b880-42db-9f1f-8d2d3591469c@linux.intel.com>
 <83f9e278-8249-4f10-8542-031260d43c4c@oracle.com>
 <10bb7484-baaf-4d32-b40d-790f56267489@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <10bb7484-baaf-4d32-b40d-790f56267489@oracle.com>
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

On 10/17/23 12:00 AM, Joao Martins wrote:
>>> The iommu_dirty_bitmap is defined in iommu core. The iommu driver has no
>>> need to understand it and check its member anyway.
>>>
>> (...) The iommu driver has no need to understand it. iommu_dirty_bitmap_record()
>> already makes those checks in case there's no iova_bitmap to set bits to.
>>
> This is all true but the reason I am checking iommu_dirty_bitmap::bitmap is to
> essentially not record anything in the iova bitmap and just clear the dirty bits
> from the IOPTEs, all when dirty tracking is technically disabled. This is done
> internally only when starting dirty tracking, and thus to ensure that we cleanup
> all dirty bits before we enable dirty tracking to have a consistent snapshot as
> opposed to inheriting dirties from the past.

It's okay since it serves a functional purpose. Can you please add some
comments around the code to explain the rationale.

Best regards,
baolu
