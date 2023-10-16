Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5F87CA83E
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 14:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbjJPMmi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 08:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233412AbjJPMmh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 08:42:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5FBE8
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 05:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697460155; x=1728996155;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kJa9LCleZSuKMx8+bUfIFtH/NjUO548v8N9SSN7TIR0=;
  b=a3tFauu7P4lmELHdPDgg3eKas2/+mjGpz3Pc8ylo+w0fiR7/qvItbUUR
   h7Mn1TbqZ4MNRhaINuU3bAD5P9Ructr7GayTIp9hceRlJ77CFXa9TXfzs
   4+DQJ0cmw2kOYtqMPbjYdVtm1pFbVZnCETbxyspkJrESpe/xQa7VVezbA
   VZYDgUqDIG2FJPtj7Qksq+fe7wMG6Jnt27tULz4nv/CJWBKvazE5Q3f5D
   OEFc/3Es82ej62FofwhHwIF2MS4VOe/UG3PbULj0yPPwBWQQxG/qCi4Ow
   p0fEJLWeD4WuHE08MtcpZf4Rgy24ko8GnsyyH2aZU3VAJgEoE+iR1JYSi
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="389374765"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="389374765"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 05:41:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10863"; a="879413581"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="879413581"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.249.171.91]) ([10.249.171.91])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 05:41:40 -0700
Message-ID: <ab9f9259-6ba5-7cdf-10d9-f0b9502ca51d@linux.intel.com>
Date:   Mon, 16 Oct 2023 20:41:38 +0800
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
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <046e8881-2fe4-45db-846e-99122d4dce86@linux.intel.com>
 <5adefd4e-d388-4c89-851b-a37f92d68e06@oracle.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <5adefd4e-d388-4c89-851b-a37f92d68e06@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/16 18:42, Joao Martins wrote:
>>> +        domain->dirty_ops = &intel_dirty_ops;
>>>        return domain;
>>>    }
>> The VT-d driver always uses second level for a user domain translation.
>> In order to avoid checks of "domain->use_first_level" in the callbacks,
>> how about check it here and return failure if first level is used for
>> user domain?
>>
> I was told by Yi Y Sun offlist to have the first_level checked, because dirty
> bit in first stage page table is always enabled (and cannot be toggled on/off).
> I can remove it again; initially RFC didn't have it as it was failing in similar
> way to how you suggest here. Not sure how to proceed?

Yi was right. But we currently have no use case for dirty tracking in
the first-level page table. So let's start from only supporting it in
the second level page table.

If we later identify a use case for dirty tracking in the first level
page table, we can then add the code with appropriate testing efforts.

Best regards,
baolu

