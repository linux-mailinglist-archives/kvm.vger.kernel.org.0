Return-Path: <kvm+bounces-7584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00981843EE6
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 12:57:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3E1C28EDC0
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E06227690F;
	Wed, 31 Jan 2024 11:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h1kcoIRd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510F069E08;
	Wed, 31 Jan 2024 11:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706702215; cv=none; b=l/lznBjRUrTvErm1kbDJnMw+MiE1MIWcRgNCjuiXBFz+wdiD+80KD6mCRKnvTsYiZDa0C+WyKWwzDkLM5tzTEkmRKKThUQIkOdUkG8CX213gCByG4aYMJz1w6ByejpapgmSKyuagSDoB47V1ByTre03iayozOA+1cRFEipNg84g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706702215; c=relaxed/simple;
	bh=On5M1nwx4dbdywb6fvXVu3XL6d6kWMi9Tks0UaCFN0c=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z30XRvlIlAek/pLcOLvjDeltrQwJ3QibAb5K4IdZdxGGNHGshnp/54ToX8VYNdzYn6HCjsjkmUwK7lW0HFZRIgVQn0qwaWzEgy0thM1gwERxEQClqs6/Qq7uLEJW0In0rK+s5ovb8PJteub+fOphC2YuH/UhsB7Fr283CQjqurE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h1kcoIRd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40VBaamk008632;
	Wed, 31 Jan 2024 11:56:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=uuHL+cyOgNd8cycNn48bDe4RL4vMUCHmQgmAxpjvDnw=;
 b=h1kcoIRdLuG+OM5wBFTZ7dCvSFbBj2tEaKpJYDuJGTmm3iIaquX4VYuVTTeNqmJriVjh
 c5bmSnYRFv9F1RQtbv9ocD9A2O2xaD/YOPsDMmsgvK4ahAaEMQ0QLR+awqVtMlq351Cu
 nDTwP0YamJ5sF06ir6OXkhhd30XgYeiM8hMXN/0/nIdPIfjS8Ex8Z56sJrQeZRXLlrbc
 KcAUoT+2sV2OfblzgUevUq95yc0BqqRfvH95Bxe4KwrmRuNEN3wPD6+cZNOYkADqhdg3
 FKWM5ykM+h6biwPAGX1zg5Pr/20Ta7PuQ8DkcLYC1VH8CQv7JenMBlge6hwhzXZlS7dI Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vymu81gpr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 11:56:51 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40VBb4vk012034;
	Wed, 31 Jan 2024 11:56:49 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vymu81ggv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 11:56:49 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40V9maMs011231;
	Wed, 31 Jan 2024 11:56:27 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vweckmuu6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 11:56:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40VBuOQ89962002
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 11:56:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 936D12004B;
	Wed, 31 Jan 2024 11:56:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6846720043;
	Wed, 31 Jan 2024 11:56:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 31 Jan 2024 11:56:24 +0000 (GMT)
Date: Wed, 31 Jan 2024 12:56:18 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 1/5] lib: s390x: sigp: Dirty CC before
 sigp execution
Message-ID: <20240131125618.42f508d7@p-imbrenda>
In-Reply-To: <20240131074427.70871-2-frankja@linux.ibm.com>
References: <20240131074427.70871-1-frankja@linux.ibm.com>
	<20240131074427.70871-2-frankja@linux.ibm.com>
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
X-Proofpoint-GUID: SHksygXS3FFRjTvSXKBMcQVxybe-0QN4
X-Proofpoint-ORIG-GUID: uDtkKIaZQ_YtlgCYkHBfd1fMThpxw522
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_06,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 malwarescore=0 suspectscore=0 mlxlogscore=922 bulkscore=0
 phishscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401310091

On Wed, 31 Jan 2024 07:44:23 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Dirtying the CC allows us to find missing CC changes when sigp is
> emulated.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  lib/s390x/asm/sigp.h | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/sigp.h b/lib/s390x/asm/sigp.h
> index 61d2c625..4eae95d0 100644
> --- a/lib/s390x/asm/sigp.h
> +++ b/lib/s390x/asm/sigp.h
> @@ -49,13 +49,17 @@ static inline int sigp(uint16_t addr, uint8_t order, unsigned long parm,
>  		       uint32_t *status)
>  {
>  	register unsigned long reg1 asm ("1") = parm;
> +	uint64_t bogus_cc = SIGP_CC_NOT_OPERATIONAL;
>  	int cc;
>  
>  	asm volatile(
> +		"	tmll	%[bogus_cc],3\n"
>  		"	sigp	%1,%2,0(%3)\n"
>  		"	ipm	%0\n"
>  		"	srl	%0,28\n"
> -		: "=d" (cc), "+d" (reg1) : "d" (addr), "a" (order) : "cc");
> +		: "=d" (cc), "+d" (reg1)
> +		: "d" (addr), "a" (order), [bogus_cc] "d" (bogus_cc)
> +		: "cc");

since you are doing changes in this inline asm, could you put names for
all the parameters? that way it will be more consistent and readable.

also in all the other patches in the series (except patch 2)

>  	if (status)
>  		*status = reg1;
>  	return cc;


