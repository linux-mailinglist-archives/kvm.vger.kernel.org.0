Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D602343DCD9
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 10:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhJ1IQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 04:16:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230100AbhJ1IQy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 28 Oct 2021 04:16:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635408867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cDuOiyvsuW5iZzHfKwncUU1ksOibBW1HjvLFDhVTp80=;
        b=SzfYZwpxtrWiOfCJDE+LJ/qM97QDlcptZFNV/ojGEk1UVpeyIZP1ludOsxUg6JyXDD5aM4
        2qrl+tZcQASGfQBozzXZzzOamzG1GoxFHTgsJOHMmg12V2lU2rAHBXAPNw6xYJsyR5gMky
        FlpRQs0NgQMXi6mUEoEppSLMfKP68Sk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-IDBgccwHNOu-sOzrvvQ5Dg-1; Thu, 28 Oct 2021 04:14:24 -0400
X-MC-Unique: IDBgccwHNOu-sOzrvvQ5Dg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7C2D2101796C;
        Thu, 28 Oct 2021 08:14:22 +0000 (UTC)
Received: from localhost (unknown [10.39.194.138])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 266645D740;
        Thu, 28 Oct 2021 08:14:13 +0000 (UTC)
Date:   Thu, 28 Oct 2021 09:14:13 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     John Levon <levon@movementarian.org>
Cc:     Elena <elena.ufimtseva@oracle.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, mst@redhat.com, john.g.johnson@oracle.com,
        dinechin@redhat.com, cohuck@redhat.com, jasowang@redhat.com,
        felipe@nutanix.com, jag.raman@oracle.com, eafanasova@gmail.com
Subject: Re: MMIO/PIO dispatch file descriptors (ioregionfd) design discussion
Message-ID: <YXpb1f3KicZxj1oj@stefanha-x1.localdomain>
References: <88ca79d2e378dcbfb3988b562ad2c16c4f929ac7.camel@gmail.com>
 <YWUeZVnTVI7M/Psr@heatpipe>
 <YXamUDa5j9uEALYr@stefanha-x1.localdomain>
 <20211025152122.GA25901@nuker>
 <YXhQk/Sh0nLOmA2n@movementarian.org>
 <YXkmx3V0VklA6qHl@stefanha-x1.localdomain>
 <YXlEhCYAJuhsVwDv@movementarian.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cwItEpQlM3dmBURJ"
Content-Disposition: inline
In-Reply-To: <YXlEhCYAJuhsVwDv@movementarian.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--cwItEpQlM3dmBURJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 27, 2021 at 01:22:28PM +0100, John Levon wrote:
> On Wed, Oct 27, 2021 at 11:15:35AM +0100, Stefan Hajnoczi wrote:
>=20
> > > > I like this approach as well.
> > > > As you have mentioned, the device emulation code with first approach
> > > > does have to how to handle the region accesses. The second approach=
 will
> > > > make things more transparent. Let me see how can I modify what ther=
e is
> > > > there now and may ask further questions.
> > >=20
> > > Sorry I'm a bit late to this discussion, I'm not clear on the above W=
RT
> > > vfio-user. If an ioregionfd has to cover a whole BAR0 (?), how would =
this
> > > interact with partly-mmap()able regions like we do with SPDK/vfio-use=
r/NVMe?
> >=20
> > The ioregionfd doesn't need to cover an entire BAR. QEMU's MemoryRegions
> > form a hierarchy, so it's possible to sub-divide the BAR into several
> > MemoryRegions.
>=20
> I think you're saying that when vfio-user client in qemu calls
> VFIO_USER_DEVICE_GET_REGION_IO_FDS, it would create a sub-MR correspondin=
g to
> each one, before asking KVM to configure them?

Yes. Actually I wasn't thinking of the vfio-user client but just about
QEMU device emulation code in general. What you suggested sounds like a
clean mapping from MemoryRegions to vfio-user.

Stefan

--cwItEpQlM3dmBURJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmF6W9UACgkQnKSrs4Gr
c8i+hwgAyCI2iGTHLFwogMjJbsa9jdKXiwENuqVpyhbeW7ov29LHVODiRJX0FvDj
RhQRePoHohxQSaMU2czi5re+0QD6QoVpSnTuhsWkoBHH6LUQJgT+WP5la2AItplG
YBeE7KdtEqpkRVKrRlvZMTGEbg4+rSLh80fdyh6owqFw531pOtlvZjx6Qpdj+rwb
UbOv//OuSq/RJGsi3ZDsL0ifUctKS4+NUIcxawjTvprbpLY5jnSdarxgjEKn2NJh
axhKFgV0D+DaU9xxrtLl12uqI1cGrY07gPEhiDI5bTMmc91OtMZJ9OxHEnDX7CVn
pS/A+nv2kQq74Y/LqT3lIWGVpeJMmA==
=4x+E
-----END PGP SIGNATURE-----

--cwItEpQlM3dmBURJ--

