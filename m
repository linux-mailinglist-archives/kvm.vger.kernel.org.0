Return-Path: <kvm+bounces-60830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05177BFCB75
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 16:57:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D317D19C7770
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 14:56:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A652E330B06;
	Wed, 22 Oct 2025 14:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b="ysNv8ldh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9C8281368
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 14:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761144948; cv=none; b=cKU/FQom71P4TJJvMrG4kNsWF0F6IbCocLR0qnoYVP9Tm4wkdb6yCGA6slwpHxQB3X6smStGwJ2XKYkbz1t857dVmW4Y2n0GGEi3tGqEBGxa/sNliq08C13TYQ0oPbyyG3WvNysfcox2mfW+AJvm9hlTwYgLcowtR2OwcHa7rLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761144948; c=relaxed/simple;
	bh=mTXEDhbPklwnuwXoHo+JEFvJqInjrTql1fJnNdnVWLI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l71QvudTOp+6K27Gj+c1pM2ihDSPjyEO++zBbvxC4t3ASuiMB4ZtlERC35d1KlZNkKA0QRMkfbaugkQ4BYXpxna2kyvRtiUhmwH5x32HDMWUEdyCJ4FtOVBPEB4/bb3/5HgKbL2BRkEUkXTFe+3mnknjtVPVUfdfQ048rYUgbWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=fb.com header.i=@fb.com header.b=ysNv8ldh; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fb.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 59ME1BRg495057
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 07:55:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=3Pxq7adyZuGRjMYC5LoHOzZm+NXukvXLEAUXf/pfmxI=; b=ysNv8ldhADFR
	9OIOs0r/axpxcVw7nhFTF/+6n21gJs+XoQ76eTb2uA0YEMpDtiTG5U7mixtluGAZ
	i2rd+ThcEsCTTmI+em1JPb+9g5GM8AlsvgH+yV+LsKuVatT83/YsJmllY+uDH06j
	0VSUIHmM7hgIohSIuWv3nPUpCeuOodnj/NCxWTwdMpX8m5IVSfXj6PFdxgzt2Uzx
	dAih3CxEqW3G9i77NhxIMHO5PVFullHL90rfXqkKr/m7l1TCd/330IkKMRiMM0v9
	mpO1j8rjOOxCjQi4QX1yVF3GunCrOpkvGGfTtlMuWhfY3P2k0jaXTavPVyIkswNj
	m9zLpKj7jw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 49xr0q3tme-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 07:55:45 -0700 (PDT)
Received: from twshared0973.10.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Wed, 22 Oct 2025 14:55:43 +0000
Received: by devgpu012.nha5.facebook.com (Postfix, from userid 23751)
	id 4F811591CCA; Wed, 22 Oct 2025 07:55:35 -0700 (PDT)
Date: Wed, 22 Oct 2025 07:55:35 -0700
From: Alex Mastro <amastro@fb.com>
To: David Matlack <dmatlack@google.com>
CC: Alex Williamson <alex@shazbot.org>,
        Alejandro Jimenez
	<alejandro.j.jimenez@oracle.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/3] vfio: handle DMA map/unmap up to the addressable
 limit
Message-ID: <aPjwZ1Fh9hmFJyok@devgpu012.nha5.facebook.com>
References: <20251015132452.321477fa@shazbot.org>
 <3308406e-2e64-4d53-8bcc-bac84575c1d9@oracle.com>
 <aPFheZru+U+C4jT7@devgpu015.cco6.facebook.com>
 <20251016160138.374c8cfb@shazbot.org>
 <aPJu5sXw6v3DI8w8@devgpu012.nha5.facebook.com>
 <20251020153633.33bf6de4@shazbot.org>
 <aPe0E6Jj9BJA2Bd5@devgpu012.nha5.facebook.com>
 <CALzav=ebeVvg5jyFjkAN-Ud==6xS9y1afszSE10mpa9PUOu+Dw@mail.gmail.com>
 <aPfbU4rYkSUDG4D0@devgpu012.nha5.facebook.com>
 <CALzav=cyDaiKbQfkjF_UUQ0PB6cAKZhnSqM3ZvodqqEe8kQEqw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CALzav=cyDaiKbQfkjF_UUQ0PB6cAKZhnSqM3ZvodqqEe8kQEqw@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-GUID: 64kSc-zHA8ZiIjN4Q9ATLhkt7Qb3I3Jg
