Return-Path: <kvm+bounces-37322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0073DA287FD
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 11:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 110B01882649
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 10:30:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2772230D3D;
	Wed,  5 Feb 2025 10:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="trmtuFNx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415C1230D26;
	Wed,  5 Feb 2025 10:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738751158; cv=none; b=E6mXNORgnkKMcqOl6eYPyl7SdJIS9CUVv8QTaCvjwK1FCtWYL5rqiQ5+M0C9KtAX2zuZY2voFzKxWc1q/MyS1RlosLHaxoQD/EBUrQUfHwmOvPGzRxR4UP9nOEssfHozQf6kGQtkDgbS9TQa6bmnttIr86XXftI6Cr1CwF5HeEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738751158; c=relaxed/simple;
	bh=AeKiv7gvV+JTOIS5grj0H2LBuZw2PXokcSoHbFhxKxs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQLjnfw6tOs5ULCe5O/qAbFj3tzZCjZrU9EhG14tYqj0lBP7Tvnp5/IxafECF04EAiMAsznUk9arf2Wz8BFDfzFD2Kqy0JysbIex1y45fJGcKvTHozbTpFnae+XlNJRRKJzl4cmdWYOaX177TXzzMWYuOedlhzshQYgNAntWCG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=trmtuFNx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5157WqQj000866;
	Wed, 5 Feb 2025 10:25:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cmS7ZF
	f5XLDep74LODzLfPaoaTknkdLWfYMGhHyi/g0=; b=trmtuFNx6FJHKKj0D+JtV+
	p+HAgG8NoRlI2j8SUlXOpvO/1tpfSvwiI6TVUDN31luaUKeDMIt+WhpwtacmMUT+
	jT4s2ftu7sOPC1K07X6zagso1s16Z0FA9IQl3CfPNQh3ezmy7KA8O1pGTd64JIn1
	9mcqhw6DdoMSWVmBvh8nt5KMskJO/ERUn79TVdWtkN6oarn+nhxVNV5RPizgN5Te
	KcJu8LGTFFUKm7cwjYjGx43MlDxwZ3bpEzl0AkD949SFe4KQ13mXIBvVjdngqYsp
	Sq3g4T8b4yHQpDS0mCgz+kWPtk6H8Ix9bpW06Ri+2ZwM5y65K2oqpgq89GGEc1mQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44m3pnrs7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Feb 2025 10:25:55 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5157FwtV016297;
	Wed, 5 Feb 2025 10:25:55 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44hwxsgewe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Feb 2025 10:25:55 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 515APpsW22675800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Feb 2025 10:25:52 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DBE982005A;
	Wed,  5 Feb 2025 10:25:51 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BACA92004E;
	Wed,  5 Feb 2025 10:25:51 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Feb 2025 10:25:51 +0000 (GMT)
Date: Wed, 5 Feb 2025 11:25:50 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, nrb@linux.ibm.com,
        hca@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH] lib: s390x: css: Name inline assembly
 arguments and clean them up
Message-ID: <20250205112550.45a6b2cd@p-imbrenda>
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
X-Proofpoint-ORIG-GUID: eif_eVIbVwiBeVu36WGjR9eXI_8ghSFm
X-Proofpoint-GUID: eif_eVIbVwiBeVu36WGjR9eXI_8ghSFm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_04,2025-02-05_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxlogscore=932 spamscore=0
 mlxscore=0 suspectscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502050080

On Tue,  4 Feb 2025 09:51:33 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Less need to count the operands makes the code easier to read.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
> 
> This one has been gathering dust for a while.
> rfc->v1: Moved to Q constraint (thanks Heiko)
> 
> ---

[...]

>  	asm volatile(" .insn   rre,0xb25f0000,%2,0\n"
> -		     " ipm     %0\n"
> -		     " srl     %0,28\n"
> -		     : "=d" (cc), "=m" (p)
> +		     " ipm     %[cc]\n"
> +		     " srl     %[cc],28\n"
> +		     : [cc] "=d" (cc), "=m" (p)
>  		     : "d" (p), "m" (p)

this bit (which you did not touch) is actually the most confusing to me.
what's the point of separately specifying both "d" and "m" constraints
for (p) ? (and it also has a "=m" in the output clobberlist)

>  		     : "cc");
>  


