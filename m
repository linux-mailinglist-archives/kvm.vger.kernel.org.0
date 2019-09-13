Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75E7B16E1
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 02:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbfIMA23 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 12 Sep 2019 20:28:29 -0400
Received: from mga17.intel.com ([192.55.52.151]:46674 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfIMA23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 20:28:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 17:28:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="336745124"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by orsmga004.jf.intel.com with ESMTP; 12 Sep 2019 17:28:28 -0700
Received: from fmsmsx118.amr.corp.intel.com (10.18.116.18) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 12 Sep 2019 17:28:28 -0700
Received: from shsmsx106.ccr.corp.intel.com (10.239.4.159) by
 fmsmsx118.amr.corp.intel.com (10.18.116.18) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 12 Sep 2019 17:28:28 -0700
Received: from shsmsx104.ccr.corp.intel.com ([169.254.5.32]) by
 SHSMSX106.ccr.corp.intel.com ([169.254.10.86]) with mapi id 14.03.0439.000;
 Fri, 13 Sep 2019 08:28:26 +0800
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "He, Shaopeng" <shaopeng.he@intel.com>,
        "Xia, Chenbo" <chenbo.xia@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: mdev live migration support with vfio-mdev-pci
Thread-Topic: mdev live migration support with vfio-mdev-pci
Thread-Index: AdVnA09V4FzczbJgRN2UKw0Ev4IjjgCMcrOAACTLjpA=
Date:   Fri, 13 Sep 2019 00:28:25 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D19D5721C8@SHSMSX104.ccr.corp.intel.com>
References: <A2975661238FB949B60364EF0F2C25743A08FC3F@SHSMSX104.ccr.corp.intel.com>
 <20190912154127.04ed3951@x1.home>
In-Reply-To: <20190912154127.04ed3951@x1.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTBhNDBhYzItOTNhMC00OWU3LWEyYzItNDAwNzg1NDA0N2U4IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTUJYMmpFclpMR29uMXU4NDJXeXJ5MGNiVWd6MjhHWHpydERxc0ZMVHZJT3ErWkxMRDVhOE4rMzlvVE9KeGJ0WCJ9
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson
> Sent: Thursday, September 12, 2019 10:41 PM
> 
> On Mon, 9 Sep 2019 11:41:45 +0000
> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
> 
> > Hi Alex,
> >
> > Recently, we had an internal discussion on mdev live migration support
> > for SR-IOV. The usage is to wrap VF as mdev and make it migrate-able
> > when passthru to VMs. It is very alike with the vfio-mdev-pci sample
> > driver work which also wraps PF/VF as mdev. But there is gap. Current
> > vfio-mdev-pci driver is a generic driver which has no ability to support
> > customized regions. e.g. state save/restore or dirty page region which is
> > important in live migration. To support the usage, there are two
> directions:
> >
> > 1) extend vfio-mdev-pci driver to expose interface, let vendor specific
> > in-kernel module (not driver) to register some ops for live migration.
> > Thus to support customized regions. In this direction, vfio-mdev-pci
> > driver will be in charge of the hardware. The in-kernel vendor specific
> > module is just to provide customized region emulation.
> > - Pros: it will be helpful if we want to expose some user-space ABI in
> >         future since it is a generic driver.
> > - Cons: no apparent cons per me, may keep me honest, my folks.
> >
> > 2) further abstract out the generic parts in vfio-mdev-driver to be a library
> > and let vendor driver to call the interfaces exposed by this library. e.g.
> > provides APIs to wrap a VF as mdev and make a non-singleton iommu
> > group to be vfio viable when a vendor driver wants to wrap a VF as a
> > mdev. In this direction, device driver still in charge of hardware.
> > - Pros: devices driver still owns the device, which looks to be more
> >         "reasonable".
> > - Cons: no apparent cons, may be unable to have unified user space ABI if
> >         it's needed in future.
> >
> > Any thoughts on the above usage and the two directions? Also, Kevin, Yan,
> > Shaopeng could keep me honest if anything missed.
> 
> A concern with 1) is that we specifically made the vfio-mdev-pci driver
> a sample driver to avoid user confusion over when to use vfio-pci vs
> when to use vfio-mdev-pci.  This use case suggests vfio-mdev-pci
> becoming a peer of vfio-pci when really I think it was meant only as a
> demo of IOMMU backed mdev devices and perhaps a starting point for
> vendors wanting to create an mdev wrapper around real hardware.  I
> had assumed that in the latter case, the sample driver would be forked.
> Do these new suggestions indicate we're deprecating vfio-pci?  I'm not
> necessarily in favor of that. Couldn't we also have device specific
> extensions of vfio-pci that could provide migration support for a
> physical device?  Do we really want to add the usage burden of the mdev
> sysfs interface if we're only adding migration to a VF?  Maybe instead
> we should add common helpers for migration that could be used by either
> vfio-pci or vendor specific mdev drivers.  Ideally I think that if
> we're not trying to multiplex a device into multiple mdevs or trying
> to supplement a device that would be incomplete without mdev, and only
> want to enable migration for a PF/VF, we'd bind it to vfio-pci and those
> features would simply appear for device we've enlightened vfio-pci to
> migrate.  Thanks,
> 

That would be better and simpler. We thought you may want to keep 
current vfio-pci intact. :-) btw do you prefer to putting device specific 
migration logic within VFIO, or building some mechanism for PF/VF driver 
to register and handle? The former is fully constrained with VFIO but
moving forward may get complex. The latter keeps the VFIO clean and
reuses existing driver logic thus simpler, just that PF/VF driver enters
a special mode in which it's not bound to the PF/VF device (vfio-pci is
the actual driver) and simply acts as callbacks to handler device specific
migration request. 

Thanks
Kevin
