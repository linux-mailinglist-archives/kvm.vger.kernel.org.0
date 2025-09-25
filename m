Return-Path: <kvm+bounces-58778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DBBB8BA0035
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 16:31:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86CAC168FF4
	for <lists+kvm@lfdr.de>; Thu, 25 Sep 2025 14:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8FB92D027F;
	Thu, 25 Sep 2025 14:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UMdN1DI6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145CF2C0F8C;
	Thu, 25 Sep 2025 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758810499; cv=none; b=fmoLTIgnhFrhpiqk6JfVUej8dwX5i4WCBht3vE5rCVJkkwGe7KEilIpz9lztXB5cAz3YCwupgCrCGZpNtrhes0jz7Da9jN/I2aSAePiWo3ymL9IbV67tjZSqdcXcnrjVluWdCZ8iREfn1Q3yhozYLwcFy6xryxhEYGEMd4SjXOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758810499; c=relaxed/simple;
	bh=vW7j2KWCOfJfuZMh3iWYpO1pCvtswVmOTtWQRB2BEdQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=poXzHd0wlsczIWQhy7UrXgF6eHJwd+Wi5EleHacMPBx8yMqYf9wbqrsjPpGErUmLFkPmq2STbc68syi3xsUt0Mz5BCbn08gOVyFgllOqAbB5aAAADrx5sKFHjW1g38Ssq1RYeA2ULvYMahNGj0jbVWMN20EZXJvQgq0YE3aVYZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UMdN1DI6; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58P7cfm3027646;
	Thu, 25 Sep 2025 14:28:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=3HyxuZ
	+gavaQ6q/gkoxk1mSPJPimkLJjL2E2gKKwKkM=; b=UMdN1DI6DdXqCKT94/MFSJ
	EE8ypqYGbr4neS+suRFI3w9QTyrZoufCp2Z5cjUUXtD/7isFvO4MqZ+C+S2WiKcP
	CpgXIq526/GwrnoD9sGkY+05wzT3eCvvU6rVeF72/fESOmGC2EkNL93lB9fHS1ms
	5Gjh1tMO4yhdRTxY/idZb7LK2D/rKE7Rc1WxotI9Xfa0kATXa1/d9Z6MJqWgDHQv
	Dl+ty2xdB09MNJvwMrwmIr2utacRrfNMoD3UBJLran03fXjYdo7sX3IuNFqd/Mxx
	cRRIyxPP9q1PP2luT3xYw80JCSdPAsQamfhXivJUUE7lKg+oIHAFx0biXARRUPNQ
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499ky6ec81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 14:28:09 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58PD9AjY008311;
	Thu, 25 Sep 2025 14:28:08 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49a6yy6gbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Sep 2025 14:28:08 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58PES67T41550500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Sep 2025 14:28:07 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D95485805E;
	Thu, 25 Sep 2025 14:28:06 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 497E658056;
	Thu, 25 Sep 2025 14:28:05 +0000 (GMT)
Received: from [9.111.71.247] (unknown [9.111.71.247])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 25 Sep 2025 14:28:05 +0000 (GMT)
Message-ID: <d22cb26b864362454ace07ed5fcb9758c40ee32e.camel@linux.ibm.com>
Subject: Re: [PATCH v4 07/10] s390/pci: Store PCI error information for
 passthrough devices
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, clg@redhat.com,
        mjrosato@linux.ibm.com
