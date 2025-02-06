Return-Path: <kvm+bounces-37518-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7A9EA2AECF
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 18:28:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 633CE168E0C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 17:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8365616EB42;
	Thu,  6 Feb 2025 17:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nv7fU46v"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1506D239572;
	Thu,  6 Feb 2025 17:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738862888; cv=none; b=eoNSS+Vj3DF/evWs9DDeiWhz4Jhuqh8aC/y20El6wQ+je6ArgXLYS7yuIj2suKrkq07+yUsioVFE1Jw2siZI4uxtvqOFXaQnRigwCVbjuDpLtrEJQeedyNnby3XkhKKEBoJCEU2NMtrckvsZRe+jZGRNVu4dBcBer83TF83QzAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738862888; c=relaxed/simple;
	bh=I1D8HIFxfi4EvDiIubeBCm2CKOjJ3YJAkHhs03SgKeo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tJPlZs04sHoxAXDy/iP5zqUOK29nhZgpnbV1t9tkZGC9UDEiA5/mzBKmMc9f0NxQMH/tx7OG6Tc1buWTfdtoC0Vb1b+IsIigz29suMsniLfgXVZ5KAf4VGa6wEJUAhB0qilPZkNgLFYJekIHHiNU3Kemg6UY46xbMPcKhGv0sUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nv7fU46v; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 516ESPfh009811;
	Thu, 6 Feb 2025 17:28:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=U7KGUP
	0KplSQNojFLq+iZErwGlgKyPg0MFmq8Ps2eSA=; b=nv7fU46vzIFNBAzttU95dJ
	JwgrIWwJptTVpijZnaH/ALZ0C5WR8pu2+1G6vDCQ0HIrTmmZgevBrOUF3KuEZpdl
	YQrBs+Jt2Wssq9OKTwtJFY0LkW8op384elFTGYhG7Of/brusCmIk2oKvEiKt9Jon
	cxmx9Rcu7TrubJXSo6F/tCgY3AK6juAYgEuGu6htAdUkH1k7ZeL2AHz6p6vRhBcb
	kNPISy0eL8mbq1+/dBteQgvaa//TGsLOLpKXnMkoWyX97vNTVOdJOWT8T9PIsHag
	P+kLDgdhTXG4NWoevuFYTO039xmwGJVZeeyqny04YlHbRlIQvTI8tpumw+FDol6w
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44mk5a4kse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 17:28:06 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 516FuVfB005251;
	Thu, 6 Feb 2025 17:28:05 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44j05k775x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 17:28:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 516HS19331916418
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Feb 2025 17:28:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6A5320043;
	Thu,  6 Feb 2025 17:28:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15B4020040;
	Thu,  6 Feb 2025 17:28:01 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.19.151])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu,  6 Feb 2025 17:28:01 +0000 (GMT)
Date: Thu, 6 Feb 2025 18:22:30 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, nrb@linux.ibm.com,
        hca@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH] lib: s390x: css: Name inline assembly
 arguments and clean them up
Message-ID: <20250206182230.68ec3c69@p-imbrenda>
In-Reply-To: <20250204100339.28158-1-frankja@linux.ibm.com>
References: <20250204100339.28158-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YaNjJ_jtQtwNOB5Fy136WNutC98QMXtm
X-Proofpoint-ORIG-GUID: YaNjJ_jtQtwNOB5Fy136WNutC98QMXtm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_05,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 mlxscore=0 malwarescore=0
 suspectscore=0 clxscore=1015 impostorscore=0 spamscore=0 adultscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502060137

On Tue,  4 Feb 2025 09:51:33 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Less need to count the operands makes the code easier to read.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


