Return-Path: <kvm+bounces-753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 163907E2375
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 14:12:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3D7F28156A
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 13:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1432420B16;
	Mon,  6 Nov 2023 13:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eWncM/lW"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4058B1EB5B
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 13:11:53 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D45123;
	Mon,  6 Nov 2023 05:11:51 -0800 (PST)
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6DBJGD007396;
	Mon, 6 Nov 2023 13:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=HJaFqYDEX3kALLXIIeuGw1TiOk7dJ/xUW58eZSygfwQ=;
 b=eWncM/lWXeOn6ril255ahNxfkvQrqRtoiiXVW+g9TyrgEPLOkC0VbZksXWmk1OFPf3OI
 R/IKQu3Ww27kHj/buu8g8SRTyqCIbFcqypL6dRj6S8XTwJWLdEk35XekWsqIvjxmOltA
 IyJAbh72Az5GMlpXrIofzdZ9Mq048XmHNwNWGDLoSCqWEM+yBhjNH0q7y+uVH1txVJkc
 sAVuRtV/Dkg73ljCn4roU49ICelDbZsuCWAQpxvHspYIGjlpPUCTHGTgJkixsWpz722L
 FX3pGRfgr3BthLiMCglpw01ti4UaDwgDhbiy6It3JnS8bJSmJPTD/7t6Ittub/C0wUTc 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6v2cgxp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 13:11:50 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6DBMBC007704;
	Mon, 6 Nov 2023 13:11:22 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6v2cgw55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 13:11:21 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6BFAfB025600;
	Mon, 6 Nov 2023 13:06:30 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u619n9c69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 13:06:30 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6D6NxT26346124
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 13:06:23 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EBC72004B;
	Mon,  6 Nov 2023 13:06:23 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E227E20040;
	Mon,  6 Nov 2023 13:06:22 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.179.20.192])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 13:06:22 +0000 (GMT)
Message-ID: <c78b345b9b59197cad89a661095f5f3d1e0d0718.camel@linux.ibm.com>
Subject: Re: [PATCH 2/4] KVM: s390: vsie: Fix length of facility list
 shadowed
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik
 <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-s390@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Mueller <mimu@linux.vnet.ibm.com>
Date: Mon, 06 Nov 2023 14:06:22 +0100
In-Reply-To: <c05841de-d1d9-406b-a143-f1e3662d99b9@redhat.com>
References: <20231103173008.630217-1-nsg@linux.ibm.com>
	 <20231103173008.630217-3-nsg@linux.ibm.com>
	 <c05841de-d1d9-406b-a143-f1e3662d99b9@redhat.com>
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
X-Proofpoint-GUID: NFBuleUfpl0A5RdcDYsMtUWD7pt_1J65
X-Proofpoint-ORIG-GUID: r0q_Ym5a6BFu19GXALQXc3W3yTrUqtMb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 priorityscore=1501 adultscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060107

On Fri, 2023-11-03 at 19:34 +0100, David Hildenbrand wrote:
> On 03.11.23 18:30, Nina Schoetterl-Glausch wrote:
> > The length of the facility list accessed when interpretively executing
> > STFLE is the same as the hosts facility list (in case of format-0)
> > When shadowing, copy only those bytes.
> > The memory following the facility list need not be accessible, in which
> > case we'd wrongly inject a validity intercept.
> >=20
> > Fixes: 66b630d5b7f2 ("KVM: s390: vsie: support STFLE interpretation")
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> > ---
> >   arch/s390/include/asm/facility.h |  6 ++++++
> >   arch/s390/kernel/Makefile        |  2 +-
> >   arch/s390/kernel/facility.c      | 18 ++++++++++++++++++
> >   arch/s390/kvm/vsie.c             | 12 +++++++++++-
> >   4 files changed, 36 insertions(+), 2 deletions(-)
> >   create mode 100644 arch/s390/kernel/facility.c

[...]

> > diff --git a/arch/s390/kernel/facility.c b/arch/s390/kernel/facility.c

[...]

> > +#include <asm/facility.h>
> > +
> > +unsigned int stfle_size(void)
> > +{
> > +	static unsigned int size =3D 0;
> > +	u64 dummy;
> > +
> > +	if (!size) {
> > +		size =3D __stfle_asm(&dummy, 1) + 1;
> > +	}
> > +	return size;
> > +}
> > +EXPORT_SYMBOL(stfle_size);
>=20
> Possible races? Should have to use an atomic?

Good point. Calling __stfle_asm multiple times is fine
and AFAIK torn reads/writes aren't possible. I don't see a way
for the compiler to break things either.
But it might indeed be nicer to use an atomic, without
any downsides.

>=20
> No access to documentation, but sounds plausible.
>=20
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks!

