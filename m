Return-Path: <kvm+bounces-7079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52D3483D495
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 09:15:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBDC028615B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 08:15:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0340017745;
	Fri, 26 Jan 2024 06:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AvviNS2i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252B2C2E3;
	Fri, 26 Jan 2024 06:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706251448; cv=none; b=RTMKwCfJRQRQZAbzjAAN6E8dOlGLETCQOivgxTWp9AMv1H6Gx6mwQvk/eJ8zZ23upchs19q9sc5PknOkliNFKLMmUIxeifbTboErIg2JK28+MfgTzBmsGeTLaqLjPylWHAEpWPUFJ60M88Pkf1mnLAPjyY+YXHpycEywSFjxYms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706251448; c=relaxed/simple;
	bh=y5wLNN7Z3zsHAdRNaCAGJxPKA+oPlN1uoRNwzgksWtU=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=R1Y+qJdObEP3rs6Xy9RQbdS1EzFjh7qboPLZ1ahQ7WSMZWn4nwsIjuhDMETu8sRc0fG4dRIVdow5FuzrD5NAb58L798nqFuyUGsD0BeTVNVpl7Ce+TynlIr7RdifE6R5QFWQto1r3NrnD2JtCfks8IGb4raasvaFEn3sdrkWze8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AvviNS2i; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706251446; x=1737787446;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y5wLNN7Z3zsHAdRNaCAGJxPKA+oPlN1uoRNwzgksWtU=;
  b=AvviNS2iywgCC0prxd78zGNbgtK5e1FLq+sPaEjToFXWn8X5yVLnQ07e
   5gDarWXsvJQa8PT/mvs2VTYQxr6VGhjofK1gjQPN0FE/iv4DX0gMy6Pxe
   /jHvKpSl5nW8ijbGNU/DDLIghzkjlH8PgXyCDV6Kp/v4j99C1Rx+w3i5K
   jVDtbb7r89VXKUGPym64Ta7RjJh4RVPaFEiXTmfAnr9s2SvbO4+RDMDPD
   qa27cSwiWGuJ0xsBhCmRD6DBNTAifVC5lARA53neL2nYwcYZvrQUY5r/w
   EPJ7Kec3HXo8Hf2pns4MnisxfFxSBPzU5DW2qx7U7gQh0Ls+Gdkam50cN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9155718"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9155718"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 22:44:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="877304497"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="877304497"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.249.174.176]) ([10.249.174.176])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2024 22:43:56 -0800
Message-ID: <2f583fda-aebc-41c2-898c-d4f46eaa1ab4@linux.intel.com>
Date: Fri, 26 Jan 2024 14:43:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
 Jacob Pan <jacob.jun.pan@linux.intel.com>,
 Longfang Liu <liulongfang@huawei.com>, Yan Zhao <yan.y.zhao@intel.com>,
 iommu@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v10 15/16] iommu: Make iopf_group_response() return void
