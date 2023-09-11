Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6B279BDE6
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236772AbjIKUty (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237286AbjIKM0p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 08:26:45 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF9841B9;
        Mon, 11 Sep 2023 05:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694435200; x=1725971200;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZeJFG3p0amLf2aZVuMJVpjZKpOancQKu1R8Tg7UuK28=;
  b=gBV1rBwij45n6sFcU/i+wCxFHiFVl38Ctm1Q5yQqKhzmba5cFMOEpkVV
   IRzGU1i+ZPokipjFQccJ6mXd5DuoCGAgH87lOHsI/5Is7QI9DdrcOYf4j
   fFbKE7FmH/oRxyasKjjdVdQUNoXayk8snFbS5jnSaEvdeWgiHzkSj4f4t
   +MBfRK7ftJCg1AK6/nyqh3yalhlxoeLb8rhlZN3JqHqPtoI7Jy/PKo44T
   750ApI2G4AQKth0Iar61HpwvTnGX6PAaqzP1p59mJOSkogzScspDmjh2t
   sH4QcfokoZGJblQwUiHdgRDYpaA3R+Cj5CEbMVkH59UpSnA7KEQSrJBAw
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="376979526"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="376979526"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 05:26:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="813351012"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="813351012"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.255.28.234]) ([10.255.28.234])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 05:26:37 -0700
Message-ID: <926da2a0-6b3e-cb24-23d1-1d9bce93b997@linux.intel.com>
Date:   Mon, 11 Sep 2023 20:26:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Cc:     baolu.lu@linux.intel.com, "Liu, Yi L" <yi.l.liu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 09/10] iommu: Make iommu_queue_iopf() more generic
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>
References: <20230825023026.132919-1-baolu.lu@linux.intel.com>
 <20230825023026.132919-10-baolu.lu@linux.intel.com>
 <BN9PR11MB52762A33BC9F41AB424915688CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <cbfbe969-1a92-52bf-f00c-3fb89feefd66@linux.intel.com>
 <BN9PR11MB52768891BC89107AD291E45C8CE6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <67aa00ae-01e6-0dd8-499f-279cb6df3ddd@linux.intel.com>
 <BN9PR11MB527610423B186F1C5E734A4B8CE4A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <068e3e43-a5c9-596b-3d39-782b7893dbcc@linux.intel.com>
 <BN9PR11MB52768F9AEBC4BF39300E44478CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52768F9AEBC4BF39300E44478CF2A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

Thanks for looking at my patches.

