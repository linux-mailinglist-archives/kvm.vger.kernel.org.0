Return-Path: <kvm+bounces-30600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 633569BC3F4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 04:39:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E367C1F21D40
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 03:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F42C187870;
	Tue,  5 Nov 2024 03:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UvpK8b4z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F0E4D9FE
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 03:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730777939; cv=none; b=A4c93U/farWrZAfygEF1oFYRgtiZt9SWSozZljAvgHHO+U4/dPV9duoDGqkOvy7tBvbNg7MoThe46zMaDreyobUgrr3TEvObvskrsau1ByW6ZfIAPTsuSZYT1nJj+KMW4yP5ATxYYZZ8ZipEID+1/ZRKkfFtX8pPnlg7Jh2kEGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730777939; c=relaxed/simple;
	bh=pli57L/PI2PdF6meJNMHYu+iNu2hcdYsBPqUagn44Zc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VQr1URxMWOmvUPI/ow+L+Yh+npvqN5lPiUwT1oU1DJIYp8d4OzSrvlnr7dqjI03R9njB5WBkqXDI+YX/plbgRqoFIc+BAdER5g9colJ3yLiGzC5r6nk4qwPQNtpnw3osAOmx4efjyn1IeWrs6sfHL3/Neg0Pn+QAYEiGcSZTSvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UvpK8b4z; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730777938; x=1762313938;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=pli57L/PI2PdF6meJNMHYu+iNu2hcdYsBPqUagn44Zc=;
  b=UvpK8b4zgIks61Tbkf9EbFte+QD5E4VB9SGQlXfqW07zsqkjmwIW2NIV
   4RbCTsblBDSJRmdkt7SYFTx7HFhnY5ZrhvAzKjSGzGxVy5NtI7aeo48gn
   wJ/f4NPpetQW2XyZKFebsktJOoXNtcjhyOrjUh4m3l2v3iMT/VdjraACL
   ntgYYIxnL40VexPjZ8A8rIRUOqltL0r6GwrNflJvtBzxpqwROvY75EKRc
   lpXDlCHj06QbTua1kiAd5OzpM6GzzF/xhid6W1+y0OfOjRzWD8E/ljBUk
   IdVoqnywTZuWTAAiN6KxeyF0Xi7Ggv8f5eBRValItJxhngEUImM7NXN+V
   g==;
X-CSE-ConnectionGUID: 6fvazHivSsCWhNDflbPlXg==
X-CSE-MsgGUID: 8C69hC73RsWZ8gE9ynXvyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="18122516"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="18122516"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 19:38:57 -0800
X-CSE-ConnectionGUID: RYng68VJSPOm8/UCS+NdQw==
X-CSE-MsgGUID: WNI4FsQITuq7uSOFIgZ5Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83956764"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 19:38:55 -0800
Message-ID: <1076c17a-b053-4332-8684-926842126b36@linux.intel.com>
Date: Tue, 5 Nov 2024 11:38:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/13] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-12-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241104131842.13303-12-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 21:18, Yi Liu wrote:
> From: Lu Baolu <baolu.lu@linux.intel.com>
> 
> Add intel_nested_set_dev_pasid() to set a nested type domain to a PASID
> of a device.
> 

Co-developed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Co-developed-by: Yi Liu <yi.l.liu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

And convert the patch author to you.

> ---
>   drivers/iommu/intel/iommu.c  |  2 +-
>   drivers/iommu/intel/iommu.h  |  7 ++++++
>   drivers/iommu/intel/nested.c | 43 ++++++++++++++++++++++++++++++++++++
>   drivers/iommu/intel/pasid.h  | 11 +++++++++
>   4 files changed, 62 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 7e82b3a4bba7..7f1ca3c342a3 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -1944,7 +1944,7 @@ static int domain_setup_first_level(struct intel_iommu *iommu,
>   					     flags);
>   }
>   
> -static bool dev_is_real_dma_subdevice(struct device *dev)
> +bool dev_is_real_dma_subdevice(struct device *dev)

How about making this a static inline in the header?

