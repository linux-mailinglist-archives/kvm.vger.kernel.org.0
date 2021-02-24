Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC3EB32460C
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 23:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbhBXWBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 17:01:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34894 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233002AbhBXWBo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 17:01:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614204016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6lRQ8B1lOEgqC+efJdYDMJddI/iSKH9Jht7GW4/kcEY=;
        b=BKrVS0DVmu0joiCx+q7p8lkk2jYQ4EMMfHf7L7p919P7oHZ0ueACj/2bUXgLMLpaa1YCQo
        ax2Eb97LW3Qv4cKmHSgwuj3QlBWXGsA+/5ADZj495D99myX9hOdnM2e3RUMh0m3peM8gib
        t44V9DqwRig9f7csY9ol3xmMC3RYh2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-FIOlqrjeMEe-HaUHnOg2oQ-1; Wed, 24 Feb 2021 17:00:14 -0500
X-MC-Unique: FIOlqrjeMEe-HaUHnOg2oQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00F991E565;
        Wed, 24 Feb 2021 22:00:13 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 978F85C230;
        Wed, 24 Feb 2021 22:00:12 +0000 (UTC)
Date:   Wed, 24 Feb 2021 14:55:08 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 10/10] vfio/type1: Register device notifier
Message-ID: <20210224145508.1f0edb06@omen.home.shazbot.org>
In-Reply-To: <20210222175523.GQ4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
        <161401275279.16443.6350471385325897377.stgit@gimli.home>
        <20210222175523.GQ4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Feb 2021 13:55:23 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 22, 2021 at 09:52:32AM -0700, Alex Williamson wrote:
> > Introduce a new default strict MMIO mapping mode where the vma for
> > a VM_PFNMAP mapping must be backed by a vfio device.  This allows
> > holding a reference to the device and registering a notifier for the
> > device, which additionally keeps the device in an IOMMU context for
> > the extent of the DMA mapping.  On notification of device release,
> > automatically drop the DMA mappings for it.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >  drivers/vfio/vfio_iommu_type1.c |  124 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 123 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index b34ee4b96a4a..2a16257bd5b6 100644
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -61,6 +61,11 @@ module_param_named(dma_entry_limit, dma_entry_limit, uint, 0644);
> >  MODULE_PARM_DESC(dma_entry_limit,
> >  		 "Maximum number of user DMA mappings per container (65535).");
> >  
> > +static bool strict_mmio_maps = true;
> > +module_param_named(strict_mmio_maps, strict_mmio_maps, bool, 0644);
> > +MODULE_PARM_DESC(strict_mmio_maps,
> > +		 "Restrict to safe DMA mappings of device memory (true).");  
> 
> I think this should be a kconfig, historically we've required kconfig
> to opt-in to unsafe things that could violate kernel security. Someone
> building a secure boot trusted kernel system should not have an
> options for userspace to just turn off protections.

It could certainly be further protected that this option might not
exist based on a Kconfig, but I think we're already risking breaking
some existing users and I'd rather allow it with an opt-in (like we
already do for lack of interrupt isolation), possibly even with a
kernel taint if used, if necessary.

