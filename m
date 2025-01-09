Return-Path: <kvm+bounces-34901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0489A07237
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 10:55:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4B7A167CC2
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2025 09:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA20821771B;
	Thu,  9 Jan 2025 09:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="i6dZ7MS8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A8E215187;
	Thu,  9 Jan 2025 09:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736416276; cv=none; b=rSTrC9kSnkZrcsVvreTrpG+GLolZWCi19FfOvKjYAx6xTzy5cuBo3o/pmF0P4LHskz3l1U+v0k84GzDn1vbgIpR+oLT4r45iCm6qU5xD7i1SgZnsCSv/ozixJP/Su6lRbgCE/b5xAq8C0lsjxXIAS8fXdoQkXeF4AdIF7+eahlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736416276; c=relaxed/simple;
	bh=Gg+Y5yDS6mn0qrYlJhaeEfkWDq/ZXijycyjez1j1x+s=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=R9jLdvWc9EfSAB5LJvW3XUU2t61HE/Nj3A0FMkO4fPciB/hHkSvZuvU6m0C//G1ORt5dJlCHQwC+LyCxpMCTQ8KenokHPmlksYr1xTBeMZ5YlEISsK05N8Jnvm/c+ybhSv/h5J4V6d1RQ9+u3I6r/j3VYx/pk85HUyyPmNlB7n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=i6dZ7MS8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5093shRD009879;
	Thu, 9 Jan 2025 09:51:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JTtRDv
	KOF4kAHsP+hDLCC9JccbrM01VfizVNYVFgGjY=; b=i6dZ7MS8GjxJ1JoXcPN6A8
	EYLCcDqKsF2gvFa9ef7Exx3QRPh9o8ED+q0aSOQA1SNHX77/bj31hyOKugFSYzee
	UwisfoSS3rcOdgpD9AG1BLENAPNDSNd+u1skkc5BYoJXUQUyS3zvRq/CRgI4xsX2
	3aBXOQzo8HAgEDdmXcDSHtHMcNtigrGrinjMVWcu8/5mGmPq++/ccO0DDyM5DLIE
	SaHH+WbNhquTor63o1kMNMhD5G3p/sBD34Bz30NgUbrvg/Vdgx1yb0IIwD3/4guw
	R3VqWfxLtmOsJgkIR14m8qrFgdmlcQxtavlbHgN1yLsUl+pIf8Epj2RyrMjf8v8A
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4426xc9e43-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 09:51:12 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50994R8F013576;
	Thu, 9 Jan 2025 09:51:11 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygap4fyd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Jan 2025 09:51:11 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5099p54k45285866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Jan 2025 09:51:05 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D7A420043;
	Thu,  9 Jan 2025 09:51:05 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5054E20040;
	Thu,  9 Jan 2025 09:51:05 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.13.177])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Jan 2025 09:51:05 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 09 Jan 2025 10:51:05 +0100
Message-Id: <D6XG6ZSJ22ZU.1UDCOZQS6KUBP@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <thuth@redhat.com>, <david@redhat.com>, <schlameuss@linux.ibm.com>,
        <linux-s390@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 3/3] s390x: pv: Add test for large
 host pages backing
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>
X-Mailer: aerc 0.18.2
References: <20241218135138.51348-1-imbrenda@linux.ibm.com>
 <20241218135138.51348-4-imbrenda@linux.ibm.com>
 <D6GMPV211UPF.CC1OSNJYEJ6T@linux.ibm.com>
 <20241220165224.3307fbf4@p-imbrenda>
In-Reply-To: <20241220165224.3307fbf4@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VMIwGD-hqSBVKszyq2mNP4dD0Qn45wmf
X-Proofpoint-ORIG-GUID: VMIwGD-hqSBVKszyq2mNP4dD0Qn45wmf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxlogscore=870 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2411120000 definitions=main-2501090076

On Fri Dec 20, 2024 at 4:52 PM CET, Claudio Imbrenda wrote:
[...]
> > > diff --git a/s390x/snippets/c/pv-memhog.c b/s390x/snippets/c/pv-memho=
g.c
> > > new file mode 100644
> > > index 00000000..43f0c2b1
> > > --- /dev/null
> > > +++ b/s390x/snippets/c/pv-memhog.c
> > > @@ -0,0 +1,59 @@ =20
> > [...]
> > > +int main(void)
> > > +{
> > > +	uint64_t param, addr, i, n;
> > > +
> > > +	READ_ONCE(*MIDPAGE_PTR(SZ_1M + 42 * PAGE_SIZE));
> > > +	param =3D get_value(42); =20
> >=20
> > (see below)
> >=20
> > > +	n =3D (param >> 32) & 0x1fffffff;
> > > +	n =3D n ? n : N_PAGES;
> > > +	param &=3D 0x7fffffff;
> > > +
> > > +	while (true) {
> > > +		for (i =3D 0; i < n; i++) {
> > > +			addr =3D ((param ? i * param : i * i * i) * PAGE_SIZE) & MASK_2G;
> > > +			WRITE_ONCE(*MIDPAGE_PTR(addr), addr);
> > > +		}
> > > +
> > > +		i =3D get_value(23);
> > > +		if (i !=3D 42) =20
> >=20
> > I would like some defines for 23 and 42 and possibly share them with th=
e host.
>
> not sure what's the easiest way to share with the host, but I can just
> copy the defines

The sie-dat.c test does this, there's a header file

s390x/snippets/c/sie-dat.h

which is included in the host:

#include "snippets/c/sie-dat.h"

Not the most beautiful way, but works.

