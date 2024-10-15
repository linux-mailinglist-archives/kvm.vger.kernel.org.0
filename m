Return-Path: <kvm+bounces-28877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 498B099E4E9
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 13:01:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DBCB1C257A8
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 11:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66E3A1D89F5;
	Tue, 15 Oct 2024 11:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IBxfhDPi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDC51D4146;
	Tue, 15 Oct 2024 11:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728990071; cv=none; b=HS6LiCtXUV3Z8sWp+3oB+8GbuuvnqQ3otkH4TntCsBICbHE60IvYlhmEuRbtu6FPLTF1H+2TVHQfi/LTAGJLrZvcxk81IxWWsb4yMLTc3viR66/n10qoZy13EKT+nTpAdDC3gYuDywa8zUfJzGow7GECgp5scSW1+g/3LM90CIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728990071; c=relaxed/simple;
	bh=shQwwPCu66L6/cJvq9dxEjhUJYr1Cv0Hj2Dpv1dygoc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KxvEZTR3YCCv2SN2iUZnHaxYIguDjhh5ASy0Jp07rHXn4O5sVnKe4xgeq5PQL4ixy24ADqvfQ4eUHqXsQRmDVo2yw5594UOeemlNnBrS6N6gdam4fmnQ/FS/Z6TZWsGP9hcDAtX0cbVUw3S+dq+u7OgUV96Xj2uqwghhU0/JoNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IBxfhDPi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49FAO16m004304;
	Tue, 15 Oct 2024 11:01:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=LdGqa8
	XKBbw272qeM789lpbXRCsp9HgKR+VUIIiXOog=; b=IBxfhDPikqwUBzU1RiUxF/
	8/yu+9j33R9pTWNfuorUPi6QLuwcPiqWzvWRQ3GfT8MF1RmqpD0FSgZN8hfmYWt4
	n+TNI64pJ04oqzWZPGIKplfrXvLf/tGYNglDA45Ixbn/0xSF96eciAL3s7KeDkbf
	XWbU6KkEbF5FzlhcMkfm6Uvzrr63WgF9MrWRGQrYJrH+Xwap8gsSxvMWfBTzN2ZO
	YsDjt7egeZGlK4xw/5YXj/qesZHtw3TW1tg13UyPnmLvTYn1u31gq5vLOkPmjw/T
	Et6KavP6g3b32Yy+L5FoBTNGoYJLByEWQ54iQfI/OBNTdT6dfPiHLP5Zvv13NgSQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429pkyg51r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 11:01:06 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49FB15X3028828;
	Tue, 15 Oct 2024 11:01:05 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429pkyg51p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 11:01:05 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F8jtbY005215;
	Tue, 15 Oct 2024 11:01:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4285nj33te-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 11:01:04 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49FB11AH15597872
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 11:01:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 650542004E;
	Tue, 15 Oct 2024 11:01:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AA0F2004B;
	Tue, 15 Oct 2024 11:01:01 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 11:01:01 +0000 (GMT)
Message-ID: <cbf183ce6115b87553b9b5a90067fd32a87fbd72.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 7/7] s390x: Add test for STFLE
 interpretive execution (format-0)
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, Thomas Huth <thuth@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Date: Tue, 15 Oct 2024 13:01:00 +0200
In-Reply-To: <172854883775.172737.10768298982142687956@t14-nrb.local>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	 <20240620141700.4124157-8-nsg@linux.ibm.com>
	 <172476771096.31767.10959866977543273401@t14-nrb.local>
	 <0d1fb151a09701588f98547cdb9f74bc743cb615.camel@linux.ibm.com>
	 <172854883775.172737.10768298982142687956@t14-nrb.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 (3.52.3-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: abqEBoZ74hHVncr886kkrj9zn91cWFvr
X-Proofpoint-GUID: AHqzKVH3XSXxZw81vjpSUOgd3oQ5-Sj1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 mlxlogscore=999 mlxscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150072

On Thu, 2024-10-10 at 10:27 +0200, Nico Boehr wrote:
> Quoting Nina Schoetterl-Glausch (2024-09-02 16:24:53)
> > On Tue, 2024-08-27 at 16:08 +0200, Nico Boehr wrote:
> > > Quoting Nina Schoetterl-Glausch (2024-06-20 16:17:00)
> > > [...]
> > > > diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
> > > > index a66fe56a..2bad05c5 100644
> > > > --- a/lib/s390x/asm/facility.h
> > > > +++ b/lib/s390x/asm/facility.h
> > > > @@ -27,12 +27,20 @@ static inline void stfl(void)
> > > >         asm volatile("  stfl    0(0)\n" : : : "memory");
> > > >  }
> > > > =20
> > > > -static inline void stfle(uint64_t *fac, unsigned int nb_doubleword=
s)
> > > > +static inline unsigned int stfle(uint64_t *fac, unsigned int nb_do=
ublewords)
> > >=20
> > > Why unsigned int?
> >=20
> > The return value is 1-256, the size of the type is a bit arbitrary I su=
ppose.
> >=20
> > >=20
> > > [...]
> > > > diff --git a/s390x/snippets/c/stfle.c b/s390x/snippets/c/stfle.c
> > > > new file mode 100644
> > > > index 00000000..eb024a6a
> > > > --- /dev/null
> > > > +++ b/s390x/snippets/c/stfle.c
> > > [...]
> > > > +int main(void)
> > > > +{
> > > > +       const unsigned int max_fac_len =3D 8;
> > > > +       uint64_t res[max_fac_len + 1];
> > > > +
> > > > +       res[0] =3D max_fac_len - 1;
> > > > +       asm volatile ( "lg      0,%[len]\n"
> > > > +               "       stfle   %[fac]\n"
> > > > +               "       stg     0,%[len]\n"
> > > > +               : [fac] "=3DQS"(*(uint64_t(*)[max_fac_len])&res[1])=
,
>=20
> Nina, do you mind sending a new version where we have the constraints
> simplified, e.g. with just a memory clobber?

Will do

