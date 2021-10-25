Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672B7439681
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 14:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhJYMpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 08:45:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33538 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233055AbhJYMpa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Oct 2021 08:45:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635165787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=79f/9afnwtB829IMzgS0+GQeVHdsj73e3rNCJCAuleY=;
        b=HCyLbi0U5zqfqHeHOYLO4DPdGb0S8HcW1uHyQr0ELtTvGCpem91NAi4cR2ZXF/NOjk9S5b
        UIGInqJ8xl4mdmfj+BHm9s/S19sapCPSI8XAf/MG6zR2vOVtmeqVmVjWn+I9lMGqJVpvM+
        NUuY5wX6yR543GgdLMbjCFkS/cELpZw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-dUyAEKn0Ne6zLaA8wcLKsw-1; Mon, 25 Oct 2021 08:43:04 -0400
X-MC-Unique: dUyAEKn0Ne6zLaA8wcLKsw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AACF0101F000;
        Mon, 25 Oct 2021 12:43:02 +0000 (UTC)
Received: from localhost (unknown [10.39.192.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 53C825BAFB;
        Mon, 25 Oct 2021 12:42:57 +0000 (UTC)
Date:   Mon, 25 Oct 2021 13:42:56 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     elena <elena.ufimtseva@oracle.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, mst@redhat.com,
        john.g.johnson@oracle.com, dinechin@redhat.com, cohuck@redhat.com,
        jasowang@redhat.com, felipe@nutanix.com, jag.raman@oracle.com,
        eafanasova@gmail.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <YXamUDa5j9uEALYr@stefanha-x1.localdomain>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <YWUeZVnTVI7M/Psr@heatpipe>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PKDBWrlb7QGTn9i6"
Content-Disposition: inline
In-Reply-To: <YWUeZVnTVI7M/Psr@heatpipe>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--PKDBWrlb7QGTn9i6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 11, 2021 at 10:34:29PM -0700, elena wrote:
> On Wed, Nov 25, 2020 at 12:44:07PM -0800, Elena Afanasova wrote:
> > Hello,
> >
>=20
> Hi
>=20
> Sorry for top-posting, just wanted to provide a quik update.
> We are currently working on the support for ioregionfd in Qemu and will
> be posting the patches soon. Plus the KVM patches will be posted based
> of the RFC v3 with some fixes if there are no objections from Elena's side
> who originally posted KVM RFC patchset.

Hi Elena,
I'm curious what approach you want to propose for QEMU integration. A
while back I thought about the QEMU API. It's possible to implement it
along the lines of the memory_region_add_eventfd() API where each
ioregionfd is explicitly added by device emulation code. An advantage of
this approach is that a MemoryRegion can have multiple ioregionfds, but
I'm not sure if that is a useful feature.

An alternative is to cover the entire MemoryRegion with one ioregionfd.
That way the device emulation code can use ioregionfd without much fuss
since there is a 1:1 mapping between MemoryRegions, which are already
there in existing devices. There is no need to think deeply about which
ioregionfds to create for a device.

A new API called memory_region_set_aio_context(MemoryRegion *mr,
AioContext *ctx) would cause ioregionfd (or a userspace fallback for
non-KVM cases) to execute the MemoryRegion->read/write() accessors from
the given AioContext. The details of ioregionfd are hidden behind the
memory_region_set_aio_context() API, so the device emulation code
doesn't need to know the capabilities of ioregionfd.

The second approach seems promising if we want more devices to use
ioregionfd inside QEMU because it requires less ioregionfd-specific
code.

Stefan

--PKDBWrlb7QGTn9i6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmF2plAACgkQnKSrs4Gr
c8hugQgAsK965URBPD6/lg7f0ucQqEchs2Spk7bGtxC1VOoSL7mxqgDmaNGfqzME
BWlS7vNeCaaiT13vsw1H0rDh6QumtlQpnJfNkNnX+K2tjxjZIftNnhlRiN/NHbzN
ZbeBAJKlf6yf9wuePTMwu+zxR6yPFIAVVZrvPh27OInSOEkRMCx1MmjqyA3pRnFX
gyY8Krxcrgh1rgoyC03MNOkTRTEHExn40sNcIXcqcNfwd1k/dEAXnaiulT1qya1i
o/b6L4LGDpw5BwwqsTu2dSJ6+cjhiaJ2BPuSewFjGf8xr37IXKB2hexPmar958sI
gvbcgCEHS+0KtUXXb5O8VA3f5HRmNQ==
=zbN3
-----END PGP SIGNATURE-----

--PKDBWrlb7QGTn9i6--

