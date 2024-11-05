Return-Path: <kvm+bounces-30591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C25859BC2E8
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 03:07:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C964281A7F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 02:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE390364BA;
	Tue,  5 Nov 2024 02:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EUJO/hk7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC82322F1C
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 02:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730772424; cv=none; b=dvcFAoeAqTTkixZZLoiJ+0GFXAjrkfOpeCnhVP3bNRK2PLcsdiH07n8O8w7IzA03tPfas+CmFLqTn8XInDOfCDNe1s/3Q08ild27s7yjbdfVq+AdD0pzVread5cDuEsmdkGnHHvD2jVk7XWWIqZ+a+VVyLupT5UH5wUwUyY5zeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730772424; c=relaxed/simple;
	bh=vluMpp8ZWItN8pJZXKoSedoGbDikGFDgiyAjaJ2wtEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZfIktzC3cB/RKoGRdLjXIeXG/fXNMSPyRhm/iJVGV79oGgnSPhUYSv2bV793nh4oiBg2f8WlEMiiPXF7oY5Q6DWvLpSY/PO8oB9rvsnyKt/LlhqKIKKqrAtiCmPrcLOKdwencWd6o305/CH5GKiyTaoMJn+M4mWJCW0RKPXSL8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EUJO/hk7; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730772423; x=1762308423;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vluMpp8ZWItN8pJZXKoSedoGbDikGFDgiyAjaJ2wtEI=;
  b=EUJO/hk7u9pDHjl6PqPw1p4uDXB8TX7Er/Ii6c3kEma1XkT6pMct1LvX
   R7AztnKI6CbgiR2aNPy+NLQN/aQdcUnr9QOpkp+t1nK74X7dNc6hIHGBe
   Ha/ot1ppU/N06PcgQZXsJ/Lbqi5myYkwd/TSXejwZi5OafpvUyw2hMImz
   bDBncLqX+MpKmit33dIjJuB+B4oafNEhi3jzQoj6xUsnFywgmrPDiHB+G
   aBMcoqWZjFDm2mgT8wgecxJ9SZ/xKChZ507hI7lBhQFlK+IpRhACpUYMQ
   1i/BUPtwozfKpMop9LKQJvZXbz4i7HzYmelvp4S3Tzp8KMIuuHhzkhnRP
   Q==;
X-CSE-ConnectionGUID: ZmWf6UgqRW2RICDFI3ZeJQ==
X-CSE-MsgGUID: Kulj2ve4RpCz80+50kU3/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30612613"
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="30612613"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:07:03 -0800
X-CSE-ConnectionGUID: p/a9eYMxQNOM8nwlWTjulg==
X-CSE-MsgGUID: in8m8QgYT0GyVn00unInwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,258,1725346800"; 
   d="scan'208";a="87767734"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 18:06:59 -0800
Message-ID: <de7cbf75-930f-42b3-beb5-3be697defe50@linux.intel.com>
Date: Tue, 5 Nov 2024 10:06:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/13] iommu/vt-d: Add pasid replace helpers
To: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, jgg@nvidia.com,
 kevin.tian@intel.com
Cc: alex.williamson@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
 kvm@vger.kernel.org, chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
 zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-5-yi.l.liu@intel.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20241104131842.13303-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 21:18, Yi Liu wrote:
> pasid replacement allows converting a present pasid entry to be FS, SS,
> PT or nested, hence add helpers for such operations. This simplifies the
> callers as well since the caller can switch the pasid to the new domain
> by one-shot.
> 
> Suggested-by: Lu Baolu<baolu.lu@linux.intel.com>
> Signed-off-by: Yi Liu<yi.l.liu@intel.com>
> ---
>   drivers/iommu/intel/pasid.c | 173 ++++++++++++++++++++++++++++++++++++
>   drivers/iommu/intel/pasid.h |  12 +++
>   2 files changed, 185 insertions(+)

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

with a nit below

> 
> diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
> index 65fd2fee01b7..b7c2d65b8726 100644
> --- a/drivers/iommu/intel/pasid.c
> +++ b/drivers/iommu/intel/pasid.c
> @@ -390,6 +390,40 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
>   	return 0;
>   }
>   
> +int intel_pasid_replace_first_level(struct intel_iommu *iommu,
> +				    struct device *dev, pgd_t *pgd,
> +				    u32 pasid, u16 did, int flags)
> +{
> +	struct pasid_entry *pte;
> +	u16 old_did;
> +
> +	if (!ecap_flts(iommu->ecap) ||
> +	    ((flags & PASID_FLAG_FL5LP) && !cap_fl5lp_support(iommu->cap)))
> +		return -EINVAL;
> +
> +	spin_lock(&iommu->lock);
> +	pte = intel_pasid_get_entry(dev, pasid);
> +	if (!pte) {
> +		spin_unlock(&iommu->lock);
> +		return -ENODEV;
> +	}
> +
> +	if (!pasid_pte_is_present(pte)) {
> +		spin_unlock(&iommu->lock);
> +		return -EINVAL;
> +	}
> +
> +	old_did = pasid_get_domain_id(pte);
> +
> +	pasid_pte_config_first_level(iommu, pte, pgd, did, flags);
> +	spin_unlock(&iommu->lock);
> +
> +	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
> +	intel_drain_pasid_prq(dev, pasid);
> +
> +	return 0;
> +}
> +
>   /*
>    * Skip top levels of page tables for iommu which has less agaw
>    * than default. Unnecessary for PT mode.
> @@ -483,6 +517,55 @@ int intel_pasid_setup_second_level(struct intel_iommu *iommu,
>   	return 0;
>   }
>   
> +int intel_pasid_replace_second_level(struct intel_iommu *iommu,
> +				     struct dmar_domain *domain,
> +				     struct device *dev, u32 pasid)
> +{
> +	struct pasid_entry *pte;
> +	struct dma_pte *pgd;
> +	u16 did, old_did;
> +	u64 pgd_val;
> +	int agaw;
> +
> +	/*
> +	 * If hardware advertises no support for second level
> +	 * translation, return directly.
> +	 */
> +	if (!ecap_slts(iommu->ecap))
> +		return -EINVAL;
> +
> +	pgd = domain->pgd;
> +	agaw = iommu_skip_agaw(domain, iommu, &pgd);

iommu_skip_agaw() has been removed after domain_alloc_paging is
supported in this driver. Perhaps you need a rebase if you have a new
version.

> +	if (agaw < 0)
> +		return -EINVAL;
> +
> +	pgd_val = virt_to_phys(pgd);
> +	did = domain_id_iommu(domain, iommu);
> +
> +	spin_lock(&iommu->lock);
> +	pte = intel_pasid_get_entry(dev, pasid);
> +	if (!pte) {
> +		spin_unlock(&iommu->lock);
> +		return -ENODEV;
> +	}
> +
> +	if (!pasid_pte_is_present(pte)) {
> +		spin_unlock(&iommu->lock);
> +		return -EINVAL;
> +	}
> +
> +	old_did = pasid_get_domain_id(pte);
> +
> +	pasid_pte_config_second_level(iommu, pte, pgd_val, agaw,
> +				      did, domain->dirty_tracking);
> +	spin_unlock(&iommu->lock);
> +
> +	intel_pasid_flush_present(iommu, dev, pasid, old_did, pte);
> +	intel_drain_pasid_prq(dev, pasid);
> +
> +	return 0;
> +}

--
baolu

