Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A932D1432
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 15:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgLGO7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 09:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgLGO7F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 09:59:05 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFA5C061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 06:58:25 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id p22so1968400edu.11
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 06:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zbBc26vLrzccGvn35QwETDj9Yz9c3XiSyayc4sPGk54=;
        b=uFMrmLgf9g/4hMvuG3sQUx1TaT60mGwmGxE7/6bWtIg4Hm7T+0pyNFAbMFf0SDdq0Z
         JPYK0nkQdRWl/yzY2KuRfpFHususXN8gsCLcol9iWiStyilw7iI0GaihcoYGLTj98kfD
         +76tmISqFzeoABZqeMQXcCRBtxRznoXJrSPRQSGvf4ZIPDaUwdM1A7FSyxf/UypWLDOp
         fbbIJhkZduP+52WeYQfMYF+lIIyOVx+0ZZMmD5OtS9GQt2ujQF1ISweLtU1klXylYae3
         DIYuTW7a3u2sRQx0nYshR7ZYeSY5t3oL5luSKv2+/bjPXcX+LiH0xKQbRqQxXYl3EVGC
         YIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zbBc26vLrzccGvn35QwETDj9Yz9c3XiSyayc4sPGk54=;
        b=dnlz3eNfe6+9hhOmeXuxFPQjrynx7pCLkNPcCXpBlh/7UEav5ngfyd7p8VcDpjtRB3
         odC2dRn/C9T5/Udhurqj8hnR/RduR8VWKblND2lY9V4ru0/8+tln09P0DoCCdPKjFQAH
         nfzikPhFZolgWgyZag4PMqo6BM6rOkH+E0pdZlH2pcar4vTmH1DQXsvSQ8Rg8IBn21jo
         fxsOo2HSH0upGQ8ypu7PiRkrhTQRot1EPY2tRYOnXYiBEJLbjeguDn17eVtCBsKn7LWT
         esH33iHOP+771F8raoUNRYg/sv7/YYwJueinkffsZEJoE/u9D7xoPGdideW4W6sgCaw3
         fStg==
X-Gm-Message-State: AOAM530EUXblfksiZUIr0x8ZASbN+8iEoc6lS42ijeqoQRQXwKuinfBh
        7aTgXBGpdO+2HYSkRbnV6s8=
X-Google-Smtp-Source: ABdhPJwDzwTNHuGesMF+zOuP4Y+i2YlF/CIBBNLCC3tuHUOoPtDYeqBFHYBUP2YMLE2JxzV0L9aGuA==
X-Received: by 2002:aa7:d5d6:: with SMTP id d22mr3582118eds.160.1607353104281;
        Mon, 07 Dec 2020 06:58:24 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id zn5sm12448022ejb.111.2020.12.07.06.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 06:58:22 -0800 (PST)
Date:   Mon, 7 Dec 2020 14:58:21 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, john.g.johnson@oracle.com, dinechin@redhat.com,
        cohuck@redhat.com, jasowang@redhat.com, felipe@nutanix.com,
        elena.ufimtseva@oracle.com, jag.raman@oracle.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <20201207145821.GH203660@stefanha-x1.localdomain>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <20201202180628.GA100143@xz-x1>
 <20201203111036.GD689053@stefanha-x1.localdomain>
 <20201203144037.GG108496@xz-x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="U3BNvdZEnlJXqmh+"
Content-Disposition: inline
In-Reply-To: <20201203144037.GG108496@xz-x1>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--U3BNvdZEnlJXqmh+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 03, 2020 at 09:40:37AM -0500, Peter Xu wrote:
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
>=20
> Yes I think kvm capability can be used as a way for the handshake between=
 VMM
> and KVM.  However I'm not sure how to do similar things to the emulation
> process besides passing over the ioregionfd, because that's between VMM a=
nd the
> emulation process.  Is there a way to do so with current proposasl?

The interface is designed so the VMM controls the ioregionfd setup on
behalf of the device emulation process. This is for security: the device
emulation process is untrusted.

There is setup involving the VMM and the device emulation process that
is outside the scope of the KVM API where the device emulation process
could request for the VMM to enable ioregionfd features. For example, if
QEMU is initializing a vfio-user device emulation program then QEMU
queries available vfio-user device regions from the device emulation
program. This is where extra information like ioregionfd support would
be indicated by the device emulation program.

> The out-of-order feature may not be a good enough example if it's destine=
d to
> be useless... but let's just imagine we have such a requirement as an ext=
ention
> to the current wire protocol.  What I was thinking was whether we could h=
ave
> another handshake somehow to the emulation process, so that we can identi=
fy "ok
> this emulation process supports out-of-band" or vice versa.  Only with th=
at
> information could VMM enable/disable the out-of-band in KVM.
>=20
> The handshake to the emulation process can start from either VMM or KVM. =
 And
> my previous idea was simply let KVM and emualtion process talk rather tha=
n VMM
> against the emulation, because they really look like two isolated protoco=
ls:
>=20
>   - The VMM <-> KVM talks via KVM_SET_IOREGIONFD, it is only responsible =
to
>     setup a mmio/pio region in the guest and create the fd. As long as the
>     region is properly setup, and the fd is passed over to emulation proc=
ess,
>     it's done as a proxy layer.
>=20
>   - The KVM <-> emulation process talks via the wire protocol (so this pr=
otocol
>     can be irrelevant to KVM_SET_IOREGIONFD protocol itself).  For exampl=
e the
>     out-of-band feature changes the behavior of the wire protocol.  Ideal=
ly it
>     does not even need a new KVM capability because KVM_SET_IOREGIONFD
>     functionality shouldn't be touched.
>=20
> I thought it would be cleaner to have these protocols separate, but I cou=
ld
> also be wrong or over-engineering.

This makes sense to me if the wire protocol needs to become complex. For
now sticking to the simple control/data plane approach is what I would
suggest for security.

Stefan

--U3BNvdZEnlJXqmh+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/OQw0ACgkQnKSrs4Gr
c8iIpgf/X2xmXUC+aoi/QZjVwPf7oYcYOeypEl2uP26dJ0LqpQgG1gKgQQent8MU
0G5GurM5XgRG5jiFh+hQddJX1y4tp9DiW4CDGTXJ2EWiC5gedcHDH4IAS7hlOVP1
Gua5wIL3pUGOUbsjV2CAbtg0Chs0vLFI/5t4SFQ3am9qyOakSPlcw+1CJLMW9Q9A
ShQc6xQS/EBrL9rmYXNOqoFjypnYjFcszpAz9q20Tzd9S1dHGaJT6X13jeFHEpDG
YaYFftVZkCIvihT4sm/xtEQeZZHQexyglRy/nusgNnfWWh8562zHh6hW1x1A05vo
L1fcPDcfBSR3MVK4epAaNFN2aq84mA==
=qKLE
-----END PGP SIGNATURE-----

--U3BNvdZEnlJXqmh+--
