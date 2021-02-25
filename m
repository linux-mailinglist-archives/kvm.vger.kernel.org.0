Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681A432599B
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 23:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232008AbhBYWXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 17:23:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34127 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233481AbhBYWWu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Feb 2021 17:22:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614291682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ccfUoSqyqBopC60NplQ5jqhwhcyBVDA6jI4bJ7yvEPI=;
        b=K1wn7uYhfeDVpj2H2EgxNS+gbYYHrHBzxy/rc9hUmpb2RtERlOjQ9n6E25UdgPZg88OEfy
        L7RSKwK5bBgvy9rS3xQoDvNPsvi4sAse2UvQtQkf1FBdpOzSApL+evCeanZBBAi+IuOHlY
        BabP6E6upi67kIH6ZAov582+bwmuExw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-IkYSw3fGPv2SryrOnyVQmQ-1; Thu, 25 Feb 2021 17:21:18 -0500
X-MC-Unique: IkYSw3fGPv2SryrOnyVQmQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BAB8107ACE3;
        Thu, 25 Feb 2021 22:21:17 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 414886090F;
        Thu, 25 Feb 2021 22:21:14 +0000 (UTC)
Date:   Thu, 25 Feb 2021 15:21:13 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 05/10] vfio: Create a vfio_device from vma lookup
Message-ID: <20210225152113.3e083b4a@omen.home.shazbot.org>
In-Reply-To: <20210225000610.GP4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
        <161401268537.16443.2329805617992345365.stgit@gimli.home>
        <20210222172913.GP4247@nvidia.com>
        <20210224145506.48f6e0b4@omen.home.shazbot.org>
        <20210225000610.GP4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Feb 2021 20:06:10 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Feb 24, 2021 at 02:55:06PM -0700, Alex Williamson wrote:
> 
> > > The only use of the special ops would be if there are multiple types
> > > of mmap's going on, but for this narrow use case those would be safely
> > > distinguished by the vm_pgoff instead  
> > 
> > We potentially do have device specific regions which can support mmap,
> > for example the migration region.  We'll need to think about how we
> > could even know if portions of those regions map to a device.  We could
> > use the notifier to announce it and require the code supporting those
> > device specific regions manage it.  
> 
> So, the above basically says any VFIO VMA is allowed for VFIO to map
> to the IOMMU.
> 
> If there are places creating mmaps for VFIO that should not go to the
> IOMMU then they need to return NULL from this function.
> 
> > I'm not really clear what you're getting at with vm_pgoff though, could
> > you explain further?  
> 
> Ah, so I have to take a side discussion to explain what I ment.
> 
> The vm_pgoff is a bit confused because we change it here in vfio_pci:
> 
>     vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
> 
> But the address_space invalidation assumes it still has the region
> based encoding:
> 
> +	vfio_device_unmap_mapping_range(vdev->device,
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
> +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX));
> 
> Those three indexes are in the vm_pgoff numberspace and so vm_pgoff
> must always be set to the same thing - either the
> VFIO_PCI_INDEX_TO_OFFSET() coding or the physical pfn. 

Aha, I hadn't made that connection.

> Since you say we need a limited invalidation this looks like a bug to
> me - and it must always be the VFIO_PCI_INDEX_TO_OFFSET coding.

Yes, this must have only worked in testing because I mmap'd BAR0 which
is at index/offset zero, so the pfn range overlapped the user offset.
I'm glad you caught that...

> So, the PCI vma needs to get switched to use the
> VFIO_PCI_INDEX_TO_OFFSET coding and then we can always extract the
> region number from the vm_pgoff and thus access any additional data,
> such as the base pfn or a flag saying this cannot be mapped to the
> IOMMU. Do the reverse of VFIO_PCI_INDEX_TO_OFFSET and consult
> information attached to that region ID.
> 
> All places creating vfio mmaps have to set the vm_pgoff to
> VFIO_PCI_INDEX_TO_OFFSET().

This is where it gets tricky.  The vm_pgoff we get from
file_operations.mmap is already essentially describing an offset from
the base of a specific resource.  We could convert that from an absolute
offset to a pfn offset, but it's only the bus driver code (ex.
vfio-pci) that knows how to get the base, assuming there is a single
base per region (we can't assume enough bits per region to store
absolute pfn).  Also note that you're suggesting that all vfio mmaps
would need to standardize on the vfio-pci implementation of region
layouts.  Not that most drivers haven't copied vfio-pci, but we've
specifically avoided exposing it as a fixed uAPI such that we could have
the flexibility for a bus driver to implement regions offsets however
they need.

So I'm not really sure what this looks like.  Within vfio-pci we could
keep the index bits in place to allow unmmap_mapping_range() to
selectively zap matching vm_pgoffs but expanding that to a vfio
standard such that the IOMMU backend can also extract a pfn looks very
limiting, or ugly.  Thanks,

Alex

> But we have these violations that need fixing:
> 
> drivers/vfio/fsl-mc/vfio_fsl_mc.c:      vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
> drivers/vfio/platform/vfio_platform_common.c:   vma->vm_pgoff = (region.addr >> PAGE_SHIFT) + pgoff;
> 
> Couldn't see any purpose to this code, cargo cult copy? Just delete
> it.
> 
> drivers/vfio/pci/vfio_pci.c:    vma->vm_pgoff = (pci_resource_start(pdev, index) >> PAGE_SHIFT) + pgoff;
> 
> Used to implement fault() but we could get the region number and
> extract the pfn from the vfio_pci_device's data easy enough.
> 
> I manually checked that other parts of VFIO not under drivers/vfio are
> doing it OK, looks fine.
> 
> Jason
> 

