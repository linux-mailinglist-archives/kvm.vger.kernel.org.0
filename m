Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A97417B2E
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 15:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfEHN7o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 09:59:44 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:35278 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfEHN7o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 09:59:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1CCFA78;
        Wed,  8 May 2019 06:59:43 -0700 (PDT)
Received: from [10.1.196.75] (e110467-lin.cambridge.arm.com [10.1.196.75])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B3D493F238;
        Wed,  8 May 2019 06:59:40 -0700 (PDT)
Subject: Re: [PATCH v7 06/23] iommu: Introduce bind/unbind_guest_msi
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
 <20190408121911.24103-7-eric.auger@redhat.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <a11e6535-9e9e-ed8d-9d19-1f9d895effa6@arm.com>
Date:   Wed, 8 May 2019 14:59:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190408121911.24103-7-eric.auger@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/04/2019 13:18, Eric Auger wrote:
> On ARM, MSI are translated by the SMMU. An IOVA is allocated
> for each MSI doorbell. If both the host and the guest are exposed
> with SMMUs, we end up with 2 different IOVAs allocated by each.
> guest allocates an IOVA (gIOVA) to map onto the guest MSI
> doorbell (gDB). The Host allocates another IOVA (hIOVA) to map
> onto the physical doorbell (hDB).
> 
> So we end up with 2 untied mappings:
>           S1            S2
> gIOVA    ->    gDB
>                hIOVA    ->    hDB
> 
> Currently the PCI device is programmed by the host with hIOVA
> as MSI doorbell. So this does not work.
> 
> This patch introduces an API to pass gIOVA/gDB to the host so
> that gIOVA can be reused by the host instead of re-allocating
> a new IOVA. So the goal is to create the following nested mapping:
> 
>           S1            S2
> gIOVA    ->    gDB     ->    hDB
> 
> and program the PCI device with gIOVA MSI doorbell.
> 
> In case we have several devices attached to this nested domain
> (devices belonging to the same group), they cannot be isolated
> on guest side either. So they should also end up in the same domain
> on guest side. We will enforce that all the devices attached to
> the host iommu domain use the same physical doorbell and similarly
> a single virtual doorbell mapping gets registered (1 single
> virtual doorbell is used on guest as well).
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> v6 -> v7:
> - remove the device handle parameter.
> - Add comments saying there can only be a single MSI binding
>    registered per iommu_domain
> v5 -> v6:
> -fix compile issue when IOMMU_API is not set
> 
> v3 -> v4:
> - add unbind
> 
> v2 -> v3:
> - add a struct device handle
> ---
>   drivers/iommu/iommu.c | 37 +++++++++++++++++++++++++++++++++++++
>   include/linux/iommu.h | 23 +++++++++++++++++++++++
>   2 files changed, 60 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 6d6cb4005ca5..0d160bbd6f81 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1575,6 +1575,43 @@ static void __iommu_detach_device(struct iommu_domain *domain,
>   	trace_detach_device_from_domain(dev);
>   }
>   
> +/**
> + * iommu_bind_guest_msi - Passes the stage1 GIOVA/GPA mapping of a
> + * virtual doorbell
> + *
> + * @domain: iommu domain the stage 1 mapping will be attached to
> + * @iova: iova allocated by the guest
> + * @gpa: guest physical address of the virtual doorbell
> + * @size: granule size used for the mapping
> + *
> + * The associated IOVA can be reused by the host to create a nested
> + * stage2 binding mapping translating into the physical doorbell used
> + * by the devices attached to the domain.
> + *
> + * All devices within the domain must share the same physical doorbell.
> + * A single MSI GIOVA/GPA mapping can be attached to an iommu_domain.
> + */
> +
> +int iommu_bind_guest_msi(struct iommu_domain *domain,
> +			 dma_addr_t giova, phys_addr_t gpa, size_t size)
> +{
> +	if (unlikely(!domain->ops->bind_guest_msi))
> +		return -ENODEV;
> +
> +	return domain->ops->bind_guest_msi(domain, giova, gpa, size);
> +}
> +EXPORT_SYMBOL_GPL(iommu_bind_guest_msi);
> +
> +void iommu_unbind_guest_msi(struct iommu_domain *domain,
> +			    dma_addr_t iova)
> +{
> +	if (unlikely(!domain->ops->unbind_guest_msi))
> +		return;
> +
> +	domain->ops->unbind_guest_msi(domain, iova);
> +}
> +EXPORT_SYMBOL_GPL(iommu_unbind_guest_msi);
> +
>   void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
>   {
>   	struct iommu_group *group;
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 7c7c6bad1420..a2f3f964ead2 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -192,6 +192,8 @@ struct iommu_resv_region {
>    * @attach_pasid_table: attach a pasid table
>    * @detach_pasid_table: detach the pasid table
>    * @cache_invalidate: invalidate translation caches
> + * @bind_guest_msi: provides a stage1 giova/gpa MSI doorbell mapping
> + * @unbind_guest_msi: withdraw a stage1 giova/gpa MSI doorbell mapping
>    * @pgsize_bitmap: bitmap of all possible supported page sizes
>    */
>   struct iommu_ops {
> @@ -243,6 +245,10 @@ struct iommu_ops {
>   	int (*cache_invalidate)(struct iommu_domain *domain, struct device *dev,
>   				struct iommu_cache_invalidate_info *inv_info);
>   
> +	int (*bind_guest_msi)(struct iommu_domain *domain,
> +			      dma_addr_t giova, phys_addr_t gpa, size_t size);
> +	void (*unbind_guest_msi)(struct iommu_domain *domain, dma_addr_t giova);
> +
>   	unsigned long pgsize_bitmap;
>   };
>   
> @@ -356,6 +362,11 @@ extern void iommu_detach_pasid_table(struct iommu_domain *domain);
>   extern int iommu_cache_invalidate(struct iommu_domain *domain,
>   				  struct device *dev,
>   				  struct iommu_cache_invalidate_info *inv_info);
> +extern int iommu_bind_guest_msi(struct iommu_domain *domain,
> +				dma_addr_t giova, phys_addr_t gpa, size_t size);
> +extern void iommu_unbind_guest_msi(struct iommu_domain *domain,
> +				   dma_addr_t giova);
> +
>   extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
>   extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
>   extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
> @@ -812,6 +823,18 @@ iommu_cache_invalidate(struct iommu_domain *domain,
>   	return -ENODEV;
>   }
>   
> +static inline
> +int iommu_bind_guest_msi(struct iommu_domain *domain,
> +			 dma_addr_t giova, phys_addr_t gpa, size_t size)
> +{
> +	return -ENODEV;
> +}
> +static inline
> +int iommu_unbind_guest_msi(struct iommu_domain *domain, dma_addr_t giova)
> +{
> +	return -ENODEV;

It's less of a problem than mismatching the other way round, but for 
consistency this should return void like the real version.

Robin.

> +}
> +
>   #endif /* CONFIG_IOMMU_API */
>   
>   #ifdef CONFIG_IOMMU_DEBUGFS
> 
