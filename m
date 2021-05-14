Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37B038084E
	for <lists+kvm@lfdr.de>; Fri, 14 May 2021 13:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbhENLSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 May 2021 07:18:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46246 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229554AbhENLST (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 May 2021 07:18:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620991027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W5RwLAOv+5zDhb48jm8eBhCuuthZufD7RucTO6jQQpQ=;
        b=RTT6z3JIc0mTNwoZthVRrpqm/aHsC7P7vClmjkRKpBxnYJ1yMHbovnQOzP1/K+JCRIzxzD
        UGNp6hWDbjmu9sK1r0Qpq0W10B+fFFVf/eQ4/27zNqsRrUFG+pd5j8rBJawPZTOBiF02Nr
        +Gq8/1kruH77iuYnBOa8Cgyfpblrgp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-586-DgMMW04FOaWydBgputb3pw-1; Fri, 14 May 2021 07:17:03 -0400
X-MC-Unique: DgMMW04FOaWydBgputb3pw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 836841854E27;
        Fri, 14 May 2021 11:17:02 +0000 (UTC)
Received: from localhost (ovpn-114-20.ams2.redhat.com [10.36.114.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6E1A19C59;
        Fri, 14 May 2021 11:16:58 +0000 (UTC)
Date:   Fri, 14 May 2021 12:16:57 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        xieyongji@bytedance.com, file@sect.tu-berlin.de,
        ashish.kalra@amd.com, konrad.wilk@oracle.com,
        kvm <kvm@vger.kernel.org>, hch@infradead.org
Subject: Re: [RFC PATCH V2 0/7] Do not read from descripto ring
Message-ID: <YJ5cKe0egklXDpng@stefanha-x1.localdomain>
References: <20210423080942.2997-1-jasowang@redhat.com>
 <YJ1TgoFSwOkQrC+1@stefanha-x1.localdomain>
 <CACGkMEv0uWd+X87cYoG-GGjTXBvRztp2CY3RKyq9jFbSYK1n0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sVPgGJkF/8l4V9c1"
Content-Disposition: inline
In-Reply-To: <CACGkMEv0uWd+X87cYoG-GGjTXBvRztp2CY3RKyq9jFbSYK1n0Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--sVPgGJkF/8l4V9c1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 14, 2021 at 03:29:20PM +0800, Jason Wang wrote:
> On Fri, May 14, 2021 at 12:27 AM Stefan Hajnoczi <stefanha@redhat.com> wr=
ote:
> >
> > On Fri, Apr 23, 2021 at 04:09:35PM +0800, Jason Wang wrote:
> > > Sometimes, the driver doesn't trust the device. This is usually
> > > happens for the encrtpyed VM or VDUSE[1].
> >
> > Thanks for doing this.
> >
> > Can you describe the overall memory safety model that virtio drivers
> > must follow?
>=20
> My understanding is that, basically the driver should not trust the
> device (since the driver doesn't know what kind of device that it
> tries to drive)
>=20
> 1) For any read only metadata (required at the spec level) which is
> mapped as coherent, driver should not depend on the metadata that is
> stored in a place that could be wrote by the device. This is what this
> series tries to achieve.
> 2) For other metadata that is produced by the device, need to make
> sure there's no malicious device triggered behavior, this is somehow
> similar to what vhost did. No DOS, loop, kernel bug and other stuffs.
> 3) swiotb is a must to enforce memory access isolation. (VDUSE or encrypt=
ed VM)
>=20
> > For example:
> >
> > - Driver-to-device buffers must be on dedicated pages to avoid
> >   information leaks.
>=20
> It looks to me if swiotlb is used, we don't need this since the
> bouncing is not done at byte not page.
>=20
> But if swiotlb is not used, we need to enforce this.
>=20
> >
> > - Driver-to-device buffers must be on dedicated pages to avoid memory
> >   corruption.
>=20
> Similar to the above.
>=20
> >
> > When I say "pages" I guess it's the IOMMU page size that matters?
> >
>=20
> And the IOTLB page size.
>=20
> > What is the memory access granularity of VDUSE?
>=20
> It has an swiotlb, but the access and bouncing is done per byte.
>=20
> >
> > I'm asking these questions because there is driver code that exposes
> > kernel memory to the device and I'm not sure it's safe. For example:
> >
> >   static int virtblk_add_req(struct virtqueue *vq, struct virtblk_req *=
vbr,
> >                   struct scatterlist *data_sg, bool have_data)
> >   {
> >           struct scatterlist hdr, status, *sgs[3];
> >           unsigned int num_out =3D 0, num_in =3D 0;
> >
> >           sg_init_one(&hdr, &vbr->out_hdr, sizeof(vbr->out_hdr));
> >                             ^^^^^^^^^^^^^
> >           sgs[num_out++] =3D &hdr;
> >
> >           if (have_data) {
> >                   if (vbr->out_hdr.type & cpu_to_virtio32(vq->vdev, VIR=
TIO_BLK_T_OUT))
> >                           sgs[num_out++] =3D data_sg;
> >                   else
> >                           sgs[num_out + num_in++] =3D data_sg;
> >           }
> >
> >           sg_init_one(&status, &vbr->status, sizeof(vbr->status));
> >                                ^^^^^^^^^^^^
> >           sgs[num_out + num_in++] =3D &status;
> >
> >           return virtqueue_add_sgs(vq, sgs, num_out, num_in, vbr, GFP_A=
TOMIC);
> >   }
> >
> > I guess the drivers don't need to be modified as long as swiotlb is used
> > to bounce the buffers through "insecure" memory so that the memory
> > surrounding the buffers is not exposed?
>=20
> Yes, swiotlb won't bounce the whole page. So I think it's safe.

Thanks Jason and Yongji Xie for clarifying. Seems like swiotlb or a
similar mechanism can handle byte-granularity isolation so the drivers
not need to worry about information leaks or memory corruption outside
the mapped byte range.

We still need to audit virtio guest drivers to ensure they don't trust
data that can be modified by the device. I will look at virtio-blk and
virtio-fs next week.

Stefan

--sVPgGJkF/8l4V9c1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCeXCcACgkQnKSrs4Gr
c8jF+gf/Vtd4SZNzIhFTDB1G04GVxoQ088UYgie1YzPOdUKdocbXMekhi5sIbbpY
YnyX2xxK2Lw/HEax3ORpIBfz+6KhQQUIfYvhFMGcdQVdmann2+3HcI7iY+pJRHoi
oc+EJkRUqKMktvoTwygmK7Hqef0BY7CyXVl/Ku/P2jgMY5+IP7KbQ8GNIekiVXq9
Me/+kRXKmdQ8H31IClIt2C0NmJbLtGMlVj/BZ12xB63CmcV+LeoRsgvE3kRh7y6P
cNN7YKplOTQb8WyHj13Iparzo9I44T2jOtSmNxpB9AC57kNZ3/hQYdB/g/jRUihn
xjVZ7isEemqTD8OzFHs3RWdfIfy7SA==
=2ehA
-----END PGP SIGNATURE-----

--sVPgGJkF/8l4V9c1--

