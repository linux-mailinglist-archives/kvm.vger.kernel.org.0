Return-Path: <kvm+bounces-22484-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 07E8393EED1
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 09:45:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3899F1C21BE9
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 07:45:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D3D13E028;
	Mon, 29 Jul 2024 07:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N0vsiRi/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D994113BAE3;
	Mon, 29 Jul 2024 07:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722238931; cv=none; b=BDLdp+llbJtmtCxFP9GTw+VdGXq63RJjOumNepwcXNp8MYaEe1pZx15bLjuA0PMuZwnHgHPtQkHV3gRPNVwTxbmAV6JXan1E45IgF+Y5NY3BjMM9Z1nWPfjiZVYRfFNf+r0Dt73IPP20cTEzFBmumSjt/OTiVaeJIOoJQxgDMm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722238931; c=relaxed/simple;
	bh=CFkUsARNX/VdUV/6OrvXxJCl8G2ULrIF/o9MLMWDVgQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YE8he6XW6c1awPiTLq3TZJTY21QHPBRTLT9szxS55zLDbSkMdGuc/nC00Y1dbMgYCTQW+9caX+xctwI998ZvAiy2eHk4j3Ciyp5fg/4wUOCImvdmAHgAHYdKpIfyCsroiB/OpfiIIVsNdyGXmHkZHEnWUSObSlwu2WtB9HoIBiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N0vsiRi/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46T6ukZO008808;
	Mon, 29 Jul 2024 07:42:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:in-reply-to:references:date:message-id
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	G6c3m7ROyba/8ZiFLEJb3NUolP5Qm0AiHZz4CD3VWzg=; b=N0vsiRi/960t0/s1
	goK3W7+7NmgC1Lv7hkRDNRvN15ZFovfSesosTXO9F9gDzIqUwPS5OxarJpZ4Y1si
	LBxGzRkbJQ7PXRbB8lMaOsM7MMDqfjOfFyWYKpSkPuQAOUAhyVaUkWIosNyzWywh
	VfftjqSFISs001C2VQhFv/FTUCvzVJxLefJ3+79Ip5QRzszUmW0CvMRrYy5IGxSp
	auW3+MAAlHssy8DWThiMpT8SRRoFdL1QXXqde242RtKENJkJaKL/1F2LuOn0sRuV
	Lot8u3Up/ziqKMJPgK7jzEu5HftOOdlBBEoOd/8Sbg1/IrFw4u/M/PXKETrjaoLd
	ytNfSA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40mputc6ee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Jul 2024 07:42:06 +0000 (GMT)
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46T7c6cm015501;
	Mon, 29 Jul 2024 07:42:05 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40mputc6ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Jul 2024 07:42:05 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46T6v96a018776;
	Mon, 29 Jul 2024 07:42:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40nc7pdfye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 29 Jul 2024 07:42:05 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46T7fx6s38535670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jul 2024 07:42:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B3842004B;
	Mon, 29 Jul 2024 07:41:59 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DC1820043;
	Mon, 29 Jul 2024 07:41:59 +0000 (GMT)
Received: from li-1de7cd4c-3205-11b2-a85c-d27f97db1fe1.ibm.com (unknown [9.171.68.163])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 29 Jul 2024 07:41:58 +0000 (GMT)
From: "Marc Hartmayer" <mhartmay@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>, linux-s390@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>, Nicholas Piggin <npiggin@gmail.com>
Cc: kvm@vger.kernel.org, Nico Boehr <nrb@linux.ibm.com>,
        Steffen Eiden
 <seiden@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x/Makefile: snippets: Add
 separate target for the ELF snippets
In-Reply-To: <7a7405e6-49fe-4322-a010-1b3af5c50df4@linux.ibm.com>
References: <20240604115932.86596-1-mhartmay@linux.ibm.com>
 <20240604115932.86596-2-mhartmay@linux.ibm.com>
 <7a7405e6-49fe-4322-a010-1b3af5c50df4@linux.ibm.com>
Date: Mon, 29 Jul 2024 09:41:57 +0200
Message-ID: <875xsotzju.fsf@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FtxZQZ-CTLstnwD9kfz8_00sm09oAZJa
X-Proofpoint-GUID: 6GsOsX-3UlHCa10rwLqF9K44-0h1BQr3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-29_05,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2407110000 definitions=main-2407290049

On Mon, Jul 29, 2024 at 09:00 AM +0200, Janosch Frank <frankja@linux.ibm.co=
m> wrote:
> On 6/4/24 1:59 PM, Marc Hartmayer wrote:
>> It's unusual to create multiple files in one target rule, and it's even =
more
>> unusual to create an ELF file with a `.gbin` file extension first, and t=
hen
>> overwrite it in the next step. It might even lead to errors as the input=
 file
>> path is also used as the output file path - but this depends on the objc=
opy
>> implementation. Therefore, create an extra target for the ELF files and =
list it
>> as a prerequisite for the *.gbin targets.
>>=20
>> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
>
> I've picked this one but it's unlikely that I'll pick the other patches=20
> in the series. Thanks for improving the makefile and fixing my
> mistakes :)

Thanks for the r-b and fine with me. The other two patches are not as
useful and would make s390x even more different from other architectures
with little to no real benefit.

>
--=20
Kind regards / Beste Gr=C3=BC=C3=9Fe
   Marc Hartmayer

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Wolfgang Wendt
Gesch=C3=A4ftsf=C3=BChrung: David Faller
Sitz der Gesellschaft: B=C3=B6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

