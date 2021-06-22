Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3733B0801
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 16:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhFVPAT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 11:00:19 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:36662 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231656AbhFVPAQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Jun 2021 11:00:16 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15MEhULj187659;
        Tue, 22 Jun 2021 10:58:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=n9xGlmupv4opIn3YqzjMStUK+s9mChU/0uMEJHKrDfI=;
 b=dBNycG3UQriX0js/RWNZ/94BC9V6spoIummgWW5mBSHs/DIFFc9HVX87a4bksvL8dlqX
 TRuQo4iRpUZoJFuSDeAFKHLtCPIUIhzQ0jwJyKwpsL/QQ0cHCA3sKFzUOoMmBY9FA0v4
 FhWqg0ILQ+5q6J4nK9c7OTY0v+zTOwdGH57ffQ+tVs+1ru5rhw0qTh7Eu3OtKgl0pG6c
 s57Q4nX8m4zSI1o5WNhUB6wT6g6/DE/CIz/qn2tQFlTp3N+hHH0BNJbpUwa3a6vvtX7l
 ON09li4TnmQ9xnNXHCSaH5or/r+7wtxtqoDPjVBTxGru+83vlIu/YGnxZBRhmZuvzTlc 2w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39bgswb2ct-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 10:58:00 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15MEifjA193811;
        Tue, 22 Jun 2021 10:57:59 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 39bgswb2bx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 10:57:59 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15MEs1VA024048;
        Tue, 22 Jun 2021 14:56:58 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3998789hgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 22 Jun 2021 14:56:57 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15MEutPJ20971866
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Jun 2021 14:56:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2F004C04A;
        Tue, 22 Jun 2021 14:56:54 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 912884C044;
        Tue, 22 Jun 2021 14:56:54 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.32.128])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 22 Jun 2021 14:56:54 +0000 (GMT)
Subject: Re: [PATCH] KVM: s390: get rid of register asm usage
To:     Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20210621140356.1210771-1-hca@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <4f5e36d2-1f1f-c6cf-5066-a81e3b5caa91@de.ibm.com>
Date:   Tue, 22 Jun 2021 16:56:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210621140356.1210771-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZZhBNOlCrXSIFeCiqNIe1mp4V-x1BZ6p
X-Proofpoint-ORIG-GUID: LI7qAlLbX_gVT5LRx3JP_pJkZpVGReBb
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_08:2021-06-21,2021-06-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 spamscore=0 bulkscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106220090
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 21.06.21 16:03, Heiko Carstens wrote:
> Using register asm statements has been proven to be very error prone,
> especially when using code instrumentation where gcc may add function
> calls, which clobbers register contents in an unexpected way.
> 
> Therefore get rid of register asm statements in kvm code, even though
> there is currently nothing wrong with them. This way we know for sure
> that this bug class won't be introduced here.
> 
> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

thanks applied.

> ---
>   arch/s390/kvm/kvm-s390.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 1296fc10f80c..4b7b24f07790 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -329,31 +329,31 @@ static void allow_cpu_feat(unsigned long nr)
>   
>   static inline int plo_test_bit(unsigned char nr)
>   {
> -	register unsigned long r0 asm("0") = (unsigned long) nr | 0x100;
> +	unsigned long function = (unsigned long) nr | 0x100;
>   	int cc;
>   
>   	asm volatile(
> +		"	lgr	0,%[function]\n"
>   		/* Parameter registers are ignored for "test bit" */
>   		"	plo	0,0,0,0(0)\n"
>   		"	ipm	%0\n"
>   		"	srl	%0,28\n"
>   		: "=d" (cc)
> -		: "d" (r0)
> -		: "cc");
> +		: [function] "d" (function)
> +		: "cc", "0");
>   	return cc == 0;
>   }
>   
>   static __always_inline void __insn32_query(unsigned int opcode, u8 *query)
>   {
> -	register unsigned long r0 asm("0") = 0;	/* query function */
> -	register unsigned long r1 asm("1") = (unsigned long) query;
> -
>   	asm volatile(
> -		/* Parameter regs are ignored */
> +		"	lghi	0,0\n"
> +		"	lgr	1,%[query]\n"
> +		/* Parameter registers are ignored */
>   		"	.insn	rrf,%[opc] << 16,2,4,6,0\n"
>   		:
> -		: "d" (r0), "a" (r1), [opc] "i" (opcode)
> -		: "cc", "memory");
> +		: [query] "d" ((unsigned long)query), [opc] "i" (opcode)
> +		: "cc", "memory", "0", "1");
>   }
>   
>   #define INSN_SORTL 0xb938
> 
