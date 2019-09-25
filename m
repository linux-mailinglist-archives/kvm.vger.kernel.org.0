Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C164BD789
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 07:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411588AbfIYFAh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 25 Sep 2019 01:00:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:30416 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392901AbfIYFAh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 01:00:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Sep 2019 22:00:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,546,1559545200"; 
   d="scan'208";a="389099359"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga005.fm.intel.com with ESMTP; 24 Sep 2019 22:00:36 -0700
Received: from fmsmsx112.amr.corp.intel.com (10.18.116.6) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Sep 2019 22:00:36 -0700
Received: from shsmsx154.ccr.corp.intel.com (10.239.6.54) by
 FMSMSX112.amr.corp.intel.com (10.18.116.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 24 Sep 2019 22:00:36 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX154.ccr.corp.intel.com ([169.254.7.195]) with mapi id 14.03.0439.000;
 Wed, 25 Sep 2019 13:00:34 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Sun, Yi Y" <yi.y.sun@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: RE: [RFC PATCH 3/4] iommu/vt-d: Map/unmap domain with mmmap/mmunmap
Thread-Topic: [RFC PATCH 3/4] iommu/vt-d: Map/unmap domain with mmmap/mmunmap
Thread-Index: AQHVcgpE6R/hKdlXw06opjb4d97sh6c719ng
Date:   Wed, 25 Sep 2019 05:00:34 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D58F0B7@SHSMSX104.ccr.corp.intel.com>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122454.9888-4-baolu.lu@linux.intel.com>
In-Reply-To: <20190923122454.9888-4-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTNkM2FjODUtYzVhNC00NDdlLWFkOTUtMDhkMjMxOWNmZDQyIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRGsya0RFYkw5b01DV2tWQkFMeG1TTmwwUVdFWm90bTlPWjdYUSt4YmdQand0XC9ON1wvM1FDNWh1SzVnVWtZUXRaIn0=
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Lu Baolu [mailto:baolu.lu@linux.intel.com]
> Sent: Monday, September 23, 2019 8:25 PM
> 
> If a dmar domain has DOMAIN_FLAG_FIRST_LEVEL_TRANS bit set
> in its flags, IOMMU will use the first level page table for
> translation. Hence, we need to map or unmap addresses in the
> first level page table.
> 
> Cc: Ashok Raj <ashok.raj@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Liu Yi L <yi.l.liu@intel.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/intel-iommu.c | 94 ++++++++++++++++++++++++++++++++-
> ----
>  1 file changed, 82 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
> index 9cfe8098d993..103480016010 100644
> --- a/drivers/iommu/intel-iommu.c
> +++ b/drivers/iommu/intel-iommu.c
> @@ -168,6 +168,11 @@ static inline unsigned long virt_to_dma_pfn(void
> *p)
>  	return page_to_dma_pfn(virt_to_page(p));
>  }
> 
> +static inline unsigned long dma_pfn_to_addr(unsigned long pfn)
> +{
> +	return pfn << VTD_PAGE_SHIFT;
> +}
> +
>  /* global iommu list, set NULL for ignored DMAR units */
>  static struct intel_iommu **g_iommus;
> 
> @@ -307,6 +312,9 @@ static int hw_pass_through = 1;
>   */
>  #define DOMAIN_FLAG_LOSE_CHILDREN		BIT(1)
> 
> +/* Domain uses first level translation for DMA remapping. */
> +#define DOMAIN_FLAG_FIRST_LEVEL_TRANS		BIT(2)
> +
>  #define for_each_domain_iommu(idx, domain)			\
>  	for (idx = 0; idx < g_num_of_iommus; idx++)		\
>  		if (domain->iommu_refcnt[idx])
> @@ -552,6 +560,11 @@ static inline int domain_type_is_si(struct
> dmar_domain *domain)
>  	return domain->flags & DOMAIN_FLAG_STATIC_IDENTITY;
>  }
> 
> +static inline int domain_type_is_flt(struct dmar_domain *domain)
> +{
> +	return domain->flags & DOMAIN_FLAG_FIRST_LEVEL_TRANS;
> +}
> +
>  static inline int domain_pfn_supported(struct dmar_domain *domain,
>  				       unsigned long pfn)
>  {
> @@ -1147,8 +1160,15 @@ static struct page *domain_unmap(struct
> dmar_domain *domain,
>  	BUG_ON(start_pfn > last_pfn);
> 
>  	/* we don't need lock here; nobody else touches the iova range */
> -	freelist = dma_pte_clear_level(domain, agaw_to_level(domain-
> >agaw),
> -				       domain->pgd, 0, start_pfn, last_pfn,
> NULL);
> +	if (domain_type_is_flt(domain))
> +		freelist = intel_mmunmap_range(domain,
> +					       dma_pfn_to_addr(start_pfn),
> +					       dma_pfn_to_addr(last_pfn + 1));
> +	else
> +		freelist = dma_pte_clear_level(domain,
> +					       agaw_to_level(domain->agaw),
> +					       domain->pgd, 0, start_pfn,
> +					       last_pfn, NULL);

what about providing an unified interface at the caller side, then having 
the level differentiated within the interface?

> 
>  	/* free pgd */
>  	if (start_pfn == 0 && last_pfn == DOMAIN_MAX_PFN(domain->gaw))
> {
> @@ -2213,9 +2233,10 @@ static inline int hardware_largepage_caps(struct
> dmar_domain *domain,
>  	return level;
>  }
> 
> -static int __domain_mapping(struct dmar_domain *domain, unsigned long
> iov_pfn,
> -			    struct scatterlist *sg, unsigned long phys_pfn,
> -			    unsigned long nr_pages, int prot)
> +static int
> +__domain_mapping_dma(struct dmar_domain *domain, unsigned long
> iov_pfn,
> +		     struct scatterlist *sg, unsigned long phys_pfn,
> +		     unsigned long nr_pages, int prot)
>  {
>  	struct dma_pte *first_pte = NULL, *pte = NULL;
>  	phys_addr_t uninitialized_var(pteval);
> @@ -2223,13 +2244,6 @@ static int __domain_mapping(struct
> dmar_domain *domain, unsigned long iov_pfn,
>  	unsigned int largepage_lvl = 0;
>  	unsigned long lvl_pages = 0;
> 
> -	BUG_ON(!domain_pfn_supported(domain, iov_pfn + nr_pages - 1));
> -
> -	if ((prot & (DMA_PTE_READ|DMA_PTE_WRITE)) == 0)
> -		return -EINVAL;
> -
> -	prot &= DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP;
> -
>  	if (!sg) {
>  		sg_res = nr_pages;
>  		pteval = ((phys_addr_t)phys_pfn << VTD_PAGE_SHIFT) |
> prot;
> @@ -2328,6 +2342,62 @@ static int __domain_mapping(struct
> dmar_domain *domain, unsigned long iov_pfn,
>  	return 0;
>  }
> 
> +static int
> +__domain_mapping_mm(struct dmar_domain *domain, unsigned long
> iov_pfn,
> +		    struct scatterlist *sg, unsigned long phys_pfn,
> +		    unsigned long nr_pages, int prot)
> +{
> +	int ret = 0;
> +
> +	if (!sg)
> +		return intel_mmmap_range(domain,
> dma_pfn_to_addr(iov_pfn),
> +					 dma_pfn_to_addr(iov_pfn +
> nr_pages),
> +					 dma_pfn_to_addr(phys_pfn), prot);
> +
> +	while (nr_pages > 0) {
> +		unsigned long sg_pages, phys;
> +		unsigned long pgoff = sg->offset & ~PAGE_MASK;
> +
> +		sg_pages = aligned_nrpages(sg->offset, sg->length);
> +		phys = sg_phys(sg) - pgoff;
> +
> +		ret = intel_mmmap_range(domain,
> dma_pfn_to_addr(iov_pfn),
> +					dma_pfn_to_addr(iov_pfn +
> sg_pages),
> +					phys, prot);
> +		if (ret)
> +			break;
> +
> +		sg->dma_address =
> ((dma_addr_t)dma_pfn_to_addr(iov_pfn)) + pgoff;
> +		sg->dma_length = sg->length;
> +
> +		nr_pages -= sg_pages;
> +		iov_pfn += sg_pages;
> +		sg = sg_next(sg);
> +	}
> +
> +	return ret;
> +}
> +
> +static int
> +__domain_mapping(struct dmar_domain *domain, unsigned long iov_pfn,
> +		 struct scatterlist *sg, unsigned long phys_pfn,
> +		 unsigned long nr_pages, int prot)
> +{
> +	BUG_ON(!domain_pfn_supported(domain, iov_pfn + nr_pages - 1));
> +
> +	if ((prot & (DMA_PTE_READ|DMA_PTE_WRITE)) == 0)
> +		return -EINVAL;
> +
> +	prot &= DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP;
> +
> +	if (domain_type_is_flt(domain))
> +		return __domain_mapping_mm(domain, iov_pfn, sg,
> +					   phys_pfn, nr_pages, prot);
> +	else
> +		return __domain_mapping_dma(domain, iov_pfn, sg,
> +					    phys_pfn, nr_pages, prot);
> +}
> +
>  static int domain_mapping(struct dmar_domain *domain, unsigned long
> iov_pfn,
>  			  struct scatterlist *sg, unsigned long phys_pfn,
>  			  unsigned long nr_pages, int prot)
> --
> 2.17.1

