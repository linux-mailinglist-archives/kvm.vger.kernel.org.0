Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B38438ED2
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 07:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhJYFbv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 01:31:51 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:48605 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhJYFbt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 01:31:49 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4Hd3RV3yc5z4xZ1; Mon, 25 Oct 2021 16:29:26 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1635139766;
        bh=6zAr2dccLE+Xq46zC4THi7D5zvFV8MFg187CSJj4PoU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Soao14g4N+KZ/f9ElfqcTacz+edrkXvdUyuFDgkOIFFrK9kUH2lpbmN3vk8hW17/H
         /q6A0UCMXTV3UhexzZ6bC1Lh9qDYDc6E15yfCAZayVk1HT/60wXMetI0KviTXKvKnr
         Elq25upo6pL91ZXHBgCljcx5VZBkiMuPs8pKxLok=
Date:   Mon, 25 Oct 2021 16:14:56 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 13/20] iommu: Extend iommu_at[de]tach_device() for multiple
 devices group
Message-ID: <YXY9UIKDlQpNDGax@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-14-yi.l.liu@intel.com>
 <YWe+88sfCbxgMYPN@yekko>
 <BN9PR11MB54337A8E65C789D038D875C68CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YWzwmAQDB9Qwu2uQ@yekko>
 <20211018163238.GO2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yxRtDnBMBAGaMdJf"
Content-Disposition: inline
In-Reply-To: <20211018163238.GO2744544@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--yxRtDnBMBAGaMdJf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 18, 2021 at 01:32:38PM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 18, 2021 at 02:57:12PM +1100, David Gibson wrote:
>=20
> > The first user might read this.  Subsequent users are likely to just
> > copy paste examples from earlier things without fully understanding
> > them.  In general documenting restrictions somewhere is never as
> > effective as making those restrictions part of the interface signature
> > itself.
>=20
> I'd think this argument would hold more water if you could point to
> someplace in existing userspace that cares about the VFIO grouping.

My whole point here is that the proposed semantics mean that we have
weird side effects even if the app doesn't think it cares about
groups.

e.g. App's input is a bunch of PCI addresses for NICs.  It attaches
each one to a separate IOAS and bridges packets between them all.  As
far as the app is concerned, it doesn't care about groups, as you say.

Except that it breaks if any two of the devices are in the same group.
Worse, it has a completely horrible failure mode: no syscall returns
an, it just starts trying to do dma with device A, and the packets get
written into the IOAS that belongs to device B instead.  Sounds like a
complete nightmare to debug if you don't know about groups, because
you never thought you cared.


And yes, for a simple bridge like this app, attaching all the devices
to the same IOAS is a more likely setup.  But using an IOAS per device
is a perfectly valid configuration as well, and with the current draft
nothing will warn the app that this is a bad idea.

> From what I see the applications do what the admin tells them to do -
> and if the admin says to use a certain VFIO device then that is
> excatly what they do. I don't know of any applications that ask the
> admin to tell them group information.
>=20
> What I see is aligning what the kernel provides to the APIs the
> applications have already built.
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--yxRtDnBMBAGaMdJf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmF2PVAACgkQbDjKyiDZ
s5LUJhAAqfdhIEiSLBVFINn04mkXp8wdf6ByN7npipHdyHzSj76wY3CwovNLbLyM
VVz+ua0VowY3482C4CbDxOEKQeYGIn5xD0nsr/gOl7PLm3uBsk4/NVXprgHblYFZ
Xlb4YtykCSVsxn/QPLYNTX4xhcWL8gUC0FS5n9Ga4N9/8JeT93aWbRMDO+hTTTv0
Enk/XhH3r4JtHXFUdr2CyU1MXmgJNd0J/Pz48U6OSqq/NP/vOhu9TnqYBLuNyV9J
ktLJe/vccmavhgscTZRH8hRTCQNgzsYC0OggrREEujZzOV6+uNFr8wCG3GvbGS4h
5+zL1kkHJ4KAIS38aQxylEOsbCIExyrSixQzdSorJWEGcNdDSy8cSmYeVzWoJMZX
jEVcCWXFkWobgB9GynbW9nj5sKZUe/8O9eVDpd9g1UDIagzdmD2yNUdLDwrx++Ef
YtJIFiYSHenbzzIfAoPcxCLLh7O/oXFTp654dODuIuZPfO2FLTdHNRznRn4r0aWW
x6u4e9KgdC9A5yeN74/Ho0U5snn5PDDxLam/tNz7/xiUBaxgKp96NS5peNU0BMOL
mI43kdEhXxrXlT3a4k+XZU+WHRTeFh69g9OyJqW6x1dkp5N/3DYgNF3nThc/x1s0
6tZg+nTGqnEAMV0QYgbR/4H5El5fMHJekab+aaMO69Ny5NnU110=
=Mlw2
-----END PGP SIGNATURE-----

--yxRtDnBMBAGaMdJf--
