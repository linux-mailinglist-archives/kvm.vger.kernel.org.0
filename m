Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F193DB23AF
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 17:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388208AbfIMPyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Sep 2019 11:54:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60812 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387739AbfIMPyb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Sep 2019 11:54:31 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C5963058DAA;
        Fri, 13 Sep 2019 15:54:30 +0000 (UTC)
Received: from x1.home (ovpn-118-102.phx2.redhat.com [10.3.118.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C98B60600;
        Fri, 13 Sep 2019 15:54:30 +0000 (UTC)
Date:   Fri, 13 Sep 2019 09:54:29 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Xia, Chenbo" <chenbo.xia@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: mdev live migration support with vfio-mdev-pci
Message-ID: <20190913095429.19f9e080@x1.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D5721C8@SHSMSX104.ccr.corp.intel.com>
References: <A2975661238FB949B60364EF0F2C25743A08FC3F@SHSMSX104.ccr.corp.intel.com>
        <20190912154127.04ed3951@x1.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D5721C8@SHSMSX104.ccr.corp.intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 13 Sep 2019 15:54:30 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Sep 2019 00:28:25 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson
> > Sent: Thursday, September 12, 2019 10:41 PM
> > 
> > On Mon, 9 Sep 2019 11:41:45 +0000
> > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> >   
> > > Hi Alex,
> > >
> > > Recently, we had an internal discussion on mdev live migration support
> > > for SR-IOV. The usage is to wrap VF as mdev and make it migrate-able
> > > when passthru to VMs. It is very alike with the vfio-mdev-pci sample
> > > driver work which also wraps PF/VF as mdev. But there is gap. Current
> > > vfio-mdev-pci driver is a generic driver which has no ability to support
> > > customized regions. e.g. state save/restore or dirty page region which is
> > > important in live migration. To support the usage, there are two  
> > directions:  
> > >
> > > 1) extend vfio-mdev-pci driver to expose interface, let vendor specific
> > > in-kernel module (not driver) to register some ops for live migration.
> > > Thus to support customized regions. In this direction, vfio-mdev-pci
> > > driver will be in charge of the hardware. The in-kernel vendor specific
> > > module is just to provide customized region emulation.
> > > - Pros: it will be helpful if we want to expose some user-space ABI in
> > >         future since it is a generic driver.
> > > - Cons: no apparent cons per me, may keep me honest, my folks.
> > >
> > > 2) further abstract out the generic parts in vfio-mdev-driver to be a library
> > > and let vendor driver to call the interfaces exposed by this library. e.g.
> > > provides APIs to wrap a VF as mdev and make a non-singleton iommu
> > > group to be vfio viable when a vendor driver wants to wrap a VF as a
> > > mdev. In this direction, device driver still in charge of hardware.
> > > - Pros: devices driver still owns the device, which looks to be more
> > >         "reasonable".
> > > - Cons: no apparent cons, may be unable to have unified user space ABI if
> > >         it's needed in future.
> > >
> > > Any thoughts on the above usage and the two directions? Also, Kevin, Yan,
> > > Shaopeng could keep me honest if anything missed.  
> > 
> > A concern with 1) is that we specifically made the vfio-mdev-pci driver
> > a sample driver to avoid user confusion over when to use vfio-pci vs
> > when to use vfio-mdev-pci.  This use case suggests vfio-mdev-pci
> > becoming a peer of vfio-pci when really I think it was meant only as a
> > demo of IOMMU backed mdev devices and perhaps a starting point for
> > vendors wanting to create an mdev wrapper around real hardware.  I
> > had assumed that in the latter case, the sample driver would be forked.
> > Do these new suggestions indicate we're deprecating vfio-pci?  I'm not
> > necessarily in favor of that. Couldn't we also have device specific
> > extensions of vfio-pci that could provide migration support for a
> > physical device?  Do we really want to add the usage burden of the mdev
> > sysfs interface if we're only adding migration to a VF?  Maybe instead
> > we should add common helpers for migration that could be used by either
> > vfio-pci or vendor specific mdev drivers.  Ideally I think that if
> > we're not trying to multiplex a device into multiple mdevs or trying
> > to supplement a device that would be incomplete without mdev, and only
> > want to enable migration for a PF/VF, we'd bind it to vfio-pci and those
> > features would simply appear for device we've enlightened vfio-pci to
> > migrate.  Thanks,
> >   
> 
> That would be better and simpler. We thought you may want to keep 
> current vfio-pci intact. :-) btw do you prefer to putting device specific 
> migration logic within VFIO, or building some mechanism for PF/VF driver 
> to register and handle? The former is fully constrained with VFIO but
> moving forward may get complex. The latter keeps the VFIO clean and
> reuses existing driver logic thus simpler, just that PF/VF driver enters
> a special mode in which it's not bound to the PF/VF device (vfio-pci is
> the actual driver) and simply acts as callbacks to handler device specific
> migration request.

I'm not sure how this native device driver registration would work, is
seems troublesome for the user.  vfio-pci already has optional support
for IGD extensions.  I imagine it would be similar to that, but we may
try to modularize it within vfio-pci, perhaps similar to how Eric
supports resets on vfio-platform.  There's also an issue with using the
native driver that users cannot then blacklist the native driver if
they only intend to use the device with vfio-pci.  It's probably best
to keep it contained, but modular within vfio-pci.  Thanks,

Alex
