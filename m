Return-Path: <kvm+bounces-62593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 28BA6C4967C
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 22:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D7A024E317A
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 21:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A29C732C954;
	Mon, 10 Nov 2025 21:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ku4UXJoS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48ED132AADA;
	Mon, 10 Nov 2025 21:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762810221; cv=none; b=TDCuOt52XSUaFCSBlS8X+JrW5W2Wad/KwQyeG/69A7BC+OT8jGXyV9QpBrBu9aqKaWmVHcbLG2O+qxl8qFI0ZbWskkIujVo1QfTheXOfdv6OZNojZd17s/TnjzpSlT/1r7ZXIEtJV0Siai5Fbc4lfUs+g8HXOfgb7DU+0oclmVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762810221; c=relaxed/simple;
	bh=bD9RVt9bJpG8ZW3LPzIAShrzFYwf1MdbxQfV+z1LfRQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VqRZuFn9YENKhO5IyXQ9bu/hceyG2sWhmP3wmpR7BT/bQNmyZnIv4no2GMLpOGZpwdjVT/EmMhjpRKNjA/4cMFAls29MaYZ5va45kcmkzoSc7aveqzex0h7xOWjI97XSVDpuNN7XlS4DJs6wdMkgpAFBJEpF1r8v2mVk3UV05RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ku4UXJoS; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAE2R1p031322;
	Mon, 10 Nov 2025 21:30:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=jKPUsN
	AYTJ5KW3G5U+DKxA5L1nLOkv/1sA+J3QgZgvc=; b=ku4UXJoSr8Uuw6RQk4mACG
	/iusOa+Tv1xCc2fEW8kP0y7Qc+7OXfbdoHGWuw7HxWyUvSOrqrMtnGzfvzaAo7nm
	Qq8bneMOC761gPfoFtTbhy1vhN2pirEcoNDpcmxk+mffqpReDhYD9ySZ7e9mhlxJ
	/Q9WHUR4c5YQkS1CfKVQutMAqh38dCqe5XJ2cU04FFa+FbvgrBy9HLP59YJ74QkL
	41ErkulmwN1U3FCseXgoAnYWq0swzuR1vHgm3Ll4kORtgYIYiWDvevBlVnLj3N32
	RmIFGrnV7LxpLWvIuGuPh+e5MclzfJfn9mlNvxbbjTGc5V/KnbScK480CbDzQlBw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a9wk827uy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 21:30:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAKF6Wp014762;
	Mon, 10 Nov 2025 21:30:13 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4aahpjyp8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 10 Nov 2025 21:30:13 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AALUC2s39190838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 21:30:12 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1635F58064;
	Mon, 10 Nov 2025 21:30:12 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CA215805A;
	Mon, 10 Nov 2025 21:30:11 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.62.231])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 10 Nov 2025 21:30:11 +0000 (GMT)
Message-ID: <33338cb8c04dfed521542c9145ca282f9dc9d763.camel@linux.ibm.com>
Subject: Re: [PATCH RFC v2 03/11] KVM: s390: Move scao validation into a
 function
From: Eric Farman <farman@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Vasily
 Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger	 <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico
 Boehr <nrb@linux.ibm.com>, David Hildenbrand	 <david@redhat.com>,
        Sven
 Schnelle <svens@linux.ibm.com>,
        Paolo Bonzini	 <pbonzini@redhat.com>, Shuah
 Khan <shuah@kernel.org>
