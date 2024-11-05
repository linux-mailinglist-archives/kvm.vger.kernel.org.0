Return-Path: <kvm+bounces-30699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F2FCE9BC79B
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 08:57:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 70ECEB22A61
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFDDB1FEFC1;
	Tue,  5 Nov 2024 07:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ROAUS+mR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05621C57B2
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 07:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730793451; cv=none; b=W2FXQMG1dGzJYzjlIECkXXvN6e0SRPdwYj3NROhKnZoWK0Ir7XLcbTbUmhkI2LdvEANzoQnjEGNFE5xvouyn2swaqq5vJcViNiI5rUAGNkapcYMgQVA1arg9q25iH6yL2LC/ZtXlBDLwBsKyCTVAkp6UAeqsHbf4aiQ2Hv+jU9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730793451; c=relaxed/simple;
	bh=xjUfFvTbd+zrT+hckx++a9O0WJ55CCvoqlRbbkcQAo8=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Yw+axw7VG8cPWHGxVw7LB4qaa4GarW9kOlgRmi0/Rp0TIUoyBr0ysXUGtHH0JqzbtZrDzGIfBP41fJ2i/pjqskeARMrZWiP9mLWSUv0EeFBaVr8o2+Tqkx6+yYXZLgqA/Jifahp+IQNsudda7PNMB0JOigr4XhUJRN8qrrP7YKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ROAUS+mR; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730793450; x=1762329450;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xjUfFvTbd+zrT+hckx++a9O0WJ55CCvoqlRbbkcQAo8=;
  b=ROAUS+mRuBGwW9rZ0/5LhmgrXrdESYxZMgcH4tq+/fMwM7c705VX3NaX
   SURlVPBgu/gCh6PH3EcxutGiVK7piJ4oPUzb3fuQAqPBU6qNqVWZVTCkD
   V0wJPKTczXzQ9PwtkP+38vlEdaVMoOWVx7O436XiSHlWRTzcOOnD/yjAd
   oeEvFBWqrkPUFSn6J3eF6BcA9Wf+Ak5++OZl6gFekVnAJFcU8Pxegzd2t
   PoE/oBzJDPEHiA8jujCnLHxCK4Q85gLY2F2oCu/3WW2FiqVr7wS6Nvpn7
   lKo7Khnu+DtzPf1ECIBJ7HrHVfpdxaLoN+yju9Q263XYs2A0Lb2f3xveQ
   w==;
X-CSE-ConnectionGUID: n1LBM6PjRfq5VHRFIZZdWg==
X-CSE-MsgGUID: sWL9G6cYR2iPnvhZ4W5Rvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41069456"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41069456"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 23:57:29 -0800
X-CSE-ConnectionGUID: 9KuR2Tc9RMuNgyBR0ykcqQ==
X-CSE-MsgGUID: SZ+1SQ38S5ef4COaA0xQ4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83855344"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.124.240.228]) ([10.124.240.228])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 23:57:26 -0800
Message-ID: <6e395258-96a1-44a5-a98f-41667e4ef715@linux.intel.com>
Date: Tue, 5 Nov 2024 15:57:24 +0800
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
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <4f33b93c-6e86-428d-a942-09cd959a2f08@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2024/11/5 15:49, Yi Liu wrote:
> On 2024/11/5 11:58, Baolu Lu wrote:
>> On 11/4/24 21:25, Yi Liu wrote:
>>> +/**
>>> + * iommu_replace_device_pasid - Replace the domain that a pasid is 
>>> attached to
>>> + * @domain: the new iommu domain
>>> + * @dev: the attached device.
>>> + * @pasid: the pasid of the device.
>>> + * @handle: the attach handle.
>>> + *
>>> + * This API allows the pasid to switch domains. Return 0 on success, 
>>> or an
>>> + * error. The pasid will keep the old configuration if replacement 
>>> failed.
>>> + * This is supposed to be used by iommufd, and iommufd can guarantee 
>>> that
>>> + * both iommu_attach_device_pasid() and iommu_replace_device_pasid() 
>>> would
>>> + * pass in a valid @handle.
>>> + */
>>> +int iommu_replace_device_pasid(struct iommu_domain *domain,
>>> +                   struct device *dev, ioasid_t pasid,
>>> +                   struct iommu_attach_handle *handle)
>>> +{
>>> +    /* Caller must be a probed driver on dev */
>>> +    struct iommu_group *group = dev->iommu_group;
>>> +    struct iommu_attach_handle *curr;
>>> +    int ret;
>>> +
>>> +    if (!domain->ops->set_dev_pasid)
>>> +        return -EOPNOTSUPP;
>>> +
>>> +    if (!group)
>>> +        return -ENODEV;
>>> +
>>> +    if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
>>> +        pasid == IOMMU_NO_PASID || !handle)
>>> +        return -EINVAL;
>>> +
>>> +    handle->domain = domain;
>>> +
>>> +    mutex_lock(&group->mutex);
>>> +    /*
>>> +     * The iommu_attach_handle of the pasid becomes inconsistent 
>>> with the
>>> +     * actual handle per the below operation. The concurrent PRI 
>>> path will
>>> +     * deliver the PRQs per the new handle, this does not have a 
>>> functional
>>> +     * impact. The PRI path would eventually become consistent when the
>>> +     * replacement is done.
>>> +     */
>>> +    curr = (struct iommu_attach_handle *)xa_store(&group->pasid_array,
>>> +                              pasid, handle,
>>> +                              GFP_KERNEL);
>>
>> The iommu drivers can only flush pending PRs in the hardware queue when
>> __iommu_set_group_pasid() is called. So, it appears more reasonable to
>> reorder things like this:
>>
>>      __iommu_set_group_pasid();
>>      switch_attach_handle();
>>
>> Or anything I overlooked?
> 
> not quite get why this handle is related to iommu driver flushing PRs.
> Before __iommu_set_group_pasid(), the pasid is still attached with the
> old domain, so is the hw configuration.

I meant that in the path of __iommu_set_group_pasid(), the iommu drivers
have the opportunity to flush the PRs pending in the hardware queue. If
the attach_handle is switched (by calling xa_store()) before
__iommu_set_group_pasid(), the pending PRs will be routed to iopf
handler of the new domain, which is not desirable.

--
baolu

