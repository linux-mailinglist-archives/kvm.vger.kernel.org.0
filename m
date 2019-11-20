Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E2F10451F
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 21:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfKTUbz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 15:31:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23417 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725815AbfKTUbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 15:31:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574281913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HHSSmYMXHPsKCs1Q6EW/xg8P7KSA2E1ZxvHaD/SQD+8=;
        b=SwUQouyf1A/r16fwwuFjfa+yEiGYH4fGav3pBjARnDVING6MsUvJtokAWtIcTaSVEZ+RdI
        r/NEqlhnnHM8+QfgyEFz5LjtrgQWJ6Lx8Pz+Q48z1YXZpYsyF5k7jmkPMrtSkhmDXpU3aB
        LpLqEOzdr5/RL6QggYDhx/tPRbPpD44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-qq6Z3ilNNdOJ2rDQE6ng1Q-1; Wed, 20 Nov 2019 15:31:52 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75AC88018A3;
        Wed, 20 Nov 2019 20:31:49 +0000 (UTC)
Received: from x1.home (ovpn-116-56.phx2.redhat.com [10.3.116.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 214EF6E3E7;
        Wed, 20 Nov 2019 20:31:48 +0000 (UTC)
Date:   Wed, 20 Nov 2019 13:31:47 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     <lantianyu1986@gmail.com>, <cohuck@redhat.com>,
        "KY Srinivasan" <kys@microsoft.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "Stephen Hemminger" <sthemmin@microsoft.com>, <sashal@kernel.org>,
        <mchehab+samsung@kernel.org>, <davem@davemloft.net>,
        <gregkh@linuxfoundation.org>, <robh@kernel.org>,
        <Jonathan.Cameron@huawei.com>, <paulmck@linux.ibm.com>,
        "Michael Kelley" <mikelley@microsoft.com>,
        "Tianyu Lan" <Tianyu.Lan@microsoft.com>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-hyperv@vger.kernel.org>, "vkuznets" <vkuznets@redhat.com>
Subject: Re: [PATCH] VFIO/VMBUS: Add VFIO VMBUS driver support
Message-ID: <20191120133147.1d627348@x1.home>
In-Reply-To: <20191120114611.4721a7e9@hermes.lan>
References: <20191111084507.9286-1-Tianyu.Lan@microsoft.com>
        <20191119165620.0f42e5ba@x1.home>
        <20191120103503.5f7bd7c4@hermes.lan>
        <20191120120715.0cecf5ea@x1.home>
        <20191120114611.4721a7e9@hermes.lan>
Organization: Red Hat
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: qq6Z3ilNNdOJ2rDQE6ng1Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 20 Nov 2019 11:46:11 -0800
Stephen Hemminger <stephen@networkplumber.org> wrote:

> On Wed, 20 Nov 2019 12:07:15 -0700
> Alex Williamson <alex.williamson@redhat.com> wrote:
>=20
> > On Wed, 20 Nov 2019 10:35:03 -0800
> > Stephen Hemminger <stephen@networkplumber.org> wrote:
> >  =20
> > > On Tue, 19 Nov 2019 15:56:20 -0800
> > > "Alex Williamson" <alex.williamson@redhat.com> wrote:
> > >    =20
> > > > On Mon, 11 Nov 2019 16:45:07 +0800
> > > > lantianyu1986@gmail.com wrote:
> > > >      =20
> > > > > From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> > > > >=20
> > > > > This patch is to add VFIO VMBUS driver support in order to expose
> > > > > VMBUS devices to user space drivers(Reference Hyper-V UIO driver)=
.
> > > > > DPDK now has netvsc PMD driver support and it may get VMBUS resou=
rces
> > > > > via VFIO interface with new driver support.
> > > > >=20
> > > > > So far, Hyper-V doesn't provide virtual IOMMU support and so this
> > > > > driver needs to be used with VFIO noiommu mode.       =20
> > > >=20
> > > > Let's be clear here, vfio no-iommu mode taints the kernel and was a
> > > > compromise that we can re-use vfio-pci in its entirety, so it had a
> > > > high code reuse value for minimal code and maintenance investment. =
 It
> > > > was certainly not intended to provoke new drivers that rely on this=
 mode
> > > > of operation.  In fact, no-iommu should be discouraged as it provid=
es
> > > > absolutely no isolation.  I'd therefore ask, why should this be in =
the
> > > > kernel versus any other unsupportable out of tree driver?  It appea=
rs
> > > > almost entirely self contained.  Thanks,
> > > >=20
> > > > Alex     =20
> > >=20
> > > The current VMBUS access from userspace is from uio_hv_generic
> > > there is (and will not be) any out of tree driver for this.   =20
> >=20
> > I'm talking about the driver proposed here.  It can only be used in a
> > mode that taints the kernel that its running on, so why would we sign
> > up to support 400 lines of code that has no safe way to use it?
> >   =20
> > > The new driver from Tianyu is to make VMBUS behave like PCI.
> > > This simplifies the code for DPDK and other usermode device drivers
> > > because it can use the same API's for VMBus as is done for PCI.   =20
> >=20
> > But this doesn't re-use the vfio-pci API at all, it explicitly defines
> > a new vfio-vmbus API over the vfio interfaces.  So a user mode driver
> > might be able to reuse some vfio support, but I don't see how this has
> > anything to do with PCI.
> >  =20
> > > Unfortunately, since Hyper-V does not support virtual IOMMU yet,
> > > the only usage modle is with no-iommu taint.   =20
> >=20
> > Which is what makes it unsupportable and prompts the question why it
> > should be included in the mainline kernel as it introduces a
> > maintenance burden and normalizes a usage model that's unsafe.  Thanks,=
 =20
>=20
> Many existing userspace drivers are unsafe:
>   - out of tree DPDK igb_uio is unsafe.

Why is it out of tree?

>   - VFIO with noiommu is unsafe.

Which taints the kernel and requires raw I/O user privs.

>   - hv_uio_generic is unsafe.

Gosh, it's pretty coy about this, no kernel tainting, no user
capability tests, no scary dmesg or Kconfig warnings.  Do users know
it's unsafe?

> This new driver is not any better or worse. This sounds like a complete
> repeat of the discussion that occurred before introducing VFIO noiommu mo=
de.
>=20
> Shouldn't vmbus vfio taint the kernel in the same way as vfio noiommu doe=
s?

Yes, the no-iommu interaction happens at the vfio-core level.  I can't
speak for any of the uio interfaces you mention, but I know that
uio_pci_generic is explicitly intended for non-DMA use cases and in
fact the efforts to enable MSI/X support in that driver and the
objections raised for breaking that usage model by the maintainer, is
what triggered no-iommu support for vfio.  IIRC, the rationale was
largely for code reuse both at the kernel and userspace driver level,
while imposing a minimal burden in vfio-core for this dummy iommu
driver.  vfio explicitly does not provide a DMA mapping solution for
no-iommu use cases because I'm not willing to maintain any more lines
of code to support this usage model.  The tainting imposed by this model
and incomplete API was intended to be a big warning to discourage its
use and as features like vIOMMU become more prevalent and bare metal
platforms without physical IOMMUs hopefully become less prevalent,
maybe no-iommu could be phased out or removed.

You might consider this a re-hashing of those previous discussions, but
to me it seems like taking advantage of and promoting an interface that
should have plenty of warning signs that this is not a safe way to use
the device from userspace.  Without some way to take advantage of the
code in a safe way, this just seems to be normalizing an unsupportable
usage model.  Thanks,

Alex

