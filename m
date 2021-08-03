Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E173DE42F
	for <lists+kvm@lfdr.de>; Tue,  3 Aug 2021 03:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhHCB7z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 21:59:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbhHCB7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 21:59:54 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917BDC06175F;
        Mon,  2 Aug 2021 18:59:44 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4Gdyjn2qhBz9sRR; Tue,  3 Aug 2021 11:59:41 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1627955981;
        bh=mcssnhKHGpqf7aGtYadSQBmF9hBe6OphCi9VnHFLwK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YJzBitf3pp0u/NKy0gtRB+9FzkbD9C+yw1jDFI3o0uuA3rzB2LyegGA/PabDE74vP
         G+IG8wYOgtVrgFbrnRs7bMXHz5TJ72GHsRS3ush9ybD0NN4nZdzMsDsjCL8AUYXNSH
         F25Pcd0z5I5RLRdUHZii6gWgRXAyHxYnPsR78ncc=
Date:   Tue, 3 Aug 2021 11:58:54 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <YQii3g3plte4gT5Z@yekko>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP4/KJoYfbaf5U94@yekko>
 <20210730145123.GW1721383@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="woWztZ/43ybkO+Tp"
Content-Disposition: inline
In-Reply-To: <20210730145123.GW1721383@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--woWztZ/43ybkO+Tp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 30, 2021 at 11:51:23AM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 26, 2021 at 02:50:48PM +1000, David Gibson wrote:
>=20
> > That said, I'm still finding the various ways a device can attach to
> > an ioasid pretty confusing.  Here are some thoughts on some extra
> > concepts that might make it easier to handle [note, I haven't thought
> > this all the way through so far, so there might be fatal problems with
> > this approach].
>=20
> I think you've summarized how I've been viewing this problem. All the
> concepts you pointed to should show through in the various APIs at the
> end, one way or another.
>=20
> How much we need to expose to userspace, I don't know.
>=20
> Does userspace need to care how the system labels traffic between DMA
> endpoint and the IOASID? At some point maybe yes since stuff like
> PASID does leak out in various spots

Yeah, I'm not sure.  I think it probably doesn't for the "main path"
of the API, though we might want to expose that for debugging and some
edge cases.

We *should* however be exposing the address type for each IOAS, since
that affects how your MAP operations will work, as well as what
endpoints are compatible with the IOAS.

> > /dev/iommu would work entirely (or nearly so) in terms of endpoint
> > handles, not device handles.  Endpoints are what get bound to an IOAS,
> > and endpoints are what get the user chosen endpoint cookie.
>=20
> While an accurate modeling of groups, it feels like an
> overcomplication at this point in history where new HW largely doesn't
> need it.

So.. first, is that really true across the board?  I expect it's true
of high end server hardware, but for consumer level and embedded
hardware as well?  Then there's virtual hardware - I could point to
several things still routinely using emulated PCIe to PCI bridges in
qemu.

Second, we can't just ignore older hardware.

> The user interface VFIO and others presents is device
> centric, inserting a new endpoint object is going going back to some
> kind of group centric view of the world.

Well, kind of, yeah, because I still think the concept has value.
Part of the trouble is that "device" is pretty ambiguous.  "Device" in
the sense of PCI address for register interface may not be the same as
"device" in terms of DMA RID may not be the same as as "device" in
terms of Linux struct device=20


terms of PCI register interface is not the same as "device"
in terms of RID / DMA identifiability is not the same "device" in
terms of what.

> I'd rather deduce the endpoint from a collection of devices than the
> other way around...

Which I think is confusing, and in any case doesn't cover the case of
one "device" with multiple endpoints.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--woWztZ/43ybkO+Tp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmEIot4ACgkQbDjKyiDZ
s5LrNhAAuKUL5EwDkgGG0d1RtZfMCGJzZoJmU/9h/PLaLeR/INpQR+ZrAd0vNrUd
XxGaIEZelNKEFXMyALoYwXqiwxdwdhduIpdBaN2X2usYYKaMl6iuP34CMWKl7gxq
U+91Jwb/lP3IrU1t9fhAJaNUL/wIKpmMefsFjVqicYjwxGdIHdJLT8TsHqnd/Suq
Yx5kjGQhF8o3lziQtAeDwMfGytM2rekdpshVrIye8+6urrxO/PM308gGGUj3QBfE
NxmDYQWRDcqrPdtLN8Ln8sPi7GDliXX0+8pC83RiRPUgXGCgoLcmF8KGVUtio/td
TC8laRhl15Zls1/EyuBlDRZBkp/SQSlksh3v9sgHfJqUofgLtWcHtb8w+arNEGKQ
b3ppdmORDQg47ELkRE/fYgNNHiFQmzZxEP7TJJaR+uhY2DQ7LEsFS3UUeFI82oUb
DY9+4FwKgI73+Cz+f088tIJ5gJgLoESLUDcqShvsbFK4RjD3bJcyCwwap8Vz5kuf
eH/fdvoeqw/M8L2xS+i6NqzVY59hAOFWNj8yU1O4V3yLCo8D8Z7/4ouoRqWgz6Ci
7JhDg/zYuoCRG9KNDO5s/FNpuQW6UCiJi07ZQi6J62mnmRvi3gFJcn3Wvi15yY4K
gLebfSKkC/adNM5iUb0shqpYS5qLt5OZUITuujtV2wVs5hr2zUk=
=1JD4
-----END PGP SIGNATURE-----

--woWztZ/43ybkO+Tp--
