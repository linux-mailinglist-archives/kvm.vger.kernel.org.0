Return-Path: <kvm+bounces-19989-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC8790EF94
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 16:00:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CFCD1C21AAD
	for <lists+kvm@lfdr.de>; Wed, 19 Jun 2024 14:00:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CCED150987;
	Wed, 19 Jun 2024 14:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S9Nd1see"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B34D26A;
	Wed, 19 Jun 2024 14:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718805629; cv=none; b=LT0BP/3giZNOwWvlxHmM1Dlti6eG4qomDkBT4+0znLOuuOHac51Z7F7mXiHN9HY4xEB1Tmy41RSOBkEY+ltVtR1KuPtc54OT9y4uyphuZtK7safOvcJxtSblrx96neWMvWTtJ7ejEIPyJlVFeFa2HWK12yMpPVs1wo+aSFc0UW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718805629; c=relaxed/simple;
	bh=k3gSboAJc+MvETXcfhdx81BB8B2hrN6M6hXGZXPOdq0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EsIuSD4OEoPC8FiRo+11o2Sx2fZwKAB5iyQseSakbCIAk+s+j00tSfFP92vCQ8UUaoEqFOH8LBLRutD6TU19syKAcIruQAMT7gEuSNcuhfiQOE+OPxB3T4dObK2OuxK+0U5HYI0MzNby3MbQn1TNnThMG3NkkJfUiZ3CpnYClIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S9Nd1see; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45JDR102003196;
	Wed, 19 Jun 2024 14:00:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	k3gSboAJc+MvETXcfhdx81BB8B2hrN6M6hXGZXPOdq0=; b=S9Nd1seeM2taZwhn
	3Go0MPxv9KF29c3xx+SsDcbtZlLa8/ddvAX1ckUKXEnp7prf8VbtZK3wmMOWAEuK
	XE4TRDXdtNu/f2aebtfk8NcL1hUsc5wEfrM9KKDk2yoHC0aJdubXBjU4sDZP0sF9
	zCeHWOwwwzdpQ8VgmdoXmp9JRCS0HvjD6TT94VB1Kclw2Subfjw2MghuuWCxysvr
	T207gexiGQNz1aoV1iAaOs6EFqNR3OOlLsdtz1wYhfU0VjmZ6pXrUi/YCFgT/W20
	J/HUD3yWjhw7Nz7C8WY3q6We7IScQAsw+ozQtmDoA0JWozJanbfSQymMB3udcqe0
	KM0KWg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yux3fgfma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 14:00:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45JCAgh6023990;
	Wed, 19 Jun 2024 14:00:22 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ysp9qd1w7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 19 Jun 2024 14:00:22 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45JE0IlJ11666108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Jun 2024 14:00:20 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53B0058069;
	Wed, 19 Jun 2024 14:00:16 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 569F95808E;
	Wed, 19 Jun 2024 14:00:15 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.159.49])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 19 Jun 2024 14:00:15 +0000 (GMT)
Message-ID: <8ae9b1bef0e8ef4689873911c8ae5c9a921401a9.camel@linux.ibm.com>
Subject: Re: [PATCH] s390/cio: add missing MODULE_DESCRIPTION() macros
From: Eric Farman <farman@linux.ibm.com>
To: Halil Pasic <pasic@linux.ibm.com>
Cc: Vineeth Vijayan <vneethv@linux.ibm.com>,
        Jeff Johnson
 <quic_jjohnson@quicinc.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Matthew
 Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Wed, 19 Jun 2024 10:00:14 -0400
In-Reply-To: <20240619123255.4b1a6c6d.pasic@linux.ibm.com>
References: 
	<20240615-md-s390-drivers-s390-cio-v1-1-8fc9584e8595@quicinc.com>
	 <064eb313-2f38-479d-80bd-14777f7d3d62@linux.ibm.com>
	 <afdde0842680698276df0856dd8b896dac692b56.camel@linux.ibm.com>
	 <20240619123255.4b1a6c6d.pasic@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 3U6wkBpOZZvOXgSq-0KAzS0OtU9mEOAY
X-Proofpoint-GUID: 3U6wkBpOZZvOXgSq-0KAzS0OtU9mEOAY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-19_02,2024-06-19_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 clxscore=1015 phishscore=0 mlxlogscore=943 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406190104

On Wed, 2024-06-19 at 12:32 +0200, Halil Pasic wrote:
> On Tue, 18 Jun 2024 16:11:33 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
>=20
> > > > +MODULE_DESCRIPTION("VFIO based Physical Subchannel device
> > > > driver");=C2=A0=20
> > >=20
> > > Halil/Mathew/Eric,
> > > Could you please comment on this ?=C2=A0=20
> >=20
> > That's what is in the prologue, and is fine.
>=20
> Eric can you explain it to me why is the attribute "physical"
> appropriate
> here? I did a quick grep for "Physical Subchannel" only turned up
> hits
> in vfio-ccw.

One hit, in the prologue comment of this module. "Physical device" adds
three to the tally, but only one of those is in vfio-ccw so we should
expand your query regarding "physical" vs "emulated" vs "virtual" in
the context of, say, tape devices.

>=20
> My best guess is that "physical" was somehow intended to mean the
> opposite of "virtual". But actually it does not matter if our
> underlying
> subchannel is emulated or not, at least AFAIU.

I also believe this was intended to mean "not virtual," regardless of
whether there's emulation taking place underneath. That point is moot
since I don't see that information being surfaced, such that the driver
can only work with "physical" subchannels.

I'm fine with removing it if it bothers you, but I don't see it as an
issue.

Thanks,
Eric

>=20
> Regards,
> Halil


