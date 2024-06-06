Return-Path: <kvm+bounces-18998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BCAE8FE052
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 09:59:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E3A31C24ABF
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 07:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230A713BC30;
	Thu,  6 Jun 2024 07:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qWFcqMsT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496AD13AD22
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 07:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717660743; cv=none; b=RiUZqGfkfvP26R7FZRL2G6LNyUVIgIxUcF5nWh24Fafixu8bM19xkIZP6X1dOk3ZOSkOW5+NkPKUPVUermEynW7qarBoeqHab4A3WFfs3ikjYpwj40PVtBjR+VXRY9xlDKzuBakbUF7dXVTlBBFerCbgYAqTWdzVkV623RhbE/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717660743; c=relaxed/simple;
	bh=nk7+3Hqvff2edRi1b8P0ZrA2TyIVvk62hbw8Ro+JfUw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SNlczswN0RUMgYXdtfLKA+XGsmoWFetBO/nksyr9/Uy6ChHryeTSDWawoOVPDNYsK11Le6qJkUY8HYaspVq2FWv0xjkklHOLfLEToHRsCJ8Ysu5tYlgMnvydOTGeCtM6nY31R6ywo9sqnkb/cEodGSB7yB5UA4LTz9lUMG9CfNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qWFcqMsT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4567oP3o005719;
	Thu, 6 Jun 2024 07:58:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=w+V5nS5ccoaYF288cuPrSfCZKP3xIt82fxdgWpPbnPY=;
 b=qWFcqMsTN5MFbLrfm/SvQgFgLoTFZ9RID5L2lGCeQ21WkYtP5crJpij0EToRifk517qd
 4a+5c5cc9Kdmt/mK29jw7nfUl7PVznjmEaN4W3ZaRg15P0OI/SrRCCk8kzOEsYfH4SRm
 BdvZXPfDMouy7/wzP2gp6JWQA4iFGE9w+HiRtbKcD56CnBOGdPGC9ftMZBb1jEEOVqsG
 EUzjV4fWKHxhezDcAFugic7ZT+RrJ9Azsf5xZahudvkaFnK62qVvu2L+OvRUJSdcmb6D
 wwQ9DVX7ry3NMMfXrrWdoEOhCBZ+cfN3eClxQPXN9AKQHp/JNbSQNMk1zjCnuJ3CEB4x SA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yk5tc0j6g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Jun 2024 07:58:52 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4567wpj7017798;
	Thu, 6 Jun 2024 07:58:51 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yk5tc0j6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Jun 2024 07:58:51 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4565VfZD031204;
	Thu, 6 Jun 2024 07:58:51 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygeypsaub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Jun 2024 07:58:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4567wlfS51642670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Jun 2024 07:58:49 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 02EFD20043;
	Thu,  6 Jun 2024 07:58:47 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DADF120040;
	Thu,  6 Jun 2024 07:58:46 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.152.224.248])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  6 Jun 2024 07:58:46 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>
Cc: Andrew Jones <andrew.jones@linux.dev>, kvm@vger.kernel.org
Subject: Re: [RFC kvm-unit-tests PATCH] build: fix .aux.o target building
In-Reply-To: <D1SMM4C3H27B.2VWTDLUIB7RU3@gmail.com>
References: <20240605081623.8765-1-npiggin@gmail.com>
 <87cyovekmh.fsf@linux.ibm.com> <D1S0ZSXXGJFC.2IE9N2O8K9ETJ@gmail.com>
 <87frtrh1ho.fsf@linux.ibm.com> <D1SMM4C3H27B.2VWTDLUIB7RU3@gmail.com>
Date: Thu, 06 Jun 2024 09:58:45 +0200
Message-ID: <87h6e6sdsa.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pspc1nSHF5GbLVmst8J7Zc-qj6KThRkY
X-Proofpoint-ORIG-GUID: vRYqkQ76xHymYFmXnn4MiBDSY4PN7Kgs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-06_01,2024-06-06_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 malwarescore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 mlxscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406060057

On Thu, Jun 06, 2024 at 01:49 PM +1000, "Nicholas Piggin" <npiggin@gmail.co=
m> wrote:
> On Thu Jun 6, 2024 at 1:07 AM AEST, Marc Hartmayer wrote:
>> On Wed, Jun 05, 2024 at 08:53 PM +1000, "Nicholas Piggin" <npiggin@gmail=
.com> wrote:
>> > On Wed Jun 5, 2024 at 8:42 PM AEST, Marc Hartmayer wrote:
>> >> On Wed, Jun 05, 2024 at 06:16 PM +1000, Nicholas Piggin <npiggin@gmai=
l.com> wrote:

[=E2=80=A6snip=E2=80=A6]

>
>
>> But what was also interesting is that if I=E2=80=99m using multiple
>> jobs I don=E2=80=99t see the issue.
>>
>> make clean -j; make -j; make -j # <- the last make has nothing to do
>>
>> if I=E2=80=99m using:
>>
>> make clean -j; make; make -j # <- the last make has something to do=E2=
=80=A6
>>                                   that something that irritates me
>
> This is with s390x? Maybe with parallel make, the target is getting

No, it=E2=80=99s a ppc64 cross-build on x86.

> rebuilt via a different prerequisite that is not a .SECONDARY target?
> Adding %.aux.o in PRECIOUS there should help in that case.

Yes, it helps - that was the reason for my fix :)

>
>> >
>> > Is it better to define explicit targets if we want to keep them, or
>> > add to .PRECIOUS? Your patch would be simpler.
>>
>> Normally, I would say without .PRECIOUS it=E2=80=99s cleaner, but there =
is
>> already a .PRECIOUS for %.so=E2=80=A6 So as Andrew has already written
>>
>> .PRECIOUS: %.so %.aux.o
>>
>> should also be fine.
>
> Okay, for a minimal fix I will do that.
>
> Thanks,
> Nick
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

