Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB663E9853
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 21:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231301AbhHKTIE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 15:08:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229655AbhHKTID (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 15:08:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E315360EB9;
        Wed, 11 Aug 2021 19:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628708859;
        bh=1hYJaS9V+VuBZvtWB2L4aOhM8mH8mTWyc+75eQ94cnA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Y9K4xPCz9DFNcuZKdF98a04mIrOW7O5VSC3yfwagEuf0rzKYDMiOhzHF2KEYpVkLq
         9uCG/DMWzXnD75Uu+52rNC2cHlhctCvddfuZMMC6NgqdbOX8LD/dwJ/7gf0vjR4uqS
         chboryptqNVfXJbZPuaZn/cP+8tKKiHne/TNhI98m7UjS5jEfhp2MEixyM6CcFBk/2
         +wZOhSwCgI0SwJ8IcBUTtpZPmjxV3JoC80llXrW32HvjYE/mU6dE3LWmSL0ojdtqfo
         0zVH4hNsYVCgiwtB7Qzgm2KZofsOOxGSATSwSh4ytP88mlpBptzF3IMFnwCMKjs2Fv
         UT42cojvlPYqA==
Date:   Wed, 11 Aug 2021 14:07:37 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
Message-ID: <20210811190737.GA2378935@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806002357.GD1672295@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:
> On Wed, Aug 04, 2021 at 03:34:12PM -0500, Bjorn Helgaas wrote:
> 
> > > The first use will be to define a VFIO flag that indicates the PCI driver
> > > is a VFIO driver.
> >
> > Is there such a thing as a "VFIO driver" today?  
> 
> Yes.
> 
> VFIO has long existed as a driver subsystem that binds drivers to
> devices in various bus types. In the case of PCI the admin moves a PCI
> device from normal operation to VFIO operation via something like:

What specifically makes a driver a "VFIO driver"?  Maybe that it
supports the VFIO ioctls in include/uapi/linux/vfio.h?  That by itself
doesn't require special treatment by the kernel, so I think there's
more here.

> echo vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
> 
> Other bus types (platform, acpi, etc) have a similar command to move
> them to VFIO.

Do the other bus types have a flag analogous to
PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
other bus types, it'd be nice if the approach were similar.

> > > This patch is the infrastructure to provide the information in the
> > > modules.alias to userspace and enable the only PCI VFIO driver. Later
> > > series introduce additional HW specific VFIO PCI drivers.
> > 
> > s/the only/only the/ ?  (Not sure what you intend, but "the only"
> > doesn't seem right)
> 
> "the only" is correct, at this point in the sequence there is only one
> pci_driver that uses this, vfio_pci.ko

Can we just name the specific driver instead of obliquely referring to
"the only such driver", e.g., something like "... add a modules.alias
entry for vfio_pci.ko, currently the only PCI VFIO driver"?

> > Sorry, I know I'm totally missing the point here.
> 
> Lets try again..
> 
> PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to struct pci_device_id
> 
> Allow device drivers to include match entries in the modules.alias file
> produced by kbuild that are not used for normal driver autoprobing and
> module autoloading. Drivers using these match entries can be connected to
> the PCI device manually, by userspace, using the existing driver_override
> sysfs.

IIUC, the end result of this is basically a tweak to the existing
sysfs driver_override functionality.

And I *think* (correct me if I'm wrong), this actually has nothing in
particular to do with VFIO.  It's just that you want to expose some
device IDs that are only used for binding when driver_override is set.

> Add the flag PCI_ID_F_VFIO_DRIVER_OVERRIDE to indicate that the match
> entry is for the VFIO subsystem. These match entries are prefixed with
> "vfio_" in the modules.alias.
> 
> For example the resulting modules.alias may have:
> 
>   alias pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_core
>   alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
>   alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci
> 
> In this example mlx5_core and mlx5_vfio_pci match to the same PCI
> device. The kernel will autoload and autobind to mlx5_core but the kernel
> and udev mechanisms will ignore mlx5_vfio_pci.
> 
> When userspace wants to change a device to the VFIO subsystem userspace
> can implement a generic algorithm:
> 
>    1) Identify the sysfs path to the device:
>     /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0
> 
>    2) Get the modalias string from the kernel:
>     $ cat /sys/bus/pci/devices/0000:01:00.0/modalias
>     pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00

So far, I think this is all the existing behavior, unaffected by this
patch.

>    3) Prefix it with vfio_:
>     vfio_pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00
> 
>    4) Search modules.alias for the above string and select the entry that
>       has the fewest *'s:
>     alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci

