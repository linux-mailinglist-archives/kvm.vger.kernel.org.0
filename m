Return-Path: <kvm+bounces-57547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DB6BB578C4
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 13:44:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3D3A1883FEF
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 11:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0037D2FF661;
	Mon, 15 Sep 2025 11:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="g+UjgV0e"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A5A1E87B;
	Mon, 15 Sep 2025 11:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757936590; cv=none; b=e5sj7/99XtOtvWsFqm1FX+WnxccVJAqD0qAIyJFitOemkEnJQ+4eL4km4ArrOXnxl+c0keqIYbfH2WphuA0nn4UG0gXbNbCmLgaoATT8UgbHWpEJ+/ImWWTD+CCvJgt7PRO7Fwod+XBUzz8CifcdMp/vyohdeqMUIdJaTluqkaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757936590; c=relaxed/simple;
	bh=HEzdyDFXkbP9JUN6fUEa6cGxJMAAw0uCEMc4jm99RxI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JuVBCbDwDcUaubDrYqvlvniIlURo61hMaL0Z2/N0jHiy6GyjYFDPBn4MjUcewj8UDvyiptuFjKuKTobXVp5y9T565LVjBaNgQu7Z0UIyNmJABOgrtpUq+WD3806dz1Fo4Xjr7mLnpcrUZBeZ/4vUAhByxpzXlAA8sD2FPHbaQDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=g+UjgV0e; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F9bPK1019175;
	Mon, 15 Sep 2025 11:43:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=jX11MQ
	xPNBISFxcol0oL9sWGm4w42kLCHqWzUkck0bk=; b=g+UjgV0eJ1naDZ5r6fWueF
	tgHJEDEnRG9yDb0k2TbGmwB1xseRku08LZwnhkRfCWnhG3i3U/Ovd4koIvg88Dd+
	15Z70iThnfsXhCqA2/7VrdMhaH7fKHLw/Ozj6MXZolw4N3flLMe0LvIhe0D8K+I/
	OsK2BS5XvSz9i9cUbJYsB4BKSmq657iKCMm2NCwZM7VykSWk2QV1XQxPhsGixmb6
	KfnPnZB84K5aJ/uVoqEtAfv772TiZVhzrjpLfgHbZ29hgOfLZlaD4Ih/pHSEXAmF
	8o9RoMRY0JMJWAVxITdgFUhQj2jRcYiObtWK12xTeDHQcVI5AB6WPCstg/CCSOQA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496gat0kaj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 11:43:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAoCl1029498;
	Mon, 15 Sep 2025 11:43:02 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495kb0pcfw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 11:43:02 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58FBh1qb28771024
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 11:43:01 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A294E58063;
	Mon, 15 Sep 2025 11:43:01 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5A5E58055;
	Mon, 15 Sep 2025 11:42:59 +0000 (GMT)
Received: from [9.87.138.96] (unknown [9.87.138.96])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Sep 2025 11:42:59 +0000 (GMT)
Message-ID: <197d61dcb036c1038180acf26042b82d4320b9f2.camel@linux.ibm.com>
Subject: Re: [PATCH v3 07/10] s390/pci: Store PCI error information for
 passthrough devices
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Farhan Ali <alifm@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Cc: alex.williamson@redhat.com, helgaas@kernel.org, mjrosato@linux.ibm.com
Date: Mon, 15 Sep 2025 13:42:59 +0200
In-Reply-To: <20250911183307.1910-8-alifm@linux.ibm.com>
References: <20250911183307.1910-1-alifm@linux.ibm.com>
	 <20250911183307.1910-8-alifm@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=BKWzrEQG c=1 sm=1 tr=0 ts=68c7fbc8 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=h0cegru4K6vSp0ebvysA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: DPeKLJYxrHxHXuIUTv0bnKSwWRyckEkT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDA4NiBTYWx0ZWRfX1zglfpap2fVX
 fN1LYZJSkJ98xqHHCNo4+etWT4juC2U3TQUUIOyL9wtWc+81ZqYlWxSsfX/h0c8mXLilz1Pc7v+
 gn43hh7XsZO9srtkLRdtLP2lhmLR6Q7cCl1Y4jP0sqXAuSbKvUzJOP9wGf2FIJaYeCIm4oYnI6a
 fOHwZw7qPuyXMFCg55g1T/8iLYyyi89saImoU1TaSHP6DJ7mbold+iMMvyC+nlyKORIx0/MAQs8
 XxhDCp2I4HS2+PxB6uoa+ucmtUm+HCw8ScENdIxnU+XD+45h/FSPqlD0jAvsjJrE1HgCOnJNBSn
 P+ugV0go8kXN4ojqsOPz4V6LIpt0PA66+GUmLQwZZEcLj9dd0jVzdj+LiEOkylXd+SKFUy1KpcD
 n9hKewBm
