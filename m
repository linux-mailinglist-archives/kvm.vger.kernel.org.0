Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07B804DC29
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 23:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfFTVIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 17:08:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbfFTVII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 17:08:08 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 52C63821CB;
        Thu, 20 Jun 2019 21:08:00 +0000 (UTC)
Received: from x1.home (ovpn-117-35.phx2.redhat.com [10.3.117.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A59825D71C;
        Thu, 20 Jun 2019 21:07:57 +0000 (UTC)
Date:   Thu, 20 Jun 2019 15:07:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
Message-ID: <20190620150757.7b2fa405@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C257439F0164E@SHSMSX104.ccr.corp.intel.com>
References: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
        <1560000071-3543-10-git-send-email-yi.l.liu@intel.com>
        <20190619222647.72efc76a@x1.home>
        <A2975661238FB949B60364EF0F2C257439F0164E@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 20 Jun 2019 21:08:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Jun 2019 13:00:34 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Thursday, June 20, 2019 12:27 PM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > 
> > On Sat,  8 Jun 2019 21:21:11 +0800
> > Liu Yi L <yi.l.liu@intel.com> wrote:
> >   
> > > This patch adds sample driver named vfio-mdev-pci. It is to wrap
> > > a PCI device as a mediated device. For a pci device, once bound
> > > to vfio-mdev-pci driver, user space access of this device will
> > > go through vfio mdev framework. The usage of the device follows
> > > mdev management method. e.g. user should create a mdev before
> > > exposing the device to user-space.
> > >
> > > Benefit of this new driver would be acting as a sample driver
> > > for recent changes from "vfio/mdev: IOMMU aware mediated device"
> > > patchset. Also it could be a good experiment driver for future
> > > device specific mdev migration support.
> > >
> > > To use this driver:
> > > a) build and load vfio-mdev-pci.ko module
> > >    execute "make menuconfig" and config CONFIG_SAMPLE_VFIO_MDEV_PCI
> > >    then load it with following command  
> > >    > sudo modprobe vfio
> > >    > sudo modprobe vfio-pci
> > >    > sudo insmod drivers/vfio/pci/vfio-mdev-pci.ko  
> > >
> > > b) unbind original device driver
> > >    e.g. use following command to unbind its original driver  
> > >    > echo $dev_bdf > /sys/bus/pci/devices/$dev_bdf/driver/unbind  
> > >
> > > c) bind vfio-mdev-pci driver to the physical device  
> > >    > echo $vend_id $dev_id > /sys/bus/pci/drivers/vfio-mdev-pci/new_id  
> > >
> > > d) check the supported mdev instances  
> > >    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/  
> > >      vfio-mdev-pci-type1  
> > >    > ls /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\  
> > >      vfio-mdev-pci-type1/
> > >      available_instances  create  device_api  devices  name  
> > 
> > 
> > I think the static type name here is a problem (and why does it
> > include "type1"?).  We generally consider that a type defines a
> > software compatible mdev, but in this case any PCI device wrapped in
> > vfio-mdev-pci gets the same mdev type.  This is only a sample driver,
> > but that's a bad precedent.  I've taken a stab at fixing this in the
> > patch below, using the PCI vendor ID, device ID, subsystem vendor ID,
> > subsystem device ID, class code, and revision to try to make the type
> > as specific to the physical device assigned as we can through PCI.  
> 
> Thanks, it is much better than what I proposed.
> 
> >   
> > >
> > > e)  create mdev on this physical device (only 1 instance)  
> > >    > echo "83b8f4f2-509f-382f-3c1e-e6bfe0fa1003" > \  
> > >      /sys/bus/pci/devices/$dev_bdf/mdev_supported_types/\
> > >      vfio-mdev-pci-type1/create  
> > 
> > Whoops, available_instances always reports 1 and it doesn't appear that
> > the create function prevents additional mdevs.  Also addressed in the
> > patch below.  
> 
> yep, thanks.
> 
> >   
> > > f) passthru the mdev to guest
> > >    add the following line in Qemu boot command
> > >    -device vfio-pci,\
> > >     sysfsdev=/sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003
> > >
> > > g) destroy mdev  
> > >    > echo 1 > /sys/bus/mdev/devices/83b8f4f2-509f-382f-3c1e-e6bfe0fa1003/\  
> > >      remove
> > >  
> > 
> > I also found that unbinding the parent device doesn't unregister with
> > mdev, so it cannot be bound again, also fixed below.  
> 
> Oops, good catch. :-)
> 
> > However, the patch below just makes the mdev interface behave
> > correctly, I can't make it work on my system because commit
> > 7bd50f0cd2fd ("vfio/type1: Add domain at(de)taching group helpers")  
> 
> What error did you encounter. I tested the patch with a device in a
> singleton iommu group. I'm also searching a proper machine with
> multiple devices in an iommu group and test it.