And this patch basically adds this modules.alias entry.

Previously vfio_pci contained no vendor/device IDs, and the only way
to bind it to a device was to either:

  - Modprobe the driver and write dynamic device IDs to the driver's
    /sys/.../new_id.  This should directly bind the driver to all
    devices that match the new IDs (see new_id_store()).

or

  - Write "vfio_pci" to the device's /sys/.../driver_override.
    AFAICS, this won't bind anything (see driver_override_store()),
    but if we call the driver's .probe() method via modprobe or
    rescan, the driver_override will match any device regardless of
    ID.

IIUC, after this patch, you can add vendor/device IDs to a struct
pci_driver with this new flag.  These IDs are advertised via
modules.alias.

For driver binding, IDs with the new flag are eligible to match only
when driver_override is set to the matching driver.

Setting a device's driver_override has *always* caused the matching
driver to bind.  The only difference after this patch is that now we
give the driver an ID from its .id_table instead of pci_device_id_any.

>    5) modprobe the matched module name:
>     $ modprobe mlx5_vfio_pci

I assume somewhere in here you need to unbind mlx5_core before binding
mlx5_vfio_pci?

>    6) cat the matched module name to driver_override:
>     echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override

Don't you need something here to trigger the driver attach, i.e.,
should step 5 and step 6 be swapped?  What if the driver is already
loaded?  Can you modprobe again to make it bind to a second device?

> The algorithm is independent of bus type. In future the other buses's with
> VFIO device drivers, like platform and ACPI, can use this algorithm as
> well.

s/buses's/buses/

I see drivers/vfio/platform/vfio_platform.c; is that what you mean?  I
don't see any VFIO things with ACPI in their name, so maybe I'm
looking the wrong place.  If this is purely *plans* for the future,
maybe say something like "planned VFIO drivers ..."

> This patch is the infrastructure to provide the information in the
> modules.alias to userspace. Convert the only VFIO pci_driver which
> results in one new line in the modules.alias:

"Convert vfio_pci, currently the only VFIO PCI driver, which ..." ?

>   alias vfio_pci:v*d*sv*sd*bc*sc*i* vfio_pci
> 
> Later series introduce additional HW specific VFIO PCI drivers, such as
> mlx5_vfio_pci.
> 
> > > diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> > > index 7c97fa8e36bc..f53b38e8f696 100644
> > > +++ b/scripts/mod/file2alias.c
> > > @@ -426,7 +426,7 @@ static int do_ieee1394_entry(const char *filename,
> > >  	return 1;
> > >  }
> > >  
> > > -/* Looks like: pci:vNdNsvNsdNbcNscNiN. */
> > > +/* Looks like: pci:vNdNsvNsdNbcNscNiN or <prefix>_pci:vNdNsvNsdNbcNscNiN. */
> > >  static int do_pci_entry(const char *filename,
> > >  			void *symval, char *alias)
> > >  {
> > > @@ -440,8 +440,12 @@ static int do_pci_entry(const char *filename,
> > >  	DEF_FIELD(symval, pci_device_id, subdevice);
> > >  	DEF_FIELD(symval, pci_device_id, class);
> > >  	DEF_FIELD(symval, pci_device_id, class_mask);
> > > +	DEF_FIELD(symval, pci_device_id, flags);
> > 
> > I'm a little bit wary of adding a new field to this kernel/user
> > interface just for this single bit.  Maybe it's justified but feels
> > like it's worth being careful.
> 
> A couple of us looked at this in one of the RFC threads..
> 
> As far as we could tell this is not a kernel/user interface. It is an
> interface within kbuild between gcc and file2alias and is not used or
> really exported beyond the kernel build sequence.
> 
> Debian code search didn't find anything, for instance.
> 
> modules.alias, as output by file2alias during kbuild, is the canonical
> "kernel/user" interface here. Everything that needs this data should
> be using that.

Ah, thanks.  I was thinking this added something to /sys/.../modalias,
but sounds like that's not the case.
