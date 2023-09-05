Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A02792764
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbjIEQEa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351410AbjIEFUA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 01:20:00 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D834CCB;
        Mon,  4 Sep 2023 22:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693891195; x=1725427195;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bvHQeHLkknHZ/9vJp80UHxLBNoyfMy8CBO1mOy/WJps=;
  b=GSoZYj/Fwvqg2CwiTPhv0jDJo1sOUmvKzJVFok1Zhr2ug/Z1eY56iPob
   hemftubSHI3RQzNkQDJivrzZ2r8UR7CVupy5VubFm43459420XddLtHZF
   t70nrU6YB5ZaepWVsFJmmDij2Rc7TlN9zHmd2mXDbMLB1hX3lGObMi+b9
   dsQc+Oy1/4uzVft/S3O70qaNRhJDrhseZXSlUFWf5e0YWX9qd/OHpOhV5
   29H23kCqM8enAOaXUOjWR714RNfsJI5BeYumWMh6pvz1p1UybxsbBsSU0
   ulRif4fNa2xszsIvPlhHD3cUJiu/rWe0LNZQK7JqO5ivlUm66J50I6BNb
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="407693819"
X-IronPort-AV: E=Sophos;i="6.02,228,1688454000"; 
   d="scan'208";a="407693819"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 22:19:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="740983062"
X-IronPort-AV: E=Sophos;i="6.02,228,1688454000"; 
   d="scan'208";a="740983062"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.214.54]) ([10.254.214.54])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 22:19:50 -0700
Message-ID: <068e3e43-a5c9-596b-3d39-782b7893dbcc@linux.intel.com>
Date:   Tue, 5 Sep 2023 13:19:48 +0800
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
Content-Language: en-US
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB527610423B186F1C5E734A4B8CE4A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/9/1 10:49, Tian, Kevin wrote:
>> From: Baolu Lu<baolu.lu@linux.intel.com>
>> Sent: Thursday, August 31, 2023 5:28 PM
>>
>> On 2023/8/30 15:43, Tian, Kevin wrote:
>>>> From: Baolu Lu<baolu.lu@linux.intel.com>
>>>> Sent: Saturday, August 26, 2023 4:01 PM
>>>>
>>>> On 8/25/23 4:17 PM, Tian, Kevin wrote:
>>>>>> +
>>>>>>     /**
>>>>>>      * iopf_queue_flush_dev - Ensure that all queued faults have been
>>>>>> processed
>>>>>>      * @dev: the endpoint whose faults need to be flushed.
>>>>> Presumably we also need a flush callback per domain given now
>>>>> the use of workqueue is optional then flush_workqueue() might
>>>>> not be sufficient.
>>>>>
>>>> The iopf_queue_flush_dev() function flushes all pending faults from the
>>>> IOMMU queue for a specific device. It has no means to flush fault queues
>>>> out of iommu core.
>>>>
>>>> The iopf_queue_flush_dev() function is typically called when a domain is
>>>> detaching from a PASID. Hence it's necessary to flush the pending faults
>>>> from top to bottom. For example, iommufd should flush pending faults in
>>>> its fault queues after detaching the domain from the pasid.
>>>>
>>> Is there an ordering problem? The last step of intel_svm_drain_prq()
>>> in the detaching path issues a set of descriptors to drain page requests
>>> and responses in hardware. It cannot complete if not all software queues
>>> are drained and it's counter-intuitive to drain a software queue after
>>> the hardware draining has already been completed.
>>>
>>> btw just flushing requests is probably insufficient in iommufd case since
>>> the responses are received asynchronously. It requires an interface to
>>> drain both requests and responses (presumably with timeouts in case
>>> of a malicious guest which never responds) in the detach path.
>> You are right. Good catch.
>>
>> To put it simply, iopf_queue_flush_dev() is insufficient to support the
>> case of forwarding iopf's over iommufd. Do I understand it right?
> yes

I added below patch to address the iopf_queue_flush_dev() issue. What do
you think of this？

iommu: Improve iopf_queue_flush_dev()

The iopf_queue_flush_dev() is called by the iommu driver before releasing
a PASID. It ensures that all pending faults for this PASID have been
handled or cancelled, and won't hit the address space that reuses this
PASID. The driver must make sure that no new fault is added to the queue.

The SMMUv3 driver doesn't use it because it only implements the
Arm-specific stall fault model where DMA transactions are held in the SMMU
while waiting for the OS to handle iopf's. Since a device driver must
complete all DMA transactions before detaching domain, there are no
pending iopf's with the stall model. PRI support requires adding a call to
iopf_queue_flush_dev() after flushing the hardware page fault queue.

The current implementation of iopf_queue_flush_dev() is a simplified
version. It is only suitable for SVA case in which the processing of iopf
is implemented in the inner loop of the iommu subsystem.

Improve this interface to make it also work for handling iopf out of the
iommu core.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
  include/linux/iommu.h      |  4 ++--
  drivers/iommu/intel/svm.c  |  2 +-
  drivers/iommu/io-pgfault.c | 40 ++++++++++++++++++++++++++++++++++++--
  3 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 77ad33ffe3ac..465e23e945d0 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -1275,7 +1275,7 @@ iommu_sva_domain_alloc(struct device *dev, struct 
mm_struct *mm)
  #ifdef CONFIG_IOMMU_IOPF
  int iopf_queue_add_device(struct iopf_queue *queue, struct device *dev);
  int iopf_queue_remove_device(struct iopf_queue *queue, struct device 
*dev);
-int iopf_queue_flush_dev(struct device *dev);
+int iopf_queue_flush_dev(struct device *dev, ioasid_t pasid);
  struct iopf_queue *iopf_queue_alloc(const char *name);
  void iopf_queue_free(struct iopf_queue *queue);
  int iopf_queue_discard_partial(struct iopf_queue *queue);
@@ -1295,7 +1295,7 @@ iopf_queue_remove_device(struct iopf_queue *queue, 
struct device *dev)
  	return -ENODEV;
  }

-static inline int iopf_queue_flush_dev(struct device *dev)
+static inline int iopf_queue_flush_dev(struct device *dev, ioasid_t pasid)
  {
  	return -ENODEV;
  }
diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
index 780c5bd73ec2..4c3f4533e337 100644
--- a/drivers/iommu/intel/svm.c
+++ b/drivers/iommu/intel/svm.c
@@ -495,7 +495,7 @@ void intel_drain_pasid_prq(struct device *dev, u32 
pasid)
  		goto prq_retry;
  	}

-	iopf_queue_flush_dev(dev);
+	iopf_queue_flush_dev(dev, pasid);

  	/*
  	 * Perform steps described in VT-d spec CH7.10 to drain page
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 3e6845bc5902..84728fb89ac7 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -309,17 +309,53 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
   *
   * Return: 0 on success and <0 on error.
   */
