Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D034851376D
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 16:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiD1O4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 10:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiD1O4m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 10:56:42 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F050BB1AB2
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 07:53:27 -0700 (PDT)
Received: by gandalf.ozlabs.org (Postfix, from userid 1007)
        id 4KpzBt3MgNz4ySY; Fri, 29 Apr 2022 00:53:26 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gibson.dropbear.id.au; s=201602; t=1651157606;
        bh=R1RXatjGRRQckNHChhTscLpeho5BmCExzGTgb1Yf0qU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X+UBOugeVqd3uXX08dIEREdc/UsBp2Xm294X49fmWDfPA5hTtGUqmAMmfzELF+pnj
         JpNXaZx2dUONkv5wCzrhXhxX5uXvACt7GXJeMD4emhwkgSD5UHSc+5Qx4IHZ5LjHbC
         bWl1zLKvJHWfAWIUqsZk/Yl3oipLofcSjJiL9zOs=
Date:   Fri, 29 Apr 2022 00:53:16 +1000
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <YmqqXHsCTxVb2/Oa@yekko>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
 <20220324003342.GV11336@nvidia.com>
 <20220324160403.42131028.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="lspAXFTELjodDmjg"
Content-Disposition: inline
In-Reply-To: <20220324160403.42131028.alex.williamson@redhat.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--lspAXFTELjodDmjg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 24, 2022 at 04:04:03PM -0600, Alex Williamson wrote:
> On Wed, 23 Mar 2022 21:33:42 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Wed, Mar 23, 2022 at 04:51:25PM -0600, Alex Williamson wrote:
> >=20
> > > My overall question here would be whether we can actually achieve a
> > > compatibility interface that has sufficient feature transparency that=
 we
> > > can dump vfio code in favor of this interface, or will there be enough
> > > niche use cases that we need to keep type1 and vfio containers around
> > > through a deprecation process? =20
> >=20
> > Other than SPAPR, I think we can.
>=20
> Does this mean #ifdef CONFIG_PPC in vfio core to retain infrastructure
> for POWER support?

There are a few different levels to consider for dealing with PPC.
For a suitable long term interface for ppc hosts and guests dropping
this is fine: the ppc specific iommu model was basically an
ill-conceived idea from the beginning, because none of us had
sufficiently understood what things were general and what things where
iommu model/hw specific.

=2E.mostly.  There are several points of divergence for the ppc iommu
model.

1) Limited IOVA windows.  This one turned out to not really be ppc
specific, and is (rightly) handlded generically in the new interface.
No problem here.

2) Costly GUPs.  pseries (the most common ppc machine type) always
expects a (v)IOMMU.  That means that unlike the common x86 model of a
host with IOMMU, but guests with no-vIOMMU, guest initiated
maps/unmaps can be a hot path.  Accounting in that path can be
prohibitive (and on POWER8 in particular it prevented us from
optimizing that path the way we wanted).  We had two solutions for
that, in v1 the explicit ENABLE/DISABLE calls, which preaccounted
based on the IOVA window sizes.  That was improved in the v2 which
used the concept of preregistration.  IIUC iommufd can achieve the
same effect as preregistration using IOAS_COPY, so this one isn't
really a problem either.

3) "dynamic DMA windows" (DDW).  The IBM IOMMU hardware allows for 2 IOVA
windows, which aren't contiguous with each other.  The base addresses
of each of these are fixed, but the size of each window, the pagesize
(i.e. granularity) of each window and the number of levels in the
IOMMU pagetable are runtime configurable.  Because it's true in the
hardware, it's also true of the vIOMMU interface defined by the IBM
hypervisor (and adpoted by KVM as well).  So, guests can request
changes in how these windows are handled.  Typical Linux guests will
use the "low" window (IOVA 0..2GiB) dynamically, and the high window
(IOVA 1<<60..???) to map all of RAM.  However, as a hypervisor we
can't count on that; the guest can use them however it wants.


(3) still needs a plan for how to fit it into the /dev/iommufd model.
This is a secondary reason that in the past I advocated for the user
requesting specific DMA windows which the kernel would accept or
refuse, rather than having a query function - it connects easily to
the DDW model.  With the query-first model we'd need some sort of
extension here, not really sure what it should look like.



Then, there's handling existing qemu (or other software) that is using
the VFIO SPAPR_TCE interfaces.  First, it's not entirely clear if this
should be a goal or not: as others have noted, working actively to
port qemu to the new interface at the same time as making a
comprehensive in-kernel compat layer is arguably redundant work.

