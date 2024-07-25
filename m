Return-Path: <kvm+bounces-22245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1725093C443
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4971C1C217B4
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE1E19D068;
	Thu, 25 Jul 2024 14:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fjWaSQRE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3C913DDB8;
	Thu, 25 Jul 2024 14:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918061; cv=none; b=kbA9x3j44X9gs/raUooGVE6qjvs6gLWSjc8BAQ2Z4RpYqq6Q4XkGrIogS9V+VHslHDrBOw3euNgD2Sq1sWNDEtc4erhzmexb0cIu6xe6MfHLlkMl3lBgs/ORJ5znogFtMlQRbtMwg3J/0THpBJQgnnxG+8h+F1rfexB97BW3DdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918061; c=relaxed/simple;
	bh=Lvi5mM59A8lgVBo2s+yZRNqFzHpO44burmeJPCGvcNU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SPjmPFwyU/p+yThmLhjPPk380CCiU1K8rgGJlUbcHNvpaQTntToMiH9eB09RRjguWslrkDA7Ez37Imnn5FmQV1vbOM3ZElH6SiDbIiQ3BwFW9PVzhWFCcW6VIoVFwk/zWFCfsS3xxCu52eP4vbsPhLEFLzwgqITRgdSx2gSUQOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fjWaSQRE; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46PEQ5fu025352;
	Thu, 25 Jul 2024 14:34:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	/HgKCcOq0agk4VZv081eM+tET9exaj5JrSAiUPnyWOo=; b=fjWaSQRE+ZHBRfV5
	53bfnmLiMf3Ifnz5rZdPkwTyazAa7xdFrnTdrMwcYl+Q9eYqmbUfncjhS8jh7Ei1
	X5VzoGK75wasYIbly1gqGw06TcUrusaykIXp0MIH4pHCrUu/w3ZDpeFuZx2+EM/8
	7Re2ONLYxcjUvWCPPoFTTbnq9+DmevwFIE4RCOHg5xD6aUA4MJqJZzcRRqq7h7ID
	Io+IqCgZ+Kq3WmdLpeQ+4ZQ9fxD0EUCMZwkyMpJBpI+ep/kUw7oh/78GKqMj8piw
	wwFW+QAO8wxxnne73XQ2IwHhoxPb74o2ZylKJNNQjFStfMC4CypepBYSybJtPMy6
	pVdNAQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kdgx1jt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:34:17 +0000 (GMT)
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46PEYHmR008061;
	Thu, 25 Jul 2024 14:34:17 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kdgx1jt1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:34:17 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46PCYKQx018513;
	Thu, 25 Jul 2024 14:34:16 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40kk3hha8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:34:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46PEYAgr27197980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jul 2024 14:34:12 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6AF52004B;
	Thu, 25 Jul 2024 14:34:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3385B20040;
	Thu, 25 Jul 2024 14:34:10 +0000 (GMT)
Received: from darkmoore (unknown [9.179.29.251])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 25 Jul 2024 14:34:10 +0000 (GMT)
Date: Thu, 25 Jul 2024 16:34:08 +0200
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        nrb@linux.ibm.com, npiggin@gmail.com, nsg@linux.ibm.com,
        mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: Move SIE assembly into new
 file
Message-ID: <20240725163408.724e456c.schlameuss@linux.ibm.com>
In-Reply-To: <20240718105104.34154-4-frankja@linux.ibm.com>
References: <20240718105104.34154-1-frankja@linux.ibm.com>
	<20240718105104.34154-4-frankja@linux.ibm.com>
Organization: IBM
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7-vkmDaPfF6Ar4ufFIHWOe7lIIenqYDf
X-Proofpoint-GUID: l9ddxCeCtr89DLvtoEuR0K8eb1_68RsO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-25_13,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407250099

On Thu, 18 Jul 2024 10:50:18 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> In contrast to the other functions in cpu.S it's quite lengthy so
> let's split it off.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  s390x/Makefile             |  2 +-
>  s390x/{cpu.S => cpu-sie.S} | 59 +----------------------------------
>  s390x/cpu.S                | 64 --------------------------------------
>  3 files changed, 2 insertions(+), 123 deletions(-)
>  copy s390x/{cpu.S => cpu-sie.S} (56%)

[...]

> diff --git a/s390x/cpu.S b/s390x/cpu-sie.S
> similarity index 56%
> copy from s390x/cpu.S
> copy to s390x/cpu-sie.S
> index 9155b044..9370b5c0 100644
> --- a/s390x/cpu.S
> +++ b/s390x/cpu-sie.S
> @@ -1,6 +1,6 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
> - * s390x assembly library
> + * s390x SIE assembly library
>   *
>   * Copyright (c) 2019 IBM Corp.
>   *

Should we not also update the Copyright here? At least to 
"Copyright (c) 2019, 2024 IBM Corp."?

[...]

