Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC582C844C
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 13:49:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726036AbgK3Msl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 07:48:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:22346 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbgK3Msk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Nov 2020 07:48:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606740434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SE0peqQRnn2fzC8E5zj7//ljEclCXVXCI/uFfBeiSNQ=;
        b=Z4CjcgJ9ZpszEIgKUWEoP2f3LLsSM0ovNu20/O8M007WkH3jW2C3IQ868/iG285RhC4YFT
        Jb2UIc+V0vSZbZpTiahFwNlxkwRFk6ng+D2mVh8XwiaKH8jE7IIK1+YASExSp+GsqaZ3Ki
        Lk7NElgKCSVNOcNKjE+rjVHlqrEhqFc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-sEQA9DnHNke2LagMQ_THdw-1; Mon, 30 Nov 2020 07:47:10 -0500
X-MC-Unique: sEQA9DnHNke2LagMQ_THdw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75EE380F04D;
        Mon, 30 Nov 2020 12:47:09 +0000 (UTC)
Received: from localhost (ovpn-115-30.ams2.redhat.com [10.36.115.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 022C027CA2;
        Mon, 30 Nov 2020 12:47:02 +0000 (UTC)
Date:   Mon, 30 Nov 2020 12:47:02 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org,
        mst@redhat.com, john.g.johnson@oracle.com, dinechin@redhat.com,
        cohuck@redhat.com, felipe@nutanix.com,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <20201130124702.GB422962@stefanha-x1.localdomain>
References: <CAFO2pHzmVf7g3z0RikQbYnejwcWRtHKV=npALs49eRDJdt4mJQ@mail.gmail.com>
 <0447ec50-6fe8-4f10-73db-e3feec2da61c@redhat.com>
 <20201126123659.GC1180457@stefanha-x1.localdomain>
 <c9f926fb-438c-9588-f018-dd040935e5e5@redhat.com>
 <20201127134403.GB46707@stefanha-x1.localdomain>
 <6001ed07-5823-365e-5235-8bfea0e72c7f@redhat.com>
MIME-Version: 1.0
In-Reply-To: <6001ed07-5823-365e-5235-8bfea0e72c7f@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 30, 2020 at 10:14:15AM +0800, Jason Wang wrote:
> On 2020/11/27 =E4=B8=8B=E5=8D=889:44, Stefan Hajnoczi wrote:
> > On Fri, Nov 27, 2020 at 11:39:23AM +0800, Jason Wang wrote:
> > > On 2020/11/26 =E4=B8=8B=E5=8D=888:36, Stefan Hajnoczi wrote:
> > > > On Thu, Nov 26, 2020 at 11:37:30AM +0800, Jason Wang wrote:
> > > > > On 2020/11/26 =E4=B8=8A=E5=8D=883:21, Elena Afanasova wrote:
> > > Or I wonder whether we can attach an eBPF program when trapping MMIO/=
PIO and
> > > allow it to decide how to proceed?
> > The eBPF program approach is interesting, but it would probably require
> > access to guest RAM and additional userspace state (e.g. device-specifi=
c
> > register values). I don't know the current status of Linux eBPF - is it
> > possible to access user memory (it could be swapped out)?
>=20
>=20
> AFAIK it doesn't, but just to make sure I understand, any reason that eBP=
F
> need to access userspace memory here?

Maybe we're thinking of different things. In the past I've thought about
using eBPF to avoid a trip to userspace for request submission and
completion, but that requires virtqueue parsing from eBPF and guest RAM
access.

Are you thinking about replacing ioctl(KVM_SET_IOREGION) and all the
necessary kvm.ko code with an ioctl(KVM_SET_IO_PROGRAM), where userspace
can load an eBPF program into kvm.ko that gets executed when an MMIO/PIO
accesses occur? Wouldn't it need to write to userspace memory to store
the ring index that was written to the doorbell register, for example?
How would the program communicate with userspace (eventfd isn't enough)
and how can it handle synchronous I/O accesses like reads?

Stefan

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/E6cUACgkQnKSrs4Gr
c8hUbQgAo7jexK7IdFgPGVxfRMuNL6niODhTY7oAwwh0xzUIhmJcT5uh6zdNC9qc
OVG99QB7fN7fOxUBMVJ7fLMG27UEeXZJ38iALGnVOCA6I2Ep6ekAdUBGducFKpkX
N+cY72Z6zWSN4inmCDUJjBLHEhl87k7y3qa3KmdULM78ArAwxxSTYtmiZX3amUxa
E7BfaCRMEa/AVzyNUj2m/TrO3oLzvEsukVmtZZsalFUCClZq6UmoI96wdgvZM6NR
UAyc5+JjXZa+HPZz875VhpzpP2r9rQBElkV/Hbn6tg7rMf/W0bLPD0FViV8UaDG1
8NPGOiy82Soolvi3QUpGps1YcjszWQ==
=wC1T
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--

