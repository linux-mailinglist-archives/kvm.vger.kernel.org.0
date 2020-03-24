Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10550191ADF
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 21:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgCXUX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 16:23:27 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:25119 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725941AbgCXUX1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Mar 2020 16:23:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585081405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KlUvNpc84ktepiF4oVUXvul2FSDKaqtN01s1HUbhcGY=;
        b=YfGPN7PsybDofPfvUnM85dguJIg3eBr1WOb4fdrA7kZxtZODjzoFqQlWDHUg9Obg+ze355
        q/FUVR4jtOuUgcxrhvcm/ckw5GHb1+b1elEwO49QecnrSuTTOVGxRN+smuqjRRK6zKDn0x
        MH1DAd7nn++wN9TqPgm0SonwSD9Vlrk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-Rgz1BAuIPZ-KDSSogetphQ-1; Tue, 24 Mar 2020 16:23:18 -0400
X-MC-Unique: Rgz1BAuIPZ-KDSSogetphQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 618B08010EC;
        Tue, 24 Mar 2020 20:23:15 +0000 (UTC)
Received: from work-vm (ovpn-114-253.ams2.redhat.com [10.36.114.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0521010027A3;
        Tue, 24 Mar 2020 20:23:07 +0000 (UTC)
Date:   Tue, 24 Mar 2020 20:23:04 +0000
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
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
        "Zhengxiao.zx@alibaba-inc.com" <Zhengxiao.zx@alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v15 Kernel 4/7] vfio iommu: Implementation of ioctl for
 dirty pages tracking.
Message-ID: <20200324202304.GJ2645@work-vm>
References: <20200319165704.1f4eb36a@w520.home>
 <bc48ae5c-67f9-d95e-5d60-6c42359bb790@nvidia.com>
 <20200320120137.6acd89ee@x1.home>
 <cf0ee134-c1c7-f60c-afc2-8948268d8880@nvidia.com>
 <20200320125910.028d7af5@w520.home>
 <7062f72a-bf06-a8cd-89f0-9e729699a454@nvidia.com>
 <20200323124448.2d3bc315@w520.home>
 <20200323185114.GF3017@work-vm>
 <20200324030118.GD5456@joy-OptiPlex-7040>
 <20200324083644.36494641@w520.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324083644.36494641@w520.home>
User-Agent: Mutt/1.13.3 (2020-01-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Alex Williamson (alex.williamson@redhat.com) wrote:
> On Mon, 23 Mar 2020 23:01:18 -0400
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Tue, Mar 24, 2020 at 02:51:14AM +0800, Dr. David Alan Gilbert wrote:
> > > * Alex Williamson (alex.williamson@redhat.com) wrote:  
> > > > On Mon, 23 Mar 2020 23:24:37 +0530
> > > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > >   
> > > > > On 3/21/2020 12:29 AM, Alex Williamson wrote:  
> > > > > > On Sat, 21 Mar 2020 00:12:04 +0530
> > > > > > Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > > > >     
> > > > > >> On 3/20/2020 11:31 PM, Alex Williamson wrote:    
> > > > > >>> On Fri, 20 Mar 2020 23:19:14 +0530
> > > > > >>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > > > >>>        
> > > > > >>>> On 3/20/2020 4:27 AM, Alex Williamson wrote:    
> > > > > >>>>> On Fri, 20 Mar 2020 01:46:41 +0530
> > > > > >>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> > > > > >>>>>           
> > > > > >>
> > > > > >> <snip>
> > > > > >>    
> > > > > >>>>>> +static int vfio_iova_dirty_bitmap(struct vfio_iommu *iommu, dma_addr_t iova,
> > > > > >>>>>> +				  size_t size, uint64_t pgsize,
> > > > > >>>>>> +				  u64 __user *bitmap)
> > > > > >>>>>> +{
> > > > > >>>>>> +	struct vfio_dma *dma;
> > > > > >>>>>> +	unsigned long pgshift = __ffs(pgsize);
> > > > > >>>>>> +	unsigned int npages, bitmap_size;
> > > > > >>>>>> +
> > > > > >>>>>> +	dma = vfio_find_dma(iommu, iova, 1);
> > > > > >>>>>> +
> > > > > >>>>>> +	if (!dma)
> > > > > >>>>>> +		return -EINVAL;
> > > > > >>>>>> +
> > > > > >>>>>> +	if (dma->iova != iova || dma->size != size)
> > > > > >>>>>> +		return -EINVAL;
> > > > > >>>>>> +
> > > > > >>>>>> +	npages = dma->size >> pgshift;
> > > > > >>>>>> +	bitmap_size = DIRTY_BITMAP_BYTES(npages);
> > > > > >>>>>> +
> > > > > >>>>>> +	/* mark all pages dirty if all pages are pinned and mapped. */
> > > > > >>>>>> +	if (dma->iommu_mapped)
> > > > > >>>>>> +		bitmap_set(dma->bitmap, 0, npages);
> > > > > >>>>>> +
> > > > > >>>>>> +	if (copy_to_user((void __user *)bitmap, dma->bitmap, bitmap_size))
> > > > > >>>>>> +		return -EFAULT;    
> > > > > >>>>>
> > > > > >>>>> We still need to reset the bitmap here, clearing and re-adding the
> > > > > >>>>> pages that are still pinned.
> > > > > >>>>>
> > > > > >>>>> https://lore.kernel.org/kvm/20200319070635.2ff5db56@x1.home/
> > > > > >>>>>           
> > > > > >>>>
> > > > > >>>> I thought you agreed on my reply to it
> > > > > >>>> https://lore.kernel.org/kvm/31621b70-02a9-2ea5-045f-f72b671fe703@nvidia.com/
> > > > > >>>>       
> > > > > >>>>    > Why re-populate when there will be no change since
> > > > > >>>>    > vfio_iova_dirty_bitmap() is called holding iommu->lock? If there is any
> > > > > >>>>    > pin request while vfio_iova_dirty_bitmap() is still working, it will
> > > > > >>>>    > wait till iommu->lock is released. Bitmap will be populated when page is
> > > > > >>>>    > pinned.    
> > > > > >>>
> > > > > >>> As coded, dirty bits are only ever set in the bitmap, never cleared.
> > > > > >>> If a page is unpinned between iterations of the user recording the
> > > > > >>> dirty bitmap, it should be marked dirty in the iteration immediately
> > > > > >>> after the unpinning and not marked dirty in the following iteration.
> > > > > >>> That doesn't happen here.  We're reporting cumulative dirty pages since
> > > > > >>> logging was enabled, we need to be reporting dirty pages since the user
> > > > > >>> last retrieved the dirty bitmap.  The bitmap should be cleared and
> > > > > >>> currently pinned pages re-added after copying to the user.  Thanks,
> > > > > >>>        
> > > > > >>
> > > > > >> Does that mean, we have to track every iteration? do we really need that
> > > > > >> tracking?
> > > > > >>
> > > > > >> Generally the flow is:
> > > > > >> - vendor driver pin x pages
> > > > > >> - Enter pre-copy-phase where vCPUs are running - user starts dirty pages
> > > > > >> tracking, then user asks dirty bitmap, x pages reported dirty by
> > > > > >> VFIO_IOMMU_DIRTY_PAGES ioctl with _GET flag
> > > > > >> - In pre-copy phase, vendor driver pins y more pages, now bitmap
> > > > > >> consists of x+y bits set
> > > > > >> - In pre-copy phase, vendor driver unpins z pages, but bitmap is not
> > > > > >> updated, so again bitmap consists of x+y bits set.
> > > > > >> - Enter in stop-and-copy phase, vCPUs are stopped, mdev devices are stopped
> > > > > >> - user asks dirty bitmap - Since here vCPU and mdev devices are stopped,
> > > > > >> pages should not get dirty by guest driver or the physical device.
> > > > > >> Hence, x+y dirty pages would be reported.
> > > > > >>
> > > > > >> I don't think we need to track every iteration of bitmap reporting.    
> > > > > > 
> > > > > > Yes, once a bitmap is read, it's reset.  In your example, after
> > > > > > unpinning z pages the user should still see a bitmap with x+y pages,
> > > > > > but once they've read that bitmap, the next bitmap should be x+y-z.
> > > > > > Userspace can make decisions about when to switch from pre-copy to
> > > > > > stop-and-copy based on convergence, ie. the slope of the line recording
> > > > > > dirty pages per iteration.  The implementation here never allows an
> > > > > > inflection point, dirty pages reported through vfio would always either
> > > > > > be flat or climbing.  There might also be a case that an iommu backed
> > > > > > device could start pinning pages during the course of a migration, how
> > > > > > would the bitmap ever revert from fully populated to only tracking the
> > > > > > pinned pages?  Thanks,
> > > > > >     
> > > > > 
> > > > > At KVM forum we discussed this - if guest driver pins say 1024 pages 
> > > > > before migration starts, during pre-copy phase device can dirty 0 pages 
> > > > > in best case and 1024 pages in worst case. In that case, user will 
> > > > > transfer content of 1024 pages during pre-copy phase and in 
> > > > > stop-and-copy phase also, that will be pages will be copied twice. So we 
> > > > > decided to only get dirty pages bitmap at stop-and-copy phase. If user 
> > > > > is going to get dirty pages in stop-and-copy phase only, then that will 
> > > > > be single iteration.
> > > > > There aren't any devices yet that can track sys memory dirty pages. So 
> > > > > we can go ahead with this patch and support for dirty pages tracking 
> > > > > during pre-copy phase can be added later when there will be consumers of 
> > > > > that functionality.  
> > > > 
> > > > So if I understand this right, you're expecting the dirty bitmap to
> > > > accumulate dirty bits, in perpetuity, so that the user can only
> > > > retrieve them once at the end of migration?  But if that's the case,
> > > > the user could simply choose to not retrieve the bitmap until the end
> > > > of migration, the result would be the same.  What we have here is that
> > > > dirty bits are never cleared, regardless of whether the user has seen
> > > > them, which is wrong.  Sorry, we had a lot of discussions at KVM forum,
> > > > I don't recall this specific one 5 months later and maybe we weren't
> > > > considering all aspects.  I see the behavior we have here as incorrect,
> > > > but it also seems relatively trivial to make correct.  I hope the QEMU
> > > > code isn't making us go through all this trouble to report a dirty
> > > > bitmap that gets thrown away because it expects the final one to be
> > > > cumulative since the beginning of dirty logging.  Thanks,  
> > > 
> > > I remember the discussion that we couldn't track the system memory
> > > dirtying with current hardware; so the question then is just to track  
> > hi Dave
> > there are already devices that are able to track the system memory,
> > through two ways:
> > (1) software method. like VFs for "Intel(R) Ethernet Controller XL710 Family
> > support".
> > (2) hardware method. through hardware internal buffer (as one Intel
> > internal hardware not yet to public, but very soon) or through VTD-3.0
> > IOMMU.
> > 
> > we have already had code verified using the two ways to track system memory
> > in fine-grained level.
> > 
> > 
> > > what has been pinned and then ideally put that memory off until the end.
> > > (Which is interesting because I don't think we currently have  a way
> > > to delay RAM pages till the end in qemu).  
> > 
> > I think the problem here is that we mixed pinned pages with dirty pages.
> 
> We are reporting dirty pages, pinned pages are just assumed to be dirty.
> 
> > yes, pinned pages for mdev devices are continuously likely to be dirty
> > until device stopped.
> > But for devices that are able to report dirty pages, dirtied pages
> > will be marked again if hardware writes them later.
> > 
> > So, is it good to introduce a capability to let vfio/qemu know how to
> > treat the dirty pages?
> 
> Dirty pages are dirty, QEMU doesn't need any special flag, instead we
> need to evolve different mechanisms for the vendor driver so that we
> can differentiate pages pinned for read vs pages pinned for write.
> Perhaps interfaces to pin pages without dirtying them, and a separate
> mechanism to dirty a previously pinned-page, ie. promote it permanently
> or transiently to a writable page.
> 
> > (1) for devices have no fine-grained dirty page tracking capability
> >   a. pinned pages are regarded as dirty pages. they are not cleared by
> >   dirty page query
> >   b. unpinned pages are regarded as dirty pages. they are cleared by
> >   dirty page query or UNMAP ioctl.
> > (2) for devices that have fine-grained dirty page tracking capability
> >    a. pinned/unpinned pages are not regarded as dirty pages
> 
> We need a pin-read-only interface for this.
> 
> >    b. only pages they reported are regarded as dirty pages and are to be
> >    cleared by dirty page query and UNMAP ioctl.
> 
> We need a set-dirty or promote-writable interface for this.
> 
> > (3) for dirty pages marking APIs, like vfio_dma_rw()...
> >    pages marked by them are regared as dirty and are to be cleared by
> >    dirty page query and UNMAP ioctl
> > 
> > For (1), qemu VFIO only reports dirty page amount and would not transfer
> > those pages until last round.
> > for (2) and (3), qemu VFIO should report and transfer them in each
> > round.
> 
> IMO, QEMU should not be aware of any of this.  Userspace has an
> interface to retrieve dirtied pages (period).  We should adjust the
> pages that we report as dirtied to be accurate based on the
> capabilities of the vendor driver.  We can evolve those internal APIs
> between the vendor driver and vfio iommu over time without modifying
> this user interface.

I'm not sure;  if you have a block of memory that's constantly marked
dirty in (1) - we need to avoid constantly retransmitting that memory to
the destination; there's no point in sending it until the end of the
iterations - so it shouldn't even get sent once in the iteration.
But at the same time, we can't ignore the fact that those pages are
going to be dirty - because that influences the downtime; so we need
to know we're going to be getting them later, even if we don't
initially mark them as dirty.

> > > [I still worry whether migration will be usable with any
> > > significant amount of system ram that's pinned in this way; the
> > > downside will very easily get above the threshold that people like]
> > >   
> > yes. that's why we have to do multi-round dirty page query and
> > transfer and clear the dirty bitmaps in each round for devices that are
> > able to track in fine grain.
> > and that's why we have to report the amount of dirty pages before
> > stop-and-copy phase for mdev devices, so that people are able to know
> > the real downtime as much as possible.
> 
> Yes, the dirty bitmap should be accurate to report the pages dirtied
> since it was last retrieved and over time we can add internal
> interfaces to give vendor drivers more granularity in marking pinned
> pages dirty and perhaps even exposing the bitmap to the vendor drivers
> to set pages themselves.  I don't necessarily think it's worthwhile to
> create a new class of dirtied pages to transfer at the end, we're
> fighting a losing battle at that point.  We should be focusing on
> improving the granularity of page dirtying in order to reduce the pages
> transferred at the end of migration.  Thanks,

Dave

> Alex
--
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

