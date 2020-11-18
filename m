Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9092B8197
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 17:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgKRQRI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 11:17:08 -0500
Received: from mga05.intel.com ([192.55.52.43]:29216 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbgKRQRI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Nov 2020 11:17:08 -0500
IronPort-SDR: 4Hd5tqK4n5BorG1TpWStgObwhbRMA87jpCHo/i+boDNjnVymr/KS0GoJnfsJ/zzpiOc3tiYTsh
 xmE5Ysc+noLw==
X-IronPort-AV: E=McAfee;i="6000,8403,9808"; a="255851120"
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="255851120"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 08:17:06 -0800
IronPort-SDR: lcKzzWY9cqfU4Mn4czy7ppuNSZ/hpiiZkLLjIcNakjW2zfskIFwuIX9SGAEQI+cXeyrm866Re5
 I3HnLhyY5zqg==
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="357041404"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 08:17:05 -0800
Date:   Wed, 18 Nov 2020 08:19:40 -0800
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, will@kernel.org, joro@8bytes.org,
        maz@kernel.org, robin.murphy@arm.com, alex.williamson@redhat.com,
        jean-philippe@linaro.org, zhangfei.gao@linaro.org,
        zhangfei.gao@gmail.com, vivek.gautam@arm.com,
        shameerali.kolothum.thodi@huawei.com, yi.l.liu@intel.com,
        tn@semihalf.com, nicoleotsuka@gmail.com, yuzenghui@huawei.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v13 01/15] iommu: Introduce attach/detach_pasid_table
 API
Message-ID: <20201118081940.3192ac1c@jacob-builder>
In-Reply-To: <20201118112151.25412-2-eric.auger@redhat.com>
References: <20201118112151.25412-1-eric.auger@redhat.com>
        <20201118112151.25412-2-eric.auger@redhat.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Wed, 18 Nov 2020 12:21:37 +0100, Eric Auger <eric.auger@redhat.com>
wrote:

