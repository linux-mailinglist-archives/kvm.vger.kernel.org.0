Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB6A18ED9B
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 02:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCWBUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Mar 2020 21:20:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:40359 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726916AbgCWBUT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Mar 2020 21:20:19 -0400
IronPort-SDR: NWVb3ricZQvujPRpAv5kQ64aWisAl/HZVy+iF7a7DstmDndFaKf+KEK/1w0HN1NQBrRVQ/vDim
 pBGTGlZQIcVA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 18:20:18 -0700
IronPort-SDR: C5W7DBlsZsmDNqxgn5kUVm+1enbfNIRY8NRiPmEjm6642kzxEs7IMjEmjO07Q/Q60ryxsAo7sW
 bQz/T9f6PUNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,294,1580803200"; 
   d="scan'208";a="392752188"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga004.jf.intel.com with ESMTP; 22 Mar 2020 18:20:11 -0700
Date:   Sun, 22 Mar 2020 21:10:41 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
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
Subject: Re: [PATCH v14 Kernel 5/7] vfio iommu: Update UNMAP_DMA ioctl to get
 dirty bitmap before unmap
Message-ID: <20200323011041.GB5456@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1584560474-19946-1-git-send-email-kwankhede@nvidia.com>
 <1584560474-19946-6-git-send-email-kwankhede@nvidia.com>
 <20200320083529.GA5456@joy-OptiPlex-7040>
 <20200320094039.4d99408d@w520.home>
 <20200320094727.12aba30e@w520.home>
 <aa76ad96-394f-f1fb-2e8d-a453bd69a39b@nvidia.com>
 <20200320132821.2fe80c29@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320132821.2fe80c29@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 21, 2020 at 03:28:21AM +0800, Alex Williamson wrote:
