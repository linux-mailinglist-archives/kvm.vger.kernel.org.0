Return-Path: <kvm+bounces-20142-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DECFC910E43
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:16:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4EFB2B24EC7
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE94A1B3F3B;
	Thu, 20 Jun 2024 17:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="P34d6n1P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9B41ABCB1;
	Thu, 20 Jun 2024 17:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718903784; cv=none; b=Jpjm4TOAB7kwLwb830Kgl3qM1BpQyqPiQ5OH8IXXtFspHjdBY4WhEH69Xo7C3PTXp88uE5GTI5aIYPHaat4oO6taiskHp1IfRcghFKt68h/4A2A/SEVXPfm0QoIsd0F6iPccx9TI2i8yNuixzkRuzA22kCV7vDwZ35kvpzvYzu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718903784; c=relaxed/simple;
	bh=V4DZg/EyfQ49qBE+Du0IVbkpor2dkrY+41/1OIKIkf0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DBdWS+dWo3GeqiOic3KHhb+g2w7s6i8U9yAvNrYxl0+49mHX4EKPRJptt7OUrAxuKcqkNkc2lUPCFvrZAtKmcaILnEP8QiVXYw5Q3bJEBqH/yQQ/MmVLUci2c5I6xNJhg5qsbZ5UkLSqKJGoVF1exoMRUtPVz5lOlsdxi+FfaV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=P34d6n1P; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KGQjUL011790;
	Thu, 20 Jun 2024 17:16:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	hDycikH0vt9FQ3+yg1nelgakQAYHF9r8CxJ1L9fKtTc=; b=P34d6n1P5M9LlDRd
	Cs6XCAlT1hjUe9BEyv2GmSy44xrKebgTez3T5iBS/De6CM2wo3bfqPgf8/aFwnHg
	csd2L1M9igxdovQPkJPY23UV45VddMIgczHrrKW+z8XELwXZWm1XOChxm1VUYOOW
	/rwNXKykJYxX/LpNT9pqhnviXDbpNX5l1HTvyiwWNuT25rskh9kTfQ50B1KzxPL3
	gcCRFTonCDhJfoc3V+RmyHW5ioRBhNbbJW0RFTxTKNpec/4JFuMk4SKK0mtF5phO
	pKGn8b/Xu5RFCrPeNfpfFQcytkMMTRVloqmIbETf3CYyEm/UkwbA7zJgQAnrElsM
	LsEbhQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvndp8k7n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:16:12 +0000 (GMT)
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KHGCap029286;
	Thu, 20 Jun 2024 17:16:12 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvndp8k7g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:16:12 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KFgRFK023957;
	Thu, 20 Jun 2024 17:16:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ysp9qrcpa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:16:11 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KHG5PC28836440
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:16:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ABC1B2005A;
	Thu, 20 Jun 2024 17:16:05 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8893820043;
	Thu, 20 Jun 2024 17:16:05 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.boeblingen.de.ibm.com (unknown [9.152.224.238])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Jun 2024 17:16:05 +0000 (GMT)
Message-ID: <c5e1cccdd7619f280d58b2ef00c076d5426e764b.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: Add library functions for
 exiting from snippet
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>,
        Nico =?ISO-8859-1?Q?B=F6hr?=
 <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>,
        David
 Hildenbrand <david@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Date: Thu, 20 Jun 2024 19:16:05 +0200
In-Reply-To: <20240620185544.4f587685@p-imbrenda>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	 <20240620141700.4124157-6-nsg@linux.ibm.com>
	 <20240620185544.4f587685@p-imbrenda>
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
X-Proofpoint-GUID: xOqiT6yeDTI9e5of6i5vZyNwH0c6Lv2n
X-Proofpoint-ORIG-GUID: bVrzZfR_lPK0LGQNqP7c38RIzZ_jbcUc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_08,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 bulkscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 mlxlogscore=809 spamscore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200122

On Thu, 2024-06-20 at 18:55 +0200, Claudio Imbrenda wrote:
> On Thu, 20 Jun 2024 16:16:58 +0200
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > It is useful to be able to force an exit to the host from the snippet,
> > as well as do so while returning a value.
> > Add this functionality, also add helper functions for the host to check
> > for an exit and get or check the value.
> > Use diag 0x44 and 0x9c for this.
> > Add a guest specific snippet header file and rename snippet.h to reflec=
t
> > that it is host specific.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
>=20
> [...]
>=20
>=20
> > +static inline void diag44(void)
> > +{
> > +	asm volatile("diag	0,0,0x44\n");
> > +}
> > +
> > +static inline void diag9c(uint64_t val)
> > +{
> > +	asm volatile("diag	%[val],0,0x9c\n"
> > +		:
> > +		: [val] "d"(val)
> > +	);
> > +}
> > +
> >  #endif
>=20
> [...]
>=20
> > +static inline void force_exit(void)
> > +{
> > +	diag44();
> > +	mb(); /* allow host to modify guest memory */
> > +}
> > +
> > +static inline void force_exit_value(uint64_t val)
> > +{
> > +	diag9c(val);
> > +	mb(); /* allow host to modify guest memory */
> > +}
>=20
> why not adding "memory" to the clobbers of the inline asm? (not a big
> deal, I'm just curious if there is a specific reason for an explicit
> mb())

Mostly a matter of taste I guess.
The diag functions are just convenience wrappers, doing nothing but
executing the diag.
force_exit is a protocol between the host and guest that uses the diags
and adds additional semantics on top.
In theory you could have other use cases where the diags are just a timesli=
ce yield.
>=20
>=20
> [...]


