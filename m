Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367B07A4F2A
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjIRQfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjIRQez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:34:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F99028B69
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695053769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KEnkYg296WtOmgfRUE57PJ4oLhWmzs88dx68A5cViHk=;
        b=JWclkQER1QEDsusmu++4e6c8f934fi7K+yiLKrlDgVs27hKS0bWEMs++iydaDpeNXy4aAK
        PB2E8FuAv1n/Rwcyl9SDARjh/pBZdBDwC2paoJJMmPkF41XZz2FfgYAigyyJFmT4xiT8wV
        4cOvbSKO5DlmFfT7UVrFVN9KIw2qUgM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-cr41bOkWMNWtVt8JV0Vymw-1; Mon, 18 Sep 2023 10:15:29 -0400
X-MC-Unique: cr41bOkWMNWtVt8JV0Vymw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF0A6945924;
        Mon, 18 Sep 2023 14:15:28 +0000 (UTC)
Received: from localhost (unknown [10.39.195.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ABA5840C6EA8;
        Mon, 18 Sep 2023 14:15:27 +0000 (UTC)
Date:   Mon, 18 Sep 2023 10:15:21 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, David Laight <David.Laight@aculab.com>,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 2/3] vfio: use __aligned_u64 in struct
 vfio_device_gfx_plane_info
Message-ID: <20230918141521.GB1279696@fedora>
References: <20230829182720.331083-1-stefanha@redhat.com>
 <20230829182720.331083-3-stefanha@redhat.com>
 <20230915140458.392e436a.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T9LRd/OHSsH3oZV0"
Content-Disposition: inline
In-Reply-To: <20230915140458.392e436a.alex.williamson@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--T9LRd/OHSsH3oZV0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 15, 2023 at 02:04:58PM -0600, Alex Williamson wrote:
> On Tue, 29 Aug 2023 14:27:19 -0400
> Stefan Hajnoczi <stefanha@redhat.com> wrote:
>=20
> > The memory layout of struct vfio_device_gfx_plane_info is
> > architecture-dependent due to a u64 field and a struct size that is not
> > a multiple of 8 bytes:
> > - On x86_64 the struct size is padded to a multiple of 8 bytes.
> > - On x32 the struct size is only a multiple of 4 bytes, not 8.
> > - Other architectures may vary.
> >=20
> > Use __aligned_u64 to make memory layout consistent. This reduces the
> > chance of 32-bit userspace on a 64-bit kernel breakage.
> >=20
> > This patch increases the struct size on x32 but this is safe because of
> > the struct's argsz field. The kernel may grow the struct as long as it
> > still supports smaller argsz values from userspace (e.g. applications
> > compiled against older kernel headers).
> >=20
> > Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  include/uapi/linux/vfio.h        | 3 ++-
> >  drivers/gpu/drm/i915/gvt/kvmgt.c | 4 +++-
> >  samples/vfio-mdev/mbochs.c       | 6 ++++--
> >  samples/vfio-mdev/mdpy.c         | 4 +++-
> >  4 files changed, 12 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 94007ca348ed..777374dd7725 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -816,7 +816,7 @@ struct vfio_device_gfx_plane_info {
> >  	__u32 drm_plane_type;	/* type of plane: DRM_PLANE_TYPE_* */
> >  	/* out */
> >  	__u32 drm_format;	/* drm format of plane */
> > -	__u64 drm_format_mod;   /* tiled mode */
> > +	__aligned_u64 drm_format_mod;   /* tiled mode */
> >  	__u32 width;	/* width of plane */
> >  	__u32 height;	/* height of plane */
> >  	__u32 stride;	/* stride of plane */
> > @@ -829,6 +829,7 @@ struct vfio_device_gfx_plane_info {
> >  		__u32 region_index;	/* region index */
> >  		__u32 dmabuf_id;	/* dma-buf id */
> >  	};
> > +	__u32 reserved;
> >  };
> > =20
> >  #define VFIO_DEVICE_QUERY_GFX_PLANE _IO(VFIO_TYPE, VFIO_BASE + 14)
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gv=
t/kvmgt.c
> > index 9cd9e9da60dd..813cfef23453 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -1382,7 +1382,7 @@ static long intel_vgpu_ioctl(struct vfio_device *=
vfio_dev, unsigned int cmd,
> >  		intel_gvt_reset_vgpu(vgpu);
> >  		return 0;
> >  	} else if (cmd =3D=3D VFIO_DEVICE_QUERY_GFX_PLANE) {
> > -		struct vfio_device_gfx_plane_info dmabuf;
> > +		struct vfio_device_gfx_plane_info dmabuf =3D {};
> >  		int ret =3D 0;
> > =20
> >  		minsz =3D offsetofend(struct vfio_device_gfx_plane_info,
> > @@ -1392,6 +1392,8 @@ static long intel_vgpu_ioctl(struct vfio_device *=
vfio_dev, unsigned int cmd,
> >  		if (dmabuf.argsz < minsz)
> >  			return -EINVAL;
> > =20
> > +		minsz =3D min(dmabuf.argsz, sizeof(dmabuf));
> > +
> >  		ret =3D intel_vgpu_query_plane(vgpu, &dmabuf);
> >  		if (ret !=3D 0)
> >  			return ret;
> > diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> > index 3764d1911b51..78aa977ae597 100644
> > --- a/samples/vfio-mdev/mbochs.c
> > +++ b/samples/vfio-mdev/mbochs.c
> > @@ -1262,7 +1262,7 @@ static long mbochs_ioctl(struct vfio_device *vdev=
, unsigned int cmd,
> > =20
> >  	case VFIO_DEVICE_QUERY_GFX_PLANE:
> >  	{
> > -		struct vfio_device_gfx_plane_info plane;
> > +		struct vfio_device_gfx_plane_info plane =3D {};
> > =20
> >  		minsz =3D offsetofend(struct vfio_device_gfx_plane_info,
> >  				    region_index);
> > @@ -1273,11 +1273,13 @@ static long mbochs_ioctl(struct vfio_device *vd=
ev, unsigned int cmd,
> >  		if (plane.argsz < minsz)
> >  			return -EINVAL;
> > =20
> > +		outsz =3D min_t(unsigned long, plane.argsz, sizeof(plane));
>=20
> Sorry, I'm struggling with why these two sample drivers use min_t()
> when passed the exact same args as kvmgt above which just uses min().

min() would work fine here, too.

> But more importantly I'm also confused why we need this at all.  The
> buffer we're copying to is provided by the user, so what's wrong with
> leaving the user provided reserved data?  Are we just trying to return
> a zero'd reserved field if argsz allows for it?
>=20
> Any use of the reserved field other than as undefined data would need
> to be associated with a flags bit, so I don't think it's buying us
> anything to return it zero'd.  What am I missing?  Thanks,

I don't remember anymore and what you've described makes sense to me.
I'll remove this in the next revision.

Stefan

>=20
> Alex
>=20
> > +
> >  		ret =3D mbochs_query_gfx_plane(mdev_state, &plane);
> >  		if (ret)
> >  			return ret;
> > =20
> > -		if (copy_to_user((void __user *)arg, &plane, minsz))
> > +		if (copy_to_user((void __user *)arg, &plane, outsz))
> >  			return -EFAULT;
> > =20
> >  		return 0;
> > diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> > index 064e1c0a7aa8..f5c2effc1cec 100644
> > --- a/samples/vfio-mdev/mdpy.c
> > +++ b/samples/vfio-mdev/mdpy.c
> > @@ -591,7 +591,7 @@ static long mdpy_ioctl(struct vfio_device *vdev, un=
signed int cmd,
> > =20
> >  	case VFIO_DEVICE_QUERY_GFX_PLANE:
> >  	{
> > -		struct vfio_device_gfx_plane_info plane;
> > +		struct vfio_device_gfx_plane_info plane =3D {};
> > =20
> >  		minsz =3D offsetofend(struct vfio_device_gfx_plane_info,
> >  				    region_index);
> > @@ -602,6 +602,8 @@ static long mdpy_ioctl(struct vfio_device *vdev, un=
signed int cmd,
> >  		if (plane.argsz < minsz)
> >  			return -EINVAL;
> > =20
> > +		minsz =3D min_t(unsigned long, plane.argsz, sizeof(plane));
> > +
> >  		ret =3D mdpy_query_gfx_plane(mdev_state, &plane);
> >  		if (ret)
> >  			return ret;
>=20

--T9LRd/OHSsH3oZV0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUIW3gACgkQnKSrs4Gr
c8jxdggAqmEiI+Ao4OaZR6saj2CtHW15SNrDLvYpBv+e4N80qp00lQULYbe5FKEN
ogP+F1MtDy72BVFjvW/jjrUBuxko6s2lfT3fTLWzwk1ySYuc7g/dtCN5OxIRI1m5
KUFq8/fFcXJ9WjMoasvCNjTajeDHqS6dcUQuIuV8J02wdPUbiFC/gdotp1LmTY/O
E1x5wWmq2dD2EamXQrz8O9seWVSusdYQU5lTdnpHDpeOS89hvzUlfIARdFby/1Tf
OgJzYqfCCANZ3DEw7AGvZ9rPGSOgha6rQPAw3rPfDGrvMZ3lPd1DzlOxgLYs4MKF
4TvwNvX/VwOWwpKKlf+R5+VmD7h6Zg==
=AFe6
-----END PGP SIGNATURE-----

--T9LRd/OHSsH3oZV0--

