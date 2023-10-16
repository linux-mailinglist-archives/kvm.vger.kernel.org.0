Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575B17CA8D0
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbjJPNGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjJPNGx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:06:53 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6C9AD
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 06:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697461611; x=1728997611;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/wMfPWUxc6xnmZ3/sCLFu2waW0a1/OqDzvcryID9nSQ=;
  b=ibz7HWQnJd0lIwIvqV21cX15v7dKKNqZ7N+T+qKLPpDiMXGoBhc48kwz
   e+LTuNGRXcCmIOJU4MyOA3I2GRVHtoDu0Ouhcpaa/7XGqx4h6KqsGxih7
   y5gZIynhu4dQC8kw9yeHGoQulNWpQ7kSyggYZuZ6cBVn/7r9KkTZJz87b
   0YWNpXmsEKy88d9jG3ZCrzPwkGar6vZruNrpnmKhsKicp4qTqx/f/edyt
   p85O9L0Vc1bp5kzL+0hSop/ly/rPWUX745dVCv8FbRN8R3k7O9rFpS1Wn
   7vrbyzGWWtnDfqdaeNzCeYsnSt8W6br06rwUjQAWJ4yeKXiFYTwWQN54k
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="365778168"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="365778168"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 06:06:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="790792620"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="790792620"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.249.171.91]) ([10.249.171.91])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 06:06:47 -0700
Message-ID: <8cdc1a89-464a-8ca5-7059-2911ed9819d4@linux.intel.com>
Date:   Mon, 16 Oct 2023 21:06:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
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
 <6859c129-7366-423c-9348-96c5fff0d3a0@linux.intel.com>
 <e7354a51-4b9e-411c-b6ff-b39a14061b9c@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <e7354a51-4b9e-411c-b6ff-b39a14061b9c@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/16 19:39, Joao Martins wrote:
>>> +    /* Device IOTLB doesn't need to be flushed in caching mode. */
>>> +    if (!cap_caching_mode(iommu->cap))
>>> +        devtlb_invalidation_with_pasid(iommu, dev, pasid);
>> For the device IOTLB invalidation, need to follow what spec requires.
>>
>>    If (pasid is RID_PASID)
>>     - Global Device-TLB invalidation to affected functions
>>    Else
>>     - PASID-based Device-TLB invalidation (with S=1 and
>>       Addr[63:12]=0x7FFFFFFF_FFFFF) to affected functions
>>
> devtlb_invalidation_with_pasid() underneath does:
> 
> 	if (pasid == PASID_RID2PASID)
> 		qi_flush_dev_iotlb(iommu, sid, pfsid, qdep, 0, 64 - VTD_PAGE_SHIFT);
> 	else
> 		qi_flush_dev_iotlb_pasid(iommu, sid, pfsid, pasid, qdep, 0, 64 - VTD_PAGE_SHIFT);
> 
> ... Which is what the spec suggests (IIUC).

Ah! I overlooked this. Sorry about it.

> Should I read your comment above as to drop the cap_caching_mode(iommu->cap) ?

No. Your code is fine.

Best regards,
baolu
