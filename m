Return-Path: <kvm+bounces-13904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 305A589C978
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 18:18:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C9D6E1F24A9C
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 16:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E131420DB;
	Mon,  8 Apr 2024 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FyCzFWBN"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C22B5B1E0
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 16:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712593114; cv=none; b=Tn3fEYflLSd/NdGFpPy4llzrIrQCgeakGa8L0m/vp2fvSzvNsFgELnnFfsTPM2zSnzdpciitENWWcn0mUSXg9TIi+DBZWAcf/ZccNVouqA/y8Cpy9sY946qTlhGIUyzmdFmc+BL8ZJLwXy1W7rVVAXQbS8NNr7JDeW6qpga6DZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712593114; c=relaxed/simple;
	bh=eVmTDpLhat6NR4Cq0GQ9Px84kqz6iq861BvwWIVt8oE=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Cc:To:From:
	 Subject:Message-ID:Date; b=cMrDPZARAyQgOePmgmKKUxzFR8qwO0VUY/LgrzCTugsukddN4d9DzJSNRbfn5yMXh52lW5vjMOBEcRgCARBSl9wetF3XQrNn93+HbbA1kBnATKto95iRJWi6b+eeJwYhuwbZ1Kb1vi0CKrZuYWlDLq9Uzn4TmrtCLw6O775jBVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FyCzFWBN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438FrtPX032330;
	Mon, 8 Apr 2024 16:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=HJL/TRvUEDOOlP2eNNp4Hgfo9olRWi1uem16/74jwmo=;
 b=FyCzFWBN7hK43f5D/vi+g45SNsKHlTM4R5sDlCOhpoOnvH+k79XdwKFrCODWNCuLpENl
 suvkyLv6d9bKeqFAy5dkz+SEGck0t6pnyIA8OGdrUZew9JGI9Gsqpv7zCdR4idGOb5AJ
 rfszBYh3mjBSgQA669W4LCwSPkn2bUjmt6ifZy4TNm1MscOd4oUzDGx+WKaUrLx10gfa
 BtTlA/HqyMYzCwmjMwr9pmeTL/IN4BpMy/UrEipn2pu6AlU2J4FW3h9LcrrHQIs3Rn9g
 3iNbvHDNqND2lKGZ98s0yH40DwSZNe2pAhTTgc/bVuLHHIneSHOWvzK6xEDOsXC1vs7F Jg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xcjt685dr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 16:18:18 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 438GEsax030993;
	Mon, 8 Apr 2024 16:18:18 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xcjt685dd-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 16:18:18 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 438FLBtF022587;
	Mon, 8 Apr 2024 16:06:36 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xbhqns0dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 16:06:36 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 438G6WlW40370560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Apr 2024 16:06:34 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C94D72004B;
	Mon,  8 Apr 2024 16:06:32 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A375920043;
	Mon,  8 Apr 2024 16:06:32 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.39.74])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Apr 2024 16:06:32 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240405083539.374995-7-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com> <20240405083539.374995-7-npiggin@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
To: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>
From: Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v8 06/35] gitlab-ci: Run migration selftest on s390x and powerpc
Message-ID: <171259239221.48513.3205716585028068515@t14-nrb>
User-Agent: alot/0.8.1
Date: Mon, 08 Apr 2024 18:06:32 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZaoFmt7ntYkgeBnqU6_u_iHaeyqwty-m
X-Proofpoint-ORIG-GUID: QlQdmXWPyUmtL4R66NXoTtrIqQduudxU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_14,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404080126

Quoting Nicholas Piggin (2024-04-05 10:35:07)
> The migration harness is complicated and easy to break so CI will
> be helpful.
>=20
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
>  .gitlab-ci.yml      | 32 +++++++++++++++++++++++---------
>  s390x/unittests.cfg |  8 ++++++++
>  2 files changed, 31 insertions(+), 9 deletions(-)
>=20
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index ff34b1f50..60b3cdfd2 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
[...]
> @@ -135,7 +147,7 @@ build-riscv64:
>  build-s390x:
>   extends: .outoftree_template
>   script:
> - - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
> + - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu nmap-ncat
>   - mkdir build
>   - cd build
>   - ../configure --arch=3Ds390x --cross-prefix=3Ds390x-linux-gnu-
> @@ -161,6 +173,8 @@ build-s390x:
>        sclp-1g
>        sclp-3g
>        selftest-setup
> +      selftest-migration-kvm

We're running under TCG in the Gitlab CI. I'm a little bit confused why
we're running a KVM-only test here.

