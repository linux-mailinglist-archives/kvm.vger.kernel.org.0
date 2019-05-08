Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB3617E51
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 18:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbfEHQmj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 12:42:39 -0400
Received: from foss.arm.com ([217.140.101.70]:40204 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbfEHQmj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 12:42:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 15A9E374;
        Wed,  8 May 2019 09:42:38 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 31A2E3F238;
        Wed,  8 May 2019 09:42:35 -0700 (PDT)
Subject: Re: [PATCH v7 15/23] dma-iommu: Implement NESTED_MSI cookie
To:     Eric Auger <eric.auger@redhat.com>, eric.auger.pro@gmail.com,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, joro@8bytes.org,
        alex.williamson@redhat.com, jacob.jun.pan@linux.intel.com,
        yi.l.liu@intel.com, jean-philippe.brucker@arm.com,
        will.deacon@arm.com
Cc:     kevin.tian@intel.com, ashok.raj@intel.com, marc.zyngier@arm.com,
        christoffer.dall@arm.com, peter.maydell@linaro.org,
        vincent.stehle@arm.com
References: <20190408121911.24103-1-eric.auger@redhat.com>
 <20190408121911.24103-16-eric.auger@redhat.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <e77ca8ef-4ec0-8fff-fd8b-1cc9cbf7f1b0@arm.com>
Date:   Wed, 8 May 2019 17:42:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408121911.24103-16-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/2019 13:19, Eric Auger wrote:
> Up to now, when the type was UNMANAGED, we used to
> allocate IOVA pages within a reserved IOVA MSI range.
> 
> If both the host and the guest are exposed with SMMUs, each
> would allocate an IOVA. The guest allocates an IOVA (gIOVA)
> to map onto the guest MSI doorbell (gDB). The Host allocates
> another IOVA (hIOVA) to map onto the physical doorbell (hDB).
> 
> So we end up with 2 unrelated mappings, at S1 and S2:
>           S1             S2
> gIOVA    ->     gDB
>                 hIOVA    ->    hDB
> 
> The PCI device would be programmed with hIOVA.
> No stage 1 mapping would existing, causing the MSIs to fault.
> 
> iommu_dma_bind_guest_msi() allows to pass gIOVA/gDB
> to the host so that gIOVA can be used by the host instead of
> re-allocating a new hIOVA.
> 
>           S1           S2
> gIOVA    ->    gDB    ->    hDB
> 
> this time, the PCI device can be programmed with the gIOVA MSI
> doorbell which is correctly mapped through both stages.

Hmm, this implies that both the guest kernel and host userspace are 
totally broken if hDB is a hardware MSI region...

Robin.

> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v6 -> v7:
> - removed device handle
> 
> v3 -> v4:
> - change function names; add unregister
> - protect with msi_lock
> 
> v2 -> v3:
> - also store the device handle on S1 mapping registration.
>    This garantees we associate the associated S2 mapping binds
>    to the correct physical MSI controller.
> 
> v1 -> v2:
> - unmap stage2 on put()
> ---
>   drivers/iommu/dma-iommu.c | 129 +++++++++++++++++++++++++++++++++++++-
>   include/linux/dma-iommu.h |  17 +++++
>   2 files changed, 143 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 77aabe637a60..9905260ad342 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -35,12 +35,15 @@
>   struct iommu_dma_msi_page {
>   	struct list_head	list;
>   	dma_addr_t		iova;
> +	dma_addr_t		gpa;
>   	phys_addr_t		phys;
> +	size_t			s1_granule;
>   };
>   
>   enum iommu_dma_cookie_type {
>   	IOMMU_DMA_IOVA_COOKIE,
>   	IOMMU_DMA_MSI_COOKIE,
> +	IOMMU_DMA_NESTED_MSI_COOKIE,
>   };
>   
>   struct iommu_dma_cookie {
> @@ -110,14 +113,17 @@ EXPORT_SYMBOL(iommu_get_dma_cookie);
>    *
>    * Users who manage their own IOVA allocation and do not want DMA API support,
>    * but would still like to take advantage of automatic MSI remapping, can use
> - * this to initialise their own domain appropriately. Users should reserve a
> + * this to initialise their own domain appropriately. Users may reserve a
>    * contiguous IOVA region, starting at @base, large enough to accommodate the
>    * number of PAGE_SIZE mappings necessary to cover every MSI doorbell address
> - * used by the devices attached to @domain.
> + * used by the devices attached to @domain. The other way round is to provide
> + * usable iova pages through the iommu_dma_bind_doorbell API (nested stages
> + * use case)
>    */
>   int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
>   {
>   	struct iommu_dma_cookie *cookie;
> +	int nesting, ret;
>   
>   	if (domain->type != IOMMU_DOMAIN_UNMANAGED)
>   		return -EINVAL;
> @@ -125,7 +131,12 @@ int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base)
>   	if (domain->iova_cookie)
>   		return -EEXIST;
>   
> -	cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
> +	ret =  iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, &nesting);
> +	if (!ret && nesting)
> +		cookie = cookie_alloc(IOMMU_DMA_NESTED_MSI_COOKIE);
> +	else
> +		cookie = cookie_alloc(IOMMU_DMA_MSI_COOKIE);
> +
>   	if (!cookie)
>   		return -ENOMEM;
>   
> @@ -146,6 +157,7 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
>   {
>   	struct iommu_dma_cookie *cookie = domain->iova_cookie;
>   	struct iommu_dma_msi_page *msi, *tmp;
> +	bool s2_unmap = false;
>   
>   	if (!cookie)
>   		return;
> @@ -153,7 +165,15 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
>   	if (cookie->type == IOMMU_DMA_IOVA_COOKIE && cookie->iovad.granule)
>   		put_iova_domain(&cookie->iovad);
>   
> +	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE)
> +		s2_unmap = true;
> +
>   	list_for_each_entry_safe(msi, tmp, &cookie->msi_page_list, list) {
> +		if (s2_unmap && msi->phys) {
> +			size_t size = cookie_msi_granule(cookie);
> +
> +			WARN_ON(iommu_unmap(domain, msi->gpa, size) != size);
> +		}
>   		list_del(&msi->list);
>   		kfree(msi);
>   	}
> @@ -162,6 +182,82 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
>   }
>   EXPORT_SYMBOL(iommu_put_dma_cookie);
>   
> +/**
> + * iommu_dma_bind_guest_msi - Allows to pass the stage 1
> + * binding of a virtual MSI doorbell used by @dev.
> + *
> + * @domain: domain handle
> + * @iova: guest iova
> + * @gpa: gpa of the virtual doorbell
> + * @size: size of the granule used for the stage1 mapping
> + *
> + * In nested stage use case, the user can provide IOVA/IPA bindings
> + * corresponding to a guest MSI stage 1 mapping. When the host needs
> + * to map its own MSI doorbells, it can use @gpa as stage 2 input
> + * and map it onto the physical MSI doorbell.
> + */
> +int iommu_dma_bind_guest_msi(struct iommu_domain *domain,
> +			     dma_addr_t iova, phys_addr_t gpa, size_t size)
> +{
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iommu_dma_msi_page *msi;
> +	int ret = 0;
> +
> +	if (!cookie)
> +		return -EINVAL;
> +
> +	if (cookie->type != IOMMU_DMA_NESTED_MSI_COOKIE)
> +		return -EINVAL;
> +
> +	iova = iova & ~(dma_addr_t)(size - 1);
> +	gpa = gpa & ~(phys_addr_t)(size - 1);
> +
> +	spin_lock(&cookie->msi_lock);
> +
> +	list_for_each_entry(msi, &cookie->msi_page_list, list) {
> +		if (msi->iova == iova)
> +			goto unlock; /* this page is already registered */
> +	}
> +
> +	msi = kzalloc(sizeof(*msi), GFP_ATOMIC);
> +	if (!msi) {
> +		ret = -ENOMEM;
> +		goto unlock;
> +	}
> +
> +	msi->iova = iova;
> +	msi->gpa = gpa;
> +	msi->s1_granule = size;
> +	list_add(&msi->list, &cookie->msi_page_list);
> +unlock:
> +	spin_unlock(&cookie->msi_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(iommu_dma_bind_guest_msi);
> +
> +void iommu_dma_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova)
> +{
> +	struct iommu_dma_cookie *cookie = domain->iova_cookie;
> +	struct iommu_dma_msi_page *msi, *tmp;
> +
> +	list_for_each_entry_safe(msi, tmp, &cookie->msi_page_list, list) {
> +		dma_addr_t aligned_giova =
> +			giova & ~(dma_addr_t)(msi->s1_granule - 1);
> +
> +		if (msi->iova == aligned_giova) {
> +			if (msi->phys) {
> +				/* unmap the stage 2 */
> +				size_t size = cookie_msi_granule(cookie);
> +
> +				WARN_ON(iommu_unmap(domain, msi->gpa, size) != size);
> +			}
> +			list_del(&msi->list);
> +			kfree(msi);
> +		}
> +	}
> +}
> +EXPORT_SYMBOL(iommu_dma_unbind_guest_msi);
> +
>   /**
>    * iommu_dma_get_resv_regions - Reserved region driver helper
>    * @dev: Device from iommu_get_resv_regions()
> @@ -869,6 +965,33 @@ static struct iommu_dma_msi_page *iommu_dma_get_msi_page(struct device *dev,
>   		if (msi_page->phys == msi_addr)
>   			return msi_page;
>   
> +	/*
> +	 * In nested stage mode, we do not allocate an MSI page in
> +	 * a range provided by the user. Instead, IOVA/IPA bindings are
> +	 * individually provided. We reuse thise IOVAs to build the
> +	 * GIOVA -> GPA -> MSI HPA nested stage mapping.
> +	 */
> +	if (cookie->type == IOMMU_DMA_NESTED_MSI_COOKIE) {
> +		list_for_each_entry(msi_page, &cookie->msi_page_list, list)
> +			if (!msi_page->phys) {
> +				int ret;
> +
> +				/* do the stage 2 mapping */
> +				ret = iommu_map(domain,
> +						msi_page->gpa, msi_addr, size,
> +						IOMMU_MMIO | IOMMU_WRITE);
> +				if (ret) {
> +					pr_warn("MSI S2 mapping failed (%d)\n",
> +						ret);
> +					return NULL;
> +				}
> +				msi_page->phys = msi_addr;
> +				return msi_page;
> +			}
> +		pr_warn("%s no MSI binding found\n", __func__);
> +		return NULL;
> +	}
> +
>   	msi_page = kzalloc(sizeof(*msi_page), GFP_ATOMIC);
>   	if (!msi_page)
>   		return NULL;
> diff --git a/include/linux/dma-iommu.h b/include/linux/dma-iommu.h
> index e760dc5d1fa8..fa898d514edb 100644
> --- a/include/linux/dma-iommu.h
> +++ b/include/linux/dma-iommu.h
> @@ -24,6 +24,7 @@
>   #include <linux/dma-mapping.h>
>   #include <linux/iommu.h>
>   #include <linux/msi.h>
> +#include <uapi/linux/iommu.h>
>   
>   int iommu_dma_init(void);
>   
> @@ -73,6 +74,9 @@ void iommu_dma_unmap_resource(struct device *dev, dma_addr_t handle,
>   /* The DMA API isn't _quite_ the whole story, though... */
>   void iommu_dma_map_msi_msg(int irq, struct msi_msg *msg);
>   void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list);
> +int iommu_dma_bind_guest_msi(struct iommu_domain *domain,
> +			     dma_addr_t iova, phys_addr_t gpa, size_t size);
> +void iommu_dma_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova);
>   
>   #else
>   
> @@ -103,6 +107,19 @@ static inline void iommu_dma_map_msi_msg(int irq, struct msi_msg *msg)
>   {
>   }
>   
> +static inline int
> +iommu_dma_bind_guest_msi(struct iommu_domain *domain, struct device *dev,
> +			 dma_addr_t iova, phys_addr_t gpa, size_t size)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline void
> +iommu_dma_unbind_guest_msi(struct iommu_domain *domain,
> +			   struct device *dev, dma_addr_t giova);
> +{
> +}
> +
>   static inline void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list)
>   {
>   }
> 
