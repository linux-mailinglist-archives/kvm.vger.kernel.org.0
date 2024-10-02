Return-Path: <kvm+bounces-27808-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 027C198DE00
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 16:55:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33E041C2262F
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 14:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294D01D0951;
	Wed,  2 Oct 2024 14:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QeIeQC8g"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53919475;
	Wed,  2 Oct 2024 14:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880720; cv=none; b=kdVXyn6zGMqX2l1RhvripBGZP5W0Ra88LtA/8zRSzkudlzNjsfwfQA2QEfndY37MGVn0Hn7B53m1xPltLU1ejFe0v2g11MPbpLSpJW3p/t7/nPHU/o9mjS+XbBD3uFaC+9FEriXAif3fyoVBXk+QabQzEPiSvbyBWYCltpoayEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880720; c=relaxed/simple;
	bh=+Kbkj3EgLxDp0VAIKoa/kYQBRLMmKIQu1pFpRfZ81UQ=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=qE/rqUDq+rRjCDmLrlh81KwA8vLFLIrZYkQqGvlsGtkHPlE89IIhRMrOYKY3GEDhDDi0JAFqjQT3ZcP2mvpTtoXVPiOQH5Qtwp8B8NhqM18LacY55lF/P3T+3aBepTgNZWHyFcXgSjAFYRpdQcyKXSeLXaQgk3DFWp9utvHXX1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QeIeQC8g; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492EngtI006725;
	Wed, 2 Oct 2024 14:51:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:mime-version:content-transfer-encoding:in-reply-to
	:references:subject:from:cc:to:date:message-id; s=pp1; bh=W7X51P
	WINK4iz6r2QM6CiApUFhMAvy84DJEX+/rdD50=; b=QeIeQC8gHIPI/BOGDJT427
	tupdXcYfPz/eLwK4Uo6ECTXbOppfPAqepUn6biFjwBA7TNs19SqWAbWPxObPO0dt
	hlrSosHoWq5cI9OfvfJvaPJkFKZIPCSv1HSXpKO//PXZu7Oxlmk9i2CdgOHI569a
	+wpALNr2PXqJ6lJJA/K0CFrKq/i2bqbnCb9yAhSFyD6HqS3ZZwfbT4ehxvvRoya+
	WrJ+tlqj4cqgMH+OM8tJsmJbOqAfj2+xmQ3/tZE0kwThBs9ibskiymlL4KDjiIp1
	BDoNYJFzaG21G8xYtUx/GW3pGiCkjwDr4TAypcK0HVAlgEy60+G6OXS/yWyF9a0A
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42189800c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:51:56 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 492EpufZ012736;
	Wed, 2 Oct 2024 14:51:56 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42189800c5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:51:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 492DODk0017899;
	Wed, 2 Oct 2024 14:51:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41xw4n2wjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:51:55 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 492Epn7q25625284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Oct 2024 14:51:49 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10B6E20043;
	Wed,  2 Oct 2024 14:51:49 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D94D120040;
	Wed,  2 Oct 2024 14:51:48 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.74.111])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  2 Oct 2024 14:51:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20241002163133.3ade7537@p-imbrenda.boeblingen.de.ibm.com>
References: <20241001113640.55210-1-imbrenda@linux.ibm.com> <172787913947.65827.12438423086547383920@t14-nrb.local> <20241002163133.3ade7537@p-imbrenda.boeblingen.de.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/1] s390x: edat: test 2G large page spanning end of memory
From: Nico Boehr <nrb@linux.ibm.com>
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, borntraeger@de.ibm.com,
        david@redhat.com, thuth@redhat.com, linux-s390@vger.kernel.org
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Date: Wed, 02 Oct 2024 16:51:47 +0200
Message-ID: <172788070709.65827.11642696032248854756@t14-nrb.local>
User-Agent: alot/0.10
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: r9Pr0d-NaCy4A0PxqK1sNxRlvdWwP7X4
X-Proofpoint-ORIG-GUID: _ZDqO8t-ZU8IoWTO_rUB_Gy2GdcUOpCX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_14,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 impostorscore=0
 phishscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2408220000 definitions=main-2410020106

Quoting Claudio Imbrenda (2024-10-02 16:31:33)
> On Wed, 02 Oct 2024 16:25:39 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
>=20
> > Quoting Claudio Imbrenda (2024-10-01 13:36:40)
> > [...]
> > > diff --git a/s390x/edat.c b/s390x/edat.c
> > > index 16138397..1f582efc 100644
> > > --- a/s390x/edat.c
> > > +++ b/s390x/edat.c
> > > @@ -196,6 +196,8 @@ static void test_edat1(void)
> > > =20
> > >  static void test_edat2(void)
> > >  { =20
> > [...]
> > > @@ -206,7 +208,21 @@ static void test_edat2(void)
> > >         /* Prefixing should not work with huge pages, just like large=
 pages */
> > >         report(!memcmp(0, VIRT(prefix_buf), LC_SIZE) &&
> > >                 !memcmp(prefix_buf, VIRT(0), LC_SIZE),
> > > -               "pmd, large, prefixing");
> > > +               "pud, large, prefixing");
> > > +
> > > +       mem_end =3D get_ram_size();
> > > +       if (mem_end >=3D BIT_ULL(REGION3_SHIFT)) {
> > > +               report_skip("pud spanning end of memory"); =20
> >=20
> > Does it make sense to explicitly add a mem parameter in unittests.cfg so
> > this will never be the case?
>=20
> hmmm, I did not consider this case; I kinda assumed we would never
> increase the default guest size
>=20
> I do not have any strong opinions

As long as the default mem size is OK, I think it's fine to leave as-is.

