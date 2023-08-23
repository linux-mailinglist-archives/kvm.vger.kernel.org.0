Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD379784E1E
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 03:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjHWBYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Aug 2023 21:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjHWBYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Aug 2023 21:24:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6515BCFF;
        Tue, 22 Aug 2023 18:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692753853; x=1724289853;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q0BAVsMWcTSrvSbD3t5HhjUKbzro+4+pJwfTYyBr0KQ=;
  b=ags29oKkgyeHzDmMDC63s1B8y+PoTQbAaWWaYyk/ormVbe50YITSnnhE
   ysuAsAEr8HoGEzYuLlKQ/nkJIA3BbYHMd/kXAgC6sUnV5JvxbqzmV2Q2l
   agK/VoA1RSKkm3GQnDUHuV3sSyFLvAhbR2fwV5Sun9EoEuXG3u1sf7j+h
   0NUEwpQF7MG3Jpd4VffhPpyLVAxIi71EIlQ4vHaWSMGAdZNXLGOISj1d4
   5RsU+4q9IjWzakSiqJ+qgb3PzkuRGx7zgv2rRNmwB64qev6H+5tB5tz9R
   nZl5wgwyVlW1JUaod2vSh7BR6p8je3UjmmZpFsWqhAdNkfQQgTQdYdffp
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="354367102"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="354367102"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 18:24:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10810"; a="771542173"
X-IronPort-AV: E=Sophos;i="6.01,194,1684825200"; 
   d="scan'208";a="771542173"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.189.105]) ([10.252.189.105])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2023 18:24:07 -0700
Message-ID: <c0c89983-cba4-1cb0-1cb5-9aae217da318@linux.intel.com>
Date:   Wed, 23 Aug 2023 09:24:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Cc:     baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/11] iommu: Prepare to deliver page faults to user
 space
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230817234047.195194-1-baolu.lu@linux.intel.com>
 <ZOOtjJLumarsBzwN@ziepe.ca>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZOOtjJLumarsBzwN@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/22 2:31, Jason Gunthorpe wrote:
> On Fri, Aug 18, 2023 at 07:40:36AM +0800, Lu Baolu wrote:
>> When a user-managed page table is attached to an IOMMU, it is necessary
>> to deliver IO page faults to user space so that they can be handled
>> appropriately. One use case for this is nested translation, which is
>> currently being discussed in the mailing list.
>>
>> I have posted a RFC series [1] that describes the implementation of
>> delivering page faults to user space through IOMMUFD. This series has
>> received several comments on the IOMMU refactoring, which I am trying to
>> address in this series.
> 
> Looking at this after all the patches are applied..

Thank you very much for reviewing my patches.

> 
> iommu_report_device_fault() and iommu_queue_iopf() should be put in
> the same file.

Yes. I will move both into io-pgfault.c. After that, iommu_queue_iopf()
becomes static.

> 
> iommu_queue_iopf() seems misnamed since it isn't queuing anything. It
> is delivering the fault to the domain.

Yeah, perhaps we can rename it to iommu_handle_iopf().

/**
  * iommu_handle_iopf - IO Page Fault handler
  * @fault: fault event
  * @dev: struct device.

> 
> It is weird that iommu_sva_domain_alloc is not in the sva file

Agreed. I will move it to iommu-sva.c.

> iopf_queue_work() wrappers a work queue, but it should trampoline
> through another function before invoking the driver's callback and not
> invoke it with a weird work_struct - decode the group and get back the
> domain. Every single handler will require the group and domain.

The work queue wrapper is duplicate. I will remove it and let the driver
to call queue_work() directly.

> 
> Same for domain->iopf_handler, the domain should be an argument if we
> are invoking the function on a domain.
> 
> Perhaps group->domain is a simple answer.

Yes. I will add domain in fault group and make it part of the parameters
of the callback.

Best regards,
baolu
