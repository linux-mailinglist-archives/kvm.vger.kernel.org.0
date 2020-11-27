Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07DA2C6717
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 14:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgK0NoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 08:44:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729402AbgK0NoW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Nov 2020 08:44:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606484659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Yeg+2fZ0UY+ADLsWFzmjQq4/iIrLsF7/2W/9Pc6APfo=;
        b=L3Mm+UatYucAxjiQlWZDde43IBkJb5riwdbLn67WTvDhh0PxvPMLonI2KOOhY3j6h6Zh5P
        YDCFAFtPBZVQk0q7WdaK2+yM+20dE5y4lGoSvnK6171zPyRzJBNDSav9hmepCGwr6zf/9c
        bvlItEipXbRqh1txZz5uxUBcn38sfjA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-Q4SkVzzzNkubeMLxirrd9Q-1; Fri, 27 Nov 2020 08:44:17 -0500
X-MC-Unique: Q4SkVzzzNkubeMLxirrd9Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C54F809DD1;
        Fri, 27 Nov 2020 13:44:16 +0000 (UTC)
Received: from localhost (ovpn-113-76.ams2.redhat.com [10.36.113.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 643115D9D5;
        Fri, 27 Nov 2020 13:44:04 +0000 (UTC)
Date:   Fri, 27 Nov 2020 13:44:03 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, john.g.johnson@oracle.com, dinechin@redhat.com,
        cohuck@redhat.com, felipe@nutanix.com,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <20201127134403.GB46707@stefanha-x1.localdomain>
References: <CAFO2pHzmVf7g3z0RikQbYnejwcWRtHKV=npALs49eRDJdt4mJQ@mail.gmail.com>
 <0447ec50-6fe8-4f10-73db-e3feec2da61c@redhat.com>
 <20201126123659.GC1180457@stefanha-x1.localdomain>
 <c9f926fb-438c-9588-f018-dd040935e5e5@redhat.com>
MIME-Version: 1.0
In-Reply-To: <c9f926fb-438c-9588-f018-dd040935e5e5@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 27, 2020 at 11:39:23AM +0800, Jason Wang wrote:
>=20
> On 2020/11/26 =E4=B8=8B=E5=8D=888:36, Stefan Hajnoczi wrote:
> > On Thu, Nov 26, 2020 at 11:37:30AM +0800, Jason Wang wrote:
> > > On 2020/11/26 =E4=B8=8A=E5=8D=883:21, Elena Afanasova wrote:
> > > > Hello,
> > > >=20
> > > > I'm an Outreachy intern with QEMU and I=E2=80=99m working on implem=
enting the
> > > > ioregionfd API in KVM.
> > > > So I=E2=80=99d like to resume the ioregionfd design discussion. The=
 latest
> > > > version of the ioregionfd API document is provided below.
> > > >=20
> > > > Overview
> > > > --------
> > > > ioregionfd is a KVM dispatch mechanism for handling MMIO/PIO access=
es
> > > > over a
> > > > file descriptor without returning from ioctl(KVM_RUN). This allows =
device
> > > > emulation to run in another task separate from the vCPU task.
> > > >=20
> > > > This is achieved through KVM ioctls for registering MMIO/PIO region=
s and
> > > > a wire
> > > > protocol that KVM uses to communicate with a task handling an MMIO/=
PIO
> > > > access.
> > > >=20
> > > > The traditional ioctl(KVM_RUN) dispatch mechanism with device emula=
tion
> > > > in a
> > > > separate task looks like this:
> > > >=20
> > > >  =C2=A0 =C2=A0kvm.ko=C2=A0 <---ioctl(KVM_RUN)---> VMM vCPU task <--=
-messages---> device
> > > > task
> > > >=20
> > > > ioregionfd improves performance by eliminating the need for the vCP=
U
> > > > task to
> > > > forward MMIO/PIO exits to device emulation tasks:
> > >=20
> > > I wonder at which cases we care performance like this. (Note that vho=
st-user
> > > suppots set|get_config() for a while).
> > NVMe emulation needs this because ioeventfd cannot transfer the value
> > written to the doorbell. That's why QEMU's NVMe emulation doesn't
> > support IOThreads.
>=20
>=20
> I think it depends on how many different value that can be carried via
> doorbell. If it's not tons of, we can use datamatch. Anyway virtio suppor=
t
> differing queue index via the value wrote to doorbell.

There are too many value, it's not the queue index. It's the ring index
of the latest request. If the ring size is 128, we need 128 ioeventfd
registrations, etc. It becomes a lot.

By the way, the long-term use case for ioregionfd is to allow vfio-user
device emulation processes to directly handle I/O accesses. Elena
benchmarked ioeventfd vs dispatching through QEMU and can share the
perform results. I think the number was around 30+% improvement via
direct ioeventfd dispatch, so it will be important for high IOPS
devices (network and storage controllers).

> >=20
> > > > KVM_CREATE_IOREGIONFD
> > > > ---------------------
> > > > :Capability: KVM_CAP_IOREGIONFD
> > > > :Architectures: all
> > > > :Type: system ioctl
> > > > :Parameters: none
> > > > :Returns: an ioregionfd file descriptor, -1 on error
> > > >=20
> > > > This ioctl creates a new ioregionfd and returns the file descriptor=
. The
> > > > fd can
> > > > be used to handle MMIO/PIO accesses instead of returning from
> > > > ioctl(KVM_RUN)
> > > > with KVM_EXIT_MMIO or KVM_EXIT_PIO. One or more MMIO or PIO regions=
 must
> > > > be
> > > > registered with KVM_SET_IOREGION in order to receive MMIO/PIO acces=
ses
> > > > on the
> > > > fd. An ioregionfd can be used with multiple VMs and its lifecycle i=
s not
> > > > tied
> > > > to a specific VM.
> > > >=20
> > > > When the last file descriptor for an ioregionfd is closed, all regi=
ons
> > > > registered with KVM_SET_IOREGION are dropped and guest accesses to =
those
> > > > regions cause ioctl(KVM_RUN) to return again.
> > >=20
> > > I may miss something, but I don't see any special requirement of this=
 fd.
> > > The fd just a transport of a protocol between KVM and userspace proce=
ss. So
> > > instead of mandating a new type, it might be better to allow any type=
 of fd
> > > to be attached. (E.g pipe or socket).
> > pipe(2) is unidirectional on Linux, so it won't work.
>=20
>=20
> Can we accept two file descriptors to make it work?
>=20
>=20
> >=20
> > mkfifo(3) seems usable but creates a node on a filesystem.
> >=20
> > socketpair(2) would work, but brings in the network stack when it's not
> > needed. The advantage is that some future user case might want to direc=
t
> > ioregionfd over a real socket to a remote host, which would be cool.
> >=20
> > Do you have an idea of the performance difference of socketpair(2)
> > compared to a custom fd?
>=20
>=20
> It should be slower than custom fd and UNIX socket should be faster than
> TIPC. Maybe we can have a custom fd, but it's better to leave the policy =
to
> the userspace:
>=20
> 1) KVM should not have any limitation of the fd it uses, user will risk
> itself if the fd has been used wrongly, and the custom fd should be one o=
f
> the choice
> 2) it's better to not have a virt specific name (e.g "KVM" or "ioregion")

