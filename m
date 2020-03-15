Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCC71860AD
	for <lists+kvm@lfdr.de>; Mon, 16 Mar 2020 01:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgCPAGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Mar 2020 20:06:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:49834 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729065AbgCPAGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Mar 2020 20:06:06 -0400
IronPort-SDR: bItU5+bpVuQLYsEPRLswc7/pJvuCimljUVFMsVs3ahCzsFi58JEbJaSfCxCPdQLKUwW5ZpK2pS
 +vps9hVRAx3Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2020 17:06:05 -0700
IronPort-SDR: K011tSRQz9rFpJchs1l25EtCl6RLu7klBLFQCrFnLlMtL32vbRkwWon/pUs4Jmh8bxMm1ykU7h
 MqPyTcJd/2/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,558,1574150400"; 
   d="scan'208";a="443119513"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by fmsmga005.fm.intel.com with ESMTP; 15 Mar 2020 17:06:02 -0700
Date:   Sun, 15 Mar 2020 19:56:33 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Neo Jia (cjia@nvidia.com)" <cjia@nvidia.com>
Subject: Re: [PATCH v4 0/7] use vfio_dma_rw to read/write IOVAs from CPU side
Message-ID: <20200315235633.GB4641@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200313030548.7705-1-yan.y.zhao@intel.com>
 <20200313162958.5bfb5b82@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313162958.5bfb5b82@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Mar 14, 2020 at 06:29:58AM +0800, Alex Williamson wrote:
> [Cc +NVIDIA]
> 
> On Thu, 12 Mar 2020 23:05:48 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > It is better for a device model to use IOVAs to read/write memory to
> > perform some sort of virtual DMA on behalf of the device.
> > 
> > patch 1 exports VFIO group to external user so that it can hold the group
> > reference until finishing using of it. It saves ~500 cycles that are spent
> > on VFIO group looking up, referencing and dereferencing. (this data is
> > measured with 1 VFIO user).
> > 
> > patch 2 introduces interface vfio_dma_rw().
> > 
> > patch 3 introduces interfaces vfio_group_pin_pages() and
> > vfio_group_unpin_pages() to get rid of VFIO group looking-up in
> > vfio_pin_pages() and vfio_unpin_pages().
> > 
> > patch 4-5 let kvmgt switch from calling kvm_read/write_guest() to calling
> > vfio_dma_rw to rw IOVAs.
> > 
> > patch 6 let kvmgt switch to use lighter version of vfio_pin/unpin_pages(),
> > i.e. vfio_group_pin/unpin_pages()
> > 
> > patch 7 enables kvmgt to read/write IOVAs of size larger than PAGE_SIZE.
> 
> This looks pretty good to me, hopefully Kirti and Neo can find some
> advantage with this series as well.  Given that we're also trying to
> get the migration interface and dirty page tracking integrated for
> v5.7, would it make sense to merge the first 3 patches via my next
> branch?  This is probably the easiest way to update the dirty tracking.
> Thanks,
> 
sure. glad to hear that :)

Thanks
Yan

