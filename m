Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA85709821
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231575AbjESNWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjESNWj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:22:39 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72656CE
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:22:37 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E3611FB;
        Fri, 19 May 2023 06:23:22 -0700 (PDT)
Received: from [10.57.84.114] (unknown [10.57.84.114])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B09B83F762;
        Fri, 19 May 2023 06:22:34 -0700 (PDT)
Message-ID: <940bbc2e-874e-8cde-c4c9-be7884c3ef57@arm.com>
Date:   Fri, 19 May 2023 14:22:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Content-Language: en-GB
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
From:   Robin Murphy <robin.murphy@arm.com>
In-Reply-To: <20230518204650.14541-5-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023-05-18 21:46, Joao Martins wrote:
> Add to iommu domain operations a set of callbacks to perform dirty
> tracking, particulary to start and stop tracking and finally to read and
> clear the dirty data.
> 
> Drivers are generally expected to dynamically change its translation
> structures to toggle the tracking and flush some form of control state
> structure that stands in the IOVA translation path. Though it's not
> mandatory, as drivers will be enable dirty tracking at boot, and just flush
> the IO pagetables when setting dirty tracking.  For each of the newly added
> IOMMU core APIs:
> 
> .supported_flags[IOMMU_DOMAIN_F_ENFORCE_DIRTY]: Introduce a set of flags
> that enforce certain restrictions in the iommu_domain object. For dirty
> tracking this means that when IOMMU_DOMAIN_F_ENFORCE_DIRTY is set via its
> helper iommu_domain_set_flags(...) devices attached via attach_dev will
> fail on devices that do *not* have dirty tracking supported. IOMMU drivers
> that support dirty tracking should advertise this flag, while enforcing
> that dirty tracking is supported by the device in its .attach_dev iommu op.

Eww, no. For an internal thing, just call ->capable() - I mean, you're 
literally adding this feature as one of its caps...

However I'm not sure if we even need that - domains which don't support 
dirty tracking should just not expose the ops, and thus it ought to be 
inherently obvious.

I'm guessing most of the weirdness here is implicitly working around the 
enabled-from-the-start scenario on SMMUv3:

	domain = iommu_domain_alloc(bus);
	iommu_set_dirty_tracking(domain);
	// arm-smmu-v3 says OK since it doesn't know that it
	// definitely *isn't* possible, and saying no wouldn't
	// be helpful
	iommu_attach_group(group, domain);
	// oops, now we see that the relevant SMMU instance isn't one
	// which actually supports HTTU, what do we do? :(

I don't have any major objection to the general principle of flagging 
the domain to fail attach if it can't do what we promised, as a bodge 
for now, but please implement it privately in arm-smmu-v3 so it's easier 
to clean up again in future once until iommu_domain_alloc() gets sorted 
out properly to get rid of this awkward blind spot.

Thanks,
Robin.