Date: Thu, 25 Sep 2025 16:28:04 +0200
In-Reply-To: <20250924171628.826-8-alifm@linux.ibm.com>
References: <20250924171628.826-1-alifm@linux.ibm.com>
	 <20250924171628.826-8-alifm@linux.ibm.com>
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
 CYJAFAmesutgFCQenEYkACgkQr+Q/FejCYJDIzA//W5h3t+anRaztihE8ID1c6ifS7lNUtXr0wEKx
 Qm6EpDQKqFNP+n3R4A5w4gFqKv2JpYQ6UJAAlaXIRTeT/9XdqxQlHlA20QWI7yrJmoYaF74ZI9s/C
 8aAxEzQZ64NjHrmrZ/N9q8JCTlyhk5ZEV1Py12I2UH7moLFgBFZsPlPWAjK2NO/ns5UJREAJ04pR9
 XQFSBm55gsqkPp028cdoFUD+IajGtW7jMIsx/AZfYMZAd30LfmSIpaPAi9EzgxWz5habO1ZM2++9e
 W6tSJ7KHO0ZkWkwLKicrqpPvA928eNPxYtjkLB2XipdVltw5ydH9SLq0Oftsc4+wDR8TqhmaUi8qD
 Fa2I/0NGwIF8hjwSZXtgJQqOTdQA5/6voIPheQIi0NBfUr0MwboUIVZp7Nm3w0QF9SSyTISrYJH6X
 qLp17NwnGQ9KJSlDYCMCBJ+JGVmlcMqzosnLli6JszAcRmZ1+sd/f/k47Fxy1i6o14z9Aexhq/UgI
 5InZ4NUYhf5pWflV41KNupkS281NhBEpChoukw25iZk0AsrukpJ74x69MJQQO+/7PpMXFkt0Pexds
 XQrtsXYxLDQk8mgjlgsvWl0xlk7k7rddN1+O/alcv0yBOdvlruirtnxDhbjBqYNl8PCbfVwJZnyQ4
 SAX2S9XiGeNtWfZ5s2qGReyAcd2nBna0KU5pa2xhcyBTY2huZWxsZSA8bmlrbGFzLnNjaG5lbGxlQ
 GlibS5jb20+iQJUBBMBCAA+AhsBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEEnbAAstJ1IDCl9y
 3cr+Q/FejCYJAFAmesuuEFCQenEYkACgkQr+Q/FejCYJCosA/9GCtbN8lLQkW71n/CHR58BAA5ct1
 KRYiZNPnNNAiAzjvSb0ezuRVt9H0bk/tnj6pPj0zdyU2bUj9Ok3lgocWhsF2WieWbG4dox5/L1K28
 qRf3p+vdPfu7fKkA1yLE5GXffYG3OJnqR7OZmxTnoutj81u/tXO95JBuCSJn5oc5xMQvUUFzLQSbh
 prIWxcnzQa8AHJ+7nAbSiIft/+64EyEhFqncksmzI5jiJ5edABiriV7bcNkK2d8KviUPWKQzVlQ3p
 LjRJcJJHUAFzsZlrsgsXyZLztAM7HpIA44yo+AVVmcOlmgPMUy+A9n+0GTAf9W3y36JYjTS+ZcfHU
 KP+y1TRGRzPrFgDKWXtsl1N7sR4tRXrEuNhbsCJJMvcFgHsfni/f4pilabXO1c5Pf8fiXndCz04V8
 ngKuz0aG4EdLQGwZ2MFnZdyf3QbG3vjvx7XDlrdzH0wUgExhd2fHQ2EegnNS4gNHjq82uLPU0hfcr
 obuI1D74nV0BPDtr7PKd2ryb3JgjUHKRKwok6IvlF2ZHMMXDxYoEvWlDpM1Y7g81NcKoY0BQ3ClXi
 a7vCaqAAuyD0zeFVGcWkfvxYKGqpj8qaI/mA8G5iRMTWUUUROy7rKJp/y2ioINrCul4NUJUujfx4k
 7wFU11/YNAzRhQG4MwoO5e+VY66XnAd+XPyBIlvy0K05pa2xhcyBTY2huZWxsZSA8bmlrbGFzLnNj
 aG5lbGxlQGdtYWlsLmNvbT6JAlQEEwEIAD4CGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQSds
 ACy0nUgMKX3Ldyv5D8V6MJgkAUCZ6y64QUJB6cRiQAKCRCv5D8V6MJgkEr/D/9iaYSYYwlmTJELv+
 +EjsIxXtneKYpjXEgNnPwpKEXNIpuU/9dcVDcJ10MfvWBPi3sFbIzO9ETIRyZSgrjQxCGSIhlbom4
 D8jVzTA698tl9id0FJKAi6T0AnBF7CxyqofPUzAEMSj9ynEJI/Qu8pHWkVp97FdJcbsho6HNMthBl
 +Qgj9l7/Gm1UW3ZPvGYgU75uB/mkaYtEv0vYrSZ+7fC2Sr/O5SM2SrNk+uInnkMBahVzCHcoAI+6O
 Enbag+hHIeFbqVuUJquziiB/J4Z2yT/3Ps/xrWAvDvDgdAEr7Kn697LLMRWBhGbdsxdHZ4ReAhc8M
 8DOcSWX7UwjzUYq7pFFil1KPhIkHctpHj2Wvdnt+u1F9fN4e3C6lckUGfTVd7faZ2uDoCCkJAgpWR
 10V1Q1Cgl09VVaoi6LcGFPnLZfmPrGYiDhM4gyDDQJvTmkB+eMEH8u8V1X30nCFP2dVvOpevmV5Uk
 onTsTwIuiAkoTNW4+lRCFfJskuTOQqz1F8xVae8KaLrUt2524anQ9x0fauJkl3XdsVcNt2wYTAQ/V
 nKUNgSuQozzfXLf+cOEbV+FBso/1qtXNdmAuHe76ptwjEfBhfg8L+9gMUthoCR94V0y2+GEzR5nlD
 5kfu8ivV/gZvij+Xq3KijIxnOF6pd0QzliKadaFNgGw4FoUeZo0rQhTmlrbGFzIFNjaG5lbGxlIDx
 uaWtzQGtlcm5lbC5vcmc+iQJUBBMBCAA+AhsBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEEnbAA
 stJ1IDCl9y3cr+Q/FejCYJAFAmesuuEFCQenEYkACgkQr+Q/FejCYJC6yxAAiQQ5NAbWYKpkxxjP/
 AajXheMUW8EtK7EMJEKxyemj40laEs0wz9owu8ZDfQl4SPqjjtcRzUW6vE6JvfEiyCLd8gUFXIDMS
 l2hzuNot3sEMlER9kyVIvemtV9r8Sw1NHvvCjxOMReBmrtg9ooeboFL6rUqbXHW+yb4GK+1z7dy+Q
 9DMlkOmwHFDzqvsP7eGJN0xD8MGJmf0L5LkR9LBc+jR78L+2ZpKA6P4jL53rL8zO2mtNQkoUO+4J6
 0YTknHtZrqX3SitKEmXE2Is0Efz8JaDRW41M43cE9b+VJnNXYCKFzjiqt/rnqrhLIYuoWCNzSJ49W
 vt4hxfqh/v2OUcQCIzuzcvHvASmt049ZyGmLvEz/+7vF/Y2080nOuzE2lcxXF1Qr0gAuI+wGoN4gG
 lSQz9pBrxISX9jQyt3ztXHmH7EHr1B5oPus3l/zkc2Ajf5bQ0SE7XMlo7Pl0Xa1mi6BX6I98CuvPK
 SA1sQPmo+1dQYCWmdQ+OIovHP9Nx8NP1RB2eELP5MoEW9eBXoiVQTsS6g6OD3rH7xIRxRmuu42Z5e
 0EtzF51BjzRPWrKSq/mXIbl5nVW/wD+nJ7U7elW9BoJQVky03G0DhEF6fMJs08DGG3XoKw/CpGtMe
 2V1z/FRotP5Fkf5VD3IQGtkxSnO/awtxjlhytigylgrZ4wDpSE=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gEqyHAxMd8WOw0AvtrnpLCnMhoue5R1M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAyMCBTYWx0ZWRfX3b9scm/F1/Kq
 GcbabaQ6tIbylgkDQiWSP3zGw2is0JwvJMDBBjvuHTPKzZqy7RfL7Z2ETjRc30wWxbmaY4WxXWQ
 k83hReqbKY6hxpnI0TK+6GwBENtGteaEjDVxdvLiOBRMkdvGc3MOtS6TVcBTEAxarHOA82Zx1+W
 mreOQhfO/K4d0DjEBYGDv9uXxqXqGQvywxNa6q7rKfW3NrB9MQKfR/kDIpYhVw+afELQcNnete3
 3CEx8bOfx2jODDpG6gDW3NCZejN3VNNkcLtPaU0PnwSk05k2QfHnVwuRepY4XSHDtnXe80SoNRC
 8ovrep0Uut0gXO5REGRxnchhiRtDqyGiNfgm4mXdqqx8ZouI7cxpwAM1GMVsJPlJyCOFQtt21Qj
 aSteWWbE
