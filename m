Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DBF43BE65
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 02:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhJ0ARx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Oct 2021 20:17:53 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:51593 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbhJ0ARp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Oct 2021 20:17:45 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4Hf8N76gFJz4xbt; Wed, 27 Oct 2021 11:15:19 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1635293719;
        bh=dKeVKsGMF2yh/WmFnvSeUwHjMJ9NdhhLGarW1W7UHaM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O3tFvRmZe2stjsNh610SuRMHbefz50riV1AKZDV2Uc0s3jsive5JQNnaACk8GwOR/
         zygRbW0flKtrC7nLiDDNB6wcj2AwVb5QnfRQaZhmdUGzEmZB0hiDitdBRgH6JoBMud
         Tr73DXkaFeMXFBbm8Y69+xUSBDXtCLxD/I4DHCfQ=
Date:   Tue, 26 Oct 2021 20:23:22 +1100
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
Message-ID: <YXfJCrvtaXHV+qs/@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-14-yi.l.liu@intel.com>
 <YWe+88sfCbxgMYPN@yekko>
 <BN9PR11MB54337A8E65C789D038D875C68CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YWzwmAQDB9Qwu2uQ@yekko>
 <20211018163238.GO2744544@nvidia.com>
 <YXY9UIKDlQpNDGax@yekko>
 <20211025121410.GQ2744544@nvidia.com>
 <YXauO+YSR7ivz1QW@yekko>
 <20211025233602.GN2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HAEESUd3nsaELdfA"
Content-Disposition: inline
In-Reply-To: <20211025233602.GN2744544@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--HAEESUd3nsaELdfA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 25, 2021 at 08:36:02PM -0300, Jason Gunthorpe wrote:
> On Tue, Oct 26, 2021 at 12:16:43AM +1100, David Gibson wrote:
> > If you attach devices A and B (both in group X) to IOAS 1, then detach
> > device A, what happens?  Do you detach both devices?  Or do you have a
> > counter so you have to detach as many time as you attached?
>=20
> I would refcount it since that is the only thing that makes semantic
> sense with the device centric model.

Yes, I definitely think that's the better option here.  This does
still leave (at least) one weird edge case where the group structure
can "leak" into the awareness of code that otherwise doesn't care,
though it's definitely less nasty that the ones I mentioned before:

If an app wants to move a bunch of devices from one IOAS to another,
it can do it either:

A)
	for each dev:
		detach dev from IOAS
	for each dev:
		attach dev to new IOAS

or B)

	for each dev:
		detach dev from IOAS
		attach dev to new IOAS

With only singleton groups they're pretty much equivalent, but with
multiple devices in a group, (B) will fail.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--HAEESUd3nsaELdfA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmF3yQoACgkQbDjKyiDZ
s5LyLBAAsvp/wdXHEJM94XhKjCF5ao1wc21uqzV/TsPjACrM7F0hBGc58zmLojnN
SrvWkquRwIZJKQPtQTNfck2bsDXYP5bv0Kfr2C7NJF63COQc/G112VoUQSa+6cKu
doeXjM0heJj6e8Rs/d3vtBnNtpsiAowZVB2T45vpeVKRMwrPz6AHeus5T3kPcRcL
hTi9zDLal1AtfomkvLzSZXmS/alx3xraTe4dMCdgCfG6l1VlDfaTQouX52ELZrDy
Glnr/CX5zAi/PX+e4Vtojjr1+wt8IKbQeXXB5/m9Fxbn8Q6OirmuMnElgra2hRG2
6Zoe5VmV148pB31a17eDcEn4ISCy0XTzvXxvYFbqyU+zBat8BIWnSrHHkK/HnwPr
hdQSJZLcCq4vZh0LmSEIEanq66a4BTGaFmDoP2+MV2KCniQouwrrQdxPndDMmm+K
6VNuSrReFl6EYBBvbFX3Xs4UT3cVeRPRXhuMLo3nLdjcTqQnK8hJlUB6PCDUahcb
NZwmAlsRSuMRrWoB6tFd8fLENKDwO4+PKbX7MK2UPUOy+2YFATypnAe26STD0jOj
nwgz6yvTuKTLRvpXsYVzxc7bMJgWHXzNWPlogsttWd0yDd4ZX1n65SMid0/JRWvZ
dja1XtV+i0gGz3Z+L+CPSdwZai1jRL5ZNFWOjdruncdKXUNDHkY=
=YvzU
-----END PGP SIGNATURE-----

--HAEESUd3nsaELdfA--
