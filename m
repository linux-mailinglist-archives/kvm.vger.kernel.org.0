Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CEE2ABFD3
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 16:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbgKIP2d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 10:28:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30520 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729289AbgKIP2d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Nov 2020 10:28:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604935711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q4M13rFXdH1RVacgKaE1UkWy4gzYxCZ7aWqF1tml030=;
        b=eJqKEr9/z03kW3hRZ6qCyUBLlnd1AO6mKtjxvkK4B5LBMxAh5dRR9gbzd/YoaCNsTjvLAm
        lZzNx8/WMQuT88+YB69Po+VJcs7Tee0VZVZJe9ublot/g2An4co14bDLmVTJfLx6OsHX7i
        +2oj9YsfZ+mZ1r4yIUGRlEchnPVbG+M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-dQi-tvSrOe6bh5ezzXzt0w-1; Mon, 09 Nov 2020 10:28:28 -0500
X-MC-Unique: dQi-tvSrOe6bh5ezzXzt0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51480809DCE;
        Mon,  9 Nov 2020 15:28:27 +0000 (UTC)
Received: from x1.home (ovpn-112-213.phx2.redhat.com [10.3.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8480919C78;
        Mon,  9 Nov 2020 15:28:23 +0000 (UTC)
Date:   Mon, 9 Nov 2020 08:28:22 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Auger Eric <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vikram Prakash <vikram.prakash@broadcom.com>
Subject: Re: [RFC, v0 1/3] vfio/platform: add support for msi
Message-ID: <20201109082822.650d106a@x1.home>
In-Reply-To: <CAHLZf_uan_nbewxRgTtbkAAk1rGAggq_3Z4EgtRqsPryt58eOw@mail.gmail.com>
References: <20201105060257.35269-1-vikas.gupta@broadcom.com>
        <20201105060257.35269-2-vikas.gupta@broadcom.com>
        <20201105000806.1df16656@x1.home>
        <CAHLZf_vyn1RKEsQWcd7=M1462F2hurSvE37aW3b+1QvFAnBTPQ@mail.gmail.com>
        <20201105201208.5366d71e@x1.home>
        <CAHLZf_uan_nbewxRgTtbkAAk1rGAggq_3Z4EgtRqsPryt58eOw@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 9 Nov 2020 12:11:15 +0530
Vikas Gupta <vikas.gupta@broadcom.com> wrote:

> Hi Alex,
>=20
> On Fri, Nov 6, 2020 at 8:42 AM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > On Fri, 6 Nov 2020 08:24:26 +0530
> > Vikas Gupta <vikas.gupta@broadcom.com> wrote:
> > =20
> > > Hi Alex,
> > >
> > > On Thu, Nov 5, 2020 at 12:38 PM Alex Williamson
> > > <alex.williamson@redhat.com> wrote: =20
> > > >
> > > > On Thu,  5 Nov 2020 11:32:55 +0530
> > > > Vikas Gupta <vikas.gupta@broadcom.com> wrote:
> > > > =20
> > > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > > > index 2f313a238a8f..aab051e8338d 100644
> > > > > --- a/include/uapi/linux/vfio.h
> > > > > +++ b/include/uapi/linux/vfio.h
> > > > > @@ -203,6 +203,7 @@ struct vfio_device_info {
> > > > >  #define VFIO_DEVICE_FLAGS_AP (1 << 5)        /* vfio-ap device */
> > > > >  #define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)    /* vfio-fsl-mc devi=
ce */
> > > > >  #define VFIO_DEVICE_FLAGS_CAPS       (1 << 7)        /* Info sup=
ports caps */
> > > > > +#define VFIO_DEVICE_FLAGS_MSI        (1 << 8)        /* Device s=
upports msi */
> > > > >       __u32   num_regions;    /* Max region index + 1 */
> > > > >       __u32   num_irqs;       /* Max IRQ index + 1 */
> > > > >       __u32   cap_offset;     /* Offset within info struct of fir=
st cap */ =20
> > > >
> > > > This doesn't make any sense to me, MSIs are just edge triggered
> > > > interrupts to userspace, so why isn't this fully described via
> > > > VFIO_DEVICE_GET_IRQ_INFO?  If we do need something new to describe =
it,
> > > > this seems incomplete, which indexes are MSI (IRQ_INFO can describe
> > > > that)?  We also already support MSI with vfio-pci, so a global flag=
 for
> > > > the device advertising this still seems wrong.  Thanks,
> > > >
> > > > Alex
> > > > =20
> > > Since VFIO platform uses indexes for IRQ numbers so I think MSI(s)
> > > cannot be described using indexes. =20
> >
> > That would be news for vfio-pci which has been describing MSIs with
> > sub-indexes within indexes since vfio started.
> > =20
> > > In the patch set there is no difference between MSI and normal
> > > interrupt for VFIO_DEVICE_GET_IRQ_INFO. =20
> >
> > Then what exactly is a global device flag indicating?  Does it indicate
> > all IRQs are MSI? =20
>=20
> No, it's not indicating that all are MSI.
> The rationale behind adding the flag to tell user-space that platform
> device supports MSI as well. As you mentioned recently added
> capabilities can help on this, I`ll go through that.


It still seems questionable to me to use a device info capability to
describe an interrupt index specific feature.  The scope seems wrong.
Why does userspace need to know that this IRQ is MSI rather than
indicating it's simply an edge triggered interrupt?  That can be done
using only vfio_irq_info.flags.


> > > The patch set adds MSI(s), say as an extension, to the normal
> > > interrupts and handled accordingly. =20
> >
> > So we have both "normal" IRQs and MSIs?  How does the user know which
> > indexes are which? =20
>=20
> With this patch set, I think this is missing and user space cannot
> know that particular index is MSI interrupt.
> For platform devices there is no such mechanism, like index and
> sub-indexes to differentiate between legacy, MSI or MSIX as it=E2=80=99s =
there
> in PCI.

Indexes and sub-indexes are a grouping mechanism of vfio to describe
related interrupts.  That terminology doesn't exist on PCI either, it's
meant to be used generically.  It's left to the vfio bus driver how
userspace associates a given index to a device feature.

> I believe for a particular IRQ index if the flag
> VFIO_IRQ_INFO_NORESIZE is used then user space can know which IRQ
> index has MSI(s). Does it make sense?


No, no-resize is an implementation detail, not an indication of the
interrupt mechanism.  It's still not clear to me why it's important to
expose to userspace that a given interrupt is MSI versus simply
exposing it as an edge interrupt (ie. automasked =3D false).  If it is
necessary, the most direct approach might be to expose a capability
extension in the vfio_irq_info structure to describe it.  Even then
though, I don't think simply exposing a index as MSI is very
meaningful.  What is userspace intended to do differently based on this
information?  Thanks,

Alex