X-Authority-Analysis: v=2.4 cv=XYGJzJ55 c=1 sm=1 tr=0 ts=68d55179 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=NDtGctlWJZRkknF2ZLwA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: gEqyHAxMd8WOw0AvtrnpLCnMhoue5R1M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-25_01,2025-09-25_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 clxscore=1015 adultscore=0 malwarescore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509200020

On Wed, 2025-09-24 at 10:16 -0700, Farhan Ali wrote:
> For a passthrough device we need co-operation from user space to recover
> the device. This would require to bubble up any error information to user
> space.  Let's store this error information for passthrough devices, so it
> can be retrieved later.
>=20
> Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
> ---
>  arch/s390/include/asm/pci.h      | 28 ++++++++++
>  arch/s390/pci/pci.c              |  1 +
>  arch/s390/pci/pci_event.c        | 95 +++++++++++++++++++-------------
>  drivers/vfio/pci/vfio_pci_zdev.c |  2 +
>  4 files changed, 88 insertions(+), 38 deletions(-)
>=20
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index f47f62fc3bfd..40bfe5721109 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -116,6 +116,31 @@ struct zpci_bus {
>  	enum pci_bus_speed	max_bus_speed;
>  };
> =20
> +/* Content Code Description for PCI Function Error */
> +struct zpci_ccdf_err {
> +	u32 reserved1;
> +	u32 fh;                         /* function handle */
> +	u32 fid;                        /* function id */
> +	u32 ett         :  4;           /* expected table type */
> +	u32 mvn         : 12;           /* MSI vector number */
> +	u32 dmaas       :  8;           /* DMA address space */
> +	u32 reserved2   :  6;
> +	u32 q           :  1;           /* event qualifier */
> +	u32 rw          :  1;           /* read/write */
> +	u64 faddr;                      /* failing address */
> +	u32 reserved3;
> +	u16 reserved4;
> +	u16 pec;                        /* PCI event code */
> +} __packed;
> +
> +#define ZPCI_ERR_PENDING_MAX 4
> +struct zpci_ccdf_pending {
> +	u8 count;
> +	u8 head;
> +	u8 tail;
> +	struct zpci_ccdf_err err[ZPCI_ERR_PENDING_MAX];
> +};

