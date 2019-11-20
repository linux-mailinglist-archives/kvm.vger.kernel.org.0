Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4271F103155
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 02:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbfKTB7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 20:59:42 -0500
Received: from mga07.intel.com ([134.134.136.100]:41319 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727082AbfKTB7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 20:59:42 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 17:59:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,220,1571727600"; 
   d="scan'208";a="196697881"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by orsmga007.jf.intel.com with ESMTP; 19 Nov 2019 17:59:37 -0800
Date:   Tue, 19 Nov 2019 20:51:32 -0500
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
Message-ID: <20191120015132.GA24995@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
 <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
 <20191112153020.71406c44@x1.home>
 <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
 <20191113130705.32c6b663@x1.home>
 <7f74a2a1-ba1c-9d4c-dc5e-343ecdd7d6d6@nvidia.com>
 <20191114140625.213e8a99@x1.home>
 <20191115024035.GA24163@joy-OptiPlex-7040>
 <20191114202133.4b046cb9@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114202133.4b046cb9@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 15, 2019 at 11:21:33AM +0800, Alex Williamson wrote:
> On Thu, 14 Nov 2019 21:40:35 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Fri, Nov 15, 2019 at 05:06:25AM +0800, Alex Williamson wrote:
> > > On Fri, 15 Nov 2019 00:26:07 +0530
> > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > >   
> > > > On 11/14/2019 1:37 AM, Alex Williamson wrote:  
> > > > > On Thu, 14 Nov 2019 01:07:21 +0530
> > > > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > > >     
> > > > >> On 11/13/2019 4:00 AM, Alex Williamson wrote:    
> > > > >>> On Tue, 12 Nov 2019 22:33:37 +0530
> > > > >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > > >>>        
> > > > >>>> All pages pinned by vendor driver through vfio_pin_pages API should be
> > > > >>>> considered as dirty during migration. IOMMU container maintains a list of
> > > > >>>> all such pinned pages. Added an ioctl defination to get bitmap of such    
> > > > >>>
> > > > >>> definition
> > > > >>>        
> > > > >>>> pinned pages for requested IO virtual address range.    
> > > > >>>
> > > > >>> Additionally, all mapped pages are considered dirty when physically
> > > > >>> mapped through to an IOMMU, modulo we discussed devices opting in to
> > > > >>> per page pinning to indicate finer granularity with a TBD mechanism to
> > > > >>> figure out if any non-opt-in devices remain.
> > > > >>>        
> > > > >>
> > > > >> You mean, in case of device direct assignment (device pass through)?    
> > > > > 
> > > > > Yes, or IOMMU backed mdevs.  If vfio_dmas in the container are fully
> > > > > pinned and mapped, then the correct dirty page set is all mapped pages.
> > > > > We discussed using the vpfn list as a mechanism for vendor drivers to
> > > > > reduce their migration footprint, but we also discussed that we would
> > > > > need a way to determine that all participants in the container have
> > > > > explicitly pinned their working pages or else we must consider the
> > > > > entire potential working set as dirty.
> > > > >     
> > > > 
> > > > How can vendor driver tell this capability to iommu module? Any suggestions?  
> > > 
> > > I think it does so by pinning pages.  Is it acceptable that if the
> > > vendor driver pins any pages, then from that point forward we consider
> > > the IOMMU group dirty page scope to be limited to pinned pages?  There
> > > are complications around non-singleton IOMMU groups, but I think we're
> > > already leaning towards that being a non-worthwhile problem to solve.
> > > So if we require that only singleton IOMMU groups can pin pages and we
> > > pass the IOMMU group as a parameter to
> > > vfio_iommu_driver_ops.pin_pages(), then the type1 backend can set a
> > > flag on its local vfio_group struct to indicate dirty page scope is
> > > limited to pinned pages.  We might want to keep a flag on the
> > > vfio_iommu struct to indicate if all of the vfio_groups for each
> > > vfio_domain in the vfio_iommu.domain_list dirty page scope limited to
> > > pinned pages as an optimization to avoid walking lists too often.  Then
> > > we could test if vfio_iommu.domain_list is not empty and this new flag
> > > does not limit the dirty page scope, then everything within each
> > > vfio_dma is considered dirty.
> > >  
> > 
> > hi Alex
> > could you help clarify whether my understandings below are right?
> > In future,
> > 1. for mdev and for passthrough device withoug hardware ability to track
> > dirty pages, the vendor driver has to explicitly call
> > vfio_pin_pages()/vfio_unpin_pages() + a flag to tell vfio its dirty page set.
> 
> For non-IOMMU backed mdevs without hardware dirty page tracking,
> there's no change to the vendor driver currently.  Pages pinned by the
> vendor driver are marked as dirty.
> 
> For any IOMMU backed device, mdev or direct assignment, all mapped
> memory would be considered dirty unless there are explicit calls to pin
> pages on top of the IOMMU page pinning and mapping.  These would likely
> be enabled only when the device is in the _SAVING device_state.
> 
> > 2. for those devices with hardware ability to track dirty pages, will still
> > provide a callback to vendor driver to get dirty pages. (as for those devices,
> > it is hard to explicitly call vfio_pin_pages()/vfio_unpin_pages())
> >
> > 3. for devices relying on dirty bit info in physical IOMMU, there
> > will be a callback to physical IOMMU driver to get dirty page set from
> > vfio.
> 
> The proposal here does not cover exactly how these would be
> implemented, it only establishes the container as the point of user
> interaction with the dirty bitmap and hopefully allows us to maintain
> that interface regardless of whether we have dirty tracking at the
> device or the system IOMMU.  Ideally devices with dirty tracking would
> make use of page pinning and we'd extend the interface to allow vendor
> drivers the ability to indicate the clean/dirty state of those pinned
> pages.  For system IOMMU dirty page tracking, that potentially might
> mean that we support IOMMU page faults and the container manages those
> faults such that the container is the central record of dirty pages.
> Until these interfaces are designed, we can only speculate, but the
> goal is to design a user interface compatible with how those features
> might evolve.  If you identify something that can't work, please raise
> the issue.  Thanks,
> 
> Alex
>
hi Alex
I think there are two downsides of centralizing dirty page tracking into
vfio container.
1. vendor driver has to report dirty pages to vfio container immediately
after it detects a dirty page.
It lost the freedom to record dirty pages in whatever way and query it on
receiving log_sync call.
e.g. it can record dirty page info in its internal hardware buffer or
record in hardware IOMMU and ask for that by itself.

2. the vfio container, if based on pin_pages, only knows which pages are
dirty or not dirty, but don't know incremental information. That's why
in Kirti's QEMU implementation only query dirty pages after stopping
device, right? but if in that way, QEMU migration may generate a wrong
downtime expectation and cause a longer downtime. E.g.  before stopping
device, QEMU thinks there's only 100M data left and can limit
migration downtime to certain value. but after stopping device and query
dirty pages again, it finds out there're actually 1000M more...

That's more concerns to it.

Thanks
Yan
