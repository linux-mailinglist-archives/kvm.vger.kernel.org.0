Return-Path: <kvm+bounces-19336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A33904030
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 17:38:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14E3AB24839
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 15:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 011DC376E7;
	Tue, 11 Jun 2024 15:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dl6lbxuW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862EF2E851;
	Tue, 11 Jun 2024 15:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718120252; cv=none; b=aDl2Y2lTCuAknD8fbM/BfRjaT9XFt+iVKWuUnEN8M72bXTM8kFd4ByJZ5ra/OKkIDbTEqCm8IrCzQcnqwuK+hh8AqK+GLdhzTRe5QccNJEBI2esTY0jKU1SIspo2dHeUiGjw0/Odzv0WBvSyNMNfKCntrCf/yswTbi53oXf+65k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718120252; c=relaxed/simple;
	bh=+4bpNP3Rk7Ze8cN0tCLEvFAv4F8Chobda491tbKSylc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j/olbOQJXzHLqpLg7Fod7Vl9ksKpJ2w6l7YPQnyp9eG/gp5Uo1Dds5DWzeGJtXM+HfntxMtqW7fMaiggsCKPN1+JAB+1iwrtwZSP4+GFT5+CR97tKjozdyLsdLRAZmrHEytmJQfJOYr7xQ6+IwwWK6XWEsZP8L5+Xw/3iN0kfwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dl6lbxuW; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BDoZ3l002446;
	Tue, 11 Jun 2024 15:37:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	YuJmmDUmMoIyVg0142UGSIdXG0Vqk0V5S5A4k1eEg5I=; b=Dl6lbxuWF97RRN4x
	WiCjmZnDeCkMj0jdWnCAA1Mgk3joA4ckC967Lo9i9Cdby3/tlncDbGBBIg3C7sUm
	sR3oNVrZrv4tYKDUnKMTytGR0SuWRN89c1B1smjSQo+kHwsyUbZR4Jj9OinqEg8T
	V8cOAq1h+5ROyOKBtOqMAFdaezYkYQTIiizOGOUbtoJzv/U8NMgPOInh7lWdCfsC
	ySJNfi/9COBlP5p/rAqYgXgGJJ+/BbCRVBTjjRjEDHQ7+9w7RIsTygh9t2pZk53o
	ChwAK2QsnrkQt/Neoci7P30PwCrl/XucQRHht1hoiBgp9BBZY77gzqiWN0ODUgTe
	ik7agA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypnrcrmdu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 15:37:28 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45BFbGct007861;
	Tue, 11 Jun 2024 15:37:27 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypnrcrmdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 15:37:27 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45BDwPGv003905;
	Tue, 11 Jun 2024 15:37:26 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yn2mppkjs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 15:37:26 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45BFbNkQ17563926
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 11 Jun 2024 15:37:25 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F67458063;
	Tue, 11 Jun 2024 15:37:23 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 05B7E58064;
	Tue, 11 Jun 2024 15:37:21 +0000 (GMT)
Received: from [9.179.8.185] (unknown [9.179.8.185])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Jun 2024 15:37:20 +0000 (GMT)
Message-ID: <b38b571b753441314c090c3eb51c49c0e28a19d5.camel@linux.ibm.com>
Subject: Re: [PATCH v3 1/3] s390/pci: Fix s390_mmio_read/write syscall page
 fault handling
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>,
        Gerald Schaefer
 <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gerd
 Bayer <gbayer@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date: Tue, 11 Jun 2024 17:37:20 +0200
