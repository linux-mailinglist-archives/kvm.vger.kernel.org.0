Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2811A8E4A
	for <lists+kvm@lfdr.de>; Wed, 15 Apr 2020 00:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634206AbgDNWKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 18:10:10 -0400
Received: from mga07.intel.com ([134.134.136.100]:25344 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2634191AbgDNWJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 18:09:59 -0400
IronPort-SDR: Phl2lplXB1sjhV5jgCvcjhbBJdCJzqQQbrfouAvzellBkWFpi+pFkzo1vkRB8s1yB15xoy6JxV
 LPEx4kwh7/Ow==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2020 15:09:53 -0700
IronPort-SDR: z837rZDCi2m1k6zBWZpaQSNM0+WtN9dFFFwolOKOzIvvZawNDrlXKOouPd/VKxqwq36IycAHLI
 MLMzuG6tT34Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,384,1580803200"; 
   d="scan'208";a="427218373"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga005.jf.intel.com with ESMTP; 14 Apr 2020 15:09:53 -0700
Date:   Tue, 14 Apr 2020 15:15:48 -0700
From:   Jacob Pan <jacob.jun.pan@linux.intel.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, will@kernel.org, joro@8bytes.org,
        maz@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org,
        zhangfei.gao@linaro.org, shameerali.kolothum.thodi@huawei.com,
        alex.williamson@redhat.com, yi.l.liu@intel.com,
        peter.maydell@linaro.org, zhangfei.gao@gmail.com, tn@semihalf.com,
        zhangfei.gao@foxmail.com, bbhushan2@marvell.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v11 01/13] iommu: Introduce attach/detach_pasid_table
 API
Message-ID: <20200414151548.658a0401@jacob-builder>
In-Reply-To: <20200414150607.28488-2-eric.auger@redhat.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
        <20200414150607.28488-2-eric.auger@redhat.com>
Organization: OTC
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

There are some discussions about how to size the uAPI data.
https://lkml.org/lkml/2020/4/14/939

I think the problem with the current scheme is that when uAPI data gets
extended, if VFIO continue to use:

minsz = offsetofend(struct vfio_iommu_type1_set_pasid_table, config);
if (copy_from_user(&spt, (void __user *)arg, minsz))

It may copy more data from user than what was setup by the user.

So, as suggested by Alex, we could add argsz to the IOMMU uAPI struct.
So if argsz > minsz, then fail the attach_table since kernel might be
old, doesn't know about the extra data.
If argsz <= minsz, kernel can support the attach_table but must process
the data based on flags or config.

Does it make sense to you?


On Tue, 14 Apr 2020 17:05:55 +0200
Eric Auger <eric.auger@redhat.com> wrote:

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> 
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
> Reviewed-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
> ---
>  drivers/iommu/iommu.c      | 19 ++++++++++++++
>  include/linux/iommu.h      | 18 ++++++++++++++
>  include/uapi/linux/iommu.h | 51
> ++++++++++++++++++++++++++++++++++++++ 3 files changed, 88
> insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 2b471419e26c..b71ad56f8c99 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -1723,6 +1723,25 @@ int iommu_sva_unbind_gpasid(struct
> iommu_domain *domain, struct device *dev, }
>  EXPORT_SYMBOL_GPL(iommu_sva_unbind_gpasid);
>  
> +int iommu_attach_pasid_table(struct iommu_domain *domain,
> +			     struct iommu_pasid_table_config *cfg)
> +{
> +	if (unlikely(!domain->ops->attach_pasid_table))
> +		return -ENODEV;
> +
> +	return domain->ops->attach_pasid_table(domain, cfg);
> +}
> +EXPORT_SYMBOL_GPL(iommu_attach_pasid_table);
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
> index 7ef8b0bda695..3e1057c3585a 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -248,6 +248,8 @@ struct iommu_iotlb_gather {
>   * @cache_invalidate: invalidate translation caches
>   * @sva_bind_gpasid: bind guest pasid and mm
>   * @sva_unbind_gpasid: unbind guest pasid and mm
> + * @attach_pasid_table: attach a pasid table
> + * @detach_pasid_table: detach the pasid table
>   * @pgsize_bitmap: bitmap of all possible supported page sizes
>   * @owner: Driver module providing these ops
>   */
> @@ -307,6 +309,9 @@ struct iommu_ops {
>  				      void *drvdata);
>  	void (*sva_unbind)(struct iommu_sva *handle);
>  	int (*sva_get_pasid)(struct iommu_sva *handle);
> +	int (*attach_pasid_table)(struct iommu_domain *domain,
> +				  struct iommu_pasid_table_config
> *cfg);
> +	void (*detach_pasid_table)(struct iommu_domain *domain);
>  
>  	int (*page_response)(struct device *dev,
>  			     struct iommu_fault_event *evt,
> @@ -446,6 +451,9 @@ extern int iommu_sva_bind_gpasid(struct
> iommu_domain *domain, struct device *dev, struct
> iommu_gpasid_bind_data *data); extern int
> iommu_sva_unbind_gpasid(struct iommu_domain *domain, struct device
> *dev, ioasid_t pasid); +extern int iommu_attach_pasid_table(struct
> iommu_domain *domain,
> +				    struct iommu_pasid_table_config
> *cfg); +extern void iommu_detach_pasid_table(struct iommu_domain
> *domain); extern struct iommu_domain *iommu_get_domain_for_dev(struct
> device *dev); extern struct iommu_domain *iommu_get_dma_domain(struct
> device *dev); extern int iommu_map(struct iommu_domain *domain,
> unsigned long iova, @@ -1048,6 +1056,16 @@ iommu_aux_get_pasid(struct
> iommu_domain *domain, struct device *dev) return -ENODEV;
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
> index 4ad3496e5c43..8d00be10dc6d 100644
> --- a/include/uapi/linux/iommu.h
> +++ b/include/uapi/linux/iommu.h
> @@ -321,4 +321,55 @@ struct iommu_gpasid_bind_data {
>  	};
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
> + *         and no PASID is passed along with the incoming
> transaction)
> + * @padding: reserved for future use (should be zero)
> + *
> + * The PASID table is referred to as the Context Descriptor (CD)
> table on ARM
> + * SMMUv3. Please refer to the ARM SMMU 3.x spec (ARM IHI 0070A) for
> full
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
> + * struct iommu_pasid_table_config - PASID table data used to bind
> guest PASID
> + *     table to the host IOMMU
> + * @version: API version to prepare for future extensions
> + * @format: format of the PASID table
> + * @base_ptr: guest physical address of the PASID table
> + * @pasid_bits: number of PASID bits used in the PASID table
> + * @config: indicates whether the guest translation stage must
> + *          be translated, bypassed or aborted.
> + * @padding: reserved for future use (should be zero)
> + * @smmuv3: table information when @format is
> %IOMMU_PASID_FORMAT_SMMUV3
> + */
> +struct iommu_pasid_table_config {
> +#define PASID_TABLE_CFG_VERSION_1 1
> +	__u32	version;
> +#define IOMMU_PASID_FORMAT_SMMUV3	1
> +	__u32	format;
> +	__u64	base_ptr;
> +	__u8	pasid_bits;
> +#define IOMMU_PASID_CONFIG_TRANSLATE	1
> +#define IOMMU_PASID_CONFIG_BYPASS	2
> +#define IOMMU_PASID_CONFIG_ABORT	3
> +	__u8	config;
> +	__u8    padding[6];
> +	union {
> +		struct iommu_pasid_smmuv3 smmuv3;
> +	};
> +};
> +
>  #endif /* _UAPI_IOMMU_H */

[Jacob Pan]