In vfio_iommu_type1, iommu backed mdev devices use the
iommu_attach_device() interface, which includes:

        if (iommu_group_device_count(group) != 1)
                goto out_unlock;

So it's impossible to use with non-singleton groups currently.

> > used iommu_attach_device() rather than iommu_attach_group() for non-aux
> > mdev iommu_device.  Is there a requirement that the mdev parent device
> > is in a singleton iommu group?  
> 
> I don't think there should have such limitation. Per my understanding,
> vfio-mdev-pci should also be able to bind to devices which shares
> iommu group with other devices. vfio-pci works well for such devices.
> And since the two drivers share most of the codes, I think vfio-mdev-pci
> should naturally support it as well.

Yes, the difference though is that vfio.c knows when devices are in the
same group, which mdev vfio.c only knows about the non-iommu backed
group, not the group that is actually used for the iommu backing.  So
we either need to enlighten vfio.c or further abstract those details in
vfio_iommu_type1.c.
 
> > If this is a simplification, then
> > vfio-mdev-pci should not bind to devices where this is violated since
> > there's no way to use the device.  Can we support it though?  
> 
> yeah, I think we need to support it.
> 
> > If I have two devices in the same group and bind them both to
> > vfio-mdev-pci, I end up with three groups, one for each mdev device and
> > the original physical device group.  vfio.c works with the mdev groups
> > and will try to match both groups to the container.  vfio_iommu_type1.c
> > also works with the mdev groups, except for the point where we actually
> > try to attach a group to a domain, which is the only window where we use
> > the iommu_device rather than the provided group, but we don't record
> > that anywhere.  Should struct vfio_group have a pointer to a reference
> > counted object that tracks the actual iommu_group attached, such that
> > we can determine that the group is already attached to the domain and
> > not try to attach again?   
> 
> Agreed, we need to avoid such duplicated attach. Instead of adding
> reference counted object in vfio_group. I'm also considering the logic
> below:
> 
>     /*
>       * Do this check in vfio_iommu_type1_attach_group(), after mdev_group
>       * is initialized.
>       */
>     if (vfio_group->mdev_group) {
>          /*
>            * vfio_group->mdev_group is true means vfio_group->iommu_group
>            * is not the actual iommu_group which is going to be attached to
>            * domain. To avoid duplicate iommu_group attach, needs to check if
>            * the actual iommu_group. vfio_get_parent_iommu_group() is a
>            * newly added helper function which returns the actual attach
>            * iommu_group going to be attached for this mdev group.
>               */
>          p_iommu_group = vfio_get_parent_iommu_group(
>                                                                          vfio_group->iommu_group);
>          list_for_each_entry(d, &iommu->domain_list, next) {
>                  if (find_iommu_group(d, p_iommu_group)) {
>                          mutex_unlock(&iommu->lock);
>                          // skip group attach;
>                  }
>          }

We don't currently create a struct vfio_group for the parent, only for
the mdev iommu group.  The iommu_attach for an iommu backed mdev
doesn't leave any traces of where it is actually attached, we just
count on retracing our steps for the detach.  That's why I'm thinking
we need an object somewhere to track it and it needs to be reference
counted so that if both a vfio-mdev-pci device and a vfio-pci device
are using it, we leave it in place if either one is removed.
 
> > Ideally I'd be able to bind one device to
> > vfio-pci, the other to vfio-mdev-pci, and be able to use them both
> > within the same container.  It seems like this should be possible, it's
> > the same effective iommu configuration as if they were both bound to
> > vfio-pci.  Thanks,  
> 
> Agreed. Will test it. And thanks for the fix patch below. I've test it
> with a device in a singleton iommu group. Need to test the scenario
> you mentioned above. :-)

Thanks!

Alex
