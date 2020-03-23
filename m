Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB9D18FCEB
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 19:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgCWSpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 14:45:03 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:53549 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727011AbgCWSpC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Mar 2020 14:45:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584989101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZvQkV5UjY9qG2FnyoFGOJmOVyJoHiDG8SUlErJt60zs=;
        b=WdC68EuwKv007fZXnIHt88/RMpRTM5QfgjRzPfL0J/HErmbOL4TsCdf8NWjL0E4vFY5EE/
        722WDfso1VwGYkJxX9dWuuEs+vJwFxJZUszN0zJwBllw++nZZeBbikLUhRkclnZQ2jc265
        oBdXLHgZl7osS1+i6FMx6IzbCgeSqPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-wU-3YBu-OSqOPU_ZrJhw5g-1; Mon, 23 Mar 2020 14:44:53 -0400
X-MC-Unique: wU-3YBu-OSqOPU_ZrJhw5g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E74EB1922961;
        Mon, 23 Mar 2020 18:44:50 +0000 (UTC)
Received: from w520.home (ovpn-112-162.phx2.redhat.com [10.3.112.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2640C7E323;
        Mon, 23 Mar 2020 18:44:49 +0000 (UTC)
Date:   Mon, 23 Mar 2020 12:44:48 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v15 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Message-ID: <20200323124448.2d3bc315@w520.home>
In-Reply-To: <7062f72a-bf06-a8cd-89f0-9e729699a454@nvidia.com>
References: <1584649004-8285-1-git-send-email-kwankhede@nvidia.com>
        <1584649004-8285-5-git-send-email-kwankhede@nvidia.com>
        <20200319165704.1f4eb36a@w520.home>
        <bc48ae5c-67f9-d95e-5d60-6c42359bb790@nvidia.com>
        <20200320120137.6acd89ee@x1.home>
        <cf0ee134-c1c7-f60c-afc2-8948268d8880@nvidia.com>
        <20200320125910.028d7af5@w520.home>
        <7062f72a-bf06-a8cd-89f0-9e729699a454@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Mar 2020 23:24:37 +0530
Kirti Wankhede <kwankhede@nvidia.com> wrote:

> On 3/21/2020 12:29 AM, Alex Williamson wrote:
> > On Sat, 21 Mar 2020 00:12:04 +0530
> > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >   
> >> On 3/20/2020 11:31 PM, Alex Williamson wrote:  
> >>> On Fri, 20 Mar 2020 23:19:14 +0530
> >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>      
> >>>> On 3/20/2020 4:27 AM, Alex Williamson wrote:  
> >>>>> On Fri, 20 Mar 2020 01:46:41 +0530
> >>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> >>>>>         
> >>
> >> <snip>
> >>  
> >>>>>> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> >>>>>> +				  size_t size, uint64_t pgsize,
> >>>>>> +				  u64 __user *bitmap)
> >>>>>> +{
> >>>>>> +	struct vfio_dma *dma;
> >>>>>> +	unsigned long pgshift = __ffs(pgsize);
> >>>>>> +	unsigned int npages, bitmap_size;
> >>>>>> +
> >>>>>> +	dma = vfio_find_dma(iommu, iova, 1);
> >>>>>> +
> >>>>>> +	if (!dma)
> >>>>>> +		return -EINVAL;
> >>>>>> +
> >>>>>> +	if (dma->iova != iova || dma->size != size)
> >>>>>> +		return -EINVAL;
> >>>>>> +
> >>>>>> +	npages = dma->size >> pgshift;
> >>>>>> +	bitmap_size = DIRTY_BITMAP_BYTES(npages);
> >>>>>> +
> >>>>>> +	/* mark all pages dirty if all pages are pinned and mapped. */
> >>>>>> +	if (dma->iommu_mapped)
> >>>>>> +		bitmap_set(dma->bitmap, 0, npages);
> >>>>>> +
> >>>>>> +	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
> >>>>>> +		return -EFAULT;  
> >>>>>
> >>>>> We still need to reset the bitmap here, clearing and re-adding the
> >>>>> pages that are still pinned.
> >>>>>
> >>>>> https://lore.kernel.org/kvm/20200319070635.2ff5db56@x1.home/
> >>>>>         
> >>>>
> >>>> I thought you agreed on my reply to it
> >>>> https://lore.kernel.org/kvm/31621b70-02a9-2ea5-045f-f72b671fe703@nvidia.com/
> >>>>     
> >>>>    > Why re-populate when there will be no change since
> >>>>    > vfio_iova_dirty_bitmap() is called holding iommu->lock? If there is any
> >>>>    > pin request while vfio_iova_dirty_bitmap() is still working, it will
> >>>>    > wait till iommu->lock is released. Bitmap will be populated when page is
> >>>>    > pinned.  
> >>>
> >>> As coded, dirty bits are only ever set in the bitmap, never cleared.
> >>> If a page is unpinned between iterations of the user recording the
> >>> dirty bitmap, it should be marked dirty in the iteration immediately
> >>> after the unpinning and not marked dirty in the following iteration.
> >>> That doesn't happen here.  We're reporting cumulative dirty pages since
> >>> logging was enabled, we need to be reporting dirty pages since the user
> >>> last retrieved the dirty bitmap.  The bitmap should be cleared and
> >>> currently pinned pages re-added after copying to the user.  Thanks,
> >>>      
> >>
> >> Does that mean, we have to track every iteration? do we really need that
> >> tracking?
> >>
> >> Generally the flow is:
> >> - vendor driver pin x pages
> >> - Enter pre-copy-phase where vCPUs are running - user starts dirty pages
> >> tracking, then user asks dirty bitmap, x pages reported dirty by
> >> VFIO_IOMMU_DIRTY_PAGES ioctl with _GET flag
> >> - In pre-copy phase, vendor driver pins y more pages, now bitmap
> >> consists of x+y bits set
> >> - In pre-copy phase, vendor driver unpins z pages, but bitmap is not
> >> updated, so again bitmap consists of x+y bits set.
> >> - Enter in stop-and-copy phase, vCPUs are stopped, mdev devices are stopped
> >> - user asks dirty bitmap - Since here vCPU and mdev devices are stopped,
> >> pages should not get dirty by guest driver or the physical device.
> >> Hence, x+y dirty pages would be reported.
> >>
> >> I don't think we need to track every iteration of bitmap reporting.  
> > 
> > Yes, once a bitmap is read, it's reset.  In your example, after
> > unpinning z pages the user should still see a bitmap with x+y pages,
> > but once they've read that bitmap, the next bitmap should be x+y-z.
> > Userspace can make decisions about when to switch from pre-copy to
> > stop-and-copy based on convergence, ie. the slope of the line recording
> > dirty pages per iteration.  The implementation here never allows an
> > inflection point, dirty pages reported through vfio would always either
> > be flat or climbing.  There might also be a case that an iommu backed
> > device could start pinning pages during the course of a migration, how
> > would the bitmap ever revert from fully populated to only tracking the
> > pinned pages?  Thanks,
> >   
> 
> At KVM forum we discussed this - if guest driver pins say 1024 pages 
> before migration starts, during pre-copy phase device can dirty 0 pages 
> in best case and 1024 pages in worst case. In that case, user will 
> transfer content of 1024 pages during pre-copy phase and in 
> stop-and-copy phase also, that will be pages will be copied twice. So we 
> decided to only get dirty pages bitmap at stop-and-copy phase. If user 
> is going to get dirty pages in stop-and-copy phase only, then that will 
> be single iteration.
> There aren't any devices yet that can track sys memory dirty pages. So 
> we can go ahead with this patch and support for dirty pages tracking 
> during pre-copy phase can be added later when there will be consumers of 
> that functionality.

So if I understand this right, you're expecting the dirty bitmap to
accumulate dirty bits, in perpetuity, so that the user can only
retrieve them once at the end of migration?  But if that's the case,
the user could simply choose to not retrieve the bitmap until the end
of migration, the result would be the same.  What we have here is that
dirty bits are never cleared, regardless of whether the user has seen
them, which is wrong.  Sorry, we had a lot of discussions at KVM forum,
I don't recall this specific one 5 months later and maybe we weren't
considering all aspects.  I see the behavior we have here as incorrect,
but it also seems relatively trivial to make correct.  I hope the QEMU
code isn't making us go through all this trouble to report a dirty
bitmap that gets thrown away because it expects the final one to be
cumulative since the beginning of dirty logging.  Thanks,

Alex

