Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A32D316B7D
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 17:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbhBJQle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 11:41:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232306AbhBJQjX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 10 Feb 2021 11:39:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612975076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bMYUVolCX8etXcsoI4Smye10LqcwPKuQiClDt37lmPE=;
        b=OE44on5PIrx5L/VWYvJO93mpIZmjJAsUt2e6Tmn9CumSxckn8+chjLjEdU+PsAcLAiqg5B
        Q9zMtXkPTcldsNrrIh5xDEXPy+cMiuIXw2dpY2nDnpxEPsXIAwk0EI1biKgz39qHOdSgG6
        MAgpA6Lp6NOJRRykKIrSBrkqXp/lp60=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-570-BmNFSAQ_PCWJSpM_Y9f6BA-1; Wed, 10 Feb 2021 11:37:52 -0500
X-MC-Unique: BmNFSAQ_PCWJSpM_Y9f6BA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2F721934103;
        Wed, 10 Feb 2021 16:37:48 +0000 (UTC)
Received: from omen.home.shazbot.org (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 504BB5D9D0;
        Wed, 10 Feb 2021 16:37:47 +0000 (UTC)
Date:   Wed, 10 Feb 2021 09:37:46 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "liranl@nvidia.com" <liranl@nvidia.com>,
        "oren@nvidia.com" <oren@nvidia.com>,
        "tzahio@nvidia.com" <tzahio@nvidia.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "yarong@nvidia.com" <yarong@nvidia.com>,
        "aviadye@nvidia.com" <aviadye@nvidia.com>,
        "shahafs@nvidia.com" <shahafs@nvidia.com>,
        "artemp@nvidia.com" <artemp@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "ACurrid@nvidia.com" <ACurrid@nvidia.com>,
        "gmataev@nvidia.com" <gmataev@nvidia.com>,
        "cjia@nvidia.com" <cjia@nvidia.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH v2 0/9] Introduce vfio-pci-core subsystem
Message-ID: <20210210093746.7736b25c@omen.home.shazbot.org>
In-Reply-To: <20210210133452.GW4247@nvidia.com>
References: <20210201162828.5938-1-mgurtovoy@nvidia.com>
        <MWHPR11MB18867A429497117960344A798C8D9@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210210133452.GW4247@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 10 Feb 2021 09:34:52 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Feb 10, 2021 at 07:52:08AM +0000, Tian, Kevin wrote:
> > > This subsystem framework will also ease on adding vendor specific
> > > functionality to VFIO devices in the future by allowing another module
> > > to provide the pci_driver that can setup number of details before
> > > registering to VFIO subsystem (such as inject its own operations). =20
> >=20
> > I'm a bit confused about the change from v1 to v2, especially about
> > how to inject module specific operations. From live migration p.o.v
> > it may requires two hook points at least for some devices (e.g. i40e=20
> > in original Yan's example): =20
>=20
> IMHO, it was too soon to give up on putting the vfio_device_ops in the
> final driver- we should try to define a reasonable public/private
> split of vfio_pci_device as is the norm in the kernel. No reason we
> can't achieve that.
>=20
> >  register a migration region and intercept guest writes to specific
> > registers. [PATCH 4/9] demonstrates the former but not the latter
> > (which is allowed in v1). =20
>=20
> And this is why, the ROI to wrapper every vfio op in a PCI op just to
> keep vfio_pci_device completely private is poor :(

Says someone who doesn't need to maintain the core, fixing bugs and
adding features, while not breaking vendor driver touching private data
in unexpected ways ;)

> > Then another question. Once we have this framework in place, do we=20
> > mandate this approach for any vendor specific tweak or still allow
> > doing it as vfio_pci_core extensions (such as igd and zdev in this
> > series)? =20
>=20
> I would say no to any further vfio_pci_core extensions that are tied
> to specific PCI devices. Things like zdev are platform features, they
> are not tied to specific PCI devices
>=20
> > If the latter, what is the criteria to judge which way is desired? Also=
 what=20
> > about the scenarios where we just want one-time vendor information,=20
> > e.g. to tell whether a device can tolerate arbitrary I/O page faults [1=
] or
> > the offset in VF PCI config space to put PASID/ATS/PRI capabilities [2]?
> > Do we expect to create a module for each device to provide such info?
> > Having those questions answered is helpful for better understanding of
> > this proposal IMO. =F0=9F=98=8A
> >=20
> > [1] https://lore.kernel.org/kvm/d4c51504-24ed-2592-37b4-f390b97fdd00@hu=
awei.com/T/ =20
>=20
> SVA is a platform feature, so no problem. Don't see a vfio-pci change
> in here?
>=20
> > [2] https://lore.kernel.org/kvm/20200407095801.648b1371@w520.home/ =20
>=20
> This one could have been done as a broadcom_vfio_pci driver. Not sure
> exposing the entire config space unprotected is safe, hard to know
> what the device has put in there, and if it is secure to share with a
> guest..

The same argument could be made about the whole device, not just config
space.  In fact we know that devices like GPUs provide access to config
space through other address spaces, I/O port and MMIO BARs.  Config
space is only the architected means to manipulate the link interface
and device features, we can't determine if it's the only means.  Any
emulation or access restrictions we put in config space are meant to
make the device work better for the user (ex. re-using host kernel
device quirks) or prevent casual misconfiguration (ex. incompatible mps
settings, BAR registers), the safety of assigning a device to a user
is only as good as the isolation and error handling that the platform
allows.

=20
> > MDEV core is already a well defined subsystem to connect mdev
> > bus driver (vfio-mdev) and mdev device driver (mlx5-mdev). =20
>=20
> mdev is two things
>=20
>  - a driver core bus layer and sysfs that makes a lifetime model
>  - a vfio bus driver that doesn't do anything but forward ops to the
>    main ops
>=20
> > vfio-mdev is just the channel to bring VFIO APIs through mdev core
> > to underlying vendor specific mdev device driver, which is already
> > granted flexibility to tweak whatever needs through mdev_parent_ops. =20
>=20
> This is the second thing, and it could just be deleted. The actual
> final mdev driver can just use vfio_device_ops directly. The
> redirection shim in vfio_mdev.c doesn't add value.
>=20
> > Then what exact extension is talked here by creating another subsystem
> > module? or are we talking about some general library which can be
> > shared by underlying mdev device drivers to reduce duplicated
> > emulation code? =20
>=20
> IMHO it is more a design philosophy that the end driver should
> implement the vfio_device_ops directly vs having a stack of ops
> structs.

And that's where turning vfio-pci into a vfio-pci-core library comes
in, lowering the bar for a vendor driver to re-use what vfio-pci has
already done.  This doesn't change the basic vfio architecture that
already allows any vendor driver to register with its own
vfio_device_ops, it's just code-reuse, which only makes sense if we're
not just shifting the support burden from the vendor driver to the new
library-ized core.  Like Kevin though, I don't really understand the
hand-wave application to mdev.  Sure, vfio-mdev could be collapsed now
that we've rejected that there could be other drivers binding to mdev
devices, but mdev-core provides a common lifecycle management within a
class of devices, so if you subscribe to mdev, your vendor driver is
providing essentially vfio_device_ops plus the mdev extra callbacks.
If your vendor driver doesn't subscribe to that lifecycle, then just
implement a vfio bus driver with your own vfio_device_ops.  The nature
of that mdev lifecycle doesn't seem to mesh well with a library that
expects to manage a whole physical PCI device though.  Thanks,

Alex

