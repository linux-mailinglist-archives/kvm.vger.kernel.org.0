Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3137701DB
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 15:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbjHDNfQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 09:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjHDNe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 09:34:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F5349EF
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 06:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691156018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=45kQgiSBOKtBn30hl7nEzXbBLg6OZPFTU4+BCqs3KfA=;
        b=Pk61h+Tymqud4DhmtyBFjSURwe//ZFZo6tCAxTENOL5CqK3UW4+/srpyyeXSbw3hNJEqBi
        ITO1VJa2CWbpGe/B5BN/mCG9bEHgA4p3MjQ3LrShMqKm07WdevK2rJMUAlvdE0XNp0FM52
        TmKss16cr8UxOJWxfHoJK6xtvZyAm+I=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-7K0zDbZlMWSeqSeindt9Lw-1; Fri, 04 Aug 2023 09:33:33 -0400
X-MC-Unique: 7K0zDbZlMWSeqSeindt9Lw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 724CF1C0782E;
        Fri,  4 Aug 2023 13:33:33 +0000 (UTC)
Received: from localhost (unknown [10.39.192.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BAE044021CE;
        Fri,  4 Aug 2023 13:33:32 +0000 (UTC)
Date:   Fri, 4 Aug 2023 09:33:31 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: align capability structures
Message-ID: <20230804133331.GB2420180@fedora>
References: <20230803144109.2331944-1-stefanha@redhat.com>
 <20230803151823.4e5943e6.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="WVfC8m5JvGDBOPVz"
Content-Disposition: inline
In-Reply-To: <20230803151823.4e5943e6.alex.williamson@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--WVfC8m5JvGDBOPVz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 03, 2023 at 03:18:23PM -0600, Alex Williamson wrote:
> On Thu,  3 Aug 2023 10:41:09 -0400
> Stefan Hajnoczi <stefanha@redhat.com> wrote:
>=20
> > The VFIO_DEVICE_GET_INFO, VFIO_DEVICE_GET_REGION_INFO, and
> > VFIO_IOMMU_GET_INFO ioctls fill in an info struct followed by capability
> > structs:
> >=20
> >   +------+---------+---------+-----+
> >   | info | caps[0] | caps[1] | ... |
> >   +------+---------+---------+-----+
> >=20
> > Both the info and capability struct sizes are not always multiples of
> > sizeof(u64), leaving u64 fields in later capability structs misaligned.
> >=20
> > Userspace applications currently need to handle misalignment manually in
> > order to support CPU architectures and programming languages with strict
> > alignment requirements.
> >=20
> > Make life easier for userspace by ensuring alignment in the kernel.
> > The new layout is as follows:
> >=20
> >   +------+---+---------+---------+---+-----+
> >   | info | 0 | caps[0] | caps[1] | 0 | ... |
> >   +------+---+---------+---------+---+-----+
> >=20
> > In this example info and caps[1] have sizes that are not multiples of
> > sizeof(u64), so zero padding is added to align the subsequent structure.
> >=20
> > Adding zero padding between structs does not break the uapi. The memory
> > layout is specified by the info.cap_offset and caps[i].next fields
> > filled in by the kernel. Applications use these field values to locate
> > structs and are therefore unaffected by the addition of zero padding.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  include/linux/vfio.h             |  2 +-
> >  drivers/gpu/drm/i915/gvt/kvmgt.c |  7 +++--
> >  drivers/s390/cio/vfio_ccw_ops.c  |  7 +++--
> >  drivers/vfio/pci/vfio_pci_core.c | 14 ++++++---
> >  drivers/vfio/vfio_iommu_type1.c  |  7 +++--
> >  drivers/vfio/vfio_main.c         | 53 +++++++++++++++++++++++++++-----
> >  6 files changed, 71 insertions(+), 19 deletions(-)
> >=20
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index 2c137ea94a3e..ff0864e73cc3 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -272,7 +272,7 @@ struct vfio_info_cap {
> >  struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *c=
aps,
> >  					       size_t size, u16 id,
> >  					       u16 version);
> > -void vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset);
> > +ssize_t vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset);
> > =20
> >  int vfio_info_add_capability(struct vfio_info_cap *caps,
> >  			     struct vfio_info_cap_header *cap, size_t size);
> > diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gv=
t/kvmgt.c
> > index de675d799c7d..9060e9c6ac7c 100644
> > --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> > +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> > @@ -1297,7 +1297,10 @@ static long intel_vgpu_ioctl(struct vfio_device =
*vfio_dev, unsigned int cmd,
> >  				info.argsz =3D sizeof(info) + caps.size;
> >  				info.cap_offset =3D 0;
> >  			} else {
> > -				vfio_info_cap_shift(&caps, sizeof(info));
> > +				ssize_t cap_offset =3D vfio_info_cap_shift(&caps, sizeof(info));
> > +				if (cap_offset < 0)
> > +					return cap_offset;
> > +
> >  				if (copy_to_user((void __user *)arg +
> >  						  sizeof(info), caps.buf,
> >  						  caps.size)) {
> > @@ -1305,7 +1308,7 @@ static long intel_vgpu_ioctl(struct vfio_device *=
vfio_dev, unsigned int cmd,
> >  					kfree(sparse);
> >  					return -EFAULT;
> >  				}
> > -				info.cap_offset =3D sizeof(info);
> > +				info.cap_offset =3D cap_offset;
>=20
> The copy_to_user() above needs to be modified to make this true:
>=20
> 	copy_to_user((void __user *)arg + cap_offset,...
>=20
> Same for all similar below.

vfio_info_cap_shift() inserts zero padding before the first capability
in order to achieve alignment. The zero padding is part of caps.buf, not
the info struct. Therefore the copy_to_user((void __user *)arg +
sizeof(info), ...) is correct.

It's confusing though. Your suggestion for simplifying alignment below
looks good and will avoid this issue.

>=20
> >  			}
> > =20
> >  			kfree(caps.buf);
> > diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_cc=
w_ops.c
> > index 5b53b94f13c7..63d5163376a5 100644
> > --- a/drivers/s390/cio/vfio_ccw_ops.c
> > +++ b/drivers/s390/cio/vfio_ccw_ops.c
> > @@ -361,13 +361,16 @@ static int vfio_ccw_mdev_get_region_info(struct v=
fio_ccw_private *private,
> >  			info->argsz =3D sizeof(*info) + caps.size;
> >  			info->cap_offset =3D 0;
> >  		} else {
> > -			vfio_info_cap_shift(&caps, sizeof(*info));
> > +			ssize_t cap_offset =3D vfio_info_cap_shift(&caps, sizeof(*info));
> > +			if (cap_offset < 0)
> > +				return cap_offset;
> > +
> >  			if (copy_to_user((void __user *)arg + sizeof(*info),
> >  					 caps.buf, caps.size)) {
> >  				kfree(caps.buf);
> >  				return -EFAULT;
> >  			}
> > -			info->cap_offset =3D sizeof(*info);
> > +			info->cap_offset =3D cap_offset;
> >  		}
> > =20
> >  		kfree(caps.buf);
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_p=
ci_core.c
> > index 20d7b69ea6ff..92c093b99187 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -966,12 +966,15 @@ static int vfio_pci_ioctl_get_info(struct vfio_pc=
i_core_device *vdev,
> >  		if (info.argsz < sizeof(info) + caps.size) {
> >  			info.argsz =3D sizeof(info) + caps.size;
> >  		} else {
> > -			vfio_info_cap_shift(&caps, sizeof(info));
> > +			ssize_t cap_offset =3D vfio_info_cap_shift(&caps, sizeof(info));
> > +			if (cap_offset < 0)
> > +				return cap_offset;
> > +
> >  			if (copy_to_user(arg + 1, caps.buf, caps.size)) {
> >  				kfree(caps.buf);
> >  				return -EFAULT;
> >  			}
> > -			info.cap_offset =3D sizeof(*arg);
> > +			info.cap_offset =3D cap_offset;
> >  		}
> > =20
> >  		kfree(caps.buf);
> > @@ -1107,12 +1110,15 @@ static int vfio_pci_ioctl_get_region_info(struc=
t vfio_pci_core_device *vdev,
> >  			info.argsz =3D sizeof(info) + caps.size;
> >  			info.cap_offset =3D 0;
> >  		} else {
> > -			vfio_info_cap_shift(&caps, sizeof(info));
> > +			ssize_t cap_offset =3D vfio_info_cap_shift(&caps, sizeof(info));
> > +			if (cap_offset < 0)
> > +				return cap_offset;
> > +
> >  			if (copy_to_user(arg + 1, caps.buf, caps.size)) {
> >  				kfree(caps.buf);
> >  				return -EFAULT;
> >  			}
> > -			info.cap_offset =3D sizeof(*arg);
> > +			info.cap_offset =3D cap_offset;
> >  		}
> > =20
> >  		kfree(caps.buf);
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_=
type1.c
> > index ebe0ad31d0b0..ab64b9e3ed7c 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -2808,14 +2808,17 @@ static int vfio_iommu_type1_get_info(struct vfi=
o_iommu *iommu,
> >  		if (info.argsz < sizeof(info) + caps.size) {
> >  			info.argsz =3D sizeof(info) + caps.size;
> >  		} else {
> > -			vfio_info_cap_shift(&caps, sizeof(info));
> > +			ssize_t cap_offset =3D vfio_info_cap_shift(&caps, sizeof(info));
> > +			if (cap_offset < 0)
> > +				return cap_offset;
> > +
> >  			if (copy_to_user((void __user *)arg +
> >  					sizeof(info), caps.buf,
> >  					caps.size)) {
> >  				kfree(caps.buf);
> >  				return -EFAULT;
> >  			}
> > -			info.cap_offset =3D sizeof(info);
> > +			info.cap_offset =3D cap_offset;
> >  		}
> > =20
> >  		kfree(caps.buf);
> > diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> > index f0ca33b2e1df..4fc8698577a7 100644
> > --- a/drivers/vfio/vfio_main.c
> > +++ b/drivers/vfio/vfio_main.c
> > @@ -1171,8 +1171,18 @@ struct vfio_info_cap_header *vfio_info_cap_add(s=
truct vfio_info_cap *caps,
> >  {
> >  	void *buf;
> >  	struct vfio_info_cap_header *header, *tmp;
> > +	size_t header_offset;
> > +	size_t new_size;
> > =20
> > -	buf =3D krealloc(caps->buf, caps->size + size, GFP_KERNEL);
> > +	/*
> > +	 * Reserve extra space when the previous capability was not a multipl=
e of
> > +	 * the largest field size. This ensures that capabilities are properly
> > +	 * aligned.
> > +	 */
>=20
> If we simply start with:
>=20
> 	size =3D ALIGN(size, sizeof(u64));
>=20
> then shouldn't there never be a previous misaligned size to correct?

Yes, I applied padding at the beginning but it could be applied at the
end instead.

> I wonder if we really need all this complexity, we're drawing from a
> finite set of info structs for the initial alignment, we can pad those
> without breaking the uapi and we can introduce a warning to avoid such
> poor alignment in the future.  Allocating an aligned size for each
> capability is then sufficiently trivial to handle runtime.  ex:
>=20
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 902f06e52c48..2d074cbd371d 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1362,6 +1362,8 @@ struct vfio_info_cap_header *vfio_info_cap_add(stru=
ct vfio_info_cap *caps,
>  	void *buf;
>  	struct vfio_info_cap_header *header, *tmp;
> =20
> +	size =3D ALIGN(size, sizeof(u64));
> +
>  	buf =3D krealloc(caps->buf, caps->size + size, GFP_KERNEL);
>  	if (!buf) {
>  		kfree(caps->buf);
> @@ -1395,6 +1397,8 @@ void vfio_info_cap_shift(struct vfio_info_cap *caps=
, size_t offset)
>  	struct vfio_info_cap_header *tmp;
>  	void *buf =3D (void *)caps->buf;
> =20
> +	WARN_ON(!IS_ALIGNED(offset, sizeof(u64)));
> +
>  	for (tmp =3D buf; tmp->next; tmp =3D buf + tmp->next - offset)
>  		tmp->next +=3D offset;
>  }
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index fa06e3eb4955..fd2761841ffe 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -217,6 +217,7 @@ struct vfio_device_info {
>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */
> +	__u32	pad;		/* Size must be aligned for caps */
>  };
>  #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
> =20
> @@ -1444,6 +1445,7 @@ struct vfio_iommu_type1_info {
>  #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
>  	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
>  	__u32   cap_offset;	/* Offset within info struct of first cap */
> +	__u32	pad;		/* Size must be aligned for caps */
>  };
> =20
>  /*

Yes, that's much simpler. I'll send another revision that follows that
approach.

Stefan

--WVfC8m5JvGDBOPVz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmTM/ioACgkQnKSrs4Gr
c8g3Pwf3VG15v3+GS4X743P+y7AcUWisX6pcKLfbyw9SzCGTycNPl7cu+eEqvDyV
uBBDH1CTJsT5NrmHLwitDvOG8/SpaAIX+YFePSHNbPYLQvgnhCk+fRn+neRoAt6s
+EXr1DmOgrngGRnLKmQTg8Dj7p6FeEchdu8kAOahrI3WgIPrph6dBsh2bDxEsNM3
ymVIw2huG+hW6fbOqwMNsr6D1PWIJnvOQPG/RaULvCzGHQCabxpnqHXXobsDOfK3
WkeXsX6vKB79CrKRbvYSpc09yFBinallWJquQDB6xgP535NVR4roG8XhDRhKIOFe
CeLdhHzp3V13yom1b3KfibwzihbR
=Rd+O
-----END PGP SIGNATURE-----

--WVfC8m5JvGDBOPVz--

