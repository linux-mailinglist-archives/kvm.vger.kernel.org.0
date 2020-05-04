Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374A21C3CD6
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 16:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbgEDOVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 10:21:05 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52844 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729118AbgEDOVD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 10:21:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588602062;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kEhPnil3Au9ljZyWx7OUd3eWbeEZNvjibden46SQ+d8=;
        b=ScLmwShLfKCvGiiAr5GitGXpOzl4cSVlZls65pwPdNBbcjMnIMCrthgyUqzeNkDXsFFUM8
        xDfH56K7fs+nDABS/SQJnKITGF30JWqFEFZfmuAGeoxtGHN1hN0qmu6D0dDhIAfS+dLe8g
        pfuY9/n8xbBa2/5gUZHTlKz8ZxOGtk4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-d5U_WhvSPbmwh6DTLH-6NA-1; Mon, 04 May 2020 10:21:00 -0400
X-MC-Unique: d5U_WhvSPbmwh6DTLH-6NA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0A1518FE861;
        Mon,  4 May 2020 14:20:58 +0000 (UTC)
Received: from x1.home (ovpn-113-95.phx2.redhat.com [10.3.113.95])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB11958;
        Mon,  4 May 2020 14:20:55 +0000 (UTC)
Date:   Mon, 4 May 2020 08:20:55 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        cohuck@redhat.com, peterx@redhat.com
Subject: Re: [PATCH 2/3] vfio-pci: Fault mmaps to enable vma tracking
Message-ID: <20200504082055.0faeef8b@x1.home>
In-Reply-To: <20200501232550.GP26002@ziepe.ca>
References: <158836742096.8433.685478071796941103.stgit@gimli.home>
        <158836915917.8433.8017639758883869710.stgit@gimli.home>
        <20200501232550.GP26002@ziepe.ca>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 1 May 2020 20:25:50 -0300
Jason Gunthorpe <jgg@ziepe.ca> wrote:

> On Fri, May 01, 2020 at 03:39:19PM -0600, Alex Williamson wrote:
> > Rather than calling remap_pfn_range() when a region is mmap'd, setup
> > a vm_ops handler to support dynamic faulting of the range on access.
> > This allows us to manage a list of vmas actively mapping the area that
> > we can later use to invalidate those mappings.  The open callback
> > invalidates the vma range so that all tracking is inserted in the
> > fault handler and removed in the close handler.
> > 
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/vfio/pci/vfio_pci.c         |   76 ++++++++++++++++++++++++++++++++++-
> >  drivers/vfio/pci/vfio_pci_private.h |    7 +++
> >  2 files changed, 81 insertions(+), 2 deletions(-)  
> 
> > +static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
> > +{
> > +	struct vm_area_struct *vma = vmf->vma;
> > +	struct vfio_pci_device *vdev = vma->vm_private_data;
> > +
> > +	if (vfio_pci_add_vma(vdev, vma))
> > +		return VM_FAULT_OOM;
> > +
> > +	if (remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> > +			    vma->vm_end - vma->vm_start, vma->vm_page_prot))
> > +		return VM_FAULT_SIGBUS;
> > +
> > +	return VM_FAULT_NOPAGE;
> > +}
> > +
> > +static const struct vm_operations_struct vfio_pci_mmap_ops = {
> > +	.open = vfio_pci_mmap_open,
> > +	.close = vfio_pci_mmap_close,
> > +	.fault = vfio_pci_mmap_fault,
> > +};
> > +
> >  static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
> >  {
> >  	struct vfio_pci_device *vdev = device_data;
> > @@ -1357,8 +1421,14 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
> >  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> >  	vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
> >  
> > -	return remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> > -			       req_len, vma->vm_page_prot);
> > +	/*
> > +	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
> > +	 * change vm_flags within the fault handler.  Set them now.
> > +	 */
> > +	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
> > +	vma->vm_ops = &vfio_pci_mmap_ops;  
> 
> Perhaps do the vfio_pci_add_vma & remap_pfn_range combo here if the
> BAR is activated ? That way a fully populated BAR is presented in the
> common case and avoids taking a fault path?
> 
> But it does seem OK as is

Thanks for reviewing.  There's also an argument that we defer
remap_pfn_range() until the device is actually touched, which might
reduce the startup latency.  It's also a bit inconsistent with the
vm_ops.open() path where I can't return error, so I can't call
vfio_pci_add_vma(), I can only zap the vma so that the fault handler
can return an error if necessary.  Therefore it felt more consistent,
with potential startup latency improvements, to defer all mappings to
the fault handler.  If there's a good reason to do otherwise, I can
make the change, but I doubt I'd have encountered the dma mapping of an
unfaulted vma issue had I done it this way, so maybe there's a test
coverage argument as well.  Thanks,

Alex

