Return-Path: <kvm+bounces-27429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C86EC9861D1
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 17:02:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E54D1F2C763
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 15:02:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B9A617C989;
	Wed, 25 Sep 2024 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nAHGq7eZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0545518CBF1;
	Wed, 25 Sep 2024 14:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727275036; cv=none; b=DSB2EMOXMqqS4G8OS1+qu6MPyIOd00ithSsqewARnaXr/hFeZhug6gwAEEiutSS6WE5mdfqrQHTUuZJsvFthjtoXTgbjaSKuwTKwFnhNj8r8dC3XtQGB4OVL2d50Q87ivyiE7m7d89t0lYcPwUXg4RuOV+21pf79SqGqQVibbZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727275036; c=relaxed/simple;
	bh=33LMCYs4ZAMWUAeDvSpTN6EjILkxtvhX9lBP6A7goaE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mCrEISckdb3uL8ITOz/ykBHYbqQWvOyBeOsforqTdT6T30d1SDBK4IjWBCt/LJsvkbnzWzghUQ2ulxX2dHnE0JeZdyDKU+gCayFYrDL5R1Nw9PgwrXTyKrQCDbbP0e4EZszTF0wiu1tm0i+4UUhySybkpzZZtRK1eg51NDAAeqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nAHGq7eZ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48P1X8BE005761;
	Wed, 25 Sep 2024 14:37:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	b1uqCTj7RZo8GESVV5hiVMQ9MJSDCuFgBtvmHa3hTX0=; b=nAHGq7eZFjA6y0y0
	87wdzmZGA91T7HhktPHqyo29xzu49o4C1qf30g7ciIyVIbXMc4FYERsW86pfODQ1
	SUt2w6lcsYZoVAMaSFQ7au0LPeVXYbWo1Q1A5dvdXOEM16qw0vK4IDp6NgCeFfrs
	sfngaKyNILCTvslZUUN7ZJCbqWb9FsZlQlrPGPHRTulJEzkd3IXZO2m/+VX3mb3A
	0hI7LHl5JJcsJGCvYstm+Q9pZ7k3ejLRhiBV09tfV4oX7jQ15tm+SBdriKECk+xk
	dFSGlyvToG5FGVFGs20TEuMpWWEVEEcucLVFieUy6dP6Hz+JW6SgNZDN8bONj8HD
	rtfl0A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41snnagrwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Sep 2024 14:37:12 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 48PEXx4H018588;
	Wed, 25 Sep 2024 14:37:12 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 41snnagrwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Sep 2024 14:37:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 48PBx6tB001138;
	Wed, 25 Sep 2024 14:37:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 41t8futa5q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Sep 2024 14:37:11 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 48PEb7Bu47645160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 14:37:07 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7414720043;
	Wed, 25 Sep 2024 14:37:07 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 40E6220040;
	Wed, 25 Sep 2024 14:37:07 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 25 Sep 2024 14:37:07 +0000 (GMT)
Date: Wed, 25 Sep 2024 16:37:05 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/2] s390x: edat: move LC_SIZE to
 arch_def.h
Message-ID: <20240925163705.0f8235ce@p-imbrenda.boeblingen.de.ibm.com>
In-Reply-To: <20240923062820.319308-3-nrb@linux.ibm.com>
References: <20240923062820.319308-1-nrb@linux.ibm.com>
	<20240923062820.319308-3-nrb@linux.ibm.com>
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
X-Proofpoint-GUID: PeIcZLOMMc3C1Cy4krRnpFAHtaLTRG-E
X-Proofpoint-ORIG-GUID: dS9vUiRfknAdxqYmbvQwtYg3Mtntz0pY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_04,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 impostorscore=0 priorityscore=1501
 phishscore=0 bulkscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2408220000
 definitions=main-2409250103

On Mon, 23 Sep 2024 08:26:04 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> struct lowcore is defined in arch_def.h and LC_SIZE is useful to other
> tests as well, therefore move it to arch_def.h.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

I find this patch a little weird here, since it's not used for the
previous patch, and doesn't seem to have anything to do with it either.

the patch itself is otherwise good, I'm just a little puzzled.

nonetheless:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 1 +
>  s390x/edat.c             | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 745a33878de5..5574a45156a9 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -119,6 +119,7 @@ enum address_space {
>  
>  #define CTL2_GUARDED_STORAGE		(63 - 59)
>  
> +#define LC_SIZE	(2 * PAGE_SIZE)
>  struct lowcore {
>  	uint8_t		pad_0x0000[0x0080 - 0x0000];	/* 0x0000 */
>  	uint32_t	ext_int_param;			/* 0x0080 */
> diff --git a/s390x/edat.c b/s390x/edat.c
> index 16138397017c..e664b09d9633 100644
> --- a/s390x/edat.c
> +++ b/s390x/edat.c
> @@ -17,7 +17,6 @@
>  
>  #define PGD_PAGE_SHIFT (REGION1_SHIFT - PAGE_SHIFT)
>  
> -#define LC_SIZE	(2 * PAGE_SIZE)
>  #define VIRT(x)	((void *)((unsigned long)(x) + (unsigned long)mem))
>  
>  static uint8_t prefix_buf[LC_SIZE] __attribute__((aligned(LC_SIZE)));


