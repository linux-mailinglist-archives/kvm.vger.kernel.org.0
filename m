Return-Path: <kvm+bounces-13901-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9920C89C91A
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 17:57:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB2431C24263
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0ED581420D5;
	Mon,  8 Apr 2024 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Bc4//Bvg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB88A22091
	for <kvm@vger.kernel.org>; Mon,  8 Apr 2024 15:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712591860; cv=none; b=CpRC7Vv1Zi8+/D/bpf9SgSavGzknQmkiR1y6HKN5o7oPoLaORdT64eTtqK8psENTCy/r2i6sq6PzDg0oGotNd436qFVtAPF3AZhgF2FtoTM5haTeLR2drg1gWa8U+7+4sLMzEUk4CpISPezKgq1cPUAPk46jj1iZiL6rA9UX7l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712591860; c=relaxed/simple;
	bh=KmN8pXzmPS9C+zTpyDDF126atEYnqqKhMpgKvQn8Pd4=;
	h=Content-Type:MIME-Version:In-Reply-To:References:Cc:To:From:
	 Subject:Message-ID:Date; b=bzPH0Zx2F+s2IihaNw8urGnUcAVPZ9mmg2THfjTBtFsNG22ImcvNVO9Pyn7LS3AedOzHZlnvHuoJTouQiJ5yLAoDlbaJb8SHSlLifRpVA77KZp3/zjXYoe2Pi71h9rhVvb07v0V3holuGxj2N4Ff5T9UPi6tjy/2Ilm2RpX1vVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Bc4//Bvg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 438FtRrs031161;
	Mon, 8 Apr 2024 15:57:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=KmN8pXzmPS9C+zTpyDDF126atEYnqqKhMpgKvQn8Pd4=;
 b=Bc4//Bvg/S9abrH/E57xm4l5CgWB2VuC9cZi6UT6KhYexbiIu4p0nTX3zK91s95xOz8e
 oDiSWY+siCOwnzqyRh9uk2tfku0BJP6o5O/HV8xUArknVt2SBT2ft1ougjxJBje7tXgf
 EADTENHW/Wwmjk3a4fthpGmY9BY0aH+Fe6/ysxifOaHLWxm7YIZW1SEvct/AzQz2JXbl
 ZXPZ5EED5skwKUetrQ3hNxYA8MWpNW+yK8nMnihbnPcMzip87lrMpKy0c81IFBDiF88R
 iYDOUpzrE/Czhh4FG4m+W4+38fjlA4ZRwura0g85MxljrPrpqFaDfnb2udpDI+CGqr2E xA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xck8081v2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 15:57:25 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 438FvOGM001415;
	Mon, 8 Apr 2024 15:57:24 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xck8081uy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 15:57:24 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 438EGVbP013594;
	Mon, 8 Apr 2024 15:57:23 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3xbgqt96g6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Apr 2024 15:57:23 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 438FvKfk31654532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Apr 2024 15:57:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFE692004B;
	Mon,  8 Apr 2024 15:57:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AFC2C20043;
	Mon,  8 Apr 2024 15:57:19 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.39.74])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Apr 2024 15:57:19 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240405083539.374995-5-npiggin@gmail.com>
References: <20240405083539.374995-1-npiggin@gmail.com> <20240405083539.374995-5-npiggin@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>, Laurent Vivier <lvivier@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org
To: Nicholas Piggin <npiggin@gmail.com>, Thomas Huth <thuth@redhat.com>
From: Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v8 04/35] (arm|s390): Use migrate_skip in test cases
Message-ID: <171259183982.48513.4621854263016449501@t14-nrb>
User-Agent: alot/0.8.1
Date: Mon, 08 Apr 2024 17:57:19 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WvvrAYk1eNdisLzf_Jt3swG_pnL4iGIq
X-Proofpoint-GUID: thx2ta3EUP6_hwSXn20sQbJ-IGXKBSAL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-08_14,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 phishscore=0 bulkscore=0 adultscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=666 priorityscore=1501 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404080123

Quoting Nicholas Piggin (2024-04-05 10:35:05)
> Have tests use the new migrate_skip command in skip paths, rather than
> calling migrate_once to prevent harness reporting an error.
>=20
> s390x/migration.c adds a new command that looks like it was missing
> previously.
>=20
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>

Thanks for finding the missing skip!

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

