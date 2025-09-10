Return-Path: <kvm+bounces-57178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CA42B51011
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 09:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 861BB7B2FC4
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 07:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51FB330DD03;
	Wed, 10 Sep 2025 07:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fwCagt4P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78CD30CDBF
	for <kvm@vger.kernel.org>; Wed, 10 Sep 2025 07:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757491049; cv=none; b=JGMsb4LSnkF2nc5wWyi++3566h6OooO5m1VntFoJXmuGkUaOpV7XcpZjq52uoHzI9Y5UBD4kBk6g35tCnE5rKa8xIswD0oJSxwpJ6vlK5YHvm0LVyQlSCmCBbWdnQOFsAUEJzciYTsHgfwxHntqgYDcVJTluKeNrhzul0H/IRbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757491049; c=relaxed/simple;
	bh=2yWjQtca9vIFurOaNmKLaOJeKwiFA5Qvxekl5cC7zrI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=V5MfwWVVyaZDe6y+139x3IipzDPiO3V6qr9+1e2Rzt7Zbo2XZLQsBNA2z/pUcLFfVbQYw75Woqc4j4veP/GBSlR9cncCo8e5psCp7IGpfQVpOgCW5gFiaep1gwvA/lI5N7BX4wTczBlNgiYZln0eK0mLVjy2TTf/9mwLn/1ls4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fwCagt4P; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589K4bwg018625;
	Wed, 10 Sep 2025 07:57:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=T3AdB4
	hqqFlARSsNDT6AJcRm4apQQebfJeVbRsEuVTs=; b=fwCagt4PUxXtZX/SuFW3Ha
	CiXZoWCoFqIbJHh4u9ZQuftSB/IJ4VBe7sj3dWqmNaYr6Xplu4F/OA1jlb+bJ4Bw
	e9HuPdxW+a87aTlKTXqHl9G2fdKtJqE2VKlv/Za8f0EsxMuNCM/8KjLRYcCftWLq
	/xygDgfU5LewLmSQVr3XY2ATX7htVpo+zqq86WRlBe1SuKG0UeM/g3Xd8cfvVnES
	kGULwPwpvRfZoxkBb9BPlgBI+0mcgs5Jzf0mnEwwGjqx9Wo9WpEUEuw2DYC01ZuY
	Dbai10h+QqPd6lS/7GdCZ2c0TdBD8QFm7w4mF11yW9a/fdfv2srKGcsgH/r2gzQA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acr4f6y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 07:57:22 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58A5m0qZ007950;
	Wed, 10 Sep 2025 07:57:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49109pqc2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 07:57:21 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58A7vHS552560248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 07:57:17 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C9FC620040;
	Wed, 10 Sep 2025 07:57:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31F3220043;
	Wed, 10 Sep 2025 07:57:17 +0000 (GMT)
Received: from t14-nrb (unknown [9.155.202.117])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 07:57:17 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 10 Sep 2025 09:57:17 +0200
Message-Id: <DCOYKSEY6V79.3HE423J6WWXTT@linux.ibm.com>
Cc: "Andrew Jones" <andrew.jones@linux.dev>,
        "Janosch Frank"
 <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2] scripts/arch-run.bash: Drop the
 dependency on "jq"
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Thomas Huth" <thuth@redhat.com>, <kvm@vger.kernel.org>,
        "Claudio
 Imbrenda" <imbrenda@linux.ibm.com>
X-Mailer: aerc 0.20.1
References: <20250909045855.71512-1-thuth@redhat.com>
In-Reply-To: <20250909045855.71512-1-thuth@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nLkCKCXGlfgUh3xVynvAMU9vNZ1ekW2d
X-Authority-Analysis: v=2.4 cv=Mp1S63ae c=1 sm=1 tr=0 ts=68c12f62 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=JApUutT44eaPP5SMeaQA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: nLkCKCXGlfgUh3xVynvAMU9vNZ1ekW2d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAwMCBTYWx0ZWRfX4XpSfBW+stAp
 h3u4TbTbgY54JhluKRdypZ2/E8JdJvRObIiQGi5X8Nz1MnN2RyjNxDp4jT5TGvF4aVrAO+DPzSH
 BnY+m+TGoxWa74WC/cgN3VfHj0f59tamaw54HD9/NMPffTSjf1lEp/YqKShMepdcWE/57/TgmKz
 g1RHcpIylkH3yR8EG0yv6KlBdLyKCyKcA+edGrOQHb7FrAGsoqh789kxFbW0ZC63qVXJx5950oO
 V8EZZcwE3HGFxnvi23Ba2H+crMhIUTrwk7Xk3WWthWJd3xkLUZRyu6nUvBOFZx5bf14Pav9nwNx
 vLpuNK/AD0qyPLdTWs9Er+s+py8nQh4IbrPfRFBCu4PPaP5HrWjVfeT5nZ5/LXo9bv1ycaYMFSf
 BypFtyxa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1011 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060000

On Tue Sep 9, 2025 at 6:58 AM CEST, Thomas Huth wrote:
> For checking whether a panic event occurred, a simple "grep"
> for the related text in the output is enough - it's very unlikely
> that the output of QEMU will change. This way we can drop the
> dependency on the program "jq" which might not be installed on
> some systems.

Trying to understand which problem you're trying to solve here.

Is there any major distribution which doesn't have jq in its repos? Or any
reason why you wouldn't install it?

> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 36222355..16417a1e 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -296,11 +296,6 @@ do_migration ()
> =20
>  run_panic ()
>  {
[...]
> -	panic_event_count=3D$(jq -c 'select(.event =3D=3D "GUEST_PANICKED")' < =
${qmp}.out | wc -l)
> -	if [ "$panic_event_count" -lt 1 ]; then
> +	if ! grep -E -q '"event"[[:blank:]]*:[[:blank:]]*"GUEST_PANICKED"' ${qm=
p}.out ; then

This changes behaviour.

Now "event" can be arbitrarily deep nested in the JSON. It could even be
completely invalid JSON.

Not saying we shouldn't do this, it just comes with a cost and we need to s=
ee if
it's worth paying that.