Okay, it looks like there are things to investigate here.

Elena: My suggestion would be to start with the simplest option -
letting userspace pass in 1 file descriptor. You can investigate the
performance of socketpair(2)/fifo(7), 2 pipe fds, or a custom file
implementation later if time permits. That way the API has maximum
flexibility (userspace can decide on the file type).

> Or I wonder whether we can attach an eBPF program when trapping MMIO/PIO =
and
> allow it to decide how to proceed?

The eBPF program approach is interesting, but it would probably require
access to guest RAM and additional userspace state (e.g. device-specific
register values). I don't know the current status of Linux eBPF - is it
possible to access user memory (it could be swapped out)?

Stefan

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/BAqMACgkQnKSrs4Gr
c8j44gf/fIstq9/Sl/HopBlvSqKwV5cMFtEg36hr6s3Ln43IguOzLAJVlCDGsBVg
WsVF2J7Q5112NgxlrvWpYmpX/BOuOG3LeHkt8XrTH4AWcUFgbDdAxzJvZkfyZIPA
5gxc1mmOp8NX2knmUj+HPs/iGzKQeYDPre8j+jT8HYyoamvxuWuu7usvAbF+9zev
WidcmBwOzXuUxOX6mD7JwBeeyCBe/ok99mmM+QwKoC4bKSytZDbDRpIYr7UOB7ny
K/FMtV85UUcUZ4EJ4qGpUiuEuuABH4jiVMkQgmAdCrKAsCDwMc70nPVmUtFeOyVY
Z+hFGIRgtN7HUbxHfVUVKU81TR6l4A==
=PUpI
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--