In-Reply-To: <89c74380-6a60-4091-ba57-93c75d9a37d7@redhat.com>
References: <20240529-vfio_pci_mmap-v3-0-cd217d019218@linux.ibm.com>
	 <20240529-vfio_pci_mmap-v3-1-cd217d019218@linux.ibm.com>
	 <98de56b1ba37f51639b9a2c15a745e19a45961a0.camel@linux.ibm.com>
	 <30ecb17b7a3414aeb605c51f003582c7f2cf6444.camel@linux.ibm.com>
	 <db10735e74d5a89aed73ad3268e0be40394efc31.camel@linux.ibm.com>
	 <ce7b9655-aaeb-4a13-a3ac-bd4a70bbd173@redhat.com>
	 <32b515269a31e177779f4d2d4fe2c05660beccc4.camel@linux.ibm.com>
	 <89c74380-6a60-4091-ba57-93c75d9a37d7@redhat.com>
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
X-Proofpoint-ORIG-GUID: 8BpTbv-O-kOTncNcEHlvsAVFYon6FovL
X-Proofpoint-GUID: mBHSUZxV2dlv1YDkckywynhTdRKTbhS3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_09,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 mlxlogscore=885 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2405170001 definitions=main-2406110111

On Tue, 2024-06-11 at 17:10 +0200, David Hildenbrand wrote:
> > >=20
> > > which checks mmap_assert_write_locked().
> > >=20
> > > Setting VMA flags would be racy with the mmap lock in read mode.
> > >=20
> > >=20
> > > remap_pfn_range() documents: "this is only safe if the mm semaphore i=
s
> > > held when called." which doesn't spell out if it needs to be held in
> > > write mode (which I think it does) :)
> >=20
> > Logically this makes sense to me. At the same time it looks like
> > fixup_user_fault() expects the caller to only hold mmap_read_lock() as
> > I do here. In there it even retakes mmap_read_lock(). But then wouldn't
> > any fault handling by its nature need to hold the write lock?
>=20
> Well, if you're calling remap_pfn_range() right now the expectation is=
=20
> that we hold it in write mode. :)
>=20
> Staring at some random users, they all call it from mmap(), where you=20
> hold the mmap lock in write mode.
>=20
>=20
> I wonder why we are not seeing that splat with vfio all of the time?
>=20
> That mmap lock check was added "recently". In 1c71222e5f23 we started=20
> using vm_flags_set(). That (including the mmap_assert_write_locked())=20
> check was added via bc292ab00f6c almost 1.5 years ago.
>=20
> Maybe vfio is a bit special and was never really run with lockdep?
>=20
> >=20
> > >=20
> > >=20
> > > My best guess is: if you are using remap_pfn_range() from a fault
> > > handler (not during mmap time) you are doing something wrong, that's =
why
> > > you get that report.
> >=20
> > @Alex: I guess so far the vfio_pci_mmap_fault() handler is only ever
> > triggered by "normal"/"actual" page faults where this isn't a problem?
> > Or could it be a problem there too?
> >=20
>=20
> I think we should see it there as well, unless I am missing something.

Well good news for me, bad news for everyone else. I just reproduced
the same problem on my x86_64 workstation. I "ported over" (hacked it
until it compiles) an x86 version of my trivial vfio-pci user-space
test code that mmaps() the BAR 0 of an NVMe and MMIO reads the NVMe
version field at offset 8. On my x86_64 box this leads to the following
splat (still on v6.10-rc1).

[  555.396773] ------------[ cut here ]------------
[  555.396774] WARNING: CPU: 3 PID: 1424 at include/linux/rwsem.h:85 remap_=
pfn_range_notrack+0x625/0x650
[  555.396778] Modules linked in: vfio_pci <-- 8< -->
[  555.396877] CPU: 3 PID: 1424 Comm: vfio-test Tainted: G        W        =
  6.10.0-rc1-niks-00007-gb19d6d864df1 #4 d09afec01ce27ca8218580af28295f25e2=
