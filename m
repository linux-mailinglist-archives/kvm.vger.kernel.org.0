Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261F3512B89
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 08:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243807AbiD1GbZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 02:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235906AbiD1GbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 02:31:22 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3014CCD5
        for <kvm@vger.kernel.org>; Wed, 27 Apr 2022 23:28:08 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4Kplzp22Nrz4ySX; Thu, 28 Apr 2022 16:28:06 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1651127286;
        bh=0B814dxJaRNgHX0ymjMRCIz8UmihQ/9vE3ArZl89JR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F5Eijx8JxkipF5SM1J8vW/ZfFNU/gTPsGs4qkl0tPl6dhJy/+aQByH4C4TzEW+AYl
         jWOjyJkf70DA0sMIlS2X5jtVCTdJCoujW1FXtPcHkCwokuQECRvVUoscQyJj2pvi57
         cTiJLrWcQAAXM0zbY3WGdH3wvQFJxFNzaBs8jjOM=
Date:   Thu, 28 Apr 2022 15:58:30 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <YmotBkM103HqanoZ@yekko>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <YkUvzfHM00FEAemt@yekko>
 <20220331125841.GG2120790@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="332gL9uvgMOgNnaU"
Content-Disposition: inline
In-Reply-To: <20220331125841.GG2120790@nvidia.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--332gL9uvgMOgNnaU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 31, 2022 at 09:58:41AM -0300, Jason Gunthorpe wrote:
> On Thu, Mar 31, 2022 at 03:36:29PM +1100, David Gibson wrote:
>=20
> > > +/**
> > > + * struct iommu_ioas_iova_ranges - ioctl(IOMMU_IOAS_IOVA_RANGES)
> > > + * @size: sizeof(struct iommu_ioas_iova_ranges)
> > > + * @ioas_id: IOAS ID to read ranges from
> > > + * @out_num_iovas: Output total number of ranges in the IOAS
> > > + * @__reserved: Must be 0
> > > + * @out_valid_iovas: Array of valid IOVA ranges. The array length is=
 the smaller
> > > + *                   of out_num_iovas or the length implied by size.
> > > + * @out_valid_iovas.start: First IOVA in the allowed range
> > > + * @out_valid_iovas.last: Inclusive last IOVA in the allowed range
> > > + *
> > > + * Query an IOAS for ranges of allowed IOVAs. Operation outside thes=
e ranges is
> > > + * not allowed. out_num_iovas will be set to the total number of iov=
as
> > > + * and the out_valid_iovas[] will be filled in as space permits.
> > > + * size should include the allocated flex array.
> > > + */
> > > +struct iommu_ioas_iova_ranges {
> > > +	__u32 size;
> > > +	__u32 ioas_id;
> > > +	__u32 out_num_iovas;
> > > +	__u32 __reserved;
> > > +	struct iommu_valid_iovas {
> > > +		__aligned_u64 start;
> > > +		__aligned_u64 last;
> > > +	} out_valid_iovas[];
> > > +};
> > > +#define IOMMU_IOAS_IOVA_RANGES _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_IO=
VA_RANGES)
> >=20
> > Is the information returned by this valid for the lifeime of the IOAS,
> > or can it change?  If it can change, what events can change it?
> >
> > If it *can't* change, then how do we have enough information to
> > determine this at ALLOC time, since we don't necessarily know which
> > (if any) hardware IOMMU will be attached to it.
>=20
> It is a good point worth documenting. It can change. Particularly
> after any device attachment.

Right.. this is vital and needs to be front and centre in the
comments/docs here.  Really, I think an interface that *doesn't* have
magically changing status would be better (which is why I was
advocating that the user set the constraints, and the kernel supplied
or failed outright).  Still I recognize that has its own problems.

> I added this:
>=20
>  * Query an IOAS for ranges of allowed IOVAs. Mapping IOVA outside these =
ranges
>  * is not allowed. out_num_iovas will be set to the total number of iovas=
 and
>  * the out_valid_iovas[] will be filled in as space permits. size should =
include
>  * the allocated flex array.
>  *
>  * The allowed ranges are dependent on the HW path the DMA operation take=
s, and
>  * can change during the lifetime of the IOAS. A fresh empty IOAS will ha=
ve a
>  * full range, and each attached device will narrow the ranges based on t=
hat
>  * devices HW restrictions.

I think you need to be even more explicit about this: which exact
operations on the fd can invalidate exactly which items in the
information from this call?  Can it only ever be narrowed, or can it
be broadened with any operations?

> > > +#define IOMMU_IOAS_COPY _IO(IOMMUFD_TYPE, IOMMUFD_CMD_IOAS_COPY)
> >=20
> > Since it can only copy a single mapping, what's the benefit of this
> > over just repeating an IOAS_MAP in the new IOAS?
>=20
> It causes the underlying pin accounting to be shared and can avoid
> calling GUP entirely.

If that's the only purpose, then that needs to be right here in the
comments too.  So is expected best practice to IOAS_MAP everything you
might want to map into a sort of "scratch" IOAS, then IOAS_COPY the
mappings you actually end up wanting into the "real" IOASes for use?

Seems like it would be nicer for the interface to just figure it out
for you: I can see there being sufficient complications with that to
have this slightly awkward interface, but I think it needs a rationale
to accompany it.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--332gL9uvgMOgNnaU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmJqLP8ACgkQgypY4gEw
YSJQhBAA0vbPYQkWajyUkrm7VrSShNBVj1XxBrzWLMKazGvweToud0V0W4HfBQo5
ju0BEq6McEvCbqpCgJz8K4lrVoaVCZrsXaanrocgvuqJ5REhlMT7asmJtQFT5bkk
j2poJPC7ByZEtBFtA0toLrvVo9J4JqTJ0sMzLGqYPmYmps3MOBCUa2K6j0VIRwXd
1+pMjmrCg16aZcabN2yOPnVjB/LosjUw2fv9vQvFjoT0SW7jmmOSjRSIB7i75NtN
TK4akZ3kS6fnS/3suoWuQ2ivvQPyJwQjhbXZ1EtVcegVtZjypBeEufw9TfQ7w/Wu
xNXOoZaTCmH+1/vTGgxFe4mwd3wR2a7UwIxRdkgh0l4HAaGkdaFv7VLrcXfZyJfi
RALENQJWnL/h44WXonbzy0V8EGB1exL9aMXSHlIcXpjg0VpRtHHnUg6B7euBSesQ
akTUBBU4yJynrwng9wm/XLxa+r58T5HYMXhAoLjpGAZg6+ZIxBmXsT3z2hAB5X1g
r/CCIDKzQQGIeR/Hruq0xt3TimCWz9jgOCstqi3EX0MXMenkOC3Ydp6mGH17Yx3l
QGcjYiAmdWcayN3dxsL/IfZyfEq2vGh+m+fCRAyicuf6f7eUh+vV0yWrxBHRdCsw
1vGjnrk64oDnaKX9lXOCPFoGFB/Q+GzWNaDexZW7AI2bhSsoaYY=
=zSej
-----END PGP SIGNATURE-----

--332gL9uvgMOgNnaU--
