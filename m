Return-Path: <kvm+bounces-39099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A642BA4389B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 10:04:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88F67168CA8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 09:03:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A626926138C;
	Tue, 25 Feb 2025 08:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="iQr28sfT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB8A260A51;
	Tue, 25 Feb 2025 08:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740473976; cv=none; b=r0pGldsevAcVpmHTDOmTKvpMPCWZYIL2rxO8Mx5YNhM33T8btOEKsnzJ/JCpfndxgtOXrhL1/BFxAGdyMAaGGHKBvuR8J9DB/KDikaDT0XtjVHoiRKNqekwi130amTcrAKFlDYZ77XRMXzm1Niy/1SXbedyMOI/+0/VFgRJZKRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740473976; c=relaxed/simple;
	bh=j4OcuOIxDqRceIeKTKMmyfwbdm/9Jn9sPvi80mVECCg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HfyNkmu/2aZaJWhWQQe8JGSxvVf4gNDnuVFH/b+VGkhN/cHOKSkrsx+d1PFWMftX/JmaiihY95OKC0NXwG3U1TPMZaxE9zVsa2b9/yLmKjQ3uzJJRipepbceLyN+54HOwnKLBVGhp8yW6Sp2WFaj2uTvDAQpnKOPz0KKZ/jJ88g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=iQr28sfT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OMnnbM013323;
	Tue, 25 Feb 2025 08:59:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Loa/Wr
	M/LsbHwGJZMxV7AkdUyRBOgiibIECkTOxcRgQ=; b=iQr28sfTU79Eln2+pesj10
	IMaBgbExFsJRyMVVqhtaMOF6Y7ta1qLERtZDNPa53Z6Rbyq9CBy1lgyKn2yOhQj7
	b1PVdsTYpb1kw8oQW8pupQYWR1Bpzz5w4Xedo1e46paO0d3Gg6AKeqyrpooQpFVn
	02v3tK0VjYexFBLFB3YiS6Zmc7C9T4XRrYwWgfCdTXRcFT2J/VrkaRFgpEfEq3Q6
	dFpYtw7rOEb5iPIvQ6k6m1m/JJMZL2d3rz4w+ALdVWW+Wl3GICGaNrt4ExfNIpDD
	NwsIbCrZbLnCAGiSV/D6VG28Kf+KfhiOtTl3aV0OB9nOvEGO+bS2zOcVx35g/Q4w
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4511waa3q6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 08:59:21 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 51P8xKdH024869;
	Tue, 25 Feb 2025 08:59:20 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4511waa3q3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 08:59:20 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51P5wIx9012735;
	Tue, 25 Feb 2025 08:59:19 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44yrwsm4tt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Feb 2025 08:59:19 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51P8xIA529557272
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 08:59:18 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 514205805A;
	Tue, 25 Feb 2025 08:59:18 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F7965805D;
	Tue, 25 Feb 2025 08:59:14 +0000 (GMT)
Received: from [9.171.91.87] (unknown [9.171.91.87])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Feb 2025 08:59:14 +0000 (GMT)
Message-ID: <7bcd6de5f40b2ee6d4d6758e3d2473172bd9b990.camel@linux.ibm.com>
Subject: Re: [PATCH v6 0/3] vfio/pci: s390: Fix issues preventing
 VFIO_PCI_MMAP=y for s390 and enable it
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Alexandra Winter
 <wintera@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato	
 <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Thorsten Winkler	
 <twinkler@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Julian Ruess
	 <julianr@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Gerald Schaefer	 <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Date: Tue, 25 Feb 2025 09:59:13 +0100
In-Reply-To: <20250224205314.GA478317@bhelgaas>
References: <20250224205314.GA478317@bhelgaas>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oLFPjSzyp6gQNtF5PwA-vF2Ohd1XdAH1
X-Proofpoint-ORIG-GUID: P3H2XF625KdDvvOt1mMRoJsXJvEAF0M_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_03,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=974 mlxscore=0
 malwarescore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 phishscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502100000 definitions=main-2502250061

On Mon, 2025-02-24 at 14:53 -0600, Bjorn Helgaas wrote:
> On Fri, Feb 14, 2025 at 02:10:51PM +0100, Niklas Schnelle wrote:
> > With the introduction of memory I/O (MIO) instructions enbaled in commi=
t
> > 71ba41c9b1d9 ("s390/pci: provide support for MIO instructions") s390
> > gained support for direct user-space access to mapped PCI resources.
> > Even without those however user-space can access mapped PCI resources
> > via the s390 specific MMIO syscalls. There is thus nothing fundamentall=
y
> > preventing s390 from supporting VFIO_PCI_MMAP, allowing user-space
> > drivers to access PCI resources without going through the pread()
> > interface. To actually enable VFIO_PCI_MMAP a few issues need fixing
> > however.
> >=20
> > Firstly the s390 MMIO syscalls do not cause a page fault when
> > follow_pte() fails due to the page not being present. This breaks
> > vfio-pci's mmap() handling which lazily maps on first access.
> >=20
> > Secondly on s390 there is a virtual PCI device called ISM which has
> > a few oddities. For one it claims to have a 256 TiB PCI BAR (not a typo=
)
> > which leads to any attempt to mmap() it fail with the following message=
:
> >=20
> >     vmap allocation for size 281474976714752 failed: use vmalloc=3D<siz=
e> to increase size
> >=20
> > Even if one tried to map this BAR only partially the mapping would not
> > be usable on systems with MIO support enabled. So just block mapping
> > BARs which don't fit between IOREMAP_START and IOREMAP_END. Solve this
> > by keeping the vfio-pci mmap() blocking behavior around for this
> > specific device via a PCI quirk and new pdev->non_mappable_bars
> > flag.
> >=20
> > As noted by Alex Williamson With mmap() enabled in vfio-pci it makes
> > sense to also enable HAVE_PCI_MMAP with the same restriction for pdev->
> > non_mappable_bars. So this is added in patch 3 and I tested this with
> > another small test program.
> >=20
> > Note:
> > For your convenience the code is also available in the tagged
> > b4/vfio_pci_mmap branch on my git.kernel.org site below:
> > https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git/
> >=20
> > Thanks,
> > Niklas
> >=20
> > Link: https://lore.kernel.org/all/c5ba134a1d4f4465b5956027e6a4ea6f6beff=
969.camel@linux.ibm.com/
> > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > ---
> > Changes in v6:
> > - Add a patch to also enable PCI resource mmap() via sysfs and proc
> >   exlcluding pdev->non_mappable_bars devices (Alex Williamson)
> > - Added Acks
> > - Link to v5: https://lore.kernel.org/r/20250212-vfio_pci_mmap-v5-0-633=
ca5e056da@linux.ibm.com
>=20
> I think the series would be more readable if patch 2/3 included all
> the core changes (adding pci_dev.non_mappable_bars, the 3/3
> pci-sysfs.c and proc.c changes to test it, and I suppose the similar
> vfio_pci_core.c change), and we moved all the s390 content from 2/3 to
> 3/3.

Maybe we could do the following:

1/3: As is

2/3: Introduces pdev->non_mappable_bars and the checks in vfio and
proc.c/pci-sysfs.c. To make the flag handle the vfio case with
VFIO_PCI_MMAP gone, a one-line change in s390 will set pdev-
>non_mappable_bars =3D 1 for all PCI devices.

3/3: Changes setting pdev->non_mappable_bars =3D 1 in s390 to only the
ISM device using the quirk handling and adds HAVE_PCI_MMAP.

Thanks,
Niklas

