Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FC242D247
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 08:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbhJNGYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 02:24:41 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:58217 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhJNGYh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 02:24:37 -0400
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4HVK7r2D0Cz4xbc; Thu, 14 Oct 2021 17:22:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1634192552;
        bh=991NeYHmGQZ0qysWHBsYafRGzaDyb/Bat2azxap/yuA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nuoDIaNHdj78leDbbLxyLp2Ij29lHlzRddLzEV4C4IQpwkXEgwwujoowjw3w5L5A6
         9G227cKlN1AXsl+ZHIVYb4hff0hDLG/YJsOTfEfVu7e0q/r26n+ppaf8qcpKvSp+4W
         CJoApzt3VMg/HL+9Vv6vphckmAi6ytXH+lAwDti4=
Date:   Thu, 14 Oct 2021 15:53:33 +1100
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
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <YWe3zS4lIn8cj6su@yekko>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <YVanJqG2pt6g+ROL@yekko>
 <20211001122225.GK964074@nvidia.com>
 <YWPTWdHhoI4k0Ksc@yekko>
 <20211011184914.GQ2744544@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OErWDsOPH+kUGf0j"
Content-Disposition: inline
In-Reply-To: <20211011184914.GQ2744544@nvidia.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--OErWDsOPH+kUGf0j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 11, 2021 at 03:49:14PM -0300, Jason Gunthorpe wrote:
> On Mon, Oct 11, 2021 at 05:02:01PM +1100, David Gibson wrote:
>=20
> > > This means we cannot define an input that has a magic HW specific
> > > value.
> >=20
> > I'm not entirely sure what you mean by that.
>=20
> I mean if you make a general property 'foo' that userspace must
> specify correctly then your API isn't general anymore. Userspace must
> know if it is A or B HW to set foo=3DA or foo=3DB.

I absolutely agree.  Which is exactly why I'm advocating that
userspace should request from the kernel what it needs (providing a
*minimum* of information) and the kernel satisfies that (filling in
the missing information as suitable for the platform) or outright
fails.

I think that is more robust across multiple platforms and usecases
than advertising a bunch of capabilities and forcing userspace to
interpret those to work out what it can do.

> Supported IOVA ranges are easially like that as every IOMMU is
> different. So DPDK shouldn't provide such specific or binding
> information.

Absolutely, DPDK should not provide that.  qemu *should* provide that,
because the specific IOVAs matter to the guest.  That will inevitably
mean that the request is more likely to fail, but that's a fundamental
tradeoff.

> > No, I don't think that needs to be a condition.  I think it's
> > perfectly reasonable for a constraint to be given, and for the host
> > IOMMU to just say "no, I can't do that".  But that does mean that each
> > of these values has to have an explicit way of userspace specifying "I
> > don't care", so that the kernel will select a suitable value for those
> > instead - that's what DPDK or other userspace would use nearly all the
> > time.
>=20
> My feeling is that qemu should be dealing with the host !=3D target
> case, not the kernel.
>=20
> The kernel's job should be to expose the IOMMU HW it has, with all
> features accessible, to userspace.

See... to me this is contrary to the point we agreed on above.

> Qemu's job should be to have a userspace driver for each kernel IOMMU
> and the internal infrastructure to make accelerated emulations for all
> supported target IOMMUs.

This seems the wrong way around to me.  I see qemu as providing logic
to emulate each target IOMMU.  Where that matches the host, there's
the potential for an accelerated implementation, but it makes life a
lot easier if we can at least have a fallback that will work on any
sufficiently capable host IOMMU.

> In other words, it is not the kernel's job to provide target IOMMU
> emulation.

Absolutely not.  But it *is* the kernel's job to let qemu do as mach
as it can with the *host* IOMMU.

> The kernel should provide truely generic "works everywhere" interface
> that qemu/etc can rely on to implement the least accelerated emulation
> path.

Right... seems like we're agreeing again.

