Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8046609CF
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 17:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfGEPzZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 5 Jul 2019 11:55:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57782 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726696AbfGEPzZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 11:55:25 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22A71C058CA8;
        Fri,  5 Jul 2019 15:55:24 +0000 (UTC)
Received: from x1.home (ovpn-116-83.phx2.redhat.com [10.3.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E89E818657;
        Fri,  5 Jul 2019 15:55:20 +0000 (UTC)
Date:   Fri, 5 Jul 2019 09:55:20 -0600
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
Message-ID: <20190705095520.548331c2@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C257439F1FF4E@SHSMSX104.ccr.corp.intel.com>
References: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
        <1560000071-3543-10-git-send-email-yi.l.liu@intel.com>
        <20190619222647.72efc76a@x1.home>
        <A2975661238FB949B60364EF0F2C257439F0164E@SHSMSX104.ccr.corp.intel.com>
        <20190620150757.7b2fa405@x1.home>
        <A2975661238FB949B60364EF0F2C257439F02663@SHSMSX104.ccr.corp.intel.com>
        <20190621095740.41e6e98e@x1.home>
        <A2975661238FB949B60364EF0F2C257439F05415@SHSMSX104.ccr.corp.intel.com>
        <20190628090741.51e8d18e@x1.home>
        <A2975661238FB949B60364EF0F2C257439F1E9EC@SHSMSX104.ccr.corp.intel.com>
        <20190703112212.146ac71c@x1.home>
        <A2975661238FB949B60364EF0F2C257439F1FF4E@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 05 Jul 2019 15:55:24 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 4 Jul 2019 09:11:02 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Thursday, July 4, 2019 1:22 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > 
> > On Wed, 3 Jul 2019 08:25:25 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > Hi Alex,
> > >
> > > Thanks for the comments. Have four inline responses below. And one
> > > of them need your further help. :-)  
> 
> [...]
> 
> > > > > >  
> > > > > > > > > > used iommu_attach_device() rather than iommu_attach_group()
> > > > > > > > > > for non-aux mdev iommu_device.  Is there a requirement that
> > > > > > > > > > the mdev parent device is in a singleton iommu group?  
> > > > > > > > >
> > > > > > > > > I don't think there should have such limitation. Per my
> > > > > > > > > understanding, vfio-mdev-pci should also be able to bind to
> > > > > > > > > devices which shares iommu group with other devices. vfio-pci works  
> > well  
> > > > for such devices.  
> > > > > > > > > And since the two drivers share most of the codes, I think
> > > > > > > > > vfio-mdev-pci should naturally support it as well.  
> > > > > > > >
> > > > > > > > Yes, the difference though is that vfio.c knows when devices are
> > > > > > > > in the same group, which mdev vfio.c only knows about the
> > > > > > > > non-iommu backed group, not the group that is actually used for
> > > > > > > > the iommu backing.  So we either need to enlighten vfio.c or
> > > > > > > > further abstract those details in vfio_iommu_type1.c.  
> > > > > > >
> > > > > > > Not sure if it is necessary to introduce more changes to vfio.c or
> > > > > > > vfio_iommu_type1.c. If it's only for the scenario which two
> > > > > > > devices share an iommu_group, I guess it could be supported by
> > > > > > > using __iommu_attach_device() which has no device counting for the
> > > > > > > group. But maybe I missed something here. It would be great if you
> > > > > > > can elaborate a bit for it. :-)  
> > > > > >
> > > > > > We need to use the group semantics, there's a reason
> > > > > > __iommu_attach_device() is not exposed, it's an internal helper.  I
> > > > > > think there's no way around that we need to somewhere track the
> > > > > > actual group we're attaching to and have the smarts to re-use it for
> > > > > > other devices in the same group.  
> > > > >
> > > > > Hmmm, exposing __iommu_attach_device() is not good, let's forget it.
> > > > > :-)
> > > > >  
> > > > > > > > > > If this is a simplification, then vfio-mdev-pci should not
> > > > > > > > > > bind to devices where this is violated since there's no way
> > > > > > > > > > to use the device.  Can we support it though?  
> > > > > > > > >
> > > > > > > > > yeah, I think we need to support it.  
> > >
> > > I've already made vfio-mdev-pci driver work for non-singleton iommu
> > > group. e.g. for devices in a single iommu group, I can bind the devices
> > > to eithervfio-pci or vfio-mdev-pci and then passthru them to a VM. And
> > > it will fail if user tries to passthru a vfio-mdev-pci device via vfio-pci
> > > manner "-device vfio-pci,host=01:00.1". In other words, vfio-mdev-pci
> > > device can only passthru via
> > > "-device vfio-pci,sysfsdev=/sys/bus/mdev/devices/UUID". This is what
> > > we expect.
> > >
> > > However, I encountered a problem when trying to prevent user from
> > > passthru these devices to different VMs. I've tried in my side, and I
> > > can passthru vfio-pci device and vfio-mdev-pci device to different
> > > VMs. But actually this operation should be failed. If all the devices
> > > are bound to vfio-pci, Qemu will open iommu backed group. So
> > > Qemu can check if a given group has already been used by an
> > > AddressSpace (a.ka. VM) in vfio_get_group() thus to prevent
> > > user from passthru these devices to different VMs if the devices
> > > are in the same iommu backed group. However, here for a
> > > vfio-mdev-pci device, it has a new group and group ID, Qemu
> > > will not be able to detect if the other devices (share iommu group
> > > with vfio-mdev-pci device) are passthru to existing VMs. This is the
> > > major problem for vfio-mdev-pci to support non-singleton group
> > > in my side now. Even all devices are bound to vfio-mdev-pci driver,
> > > Qemu is still unable to check since all the vfio-mdev-pci devices
> > > have a separate mdev group.
> > >
> > > To fix it, may need Qemu to do more things. E.g. If it tries to use a
> > > non-singleton iommu backed group, it needs to check if any mdev
> > > group is created and used by an existing VM. Also it needs check if
> > > iommu backed group is passthru to an existing VM when trying to
> > > use a mdev group. For singleton iommu backed group and
> > > aux-domain enabled physical device, still allow to passthru mdev
> > > group to different VMs. To achieve these checks, Qemu may need
> > > to have knowledge whether a group is iommu backed and singleton
> > > or not. Do you think it is good to expose such info to userspace? or
> > > any other idea? :-)  
> > 
> > QEMU is never responsible for isolating a group, QEMU is just a
> > userspace driver, it's vfio's responsibility to prevent the user from
> > splitting groups in ways that are not allowed.  QEMU does not know the  
> 
> yep, also my concern.
> 
> > true group association, it only knows the "virtual" group of the mdev
> > device.  QEMU will create a container and add the mdev virtual group to
> > the container.  In the kernel, the type1 backend should actually do an
> > iommu_attach_group(), attaching the iommu_device group to the domain.
> > When QEMU processes the next device, it will have a different group,
> > but (assuming no vIOMMU) it will try to attach it to the same
> > container, which should work because the iommu_device group backing the
> > mdev virtual group is already attached to this domain.
> > If we had two separate QEMU processes, each with an mdev device from a
> > common group at the iommu_device level, the type1 backend should fail
> > to attach the group to the container for the later caller.  I'd think
> > this should fail at the iommu_attach_group() call since the group we're
> > trying to attach is already attached to another domain.  
> 
> Agree with you. At first, I want to fail it in similar way with vfio-pci devices.
> For vfio-pci devices from a common group, vfio will fail the operation around
> /dev/vfio/group_id open if user tries to assign the vfio-pci devices from common
> group to multiple QEMU processes. Meanwhile, QEMU will avoid to open a
> /dev/vfio/group_id multiple times, so current vfio/QEMU works well for 
> non- singleton group (no vIOMMU). Unfortunately, looks like we have no way
> to fail vfio-mdev-pci devices in similar mechanism as each mdev has a separate
> group. So yes, I agree with you that we may fail it around the group attach
> phase. Below is my draft idea:
> 
> In vfio_iommu_type1_attach_group(), we need to do the following checks.
> 
> if (mdev_group) {
> 	if (iommu_device group enabled aux-domain) {
> 		/*
> 		  * iommu_group enabled aux-domain means the iommu_devices
> 		  * in this group are aux-domain enabled. e.g. SIOV capable devices.
> 		  * Also, I think for aux-domain enabled group, it essentially means
> 		  * the group is a singleton group as SIOV capable devices require
> 		  * to be in a singleton group.
> 		  */
> 		 iommu_aux_attach_device();
> 	} else {
> 		/*
> 		  * needs to check the group->opened in vfio.c. Just like what
> 		  * vfio_group_fopen() does. May be a new VFIO interface required
> 		  * here since the group->opened is within vfio.c.
> 		  * vfio_iommu_device_group_opened_inc() will inc group->opened, so
> 		  * that other VM will fail when trying to open the group. And another
> 		  * VFIO interface is also required to dec group->opened when VM is
> 		  * down.
> 		  */
> 		if (vfio_iommu_device_group_opened_inc(iommu_device_group))
> 			return -EBUSY;
> 		iommu_attach_gorup(iommu_device_group);
> 	}
> }
> 
> The concern here is the two new VFIO interfaces. Any thoughts on this proposal? :-)
> 
> > It's really unfortunate that we don't have the mdev inheriting the
> > iommu group of the iommu_device so that userspace can really understand
> > this relationship.  A separate group makes sense for the aux-domain
> > case, and is (I guess) not a significant issue in the case of a
> > singleton iommu_device group, but it's pretty awkward here.  Perhaps
> > this is something we should correct in design of iommu backed mdevs.  
> 
> Yeah, for aux-domain case, it is not significant issue as aux-domain essentially
> means singleton iommu_devie group. And in early time, when designing the support
> for wrap pci as a mdev, we also considered to let vfio-mdev-pci to reuse
> iommu_device group. But this results in an iommu backed group includes mdev and
> physical devices, which might also be strange. Do you think it is valuable to reconsider
> it?

From a group perspective, the cleanest solution would seem to be that
IOMMU backed mdevs w/o aux domain support should inherit the IOMMU
group of the iommu_device, but I think the barrier here is that we have
a difficult time determining if the group is "viable" in that case.
For example a group where one devices is bound to a native host driver
and the other device bound to a vfio driver would typically be
considered non-viable as it breaks the isolation guarantees.  However
I think in this configuration, the parent device is effectively
participating in the isolation and "donating" its iommu group on behalf
of the mdev device.  I don't think we can simultaneously use that iommu
group for any other purpose.  I'm sure we could come up with a way for
vifo-core to understand this relationship and add it to the white list,
I wonder though how confusing this might be to users who now understand
the group/driver requirement to be "all endpoints bound to vfio
drivers".  This might still be the best approach regardless of this.
Thanks,

Alex
