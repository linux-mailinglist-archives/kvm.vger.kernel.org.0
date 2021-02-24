Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD2232460F
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 23:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbhBXWBx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 17:01:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41328 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235858AbhBXWBs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 17:01:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614204021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d3zNzQpUkthvSsw8SqaDLlrWN97gOHRelA4yiNMna1A=;
        b=IT4hF64GXvnh/DvDLVeLorIJG8ueksme9dS4RXWREHKVcSqLrUtP+gvKpCiHo9YC+4SJlE
        eRAQyJ/sR4WRw1qjKOMmJMfzpHA4Tpqv1yUA0EWK+/dNh20TBnuKvhpAqfQgAqexxmSrdd
        hMg3zDehJVG5rn/FKNkBzRqfnLrDwF8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-519-fxOhGzUaN5-yvJMuj582Kw-1; Wed, 24 Feb 2021 17:00:14 -0500
X-MC-Unique: fxOhGzUaN5-yvJMuj582Kw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3411D8710E3;
        Wed, 24 Feb 2021 22:00:12 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E90135F9C0;
        Wed, 24 Feb 2021 22:00:08 +0000 (UTC)
Date:   Wed, 24 Feb 2021 14:55:05 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterx@redhat.com>
Subject: Re: [RFC PATCH 04/10] vfio/pci: Use
 vfio_device_unmap_mapping_range()
Message-ID: <20210224145505.61a4fbc1@omen.home.shazbot.org>
In-Reply-To: <20210222172230.GO4247@nvidia.com>
References: <161401167013.16443.8389863523766611711.stgit@gimli.home>
        <161401267316.16443.11184767955094847849.stgit@gimli.home>
        <20210222172230.GO4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Feb 2021 13:22:30 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Feb 22, 2021 at 09:51:13AM -0700, Alex Williamson wrote:
> 
> > +	vfio_device_unmap_mapping_range(vdev->device,
> > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX),
> > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX) -
> > +			VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX));  
> 
> Isn't this the same as invalidating everything? I see in
> vfio_pci_mmap():
> 
> 	if (index >= VFIO_PCI_ROM_REGION_INDEX)
> 		return -EINVAL;

No, immediately above that is:

        if (index >= VFIO_PCI_NUM_REGIONS) {
                int regnum = index - VFIO_PCI_NUM_REGIONS;
                struct vfio_pci_region *region = vdev->region + regnum;

                if (region && region->ops && region->ops->mmap &&
                    (region->flags & VFIO_REGION_INFO_FLAG_MMAP))
                        return region->ops->mmap(vdev, region, vma);
                return -EINVAL;
        }

We can have device specific regions that can support mmap, but those
regions aren't necessarily on-device memory so we can't assume they're
tied to the memory bit in the command register.
 
> > @@ -2273,15 +2112,13 @@ static int vfio_pci_try_zap_and_vma_lock_cb(struct pci_dev *pdev, void *data)
> >  
> >  	vdev = vfio_device_data(device);
> >  
> > -	/*
> > -	 * Locking multiple devices is prone to deadlock, runaway and
> > -	 * unwind if we hit contention.
> > -	 */
> > -	if (!vfio_pci_zap_and_vma_lock(vdev, true)) {
> > +	if (!down_write_trylock(&vdev->memory_lock)) {
> >  		vfio_device_put(device);
> >  		return -EBUSY;
> >  	}  
> 
> And this is only done as part of VFIO_DEVICE_PCI_HOT_RESET?

Yes.

> It looks like VFIO_DEVICE_PCI_HOT_RESET effects the entire slot?

Yes.

> How about putting the inode on the reflck structure, which is also
> per-slot, and then a single unmap_mapping_range() will take care of
> everything, no need to iterate over things in the driver core.
>
> Note the vm->pg_off space doesn't have any special meaning, it is
> fine that two struct vfio_pci_device's are sharing the same address
> space and using an incompatible overlapping pg_offs

Ok, but how does this really help us, unless you're also proposing some
redesign of the memory_lock semaphore?  Even if we're zapping all the
affected devices for a bus reset that doesn't eliminate that we still
require device level granularity for other events.  Maybe there's some
layering of the inodes that you're implying that allows both, but it
still feels like a minor optimization if we need to traverse devices
for the memory_lock.

> > diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
> > index 9cd1882a05af..ba37f4eeefd0 100644
> > +++ b/drivers/vfio/pci/vfio_pci_private.h
> > @@ -101,6 +101,7 @@ struct vfio_pci_mmap_vma {
> >  
> >  struct vfio_pci_device {
> >  	struct pci_dev		*pdev;
> > +	struct vfio_device	*device;  
> 
> Ah, I did this too, but I didn't use a pointer :)

vfio_device is embedded in vfio.c, so that worries me.

> All the places trying to call vfio_device_put() when they really want
> a vfio_pci_device * become simpler now. Eg struct vfio_devices wants
> to have an array of vfio_pci_device, and get_pf_vdev() only needs to
> return one pointer.

Sure, that example would be a good simplification.  I'm not sure see
other cases where we're going out of our way to manage the vfio_device
versus vfio_pci_device objects though.  Thanks,

Alex

