Return-Path: <kvm+bounces-7755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1680845EEE
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:52:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE55FB28D57
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:52:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D2B67C6EA;
	Thu,  1 Feb 2024 17:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cakyn+Dq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9173F7C6CA;
	Thu,  1 Feb 2024 17:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706809945; cv=none; b=U7m1iQb9jJjw3+kcPTaay2J0urLuH1nZZONHHMVydMRuEp4cP+GiZVCP9tmklm+1ysCksS23tg6NzTjvN7XBC4WEtc2mrZcpKCycvz5/8cuUL2KsRzA39M8hVUPOOYlhY0HbRuPlSeN95iDCek/1nIJeqaf43CUr8I25s6R2QH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706809945; c=relaxed/simple;
	bh=vKGVOt3qDY/BbZWbDGXKexzYGxavNrzwHlou1tNwrwg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hWuAgZsz1UwaBm4K8ZECr3tCl7ptbb9FPdsmo5lWMqzu3Kw3TyK+dlEgNQk3LTr8uPtsfrcUIDU6gJ2C1vdRUUemQiYPon/H5m6foWQT5yulp+95j/vOGx0UrExk/nsa+1EydlgboqiQx5ElAtgOME8OW1C5pN3XHapVv77YuhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cakyn+Dq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411HOVFk027203;
	Thu, 1 Feb 2024 17:52:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=9jHM+F2W8hB/Kpbn1Kor3AqkqKDgnCHSoCprrPdaBgs=;
 b=cakyn+DqeNwhdY2wMCSd1kdBYUAoBHP0tduph7RvwNmSYV2XPQCxI867cuqORE3y0p41
 hVoIXRywyX3MlXsFfOsyDXWKRwpIeyO1N/6jF6BEKX/6W4Z7cp3C5Xjj4vTTMYwuqGTF
 6KzOwReu1+nuDG4IUNBGg01lqkkRG9FPG1DAmPBp7xkp8Kk/3VliHMObJ/XSg3k0sit1
 1NVvzpdfaovW0/0tH17am68EGMispiVR1vL+nfGmQE4XZqpsh10JpLPyjD7bB9YaWVpd
 bpJ8fLCLj/mZUDQwWEck85bt8VNoW+N57uPbrvMGc6wlFAHwn/i5bBRZIMfKzq0gcI+y sg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0e5x3m22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 17:52:22 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 411G1BVB017203;
	Thu, 1 Feb 2024 17:52:22 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0e5x3m1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 17:52:22 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 411GKCR8007188;
	Thu, 1 Feb 2024 17:52:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vwev2nk60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 17:52:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411HqI6O17957522
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 17:52:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 015E320043;
	Thu,  1 Feb 2024 17:52:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9668B20040;
	Thu,  1 Feb 2024 17:52:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.24.180])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu,  1 Feb 2024 17:52:17 +0000 (GMT)
Date: Thu, 1 Feb 2024 18:52:16 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests RFC 1/2] lib: s390x: sigp: Name inline assembly
 arguments
Message-ID: <20240201185216.08a5ad10@p-imbrenda>
In-Reply-To: <20240201142356.534783-2-frankja@linux.ibm.com>
References: <20240201142356.534783-1-frankja@linux.ibm.com>
	<20240201142356.534783-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: rSu7dnpQblSmGtG2U_ImBXHTeYmdBZMC
X-Proofpoint-ORIG-GUID: a2MJ2jwwycFgTQvSvUbAUXV9xrmXIAyu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_04,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 adultscore=0 clxscore=1015
 impostorscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402010138

On Thu,  1 Feb 2024 14:23:55 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Less need to count the operands makes the code easier to read.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/sigp.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
> index 4eae95d0..c9af2c49 100644
> --- a/lib/s390x/asm/sigp.h
> +++ b/lib/s390x/asm/sigp.h
> @@ -54,11 +54,11 @@ static inline int sigp(uint16_t addr, uint8_t order, unsigned long parm,
>  
>  	asm volatile(
>  		"	tmll	%[bogus_cc],3\n"
> -		"	sigp	%1,%2,0(%3)\n"
> -		"	ipm	%0\n"
> -		"	srl	%0,28\n"
> -		: "=d" (cc), "+d" (reg1)
> -		: "d" (addr), "a" (order), [bogus_cc] "d" (bogus_cc)
> +		"	sigp	%[reg1],%[addr],0(%[order])\n"
> +		"	ipm	%[cc]\n"
> +		"	srl	%[cc],28\n"
> +		: [cc] "=d" (cc), [reg1] "+d" (reg1)
> +		: [addr] "d" (addr), [order] "a" (order), [bogus_cc] "d" (bogus_cc)
>  		: "cc");
>  	if (status)
>  		*status = reg1;