> In virtualization use case, when a guest is assigned
> a PCI host device, protected by a virtual IOMMU on the guest,
> the physical IOMMU must be programmed to be consistent with
> the guest mappings. If the physical IOMMU supports two
> translation stages it makes sense to program guest mappings
> onto the first stage/level (ARM/Intel terminology) while the host
> owns the stage/level 2.
> 
> In that case, it is mandated to trap on guest configuration
> settings and pass those to the physical iommu driver.
> 
> This patch adds a new API to the iommu subsystem that allows
> to set/unset the pasid table information.
> 
> A generic iommu_pasid_table_config struct is introduced in
> a new iommu.h uapi header. This is going to be used by the VFIO
> user API.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> Signed-off-by: Liu, Yi L <yi.l.liu@linux.intel.com>
> Signed-off-by: Ashok Raj <ashok.raj@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v12 -> v13:
> - Fix config check
> 
> v11 -> v12:
> - add argsz, name the union
> ---
>  drivers/iommu/iommu.c      | 68 ++++++++++++++++++++++++++++++++++++++
>  include/linux/iommu.h      | 21 ++++++++++++
>  include/uapi/linux/iommu.h | 54 ++++++++++++++++++++++++++++++
>  3 files changed, 143 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index b53446bb8c6b..978fe34378fb 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2171,6 +2171,74 @@ int iommu_uapi_sva_unbind_gpasid(struct
> iommu_domain *domain, struct device *dev }
>  EXPORT_SYMBOL_GPL(iommu_uapi_sva_unbind_gpasid);
>  
> +int iommu_attach_pasid_table(struct iommu_domain *domain,
> +			     struct iommu_pasid_table_config *cfg)
> +{
> +	if (unlikely(!domain->ops->attach_pasid_table))
> +		return -ENODEV;
> +
> +	return domain->ops->attach_pasid_table(domain, cfg);
> +}
> +
> +int iommu_uapi_attach_pasid_table(struct iommu_domain *domain,
> +				  void __user *uinfo)
> +{
> +	struct iommu_pasid_table_config pasid_table_data = { 0 };
> +	u32 minsz;
> +
> +	if (unlikely(!domain->ops->attach_pasid_table))
> +		return -ENODEV;
> +
> +	/*
> +	 * No new spaces can be added before the variable sized union,
> the
> +	 * minimum size is the offset to the union.
> +	 */
> +	minsz = offsetof(struct iommu_pasid_table_config, vendor_data);
> +
> +	/* Copy minsz from user to get flags and argsz */
> +	if (copy_from_user(&pasid_table_data, uinfo, minsz))
> +		return -EFAULT;
> +
> +	/* Fields before the variable size union are mandatory */
> +	if (pasid_table_data.argsz < minsz)
> +		return -EINVAL;
> +
> +	/* PASID and address granu require additional info beyond minsz
> */
> +	if (pasid_table_data.version != PASID_TABLE_CFG_VERSION_1)
> +		return -EINVAL;
> +	if (pasid_table_data.format == IOMMU_PASID_FORMAT_SMMUV3 &&
> +	    pasid_table_data.argsz <
> +		offsetofend(struct iommu_pasid_table_config,
> vendor_data.smmuv3))
> +		return -EINVAL;
> +
> +	/*
> +	 * User might be using a newer UAPI header which has a larger
> data
> +	 * size, we shall support the existing flags within the current
> +	 * size. Copy the remaining user data _after_ minsz but not more
> +	 * than the current kernel supported size.
> +	 */
> +	if (copy_from_user((void *)&pasid_table_data + minsz, uinfo +
> minsz,
> +			   min_t(u32, pasid_table_data.argsz,
> sizeof(pasid_table_data)) - minsz))
> +		return -EFAULT;
> +
> +	/* Now the argsz is validated, check the content */
> +	if (pasid_table_data.config < IOMMU_PASID_CONFIG_TRANSLATE ||
> +	    pasid_table_data.config > IOMMU_PASID_CONFIG_ABORT)
> +		return -EINVAL;
> +
> +	return domain->ops->attach_pasid_table(domain,
> &pasid_table_data); +}
> +EXPORT_SYMBOL_GPL(iommu_uapi_attach_pasid_table);
> +
> +void iommu_detach_pasid_table(struct iommu_domain *domain)
> +{
> +	if (unlikely(!domain->ops->detach_pasid_table))
> +		return;
> +
> +	domain->ops->detach_pasid_table(domain);
> +}
> +EXPORT_SYMBOL_GPL(iommu_detach_pasid_table);
> +
>  static void __iommu_detach_device(struct iommu_domain *domain,
>  				  struct device *dev)
>  {
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index b95a6f8db6ff..464fcbecf841 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -223,6 +223,8 @@ struct iommu_iotlb_gather {
>   * @cache_invalidate: invalidate translation caches
>   * @sva_bind_gpasid: bind guest pasid and mm
>   * @sva_unbind_gpasid: unbind guest pasid and mm
> + * @attach_pasid_table: attach a pasid table
> + * @detach_pasid_table: detach the pasid table
>   * @def_domain_type: device default domain type, return value:
>   *		- IOMMU_DOMAIN_IDENTITY: must use an identity domain
>   *		- IOMMU_DOMAIN_DMA: must use a dma domain
> @@ -287,6 +289,9 @@ struct iommu_ops {
>  				      void *drvdata);
>  	void (*sva_unbind)(struct iommu_sva *handle);
>  	u32 (*sva_get_pasid)(struct iommu_sva *handle);
> +	int (*attach_pasid_table)(struct iommu_domain *domain,
> +				  struct iommu_pasid_table_config *cfg);
> +	void (*detach_pasid_table)(struct iommu_domain *domain);
>  
>  	int (*page_response)(struct device *dev,
>  			     struct iommu_fault_event *evt,
> @@ -434,6 +439,11 @@ extern int iommu_uapi_sva_unbind_gpasid(struct
> iommu_domain *domain, struct device *dev, void __user *udata);
>  extern int iommu_sva_unbind_gpasid(struct iommu_domain *domain,
>  				   struct device *dev, ioasid_t pasid);
> +extern int iommu_attach_pasid_table(struct iommu_domain *domain,
> +				    struct iommu_pasid_table_config
> *cfg); +extern int iommu_uapi_attach_pasid_table(struct iommu_domain
> *domain,
> +					 void __user *udata);
> +extern void iommu_detach_pasid_table(struct iommu_domain *domain);
>  extern struct iommu_domain *iommu_get_domain_for_dev(struct device *dev);
>  extern struct iommu_domain *iommu_get_dma_domain(struct device *dev);
>  extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
> @@ -639,6 +649,7 @@ struct iommu_sva *iommu_sva_bind_device(struct device
> *dev, void iommu_sva_unbind_device(struct iommu_sva *handle);
>  u32 iommu_sva_get_pasid(struct iommu_sva *handle);
>  
> +
>  #else /* CONFIG_IOMMU_API */
>  
>  struct iommu_ops {};
> @@ -1020,6 +1031,16 @@ iommu_aux_get_pasid(struct iommu_domain *domain,
> struct device *dev) return -ENODEV;
>  }
>  
> +static inline
> +int iommu_attach_pasid_table(struct iommu_domain *domain,
> +			     struct iommu_pasid_table_config *cfg)
> +{
> +	return -ENODEV;
> +}
> +
> +static inline
> +void iommu_detach_pasid_table(struct iommu_domain *domain) {}
> +
>  static inline struct iommu_sva *
>  iommu_sva_bind_device(struct device *dev, struct mm_struct *mm, void
> *drvdata) {
> diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> index e1d9e75f2c94..082d758dd016 100644
> --- a/include/uapi/linux/iommu.h
> +++ b/include/uapi/linux/iommu.h
> @@ -338,4 +338,58 @@ struct iommu_gpasid_bind_data {
>  	} vendor;
>  };
>  
> +/**
> + * struct iommu_pasid_smmuv3 - ARM SMMUv3 Stream Table Entry stage 1
> related
> + *     information
> + * @version: API version of this structure
> + * @s1fmt: STE s1fmt (format of the CD table: single CD, linear table
> + *         or 2-level table)
> + * @s1dss: STE s1dss (specifies the behavior when @pasid_bits != 0
> + *         and no PASID is passed along with the incoming transaction)
> + * @padding: reserved for future use (should be zero)
> + *
> + * The PASID table is referred to as the Context Descriptor (CD) table
> on ARM
> + * SMMUv3. Please refer to the ARM SMMU 3.x spec (ARM IHI 0070A) for full
> + * details.
> + */
> +struct iommu_pasid_smmuv3 {
> +#define PASID_TABLE_SMMUV3_CFG_VERSION_1 1
> +	__u32	version;
> +	__u8	s1fmt;
> +	__u8	s1dss;
> +	__u8	padding[2];
> +};
> +
> +/**
> + * struct iommu_pasid_table_config - PASID table data used to bind guest
> PASID
> + *     table to the host IOMMU
> + * @argsz: User filled size of this data
> + * @version: API version to prepare for future extensions
> + * @format: format of the PASID table
> + * @base_ptr: guest physical address of the PASID table
> + * @pasid_bits: number of PASID bits used in the PASID table
> + * @config: indicates whether the guest translation stage must
> + *          be translated, bypassed or aborted.
> + * @padding: reserved for future use (should be zero)
> + * @vendor_data.smmuv3: table information when @format is
> + * %IOMMU_PASID_FORMAT_SMMUV3
> + */
> +struct iommu_pasid_table_config {
> +	__u32	argsz;
> +#define PASID_TABLE_CFG_VERSION_1 1
> +	__u32	version;
> +#define IOMMU_PASID_FORMAT_SMMUV3	1
> +	__u32	format;
There will be a u32 gap here, right? perhaps another padding?

> +	__u64	base_ptr;
> +	__u8	pasid_bits;
> +#define IOMMU_PASID_CONFIG_TRANSLATE	1
> +#define IOMMU_PASID_CONFIG_BYPASS	2
> +#define IOMMU_PASID_CONFIG_ABORT	3
> +	__u8	config;
> +	__u8    padding[2];
> +	union {
> +		struct iommu_pasid_smmuv3 smmuv3;
> +	} vendor_data;
> +};
> +
>  #endif /* _UAPI_IOMMU_H */


Thanks,

Jacob
