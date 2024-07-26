Return-Path: <kvm+bounces-22300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D700493CFA6
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 10:32:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80F801F21A16
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 08:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5A92176ACD;
	Fri, 26 Jul 2024 08:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="srhshcfb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422CF433AB;
	Fri, 26 Jul 2024 08:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721982714; cv=none; b=DQb1H2K44TOWTY3Ykhs6zNqlum/6m1uuZHzFFZnmTy4tuhelsjc83FvTyHQVCbJ06bkXCmx+WDCa+fw9BNc9r9x1JtMDzIBqNT0avINWCeuIBEoqFaTOguP3XYTSjyBQ5qQAsoi0shrNGcmHA/2RqKVpHMh5U0tIBKkWzwsdw60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721982714; c=relaxed/simple;
	bh=GMnnVONRExBFih6kJMj9Wc3cfqI9J4A6HZ2pDZyWjeE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kGpR9ITQd6K2LFYxtIPtZZk21Aptv4QHwb30xEtGis0J3AhuWGG9r3/WxgP+LuLmZustRML3ujQyBjB48JL8nW8o6va9Jqr7uQHpcl+4BZgzTPGmpI207psSQGmIOMu4cnelOn26OfPVBI5jGz/ubi27Wpu+br5Aprj6cuPm7ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=srhshcfb; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46Q7SJ2H004905;
	Fri, 26 Jul 2024 08:31:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:in-reply-to:references:date:message-id
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	iENWra52OHXAvIK10QZTUvU9+u8TKBkpxMzwlLx8VB0=; b=srhshcfb4izpU9sG
	ldTwxO1SIaHqXYx1e9fzjk6Y+y84ySPTErSAEWGYk59Yig9KJPzxXBkY88RaSeW5
	9806naAlZ+VlzRZnF6xUPqzfq09LQQFsksM5fGOsieHryxyjfx/Wn+ShAVgskKg+
	2YDPyUnU6pbLIPTb3RTYpumzVwn0Ei36yOTNIfSkr2cISmbBo+alUo80hkPcsxyX
	LPD1e0cPyWkXk8tmz75JPIeQv8duHrYLgWQ9XqLK5tRgaWrdA64JGMRGJ/vvGgcF
	rXy7NZ6CqXRPbvvMweyCi5+cdqpQMxMeX5qqFjx9bWDEDSbI2Ytt5L5FmnBgz7m7
	LeG72Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40m3x18k50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Jul 2024 08:31:50 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46Q8Vnvt015918;
	Fri, 26 Jul 2024 08:31:49 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40m3x18k4v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Jul 2024 08:31:49 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46Q6wss3006625;
	Fri, 26 Jul 2024 08:31:48 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40gxn7swvk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Jul 2024 08:31:48 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46Q8VgbF26739250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 08:31:44 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D82D2004B;
	Fri, 26 Jul 2024 08:31:42 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F102320040;
	Fri, 26 Jul 2024 08:31:41 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.179.0.55])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 26 Jul 2024 08:31:41 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: linux-s390@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
        Nicholas
 Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr
 <nrb@linux.ibm.com>, Steffen Eiden <seiden@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 0/3] s390x: small Makefile improvements
In-Reply-To: <20240604115932.86596-1-mhartmay@linux.ibm.com>
References: <20240604115932.86596-1-mhartmay@linux.ibm.com>
Date: Fri, 26 Jul 2024 10:31:40 +0200
Message-ID: <871q3g7dw3.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XkaZV6POofjgD772eJtSsTe6zflIN92V
X-Proofpoint-GUID: jYvbfCPAnTQaR9IWGLOrz78SDfiNEjwP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_07,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 mlxlogscore=987 clxscore=1011 impostorscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407260054

On Tue, Jun 04, 2024 at 01:59 PM +0200, Marc Hartmayer <mhartmay@linux.ibm.=
com> wrote:
> The first patch is useful anyway, the third could be dropped to be consis=
tent
> with the other architectures.
>
> Marc Hartmayer (2):
>   s390x/Makefile: snippets: Add separate target for the ELF snippets
>   s390x/Makefile: snippets: Avoid creation of .eh_frame and
>     .eh_frame_hdr sections
>
> Super User (1):
>   Revert "s390x: Specify program headers with flags to avoid linker
>     warnings"
>
>  s390x/Makefile              | 16 ++++++++++------
>  s390x/snippets/c/flat.lds.S | 12 +++---------
>  2 files changed, 13 insertions(+), 15 deletions(-)
>
>
> base-commit: 31f2cece1db4175869ca3fe4cbe229c0e15fdaf0
> --=20
> 2.34.1
>
>

Polite ping.

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

