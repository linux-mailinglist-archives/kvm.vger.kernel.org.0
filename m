Return-Path: <kvm+bounces-15465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D383D8AC5D7
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 09:45:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DACB283257
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 07:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B2EF4F5FA;
	Mon, 22 Apr 2024 07:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mo12oYDq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD324F20C;
	Mon, 22 Apr 2024 07:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713771835; cv=none; b=paGjAtOy/hR+8o9+uIfCrNfZSLAzeUjwcisqU/0qexPsR8r5tNKvBicdZGS61bzyu/CH1XvNR2EfK4fZeYWnLopRxUj9IlwEuh6EHdvjQWj0Sxp+TGHYByLzO1YMM9/M/aDyLErCSuMC61qmiYWZygYNXGBjACu/wvMUJEnBYOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713771835; c=relaxed/simple;
	bh=5WRrp2XlCBbaYWPMG2K05cHdvPj+ojQddV0PAVsqUck=;
	h=Content-Type:MIME-Version:In-Reply-To:References:From:Cc:Subject:
	 To:Message-ID:Date; b=pXj2a4RUhhRHqkTKbBs7WIQJGM08oqDAyzgTW5cL91D8C0cIVSh/aBqiwLtS1oUiNHjNiQk31RHPaJl0DM92d2VhJdXnJ9Yqt6lAqMKS1MOOiYjm1tUPW+6Y5lV0UcKa03m/CI3a3TTJldFFwf1uSQUNYpimLMBncUNOHRc4hRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mo12oYDq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43M6Y6xI006118;
	Mon, 22 Apr 2024 07:43:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : cc : subject : to : message-id : date; s=pp1;
 bh=aScYhJOHOcLVhAWwC78J6jMDinp6nCGDxDPg3cyBaHY=;
 b=mo12oYDqlF5GBwP+RQclj7YSn+EbVP0QQcgXasYRa3izQO4ZQQEWxcyPhQtB84DK7FsI
 WlVAPTcjWTlWIBIlgq0UXjcWyCX9P2rnG7R+JGGqSr2XjaBcrCRZiBHbAb/ZtE0LGhSk
 zA2AAd1wgSWUxZbgrYm3FSBGB0XrhC7gRuU3VvqsupWjIOpNPtQYbu80dDLgKTiNkKsp
 +GvUiEEaFI1b0aAS1y7uLTGA0uAo3tjvD8mEr9k/YavVsNNVDdEqxT873rAh0y56HITm
 5G0eiQH/yDlQjSzWQUaUJ4TfgGl73VJ9VxV3xSHtEIJkv0mPe8ZYA2KjeMWbwM+XL+y1 /w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnjq804pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 07:43:52 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43M7hpXW024022;
	Mon, 22 Apr 2024 07:43:51 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xnjq804pn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 07:43:51 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43M6a6ud023012;
	Mon, 22 Apr 2024 07:43:50 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xms1npdew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Apr 2024 07:43:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43M7hi7R18088380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Apr 2024 07:43:47 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DBC1E2004D;
	Mon, 22 Apr 2024 07:43:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBED220049;
	Mon, 22 Apr 2024 07:43:44 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.40.163])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Apr 2024 07:43:44 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20240201142356.534783-3-frankja@linux.ibm.com>
References: <20240201142356.534783-1-frankja@linux.ibm.com> <20240201142356.534783-3-frankja@linux.ibm.com>
From: Nico Boehr <nrb@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests RFC 2/2] lib: s390x: css: Name inline assembly arguments and clean them up
To: Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Message-ID: <171377182433.14316.15188579220205837716@t14-nrb>
User-Agent: alot/0.8.1
Date: Mon, 22 Apr 2024 09:43:44 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Zuf2ESIbACEZbowOvwK844F4A_dNpinX
X-Proofpoint-ORIG-GUID: ZML52YoSLp85LC0Sl7VzlhAdaZqGa1w1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-22_04,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 clxscore=1011 priorityscore=1501 suspectscore=0 spamscore=0
 mlxlogscore=887 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2404010000 definitions=main-2404220035

Quoting Janosch Frank (2024-02-01 15:23:56)
[...]
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 504b3f14..e4311124 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
[...]
> @@ -167,11 +167,11 @@ static inline int msch(unsigned long schid, struct =
schib *addr)
>         int cc;
> =20
>         asm volatile(
> -               "       msch    0(%3)\n"
> -               "       ipm     %0\n"
> -               "       srl     %0,28"
> -               : "=3Dd" (cc)
> -               : "d" (reg1), "m" (*addr), "a" (addr)
> +               "       msch    0(%[addr])\n"
> +               "       ipm     %[cc]\n"
> +               "       srl     %[cc],28"
> +               : [cc] "=3Dd" (cc)
> +               : "d" (reg1), [addr] "a" (addr)

I think there was a reason why the "m"(*addr) was here. Either add it back
or add a memory clobber.

I will only take the first patch of this series for now.

