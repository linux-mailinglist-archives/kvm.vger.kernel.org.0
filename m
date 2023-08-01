Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA7EC76BDAB
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 21:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbjHATZE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Aug 2023 15:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232366AbjHATYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Aug 2023 15:24:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E18199F
        for <kvm@vger.kernel.org>; Tue,  1 Aug 2023 12:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690917832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2M7D2+uxCtAadPDyLgt7GBKp7WXr6ICJfQraK6HnRS0=;
        b=gKMFKV3mWwcI5oSiyXEgj8DhdrQFHuDboIqKTRqaTndgf0+cEaa/e2UvM4Od+2oyQjrlyu
        JjV+jEsVwZJ0bj3fYJmKBAx0T20517pZmOlH+r3tz3qMkEOBo/12qX58ZJ/0hHPeID/2KC
        E2o4q/WqWfiD0SLbqfqrlEHWHpnlkMU=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-w7oRwQd7OASQR0HV7h5RMQ-1; Tue, 01 Aug 2023 15:23:49 -0400
X-MC-Unique: w7oRwQd7OASQR0HV7h5RMQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7206D1C060C4;
        Tue,  1 Aug 2023 19:23:49 +0000 (UTC)
Received: from localhost (unknown [10.39.192.73])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF753C57967;
        Tue,  1 Aug 2023 19:23:47 +0000 (UTC)
Date:   Tue, 1 Aug 2023 15:23:45 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio/type1: fix cap_migration information leak
Message-ID: <20230801192345.GA1414936@fedora>
References: <20230801155352.1391945-1-stefanha@redhat.com>
 <20230801103114.757d7992.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0CjF++Sq7XzfS4wJ"
Content-Disposition: inline
In-Reply-To: <20230801103114.757d7992.alex.williamson@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--0CjF++Sq7XzfS4wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 01, 2023 at 10:31:14AM -0600, Alex Williamson wrote:
> On Tue,  1 Aug 2023 11:53:52 -0400
> Stefan Hajnoczi <stefanha@redhat.com> wrote:
>=20
> > Fix an information leak where an uninitialized hole in struct
> > vfio_iommu_type1_info_cap_migration on the stack is exposed to userspac=
e.
> >=20
> > The definition of struct vfio_iommu_type1_info_cap_migration contains a=
 hole as
> > shown in this pahole(1) output:
> >=20
> >   struct vfio_iommu_type1_info_cap_migration {
> >           struct vfio_info_cap_header header;              /*     0    =
 8 */
> >           __u32                      flags;                /*     8    =
 4 */
> >=20
> >           /* XXX 4 bytes hole, try to pack */
> >=20
> >           __u64                      pgsize_bitmap;        /*    16    =
 8 */
> >           __u64                      max_dirty_bitmap_size; /*    24   =
  8 */
> >=20
> >           /* size: 32, cachelines: 1, members: 4 */
> >           /* sum members: 28, holes: 1, sum holes: 4 */
> >           /* last cacheline: 32 bytes */
> >   };
> >=20
> > The cap_mig variable is filled in without initializing the hole:
> >=20
> >   static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
> >                          struct vfio_info_cap *caps)
> >   {
> >       struct vfio_iommu_type1_info_cap_migration cap_mig;
> >=20
> >       cap_mig.header.id =3D VFIO_IOMMU_TYPE1_INFO_CAP_MIGRATION;
> >       cap_mig.header.version =3D 1;
> >=20
> >       cap_mig.flags =3D 0;
> >       /* support minimum pgsize */
> >       cap_mig.pgsize_bitmap =3D (size_t)1 << __ffs(iommu->pgsize_bitmap=
);
> >       cap_mig.max_dirty_bitmap_size =3D DIRTY_BITMAP_SIZE_MAX;
> >=20
> >       return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap=
_mig));
> >   }
> >=20
> > The structure is then copied to a temporary location on the heap. At th=
is point
> > it's already too late and ioctl(VFIO_IOMMU_GET_INFO) copies it to users=
pace
> > later:
> >=20
> >   int vfio_info_add_capability(struct vfio_info_cap *caps,
> >                    struct vfio_info_cap_header *cap, size_t size)
> >   {
> >       struct vfio_info_cap_header *header;
> >=20
> >       header =3D vfio_info_cap_add(caps, size, cap->id, cap->version);
> >       if (IS_ERR(header))
> >           return PTR_ERR(header);
> >=20
> >       memcpy(header + 1, cap + 1, size - sizeof(*header));
> >=20
> >       return 0;
> >   }
> >=20
> > This issue was found by code inspection.
>=20
> LGTM, but missing:
>=20
> Fixes: ad721705d09c ("vfio iommu: Add migration capability to report supp=
orted features")
>=20
> I'll give a bit for further comments/reviews and queue it for v6.6 with
> the above update.  Thanks,

Great, thanks for squashing in the "Fixes" line that I forgot.

Stefan

--0CjF++Sq7XzfS4wJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmTJW8EACgkQnKSrs4Gr
c8gIVAf8DE2gcidYmywXZWL207MyVOVVJNJ59lICK3bNWX3DfaBlXF67fKU8zzZM
2Mi55gSKvhPLcluyAiSuLnKlB00TKRATlrBTxXtG4q5Ps6SxbE+tzc0KNZVvSNTl
9eK+at3FddLX0nbLKO/rkNFcK74rP20crr6W/Hy6SnHAI8KRYd3LO7+bfg+kgq8g
a0AeCk5iwL73lEJrXZaVo6loDBq7H0JUoupt5j87HtO+XYXRzfFZ/vCci0LyEFI4
n+WO3DUXGALN4Z4rUyDaG0oZkC30sz7hmsP71FtT4uEAqeY8Qi3BufVFM2IghXT4
FKOs9Z49Jw7JfYDp1EhkbdeAas9nmg==
=e8Ic
-----END PGP SIGNATURE-----

--0CjF++Sq7XzfS4wJ--