X-Proofpoint-ORIG-GUID: DPeKLJYxrHxHXuIUTv0bnKSwWRyckEkT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150086

On Thu, 2025-09-11 at 11:33 -0700, Farhan Ali wrote:
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
> index f47f62fc3bfd..72e05af90e08 100644
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
> +#define ZPCI_ERR_PENDING_MAX 16

16 pending error events sounds like a lot for a single devices. This
also means that the array alone already spans more than 2 cache lines
(256 byte on s390x). I can't imagine that we'd ever have that many
errors pending. This is especially true since a device already in an
error state would be the least likely to cause more errors. We have
seen cases of 2 errors in the past, so maybe 4 would give us good head
room?

> +struct zpci_ccdf_pending {
> +	size_t count;
> +	int head;
> +	int tail;
> +	struct zpci_ccdf_err err[ZPCI_ERR_PENDING_MAX];
> +};
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
>=20
--- snip ---

> -
>  /* Content Code Description for PCI Function Availability */
>  struct zpci_ccdf_avail {
>  	u32 reserved1;
> @@ -76,6 +59,41 @@ static bool is_driver_supported(struct pci_driver *dri=
ver)
>  	return true;
>  }
> =20
> +static void zpci_store_pci_error(struct pci_dev *pdev,
> +				 struct zpci_ccdf_err *ccdf)
> +{
> +	struct zpci_dev *zdev =3D to_zpci(pdev);
> +	int i;
> +
> +	mutex_lock(&zdev->pending_errs_lock);
> +	if (zdev->pending_errs.count >=3D ZPCI_ERR_PENDING_MAX) {
> +		pr_err("%s: Cannot store PCI error info for device",
> +				pci_name(pdev));
> +		mutex_unlock(&zdev->pending_errs_lock);

I think the error message should state that the maximum number of
pending error events has been queued. As with the ZPI_ERR_PENDING_MAX I
really don't think we would reach this even at 4 vs 16 max pending but
if we do I agree that having the first couple of errors saved is
probably nice for analysis.

> +		return;
> +	}
> +
> +	i =3D zdev->pending_errs.tail % ZPCI_ERR_PENDING_MAX;
> +	memcpy(&zdev->pending_errs.err[i], ccdf, sizeof(struct zpci_ccdf_err));
> +	zdev->pending_errs.tail++;
> +	zdev->pending_errs.count++;

With tail being int this would be undefined behavior if it ever
overflowed. Since the array is of fixed length that is always smaller
than 256 how about making tail, head, and count u8. The memory saving
doesn't matter but at least overflow becomes well defined.

> +	mutex_unlock(&zdev->pending_errs_lock);
> +}
> +
> +void zpci_cleanup_pending_errors(struct zpci_dev *zdev)
> +{
> +	struct pci_dev *pdev =3D NULL;
> +
> +	mutex_lock(&zdev->pending_errs_lock);
> +	pdev =3D pci_get_slot(zdev->zbus->bus, zdev->devfn);
> +	if (zdev->pending_errs.count)
> +		pr_err("%s: Unhandled PCI error events count=3D%zu",
> +				pci_name(pdev), zdev->pending_errs.count);

I think this could be a zpci_dbg(). That way you also don't need the
pci_get_slot() which is also buggy as it misses a pci_dev_put(). The
message also doesn't seem useful for the user. As I understand it this
would happen if a vfio-pci user dies without handling all the error
events but then vfio-pci will also reset the slot on closing of the
fds, no? So the device will get reset anyway.

> +	memset(&zdev->pending_errs, 0, sizeof(struct zpci_ccdf_pending));

If this goes wrong and we subsequently crash or take a live memory dump
I'd prefer to have bread crumbs such as the errors that weren't cleaned
up. Wouldn't it be enough to just set the count to zero and for debug
the original count will be in s390dbf. Also maybe it would make sense
to pull the zdev->mediated_recovery clearing in here?

> +	mutex_unlock(&zdev->pending_errs_lock);
> +}
> +EXPORT_SYMBOL_GPL(zpci_cleanup_pending_errors);
> +
>  static pci_ers_result_t zpci_event_notify_error_detected(struct pci_dev =
*pdev,
>  							 struct pci_driver *driver)
>  {
> @@ -169,7 +187,8 @@ static pci_ers_result_t zpci_event_do_reset(struct pc=
i_dev *pdev,
>   * and the platform determines which functions are affected for
>   * multi-function devices.
>   */
> -static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev=
 *pdev)
> +static pci_ers_result_t zpci_event_attempt_error_recovery(struct pci_dev=
 *pdev,
> +							  struct zpci_ccdf_err *ccdf)
>  {
>  	pci_ers_result_t ers_res =3D PCI_ERS_RESULT_DISCONNECT;
>  	struct zpci_dev *zdev =3D to_zpci(pdev);
> @@ -188,13 +207,6 @@ static pci_ers_result_t zpci_event_attempt_error_rec=
overy(struct pci_dev *pdev)
>  	}
>  	pdev->error_state =3D pci_channel_io_frozen;
> =20
> -	if (needs_mediated_recovery(pdev)) {
> -		pr_info("%s: Cannot be recovered in the host because it is a pass-thro=
ugh device\n",
> -			pci_name(pdev));
> -		status_str =3D "failed (pass-through)";
> -		goto out_unlock;
> -	}
> -
>  	driver =3D to_pci_driver(pdev->dev.driver);
>  	if (!is_driver_supported(driver)) {
>  		if (!driver) {
> @@ -210,12 +222,22 @@ static pci_ers_result_t zpci_event_attempt_error_re=
covery(struct pci_dev *pdev)
>  		goto out_unlock;
>  	}
> =20
> +	if (needs_mediated_recovery(pdev))
> +		zpci_store_pci_error(pdev, ccdf);
> +
>  	ers_res =3D zpci_event_notify_error_detected(pdev, driver);
>  	if (ers_result_indicates_abort(ers_res)) {
>  		status_str =3D "failed (abort on detection)";
>  		goto out_unlock;
>  	}
> =20
> +	if (needs_mediated_recovery(pdev)) {
> +		pr_info("%s: Recovering passthrough device\n", pci_name(pdev));

I'd say technically we're not recovering the device here but rather
leaving it alone so user-space can take over the recovery. Maybe this
could be made explicit in the message. Something like:

""%s: Leaving recovery of pass-through device to user-space\n"

> +		ers_res =3D PCI_ERS_RESULT_RECOVERED;
> +		status_str =3D "in progress";
> +		goto out_unlock;
> +	}
> +
>  	if (ers_res !=3D PCI_ERS_RESULT_NEED_RESET) {
>  		ers_res =3D zpci_event_do_error_state_clear(pdev, driver);
>  		if (ers_result_indicates_abort(ers_res)) {
> @@ -258,25 +280,20 @@ static pci_ers_result_t zpci_event_attempt_error_re=
covery(struct pci_dev *pdev)
>   * @pdev: PCI function for which to report
>   * @es: PCI channel failure state to report
>   */
> -static void zpci_event_io_failure(struct pci_dev *pdev, pci_channel_stat=
e_t es)
> +static void zpci_event_io_failure(struct pci_dev *pdev, pci_channel_stat=
e_t es,
> +				  struct zpci_ccdf_err *ccdf)
>  {
>  	struct pci_driver *driver;
> =20
>  	pci_dev_lock(pdev);
>  	pdev->error_state =3D es;
> -	/**
> -	 * While vfio-pci's error_detected callback notifies user-space QEMU
> -	 * reacts to this by freezing the guest. In an s390 environment PCI
> -	 * errors are rarely fatal so this is overkill. Instead in the future
> -	 * we will inject the error event and let the guest recover the device
> -	 * itself.
> -	 */
> +
>  	if (needs_mediated_recovery(pdev))
> -		goto out;
> +		zpci_store_pci_error(pdev, ccdf);
>  	driver =3D to_pci_driver(pdev->dev.driver);
>  	if (driver && driver->err_handler && driver->err_handler->error_detecte=
d)
>  		driver->err_handler->error_detected(pdev, pdev->error_state);
> -out:
> +
>  	pci_dev_unlock(pdev);
>  }
> =20
> @@ -312,6 +329,7 @@ static void __zpci_event_error(struct zpci_ccdf_err *=
ccdf)
>  	pr_err("%s: Event 0x%x reports an error for PCI function 0x%x\n",
>  	       pdev ? pci_name(pdev) : "n/a", ccdf->pec, ccdf->fid);
> =20
> +
>  	if (!pdev)

Nit, stray empty line.

>  		goto no_pdev;
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

