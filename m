Return-Path: <kvm+bounces-20455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0545915F83
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 09:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AD11284D4F
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 07:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA7661494D1;
	Tue, 25 Jun 2024 07:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ihn+IZGF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CF114901B;
	Tue, 25 Jun 2024 07:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719299186; cv=none; b=SJWa4p3WuHtfpFzaqS9BENvHv5HxfPsm+ptXPs6l0wp8axHlUTXTTKA6u+hC/EyuHtukYHmMYP10hKXhwXe6oO20dKIxsERmOzzWVQUdTIPRuBSa9BhExZFiQaURtb+9DxvumicHKzg9364yLD4uHz6axlmAR/kw4gbrQCD+uyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719299186; c=relaxed/simple;
	bh=ID8U5OSxgYwXxSbviBAOTbMQBsuBvXwx/c289TgPnYI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j/zFI7ub8L8vBL0EKkk0ovLBg5oVkgtGgkAbarz/MUfwxCYKnJbPu8EfnVgD5EfGmUzhTzycoEcf8DfCWkMr5hO9PVzLyFOMcgDwoR1ED9sQz54xpq9Ll+4tRX2eVYCDf+RBJ8+onoEwJsZN4qkOasXf5GCIu7ogXIh/yR1I3YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ihn+IZGF; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45P6plPX006771;
	Tue, 25 Jun 2024 07:06:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	message-id:subject:from:to:cc:date:in-reply-to:references
	:content-type:content-transfer-encoding:mime-version; s=pp1; bh=
	0dh98OiGcjyBRxaeJW5dhBodNCgsPnObIIsCgSMn8ZI=; b=ihn+IZGF6aFK1xEj
	ByNBVSVhJNhaai/SvwlJ/rZtSw1JkHbsMn6lZdYPpqqHSWypYlEmZ9/qnCnSlPrV
	iLfjrTqZ2ZKdy9ZlgXaykRWp4EWBjRIUF7G/BDFRKYE6o6c+luECJHneXlIlI+1D
	gZOQiVZaG3DI1PHLco1eB6xGX7uAx+c/X2+lMhY0o7PPn9QsQ/inwqL1L+L21Ix5
	Mq893YvptIblLlQ+hJ7apxQlxYXQB9/k+zhdajPLB8/poQq9QPS1FPMKkHJG9BL2
	kYZNzGCZbZj1c2cRBPVCOStJJD8GPzsNAUnrpuElHZgT84zIB2iVDk91vaUgTI+B
	ni522A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yyr7c85jr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Jun 2024 07:06:12 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45P76CRj032186;
	Tue, 25 Jun 2024 07:06:12 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yyr7c85jp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Jun 2024 07:06:12 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45P6nU2T008229;
	Tue, 25 Jun 2024 07:06:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yx9b0n844-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 25 Jun 2024 07:06:11 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45P7654l53084448
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Jun 2024 07:06:07 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6BC5C2004E;
	Tue, 25 Jun 2024 07:06:05 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D82CA20040;
	Tue, 25 Jun 2024 07:06:04 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.171.29.84])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 25 Jun 2024 07:06:04 +0000 (GMT)
Message-ID: <3d4335edb1091bbf91d8329a152f006003930b60.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/7] lib: Add pseudo random functions
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, Nico Boehr <nrb@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, Andrew Jones <andrew.jones@linux.dev>
Cc: linux-s390@vger.kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank
 <frankja@linux.ibm.com>, kvm@vger.kernel.org
Date: Tue, 25 Jun 2024 09:06:04 +0200
In-Reply-To: <D28RMVNELBHS.HJUXVDHDPAC4@gmail.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	 <20240620141700.4124157-2-nsg@linux.ibm.com>
	 <D28RMVNELBHS.HJUXVDHDPAC4@gmail.com>
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
X-Proofpoint-GUID: uAFWB8ndUoUx9H6j1fpkdcsmUvqsz8S7
X-Proofpoint-ORIG-GUID: eNEctS8mlVLUv_3oEtbmkvOc47nQKMO_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-25_03,2024-06-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 phishscore=0 priorityscore=1501 mlxlogscore=727 bulkscore=0 clxscore=1015
 mlxscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406250051

On Tue, 2024-06-25 at 13:08 +1000, Nicholas Piggin wrote:
> On Fri Jun 21, 2024 at 12:16 AM AEST, Nina Schoetterl-Glausch wrote:

[...]

> >     I tested the implementation in the following way:
> >    =20
> >     cat <<'EOF' > rand.py
> >     #!/usr/bin/python3
> >    =20
> >     def prng32(seed):
> >         from hashlib import sha256
> >         state =3D seed.to_bytes(8, byteorder=3D"big")
> >         while True:
> >             state =3D sha256(state).digest()
> >             for i in range(8):
> >                 yield int.from_bytes(state[i*4:(i+1)*4], byteorder=3D"b=
ig")
> >    =20
> >     r =3D prng32(0)
> >     for i in range(100):
> >         print(f"{next(r):08x}")
> >    =20
> >     EOF
> >    =20
> >     cat <<'EOF' > rand.c
> >     #include <stdio.h>
> >     #include "rand.h"
> >    =20
> >     void main(void)
> >     {
> >     	prng_state state =3D prng_init(0);
> >     	for (int i =3D 0; i < 100; i++) {
> >     		printf("%08x\n", prng32(&state));
> >     	}
> >     }
> >     EOF
> >     cat <<'EOF' > libcflat.h
> >     #define ARRAY_SIZE(_a) (sizeof(_a)/sizeof((_a)[0]))
> >     EOF
> >     chmod +x rand.py
> >     ln -s lib/rand.c librand.c
> >     gcc -Ilib librand.c rand.c
> >     diff <(./a.out) <(./rand.py)
>=20
> Cool... you made a unit test for the unit tests. We could start a
> make check? :)

I wouldn't complain about it, but my test is a bit hacky and I don't
expect the code to get touched much.
>=20
> Acked-by: Nicholas Piggin <npiggin@gmail.com>
>=20
> Thanks,
> Nick


