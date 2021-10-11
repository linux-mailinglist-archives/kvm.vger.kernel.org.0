Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D05B428592
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 05:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhJKD2y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 10 Oct 2021 23:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233264AbhJKD2x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 10 Oct 2021 23:28:53 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30E1C061570;
        Sun, 10 Oct 2021 20:26:53 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HSPNW4sRpz4xbc; Mon, 11 Oct 2021 14:26:51 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1633922811;
        bh=RzarCJ/iuPvuUb6JjprFQQYugb74lPNA9To2B9JBEaA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LyZqqdQjik07FKZJ5xvz/gaQnsXaq5EqMzu7gBtg5Jw9Z4TpOl6I9mTY8emE9D1eU
         noM+JfptyGWe1TgtRLM5FS8DgHlLunji2lQ6SeL8O5qWxeswmKUAV5f5PzNluTsHAu
         6BNFP38m2m86L5Qngupt69I+t0KCHDlyazEXXAfk=
Date:   Mon, 11 Oct 2021 14:24:21 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Liu Yi L <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        hch@lst.de, jasowang@redhat.com, joro@8bytes.org,
        jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@linux.intel.com, jun.j.tian@intel.com, hao.wu@intel.com,
        dave.jiang@intel.com, jacob.jun.pan@linux.intel.com,
        kwankhede@nvidia.com, robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        nicolinc@nvidia.com
Subject: Re: [RFC 07/20] iommu/iommufd: Add iommufd_[un]bind_device()
Message-ID: <YWOuZWSIv304tY2L@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-8-yi.l.liu@intel.com>
 <YVP44v4FVYJBSEEF@yekko>
 <20210929122457.GP964074@nvidia.com>
 <YVUqpff7DUtTLYKx@yekko>
 <20211001124322.GN964074@nvidia.com>
 <YV5MAdzR6c2knowf@yekko>
 <20211007113503.GG2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0VYc2zw48AcQLMtf"
Content-Disposition: inline
In-Reply-To: <20211007113503.GG2744544@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--0VYc2zw48AcQLMtf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 07, 2021 at 08:35:03AM -0300, Jason Gunthorpe wrote:
> On Thu, Oct 07, 2021 at 12:23:13PM +1100, David Gibson wrote:
> > On Fri, Oct 01, 2021 at 09:43:22AM -0300, Jason Gunthorpe wrote:
> > > On Thu, Sep 30, 2021 at 01:10:29PM +1000, David Gibson wrote:
> > > > On Wed, Sep 29, 2021 at 09:24:57AM -0300, Jason Gunthorpe wrote:
> > > > > On Wed, Sep 29, 2021 at 03:25:54PM +1000, David Gibson wrote:
> > > > >=20
> > > > > > > +struct iommufd_device {
> > > > > > > +	unsigned int id;
> > > > > > > +	struct iommufd_ctx *ictx;
> > > > > > > +	struct device *dev; /* always be the physical device */
> > > > > > > +	u64 dev_cookie;
> > > > > >=20
> > > > > > Why do you need both an 'id' and a 'dev_cookie'?  Since they're=
 both
> > > > > > unique, couldn't you just use the cookie directly as the index =
into
> > > > > > the xarray?
> > > > >=20
> > > > > ID is the kernel value in the xarray - xarray is much more effici=
ent &
> > > > > safe with small kernel controlled values.
> > > > >=20
> > > > > dev_cookie is a user assigned value that may not be unique. It's
> > > > > purpose is to allow userspace to receive and event and go back to=
 its
> > > > > structure. Most likely userspace will store a pointer here, but i=
t is
> > > > > also possible userspace could not use it.
> > > > >=20
> > > > > It is a pretty normal pattern
> > > >=20
> > > > Hm, ok.  Could you point me at an example?
> > >=20
> > > For instance user_data vs fd in io_uring
> >=20
> > Ok, but one of those is an fd, which is an existing type of handle.
> > Here we're introducing two different unique handles that aren't an
> > existing kernel concept.
>=20
> I'm not sure how that matters, the kernel has many handles - and we
> get to make more of them.. Look at xarray/idr users in the kernel, many of
> those are making userspace handles.

Again, I'm commenting *just* on the fact that the current draft
introduce *two* handles for the same object.  I have no objection to
either of the handles in isoation.

> > That said... is there any strong reason why user_data needs to be
> > unique?  I can imagine userspace applications where you don't care
> > which device the notification is coming from - or at least don't care
> > down to the same granularity that /dev/iommu is using.  In which case
> > having the kernel provided unique handle and the
> > not-necessarily-unique user_data would make perfect sense.
>=20
> I don't think the user_data 64 bit value should be unique, it is just
> transported from  user to kernal and back again. It is *not* a handle,
> it is a cookie.
>=20
> Handles for the kernel/user boundary should come from xarrays that
> have nice lookup properties - not from user provided 64 bit values
> that have to be stored in red black trees..

Yes, I think that would make more sense.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--0VYc2zw48AcQLMtf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFjrmMACgkQbDjKyiDZ
s5L66BAA2KSYaq6MCy69G1nEtfYbAGPDJ4QuXouV1K4wx7uIroH1P/RjgD3gcaw9
I2/Ity23aYrXP7e/JIthanEw7WnB9Zw8Y7SqhqPsXfkpoQt0F9Voykhh6PUobHPj
FjAovwh2OID8MdecvxwsTVxfadH6Hs5E2ZJxgM7i7IexUFXp8ArKgTJoYfj1vvsz
eUmRJdqUVQsmAhLsprRXEVxleF1McEorHfR+gz/cGmoJHt/z66PqLBjARlbXtebg
2Iux0IFpguxtrKT9zpTEflC9qGJveGz7dGsrf9RFO+P2Xvgn1NG5qHaB0iYjZZxQ
hAdWXsW8SLOEmgDAfizHHRYJ/gbEx6rmmv8UmhdRD+CqvnFKj+g27bgN/AUuFUFf
2BZ0gAeQHyycgeKNruOUNq3p2grSzb4v1d3E8xFPnzJ9jXir2t78j4wcqwjdS3Ek
PR4NriYCCjRMiDon+cFP/qvjq4Aj50PJfh6zPjMiKobKd165ubO+KYzFYZMzsQ5B
wjyHMQwk5IzIxQTXXMhlV6ZgoATn6ivmaF5++e1YOitPOhFL5oKdcAR7ap5lt7Mq
iLVEPbPb1pcUjJJe+OJqNyAL1g59UUFpvILvGXDbVq2cqlf+cPlQMwUaTV9Nyut4
TPz2KR1VWKXN+eT+k3p6MuORLsAV67F/FqnZF0jVKu3blPwonCs=
=/qGA
-----END PGP SIGNATURE-----

--0VYc2zw48AcQLMtf--
