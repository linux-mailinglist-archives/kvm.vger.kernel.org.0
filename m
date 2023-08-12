Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D91BB77A431
	for <lists+kvm@lfdr.de>; Sun, 13 Aug 2023 01:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjHLXS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Aug 2023 19:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjHLXS4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Aug 2023 19:18:56 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E325C1706;
        Sat, 12 Aug 2023 16:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691882338; x=1723418338;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YCFZ1BkJqg0tYLeycNbOu2/N2SOtbW+f40vRiIfcHdM=;
  b=HrbvEiRW11r1Gq6kqMN0TxZM2WMyKbjUFa0NNderrtQc2Yno1FuOydKD
   dpafH+pd4Iaov/c2qPjvaUyWkp351kVs0ZJzA4HJ9lZIMMwtWqlm0GjFP
   e8XYjC+Fa33Gs9XspYQ1BbiH5T5Wa26RThStsEn2JI5dvji/FbFjkGDlg
   +PviMB7FasnZnGWzH6auPm65pNWOVp/Acn3apUuxg2MWHqKwVYBbtVRCr
   Qc7BQlmg9CekA7rjVd8Yf2IHTvdB77yL07QbSO9OOoJ5Wrvr62cazNUnx
   75oFq+r9hdP7Cl7Y4OKyWFdiwbYAFm2gGXrEXjilGJS/MgeNKwY4Ct0/1
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10800"; a="458221654"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="458221654"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2023 16:18:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10800"; a="733011957"
X-IronPort-AV: E=Sophos;i="6.01,168,1684825200"; 
   d="scan'208";a="733011957"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.211.171]) ([10.254.211.171])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2023 16:18:53 -0700
Message-ID: <9f5a1e52-8217-7aba-135c-7610bf21d1de@linux.intel.com>
Date:   Sun, 13 Aug 2023 07:18:50 +0800
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
Subject: Re: [PATCH v2 10/12] iommu: Make iommu_queue_iopf() more generic
To:     Jason Gunthorpe <jgg@ziepe.ca>
References: <20230727054837.147050-1-baolu.lu@linux.intel.com>
 <20230727054837.147050-11-baolu.lu@linux.intel.com>
 <ZNU1Zev6j92IJRjn@ziepe.ca>
 <7fc396d5-e2bd-b126-b3a6-88f8033c14b4@linux.intel.com>
 <ZNY3rYJbBFEMFi80@ziepe.ca>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <ZNY3rYJbBFEMFi80@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/8/11 21:29, Jason Gunthorpe wrote:
> On Fri, Aug 11, 2023 at 10:21:20AM +0800, Baolu Lu wrote:
> 
>>> This also has lifetime problems on the mm.
>>>
>>> The domain should flow into the iommu_sva_handle_iopf() instead of the
>>> void *data.
>>
>> Okay, but I still want to keep void *data as a private pointer of the
>> iopf consumer. For SVA, it's probably NULL.
> 
> I'd rather give the iommu_domain some 'private' void * than pass
> around weird pointers all over the place... That might be broadly
> useful, eg iommufd could store the hwpt in there.

Yes, you are right. With the private pointer stored in domain and domain
is passed to the iopf handler, there will be no need for a @data
parameter for iopf handler.

> 
>>> We need to document/figure out some how to ensure that the faults are
>>> all done processing before a fault enabled domain can be freed.
>>
>> This has been documented in drivers/iommu/io-pgfault.c:
>>
>> [...]
>>   * Any valid page fault will be eventually routed to an iommu domain and the
>>   * page fault handler installed there will get called. The users of this
>>   * handling framework should guarantee that the iommu domain could only be
>>   * freed after the device has stopped generating page faults (or the iommu
>>   * hardware has been set to block the page faults) and the pending page
>> faults
>>   * have been flushed.
>>   *
>>   * Return: 0 on success and <0 on error.
>>   */
>> int iommu_queue_iopf(struct iommu_fault *fault, void *cookie)
>> [...]
>>
>>> This patch would be better ordered before the prior patch.
>>
>> Let me try this in the next version.
> 
> Okay.. but can we have some debugging to enforce this maybe? Also add
> a comment when we obtain the domain on this path to see the above
> about the lifetime

Yes. Sure.

Probably I will add a dev_warn() when get_domain for device or pasid
returns NULL...

In the paths of removing domain from device or pasid, I will add a check
for pending faults. Will trigger a dev_warn() if there is any pending
faults for the affected domain.

Best regards,
baolu

