Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A813AAD4D
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 09:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhFQHYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 03:24:18 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:42809 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhFQHYQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 03:24:16 -0400
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G5D5W6N8xz9sWM; Thu, 17 Jun 2021 17:22:07 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623914527;
        bh=nMIejQhBBbAiJzh1waEkmffz9zEoMKNNjdFKEBUdaAs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LP2SrMyFZFM3lxnV0cfsJLLOZ8pFFXH4yyGOAuS/2XtiUfUx3XwCsddDp919mD57F
         XzK/GtQd1OZxlkdHpfgxnFDEZ4UL8woMDvJ38I2R8RBvX/0nRdewdAjSGYOPSFnb9v
         LpwehvlI98nioGHkuJ42banezN8EHq75C6WmjrFI=
Date:   Thu, 17 Jun 2021 15:02:33 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Joerg Roedel <joro@8bytes.org>, Jason Gunthorpe <jgg@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
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
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <YMrXaWfAyLBnI3eP@yekko>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
 <YMDC8tOMvw4FtSek@8bytes.org>
 <20210609150009.GE1002214@nvidia.com>
 <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8PvddoXrk24w8n4P"
Content-Disposition: inline
In-Reply-To: <20210609101532.452851eb.alex.williamson@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--8PvddoXrk24w8n4P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 09, 2021 at 10:15:32AM -0600, Alex Williamson wrote:
> On Wed, 9 Jun 2021 17:51:26 +0200
> Joerg Roedel <joro@8bytes.org> wrote:
>=20
> > On Wed, Jun 09, 2021 at 12:00:09PM -0300, Jason Gunthorpe wrote:
> > > Only *drivers* know what the actual device is going to do, devices do
> > > not. Since the group doesn't have drivers it is the wrong layer to be
> > > making choices about how to configure the IOMMU. =20
> >=20
> > Groups don't carry how to configure IOMMUs, that information is
> > mostly in the IOMMU domains. And those (or an abstraction of them) is
> > configured through /dev/ioasid. So not sure what you wanted to say with
> > the above.
> >=20
> > All a group carries is information about which devices are not
> > sufficiently isolated from each other and thus need to always be in the
> > same domain.
> >=20
> > > The device centric approach is my attempt at this, and it is pretty
> > > clean, I think. =20
> >=20
> > Clean, but still insecure.
> >=20
> > > All ACS does is prevent P2P operations, if you assign all the group
> > > devices into the same /dev/iommu then you may not care about that
> > > security isolation property. At the very least it is policy for user
> > > to decide, not kernel. =20
> >=20
> > It is a kernel decision, because a fundamental task of the kernel is to
> > ensure isolation between user-space tasks as good as it can. And if a
> > device assigned to one task can interfer with a device of another task
> > (e.g. by sending P2P messages), then the promise of isolation is broken.
>=20
> AIUI, the IOASID model will still enforce IOMMU groups, but it's not an
> explicit part of the interface like it is for vfio.  For example the
> IOASID model allows attaching individual devices such that we have
> granularity to create per device IOASIDs, but all devices within an
> IOMMU group are required to be attached to an IOASID before they can be
> used.  It's not entirely clear to me yet how that last bit gets
> implemented though, ie. what barrier is in place to prevent device
> usage prior to reaching this viable state.
>
> > > Groups should be primarily about isolation security, not about IOASID
> > > matching. =20
> >=20
> > That doesn't make any sense, what do you mean by 'IOASID matching'?
>=20
> One of the problems with the vfio interface use of groups is that we
> conflate the IOMMU group for both isolation and granularity.  I think
> what Jason is referring to here is that we still want groups to be the
> basis of isolation, but we don't want a uAPI that presumes all devices
> within the group must use the same IOASID.  For example, if a user owns
> an IOMMU group consisting of non-isolated functions of a multi-function
> device, they should be able to create a vIOMMU VM where each of those
> functions has its own address space.  That can't be done today, the
> entire group would need to be attached to the VM under a PCIe-to-PCI
> bridge to reflect the address space limitation imposed by the vfio
> group uAPI model.  Thanks,

I'm fairly sceptical of the idea of allowing the "identifiable
requestor" grouping to be different from the isolation grouping.
Certainly it's possible in hardware, but I think it makes the
interface horribly complex to understand without buying much.

"Good" modern devices on modern systems will be both fully isolated
and well identified, so for the uses cases that people seem to mostly
care about here we'll still have identification group =3D=3D isolation
group =3D=3D one device.

In other words, do we really have use cases where we need to identify
different devices IDs, even though we know they're not isolated.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--8PvddoXrk24w8n4P
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDK12cACgkQbDjKyiDZ
s5JIqw/+Le8InXvaXY8PJqs4GLnd0hYRw12Z0I/TLdJN/Tb0dn4/aCLKUwXDe2L0
RmzpW/UurBMhJcndCukBTe5k9ylkhmifjAVHzDt+fjxc1hdwaaUWKblj8lQPzVkb
TBSFQlj9hGJ1zVYZRq1lG2Oh8CbUveiM3UP7dfaV/N0M5KhBtqdMsq/+LrF9MW0s
6d7ckET4i2UoOBVWVLO+UVx2HekQmZ6F0LJIUs45PkqusM0U5ruBsnmhCy8oNgcB
HWoICR834W0u6r8ox8QXQCpe5vvIk6RzXGc0hgWEmQCT7QHIrg6J4QqspIalkp0O
7Mm9HlgHXg/d9emXUA+kL5GvvtF84+iNjxMU9llCrCIsq24rvY1x2GhmzcyVly/9
6Rzclsze/0I3DF7oHvwlW8x6fbQ6rKDryLfeIPBrGzoyEQQmTznTkVbo/MSbilUY
q739RRgRjq9248MZJFZJ8UVYDsyfxgXglLB/8R1O/Y/q+z88W4EbX7p2tcHSQXMx
wBkdYp0oQyhpvCHIbsqPnClnwM5Ox1w640jM0aq439IchMWcd+xkumiamm1uHcu7
jkl9Gr+6qzPXAFZdpuSgKUV+HJhf3U7A/94rZlNoP75fhC9UrODKZFLmtmRymegG
w+NjcLl2mH0z1r3r0L7BE1w7eafKYOAqQF1I6VWIXnoWojHHq5w=
=CyOl
-----END PGP SIGNATURE-----

--8PvddoXrk24w8n4P--
