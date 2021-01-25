Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B852C303038
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 00:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732721AbhAYXdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 18:33:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732914AbhAYXd0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 18:33:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611617519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j42RI3rK5rRixflFMh1UUzbe7YwSLEe6oi69dQNNK2c=;
        b=JF2Z1LbYshowPJgcDnEAgt8dJuCl5Mubrazpp4A1x6BVwSux1psqKM6iE4uuwuS4GZvwR6
        t/ouK52u7Rs/6tEqqOXkKcn+/UY86xblDvbFGiqPIiH1JX3eBA9C/i2+iX7pnROo2QNKI2
        UoHY/MGrkWHSooC24q+QE/gtoCakXzs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-zYSd0EcUM82xDSWrdCG0Uw-1; Mon, 25 Jan 2021 18:31:55 -0500
X-MC-Unique: zYSd0EcUM82xDSWrdCG0Uw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1483806674;
        Mon, 25 Jan 2021 23:31:53 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A68086A254;
        Mon, 25 Jan 2021 23:31:52 +0000 (UTC)
Date:   Mon, 25 Jan 2021 16:31:51 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liranl@nvidia.com>,
        <oren@nvidia.com>, <tzahio@nvidia.com>, <leonro@nvidia.com>,
        <yarong@nvidia.com>, <aviadye@nvidia.com>, <shahafs@nvidia.com>,
        <artemp@nvidia.com>, <kwankhede@nvidia.com>, <ACurrid@nvidia.com>,
        <gmataev@nvidia.com>, <cjia@nvidia.com>
Subject: Re: [PATCH RFC v1 0/3] Introduce vfio-pci-core subsystem
Message-ID: <20210125163151.5e0aeecb@omen.home.shazbot.org>
In-Reply-To: <20210125180440.GR4147@nvidia.com>
References: <20210117181534.65724-1-mgurtovoy@nvidia.com>
        <20210122122503.4e492b96@omen.home.shazbot.org>
        <20210122200421.GH4147@nvidia.com>
        <20210125172035.3b61b91b.cohuck@redhat.com>
        <20210125180440.GR4147@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 25 Jan 2021 14:04:40 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Jan 25, 2021 at 05:20:35PM +0100, Cornelia Huck wrote:
> 
> > I think you cut out an important part of Alex' comment, so let me
> > repost it here:  
> 
> Yes, I've already respnded to this.

Not really.  For example, how can struct vfio_pci_device be exposed
as-is to the various drivers that may be derived from vfio-pci-core?
As soon as such a driver starts touching those fields or performing
operations on their own without making proper use of those fields, then
the API is not the simple set of exported functions below, it's the
entire mechanics of every bit of data in that structure and the
structures it includes.  If we're making a library then we need to
define public and private data.  We're just tossing everything here
into the private header which is necessarily public to the derived
drivers if they're to have any means to operate on the device.

> > I'm missing the bigger picture of how this api is supposed to work out,
> > a driver with a lot of TODOs does not help much to figure out whether
> > this split makes sense and is potentially useful for a number of use
> > cases  
> 
> The change to vfio-pci is essentially complete, ignoring some
> additional cleanup. I'm not sure seeing details how some mlx5 driver
> uses it will be substantially more informative if it is useful for
> S390, or Intel.

We're supposed to be enlightened by a vendor driver that does nothing
more than pass the opaque device_data through to the core functions,
but in reality this is exactly the point of concern above.  At a
minimum that vendor driver needs to look at the vdev to get the pdev,
but then what else does it look at, consume, or modify.  Now we have
vendor drivers misusing the core because it's not clear which fields
are private and how public fields can be used safely, any core
extensions potentially break vendor drivers, etc.  We're only even hand
waving that existing device specific support could be farmed out to new
device specific drivers without even going to the effort to prove that.
 
> As far as API it is clear to see:
> 
> > +/* Exported functions */
> > +struct vfio_pci_device *vfio_create_pci_device(struct pci_dev *pdev,
> > +               const struct vfio_device_ops *vfio_pci_ops, void *dd_data);

Nit, dd_data is never defined or used.  The function returns a struct
vfio_pci_device, but I'm not sure whether that's supposed to be public
or private.  IMO, it should be private and perhaps access functions
should be provided for fields we consider public.

