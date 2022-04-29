Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2ECF514AC6
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 15:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349313AbiD2Nnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 09:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245622AbiD2Nnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 09:43:45 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3268C2611
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 06:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651239627; x=1682775627;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=mO3fK/GMhj5ngxdTy682pnmAooXgUBLN8505Zg2MY9I=;
  b=EIUuI2E1DUnraPW8PKN3NMbHcV1oahQ43tbA5Pt7zN8UvDEpGpIXIp4N
   bx5q/Wtp5/nfeAvRzJTJeZbavGFev3KOeeDnpvp8RusR3zKvUt8LjGGyH
   oQtoDqPAhLw7r2BhECVZpSc4qVn2N4mMjuMJ2Qz7BetURngdbn808ztxC
   x6ltnTEFsFd5KEjQS4USa+an/4U4GMQfxs5aZfCRmiPYNqWpnjf67wU+k
   1rq0FXIsElsUsHPSEivUjymYdrH+pMuqKhpW9VKwkYKq1hIdYnZL8gYy9
   G9uit96lPskYRhZfm5Cyp1Hw/OsgFRv4zKCPChGTvu0Pqk2tWEfodJKaf
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="248576182"
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="248576182"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 06:40:26 -0700
X-IronPort-AV: E=Sophos;i="5.91,185,1647327600"; 
   d="scan'208";a="582130605"
Received: from lye4-mobl.ccr.corp.intel.com (HELO [10.249.170.95]) ([10.249.170.95])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 06:40:22 -0700
Message-ID: <2d369e58-8ac0-f263-7b94-fe73917782e1@linux.intel.com>
Date:   Fri, 29 Apr 2022 21:40:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC 01/19] iommu: Add iommu_domain ops for dirty tracking
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>,
        iommu@lists.linux-foundation.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <20220428210933.3583-1-joao.m.martins@oracle.com>
 <20220428210933.3583-2-joao.m.martins@oracle.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20220428210933.3583-2-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Joao,

Thanks for doing this.

On 2022/4/29 05:09, Joao Martins wrote:
> Add to iommu domain operations a set of callbacks to
> perform dirty tracking, particulary to start and stop
> tracking and finally to test and clear the dirty data.
> 
> Drivers are expected to dynamically change its hw protection
> domain bits to toggle the tracking and flush some form of
> control state structure that stands in the IOVA translation
> path.
> 
> For reading and clearing dirty data, in all IOMMUs a transition
> from any of the PTE access bits (Access, Dirty) implies flushing
> the IOTLB to invalidate any stale data in the IOTLB as to whether
> or not the IOMMU should update the said PTEs. The iommu core APIs
> introduce a new structure for storing the dirties, albeit vendor
> IOMMUs implementing .read_and_clear_dirty() just use
> iommu_dirty_bitmap_record() to set the memory storing dirties.
> The underlying tracking/iteration of user bitmap memory is instead
> done by iommufd which takes care of initializing the dirty bitmap
> *prior* to passing to the IOMMU domain op.
> 
> So far for currently/to-be-supported IOMMUs with dirty tracking
> support this particularly because the tracking is part of
> first stage tables and part of address translation. Below
> it is mentioned how hardware deal with the hardware protection
> domain control bits, to justify the added iommu core APIs.
> vendor IOMMU implementation will also explain in more detail on
> the dirty bit usage/clearing in the IOPTEs.
> 
> * x86 AMD:
> 
> The same thing for AMD particularly the Device Table
> respectivally, followed by flushing the Device IOTLB. On AMD[1],
> section "2.2.1 Updating Shared Tables", e.g.
> 
>> Each table can also have its contents cached by the IOMMU or
> peripheral IOTLBs. Therefore, after
> updating a table entry that can be cached, system software must
> send the IOMMU an appropriate
> invalidate command. Information in the peripheral IOTLBs must
> also be invalidated.
> 
> There's no mention of particular bits that are cached or
> not but fetching a dev entry is part of address translation
> as also depicted, so invalidate the device table to make
> sure the next translations fetch a DTE entry with the HD bits set.
> 
> * x86 Intel (rev3.0+):
> 
> Likewise[2] set the SSADE bit in the scalable-entry second stage table
> to enable Access/Dirty bits in the second stage page table. See manual,
> particularly on "6.2.3.1 Scalable-Mode PASID-Table Entry Programming
> Considerations"
> 
>> When modifying root-entries, scalable-mode root-entries,
> context-entries, or scalable-mode context
> entries:
>> Software must serially invalidate the context-cache,
> PASID-cache (if applicable), and the IOTLB.  The serialization is
> required since hardware may utilize information from the
> context-caches (e.g., Domain-ID) to tag new entries inserted to
> the PASID-cache and IOTLB for processing in-flight requests.
> Section 6.5 describe the invalidation operations.
> 
> And also the whole chapter "" Table "Table 23.  Guidance to
> Software for Invalidations" in "6.5.3.3 Guidance to Software for
> Invalidations" explicitly mentions
> 
>> SSADE transition from 0 to 1 in a scalable-mode PASID-table
> entry with PGTT value of Second-stage or Nested
> 
> * ARM SMMUV3.2:
> 
> SMMUv3.2 needs to toggle the dirty bit descriptor
> over the CD (or S2CD) for toggling and flush/invalidate
> the IOMMU dev IOTLB.
> 
> Reference[0]: SMMU spec, "5.4.1 CD notes",
> 
>> The following CD fields are permitted to be cached as part of a
> translation or TLB entry, and alteration requires
> invalidation of any TLB entry that might have cached these
> fields, in addition to CD structure cache invalidation:
> 
> ...
> HA, HD
> ...
> 
> Although, The ARM SMMUv3 case is a tad different that its x86
> counterparts. Rather than changing *only* the IOMMU domain device entry to
> enable dirty tracking (and having a dedicated bit for dirtyness in IOPTE)
> ARM instead uses a dirty-bit modifier which is separately enabled, and
> changes the *existing* meaning of access bits (for ro/rw), to the point
> that marking access bit read-only but with dirty-bit-modifier enabled
> doesn't trigger an perm io page fault.
> 
> In pratice this means that changing iommu context isn't enough
> and in fact mostly useless IIUC (and can be always enabled). Dirtying
> is only really enabled when the DBM pte bit is enabled (with the
> CD.HD bit as a prereq).
> 
> To capture this h/w construct an iommu core API is added which enables
> dirty tracking on an IOVA range rather than a device/context entry.
> iommufd picks one or the other, and IOMMUFD core will favour
> device-context op followed by IOVA-range alternative.