> On Sat, 21 Mar 2020 00:44:32 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
> > On 3/20/2020 9:17 PM, Alex Williamson wrote:
> > > On Fri, 20 Mar 2020 09:40:39 -0600
> > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > >   
> > >> On Fri, 20 Mar 2020 04:35:29 -0400
> > >> Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >>  
> > >>> On Thu, Mar 19, 2020 at 03:41:12AM +0800, Kirti Wankhede wrote:  
> > >>>> DMA mapped pages, including those pinned by mdev vendor drivers, might
> > >>>> get unpinned and unmapped while migration is active and device is still
> > >>>> running. For example, in pre-copy phase while guest driver could access
> > >>>> those pages, host device or vendor driver can dirty these mapped pages.
> > >>>> Such pages should be marked dirty so as to maintain memory consistency
> > >>>> for a user making use of dirty page tracking.
> > >>>>
> > >>>> To get bitmap during unmap, user should set flag
> > >>>> VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP, bitmap memory should be allocated and
> > >>>> zeroed by user space application. Bitmap size and page size should be set
> > >>>> by user application.
> > >>>>
> > >>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > >>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> > >>>> ---
> > >>>>   drivers/vfio/vfio_iommu_type1.c | 55 ++++++++++++++++++++++++++++++++++++++---
> > >>>>   include/uapi/linux/vfio.h       | 11 +++++++++
> > >>>>   2 files changed, 62 insertions(+), 4 deletions(-)
> > >>>>
> > >>>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > >>>> index d6417fb02174..aa1ac30f7854 100644
> > >>>> --- a/drivers/vfio/vfio_iommu_type1.c
> > >>>> +++ b/drivers/vfio/vfio_iommu_type1.c
> > >>>> @@ -939,7 +939,8 @@ static int verify_bitmap_size(uint64_t npages, uint64_t bitmap_size)
> > >>>>   }
> > >>>>   
> > >>>>   static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> > >>>> -			     struct vfio_iommu_type1_dma_unmap *unmap)
> > >>>> +			     struct vfio_iommu_type1_dma_unmap *unmap,
> > >>>> +			     struct vfio_bitmap *bitmap)
> > >>>>   {
> > >>>>   	uint64_t mask;
> > >>>>   	struct vfio_dma *dma, *dma_last = NULL;
> > >>>> @@ -990,6 +991,10 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> > >>>>   	 * will be returned if these conditions are not met.  The v2 interface
> > >>>>   	 * will only return success and a size of zero if there were no
> > >>>>   	 * mappings within the range.
> > >>>> +	 *
> > >>>> +	 * When VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP flag is set, unmap request
> > >>>> +	 * must be for single mapping. Multiple mappings with this flag set is
> > >>>> +	 * not supported.
> > >>>>   	 */
> > >>>>   	if (iommu->v2) {
> > >>>>   		dma = vfio_find_dma(iommu, unmap->iova, 1);
> > >>>> @@ -997,6 +1002,13 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
> > >>>>   			ret = -EINVAL;
> > >>>>   			goto unlock;
> > >>>>   		}
> > >>>> +
> > >>>> +		if ((unmap->flags & VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP) &&
> > >>>> +		    (dma->iova != unmap->iova || dma->size != unmap->size)) {  
> > >>> dma is probably NULL here!  
> > >>
> > >> Yep, I didn't look closely enough there.  This is situated right
> > >> between the check to make sure we're not bisecting a mapping at the
> > >> start of the unmap and the check to make sure we're not bisecting a
> > >> mapping at the end of the unmap.  There's no guarantee that we have a
> > >> valid pointer here.  The test should be in the while() loop below this
> > >> code.  
> > > 
> > > Actually the test could remain here, we can exit here if we can't find
> > > a dma at the start of the unmap range with the GET_DIRTY_BITMAP flag,
> > > but we absolutely cannot deref dma without testing it.
> > >   
> > 
> > In the check above newly added check, if dma is NULL then its an error 
> > condition, because Unmap requests must fully cover previous mappings, right?
> 
> Yes, but we'll do a null pointer deref before we return error.
>  
> > >>> And this restriction on UNMAP would make some UNMAP operations of vIOMMU
> > >>> fail.
> > >>>
> > >>> e.g. below condition indeed happens in reality.
> > >>> an UNMAP ioctl comes for IOVA range from 0xff800000, of size 0x200000
> > >>> However, IOVAs in this range are mapped page by page.i.e., dma->size is 0x1000.
> > >>>
> > >>> Previous, this UNMAP ioctl could unmap successfully as a whole.  
> > >>
> > >> What triggers this in the guest?  Note that it's only when using the
> > >> GET_DIRTY_BITMAP flag that this is restricted.  Does the event you're
> > >> referring to potentially occur under normal circumstances in that mode?
> > >> Thanks,
> > >>  

it happens in vIOMMU Domain level invalidation of IOTLB
(domain-selective invalidation, see vtd_iotlb_domain_invalidate() in qemu).
common in VTD lazy mode, and NOT just happening once at boot time.
rather than invalidate page by page, it batches the page invalidation.
so, when this invalidation takes place, even higher level page tables
have been invalid and therefore it has to invalidate a bigger combined range.
That's why we see IOVAs are mapped in 4k pages, but are unmapped in 2M
pages.

I think those UNMAPs should also have GET_DIRTY_BIMTAP flag on, right?
> > 
> > Such unmap would callback vfio_iommu_map_notify() in QEMU. In 
> > vfio_iommu_map_notify(), unmap is called on same range <iova, 
> > iotlb->addr_mask + 1> which was used for map. Secondly unmap with bitmap 
> > will be called only when device state has _SAVING flag set.
> 
in this case, iotlb->addr_mask in unmap is 0x200000 -1.
different than 0x1000 -1 used for map.
> It might be helpful for Yan, and everyone else, to see the latest QEMU
> patch series.  Thanks,
>
yes, please. also curious of log_sync part for vIOMMU. given most IOVAs in
address space are unmapped and therefore no IOTLBs are able to be found.

Thanks
Yan
