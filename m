Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE031436A
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 03:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfEFBsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 May 2019 21:48:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:49033 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfEFBsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 May 2019 21:48:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 May 2019 18:48:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,435,1549958400"; 
   d="scan'208";a="146640656"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by fmsmga008.fm.intel.com with ESMTP; 05 May 2019 18:48:39 -0700
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
Subject: Re: [RFC 1/7] iommu/vt-d: Set the dma_ops per device so we can remove
 the iommu_no_mapping code
To:     Tom Murphy <tmurphy@arista.com>, iommu@lists.linux-foundation.org
References: <20190504132327.27041-1-tmurphy@arista.com>
 <20190504132327.27041-2-tmurphy@arista.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <8fef18f5-773c-e1c9-2537-c9dff5bfd35e@linux.intel.com>
Date:   Mon, 6 May 2019 09:42:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190504132327.27041-2-tmurphy@arista.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 5/4/19 9:23 PM, Tom Murphy wrote:
> Set the dma_ops per device so we can remove the iommu_no_mapping code.
> 
> Signed-off-by: Tom Murphy<tmurphy@arista.com>
> ---
>   drivers/iommu/intel-iommu.c | 85 +++----------------------------------
>   1 file changed, 6 insertions(+), 79 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index eace915602f0..2db1dc47e7e4 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -2622,17 +2622,6 @@ static int __init si_domain_init(int hw)
>   	return 0;
>   }
>   
> -static int identity_mapping(struct device *dev)
> -{
> -	struct device_domain_info *info;
> -
> -	info = dev->archdata.iommu;
> -	if (info && info != DUMMY_DEVICE_DOMAIN_INFO)
> -		return (info->domain == si_domain);
> -
> -	return 0;
> -}
> -
>   static int domain_add_dev_info(struct dmar_domain *domain, struct device *dev)
>   {
>   	struct dmar_domain *ndomain;
> @@ -3270,43 +3259,6 @@ static unsigned long intel_alloc_iova(struct device *dev,
>   	return iova_pfn;
>   }
>   
> -/* Check if the dev needs to go through non-identity map and unmap process.*/
> -static int iommu_no_mapping(struct device *dev)
> -{
> -	int found;
> -
> -	if (iommu_dummy(dev))
> -		return 1;
> -
> -	found = identity_mapping(dev);
> -	if (found) {
> -		/*
> -		 * If the device's dma_mask is less than the system's memory
> -		 * size then this is not a candidate for identity mapping.
> -		 */
> -		u64 dma_mask = *dev->dma_mask;
> -
> -		if (dev->coherent_dma_mask &&
> -		    dev->coherent_dma_mask < dma_mask)
> -			dma_mask = dev->coherent_dma_mask;
> -
> -		if (dma_mask < dma_get_required_mask(dev)) {
> -			/*
> -			 * 32 bit DMA is removed from si_domain and fall back
> -			 * to non-identity mapping.
> -			 */
> -			dmar_remove_one_dev_info(dev);
> -			dev_warn(dev, "32bit DMA uses non-identity mapping\n");
> -
> -			return 0;
> -		}

The iommu_no_mapping() also checks whether any 32bit DMA device uses
identity mapping. The device might not work if the system memory space
is bigger than 4G.

Will you add this to other place, or it's unnecessary?

Best regards,
Lu Baolu
