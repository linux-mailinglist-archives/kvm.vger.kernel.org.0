Return-Path: <kvm+bounces-32520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99DE69D96D5
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 12:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AF7E162101
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 11:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94BB51CF5C6;
	Tue, 26 Nov 2024 11:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ApXnpQsn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D581CCB50;
	Tue, 26 Nov 2024 11:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732622265; cv=none; b=ECfmWiM8v4ByDcxGCctD8eFuSWz/rnxFasb0WE+C3gPa4048R/D7c/XaGFfccLjJESZjW/OU5/RGSu2YYw+OMwWu5FinOnYUK44Ravqb8kTwMv1HmdcHO4/4w1gjZXRShN8zBRbUfnL1x4F4SPEl4pg27jumwc9ET0QvHZDFcws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732622265; c=relaxed/simple;
	bh=NEruHpdky6RjOpdxUlQi3nrzYq6eDv/Xm8t/qbknvO4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E5xbCqonn4PTuepys6430Vw9W1G/YgyYuHRNbH3XjEld7AR5S4cEPznP+sevS03YifxyUQ1zzCFzZE9eA/fTt8cNRFOi28z8BO5yAl8WZUa7VV352m3tkVpVZZoBynwGxZQ2RSajW5V/cFJTfSeNlXC5q24YxbFPAR3GMWznRvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ApXnpQsn; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQ1aGSa024921;
	Tue, 26 Nov 2024 11:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8w6NQL
	t5c13D3GWEe98oQDkzAsHadgr/o2tyGHrq9Ts=; b=ApXnpQsnChgH+LsJyg/u1Y
	IInC68bP3c9udCij8rYq6LZYV6e4yQP/UPQXuluE2xP+V+3Wh7AZlgY+gJyd7iPh
	tLX0idSaqYzPHlmT/C3reFyPGiqO9Uo4fe2pdBDTkafFZba1w8rCUQGoTuM4TUDu
	cHWtb4757W9hIJICzcaOyiLGRHRKtSQb5R/zn9BsRiJubGQMsDEAPAI4ZF6napqL
	4zIms4u8Ls2bI8bRmT6N5W8hjRMHfSSpPmL/XWa54sfCz8S8zuzyJO6GwnPJJozF
	/WgP6UmhQ/19+BGeBobmiwJSP6U4ddOOXFZA91IYkzmoiQkesYy4wFUFe3hxbU6w
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43386ndqnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 11:57:41 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AQBumsR000843;
	Tue, 26 Nov 2024 11:57:38 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 433sryaa3y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Nov 2024 11:57:38 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AQBvYev19923430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Nov 2024 11:57:34 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D4D02004E;
	Tue, 26 Nov 2024 11:57:34 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B2BC2004D;
	Tue, 26 Nov 2024 11:57:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Nov 2024 11:57:34 +0000 (GMT)
Date: Tue, 26 Nov 2024 12:57:32 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] KVM: s390: Increase size of union sca_utility to
 four bytes
Message-ID: <20241126125732.1889fb09@p-imbrenda>
In-Reply-To: <20241126102515.3178914-4-hca@linux.ibm.com>
References: <20241126102515.3178914-1-hca@linux.ibm.com>
	<20241126102515.3178914-4-hca@linux.ibm.com>
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
X-Proofpoint-GUID: s9wc8hiXqEJuDAANPimd1KeecB2kZbzr
X-Proofpoint-ORIG-GUID: s9wc8hiXqEJuDAANPimd1KeecB2kZbzr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 suspectscore=0 impostorscore=0 malwarescore=0 spamscore=0
 clxscore=1015 adultscore=0 lowpriorityscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411260097

On Tue, 26 Nov 2024 11:25:15 +0100
Heiko Carstens <hca@linux.ibm.com> wrote:

> kvm_s390_update_topology_change_report() modifies a single bit within
> sca_utility using cmpxchg(). Given that the size of the sca_utility union
> is two bytes this generates very inefficient code. Change the size to four
> bytes, so better code can be generated.
> 
> Even though the size of sca_utility doesn't reflect architecture anymore
> this seems to be the easiest and most pragmatic approach to avoid
> inefficient code.
> 
> Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 1cd8eaebd3c0..1cb1de232b9e 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -95,10 +95,10 @@ union ipte_control {
>  };
>  
>  union sca_utility {
> -	__u16 val;
> +	__u32 val;

I know I said the patch was fine but I realised now that I would like a
short comment here explaining that 32 bits allows for more efficient
code

you can add it when picking, no need to send a v3

>  	struct {
> -		__u16 mtcr : 1;
> -		__u16 reserved : 15;
> +		__u32 mtcr : 1;
> +		__u32	   : 31;
>  	};
>  };
>  
> @@ -107,7 +107,7 @@ struct bsca_block {
>  	__u64	reserved[5];
>  	__u64	mcn;
>  	union sca_utility utility;
> -	__u8	reserved2[6];
> +	__u8	reserved2[4];
>  	struct bsca_entry cpu[KVM_S390_BSCA_CPU_SLOTS];
>  };
>  
> @@ -115,7 +115,7 @@ struct esca_block {
>  	union ipte_control ipte_control;
>  	__u64   reserved1[6];
>  	union sca_utility utility;
> -	__u8	reserved2[6];
> +	__u8	reserved2[4];
>  	__u64   mcn[4];
>  	__u64   reserved3[20];
>  	struct esca_entry cpu[KVM_S390_ESCA_CPU_SLOTS];


