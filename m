Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519522CD478
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 12:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgLCLVf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 06:21:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgLCLVe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 06:21:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606994407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aBnaYUr0lw2ghf4vmO9i9+7oCpgPHb/5P4+nJOj15wY=;
        b=VnredGAuZzKFKRlE483nz0ANWa801m6vST0gSvTZBS0IVsXDT94eZ7wxIJ+8jp5r7jzC53
        TtoQI24af9l8IokEgVVC2VRRaI5EXs0D2LI+vbxH4NRr6+SqAnL1WeW6WCh8yF1GCiUHg8
        sx3g0DCJEbs5+t637rqG897UE9ffY3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-b8fq0J7ZPTafWVTglXTe2Q-1; Thu, 03 Dec 2020 06:20:05 -0500
X-MC-Unique: b8fq0J7ZPTafWVTglXTe2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 241C2A40CE;
        Thu,  3 Dec 2020 11:20:04 +0000 (UTC)
Received: from localhost (ovpn-115-46.ams2.redhat.com [10.36.115.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2E0A5C1B4;
        Thu,  3 Dec 2020 11:20:03 +0000 (UTC)
Date:   Thu, 3 Dec 2020 11:20:02 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Justin He <Justin.He@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Message-ID: <20201203112002.GE689053@stefanha-x1.localdomain>
References: <20201119142737.17574-1-justin.he@arm.com>
 <20201124181228.GA276043@xz-x1>
 <AM6PR08MB32245E7F990955395B44CE6BF7FA0@AM6PR08MB3224.eurprd08.prod.outlook.com>
 <20201125155711.GA6489@xz-x1>
 <20201202143356.GK655829@stefanha-x1.localdomain>
 <20201202154511.GI3277@xz-x1>
MIME-Version: 1.0
In-Reply-To: <20201202154511.GI3277@xz-x1>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pY3vCvL1qV+PayAL"
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--pY3vCvL1qV+PayAL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 02, 2020 at 10:45:11AM -0500, Peter Xu wrote:
> On Wed, Dec 02, 2020 at 02:33:56PM +0000, Stefan Hajnoczi wrote:
> > On Wed, Nov 25, 2020 at 10:57:11AM -0500, Peter Xu wrote:
> > > On Wed, Nov 25, 2020 at 01:05:25AM +0000, Justin He wrote:
> > > > > I'd appreciate if you could explain why vfio needs to dma map som=
e
> > > > > PROT_NONE
> > > >=20
> > > > Virtiofs will map a PROT_NONE cache window region firstly, then rem=
ap the sub
> > > > region of that cache window with read or write permission. I guess =
this might
> > > > be an security concern. Just CC virtiofs expert Stefan to answer it=
 more accurately.
> > >=20
> > > Yep.  Since my previous sentence was cut off, I'll rephrase: I was th=
inking
> > > whether qemu can do vfio maps only until it remaps the PROT_NONE regi=
ons into
> > > PROT_READ|PROT_WRITE ones, rather than trying to map dma pages upon P=
ROT_NONE.
> >=20
> > Userspace processes sometimes use PROT_NONE to reserve virtual address
> > space. That way future mmap(NULL, ...) calls will not accidentally
> > allocate an address from the reserved range.
> >=20
> > virtio-fs needs to do this because the DAX window mappings change at
> > runtime. Initially the entire DAX window is just reserved using
> > PROT_NONE. When it's time to mmap a portion of a file into the DAX
> > window an mmap(fixed_addr, ...) call will be made.
>=20
> Yes I can understand the rational on why the region is reserved.  However=
 IMHO
> the real question is why such reservation behavior should affect qemu mem=
ory
> layout, and even further to VFIO mappings.
>=20
> Note that PROT_NONE should likely mean that there's no backing page at al=
l in
> this case.  Since vfio will pin all the pages before mapping the DMAs, it=
 also
> means that it's at least inefficient, because when we try to map all the
> PROT_NONE pages we'll try to fault in every single page of it, even if th=
ey may
> not ever be used.
>=20
> So I still think this patch is not doing the right thing.  Instead we sho=
uld
> somehow teach qemu that the virtiofs memory region should only be the siz=
e of
> enabled regions (with PROT_READ|PROT_WRITE), rather than the whole reserv=
ed
> PROT_NONE region.

virtio-fs was not implemented with IOMMUs in mind. The idea is just to
install a kvm.ko memory region that exposes the DAX window.

Perhaps we need to treat the DAX window like an IOMMU? That way the
virtio-fs code can send map/unmap notifications and hw/vfio/ can
propagate them to the host kernel.

Stefan

--pY3vCvL1qV+PayAL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/IyeIACgkQnKSrs4Gr
c8iF/Af+JSgK6lDLW2cHuI6L3u9Vn1woF5DUnLlLyyXJ+JaSu1iT2HN9Fvp8FQuW
651zMyqbvCGiuFqOD3MwP0umjJFoIq4F0ljrLmEySbatQQBinv5aybBYyjSheyx7
Fqm1rhtsGtvbshhpWwwRJ2wo4w/LKlFTaFYGVzlP6gFdLBaaekxt8yxI+xzfZ6O1
CiJkRN5XL8vxLj/QAxP10UY9Dq+apPXmqeGmGKxE9tLpAbRAdLUmz3xfVZOZc9Cl
NVRUH652bL3B0PwLkmz7g4qS3zXrJjzVHVQ9KG9Nrijog+T1nk/0sUY4nr+rJI6o
NZspGjfYJQNLzqxe8NQ3ZIo4B1HSNw==
=hx6l
-----END PGP SIGNATURE-----

--pY3vCvL1qV+PayAL--

