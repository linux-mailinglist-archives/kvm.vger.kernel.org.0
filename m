Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374CB1C3F08
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 17:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbgEDPxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 11:53:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23866 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728873AbgEDPxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 11:53:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588607600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bSWYDQDC7kolljOU3FOH/hFgbKSyHO/eA7z20C/Wf7g=;
        b=J9/ZiS/Mb7Nc8TxyKtxPx0J+Q/saNhyEk+ITaPYE97t33OVXUGjdlkPfHja6GmDg80msyG
        tlnJ21QqLjA66CmgR9ot/8TtPNEK+hYtp1bTZ8+8sbyX+Qo6eztfTqmqCYf91zqPdlAr9f
        N13rTMMOJ4piFqEbt0KLSvSxOFTeQxA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-225-xCKsR0mOPfmMx1ghtVk2vw-1; Mon, 04 May 2020 11:53:18 -0400
X-MC-Unique: xCKsR0mOPfmMx1ghtVk2vw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE42F1895A28;
        Mon,  4 May 2020 15:53:17 +0000 (UTC)
Received: from x1.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 643D06FF1A;
        Mon,  4 May 2020 15:53:14 +0000 (UTC)
Date:   Mon, 4 May 2020 09:53:13 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 2/3] vfio-pci: Fault mmaps to enable vma tracking
Message-ID: <20200504095313.271fbe40@x1.home>
In-Reply-To: <20200504150556.GX26002@ziepe.ca>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
        <158836915917.8433.8017639758883869710.stgit@gimli.home>
        <20200501232550.GP26002@ziepe.ca>
        <20200504082055.0faeef8b@x1.home>
        <20200504150556.GX26002@ziepe.ca>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 4 May 2020 12:05:56 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Mon, May 04, 2020 at 08:20:55AM -0600, Alex Williamson wrote:
> > On Fri, 1 May 2020 20:25:50 -0300
> > Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >   
> > > On Fri, May 01, 2020 at 03:39:19PM -0600, Alex Williamson wrote:  
> > > > Rather than calling remap_pfn_range() when a region is mmap'd, setup
> > > > a vm_ops handler to support dynamic faulting of the range on access.
> > > > This allows us to manage a list of vmas actively mapping the area that
> > > > we can later use to invalidate those mappings.  The open callback
> > > > invalidates the vma range so that all tracking is inserted in the
> > > > fault handler and removed in the close handler.
> > > > 
> > > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > >  drivers/vfio/pci/vfio_pci.c         |   76 ++++++++++++++++++++++++++++++++++-
> > > >  drivers/vfio/pci/vfio_pci_private.h |    7 +++
> > > >  2 files changed, 81 insertions(+), 2 deletions(-)    
> > >   
> > > > +static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> > > > +{
> > > > +	struct vm_area_struct *vma = vmf->vma;
> > > > +	struct vfio_pci_device *vdev = vma->vm_private_data;
> > > > +
> > > > +	if (vfio_pci_add_vma(vdev, vma))
> > > > +		return VM_FAULT_OOM;
> > > > +
> > > > +	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> > > > +			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
> > > > +		return VM_FAULT_SIGBUS;
> > > > +
> > > > +	return VM_FAULT_NOPAGE;
> > > > +}
> > > > +
> > > > +static const struct vm_operations_struct vfio_pci_mmap_ops = {
> > > > +	.open = vfio_pci_mmap_open,
> > > > +	.close = vfio_pci_mmap_close,
> > > > +	.fault = vfio_pci_mmap_fault,
> > > > +};
> > > > +
> > > >  static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
> > > >  {
> > > >  	struct vfio_pci_device *vdev = device_data;
> > > > @@ -1357,8 +1421,14 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
> > > >  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> > > >  	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
> > > >  
> > > > -	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> > > > -			       req_len, vma->vm_page_prot);
> > > > +	/*
> > > > +	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
> > > > +	 * change vm_flags within the fault handler.  Set them now.
> > > > +	 */
> > > > +	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
> > > > +	vma->vm_ops = &vfio_pci_mmap_ops;    
> > > 
> > > Perhaps do the vfio_pci_add_vma & remap_pfn_range combo here if the
> > > BAR is activated ? That way a fully populated BAR is presented in the
> > > common case and avoids taking a fault path?
> > > 
> > > But it does seem OK as is  
> > 
> > Thanks for reviewing.  There's also an argument that we defer
> > remap_pfn_range() until the device is actually touched, which might
> > reduce the startup latency.  
> 
> But not startup to a functional VM as that will now have to take the
> slower fault path.

We need to take the fault path regardless because a VM will size and
(virtually) map the BARs, toggling the memory enable bit.  As provided
here, we don't trigger the fault unless the user attempts to access the
BAR or we DMA map the BAR.  That defers the fault until the VM is (to
some extent) up and running, and has a better chance for multi-threaded
faulting than does QEMU initialization. 
 
> > It's also a bit inconsistent with the vm_ops.open() path where I
> > can't return error, so I can't call vfio_pci_add_vma(), I can only
> > zap the vma so that the fault handler can return an error if
> > necessary.  
> 
> open could allocate memory so the zap isn't needed. If allocation
> fails then do the zap and take the slow path.

That's a good idea, but it also gives us one more initialization
variation.  I thought it was a rather nice feature that our vma_list
includes only vmas that have actually faulted in the mapping since it
was last zapped.  This is our steady state, so why not get there
immediately rather than putting every mmap or open into the list,
regardless of whether that particular vma ever accesses the mapping?
If we have vmas in our vma_list that have never accessed the mapping,
we're increasing our latency on zap.

> > handler.  If there's a good reason to do otherwise, I can make the
> > change, but I doubt I'd have encountered the dma mapping of an
> > unfaulted vma issue had I done it this way, so maybe there's a test
> > coverage argument as well.  Thanks,  
> 
> This test is best done by having one thread disable the other bar
> while another thread is trying to map it

We can split hairs on the best mechanism to trigger this, but the best
test is the one that actually gets run, and this triggered by simply
starting an assigned device VM.  Thanks,

Alex