>   {
>   	return dev && dev_is_pci(dev) &&
>   	       pci_real_dma_dev(to_pci_dev(dev)) != to_pci_dev(dev);
> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
> index 8e7ffb421ac4..55478d7b64cf 100644
> --- a/drivers/iommu/intel/iommu.h
> +++ b/drivers/iommu/intel/iommu.h
> @@ -818,6 +818,11 @@ domain_id_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
>   	return info->did;
>   }
>   
> +static inline int domain_type_is_nested(struct dmar_domain *domain)
> +{
> +	return domain->domain.type == IOMMU_DOMAIN_NESTED;
> +}

Why do you need this?

> +
>   /*
>    * 0: readable
>    * 1: writable
> @@ -1225,6 +1230,8 @@ void __iommu_flush_iotlb(struct intel_iommu *iommu, u16 did, u64 addr,
>    */
>   #define QI_OPT_WAIT_DRAIN		BIT(0)
>   
> +bool dev_is_real_dma_subdevice(struct device *dev);
> +
>   int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
>   void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu);
>   void device_block_translation(struct device *dev);
> diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
> index 3ce3c4fd210e..890087f3509f 100644
> --- a/drivers/iommu/intel/nested.c
> +++ b/drivers/iommu/intel/nested.c
> @@ -130,8 +130,51 @@ static int intel_nested_cache_invalidate_user(struct iommu_domain *domain,
>   	return ret;
>   }
>   
> +static int intel_nested_set_dev_pasid(struct iommu_domain *domain,
> +				      struct device *dev, ioasid_t pasid,
> +				      struct iommu_domain *old)
> +{
> +	struct device_domain_info *info = dev_iommu_priv_get(dev);
> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> +	struct intel_iommu *iommu = info->iommu;
> +	struct dev_pasid_info *dev_pasid;
> +	int ret;
> +
> +	/* No SVA domain replacement usage so far */
> +	if (old && old->type == IOMMU_DOMAIN_SVA)
> +		return -EOPNOTSUPP;

No need for this check from driver's point of view. If there is really a
need, it should go to the iommu core.

> +
> +	if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
 > +		return -EOPNOTSUPP;> +
> +	if (context_copied(iommu, info->bus, info->devfn))
> +		return -EBUSY;
> +
> +	ret = prepare_domain_attach_device(&dmar_domain->s2_domain->domain,
> +					   dev);
> +	if (ret)
> +		return ret;
> +
> +	dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
> +	if (IS_ERR(dev_pasid))
> +		return PTR_ERR(dev_pasid);
> +
> +	ret = domain_setup_nested(iommu, dmar_domain, dev, pasid, old);
> +	if (ret)
> +		goto out_remove_dev_pasid;
> +
> +	domain_remove_dev_pasid(old, dev, pasid);
> +
> +	return 0;
> +
> +out_remove_dev_pasid:
> +	domain_remove_dev_pasid(domain, dev, pasid);
> +	return ret;
> +}
> +
>   static const struct iommu_domain_ops intel_nested_domain_ops = {
>   	.attach_dev		= intel_nested_attach_dev,
> +	.set_dev_pasid		= intel_nested_set_dev_pasid,
>   	.free			= intel_nested_domain_free,
>   	.cache_invalidate_user	= intel_nested_cache_invalidate_user,
>   };
> diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
> index a3b5945a1812..31a4e7c01853 100644
> --- a/drivers/iommu/intel/pasid.h
> +++ b/drivers/iommu/intel/pasid.h
> @@ -335,6 +335,17 @@ static inline int domain_setup_passthrough(struct intel_iommu *iommu,
>   	return intel_pasid_setup_pass_through(iommu, dev, pasid);
>   }
>   
> +static inline int domain_setup_nested(struct intel_iommu *iommu,
> +				      struct dmar_domain *domain,
> +				      struct device *dev, ioasid_t pasid,
> +				      struct iommu_domain *old)
> +{
> +	if (old)
> +		return intel_pasid_replace_nested(iommu, dev,
> +						  pasid, domain);
> +	return intel_pasid_setup_nested(iommu, dev, pasid, domain);
> +}
> +
>   void intel_pasid_tear_down_entry(struct intel_iommu *iommu,
>   				 struct device *dev, u32 pasid,
>   				 bool fault_ignore);

Others look good to me.

--
baolu