X-Authority-Analysis: v=2.4 cv=dLSrWeZb c=1 sm=1 tr=0 ts=68f8f071 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=FOH2dFAWAAAA:8 a=v4r7LAIuhmP5iyC60hwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDEyMiBTYWx0ZWRfX/SZBepf6D0Ui
 azB/HQabcCESs5LFp46Pw5XMdyyajXyuPpd4R/ti18eZIJx7bdIDEUeJg7uiG/oDazTofIv5LRg
 vXPvY9UGqjHjcZO3kNVwnAvJvMLDPeNmq3+QZ1SLUL46/gwNWwYVs5cqo2kieJ9WhszkawAjtxS
 3c53cGqSDKHjpcWIqs+iL7sU8F6u/yWVP3IfPYpqQITgeZy78l3f2VG+i64Zj+i5CDrinRjUFab
 l3nl6pihPLl8PVLPRUeNOqIPEaiJAQ7mtR35wPGm4zDDQp/HhqpZJvt33Oq6x8WzsxfqCsWiHrp
 V0iTXxpzSfUQd59pww96dtuodC25KhZaBYN70jTD5Q8dcZgXVQVlJEtdtdd+obJwejoI6T47Txk
 mWKTQSPxoAGQ9es7KAbdcYlgfcAPmA==
X-Proofpoint-ORIG-GUID: 64kSc-zHA8ZiIjN4Q9ATLhkt7Qb3I3Jg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_06,2025-10-13_01,2025-03-28_01

Thanks David -- this is good feedback. Will roll these suggestions into v=
5.

On Tue, Oct 21, 2025 at 05:38:31PM -0700, David Matlack wrote:
> On Tue, Oct 21, 2025 at 12:13=E2=80=AFPM Alex Mastro <amastro@fb.com> w=
rote:
> > I updated the *_unmap function signatures to return the count of byte=
s unmapped,
> > since that is part of the test pass criteria. Also added unmap_all fl=
avors,
> > since those exercise different code paths than range-based unmap.
>=20
> When you send, can you introduce these in a separate commit and update
> the existing test function in vfio_dma_mapping_test.c to assert on it?

SGTM

> > +#undef FIXTURE_VARIANT_ADD_IOMMU_MODE
>=20
> I think this can/should go just after the
> FIXTURE_VARIANT_ADD_ALL_IOMMU_MODES(); statement. The same below.

Ack.

> > +       unmapped =3D vfio_pci_dma_unmap_all(self->device);
> > +       ASSERT_EQ(unmapped, size);
>=20
> The unmap_all test should probably be in a separate TEST_F. You can
> put the struct vfio_dma_region in the FIXTURE and initialize it in the
> FIXTURE_SETUP() to reduce code duplication.
> > +}

Make sense.

> Would it be useful to add negative map/unmap tests as well? If so we'd
> need a way to plumb the return value of the ioctl up to the caller so
> you can assert that it failed, which will conflict with returning the
> amount of unmapped bytes.

Testing negative cases would be useful. Not sure about the mechanics yet.

>=20
> Maybe we should make unmapped an output parameter like so?
>=20
> int __vfio_pci_dma_map(struct vfio_pci_device *device,
>         struct vfio_dma_region *region);
>=20
> void vfio_pci_dma_map(struct vfio_pci_device *device,
>         struct vfio_dma_region *region);
>=20
> int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
>         struct vfio_dma_region *region, u64 *unmapped);
>=20
> void vfio_pci_dma_unmap(struct vfio_pci_device *device,
>         struct vfio_dma_region *region, u64 *unmapped);
>=20
> int __vfio_pci_dma_unmap_all(struct vfio_pci_device *device, u64 *unmap=
ped);
> void vfio_pci_dma_unmap_all(struct vfio_pci_device *device, u64 *unmapp=
ed);
>=20
> unmapped can be optional and callers that don't care can pass in NULL.
> It'll be a little gross though to see NULL on all the unmap calls
> though... Maybe unmapped can be restricted to __vfio_pci_dma_unmap().
> So something like this:
>=20
> int __vfio_pci_dma_unmap(struct vfio_pci_device *device,
>         struct vfio_dma_region *region, u64 *unmapped);
>=20
> void vfio_pci_dma_unmap(struct vfio_pci_device *device,
>         struct vfio_dma_region *region);

I'll put some thought into this and propose something in v5.

