Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 279401300BC
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2020 05:08:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgADEBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 23:01:34 -0500
Received: from mga18.intel.com ([134.134.136.126]:61499 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgADEBd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jan 2020 23:01:33 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jan 2020 20:01:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,393,1571727600"; 
   d="scan'208";a="216937680"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by fmsmga008.fm.intel.com with ESMTP; 03 Jan 2020 20:01:29 -0800
Date:   Fri, 3 Jan 2020 22:53:10 -0500
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Kirti Wankhede <kwankhede@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v10 Kernel 4/5] vfio iommu: Implementation of ioctl to
 for dirty pages tracking.
Message-ID: <20200104035310.GA32421@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20191217051513.GE21868@joy-OptiPlex-7040>
 <17ac4c3b-5f7c-0e52-2c2b-d847d4d4e3b1@nvidia.com>
 <20191217095110.GH21868@joy-OptiPlex-7040>
 <0d9604d9-3bb2-6944-9858-983366f332bb@nvidia.com>
 <20191218010451.GI21868@joy-OptiPlex-7040>
 <20191218200552.GX3707@work-vm>
 <20191219005749.GJ21868@joy-OptiPlex-7040>
 <75c4f23b-b668-6edb-2f4e-191b253cede9@nvidia.com>
 <20191220005836.GK21868@joy-OptiPlex-7040>
 <20200103194434.GT3804@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103194434.GT3804@work-vm>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jan 04, 2020 at 03:44:34AM +0800, Dr. David Alan Gilbert wrote:
> * Yan Zhao (yan.y.zhao@intel.com) wrote:
> > On Fri, Dec 20, 2019 at 12:21:45AM +0800, Kirti Wankhede wrote:
> > > 
> > > 
> > > On 12/19/2019 6:27 AM, Yan Zhao wrote:
> > > > On Thu, Dec 19, 2019 at 04:05:52AM +0800, Dr. David Alan Gilbert wrote:
> > > >> * Yan Zhao (yan.y.zhao@intel.com) wrote:
> > > >>> On Tue, Dec 17, 2019 at 07:47:05PM +0800, Kirti Wankhede wrote:
> > > >>>>
> > > >>>>
> > > >>>> On 12/17/2019 3:21 PM, Yan Zhao wrote:
> > > >>>>> On Tue, Dec 17, 2019 at 05:24:14PM +0800, Kirti Wankhede wrote:
> > > >>>>>>>>     
> > > >>>>>>>>     		return copy_to_user((void __user *)arg, &unmap, minsz) ?
> > > >>>>>>>>     			-EFAULT : 0;
> > > >>>>>>>> +	} else if (cmd == VFIO_IOMMU_DIRTY_PAGES) {
> > > >>>>>>>> +		struct vfio_iommu_type1_dirty_bitmap range;
> > > >>>>>>>> +		uint32_t mask = VFIO_IOMMU_DIRTY_PAGES_FLAG_START |
> > > >>>>>>>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP |
> > > >>>>>>>> +				VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP;
> > > >>>>>>>> +		int ret;
> > > >>>>>>>> +
> > > >>>>>>>> +		if (!iommu->v2)
> > > >>>>>>>> +			return -EACCES;
> > > >>>>>>>> +
> > > >>>>>>>> +		minsz = offsetofend(struct vfio_iommu_type1_dirty_bitmap,
> > > >>>>>>>> +				    bitmap);
> > > >>>>>>>> +
> > > >>>>>>>> +		if (copy_from_user(&range, (void __user *)arg, minsz))
> > > >>>>>>>> +			return -EFAULT;
> > > >>>>>>>> +
> > > >>>>>>>> +		if (range.argsz < minsz || range.flags & ~mask)
> > > >>>>>>>> +			return -EINVAL;
> > > >>>>>>>> +
> > > >>>>>>>> +		if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_START) {
> > > >>>>>>>> +			iommu->dirty_page_tracking = true;
> > > >>>>>>>> +			return 0;
> > > >>>>>>>> +		} else if (range.flags & VFIO_IOMMU_DIRTY_PAGES_FLAG_STOP) {
> > > >>>>>>>> +			iommu->dirty_page_tracking = false;
> > > >>>>>>>> +
> > > >>>>>>>> +			mutex_lock(&iommu->lock);
> > > >>>>>>>> +			vfio_remove_unpinned_from_dma_list(iommu);
> > > >>>>>>>> +			mutex_unlock(&iommu->lock);
> > > >>>>>>>> +			return 0;
> > > >>>>>>>> +
> > > >>>>>>>> +		} else if (range.flags &
> > > >>>>>>>> +				 VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP) {
> > > >>>>>>>> +			uint64_t iommu_pgmask;
> > > >>>>>>>> +			unsigned long pgshift = __ffs(range.pgsize);
> > > >>>>>>>> +			unsigned long *bitmap;
> > > >>>>>>>> +			long bsize;
> > > >>>>>>>> +
> > > >>>>>>>> +			iommu_pgmask =
> > > >>>>>>>> +			 ((uint64_t)1 << __ffs(vfio_pgsize_bitmap(iommu))) - 1;
> > > >>>>>>>> +
> > > >>>>>>>> +			if (((range.pgsize - 1) & iommu_pgmask) !=
> > > >>>>>>>> +			    (range.pgsize - 1))
> > > >>>>>>>> +				return -EINVAL;
> > > >>>>>>>> +
> > > >>>>>>>> +			if (range.iova & iommu_pgmask)
> > > >>>>>>>> +				return -EINVAL;
> > > >>>>>>>> +			if (!range.size || range.size > SIZE_MAX)
> > > >>>>>>>> +				return -EINVAL;
> > > >>>>>>>> +			if (range.iova + range.size < range.iova)
> > > >>>>>>>> +				return -EINVAL;
> > > >>>>>>>> +
> > > >>>>>>>> +			bsize = verify_bitmap_size(range.size >> pgshift,
> > > >>>>>>>> +						   range.bitmap_size);
> > > >>>>>>>> +			if (bsize)
> > > >>>>>>>> +				return ret;
> > > >>>>>>>> +
> > > >>>>>>>> +			bitmap = kmalloc(bsize, GFP_KERNEL);
> > > >>>>>>>> +			if (!bitmap)
> > > >>>>>>>> +				return -ENOMEM;
> > > >>>>>>>> +
> > > >>>>>>>> +			ret = copy_from_user(bitmap,
> > > >>>>>>>> +			     (void __user *)range.bitmap, bsize) ? -EFAULT : 0;
> > > >>>>>>>> +			if (ret)
> > > >>>>>>>> +				goto bitmap_exit;
> > > >>>>>>>> +
> > > >>>>>>>> +			iommu->dirty_page_tracking = false;
> > > >>>>>>> why iommu->dirty_page_tracking is false here?
> > > >>>>>>> suppose this ioctl can be called several times.
> > > >>>>>>>
> > > >>>>>>
> > > >>>>>> This ioctl can be called several times, but once this ioctl is called
> > > >>>>>> that means vCPUs are stopped and VFIO devices are stopped (i.e. in
> > > >>>>>> stop-and-copy phase) and dirty pages bitmap are being queried by user.
> > > >>>>>>
> > > >>>>> can't agree that VFIO_IOMMU_DIRTY_PAGES_FLAG_GET_BITMAP can only be
> > > >>>>> called in stop-and-copy phase.
> > > >>>>> As stated in last version, this will cause QEMU to get a wrong expectation
> > > >>>>> of VM downtime and this is also the reason for previously pinned pages
> > > >>>>> before log_sync cannot be treated as dirty. If this get bitmap ioctl can
> > > >>>>> be called early in save_setup phase, then it's no problem even all ram
> > > >>>>> is dirty.
> > > >>>>>
> > > >>>>
> > > >>>> Device can also write to pages which are pinned, and then there is no
> > > >>>> way to know pages dirtied by device during pre-copy phase.
> > > >>>> If user ask dirty bitmap in per-copy phase, even then user will have to
> > > >>>> query dirty bitmap in stop-and-copy phase where this will be superset
> > > >>>> including all pages reported during pre-copy. Then instead of copying
> > > >>>> all pages twice, its better to do it once during stop-and-copy phase.
> > > >>>>
> > > >>> I think the flow should be like this:
> > > >>> 1. save_setup --> GET_BITMAP ioctl --> return bitmap for currently + previously
> > > >>> pinned pages and clean all previously pinned pages
> > > >>>
> > > >>> 2. save_pending --> GET_BITMAP ioctl  --> return bitmap of (currently
> > > >>> pinned pages + previously pinned pages since last clean) and clean all
> > > >>> previously pinned pages
> > > >>>
> > > >>> 3. save_complete_precopy --> GET_BITMAP ioctl --> return bitmap of (currently
> > > >>> pinned pages + previously pinned pages since last clean) and clean all
> > > >>> previously pinned pages
> > > >>>
> > > >>>
> > > >>> Copying pinned pages multiple times is unavoidable because those pinned pages
> > > >>> are always treated as dirty. That's per vendor's implementation.
> > > >>> But if the pinned pages are not reported as dirty before stop-and-copy phase,
> > > >>> QEMU would think dirty pages has converged
> > > >>> and enter blackout phase, making downtime_limit severely incorrect.
> > > >>
> > > >> I'm not sure it's any worse.
> > > >> I *think* we do a last sync after we've decided to go to stop-and-copy;
> > > >> wont that then mark all those pages as dirty again, so it'll have the
> > > >> same behaviour?
> > > > No. something will be different.
> > > > currently, in kirti's implementation, if GET_BITMAP ioctl is called only
> > > > once in stop-and-copy phase, then before that phase, QEMU does not know those
> > > > pages are dirty.
> > > > If we can report those dirty pages earlier before stop-and-copy phase,
> > > > QEMU can at least copy other pages to reduce dirty pages to below threshold.
> > > > 
> > > > Take a example, let's assume those vfio dirty pages is 1Gb, and network speed is
> > > > also 1Gb. Expected vm downtime is 1s.
> > > > If before stop-and-copy phase, dirty pages produced by other pages is
> > > > also 1Gb. To meet the expected vm downtime, QEMU should copy pages to
> > > > let dirty pages be less than 1Gb, otherwise, it should not complete live
> > > > migration.
> > > > If vfio does not report this 1Gb dirty pages, QEMU would think there's
> > > > only 1Gb and stop the vm. It would then find out there's actually 2Gb and vm
> > > > downtime is 2s.
> > > > Though the expected vm downtime is always not exactly the same as the
> > > > true vm downtime, it should be caused by rapid dirty page rate, which is
> > > > not predictable.
> > > > Right?
> > > > 
> > > 
> > > If you report vfio dirty pages 1Gb before stop-and-copy phase (i.e. in 
> > > pre-copy phase), enter into stop-and-copy phase, how will you know which 
> > > and how many pages are dirtied by device from the time when pages copied 
> > > in pre-copy phase to that time where device is stopped? You don't have a 
> > > way to know which pages are dirtied by device. So ideally device can 
> > > write to all pages which are pinned. Then we have to mark all those 
> > > pinned pages dirty in stop-and-copy phase, 1Gb, and copy to destination. 
> > > Now you had copied same pages twice. Shouldn't we try not to copy pages 
> > > twice?
> > >
> > For mdevs who reply on treating all pinned pages as dirty pages, as above
> > mentioned condition, repeated page copying can be avoided by
> > (1) adding an ioctl to get size of dirty pages and report it to QEMU through
> > vfio_save_pending() interface
> > (2) in this GET_BITMAP ioctl, empty bitmap is returned until stop-and-copy phase.
> > 
> > But for devices who know fine-grained dirty pages, (e.g. devices have ditry page
> > tracking in hardware), GET_BITMAP ioctl has to return incremental dirty
> > bitmaps in each iteration and step (1) should return 0 to avoid 2*size
> > of dirty page reported.
> 
> I think you're right that something is needed; but it's starting to get
> a bit complex.
> 
> As well as the size, you need the addresses to know which areas to avoid
> - it's not just a simple size, because I think you only care about areas
> that the guest has registered/pinned to the device; so it would have to
> be a list somehow.  So then if you got that list you'd add the size
> to the amount you knew was pending, and avoid sending that area until
> stop-and-copy.
> 
> However, if it is only areas that the guest has registered, then what
> happens if the guest (de)registers an area during the migration process?
> That says the list itself has to be refreshed.  So it's getting messy.
> 
> Dave
>

hi Dave,
I think this GET_BITMAP interface is only for system memory (not device
internal memory) and Kirti has already maintained a vpfn list to record
dirty pages list. It's constantly refreshed during migration.
a. for devices who do not know fine-grained dirty pages,
they can report dirty page size (in vfio module) and not report dirty bitmap
to qemu ram module until stop-and-copy phase.
As it does not report dirty bitmaps, dirty status of unpinned pages during
migration will not be cleared.
b. for devices who know fine-grained dirty pages,
it can report dirty page size (to qemu ram module, not through vfio module)
by reporting dirty bitmap to qemu ram module.
dirty status of unpinned pages during migraion is cleared after each iteration.

The key is to differentiate whether a device has the ability to track fine-grained
dirty pages.
Though more complex than current implementation, it's right. Agree? :)

Thanks
Yan

> > 
> --
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
