Return-Path: <kvm+bounces-37222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5AF4A26F49
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 11:26:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 665783A5DAA
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 10:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C7020969D;
	Tue,  4 Feb 2025 10:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="CBaedX66"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AE4207A1D
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 10:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738664774; cv=none; b=gwHFB2Gauls1MJsRWdO7QOPn5b9ub9VqsFRJklQV1qKnmRydHZ9WUkokPLnqTfw24yrUN8tetMcCXBbcqMjebYbxd6APLLk/h+9CQXGu1G5Qwe/TCPqC7X5nzH+4gs2HaFWIMDVZ5CPTf7ZF0005MbeNm01Q1vGTDBRoIZUfA2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738664774; c=relaxed/simple;
	bh=p2Q2gUrWhMkp0enhN/vMtR4z9uYlZGmSnRxEgoWPVpY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=m0ojCsRgqFwCBLDAozrHXnudKifUZ1RafmHKOjQOI+STC/zzVOZqsdBBXj/VR7UV0e5uhOozkDfYZCxFRP8tT3VzXKjpcrnB+Jor08dCU4+w5obz2Ecx2zyQlKkr+jokutSRKMMaxDOqBFm9MAeNryRw+u+nrSpnKiLuyqc+NXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=CBaedX66; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5145NkXd008364;
	Tue, 4 Feb 2025 10:25:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=p2Q2gU
	rWhMkp0enhN/vMtR4z9uYlZGmSnRxEgoWPVpY=; b=CBaedX66yDvEssiJ6HnMXr
	oVjZ1gC/tdCAnLha0xHd2+I9PHHZKA7zT6/I+5wM3LyVcDs4knl3oXO4PJELobIY
	FuR20stbLslURqorBHKw7Gkf4nAJ40Lrq9UUmqDnBqLJ9YecPhT4QUUarOGbvPgK
	Mb3ptSkKORlQltFjE+JZh0yZRJH4pAzRqAGH05qhLTdXH5/hLA9nnJzUX8ZfDY10
	geo1LlIxZfmKechLLLZjEvD3w22ryPdVFDkHgrrpODs/LuAQL+iEoZEuhRJVOenx
	Pn227GwwT1tUKQ77dmHIjJOwSlylLseIqzWMVeHa9k9QVUcTcgoOGEuAB7ThndGg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44kcq7sbvj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Feb 2025 10:25:51 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5147oYPp016280;
	Tue, 4 Feb 2025 10:25:50 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44hwxsb66r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 04 Feb 2025 10:25:50 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 514APlCD55771512
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 4 Feb 2025 10:25:47 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EDAA02004E;
	Tue,  4 Feb 2025 10:25:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D224420040;
	Tue,  4 Feb 2025 10:25:46 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.3.166])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  4 Feb 2025 10:25:46 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Feb 2025 11:25:46 +0100
Message-Id: <D7JL7PZRWG6Z.3AS6HJAFZX6JA@linux.ibm.com>
Cc: "Janosch Frank" <frankja@linux.ibm.com>, "Thomas Huth"
 <thuth@redhat.com>,
        =?utf-8?q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        "Andrew Jones" <andrew.jones@linux.dev>,
        "Paolo Bonzini"
 <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v1] editorconfig: Add max line length
 setting for commit message and branch description
From: "Nico Boehr" <nrb@linux.ibm.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, <kvm@vger.kernel.org>
X-Mailer: aerc 0.18.2
References: <20250131115307.70334-1-mhartmay@linux.ibm.com>
In-Reply-To: <20250131115307.70334-1-mhartmay@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i--6P0OUOqWTKuzx-GdmAJ6L7vDfGWRh
X-Proofpoint-ORIG-GUID: i--6P0OUOqWTKuzx-GdmAJ6L7vDfGWRh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 spamscore=0 priorityscore=1501
 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502040080

On Fri Jan 31, 2025 at 12:53 PM CET, Marc Hartmayer wrote:
> Add max line length setting for commit messages and branch descriptions t=
o
> the Editorconfig configuration. Use herefor the same value as used by
> checkpatch [1]. See [2] for details about the file 'COMMIT_EDITMSG'.
>
> [1] https://github.com/torvalds/linux/blob/69e858e0b8b2ea07759e995aa383e8=
780d9d140c/scripts/checkpatch.pl#L3270
> [2] https://git-scm.com/docs/git-commit/2.46.1#Documentation/git-commit.t=
xt-codeGITDIRCOMMITEDITMSGcode
>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>

I don't use editorconfig, but it seems like a valuable thing to do, hence:

Acked-by: Nico Boehr <nrb@linux.ibm.com>

Thanks!

