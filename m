Return-Path: <kvm+bounces-7712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D929A8459D3
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:16:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 784EB1F27F95
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 14:16:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9594B5F46D;
	Thu,  1 Feb 2024 14:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MruKVABT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42AE5D465;
	Thu,  1 Feb 2024 14:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706796981; cv=none; b=U/HTqwhq3Wu/q72dDuK+2kZD7FMfXG3rO11A+CqJBZaRnEFIDtPbt2yET0+GL/SYPMBiUzMRLDRPyj8aabPQK2WuduZWjB6xFE3wHtNWLOevwjyniagxADsa6dngNeZAmSDOK2CPZrSBE/5BNBpXhBMnzsIEXbnevD7py+cihh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706796981; c=relaxed/simple;
	bh=kAAjVFaXiz9wrscVMXE1eyu3NwVY4hZIwQWqekK3nY8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=lNx9y3GQyBSIZBGL8OGkN7kQM9HvTbR8db0Kcw85nya8FrYQ8zf7k2bfzXMLObPTLdchQGxtWRypIrcjXHPRx86HFia4Llz+8GjLqqwBlompX5b7jWaQsx9ns2Xm+fkM7Vu4b+i16sbzjBGUUurW7hi2pgK7xGCwbCJelmwS+MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MruKVABT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411ECuxH015100;
	Thu, 1 Feb 2024 14:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=iSd/OyC29e+JKUIpRkmoiKhvI+j/4H2ikjRB0UBGEgw=;
 b=MruKVABTd9jpPGI88Ippwbh7mccJKwQk7M9dFlGbfWc1b2Gy74FLIshiM0QdyGKExVPf
 weHqYzBNXARlxccLIo+h9xOePaMRrnbXXurvNO8bjQFUtdBj7470bQoEeAA68IF0+fhG
 MQ+t1TsUDbGkuNNjKk+Bxnxuo+I7o04CETGUadFUkfNSxkQ7YbdPAB5iAKyfQa3VaABf
 8EeRBjRIBCShCZY7mMJ9AuJ03gNfXxvd0coy2wLiAJZ2HzBMgvEJK35z8QT7umkhz5mf
 ZinTvdGKstAzBWX19gUYlME+5TuQS8ayhGwY1vv0HlZLQMM/T3M8JnWudorYeNFtYqLM bA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0cv6r3gr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:16:18 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 411ECtMo015061;
	Thu, 1 Feb 2024 14:16:18 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0cv6r3g6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:16:18 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 411BCDJq010858;
	Thu, 1 Feb 2024 14:16:17 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vweckv90s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:16:17 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411EGECC41353562
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 14:16:14 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FB502004F;
	Thu,  1 Feb 2024 14:16:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E37D72004D;
	Thu,  1 Feb 2024 14:16:13 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.50.130])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  1 Feb 2024 14:16:13 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Thomas Huth <thuth@redhat.com>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] (arm|powerpc|s390x): Makefile: add
 `%.aux.o` target
In-Reply-To: <db6ac7f8-5a1e-4119-a48c-6c4b4e05cb27@redhat.com>
References: <20240125151127.94798-1-mhartmay@linux.ibm.com>
 <db6ac7f8-5a1e-4119-a48c-6c4b4e05cb27@redhat.com>
Date: Thu, 01 Feb 2024 15:16:12 +0100
Message-ID: <87wmro9snn.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ljph48Knk4l2rhiuIYRtl4Sui3_WN9RI
X-Proofpoint-ORIG-GUID: 5tRI3DQiWujXhdjWqaNnqKWXGPBfqWUR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_02,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 priorityscore=1501 spamscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402010112

On Thu, Feb 01, 2024 at 01:09 PM +0100, Thomas Huth <thuth@redhat.com> wrot=
e:
> On 25/01/2024 16.11, Marc Hartmayer wrote:
>> It's unusual to create multiple files in one target rule, therefore crea=
te an
>> extra target for `%.aux.o` and list it as prerequisite. As a side effect=
, this
>> change fixes the dependency tracking of the prerequisites of
>> `.aux.o` (`lib/auxinfo.c` was missing).
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>> ---
>>   arm/Makefile.common     | 23 ++++++++++++-----------
>>   powerpc/Makefile.common | 10 +++++-----
>>   s390x/Makefile          |  9 +++++----
>>   3 files changed, 22 insertions(+), 20 deletions(-)
>
> Patch looks sane to me, so I went ahead and pushed it to the git repo.
> Thanks!

Thanks.

>
> By the way, unrelated to your modifications, but while testing it, I noti=
ced=20
> that "make distclean" leaves some files behind for the s390x build:
>
>   ./configure --arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-
>   make -j$(nproc)
>   make distclean
>   git status --ignored
>
> On branch master
> Your branch is up to date with 'origin/master'.
>
> Ignored files:
>    (use "git add -f <file>..." to include in what will be committed)
> 	.mvpg-snippet.d
> 	.sie-dat.d
> 	.spec_ex.d

> 	lib/auxinfo.o

At least, this file is related to this patch. Before it was always
deleted, now it=E2=80=99s only removed if the =E2=80=9CMakefile semantics=
=E2=80=9D enforce it.

[=E2=80=A6snip]

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

