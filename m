Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79ADA4ECAC
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 17:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfFUP5o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 11:57:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfFUP5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 11:57:44 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 87A98811DC;
        Fri, 21 Jun 2019 15:57:43 +0000 (UTC)
Received: from x1.home (ovpn-117-35.phx2.redhat.com [10.3.117.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 490C25B689;
        Fri, 21 Jun 2019 15:57:41 +0000 (UTC)
Date:   Fri, 21 Jun 2019 09:57:40 -0600
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
Message-ID: <20190621095740.41e6e98e@x1.home>
In-Reply-To: <A2975661238FB949B60364EF0F2C257439F02663@SHSMSX104.ccr.corp.intel.com>
References: <1560000071-3543-1-git-send-email-yi.l.liu@intel.com>
        <1560000071-3543-10-git-send-email-yi.l.liu@intel.com>
        <20190619222647.72efc76a@x1.home>
        <A2975661238FB949B60364EF0F2C257439F0164E@SHSMSX104.ccr.corp.intel.com>
        <20190620150757.7b2fa405@x1.home>
        <A2975661238FB949B60364EF0F2C257439F02663@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 21 Jun 2019 15:57:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Jun 2019 10:23:10 +0000
"Liu, Yi L" <yi.l.liu@intel.com> wrote:

> Hi Alex,
> 
> > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > Sent: Friday, June 21, 2019 5:08 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > 
> > On Thu, 20 Jun 2019 13:00:34 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > Hi Alex,
> > >  
> > > > From: Alex Williamson [mailto:alex.williamson@redhat.com]
> > > > Sent: Thursday, June 20, 2019 12:27 PM
> > > > To: Liu, Yi L <yi.l.liu@intel.com>
> > > > Subject: Re: [PATCH v1 9/9] smaples: add vfio-mdev-pci driver
> > > >
> > > > On Sat,  8 Jun 2019 21:21:11 +0800
> > > > Liu Yi L <yi.l.liu@intel.com> wrote:
> > > >  
> > > > > This patch adds sample driver named vfio-mdev-pci. It is to wrap
> > > > > a PCI device as a mediated device. For a pci device, once bound
> > > > > to vfio-mdev-pci driver, user space access of this device will
> > > > > go through vfio mdev framework. The usage of the device follows
> > > > > mdev management method. e.g. user should create a mdev before
> > > > > exposing the device to user-space.  
> [...]
> > >  
> > > > However, the patch below just makes the mdev interface behave
> > > > correctly, I can't make it work on my system because commit
> > > > 7bd50f0cd2fd ("vfio/type1: Add domain at(de)taching group helpers")  
> > >
> > > What error did you encounter. I tested the patch with a device in a
> > > singleton iommu group. I'm also searching a proper machine with
> > > multiple devices in an iommu group and test it.  
> > 
> > In vfio_iommu_type1, iommu backed mdev devices use the
> > iommu_attach_device() interface, which includes:
> > 
> >         if (iommu_group_device_count(group) != 1)
> >                 goto out_unlock;
> > 
> > So it's impossible to use with non-singleton groups currently.  
> 
> Hmmm, I think it is no longer good to use iommu_attach_device() for iommu
> backed mdev devices now. In this flow, the purpose here is to attach a device
> to a domain and no need to check whether the device is in a singleton iommu
> group. I think it would be better to use __iommu_attach_device() instead of
> iommu_attach_device().

That's a static and unexported, it's intentionally not an exposed
interface.  We can't attach devices in the same group to separate
domains allocated through iommu_domain_alloc(), this would violate the
iommu group isolation principles.

> Also I found a potential mutex lock issue if using iommu_attach_device().
> In vfio_iommu_attach_group(), it uses iommu_group_for_each_dev() to loop
> all the devices in the group. It holds group->mutex. And then vfio_mdev_attach_domain()
> calls iommu_attach_device() which also tries to get group->mutex. This would be
> an issue. If you are fine with it, I may post another patch for it. :-)

Gack, yes, please send a patch.

> > > > used iommu_attach_device() rather than iommu_attach_group() for non-aux
> > > > mdev iommu_device.  Is there a requirement that the mdev parent device
> > > > is in a singleton iommu group?  
> > >
> > > I don't think there should have such limitation. Per my understanding,
> > > vfio-mdev-pci should also be able to bind to devices which shares
> > > iommu group with other devices. vfio-pci works well for such devices.
> > > And since the two drivers share most of the codes, I think vfio-mdev-pci
> > > should naturally support it as well.  
> > 
> > Yes, the difference though is that vfio.c knows when devices are in the
> > same group, which mdev vfio.c only knows about the non-iommu backed
> > group, not the group that is actually used for the iommu backing.  So
> > we either need to enlighten vfio.c or further abstract those details in
> > vfio_iommu_type1.c.  
> 
> Not sure if it is necessary to introduce more changes to vfio.c or
> vfio_iommu_type1.c. If it's only for the scenario which two devices share an
> iommu_group, I guess it could be supported by using __iommu_attach_device()
> which has no device counting for the group. But maybe I missed something
> here. It would be great if you can elaborate a bit for it. :-)

