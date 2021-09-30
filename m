Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC65141D231
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 06:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347891AbhI3EVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 00:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347928AbhI3EVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 00:21:16 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48161C06176A;
        Wed, 29 Sep 2021 21:19:30 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HKg4C5HmYz4xbQ; Thu, 30 Sep 2021 14:19:23 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1632975563;
        bh=NRJoicPyChT5bSglpE5PZvju2v1MLLcprgAknSG0Odk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LApzlqydq0YPauTRjzyufGANEU34JgSwWC9+l6wirLQ69eTfehT2IDIz9jVLzHo2N
         ZWXYeOJU+hjWd2VRWYcn6J0aLOuRugSUOAx2P6CTy4+e8o6cJ/5iS93SF4VnUR31zK
         zHk5YgKuMN0jFZZ0wId4tq0kLP/ReNOcIgk0GaLI=
Date:   Thu, 30 Sep 2021 13:05:24 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "hch@lst.de" <hch@lst.de>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <YVUpdKNjxeQ9Oc1y@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
 <YVPxzad5TYHAc1H/@yekko>
 <BN9PR11MB5433E1BF538C7D3632F4C6188CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YVQJJ/ZlRoJbAt0+@yekko>
 <BN9PR11MB54335B4BA1134B14E1408D358CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YbdJW4Bwlc08+mUE"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54335B4BA1134B14E1408D358CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--YbdJW4Bwlc08+mUE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2021 at 07:31:08AM +0000, Tian, Kevin wrote:
> > From: David Gibson
> > Sent: Wednesday, September 29, 2021 2:35 PM
> >=20
> > On Wed, Sep 29, 2021 at 05:38:56AM +0000, Tian, Kevin wrote:
> > > > From: David Gibson <david@gibson.dropbear.id.au>
> > > > Sent: Wednesday, September 29, 2021 12:56 PM
> > > >
> > > > >
> > > > > Unlike vfio, iommufd adopts a device-centric design with all group
> > > > > logistics hidden behind the fd. Binding a device to iommufd serves
> > > > > as the contract to get security context established (and vice ver=
sa
> > > > > for unbinding). One additional requirement in iommufd is to manage
> > the
> > > > > switch between multiple security contexts due to decoupled
> > bind/attach:
> > > > >
> > > > > 1)  Open a device in "/dev/vfio/devices" with user access blocked;
> > > >
> > > > Probably worth clarifying that (1) must happen for *all* devices in
> > > > the group before (2) happens for any device in the group.
> > >
> > > No. User access is naturally blocked for other devices as long as they
> > > are not opened yet.
> >=20
> > Uh... my point is that everything in the group has to be removed from
> > regular kernel drivers before we reach step (2).  Is the plan that you
> > must do that before you can even open them?  That's a reasonable
> > choice, but then I think you should show that step in this description
> > as well.
>=20
> Agree. I think below proposal can meet above requirement and ensure
> it's not broken in the whole process when the group is operated by the
> userspace:
>=20
> https://lore.kernel.org/kvm/20210928140712.GL964074@nvidia.com/
>=20
> and definitely an updated description will be provided when sending out
> the new proposal.
>=20
> >=20
> > > > > 2)  Bind the device to an iommufd with an initial security context
> > > > >     (an empty iommu domain which blocks dma) established for its
> > > > >     group, with user access unblocked;
> > > > >
> > > > > 3)  Attach the device to a user-specified ioasid (shared by all d=
evices
> > > > >     attached to this ioasid). Before attaching, the device should=
 be first
> > > > >     detached from the initial context;
> > > >
> > > > So, this step can implicitly but observably change the behaviour for
> > > > other devices in the group as well.  I don't love that kind of
> > > > difficult to predict side effect, which is why I'm *still* not tota=
lly
> > > > convinced by the device-centric model.
> > >
> > > which side-effect is predicted here? The user anyway needs to be
> > > aware of such group restriction regardless whether it uses group
> > > or nongroup interface.
> >=20
> > Yes, exactly.  And with a group interface it's obvious it has to
> > understand it.  With the non-group interface, you can get to this
> > stage in ignorance of groups.  It will even work as long as you are
> > lucky enough only to try with singleton-group devices.  Then you try
> > it with two devices in the one group and doing (3) on device A will
> > implicitly change the DMA environment of device B.
>=20
> for non-group we can also document it obviously in uAPI that the user
> must understand group restriction and violating it will get failure
> when attaching to different IOAS's for devices in the same group.

Documenting limitations is always inferior to building them into the
actual API signatures.  Sometimes its the only option, but people
frequently don't read the docs, whereas they kind of have to look at
the API itself.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--YbdJW4Bwlc08+mUE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFVKXEACgkQbDjKyiDZ
s5LLXhAA4KWUYr6vDUxAFLkT4L1KLKZqWhjkk8LmbvVrhToLi60vFIhp1pTiwMVO
slRlmjGBn/Q33uuWmiFKrcPxz29jfamSP/9zSX4X2qeGKxRXQlxkY+jyNTIjymqI
R8JrzRq+fXG5bFtEZKj/KpBtme+GMfYiDdx/yR8UVbLyLkDXbPK82fltDIDFAnhd
3eon0AdwqF3UNCpBCoDkHa2oPyEvL6eho4olzXkOIIFU/eYcUv8KlLpbg3R3dMP7
hBh6KhIlo0SsWdAdhBYignw8aSeMy4fGWenmsnY4SLLYiaps+g5dYXOolHHRbkWz
Yo+KzfJX82FPXw8VUPoU3ueXMld0C+xYGrFPsv3aL1IHphhdCeMPg5qyVnqYxZa0
h7Z8En/rnzAJGqO2aVaYN+CZJcRX9rpKbL+tieorl2v05F4QI2xyFyFFOwg3Qbhc
Y+8J+aShOklfEI2z38FDgUA5v+FT1sh38ZKxK4DF8AXUEWApgTp1Adhc92Qg+yE4
M5UaX8b18Cic3e6hJ7Zc7xckwjQr2HMpC0YA6Uq8+Hpoc3E4asPg0l1WmxofaxF5
Ix0YsOiFVNhBFqCy9/hDqXZIbs7qThiV7QtQm5vJCXtqxDlb7EjwyQpBG3lbYc/e
1BWuzTON93WgeSg92dgod7n/5aQX6Xb/LLS/MYX3VymPI7xOvbc=
=/I/A
-----END PGP SIGNATURE-----

--YbdJW4Bwlc08+mUE--