d2ed53
[  555.396880] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M.=
/X570 Creator, BIOS P3.40 01/28/2021
[  555.396881] RIP: 0010:remap_pfn_range_notrack+0x625/0x650
[  555.396884] Code: a8 00 00 00 75 39 44 89 e0 48 81 c4 b0 00 00 00 5b 41 =
5c 41 5d 41 5e 41 5f 5d e9 26 a7 e5 00 cc 0f 0b 41 bc ea ff ff ff eb c9 <0f=
> 0b 49 8b 47 10 e9 72 fa ff ff e8 8b 56 b5 ff e9 c0 fa ff ff e8
[  555.396887] RSP: 0000:ffffaf8b04ed3bc0 EFLAGS: 00010246
[  555.396889] RAX: ffff9ea747cfe300 RBX: 00000000000ee200 RCX: 00000000000=
00100
[  555.396890] RDX: 00000000000ee200 RSI: ffff9ea747cfe300 RDI: ffff9ea76db=
58fd0
[  555.396892] RBP: 00000000ffffffea R08: 8000000000000035 R09: 00000000000=
00000
[  555.396894] R10: ffff9ea76d9bbf40 R11: ffffffff96e5ce50 R12: 00000000000=
04000
[  555.396895] R13: 00007f23b988a000 R14: ffff9ea76db58fd0 R15: ffff9ea76db=
58fd0
[  555.396897] FS:  00007f23b9561740(0000) GS:ffff9eb66e780000(0000) knlGS:=
0000000000000000
[  555.396899] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  555.396901] CR2: 00007f23b988a008 CR3: 0000000136bde000 CR4: 00000000003=
50ef0
[  555.396903] Call Trace:
[  555.396904]  <TASK>
[  555.396905]  ? __warn+0x18c/0x2a0
[  555.396908]  ? remap_pfn_range_notrack+0x625/0x650
[  555.396911]  ? report_bug+0x1bb/0x270
[  555.396915]  ? handle_bug+0x42/0x70
[  555.396917]  ? exc_invalid_op+0x1a/0x50
[  555.396920]  ? asm_exc_invalid_op+0x1a/0x20
[  555.396923]  ? __pfx_is_ISA_range+0x10/0x10
[  555.396926]  ? remap_pfn_range_notrack+0x625/0x650
[  555.396929]  ? asm_exc_invalid_op+0x1a/0x20
[  555.396933]  ? track_pfn_remap+0x170/0x180
[  555.396936]  remap_pfn_range+0x6f/0xc0
[  555.396940]  vfio_pci_mmap_fault+0xf3/0x1b0 [vfio_pci_core 6df3b7ac5dcec=
b63cb090734847a65c799a8fef2]
[  555.396946]  __do_fault+0x11b/0x210
[  555.396949]  do_pte_missing+0x239/0x1350
[  555.396953]  handle_mm_fault+0xb10/0x18b0
[  555.396959]  do_user_addr_fault+0x293/0x710
[  555.396963]  exc_page_fault+0x82/0x1c0
[  555.396966]  asm_exc_page_fault+0x26/0x30
[  555.396968] RIP: 0033:0x55b0ea8bb7ac
[  555.396972] Code: 00 00 b0 00 e8 e5 f8 ff ff 31 c0 48 83 c4 20 5d c3 66 =
66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 48 89 7d f8 48 8b 45 f8 <8b=
> 00 89 c0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48
[  555.396974] RSP: 002b:00007fff80973530 EFLAGS: 00010202
[  555.396976] RAX: 00007f23b988a008 RBX: 00007fff80973738 RCX: 00007f23b98=
8a000
[  555.396978] RDX: 0000000000000001 RSI: 00007fff809735e8 RDI: 00007f23b98=
8a008
[  555.396979] RBP: 00007fff80973530 R08: 0000000000000005 R09: 00000000000=
00000
[  555.396981] R10: 0000000000000001 R11: 0000000000000246 R12: 00000000000=
00002
[  555.396982] R13: 0000000000000000 R14: 00007f23b98c8000 R15: 000055b0ea8=
bddc0
[  555.396986]  </TASK>
[  555.396987] ---[ end trace 0000000000000000 ]---


