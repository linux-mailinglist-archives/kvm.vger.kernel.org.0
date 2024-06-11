Return-Path: <kvm+bounces-19325-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3FA8903D3B
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 15:27:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F13E286A8F
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 13:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 263D917CA1F;
	Tue, 11 Jun 2024 13:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cjs9pIZ2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD39C1802CF;
	Tue, 11 Jun 2024 13:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112216; cv=none; b=rD1z0bsGggvMBDfPaHVVKjUfrQJkGYnFlzrGwhf5URoZ4TjoDRdlCG4kaMELoYs1NQ6sNADDnM/tykr1qqWX6E2ehrhOuScw0uvPciZHRT/fjdkZ9QamD554fm4X4PHBzVOLyLuYnjWE32YVCEHFR2OrOYcZvnKQDhDRC5yurfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112216; c=relaxed/simple;
	bh=Oj8hTpHqRt5Wv8Za1TW2g+HdJy6YR5bszvzFPxAunV4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pq++WV1sDxFRz5n0J7gn+FNDMRQMb13fjH/ALqjQjiySAeNb0AafH9eABIlot1fkfFNZZe/+bCIpZ5g9BxLQ5aHkfc/iZe9hChtRHhUQNOxY29pRoNASp/7gGWVnDditnVqqHi/yxn5+f+MCGaPIruApvcAefQxHL6/47OQrhVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cjs9pIZ2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BBSilx015944;
	Tue, 11 Jun 2024 13:23:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	GUDLAz90LJa54aUdAoi/lqQUowtLtFY+JLWY7HYgIWs=; b=cjs9pIZ239FI+GrY
	AM7G9tFmtgOiJb4X+lPcXLDvfC7qCUuf6bfKS9mQ3IY4ke9lcHbvPcahSrkFe4ms
	NN/BNW/rRjOJ9WYW0OcHy5KVhn2vBhieCL+S8sGts95QUtWCPPryWU6kr80VJreQ
	+1fxilLMEr5+uoHANaWclYSvQnbpmZWXnZD+LGGNpwEdjwRF/y9LgidJr2ZHnR7V
	PoFZNhbusKGdSI5fqafs9sHH8M6PqNFuH7CsQpBc9IfGdTPcvgfs+pXCfCDTndew
	h2TYpu0Mr6OR0G7R84Y4cJp6zOwhZ/cyLlK2WbbrQVkYe5nxUKuhEmuxCAEq4Rd9
	Gk7yjQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypnr0r8x3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 13:23:32 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45BDNWTi030894;
	Tue, 11 Jun 2024 13:23:32 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypnr0r8wy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 13:23:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45BAAKef027243;
	Tue, 11 Jun 2024 13:23:31 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yn210p3gy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 13:23:31 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45BDNRnI61473112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 13:23:29 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEC445804B;
	Tue, 11 Jun 2024 13:23:27 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EF77B5805B;
	Tue, 11 Jun 2024 13:23:24 +0000 (GMT)
Received: from [9.179.8.185] (unknown [9.179.8.185])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Jun 2024 13:23:24 +0000 (GMT)
Message-ID: <db10735e74d5a89aed73ad3268e0be40394efc31.camel@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alex
 Williamson <alex.williamson@redhat.com>,
        Gerd Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>
