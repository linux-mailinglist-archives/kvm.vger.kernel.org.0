Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD2D2CEEBD
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 14:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbgLDNZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 08:25:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728066AbgLDNZQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 08:25:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607088229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y6CPOMvmdtjIpOxysMt1Ko7zRAeAEpIXTLMj5oLiKUA=;
        b=Q1X0RHgpG+M31GsM0HMpbiZLcXHblktuzXK6DtjMVUZoD92iokW/P93vxWaLRWb/Hh3sVK
        pgEIlXsgeWY7MKk1PEoyZZZQgLKEomjj9sUvJwa2Mi9UJYmC29W8r3e3FCJ/KAx6PnQ0pr
        RBHcdYWhGOS1LYK68dy72y1+4ozUKKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-RMTy46Y6No-Ylp6MzHcUNw-1; Fri, 04 Dec 2020 08:23:45 -0500
X-MC-Unique: RMTy46Y6No-Ylp6MzHcUNw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D474910054FF;
        Fri,  4 Dec 2020 13:23:43 +0000 (UTC)
Received: from localhost (ovpn-112-11.ams2.redhat.com [10.36.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74F066087C;
        Fri,  4 Dec 2020 13:23:34 +0000 (UTC)
Date:   Fri, 4 Dec 2020 13:23:33 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        john.g.johnson@oracle.com, dinechin@redhat.com, cohuck@redhat.com,
        jasowang@redhat.com, felipe@nutanix.com,
        elena.ufimtseva@oracle.com, jag.raman@oracle.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <20201204132333.GA1008790@stefanha-x1.localdomain>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <20201202180628.GA100143@xz-x1>
 <20201203111036.GD689053@stefanha-x1.localdomain>
 <20201203062357-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20201203062357-mutt-send-email-mst@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 03, 2020 at 06:34:00AM -0500, Michael S. Tsirkin wrote:
> On Thu, Dec 03, 2020 at 11:10:36AM +0000, Stefan Hajnoczi wrote:
> > On Wed, Dec 02, 2020 at 01:06:28PM -0500, Peter Xu wrote:
> > > On Wed, Nov 25, 2020 at 12:44:07PM -0800, Elena Afanasova wrote:
> > >=20
> > > [...]
> > >=20
> > > > Wire protocol
> > > > -------------
> > > > The protocol spoken over the file descriptor is as follows. The dev=
ice reads
> > > > commands from the file descriptor with the following layout::
> > > >=20
> > > >   struct ioregionfd_cmd {
> > > >       __u32 info;
> > > >       __u32 padding;
> > > >       __u64 user_data;
> > > >       __u64 offset;
> > > >       __u64 data;
> > > >   };
> > >=20
> > > I'm thinking whether it would be nice to have a handshake on the wire=
 protocol
> > > before starting the cmd/resp sequence.
> > >=20
> > > I was thinking about migration - we have had a hard time trying to be
> > > compatible between old/new qemus.  Now we fixed those by applying the=
 same
> > > migration capabilities on both sides always so we do the handshake "m=
anually"
> > > from libvirt, but it really should be done with a real handshake on t=
he
> > > channel, imho..  That's another story, for sure.
> > >=20
> > > My understanding is that the wire protocol is kind of a standalone (b=
ut tiny)
> > > protocol between kvm and the emulation process.  So I'm thinking the =
handshake
> > > could also help when e.g. kvm can fallback to an old version of wire =
protocol
> > > if it knows the emulation binary is old.  Ideally, I think this could=
 even
> > > happen without VMM's awareness.
> > >=20
> > > [...]
> >=20
> > I imagined that would happen in the control plane (KVM ioctls) instead
> > of the data plane (the fd). There is a flags field in
> > ioctl(KVM_SET_IOREGION):
> >=20
> >   struct kvm_ioregion {
> >       __u64 guest_paddr; /* guest physical address */
> >       __u64 memory_size; /* bytes */
> >       __u64 user_data;
> >       __s32 fd; /* previously created with KVM_CREATE_IOREGIONFD */
> >       __u32 flags;
> >       __u8  pad[32];
> >   };
> >=20
> > When userspace sets up the ioregionfd it can tell the kernel which
> > features to enable.
> >=20
> > Feature availability can be checked through ioctl(KVM_CHECK_EXTENSION).
> >=20
> > Do you think this existing mechanism is enough? It's not clear to me
> > what kind of additional negotiation would be necessary between the
> > device emulation process and KVM after the ioregionfd has been
> > registered?
> >=20
> > > > Ordering
> > > > --------
> > > > Guest accesses are delivered in order, including posted writes.
> > >=20
> > > I'm wondering whether it should prepare for out-of-order commands ass=
uming if
> > > there's no handshake so harder to extend, just in case there could be=
 some slow
> > > commands so we still have chance to reply to a very trivial command d=
uring
> > > handling the slow one (then each command may require a command ID, to=
o).  But
> > > it won't be a problem at all if we can easily extend the wire protoco=
l so the
> > > ordering constraint can be extended too when really needed, and we ca=
n always
> > > start with in-order-only requests.
> >=20
> > Elena and I brainstormed out-of-order commands but didn't include them
> > in the proposal because it's not clear that they are needed. For
> > multi-queue devices the per-queue registers can be assigned different
> > ioregionfds that are handled by dedicated threads.
>=20
> The difficulty is I think the reverse: reading
> any register from a PCI device is normally enough to flush any
> writes and interrupts in progress.

Accesses dispatched on the same ioregionfd are ordered. If a device
requires ordering then it needs to use one ioregionfd.

I'm not aware of issues with ioeventfd where the vhost worker thread or
QEMU's IOThread process the doorbell while the vCPU thread processes
other virtio-pci register accesses. The situation is similar with
ioregionfd.

Stefan

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/KOFUACgkQnKSrs4Gr
c8hRuwf/VYFYtwrordxeEGADK7KLIzOUbzW+SH0sonIf7dl+Cbm3k9SHdMwesonw
0KEmzlo9TLM0k6I8/y3f53r9vZXPy+xwcMTynRCX17g+HDTkmL0ZPPbGtH4wcfZM
HX7cbTiWtCN9M9R/a5cotVQHFbeTnvuptYcx7ek1vbm/DQ1hPnRT2hA2J5Qfwe2v
xiG7JnOw3Zz6VW814ryeq66NLVhk7p7dtJjMXchmB/NOTu81MUY9x/qBV9rNuqk2
wMRJc42buvPMYqlDyPg4vWO6l8gY5kq7ht9T3yFZqcAnY0QamFihauFrXcpe66Dq
i9OwY20kBfYCSGv9QO0qU7ywXNyS/Q==
=bzz/
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--