-int iopf_queue_flush_dev(struct device *dev)
+int iopf_queue_flush_dev(struct device *dev, ioasid_t pasid)
  {
  	struct iommu_fault_param *iopf_param = iopf_get_dev_fault_param(dev);
+	const struct iommu_ops *ops = dev_iommu_ops(dev);
+	struct iommu_page_response resp;
+	struct iopf_fault *iopf, *next;
+	int ret = 0;

  	if (!iopf_param)
  		return -ENODEV;

  	flush_workqueue(iopf_param->queue->wq);
+
+	mutex_lock(&iopf_param->lock);
+	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
+		if (!(iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) ||
+		    iopf->fault.prm.pasid != pasid)
+			break;
+
+		list_del(&iopf->list);
+		kfree(iopf);
+	}
+
+	list_for_each_entry_safe(iopf, next, &iopf_param->faults, list) {
+		if (!(iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_PASID_VALID) ||
+		    iopf->fault.prm.pasid != pasid)
+			continue;
+
+		memset(&resp, 0, sizeof(struct iommu_page_response));
+		resp.pasid = iopf->fault.prm.pasid;
+		resp.grpid = iopf->fault.prm.grpid;
+		resp.code = IOMMU_PAGE_RESP_INVALID;
+
+		if (iopf->fault.prm.flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID)
+			resp.flags = IOMMU_PAGE_RESP_PASID_VALID;
+
+		ret = ops->page_response(dev, iopf, &resp);
+		if (ret)
+			break;
+
+		list_del(&iopf->list);
+		kfree(iopf);
+	}
+	mutex_unlock(&iopf_param->lock);
  	iopf_put_dev_fault_param(iopf_param);

-	return 0;
+	return ret;
  }
  EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);

Best regards,
baolu
