Return-Path: <kvm+bounces-62840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E6D6BC50B13
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 07:22:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CC7124EBF24
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 06:22:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2807F2DE6F5;
	Wed, 12 Nov 2025 06:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LzDtcjbX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8424C10942;
	Wed, 12 Nov 2025 06:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762928539; cv=none; b=E+539e+SCWByRFEdLhNAEu9YMxmDYQV4BrlQ+iEP4xtwSPjI2zUBd9Tj23s6Wk8YOFyjcvcZdAesOn26WE6nvlMJu0ywakD+pUk5eSlZa2aJOtDaOoA00L8/WE7kGvy6BsL9ptyRmeH9FEZicXlXIDDNXtlzhUfGX98peNP+zJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762928539; c=relaxed/simple;
	bh=WUP1kjvtR8UUXkZWolJKlxqm2Abil0rICQsZg+E7nCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CMEkvxrplpU2UbmknE3XdlC4NNjYBE8qsXe6Dp9Ymt6NNHMFpcvzfBVR+GFl+jMTIdXwLft32RDNdjsh2XmoT+CBD1qn7Vp1oJXZ45oIN+HhxDDeBcO00AmbSXa/R2hD+MD+/bLueCdanZUFDDkT0TTGAslb8ahsifJJnhoGxBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LzDtcjbX; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762928537; x=1794464537;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WUP1kjvtR8UUXkZWolJKlxqm2Abil0rICQsZg+E7nCk=;
  b=LzDtcjbX0ne40r/mjR0TirnKeX9ffMeHZO6roH8FZApBBBIkIWImBn/M
   YTHJicLbXMkcAgO16mv4w3qqveOuAK7lthGFQOmJMRWu2YWtyG+jhgRRl
   zkX6zvzsB1keAUvj+26FAsPCFQrkoxRLQC+4ERXx9uyyFPEaAVP/g7GMo
   E6e0yXKxIxtr164KfvaeyjOKoOu7HIcLI4rH4u4zR0Rcg65eIVBIv1hrt
   HTsotLBrgji5sZs8Dbn8amUCXdPw+3TIEcUvgLA+gB253B2TNI0iXbugM
   8jziFRhmE42XlD8fEYnF57TNThPLGeqplBHQVAKD/bbe9wYyl8z2D/GoG
   A==;
X-CSE-ConnectionGUID: H5fe4gaeTDiHo0GYp9sPNg==
X-CSE-MsgGUID: nlJHO3AuTp2/vj1t03DQHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11610"; a="82383158"
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="82383158"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 22:22:17 -0800
X-CSE-ConnectionGUID: bunbCrviTPWIJPn1B3GT+g==
X-CSE-MsgGUID: jeGtRGzFRRCq22mROzCv+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,298,1754982000"; 
   d="scan'208";a="189106120"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2025 22:22:12 -0800
Message-ID: <60970315-613f-4e62-8923-e162c29d9362@linux.intel.com>
Date: Wed, 12 Nov 2025 14:18:09 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 4/5] iommu: Introduce iommu_dev_reset_prepare() and
 iommu_dev_reset_done()
To: Nicolin Chen <nicolinc@nvidia.com>, joro@8bytes.org, afael@kernel.org,
 bhelgaas@google.com, alex@shazbot.org, jgg@nvidia.com, kevin.tian@intel.com
Cc: will@kernel.org, robin.murphy@arm.com, lenb@kernel.org,
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-pci@vger.kernel.org, kvm@vger.kernel.org, patches@lists.linux.dev,
 pjaroszynski@nvidia.com, vsethi@nvidia.com, helgaas@kernel.org,
 etzhao1900@gmail.com
References: <cover.1762835355.git.nicolinc@nvidia.com>
 <28af027371a981a2b4154633e12cdb1e5a11da4a.1762835355.git.nicolinc@nvidia.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <28af027371a981a2b4154633e12cdb1e5a11da4a.1762835355.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/11/25 13:12, Nicolin Chen wrote:
> +/**
> + * iommu_dev_reset_prepare() - Block IOMMU to prepare for a device reset
> + * @dev: device that is going to enter a reset routine
> + *
> + * When certain device is entering a reset routine, it wants to block any IOMMU
> + * activity during the reset routine. This includes blocking any translation as
> + * well as cache invalidation (especially the device cache).
> + *
> + * This function attaches all RID/PASID of the device's to IOMMU_DOMAIN_BLOCKED
> + * allowing any blocked-domain-supporting IOMMU driver to pause translation and
> + * cahce invalidation, but leaves the software domain pointers intact so later
> + * the iommu_dev_reset_done() can restore everything.
> + *
> + * Return: 0 on success or negative error code if the preparation failed.
> + *
> + * Caller must use iommu_dev_reset_prepare() and iommu_dev_reset_done() together
> + * before/after the core-level reset routine, to unset the resetting_domain.
> + *
> + * These two functions are designed to be used by PCI reset functions that would
> + * not invoke any racy iommu_release_device(), since PCI sysfs node gets removed
> + * before it notifies with a BUS_NOTIFY_REMOVED_DEVICE. When using them in other
> + * case, callers must ensure there will be no racy iommu_release_device() call,
> + * which otherwise would UAF the dev->iommu_group pointer.
> + */
> +int iommu_dev_reset_prepare(struct device *dev)
> +{
> +	struct iommu_group *group = dev->iommu_group;
> +	unsigned long pasid;
> +	void *entry;
> +	int ret = 0;
> +
> +	if (!dev_has_iommu(dev))
> +		return 0;

Nit: This interface is only for PCI layer, so why not just

	if (WARN_ON(!dev_is_pci(dev)))
		return -EINVAL;
?
> +
> +	guard(mutex)(&group->mutex);
> +
> +	/*
> +	 * Once the resetting_domain is set, any concurrent attachment to this
> +	 * iommu_group will be rejected, which would break the attach routines
> +	 * of the sibling devices in the same iommu_group. So, skip this case.
> +	 */
> +	if (dev_is_pci(dev)) {
> +		struct group_device *gdev;
> +
> +		for_each_group_device(group, gdev) {
> +			if (gdev->dev != dev)
> +				return 0;
> +		}
> +	}

With above dev_is_pci() check, here it can simply be,

	if (list_count_nodes(&group->devices) != 1)
		return 0;		

> +
> +	/* Re-entry is not allowed */
> +	if (WARN_ON(group->resetting_domain))
> +		return -EBUSY;
> +
> +	ret = __iommu_group_alloc_blocking_domain(group);
> +	if (ret)
> +		return ret;
> +
> +	/* Stage RID domain at blocking_domain while retaining group->domain */
> +	if (group->domain != group->blocking_domain) {
> +		ret = __iommu_attach_device(group->blocking_domain, dev,
> +					    group->domain);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/*
> +	 * Stage PASID domains at blocking_domain while retaining pasid_array.
> +	 *
> +	 * The pasid_array is mostly fenced by group->mutex, except one reader
> +	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
> +	 */
> +	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
> +		iommu_remove_dev_pasid(dev, pasid,
> +				       pasid_array_entry_to_domain(entry));
> +
> +	group->resetting_domain = group->blocking_domain;
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_dev_reset_prepare);
> +
> +/**
> + * iommu_dev_reset_done() - Restore IOMMU after a device reset is finished
> + * @dev: device that has finished a reset routine
> + *
> + * When certain device has finished a reset routine, it wants to restore its
> + * IOMMU activity, including new translation as well as cache invalidation, by
> + * re-attaching all RID/PASID of the device's back to the domains retained in
> + * the core-level structure.
> + *
> + * Caller must pair it with a successfully returned iommu_dev_reset_prepare().
> + *
> + * Note that, although unlikely, there is a risk that re-attaching domains might
> + * fail due to some unexpected happening like OOM.
> + */
> +void iommu_dev_reset_done(struct device *dev)
> +{
> +	struct iommu_group *group = dev->iommu_group;
> +	unsigned long pasid;
> +	void *entry;
> +
> +	if (!dev_has_iommu(dev))
> +		return;
> +
> +	guard(mutex)(&group->mutex);
> +
> +	/* iommu_dev_reset_prepare() was bypassed for the device */
> +	if (!group->resetting_domain)
> +		return;
> +
> +	/* iommu_dev_reset_prepare() was not successfully called */
> +	if (WARN_ON(!group->blocking_domain))
> +		return;
> +
> +	/* Re-attach RID domain back to group->domain */
> +	if (group->domain != group->blocking_domain) {
> +		WARN_ON(__iommu_attach_device(group->domain, dev,
> +					      group->blocking_domain));
> +	}
> +
> +	/*
> +	 * Re-attach PASID domains back to the domains retained in pasid_array.
> +	 *
> +	 * The pasid_array is mostly fenced by group->mutex, except one reader
> +	 * in iommu_attach_handle_get(), so it's safe to read without xa_lock.
> +	 */
> +	xa_for_each_start(&group->pasid_array, pasid, entry, 1)
> +		WARN_ON(__iommu_set_group_pasid(
> +			pasid_array_entry_to_domain(entry), group, pasid,
> +			group->blocking_domain));
> +
> +	group->resetting_domain = NULL;
> +}
> +EXPORT_SYMBOL_GPL(iommu_dev_reset_done);
> +
>   #if IS_ENABLED(CONFIG_IRQ_MSI_IOMMU)
>   /**
>    * iommu_dma_prepare_msi() - Map the MSI page in the IOMMU domain

Thanks,
baolu

