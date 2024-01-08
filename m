Return-Path: <kvm+bounces-5813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ADCE826F1C
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 13:59:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E66DE282D72
	for <lists+kvm@lfdr.de>; Mon,  8 Jan 2024 12:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9845A4120F;
	Mon,  8 Jan 2024 12:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y5UKS6ye"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63ADF44C78;
	Mon,  8 Jan 2024 12:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 408CvCXQ021402;
	Mon, 8 Jan 2024 12:58:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=o/BZdwKio59MpEVALHEdqVrP8YrgB1d2qWjWRvbjbLY=;
 b=Y5UKS6ye4dDVOjomoF6apwWIMWJc0s7KjzBob0OtCz7qkPParXXlg7RfNlAVC51xY3pE
 pWLGFkjGFgWvbtv0D2ZuKaRlQDh82sP1JONNMLLmWFgOejQeKF+0/9BbIkZ6BzUxj50q
 np5OzxeeDAkziTCF7dRsMOWWWNKCXuf8EDJ/REe2MbnDAvlA9I+W13ncowhx6sHBUBeU
 oufEHknRxTYgpTkTpsfglcmE4w1s8fJv5bi+95qAvw+Rhzb8NbLeqpjZHvGHbfPtVTHl
 VHvIzri8dDgTL1iOzIvwEL62o9NRlt0i8SXLLvNntYYGBP6NOefvKB8IM1qbI6iGZAmU zQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vghgk01cq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 12:58:41 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 408CwCC1025290;
	Mon, 8 Jan 2024 12:58:41 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vghgk01bp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 12:58:41 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 408Ape1I027254;
	Mon, 8 Jan 2024 12:58:40 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vfkw1qg6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jan 2024 12:58:40 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 408CwbLN64028944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Jan 2024 12:58:37 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A6B820043;
	Mon,  8 Jan 2024 12:58:37 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E635920040;
	Mon,  8 Jan 2024 12:58:36 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.24.160])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Jan 2024 12:58:36 +0000 (GMT)
Message-ID: <00dc269c9a487b4601fc27c97771240e0b407ff6.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 3/5] s390x: Add library functions for
 exiting from snippet
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda
	 <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Nico Boehr
	 <nrb@linux.ibm.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, linux-s390@vger.kernel.org,
        David
	Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Date: Mon, 08 Jan 2024 13:58:36 +0100
In-Reply-To: <1f78218f-f67b-4d99-83d7-2b18455b2519@linux.ibm.com>
References: <20240105225419.2841310-1-nsg@linux.ibm.com>
	 <20240105225419.2841310-4-nsg@linux.ibm.com>
	 <1f78218f-f67b-4d99-83d7-2b18455b2519@linux.ibm.com>
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
X-Proofpoint-GUID: 351Nv6W-gIWw5qT9YAvNQoNOAG-8q_VB
X-Proofpoint-ORIG-GUID: yQjxqPq-4xTgeXNGamDofqmaTHWK5KxL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-08_04,2024-01-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 suspectscore=0 mlxlogscore=787 clxscore=1015
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401080111

On Mon, 2024-01-08 at 13:47 +0100, Janosch Frank wrote:
> On 1/5/24 23:54, Nina Schoetterl-Glausch wrote:
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
> >   s390x/Makefile                          |  1 +
> >   lib/s390x/asm/arch_def.h                | 13 ++++++++
> >   lib/s390x/sie.h                         |  1 +
> >   lib/s390x/snippet-guest.h               | 26 +++++++++++++++
> >   lib/s390x/{snippet.h =3D> snippet-host.h} | 10 ++++--
> >   lib/s390x/sie.c                         | 31 ++++++++++++++++++
> >   lib/s390x/snippet-host.c                | 42 ++++++++++++++++++++++++=
+
> >   lib/s390x/uv.c                          |  2 +-
> >   s390x/mvpg-sie.c                        |  2 +-
> >   s390x/pv-diags.c                        |  2 +-
> >   s390x/pv-icptcode.c                     |  2 +-
> >   s390x/pv-ipl.c                          |  2 +-
> >   s390x/sie-dat.c                         |  2 +-
> >   s390x/spec_ex-sie.c                     |  2 +-
> >   s390x/uv-host.c                         |  2 +-
> >   15 files changed, 129 insertions(+), 11 deletions(-)
> >   create mode 100644 lib/s390x/snippet-guest.h
> >   rename lib/s390x/{snippet.h =3D> snippet-host.h} (92%)
> >   create mode 100644 lib/s390x/snippet-host.c

[..]
=20
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
> > +	uint64_t code;
> > +
> > +	assert(diag =3D=3D 0x44 || diag =3D=3D 0x9c);
>=20
> You're calling it is_diag_icpt and only allow two.
> Do you have a reason for clamping this down?

I should have left the comment.
They're just "not implemented".
The PoP doesn't specify how diags are generally interpreted,
so I intended that if any other diags are needed whoever needs them
just checks if the existing logic works or if changes are required.
>=20
> I was considering consolidating pv_icptdata_check_diag() into this.


