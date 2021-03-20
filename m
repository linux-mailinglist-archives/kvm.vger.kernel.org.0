Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8D5342A8E
	for <lists+kvm@lfdr.de>; Sat, 20 Mar 2021 05:41:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhCTEko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Mar 2021 00:40:44 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhCTEkk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 20 Mar 2021 00:40:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616215237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mOiyVcIxelbfI5Hf2Zb0mb680hsw5tlDsbtGZ9FFDsc=;
        b=gLsb28/GYPEX9Aujgw8Xmc2KITBxZn33ocqjEOYvX6sdjSf+b5nhJQqnxK0Rjr+DTjusEV
        N6usNy5bF89r/kBKCxqmUUv/U/E/6YrIRg7YpsezDiUlOpzo+p+zg857Th9OKQ30RU69jC
        T+RgDwUNs+dDBx8dNfBUnHIJ2PAc/RE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-9wZOY1QrOpmbO_GBQz6XFA-1; Sat, 20 Mar 2021 00:40:33 -0400
X-MC-Unique: 9wZOY1QrOpmbO_GBQz6XFA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25F0F107ACCA;
        Sat, 20 Mar 2021 04:40:30 +0000 (UTC)
Received: from x1.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B023F6E510;
        Sat, 20 Mar 2021 04:40:28 +0000 (UTC)
Date:   Fri, 19 Mar 2021 22:40:28 -0600
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
Message-ID: <20210319224028.51b01435@x1.home.shazbot.org>
In-Reply-To: <20210319225943.GH2356281@nvidia.com>
References: <19e73e58-c7a9-03ce-65a7-50f37d52ca15@ozlabs.ru>
        <8941cf42-0c40-776e-6c02-9227146d3d66@nvidia.com>
        <20210319092341.14bb179a@omen.home.shazbot.org>
        <20210319161722.GY2356281@nvidia.com>
        <20210319162033.GA18218@lst.de>
        <20210319162848.GZ2356281@nvidia.com>
        <20210319163449.GA19186@lst.de>
        <20210319113642.4a9b0be1@omen.home.shazbot.org>
        <20210319200749.GB2356281@nvidia.com>
        <20210319150809.31bcd292@omen.home.shazbot.org>
        <20210319225943.GH2356281@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Mar 2021 19:59:43 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Mar 19, 2021 at 03:08:09PM -0600, Alex Williamson wrote:
> > On Fri, 19 Mar 2021 17:07:49 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> > > On Fri, Mar 19, 2021 at 11:36:42AM -0600, Alex Williamson wrote:  
> > > > On Fri, 19 Mar 2021 17:34:49 +0100
> > > > Christoph Hellwig <hch@lst.de> wrote:
> > > >     
> > > > > On Fri, Mar 19, 2021 at 01:28:48PM -0300, Jason Gunthorpe wrote:    
> > > > > > The wrinkle I don't yet have an easy answer to is how to load vfio_pci
> > > > > > as a universal "default" within the driver core lazy bind scheme and
> > > > > > still have working module autoloading... I'm hoping to get some
> > > > > > research into this..      
> > > > 
> > > > What about using MODULE_SOFTDEP("pre: ...") in the vfio-pci base
> > > > driver, which would load all the known variants in order to influence
> > > > the match, and therefore probe ordering?    
> > > 
> > > The way the driver core works is to first match against the already
> > > loaded driver list, then trigger an event for module loading and when
> > > new drivers are registered they bind to unbound devices.  
> > 
> > The former is based on id_tables, the latter on MODULE_DEVICE_TABLE, we
> > don't have either of those.  
> 
> Well, today we don't, but Max here adds id_table's to the special
> devices and a MODULE_DEVICE_TABLE would come too if we do the flavours
> thing below.

I think the id_tables are the wrong approach for IGD and NVLink
variants.
 
> My starting thinking is that everything should have these tables and
> they should work properly..

id_tables require ongoing maintenance whereas the existing variants
require only vendor + device class and some platform feature, like a
firmware or fdt table.  They're meant to only add extra regions to
vfio-pci base support, not extensively modify the device interface.
 
> > As noted to Christoph, the cases where we want a vfio driver to
> > bind to anything automatically is the exception.  
> 
> I agree vfio should not automatically claim devices, but once vfio is
> told to claim a device everything from there after should be
> automatic.
> 
> > > One answer is to have userspace udev have the "hook" here and when a
> > > vfio flavour mod alias is requested on a PCI device it swaps in
> > > vfio_pci if it can't find an alternative.
> > > 
> > > The dream would be a system with no vfio modules loaded could do some
> > > 
> > >  echo "vfio" > /sys/bus/pci/xxx/driver_flavour
> > > 
> > > And a module would be loaded and a struct vfio_device is created for
> > > that device. Very easy for the user.  
> > 
> > This is like switching a device to a parallel universe where we do
> > want vfio drivers to bind automatically to devices.  
> 
> Yes.
> 
> If we do this I'd probably suggest that driver_override be bumped down
> to some user compat and 'vfio > driver_override' would just set the
> flavour.
> 
> As-is driver_override seems dangerous as overriding the matching table
> could surely allow root userspace to crash the machine. In situations
> with trusted boot/signed modules this shouldn't be.

