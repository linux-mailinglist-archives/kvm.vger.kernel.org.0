Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6BA76F865
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 05:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbjHDD3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 23:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbjHDD24 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 23:28:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB3D4683;
        Thu,  3 Aug 2023 20:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691119725; x=1722655725;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hlHNuoRdEe2YIyLpE1StOcVDQ8E30zW8HoVrh6pz52g=;
  b=j0nVTliwSksWwZ/g0S36InoRK4fH3JEHCNVHkz9XJs0HxeqPVU+oBaJN
   N3+ZNT4e1ui8IOqNU+N5eFF+Y1rukWdVjHd1GE/eg42J4T0+6wCBoch43
   lI2KonJp27zyqhnxcCCaMfQffAvPmRwE6UF2eHkhJC0R75qBs1yu3NCsF
   XB4F04RJTgl2t/F703ZPw9NswbsL642T0gsR24lB/+Hp1cmOKgzZoJQUR
   co++BovdcIPaNFZGwMPmN43C7cYSwTFykNZVbWvzF+oSo42We/UNKuRFc
   gCTAPQkzy1UQ2/NzDyesvj8blZm8pKZaNNFniXpUx2BYJsmEwHn0+VFL/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="433906636"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="433906636"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:28:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="843878729"
X-IronPort-AV: E=Sophos;i="6.01,254,1684825200"; 
   d="scan'208";a="843878729"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.210.88]) ([10.254.210.88])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 20:28:21 -0700
Message-ID: <bb2cb2e8-4654-e866-f7f0-57130c6ac630@linux.intel.com>
Date:   Fri, 4 Aug 2023 11:28:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 09/12] iommu: Move iopf_handler() to iommu-sva.c
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-10-baolu.lu@linux.intel.com>
 <BN9PR11MB527611063D3B88224AB769B48C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB527611063D3B88224AB769B48C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/3 16:21, Tian, Kevin wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>> Sent: Thursday, July 27, 2023 1:49 PM
>>
>> @@ -219,3 +219,52 @@ void mm_pasid_drop(struct mm_struct *mm)
>>
>>   	ida_free(&iommu_global_pasid_ida, mm->pasid);
>>   }
>> +
>> +static int iopf_complete_group(struct device *dev, struct iopf_fault *iopf,
>> +			       enum iommu_page_response_code status)
> 
> iommu_sva_complete_iopf()
> 
>> +
>> +static void iopf_handler(struct work_struct *work)
>> +{
> 
> iommu_sva_iopf_handler()
> 

Ack to both.

Best regards,
baolu
