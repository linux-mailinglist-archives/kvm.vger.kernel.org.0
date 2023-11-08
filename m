Return-Path: <kvm+bounces-1151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A795A7E5362
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 11:30:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6238F2813C4
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 10:30:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DCCA12E71;
	Wed,  8 Nov 2023 10:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lRc5JuB6"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559DD12E4D
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 10:30:33 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1E0A1BD5;
	Wed,  8 Nov 2023 02:30:32 -0800 (PST)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8AGWAD013720;
	Wed, 8 Nov 2023 10:30:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JxD6UsZLe36ltZ0rNgJGKFFWHZcKzNR731kYjwylHyI=;
 b=lRc5JuB61Um9cI4HX3B2T9yFh4HsRazaBA4v2Uy3Cv9Px26aMil6fEiIfKSdUHR2jkMq
 pLqYOZfDlI4xI61Wr5DfAo8+1qrWoZVVbChP/6t9Xi81j3r4p5IWFc88dOaaozXlII5e
 b1m56M5Nt1Hut+mwyPCfpMP9rMtngyVeR5dqWO1E+6UDulv7iT2f0L+iwidE+adSke28
 kDNmNKLiSFPOPp3K/n2BaIVK9OiIy4XIzYhBlSXiTl5H4FU66rFUUcsRXlrV45BNJsKh
 yR/PfAZURcpqR8ZfPIIkk1QWjSu/0wRKAHsbwiQQi0FIrsrQYSAL2iOzi/rznh89+Tf9 Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u87xb1k64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 10:30:31 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8AGmFo015381;
	Wed, 8 Nov 2023 10:30:31 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u87xb1k56-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 10:30:31 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A88aJi6014346;
	Wed, 8 Nov 2023 10:30:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w21v2hh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 10:30:29 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8AUQlq16712262
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Nov 2023 10:30:26 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E21920043;
	Wed,  8 Nov 2023 10:30:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0082D20040;
	Wed,  8 Nov 2023 10:30:26 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.7.102])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Nov 2023 10:30:25 +0000 (GMT)
Message-ID: <2fb17d9dd20078bc995887a3699dd008403b50ff.camel@linux.ibm.com>
Subject: Re: [PATCH v2 2/4] KVM: s390: vsie: Fix length of facility list
 shadowed
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sven Schnelle
 <svens@linux.ibm.com>
Date: Wed, 08 Nov 2023 11:30:09 +0100
In-Reply-To: <20231107181105.3143f8f7@p-imbrenda>
References: <20231107123118.778364-1-nsg@linux.ibm.com>
	 <20231107123118.778364-3-nsg@linux.ibm.com>
	 <20231107181105.3143f8f7@p-imbrenda>
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
X-Proofpoint-ORIG-GUID: CWqPo0BzzopFjjGXcga64nJgDxYb6cCD
X-Proofpoint-GUID: uKiAAS3c2GRpL9iGBVEc7Vd1gtaLD-Bo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_01,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=606
 bulkscore=0 malwarescore=0 adultscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080087

On Tue, 2023-11-07 at 18:11 +0100, Claudio Imbrenda wrote:
> On Tue,  7 Nov 2023 13:31:16 +0100
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
>=20
> [...]
>=20
> > -obj-y	+=3D smp.o text_amode31.o stacktrace.o abs_lowcore.o
> > +obj-y	+=3D smp.o text_amode31.o stacktrace.o abs_lowcore.o facility.o
> > =20
> >  extra-y				+=3D vmlinux.lds
> > =20
> > diff --git a/arch/s390/kernel/facility.c b/arch/s390/kernel/facility.c
> > new file mode 100644
> > index 000000000000..5e80a4f65363
> > --- /dev/null
> > +++ b/arch/s390/kernel/facility.c
>=20
> I wonder if this is the right place for this?

I've wondered the same :D
>=20
> This function seems to be used only for vsie, maybe you can just move
> it to vsie.c? or do you think it will be used elsewhere too?

It's a general STFLE function and if I put it into vsie.c I'm not sure
that, if the same functionality was required somewhere else, it would be
found and moved to a common location.

I was also somewhat resistant to calling a double underscore function from
vsie.c. Of course I could implement it with my own inline asm...

The way I did it seemed nicest, but if someone else has a strong opinion
I'll defer to that.
>=20
> [...]


