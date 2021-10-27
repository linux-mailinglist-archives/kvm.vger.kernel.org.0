Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0798843C776
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 12:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhJ0KSW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 06:18:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54784 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241418AbhJ0KSV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 06:18:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635329756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8RrIMa43+CDtWe02+sOZ/DmF+8SE2AFh8Rw9HUpvuIY=;
        b=f8zTXFD1F4vrmDFTikZW0QavFPVqNagHCzMf8pIchCtQ24YUOkLNLeHs0bTNcDEnQ0mEcv
        UgCHDEtUqDCrVUdzBRQH5ebes/lyE5xbDLV/GDgJyTjPMgLS2ecDn3j8BrmWkiHaLSfKfl
        4331eOJDMTMhHMA0FUzPm2Vmpj1Z5m8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-sBjZeUYqOq-DQLky1OoOqQ-1; Wed, 27 Oct 2021 06:15:54 -0400
X-MC-Unique: sBjZeUYqOq-DQLky1OoOqQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0BC4419251A1;
        Wed, 27 Oct 2021 10:15:53 +0000 (UTC)
Received: from localhost (unknown [10.39.195.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D1F401017CE7;
        Wed, 27 Oct 2021 10:15:36 +0000 (UTC)
Date:   Wed, 27 Oct 2021 11:15:35 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     John Levon <levon@movementarian.org>
Cc:     Elena <elena.ufimtseva@oracle.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, mst@redhat.com, john.g.johnson@oracle.com,
        dinechin@redhat.com, cohuck@redhat.com, jasowang@redhat.com,
        felipe@nutanix.com, jag.raman@oracle.com, eafanasova@gmail.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <YXkmx3V0VklA6qHl@stefanha-x1.localdomain>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <YWUeZVnTVI7M/Psr@heatpipe>
 <YXamUDa5j9uEALYr@stefanha-x1.localdomain>
 <20211025152122.GA25901@nuker>
 <YXhQk/Sh0nLOmA2n@movementarian.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="J/R1b5NXlPlkwaQ9"
Content-Disposition: inline
In-Reply-To: <YXhQk/Sh0nLOmA2n@movementarian.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--J/R1b5NXlPlkwaQ9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 26, 2021 at 08:01:39PM +0100, John Levon wrote:
> On Mon, Oct 25, 2021 at 08:21:22AM -0700, Elena wrote:
>=20
> > > I'm curious what approach you want to propose for QEMU integration. A
> > > while back I thought about the QEMU API. It's possible to implement it
> > > along the lines of the memory_region_add_eventfd() API where each
> > > ioregionfd is explicitly added by device emulation code. An advantage=
 of
> > > this approach is that a MemoryRegion can have multiple ioregionfds, b=
ut
> > > I'm not sure if that is a useful feature.
> > >
> >=20
> > This is the approach that is currently in the works. Agree, I dont see
> > much of the application here at this point to have multiple ioregions
> > per MemoryRegion.
> > I added Memory API/eventfd approach to the vfio-user as well to try
> > things out.
> >=20
> > > An alternative is to cover the entire MemoryRegion with one ioregionf=
d.
> > > That way the device emulation code can use ioregionfd without much fu=
ss
> > > since there is a 1:1 mapping between MemoryRegions, which are already
> > > there in existing devices. There is no need to think deeply about whi=
ch
> > > ioregionfds to create for a device.
> > >
> > > A new API called memory_region_set_aio_context(MemoryRegion *mr,
> > > AioContext *ctx) would cause ioregionfd (or a userspace fallback for
> > > non-KVM cases) to execute the MemoryRegion->read/write() accessors fr=
om
> > > the given AioContext. The details of ioregionfd are hidden behind the
> > > memory_region_set_aio_context() API, so the device emulation code
> > > doesn't need to know the capabilities of ioregionfd.
> >=20
> > >=20
> > > The second approach seems promising if we want more devices to use
> > > ioregionfd inside QEMU because it requires less ioregionfd-specific
> > > code.
> > >=20
> > I like this approach as well.
> > As you have mentioned, the device emulation code with first approach
> > does have to how to handle the region accesses. The second approach will
> > make things more transparent. Let me see how can I modify what there is
> > there now and may ask further questions.
>=20
> Sorry I'm a bit late to this discussion, I'm not clear on the above WRT
> vfio-user. If an ioregionfd has to cover a whole BAR0 (?), how would this
> interact with partly-mmap()able regions like we do with SPDK/vfio-user/NV=
Me?

The ioregionfd doesn't need to cover an entire BAR. QEMU's MemoryRegions
form a hierarchy, so it's possible to sub-divide the BAR into several
MemoryRegions.

This means it's still possible to have mmap() sub-regions or even
ioeventfds sprinkled in between.

Stefan

--J/R1b5NXlPlkwaQ9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmF5JscACgkQnKSrs4Gr
c8i1NAgAoVH+VwSZD4M/XspAXmHGqiveQebbCraCrI8p3xbEfQIMsEVErG1dHWCV
vcAYeO7X6J+X0flOygk0g7ZeFVYmGKKr9XPAFeiFPQ5MRPhfrDlHTxrtvhxWgLuF
F2K/jkp+fl4wFvGsUZB5i/kGojbw5U3G9YRUoIHvF5N++wHNG+0cxKiqvt/n24Pc
LxkSHer04M+XDB0nsjVSJ2fNu0bWmEx3d9pSuPaVK4POLmM21whWZ3VIomW7hAPk
U0FffmXnIFYjaXA2thLf0cMBJu7oyjbCDJnBpWkEUvd5DBqTircR2pZgjiWmXBfq
ty4XOCH6ltESi6kQcPmrgMd3/ZzYjw==
=6vzl
-----END PGP SIGNATURE-----

--J/R1b5NXlPlkwaQ9--

