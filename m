Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFE911395B
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 02:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfLEBgu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 20:36:50 -0500
Received: from mga03.intel.com ([134.134.136.65]:3577 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbfLEBgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 20:36:50 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Dec 2019 17:36:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,279,1571727600"; 
   d="scan'208";a="294386012"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by orsmga001.jf.intel.com with ESMTP; 04 Dec 2019 17:36:44 -0800
Date:   Wed, 4 Dec 2019 20:28:35 -0500
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
Message-ID: <20191205012835.GB31791@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
 <20191112153020.71406c44@x1.home>
 <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
 <20191113130705.32c6b663@x1.home>
 <7f74a2a1-ba1c-9d4c-dc5e-343ecdd7d6d6@nvidia.com>
 <20191114140625.213e8a99@x1.home>
 <20191126005739.GA31144@joy-OptiPlex-7040>
 <20191203110412.055c38df@x1.home>
 <cce08ca5-79df-2839-16cd-15723b995c07@nvidia.com>
 <20191204113457.16c1316d@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204113457.16c1316d@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 05, 2019 at 02:34:57AM +0800, Alex Williamson wrote:
> On Wed, 4 Dec 2019 23:40:25 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
> > On 12/3/2019 11:34 PM, Alex Williamson wrote:
> > > On Mon, 25 Nov 2019 19:57:39 -0500
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >   
> > >> On Fri, Nov 15, 2019 at 05:06:25AM +0800, Alex Williamson wrote:  
> > >>> On Fri, 15 Nov 2019 00:26:07 +0530
> > >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > >>>      
> > >>>> On 11/14/2019 1:37 AM, Alex Williamson wrote:  
> > >>>>> On Thu, 14 Nov 2019 01:07:21 +0530
> > >>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > >>>>>        
> > >>>>>> On 11/13/2019 4:00 AM, Alex Williamson wrote:  
> > >>>>>>> On Tue, 12 Nov 2019 22:33:37 +0530
> > >>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > >>>>>>>           
> > >>>>>>>> All pages pinned by vendor driver through vfio_pin_pages API should be
> > >>>>>>>> considered as dirty during migration. IOMMU container maintains a list of
> > >>>>>>>> all such pinned pages. Added an ioctl defination to get bitmap of such  
> > >>>>>>>
> > >>>>>>> definition
> > >>>>>>>           
> > >>>>>>>> pinned pages for requested IO virtual address range.  
> > >>>>>>>
> > >>>>>>> Additionally, all mapped pages are considered dirty when physically
> > >>>>>>> mapped through to an IOMMU, modulo we discussed devices opting in to
> > >>>>>>> per page pinning to indicate finer granularity with a TBD mechanism to
> > >>>>>>> figure out if any non-opt-in devices remain.
> > >>>>>>>           
> > >>>>>>
> > >>>>>> You mean, in case of device direct assignment (device pass through)?  
> > >>>>>
> > >>>>> Yes, or IOMMU backed mdevs.  If vfio_dmas in the container are fully
> > >>>>> pinned and mapped, then the correct dirty page set is all mapped pages.
> > >>>>> We discussed using the vpfn list as a mechanism for vendor drivers to
> > >>>>> reduce their migration footprint, but we also discussed that we would
> > >>>>> need a way to determine that all participants in the container have
> > >>>>> explicitly pinned their working pages or else we must consider the
> > >>>>> entire potential working set as dirty.
> > >>>>>        
> > >>>>
> > >>>> How can vendor driver tell this capability to iommu module? Any suggestions?  
> > >>>
> > >>> I think it does so by pinning pages.  Is it acceptable that if the
> > >>> vendor driver pins any pages, then from that point forward we consider
> > >>> the IOMMU group dirty page scope to be limited to pinned pages?  There  
> > >> we should also be aware of that dirty page scope is pinned pages + unpinned pages,
> > >> which means ever since a page is pinned, it should be regarded as dirty
> > >> no matter whether it's unpinned later. only after log_sync is called and
> > >> dirty info retrieved, its dirty state should be cleared.  
> > > 
> > > Yes, good point.  We can't just remove a vpfn when a page is unpinned
> > > or else we'd lose information that the page potentially had been
> > > dirtied while it was pinned.  Maybe that vpfn needs to move to a dirty
> > > list and both the currently pinned vpfns and the dirty vpfns are walked
> > > on a log_sync.  The dirty vpfns list would be cleared after a log_sync.
> > > The container would need to know that dirty tracking is enabled and
> > > only manage the dirty vpfns list when necessary.  Thanks,
> > >   
> > 
> > If page is unpinned, then that page is available in free page pool for 
> > others to use, then how can we say that unpinned page has valid data?
> > 
> > If suppose, one driver A unpins a page and when driver B of some other 
> > device gets that page and he pins it, uses it, and then unpins it, then 
> > how can we say that page has valid data for driver A?
> > 
> > Can you give one example where unpinned page data is considered reliable 
> > and valid?
> 
> We can only pin pages that the user has already allocated* and mapped
> through the vfio DMA API.  The pinning of the page simply locks the
> page for the vendor driver to access it and unpinning that page only
> indicates that access is complete.  Pages are not freed when a vendor
> driver unpins them, they still exist and at this point we're now
> assuming the device dirtied the page while it was pinned.  Thanks,
> 
> Alex
> 
> * An exception here is that the page might be demand allocated and the
>   act of pinning the page could actually allocate the backing page for
>   the user if they have not faulted the page to trigger that allocation
>   previously.  That page remains mapped for the user's virtual address
>   space even after the unpinning though.
>

Yes, I can give an example in GVT.
when a gem_object is allocated in guest, before submitting it to guest
vGPU, gfx cmds in its ring buffer need to be pinned into GGTT to get a
global graphics address for hardware access. At that time, we shadow
those cmds and pin pages through vfio pin_pages(), and submit the shadow
gem_object to physial hardware.
After guest driver thinks the submitted gem_object has completed hardware
DMA, it unnpinnd those pinned GGTT graphics memory addresses. Then in
host, we unpin the shadow pages through vfio unpin_pages.
But, at this point, guest driver is still free to access the gem_object
through vCPUs, and guest user space is probably still mapping an object
into the gem_object in guest driver.
So, missing the dirty page tracking for unpinned pages would cause
data inconsitency.

Thanks
Yan
