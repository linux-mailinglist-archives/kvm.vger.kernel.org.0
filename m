Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F90B2CD45A
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 12:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgLCLMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 06:12:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59038 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728548AbgLCLMT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 06:12:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606993852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aNhlMaxisIGGoGrRPyuDHEQlSOMxeoNxxEf2z066/a4=;
        b=NsVtAIuOx0zJpIBsr+4uu6CIAkrsjHZwITRHLTIJ3ItKsC5nNA4mNYaRQMnXfD1u20qK24
        OFTFMD4NfMzlHwMtjSfobsyI6aXt9k9WCiVZ3UlwLQRp26soXgzVC7MMMy7t7e1rk2URKL
        bD51YDkAnsJw3yuNsbnrL35Elh0SnVo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-rY2D4gOaN56g3WIdnqS_RA-1; Thu, 03 Dec 2020 06:10:48 -0500
X-MC-Unique: rY2D4gOaN56g3WIdnqS_RA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 648CF8049C0;
        Thu,  3 Dec 2020 11:10:47 +0000 (UTC)
Received: from localhost (ovpn-115-46.ams2.redhat.com [10.36.115.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 062BB10016F6;
        Thu,  3 Dec 2020 11:10:37 +0000 (UTC)
Date:   Thu, 3 Dec 2020 11:10:36 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, john.g.johnson@oracle.com, dinechin@redhat.com,
        cohuck@redhat.com, jasowang@redhat.com, felipe@nutanix.com,
        elena.ufimtseva@oracle.com, jag.raman@oracle.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <20201203111036.GD689053@stefanha-x1.localdomain>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <20201202180628.GA100143@xz-x1>
MIME-Version: 1.0
In-Reply-To: <20201202180628.GA100143@xz-x1>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="at6+YcpfzWZg/htY"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--at6+YcpfzWZg/htY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 02, 2020 at 01:06:28PM -0500, Peter Xu wrote:
> On Wed, Nov 25, 2020 at 12:44:07PM -0800, Elena Afanasova wrote:
>=20
> [...]
>=20
> > Wire protocol
> > -------------
> > The protocol spoken over the file descriptor is as follows. The device =
reads
> > commands from the file descriptor with the following layout::
> >=20
> >   struct ioregionfd_cmd {
> >       __u32 info;
> >       __u32 padding;
> >       __u64 user_data;
> >       __u64 offset;
> >       __u64 data;
> >   };
>=20
> I'm thinking whether it would be nice to have a handshake on the wire pro=
tocol
> before starting the cmd/resp sequence.
>=20
> I was thinking about migration - we have had a hard time trying to be
> compatible between old/new qemus.  Now we fixed those by applying the sam=
e
> migration capabilities on both sides always so we do the handshake "manua=
lly"
> from libvirt, but it really should be done with a real handshake on the
> channel, imho..  That's another story, for sure.
>=20
> My understanding is that the wire protocol is kind of a standalone (but t=
iny)
> protocol between kvm and the emulation process.  So I'm thinking the hand=
shake
> could also help when e.g. kvm can fallback to an old version of wire prot=
ocol
> if it knows the emulation binary is old.  Ideally, I think this could eve=
n
> happen without VMM's awareness.
>=20
> [...]

I imagined that would happen in the control plane (KVM ioctls) instead
of the data plane (the fd). There is a flags field in
ioctl(KVM_SET_IOREGION):

  struct kvm_ioregion {
      __u64 guest_paddr; /* guest physical address */
      __u64 memory_size; /* bytes */
      __u64 user_data;
      __s32 fd; /* previously created with KVM_CREATE_IOREGIONFD */
      __u32 flags;
      __u8  pad[32];
  };

When userspace sets up the ioregionfd it can tell the kernel which
features to enable.

Feature availability can be checked through ioctl(KVM_CHECK_EXTENSION).

Do you think this existing mechanism is enough? It's not clear to me
what kind of additional negotiation would be necessary between the
device emulation process and KVM after the ioregionfd has been
registered?

> > Ordering
> > --------
> > Guest accesses are delivered in order, including posted writes.
>=20
> I'm wondering whether it should prepare for out-of-order commands assumin=
g if
> there's no handshake so harder to extend, just in case there could be som=
e slow
> commands so we still have chance to reply to a very trivial command durin=
g
> handling the slow one (then each command may require a command ID, too). =
 But
> it won't be a problem at all if we can easily extend the wire protocol so=
 the
> ordering constraint can be extended too when really needed, and we can al=
ways
> start with in-order-only requests.

Elena and I brainstormed out-of-order commands but didn't include them
in the proposal because it's not clear that they are needed. For
multi-queue devices the per-queue registers can be assigned different
ioregionfds that are handled by dedicated threads.

Out-of-order commands are only necessary if a device needs to
concurrently process register accesses to the *same* set of registers. I
think it's rare for hardware register interfaces to be designed like
that.

This could be a mistake, of course. If someone knows a device that needs
multiple in-flight register accesses, please let us know.

Stefan

--at6+YcpfzWZg/htY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/Ix6wACgkQnKSrs4Gr
c8gXjwf9HuPktBXDP96Q8wXbPnIeET2xvCJUBMr2cmAIazpfZwBKx7JfanZjjcG1
duaHzoB9qPzOr+xFa+p2tTU4JF3hmElL7VauFjUFGuEpGdBVvz3uDww8zgnw7ceF
hv6T8wcls1O6LIQI/DA/ubRcLgGXbYOcX473K0OW1PVLzMwEC7RZ2zsAISyDA2o2
KQykMaUd6FdMZXYpOkIHvxInp5U4TI7NZR41fBvWVITXcR//9KANpbYmAevvzUfN
upi+Ty6RnwMLWPBNSkj5qF/0Y2tMKHweAqu9zSetdGTHJkWLJtesRqCkqfitkEAW
WtuoSl0OAkh1OwFx7Td+35fv0vPKbg==
=1jPO
-----END PGP SIGNATURE-----

--at6+YcpfzWZg/htY--