On 2023/9/11 14:35, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Tuesday, September 5, 2023 1:20 PM
>>
>> I added below patch to address the iopf_queue_flush_dev() issue. What do
>> you think of this？
>>
>> iommu: Improve iopf_queue_flush_dev()
>>
>> The iopf_queue_flush_dev() is called by the iommu driver before releasing
>> a PASID. It ensures that all pending faults for this PASID have been
>> handled or cancelled, and won't hit the address space that reuses this
>> PASID. The driver must make sure that no new fault is added to the queue.
>>
>> The SMMUv3 driver doesn't use it because it only implements the
>> Arm-specific stall fault model where DMA transactions are held in the SMMU
>> while waiting for the OS to handle iopf's. Since a device driver must
>> complete all DMA transactions before detaching domain, there are no
>> pending iopf's with the stall model. PRI support requires adding a call to
>> iopf_queue_flush_dev() after flushing the hardware page fault queue.
>>
>> The current implementation of iopf_queue_flush_dev() is a simplified
>> version. It is only suitable for SVA case in which the processing of iopf
>> is implemented in the inner loop of the iommu subsystem.
>>
>> Improve this interface to make it also work for handling iopf out of the
>> iommu core.
>>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> ---
>>    include/linux/iommu.h      |  4 ++--
>>    drivers/iommu/intel/svm.c  |  2 +-
>>    drivers/iommu/io-pgfault.c | 40
>> ++++++++++++++++++++++++++++++++++++--
>>    3 files changed, 41 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index 77ad33ffe3ac..465e23e945d0 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -1275,7 +1275,7 @@ iommu_sva_domain_alloc(struct device *dev,
>> struct
>> mm_struct *mm)
>>    #ifdef CONFIG_IOMMU_IOPF
>>    int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev);
>>    int iopf_queue_remove_device(struct iopf_queue *queue, struct device
>> *dev);
>> -int iopf_queue_flush_dev(struct device *dev);
>> +int iopf_queue_flush_dev(struct device *dev, ioasid_t pasid);
>>    struct iopf_queue *iopf_queue_alloc(const char *name);
>>    void iopf_queue_free(struct iopf_queue *queue);
>>    int iopf_queue_discard_partial(struct iopf_queue *queue);
>> @@ -1295,7 +1295,7 @@ iopf_queue_remove_device(struct iopf_queue
>> *queue,
>> struct device *dev)
>>    	return -ENODEV;
>>    }
>>
>> -static inline int iopf_queue_flush_dev(struct device *dev)
>> +static inline int iopf_queue_flush_dev(struct device *dev, ioasid_t pasid)
>>    {
>>    	return -ENODEV;
>>    }
>> diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
>> index 780c5bd73ec2..4c3f4533e337 100644
>> --- a/drivers/iommu/intel/svm.c
>> +++ b/drivers/iommu/intel/svm.c
>> @@ -495,7 +495,7 @@ void intel_drain_pasid_prq(struct device *dev, u32
>> pasid)
>>    		goto prq_retry;
>>    	}
>>
>> -	iopf_queue_flush_dev(dev);
>> +	iopf_queue_flush_dev(dev, pasid);
>>
>>    	/*
>>    	 * Perform steps described in VT-d spec CH7.10 to drain page
>> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
>> index 3e6845bc5902..84728fb89ac7 100644
>> --- a/drivers/iommu/io-pgfault.c
>> +++ b/drivers/iommu/io-pgfault.c
>> @@ -309,17 +309,53 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
>>     *
>>     * Return: 0 on success and <0 on error.
>>     */
>> -int iopf_queue_flush_dev(struct device *dev)
>> +int iopf_queue_flush_dev(struct device *dev, ioasid_t pasid)
>>    {
>>    	struct iommu_fault_param *iopf_param =
>> iopf_get_dev_fault_param(dev);
>> +	const struct iommu_ops *ops = dev_iommu_ops(dev);
>> +	struct iommu_page_response resp;
>> +	struct iopf_fault *iopf, *next;
>> +	int ret = 0;
>>
>>    	if (!iopf_param)
>>    		return -ENODEV;
>>
>>    	flush_workqueue(iopf_param->queue->wq);
>> +
>> +	mutex_lock(&iopf_param->lock);
>> +	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
>> +		if (!(iopf->fault.prm.flags &
>> IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) ||
>> +		    iopf->fault.prm.pasid != pasid)
>> +			break;
>> +
>> +		list_del(&iopf->list);
>> +		kfree(iopf);
>> +	}
>> +
>> +	list_for_each_entry_safe(iopf, next, &iopf_param->faults, list) {
>> +		if (!(iopf->fault.prm.flags &
>> IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) ||
>> +		    iopf->fault.prm.pasid != pasid)
>> +			continue;
>> +
>> +		memset(&resp, 0, sizeof(struct iommu_page_response));
>> +		resp.pasid = iopf->fault.prm.pasid;
>> +		resp.grpid = iopf->fault.prm.grpid;
>> +		resp.code = IOMMU_PAGE_RESP_INVALID;
>> +
>> +		if (iopf->fault.prm.flags &
>> IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID)
>> +			resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
> 
> Out of curiosity. Is it a valid configuration which has REQUEST_PASID_VALID
> set but RESP_PASID_VALID cleared? I'm unclear why another response
> flag is required beyond what the request flag has told...

This seems to have uncovered a bug in VT-d driver.

The PCIe spec (Section 10.4.2.2) states:

"
If a Page Request has a PASID, the corresponding PRG Response Message
may optionally contain one as well.

If the PRG Response PASID Required bit is Clear, PRG Response Messages
do not have a PASID. If the PRG Response PASID Required bit is Set, PRG
Response Messages have a PASID if the Page Request also had one. The
Function is permitted to use the PASID value from the prefix in
conjunction with the PRG Index to match requests and responses.
"

The "PRG Response PASID Required bit" is a read-only field in the PCI
page request status register. It is represented by
"pdev->pasid_required".

So below code in VT-d driver is not correct:

542 static int intel_svm_prq_report(struct intel_iommu *iommu, struct 
device *dev,
543                                 struct page_req_dsc *desc)
544 {

[...]

556
557         if (desc->lpig)
558                 event.fault.prm.flags |= 
IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE;
559         if (desc->pasid_present) {
560                 event.fault.prm.flags |= 
IOMMU_FAULT_PAGE_REQUEST_PASID_VALID;
561                 event.fault.prm.flags |= 
IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID;
562         }
[...]

The right logic should be

	if (pdev->pasid_required)
		event.fault.prm.flags |= IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID;

Thoughts?

>> +
>> +		ret = ops->page_response(dev, iopf, &resp);
>> +		if (ret)
>> +			break;
>> +
>> +		list_del(&iopf->list);
>> +		kfree(iopf);
>> +	}
>> +	mutex_unlock(&iopf_param->lock);
>>    	iopf_put_dev_fault_param(iopf_param);
>>
>> -	return 0;
>> +	return ret;
>>    }
>>    EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
>>
> 
> This looks OK. Another nit is that the warning of "no pending PRQ"
> in iommu_page_response() should be removed given with above
> change it's expected for iommufd responses to be received after this
> flush operation in iommu core.

Yeah! Addressed.

Best regards,
baolu

