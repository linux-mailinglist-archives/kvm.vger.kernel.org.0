Return-Path: <kvm+bounces-20457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E95AA9160B2
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 10:11:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6609F1F22558
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 08:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD421148319;
	Tue, 25 Jun 2024 08:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QGLjFDGI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE981474AF;
	Tue, 25 Jun 2024 08:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719303089; cv=none; b=NQIshKqizoqKokEHqpx6ms517ddiZAAU7sa857ytnk+ozqbT7GLqUQQUPLPbhaJa7WpQ03myvUrD9qq+1sf2zzyyHkMDSshIh2vGN+luLfQC9/8ZYF0f5iZzEFa+Wre2IaX4fJd84NNNNXq9J0CWC9GAL3N0PtmqYr4xmg4BnZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719303089; c=relaxed/simple;
	bh=P4QUIiQcI3eVT9M6HjZjSUJwjB5SBq2vK92a3mbXcwU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NX8UKYV/r19dm3zO0UzS/iIhScOblTS31mTVoffMlqqyxUN5grVDG2qFkTcYlV7Z8VAJC+Zc8AinHGTMdCDkqYdQdc4VsZnqynpdqg1cPcga8prkqWzJD+NGYX03G0DQfmkyfBw9VkIqjc5LjApRGVATBe5IgMorxTQm7aiFgTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QGLjFDGI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45P7uRPk017823;
	Tue, 25 Jun 2024 08:11:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	Wp2FddHtQsTC+choX+hj2LYAdn2RfWxL3mKlZ6jY/Yk=; b=QGLjFDGIsd/Dkf0p
	ndtsYc3WjXpwZ4bqFxiTtyZWIn1IBfA+/dDrySQP1+hXaGGIeo6lxezFEibQwiDS
	SeF+yzWRjBz0muf6g54t4hRGzy+VB7VDcgmd6RSf4O2sxMt32F4GFh2G8Jk8cEOr
	88gB452gZtCN+CRe+SzeyTSLcilJQkivMqqiO9YxH3+e/XYKupzaFW7IDZx2LsDs
	7bSAnGs/XLEJdRh/38IYwcDi3OgeO95JjrsjiM8whrmdXswTl2mb2b2Xt9PHNzmy
	AeiiTMMNwoYbo0a/bXw8Sjq2c+E/nOtNNTkG9ZRp7m+OkUnF8yGpXRFk9rGBRiJb
	Opqrhw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yyre888w4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Jun 2024 08:11:16 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45P87CdN001626;
	Tue, 25 Jun 2024 08:11:16 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yyre888w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Jun 2024 08:11:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45P70Zmk008183;
	Tue, 25 Jun 2024 08:11:14 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yx9b0ngck-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Jun 2024 08:11:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45P8B9S422741258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 08:11:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F10C20043;
	Tue, 25 Jun 2024 08:11:09 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9BF4F2004D;
	Tue, 25 Jun 2024 08:11:08 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.29.84])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Jun 2024 08:11:08 +0000 (GMT)
Message-ID: <12c7ba9be7804d31f4aaa4bd804716732add1561.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 4/7] s390x: Add function for checking
 diagnose intercepts
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>,
        Claudio Imbrenda
 <imbrenda@linux.ibm.com>,
        Nico =?ISO-8859-1?Q?B=F6hr?= <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>,
        David Hildenbrand
	 <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date: Tue, 25 Jun 2024 10:11:08 +0200
In-Reply-To: <D28QHQGLKAKJ.NZ0V3NUSSFP8@gmail.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	 <20240620141700.4124157-5-nsg@linux.ibm.com>
	 <D28QHQGLKAKJ.NZ0V3NUSSFP8@gmail.com>
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
X-Proofpoint-ORIG-GUID: GzoBypElhhwxxr9FvxaKRgNuJyORVvb_
X-Proofpoint-GUID: nbObyaQjKIWAqTSvQsOAegOdFhLZ8aGP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-25_04,2024-06-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2406140001
 definitions=main-2406250058

On Tue, 2024-06-25 at 12:14 +1000, Nicholas Piggin wrote:
> On Fri Jun 21, 2024 at 12:16 AM AEST, Nina Schoetterl-Glausch wrote:
> > sie_is_diag_icpt() checks if the intercept is due to an expected
> > diagnose call and is valid.
> > It subsumes pv_icptdata_check_diag.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > ---
> >  lib/s390x/pv_icptdata.h | 42 --------------------------------
> >  lib/s390x/sie.h         | 12 ++++++++++
> >  lib/s390x/sie.c         | 53 +++++++++++++++++++++++++++++++++++++++++
> >  s390x/pv-diags.c        |  8 +++----
> >  s390x/pv-icptcode.c     | 11 ++++-----
> >  s390x/pv-ipl.c          |  7 +++---
> >  6 files changed, 76 insertions(+), 57 deletions(-)
> >  delete mode 100644 lib/s390x/pv_icptdata.h

[...]

> > +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
> > +{
> > +	union {
> > +		struct {
> > +			uint64_t     : 16;
> > +			uint64_t ipa : 16;
> > +			uint64_t ipb : 32;
> > +		};
> > +		struct {
> > +			uint64_t          : 16;
> > +			uint64_t opcode   :  8;
> > +			uint64_t r_1      :  4;
> > +			uint64_t r_2      :  4;
> > +			uint64_t r_base   :  4;
> > +			uint64_t displace : 12;
> > +			uint64_t zero     : 16;
> > +		};
> > +	} instr =3D { .ipa =3D vm->sblk->ipa, .ipb =3D vm->sblk->ipb };
> > +	uint8_t icptcode;
> > +	uint64_t code;
> > +
> > +	switch (diag) {
> > +	case 0x44:
> > +	case 0x9c:
> > +	case 0x288:
> > +	case 0x308:
> > +		icptcode =3D ICPT_PV_NOTIFY;
> > +		break;
> > +	case 0x500:
> > +		icptcode =3D ICPT_PV_INSTR;
> > +		break;
> > +	default:
> > +		/* If a new diag is introduced add it to the cases above! */
> > +		assert_msg(false, "unknown diag");
> > +	}
> > +
> > +	if (sie_is_pv(vm)) {
> > +		if (instr.r_1 !=3D 0 || instr.r_2 !=3D 2 || instr.r_base !=3D 5)
> > +			return false;
> > +		if (instr.displace)
> > +			return false;
> > +	} else {
> > +		icptcode =3D ICPT_INST;
> > +	}
> > +	if (vm->sblk->icptcode !=3D icptcode)
> > +		return false;
> > +	if (instr.opcode !=3D 0x83 || instr.zero)
> > +		return false;
> > +	code =3D instr.r_base ? vm->save_area.guest.grs[instr.r_base] : 0;
> > +	code =3D (code + instr.displace) & 0xffff;
> > +	return code =3D=3D diag;
> > +}
>=20
> It looks like this transformation is equivalent for the PV case.

Yes, the PV case just has hardcoded values that we want to check.

> You
> could put the switch into the sie_is_pv() branch? Otherwise looks okay.

I want to validate diag for both PV and non PV.
>=20
> Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Thanks!

