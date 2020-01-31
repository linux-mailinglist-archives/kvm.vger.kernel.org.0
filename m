Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C4814E7D3
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 05:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgAaETG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 23:19:06 -0500
Received: from ozlabs.org ([203.11.71.1]:49389 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727933AbgAaETG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 23:19:06 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 4883rR4R0jz9sRQ; Fri, 31 Jan 2020 15:19:03 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1580444343;
        bh=S8HBFAr+JEPEt6RudSE2u2FRnvTK1cgTyXZx/iPTRdU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OhPkwtwZM+eUMobCQtW4UNn1sRRPuk4Ul6MdQXX3oLy3SY58Z2wldCSIRs6reItaU
         nja5hiA6LgM/70Rcm/u69f+eBIaen+w5Let/iSr+4BfZGJ0Gcp60Im2Mhvm1ExI8oq
         jY+3WwXgVRhzQqEFvLZQtcxlxCkf43oQVIT0/cS0=
Date:   Fri, 31 Jan 2020 14:59:14 +1100
From:   David Gibson <david@gibson.dropbear.id.au>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com,
        alex.williamson@redhat.com, peterx@redhat.com, mst@redhat.com,
        eric.auger@redhat.com, kevin.tian@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, kvm@vger.kernel.org, hao.wu@intel.com,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: Re: [RFC v3 02/25] hw/iommu: introduce DualStageIOMMUObject
Message-ID: <20200131035914.GF15210@umbus.fritz.box>
References: <1580300216-86172-1-git-send-email-yi.l.liu@intel.com>
 <1580300216-86172-3-git-send-email-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="B0nZA57HJSoPbsHY"
Content-Disposition: inline
In-Reply-To: <1580300216-86172-3-git-send-email-yi.l.liu@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--B0nZA57HJSoPbsHY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 29, 2020 at 04:16:33AM -0800, Liu, Yi L wrote:
> From: Liu Yi L <yi.l.liu@intel.com>
>=20
> Currently, many platform vendors provide the capability of dual stage
> DMA address translation in hardware. For example, nested translation
> on Intel VT-d scalable mode, nested stage translation on ARM SMMUv3,
> and etc. In dual stage DMA address translation, there are two stages
> address translation, stage-1 (a.k.a first-level) and stage-2 (a.k.a
> second-level) translation structures. Stage-1 translation results are
> also subjected to stage-2 translation structures. Take vSVA (Virtual
> Shared Virtual Addressing) as an example, guest IOMMU driver owns
> stage-1 translation structures (covers GVA->GPA translation), and host
> IOMMU driver owns stage-2 translation structures (covers GPA->HPA
> translation). VMM is responsible to bind stage-1 translation structures
> to host, thus hardware could achieve GVA->GPA and then GPA->HPA
> translation. For more background on SVA, refer the below links.
>  - https://www.youtube.com/watch?v=3DKq_nfGK5MwQ
>  - https://events19.lfasiallc.com/wp-content/uploads/2017/11/\
> Shared-Virtual-Memory-in-KVM_Yi-Liu.pdf
>=20
> As above, dual stage DMA translation offers two stage address mappings,
> which could have better DMA address translation support for passthru
> devices. This is also what vIOMMU developers are doing so far. Efforts
> includes vSVA enabling from Yi Liu and SMMUv3 Nested Stage Setup from
> Eric Auger.
> https://www.spinics.net/lists/kvm/msg198556.html
> https://lists.gnu.org/archive/html/qemu-devel/2019-07/msg02842.html
>=20
> Both efforts are aiming to expose a vIOMMU with dual stage hardware
> backed. As so, QEMU needs to have an explicit object to stand for
> the dual stage capability from hardware. Such object offers abstract
> for the dual stage DMA translation related operations, like:
>=20
>  1) PASID allocation (allow host to intercept in PASID allocation)
>  2) bind stage-1 translation structures to host
>  3) propagate stage-1 cache invalidation to host
>  4) DMA address translation fault (I/O page fault) servicing etc.
>=20
> This patch introduces DualStageIOMMUObject to stand for the hardware
> dual stage DMA translation capability. PASID allocation/free are the
> first operation included in it, in future, there will be more operations
> like bind_stage1_pgtbl and invalidate_stage1_cache and etc.
>=20
> Cc: Kevin Tian <kevin.tian@intel.com>
> Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Eric Auger <eric.auger@redhat.com>
> Cc: Yi Sun <yi.y.sun@linux.intel.com>
> Cc: David Gibson <david@gibson.dropbear.id.au>
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>

Several overall queries about this:

1) Since it's explicitly handling PASIDs, this seems a lot more
   specific to SVM than the name suggests.  I'd suggest a rename.

2) Why are you hand rolling structures of pointers, rather than making
   this a QOM class or interface and putting those things into methods?

3) It's not really clear to me if this is for the case where both
   stages of translation are visible to the guest, or only one of
   them.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--B0nZA57HJSoPbsHY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAl4zphIACgkQbDjKyiDZ
s5IQYg/+LAuO22iNHumMZpGs30DHJ8l/gPm+BizzzE4S4QHRwO5Pe8etzEUWfcRw
ZlVfNTPtgKLOmgfJFk3kZt53UCuogwq4bodiNhTZ6ykCuq5LlADFMVhiaUJoUr8l
vfcOfD7QhQw0zCG8vPoMh+hn1eBd6KfcoyW9TW8vK0/OzNBYhj8mg0vVcjrDOSQS
Lzs/x8Pl8gnppwxgKqYBP8PATVeMOgnFPEfUaejvxW6/Dqg0Bwe55KF4ze/flAyA
PQbdHeX/c/9tGjqjJ2bVDTGylgCyFIIqaXgdSR3xUniSWf7ttwRM9b7VJrHT86wQ
D9NXjKIHQnhbgYOnsz3iI809oX3JFo8DKj2WvCvwWtLZO+ZyG1qR/SOEQZlGCe1S
w5ItoN1T5Bdq21OVDifi3iVsr20RJsMgwzwbG3YJu2jW9w3iH7tvjAsjT4sVuS62
YvhonQBiLpKr0FJsic9bgbTVnDDfQE9Nsm/cfnXrKIp505ELTFhl7BpLeit3TyCy
PNqf2r0ICn5ZoxsZ1sK2MbBAm8K+rYKXmINk3R4vBfw8Cve1K5HZZWpoCqkCF1tb
CUcwU/3B1Nem2hOGfI7JJIDXOf2BQuKnLVrTKuPOSO+ibYGWQO+BGmgoTG7ofZcf
gfkkOAWSvkaOHu1w2GM/DudhRC/rRPdOcEPldvhE9V8dVn8c8HU=
=YSYx
-----END PGP SIGNATURE-----

--B0nZA57HJSoPbsHY--
