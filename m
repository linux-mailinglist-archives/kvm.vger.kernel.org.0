Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D534479270A
	for <lists+kvm@lfdr.de>; Tue,  5 Sep 2023 18:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbjIEQDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Sep 2023 12:03:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351652AbjIEFYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Sep 2023 01:24:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0549E8;
        Mon,  4 Sep 2023 22:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693891474; x=1725427474;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7yRpurzzwCMrF3BW5n2uSjqy7aK/uDwBCGx05tS4LrI=;
  b=flAiemb0Mp8d2UGF4GIVSydyXVFX0Mq/d0VGuYoZHojAHFlVCskY76un
   R9RshMz+GYe/A5ezb6VuR5wGBhJmQTIOYBlx45XwcTOU2H/hcMXe30/u9
   XfmOXO4K7qcX21pmP+w7XrGL/o+XPYcEHGnxOvl+jxU/dPkVUY6oJZH7o
   cagn0XF03uxF3c/M3Gehw6UQfX+9wlsGzCQjqWeKJHsGUEFeQK/S1kRts
   sUHC3YlxevchlSwB6XKP7DbHPfCgCGDSLUzN42zHtfom9rRSISfVX7FzW
   VCY1dH0gqAG9R6oZfNAIBWG0rrJkHwLHKATioC1OrIfRih9oCsbpP+Rl9
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="366935207"
X-IronPort-AV: E=Sophos;i="6.02,228,1688454000"; 
   d="scan'208";a="366935207"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 22:24:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10823"; a="734505788"
