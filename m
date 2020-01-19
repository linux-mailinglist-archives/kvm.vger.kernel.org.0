Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84BA4141D48
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 11:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgASKPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 05:15:52 -0500
Received: from mga04.intel.com ([192.55.52.120]:56813 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbgASKPv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 05:15:51 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jan 2020 02:15:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,337,1574150400"; 
   d="scan'208";a="399104727"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005.jf.intel.com with ESMTP; 19 Jan 2020 02:15:49 -0800
Date:   Sun, 19 Jan 2020 05:06:37 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [PATCH v2 2/2] drm/i915/gvt: subsitute kvm_read/write_guest with
 vfio_dma_rw
Message-ID: <20200119100637.GD1759@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200115034132.2753-1-yan.y.zhao@intel.com>
 <20200115035455.12417-1-yan.y.zhao@intel.com>
 <20200115130651.29d7e9e0@w520.home>
 <20200116054941.GB1759@joy-OptiPlex-7040>
 <20200116083729.40983f38@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116083729.40983f38@w520.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 16, 2020 at 11:37:29PM +0800, Alex Williamson wrote:
> On Thu, 16 Jan 2020 00:49:41 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Thu, Jan 16, 2020 at 04:06:51AM +0800, Alex Williamson wrote:
> > > On Tue, 14 Jan 2020 22:54:55 -0500
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > >   
> > > > As a device model, it is better to read/write guest memory using vfio
> > > > interface, so that vfio is able to maintain dirty info of device IOVAs.
> > > > 
> > > > Compared to kvm interfaces kvm_read/write_guest(), vfio_dma_rw() has ~600
> > > > cycles more overhead on average.
> > > > 
> > > > -------------------------------------
> > > > |    interface     | avg cpu cycles |
> > > > |-----------------------------------|
> > > > | kvm_write_guest  |     1554       |
> > > > | ----------------------------------|
> > > > | kvm_read_guest   |     707        |
> > > > |-----------------------------------|
> > > > | vfio_dma_rw(w)   |     2274       |
> > > > |-----------------------------------|
> > > > | vfio_dma_rw(r)   |     1378       |
> > > > -------------------------------------  
> > > 
> > > In v1 you had:
> > > 
> > > -------------------------------------
> > > |    interface     | avg cpu cycles |
> > > |-----------------------------------|
> > > | kvm_write_guest  |     1546       |
> > > | ----------------------------------|
> > > | kvm_read_guest   |     686        |
> > > |-----------------------------------|
> > > | vfio_iova_rw(w)  |     2233       |
> > > |-----------------------------------|
> > > | vfio_iova_rw(r)  |     1262       |
> > > -------------------------------------
> > > 
> > > So the kvm numbers remained within +0.5-3% while the vfio numbers are
> > > now +1.8-9.2%.  I would have expected the algorithm change to at least
> > > not be worse for small accesses and be better for accesses crossing
> > > page boundaries.  Do you know what happened?
> > >  
> > I only tested the 4 interfaces in GVT's environment, where most of the
> > guest memory accesses are less than one page.
> > And the different fluctuations should be caused by the locks.
> > vfio_dma_rw contends locks with other vfio accesses which are assumed to
> > be abundant in the case of GVT.
> 
> Hmm, so maybe it's time to convert vfio_iommu.lock from a mutex to a
> rwsem?  Thanks,
> 

hi Alex
I tested your rwsem patches at (https://lkml.org/lkml/2020/1/16/1869).
They works without any runtime error at my side. :) 
However, I found out that the previous fluctuation may be because I didn't
take read/write counts in to account.
For example. though the two tests have different avg read/write cycles,
their average cycles are almost the same.
 ______________________________________________________________________
|        | avg read |            | avg write |            |            |
|        | cycles   | read cnt   | cycles    | write cnt  | avg cycles |
|----------------------------------------------------------------------|
| test 1 |   1339   | 29,587,120 |  2258     | 17,098,364 |    1676    |
| test 2 |   1340   | 28,454,262 |  2238     | 16,501,788 |    1670    |
 ----------------------------------------------------------------------

After measuring the exact read/write cnt and cycles of a specific workload,
I get below findings:

(1) with single VM running glmark2 inside.
glmark2: 40M+ read+write cnt, among which 63% is read.
among reads, 48% is of PAGE_SIZE, the rest is less than a page.
among writes, 100% is less than a page.

 __________________________________________________
|       cycles         | read | write |  avg | inc |
|--------------------------------------------------|
| kvm_read/write_page  |  694 |  1506 |  993 |  /  |
|--------------------------------------------------|
|  vfio_dma_rw(mutex)  | 1340 |  2248 | 1673 | 680 |
|--------------------------------------------------|
| vfio_dma_rw(rwsem r) | 1323 |  2198 | 1645 | 653 |
 ---------------------------------------------------

so vfio_dma_rw generally has 650+ more cycles per each read/write.
While kvm->srcu is of 160 cycles on average with one vm is running, the
cycles spending on locks for vfio_dma_rw spread like this:
 ___________________________
|        cycles       | avg |
|---------------------------|
|     iommu->lock     | 117 |
|---------------------------|
|   vfio.group_lock   | 108 |
|---------------------------|
| group->unbound_lock | 114 |
|---------------------------|
|  group->device_lock | 115 |
|---------------------------|
|     group->mutex    | 113 |
 ---------------------------

I measured the cycles for a mutex without any contention is 104 cycles
on average (including time for get_cycles() and measured in the same way
as other locks). So the contention of a single lock in a single vm
environment is light. probably because there's a vgpu lock hold in GVT already.

(2) with two VMs each running glmark2 inside.
The contention increases a little.

 ___________________________________________________
|       cycles         | read | write |  avg | inc  |
|---------------------------------------------------|
| kvm_read/write_page  | 1035 |  1832 | 1325 |  /   |
|---------------------------------------------------|
|  vfio_dma_rw(mutex)  | 2104 |  2886 | 2390 | 1065 |
|---------------------------------------------------|
| vfio_dma_rw(rwsem r) | 1965 |  2778 | 2260 | 935  |
 ---------------------------------------------------


 -----------------------------------------------
|     avg cycles       |   one VM   |  two VMs  |
|-----------------------------------------------|
|  iommu lock (mutex)  |     117    |   150     |
|-----------------------------------|-----------|
| iommu lock (rwsem r) |     117    |   156     |
|-----------------------------------|-----------|
|   kvm->srcu          |     160    |   213     |
 -----------------------------------------------

In the kvm case, avg cycles increased 332 cycles, while kvm->srcu only costed
213 cycles. The rest 109 cycles may be spent on atomic operations.
But I didn't measure them, as get_cycles() operation itself would influence final
cycles by ~20 cycles.


Thanks
Yan




> 
> > > > Comparison of benchmarks scores are as blow:
> > > > ------------------------------------------------------
> > > > |  avg score  | kvm_read/write_guest  | vfio_dma_rw  |
> > > > |----------------------------------------------------|
> > > > |   Glmark2   |         1284          |    1296      |
> > > > |----------------------------------------------------|
> > > > |  Lightsmark |         61.24         |    61.27     |
> > > > |----------------------------------------------------|
> > > > |  OpenArena  |         140.9         |    137.4     |
> > > > |----------------------------------------------------|
> > > > |   Heaven    |          671          |     670      |
> > > > ------------------------------------------------------
> > > > No obvious performance downgrade found.
> > > > 
> > > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > ---
> > > >  drivers/gpu/drm/i915/gvt/kvmgt.c | 26 +++++++-------------------
> > > >  1 file changed, 7 insertions(+), 19 deletions(-)
> > > > 
> > > > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > > > index bd79a9718cc7..17edc9a7ff05 100644
> > > > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > > > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > > > @@ -1966,31 +1966,19 @@ static int kvmgt_rw_gpa(unsigned long handle, unsigned long gpa,
> > > >  			void *buf, unsigned long len, bool write)
> > > >  {
> > > >  	struct kvmgt_guest_info *info;
> > > > -	struct kvm *kvm;
> > > > -	int idx, ret;
> > > > -	bool kthread = current->mm == NULL;
> > > > +	int ret;
> > > > +	struct intel_vgpu *vgpu;
> > > > +	struct device *dev;
> > > >  
> > > >  	if (!handle_valid(handle))
> > > >  		return -ESRCH;
> > > >  
> > > >  	info = (struct kvmgt_guest_info *)handle;
> > > > -	kvm = info->kvm;
> > > > -
> > > > -	if (kthread) {
> > > > -		if (!mmget_not_zero(kvm->mm))
> > > > -			return -EFAULT;
> > > > -		use_mm(kvm->mm);
> > > > -	}
> > > > -
> > > > -	idx = srcu_read_lock(&kvm->srcu);
> > > > -	ret = write ? kvm_write_guest(kvm, gpa, buf, len) :
> > > > -		      kvm_read_guest(kvm, gpa, buf, len);
> > > > -	srcu_read_unlock(&kvm->srcu, idx);
> > > > +	vgpu = info->vgpu;
> > > > +	dev = mdev_dev(vgpu->vdev.mdev);
> > > >  
> > > > -	if (kthread) {
> > > > -		unuse_mm(kvm->mm);
> > > > -		mmput(kvm->mm);
> > > > -	}
> > > > +	ret = write ? vfio_dma_rw(dev, gpa, buf, len, true) :
> > > > +			vfio_dma_rw(dev, gpa, buf, len, false);  
> > > 
> > > As Paolo suggested previously, this can be simplified:
> > > 
> > > ret = vfio_dma_rw(dev, gpa, buf, len, write);
> > >  
> > > >  
> > > >  	return ret;  
> > > 
> > > Or even more simple, remove the ret variable:
> > > 
> > > return vfio_dma_rw(dev, gpa, buf, len, write);
> > >   
> > oh, it seems that I missed Paolo's mail. will change it. thank you!
> > 
> > Thanks
> > Yan
> > >   
> > > >  }  
> > >   
> > 
> 
