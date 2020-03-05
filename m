Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1DF717AD5A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 18:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbgCEReR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 12:34:17 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21527 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725938AbgCEReQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 12:34:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583429655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q5Ztb+ebP7ko84zmTyGjqclC5MVj66P6wDuPjxw8z+k=;
        b=HfXliJ8vxpJzaL+gI98UQkZ03xcY8vo+obRdKKnPr4Lfy36EX5TQFFioTe6e8b7BPl1eNG
        1FQCBX72AyUz47c7DNXU0dGX5oWhq6kdxlqhZnmFHx5c+Quf89twomeiHyXDVsXq0izjlx
        AEHbzwvn7hSoLBCGRcQxvJVLf6l1SvE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-9vNhKWGMNJKBwHM2O6mVpQ-1; Thu, 05 Mar 2020 12:34:04 -0500
X-MC-Unique: 9vNhKWGMNJKBwHM2O6mVpQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7884D107ACCA;
        Thu,  5 Mar 2020 17:34:02 +0000 (UTC)
Received: from w520.home (ovpn-116-28.phx2.redhat.com [10.3.116.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 773DA272D3;
        Thu,  5 Mar 2020 17:34:00 +0000 (UTC)
Date:   Thu, 5 Mar 2020 10:33:59 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dev@dpdk.org" <dev@dpdk.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "thomas@monjalon.net" <thomas@monjalon.net>,
        "bluca@debian.org" <bluca@debian.org>,
        "jerinjacobk@gmail.com" <jerinjacobk@gmail.com>,
        "Richardson, Bruce" <bruce.richardson@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v2 0/7] vfio/pci: SR-IOV support
Message-ID: <20200305103359.4467f97f@w520.home>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D79A8A7@SHSMSX104.ccr.corp.intel.com>
References: <158213716959.17090.8399427017403507114.stgit@gimli.home>
        <AADFC41AFE54684AB9EE6CBC0274A5D19D79A8A7@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

Sorry for the delay, I've been out on PTO...

On Tue, 25 Feb 2020 02:33:27 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Alex Williamson
> > Sent: Thursday, February 20, 2020 2:54 AM
> >=20
> > Changes since v1 are primarily to patch 3/7 where the commit log is
> > rewritten, along with option parsing and failure logging based on
> > upstream discussions.  The primary user visible difference is that
> > option parsing is now much more strict.  If a vf_token option is
> > provided that cannot be used, we generate an error.  As a result of
> > this, opening a PF with a vf_token option will serve as a mechanism of
> > setting the vf_token.  This seems like a more user friendly API than
> > the alternative of sometimes requiring the option (VFs in use) and
> > sometimes rejecting it, and upholds our desire that the option is
> > always either used or rejected.
> >=20
> > This also means that the VFIO_DEVICE_FEATURE ioctl is not the only
> > means of setting the VF token, which might call into question whether
> > we absolutely need this new ioctl.  Currently I'm keeping it because I
> > can imagine use cases, for example if a hypervisor were to support
> > SR-IOV, the PF device might be opened without consideration for a VF
> > token and we'd require the hypservisor to close and re-open the PF in
> > order to set a known VF token, which is impractical.
> >=20
> > Series overview (same as provided with v1): =20
>=20
> Thanks for doing this!=20
>=20
> >=20
> > The synopsis of this series is that we have an ongoing desire to drive
> > PCIe SR-IOV PFs from userspace with VFIO.  There's an immediate need
> > for this with DPDK drivers and potentially interesting future use =20
>=20
> Can you provide a link to the DPDK discussion?

There's a thread here which proposed an out-of-tree driver that enables
a parallel sr-iov enabling interface for a vfio-pci own device.
Clearly I felt strongly about it ;)

https://patches.dpdk.org/patch/58810/

Also, documentation for making use of an Intel FPGA device with DPDK
requires the PF bound to igb_uio to support enabling SR-IOV:

https://doc.dpdk.org/guides/bbdevs/fpga_lte_fec.html

> > cases in virtualization.  We've been reluctant to add this support
> > previously due to the dependency and trust relationship between the
> > VF device and PF driver.  Minimally the PF driver can induce a denial
> > of service to the VF, but depending on the specific implementation,
> > the PF driver might also be responsible for moving data between VFs
> > or have direct access to the state of the VF, including data or state
> > otherwise private to the VF or VF driver. =20
>=20
> Just a loud thinking. While the motivation of VF token sounds reasonable
> to me, I'm curious why the same concern is not raised in other usages.
> For example, there is no such design in virtio framework, where the
> virtio device could also be restarted, putting in separate process (vhost=
-user),
> and even in separate VM (virtio-vhost-user), etc. Of course the para-
> virtualized attribute of virtio implies some degree of trust, but as you
> mentioned many SR-IOV implementations support VF->PF communication
> which also implies some level of trust. It's perfectly fine if VFIO just =
tries
> to do better than other sub-systems, but knowing how other people
> tackle the similar problem may make the whole picture clearer. =F0=9F=98=
=8A
>=20
> +Jason.