We need to use the group semantics, there's a reason
__iommu_attach_device() is not exposed, it's an internal helper.  I
think there's no way around that we need to somewhere track the actual
group we're attaching to and have the smarts to re-use it for other
devices in the same group.
 
> > > > If this is a simplification, then
> > > > vfio-mdev-pci should not bind to devices where this is violated since
> > > > there's no way to use the device.  Can we support it though?  
> > >
> > > yeah, I think we need to support it.
> > >  
> > > > If I have two devices in the same group and bind them both to
> > > > vfio-mdev-pci, I end up with three groups, one for each mdev device and
> > > > the original physical device group.  vfio.c works with the mdev groups
> > > > and will try to match both groups to the container.  vfio_iommu_type1.c
> > > > also works with the mdev groups, except for the point where we actually
> > > > try to attach a group to a domain, which is the only window where we use
> > > > the iommu_device rather than the provided group, but we don't record
> > > > that anywhere.  Should struct vfio_group have a pointer to a reference
> > > > counted object that tracks the actual iommu_group attached, such that
> > > > we can determine that the group is already attached to the domain and
> > > > not try to attach again?  
> > >
> > > Agreed, we need to avoid such duplicated attach. Instead of adding
> > > reference counted object in vfio_group. I'm also considering the logic
> > > below:  
> 
> Re-walked the code, I find the duplicated attach will happen on the vfio-mdev-pci
> device as vfio_mdev_attach_domain() only attaches the parent devices of
> iommu backed mdevs instead of all the devices within the physical iommu_group.
> While for a vfio-pci device, it will use iommu_attach_group() which attaches all the
> devices within the iommu backed group. The same with detach,
> vfio_mdev_detach_domain() detaches selective devices instead of all devices within
> the iommu backed group.

Yep, that's not good, for the non-aux case we need to follow the usual
group semantics or else we're limited to singleton groups.

> > >     /*
> > >       * Do this check in vfio_iommu_type1_attach_group(), after mdev_group
> > >       * is initialized.
> > >       */
> > >     if (vfio_group->mdev_group) {
> > >          /*
> > >            * vfio_group->mdev_group is true means vfio_group->iommu_group
> > >            * is not the actual iommu_group which is going to be attached to
> > >            * domain. To avoid duplicate iommu_group attach, needs to check if
> > >            * the actual iommu_group. vfio_get_parent_iommu_group() is a
> > >            * newly added helper function which returns the actual attach
> > >            * iommu_group going to be attached for this mdev group.
> > >               */
> > >          p_iommu_group = vfio_get_parent_iommu_group(
> > >                                                                          vfio_group->iommu_group);
> > >          list_for_each_entry(d, &iommu->domain_list, next) {
> > >                  if (find_iommu_group(d, p_iommu_group)) {
> > >                          mutex_unlock(&iommu->lock);
> > >                          // skip group attach;
> > >                  }
> > >          }  
> > 
> > We don't currently create a struct vfio_group for the parent, only for
> > the mdev iommu group.  The iommu_attach for an iommu backed mdev
> > doesn't leave any traces of where it is actually attached, we just
> > count on retracing our steps for the detach.  That's why I'm thinking
> > we need an object somewhere to track it and it needs to be reference
> > counted so that if both a vfio-mdev-pci device and a vfio-pci device
> > are using it, we leave it in place if either one is removed.  
> 
> Hmmm, here we are talking about tracking in iommu_group level though
> no good idea on where the object should  be placed yet. However, we may
> need to tack in device level as I mentioned in above paragraph. If not,
> there may be sequence issue. e.g. if vfio-mdev-pci device is attached
> firstly, then the object will be initialized, and when vfio-pci device is
> attached, we will find the attach should be skipped and just inc the ref count.
> But actually it should not be skipped since the vfio-mdev-pci attach does not
> attach all devices within the iommu backed group.

We can't do that though, the entire group needs to be attached.

> What's more, regards to sIOV case,  a parent devices may have multiple
> mdevs and the mdevs may be assigned to the same VM. Thus there will be multiple
> attach on this parent device. This also makes me believe track in device level would
> be better. 

The aux domain support essentially specifies that the device can be
attached to multiple domains, so I think we're ok for device-level
group attach there, but not for bare iommu backed devices.  Thanks,

Alex