When we're dealing with meta-drivers that can bind to anything, we
shouldn't rely on the match, but should instead verify the driver is
appropriate in the probe callback.  Even without driver_override,
there's the new_id mechanism.  Either method allows the root user to
break driver binding.  Greg has previously stated something to the
effect that users get to keep all the pieces when they break something
by manipulating driver binding.

> > > > If we coupled that with wildcard support in driver_override, ex.
> > > > "vfio_pci*", and used consistent module naming, I think we'd only need
> > > > to teach userspace about this wildcard and binding to a specific module
> > > > would come for free.    
> > > 
> > > What would the wildcard do?  
> > 
> > It allows a driver_override to match more than one driver, not too
> > dissimilar to your driver_flavor above.  In this case it would match
> > all driver names starting with "vfio_pci".  For example if we had:
> > 
> > softdep vfio-pci pre: vfio-pci-foo vfio-pci-bar
> >
> > Then we'd pre-seed the condition that drivers foo and bar precede the
> > base vfio-pci driver, each will match the device to the driver and have
> > an opportunity in their probe function to either claim or skip the
> > device.  Userspace could also set and exact driver_override, for
> > example if they want to force using the base vfio-pci driver or go
> > directly to a specific variant.  
> 
> Okay, I see. The problem is that this makes 'vfio-pci' monolithic, in
> normal situations it will load *everything*.
> 
> While that might not seem too bad with these simple drivers, at least
> the mlx5 migration driver will have a large dependency tree and pull
> in lots of other modules. Even Max's sample from v1 pulls in mlx5_core.ko
> and a bunch of other stuff in its orbit.

Luckily the mlx5 driver doesn't need to be covered by compatibility
support, so we don't need to set a softdep for it and the module could
be named such that a wildcard driver_override of vfio_pci* shouldn't
logically include that driver.  Users can manually create their own
modprobe.d softdep entry if they'd like to include it.  Otherwise
userspace would need to know to bind to it specifically.
 
> This is why I want to try for fine grained autoloading first. It
> really is the elegant solution if we can work it out.

I just don't see how we create a manageable change to userspace.

> > > Open coding a match table in probe() and returning failure feels hacky
> > > to me.  
> > 
> > How's it any different than Max's get_foo_vfio_pci_driver() that calls
> > pci_match_id() with an internal match table?    
> 
> Well, I think that is hacky too - but it is hacky only to service user
> space compatability so lets put that aside

I don't see that dropping incompatible devices in the probe function
rather than the match via id_table is necessarily a hack.  I think
driver-core explicitly supports this (see below).

> > It seems a better fit for the existing use cases, for example the
> > IGD variant can use a single line table to exclude all except Intel
> > VGA class devices in its probe callback, then test availability of
> > the extra regions we'd expose, otherwise return -ENODEV.  
> 
> I don't think we should over-focus on these two firmware triggered
> examples. I looked at the Intel GPU driver and it already only reads
> the firmware thing for certain PCI ID's, we can absolutely generate a
> narrow match table for it. Same is true for the NVIDIA GPU.

I'm not sure we can make this assertion, both only care about the type
of device and existence of associated firmware tables.  No PCI IDs are
currently involved.

> The fact this is hard or whatever is beside the point - future drivers
> in this scheme should have exact match tables. 
> 
> The mlx5 sample is a good example, as it matches a very narrow NVMe
> device that is properly labeled with a subvendor ID. It does not match
> every NVMe device and then run code to figure it out. I think this is
> the right thing to do as it is the only thing that would give us fine
> grained module loading.

Sounds like the right thing to do for that device, if it's only designed
to run in this framework.  That's more like the mdev device model

> Even so, I'm not *so* worried about "over matching" - if IGD or the
> nvidia stuff load on a wide set of devices then they can just not
> enable their extended stuff. It wastes some kernel memory, but it is
> OK.

I'd rather they bind to the base vfio-pci driver if their extended
features are not available.

> And if some driver *really* gets stuck here the true answer is to
> improve the driver core match capability.
> 
> > devices in the deny-list and non-endpoint devices.  Many drivers
> > clearly place implicit trust in their id_table, others don't.  In the
> > case of meta drivers, I think it's fair to make use of the latter
> > approach.  
> 
> Well, AFAIK, the driver core doesn't have a 'try probe, if it fails
> then try another driver' approach. One device, one driver. Am I
> missing something?

If the driver probe callback fails, really_probe() returns 0 with the
comment:

        /*
         * Ignore errors returned by ->probe so that the next driver can try
         * its luck.
         */
        ret = 0;

That allows bus_for_each_drv() to continue to iterate.

> 
> I would prefer not to propose to Greg such a radical change to how
> driver loading works..

Seems to be how it works already.
 
> I also think the softdep/implicit loading/ordering will not be
> welcomed, it feels weird to me.

AFAICT, it works within the existing driver-core, it's largely an
extension to pci-core driver_override support to enable wildcard
matching, ideally along with adding the same for all buses that support
driver_override.  Thanks,

Alex

