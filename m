Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DA165EEC99
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 05:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiI2Dxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 23:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiI2Dxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 23:53:42 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8916872B50
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 20:53:40 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4MdKGS0GhJz4xGk; Thu, 29 Sep 2022 13:53:36 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1664423616;
        bh=a/sK6v7yZRJ0VJjyQV/gPRH2mYTnyGH5ukZnBIGnTKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iknbLKFSxAJ2xqPJ69NucNzKBkEpAm8fIJsAZQZZ01X31zW5PlXE3G4TDU40UaBGd
         /eQPysjRLhl/1vxHkHN9KWhNc4jphjulEpscimedPy5tC6XgkR6oGeea2IV2zDoEOs
         hEo6TSOLiVce2S5kYJmMdDyoTpdeYgebw/M5NFIQ=
Date:   Thu, 29 Sep 2022 13:47:55 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>, iommu@lists.linux.dev,
        Jason Wang <jasowang@redhat.com>,
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
Subject: Re: [PATCH RFC v2 02/13] iommufd: Overview documentation
Message-ID: <YzUVa/Ikf+mRlgr9@yekko>
References: <0-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <2-v2-f9436d0bde78+4bb-iommufd_jgg@nvidia.com>
 <Yxf2Z+wVa8Os02Hp@yekko>
 <YxuLaxIRNsQRmqI5@nvidia.com>
 <Yx8MlOBPz1Zxig3V@yekko>
 <YzMz63fmjDH+HRqr@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5yfa0rt9VpEbXa+D"
Content-Disposition: inline
In-Reply-To: <YzMz63fmjDH+HRqr@nvidia.com>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5yfa0rt9VpEbXa+D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 27, 2022 at 02:33:31PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 12, 2022 at 08:40:20PM +1000, David Gibson wrote:
>=20
> > > > > +The iopt_pages is the center of the storage and motion of PFNs. =
Each iopt_pages
> > > > > +represents a logical linear array of full PFNs. PFNs are stored =
in a tiered
> > > > > +scheme:
> > > > > +
> > > > > + 1) iopt_pages::pinned_pfns xarray
> > > > > + 2) An iommu_domain
> > > > > + 3) The origin of the PFNs, i.e. the userspace pointer
> > > >=20
> > > > I can't follow what this "tiered scheme" is describing.
> > >=20
> > > Hum, I'm not sure how to address this.
> > >=20
> > > Is this better?
> > >=20
> > >  1) PFNs that have been "software accessed" stored in theiopt_pages::=
pinned_pfns
> > >     xarray
> > >  2) PFNs stored inside the IOPTEs accessed through an iommu_domain
> > >  3) The origin of the PFNs, i.e. the userspace VA in a mm_struct
> >=20
> > Hmm.. only slightly.  What about:
> >=20
> >    Each opt_pages represents a logical linear array of full PFNs.  The
> >    PFNs are ultimately derived from userspave VAs via an mm_struct.
> >    They are cached in .. <describe the pined_pfns and iommu_domain
> >    data structures>
>=20
> Ok, I have this now:
>=20
> Each iopt_pages represents a logical linear array of full PFNs.  The PFNs=
 are
> ultimately derived from userspave VAs via an mm_struct. Once they have be=
en
> pinned the PFN is stored in an iommu_domain's IOPTEs or inside the pinned=
_pages
> xarray if they are being "software accessed".
>=20
> PFN have to be copied between all combinations of storage locations, depe=
nding
> on what domains are present and what kinds of in-kernel "software access"=
 users
> exists. The mechanism ensures that a page is pinned only once.

LGTM, thanks.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--5yfa0rt9VpEbXa+D
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmM1FVMACgkQgypY4gEw
YSK2hA/9Hrv1lp1/s5YVngIqn5RydDQnnFdY+f9IOEQtPQtNESsPgpfloIY0Y3WN
CqWlew+XwKokqMFLTIS1M9BVZlr4ybORItcGyfJOgmTXx/VJ2w81DPzvQezzQ7iy
dppTIlbfAxm/+A2W7gGUsLsrRv+XuM74oQJ0gYlzZHqvRRvd01/MjCaISVYUG3lT
V6hjxvQjCJdGnkotOE8hX3r4UAajwQSr4duncZi/jSvrUj5vKHZWjxesWTYFH6zP
THMrxHQFxl70b8nQwryHCXbPXo5mOKyK62NREfaq7NYISiPpk3BP/iaFT5o90ixq
3m4k/3Zl56Lq9ehXY73i9TfRFhfCgTpItXR5Mf/6SwlKf5sMsdBis+A6ytqf1xIt
jEeniP9u0JdVBz8F5XuBpWm+i5N4Cnv6EbS/RTgjLgR2BTteBP9Mp1tOZI5h6apH
VVUFjUii+ZoG1GlAS4cSKkGFER2413QYLFb54CYn5cZ5gs57VMy/fUEd+wN8bmoe
OZlAxTJrwSEAr9xEis7aLRZOVDpH+aUIBsM3qmqPz05sAJbg8iDCo00hpAe9G7/f
aIihuTyTTMW6sWJ5oLV/Y6snOzAWQp46HMwiyokpzsCwF2duNSyVbIEnOqmIaUVy
7bk3rgd1i0IuY3XSERNUgQEFG2FxXB8/4j9jf3AdVes4twhAlLU=
=L8Hd
-----END PGP SIGNATURE-----

--5yfa0rt9VpEbXa+D--
