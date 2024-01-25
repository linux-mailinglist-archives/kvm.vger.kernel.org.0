Return-Path: <kvm+bounces-7019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10D3583C692
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 16:30:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E2631C2297E
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 15:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 615DA6EB7E;
	Thu, 25 Jan 2024 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oIvgTAe0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5326EB5A;
	Thu, 25 Jan 2024 15:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706196609; cv=none; b=HPqrFHsU8ixurO8r9D/aG8mxA+cJp4pnmL5q0xzTgfmanMmdByVs4jxwfRePKtKOGjb4liYLJeZk5k2LMRFeS9jZeMcWt4gNcq4Gsf7dFlblcD0x2/h9ly6rz0tggv+rJ1Br8uwRviimmwieyeh5VgOKjk1WWav6I1LC+ZAAtRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706196609; c=relaxed/simple;
	bh=8sNYc6omXmo+sIVthIv8mFB9oMl5eKVxyEvARsj5RW0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZqneGkkXCilVe8a2glcAd+Cw3oUjxNb9YUMj3iG6dLPgjFDs0Vk2wF1WERQVOHxnZV1FSI0+5JacDuvuKKDvuyws66xeTcmUWYCeoINNZSv+oYfIjATxt0O4P+wcfCbdz5U5gRLc/XFPafsB4Il/vDH+tiefhPd0JNu7Ex0e7d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oIvgTAe0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40PFOi6F022094;
	Thu, 25 Jan 2024 15:30:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=oMxuBUn4Em3leAMa/T3nkqmsWa01MMp0NYPr8CZQ8Fc=;
 b=oIvgTAe00gzGMb+ZWquXCqpKbdSRo+kggvdfMscfl6gQpzCWzZEYk43idydEKbo3uFNJ
 +AJzmYGrLpKy/fBLZ3nbLkhRWiMP/ogeT204XxcSKzdmsehi8avUmCZ4kov3gqz2yyP1
 NOF7Hugnm1T/liLO8SVrPz7GDhDgvEt9a7oOunEl8rgmbkoWYUI/Fp9BgguKXRHhvkuc
 Z2Lo8jyhogQruXatUVhYw0EP8c7BLkF/hiXbQT2ysPKstlWqDLcnWu41xUnnenhBLN+n
 Ojcjf4Q/idlN+kS9s0bKFU+bZPSrviMX5edHP4on7Dck+f+SFjhuJGimVEfCG8EXktJ1 wg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vut8w03mg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jan 2024 15:30:06 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40PFRbbg029662;
	Thu, 25 Jan 2024 15:30:06 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vut8w03kw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jan 2024 15:30:06 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40PEfrak010860;
	Thu, 25 Jan 2024 15:30:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vrrw05884-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jan 2024 15:30:05 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40PFU1wA656008
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jan 2024 15:30:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACEEE20043;
	Thu, 25 Jan 2024 15:30:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F01420040;
	Thu, 25 Jan 2024 15:30:01 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.4.43])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 25 Jan 2024 15:30:01 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda
 <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>, Thomas Huth
 <thuth@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH] (arm|powerpc|s390x): Makefile: add
 `%.aux.o` target
In-Reply-To: <20240125151127.94798-1-mhartmay@linux.ibm.com>
References: <20240125151127.94798-1-mhartmay@linux.ibm.com>
Date: Thu, 25 Jan 2024 16:30:00 +0100
Message-ID: <87v87hsa6f.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _Vucir9Hl1bSbC9f_2fUeXBemDddGFeT
X-Proofpoint-GUID: clzHjQgHy02E05mGfUniUnb1aP4CzOcW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_08,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 spamscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401250107

On Thu, Jan 25, 2024 at 04:11 PM +0100, Marc Hartmayer <mhartmay@linux.ibm.=
com> wrote:
> It's unusual to create multiple files in one target rule, therefore creat=
e an
> extra target for `%.aux.o` and list it as prerequisite. As a side effect,=
 this
> change fixes the dependency tracking of the prerequisites of
> `.aux.o` (`lib/auxinfo.c` was missing).
>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---

Note: I have only tested it for s390x, so please take a close look!

--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