> 
> > Performance:
> > 
> > Comparison between vfio_dma_rw() and kvm_read/write_guest():
> > 
> > 1. avergage CPU cycles of each interface measured with 1 running VM:
> >  --------------------------------------------------
> > |  rw       |          avg cycles of               |
> > |  size     | (vfio_dma_rw - kvm_read/write_guest) |
> > |---------- ---------------------------------------|
> > | <= 1 page |            +155 ~ +195               |        
> > |--------------------------------------------------|
> > | 5 pages   |                -530                  |
> > |--------------------------------------------------|
> > | 20 pages  |           -2005 ~ -2533              |
> >  --------------------------------------------------
> > 
> > 2. average scores
> > 
> > base: base code before applying code in this series. use
> > kvm_read/write_pages() to rw IOVAs
> > 
> > base + this series: use vfio_dma_rw() to read IOVAs and use
> > vfio_group_pin/unpin_pages(), and kvmgt is able to rw several pages
> > at a time.
> > 
> > Scores of benchmarks running in 1 VM each:
> >  -----------------------------------------------------------------
> > |                    | glmark2 | lightsmark | openarena | heavens |
> > |-----------------------------------------------------------------|
> > |       base         |  1248   |  219.70    |  114.9    |   560   |
> > |-----------------------------------------------------------------|
> > |base + this series  |  1248   |  225.8     |   115     |   559   |
> >  -----------------------------------------------------------------
> > 
> > Sum of scores of two benchmark instances running in 2 VMs each:
> >  -------------------------------------------------------
> > |                    | glmark2 | lightsmark | openarena |
> > |-------------------------------------------------------|
> > |       base         |  812    |  211.46    |  115.3    |
> > |-------------------------------------------------------|
> > |base + this series  |  814    |  214.69    |  115.9    |
> >  -------------------------------------------------------
> > 
> > 
> > Changelogs:
> > v3 --> v4:
> > - rebased to 5.6.0-rc4+
> > - adjust wrap position for vfio_group_get_external_user_from_dev() in
> >   header file.(Alex)
> > - updated function description of vfio_group_get_external_user_from_dev()
> >   (Alex)
> > - fixed Error path group reference leaking in
> >   vfio_group_get_external_user_from_dev()  (Alex)
> > - reurn 0 for success or errno in vfio_dma_rw_chunk(). (Alex)
> > - renamed iova to user_iova in interface vfio_dam_rw().
> > - renamed vfio_pin_pages_from_group() and vfio_unpin_pages_from_group() to
> >   vfio_group_pin_pages() and vfio_group_unpin_pages()
> > - renamed user_pfn to user_iova_pfn in vfio_group_pin_pages() and
> >   vfio_group_unpin_pages()
> > 
> > v2 --> v3:
> > - add vfio_group_get_external_user_from_dev() to improve performance (Alex)
> > - add vfio_pin/unpin_pages_from_group() to avoid repeated looking up of
> >   VFIO group in vfio_pin/unpin_pages() (Alex)
> > - add a check for IOMMU_READ permission. (Alex)
> > - rename vfio_iommu_type1_rw_dma_nopin() to
> >   vfio_iommu_type1_dma_rw_chunk(). (Alex)
> > - in kvmgt, change "write ? vfio_dma_rw(...,true) :
> >   vfio_dma_rw(...,false)" to vfio_dma_rw(dev, gpa, buf, len, write)
> >   (Alex and Paolo)
> > - in kvmgt, instead of read/write context pages 1:1, combining the
> >   reads/writes of continuous IOVAs to take advantage of vfio_dma_rw() for
> >   faster crossing page boundary accesses.
> > 
> > v1 --> v2:
> > - rename vfio_iova_rw to vfio_dma_rw, vfio iommu driver ops .iova_rw
> > to .dma_rw. (Alex).
> > - change iova and len from unsigned long to dma_addr_t and size_t,
> > respectively. (Alex)
> > - fix possible overflow in dma->vaddr + iova - dma->iova + offset (Alex)
> > - split DMAs from on page boundary to on max available size to eliminate
> >   redundant searching of vfio_dma and switching mm. (Alex)
> > - add a check for IOMMU_WRITE permission.
> > 
> > 
> > Yan Zhao (7):
> >   vfio: allow external user to get vfio group from device
> >   vfio: introduce vfio_dma_rw to read/write a range of IOVAs
> >   vfio: avoid inefficient operations on VFIO group in
> >     vfio_pin/unpin_pages
> >   drm/i915/gvt: hold reference of VFIO group during opening of vgpu
> >   drm/i915/gvt: subsitute kvm_read/write_guest with vfio_dma_rw
> >   drm/i915/gvt: switch to user vfio_group_pin/upin_pages
> >   drm/i915/gvt: rw more pages a time for shadow context
> > 
> >  drivers/gpu/drm/i915/gvt/kvmgt.c     |  46 ++++---
> >  drivers/gpu/drm/i915/gvt/scheduler.c |  97 ++++++++++-----
> >  drivers/vfio/vfio.c                  | 180 +++++++++++++++++++++++++++
> >  drivers/vfio/vfio_iommu_type1.c      |  76 +++++++++++
> >  include/linux/vfio.h                 |  13 ++
> >  5 files changed, 360 insertions(+), 52 deletions(-)
> > 
> 
