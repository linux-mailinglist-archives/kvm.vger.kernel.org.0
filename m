Return-Path: <kvm+bounces-34754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EE92A0554F
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 09:27:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 838503A1F1A
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 08:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1BA1E1A2B;
	Wed,  8 Jan 2025 08:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YyCZ9rh/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FBC1B0433;
	Wed,  8 Jan 2025 08:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736324858; cv=none; b=Uprp5Bk5zdp7O1OaLTq65OZsxk1D+XdTv0tvX+R/c8JpZ0QxFZ5laCcsVWqm4qToLuzggQstw+td687U2NsvUX5CjtZwNZ9WWOeCM064Hm9851DAl/ynkC758lzY8VXAZU6Uic7S3QnQErZ58AT3arRDwN++kvArPKsVNrtBF10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736324858; c=relaxed/simple;
	bh=6z56hOhGs7RA1JlAlzTmWzZJD+rp5GBOOiWJE93mRnM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=YvJg6JAnzYt5kfyxOs+0or1Y1gp87CSQvY1/ocOMIa4dNsu7UzelleGSx89oMlZVL4pDQydRD2GZm5ZlIaylnKbA/cVEX0iAcNuAmV3Jo3OD9sUA0okVKmZX4G9S62Dc1W21WC1FLVLjZxHwiwOcNgfpLgaAAUbkNs1Cvw7feNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YyCZ9rh/; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5083qeT0015976;
	Wed, 8 Jan 2025 08:27:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=6z56hO
	hGs7RA1JlAlzTmWzZJD+rp5GBOOiWJE93mRnM=; b=YyCZ9rh/oj3XkQiiw/mz+p
	LMVPh4/MfJE+FmqHGzYo+GJU7SaM6z/FQLeQrL1rnR9m1JlEsqjhPB2uoo1fR1i/
	XeahgJp5Yh4BlGcU8eh0gnEyglz+n4ON2LvytefdawSnhSQEZrYZfDQWPB7lIBQd
	rW88chUsXV87o5h1X0qwxrYPRpCXK724e+gEC1IZKHZW6qbvAjtRP1BLzI4mocoi
	3F8nfbI6YcXDqWPbJZzaancbQoyEPDygQyeeOtlBO4MCyPkdb1XYp0Pu3OBNF7Oo
	tULVXDcynfHiytO8SiwUclpggEOoy942gsdGZTBb0xWYmLL/w1KoHNAhaYvgazPg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441huc12q3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 08:27:28 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 5088RRkp024375;
	Wed, 8 Jan 2025 08:27:27 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441huc12q0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 08:27:27 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5084oh62008861;
	Wed, 8 Jan 2025 08:27:26 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43yfpyxwj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 08:27:26 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5088RMTL57016684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 08:27:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B09F62004B;
	Wed,  8 Jan 2025 08:27:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 456FE20040;
	Wed,  8 Jan 2025 08:27:21 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.24.235])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 08:27:21 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 Jan 2025 09:27:20 +0100
Message-Id: <D6WJSC67OTP3.2QL240O0BQNGK@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 4/6] s390x: Add library functions for
 exiting from snippet
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>,
        "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>,
        "Thomas Huth" <thuth@redhat.com>,
        "Janosch Frank"
 <frankja@linux.ibm.com>
Cc: "David Hildenbrand" <david@redhat.com>, <kvm@vger.kernel.org>,
        "Nicholas
 Piggin" <npiggin@gmail.com>, <linux-s390@vger.kernel.org>
X-Mailer: aerc 0.18.2
References: <20241016180320.686132-1-nsg@linux.ibm.com>
 <20241016180320.686132-5-nsg@linux.ibm.com>
 <D67Y11RRNUJ4.3U17EAZFWQR6M@linux.ibm.com>
 <fcc8d46283daa6922c90328a1a8a36b528530166.camel@linux.ibm.com>
In-Reply-To: <fcc8d46283daa6922c90328a1a8a36b528530166.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: AEPIsKA2Ns_lm0_AOx9CAmhJbjkFgwRz
X-Proofpoint-GUID: DuAEOOGuEV6gKyPS4V8lc84UPMUZYZ9P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=727
 bulkscore=0 mlxscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080064

On Thu Dec 12, 2024 at 4:33 PM CET, Nina Schoetterl-Glausch wrote:
> On Tue, 2024-12-10 at 11:20 +0100, Nico Boehr wrote:
> > On Wed Oct 16, 2024 at 8:03 PM CEST, Nina Schoetterl-Glausch wrote:
> > > It is useful to be able to force an exit to the host from the snippet=
,
> > > as well as do so while returning a value.
> > > Add this functionality, also add helper functions for the host to che=
ck
> > > for an exit and get or check the value.
> > > Use diag 0x44 and 0x9c for this.
> > > Add a guest specific snippet header file and rename snippet.h to refl=
ect
> > > that it is host specific.
> > >=20
> > > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> >=20
> > Hi Nina,
> >=20
> > would you mind if I fix this up like this?
>
> Looks good to me.
> Thanks!

Alright, thanks. It's now in the CI for coverage. When no issues come up, I=
 will pick it.

