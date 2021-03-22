Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15096344BE7
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 17:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhCVQkm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 12:40:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22184 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231455AbhCVQk2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Mar 2021 12:40:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616431228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KsLjarnjua8MhxR/qpYAR4EVi2H41BnB8tr1ZOD2/wg=;
        b=Nh6VHoPGfz2wymCvcdG1+2T+sVAiRPGAwOlNOHPqaL7QPfz05gqTIZWG+n1uJl1CClCYhR
        N0fR42PD07225n1qRdyVzbh77oxqYrxmtHIaWXhJ450OwxFWUQwz0iIPYbly8dckxv/C3w
        InqRn5F81YkIWSJc5RWBxqcJYh0n30U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-hY-RkdLXOXy1RsR9NwKTnA-1; Mon, 22 Mar 2021 12:40:23 -0400
X-MC-Unique: hY-RkdLXOXy1RsR9NwKTnA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA11A81622;
        Mon, 22 Mar 2021 16:40:19 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-120.phx2.redhat.com [10.3.112.120])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C75317195;
        Mon, 22 Mar 2021 16:40:18 +0000 (UTC)
Date:   Mon, 22 Mar 2021 10:40:16 -0600
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
Message-ID: <20210322104016.36eb3c1f@omen.home.shazbot.org>
In-Reply-To: <20210321125818.GM2356281@nvidia.com>
References: <20210319092341.14bb179a@omen.home.shazbot.org>
        <20210319161722.GY2356281@nvidia.com>
        <20210319162033.GA18218@lst.de>
        <20210319162848.GZ2356281@nvidia.com>
        <20210319163449.GA19186@lst.de>
        <20210319113642.4a9b0be1@omen.home.shazbot.org>
        <20210319200749.GB2356281@nvidia.com>
        <20210319150809.31bcd292@omen.home.shazbot.org>
        <20210319225943.GH2356281@nvidia.com>
        <20210319224028.51b01435@x1.home.shazbot.org>
        <20210321125818.GM2356281@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 21 Mar 2021 09:58:18 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Fri, Mar 19, 2021 at 10:40:28PM -0600, Alex Williamson wrote:
> 
> > > Well, today we don't, but Max here adds id_table's to the special
> > > devices and a MODULE_DEVICE_TABLE would come too if we do the flavours
> > > thing below.  
> > 
> > I think the id_tables are the wrong approach for IGD and NVLink
> > variants.  
> 
> I really disagree with this. Checking for some random bits in firmware
> and assuming that every device made forever into the future works with
> this check is not a good way to do compatibility. Christoph made the
> same point.
> 
> We have good processes to maintain id tables, I don't see this as a
> problem.

The base driver we're discussing here is a meta-driver that binds to
any PCI endpoint as directed by the user.  There is no id_table.  There
can't be any id_table unless you're expecting every device vendor to
submit the exact subset of devices they have tested and condone usage
with this interface.  The IGD extensions here only extend that
interface by providing userspace read-only access to a few additional
pieces of information that we've found to be necessary for certain
userspace drivers.  The actual device interface is unchanged.  In the
case of the NVLink extensions, AIUI these are mostly extensions of a
firmware defined interface for managing aspects of the interconnect to
the device.  It is actually the "random bits in firmware" that we want
to expose, the ID of the device is somewhat tangential, we just only
look for those firmware extensions in association to certain vendor
devices.

Of course if you start looking at features like migration support,
that's more than likely not simply an additional region with optional
information, it would need to interact with the actual state of the
device.  For those, I would very much support use of a specific
id_table.  That's not these.

> > > As-is driver_override seems dangerous as overriding the matching table
> > > could surely allow root userspace to crash the machine. In situations
> > > with trusted boot/signed modules this shouldn't be.  
> > 
> > When we're dealing with meta-drivers that can bind to anything, we
> > shouldn't rely on the match, but should instead verify the driver is
> > appropriate in the probe callback.  Even without driver_override,
> > there's the new_id mechanism.  Either method allows the root user to
> > break driver binding.  Greg has previously stated something to the
> > effect that users get to keep all the pieces when they break something
> > by manipulating driver binding.  
> 
> Yes, but that is a view where root is allowed to break the kernel, we
> now have this optional other world where that is not allowed and root
> access to lots of dangerous things are now disabled.
> 
> new_id and driver_override should probably be in that disable list
> too..

We don't have this other world yet, nor is it clear that we will have
it.  What sort of id_table is the base vfio-pci driver expected to use?
There's always a risk that hardware doesn't adhere to the spec or that
platform firmware might escalate an error that we'd otherwise consider
mundane from a userspace driver.

> > > While that might not seem too bad with these simple drivers, at least
> > > the mlx5 migration driver will have a large dependency tree and pull
> > > in lots of other modules. Even Max's sample from v1 pulls in mlx5_core.ko
> > > and a bunch of other stuff in its orbit.  
> > 
> > Luckily the mlx5 driver doesn't need to be covered by compatibility
> > support, so we don't need to set a softdep for it and the module could
> > be named such that a wildcard driver_override of vfio_pci* shouldn't
> > logically include that driver.  Users can manually create their own
> > modprobe.d softdep entry if they'd like to include it.  Otherwise
> > userspace would need to know to bind to it specifically.  
> 
> But now you are giving up on the whole point, which was to
> automatically load the correct specific module without special admin
> involvement!

