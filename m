Return-Path: <kvm+bounces-29453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A11A9ABA74
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 02:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42BDE1C22BFA
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2024 00:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BBE5168DA;
	Wed, 23 Oct 2024 00:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="OH+kt1r1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF30322B
	for <kvm@vger.kernel.org>; Wed, 23 Oct 2024 00:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729642710; cv=none; b=Pf3kL/fn76xyNGgfg5CMqIeujtk7RrQ3a9UnBv04FdfYb9aN7Cl0KfZ+wm0jh/HcYacmfFhe/kLgj9U2GfbWKPGQ093lWXn6iJdb4CFPtNdR7efReqej0hK+Ui3o7ib5OLQno5/FqaeTU+Nsls5f+5Q1AV012oezoHuNF2giulE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729642710; c=relaxed/simple;
	bh=SBoBNINTmrmrZ6PS1raunSzBNj06bgQiQWurqk8pEkc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qecxmkPz3Xf4B7SCT/RI2rAoCHSg5tNfBFAXWkWApcy/EaDgLDyxjI9hc0Avz2uk/GARTFNKrHfTDFZvfppGjftsgGlpXZRooqhXk8rtawhW2VUyorIitue2TZ57OLsM5SYjUJbyBzIjo3sihvSdkjxdbY4dRBFjRHqx65bgaR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=OH+kt1r1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49MLoBML006937;
	Wed, 23 Oct 2024 00:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=SBoBNI
	NTmrmrZ6PS1raunSzBNj06bgQiQWurqk8pEkc=; b=OH+kt1r1ac46DhWewUxJSv
	VXQziNTkLk4XNNmuSOuq6sX1lhNEDpbRuv7aT3Tr1c//aHBuxdVvkMAut0Wh4Dve
	xpOHh5ZsQTs8u2mnhVuQvcICbDsiCECTTmAGZQRIw5kTq3bVyc2mW1suRswGD4wF
	KDhvbJRj0vSedvp/8aEpYJHZ5VKC2QaRJ4wkiYSYOTsfJVAH88OKmXs5DXq9cN4J
	N/SuTKQWlc29JViCL6WSTibw6DBfmMqq+EWRWcGXKCXliBs7NzjxCSnm0Jyq9WGq
	z1ezOywt4kb4Jdlp2DevWPWAJgwpqQGHee8IKE8ge5mYpyj8e8QBLOJZDi+Vtdmg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42emafrds9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 00:16:54 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49N0GrLj023088;
	Wed, 23 Oct 2024 00:16:53 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42emafrds8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 00:16:53 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49MM8hIG001552;
	Wed, 23 Oct 2024 00:16:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 42emk98cny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Oct 2024 00:16:52 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49N0GpHJ45285632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Oct 2024 00:16:51 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FBD020043;
	Wed, 23 Oct 2024 00:16:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83BB620040;
	Wed, 23 Oct 2024 00:16:49 +0000 (GMT)
Received: from [127.0.0.1] (unknown [9.152.108.100])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 23 Oct 2024 00:16:49 +0000 (GMT)
Message-ID: <4c383f09bd6bd9b488ad301e5f050b8c9971f3a2.camel@linux.ibm.com>
Subject: Re: [PATCH v2 07/20] tests/tcg/x86_64: Add cross-modifying code test
From: Ilya Leoshkevich <iii@linux.ibm.com>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>,
        Alex
 =?ISO-8859-1?Q?Benn=E9e?=
	 <alex.bennee@linaro.org>,
        qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>, Laurent Vivier <laurent@vivier.eu>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Mahmoud Mandour
 <ma.mandourr@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Yanan Wang
 <wangyanan55@huawei.com>, Thomas Huth <thuth@redhat.com>,
        John Snow
 <jsnow@redhat.com>,
        =?ISO-8859-1?Q?Marc-Andr=E9?= Lureau
 <marcandre.lureau@redhat.com>,
        qemu-arm@nongnu.org,
        "Daniel P."
 =?ISO-8859-1?Q?Berrang=E9?= <berrange@redhat.com>,
        Eduardo Habkost
 <eduardo@habkost.net>, devel@lists.libvirt.org,
        Cleber Rosa
 <crosa@redhat.com>, kvm@vger.kernel.org,
        Philippe
 =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
        Alexandre Iooss
 <erdnaxe@crans.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard
 Henderson <richard.henderson@linaro.org>,
        Riku Voipio
 <riku.voipio@iki.fi>, Zhao Liu <zhao1.liu@intel.com>,
        Marcelo Tosatti
 <mtosatti@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini
 <pbonzini@redhat.com>
