Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 213ADB336A
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 04:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfIPCbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Sep 2019 22:31:20 -0400
Received: from mga06.intel.com ([134.134.136.31]:29465 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbfIPCbU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Sep 2019 22:31:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Sep 2019 19:31:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,510,1559545200"; 
   d="scan'208";a="216058516"
Received: from joy-optiplex-7040.sh.intel.com (HELO joy-OptiPlex-7040) ([10.239.13.9])
  by fmsmga002.fm.intel.com with ESMTP; 15 Sep 2019 19:31:17 -0700
Date:   Sun, 15 Sep 2019 22:23:35 -0400
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Xia, Chenbo" <chenbo.xia@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: mdev live migration support with vfio-mdev-pci
Message-ID: <20190916022335.GA11885@joy-OptiPlex-7040>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <A2975661238FB949B60364EF0F2C25743A08FC3F@SHSMSX104.ccr.corp.intel.com>
 <20190912154127.04ed3951@x1.home>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D5721C8@SHSMSX104.ccr.corp.intel.com>
 <20190913095429.19f9e080@x1.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190913095429.19f9e080@x1.home>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 13, 2019 at 09:54:29AM -0600, Alex Williamson wrote:
> On Fri, 13 Sep 2019 00:28:25 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> 
> > > From: Alex Williamson
> > > Sent: Thursday, September 12, 2019 10:41 PM
> > > 
> > > On Mon, 9 Sep 2019 11:41:45 +0000
> > > "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> > >   
> > > > Hi Alex,
> > > >
> > > > Recently, we had an internal discussion on mdev live migration support
> > > > for SR-IOV. The usage is to wrap VF as mdev and make it migrate-able
> > > > when passthru to VMs. It is very alike with the vfio-mdev-pci sample
> > > > driver work which also wraps PF/VF as mdev. But there is gap. Current
> > > > vfio-mdev-pci driver is a generic driver which has no ability to support
> > > > customized regions. e.g. state save/restore or dirty page region which is
> > > > important in live migration. To support the usage, there are two  
> > > directions:  
> > > >
> > > > 1) extend vfio-mdev-pci driver to expose interface, let vendor specific
> > > > in-kernel module (not driver) to register some ops for live migration.
> > > > Thus to support customized regions. In this direction, vfio-mdev-pci
> > > > driver will be in charge of the hardware. The in-kernel vendor specific
> > > > module is just to provide customized region emulation.
> > > > - Pros: it will be helpful if we want to expose some user-space ABI in
> > > >         future since it is a generic driver.
> > > > - Cons: no apparent cons per me, may keep me honest, my folks.
> > > >
> > > > 2) further abstract out the generic parts in vfio-mdev-driver to be a library
> > > > and let vendor driver to call the interfaces exposed by this library. e.g.
> > > > provides APIs to wrap a VF as mdev and make a non-singleton iommu
> > > > group to be vfio viable when a vendor driver wants to wrap a VF as a
> > > > mdev. In this direction, device driver still in charge of hardware.
> > > > - Pros: devices driver still owns the device, which looks to be more
> > > >         "reasonable".
> > > > - Cons: no apparent cons, may be unable to have unified user space ABI if
> > > >         it's needed in future.
> > > >
> > > > Any thoughts on the above usage and the two directions? Also, Kevin, Yan,
> > > > Shaopeng could keep me honest if anything missed.  
> > > 
> > > A concern with 1) is that we specifically made the vfio-mdev-pci driver
> > > a sample driver to avoid user confusion over when to use vfio-pci vs
> > > when to use vfio-mdev-pci.  This use case suggests vfio-mdev-pci
> > > becoming a peer of vfio-pci when really I think it was meant only as a
> > > demo of IOMMU backed mdev devices and perhaps a starting point for
> > > vendors wanting to create an mdev wrapper around real hardware.  I
> > > had assumed that in the latter case, the sample driver would be forked.
> > > Do these new suggestions indicate we're deprecating vfio-pci?  I'm not
> > > necessarily in favor of that. Couldn't we also have device specific
> > > extensions of vfio-pci that could provide migration support for a
> > > physical device?  Do we really want to add the usage burden of the mdev
> > > sysfs interface if we're only adding migration to a VF?  Maybe instead
> > > we should add common helpers for migration that could be used by either
> > > vfio-pci or vendor specific mdev drivers.  Ideally I think that if
> > > we're not trying to multiplex a device into multiple mdevs or trying
> > > to supplement a device that would be incomplete without mdev, and only
> > > want to enable migration for a PF/VF, we'd bind it to vfio-pci and those
> > > features would simply appear for device we've enlightened vfio-pci to
> > > migrate.  Thanks,
> > >   
> > 
> > That would be better and simpler. We thought you may want to keep 
> > current vfio-pci intact. :-) btw do you prefer to putting device specific 
> > migration logic within VFIO, or building some mechanism for PF/VF driver 
> > to register and handle? The former is fully constrained with VFIO but
> > moving forward may get complex. The latter keeps the VFIO clean and
> > reuses existing driver logic thus simpler, just that PF/VF driver enters
> > a special mode in which it's not bound to the PF/VF device (vfio-pci is
> > the actual driver) and simply acts as callbacks to handler device specific
> > migration request.
> 
> I'm not sure how this native device driver registration would work, is
> seems troublesome for the user.  vfio-pci already has optional support
> for IGD extensions.  I imagine it would be similar to that, but we may
> try to modularize it within vfio-pci, perhaps similar to how Eric
> supports resets on vfio-platform.  There's also an issue with using the
> native driver that users cannot then blacklist the native driver if
> they only intend to use the device with vfio-pci.  It's probably best
hi Alex
how about native driver registering a handler which would be chained on
every read/write/ioctl... in vfio_pci_ops?
It will overwrite vfio-pci's default operations if a success is returned
in native driver's handler, or continue to call vfio-pci's default
operations if a positive value (indicating it will not process this param to
this op) is returned.
This native driver can be put to passthrough mode in this case, so no
need to put it to blacklist. 

If no handler is registered from native driver, then just default
vfio-pci driver is installed and native driver can be blacklisted.

Do you think this approach is fine?

Thanks
Yan


> to keep it contained, but modular within vfio-pci.  Thanks,
> Alex
