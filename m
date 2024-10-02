Return-Path: <kvm+bounces-27801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 309D798DA2A
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 16:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78166281221
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 14:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92F3A1D095D;
	Wed,  2 Oct 2024 14:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HrAar6Yx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005511D096B;
	Wed,  2 Oct 2024 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878442; cv=none; b=ev7uPjF376dGb9nRPBYLEuMJ/2QIaMbypAugG0vLG8JMV1nBRWVEo4mNrflK/+7GAwSn9/4TR5PpIO1m48fKzDlp3SY2NPpT/3FLcX6WxZNiLeQYoNpN3D0IbEEZanZzhDUdshAmEHnAxXjyopxhC/XvM3ObIODac8RGBANaomo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878442; c=relaxed/simple;
	bh=HeLUMcK6ucRDD+bOVXMOjuWIL4G56EVlC+OV+sIclUg=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Subject:From:Cc:
	 To:Date:Message-ID; b=pL+PaauiUy8tA1Y3KxIyNKI0dCzP22TkayyqUdeHQESx1Fu7fTj70wo/6Ox4RwRzN3GCbe60DNmGug8/FKI8YluzcRqnQ2XcoGbtZ94SX9Qg3KnjU2MSnyA5cOThaSfRJS1gpBZ7nen26W+53+IDQIu5ncLSjISutkEsRggYoU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HrAar6Yx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 492DnlFV005645;
	Wed, 2 Oct 2024 14:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-type:mime-version:content-transfer-encoding:in-reply-to
	:references:subject:from:cc:to:date:message-id; s=pp1; bh=fVxoa1
	aGNg+itz5ljXsjN5RrI6YIQhC/5tTEkpqoknQ=; b=HrAar6YxD09KxUNFPOQS83
	2LktopovooicmdYslJNRcrrkhdCaK/bbhyalr2pSX6b7DVtGlakkradsrp3FGjIH
	8ZrwfZPETrHlUInuU2zw349Fai96oerGxq8GUL8MZd44QKlGXJrXcZWUEIucg+w6
	+znhsh6fKkD5z+GWo49gzGkkPdGOJIcAhPHfQ4bodQPe2eQ8X1nD4g39QvPo0rBy
	HdkU65YSxvkRS0OnDj6PvamuZdCBWdUl1HZUBZdowDP+UeiWsdTisdGZl18xeX1a
	aVKd1TakIeIo4Tk/TB5j0sqRW+C/9EkDKrq4FCZc+fIFpNqPYhF0xTrqiBa0mMsQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217da04re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:13:58 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 492EDwVr017674;
	Wed, 2 Oct 2024 14:13:58 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4217da04r8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:13:58 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 492E37WZ014616;
	Wed, 2 Oct 2024 14:13:57 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 41xwmkakpe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 02 Oct 2024 14:13:57 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 492EDrie48628114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 2 Oct 2024 14:13:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5E0E2004B;
	Wed,  2 Oct 2024 14:13:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D69B20043;
	Wed,  2 Oct 2024 14:13:53 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.74.111])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  2 Oct 2024 14:13:53 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240925173452.5781864f@p-imbrenda.boeblingen.de.ibm.com>
References: <20240923062820.319308-1-nrb@linux.ibm.com> <20240923062820.319308-2-nrb@linux.ibm.com> <20240925173452.5781864f@p-imbrenda.boeblingen.de.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: add test for diag258
From: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Date: Wed, 02 Oct 2024 16:13:52 +0200
Message-ID: <172787843272.65827.14205730120913539885@t14-nrb.local>
User-Agent: alot/0.10
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VCMbz4wbsGf54TTbWbDlrMG5fEN55H0B
X-Proofpoint-ORIG-GUID: fYVDh79Me7Ix7riI0NlF7XSv9L4psTtD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-02_14,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 impostorscore=0 phishscore=0
 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2410020103

Quoting Claudio Imbrenda (2024-09-25 17:34:52)
> > +static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));
>=20
> wait, you are using LC_SIZE in this file... even though it's only
> defined in the next patch.
>=20
> I think you should swap patch 1 and 2

will do

[...]
> > +/*
> > + * Verify that the refbk pointer is a real address and not a virtual
> > + * address. This is tested by enabling DAT and establishing a mapping
> > + * for the refbk that is outside of the bounds of our (guest-)physical
>=20
> s/physical/real/ (or absolute)

Huh? Why? Talking about the size here, so absolute, real and physical are
all equivalent here.

[...]
> > +     /*
> > +      * Put a valid refbk at refbk_in_reverse_prefix.
> > +      */
> > +     memcpy(refbk_in_reverse_prefix, &pfault_init_refbk, sizeof(pfault=
_init_refbk));
> > +
> > +     ry =3D diag258(refbk_in_reverse_prefix);
> > +     report(!ry, "real address refbk accessed");
> > +
> > +     /*
> > +      * Activating should have worked. Cancel the activation and expect
> > +      * return 0. If activation would not have worked, this should ret=
urn with
> > +      * 4 (pfault handshaking not active).
> > +      */
> > +     ry =3D diag258(&pfault_cancel_refbk);
> > +     report(!ry, "handshaking canceled");
> > +
> > +     set_prefix(old_prefix);
> > +
> > +     report_prefix_pop();
> > +}
>=20
> it seems like you are only testing the first page of lowcore; can you
> expand the test to also test the second page?

Would you mind leaving this for a future extension?

> > +
> > +/*
> > + * Verify that a refbk exceeding physical memory is not accepted, even
> > + * when crossing a frame boundary.
> > + */
> > +static void test_refbk_crossing(void)
> > +{
> > +     const size_t bytes_in_last_page =3D 8;
>=20
> are there any alignment requirements for the buffer?
> if so, that should also be tested (either that a fault is triggered or
> that the lowest bytes are ignored, depending on how it is defined to
> work)

There are alignment requirements. Would it be OK to do this in a future
extension?

> > +/*
> > + * Verify that a refbk with an invalid refdiagc is not accepted.
> > + */
> > +static void test_refbk_invalid_diagcode(void)
> > +{
> > +     struct pfault_refbk refbk =3D pfault_init_refbk;
> > +
> > +     report_prefix_push("invalid refdiagc");
> > +     refbk.refdiagc =3D 0xc0fe;
>=20
> other testcases in this file depend on invalid codes failing; maybe
> move this test up?

Yes, thanks, done.

> > +int main(void)
> > +{
> > +     report_prefix_push("diag258");
> > +
> > +     expect_pgm_int();
> > +     diag258(&pfault_init_refbk);
> > +     if (clear_pgm_int() =3D=3D PGM_INT_CODE_SPECIFICATION) {
> > +             report_skip("diag258 not supported");
> > +     } else {
> > +             test_priv();
> > +             test_refbk_real();
>=20
> should probably go here....

test_refbk_real() relies on the invalid diagcode doing nothing, so it
should go *before* that one.

