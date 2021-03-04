Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FA532DBE5
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 22:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240030AbhCDVjt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 16:39:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24046 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240020AbhCDVjb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 16:39:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614893885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BO9b8O4TUFxzzCNk8BcCTrE/6CnVHbeBBT/h0w31kNc=;
        b=GBD4btP6CFZ5BoQKjJnLAD8e2khEzUdhugcH8UbLShHYCoV0w5WLxEgFOc9Wj5ALwQMPon
        EC2n9DFNegFl05GjaszAIPSESeEl0aa83QWzq9bED88FFIuRlRb3J06Gt4S8x6Ua7CBPm9
        Jiq8GDs8E3GTRnb2SJoBuJ8OIUmQI0k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-JroqD7OGOHGDCrZMZgOZ6g-1; Thu, 04 Mar 2021 16:38:04 -0500
X-MC-Unique: JroqD7OGOHGDCrZMZgOZ6g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F26D680006E;
        Thu,  4 Mar 2021 21:38:02 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9C0CF18E38;
        Thu,  4 Mar 2021 21:37:58 +0000 (UTC)
Date:   Thu, 4 Mar 2021 14:37:57 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 05/10] vfio: Create a vfio_device from vma lookup
Message-ID: <20210304143757.1ca42cfc@omen.home.shazbot.org>
In-Reply-To: <20210225234949.GV4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
        <161401268537.16443.2329805617992345365.stgit@gimli.home>
        <20210222172913.GP4247@nvidia.com>
        <20210224145506.48f6e0b4@omen.home.shazbot.org>
        <20210225000610.GP4247@nvidia.com>
        <20210225152113.3e083b4a@omen.home.shazbot.org>
        <20210225234949.GV4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Feb 2021 19:49:49 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Feb 25, 2021 at 03:21:13PM -0700, Alex Williamson wrote:
> 
> > This is where it gets tricky.  The vm_pgoff we get from
> > file_operations.mmap is already essentially describing an offset from
> > the base of a specific resource.  We could convert that from an absolute
> > offset to a pfn offset, but it's only the bus driver code (ex.
> > vfio-pci) that knows how to get the base, assuming there is a single
> > base per region (we can't assume enough bits per region to store
> > absolute pfn).  Also note that you're suggesting that all vfio mmaps
> > would need to standardize on the vfio-pci implementation of region
> > layouts.  Not that most drivers haven't copied vfio-pci, but we've
> > specifically avoided exposing it as a fixed uAPI such that we could have
> > the flexibility for a bus driver to implement regions offsets however
> > they need.  
> 
> Okay, well the bus driver owns the address space and the bus driver is
> in control of the vm_pgoff. If it doesn't want to zap then it doesn't
> need to do anything
> 
> vfio-pci can consistently use the index encoding and be fine
>  
> > So I'm not really sure what this looks like.  Within vfio-pci we could
> > keep the index bits in place to allow unmmap_mapping_range() to
> > selectively zap matching vm_pgoffs but expanding that to a vfio
> > standard such that the IOMMU backend can also extract a pfn looks very
> > limiting, or ugly.  Thanks,  
> 
> Lets add a op to convert a vma into a PFN range. The map code will
> pass the vma to the op and get back a pfn (or failure).
> 
> pci will switch the vm_pgoff to an index, find the bar base and
> compute the pfn.
> 
> It is starting to look more and more like dma buf though

How terrible would it be if vfio-core used a shared vm_private_data
structure and inserted itself into the vm_ops call chain to reference
count that structure?  We already wrap the device file descriptor via
vfio_device_fops.mmap, so we could:

	struct vfio_vma_private_data *priv;

	priv = kzalloc(...
	
	priv->device = device;
	vma->vm_private_data = priv;

	device->ops->mmap(device->device_data, vma);

	if (vma->vm_private_data == priv) {
		priv->vm_ops = vma->vm_ops;
		vma->vm_ops = &vfio_vm_ops;
	} else
		kfree(priv);

Where:

struct vfio_vma_private_data {
	struct vfio_device *device;
	unsigned long pfn_base;
	void *private_data; // maybe not needed
	const struct vm_operations_struct *vm_ops;
	struct kref kref;
	unsigned int release_notification:1;
};

Therefore unless a bus driver opts-out by replacing vm_private_data, we
can identify participating vmas by the vm_ops and have flags indicating
if the vma maps device memory such that vfio_get_device_from_vma()
should produce a device reference.  The vfio IOMMU backends would also
consume this, ie. if they get a valid vfio_device from the vma, use the
pfn_base field directly.  vfio_vm_ops would wrap the bus driver
callbacks and provide reference counting on open/close to release this
object.

I'm not thrilled with a vfio_device_ops callback plumbed through
vfio-core to do vma-to-pfn translation, so I thought this might be a
better alternative.  Thanks,

Alex

