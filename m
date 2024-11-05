Return-Path: <kvm+bounces-30703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9E59BC7DD
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 09:19:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 713E71C21556
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 08:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F10921E89C;
	Tue,  5 Nov 2024 08:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nJihW7Op"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70330205137
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 08:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730794505; cv=none; b=lNt1QUS87AyaVbrotvkyPfAAScFRzFrJ+PL8Ttxkq3c0jHkx/fP/hSW1KUHl20A1zi+ErsXQIuU7p9nHJ3Pp3rHkR3B392c0E24NT9AatA27fwYbPDPYNIXG8vRUPr3Ssi8Y0gSgtv/1Ip4xVIMqNjlZBDpy/Zmts1XFqPx8Swk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730794505; c=relaxed/simple;
	bh=A1ipWrXjYocKwqXwVtRSW9f9BszXHDm3xV7MqHl4S8g=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=o4rkFnwrCe75AN1yECcd9/vci+2mfo4/zZdn4VdAqGu33kFR+vuBTwTJSyIh6rPJUnTKlF4uzuqOpqfukJ0TroubrG8ifnQAT+b8CtCjZJqkKtJNzM7Hr0cDUrNBxV+7qbgJgi3Y7E0JApBGeiPYJlg9aMbzn6n1rOJFglV3e8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nJihW7Op; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730794504; x=1762330504;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=A1ipWrXjYocKwqXwVtRSW9f9BszXHDm3xV7MqHl4S8g=;
  b=nJihW7Opb6FANLvEdIQyGXtPKwlUwl+L4sCkzEizGHQIw2K9dTfSAiuV
   TavOkys3SDNiVd1yWxSDPY2ZIKN13ajAIPFtXn1M7i94AaQEmZl4TDd7R
   RFQJG0fFkAvJEZT3Jr9RJ0cqFrZtZa2UDGF9TYVJlX96uhqB81fNZaGTl
   SS2PtX1cMLlKc9pWN5CQazVAEAVYBW0C1BGcE1bwX0SDzw6xrSbfB0W19
   BRf0mqvj8qqSQmWSLk8T+1MkPtlhxcSALonTDGliuEwvpnOFu0hIvVNW8
   PPpDpA2ORZVMAU1j/ypDlBduB/qdkqsq0ctlFfFYaumo78OxsAZ166ZNc
   w==;
X-CSE-ConnectionGUID: t3F8KF6vQqeu4lFu/deimQ==
X-CSE-MsgGUID: mLKOE+bbThWA3qtXzsO3zg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30749239"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="30749239"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 00:15:03 -0800
X-CSE-ConnectionGUID: aPp/T77ySKOyJhfdLxegNw==
X-CSE-MsgGUID: RDwuSdPUQoShhoNt6PeXfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="114716227"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 00:15:00 -0800
Message-ID: <4fa3f147-3766-4b0b-9cc0-eeafa3f9c790@linux.intel.com>
Date: Tue, 5 Nov 2024 16:14:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: baolu.lu@linux.intel.com, alex.williamson@redhat.com,
 eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
 chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v5 01/12] iommu: Introduce a replace API for device pasid
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-2-yi.l.liu@intel.com>
 <9846d58f-c6c8-41e8-b9fc-aa782ea8b585@linux.intel.com>
 <4f33b93c-6e86-428d-a942-09cd959a2f08@intel.com>
 <6e395258-96a1-44a5-a98f-41667e4ef715@linux.intel.com>
 <64f4e0ea-fb0f-41d1-84a1-353d18d5d516@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <64f4e0ea-fb0f-41d1-84a1-353d18d5d516@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/11/5 16:10, Yi Liu wrote:
