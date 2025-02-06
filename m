Return-Path: <kvm+bounces-37519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA652A2AED0
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 18:28:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 008913A9395
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 17:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F93B1714D7;
	Thu,  6 Feb 2025 17:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E0xd5m6P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408761607A4;
	Thu,  6 Feb 2025 17:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738862888; cv=none; b=gvJfSUdt2rQ9PAt8slylE9NNva9SYwRZ6QbSPgWaDs9KbTjbWlE64g6bCLYreBzuWPcbcBJCrr8HAQ/kEUc0y77iKkNQbhuXpzLSRlBfshshAo3NAerXTiSyVzhnD/7HlKsRdwswIshdu0Z64mKnSUrfqCqfYaS5eVxAA8yQnsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738862888; c=relaxed/simple;
	bh=M8ddQlqhCpcRIqT5QtF55a8ZulR5rv2S6xHmPkwn48k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UvSdQSHiwbBOPrRdvtFLwqpQ/MPl2QclbPLnghDGMLtY0YMzXN2ULH/uALd3WFtzXMLXWAif7akUwXaNCA81eQ5JWpfJH3Qot/8O6qLqzvpTwyO6C4jpsKYQOEtpuOmKPUS0OqR8BbxSp6C7e1OonOEpFYc4xd42RlDynemf4o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=E0xd5m6P; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 516Fdn0d011337;
	Thu, 6 Feb 2025 17:28:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=pkJMle
	NkGyXi0hGfx9+L829MwymktZy7l3kQBoZ/U5s=; b=E0xd5m6P4sJYvL/B5Xy16y
	tId8OhW3flTT5Q4WfTtFm+SNk25+5TD0n29zqJxeP2c8jH4sjy7P7S9ktFwCk4Is
	OWJuZYtetk9bi5up4MWRqOPZeRtpJDxF96AdqgOq0UmDrw/3YLtYRC2+z/+HHN7V
	9hJ4d43DpGubijJHZ02VenCdDXWrykYuxc4Tag8FEoTgAKAT0tofWrvnWoV7vvP3
	YhH7DKLx/9qUyWbFI20AaIrh67N2cSc9EO93Li2RW2+v3N+i339HgjOLRli0m+lb
	gbbikYDi/8v1hGXvrotQKZVkfvgDsOxQEhDeRWr1DFBBdwXmeEgYy6f+QqJ9po2w
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44mywtrkr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 17:28:03 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 516GOwHo021554;
	Thu, 6 Feb 2025 17:28:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 44j0n1q41w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Feb 2025 17:28:03 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 516HRxns58851628
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Feb 2025 17:27:59 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 931BF20043;
	Thu,  6 Feb 2025 17:27:59 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 444FB20040;
	Thu,  6 Feb 2025 17:27:59 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.19.151])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu,  6 Feb 2025 17:27:59 +0000 (GMT)
Date: Thu, 6 Feb 2025 18:27:52 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, nrb@linux.ibm.com,
        hca@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH] lib: s390x: css: Cleanup chsc inline
 assembly
Message-ID: <20250206182752.666c356a@p-imbrenda>
In-Reply-To: <20250206150128.147206-1-frankja@linux.ibm.com>
References: <20250206150128.147206-1-frankja@linux.ibm.com>
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
X-Proofpoint-GUID: HVVDu6-GeTAK20Q8cDD35zXPwNf_ULm7
X-Proofpoint-ORIG-GUID: HVVDu6-GeTAK20Q8cDD35zXPwNf_ULm7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-06_05,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 spamscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502060137

On Thu,  6 Feb 2025 14:58:49 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Name the CHSC command block pointer instead of naming it "p".
> 
> Also replace the two "m" constraints with a memory globber so the
> constraints are easier to read.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> 
> To me it makes more sense to have a separate commit that has a message
> explaining why we changed it instead of sending a v2, so here it is.

makes sense

> 
> ---
>  lib/s390x/css.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index 06bb59c7..167f8e83 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -364,16 +364,16 @@ bool get_chsc_scsc(void);
>  #define CHSC_RSP_EBUSY	0x000B
>  #define CHSC_RSP_MAX	0x000B
>  
> -static inline int _chsc(void *p)
> +static inline int _chsc(void *com_blk)
>  {
>  	int cc;
>  
> -	asm volatile(" .insn   rre,0xb25f0000,%2,0\n"
> +	asm volatile(" .insn   rre,0xb25f0000,%[com_blk],0\n"
>  		     " ipm     %[cc]\n"
>  		     " srl     %[cc],28\n"
> -		     : [cc] "=d" (cc), "=m" (p)
> -		     : "d" (p), "m" (p)
> -		     : "cc");
> +		     : [cc] "=d" (cc)
> +		     : [com_blk] "d" (com_blk)
> +		     : "cc", "memory");
>  
>  	return cc;
>  }


