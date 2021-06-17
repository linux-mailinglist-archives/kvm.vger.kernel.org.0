Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0723AAD5A
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 09:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhFQHYV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 03:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhFQHYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 03:24:18 -0400
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DE7C06175F;
        Thu, 17 Jun 2021 00:22:11 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G5D5W491pz9sT6; Thu, 17 Jun 2021 17:22:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623914527;
        bh=zVWbZ8t57yg6jr2vkel/FfVJmSI+OssX8pb3npfVLG0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ENOesf92LKWneTrHhvauCH/Tmz57Jo+jwf8vIfQXhSZv8qrfNtxWwMvrrUa2SVU85
         L0HfZQWRvkWHZMCKtSOeTz9BQwNcM4AlPFK8MywJ35dgPX49Y+2nTAo3fTCsNIzYfq
         TJ1ygljN2+gEkdiRP9N8vES/H6QCe87y/Ri6vUKc=
Date:   Thu, 17 Jun 2021 12:42:31 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <YMq2l7YId3cjmVKG@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528173538.GA3816344@nvidia.com>
 <YLcl+zaK6Y0gB54a@yekko>
 <20210602161648.GY1002214@nvidia.com>
 <YLhlCINGPGob4Nld@yekko>
 <20210603115224.GQ1002214@nvidia.com>
 <YL6/bjHyuHJTn4Rd@yekko>
 <20210608190406.GN1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5bobZhJ8ovb9pZNW"
Content-Disposition: inline
In-Reply-To: <20210608190406.GN1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--5bobZhJ8ovb9pZNW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 08, 2021 at 04:04:06PM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 08, 2021 at 10:53:02AM +1000, David Gibson wrote:
> > On Thu, Jun 03, 2021 at 08:52:24AM -0300, Jason Gunthorpe wrote:
> > > On Thu, Jun 03, 2021 at 03:13:44PM +1000, David Gibson wrote:
> > >=20
> > > > > We can still consider it a single "address space" from the IOMMU
> > > > > perspective. What has happened is that the address table is not j=
ust a
> > > > > 64 bit IOVA, but an extended ~80 bit IOVA formed by "PASID, IOVA".
> > > >=20
> > > > True.  This does complexify how we represent what IOVA ranges are
> > > > valid, though.  I'll bet you most implementations don't actually
> > > > implement a full 64-bit IOVA, which means we effectively have a lar=
ge
> > > > number of windows from (0..max IOVA) for each valid pasid.  This ad=
ds
> > > > another reason I don't think my concept of IOVA windows is just a
> > > > power specific thing.
> > >=20
> > > Yes
> > >=20
> > > Things rapidly get into weird hardware specific stuff though, the
> > > request will be for things like:
> > >   "ARM PASID&IO page table format from SMMU IP block vXX"
> >=20
> > So, I'm happy enough for picking a user-managed pagetable format to
> > imply the set of valid IOVA ranges (though a query might be nice).
>=20
> I think a query is mandatory, and optionally asking for ranges seems
> generally useful as a HW property.
>=20
> The danger is things can get really tricky as the app can ask for
> ranges some HW needs but other HW can't provide.=20
>=20
> I would encourage a flow where "generic" apps like DPDK can somehow
> just ignore this, or at least be very, very simplified "I want around
> XX GB of IOVA space"
>=20
> dpdk type apps vs qemu apps are really quite different and we should
> be carefully that the needs of HW accelerated vIOMMU emulation do not
> trump the needs of simple universal control over a DMA map.

Agreed.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--5bobZhJ8ovb9pZNW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDKtpUACgkQbDjKyiDZ
s5L55hAAz7xTXdVl6Sc751CmGpD70USGAOw/RdKHKOF7XHOzBuYE9TL3q5fk1JDy
xbJA2l9E6UsZDNafSc4V36fAx7MUHmengBK4zqzLK3uhP+xq/4IfJ1vugMt3SJNW
Bq78GzvTs3O0j/eVDp/Ha81XK20Dy/RFfcP1E6j7YDSsXjEwkOwavFyna/xMPpGP
HJl/cLDR2rXrAIURWO33A3W7am7TZVsLPzXblykE03XVPHDupsZTDr/vd6GXf4W0
8atDbuq09y1mi7fLdNaOMx/LVZTFQtaQwd8+1jprYEc4UJ6n/f++HS7NtNCBsPwZ
QH0LJrWjW8RaG6IVOPuQIwJ1SBAZ/gtXC65UdrBMAjQaKjxoO5b/WvUxXpXktMod
CD2dYHIzo/RKmg7NBTExYOzw9J31jIoNLXXu1Ao++RmXSSHlCb5aWkS3TQFilnMp
hdZm/4Aih4DDrgFdDYBuhanzS6IpRAwysxDj9h2cJWOR/OwYdZAcnZHS03FC6DQ0
fzIbGVFKhVk+Kstnkb8AgoLgdIFSONHdUoH8ISWIZ0bO+XGBGE9PjeqV3v9C+EhD
J8xPnFzRlGgK1BleopuME+ukjT4t1yjAfqud6EYVKzN7DcfC9kkwTNtFX2CRjRNV
H/hCA3c9kxdjRi6tk/juYHoLEAHevB1IAtTukDrsw6f+vxSQ2yE=
=PXAb
-----END PGP SIGNATURE-----

--5bobZhJ8ovb9pZNW--
