Return-Path: <kvm+bounces-4536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 274DC813B2E
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 21:03:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D19DC1F225B3
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 20:03:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBE526A01C;
	Thu, 14 Dec 2023 20:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CxDxm+FC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF92697B9;
	Thu, 14 Dec 2023 20:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEIqAnu014262;
	Thu, 14 Dec 2023 20:03:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=x8XoeypXWZ9sNEFHxUhrm0suPboCMN4kuoiSzfdehZs=;
 b=CxDxm+FCfIoqcouqCoYS75SpQk/xrcx9EAzIVeEEbgwOH5zQny9cX9GLP1lWs3nnYl3m
 y9f6tdf2sHCGIHF5DNT352mx50yf6H8y/yU2jb9dKO7hFOVgUQMGB4vsjLDqn/vmztiM
 c6q8IolZEbMUiXe7Vo14x55djWogdtC+YdrdezD97E5/gHSBRPHsg0NMO5Nq2N4Mnktd
 4o1CQGDwfgQyABnwa+ulH8cEsN/sry6EoCitJQOYYD78ZuqHFHLAk5jx0znTxurHkwKB
 hiST3QY06ZW6cLa3Bhf0sKrRWEpAjngefXvF8sGNsZlzomh7tZ/cRkgmURrF75cBfKp9 Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v07c39sde-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Dec 2023 20:02:59 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3BEJKSdC015537;
	Thu, 14 Dec 2023 20:02:59 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3v07c39sch-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Dec 2023 20:02:59 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3BEJX3B0014819;
	Thu, 14 Dec 2023 20:02:58 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uw42khyfu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 14 Dec 2023 20:02:58 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3BEK2tsj10420826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Dec 2023 20:02:55 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E8B372004B;
	Thu, 14 Dec 2023 20:02:54 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B2D3720043;
	Thu, 14 Dec 2023 20:02:54 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 14 Dec 2023 20:02:54 +0000 (GMT)
Message-ID: <b61da0ed88a86d0823ac26d72f9914a7c392b415.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 3/5] s390x: Add library functions for
 exiting from snippet
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Nico =?ISO-8859-1?Q?B=F6hr?= <nrb@linux.ibm.com>,
        Thomas Huth
 <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Andrew Jones
 <andrew.jones@linux.dev>,
        David Hildenbrand <david@redhat.com>
Date: Thu, 14 Dec 2023 21:02:53 +0100
In-Reply-To: <20231213174222.542e11c6@p-imbrenda>
References: <20231213124942.604109-1-nsg@linux.ibm.com>
	 <20231213124942.604109-4-nsg@linux.ibm.com>
	 <20231213174222.542e11c6@p-imbrenda>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BEgDQ_ICxsHzdmvnWFzV6Tu-p3pG7yDz
X-Proofpoint-GUID: nrXwyXTR7dzykkA7dZ9jVI4yy-H1u5Nh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-14_13,2023-12-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312140143

On Wed, 2023-12-13 at 17:42 +0100, Claudio Imbrenda wrote:
> On Wed, 13 Dec 2023 13:49:40 +0100
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> > It is useful to be able to force an exit to the host from the snippet,
> > as well as do so while returning a value.
> > Add this functionality, also add helper functions for the host to check
> > for an exit and get or check the value.
> > Use diag 0x44 and 0x9c for this.
> > Add a guest specific snippet header file and rename the host's.
>=20
> you should also mention here that you are splitting snippet.h into a
> host-only part and a guest-only part

Well, I'm not splitting anything. Is it not clear that "the host's"
refers to snippet.h?

