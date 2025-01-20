Return-Path: <kvm+bounces-36025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E15A16F67
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 16:40:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 193BD16A10F
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 15:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67D331E9B00;
	Mon, 20 Jan 2025 15:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mZC/U5z+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEED1E8855;
	Mon, 20 Jan 2025 15:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737387647; cv=none; b=aQvSyV4tAPhWAb1En2yxdCsGxAy135/3+IycpGhyDvq3xXOAh2pKzkmZTfc8TE3DBq3BQLY3/gDWQfwc9b5XLOAi6fp+urF0BK+fZyX70Jh82PTdInU04kSOQcZUEvqDA3kXmpG6fnxlwjeN73Y1KpmpYDW68UNxrjl7R32rLrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737387647; c=relaxed/simple;
	bh=p3k6hMIdOCFNd2zmxZoARSrM7vesb/4M8e1X5W+vZqE=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=A96nysA+lebofV0yMlyvhbTtB5DOr+xrY7MXJR3zi6FXHlx5PlCWeJ/VaKvc27UlSNTUIKYgxVEkI4jegEAx35BsC7J5U/ty8pAU13A1Bj8LR0FPSlCI4zZ0QvfO0dFm0qE2fCprgzoLVvUvOZTXB9ZPuszw/mlLugCfGTDdkV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mZC/U5z+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50K7XQm8011244;
	Mon, 20 Jan 2025 15:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7hn4hf
	Z/HBzj4C7zAubInJBhSStyhZJH3Q64RSJvCy0=; b=mZC/U5z+J6QW2zAvVDKwyc
	U4u9VGs17Nzuhb0tZzlOcinkU7PeYTv4/5NDHE34LnX+PEOjtu5S4QyxN1Y+sPH5
	Im5yhiklyDRpMG6IjzZzEXTFQVEUcEsP+b+RZsOaewdQIRCGNiez8MNAeO7iFsIQ
	XmoWOj0H3CNFivO3+jNpT7+FGFP4IeDhUpUR/ZQm3qm6KJH++1oLr89MWyAOpIQz
	w2HO7zhm7pGRAGSbTpT561XDnkeVl367Wishqa2UK5D/JywWdzfBrKtSgEcaHnRr
	ch0DxQhCoQq7SI4q8ottlg07UiynP+Hb/REz9JKW9bRJ8eo+I/5Qr4F8Spfspk4Q
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 449j6na4c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:40:40 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50KFZ1sN022772;
	Mon, 20 Jan 2025 15:40:40 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 449j6na4by-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:40:39 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50KF2TUj019330;
	Mon, 20 Jan 2025 15:40:39 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 448pms755u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jan 2025 15:40:39 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50KFeZSm31392214
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jan 2025 15:40:35 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A13F20043;
	Mon, 20 Jan 2025 15:40:35 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70DDF20040;
	Mon, 20 Jan 2025 15:40:35 +0000 (GMT)
Received: from darkmoore (unknown [9.171.4.105])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 20 Jan 2025 15:40:35 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 20 Jan 2025 16:40:30 +0100
Message-Id: <D770IISGV0WG.2QZ4BTF9VJHND@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <frankja@linux.ibm.com>, <borntraeger@de.ibm.com>,
        <willy@infradead.org>, <hca@linux.ibm.com>, <svens@linux.ibm.com>,
        <agordeev@linux.ibm.com>, <gor@linux.ibm.com>, <nrb@linux.ibm.com>,
        <nsg@linux.ibm.com>, <seanjc@google.com>, <seiden@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
        "David Hildenbrand"
 <david@redhat.com>
Subject: Re: [PATCH v3 04/15] KVM: s390: selftests: fix ucontrol memory
 region test
X-Mailer: aerc 0.18.2
References: <20250117190938.93793-1-imbrenda@linux.ibm.com>
 <20250117190938.93793-5-imbrenda@linux.ibm.com>
 <19a46e9e-afbd-4f83-894d-e3331c3ac956@redhat.com>
 <20250120132531.625e2ab2@p-imbrenda>
In-Reply-To: <20250120132531.625e2ab2@p-imbrenda>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T_emD7G_vXY8aoR3PLVsiBsv3DoCD0mU
X-Proofpoint-ORIG-GUID: LjA-wSoar-A-NUJ1zRHRrcZ9-wNemix_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-20_04,2025-01-20_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=873 adultscore=0 phishscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501200128

On Mon Jan 20, 2025 at 1:25 PM CET, Claudio Imbrenda wrote:
> On Mon, 20 Jan 2025 13:12:31 +0100
> David Hildenbrand <david@redhat.com> wrote:
>
> > On 17.01.25 20:09, Claudio Imbrenda wrote:
> > > With the latest patch, attempting to create a memslot from userspace
> > > will result in an EEXIST error for UCONTROL VMs, instead of EINVAL,
> > > since the new memslot will collide with the internal memslot. There i=
s
> > > no simple way to bring back the previous behaviour.
> > >=20
> > > This is not a problem, but the test needs to be fixed accordingly.
> > >=20
> > > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > > ---
> > >   tools/testing/selftests/kvm/s390x/ucontrol_test.c | 6 ++++--
> > >   1 file changed, 4 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/tools/testing/selftests/kvm/s390x/ucontrol_test.c b/tool=
s/testing/selftests/kvm/s390x/ucontrol_test.c
> > > index 135ee22856cf..ca18736257f8 100644
> > > --- a/tools/testing/selftests/kvm/s390x/ucontrol_test.c
> > > +++ b/tools/testing/selftests/kvm/s390x/ucontrol_test.c
> > > @@ -459,10 +459,12 @@ TEST_F(uc_kvm, uc_no_user_region)
> > >   	};
> > >  =20
> > >   	ASSERT_EQ(-1, ioctl(self->vm_fd, KVM_SET_USER_MEMORY_REGION, &regi=
on));
> > > -	ASSERT_EQ(EINVAL, errno);
> > > +	if (errno !=3D EEXIST)
> > > +		ASSERT_EQ(EINVAL, errno); =20
> >=20
> > ASSERT_TRUE(errno =3D=3D EEXIST || errno =3D=3D EINVAL)'
> >=20
> > ?
> >=20

How about this?

ASSERT_TRUE(errno =3D=3D EEXIST || errno =3D=3D EINVAL)
	TH_LOG("errno %s (%i) not expected for ioctl KVM_SET_USER_MEMORY_REGION",
	strerror(errno), errno);

>
> I had thought about that, but in case of failure it won't print the
> failing value.
>
> It's probably more readable with the ASSERT_EQ, I will change it.


