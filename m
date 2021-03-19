Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD215342769
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 22:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbhCSVIk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 17:08:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48275 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhCSVIT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Mar 2021 17:08:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616188098;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=opCZHstDLqPqXMm8qZqBgIaQQd928Py+8MG6q5CxZuI=;
        b=CLq61/0cPJPHj3AvOyXlnHd6S71gtMFg5iXnLhdqzXAiQBcwLGWl1qoDVG3setiBOxxRAH
        LzqYfM0Ap5+oRkD9kdgSVsxGgtx7Eo9tFo4DKYfQ+StWoIBReNvN0xgLMIc75U1gfRpZC5
        gYx9QWlRkH+yCFByilAw39EPAeFo9+I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-36-uyssPhfJMiaaRxyfSRFD_w-1; Fri, 19 Mar 2021 17:08:14 -0400
X-MC-Unique: uyssPhfJMiaaRxyfSRFD_w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29311190D341;
        Fri, 19 Mar 2021 21:08:12 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 65E1D5D9C6;
        Fri, 19 Mar 2021 21:08:10 +0000 (UTC)
Date:   Fri, 19 Mar 2021 15:08:09 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, cohuck@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        liranl@nvidia.com, oren@nvidia.com, tzahio@nvidia.com,
        leonro@nvidia.com, yarong@nvidia.com, aviadye@nvidia.com,
        shahafs@nvidia.com, artemp@nvidia.com, kwankhede@nvidia.com,
        ACurrid@nvidia.com, cjia@nvidia.com, yishaih@nvidia.com,
        mjrosato@linux.ibm.com
Subject: Re: [PATCH 8/9] vfio/pci: export nvlink2 support into vendor
 vfio_pci drivers
Message-ID: <20210319150809.31bcd292@omen.home.shazbot.org>
In-Reply-To: <20210319200749.GB2356281@nvidia.com>
References: <20210309083357.65467-1-mgurtovoy@nvidia.com>
        <20210309083357.65467-9-mgurtovoy@nvidia.com>
        <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
        <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
        <20210319092341.14bb179a@omen.home.shazbot.org>
        <20210319161722.GY2356281@nvidia.com>
        <20210319162033.GA18218@lst.de>
        <20210319162848.GZ2356281@nvidia.com>
        <20210319163449.GA19186@lst.de>
        <20210319113642.4a9b0be1@omen.home.shazbot.org>
        <20210319200749.GB2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Mar 2021 17:07:49 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Mar 19, 2021 at 11:36:42AM -0600, Alex Williamson wrote:
> > On Fri, 19 Mar 2021 17:34:49 +0100
> > Christoph Hellwig <hch@lst.de> wrote:
> >   
> > > On Fri, Mar 19, 2021 at 01:28:48PM -0300, Jason Gunthorpe wrote:  
> > > > The wrinkle I don't yet have an easy answer to is how to load vfio_pci
> > > > as a universal "default" within the driver core lazy bind scheme and
> > > > still have working module autoloading... I'm hoping to get some
> > > > research into this..    
> > 
> > What about using MODULE_SOFTDEP("pre: ...") in the vfio-pci base
> > driver, which would load all the known variants in order to influence
> > the match, and therefore probe ordering?  
> 
> The way the driver core works is to first match against the already
> loaded driver list, then trigger an event for module loading and when
> new drivers are registered they bind to unbound devices.

The former is based on id_tables, the latter on MODULE_DEVICE_TABLE, we
don't have either of those.  As noted to Christoph, the cases where we
want a vfio driver to bind to anything automatically is the exception.
 
> So, the trouble is the event through userspace because the kernel
> can't just go on to use vfio_pci until it knows userspace has failed
> to satisfy the load request.

Given that we don't use MODULE_DEVICE_TABLE, vfio-pci doesn't autoload.
AFAIK, all tools like libvirt and driverctl that typically bind devices
to vfio-pci will manually load vfio-pci.  I think we can take advantage
of that.

> One answer is to have userspace udev have the "hook" here and when a
> vfio flavour mod alias is requested on a PCI device it swaps in
> vfio_pci if it can't find an alternative.
> 
> The dream would be a system with no vfio modules loaded could do some
> 
>  echo "vfio" > /sys/bus/pci/xxx/driver_flavour
> 
> And a module would be loaded and a struct vfio_device is created for
> that device. Very easy for the user.

