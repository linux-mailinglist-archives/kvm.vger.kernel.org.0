Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844FF7CC35F
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 14:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbjJQMlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 08:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjJQMlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 08:41:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B2983
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 05:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697546503; x=1729082503;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=42W1DWisqwY/voZkLD/Tsqnrh5mqzwZYW48wLNWNwLE=;
  b=RVSZfqbhts+Uc+ynRTJl3+imqt43+iv8UJP3B8Fs3O1xiyvSzvePM0Td
   4SZQbzgmL1YwtXcSGKU5f77IlgQKcy4UGAIaEwxudHP5QCNDQNh9Pp38c
   8nbJblQO0WKF1hAFBBeEABtbnpAastxG7vZZmbXJb5WhiDo382nF8BC7l
   sf7fObsdy4Hed4NJH7x9AgOeYd2EsyA6UwM9Jx5RF5aTiy8Pe5dUVO5+n
   +Gsmgu2Lv9BC+WKRcUzPUzqftvl2yFg52l6KIXgDEupYpUGjqPGdrO0KZ
   UjnUl+xw4wb9XASio/DbjVg3+4yqEb49wxY/0mewXrQXCaeoCcYKifzt/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="366031621"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="366031621"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 05:41:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="826426253"
X-IronPort-AV: E=Sophos;i="6.03,232,1694761200"; 
   d="scan'208";a="826426253"
Received: from wangxue2-mobl.ccr.corp.intel.com (HELO [10.254.212.22]) ([10.254.212.22])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2023 05:41:39 -0700
Message-ID: <81bd3937-482c-23be-840f-6766ca0ec65d@linux.intel.com>
Date:   Tue, 17 Oct 2023 20:41:37 +0800
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
To:     Joao Martins <joao.m.martins@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <c4816f4b-3fde-4adb-901f-4d568a4fd95a@linux.intel.com>
 <764f159d-a19c-4a1d-86a6-a2791ff21e10@oracle.com>
 <20231016114210.GM3952@nvidia.com>
 <037d2917-51a2-acae-dc06-65940a054880@linux.intel.com>
 <20231016125941.GT3952@nvidia.com>
 <3e30e72a-c1c6-55a6-8e52-6a6250d2d8de@linux.intel.com>
 <4cc0c4a0-3c00-4b29-a43b-ddfc57f2e4c0@oracle.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <4cc0c4a0-3c00-4b29-a43b-ddfc57f2e4c0@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/17 18:51, Joao Martins wrote:
> On 16/10/2023 14:01, Baolu Lu wrote:
>> On 2023/10/16 20:59, Jason Gunthorpe wrote:
>>> On Mon, Oct 16, 2023 at 08:58:42PM +0800, Baolu Lu wrote:
>>>> On 2023/10/16 19:42, Jason Gunthorpe wrote:
>>>>> On Mon, Oct 16, 2023 at 11:57:34AM +0100, Joao Martins wrote:
>>>>>
>>>>>> True. But to be honest, I thought we weren't quite there yet in PASID support
>>>>>> from IOMMUFD perspective; hence why I didn't aim at it. Or do I have the wrong
>>>>>> impression? From the code below, it clearly looks the driver does.
>>>>> I think we should plan that this series will go before the PASID
>>>>> series
>>>> I know that PASID support in IOMMUFD is not yet available, but the VT-d
>>>> driver already supports attaching a domain to a PASID, as required by
>>>> the idxd driver for kernel DMA with PASID. Therefore, from the driver's
>>>> perspective, dirty tracking should also be enabled for PASIDs.
>>> As long as the driver refuses to attach a dirty track enabled domain
>>> to PASID it would be fine for now.
>> Yes. This works.
> Baolu Lu, I am blocking PASID attachment this way; let me know if this matches
> how would you have the driver refuse dirty tracking on PASID.

Joao, how about blocking pasid attachment in intel_iommu_set_dev_pasid()
directly?

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index c86ba5a3e75c..392b6ca9ce90 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4783,6 +4783,9 @@ static int intel_iommu_set_dev_pasid(struct 
iommu_domain *domain,
         if (context_copied(iommu, info->bus, info->devfn))
                 return -EBUSY;

+       if (domain->dirty_ops)
+               return -EOPNOTSUPP;
+
         ret = prepare_domain_attach_device(domain, dev);
         if (ret)
                 return ret;

Best regards,
baolu
