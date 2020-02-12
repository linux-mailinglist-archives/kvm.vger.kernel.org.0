Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF2115A2D2
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2020 09:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbgBLIFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Feb 2020 03:05:50 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:46113 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728353AbgBLIFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Feb 2020 03:05:49 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 48HXJV1WMNz9sNg; Wed, 12 Feb 2020 19:05:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1581494746;
        bh=IGzmov+0cJgomEZP97UMK8ApIlBcyws4t7pmGf9P8RM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HRQ1FGUHrQO4O0G/6BYEiHyTjYUam0CWD8BeugOx9LcXgEoJ6YHVB5csa3D6aTWpp
         LQSiIY/Begbs194+Gdeb1P20ckTvACgsRYz9QV8JDhm3Z1S/mmZwpQjFISp2CRf5DB
         Z07wlIfS4aHoWj/bpnWqOT8K6CimmbBERb3QYFGo=
Date:   Wed, 12 Feb 2020 17:32:53 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Wu, Hao" <hao.wu@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v3 02/25] hw/iommu: introduce DualStageIOMMUObject
Message-ID: <20200212063253.GA22584@umbus.fritz.box>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-3-git-send-email-yi.l.liu@intel.com>
 <20200131035914.GF15210@umbus.fritz.box>
 <A2975661238FB949B60364EF0F2C25743A1992F1@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="185D1s7FREAUfc0L"
Content-Disposition: inline
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A1992F1@SHSMSX104.ccr.corp.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--185D1s7FREAUfc0L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 31, 2020 at 11:42:06AM +0000, Liu, Yi L wrote:
> Hi David,
>=20
> > From: David Gibson [mailto:david@gibson.dropbear.id.au]
> > Sent: Friday, January 31, 2020 11:59 AM
> > To: Liu, Yi L <yi.l.liu@intel.com>
> > Subject: Re: [RFC v3 02/25] hw/iommu: introduce DualStageIOMMUObject
> >=20
> > On Wed, Jan 29, 2020 at 04:16:33AM -0800, Liu, Yi L wrote:
> > > From: Liu Yi L <yi.l.liu@intel.com>
> > >
> > > Currently, many platform vendors provide the capability of dual stage
> > > DMA address translation in hardware. For example, nested translation
> > > on Intel VT-d scalable mode, nested stage translation on ARM SMMUv3,
> > > and etc. In dual stage DMA address translation, there are two stages
> > > address translation, stage-1 (a.k.a first-level) and stage-2 (a.k.a
> > > second-level) translation structures. Stage-1 translation results are
> > > also subjected to stage-2 translation structures. Take vSVA (Virtual
> > > Shared Virtual Addressing) as an example, guest IOMMU driver owns
> > > stage-1 translation structures (covers GVA->GPA translation), and host
> > > IOMMU driver owns stage-2 translation structures (covers GPA->HPA
> > > translation). VMM is responsible to bind stage-1 translation structur=
es
> > > to host, thus hardware could achieve GVA->GPA and then GPA->HPA
> > > translation. For more background on SVA, refer the below links.
> > >  - https://www.youtube.com/watch?v=3DKq_nfGK5MwQ
> > >  - https://events19.lfasiallc.com/wp-content/uploads/2017/11/\
> > > Shared-Virtual-Memory-in-KVM_Yi-Liu.pdf
> > >
> > > As above, dual stage DMA translation offers two stage address mapping=
s,
> > > which could have better DMA address translation support for passthru
> > > devices. This is also what vIOMMU developers are doing so far. Efforts
> > > includes vSVA enabling from Yi Liu and SMMUv3 Nested Stage Setup from
> > > Eric Auger.
> > > https://www.spinics.net/lists/kvm/msg198556.html
> > > https://lists.gnu.org/archive/html/qemu-devel/2019-07/msg02842.html
> > >
> > > Both efforts are aiming to expose a vIOMMU with dual stage hardware
> > > backed. As so, QEMU needs to have an explicit object to stand for
> > > the dual stage capability from hardware. Such object offers abstract
> > > for the dual stage DMA translation related operations, like:
> > >
> > >  1) PASID allocation (allow host to intercept in PASID allocation)
> > >  2) bind stage-1 translation structures to host
> > >  3) propagate stage-1 cache invalidation to host
> > >  4) DMA address translation fault (I/O page fault) servicing etc.
> > >
> > > This patch introduces DualStageIOMMUObject to stand for the hardware
> > > dual stage DMA translation capability. PASID allocation/free are the
> > > first operation included in it, in future, there will be more operati=
ons
> > > like bind_stage1_pgtbl and invalidate_stage1_cache and etc.
> > >
> > > Cc: Kevin Tian <kevin.tian@intel.com>
> > > Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Cc: Eric Auger <eric.auger@redhat.com>
> > > Cc: Yi Sun <yi.y.sun@linux.intel.com>
> > > Cc: David Gibson <david@gibson.dropbear.id.au>
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> >=20
> > Several overall queries about this:
> >=20
> > 1) Since it's explicitly handling PASIDs, this seems a lot more
> >    specific to SVM than the name suggests.  I'd suggest a rename.
>=20
> It is not specific to SVM in future. We have efforts to move guest
> IOVA support based on host IOMMU's dual-stage DMA translation
> capability.