Date: Tue, 11 Jun 2024 15:23:24 +0200
In-Reply-To: <30ecb17b7a3414aeb605c51f003582c7f2cf6444.camel@linux.ibm.com>
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
	 <20240529-vfio_pci_mmap-v3-1-cd217d019218@linux.ibm.com>
	 <98de56b1ba37f51639b9a2c15a745e19a45961a0.camel@linux.ibm.com>
	 <30ecb17b7a3414aeb605c51f003582c7f2cf6444.camel@linux.ibm.com>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=mQINBGHm3M8BEAC+MIQkfoPIAKdjjk84OSQ8erd2OICj98+GdhMQpIjHXn/RJdCZLa58k
 /ay5x0xIHkWzx1JJOm4Lki7WEzRbYDexQEJP0xUia0U+4Yg7PJL4Dg/W4Ho28dRBROoJjgJSLSHwc
 3/1pjpNlSaX/qg3ZM8+/EiSGc7uEPklLYu3gRGxcWV/944HdUyLcnjrZwCn2+gg9ncVJjsimS0ro/
 2wU2RPE4ju6NMBn5Go26sAj1owdYQQv9t0d71CmZS9Bh+2+cLjC7HvyTHKFxVGOznUL+j1a45VrVS
 XQ+nhTVjvgvXR84z10bOvLiwxJZ/00pwNi7uCdSYnZFLQ4S/JGMs4lhOiCGJhJ/9FR7JVw/1t1G9a
 UlqVp23AXwzbcoV2fxyE/CsVpHcyOWGDahGLcH7QeitN6cjltf9ymw2spBzpRnfFn80nVxgSYVG1d
 w75ksBAuQ/3e+oTQk4GAa2ShoNVsvR9GYn7rnsDN5pVILDhdPO3J2PGIXa5ipQnvwb3EHvPXyzakY
 tK50fBUPKk3XnkRwRYEbbPEB7YT+ccF/HioCryqDPWUivXF8qf6Jw5T1mhwukUV1i+QyJzJxGPh19
 /N2/GK7/yS5wrt0Lwxzevc5g+jX8RyjzywOZGHTVu9KIQiG8Pqx33UxZvykjaqTMjo7kaAdGEkrHZ
 dVHqoPZwhCsgQARAQABtChOaWtsYXMgU2NobmVsbGUgPHNjaG5lbGxlQGxpbnV4LmlibS5jb20+iQ
 JXBBMBCABBAhsBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAhkBFiEEnbAAstJ1IDCl9y3cr+Q/Fej
 CYJAFAmWVooIFCQWP+TMACgkQr+Q/FejCYJCmLg/+OgZD6wTjooE77/ZHmW6Egb5nUH6DU+2nMHMH
 UupkE3dKuLcuzI4aEf/6wGG2xF/LigMRrbb1iKRVk/VG/swyLh/OBOTh8cJnhdmURnj3jhaefzslA
 1wTHcxeH4wMGJWVRAhOfDUpMMYV2J5XoroiA1+acSuppelmKAK5voVn9/fNtrVr6mgBXT5RUnmW60
 UUq5z6a1zTMOe8lofwHLVvyG9zMgv6Z9IQJc/oVnjR9PWYDUX4jqFL3yO6DDt5iIQCN8WKaodlNP6
 1lFKAYujV8JY4Ln+IbMIV2h34cGpIJ7f76OYt2XR4RANbOd41+qvlYgpYSvIBDml/fT2vWEjmncm7
 zzpVyPtCZlijV3npsTVerGbh0Ts/xC6ERQrB+rkUqN/fx+dGnTT9I7FLUQFBhK2pIuD+U1K+A+Egw
 UiTyiGtyRMqz12RdWzerRmWFo5Mmi8N1jhZRTs0yAUn3MSCdRHP1Nu3SMk/0oE+pVeni3ysdJ69Sl
 kCAZoaf1TMRdSlF71oT/fNgSnd90wkCHUK9pUJGRTUxgV9NjafZy7sx1Gz11s4QzJE6JBelClBUiF
 6QD4a+MzFh9TkUcpG0cPNsFfEGyxtGzuoeE86sL1tk3yO6ThJSLZyqFFLrZBIJvYK2UiD+6E7VWRW
 9y1OmPyyFBPBosOvmrkLlDtAtyfYInO0KU5pa2xhcyBTY2huZWxsZSA8bmlrbGFzLnNjaG5lbGxlQ
 GlibS5jb20+iQJUBBMBCAA+AhsBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEEnbAAstJ1IDCl9y
 3cr+Q/FejCYJAFAmWVoosFCQWP+TMACgkQr+Q/FejCYJB7oxAAksHYU+myhSZD0YSuYZl3oLDUEFP
 3fm9m6N9zgtiOg/GGI0jHc+Tt8qiQaLEtVeP/waWKgQnje/emHJOEDZTb0AdeXZk+T5/ydrKRLmYC
 6rPge3ue1yQUCiA+T72O3WfjZILI2yOstNwd1f0epQ32YaAvM+QbKDloJSmKhGWZlvdVUDXWkS6/m
 aUtUwZpddFY8InXBxsYCbJsqiKF3kPVD515/6keIZmZh1cTIFQ+Kc+UZaz0MxkhiCyWC4cH6HZGKR
 fiXLhPlmmAyW9FiZK9pwDocTLemfgMR6QXOiB0uisdoFnjhXNfp6OHSy7w7LTIHzCsJoHk+vsyvSp
 +fxkjCXgFzGRQaJkoX33QZwQj1mxeWl594QUfR4DIZ2KERRNI0OMYjJVEtB5jQjnD/04qcTrSCpJ5
 ZPtiQ6Umsb1c9tBRIJnL7gIslo/OXBe/4q5yBCtCZOoD6d683XaMPGhi/F6+fnGvzsi6a9qDBgVvt
 arI8ybayhXDuS6/StR8qZKCyzZ/1CUofxGVIdgkseDhts0dZ4AYwRVCUFQULeRtyoT4dKfEot7hPE
 /4wjm9qZf2mDPRvJOqss6jObTNuw1YzGlpe9OvDYtGeEfHgcZqEmHbiMirwfGLaTG2xKDx4g2jd2z
 Ocf83TCERFKJEhvZxB3tRiUQTd3dZ1TIaisv/o+y0K05pa2xhcyBTY2huZWxsZSA8bmlrbGFzLnNj
 aG5lbGxlQGdtYWlsLmNvbT6JAlQEEwEIAD4CGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQSds
 ACy0nUgMKX3Ldyv5D8V6MJgkAUCZZWiiwUJBY/5MwAKCRCv5D8V6MJgkNVuEACo12niyoKhnXLQFt
 NaqxNZ+8p/MGA7g2XcVJ1bYMPoZ2Wh8zwX0sKX/dLlXVHIAeqelL5hIv6GoTykNqQGUN2Kqf0h/z7
 b85o3tHiqMAQV0dAB0y6qdIwdiB69SjpPNK5KKS1+AodLzosdIVKb+LiOyqUFKhLnablni1hiKlqY
 yDeD4k5hePeQdpFixf1YZclGZLFbKlF/A/0Q13USOHuAMYoA/iSgJQDMSUWkuC0mNxdhfVt/gVJnu
 Kq+uKUghcHflhK+yodqezlxmmRxg6HrPVqRG4pZ6YNYO7YXuEWy9JiEH7MmFYcjNdgjn+kxx4IoYU
 O0MJ+DjLpVCV1QP1ZvMy8qQxScyEn7pMpQ0aW6zfJBsvoV3EHCR1emwKYO6rJOfvtu1rElGCTe3sn
 sScV9Z1oXlvo8pVNH5a2SlnsuEBQe0RXNXNJ4RAls8VraGdNSHi4MxcsYEgAVHVaAdTLfJcXZNCIU
 cZejkOE+U2talW2n5sMvx+yURAEVsT/50whYcvomt0y81ImvCgUz4xN1axZ3PCjkgyhNiqLe+vzge
 xq7B2Kx2++hxIBDCKLUTn8JUAtQ1iGBZL9RuDrBy2rR7xbHcU2424iSbP0zmnpav5KUg4F1JVYG12
 vDCi5tq5lORCL28rjOQqE0aLHU1M1D2v51kjkmNuc2pgLDFzpvgLQhTmlrbGFzIFNjaG5lbGxlIDx
 uaWtzQGtlcm5lbC5vcmc+iQJUBBMBCAA+AhsBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEEnbAA
 stJ1IDCl9y3cr+Q/FejCYJAFAmWVoosFCQWP+TMACgkQr+Q/FejCYJAglRAAihbDxiGLOWhJed5cF
 kOwdTZz6MyYgazbr+2sFrfAhX3hxPFoG4ogY/BzsjkN0cevWpSigb2I8Y1sQD7BFWJ2OjpEpVQd0D
 sk5VbJBXEWIVDBQ4VMoACLUKgfrb0xiwMRg9C2h6KlwrPBlfgctfvrWWLBq7+oqx73CgxqTcGpfFy
 tD87R4ovR9W1doZbh7pjsH5Ae9xX5PnQFHruib3y35zC8+tvSgvYWv3Eg/8H4QWlrjLHHy2AfZDVl
 9F5t5RfGL8NRsiTdVg9VFYg/GDdck9WPEgdO3L/qoq3Iuk0SZccGl+Nj8vtWYPKNlu2UvgYEbB8cl
 UoWhg+SjjYQka7/p6tc+CCPZ8JUpkgkAdt7yXt6370wP1gct2VztS6SEGcmAE1qxtGhi5Kuln4ZJ/
 UO2yxhPHgoW99OuZw3IRHe0+mNR67JbIpSuFWDFNjZ0nckQcU1taSEUi0euWs7i4MEkm0NsOsVhbs
 4D2vMiC6kO/FqWOPmWZeAjyJw/KRUG4PaJAr5zJUx57nhKWgeTniW712n4DwCUh77D/PHY0nqBTG/
 B+QQCR/FYGpTFkO4DRVfapT8njDrsWyVpP9o64VNZP42S+DuRGWfUKCMAXsM/wPzRiDEVfnZMcUR9
 vwLSHeoV7MiIFC0xIrp5ES9R00t4UFgqtGc36DV71qjR+66Im0=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 (3.52.2-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aY4gU-zkfQ-ro1uJhQ6bnF4PWlgiYKNk
X-Proofpoint-ORIG-GUID: RuNS6Dv8-1LyqhTOBG3mUOgTCqMaB-uQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_07,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406110097

On Tue, 2024-06-11 at 14:08 +0200, Niklas Schnelle wrote:
> On Tue, 2024-06-11 at 13:21 +0200, Niklas Schnelle wrote:
> > On Wed, 2024-05-29 at 13:36 +0200, Niklas Schnelle wrote:
> > > The s390 MMIO syscalls when using the classic PCI instructions do not
> > > cause a page fault when follow_pte() fails due to the page not being
> > > present. Besides being a general deficiency this breaks vfio-pci's mm=
ap()
> > > handling once VFIO_PCI_MMAP gets enabled as this lazily maps on first
> > > access. Fix this by following a failed follow_pte() with
> > > fixup_user_page() and retrying the follow_pte().
> > >=20
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > > Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> > > ---
> > >  arch/s390/pci/pci_mmio.c | 18 +++++++++++++-----
> > >  1 file changed, 13 insertions(+), 5 deletions(-)
> > >=20
> > > diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> > > index 5398729bfe1b..80c21b1a101c 100644
> > > --- a/arch/s390/pci/pci_mmio.c
> > > +++ b/arch/s390/pci/pci_mmio.c
> > > @@ -170,8 +170,12 @@ SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned lo=
ng, mmio_addr,
> > >  		goto out_unlock_mmap;
> > > =20
> > >  	ret =3D follow_pte(vma, mmio_addr, &ptep, &ptl);
> > > -	if (ret)
> > > -		goto out_unlock_mmap;
> > > +	if (ret) {
> > > +		fixup_user_fault(current->mm, mmio_addr, FAULT_FLAG_WRITE, NULL);
> > > +		ret =3D follow_pte(vma, mmio_addr, &ptep, &ptl);
> > > +		if (ret)
> > > +			goto out_unlock_mmap;
> > > +	}
> > > =20
> > >  	io_addr =3D (void __iomem *)((pte_pfn(*ptep) << PAGE_SHIFT) |
> > >  			(mmio_addr & ~PAGE_MASK));
> > > @@ -305,12 +309,16 @@ SYSCALL_DEFINE3(s390_pci_mmio_read, unsigned lo=
ng, mmio_addr,
> > >  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
> > >  		goto out_unlock_mmap;
> > >  	ret =3D -EACCES;
> > > -	if (!(vma->vm_flags & VM_WRITE))
> > > +	if (!(vma->vm_flags & VM_READ))
> > >  		goto out_unlock_mmap;
> > > =20
> > >  	ret =3D follow_pte(vma, mmio_addr, &ptep, &ptl);
> > > -	if (ret)
> > > -		goto out_unlock_mmap;
> > > +	if (ret) {
> > > +		fixup_user_fault(current->mm, mmio_addr, 0, NULL);
> > > +		ret =3D follow_pte(vma, mmio_addr, &ptep, &ptl);
> > > +		if (ret)
> > > +			goto out_unlock_mmap;
> > > +	}
> > > =20
> > >  	io_addr =3D (void __iomem *)((pte_pfn(*ptep) << PAGE_SHIFT) |
> > >  			(mmio_addr & ~PAGE_MASK));
> > >=20
> >=20
> > Ughh, I think I just stumbled over a problem with this. This is a
> > failing lock held assertion via __is_vma_write_locked() in
> > remap_pfn_range_notrack() but I'm not sure yet what exactly causes this
> >=20
> > [   67.338855] ------------[ cut here ]------------
> > [   67.338865] WARNING: CPU: 15 PID: 2056 at include/linux/rwsem.h:85 r=
emap_pfn_range_notrack+0x596/0x5b0
> > [   67.338874] Modules linked in: <--- 8< --->
> > [   67.338931] CPU: 15 PID: 2056 Comm: vfio-test Not tainted 6.10.0-rc1=
-pci-pfault-00004-g193e3a513cee #5
> > [   67.338934] Hardware name: IBM 3931 A01 701 (LPAR)
> > [   67.338935] Krnl PSW : 0704c00180000000 000003e54c9730ea (remap_pfn_=
range_notrack+0x59a/0x5b0)
> > [   67.338940]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0=
 PM:0 RI:0 EA:3
> > [   67.338944] Krnl GPRS: 0000000000000100 000003655915fb78 000002d80b9=
a5928 000003ff7fa00000
> > [   67.338946]            0004008000000000 0000000000004000 00000000000=
00711 000003ff7fa04000
> > [   67.338948]            000002d80c533f00 000002d800000100 000002d81bb=
e6c28 000002d80b9a5928
> > [   67.338950]            000003ff7fa00000 000002d80c533f00 000003e54c9=
73120 000003655915fab0
> > [   67.338956] Krnl Code: 000003e54c9730de: a708ffea            lhi    =
 %r0,-22
> >                           000003e54c9730e2: a7f4fff6            brc    =
 15,000003e54c9730ce
> >                          #000003e54c9730e6: af000000            mc     =
 0,0
> >                          >000003e54c9730ea: a7f4fd6e            brc    =
 15,000003e54c972bc6
> >                           000003e54c9730ee: af000000            mc     =
 0,0
> >                           000003e54c9730f2: af000000            mc     =
 0,0
> >                           000003e54c9730f6: 0707                bcr    =
 0,%r7
> >                           000003e54c9730f8: 0707                bcr    =
 0,%r7
> > [   67.339025] Call Trace:
> > [   67.339027]  [<000003e54c9730ea>] remap_pfn_range_notrack+0x59a/0x5b=
0
> > [   67.339032]  [<000003e54c973120>] remap_pfn_range+0x20/0x30
> > [   67.339035]  [<000003e4cce5396c>] vfio_pci_mmap_fault+0xec/0x1d0 [vf=
io_pci_core]
> > [   67.339043]  [<000003e54c977240>] handle_mm_fault+0x6b0/0x25a0
> > [   67.339046]  [<000003e54c966328>] fixup_user_fault+0x138/0x310
> > [   67.339048]  [<000003e54c63a91c>] __s390x_sys_s390_pci_mmio_read+0x2=
8c/0x3a0
> > [   67.339051]  [<000003e54c5e200a>] do_syscall+0xea/0x120
> > [   67.339055]  [<000003e54d5f9954>] __do_syscall+0x94/0x140
> > [   67.339059]  [<000003e54d611020>] system_call+0x70/0xa0
> > [   67.339063] Last Breaking-Event-Address:
> > [   67.339065]  [<000003e54c972bc2>] remap_pfn_range_notrack+0x72/0x5b0
> > [   67.339067] ---[ end trace 0000000000000000 ]---
> >=20
>=20
> This has me a bit confused so far as __is_vma_write_locked() checks
> mmap_assert_write_locked(vma->vm_mm) but most other users of
> fixup_user_fault() hold mmap_read_lock() just like this code and
> clearly in the non page fault case we only need the read lock.
>=20

And it gets weirder, as I could have sworn that I properly tested this
on v1, I retested with v1 (tags/sent/vfio_pci_mmap-v1 on my
git.kernel.org/niks and based on v6.9) and there I don't get the above
warning. I also made sure that it's not caused by my change to
"current->mm" for v2. But I'm also not hitting the checks David moved
into follow_pte() so yeah not sure what's going on here.