Thanks this looks more reasonably sized.=20

> +
>  /* Private data per function */
>  struct zpci_dev {
>  	struct zpci_bus *zbus;
> @@ -191,6 +216,8 @@ struct zpci_dev {
>  	struct iommu_domain *s390_domain; /* attached IOMMU domain */
>  	struct kvm_zdev *kzdev;
>  	struct mutex kzdev_lock;
> +	struct zpci_ccdf_pending pending_errs;
> +	struct mutex pending_errs_lock;
>  	spinlock_t dom_lock;		/* protect s390_domain change */
>  };
> =20
--- snip ---
> +static void zpci_store_pci_error(struct pci_dev *pdev,
> +				 struct zpci_ccdf_err *ccdf)
> +{
> +	struct zpci_dev *zdev =3D to_zpci(pdev);
> +	int i;
> +
> +	mutex_lock(&zdev->pending_errs_lock);
> +	if (zdev->pending_errs.count >=3D ZPCI_ERR_PENDING_MAX) {
> +		pr_err("%s: Maximum number (%d) of pending error events queued",
> +				pci_name(pdev), ZPCI_ERR_PENDING_MAX);

So for a vfio-pci user which doesn't pick up the error information but
does reset on error and thus recovers we would leave just the 4 first
errors that occurred in the pending_errs and get this message once. I
think that is okay and maybe even preferrable since most errors are,
well, errors. And often the first time something went wrong is the
interesting one. So I think this makes sense.

> +		mutex_unlock(&zdev->pending_errs_lock);
> +		return;
> +	}
> +
> +	i =3D zdev->pending_errs.tail % ZPCI_ERR_PENDING_MAX;
> +	memcpy(&zdev->pending_errs.err[i], ccdf, sizeof(struct zpci_ccdf_err));
> +	zdev->pending_errs.tail++;
> +	zdev->pending_errs.count++;
> +	mutex_unlock(&zdev->pending_errs_lock);
> +}
> +
> +void zpci_cleanup_pending_errors(struct zpci_dev *zdev)
> +{
> +	struct pci_dev *pdev =3D NULL;
> +
> +	mutex_lock(&zdev->pending_errs_lock);
> +	pdev =3D pci_get_slot(zdev->zbus->bus, zdev->devfn);

I think you missed my comment on the previous version. This is missing
the matching pci_dev_put() for the pci_get_slot().

> +	if (zdev->pending_errs.count)
> +		pr_info("%s: Unhandled PCI error events count=3D%d",
> +				pci_name(pdev), zdev->pending_errs.count);
> +	memset(&zdev->pending_errs, 0, sizeof(struct zpci_ccdf_pending));
> +	mutex_unlock(&zdev->pending_errs_lock);
> +}
> +EXPORT_SYMBOL_GPL(zpci_cleanup_pending_errors);
> +
>=20
--- snip ---
> =20
> @@ -322,12 +340,13 @@ static void __zpci_event_error(struct zpci_ccdf_err=
 *ccdf)
>  		break;
>  	case 0x0040: /* Service Action or Error Recovery Failed */
>  	case 0x003b:
> -		zpci_event_io_failure(pdev, pci_channel_io_perm_failure);
> +		zpci_event_io_failure(pdev, pci_channel_io_perm_failure, ccdf);
>  		break;
>  	default: /* PCI function left in the error state attempt to recover */
> -		ers_res =3D zpci_event_attempt_error_recovery(pdev);
> +		ers_res =3D zpci_event_attempt_error_recovery(pdev, ccdf);
>  		if (ers_res !=3D PCI_ERS_RESULT_RECOVERED)
> -			zpci_event_io_failure(pdev, pci_channel_io_perm_failure);
> +			zpci_event_io_failure(pdev, pci_channel_io_perm_failure,
> +					ccdf);

Nit: I'd just keep the above on one line. It's still below the 100
columns limit and just cleaner on one line.

>  		break;
>  	}
>  	pci_dev_put(pdev);
> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci=
_zdev.c
> index a7bc23ce8483..2be37eab9279 100644
> --- a/drivers/vfio/pci/vfio_pci_zdev.c
> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
> @@ -168,6 +168,8 @@ void vfio_pci_zdev_close_device(struct vfio_pci_core_=
device *vdev)
> =20
>  	zdev->mediated_recovery =3D false;
> =20
> +	zpci_cleanup_pending_errors(zdev);
> +
>  	if (!vdev->vdev.kvm)
>  		return;
> =20