How about:
Add a guest specific snippet header file and rename snippet.h to reflect
that it is host specific.
>=20
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > ---
> >  s390x/Makefile                          |  1 +
> >  lib/s390x/asm/arch_def.h                | 13 ++++++++
> >  lib/s390x/sie.h                         |  1 +
> >  lib/s390x/snippet-guest.h               | 26 ++++++++++++++++
> >  lib/s390x/{snippet.h =3D> snippet-host.h} |  9 ++++--
> >  lib/s390x/sie.c                         | 28 +++++++++++++++++
> >  lib/s390x/snippet-host.c                | 40 +++++++++++++++++++++++++
> >  lib/s390x/uv.c                          |  2 +-
> >  s390x/mvpg-sie.c                        |  2 +-
> >  s390x/pv-diags.c                        |  2 +-
> >  s390x/pv-icptcode.c                     |  2 +-
> >  s390x/pv-ipl.c                          |  2 +-
> >  s390x/sie-dat.c                         |  2 +-
> >  s390x/spec_ex-sie.c                     |  2 +-
> >  s390x/uv-host.c                         |  2 +-
> >  15 files changed, 123 insertions(+), 11 deletions(-)
> >  create mode 100644 lib/s390x/snippet-guest.h
> >  rename lib/s390x/{snippet.h =3D> snippet-host.h} (93%)
> >  create mode 100644 lib/s390x/snippet-host.c
>=20
> [...]
>=20
> > diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> > index 40936bd2..908b0130 100644
> > --- a/lib/s390x/sie.c
> > +++ b/lib/s390x/sie.c
> > @@ -42,6 +42,34 @@ void sie_check_validity(struct vm *vm, uint16_t vir_=
exp)
> >  	report(vir_exp =3D=3D vir, "VALIDITY: %x", vir);
> >  }
> > =20
> > +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
> > +{
> > +	uint32_t ipb =3D vm->sblk->ipb;
> > +	uint64_t code;
>=20
> uint64_t code =3D 0;
>=20
> > +	uint16_t displace;
> > +	uint8_t base;
> > +	bool ret =3D true;
>=20
> bool ret;
>=20
> > +
> > +	ret =3D ret && vm->sblk->icptcode =3D=3D ICPT_INST;
> > +	ret =3D ret && (vm->sblk->ipa & 0xff00) =3D=3D 0x8300;
>=20
> ret =3D vm->sblk->icptcode =3D=3D ICPT_INST && (vm->sblk->ipa & 0xff00) =
=3D=3D
> 0x8300;

(*) see below
>=20
> > +	switch (diag) {
> > +	case 0x44:
> > +	case 0x9c:
> > +		ret =3D ret && !(ipb & 0xffff);
> > +		ipb >>=3D 16;
> > +		displace =3D ipb & 0xfff;
>=20
> maybe it's more readable to avoid shifting thigs around all the time:

I don't know, now I gotta be able to do rudimentary arithmetic :D
I don't really have a preference.
I wonder if defining a bit field would be worth it.
>=20
> displace =3D (ipb >> 16) & 0xfff;
> base =3D (ipb >> 28) & 0xf;
> if (base)
> 	code =3D vm->....[base];
> code =3D (code + displace) & 0xffff;
> if (ipb & 0xffff || code !=3D diag)
> 	return false;
>=20
> > +		ipb >>=3D 12;
> > +		base =3D ipb & 0xf;
> > +		code =3D base ? vm->save_area.guest.grs[base] + displace : displace;
> > +		code &=3D 0xffff;
> > +		ret =3D ret && (code =3D=3D diag);
> > +		break;
> > +	default:
> > +		abort(); /* not implemented */
> > +	}
> > +	return ret;
>=20
> although I have the feeling that this would be more readable if you
> would check diag immediately, and avoid using ret

Not sure what you mean, do you want an early return at (*)?
>=20
> > +}
> > +
> >  void sie_handle_validity(struct vm *vm)
> >  {
> >  	if (vm->sblk->icptcode !=3D ICPT_VALIDITY)
> > diff --git a/lib/s390x/snippet-host.c b/lib/s390x/snippet-host.c
> > new file mode 100644
> > index 00000000..a829c1d5
> > --- /dev/null
> > +++ b/lib/s390x/snippet-host.c
> > @@ -0,0 +1,40 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * Snippet functionality for the host.
> > + *
> > + * Copyright IBM Corp. 2023
> > + */
> > +
> > +#include <libcflat.h>
> > +#include <snippet-host.h>
> > +#include <sie.h>
> > +
> > +bool snippet_check_force_exit(struct vm *vm)
> > +{
> > +	bool r;
> > +
> > +	r =3D sie_is_diag_icpt(vm, 0x44);
> > +	report(r, "guest forced exit");
> > +	return r;
> > +}
> > +
> > +bool snippet_get_force_exit_value(struct vm *vm, uint64_t *value)
> > +{
> > +	struct kvm_s390_sie_block *sblk =3D vm->sblk;
> > +
> > +	if (sie_is_diag_icpt(vm, 0x9c)) {
> > +		*value =3D vm->save_area.guest.grs[(sblk->ipa & 0xf0) >> 4];
> > +		report_pass("guest forced exit with value: 0x%lx", *value);
> > +		return true;
> > +	}
> > +	report_fail("guest forced exit with value");
> > +	return false;
> > +}
> > +
> > +void snippet_check_force_exit_value(struct vm *vm, uint64_t value_exp)
> > +{
> > +	uint64_t value;
> > +
> > +	if (snippet_get_force_exit_value(vm, &value))
> > +		report(value =3D=3D value_exp, "guest exit value matches 0x%lx", val=
ue_exp);
> > +}
>=20
> from a readability and a consistency perspective, it would be better if
> the functions would only check stuff and return a bool or a value, and
> do the report() in the body of the testcase

Hmm, I chose to do the report in order to be consistent with check_pgm_int_=
code.
>=20
>=20
> [...]


