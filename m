Return-Path: <kvm+bounces-29166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C83BC9A3C82
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 13:01:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03B041C239EC
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 11:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BAB204094;
	Fri, 18 Oct 2024 10:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tN1mp8mz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E8E2022C3;
	Fri, 18 Oct 2024 10:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729248981; cv=none; b=uYr2pywWcqSXP3yIQASwzPhU262q/QUaMlngeEu5AplDtaFwS4NT2xTbxlKO3rM+Qze4hxjIzA9U35VJ4GTKiUDk2fZmpBx+p084pvmg/zohcZkz86zGyMHTefVF+BgI/dOPPxFdKdfngXi5T9R0F+1cKq1TLGnFZYfrAMK/lGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729248981; c=relaxed/simple;
	bh=aIfATgPT2r3L16kqOwd+kbWy7o5B3gL0vouhworFFBQ=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=INHJaAQoNSoT6aJab4azrgXXEqQtc87xslxlevjBlG7KNWFEAsg4a3u2vpEd3Uy38umOtpZpFmkCxAtmKR4Ud52Dwub+N+bhQIkH9pU1H89oyfrzHAL6+kTg89GW2g4/ADvA05HUO5HnNSm8n93/186qzgqgziKRY1RixxSoFX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tN1mp8mz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49I8oFeT007998;
	Fri, 18 Oct 2024 10:56:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HxNID/
	LRBGejTk7PjBHzmGeXpivOHFj2wDF4gutex9s=; b=tN1mp8mzoJ2fkh9+hIr+FK
	o6BaZbTa2dzogJFOBUvcAVBqfda0F5oWyXdNZF3mjGu6m/fz701NJWCHTGzI5DzB
	ynZQTQcmGvrDyqSmudgMV+/yfGSYYuxqEMbsyXu9tBeu1dCw0rbC/wZaHZ8CNTQV
	/ObwuaqOwP8eLkNT6lP6dQkDPxC2IVmDvcGKJjMb5mSgc/HJHpUF6syGR7j1UFQh
	pNvSi4leE3Hjd5nHUt7urRpFPx1X7AFzCFrnpqsYQWTOiZWQgeIN2p47Ap1u9alY
	ePCJif5VmZ0VmesUh6/FJZer6UGzUV9pG9ditAPk6wL0/StWQcQIUuwfy3VNlYkw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42as8a7wv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Oct 2024 10:56:17 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49IAuH3E013334;
	Fri, 18 Oct 2024 10:56:17 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42as8a7wv8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Oct 2024 10:56:17 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49I7UhbL027480;
	Fri, 18 Oct 2024 10:56:16 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4283ty43s4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 18 Oct 2024 10:56:16 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49IAuC2p46203228
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 18 Oct 2024 10:56:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D180B2004B;
	Fri, 18 Oct 2024 10:56:12 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF81220043;
	Fri, 18 Oct 2024 10:56:12 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.13.120])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 18 Oct 2024 10:56:12 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e649996c-559f-425e-833f-ca83bad59372@linux.ibm.com>
References: <20241016180320.686132-1-nsg@linux.ibm.com> <20241016180320.686132-5-nsg@linux.ibm.com> <e649996c-559f-425e-833f-ca83bad59372@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 4/6] s390x: Add library functions for exiting from snippet
From: Nico Boehr <nrb@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        Nicholas Piggin <npiggin@gmail.com>, linux-s390@vger.kernel.org
To: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>
Date: Fri, 18 Oct 2024 12:56:11 +0200
Message-ID: <172924897145.324297.7466880604426455626@t14-nrb.local>
User-Agent: alot/0.10
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NMfHCuccsRDQfSkdrc68ahAigzR9m_N6
X-Proofpoint-ORIG-GUID: LIR1yEB77envDzp5WGfmp04aEKMwBNyK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 suspectscore=0 mlxlogscore=929 phishscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410180070

Quoting Janosch Frank (2024-10-18 10:02:37)
[...]
> > +static inline uint64_t snippet_get_force_exit_value(struct vm *vm)
> > +{
> > +     struct kvm_s390_sie_block *sblk =3D vm->sblk;
> > +
> > +     assert(snippet_is_force_exit_value(vm));
> > +
> > +     return vm->save_area.guest.grs[sblk_ip_as_diag(sblk).r_1];
> > +}
>=20
> The cpu address parameter for 9C is 16 bit.
> While we could make it 64 bit for snippets I don't see a reason to do=20
> so. The 16 bits are enough to indicate something to the host which can=20
> then go and fetch memory for more data.

Mh, how exactly would you "fetch memory"? That requires knowledge on where
things are in guest memory which can be painful to figure out from the
host.

I've found it useful to be able to pass a pointer from guest to host. Maybe
a diag500 is the better option? gr2 contains the cookie which is a 64-bit
value - see Linux' Documentation/virt/kvm/s390/s390-diag.rst.

P.S. Did I miss the part in the docs where the 16-bit restriction of 9c is
documented or is it missing?

