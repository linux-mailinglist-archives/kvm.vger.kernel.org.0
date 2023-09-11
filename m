Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825C279ADC4
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 01:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235830AbjIKUtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237385AbjIKMqh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 08:46:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782E210E;
        Mon, 11 Sep 2023 05:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694436392; x=1725972392;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XG3f/Go4Kskr9FPWHx1DIAciSaD0sIA1smH1YceAZ4E=;
  b=DXPDcL18Jf2M4EiM+0W6mNcnIKPagObXVag/Kzj17D//Vtik1vqRgai/
   7u/CEJaLgwlLx+OkJS1YFFLDbW8O/X2QZMjznQk1NFfpDbQ1DrqxfmJDB
   IDGgkaJiXaeLyEfUg94KopkNzqXCtg7dOmb/Wq9/VvVCyuXl3NizWImEx
   5DQ2tNA10Ln7+QMo5QttRWK+HN9k3KPUg1ri6tfmc/RrM75aPG+d9WVJy
   lGF0xSoRWROWExpm65KPof2041bJ5aTCw/WXUQ2Vk87aORj8YuT4G8pnn
   m0SjQec5y0dFl+XRiq2ywZ8Lw9zvplM1EJ9FkWAtBgbwLYLVST/RHWMuY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="409038057"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="409038057"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 05:46:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="808815482"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="808815482"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.255.28.234]) ([10.255.28.234])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 05:46:28 -0700
Message-ID: <eca39154-bc45-3c7d-88a9-b377f4d248f9@linux.intel.com>
Date:   Mon, 11 Sep 2023 20:46:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cfd9e0b8-167e-a79b-9ef1-b3bfa38c9199@linux.intel.com>
 <BN9PR11MB5276926066CC3A8FCCFD3DB08CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ed11a5c4-7256-e6ea-e94e-0dfceba6ddbf@linux.intel.com>
 <BN9PR11MB5276622C8271402487FA44708CE4A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <c9228377-0a5c-adf8-d0ef-9a791226603d@linux.intel.com>
 <BN9PR11MB52764790D53DF8AB4ED417098CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52764790D53DF8AB4ED417098CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/9/11 14:57, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Tuesday, September 5, 2023 1:24 PM
>>
>> Hi Kevin,
>>
>> I am trying to address this issue in below patch. Does it looks sane to
>> you?
>>
>> iommu: Consolidate per-device fault data management
>>
>> The per-device fault data is a data structure that is used to store
>> information about faults that occur on a device. This data is allocated
>> when IOPF is enabled on the device and freed when IOPF is disabled. The
>> data is used in the paths of iopf reporting, handling, responding, and
>> draining.
>>
>> The fault data is protected by two locks:
>>
>> - dev->iommu->lock: This lock is used to protect the allocation and
>>     freeing of the fault data.
>> - dev->iommu->fault_parameter->lock: This lock is used to protect the
>>     fault data itself.
>>
>> Improve the iopf code to enforce this lock mechanism and add a reference
>> counter in the fault data to avoid use-after-free issue.
>>
> 
> Can you elaborate the use-after-free issue and why a new user count
> is required?

I was concerned that when iommufd uses iopf, page fault report/response
may occur simultaneously with enable/disable PRI.

Currently, this is not an issue as the enable/disable PRI is in its own
path. In the future, we may discard this interface and enable PRI when
attaching the first PRI-capable domain, and disable it when detaching
the last PRI-capable domain.

> 
> btw a Fix tag is required given this mislocking issue has been there for
> quite some time...

I don't see any real issue fixed by this change. It's only a lock
refactoring after the code refactoring and preparing it for iommufd use.
Perhaps I missed anything?

Best regards,
baolu
