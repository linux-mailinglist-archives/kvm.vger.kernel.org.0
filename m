Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85A1D19726B
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 04:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgC3CYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 22:24:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:63642 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbgC3CYp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 22:24:45 -0400
IronPort-SDR: RUqQbK1zEQDLRDtPcagufz+JeFZ23HS/p4MqUQ0yytV2wIC5JcD0vk+MNo+HmcMJmnnd5PIY0/
 AborXCWT8AYg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2020 19:24:44 -0700
IronPort-SDR: LNQIuW64wDlZVPiKJn63DVtJ/4DNuUQCARCuBcqiUEX2HuSoubJXLUtXjhIkmRiR8EvUBy4uVh
 ATXPTOhCKy5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,322,1580803200"; 
   d="scan'208";a="272224977"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga004.fm.intel.com with ESMTP; 29 Mar 2020 19:24:39 -0700
Date:   Sun, 29 Mar 2020 22:15:06 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v16 Kernel 5/7] vfio iommu: Update UNMAP_DMA ioctl to get
 dirty bitmap before unmap
Message-ID: <20200330021506.GC30683@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1585078359-20124-1-git-send-email-kwankhede@nvidia.com>
 <1585078359-20124-6-git-send-email-kwankhede@nvidia.com>
 <20200325021800.GC20109@joy-OptiPlex-7040>
 <3cabb357-b9c5-f8b3-5d57-1178ec0dde5a@nvidia.com>
 <20200327000426.GA26419@joy-OptiPlex-7040>
 <b6524b4a-e6a0-7328-5003-7286f2fd61a8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6524b4a-e6a0-7328-5003-7286f2fd61a8@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 27, 2020 at 12:42:43PM +0800, Kirti Wankhede wrote:
> 
> 
> On 3/27/2020 5:34 AM, Yan Zhao wrote:
> > On Fri, Mar 27, 2020 at 05:39:44AM +0800, Kirti Wankhede wrote:
> >>
> >>
> >> On 3/25/2020 7:48 AM, Yan Zhao wrote:
> >>> On Wed, Mar 25, 2020 at 03:32:37AM +0800, Kirti Wankhede wrote:
> >>>> DMA mapped pages, including those pinned by mdev vendor drivers, might
> >>>> get unpinned and unmapped while migration is active and device is still
> >>>> running. For example, in pre-copy phase while guest driver could access
> >>>> those pages, host device or vendor driver can dirty these mapped pages.
> >>>> Such pages should be marked dirty so as to maintain memory consistency
> >>>> for a user making use of dirty page tracking.
> >>>>
> >>>> To get bitmap during unmap, user should allocate memory for bitmap, set
> >>>> size of allocated memory, set page size to be considered for bitmap and
> >>>> set flag VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP.
> >>>>
> >>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> >>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> >>>> ---
> >>>>    drivers/vfio/vfio_iommu_type1.c | 54 ++++++++++++++++++++++++++++++++++++++---
> >>>>    include/uapi/linux/vfio.h       | 10 ++++++++
> >>>>    2 files changed, 60 insertions(+), 4 deletions(-)
> >>>>
> >>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >>>> index 27ed069c5053..b98a8d79e13a 100644
> >>>> --- a/drivers/vfio/vfio_iommu_type1.c
> >>>> +++ b/drivers/vfio/vfio_iommu_type1.c
> >>>> @@ -982,7 +982,8 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
> >>>>    }
> >>>>    
> >>>>    static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>>> -			     struct vfio_iommu_type1_dma_unmap *unmap)
> >>>> +			     struct vfio_iommu_type1_dma_unmap *unmap,
> >>>> +			     struct vfio_bitmap *bitmap)
> >>>>    {
> >>>>    	uint64_t mask;
> >>>>    	struct vfio_dma *dma, *dma_last = NULL;
> >>>> @@ -1033,6 +1034,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>>>    	 * will be returned if these conditions are not met.  The v2 interface
> >>>>    	 * will only return success and a size of zero if there were no
> >>>>    	 * mappings within the range.
> >>>> +	 *
> >>>> +	 * When VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP flag is set, unmap request
> >>>> +	 * must be for single mapping. Multiple mappings with this flag set is
> >>>> +	 * not supported.
> >>>>    	 */
> >>>>    	if (iommu->v2) {
> >>>>    		dma = vfio_find_dma(iommu, unmap->iova, 1);
> >>>> @@ -1040,6 +1045,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> >>>>    			ret = -EINVAL;
> >>>>    			goto unlock;
> >>>>    		}
> >>>> +
> >>>> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> >>>> +		    (dma->iova != unmap->iova || dma->size != unmap->size)) {
> >>> potential NULL pointer!
> >>>
> >>> And could you address the comments in v14?
> >>> How to handle DSI unmaps in vIOMMU
> >>> (https://lore.kernel.org/kvm/20200323011041.GB5456@joy-OptiPlex-7040/)
> >>>
> >>
> >> Sorry, I drafted reply to it, but I missed to send, it remained in my drafts
> >>
> >>   >
> >>   > it happens in vIOMMU Domain level invalidation of IOTLB
> >>   > (domain-selective invalidation, see vtd_iotlb_domain_invalidate() in
> >> qemu).
> >>   > common in VTD lazy mode, and NOT just happening once at boot time.
> >>   > rather than invalidate page by page, it batches the page invalidation.
> >>   > so, when this invalidation takes place, even higher level page tables
> >>   > have been invalid and therefore it has to invalidate a bigger
> >> combined range.
> >>   > That's why we see IOVAs are mapped in 4k pages, but are unmapped in 2M
> >>   > pages.
> >>   >
> >>   > I think those UNMAPs should also have GET_DIRTY_BIMTAP flag on, right?
> >>
> >>
> >> vtd_iotlb_domain_invalidate()
> >>     vtd_sync_shadow_page_table()
> >>       vtd_sync_shadow_page_table_range(vtd_as, &ce, 0, UINT64_MAX)
> >>         vtd_page_walk()
> >>           vtd_page_walk_level() - walk over specific level for IOVA range
> >>             vtd_page_walk_one()
> >>               memory_region_notify_iommu()
> >>               ...
> >>                 vfio_iommu_map_notify()
> >>
> >> In the above trace, isn't page walk will take care of creating proper
> >> IOTLB entry which should be same as created during mapping for that
> >> IOTLB entry?
> >>
> > No. It does walk the page table, but as it's dsi (delay & batched unmap),
> > pages table entry for a whole 2M (the higher level, not last level for 4K)
> > range is invalid, so the iotlb->addr_mask what vfio_iommu_map_notify()
> > receives is (2M - 1), not the same as the size for map.
> > 
> 
> When do this happen? during my testing I never hit this case. How can I 
> hit this case?

Just common settings to enable vIOMMU:
Qemu: -device intel-iommu,caching-mode=true
guest kernel parameter: intel_iommu=on

(intel_iommu=on turns on lazy mode by default)

In lazy mode, guest notifies DMA MAP on page level, but notifies DMA UNMAPs
in batch.
with a pass-through NVMe, there are 89 DSI unmaps in 1 second for a typical fio.
With a pass-through GPU, there 22 DSI unmaps in total for benchmark openArena
(lasting around 55 secs)
> 
> In this case, will adjacent whole vfio_dmas will be clubbed together or 
> will there be any intersection of vfio_dmas?
>
clubbed together.