X-IronPort-AV: E=Sophos;i="6.02,228,1688454000"; 
   d="scan'208";a="734505788"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.254.214.54]) ([10.254.214.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 22:24:29 -0700
Message-ID: <c9228377-0a5c-adf8-d0ef-9a791226603d@linux.intel.com>
Date:   Tue, 5 Sep 2023 13:24:26 +0800
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
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB5276622C8271402487FA44708CE4A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/9/1 10:50, Tian, Kevin wrote:
>> From: Baolu Lu <baolu.lu@linux.intel.com>
>> Sent: Thursday, August 31, 2023 7:25 PM
>>
>> On 2023/8/30 15:55, Tian, Kevin wrote:
>>>> From: Baolu Lu <baolu.lu@linux.intel.com>
>>>> Sent: Saturday, August 26, 2023 4:04 PM
>>>>
>>>> On 8/25/23 4:17 PM, Tian, Kevin wrote:
>>>>>> +static void assert_no_pending_iopf(struct device *dev, ioasid_t pasid)
>>>>>> +{
>>>>>> +	struct iommu_fault_param *iopf_param = dev->iommu-
>>>>>>> fault_param;
>>>>>> +	struct iopf_fault *iopf;
>>>>>> +
>>>>>> +	if (!iopf_param)
>>>>>> +		return;
>>>>>> +
>>>>>> +	mutex_lock(&iopf_param->lock);
>>>>>> +	list_for_each_entry(iopf, &iopf_param->partial, list) {
>>>>>> +		if (WARN_ON(iopf->fault.prm.pasid == pasid))
>>>>>> +			break;
>>>>>> +	}
>>>>> partial list is protected by dev_iommu lock.
>>>>>
>>>>
>>>> Ah, do you mind elaborating a bit more? In my mind, partial list is
>>>> protected by dev_iommu->fault_param->lock.
>>>>
>>>
>>> well, it's not how the code is currently written. iommu_queue_iopf()
>>> doesn't hold dev_iommu->fault_param->lock to update the partial
>>> list.
>>>
>>> while at it looks there is also a mislocking in iopf_queue_discard_partial()
>>> which only acquires queue->lock.
>>>
>>> So we have three places touching the partial list all with different locks:
>>>
>>> - iommu_queue_iopf() relies on dev_iommu->lock
>>> - iopf_queue_discard_partial() relies on queue->lock
>>> - this new assert function uses dev_iommu->fault_param->lock
>>
>> Yeah, I see your point now. Thanks for the explanation.
>>
>> So, my understanding is that dev_iommu->lock protects the whole
>> pointer of dev_iommu->fault_param, while dev_iommu->fault_param->lock
>> protects the lists inside it.
>>
> 
> yes. let's use fault_param->lock consistently for those lists in all paths.

Hi Kevin,

I am trying to address this issue in below patch. Does it looks sane to
you?

iommu: Consolidate per-device fault data management

The per-device fault data is a data structure that is used to store
information about faults that occur on a device. This data is allocated
when IOPF is enabled on the device and freed when IOPF is disabled. The
data is used in the paths of iopf reporting, handling, responding, and
draining.

The fault data is protected by two locks:

- dev->iommu->lock: This lock is used to protect the allocation and
   freeing of the fault data.
- dev->iommu->fault_parameter->lock: This lock is used to protect the
   fault data itself.

Improve the iopf code to enforce this lock mechanism and add a reference
counter in the fault data to avoid use-after-free issue.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
---
  include/linux/iommu.h      |   3 +
  drivers/iommu/io-pgfault.c | 122 +++++++++++++++++++++++--------------
  2 files changed, 79 insertions(+), 46 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 1697ac168f05..77ad33ffe3ac 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -480,6 +480,8 @@ struct iommu_device {
  /**
   * struct iommu_fault_param - per-device IOMMU fault data
   * @lock: protect pending faults list
+ * @users: user counter to manage the lifetime of the data, this field
+ *         is protected by dev->iommu->lock.
   * @dev: the device that owns this param
   * @queue: IOPF queue
   * @queue_list: index into queue->devices
@@ -489,6 +491,7 @@ struct iommu_device {
   */
  struct iommu_fault_param {
  	struct mutex lock;
+	int users;

  	struct device *dev;
  	struct iopf_queue *queue;
diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
index 7e5c6798ce24..3e6845bc5902 100644
--- a/drivers/iommu/io-pgfault.c
+++ b/drivers/iommu/io-pgfault.c
@@ -26,6 +26,49 @@ void iopf_free_group(struct iopf_group *group)
  }
  EXPORT_SYMBOL_GPL(iopf_free_group);

+/*
+ * Return the fault parameter of a device if it exists. Otherwise, 
return NULL.
+ * On a successful return, the caller takes a reference of this 
parameter and
+ * should put it after use by calling iopf_put_dev_fault_param().
+ */
+static struct iommu_fault_param *iopf_get_dev_fault_param(struct device 
*dev)
+{
+	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *fault_param;
+
+	if (!param)
+		return NULL;
+
+	mutex_lock(&param->lock);
+	fault_param = param->fault_param;
+	if (fault_param)
+		fault_param->users++;
+	mutex_unlock(&param->lock);
+
+	return fault_param;
+}
+
+/* Caller must hold a reference of the fault parameter. */
+static void iopf_put_dev_fault_param(struct iommu_fault_param *fault_param)
+{
+	struct device *dev = fault_param->dev;
+	struct dev_iommu *param = dev->iommu;
+
+	mutex_lock(&param->lock);
+	if (WARN_ON(fault_param->users <= 0 ||
+		    fault_param != param->fault_param)) {
+		mutex_unlock(&param->lock);
+		return;
+	}
+
+	if (--fault_param->users == 0) {
+		param->fault_param = NULL;
+		kfree(fault_param);
+		put_device(dev);
+	}
+	mutex_unlock(&param->lock);
+}
+
  /**
   * iommu_handle_iopf - IO Page Fault handler
   * @fault: fault event
@@ -72,23 +115,14 @@ static int iommu_handle_iopf(struct iommu_fault 
*fault, struct device *dev)
  	struct iopf_group *group;
  	struct iommu_domain *domain;
  	struct iopf_fault *iopf, *next;
-	struct iommu_fault_param *iopf_param;
-	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *iopf_param = dev->iommu->fault_param;

-	lockdep_assert_held(&param->lock);
+	lockdep_assert_held(&iopf_param->lock);

  	if (fault->type != IOMMU_FAULT_PAGE_REQ)
  		/* Not a recoverable page fault */
  		return -EOPNOTSUPP;

-	/*
-	 * As long as we're holding param->lock, the queue can't be unlinked
-	 * from the device and therefore cannot disappear.
-	 */
-	iopf_param = param->fault_param;
-	if (!iopf_param)
-		return -ENODEV;
-
  	if (!(fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
  		iopf = kzalloc(sizeof(*iopf), GFP_KERNEL);
  		if (!iopf)
@@ -167,18 +201,15 @@ static int iommu_handle_iopf(struct iommu_fault 
*fault, struct device *dev)
   */
  int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
  {
-	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *fault_param;
  	struct iopf_fault *evt_pending = NULL;
-	struct iommu_fault_param *fparam;
  	int ret = 0;

-	if (!param || !evt)
+	fault_param = iopf_get_dev_fault_param(dev);
+	if (!fault_param)
  		return -EINVAL;

-	/* we only report device fault if there is a handler registered */
-	mutex_lock(&param->lock);
-	fparam = param->fault_param;
-
+	mutex_lock(&fault_param->lock);
  	if (evt->fault.type == IOMMU_FAULT_PAGE_REQ &&
  	    (evt->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
  		evt_pending = kmemdup(evt, sizeof(struct iopf_fault),
@@ -187,20 +218,18 @@ int iommu_report_device_fault(struct device *dev, 
struct iopf_fault *evt)
  			ret = -ENOMEM;
  			goto done_unlock;
  		}
-		mutex_lock(&fparam->lock);
-		list_add_tail(&evt_pending->list, &fparam->faults);
-		mutex_unlock(&fparam->lock);
+		list_add_tail(&evt_pending->list, &fault_param->faults);
  	}

  	ret = iommu_handle_iopf(&evt->fault, dev);
  	if (ret && evt_pending) {
-		mutex_lock(&fparam->lock);
  		list_del(&evt_pending->list);
-		mutex_unlock(&fparam->lock);
  		kfree(evt_pending);
  	}
  done_unlock:
-	mutex_unlock(&param->lock);
+	mutex_unlock(&fault_param->lock);
+	iopf_put_dev_fault_param(fault_param);
+
  	return ret;
  }
  EXPORT_SYMBOL_GPL(iommu_report_device_fault);
@@ -212,19 +241,20 @@ int iommu_page_response(struct device *dev,
  	int ret = -EINVAL;
  	struct iopf_fault *evt;
  	struct iommu_fault_page_request *prm;
-	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *fault_param;
  	const struct iommu_ops *ops = dev_iommu_ops(dev);
  	bool has_pasid = msg->flags & IOMMU_PAGE_RESP_PASID_VALID;

  	if (!ops->page_response)
  		return -ENODEV;

-	if (!param || !param->fault_param)
-		return -EINVAL;
+	fault_param = iopf_get_dev_fault_param(dev);
+	if (!fault_param)
+		return -ENODEV;

  	/* Only send response if there is a fault report pending */
-	mutex_lock(&param->fault_param->lock);
-	if (list_empty(&param->fault_param->faults)) {
+	mutex_lock(&fault_param->lock);
+	if (list_empty(&fault_param->faults)) {
  		dev_warn_ratelimited(dev, "no pending PRQ, drop response\n");
  		goto done_unlock;
  	}
@@ -232,7 +262,7 @@ int iommu_page_response(struct device *dev,
  	 * Check if we have a matching page request pending to respond,
  	 * otherwise return -EINVAL
  	 */
-	list_for_each_entry(evt, &param->fault_param->faults, list) {
+	list_for_each_entry(evt, &fault_param->faults, list) {
  		prm = &evt->fault.prm;
  		if (prm->grpid != msg->grpid)
  			continue;
@@ -260,7 +290,9 @@ int iommu_page_response(struct device *dev,
  	}

  done_unlock:
-	mutex_unlock(&param->fault_param->lock);
+	mutex_unlock(&fault_param->lock);
+	iopf_put_dev_fault_param(fault_param);
+
  	return ret;
  }
  EXPORT_SYMBOL_GPL(iommu_page_response);
@@ -279,22 +311,15 @@ EXPORT_SYMBOL_GPL(iommu_page_response);
   */
  int iopf_queue_flush_dev(struct device *dev)
  {
-	int ret = 0;
-	struct iommu_fault_param *iopf_param;
-	struct dev_iommu *param = dev->iommu;
+	struct iommu_fault_param *iopf_param = iopf_get_dev_fault_param(dev);

-	if (!param)
+	if (!iopf_param)
  		return -ENODEV;

-	mutex_lock(&param->lock);
-	iopf_param = param->fault_param;
-	if (iopf_param)
-		flush_workqueue(iopf_param->queue->wq);
-	else
-		ret = -ENODEV;
-	mutex_unlock(&param->lock);
+	flush_workqueue(iopf_param->queue->wq);
+	iopf_put_dev_fault_param(iopf_param);

-	return ret;
+	return 0;
  }
  EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);

@@ -318,11 +343,13 @@ int iopf_queue_discard_partial(struct iopf_queue 
*queue)

  	mutex_lock(&queue->lock);
  	list_for_each_entry(iopf_param, &queue->devices, queue_list) {
+		mutex_lock(&iopf_param->lock);
  		list_for_each_entry_safe(iopf, next, &iopf_param->partial,
  					 list) {
  			list_del(&iopf->list);
  			kfree(iopf);
  		}
+		mutex_unlock(&iopf_param->lock);
  	}
  	mutex_unlock(&queue->lock);
  	return 0;
@@ -361,6 +388,7 @@ int iopf_queue_add_device(struct iopf_queue *queue, 
struct device *dev)
  	INIT_LIST_HEAD(&fault_param->faults);
  	INIT_LIST_HEAD(&fault_param->partial);
  	fault_param->dev = dev;
+	fault_param->users = 1;
  	list_add(&fault_param->queue_list, &queue->devices);
  	fault_param->queue = queue;

@@ -413,9 +441,11 @@ int iopf_queue_remove_device(struct iopf_queue 
*queue, struct device *dev)
  	list_for_each_entry_safe(iopf, next, &fault_param->partial, list)
  		kfree(iopf);

-	param->fault_param = NULL;
-	kfree(fault_param);
-	put_device(dev);
+	if (--fault_param->users == 0) {
+		param->fault_param = NULL;
+		kfree(fault_param);
+		put_device(dev);
+	}
  unlock:
  	mutex_unlock(&param->lock);
  	mutex_unlock(&queue->lock);
-- 
2.34.1

Best regards,
baolu
