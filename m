Return-Path: <kvm+bounces-29004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D0239A0D0C
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 16:43:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1B401C2378B
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 14:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AED8520E005;
	Wed, 16 Oct 2024 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nlhwOZzR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC8520E02B;
	Wed, 16 Oct 2024 14:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729089745; cv=none; b=LlNVd8tpmw5LzYjCcSz85xhFMpxb4twWZynSl6vYkso8FjnhRKAjCsRHchUl7Qypg2YfSyMbMEhpzf2afjMb2HCi444ohM9r6HJmMlj4ueQH15WJ4mBzGp6l7ylnccar2skOjEPMZHjh4GHv+19N5yO2Rwne6fNSXe8dEFhVAVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729089745; c=relaxed/simple;
	bh=HsR5nfdcFwll8ZvnEJwdrpRYSjagPQrRY1+6vgSGPTA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=a7oD789uC6/KE88las/JhHhCpjDnHAzP2xred4X71yqgtXIEDapn2TztvHGHYNh/Pyk3b7OCNY/p9/hIi3Gmf2YTFuybvrEESqfC5UByQ5ka7/7TgS+Cj37lMvPVazLVvUhuQqeh/S8cFFlMnzUunULjeAbn070x1Ky91DEjdDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nlhwOZzR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49GEH320002066;
	Wed, 16 Oct 2024 14:42:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=n5RqZ7
	hhZqPWPMojAnyhiNnK43XJxh8KxJL0euJKmGE=; b=nlhwOZzRyAnyQ1gAhy33wR
	VN3PMY1YRINEt1FdRdZXGJZpuPQm7+B+V2/ymBmeYbiozeBGz5xk7k/nenOpEwLJ
	8ye/T2NL6o4mUjTfev1XScC7Plb5OdmDrpJG6Vl9Ty5cKSdBg1wfVARYLqMc64+S
	6ZzttvpFjIoMUmVDB4sGR0FeVI/eHpWTJpKhdVJS4Fzqz417xckAnq9obXB2Ujeg
	ugVrX6Ib/3GF6ANQVtGotPWqeUd4252TE7cN/X2bvBBkvIQHgeyDieX31YBJ8saZ
	gKYhXdW5pHQvyRScENFOxNd54HWvcrktmQAtZPf161pJN5cyNasdE0ewSgN47GYA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42af3t848y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 14:42:14 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49GEgE4A031052;
	Wed, 16 Oct 2024 14:42:14 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42af3t848v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 14:42:14 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49GESP0S005374;
	Wed, 16 Oct 2024 14:42:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4285nj9p9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Oct 2024 14:42:13 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49GEg9OG50201004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Oct 2024 14:42:09 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82F3F20043;
	Wed, 16 Oct 2024 14:42:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E76B120040;
	Wed, 16 Oct 2024 14:42:08 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.85.190])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 16 Oct 2024 14:42:08 +0000 (GMT)
Message-ID: <6be1f3a5204df164753c7b5a28e179d21e2eda5d.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: Add library functions for
 exiting from snippet
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico =?ISO-8859-1?Q?B=F6hr?=
 <nrb@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Andrew
 Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Date: Wed, 16 Oct 2024 16:42:08 +0200
In-Reply-To: <D28R3KHKTK6E.36HBUYZEGH2YA@gmail.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	 <20240620141700.4124157-6-nsg@linux.ibm.com>
	 <D28R3KHKTK6E.36HBUYZEGH2YA@gmail.com>
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
X-Proofpoint-GUID: hsVnQcnTPoRvPSeVukd1jSK7Apz5zjf1
X-Proofpoint-ORIG-GUID: P-qW7Tz9I5XPuCTQZ1gfZ4xAxsNGS-VL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410160089

On Tue, 2024-06-25 at 12:43 +1000, Nicholas Piggin wrote:
> On Fri Jun 21, 2024 at 12:16 AM AEST, Nina Schoetterl-Glausch wrote:
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
> > ---
> >  s390x/Makefile                          |  1 +
> >  lib/s390x/asm/arch_def.h                | 13 ++++++++
> >  lib/s390x/snippet-guest.h               | 26 +++++++++++++++
> >  lib/s390x/{snippet.h =3D> snippet-host.h} | 10 ++++--
> >  lib/s390x/snippet-host.c                | 42 +++++++++++++++++++++++++
> >  lib/s390x/uv.c                          |  2 +-
> >  s390x/mvpg-sie.c                        |  2 +-
> >  s390x/pv-diags.c                        |  2 +-
> >  s390x/pv-icptcode.c                     |  2 +-
> >  s390x/pv-ipl.c                          |  2 +-
> >  s390x/sie-dat.c                         |  2 +-
> >  s390x/spec_ex-sie.c                     |  2 +-
> >  s390x/uv-host.c                         |  2 +-
> >  13 files changed, 97 insertions(+), 11 deletions(-)
> >  create mode 100644 lib/s390x/snippet-guest.h
> >  rename lib/s390x/{snippet.h =3D> snippet-host.h} (92%)
> >  create mode 100644 lib/s390x/snippet-host.c
> >=20
[...]

> > diff --git a/lib/s390x/snippet-guest.h b/lib/s390x/snippet-guest.h
> > new file mode 100644
> > index 00000000..3cc098e1
> > --- /dev/null
> > +++ b/lib/s390x/snippet-guest.h
> > @@ -0,0 +1,26 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Snippet functionality for the guest.
> > + *
> > + * Copyright IBM Corp. 2023
> > + */
> > +
> > +#ifndef _S390X_SNIPPET_GUEST_H_
> > +#define _S390X_SNIPPET_GUEST_H_
> > +
> > +#include <asm/arch_def.h>
> > +#include <asm/barrier.h>
> > +
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
> You have barriers here, but couldn't the diag get moved before a prior
> store by the guest?

Yeah, makes sense to add another before.
>=20
> Silly question since I don't understand the s390x arch or snippet design
> too well... the diag here causes a guest exit to the host. After the
> host handles that, it may resume guest at the next instruction? If that
> is correct, then the barrier here (I think) is for when the guest
> resumes it would not reorder subsequent loads from guest memory before
> the diag, because the host might have modified it.

[...]

> > diff --git a/lib/s390x/snippet-host.c b/lib/s390x/snippet-host.c
> > new file mode 100644
> > index 00000000..44a60bb9
> > --- /dev/null
> > +++ b/lib/s390x/snippet-host.c

[...]

> > +void snippet_check_force_exit_value(struct vm *vm, uint64_t value_exp)
> > +{
> > +	uint64_t value;
> > +
> > +	if (snippet_is_force_exit_value(vm)) {
> > +		value =3D snippet_get_force_exit_value(vm);
> > +		report(value =3D=3D value_exp, "guest forced exit with value (0x%lx =
=3D=3D 0x%lx)",
> > +		       value, value_exp);
>=20
> This is like kvm selftests guest/host synch design, which is quite
> nice and useful.
>=20
> > +	} else {
> > +		report_fail("guest forced exit with value");
> > +	}
>=20
> Guest forced exit without value?

It's this way round so the output reads:

FAIL: guest forced exit with value

What's after the colon is what failed and the message
is the same for PASS/FAIL. Indeed a bit confusing.

> And do you also need to check for non-value force
> exit to distinguish from a normal snippet exit?

No, the function does just this check and if you need to handle
more complicated situations you need to do that in the caller.

>=20
> Thanks,
> Nick


