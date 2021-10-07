Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0549B424B9A
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 03:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbhJGBZQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 21:25:16 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:51283 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhJGBZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Oct 2021 21:25:12 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HPtqp36Vbz4xbG; Thu,  7 Oct 2021 12:23:18 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1633569798;
        bh=qstVtDT91XWliCaW5kitB3WljFF05mjQismqLt2KJ+A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n70FR0j9KTEGEzxwCxf2JDFXaUu8zShyp+4N0lscr1waf+K/ZgaxwyX9ZowdEeqyT
         93j/gp22nAcMRYODT0LPRwZZf8hod6y0LuY2l71D1O/R3Do5F53fEXCE37Ph8arTyB
         8uacyxaJkPxNRjhkPqJtBB70Xzz+taoWwt0m2ERk=
Date:   Thu, 7 Oct 2021 12:23:13 +1100
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
Message-ID: <YV5MAdzR6c2knowf@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-8-yi.l.liu@intel.com>
 <YVP44v4FVYJBSEEF@yekko>
 <20210929122457.GP964074@nvidia.com>
 <YVUqpff7DUtTLYKx@yekko>
 <20211001124322.GN964074@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="KDKmP08LDN9ERU6o"
Content-Disposition: inline
In-Reply-To: <20211001124322.GN964074@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--KDKmP08LDN9ERU6o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 01, 2021 at 09:43:22AM -0300, Jason Gunthorpe wrote:
> On Thu, Sep 30, 2021 at 01:10:29PM +1000, David Gibson wrote:
> > On Wed, Sep 29, 2021 at 09:24:57AM -0300, Jason Gunthorpe wrote:
> > > On Wed, Sep 29, 2021 at 03:25:54PM +1000, David Gibson wrote:
> > >=20
> > > > > +struct iommufd_device {
> > > > > +	unsigned int id;
> > > > > +	struct iommufd_ctx *ictx;
> > > > > +	struct device *dev; /* always be the physical device */
> > > > > +	u64 dev_cookie;
> > > >=20
> > > > Why do you need both an 'id' and a 'dev_cookie'?  Since they're both
> > > > unique, couldn't you just use the cookie directly as the index into
> > > > the xarray?
> > >=20
> > > ID is the kernel value in the xarray - xarray is much more efficient &
> > > safe with small kernel controlled values.
> > >=20
> > > dev_cookie is a user assigned value that may not be unique. It's
> > > purpose is to allow userspace to receive and event and go back to its
> > > structure. Most likely userspace will store a pointer here, but it is
> > > also possible userspace could not use it.
> > >=20
> > > It is a pretty normal pattern
> >=20
> > Hm, ok.  Could you point me at an example?
>=20
> For instance user_data vs fd in io_uring

Ok, but one of those is an fd, which is an existing type of handle.
Here we're introducing two different unique handles that aren't an
existing kernel concept.

> RDMA has many similar examples.
>=20
> More or less anytime you want to allow the kernel to async retun some
> information providing a 64 bit user_data lets userspace have an easier
> time to deal with it.

I absolutely see the need for user_data.  What I'm questioning is
having two different, user-visible unique handles, neither of which is
an fd.


That said... is there any strong reason why user_data needs to be
unique?  I can imagine userspace applications where you don't care
which device the notification is coming from - or at least don't care
down to the same granularity that /dev/iommu is using.  In which case
having the kernel provided unique handle and the
not-necessarily-unique user_data would make perfect sense.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--KDKmP08LDN9ERU6o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFeTAAACgkQbDjKyiDZ
s5IHfA//dHZrmxuC2Eg7GpSZRzPqLOFtDPTlZ/fOS0A3Ww2bU6S+CuugltvCz+U2
KZ65d6W7oAiRDmaxTdPARsY/JsYFSu+jGnVfYI4ZUf/N6v0NIInS5L5z31og1nhu
VYPLtYEPenL5Ikj/e3Ul9E6l5AqLcRqRw/j5G83ygQB3Wk93LdeF/p8wdEvEt599
U5V8JbGKUYzBySYD4+m6EhhYpAEagGRRltJE10AZm4WB9w6KbjkrQryg7zSfbbEo
ulwVrlY/IBzHmbBi82IQOiXFIZkdbvuigelt34UPdMSVj50Wmo4t/bxyTbRGk9O8
YMGa0Y5l0bH6gtl1M/e9Gq3rEwGrjSP/GyvLCZSv1D3nAti/WK7INv9NVEz1E74O
frugTJBSsodRVz31hMt+WDT5NTTv+F+xQjEnFZTcCeogHvDissXh2wnhUXSi5kQq
g8GcJfG621SrtvulFlFIhjgtXqxPzRJm+uXWTI5ESCA7+3g79Pr5kKo9UTiRK1c1
HtB8mM70Hp+vOmWSZ5D3wYZX4ImXpcWdHk0y0c1O0QQVmFF07iyqjVXu+A6r/A5y
ly8PwxvM0gnM7Ewuz37YXpGTgeiCTVaUVPITz09GN1mMqYa2V0l1X3q/G5iwb/g8
0SqR8HFGjS87nbngGm/vjD/AscCOHePTMrFQvN/GFytfMWdJO3c=
=VYju
-----END PGP SIGNATURE-----

--KDKmP08LDN9ERU6o--
