Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D922313CD9
	for <lists+kvm@lfdr.de>; Sun,  5 May 2019 04:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfEECoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 May 2019 22:44:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:46360 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbfEECoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 4 May 2019 22:44:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 May 2019 19:44:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,431,1549958400"; 
   d="scan'208";a="146346574"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by fmsmga008.fm.intel.com with ESMTP; 04 May 2019 19:43:55 -0700
Cc:     baolu.lu@linux.intel.com, murphyt7@tcd.ie,
        Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-tegra@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC 6/7] iommu/vt-d: convert the intel iommu driver to the
 dma-iommu ops api
To:     Tom Murphy <tmurphy@arista.com>, iommu@lists.linux-foundation.org
References: <20190504132327.27041-1-tmurphy@arista.com>
 <20190504132327.27041-7-tmurphy@arista.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <602b77a2-9c68-ad14-b64f-904a7ff27a15@linux.intel.com>
Date:   Sun, 5 May 2019 10:37:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504132327.27041-7-tmurphy@arista.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/4/19 9:23 PM, Tom Murphy wrote:
> static int intel_iommu_add_device(struct device *dev)
>   {
> +	struct dmar_domain *dmar_domain;
> +	struct iommu_domain *domain;
>   	struct intel_iommu *iommu;
>   	struct iommu_group *group;
> -	struct iommu_domain *domain;
> +	dma_addr_t base;
>   	u8 bus, devfn;
>   
>   	iommu = device_to_iommu(dev, &bus, &devfn);
> @@ -4871,9 +4514,12 @@ static int intel_iommu_add_device(struct device *dev)
>   	if (IS_ERR(group))
>   		return PTR_ERR(group);
>   
> +	base = IOVA_START_PFN << VTD_PAGE_SHIFT;
>   	domain = iommu_get_domain_for_dev(dev);
> +	dmar_domain = to_dmar_domain(domain);
>   	if (domain->type == IOMMU_DOMAIN_DMA)
> -		dev->dma_ops = &intel_dma_ops;
> +		iommu_setup_dma_ops(dev, base,
> +				__DOMAIN_MAX_ADDR(dmar_domain->gaw) - base);

I didn't find the implementation of iommu_setup_dma_ops() in this
series. Will the iova resource be initialized in this function?

If so, will this block iommu_group_create_direct_mappings() which
reserves and maps the reserved iova ranges.

>   
>   	iommu_group_put(group);
>   	return 0;
> @@ -5002,19 +4648,6 @@ int intel_iommu_enable_pasid(struct intel_iommu *iommu, struct intel_svm_dev *sd
>   	return ret;
>   }
>   
> -static void intel_iommu_apply_resv_region(struct device *dev,
> -					  struct iommu_domain *domain,
> -					  struct iommu_resv_region *region)
> -{
> -	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
> -	unsigned long start, end;
> -
> -	start = IOVA_PFN(region->start);
> -	end   = IOVA_PFN(region->start + region->length - 1);
> -
> -	WARN_ON_ONCE(!reserve_iova(&dmar_domain->iovad, start, end));
> -}
> -
>   struct intel_iommu *intel_svm_device_to_iommu(struct device *dev)
>   {
>   	struct intel_iommu *iommu;
> @@ -5050,13 +4683,13 @@ const struct iommu_ops intel_iommu_ops = {
>   	.detach_dev		= intel_iommu_detach_device,
>   	.map			= intel_iommu_map,
>   	.unmap			= intel_iommu_unmap,
> +	.flush_iotlb_all	= iommu_flush_iova,
>   	.flush_iotlb_range	= intel_iommu_flush_iotlb_range,
>   	.iova_to_phys		= intel_iommu_iova_to_phys,
>   	.add_device		= intel_iommu_add_device,
>   	.remove_device		= intel_iommu_remove_device,
>   	.get_resv_regions	= intel_iommu_get_resv_regions,
>   	.put_resv_regions	= intel_iommu_put_resv_regions,
> -	.apply_resv_region	= intel_iommu_apply_resv_region,

With this removed, how will iommu_group_create_direct_mappings() work?

Best regards,
Lu Baolu