Date: Wed, 23 Oct 2024 02:16:49 +0200
In-Reply-To: <6b18238b-f9c3-4046-964f-de16dc30d26e@linaro.org>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
	 <20241022105614.839199-8-alex.bennee@linaro.org>
	 <6b18238b-f9c3-4046-964f-de16dc30d26e@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H5mvpg5WpP0LgFN83-PfKKlyGVf_CLmb
X-Proofpoint-ORIG-GUID: bhM4KN_iLhtvPV9j9L2Gh6SjUqCU3ZM7
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410220156

On Tue, 2024-10-22 at 13:36 -0700, Pierrick Bouvier wrote:
> On 10/22/24 03:56, Alex Benn=C3=A9e wrote:
> > From: Ilya Leoshkevich <iii@linux.ibm.com>
> >=20
> > commit f025692c992c ("accel/tcg: Clear PAGE_WRITE before
> > translation")
> > fixed cross-modifying code handling, but did not add a test. The
> > changed code was further improved recently [1], and I was not sure
> > whether these modifications were safe (spoiler: they were fine).
> >=20
> > Add a test to make sure there are no regressions.
> >=20
> > [1]
> > https://lists.gnu.org/archive/html/qemu-devel/2022-09/msg00034.html
> >=20
> > Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> > Message-Id: <20241001150617.9977-1-iii@linux.ibm.com>
> > Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> > ---
> > =C2=A0 tests/tcg/x86_64/cross-modifying-code.c | 80
> > +++++++++++++++++++++++++
> > =C2=A0 tests/tcg/x86_64/Makefile.target=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 4 ++
> > =C2=A0 2 files changed, 84 insertions(+)
> > =C2=A0 create mode 100644 tests/tcg/x86_64/cross-modifying-code.c
> >=20
> > diff --git a/tests/tcg/x86_64/cross-modifying-code.c
> > b/tests/tcg/x86_64/cross-modifying-code.c
> > new file mode 100644
> > index 0000000000..2704df6061
> > --- /dev/null
> > +++ b/tests/tcg/x86_64/cross-modifying-code.c
> > @@ -0,0 +1,80 @@
> > +/*
> > + * Test patching code, running in one thread, from another thread.
> > + *
> > + * Intel SDM calls this "cross-modifying code" and recommends a
> > special
> > + * sequence, which requires both threads to cooperate.
> > + *
> > + * Linux kernel uses a different sequence that does not require
> > cooperation and
> > + * involves patching the first byte with int3.
> > + *
> > + * Finally, there is user-mode software out there that simply uses
> > atomics, and
> > + * that seems to be good enough in practice. Test that QEMU has no
> > problems
> > + * with this as well.
> > + */
> > +
> > +#include <assert.h>
> > +#include <pthread.h>
> > +#include <stdbool.h>
> > +#include <stdlib.h>
> > +
> > +void add1_or_nop(long *x);
> > +asm(".pushsection .rwx,\"awx\",@progbits\n"
> > +=C2=A0=C2=A0=C2=A0 ".globl add1_or_nop\n"
> > +=C2=A0=C2=A0=C2=A0 /* addq $0x1,(%rdi) */
> > +=C2=A0=C2=A0=C2=A0 "add1_or_nop: .byte 0x48, 0x83, 0x07, 0x01\n"
> > +=C2=A0=C2=A0=C2=A0 "ret\n"
> > +=C2=A0=C2=A0=C2=A0 ".popsection\n");
> > +
> > +#define THREAD_WAIT 0
> > +#define THREAD_PATCH 1
> > +#define THREAD_STOP 2
> > +
> > +static void *thread_func(void *arg)
> > +{
> > +=C2=A0=C2=A0=C2=A0 int val =3D 0x0026748d; /* nop */
> > +
> > +=C2=A0=C2=A0=C2=A0 while (true) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 switch (__atomic_load_n((in=
t *)arg, __ATOMIC_SEQ_CST)) {
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case THREAD_WAIT:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case THREAD_PATCH:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val=
 =3D __atomic_exchange_n((int *)&add1_or_nop, val,
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 __ATOMIC_SEQ_CST);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bre=
ak;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case THREAD_STOP:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret=
urn NULL;
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 default:
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ass=
ert(false);
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 __b=
uiltin_unreachable();
>=20
> Use g_assert_not_reached() instead.
> checkpatch emits an error for it now.

Is there an easy way to include glib from testcases?
It's located using meson, and I can't immediately see how to push the
respective compiler flags to the test Makefiles - this seems to be
currently handled by configure writing to $config_target_mak.

[...]



