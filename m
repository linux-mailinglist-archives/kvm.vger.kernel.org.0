Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7093676F7C6
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 04:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233728AbjHDCVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 22:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbjHDCU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 22:20:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FF84C00;
        Thu,  3 Aug 2023 19:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691115634; x=1722651634;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8RVBndkshGnvHV5Z1uI2lfdqXRdUsjPzvSMKu45GOx8=;
  b=BE58ooKKb3UA43QiNRrMs/0ypd7WyDmrm6i8Uo1tDk1K1WFxAlYNiQFK
   We3ErcdBcTTgR19hPULAxHwXTtx9wbDQ83h8gWAgweE5ozKZttdHGuFBY
   Ewt8ZAbb6udOVvDQU5IclRmv+QvHjy2lxKUB3DCv+agdMpWWvm3SdBUnh
   kRhcqB/OpEdwoPdLMe/vKxTAkl9yxQd2SWqsOq484b1eP5Nwgb9hOagdT
   2JHYFDB3e2efPHl+yyAS0gGx3Ai0awOpjrdUQIsjPz9Loi4C6bbFp8HwO
   M9kHAuwgU1rUFoiWw/KFB7y5etMCuDrOyCYJIuUGH2uqAZa/kms6buPtS
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10791"; a="456416916"
X-IronPort-AV: E=Sophos;i="6.01,253,1684825200"; 
   d="scan'208";a="456416916"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 19:20:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="873178606"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.210.88]) ([10.254.210.88])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 19:20:32 -0700
Message-ID: <15c6f634-f00a-dfa7-9759-161ec201460a@linux.intel.com>
Date:   Fri, 4 Aug 2023 10:20:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] iommu: Make pasid array per device
Content-Language: en-US
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>
References: <20230801063125.34995-1-baolu.lu@linux.intel.com>
 <ZMplBfgSb8Hh9jLt@ziepe.ca>
 <BN9PR11MB527649D7E79E29291DA1A5538C08A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZMvFR52o86upAVrp@ziepe.ca>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZMvFR52o86upAVrp@ziepe.ca>
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

On 2023/8/3 23:18, Jason Gunthorpe wrote:
> On Thu, Aug 03, 2023 at 12:44:03AM +0000, Tian, Kevin wrote:
>>> From: Jason Gunthorpe<jgg@ziepe.ca>
>>> Sent: Wednesday, August 2, 2023 10:16 PM
>>>
>>> On Tue, Aug 01, 2023 at 02:31:23PM +0800, Lu Baolu wrote:
>>>> The PCI PASID enabling interface guarantees that the address space used
>>>> by each PASID is unique. This is achieved by checking that the PCI ACS
>>>> path is enabled for the device. If the path is not enabled, then the
>>>> PASID feature cannot be used.
>>>>
>>>>      if (!pci_acs_path_enabled(pdev, NULL, PCI_ACS_RR | PCI_ACS_UF))
>>>>              return -EINVAL;
>>>>
>>>> The PASID array is not an attribute of the IOMMU group. It is more
>>>> natural to store the PASID array in the per-device IOMMU data. This
>>>> makes the code clearer and easier to understand. No functional changes
>>>> are intended.
>>> Is there a reason to do this?
>>>
>>> *PCI*  requires the ACS/etc because PCI kind of messed up how switches
>>> handled PASID so PASID doesn't work otherwise.
>>>
>>> But there is nothing that says other bus type can't have working
>>> (non-PCI) PASID and still have device isolation issues.
>>>
>>> So unless there is a really strong reason to do this we should keep
>>> the PASID list in the group just like the domain.
>>>
>> this comes from the consensus in [1].
>>
>> [1]https://lore.kernel.org/linux-iommu/ZAcyEzN4102gPsWC@nvidia.com/
> That consensus was that we don't have PASID support if there is
> multi-device groups, at least in iommufd.. That makes sense. If we
> want to change the core code to enforce this that also makes sense

In my initial plan, I had a third patch that would have enforced single-
device groups for PASID interfaces in the core. But I ultimately dropped
it because it is the fact for PCI devices, but I am not sure about other
buses although perhaps there is none.

> But this series is just moving the array?

So I took the first step by moving the pasid_array from iommu group to
the device. :-)

Best regards,
baolu
