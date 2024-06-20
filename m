Return-Path: <kvm+bounces-20139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DDA58910E18
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:07:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42B08B27E98
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 17:07:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0258A1B374E;
	Thu, 20 Jun 2024 17:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="elzH6YaZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06BE1B3730;
	Thu, 20 Jun 2024 17:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718903205; cv=none; b=cUZaLWLojhYwU5WG8t/R3z6g5Dj/3Ek1T2hEA5woWC4fmFXxJJ1X6jnK2+26eXAFyIZM3Cg6Z6ugufXDn2C9y2PAvINWRwsXJz9wFGOcxpWX9WunbMPWfvvW1iGr26zg6gk7NoEQejeOlr8REzywHVqFZdIO3FDj0uKpmYHtfhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718903205; c=relaxed/simple;
	bh=udpc/kk0BBK4oghHC+Ru/LzmE7FXsRqCjmWD78lnEHc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ufcbMFZ7drJgdcsJJcpNw7rijhhHVAJPpfeCcN/wDc40xyaaWGRt+Molu2yDdo/m+MkpjZVIxIVuIhDq0W6svrWFtM/Plq3xG+Djvftli2J/NkmvGqOFz228wqSygXWDYzwT0ZMAxjAAZI6Ahee8jU9YBX1klz1nCajnDOKOCSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=elzH6YaZ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45KG9en8017869;
	Thu, 20 Jun 2024 17:06:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	zSItsgXQrLHHlpWDDFMljBOzpUdXaztzKzN9Br2ZKok=; b=elzH6YaZB84PVqC4
	QmznHjjsBKnLoAF5q2TBhgQIqbqwE6bbn15nKBjULbVH/Gy98r8doAgN2+lTbotx
	HL6AQn3XtRCaYCZYU/liTI6bH8n8Xguo+sRQ44PXZLfz2qylH8qy1RWvujpHMv4Z
	wXyIa6dSIP4dhaL/f3vg3YA13FUgupLXXwgx3fweZ9PHMn0bLbPKiJ9EZWTnj9Gh
	QgNJJIuIiafU6bV08DIFYucnfl8CWLDixg4ua/m+EEdiaNsLA2B4+EzlKqXD3XUy
	U0sUtHdhhzx1XWYgLM9iu38GiWf8lgkennYB7fkA/XQPZAa2MeRIsrfVgffyg1a+
	CZpWKA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvp7crh9f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:34 +0000 (GMT)
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45KH6YUB018868;
	Thu, 20 Jun 2024 17:06:34 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yvp7crh9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:34 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45KGhDK4013488;
	Thu, 20 Jun 2024 17:06:33 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ysr047wsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Jun 2024 17:06:33 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45KH6RX945482256
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Jun 2024 17:06:29 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D3DF20040;
	Thu, 20 Jun 2024 17:06:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D0A0E20043;
	Thu, 20 Jun 2024 17:06:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.47.175])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 20 Jun 2024 17:06:26 +0000 (GMT)
Date: Thu, 20 Jun 2024 18:47:11 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Nico =?UTF-8?B?QsO2aHI=?= <nrb@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, Thomas Huth
 <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        David
 Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 4/7] s390x: Add function for checking
 diagnose intercepts
Message-ID: <20240620184711.50bd463c@p-imbrenda>
In-Reply-To: <20240620141700.4124157-5-nsg@linux.ibm.com>
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
	<20240620141700.4124157-5-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YLJ6q0fEno9T5olU8W9bxFUawizSXynW
X-Proofpoint-GUID: i1rjVn3bEPF74v8WK4sYLV_cMDv_jY4e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-20_07,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 bulkscore=0 adultscore=0 mlxlogscore=999
 impostorscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406200118

On Thu, 20 Jun 2024 16:16:57 +0200
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> sie_is_diag_icpt() checks if the intercept is due to an expected
> diagnose call and is valid.
> It subsumes pv_icptdata_check_diag.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>


[...]


> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 0fa915cf..d4ba2a40 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -42,6 +42,59 @@ void sie_check_validity(struct vm *vm, uint16_t vir_exp)
>  	report(vir_exp == vir, "VALIDITY: %x", vir);
>  }
>  
> +bool sie_is_diag_icpt(struct vm *vm, unsigned int diag)
> +{
> +	union {
> +		struct {
> +			uint64_t     : 16;
> +			uint64_t ipa : 16;
> +			uint64_t ipb : 32;
> +		};
> +		struct {
> +			uint64_t          : 16;
> +			uint64_t opcode   :  8;
> +			uint64_t r_1      :  4;
> +			uint64_t r_2      :  4;
> +			uint64_t r_base   :  4;
> +			uint64_t displace : 12;
> +			uint64_t zero     : 16;
> +		};
> +	} instr = { .ipa = vm->sblk->ipa, .ipb = vm->sblk->ipb };
> +	uint8_t icptcode;
> +	uint64_t code;
> +
> +	switch (diag) {
> +	case 0x44:
> +	case 0x9c:
> +	case 0x288:
> +	case 0x308:
> +		icptcode = ICPT_PV_NOTIFY;
> +		break;
> +	case 0x500:
> +		icptcode = ICPT_PV_INSTR;
> +		break;
> +	default:
> +		/* If a new diag is introduced add it to the cases above! */
> +		assert_msg(false, "unknown diag");

just a nit, but would it be possible to also print the diag number that
causes the error?


otherwise looks good