> On 2024/11/5 15:57, Baolu Lu wrote:
>> On 2024/11/5 15:49, Yi Liu wrote:
>>> On 2024/11/5 11:58, Baolu Lu wrote:
>>>> On 11/4/24 21:25, Yi Liu wrote:
>>>>> +/**
>>>>> + * iommu_replace_device_pasid - Replace the domain that a pasid is 
>>>>> attached to
>>>>> + * @domain: the new iommu domain
>>>>> + * @dev: the attached device.
>>>>> + * @pasid: the pasid of the device.
>>>>> + * @handle: the attach handle.
>>>>> + *
>>>>> + * This API allows the pasid to switch domains. Return 0 on 
>>>>> success, or an
>>>>> + * error. The pasid will keep the old configuration if replacement 
>>>>> failed.
>>>>> + * This is supposed to be used by iommufd, and iommufd can 
>>>>> guarantee that
>>>>> + * both iommu_attach_device_pasid() and 
>>>>> iommu_replace_device_pasid() would
>>>>> + * pass in a valid @handle.
>>>>> + */
>>>>> +int iommu_replace_device_pasid(struct iommu_domain *domain,
>>>>> +                   struct device *dev, ioasid_t pasid,
>>>>> +                   struct iommu_attach_handle *handle)
>>>>> +{
>>>>> +    /* Caller must be a probed driver on dev */
>>>>> +    struct iommu_group *group = dev->iommu_group;
>>>>> +    struct iommu_attach_handle *curr;
>>>>> +    int ret;
>>>>> +
>>>>> +    if (!domain->ops->set_dev_pasid)
>>>>> +        return -EOPNOTSUPP;
>>>>> +
>>>>> +    if (!group)
>>>>> +        return -ENODEV;
>>>>> +
>>>>> +    if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
>>>>> +        pasid == IOMMU_NO_PASID || !handle)
>>>>> +        return -EINVAL;
>>>>> +
>>>>> +    handle->domain = domain;
>>>>> +
>>>>> +    mutex_lock(&group->mutex);
>>>>> +    /*
>>>>> +     * The iommu_attach_handle of the pasid becomes inconsistent 
>>>>> with the
>>>>> +     * actual handle per the below operation. The concurrent PRI 
>>>>> path will
>>>>> +     * deliver the PRQs per the new handle, this does not have a 
>>>>> functional
>>>>> +     * impact. The PRI path would eventually become consistent 
>>>>> when the
>>>>> +     * replacement is done.
>>>>> +     */
>>>>> +    curr = (struct iommu_attach_handle *)xa_store(&group- 
>>>>> >pasid_array,
>>>>> +                              pasid, handle,
>>>>> +                              GFP_KERNEL);
>>>>
>>>> The iommu drivers can only flush pending PRs in the hardware queue when
>>>> __iommu_set_group_pasid() is called. So, it appears more reasonable to
>>>> reorder things like this:
>>>>
>>>>      __iommu_set_group_pasid();
>>>>      switch_attach_handle();
>>>>
>>>> Or anything I overlooked?
>>>
>>> not quite get why this handle is related to iommu driver flushing PRs.
>>> Before __iommu_set_group_pasid(), the pasid is still attached with the
>>> old domain, so is the hw configuration.
>>
>> I meant that in the path of __iommu_set_group_pasid(), the iommu drivers
>> have the opportunity to flush the PRs pending in the hardware queue. If
>> the attach_handle is switched (by calling xa_store()) before
>> __iommu_set_group_pasid(), the pending PRs will be routed to iopf
>> handler of the new domain, which is not desirable.
> 
> I see. You mean the handling of PRQs. I was interpreting you are talking
> about PRQ draining.
> 
> yet, what you described was discussed before [1]. Forwarding PRQs to the
> new domain looks to be ok.
> 
> But you reminded me one thing. What I cared about more is the case
> replacing an iopf-capable domain to non-capable domain. This means the new
> coming PRQs would be responded by iopf_error_response(). Do you see an
> issue here?

I am not sure, but it will be more reasonable if you can make it in the
right order. If that's impossible, then add some comments to explain it.

--
baolu