> > +void vfio_destroy_pci_device(struct pci_dev *pdev);  
> 
> Called from probe/remove of the consuming driver
> 
> > +int vfio_pci_core_open(void *device_data);
> > +void vfio_pci_core_release(void *device_data);
> > +long vfio_pci_core_ioctl(void *device_data, unsigned int cmd,
> > +               unsigned long arg);
> > +ssize_t vfio_pci_core_read(void *device_data, char __user *buf, size_t count,
> > +               loff_t *ppos);
> > +ssize_t vfio_pci_core_write(void *device_data, const char __user *buf,
> > +               size_t count, loff_t *ppos);
> > +int vfio_pci_core_mmap(void *device_data, struct vm_area_struct *vma);
> > +void vfio_pci_core_request(void *device_data, unsigned int count);
> > +int vfio_pci_core_match(void *device_data, char *buf);  
> 
> Called from vfio_device_ops and has the existing well defined API of
> the matching ops.

All of these require using struct vfio_pci_device to do anything beyond
the stub implementation in 3/3.

> > +int vfio_pci_core_sriov_configure(struct pci_dev *pdev, int nr_virtfn);
> > +pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
> > +               pci_channel_state_t state);
> > +  
> 
> Callbacks from the PCI core, API defined by the PCI subsystem.
> 
> Notice there is no major new API exposed from vfio-pci, nor are
> vfio-pci internals any more exposed then they used to be.

They absolutely are.  These are all private, non-exported functions and
data structures.  Here the vfio_device_ops and all the internal state
are all laid bare.

> Except create/destroy, every single newly exported function was
> already available via a function pointer someplace else in the
> API. This is a key point, because it is very much NOT like the May
> series.

They were available to vfio-core, which honored that device_data was
private.
 
> Because the new driver sits before vfio_pci because it owns the
> vfio_device_ops, it introduces nearly nothing new. The May series put
> the new driver after vfio-pci as some internalized sub-driver and
> exposed a whole new API, wrappers and callbacks to go along with it.
> 
> For instance if a new driver wants to implement some new thing under
> ioctl, like migration, then it would do
> 
> static long new_driver_pci_core_ioctl(void *device_data, unsigned int cmd,
>                unsigned long arg)
> {
>    switch (cmd) {
>      case NEW_THING: return new_driver_thing();

new_driver_thing relative too what.  Now we need to decode the
vfio-pci-core private data and parse through it to access or affect the
device.

>      default: return vfio_pci_core_ioctl(device_data, cmd, arg);
>    }
> }
> static const struct vfio_device_ops new_driver_pci_ops = {
>    [...]
>    .ioctl = new_driver_ioctl,
> };
> 
> Simple enough, if you understand the above, then you also understand
> what direction the mlx5 driver will go in.
> 
> This is also why it is clearly useful for a wide range of cases, as a
> driver can use as much or as little of the vfio-pci-core ops as it
> wants. The driver doesn't get to reach into vfio-pci, but it can sit
> before it and intercept the entire uAPI. That is very powerful.

But vfio-pci-core is actually vfio-pci and there's no way for a vendor
derived driver to do much of anything without reaching into struct
vfio_pci_device, so yes, it is reaching into vfio-pci.
 
> > or whether mdev (even with its different lifecycle model) or a  
> 
> I think it is appropriate to think of mdev as only the special
> lifecycle model, it doesn't have any other functionality.
> 
> mdev's lifecycle model does nothing to solve the need to libraryize
> vfio-pci.
> 
> > different vfio bus driver might be a better fit for the more  
> 
> What is a "vfio bus driver" ? Why would we need a bus here?

./Documentation/driver-api/vfio.rst

We refer to drivers that bridge vfio-core to bus implementations, ex.
vfio-pci, as "vfio bus drivers".  This is partially why we've so far
extended vfio-pci with device specific features, as a bus specific
driver rather than a device specific driver.

> > involved cases. (For example, can s390 ISM fit here?)  
> 
> Don't know what is special about ISM? What TODO do you think will help
> answer that question?

So far the TODOs rather mask the dirty little secrets of the extension
rather than showing how a vendor derived driver needs to root around in
struct vfio_pci_device to do something useful, so probably porting
actual device specific support rather than further hand waving would be
more helpful.  Thanks,

Alex

