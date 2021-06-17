Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1B43AAD60
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 09:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhFQHYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 03:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhFQHYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 03:24:24 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFE5C06175F;
        Thu, 17 Jun 2021 00:22:16 -0700 (PDT)
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4G5D5X0Rcrz9sX1; Thu, 17 Jun 2021 17:22:08 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1623914528;
        bh=cv9SO0hR36Zcr4ac50I3juTYJZKB4nHG5BIWoMEa7HU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SrHIuOMI6KkBFE0XphoxAhqxIbSomglcOjfWzG2pRKq+fMlpdJGC7ht3vlkI4Aumk
         T3GgdaSnI7DqFMrwNxLgFwaMIpVIjPuzAU3LeBt5H/nzAPIRviS3DvWX+z4EaAYsLY
         4rsEDmf2kSgaaT5t4+LRse8bz6TuDynlENtHAgZo=
Date:   Thu, 17 Jun 2021 15:29:30 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <YMrduqZj970sMC12@yekko>
References: <YMCy48Xnt/aphfh3@8bytes.org>
 <20210609123919.GA1002214@nvidia.com>
 <YMDC8tOMvw4FtSek@8bytes.org>
 <20210609150009.GE1002214@nvidia.com>
 <YMDjfmJKUDSrbZbo@8bytes.org>
 <20210609101532.452851eb.alex.williamson@redhat.com>
 <20210609102722.5abf62e1.alex.williamson@redhat.com>
 <20210609184940.GH1002214@nvidia.com>
 <20210610093842.6b9a4e5b.alex.williamson@redhat.com>
 <20210611164529.GR1002214@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6z+5/HR0ORsYRart"
Content-Disposition: inline
In-Reply-To: <20210611164529.GR1002214@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--6z+5/HR0ORsYRart
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 11, 2021 at 01:45:29PM -0300, Jason Gunthorpe wrote:
> On Thu, Jun 10, 2021 at 09:38:42AM -0600, Alex Williamson wrote:
>=20
> > Opening the group is not the extent of the security check currently
> > required, the group must be added to a container and an IOMMU model
> > configured for the container *before* the user can get a devicefd.
> > Each devicefd creates a reference to this security context, therefore
> > access to a device does not exist without such a context.
>=20
> Okay, I missed that detail in the organization..
>=20
> So, if we have an independent vfio device fd then it needs to be
> kept disable until the user joins it to an ioasid that provides the
> security proof to allow it to work?
>=20
> > What happens on detach?  As we've discussed elsewhere in this thread,
> > revoking access is more difficult than holding a reference to the
> > secure context, but I'm under the impression that moving a device
> > between IOASIDs could be standard practice in this new model.  A device
> > that's detached from a secure context, even temporarily, is a
> > problem.
>=20
> This is why I think the single iommu FD is critical, it is the FD, not
> the IOASID that has to authorize the security. You shouldn't move
> devices between FDs, but you can move them between IOASIDs inside the
> same FD.
>=20
> > How to label a device seems like a relatively mundane issue relative to
> > ownership and isolated contexts of groups and devices.  The label is
> > essentially just creating an identifier to device mapping, where the
> > identifier (label) will be used in the IOASID interface, right?=20
>=20
> It looks that way
>=20
> > As I note above, that makes it difficult for vfio to maintain that a
> > user only accesses a device in a secure context.  This is exactly
> > why vfio has the model of getting a devicefd from a groupfd only
> > when that group is in a secure context and maintaining references to
> > that secure context for each device.  Split ownership of the secure
> > context in IOASID vs device access in vfio and exposing devicefds
> > outside the group is still a big question mark for me.  Thanks,
>=20
> I think the protection model becomes different once we allow
> individual devices inside a group to be attached to different
> IOASID's.

I'm really wary of this.  They might be rare, but we still need to
consider the case of devices which can't be distinguished on the bus,
and therefore can't be attached to different IOASIDs.  That means that
if we allow attaching devices within a group to different IOASIDs we
effectively need to introduce two levels of "group-like" things.
First the idenfication group, then the isolation group.


You're using "group" for the isolation group, but then we have to
somehow expose this concept of identification group.  That seems like
a heap of complexity and confusion in the interface.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--6z+5/HR0ORsYRart
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDK3boACgkQbDjKyiDZ
s5I9kxAA0QukseY3jKTmf0dc22wGxjZPOcBjHPo0Q0kDkFXxDCKbE+OFmwIS/Udr
lQ2sAThf1Oy9CRMarmqN12YOtr+a02CHa+L87P4//PYb3KxVSUnfk/67MUm4KBRI
Amkn4QWgJEXeSZRp7GjftpDjZ9hoLURDUPJRPJnDb5j0zliw/eSI4IbhIVt31XLf
4l0ADlAaPyvwPvMPVSQSF7uIvSRsVr3M/RRWZjj6MSgJPwIMqaA7RXv8GGqutzc3
JFwVbI5X8AfUgDdNrRpj4HPwo32+hCvAu7g70/rKSruGjAzQM2k45b8GzfQOAXPF
JjRcSVxenCzbNmP7XlB1ZcBNQanp5KhkVReMISh2GVins129nJ2drZvaCmHUcq2v
92ppg1uqYxQgjeRQoccuwQDvJ0dTmtPldoPbCKVDm/0nauz6htcyThh5No4Kcsl8
RLl7mDukYKEX5yYCiTt2gBIjDCkO6foBotyuRwSGmQkTlUMDuQ1xTodnbfWRvLCF
87OvDiYomV+elvPx06+oOPZVqHlifFa+dFN61o/m1HiJQV7Gr3ZB8wkBsDp69WYe
FjVbJE+gDtPdZXkbS36QVY98zNWhp9wX5c4Gtl7erAzEWwgmrlg8KoD0smPKN0SQ
z9gTR1QD7S9KxWsPQF/bf76tdecS9CGOGHmch9JbstjJU3JO3pM=
=+5am
-----END PGP SIGNATURE-----

--6z+5/HR0ORsYRart--