Content-Language: en-US
To: Joel Granados <j.granados@samsung.com>
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
 <20240122054308.23901-16-baolu.lu@linux.intel.com>
 <CGME20240125162723eucas1p2cc7562a22b8af9b46076e1c7b616531b@eucas1p2.samsung.com>
 <20240125162721.yd2xejowbri5fg5r@localhost>
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20240125162721.yd2xejowbri5fg5r@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2024/1/26 0:27, Joel Granados wrote:
> On Mon, Jan 22, 2024 at 01:43:07PM +0800, Lu Baolu wrote:
>> The iopf_group_response() should return void, as nothing can do anything
>> with the failure. This implies that ops->page_response() must also return
>> void; this is consistent with what the drivers do. The failure paths,
>> which are all integrity validations of the fault, should be WARN_ON'd,
>> not return codes.
>>
>> If the iommu core fails to enqueue the fault, it should respond the fault
>> directly by calling ops->page_response() instead of returning an error
>> number and relying on the iommu drivers to do so. Consolidate the error
>> fault handling code in the core.
>>
>> Co-developed-by: Jason Gunthorpe<jgg@nvidia.com>
>> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>
>> Signed-off-by: Lu Baolu<baolu.lu@linux.intel.com>
>> ---
>>   include/linux/iommu.h                       |  14 +--
>>   drivers/iommu/intel/iommu.h                 |   4 +-
>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c |  50 +++-----
>>   drivers/iommu/intel/svm.c                   |  18 +--
>>   drivers/iommu/io-pgfault.c                  | 132 +++++++++++---------
>>   5 files changed, 99 insertions(+), 119 deletions(-)
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index 48196efc9327..d7b6f4017254 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -578,9 +578,8 @@ struct iommu_ops {
>>   	int (*dev_enable_feat)(struct device *dev, enum iommu_dev_features f);
>>   	int (*dev_disable_feat)(struct device *dev, enum iommu_dev_features f);
>>   
>> -	int (*page_response)(struct device *dev,
>> -			     struct iopf_fault *evt,
>> -			     struct iommu_page_response *msg);
>> +	void (*page_response)(struct device *dev, struct iopf_fault *evt,
>> +			      struct iommu_page_response *msg);
>>   
>>   	int (*def_domain_type)(struct device *dev);
>>   	void (*remove_dev_pasid)(struct device *dev, ioasid_t pasid);
>> @@ -1551,8 +1550,8 @@ void iopf_queue_free(struct iopf_queue *queue);
>>   int iopf_queue_discard_partial(struct iopf_queue *queue);
>>   void iopf_free_group(struct iopf_group *group);
>>   int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt);
>> -int iopf_group_response(struct iopf_group *group,
>> -			enum iommu_page_response_code status);
>> +void iopf_group_response(struct iopf_group *group,
>> +			 enum iommu_page_response_code status);
>>   #else
>>   static inline int
>>   iopf_queue_add_device(struct iopf_queue *queue, struct device *dev)
>> @@ -1594,10 +1593,9 @@ iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
>>   	return -ENODEV;
>>   }
>>   
>> -static inline int iopf_group_response(struct iopf_group *group,
>> -				      enum iommu_page_response_code status)
>> +static inline void iopf_group_response(struct iopf_group *group,
>> +				       enum iommu_page_response_code status)
>>   {
>> -	return -ENODEV;
>>   }
>>   #endif /* CONFIG_IOMMU_IOPF */
>>   #endif /* __LINUX_IOMMU_H */
>> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
>> index 696d95293a69..cf9a28c7fab8 100644
>> --- a/drivers/iommu/intel/iommu.h
>> +++ b/drivers/iommu/intel/iommu.h
>> @@ -1079,8 +1079,8 @@ struct iommu_domain *intel_nested_domain_alloc(struct iommu_domain *parent,
>>   void intel_svm_check(struct intel_iommu *iommu);
>>   int intel_svm_enable_prq(struct intel_iommu *iommu);
>>   int intel_svm_finish_prq(struct intel_iommu *iommu);
>> -int intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
>> -			    struct iommu_page_response *msg);
>> +void intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
>> +			     struct iommu_page_response *msg);
>>   struct iommu_domain *intel_svm_domain_alloc(void);
>>   void intel_svm_remove_dev_pasid(struct device *dev, ioasid_t pasid);
>>   void intel_drain_pasid_prq(struct device *dev, u32 pasid);
>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> index 4e93e845458c..42eb59cb99f4 100644
>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>> @@ -920,31 +920,29 @@ static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
>>   	return arm_smmu_cmdq_issue_cmdlist(smmu, cmds->cmds, cmds->num, true);
>>   }
>>   
>> -static int arm_smmu_page_response(struct device *dev,
>> -				  struct iopf_fault *unused,
>> -				  struct iommu_page_response *resp)
>> +static void arm_smmu_page_response(struct device *dev, struct iopf_fault *unused,
>> +				   struct iommu_page_response *resp)
>>   {
>>   	struct arm_smmu_cmdq_ent cmd = {0};
>>   	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
>>   	int sid = master->streams[0].id;
>>   
>> -	if (master->stall_enabled) {
>> -		cmd.opcode		= CMDQ_OP_RESUME;
>> -		cmd.resume.sid		= sid;
>> -		cmd.resume.stag		= resp->grpid;
>> -		switch (resp->code) {
>> -		case IOMMU_PAGE_RESP_INVALID:
>> -		case IOMMU_PAGE_RESP_FAILURE:
>> -			cmd.resume.resp = CMDQ_RESUME_0_RESP_ABORT;
>> -			break;
>> -		case IOMMU_PAGE_RESP_SUCCESS:
>> -			cmd.resume.resp = CMDQ_RESUME_0_RESP_RETRY;
>> -			break;
>> -		default:
>> -			return -EINVAL;
>> -		}
>> -	} else {
>> -		return -ENODEV;
>> +	if (WARN_ON(!master->stall_enabled))
>> +		return;
>> +
>> +	cmd.opcode		= CMDQ_OP_RESUME;
>> +	cmd.resume.sid		= sid;
>> +	cmd.resume.stag		= resp->grpid;
>> +	switch (resp->code) {
>> +	case IOMMU_PAGE_RESP_INVALID:
>> +	case IOMMU_PAGE_RESP_FAILURE:
>> +		cmd.resume.resp = CMDQ_RESUME_0_RESP_ABORT;
>> +		break;
>> +	case IOMMU_PAGE_RESP_SUCCESS:
>> +		cmd.resume.resp = CMDQ_RESUME_0_RESP_RETRY;
>> +		break;
>> +	default:
>> +		break;
>>   	}
>>   
>>   	arm_smmu_cmdq_issue_cmd(master->smmu, &cmd);
>> @@ -954,8 +952,6 @@ static int arm_smmu_page_response(struct device *dev,
>>   	 * terminated... at some point in the future. PRI_RESP is fire and
>>   	 * forget.
>>   	 */
>> -
>> -	return 0;
>>   }
>>   
>>   /* Context descriptor manipulation functions */
>> @@ -1516,16 +1512,6 @@ static int arm_smmu_handle_evt(struct arm_smmu_device *smmu, u64 *evt)
>>   	}
>>   
>>   	ret = iommu_report_device_fault(master->dev, &fault_evt);
>> -	if (ret && flt->type == IOMMU_FAULT_PAGE_REQ) {
>> -		/* Nobody cared, abort the access */
>> -		struct iommu_page_response resp = {
>> -			.pasid		= flt->prm.pasid,
>> -			.grpid		= flt->prm.grpid,
>> -			.code		= IOMMU_PAGE_RESP_FAILURE,
>> -		};
>> -		arm_smmu_page_response(master->dev, &fault_evt, &resp);
>> -	}
>> -
>>   out_unlock:
>>   	mutex_unlock(&smmu->streams_mutex);
>>   	return ret;
>> diff --git a/drivers/iommu/intel/svm.c b/drivers/iommu/intel/svm.c
>> index e1cbcb9515f0..2f8716636dbb 100644
>> --- a/drivers/iommu/intel/svm.c
>> +++ b/drivers/iommu/intel/svm.c
>> @@ -740,9 +740,8 @@ static irqreturn_t prq_event_thread(int irq, void *d)
>>   	return IRQ_RETVAL(handled);
>>   }
>>   
>> -int intel_svm_page_response(struct device *dev,
>> -			    struct iopf_fault *evt,
>> -			    struct iommu_page_response *msg)
>> +void intel_svm_page_response(struct device *dev, struct iopf_fault *evt,
>> +			     struct iommu_page_response *msg)
>>   {
>>   	struct device_domain_info *info = dev_iommu_priv_get(dev);
>>   	struct intel_iommu *iommu = info->iommu;
>> @@ -751,7 +750,6 @@ int intel_svm_page_response(struct device *dev,
>>   	bool private_present;
>>   	bool pasid_present;
>>   	bool last_page;
>> -	int ret = 0;
>>   	u16 sid;
>>   
>>   	prm = &evt->fault.prm;
>> @@ -760,16 +758,6 @@ int intel_svm_page_response(struct device *dev,
>>   	private_present = prm->flags & IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA;
>>   	last_page = prm->flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE;
>>   
>> -	if (!pasid_present) {
>> -		ret = -EINVAL;
>> -		goto out;
>> -	}
>> -
>> -	if (prm->pasid == 0 || prm->pasid >= PASID_MAX) {
>> -		ret = -EINVAL;
>> -		goto out;
>> -	}
>> -
>>   	/*
>>   	 * Per VT-d spec. v3.0 ch7.7, system software must respond
>>   	 * with page group response if private data is present (PDP)
>> @@ -798,8 +786,6 @@ int intel_svm_page_response(struct device *dev,
>>   
>>   		qi_submit_sync(iommu, &desc, 1, 0);
>>   	}
>> -out:
>> -	return ret;
>>   }
>>   
>>   static int intel_svm_set_dev_pasid(struct iommu_domain *domain,
>> diff --git a/drivers/iommu/io-pgfault.c b/drivers/iommu/io-pgfault.c
>> index c22e13df84c2..6e63e5a02884 100644
>> --- a/drivers/iommu/io-pgfault.c
>> +++ b/drivers/iommu/io-pgfault.c
>> @@ -39,7 +39,7 @@ static void iopf_put_dev_fault_param(struct iommu_fault_param *fault_param)
>>   		kfree_rcu(fault_param, rcu);
>>   }
>>   
>> -void iopf_free_group(struct iopf_group *group)
>> +static void __iopf_free_group(struct iopf_group *group)
>>   {
>>   	struct iopf_fault *iopf, *next;
>>   
>> @@ -50,6 +50,11 @@ void iopf_free_group(struct iopf_group *group)
>>   
>>   	/* Pair with iommu_report_device_fault(). */
>>   	iopf_put_dev_fault_param(group->fault_param);
>> +}
>> +
>> +void iopf_free_group(struct iopf_group *group)
>> +{
>> +	__iopf_free_group(group);
>>   	kfree(group);
>>   }
>>   EXPORT_SYMBOL_GPL(iopf_free_group);
>> @@ -97,14 +102,49 @@ static int report_partial_fault(struct iommu_fault_param *fault_param,
>>   	return 0;
>>   }
>>   
>> +static struct iopf_group *iopf_group_alloc(struct iommu_fault_param *iopf_param,
>> +					   struct iopf_fault *evt,
>> +					   struct iopf_group *abort_group)
>> +{
>> +	struct iopf_fault *iopf, *next;
>> +	struct iopf_group *group;
>> +
>> +	group = kzalloc(sizeof(*group), GFP_KERNEL);
>> +	if (!group) {
>> +		/*
>> +		 * We always need to construct the group as we need it to abort
>> +		 * the request at the driver if it cfan't be handled.
>> +		 */
>> +		group = abort_group;
>> +	}
>> +
>> +	group->fault_param = iopf_param;
>> +	group->last_fault.fault = evt->fault;
>> +	INIT_LIST_HEAD(&group->faults);
>> +	INIT_LIST_HEAD(&group->pending_node);
>> +	list_add(&group->last_fault.list, &group->faults);
>> +
>> +	/* See if we have partial faults for this group */
>> +	mutex_lock(&iopf_param->lock);
>> +	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
>> +		if (iopf->fault.prm.grpid == evt->fault.prm.grpid)
>> +			/* Insert*before*  the last fault */
>> +			list_move(&iopf->list, &group->faults);
>> +	}
>> +	list_add(&group->pending_node, &iopf_param->faults);
>> +	mutex_unlock(&iopf_param->lock);
>> +
>> +	return group;
>> +}
>> +
>>   /**
>>    * iommu_report_device_fault() - Report fault event to device driver
>>    * @dev: the device
>>    * @evt: fault event data
>>    *
>>    * Called by IOMMU drivers when a fault is detected, typically in a threaded IRQ
>> - * handler. When this function fails and the fault is recoverable, it is the
>> - * caller's responsibility to complete the fault.
>> + * handler. If this function fails then ops->page_response() was called to
>> + * complete evt if required.
>>    *
>>    * This module doesn't handle PCI PASID Stop Marker; IOMMU drivers must discard
>>    * them before reporting faults. A PASID Stop Marker (LRW = 0b100) doesn't
>> @@ -143,22 +183,18 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
>>   {
>>   	struct iommu_fault *fault = &evt->fault;
>>   	struct iommu_fault_param *iopf_param;
>> -	struct iopf_fault *iopf, *next;
>> -	struct iommu_domain *domain;
>> +	struct iopf_group abort_group = {};
>>   	struct iopf_group *group;
>>   	int ret;
>>   
>> -	if (fault->type != IOMMU_FAULT_PAGE_REQ)
>> -		return -EOPNOTSUPP;
>> -
>>   	iopf_param = iopf_get_dev_fault_param(dev);
>> -	if (!iopf_param)
>> +	if (WARN_ON(!iopf_param))
>>   		return -ENODEV;
>>   
>>   	if (!(fault->prm.flags & IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE)) {
>>   		ret = report_partial_fault(iopf_param, fault);
>>   		iopf_put_dev_fault_param(iopf_param);
>> -
>> +		/* A request that is not the last does not need to be ack'd */
>>   		return ret;
>>   	}
>>   
>> @@ -170,56 +206,33 @@ int iommu_report_device_fault(struct device *dev, struct iopf_fault *evt)
>>   	 * will send a response to the hardware. We need to clean up before
>>   	 * leaving, otherwise partial faults will be stuck.
>>   	 */
>> -	domain = get_domain_for_iopf(dev, fault);
>> -	if (!domain) {
>> +	group = iopf_group_alloc(iopf_param, evt, &abort_group);
>> +	if (group == &abort_group) {
>> +		ret = -ENOMEM;
>> +		goto err_abort;
>> +	}
>> +
>> +	group->domain = get_domain_for_iopf(dev, fault);
>> +	if (!group->domain) {
>>   		ret = -EINVAL;
>> -		goto cleanup_partial;
>> +		goto err_abort;
>>   	}
>>   
>> -	group = kzalloc(sizeof(*group), GFP_KERNEL);
>> -	if (!group) {
>> -		ret = -ENOMEM;
>> -		goto cleanup_partial;
>> -	}
>> -
>> -	group->fault_param = iopf_param;
>> -	group->last_fault.fault = *fault;
>> -	INIT_LIST_HEAD(&group->faults);
>> -	INIT_LIST_HEAD(&group->pending_node);
>> -	group->domain = domain;
>> -	list_add(&group->last_fault.list, &group->faults);
>> -
>> -	/* See if we have partial faults for this group */
>> -	mutex_lock(&iopf_param->lock);
>> -	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
>> -		if (iopf->fault.prm.grpid == fault->prm.grpid)
>> -			/* Insert*before*  the last fault */
>> -			list_move(&iopf->list, &group->faults);
>> -	}
>> -	list_add(&group->pending_node, &iopf_param->faults);
>> -	mutex_unlock(&iopf_param->lock);
>> +	/*
>> +	 * On success iopf_handler must call iopf_group_response() and
>> +	 * iopf_free_group()
>> +	 */
>> +	ret = group->domain->iopf_handler(group);
>> +	if (ret)
>> +		goto err_abort;
>> +	return 0;
>>   
>> -	ret = domain->iopf_handler(group);
>> -	if (ret) {
>> -		mutex_lock(&iopf_param->lock);
>> -		list_del_init(&group->pending_node);
>> -		mutex_unlock(&iopf_param->lock);
>> +err_abort:
>> +	iopf_group_response(group, IOMMU_PAGE_RESP_FAILURE);
>> +	if (group == &abort_group)
>> +		__iopf_free_group(group);
>> +	else
>>   		iopf_free_group(group);
>> -	}
>> -
>> -	return ret;
>> -
>> -cleanup_partial:
>> -	mutex_lock(&iopf_param->lock);
>> -	list_for_each_entry_safe(iopf, next, &iopf_param->partial, list) {
>> -		if (iopf->fault.prm.grpid == fault->prm.grpid) {
>> -			list_del(&iopf->list);
>> -			kfree(iopf);
>> -		}
>> -	}
>> -	mutex_unlock(&iopf_param->lock);
>> -	iopf_put_dev_fault_param(iopf_param);
>> -
>>   	return ret;
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_report_device_fault);
>> @@ -262,8 +275,8 @@ EXPORT_SYMBOL_GPL(iopf_queue_flush_dev);
>>    *
>>    * Return 0 on success and <0 on error.
>>    */
> Should you adjust the docs as well?

Yes. Will do.

Best regards,
baolu

