Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10E71FD30D
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 03:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfKOCsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 21:48:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:19494 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbfKOCsn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 21:48:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 18:48:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,306,1569308400"; 
   d="scan'208";a="207995195"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2019 18:48:38 -0800
Date:   Thu, 14 Nov 2019 21:40:35 -0500
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
Subject: Re: [PATCH v9 Kernel 2/5] vfio iommu: Add ioctl defination to get
 dirty pages bitmap.
Message-ID: <20191115024035.GA24163@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
 <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
 <20191112153020.71406c44@x1.home>
 <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
 <20191113130705.32c6b663@x1.home>
 <7f74a2a1-ba1c-9d4c-dc5e-343ecdd7d6d6@nvidia.com>
 <20191114140625.213e8a99@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114140625.213e8a99@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 15, 2019 at 05:06:25AM +0800, Alex Williamson wrote:
> On Fri, 15 Nov 2019 00:26:07 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
> > On 11/14/2019 1:37 AM, Alex Williamson wrote:
> > > On Thu, 14 Nov 2019 01:07:21 +0530
> > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > >   
> > >> On 11/13/2019 4:00 AM, Alex Williamson wrote:  
> > >>> On Tue, 12 Nov 2019 22:33:37 +0530
> > >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > >>>      
> > >>>> All pages pinned by vendor driver through vfio_pin_pages API should be
> > >>>> considered as dirty during migration. IOMMU container maintains a list of
> > >>>> all such pinned pages. Added an ioctl defination to get bitmap of such  
> > >>>
> > >>> definition
> > >>>      
> > >>>> pinned pages for requested IO virtual address range.  
> > >>>
> > >>> Additionally, all mapped pages are considered dirty when physically
> > >>> mapped through to an IOMMU, modulo we discussed devices opting in to
> > >>> per page pinning to indicate finer granularity with a TBD mechanism to
> > >>> figure out if any non-opt-in devices remain.
> > >>>      
> > >>
> > >> You mean, in case of device direct assignment (device pass through)?  
> > > 
> > > Yes, or IOMMU backed mdevs.  If vfio_dmas in the container are fully
> > > pinned and mapped, then the correct dirty page set is all mapped pages.
> > > We discussed using the vpfn list as a mechanism for vendor drivers to
> > > reduce their migration footprint, but we also discussed that we would
> > > need a way to determine that all participants in the container have
> > > explicitly pinned their working pages or else we must consider the
> > > entire potential working set as dirty.
> > >   
> > 
> > How can vendor driver tell this capability to iommu module? Any suggestions?
> 
> I think it does so by pinning pages.  Is it acceptable that if the
> vendor driver pins any pages, then from that point forward we consider
> the IOMMU group dirty page scope to be limited to pinned pages?  There
> are complications around non-singleton IOMMU groups, but I think we're
> already leaning towards that being a non-worthwhile problem to solve.
> So if we require that only singleton IOMMU groups can pin pages and we
> pass the IOMMU group as a parameter to
> vfio_iommu_driver_ops.pin_pages(), then the type1 backend can set a
> flag on its local vfio_group struct to indicate dirty page scope is
> limited to pinned pages.  We might want to keep a flag on the
> vfio_iommu struct to indicate if all of the vfio_groups for each
> vfio_domain in the vfio_iommu.domain_list dirty page scope limited to
> pinned pages as an optimization to avoid walking lists too often.  Then
> we could test if vfio_iommu.domain_list is not empty and this new flag
> does not limit the dirty page scope, then everything within each
> vfio_dma is considered dirty.
>

hi Alex
could you help clarify whether my understandings below are right?
In future,
1. for mdev and for passthrough device withoug hardware ability to track
dirty pages, the vendor driver has to explicitly call
vfio_pin_pages()/vfio_unpin_pages() + a flag to tell vfio its dirty page set.

2. for those devices with hardware ability to track dirty pages, will still
provide a callback to vendor driver to get dirty pages. (as for those devices,
it is hard to explicitly call vfio_pin_pages()/vfio_unpin_pages())

3. for devices relying on dirty bit info in physical IOMMU, there
will be a callback to physical IOMMU driver to get dirty page set from
vfio.

Thanks
Yan