That said, if we did want to handle this in an in-kernel compat layer,
here's roughly what you'd need for SPAPR_TCE v2:

- VFIO_IOMMU_SPAPR_TCE_GET_INFO
    I think this should be fairly straightforward; the information you
    need should be in the now generic IOVA window stuff and would just
    need massaging into the expected format.
- VFIO_IOMMU_SPAPR_REGISTER_MEMORY /
  VFIO_IOMMU_SPAPR_UNREGISTER_MEMORY
    IIUC, these could be traslated into map/unmap operations onto a
    second implicit IOAS which represents the preregistered memory
    areas (to which we'd never connect an actual device).  Along with
    this VFIO_MAP and VFIO_UNMAP operations would need to check for
    this case, verify their addresses against the preregistered space
    and be translated into IOAS_COPY operations from the prereg
    address space instead of raw IOAS_MAP operations.  Fiddly, but not
    fundamentally hard, I think.

For SPAPR_TCE_v1 things are a bit trickier

- VFIO_IOMMU_ENABLE/VFIO_IOMMU_DISABLE
    I suspect you could get away with implementing these as no-ops.
    It wouldn't be strictly correct, but I think software which is
    using the interface correctly should work this way, though
    possibly not optimally.  That might be good enough for this ugly
    old interface.

And... then there's VFIO_EEH_PE_OP.  It's very hard to know what to do
with this because the interface was completely broken for most of its
lifetime.  EEH is a fancy error handling feature of IBM PCI hardware
somewhat similar in concept, though not interface, to PCIe AER.  I have
a very strong impression that while this was a much-touted checkbox
feature for RAS, no-one, ever. actually used it.  As evidenced by the
fact that there was, I believe over a *decade* in which all the
interfaces were completely broken by design, and apparently no-one
noticed.

So, cynically, you could probably get away with making this a no-op as
well.  If you wanted to do it properly... well... that would require
training up yet another person to actually understand this and hoping
they get it done before they run screaming.  This one gets very ugly
because the EEH operations have to operate on the hardware (or
firmware) "Partitionable Endpoints" (PEs) which correspond one to one
with IOMMU groups, but not necessarily with VFIO containers, but
there's not really any sensible way to expose that to users.

You might be able to do this by simply failing this outright if
there's anything other than exactly one IOMMU group bound to the
container / IOAS (which I think might be what VFIO itself does now).
Handling that with a device centric API gets somewhat fiddlier, of
course.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--lspAXFTELjodDmjg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEoULxWu4/Ws0dB+XtgypY4gEwYSIFAmJqqlIACgkQgypY4gEw
YSJlZhAA0eF3+9g8wD+2zraRsAAS9Dr84RNzNm28VJRpePbtdAKsjxfaB/TSWfhW
4qnzrgmyro8USYSm/32AxG5LWm4a2wjavoBWuniNxoGPQi1TJWTsBtOk9eRVsnLf
nx9UIPr7TSPJQyfvoRzEFr+D/fdlZFb03bEkc99P4L2bp3ms9v2I2gauzfNZrOnZ
KI5JSX1Y33Zlr35h9OAXVn2eRaROlXK6/4HSByUT29H5vOKCMbIb2i8gWbe+BuHR
dlPHWLUHVkEGQKXGnReNWdplHW9heRPtufMDYtdoXxZ1fR6Wzn7R/mLjncNGc+MZ
AjNh5mWH+Ty/87h4nvZ71zQ3GO8/l/76nRpRnZF0DYhcFJe0xJzcWg+qGCfCBagV
xSDg9eF93ysLlw3nJJ20Xtrbly59ODKIHn5SO9zD7aL2Tb5EOiootj351peIeWMz
t5WtqGqix2fEQK6dzXK4IqVxDdk9wDxqiYl6eWRm6ez3DeK0Gk7n5bTHDehtYfps
pKYGXaCBnH1L0KltFyON7MhZ216VdBfnyXQpGlY0RUdvnBY0qqZvSDknXmBmDhGb
hWi+oKthXZyF0fw88zl6yjxj+xbZTzl9MhdonqSwCw83L24Tfipz4ZCemc2d9GO5
rQpRtVyQEpWvEssjrmnMWmL4fjY+FGDaJyWb1U05LWDmDdmyB9g=
=7kCR
-----END PGP SIGNATURE-----

--lspAXFTELjodDmjg--
