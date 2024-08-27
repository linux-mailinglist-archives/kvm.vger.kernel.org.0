Return-Path: <kvm+bounces-25154-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2571C960D32
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 16:10:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49BAA1C227CF
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 14:10:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D19091C4634;
	Tue, 27 Aug 2024 14:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f9WRBPpK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8DC1C3F0D;
	Tue, 27 Aug 2024 14:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724767733; cv=none; b=h/OJHzmYOsNqcFmldZqVzVgEBmt+VQHocwKcZU5d7sAuSA/LYe1eiVPBgbBc4j4JzSdAG/yQQsINbdW1KghSAIQJmP9LRHc1ATnVJtb/PzPf79086Y8uBIscVJa9G9dYnyVS2/QZx8HYhEkcSqkkkNCC+TzRtRpWohUdoLRr5NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724767733; c=relaxed/simple;
	bh=bP9AfGqJl14cvUwqYIane/zscbP0IkCQeGTsc85wig4=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=cyr0ENzOiY/Z6TKQIeIwOvwZSoaWzm4BEBE9J1/MuW5NQWR+G58gFdJPkydzGq/2IAFW/pEukGkNA88iMBiTyKffm/scuKFrZexOCfe+gBJVE5biCn1Mj/9VhW70Kj1dRnk59gkgZJzvpuXS414nnUu9ubsUzpO5pvDwPSrlLmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f9WRBPpK; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47R1tLtV014542;
	Tue, 27 Aug 2024 14:08:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:mime-version:content-transfer-encoding:in-reply-to
	:references:subject:from:cc:to:date:message-id; s=pp1; bh=m1O9Po
	r2h57V9W50KwdBZWJbTAIPwJYp/oPs9Mpd1xo=; b=f9WRBPpKvs2PI+4c0Z7Hb5
	Vc6ybk8L86IaXb+AexOlpb+qb4qcIFrVbev63UZdIVVwebwgp0FFFKCuSG4uV84t
	yCG0q1+37RPfi7pQ66IyJ3T/VVD7pmLMyPLliwJNXqkbZ5j3bB4Ryk1vRcO9Yg+p
	YBwd42y6X7+ZUXvPyVtKNx+Z5Qg3+3KyDAQISxL+OsxIpxJfLh0KCNOb8YdglZ4z
	CQ8ZJokPzcXccdxfvYVIhd5zO3mZj8j6H/3AP0QB3h9G3QCi0Pn1P2GrhhoeyTFx
	//UZ7fs0XjeIYRlh1ouIWg8t/H2bEILUKFydIHg1TVuA93XoPY/pbRYz3l2A9N5A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 417fvc3qg7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 14:08:37 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 47RE68di022905;
	Tue, 27 Aug 2024 14:08:37 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 417fvc3qg2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 14:08:37 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 47RBNfnL030986;
	Tue, 27 Aug 2024 14:08:36 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 417t80u5k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Aug 2024 14:08:36 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 47RE8WuM47907268
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Aug 2024 14:08:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AB43020043;
	Tue, 27 Aug 2024 14:08:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8025420040;
	Tue, 27 Aug 2024 14:08:32 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.77.101])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Aug 2024 14:08:32 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240620141700.4124157-8-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com> <20240620141700.4124157-8-nsg@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 7/7] s390x: Add test for STFLE interpretive execution (format-0)
From: Nico Boehr <nrb@linux.ibm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Date: Tue, 27 Aug 2024 16:08:30 +0200
Message-ID: <172476771096.31767.10959866977543273401@t14-nrb.local>
User-Agent: alot/0.10
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HIM8XLQucT8-y1le7NGJvGv8Dxsn3_pG
X-Proofpoint-GUID: NMkkq38X4yTCWq7tZldCd-XRGhXl8eDk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-27_07,2024-08-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1011
 lowpriorityscore=0 adultscore=0 phishscore=0 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408270104

Quoting Nina Schoetterl-Glausch (2024-06-20 16:17:00)
[...]
> diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
> index a66fe56a..2bad05c5 100644
> --- a/lib/s390x/asm/facility.h
> +++ b/lib/s390x/asm/facility.h
> @@ -27,12 +27,20 @@ static inline void stfl(void)
>         asm volatile("  stfl    0(0)\n" : : : "memory");
>  }
> =20
> -static inline void stfle(uint64_t *fac, unsigned int nb_doublewords)
> +static inline unsigned int stfle(uint64_t *fac, unsigned int nb_doublewo=
rds)

Why unsigned int?

[...]
> diff --git a/s390x/snippets/c/stfle.c b/s390x/snippets/c/stfle.c
> new file mode 100644
> index 00000000..eb024a6a
> --- /dev/null
> +++ b/s390x/snippets/c/stfle.c
[...]
> +int main(void)
> +{
> +       const unsigned int max_fac_len =3D 8;
> +       uint64_t res[max_fac_len + 1];
> +
> +       res[0] =3D max_fac_len - 1;
> +       asm volatile ( "lg      0,%[len]\n"
> +               "       stfle   %[fac]\n"
> +               "       stg     0,%[len]\n"
> +               : [fac] "=3DQS"(*(uint64_t(*)[max_fac_len])&res[1]),

Out of curiosity:

Q =3D Memory reference without index register and with short displacement
S =3D Memory reference without index register but with long displacement

Which one is it?

And: is long displacement even appropriate here?

The cast also is hard to understand. Since this is not super high
performance code, do we just want to clobber memory so this gets a bit
easier to understand?

> +                 [len] "+RT"(res[0])

Same question about RT as above.

[...]
> diff --git a/s390x/stfle-sie.c b/s390x/stfle-sie.c
> new file mode 100644
> index 00000000..a3e7f1c9
> --- /dev/null
> +++ b/s390x/stfle-sie.c
[...]
> +static struct guest_stfle_res run_guest(void)
> +{
> +       struct guest_stfle_res res;
> +       uint64_t guest_stfle_addr;
> +
> +       sie(&vm);
> +       assert(snippet_is_force_exit_value(&vm));
> +       guest_stfle_addr =3D snippet_get_force_exit_value(&vm);
> +       res.mem =3D &vm.guest_mem[guest_stfle_addr];
> +       memcpy(&res.reg, res.mem, sizeof(res.reg));
> +       res.len =3D (res.reg & 0xff) + 1;

If I'm not mistaken, you subtracted 1 in the guest. Here you add it again.
Is there a particular reason why?