It's assuming the existence of pasids though, which is a rather more
specific model than simply having two translation stages.

> Then, guest IOVA support will also re-use the methods
> provided by this abstract layer. e.g. the bind_guest_pgtbl() and
> flush_iommu_iotlb().
>=20
> For the naming, how about HostIOMMUContext? This layer is to provide
> explicit methods for setting up dual-stage DMA translation in host.

Uh.. maybe?  I'm still having trouble figuring out what this object
really represents.

> > 2) Why are you hand rolling structures of pointers, rather than making
> >    this a QOM class or interface and putting those things into methods?
>=20
> Maybe the name is not proper. Although I named it as DualStageIOMMUObject,
> it is actually a kind of abstract layer we discussed in previous email. I
> think this is similar with VFIO_MAP/UNMAP. The difference is that VFIO_MA=
P/
> UNMAP programs mappings to host iommu domain. While the newly added expli=
cit
> method is to link guest page table to host iommu domain. VFIO_MAP/UNMAP
> is exposed to vIOMMU emulators via MemoryRegion layer. right? Maybe addin=
g a
> similar abstract layer is enough. Is adding QOM really necessary for this
> case?

Um... sorry, I'm having a lot of trouble making any sense of that.

> > 3) It's not really clear to me if this is for the case where both
> >    stages of translation are visible to the guest, or only one of
> >    them.
>=20
> For this case, vIOMMU will only expose a single stage translation to VM.
> e.g. Intel VT-d, vIOMMU exposes first-level translation to guest. Hardware
> IOMMUs with the dual-stage translation capability lets guest own stage-1
> translation structures and host owns the stage-2 translation structures.
> VMM is responsible to bind guest's translation structures to host and
> enable dual-stage translation. e.g. on Intel VT-d, config translation type
> to be NESTED.

Ok, understood.

> Take guest SVM as an example, guest iommu driver owns the gVA->gPA mappin=
gs,
> which is treated as stage-1 translation from host point of view. Host its=
elf
> owns the gPA->hPPA translation and called stage-2 translation when dual-s=
tage
> translation is configured.
>=20
> For guest IOVA, it is similar with guest SVM. Guest iommu driver owns the
> gIOVA->gPA mappings, which is treated as stage-1 translation. Host owns t=
he
> gPA->hPA translation.

Ok, that makes sense.  It's still not really clear to me which part of
this setup this object represents.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--185D1s7FREAUfc0L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl5DnBMACgkQbDjKyiDZ
s5L0wxAAqn3HW9/zSf5J5Y8sgkr4tSCjrVrh5J3DVZk8buayTmrXQRl5NMGlAllJ
z96k+OjQ+/otGLFU9RTSvxDeFGew7+WgksG/LsRqG8VFWGn2pg6sqwhssGETzoRQ
oalhA+tZnwvk/+NGwT5R3fbv5hATtIzs7z3+tk6wifq7YGYfl3lbMZvkucELKwny
geOEkZMtZf9GKJzraP1Ppj0SnJhGQ+de+7e68JoBbeCpcPye0/PmKISUpkp3PNWQ
+13544JCoDMiFFZk9Z5IFtzfqugxptbYwlpZ0OYhYNS1JcnlBcew7qqukhYWKn5e
yDhHvu2Vvukvp0Q+a1h1MJ1moyQTqtC6Yu+eiMEziealMqEGvRqFhmRApNkEjUB0
xs4tMdKYTLMTsNpTf3xsf0iX9FMtjZBwkdt8HaK6Uy9UAGSGhgi9eLKofoyZNYPZ
uffICUI4q1sbCcu78zvfT+n4uhKSJNhlYm4ygNwOXYydI9MmJQCQGPcHaSjSSnrX
IsY6RfiV8B1S8eVFXfxTQ2Hk/B6VKP2GhZml3bYHwJpnIcAnoYATJcU8miDVc/2i
IP+ZdkwLscci5xUgQ/MsAA8ejlVo5EYaMwpbfwcpAT3HpHnbCk+5EbuckTuBz8Ig
yr37//nX5/o8TujUi/E1mGXAhLKNEN6GXx8W5HAmrBo0E63hVXY=
=7Fao
-----END PGP SIGNATURE-----

--185D1s7FREAUfc0L--
