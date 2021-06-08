Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B8439EC88
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 05:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhFHDDO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 23:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhFHDDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 23:03:13 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52512C061574;
        Mon,  7 Jun 2021 20:01:21 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4FzZkl2nPqz9sW8; Tue,  8 Jun 2021 13:01:18 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623121279;
        bh=+41T/Fw5wyPRXDBoLIrJVctPmPOR2fLwaGL92NdGutM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SqA5VOBzVmGy0akKvS+MCkyhOJD08nQlmYgJrmV6flYJlP2DQD9ocY0Ml6+0E3nAz
         OadDFSFgeCUP5YqI96oVelNHj61AdbHJc8uZvC8kT5LG/pelInS9EqKfd52Uyv4kSA
         FzkjpzFS2H+SGCTR/IpFTh7+vgIW2G72ERaIYlw4=
Date:   Tue, 8 Jun 2021 12:37:04 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
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
Message-ID: <YL7X0FKj+r6lIHQZ@yekko>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528200311.GP1002214@nvidia.com>
 <MWHPR11MB188685D57653827B566BF9B38C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601162225.259923bc.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oBD7VOjePs9Ih+1P"
Content-Disposition: inline
In-Reply-To: <20210601162225.259923bc.alex.williamson@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--oBD7VOjePs9Ih+1P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 01, 2021 at 04:22:25PM -0600, Alex Williamson wrote:
> On Tue, 1 Jun 2021 07:01:57 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
> >=20
> > I summarized five opens here, about:
> >=20
> > 1)  Finalizing the name to replace /dev/ioasid;
> > 2)  Whether one device is allowed to bind to multiple IOASID fd's;
> > 3)  Carry device information in invalidation/fault reporting uAPI;
> > 4)  What should/could be specified when allocating an IOASID;
> > 5)  The protocol between vfio group and kvm;
> >=20
> ...
> >=20
> > For 5), I'd expect Alex to chime in. Per my understanding looks the
> > original purpose of this protocol is not about I/O address space. It's
> > for KVM to know whether any device is assigned to this VM and then
> > do something special (e.g. posted interrupt, EPT cache attribute, etc.).
>=20
> Right, the original use case was for KVM to determine whether it needs
> to emulate invlpg, so it needs to be aware when an assigned device is
> present and be able to test if DMA for that device is cache coherent.
> The user, QEMU, creates a KVM "pseudo" device representing the vfio
> group, providing the file descriptor of that group to show ownership.
> The ugly symbol_get code is to avoid hard module dependencies, ie. the
> kvm module should not pull in or require the vfio module, but vfio will
> be present if attempting to register this device.
>=20
> With kvmgt, the interface also became a way to register the kvm pointer
> with vfio for the translation mentioned elsewhere in this thread.
>=20
> The PPC/SPAPR support allows KVM to associate a vfio group to an IOMMU
> page table so that it can handle iotlb programming from pre-registered
> memory without trapping out to userspace.

To clarify that's a guest side logical vIOMMU page table which is
partially managed by KVM.  This is an optimization - things can work
without it, but it means guest iomap/unmap becomes a hot path because
each map/unmap hypercall has to go
	guest -> KVM -> qemu -> VFIO

So there are multiple context transitions.

> > Because KVM deduces some policy based on the fact of assigned device,=
=20
> > it needs to hold a reference to related vfio group. this part is irrele=
vant
> > to this RFC.=20
>=20
> All of these use cases are related to the IOMMU, whether DMA is
> coherent, translating device IOVA to GPA, and an acceleration path to
> emulate IOMMU programming in kernel... they seem pretty relevant.
>=20
> > But ARM's VMID usage is related to I/O address space thus needs some
> > consideration. Another strange thing is about PPC. Looks it also levera=
ges
> > this protocol to do iommu group attach: kvm_spapr_tce_attach_iommu_
> > group. I don't know why it's done through KVM instead of VFIO uAPI in
> > the first place.
>=20
> AIUI, IOMMU programming on PPC is done through hypercalls, so KVM needs
> to know how to handle those for in-kernel acceleration.  Thanks,

For PAPR guests, which is the common case, yes.  Bare metal POWER
hosts have their own page table format.  And probably some of the
newer embedded ppc models have some different IOMMU model entirely,
but I'm not familiar with it.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--oBD7VOjePs9Ih+1P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmC+184ACgkQbDjKyiDZ
s5JotxAAu7wyTRuzaeVBDinjoZv5Pl9RRpRqYDd2zlWolEfYafahsPvJkI7hv0dz
q+7xnWDEDbjXyYO8/lIRgJ3xogF95Z4y8K88XmoEin+L0ZHpb6enfZzrxB5Wk/bw
HY4spyt45O7b8U5/bp7P3qiwPT8NcCW8Ba75DkBSpWPhZdmluH/1O78UUGeuqq4N
GNcF3MsHUR5H30m4NLuwAOv97OT5bb0aKHeb6rd1nJn+nyWwW+Bpnc8iuRAxzcEL
px4QBQYRH0ItJdgor8dnukxz1Evro63sS8VO+53SXtt4XUOgd9x8aHt0r+EluhCn
n7a1y2en1yHc7QEKl8gEB1u4GKm0rwP74jp0+VTgw+eQJujrjIeN1sMdXYKX6dZ8
hB4CMrJ5h2E6QCJso0vxgdaWy0sk+HOSObkIErwVktrCDZaf/H+Cqvvvncgt82Ym
ZiiLQaUbTJA7KwxHWjS8YC7L00Wzl2rBqCcH6OpJa1haBjnsEI2HmLxe7cj0pvuQ
YOeJ62QR8TJ9/p41kYca/+K/TAKMafWpZxYRSWJ9WMkjzpwvxhBG6sQPlvlIJUEH
90fO+gxMGBZb+M9LIL6XWqeIboY12kuAJ2GySNS8N8l2CBnWo/HyR+Cmetrheskc
eU53/BcWtXFrZrOP55nISiVQzajP4/FYjjRUeR5+u2PMYdGopyQ=
=Vo9Z
-----END PGP SIGNATURE-----

--oBD7VOjePs9Ih+1P--