> > >>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
> > >>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
> > >>>> ---
> > >>>>    include/uapi/linux/vfio.h | 23 +++++++++++++++++++++++
> > >>>>    1 file changed, 23 insertions(+)
> > >>>>
> > >>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > >>>> index 35b09427ad9f..6fd3822aa610 100644
> > >>>> --- a/include/uapi/linux/vfio.h
> > >>>> +++ b/include/uapi/linux/vfio.h
> > >>>> @@ -902,6 +902,29 @@ struct vfio_iommu_type1_dma_unmap {
> > >>>>    #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
> > >>>>    #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
> > >>>>    
> > >>>> +/**
> > >>>> + * VFIO_IOMMU_GET_DIRTY_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
> > >>>> + *                                     struct vfio_iommu_type1_dirty_bitmap)
> > >>>> + *
> > >>>> + * IOCTL to get dirty pages bitmap for IOMMU container during migration.
> > >>>> + * Get dirty pages bitmap of given IO virtual addresses range using
> > >>>> + * struct vfio_iommu_type1_dirty_bitmap. Caller sets argsz, which is size of
> > >>>> + * struct vfio_iommu_type1_dirty_bitmap. User should allocate memory to get
> > >>>> + * bitmap and should set size of allocated memory in bitmap_size field.
> > >>>> + * One bit is used to represent per page consecutively starting from iova
> > >>>> + * offset. Bit set indicates page at that offset from iova is dirty.
> > >>>> + */
> > >>>> +struct vfio_iommu_type1_dirty_bitmap {
> > >>>> +	__u32        argsz;
> > >>>> +	__u32        flags;
> > >>>> +	__u64        iova;                      /* IO virtual address */
> > >>>> +	__u64        size;                      /* Size of iova range */
> > >>>> +	__u64        bitmap_size;               /* in bytes */  
> > >>>
> > >>> This seems redundant.  We can calculate the size of the bitmap based on
> > >>> the iova size.
> > >>>     
> > >>
> > >> But in kernel space, we need to validate the size of memory allocated by
> > >> user instead of assuming user is always correct, right?  
> > > 
> > > What does it buy us for the user to tell us the size?  They could be
> > > wrong, they could be malicious.  The argsz field on the ioctl is mostly
> > > for the handshake that the user is competent, we should get faults from
> > > the copy-user operation if it's incorrect.
> > >  
> > 
> > It is to mainly fail safe.
> > 
> > >>>> +	void __user *bitmap;                    /* one bit per page */  
> > >>>
> > >>> Should we define that as a __u64* to (a) help with the size
> > >>> calculation, and (b) assure that we can use 8-byte ops on it?
> > >>>
> > >>> However, who defines page size?  Is it necessarily the processor page
> > >>> size?  A physical IOMMU may support page sizes other than the CPU page
> > >>> size.  It might be more important to indicate the expected page size
> > >>> than the bitmap size.  Thanks,
> > >>>     
> > >>
> > >> I see in QEMU and in vfio_iommu_type1 module, page sizes considered for
> > >> mapping are CPU page size, 4K. Do we still need to have such argument?  
> > > 
> > > That assumption exists for backwards compatibility prior to supporting
> > > the iova_pgsizes field in vfio_iommu_type1_info.  AFAIK the current
> > > interface has no page size assumptions and we should not add any.  
> > 
> > So userspace has iova_pgsizes information, which can be input to this 
> > ioctl. Bitmap should be considering smallest page size. Does that makes 
> > sense?
> 
> I'm not sure.  I thought I had an argument that the iova_pgsize could
> indicate support for sizes smaller than the processor page size, which
> would make the user responsible for using a different base for their
> page size, but vfio_pgsize_bitmap() already masks out sub-page sizes.
> Clearly the vendor driver is pinning based on processor sized pages,
> but that's independent of an IOMMU and not part of a user ABI.
> 
> I'm tempted to say your bitmap_size field has a use here, but it seems
> to fail in validating the user page size at the low extremes.  For
> example if we have a single page mapping, the user can specify the iova
> size as 4K (for example), but the minimum bitmap_size they can indicate
> is 1 byte, would we therefore assume the user's bitmap page size is 512
> bytes (ie. they provided us with 8 bits to describe a 4K range)?  We'd
> need to be careful to specify that the minimum iova_pgsize indicated
> page size is our lower bound as well.  But then what do we do if the
> user provides us with a smaller buffer than we expect?  For example, a
> 128MB iova range and only an 8-byte buffer.  Do we go ahead and assume
> a 2MB page size and fill the bitmap accordingly or do we generate an
> error?  If the latter, might we support that at some point in time and
> is it sufficient to let the user perform trial and error to test if that
> exists?  Thanks,
> 
> Alex
> 
