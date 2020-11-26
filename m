Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292562C540F
	for <lists+kvm@lfdr.de>; Thu, 26 Nov 2020 13:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388646AbgKZMhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Nov 2020 07:37:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47193 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388550AbgKZMhh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 26 Nov 2020 07:37:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606394255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PddLX7FPaU47/TGp4kLh/CaSHGDEei8RJffsQXaRHtc=;
        b=RfTkzZ3lTNFRvn5DcOFE3XiLmMuxlvIrYKTpJbn7fBfxh+2BnLq57uJ857kVWk0b3n/FqQ
        K+DxqcLPrK7ht2HTL91DLlUgXIRx1CuL+eykHw5SVLtM49hScAhFvkjYnez/7BCosrJ8uA
        gVhgbqILEeuY51xjFTOikTOEZyDcP7Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-295-aq8-D2QLOs-hm0vBeAJdWg-1; Thu, 26 Nov 2020 07:37:33 -0500
X-MC-Unique: aq8-D2QLOs-hm0vBeAJdWg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A09BE80F057;
        Thu, 26 Nov 2020 12:37:00 +0000 (UTC)
Received: from localhost (ovpn-114-182.ams2.redhat.com [10.36.114.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 308A460BFA;
        Thu, 26 Nov 2020 12:37:00 +0000 (UTC)
Date:   Thu, 26 Nov 2020 12:36:59 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, john.g.johnson@oracle.com, dinechin@redhat.com,
        cohuck@redhat.com, felipe@nutanix.com,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <20201126123659.GC1180457@stefanha-x1.localdomain>
References: <CAFO2pHzmVf7g3z0RikQbYnejwcWRtHKV=npALs49eRDJdt4mJQ@mail.gmail.com>
 <0447ec50-6fe8-4f10-73db-e3feec2da61c@redhat.com>
MIME-Version: 1.0
In-Reply-To: <0447ec50-6fe8-4f10-73db-e3feec2da61c@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/e2eDi0V/xtL+Mc8"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--/e2eDi0V/xtL+Mc8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2020 at 11:37:30AM +0800, Jason Wang wrote:
> On 2020/11/26 =E4=B8=8A=E5=8D=883:21, Elena Afanasova wrote:
> > Hello,
> >=20
> > I'm an Outreachy intern with QEMU and I=E2=80=99m working on implementi=
ng the
> > ioregionfd API in KVM.
> > So I=E2=80=99d like to resume the ioregionfd design discussion. The lat=
est
> > version of the ioregionfd API document is provided below.
> >=20
> > Overview
> > --------
> > ioregionfd is a KVM dispatch mechanism for handling MMIO/PIO accesses
> > over a
> > file descriptor without returning from ioctl(KVM_RUN). This allows devi=
ce
> > emulation to run in another task separate from the vCPU task.
> >=20
> > This is achieved through KVM ioctls for registering MMIO/PIO regions an=
d
> > a wire
> > protocol that KVM uses to communicate with a task handling an MMIO/PIO
> > access.
> >=20
> > The traditional ioctl(KVM_RUN) dispatch mechanism with device emulation
> > in a
> > separate task looks like this:
> >=20
> > =C2=A0 =C2=A0kvm.ko=C2=A0 <---ioctl(KVM_RUN)---> VMM vCPU task <---mess=
ages---> device
> > task
> >=20
> > ioregionfd improves performance by eliminating the need for the vCPU
> > task to
> > forward MMIO/PIO exits to device emulation tasks:
>=20
>=20
> I wonder at which cases we care performance like this. (Note that vhost-u=
ser
> suppots set|get_config() for a while).

NVMe emulation needs this because ioeventfd cannot transfer the value
written to the doorbell. That's why QEMU's NVMe emulation doesn't
support IOThreads.

> > KVM_CREATE_IOREGIONFD
> > ---------------------
> > :Capability: KVM_CAP_IOREGIONFD
> > :Architectures: all
> > :Type: system ioctl
> > :Parameters: none
> > :Returns: an ioregionfd file descriptor, -1 on error
> >=20
> > This ioctl creates a new ioregionfd and returns the file descriptor. Th=
e
> > fd can
> > be used to handle MMIO/PIO accesses instead of returning from
> > ioctl(KVM_RUN)
> > with KVM_EXIT_MMIO or KVM_EXIT_PIO. One or more MMIO or PIO regions mus=
t
> > be
> > registered with KVM_SET_IOREGION in order to receive MMIO/PIO accesses
> > on the
> > fd. An ioregionfd can be used with multiple VMs and its lifecycle is no=
t
> > tied
> > to a specific VM.
> >=20
> > When the last file descriptor for an ioregionfd is closed, all regions
> > registered with KVM_SET_IOREGION are dropped and guest accesses to thos=
e
> > regions cause ioctl(KVM_RUN) to return again.
>=20
>=20
> I may miss something, but I don't see any special requirement of this fd.
> The fd just a transport of a protocol between KVM and userspace process. =
So
> instead of mandating a new type, it might be better to allow any type of =
fd
> to be attached. (E.g pipe or socket).

pipe(2) is unidirectional on Linux, so it won't work.

mkfifo(3) seems usable but creates a node on a filesystem.

socketpair(2) would work, but brings in the network stack when it's not
needed. The advantage is that some future user case might want to direct
ioregionfd over a real socket to a remote host, which would be cool.

Do you have an idea of the performance difference of socketpair(2)
compared to a custom fd?

If it's neglible then using an arbitrary socket is more flexible and
sounds good.

Stefan

--/e2eDi0V/xtL+Mc8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+/oWoACgkQnKSrs4Gr
c8itZQf8DNXVisEx0R1yW3OuXvkxv6waULCW+CaLDEqEsFbNFTrl1Z13TQrukAvq
CaecRdZHDkHAKKkLn6P5r0d7QJduO7lQgqwAhjz8gAeOAp0/CSubqaVet2Q+LOOX
c7Ppt4PsLd1v6ioS7o2rwhJIT0o4JgjZAu3WCQ9g0XwEKkQlO7wFaDrv7tvvKdDz
TyYz2BD5bNHDQ68+GnTTvpqlEzV5dSXECRJIr2vzwzgN6329zdGBSPvHeY20MPwO
Cf+fSqJgBJg7xitbE4QefAZ2A49Jo4hV8cZNeFG23uj2DJ0D+Nv4kXN4gFmtB0f4
t5+2+Ao6/7TRxbGe6sCH87uVRVBEFA==
=MP/o
-----END PGP SIGNATURE-----

--/e2eDi0V/xtL+Mc8--