> > +/* Req separate object for async removal from notifier vs dropping vfio_dma */
> > +struct pfnmap_obj {
> > +	struct notifier_block	nb;
> > +	struct work_struct	work;
> > +	struct vfio_iommu	*iommu;
> > +	struct vfio_device	*device;
> > +};  
> 
> So this is basically the dmabuf, I think it would be simple enough to
> go in here and change it down the road if someone had interest.
> 
> > +static void unregister_device_bg(struct work_struct *work)
> > +{
> > +	struct pfnmap_obj *pfnmap = container_of(work, struct pfnmap_obj, work);
> > +
> > +	vfio_device_unregister_notifier(pfnmap->device, &pfnmap->nb);
> > +	vfio_device_put(pfnmap->device);  
> 
> The device_put keeps the device from becoming unregistered, but what
> happens during the hot reset case? Is this what the cover letter
> was talking about? CPU access is revoked but P2P is still possible?

Yes, this only addresses cutting off DMA mappings to a released device
where we can safely drop the DMA mapping entirely.  I think we can
consider complete removal of the mapping object safe in this case
because the user has no ongoing access to the device and after
re-opening the device it would be reasonable to expect mappings would
need to be re-established.

Doing the same around disabling device memory or a reset has a much
greater potential to break userspace.  In some of these cases QEMU will
do the right thing, but reset with dependent devices gets into
scenarios that I can't be sure about.  Other userspace drivers also
exist and I can't verify them all.  So ideally we'd want to temporarily
remove the IOMMU mapping, leaving the mapping object, and restoring it
on the other side.  But I don't think we have a way to do that in the
IOMMU API currently, other than unmap and later remap.  So we might
need to support a zombie mode for the mapping object or enhance the
IOMMU API where we could leave the iotlb entry in place but drop r+w
permissions.

At this point we're also just trying to define which error we get,
perhaps an unsupported request if we do nothing or an IOMMU fault if we
invalidate or suspend the mapping.  It's not guaranteed that one of
these has better behavior on the system than the other.
 
> > +static int vfio_device_nb_cb(struct notifier_block *nb,
> > +			     unsigned long action, void *unused)
> > +{
> > +	struct pfnmap_obj *pfnmap = container_of(nb, struct pfnmap_obj, nb);
> > +
> > +	switch (action) {
> > +	case VFIO_DEVICE_RELEASE:
> > +	{
> > +		struct vfio_dma *dma, *dma_last = NULL;
> > +		int retries = 0;
> > +again:
> > +		mutex_lock(&pfnmap->iommu->lock);
> > +		dma = pfnmap_find_dma(pfnmap);  
> 
> Feels a bit strange that the vfio_dma isn't linked to the pfnmap_obj
> instead of searching the entire list?

It does, I've been paranoid about whether we can trust that the
vfio_dma is still valid in all cases.  I had myself convinced that if
our notifier actions expand we could get another callback before our
workqueue removes the notifier, but that might be more simply handled
by having a vfio_dma pointer that gets cleared once we remove the
vfio_dma.  I'll take another look.


> > @@ -549,8 +625,48 @@ static int vaddr_get_pfn(struct vfio_iommu *iommu, struct vfio_dma *dma,
> >  		if (ret == -EAGAIN)
> >  			goto retry;  
> 
> I'd prefer this was written a bit differently, I would like it very
> much if this doesn't mis-use follow_pte() by returning pfn outside
> the lock.
> 
> vaddr_get_bar_pfn(..)
> {
>         vma = find_vma_intersection(mm, vaddr, vaddr + 1);
> 	if (!vma)
>            return -ENOENT;
>         if ((vma->vm_flags & VM_DENYWRITE) && (prot & PROT_WRITE)) // Check me
>            return -EFAULT;
>         device = vfio_device_get_from_vma(vma);
> 	if (!device)
>            return -ENOENT;
> 
> 	/*
>          * Now do the same as vfio_pci_mmap_fault() - the vm_pgoff must
> 	 * be the physical pfn when using this mechanism. Delete follow_pte entirely()
>          */
>         pfn = (vaddr - vma->vm_start)/PAGE_SIZE + vma->vm_pgoff
> 	
>         /* de-dup device and record that we are using device's pages in the
> 	   pfnmap */
>         ...
> }


This seems to undo both:

5cbf3264bc71 ("vfio/type1: Fix VA->PA translation for PFNMAP VMAs in vaddr_get_pfn()")

(which also suggests we are going to break users without the module
option opt-in above)

And:

41311242221e ("vfio/type1: Support faulting PFNMAP vmas")

So we'd have an alternate path in the un-safe mode and we'd lose the
ability to fault in mappings.

> This would be significantly better if it could do whole ranges instead
> of page at a time.

There are some patches I just put in from Daniel Jordan that use
batching.  Thanks,

Alex