Instead of specification words, I'd like to read more about why the
callbacks are needed and how should they be implemented and consumed.

> 
> [0] https://developer.arm.com/documentation/ihi0070/latest
> [1] https://www.amd.com/system/files/TechDocs/48882_IOMMU.pdf
> [2] https://cdrdv2.intel.com/v1/dl/getContent/671081
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/iommu/iommu.c      | 28 ++++++++++++++++++++
>   include/linux/io-pgtable.h |  6 +++++
>   include/linux/iommu.h      | 52 ++++++++++++++++++++++++++++++++++++++
>   3 files changed, 86 insertions(+)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 0c42ece25854..d18b9ddbcce4 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -15,6 +15,7 @@
>   #include <linux/init.h>
>   #include <linux/export.h>
>   #include <linux/slab.h>
> +#include <linux/highmem.h>
>   #include <linux/errno.h>
>   #include <linux/iommu.h>
>   #include <linux/idr.h>
> @@ -3167,3 +3168,30 @@ bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>   	return user;
>   }
>   EXPORT_SYMBOL_GPL(iommu_group_dma_owner_claimed);
> +
> +unsigned int iommu_dirty_bitmap_record(struct iommu_dirty_bitmap *dirty,
> +				       unsigned long iova, unsigned long length)
> +{
> +	unsigned long nbits, offset, start_offset, idx, size, *kaddr;
> +
> +	nbits = max(1UL, length >> dirty->pgshift);
> +	offset = (iova - dirty->iova) >> dirty->pgshift;
> +	idx = offset / (PAGE_SIZE * BITS_PER_BYTE);
> +	offset = offset % (PAGE_SIZE * BITS_PER_BYTE);
> +	start_offset = dirty->start_offset;
> +
> +	while (nbits > 0) {
> +		kaddr = kmap(dirty->pages[idx]) + start_offset;
> +		size = min(PAGE_SIZE * BITS_PER_BYTE - offset, nbits);
> +		bitmap_set(kaddr, offset, size);
> +		kunmap(dirty->pages[idx]);
> +		start_offset = offset = 0;
> +		nbits -= size;
> +		idx++;
> +	}
> +
> +	if (dirty->gather)
> +		iommu_iotlb_gather_add_range(dirty->gather, iova, length);
> +
> +	return nbits;
> +}
> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
> index 86af6f0a00a2..82b39925c21f 100644
> --- a/include/linux/io-pgtable.h
> +++ b/include/linux/io-pgtable.h
> @@ -165,6 +165,12 @@ struct io_pgtable_ops {
>   			      struct iommu_iotlb_gather *gather);
>   	phys_addr_t (*iova_to_phys)(struct io_pgtable_ops *ops,
>   				    unsigned long iova);
> +	int (*set_dirty_tracking)(struct io_pgtable_ops *ops,
> +				  unsigned long iova, size_t size,
> +				  bool enabled);
> +	int (*read_and_clear_dirty)(struct io_pgtable_ops *ops,
> +				    unsigned long iova, size_t size,
> +				    struct iommu_dirty_bitmap *dirty);
>   };
>   
>   /**
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 6ef2df258673..ca076365d77b 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -189,6 +189,25 @@ struct iommu_iotlb_gather {
>   	bool			queued;
>   };
>   
> +/**
> + * struct iommu_dirty_bitmap - Dirty IOVA bitmap state
> + *
> + * @iova: IOVA representing the start of the bitmap, the first bit of the bitmap
> + * @pgshift: Page granularity of the bitmap
> + * @gather: Range information for a pending IOTLB flush
> + * @start_offset: Offset of the first user page
> + * @pages: User pages representing the bitmap region
> + * @npages: Number of user pages pinned
> + */
> +struct iommu_dirty_bitmap {
> +	unsigned long iova;
> +	unsigned long pgshift;
> +	struct iommu_iotlb_gather *gather;
> +	unsigned long start_offset;
> +	unsigned long npages;

I haven't found where "npages" is used in this patch. It's better to add
it when it's really used? Sorry if I missed anything.

> +	struct page **pages;
> +};
> +
>   /**
>    * struct iommu_ops - iommu ops and capabilities
>    * @capable: check capability
> @@ -275,6 +294,13 @@ struct iommu_ops {
>    * @enable_nesting: Enable nesting
>    * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
>    * @free: Release the domain after use.
> + * @set_dirty_tracking: Enable or Disable dirty tracking on the iommu domain
> + * @set_dirty_tracking_range: Enable or Disable dirty tracking on a range of
> + *                            an iommu domain
> + * @read_and_clear_dirty: Walk IOMMU page tables for dirtied PTEs marshalled
> + *                        into a bitmap, with a bit represented as a page.
> + *                        Reads the dirty PTE bits and clears it from IO
> + *                        pagetables.
>    */
>   struct iommu_domain_ops {
>   	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
> @@ -305,6 +331,15 @@ struct iommu_domain_ops {
>   				  unsigned long quirks);
>   
>   	void (*free)(struct iommu_domain *domain);
> +
> +	int (*set_dirty_tracking)(struct iommu_domain *domain, bool enabled);
> +	int (*set_dirty_tracking_range)(struct iommu_domain *domain,
> +					unsigned long iova, size_t size,
> +					struct iommu_iotlb_gather *iotlb_gather,
> +					bool enabled);

It seems that we are adding two callbacks for the same purpose. How
should the IOMMU drivers select to support? Any functional different
between these two? How should the caller select to use?

> +	int (*read_and_clear_dirty)(struct iommu_domain *domain,
> +				    unsigned long iova, size_t size,
> +				    struct iommu_dirty_bitmap *dirty);
>   };
>   
>   /**
> @@ -494,6 +529,23 @@ void iommu_set_dma_strict(void);
>   extern int report_iommu_fault(struct iommu_domain *domain, struct device *dev,
>   			      unsigned long iova, int flags);
>   
> +unsigned int iommu_dirty_bitmap_record(struct iommu_dirty_bitmap *dirty,
> +				       unsigned long iova, unsigned long length);
> +
> +static inline void iommu_dirty_bitmap_init(struct iommu_dirty_bitmap *dirty,
> +					   unsigned long base,
> +					   unsigned long pgshift,
> +					   struct iommu_iotlb_gather *gather)
> +{
> +	memset(dirty, 0, sizeof(*dirty));
> +	dirty->iova = base;
> +	dirty->pgshift = pgshift;
> +	dirty->gather = gather;
> +
> +	if (gather)
> +		iommu_iotlb_gather_init(dirty->gather);
> +}
> +
>   static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
>   {
>   	if (domain->ops->flush_iotlb_all)

Best regards,
baolu
