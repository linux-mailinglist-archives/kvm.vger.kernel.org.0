Return-Path: <kvm+bounces-25681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A7949689D9
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 16:25:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FE481C22335
	for <lists+kvm@lfdr.de>; Mon,  2 Sep 2024 14:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C8F19E981;
	Mon,  2 Sep 2024 14:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kWYb477T"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAF819F139;
	Mon,  2 Sep 2024 14:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725287112; cv=none; b=dYTh7/aAbjiEAZOppJcktwyx9EPlVUHwEppi6P1hIujndO4J8q0dgIoDgOy1m9Tx/HcGvWaLEx5eZ68bKT9p6+R3VVOxy2p2Xy6NcZRVPC74bwTdhG1M5r3RRhhl/3bWGICvNX6uHZxmpHY6lqVOem53Vc/8EtT0TbSNBRlZz2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725287112; c=relaxed/simple;
	bh=DrDOjdxcgadql5m2DXZISZ1sfTqZQxqNNVSF+ORG/Sk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=R12sljIkxV+fLNePDO59lJTHTvacLXoQekTDfa8OFo2wW4n2qdu8o9r0Lh/hWzvK2g6XCLxKSCDi9ef1wLc1UEtEL3qxtKo7Vp8eU2yg7tl0Jhilb9YgpdCJ3+i4Oa3MXiaGSVVFZqm3KAIjHzCFO53BZAvK3ZDW97CSkWZxAOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kWYb477T; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4827N5fg006465;
	Mon, 2 Sep 2024 14:25:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	5ZtPBO5+7XJ5Szcv5XnJYOqDDn3orzLxqKc2gvbhS+A=; b=kWYb477TeUy4cUnY
	8/3WgBY6BGJJk7yIqRRqmKQwdYObW4YmewCYkoaOipFzQzzlMxJJakIz1xqdJjHz
	pMtV5tB/6AlEHp6CiPbiDbKLPUv4ZSe/d4xPJbtnOlssvTPcR5fFnWg6GNIf3uaY
	uJvPRYj730ZrA42G+IUvxAmD59IlzySc4UftdjYFQNoTKKdTJAK8Mf+c+BwuP3gv
	D5XWDoNwYfvduUx4opVt06cAWwu1b34PeeTzdWd+UFRlRgplXew+vZOowqvyxSJ3
	IWf7wRtQRdzQDihwUjRMgzVBE+1GsZzF9zpOnufSIHjhXSRCtA9sPNSt6wC38zjW
	8lA70w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41btp99c0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Sep 2024 14:24:59 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 482EOxIg005545;
	Mon, 2 Sep 2024 14:24:59 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41btp99c0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Sep 2024 14:24:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 482BcPXf000438;
	Mon, 2 Sep 2024 14:24:58 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 41cdguercm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 02 Sep 2024 14:24:58 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 482EOsl739059966
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 2 Sep 2024 14:24:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AD22220043;
	Mon,  2 Sep 2024 14:24:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 03DAC20040;
	Mon,  2 Sep 2024 14:24:54 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.31.79])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  2 Sep 2024 14:24:53 +0000 (GMT)
Message-ID: <0d1fb151a09701588f98547cdb9f74bc743cb615.camel@linux.ibm.com>
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
Date: Mon, 02 Sep 2024 16:24:53 +0200
In-Reply-To: <172476771096.31767.10959866977543273401@t14-nrb.local>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	 <20240620141700.4124157-8-nsg@linux.ibm.com>
	 <172476771096.31767.10959866977543273401@t14-nrb.local>
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
X-Proofpoint-GUID: iVg7jQp_OdXqhaUZZ0OQtFqaXqz7UjiD
X-Proofpoint-ORIG-GUID: l07LXFF9gnNGv11tLqBEOqsGnOpIERgk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-02_04,2024-09-02_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2409020112

On Tue, 2024-08-27 at 16:08 +0200, Nico Boehr wrote:
> Quoting Nina Schoetterl-Glausch (2024-06-20 16:17:00)
> [...]
> > diff --git a/lib/s390x/asm/facility.h b/lib/s390x/asm/facility.h
> > index a66fe56a..2bad05c5 100644
> > --- a/lib/s390x/asm/facility.h
> > +++ b/lib/s390x/asm/facility.h
> > @@ -27,12 +27,20 @@ static inline void stfl(void)
> >         asm volatile("  stfl    0(0)\n" : : : "memory");
> >  }
> > =20
> > -static inline void stfle(uint64_t *fac, unsigned int nb_doublewords)
> > +static inline unsigned int stfle(uint64_t *fac, unsigned int nb_double=
words)
>=20
> Why unsigned int?

The return value is 1-256, the size of the type is a bit arbitrary I suppos=
e.

>=20
> [...]
> > diff --git a/s390x/snippets/c/stfle.c b/s390x/snippets/c/stfle.c
> > new file mode 100644
> > index 00000000..eb024a6a
> > --- /dev/null
> > +++ b/s390x/snippets/c/stfle.c
> [...]
> > +int main(void)
> > +{
> > +       const unsigned int max_fac_len =3D 8;
> > +       uint64_t res[max_fac_len + 1];
> > +
> > +       res[0] =3D max_fac_len - 1;
> > +       asm volatile ( "lg      0,%[len]\n"
> > +               "       stfle   %[fac]\n"
> > +               "       stg     0,%[len]\n"
> > +               : [fac] "=3DQS"(*(uint64_t(*)[max_fac_len])&res[1]),
>=20
> Out of curiosity:
>=20
> Q =3D Memory reference without index register and with short displacement
> S =3D Memory reference without index register but with long displacement
>=20
> Which one is it?

Ups, just short displacement actually.

>=20
> And: is long displacement even appropriate here?
>=20
> The cast also is hard to understand. Since this is not super high
> performance code, do we just want to clobber memory so this gets a bit
> easier to understand?
>=20
> > +                 [len] "+RT"(res[0])
>=20
> Same question about RT as above.

Long, but providing a short displacement should be fine too.
Not sure if there is any benefit to letting the compiler choose.

>=20
> [...]
> > diff --git a/s390x/stfle-sie.c b/s390x/stfle-sie.c
> > new file mode 100644
> > index 00000000..a3e7f1c9
> > --- /dev/null
> > +++ b/s390x/stfle-sie.c
> [...]
> > +static struct guest_stfle_res run_guest(void)
> > +{
> > +       struct guest_stfle_res res;
> > +       uint64_t guest_stfle_addr;
> > +
> > +       sie(&vm);
> > +       assert(snippet_is_force_exit_value(&vm));
> > +       guest_stfle_addr =3D snippet_get_force_exit_value(&vm);
> > +       res.mem =3D &vm.guest_mem[guest_stfle_addr];
> > +       memcpy(&res.reg, res.mem, sizeof(res.reg));
> > +       res.len =3D (res.reg & 0xff) + 1;
>=20
> If I'm not mistaken, you subtracted 1 in the guest. Here you add it again=
.
> Is there a particular reason why?

No, it's the direct result of STFLE on register 0.