> ---
> 
> This one has been gathering dust for a while.
> rfc->v1: Moved to Q constraint (thanks Heiko)
> 
> ---
>  lib/s390x/css.h | 76 ++++++++++++++++++++++++-------------------------
>  1 file changed, 38 insertions(+), 38 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 504b3f14..42c5830c 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -135,11 +135,11 @@ static inline int ssch(unsigned long schid, struct orb *addr)
>  	int cc;
>  
>  	asm volatile(
> -		"	ssch	0(%2)\n"
> -		"	ipm	%0\n"
> -		"	srl	%0,28\n"
> -		: "=d" (cc)
> -		: "d" (reg1), "a" (addr), "m" (*addr)
> +		"	ssch	%[addr]\n"
> +		"	ipm	%[cc]\n"
> +		"	srl	%[cc],28\n"
> +		: [cc] "=d" (cc)
> +		: "d" (reg1), [addr] "Q" (*addr)
>  		: "cc", "memory");
>  	return cc;
>  }
> @@ -152,11 +152,11 @@ static inline int stsch(unsigned long schid, struct schib *addr)
>  
>  	asm volatile(
>  		"       tmll    %[bogus_cc],3\n"
> -		"	stsch	0(%3)\n"
> -		"	ipm	%0\n"
> -		"	srl	%0,28"
> -		: "=d" (cc), "=m" (*addr)
> -		: "d" (reg1), "a" (addr), [bogus_cc] "d" (bogus_cc)
> +		"	stsch	%[addr]\n"
> +		"	ipm	%[cc]\n"
> +		"	srl	%[cc],28"
> +		: [cc] "=d" (cc), [addr] "=Q" (*addr)
> +		: "d" (reg1), [bogus_cc] "d" (bogus_cc)
>  		: "cc");
>  	return cc;
>  }
> @@ -167,11 +167,11 @@ static inline int msch(unsigned long schid, struct schib *addr)
>  	int cc;
>  
>  	asm volatile(
> -		"	msch	0(%3)\n"
> -		"	ipm	%0\n"
> -		"	srl	%0,28"
> -		: "=d" (cc)
> -		: "d" (reg1), "m" (*addr), "a" (addr)
> +		"	msch	%[addr]\n"
> +		"	ipm	%[cc]\n"
> +		"	srl	%[cc],28"
> +		: [cc] "=d" (cc)
> +		: "d" (reg1), [addr] "Q" (*addr)
>  		: "cc");
>  	return cc;
>  }
> @@ -184,11 +184,11 @@ static inline int tsch(unsigned long schid, struct irb *addr)
>  
>  	asm volatile(
>  		"       tmll    %[bogus_cc],3\n"
> -		"	tsch	0(%3)\n"
> -		"	ipm	%0\n"
> -		"	srl	%0,28"
> -		: "=d" (cc), "=m" (*addr)
> -		: "d" (reg1), "a" (addr), [bogus_cc] "d" (bogus_cc)
> +		"	tsch	%[addr]\n"
> +		"	ipm	%[cc]\n"
> +		"	srl	%[cc],28"
> +		: [cc] "=d" (cc), [addr] "=Q" (*addr)
> +		: "d" (reg1), [bogus_cc] "d" (bogus_cc)
>  		: "cc");
>  	return cc;
>  }
> @@ -200,9 +200,9 @@ static inline int hsch(unsigned long schid)
>  
>  	asm volatile(
>  		"	hsch\n"
> -		"	ipm	%0\n"
> -		"	srl	%0,28"
> -		: "=d" (cc)
> +		"	ipm	%[cc]\n"
> +		"	srl	%[cc],28"
> +		: [cc] "=d" (cc)
>  		: "d" (reg1)
>  		: "cc");
>  	return cc;
> @@ -215,9 +215,9 @@ static inline int xsch(unsigned long schid)
>  
>  	asm volatile(
>  		"	xsch\n"
> -		"	ipm	%0\n"
> -		"	srl	%0,28"
> -		: "=d" (cc)
> +		"	ipm	%[cc]\n"
> +		"	srl	%cc,28"
> +		: [cc] "=d" (cc)
>  		: "d" (reg1)
>  		: "cc");
>  	return cc;
> @@ -230,9 +230,9 @@ static inline int csch(unsigned long schid)
>  
>  	asm volatile(
>  		"	csch\n"
> -		"	ipm	%0\n"
> -		"	srl	%0,28"
> -		: "=d" (cc)
> +		"	ipm	%[cc]\n"
> +		"	srl	%[cc],28"
> +		: [cc] "=d" (cc)
>  		: "d" (reg1)
>  		: "cc");
>  	return cc;
> @@ -245,9 +245,9 @@ static inline int rsch(unsigned long schid)
>  
>  	asm volatile(
>  		"	rsch\n"
> -		"	ipm	%0\n"
> -		"	srl	%0,28"
> -		: "=d" (cc)
> +		"	ipm	%[cc]\n"
> +		"	srl	%[cc],28"
> +		: [cc] "=d" (cc)
>  		: "d" (reg1)
>  		: "cc");
>  	return cc;
> @@ -262,9 +262,9 @@ static inline int rchp(unsigned long chpid)
>  	asm volatile(
>  		"       tmll    %[bogus_cc],3\n"
>  		"	rchp\n"
> -		"	ipm	%0\n"
> -		"	srl	%0,28"
> -		: "=d" (cc)
> +		"	ipm	%[cc]\n"
> +		"	srl	%[cc],28"
> +		: [cc] "=d" (cc)
>  		: "d" (reg1), [bogus_cc] "d" (bogus_cc)
>  		: "cc");
>  	return cc;
> @@ -369,9 +369,9 @@ static inline int _chsc(void *p)
>  	int cc;
>  
>  	asm volatile(" .insn   rre,0xb25f0000,%2,0\n"
> -		     " ipm     %0\n"
> -		     " srl     %0,28\n"
> -		     : "=d" (cc), "=m" (p)
> +		     " ipm     %[cc]\n"
> +		     " srl     %[cc],28\n"
> +		     : [cc] "=d" (cc), "=m" (p)
>  		     : "d" (p), "m" (p)
>  		     : "cc");
>  


