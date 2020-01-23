Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D18DB146566
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 11:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgAWKLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 05:11:43 -0500
Received: from mga05.intel.com ([192.55.52.43]:59628 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgAWKLn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 05:11:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Jan 2020 02:11:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,353,1574150400"; 
   d="scan'208";a="400293430"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.16])
  by orsmga005.jf.intel.com with ESMTP; 23 Jan 2020 02:11:40 -0800
Date:   Thu, 23 Jan 2020 05:02:27 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>
Subject: Re: [PATCH v2 2/2] drm/i915/gvt: subsitute kvm_read/write_guest with
 vfio_dma_rw
Message-ID: <20200123100227.GJ1759@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20200115035455.12417-1-yan.y.zhao@intel.com>
 <20200115130651.29d7e9e0@w520.home>
 <20200116054941.GB1759@joy-OptiPlex-7040>
 <20200116083729.40983f38@w520.home>
 <20200119100637.GD1759@joy-OptiPlex-7040>
 <20200120130157.0ee7042d@w520.home>
 <20200121081207.GE1759@joy-OptiPlex-7040>
 <20200121095116.05eeae14@w520.home>
 <20200121221038.GH1759@joy-OptiPlex-7040>
 <20200122030758.GI1759@joy-OptiPlex-7040>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122030758.GI1759@joy-OptiPlex-7040>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 22, 2020 at 11:07:58AM +0800, Yan Zhao wrote:
> On Wed, Jan 22, 2020 at 06:10:38AM +0800, Yan Zhao wrote:
> > On Wed, Jan 22, 2020 at 12:51:16AM +0800, Alex Williamson wrote:
> > > On Tue, 21 Jan 2020 03:12:07 -0500
> > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > 
> > > > On Tue, Jan 21, 2020 at 04:01:57AM +0800, Alex Williamson wrote:
> > > > > On Sun, 19 Jan 2020 05:06:37 -0500
> > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > >   
> > > > > > On Thu, Jan 16, 2020 at 11:37:29PM +0800, Alex Williamson wrote:  
> > > > > > > On Thu, 16 Jan 2020 00:49:41 -0500
> > > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > >     
> > > > > > > > On Thu, Jan 16, 2020 at 04:06:51AM +0800, Alex Williamson wrote:    
> > > > > > > > > On Tue, 14 Jan 2020 22:54:55 -0500
> > > > > > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > > > > > >       
> > > > > > > > > > As a device model, it is better to read/write guest memory using vfio
> > > > > > > > > > interface, so that vfio is able to maintain dirty info of device IOVAs.
> > > > > > > > > > 
> > > > > > > > > > Compared to kvm interfaces kvm_read/write_guest(), vfio_dma_rw() has ~600
> > > > > > > > > > cycles more overhead on average.
> > > > > > > > > > 
> > > > > > > > > > -------------------------------------
> > > > > > > > > > |    interface     | avg cpu cycles |
> > > > > > > > > > |-----------------------------------|
> > > > > > > > > > | kvm_write_guest  |     1554       |
> > > > > > > > > > | ----------------------------------|
> > > > > > > > > > | kvm_read_guest   |     707        |
> > > > > > > > > > |-----------------------------------|
> > > > > > > > > > | vfio_dma_rw(w)   |     2274       |
> > > > > > > > > > |-----------------------------------|
> > > > > > > > > > | vfio_dma_rw(r)   |     1378       |
> > > > > > > > > > -------------------------------------      
> > > > > > > > > 
> > > > > > > > > In v1 you had:
> > > > > > > > > 
> > > > > > > > > -------------------------------------
> > > > > > > > > |    interface     | avg cpu cycles |
> > > > > > > > > |-----------------------------------|
> > > > > > > > > | kvm_write_guest  |     1546       |
> > > > > > > > > | ----------------------------------|
> > > > > > > > > | kvm_read_guest   |     686        |
> > > > > > > > > |-----------------------------------|
> > > > > > > > > | vfio_iova_rw(w)  |     2233       |
> > > > > > > > > |-----------------------------------|
> > > > > > > > > | vfio_iova_rw(r)  |     1262       |
> > > > > > > > > -------------------------------------
> > > > > > > > > 
> > > > > > > > > So the kvm numbers remained within +0.5-3% while the vfio numbers are
> > > > > > > > > now +1.8-9.2%.  I would have expected the algorithm change to at least
> > > > > > > > > not be worse for small accesses and be better for accesses crossing
> > > > > > > > > page boundaries.  Do you know what happened?
> > > > > > > > >      
> > > > > > > > I only tested the 4 interfaces in GVT's environment, where most of the
> > > > > > > > guest memory accesses are less than one page.
> > > > > > > > And the different fluctuations should be caused by the locks.
> > > > > > > > vfio_dma_rw contends locks with other vfio accesses which are assumed to
> > > > > > > > be abundant in the case of GVT.    
> > > > > > > 
> > > > > > > Hmm, so maybe it's time to convert vfio_iommu.lock from a mutex to a
> > > > > > > rwsem?  Thanks,
> > > > > > >     
> > > > > > 
> > > > > > hi Alex
> > > > > > I tested your rwsem patches at (https://lkml.org/lkml/2020/1/16/1869).
> > > > > > They works without any runtime error at my side. :) 
> > > > > > However, I found out that the previous fluctuation may be because I didn't
> > > > > > take read/write counts in to account.
> > > > > > For example. though the two tests have different avg read/write cycles,
> > > > > > their average cycles are almost the same.
> > > > > >  ______________________________________________________________________
> > > > > > |        | avg read |            | avg write |            |            |
> > > > > > |        | cycles   | read cnt   | cycles    | write cnt  | avg cycles |
> > > > > > |----------------------------------------------------------------------|
> > > > > > | test 1 |   1339   | 29,587,120 |  2258     | 17,098,364 |    1676    |
> > > > > > | test 2 |   1340   | 28,454,262 |  2238     | 16,501,788 |    1670    |
> > > > > >  ----------------------------------------------------------------------
> > > > > > 
> > > > > > After measuring the exact read/write cnt and cycles of a specific workload,
> > > > > > I get below findings:
> > > > > > 
> > > > > > (1) with single VM running glmark2 inside.
> > > > > > glmark2: 40M+ read+write cnt, among which 63% is read.
> > > > > > among reads, 48% is of PAGE_SIZE, the rest is less than a page.
> > > > > > among writes, 100% is less than a page.
> > > > > > 
> > > > > >  __________________________________________________
> > > > > > |       cycles         | read | write |  avg | inc |
> > > > > > |--------------------------------------------------|
> > > > > > | kvm_read/write_page  |  694 |  1506 |  993 |  /  |
> > > > > > |--------------------------------------------------|
> > > > > > |  vfio_dma_rw(mutex)  | 1340 |  2248 | 1673 | 680 |
> > > > > > |--------------------------------------------------|
> > > > > > | vfio_dma_rw(rwsem r) | 1323 |  2198 | 1645 | 653 |
> > > > > >  ---------------------------------------------------
> > > > > > 
> > > > > > so vfio_dma_rw generally has 650+ more cycles per each read/write.
> > > > > > While kvm->srcu is of 160 cycles on average with one vm is running, the
> > > > > > cycles spending on locks for vfio_dma_rw spread like this:
> > > > > >  ___________________________
> > > > > > |        cycles       | avg |
> > > > > > |---------------------------|
> > > > > > |     iommu->lock     | 117 |
> > > > > > |---------------------------|
> > > > > > |   vfio.group_lock   | 108 |
> > > > > > |---------------------------|
> > > > > > | group->unbound_lock | 114 |
> > > > > > |---------------------------|
> > > > > > |  group->device_lock | 115 |
> > > > > > |---------------------------|
> > > > > > |     group->mutex    | 113 |
> > > > > >  ---------------------------
> > > > > > 
> > > > > > I measured the cycles for a mutex without any contention is 104 cycles
> > > > > > on average (including time for get_cycles() and measured in the same way
> > > > > > as other locks). So the contention of a single lock in a single vm
> > > > > > environment is light. probably because there's a vgpu lock hold in GVT already.
> > > > > > 
> > > > > > (2) with two VMs each running glmark2 inside.
> > > > > > The contention increases a little.
> > > > > > 
> > > > > >  ___________________________________________________
> > > > > > |       cycles         | read | write |  avg | inc  |
> > > > > > |---------------------------------------------------|
> > > > > > | kvm_read/write_page  | 1035 |  1832 | 1325 |  /   |
> > > > > > |---------------------------------------------------|
> > > > > > |  vfio_dma_rw(mutex)  | 2104 |  2886 | 2390 | 1065 |
> > > > > > |---------------------------------------------------|
> > > > > > | vfio_dma_rw(rwsem r) | 1965 |  2778 | 2260 | 935  |
> > > > > >  ---------------------------------------------------
> > > > > > 
> > > > > > 
> > > > > >  -----------------------------------------------
> > > > > > |     avg cycles       |   one VM   |  two VMs  |
> > > > > > |-----------------------------------------------|
> > > > > > |  iommu lock (mutex)  |     117    |   150     |
> > > > > > |-----------------------------------|-----------|
> > > > > > | iommu lock (rwsem r) |     117    |   156     |
> > > > > > |-----------------------------------|-----------|
> > > > > > |   kvm->srcu          |     160    |   213     |
> > > > > >  -----------------------------------------------
> > > > > > 
> > > > > > In the kvm case, avg cycles increased 332 cycles, while kvm->srcu only costed
> > > > > > 213 cycles. The rest 109 cycles may be spent on atomic operations.
> > > > > > But I didn't measure them, as get_cycles() operation itself would influence final
> > > > > > cycles by ~20 cycles.  
> > > > > 
> > > > > It seems like we need to extend the vfio external user interface so
> > > > > that GVT-g can hold the group and container user references across
> > > > > multiple calls.  For instance if we had a
> > > > > vfio_group_get_external_user_from_dev() (based on
> > > > > vfio_group_get_external_user()) then i915 could get an opaque
> > > > > vfio_group pointer which it could use to call vfio_group_dma_rw() which
> > > > > would leave us with only the iommu rw_sem locking.  i915 would release
> > > > > the reference with vfio_group_put_external_user() when the device is
> > > > > released.  The same could be done with the pin pages interface to
> > > > > streamline that as well.  Thoughts?  Thanks,
> > > > >  
> > > > hi Alex,
> > > > it works!
> > > 
> > > Hurrah!
> > > 
> > > > now the average vfio_dma_rw cycles can reduced to 1198. 
> > > > one thing I want to propose is that, in sight of dma->task is always user
> > > > space process, instead of calling get_task_mm(dma->task), can we just use
> > > > "mmget_not_zero(dma->task->mm)"? in this way, the avg cycles can
> > > > further reduce to 1051.
> > > 
> > > I'm not an expert there.  As noted in the type1 code we hold a
> > > reference to the task because it's not advised to hold a long term
> > > reference to the mm, so do we know we can look at task->mm without
> > > acquiring task_lock()?  It's possible this is safe, but it's not
> > > abundantly obvious to me.  Please research further and provide
> > > justification if you think it's correct.  Thanks,
> > > 
> > in get_task_mm, 
> > struct mm_struct *get_task_mm(struct task_struct *task)
> > {
> >         struct mm_struct *mm;
> > 
> >         task_lock(task);
> >         mm = task->mm;
> >         if (mm) {
> >                 if (task->flags & PF_KTHREAD)
> >                         mm = NULL;
> >                 else
> >                         mmget(mm);
> >         }
> >         task_unlock(task);
> >         return mm;
> > }
> > task lock is hold only during the call, so the purpose of it is to
> > ensure task->flags and task->mm is not changed or gone before mmget(mm)
> > or function return.
> > so, if we know for sure the task always has no flag PF_THREAD,
> > then we only need to ensure mm is not gone before mmget(mm) is done.
> > 
> > static inline void mmget(struct mm_struct *mm)
> > {
> >         atomic_inc(&mm->mm_users);
> > }
> > 
> > static inline bool mmget_not_zero(struct mm_struct *mm)
> > {
> >         return atomic_inc_not_zero(&mm->mm_users);
> > }
> > 
> > the atomic_inc_not_zero() in  mmget_not_zero can ensure mm is not gone
> > before its ref count inc.
> > 
> > So, I think the only thing we need to make sure is dma->task is not a
> > kernel thread.
> > Do you think I can make this assumption?
> > 
> hi Alex
> Maybe I can still test PF_KTHREAD without holding task_lock
> (task->alloc_lock), as it is only used to protect
> "->fs, ->files, ->mm, ->group_info, ->comm, keyring
> subscriptions and synchronises with wait4().  Also used in procfs.  Also
> pins the final release of task.io_context.  Also protects ->cpuset and 
> ->cgroup.subsys[]. And ->vfork_done."
> 
> I checked elsewhere in kernel, e.g.
> try_to_wake_up
> 	|->select_task_rq
> 		|->is_per_cpu_kthread
> 			|->if (!(p->flags & PF_KTHREAD))
> task->alloc_lock is not hold there.
> 
> So, I would replace get_task_mm(dma->task) into two steps:
> (1) check dma->task->flags & PF_KTHREAD, and (2) mmget_not_zero(mm).
> 
> I'll do more tests and send out new patches after Chinese new year.
> 
> Thanks
> Yan
>
hi Alex
after a second thought, I find out that the task->alloc_lock cannot be
dropped, as there are chances that dma->task->mm is set to null between
checking "dma->task->mm != NULL" and "mmget_not_zero(dma->task->mm)".

The chances of this condition can be increased by adding a msleep in-between
the two lines of code to mimic possible task schedule. Then it was proved that
dma->task->mm could be set to NULL in exit_mm() by killing QEMU.

So I have to keep the call to get_task_mm().  :)

Thanks
Yan