> iommu_cap::IOMMU_CAP_DIRTY: new device iommu_capable value when probing for
> capabilities of the device.
> 
> .set_dirty_tracking(): an iommu driver is expected to change its
> translation structures and enable dirty tracking for the devices in the
> iommu_domain. For drivers making dirty tracking always-enabled, it should
> just return 0.
> 
> .read_and_clear_dirty(): an iommu driver is expected to walk the iova range
> passed in and use iommu_dirty_bitmap_record() to record dirty info per
> IOVA. When detecting a given IOVA is dirty it should also clear its dirty
> state from the PTE, *unless* the flag IOMMU_DIRTY_NO_CLEAR is passed in --
> flushing is steered from the caller of the domain_op via iotlb_gather. The
> iommu core APIs use the same data structure in use for dirty tracking for
> VFIO device dirty (struct iova_bitmap) abstracted by
> iommu_dirty_bitmap_record() helper function.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/iommu/iommu.c      | 11 +++++++
>   include/linux/io-pgtable.h |  4 +++
>   include/linux/iommu.h      | 67 ++++++++++++++++++++++++++++++++++++++
>   3 files changed, 82 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 2088caae5074..95acc543e8fb 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2013,6 +2013,17 @@ struct iommu_domain *iommu_domain_alloc(const struct bus_type *bus)
>   }
>   EXPORT_SYMBOL_GPL(iommu_domain_alloc);
>   
> +int iommu_domain_set_flags(struct iommu_domain *domain,
> +			   const struct bus_type *bus, unsigned long val)
> +{
> +	if (!(val & bus->iommu_ops->supported_flags))
> +		return -EINVAL;
> +
> +	domain->flags |= val;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(iommu_domain_set_flags);
> +
>   void iommu_domain_free(struct iommu_domain *domain)
>   {
>   	if (domain->type == IOMMU_DOMAIN_SVA)
> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
> index 1b7a44b35616..25142a0e2fc2 100644
> --- a/include/linux/io-pgtable.h
> +++ b/include/linux/io-pgtable.h
> @@ -166,6 +166,10 @@ struct io_pgtable_ops {
>   			      struct iommu_iotlb_gather *gather);
>   	phys_addr_t (*iova_to_phys)(struct io_pgtable_ops *ops,
>   				    unsigned long iova);
> +	int (*read_and_clear_dirty)(struct io_pgtable_ops *ops,
> +				    unsigned long iova, size_t size,
> +				    unsigned long flags,
> +				    struct iommu_dirty_bitmap *dirty);
>   };
>   
>   /**
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 39d25645a5ab..992ea87f2f8e 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -13,6 +13,7 @@
>   #include <linux/errno.h>
>   #include <linux/err.h>
>   #include <linux/of.h>
> +#include <linux/iova_bitmap.h>
>   #include <uapi/linux/iommu.h>
>   
>   #define IOMMU_READ	(1 << 0)
> @@ -65,6 +66,11 @@ struct iommu_domain_geometry {
>   
>   #define __IOMMU_DOMAIN_SVA	(1U << 4)  /* Shared process address space */
>   
> +/* Domain feature flags that do not define domain types */
> +#define IOMMU_DOMAIN_F_ENFORCE_DIRTY	(1U << 6)  /* Enforce attachment of
> +						      dirty tracking supported
> +						      devices		  */
> +
>   /*
>    * This are the possible domain-types
>    *
> @@ -93,6 +99,7 @@ struct iommu_domain_geometry {
>   
>   struct iommu_domain {
>   	unsigned type;
> +	unsigned flags;
>   	const struct iommu_domain_ops *ops;
>   	unsigned long pgsize_bitmap;	/* Bitmap of page sizes in use */
>   	struct iommu_domain_geometry geometry;
> @@ -128,6 +135,7 @@ enum iommu_cap {
>   	 * this device.
>   	 */
>   	IOMMU_CAP_ENFORCE_CACHE_COHERENCY,
> +	IOMMU_CAP_DIRTY,		/* IOMMU supports dirty tracking */
>   };
>   
>   /* These are the possible reserved region types */
> @@ -220,6 +228,17 @@ struct iommu_iotlb_gather {
>   	bool			queued;
>   };
>   
> +/**
> + * struct iommu_dirty_bitmap - Dirty IOVA bitmap state
> + *
> + * @bitmap: IOVA bitmap
> + * @gather: Range information for a pending IOTLB flush
> + */
> +struct iommu_dirty_bitmap {
> +	struct iova_bitmap *bitmap;
> +	struct iommu_iotlb_gather *gather;
> +};
> +
>   /**
>    * struct iommu_ops - iommu ops and capabilities
>    * @capable: check capability
> @@ -248,6 +267,7 @@ struct iommu_iotlb_gather {
>    *                    pasid, so that any DMA transactions with this pasid
>    *                    will be blocked by the hardware.
>    * @pgsize_bitmap: bitmap of all possible supported page sizes
> + * @flags: All non domain type supported features
>    * @owner: Driver module providing these ops
>    */
>   struct iommu_ops {
> @@ -281,6 +301,7 @@ struct iommu_ops {
>   
>   	const struct iommu_domain_ops *default_domain_ops;
>   	unsigned long pgsize_bitmap;
> +	unsigned long supported_flags;
>   	struct module *owner;
>   };
>   
> @@ -316,6 +337,11 @@ struct iommu_ops {
>    * @enable_nesting: Enable nesting
>    * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
>    * @free: Release the domain after use.
> + * @set_dirty_tracking: Enable or Disable dirty tracking on the iommu domain
> + * @read_and_clear_dirty: Walk IOMMU page tables for dirtied PTEs marshalled
> + *                        into a bitmap, with a bit represented as a page.
> + *                        Reads the dirty PTE bits and clears it from IO
> + *                        pagetables.
>    */
>   struct iommu_domain_ops {
>   	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
> @@ -348,6 +374,12 @@ struct iommu_domain_ops {
>   				  unsigned long quirks);
>   
>   	void (*free)(struct iommu_domain *domain);
> +
> +	int (*set_dirty_tracking)(struct iommu_domain *domain, bool enabled);
> +	int (*read_and_clear_dirty)(struct iommu_domain *domain,
> +				    unsigned long iova, size_t size,
> +				    unsigned long flags,
> +				    struct iommu_dirty_bitmap *dirty);
>   };
>   
>   /**
> @@ -461,6 +493,9 @@ extern bool iommu_present(const struct bus_type *bus);
>   extern bool device_iommu_capable(struct device *dev, enum iommu_cap cap);
>   extern bool iommu_group_has_isolated_msi(struct iommu_group *group);
>   extern struct iommu_domain *iommu_domain_alloc(const struct bus_type *bus);
> +extern int iommu_domain_set_flags(struct iommu_domain *domain,
> +				  const struct bus_type *bus,
> +				  unsigned long flags);
>   extern void iommu_domain_free(struct iommu_domain *domain);
>   extern int iommu_attach_device(struct iommu_domain *domain,
>   			       struct device *dev);
> @@ -627,6 +662,28 @@ static inline bool iommu_iotlb_gather_queued(struct iommu_iotlb_gather *gather)
>   	return gather && gather->queued;
>   }
>   
> +static inline void iommu_dirty_bitmap_init(struct iommu_dirty_bitmap *dirty,
> +					   struct iova_bitmap *bitmap,
> +					   struct iommu_iotlb_gather *gather)
> +{
> +	if (gather)
> +		iommu_iotlb_gather_init(gather);
> +
> +	dirty->bitmap = bitmap;
> +	dirty->gather = gather;
> +}
> +
> +static inline void
> +iommu_dirty_bitmap_record(struct iommu_dirty_bitmap *dirty, unsigned long iova,
> +			  unsigned long length)
> +{
> +	if (dirty->bitmap)
> +		iova_bitmap_set(dirty->bitmap, iova, length);
> +
> +	if (dirty->gather)
> +		iommu_iotlb_gather_add_range(dirty->gather, iova, length);
> +}
> +
>   /* PCI device grouping function */
>   extern struct iommu_group *pci_device_group(struct device *dev);
>   /* Generic device grouping function */
> @@ -657,6 +714,9 @@ struct iommu_fwspec {
>   /* ATS is supported */
>   #define IOMMU_FWSPEC_PCI_RC_ATS			(1 << 0)
>   
> +/* Read but do not clear any dirty bits */
> +#define IOMMU_DIRTY_NO_CLEAR			(1 << 0)
> +
>   /**
>    * struct iommu_sva - handle to a device-mm bond
>    */
> @@ -755,6 +815,13 @@ static inline struct iommu_domain *iommu_domain_alloc(const struct bus_type *bus
>   	return NULL;
>   }
>   
> +static inline int iommu_domain_set_flags(struct iommu_domain *domain,
> +					 const struct bus_type *bus,
> +					 unsigned long flags)
> +{
> +	return -ENODEV;
> +}
> +
>   static inline void iommu_domain_free(struct iommu_domain *domain)
>   {
>   }
