Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5911F224191
	for <lists+kvm@lfdr.de>; Fri, 17 Jul 2020 19:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgGQRO0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jul 2020 13:14:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47500 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726205AbgGQRO0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jul 2020 13:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595006063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h7Vro6oATDfc57wTbAGmgD4ZVMjfXELJBQKUa0OblJs=;
        b=BVms1uMgV4BI9jgIDpYG8/kUOelur+zmDR72hY5LZ06Ntk8LGXpPu/YioDt7pb8UIu08mI
        C7V2KuVBfwWXXI0ssAQ8dZPO89LqqqXuH/9LT2LAsTH5OXteBezcjcYapVlVsmY7uC/Mn7
        WZ+qn4OgWz/0XX3LH3NXkqQDclKPBDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-mBLot0W0O2qV29HKiIlQ-Q-1; Fri, 17 Jul 2020 13:14:19 -0400
X-MC-Unique: mBLot0W0O2qV29HKiIlQ-Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAF2F18A1DE5;
        Fri, 17 Jul 2020 17:14:17 +0000 (UTC)
Received: from [10.36.115.54] (ovpn-115-54.ams2.redhat.com [10.36.115.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8FF910013C4;
        Fri, 17 Jul 2020 17:14:08 +0000 (UTC)
Subject: Re: [PATCH v5 15/15] iommu/vt-d: Support reporting nesting capability
 info
To:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        baolu.lu@linux.intel.com, joro@8bytes.org
Cc:     kevin.tian@intel.com, jacob.jun.pan@linux.intel.com,
        ashok.raj@intel.com, jun.j.tian@intel.com, yi.y.sun@intel.com,
        jean-philippe@linaro.org, peterx@redhat.com, hao.wu@intel.com,
        stefanha@gmail.com, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1594552870-55687-1-git-send-email-yi.l.liu@intel.com>
 <1594552870-55687-16-git-send-email-yi.l.liu@intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <be27f7ee-3fac-d1c5-0cd9-9581f8827de6@redhat.com>
Date:   Fri, 17 Jul 2020 19:14:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <1594552870-55687-16-git-send-email-yi.l.liu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

Missing a proper commit message. You can comment on the fact you only
support the case where all the physical iomms have the same CAP/ECAP MASKS

On 7/12/20 1:21 PM, Liu Yi L wrote:
> Cc: Kevin Tian <kevin.tian@intel.com>
> CC: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
> v2 -> v3:
> *) remove cap/ecap_mask in iommu_nesting_info.
> ---
>  drivers/iommu/intel/iommu.c | 81 +++++++++++++++++++++++++++++++++++++++++++--
>  include/linux/intel-iommu.h | 16 +++++++++
>  2 files changed, 95 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index a9504cb..9f7ad1a 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -5659,12 +5659,16 @@ static inline bool iommu_pasid_support(void)
>  static inline bool nested_mode_support(void)
>  {
>  	struct dmar_drhd_unit *drhd;
> -	struct intel_iommu *iommu;
> +	struct intel_iommu *iommu, *prev = NULL;
>  	bool ret = true;
>  
>  	rcu_read_lock();
>  	for_each_active_iommu(iommu, drhd) {
> -		if (!sm_supported(iommu) || !ecap_nest(iommu->ecap)) {
> +		if (!prev)
> +			prev = iommu;
> +		if (!sm_supported(iommu) || !ecap_nest(iommu->ecap) ||
> +		    (VTD_CAP_MASK & (iommu->cap ^ prev->cap)) ||
> +		    (VTD_ECAP_MASK & (iommu->ecap ^ prev->ecap))) {
>  			ret = false;
>  			break;>  		}
> @@ -6079,6 +6083,78 @@ intel_iommu_domain_set_attr(struct iommu_domain *domain,
>  	return ret;
>  }
>  
> +static int intel_iommu_get_nesting_info(struct iommu_domain *domain,
> +					struct iommu_nesting_info *info)
> +{
> +	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> +	u64 cap = VTD_CAP_MASK, ecap = VTD_ECAP_MASK;
> +	struct device_domain_info *domain_info;
> +	struct iommu_nesting_info_vtd vtd;
> +	unsigned long flags;
> +	unsigned int size;
> +
> +	if (domain->type != IOMMU_DOMAIN_UNMANAGED ||
> +	    !(dmar_domain->flags & DOMAIN_FLAG_NESTING_MODE))
> +		return -ENODEV;
> +
> +	if (!info)
> +		return -EINVAL;
> +
> +	size = sizeof(struct iommu_nesting_info) +
> +		sizeof(struct iommu_nesting_info_vtd);
> +	/*
> +	 * if provided buffer size is smaller than expected, should
> +	 * return 0 and also the expected buffer size to caller.
> +	 */
> +	if (info->size < size) {
> +		info->size = size;
> +		return 0;
> +	}
> +
> +	spin_lock_irqsave(&device_domain_lock, flags);
> +	/*
> +	 * arbitrary select the first domain_info as all nesting
> +	 * related capabilities should be consistent across iommu
> +	 * units.
> +	 */
> +	domain_info = list_first_entry(&dmar_domain->devices,
> +				       struct device_domain_info, link);
> +	cap &= domain_info->iommu->cap;
> +	ecap &= domain_info->iommu->ecap;
> +	spin_unlock_irqrestore(&device_domain_lock, flags);
> +
> +	info->format = IOMMU_PASID_FORMAT_INTEL_VTD;
> +	info->features = IOMMU_NESTING_FEAT_SYSWIDE_PASID |
> +			 IOMMU_NESTING_FEAT_BIND_PGTBL |
> +			 IOMMU_NESTING_FEAT_CACHE_INVLD;
> +	info->addr_width = dmar_domain->gaw;
> +	info->pasid_bits = ilog2(intel_pasid_max_id);
> +	info->padding = 0;
> +	vtd.flags = 0;
> +	vtd.padding = 0;
> +	vtd.cap_reg = cap;
> +	vtd.ecap_reg = ecap;
> +
> +	memcpy(info->data, &vtd, sizeof(vtd));
> +	return 0;
> +}
> +
> +static int intel_iommu_domain_get_attr(struct iommu_domain *domain,
> +				       enum iommu_attr attr, void *data)
> +{
> +	switch (attr) {
> +	case DOMAIN_ATTR_NESTING:
> +	{
> +		struct iommu_nesting_info *info =
> +				(struct iommu_nesting_info *)data;
> +
> +		return intel_iommu_get_nesting_info(domain, info);
> +	}
> +	default:
> +		return -ENODEV;
-ENOENT?
> +	}
> +}
> +
>  /*
>   * Check that the device does not live on an external facing PCI port that is
>   * marked as untrusted. Such devices should not be able to apply quirks and
> @@ -6101,6 +6177,7 @@ const struct iommu_ops intel_iommu_ops = {
>  	.domain_alloc		= intel_iommu_domain_alloc,
>  	.domain_free		= intel_iommu_domain_free,
>  	.domain_set_attr	= intel_iommu_domain_set_attr,
> +	.domain_get_attr	= intel_iommu_domain_get_attr,
>  	.attach_dev		= intel_iommu_attach_device,
>  	.detach_dev		= intel_iommu_detach_device,
>  	.aux_attach_dev		= intel_iommu_aux_attach_device,
> diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
> index 18f292e..c4ed0d4 100644
> --- a/include/linux/intel-iommu.h
> +++ b/include/linux/intel-iommu.h
> @@ -197,6 +197,22 @@
>  #define ecap_max_handle_mask(e) ((e >> 20) & 0xf)
>  #define ecap_sc_support(e)	((e >> 7) & 0x1) /* Snooping Control */
>  
> +/* Nesting Support Capability Alignment */
> +#define VTD_CAP_FL1GP		BIT_ULL(56)
> +#define VTD_CAP_FL5LP		BIT_ULL(60)
> +#define VTD_ECAP_PRS		BIT_ULL(29)
> +#define VTD_ECAP_ERS		BIT_ULL(30)
> +#define VTD_ECAP_SRS		BIT_ULL(31)
> +#define VTD_ECAP_EAFS		BIT_ULL(34)
> +#define VTD_ECAP_PASID		BIT_ULL(40)

> +
> +/* Only capabilities marked in below MASKs are reported */
> +#define VTD_CAP_MASK		(VTD_CAP_FL1GP | VTD_CAP_FL5LP)
> +
> +#define VTD_ECAP_MASK		(VTD_ECAP_PRS | VTD_ECAP_ERS | \
> +				 VTD_ECAP_SRS | VTD_ECAP_EAFS | \
> +				 VTD_ECAP_PASID)
> +
>  /* Virtual command interface capability */
>  #define vccap_pasid(v)		(((v) & DMA_VCS_PAS)) /* PASID allocation */
>  
> 
Thanks

Eric