Date: Mon, 10 Nov 2025 16:30:10 -0500
In-Reply-To: <20251110-vsieie-v2-3-9e53a3618c8c@linux.ibm.com>
References: <20251110-vsieie-v2-0-9e53a3618c8c@linux.ibm.com>
	 <20251110-vsieie-v2-3-9e53a3618c8c@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDAyMiBTYWx0ZWRfX/X9UlSOCql9K
 1O2Wj1tHn9h71GNuRlGkTBtSL8+VF+TaGaB9RmyMmB5OjzXPVGxShOpF8ZItlpG6DJ3y/10CxVe
 88Ag3wneje1XN8Zm1X0RpBdW1DPgYIFrojqMR3pYmReiNtRqORc4apjtO1NKjyiFn3G2wrh2Fx7
 OG8ftbwGAkZZmcq5c4KjGXz5Vf+U4BSno7OjhUZtwfxO7bFXp3uBFMrIUrbKMpR1AGsHFMLUBj/
 MkoZGHKu5PPyoEpevYAtvAym8KsQfO0fuHBCE3OGXtXfOBGx6ToCO2I3EF+dUYQL0db1pRp2Pog
 hQJFy0pMTehIyjCUEPqeD+aHDKrg34F4MGBShfWSqSPx8tqJcljoYlbrttaeB9CTuTdBtes6oLu
 8/IR4sJTENg3OC9p+3wd869TdAVJhA==
X-Authority-Analysis: v=2.4 cv=ZK3aWH7b c=1 sm=1 tr=0 ts=69125967 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=iTz0DsNiLSe9ZGz6wnkA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: xX4e9FwL-CnAYcBCxmiTPR-HAazZN0iM
X-Proofpoint-GUID: xX4e9FwL-CnAYcBCxmiTPR-HAazZN0iM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 phishscore=0 impostorscore=0 spamscore=0 bulkscore=0 adultscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511080022

On Mon, 2025-11-10 at 18:16 +0100, Christoph Schlameuss wrote:
> This improves readability as well as allows re-use in coming patches.
>=20
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>  arch/s390/kvm/vsie.c | 27 ++++++++++++++++++++-------
>  1 file changed, 20 insertions(+), 7 deletions(-)
>=20
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index ced2ca4ce5b584403d900ed11cb064919feda8e9..3d602bbd1f70b7bd8ddc2c54d=
43027dc37a6e032 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -95,6 +95,25 @@ static int set_validity_icpt(struct kvm_s390_sie_block=
 *scb,
>  	return 1;
>  }
> =20
> +/* The sca header must not cross pages etc. */
> +static int validate_scao(struct kvm_vcpu *vcpu, struct kvm_s390_sie_bloc=
k *scb, gpa_t gpa)
> +{
> +	int offset;
> +
> +	if (gpa < 2 * PAGE_SIZE)
> +		return set_validity_icpt(scb, 0x0038U);
> +	if ((gpa & ~0x1fffUL) =3D=3D kvm_s390_get_prefix(vcpu))
> +		return set_validity_icpt(scb, 0x0011U);
> +
> +	if (sie_uses_esca(scb))

This helper doesn't turn up until patch 7

> +		offset =3D offsetof(struct esca_block, cpu[0]) - 1;
> +	else
> +		offset =3D offsetof(struct bsca_block, cpu[0]) - 1;
> +	if ((gpa & PAGE_MASK) !=3D ((gpa + offset) & PAGE_MASK))
> +		return set_validity_icpt(scb, 0x003bU);
> +	return false;
> +}
> +
>  /* mark the prefix as unmapped, this will block the VSIE */
>  static void prefix_unmapped(struct vsie_page *vsie_page)
>  {
> @@ -791,13 +810,7 @@ static int pin_blocks(struct kvm_vcpu *vcpu, struct =
vsie_page *vsie_page)
> =20
>  	gpa =3D read_scao(vcpu->kvm, scb_o);
>  	if (gpa) {
> -		if (gpa < 2 * PAGE_SIZE)
> -			rc =3D set_validity_icpt(scb_s, 0x0038U);
> -		else if ((gpa & ~0x1fffUL) =3D=3D kvm_s390_get_prefix(vcpu))
> -			rc =3D set_validity_icpt(scb_s, 0x0011U);
> -		else if ((gpa & PAGE_MASK) !=3D
> -			 ((gpa + sizeof(struct bsca_block) - 1) & PAGE_MASK))
> -			rc =3D set_validity_icpt(scb_s, 0x003bU);
> +		rc =3D validate_scao(vcpu, scb_o, gpa);
>  		if (!rc) {
>  			rc =3D pin_guest_page(vcpu->kvm, gpa, &hpa);
>  			if (rc)

