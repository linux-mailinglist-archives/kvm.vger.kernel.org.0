Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6FE7CA8B3
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 14:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbjJPM66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 08:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbjJPM65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 08:58:57 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7976EB
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697461135; x=1728997135;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ffpcALQCoH9BkRWnnYzvM4d/AZg18jhAvaOid/rI4DM=;
  b=JE2zi/pvcUA4vwjb9a8ZP7XOQQsflja7s6+CUgzQLnOZPO0xupeRlLwF
   r4fSc5y9hpUE991k6Hekpa6AtW4BsOrioXl1lBmbSAU/ty2S6PVD1zhUQ
   l1xkUiiJMJ7AG3ocO+PHQq5KrLENpUCOj/N8Z1tkKgIFsdkkhWkEK5/0q
   mVop4tR+Rs+oJNW/kRdG+uaQ+0t5gOFKitdN5Mzm7d1l67tiFMTgbmlCd
   MCEh9Sa6pTxsAeeXYbCE4dvn8b63jCTBEyZghQ9EbDSQvn/Yt1zTYbqUQ
   zvhRPtlGAFeU5awhfxPElJeACcUnu5JJld4dKiTdSyEMmuOmpBnc9hexy
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="471742931"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471742931"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 05:58:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="749276873"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="749276873"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.249.171.91]) ([10.249.171.91])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 05:58:44 -0700
Message-ID: <037d2917-51a2-acae-dc06-65940a054880@linux.intel.com>
Date:   Mon, 16 Oct 2023 20:58:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Cc:     baolu.lu@linux.intel.com, iommu@lists.linux.dev,
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
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <c4816f4b-3fde-4adb-901f-4d568a4fd95a@linux.intel.com>
 <764f159d-a19c-4a1d-86a6-a2791ff21e10@oracle.com>
 <20231016114210.GM3952@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231016114210.GM3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/16 19:42, Jason Gunthorpe wrote:
> On Mon, Oct 16, 2023 at 11:57:34AM +0100, Joao Martins wrote:
> 
>> True. But to be honest, I thought we weren't quite there yet in PASID support
>> from IOMMUFD perspective; hence why I didn't aim at it. Or do I have the wrong
>> impression? From the code below, it clearly looks the driver does.
> I think we should plan that this series will go before the PASID
> series

I know that PASID support in IOMMUFD is not yet available, but the VT-d
driver already supports attaching a domain to a PASID, as required by
the idxd driver for kernel DMA with PASID. Therefore, from the driver's
perspective, dirty tracking should also be enabled for PASIDs.

However, I am also fine with deferring this code until PASID support is
added to IOMMUFD. In that case, it's better to add a comment to remind
people to revisit this issue later.

Best regards,
baolu
