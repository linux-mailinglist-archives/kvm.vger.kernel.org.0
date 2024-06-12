Return-Path: <kvm+bounces-19413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74145904BE6
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 08:49:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C8461F214AB
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 06:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7589F169376;
	Wed, 12 Jun 2024 06:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="TvtXRuwV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C081A1649C2;
	Wed, 12 Jun 2024 06:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718174932; cv=none; b=bDVw+6XtMugrLviAX8kedfgKpVhItWnMzN/Bwihddn9m/qTRlp4SUOEbVof7qwR5qxca0f8KZ0rOdst6tYiRiAyt861aAloncrWWr7fmmYtqY9+q6kq/Om+wEJx2aGTL4sqwfrHVHlEzxsWxINdHW1c+wErJiQ18Ln6zLTGMbmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718174932; c=relaxed/simple;
	bh=E9b+MQXZfY2eCb2ANlEELHoiVSOYj8GmrjOJhnRzvuI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=K9wN2qQjdkqDFQRK3lFs5qoPD/c9nelBNPIU+9EQkEt8kbYgrt7Gt/3aWc4313zD97yUR5AHkguyCpK+anz9Se8BQ1eeedbuiraDplNaMdYFTpLZJECXM/jM9vtN8KMoZ3rNwf5uo181DHOqd4seogseL5QUhMdMmTskeX3gHts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=TvtXRuwV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45C5xPJd015403;
	Wed, 12 Jun 2024 06:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:in-reply-to:references:date:message-id
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	7U/aGo/SegEj8qcEL5oci96thwe+0ZYEfL1TiW6lAi8=; b=TvtXRuwVyf0rv9Xv
	3EdzGNk5V5t7q97nijvmvC5wemqtR4pJHp8FJf8MSWlZf75JXZExYFbGRo1+cYLX
	iFPSueyYM+OooiHjECfTGD4V/46CU0UC9vDGrNjgQtJT2YsO/FBDjjevtPifDVaO
	LojcA5kilarCYm1jJX2dDKgShv5+boINScANkn1pbCXnWFAlS3KWSPIBqWNopcmB
	nXVWV0DM2jaHF5lG8/NGt1nFy0ZMIeBXKWAdV7Ypw1KIQQ+eHKSm7y8hHKPZYbWg
	sYnLmkSqoW0y0ftj3aM+jKAlJ10sWLeQwfdRj2C3mThpemyHaejsxGWH/TpQEUzP
	mxtyNg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yq60dr3kk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 06:48:13 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45C6mCSx025480;
	Wed, 12 Jun 2024 06:48:13 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yq60dr3kg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 06:48:12 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45C6622I023566;
	Wed, 12 Jun 2024 06:48:12 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yn3umjues-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 12 Jun 2024 06:48:12 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45C6m8G225821916
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 06:48:10 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5ED2120065;
	Wed, 12 Jun 2024 06:48:08 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFD5B2004D;
	Wed, 12 Jun 2024 06:48:07 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.76.207])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 12 Jun 2024 06:48:07 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>,
        kvm@vger.kernel.org
Cc: Andrew Jones <andrew.jones@linux.dev>, kvmarm@lists.linux.dev,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] build: retain intermediate .aux.o targets
In-Reply-To: <20240612044234.212156-1-npiggin@gmail.com>
References: <20240612044234.212156-1-npiggin@gmail.com>
Date: Wed, 12 Jun 2024 08:48:07 +0200
Message-ID: <87a5jqejx4.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _IynBDK5YLWOnJjcMpaLtlgb0ppN9llp
X-Proofpoint-ORIG-GUID: 76CjRMsJNf39GEcQi1k4dJX1xNvcpOto
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-12_02,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 phishscore=0 clxscore=1011 impostorscore=0 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406120044

On Wed, Jun 12, 2024 at 02:42 PM +1000, Nicholas Piggin <npiggin@gmail.com>=
 wrote:
> arm, powerpc, riscv, build .aux.o targets with implicit pattern rules
> in dependency chains that cause them to be made as intermediate files,
> which get removed when make finishes. This results in unnecessary
> partial rebuilds. If make is run again, this time the .aux.o targets
> are not intermediate, possibly due to being made via different
> dependencies.
>
> Adding .aux.o files to .PRECIOUS prevents them being removed and solves
> the rebuild problem.
>
> s390x does not have the problem because .SECONDARY prevents dependancies
> from being built as intermediate. However the same change is made for
> s390x, for consistency.
>
> Suggested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---

[=E2=80=A6snip=E2=80=A6]

> @@ -85,7 +85,7 @@ CFLAGS +=3D -fno-delete-null-pointer-checks
>  LDFLAGS +=3D -Wl,--build-id=3Dnone
>=20=20
>  # We want to keep intermediate files
> -.PRECIOUS: %.o %.lds
> +.PRECIOUS: %.o %.aux.o %.lds
>=20=20
>  asm-offsets =3D lib/$(ARCH)/asm-offsets.h
>  include $(SRCDIR)/scripts/asm-offsets.mak
> --=20
> 2.45.1
>
>

Thanks for fixing this!

Reviewed-by: Marc Hartmayer <mhartmay@linux.ibm.com>

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