This is like switching a device to a parallel universe where we do
want vfio drivers to bind automatically to devices.
 
> > If we coupled that with wildcard support in driver_override, ex.
> > "vfio_pci*", and used consistent module naming, I think we'd only need
> > to teach userspace about this wildcard and binding to a specific module
> > would come for free.  
> 
> What would the wildcard do?

It allows a driver_override to match more than one driver, not too
dissimilar to your driver_flavor above.  In this case it would match
all driver names starting with "vfio_pci".  For example if we had:

softdep vfio-pci pre: vfio-pci-foo vfio-pci-bar

Then we'd pre-seed the condition that drivers foo and bar precede the
base vfio-pci driver, each will match the device to the driver and have
an opportunity in their probe function to either claim or skip the
device.  Userspace could also set and exact driver_override, for
example if they want to force using the base vfio-pci driver or go
directly to a specific variant.
 
> > This assumes we drop the per-variant id_table and use the probe
> > function to skip devices without the necessary requirements, either
> > wrong device or missing the tables we expect to expose.  
> 
> Without a module table how do we know which driver is which? 
> 
> Open coding a match table in probe() and returning failure feels hacky
> to me.

How's it any different than Max's get_foo_vfio_pci_driver() that calls
pci_match_id() with an internal match table?  It seems a better fit for
the existing use cases, for example the IGD variant can use a single
line table to exclude all except Intel VGA class devices in its probe
callback, then test availability of the extra regions we'd expose,
otherwise return -ENODEV.  The NVLink variant can use pci_match_id() in
the probe callback to filter out anything other than NVIDIA VGA or 3D
accelerator class devices, then check for associated FDT table, or
return -ENODEV.  We already use the vfio_pci probe function to exclude
devices in the deny-list and non-endpoint devices.  Many drivers
clearly place implicit trust in their id_table, others don't.  In the
case of meta drivers, I think it's fair to make use of the latter
approach.

> > > Should we even load it by default?  One answer would be that the sysfs
> > > file to switch to vfio mode goes into the core PCI layer, and that core
> > > PCI code would contain a hack^H^H^H^Hhook to first load and bind vfio_pci
> > > for that device.  
> > 
> > Generally we don't want to be the default driver for anything (I think
> > mdev devices are the exception).  Assignment to userspace or VM is a
> > niche use case.  Thanks,  
> 
> By "default" I mean if the user says device A is in "vfio" mode then
> the kernel should
>  - Search for a specific driver for this device and autoload it
>  - If no specific driver is found then attach a default "universal"
>    driver for it. vfio_pci is a universal driver.
> 
> vfio_platform is also a "universal" driver when in ACPI mode, in some
> cases.
> 
> For OF cases platform it builts its own little subsystem complete with
> autoloading:
> 
>                 request_module("vfio-reset:%s", vdev->compat);
>                 vdev->of_reset = vfio_platform_lookup_reset(vdev->compat,
>                                                         &vdev->reset_module);
> 
> And it is a good example of why I don't like this subsystem design
> because vfio_platform doesn't do the driver loading for OF entirely
> right, vdev->compat is a single string derived from the compatible
> property:
> 
>         ret = device_property_read_string(dev, "compatible",
>                                           &vdev->compat);
>         if (ret)
>                 dev_err(dev, "Cannot retrieve compat for %s\n", vdev->name);
> 
> Unfortunately OF requires that compatible is a *list* of strings and a
> correct driver is supposed to evaluate all of them. The driver core
> does this all correctly, and this was lost when it was open coded
> here.
> 
> We should NOT be avoiding the standard infrastructure for matching
> drivers to devices by re-implementing it poorly.

I take some blame for the request_module() behavior of vfio-platform,
but I think we're on the same page that we don't want to turn vfio-pci
into a nexus for loading variant drivers.  Whatever solution we use for
vfio-pci might translate to replacing that vfio-platform behavior.  As
above, I think it's possible to create that alternate universe of
driver matching with a simple wildcard and load ordering approach,
performing the more specific filtering in the probe callback with fall
through to the next matching driver.  Thanks,

Alex

