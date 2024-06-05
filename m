Return-Path: <kvm+bounces-18874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4378B8FC94B
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 12:42:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCEBB284D5D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 10:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3BF6191489;
	Wed,  5 Jun 2024 10:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Arf0Q82r"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53F613AD05
	for <kvm@vger.kernel.org>; Wed,  5 Jun 2024 10:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717584168; cv=none; b=ZKQL4aFCxU43X88LYG+7StfbV31E0xWKOvddki1rCYCxJHB0aCuWVYgSxqGzDddOQIOZbc0xG/DIub2uta8DmwWI5iQvDVWLjyh6eB3Dl0z2TCA3JQPiEZCN8nVMuzgDQvH6iTgVd/sR+VyLiJZqiKBFfbQN5qz8/wtt+mS/fNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717584168; c=relaxed/simple;
	bh=2pBVYnnpikTEHcFhWdVV6edVGL40PQ8DJmcmh3L65Qw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MonuOZRwM8tERph8K5h5LTEuly15gOblGkaf4Evxe1wKgBbE/Rg/hcBqyTtvd3mcvy9rfgyN3Tap/hVNDDx9ROv70AizwDOHOK0SpvUJPNH4OEKWxgwXc46vvXnEtEuqzpsc4dEJC/A4foXJMf83Gq/esNwKBy/5KPwwl3xTOrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Arf0Q82r; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 455AZsX9006566;
	Wed, 5 Jun 2024 10:42:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=pp1;
 bh=392jnAsX35uwrQ4oFPw1UOs+KTklk/A8Xslty0pHNew=;
 b=Arf0Q82rKm8tcR1uqX/5AUQgFaSt8lsFklVnF4mBvwHJ7C15UBSSLjXVPKW+Gbupzo5l
 HbQFL4kCcx/cZgi4hx2MvFawMxyzAIZGYSM0MAEI8ZSe9aPZxuExRsV7IRE4OXMdXsWj
 VVzLdzSLGCxozjX2CAJfHpMfianbnoCUhlVowUKTP5X+BCAaHCYjWDKSBHbvGlMlnpWE
 el3kVr7FUoogFS6RuSX99x8Yv334Mun1kBnoxpL1QipX+apya9XkMQY1ZcJmOxtmiHAu
 HZwqL6UYKOV8aGKAX7Osmh8Zax81oodvzc/Fgrl4wz9/p40hE1jM1IaoF05CD1qDqYg5 mg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjp6x81dx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 10:42:37 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 455Agbde016324;
	Wed, 5 Jun 2024 10:42:37 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yjp6x81du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 10:42:37 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 455AACrI026600;
	Wed, 5 Jun 2024 10:42:36 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygffn3gtm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Jun 2024 10:42:35 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 455AgWLj41025856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Jun 2024 10:42:34 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE17820040;
	Wed,  5 Jun 2024 10:42:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 879942004E;
	Wed,  5 Jun 2024 10:42:31 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.49.245])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  5 Jun 2024 10:42:31 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
        Andrew Jones
 <andrew.jones@linux.dev>, kvm@vger.kernel.org
Subject: Re: [RFC kvm-unit-tests PATCH] build: fix .aux.o target building
In-Reply-To: <20240605081623.8765-1-npiggin@gmail.com>
References: <20240605081623.8765-1-npiggin@gmail.com>
Date: Wed, 05 Jun 2024 12:42:30 +0200
Message-ID: <87cyovekmh.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QvRFTXgdSLfS-KpOgRaEdE6Yj8gyDXcI
X-Proofpoint-ORIG-GUID: kmzUkegmBdyDQJvb2jJFW1yxIwpNXP2x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-05_01,2024-06-05_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 clxscore=1011 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406050081

On Wed, Jun 05, 2024 at 06:16 PM +1000, Nicholas Piggin <npiggin@gmail.com>=
 wrote:
> Here's another oddity I ran into with the build system. Try run make
> twice. With arm64 and ppc64, the first time it removes some intermediate
> files and the second causes another rebuild of several files. After
> that it's fine. s390x seems to follow a similar pattern but does not
> suffer from the problem. Also, the .PRECIOUS directive is not preventing
> them from being deleted inthe first place. So... that probably means I
> haven't understood it properly and the fix may not be correct, but it
> does appear to DTRT... Anybody with some good Makefile knowledge might
> have a better idea.
>

$ make clean -j &>/dev/null && make -d
=E2=80=A6
Successfully remade target file 'all'.
Removing intermediate files...
rm powerpc/emulator.aux.o powerpc/tm.aux.o powerpc/spapr_hcall.aux.o powerp=
c/interrupts.aux.o powerpc/selftest.aux.o powerpc/smp.aux.o powerpc/selftes=
t-migration.aux.o powerpc/spapr_vpa.aux.o powerpc/sprs.aux.o powerpc/rtas.a=
ux.o powerpc/memory-verify.aux.o

So an easier fix would be to add %.aux.o to .PRECIOUS (but that=E2=80=99s p=
robably still not clean).

.PRECIOUS: %.o %.aux.o

Fixed the issue (I=E2=80=99ve tested on ppc64 only).

>
>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

