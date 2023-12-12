Return-Path: <kvm+bounces-4140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F308980E38A
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 06:12:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A808D1F21D70
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 05:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DEE1172C;
	Tue, 12 Dec 2023 05:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z2p+tJUr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282B2CE;
	Mon, 11 Dec 2023 21:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702357921; x=1733893921;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/zUAzsErPK8Qs9uAvyrynqUtVON8UCLPxeGNKXurnzY=;
  b=Z2p+tJUrqlCPhzC0UOBB/cBUl+cxfrBxfLLOh7rwjlF8CJRm/Fdj4gsh
   pLnF/neD297txkFt0TE/etlMysEpKKUEkdJBAuTkKGsca+BlYTHCsgE6S
   DfNZSae8cDVCTOaTWHkVylTtvBs0lrJ4QCg+ZCiJ41vaMbKbVTZLLHAV9
   brYiIvRfBOheeFDmB9wagsT1aqJ8pOge1lb1rE7JjGcNRb4oiM1ML6K32
   JKcAdjIQxNHSFYon/t+LlBYQ8atKbSGX+1KpVYRmmuQJ6wAK/LDClDzuM
   v6MtzW1o9CNvwL8KGjhfb1SfN7RDTCCCA6ZTaoBOfEb3x+zyFe3GXm6oA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="391927274"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="391927274"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2023 21:12:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10921"; a="839303421"
X-IronPort-AV: E=Sophos;i="6.04,269,1695711600"; 
   d="scan'208";a="839303421"
Received: from allen-box.sh.intel.com (HELO [10.239.159.127]) ([10.239.159.127])
  by fmsmga008.fm.intel.com with ESMTP; 11 Dec 2023 21:11:57 -0800
Message-ID: <0f23e37a-5ace-492c-82e9-cf3d13f4ef6f@linux.intel.com>
Date: Tue, 12 Dec 2023 13:07:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 12/12] iommu: Use refcount for fault data access
Content-Language: en-US
To: Jason Gunthorpe <jgg@ziepe.ca>
References: <20231207064308.313316-1-baolu.lu@linux.intel.com>
 <20231207064308.313316-13-baolu.lu@linux.intel.com>
 <20231211152456.GB1489931@ziepe.ca>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20231211152456.GB1489931@ziepe.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/23 11:24 PM, Jason Gunthorpe wrote:
> On Thu, Dec 07, 2023 at 02:43:08PM +0800, Lu Baolu wrote:
>> @@ -217,12 +250,9 @@ int iommu_page_response(struct device *dev,
>>   	if (!ops->page_response)
>>   		return -ENODEV;
>>   
>> -	mutex_lock(&param->lock);
>> -	fault_param = param->fault_param;
>> -	if (!fault_param) {
>> -		mutex_unlock(&param->lock);
>> +	fault_param = iopf_get_dev_fault_param(dev);
>> +	if (!fault_param)
>>   		return -EINVAL;
>> -	}
> The refcounting should work by passing around the fault_param object,
> not re-obtaining it from the dev from a work.
> 
> The work should be locked to the iommu_fault_param that was active
> when the work was launched.
> 
> When we get to iommu_page_response it does this:
> 
> 	/* Only send response if there is a fault report pending */
> 	mutex_lock(&fault_param->lock);
> 	if (list_empty(&fault_param->faults)) {
> 		dev_warn_ratelimited(dev, "no pending PRQ, drop response\n");
> 		goto done_unlock;
> 	}
> 
> Which determines that the iommu_fault_param is stale and pending
> free..

Yes, agreed. The iopf_fault_param should be passed in together with the
iopf_group. The reference count should be released in the
iopf_free_group(). These two helps could look like below:

int iommu_page_response(struct iopf_group *group,
			struct iommu_page_response *msg)
{
	bool needs_pasid;
	int ret = -EINVAL;
	struct iopf_fault *evt;
	struct iommu_fault_page_request *prm;
	struct device *dev = group->fault_param->dev;
	const struct iommu_ops *ops = dev_iommu_ops(dev);
	bool has_pasid = msg->flags & IOMMU_PAGE_RESP_PASID_VALID;
	struct iommu_fault_param *fault_param = group->fault_param;

	if (!ops->page_response)
		return -ENODEV;

	/* Only send response if there is a fault report pending */
	mutex_lock(&fault_param->lock);
	if (list_empty(&fault_param->faults)) {
		dev_warn_ratelimited(dev, "no pending PRQ, drop response\n");
		goto done_unlock;
	}
	/*
	 * Check if we have a matching page request pending to respond,
	 * otherwise return -EINVAL
	 */
	list_for_each_entry(evt, &fault_param->faults, list) {
		prm = &evt->fault.prm;
		if (prm->grpid != msg->grpid)
			continue;

		/*
		 * If the PASID is required, the corresponding request is
		 * matched using the group ID, the PASID valid bit and the PASID
		 * value. Otherwise only the group ID matches request and
		 * response.
		 */
		needs_pasid = prm->flags & IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID;
		if (needs_pasid && (!has_pasid || msg->pasid != prm->pasid))
			continue;

		if (!needs_pasid && has_pasid) {
			/* No big deal, just clear it. */
			msg->flags &= ~IOMMU_PAGE_RESP_PASID_VALID;
			msg->pasid = 0;
		}

		ret = ops->page_response(dev, evt, msg);
		list_del(&evt->list);
		kfree(evt);
		break;
	}

done_unlock:
	mutex_unlock(&fault_param->lock);

	return ret;
}

...

void iopf_free_group(struct iopf_group *group)
{
	struct iopf_fault *iopf, *next;

	list_for_each_entry_safe(iopf, next, &group->faults, list) {
		if (!(iopf->fault.prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE))
			kfree(iopf);
	}

	/* Pair with iommu_report_device_fault(). */
	iopf_put_dev_fault_param(group->fault_param);
	kfree(group);
}

Best regards,
baolu