This series only exposed a temporary compatibility interface to provide
that anyway.  As I understood it, the long term solution was that
userspace would somehow learn which driver to use for which device.
That "somehow" isn't clear to me.

> > > This is why I want to try for fine grained autoloading first. It
> > > really is the elegant solution if we can work it out.  
> > 
> > I just don't see how we create a manageable change to userspace.  
> 
> I'm not sure I understand. Even if we add a new sysfs to set some
> flavour then that is a pretty trivial change for userspace to move
> from driver_override?

Perhaps for some definition of trivial that I'm not familiar with.
We're talking about changing libvirt and driverctl and every distro and
user that's created a custom script outside of those.  Even changing
from "vfio-pci" to "vfio-pci*" is a hurdle.

> > > I don't think we should over-focus on these two firmware triggered
> > > examples. I looked at the Intel GPU driver and it already only reads
> > > the firmware thing for certain PCI ID's, we can absolutely generate a
> > > narrow match table for it. Same is true for the NVIDIA GPU.  
> > 
> > I'm not sure we can make this assertion, both only care about the type
> > of device and existence of associated firmware tables.    
> 
> Well, I read through the Intel GPU driver and this is how I felt it
> works. It doesn't even check the firmware bit unless certain PCI IDs
> are matched first.

The IDs being only the PCI vendor ID and class code.  The entire IGD
extension is only meant to expose a vendor specific, graphics related
firmware table and collateral config space, so of course we'd restrict
it to that vendor for a graphics class device in approximately the
right location in the system.  There's a big difference between that
and a fixed id_table.
 
> For NVIDIA GPU Max checked internally and we saw it looks very much
> like how Intel GPU works. Only some PCI IDs trigger checking on the
> feature the firmware thing is linked to.

And as Alexey noted, the table came up incomplete.  But also those same
devices exist on platforms where this extension is completely
irrelevant.

> My point is: the actual *drivers* consuming these firmware features do
> *not* blindly match every PCI device and check for the firmware
> bit. They all have narrow matches and further only try to use the
> firmware thing for some subset of PCI IDs that the entire driver
> supports.

So because we don't check for an Intel specific graphics firmware table
when binding to Realtek NIC, we can leap to the conclusion that there
must be a concise id_table we can create for IGD support?

> Given that the actual drivers work this way there is no technical
> reason vfio-pci can't do this as well.

There's a giant assumption above that I'm missing.  Are you expecting
that vendors are actually going to keep up with submitting device IDs
that they claim to have tested and support with vfio-pci and all other
devices won't be allowed to bind?  That would single handedly destroy
any non-enterprise use cases of vfio-pci.

> We don't have to change them of course, they can stay as is if people
> feel really strongly.
> 
> > > Even so, I'm not *so* worried about "over matching" - if IGD or the
> > > nvidia stuff load on a wide set of devices then they can just not
> > > enable their extended stuff. It wastes some kernel memory, but it is
> > > OK.  
> > 
> > I'd rather they bind to the base vfio-pci driver if their extended
> > features are not available.  
> 
> Sure it would be nice, but functionally it is no different.

Exactly, the device interface is not changed, so why is it such a
heinous misstep that we should test for the feature we're trying to
expose rather than a specific ID and fall through if we don't find it?

> > > And if some driver *really* gets stuck here the true answer is to
> > > improve the driver core match capability.
> > >   
> > > > devices in the deny-list and non-endpoint devices.  Many drivers
> > > > clearly place implicit trust in their id_table, others don't.  In the
> > > > case of meta drivers, I think it's fair to make use of the latter
> > > > approach.    
> > > 
> > > Well, AFAIK, the driver core doesn't have a 'try probe, if it fails
> > > then try another driver' approach. One device, one driver. Am I
> > > missing something?  
> > 
> > If the driver probe callback fails, really_probe() returns 0 with the
> > comment:
> > 
> >         /*
> >          * Ignore errors returned by ->probe so that the next driver can try
> >          * its luck.
> >          */
> >         ret = 0;
> > 
> > That allows bus_for_each_drv() to continue to iterate.  
> 
> Er, but we have no reliable way to order drivers in the list so this
> still assumes the system has exactly one driver match (even if some of
> the match is now in code).
> 
> It won't work with a "universal" driver without more changes.
> 
> (and I couldn't find out why Cornelia added this long ago, or how or
> even if it actually ended up being used)

You'd need to go further back than Conny touching it, the original
import into git had:

void driver_attach(struct device_driver * drv)
{
        struct bus_type * bus = drv->bus;
        struct list_head * entry;
        int error;

        if (!bus->match)
                return;

        list_for_each(entry, &bus->devices.list) {
                struct device * dev = container_of(entry, struct device, bus_list);
                if (!dev->driver) {
                        error = driver_probe_device(drv, dev);
                        if (error && (error != -ENODEV))
                                /* driver matched but the probe failed */
                                printk(KERN_WARNING
                                    "%s: probe of %s failed with error %d\n",
                                    drv->name, dev->bus_id, error);
                }
        }
}

So unless you want to do some bitkeeper archaeology, we've always
allowed driver probes to fail and fall through to the next one, not
even complaining with -ENODEV.  In practice it hasn't been an issue
because how many drivers do you expect to have that would even try to
claim a device.  Ordering is only important when there's a catch-all so
we need to figure out how to make that last among a class of drivers
that will attempt to claim a device.  The softdep is a bit of a hack to
do that, I'll admit, but I don't see how the alternate driver flavor
universe solves having a catch-all either.  Thanks,

Alex