> So when I see proposals to have "generic" interfaces that actually
> require very HW specific setup, and cannot be used by a generic qemu
> userpace driver, I think it breaks this model. If qemu needs to know
> it is on PPC (as it does today with VFIO's PPC specific API) then it
> may as well speak PPC specific language and forget about pretending to
> be generic.

Absolutely, the current situation is a mess.

> This approach is grounded in 15 years of trying to build these
> user/kernel split HW subsystems (particularly RDMA) where it has
> become painfully obvious that the kernel is the worst place to try and
> wrangle really divergent HW into a "common" uAPI.
>=20
> This is because the kernel/user boundary is fixed. Introducing
> anything generic here requires a lot of time, thought, arguing and
> risk. Usually it ends up being done wrong (like the PPC specific
> ioctls, for instance)

Those are certainly wrong, but they came about explicitly by *not*
being generic rather than by being too generic.  So I'm really
confused aso to what you're arguing for / against.

> and when this happens we can't learn and adapt,
> we are stuck with stable uABI forever.
>=20
> Exposing a device's native programming interface is much simpler. Each
> device is fixed, defined and someone can sit down and figure out how
> to expose it. Then that is it, it doesn't need revisiting, it doesn't
> need harmonizing with a future slightly different device, it just
> stays as is.

I can certainly see the case for that approach.  That seems utterly at
odds with what /dev/iommu is trying to do, though.

> The cost, is that there must be a userspace driver component for each
> HW piece - which we are already paying here!
>=20
> > Ideally the host /dev/iommu will say "ok!", since both those ranges
> > are within the 0..2^60 translated range of the host IOMMU, and don't
> > touch the IO hole.  When the guest calls the IO mapping hypercalls,
> > qemu translates those into DMA_MAP operations, and since they're all
> > within the previously verified windows, they should work fine.
>=20
> For instance, we are going to see HW with nested page tables, user
> space owned page tables and even kernel-bypass fast IOTLB
> invalidation.

> In that world does it even make sense for qmeu to use slow DMA_MAP
> ioctls for emulation?

Probably not what you want ideally, but it's a really useful fallback
case to have.

> A userspace framework in qemu can make these optimizations and is
> also necessarily HW specific as the host page table is HW specific..
>=20
> Jason
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--OErWDsOPH+kUGf0j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFnt8sACgkQbDjKyiDZ
s5I4Lw//YnoE2f5JsM7QBtou0kBy3fL0TytQ3fyB8cYHu+msSe8I7iIsGEQSOB9m
8zgrEmJkbJCMInzhw7vkGd5mwXo9szoAj30+1s6Aes+lRGtopaZwWivCHn9Hul73
EX/rq59veeuUDEOnEdv4AEvXwMhsfPmz+RDXL3rk1SW12jTYlt96WU81sr/xiyQn
Kznq3xgDk3KAilcc+drhugtsu7LoUBTeG+lNQTaqrS01AY+I9wBtnTVQVUXvQ52N
KtgjxGnPSVE3O2bbKgVLaNiTZZH0PD4/wyMhOzzHsEs5Dy600E7qgPFr2dkSIxLI
r2jO+7V0sCWqhH5cd7WMZAArnWeAdF5zlD15QqaJZkUhsZlqvqggZwJrJJQkLPcX
yzS/O13DY1LRHfKR3C/Y8ovcX0tECZutpnPWmpz+Ly/DEBTLEv9JJjRAhyIdRBez
X9A/YX3JhFHDc8r7Zo9UoumUtNdv150h+JArfkXOSN/93iEMlwj0LNXSuxws1jTw
rq5VVaQmgzT8+mnRhSb3JKZS9K6lyEQ2uHJ1BCx8eXf+/dB8quOTdUHqq+kjx3Fc
F56xs6oLnMd+tpUaZeU1wEGYD9tVSNBEERadVtIp+zTsLlFDzqa9coX55B6LSmeO
XF/K+ireCeVCdAgaeBAQh/TPo2lyxq2QMY01Ech0JBnAbM83zqo=
=dCEw
-----END PGP SIGNATURE-----

--OErWDsOPH+kUGf0j--