We can follow the thread with Jason, but I can't really speak to
whether virtio needs something similar or doesn't provide enough PF
access to be concerned.  If they need a similar solution, we can
collaborate, but the extension we're defining here is specifically part
of the vfio-pci ABI, so it might not be easily portable to virtio.

> > To help resolve these concerns, we introduce a VF token into the VFIO
> > PCI ABI, which acts as a shared secret key between drivers.  The
> > userspace PF driver is required to set the VF token to a known value
> > and userspace VF drivers are required to provide the token to access
> > the VF device.  If a PF driver is restarted with VF drivers in use, it
> > must also provide the current token in order to prevent a rogue
> > untrusted PF driver from replacing a known driver.  The degree to
> > which this new token is considered secret is left to the userspace
> > drivers, the kernel intentionally provides no means to retrieve the
> > current token. =20
>=20
> I'm wondering whether the token idea can be used beyond SR-IOV, e.g.
> (1) we may allow vfio user space to manage Scalable IOV in the future,
> which faces the similar challenge between the PF and mdev; (2) the
> token might be used as a canonical way to replace off-tree acs-override
> workaround, say, allowing the admin to assign devices within the=20
> same iommu group to different VMs which trust each other. I'm not
> sure how much complexity will be further introduced, but it's greatly
> appreciated if you can help think a bit and if feasible abstract some=20
> logic in vfio core layer for such potential usages...

I don't see how this can be used for ACS override.  Lacking ACS, we
must assume lack of DMA isolation, which results in our IOMMU grouping.
If we split IOMMU groups, that implies something that doesn't exist.  A
user can already create a process that can own the vfio group and pass
vfio devices to other tasks, with the restriction of having a single
DMA address space.  If there is DMA isolation, then an mdev solution
might be better, but given the IOMMU integration of SIOV, I'm not sure
why the devices wouldn't simply be placed in separate groups by the
IOMMU driver.  Thanks,

Alex
=20
> > Note that the above token is only required for this new model where
> > both the PF and VF devices are usable through vfio-pci.  Existing
> > models of VFIO drivers where the PF is used without SR-IOV enabled
> > or the VF is bound to a userspace driver with an in-kernel, host PF
> > driver are unaffected.
> >=20
> > The latter configuration above also highlights a new inverted scenario
> > that is now possible, a userspace PF driver with in-kernel VF drivers.
> > I believe this is a scenario that should be allowed, but should not be
> > enabled by default.  This series includes code to set a default
> > driver_override for VFs sourced from a vfio-pci user owned PF, such
> > that the VFs are also bound to vfio-pci.  This model is compatible
> > with tools like driverctl and allows the system administrator to
> > decide if other bindings should be enabled.  The VF token interface
> > above exists only between vfio-pci PF and VF drivers, once a VF is
> > bound to another driver, the administrator has effectively pronounced
> > the device as trusted.  The vfio-pci driver will note alternate
> > binding in dmesg for logging and debugging purposes.
> >=20
> > Please review, comment, and test.  The example QEMU implementation
> > provided with the RFC is still current for this version.  Thanks,
> >=20
> > Alex
> >=20
> > RFC:
> > https://lore.kernel.org/lkml/158085337582.9445.17682266437583505502.stg
> > it@gimli.home/
> > v1:
> > https://lore.kernel.org/lkml/158145472604.16827.15751375540102298130.st
> > git@gimli.home/
> >=20
> > ---
> >=20
> > Alex Williamson (7):
> >       vfio: Include optional device match in vfio_device_ops callbacks
> >       vfio/pci: Implement match ops
> >       vfio/pci: Introduce VF token
> >       vfio: Introduce VFIO_DEVICE_FEATURE ioctl and first user
> >       vfio/pci: Add sriov_configure support
> >       vfio/pci: Remove dev_fmt definition
> >       vfio/pci: Cleanup .probe() exit paths
> >=20
> >=20
> >  drivers/vfio/pci/vfio_pci.c         |  383
> > +++++++++++++++++++++++++++++++++--
> >  drivers/vfio/pci/vfio_pci_private.h |   10 +
> >  drivers/vfio/vfio.c                 |   20 +-
> >  include/linux/vfio.h                |    4
> >  include/uapi/linux/vfio.h           |   37 +++
> >  5 files changed, 426 insertions(+), 28 deletions(-) =20
>=20

