Return-Path: <kvm+bounces-47144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 37641ABDE67
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 17:10:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 442E11886B34
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 15:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DEB52517A7;
	Tue, 20 May 2025 15:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nyRxdM4G"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9121AA7BF;
	Tue, 20 May 2025 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747753837; cv=none; b=tvZRIsb3qUF+KFRD9hXcltNJxqt4w0b3e2rUIctnMlLY198vJyQRnEerba8zZabMBYeCHt5F8k/uibV8ynrWUTzWcHiQS9jrUQ4YUh60Pev4QJbOt8naTk8J+I6Nb11g49frKDTgTEagOt+kkCrB6TOfLdYKrshgvnG9lXv4C40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747753837; c=relaxed/simple;
	bh=8pBcx7C+wGMsAM4YE9AHNpnruMuSJOh7Nq/Sv0KEcEE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QSa1JzsmwaqGmCa9EO3GSwEh/XOfMHQe8JUdoMcVJLgytPqlHW5eK1nuNtJVWKCEmlvcPuk36J20SLTygvez3Spado4vN2g38mDF4E7y6faVByuutFSANxTBwEeKj0MwDjKmZYoXRhrQmeTw1FYZXGUVfWnunp34XDMdhkAryjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nyRxdM4G; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54K7iMUm013649;
	Tue, 20 May 2025 15:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ImJYlZ
	5KVwozGboNulihlvH73RO/Xx8tW7cXQE7ByHk=; b=nyRxdM4GeKJxhIMiaN8DDY
	OdePpXv6SKOB1Uq9zqBnSbPFXF2ab6uFheECxzGBYsoOQlUYtM89Bf4dl/LeACCt
	NvYJ8yd5UHC4cMy9plevG4+keuNKZ8GQV7UbLshbWnNQhgMhRD7sI8wUSRZW7X74
	HD5OaTnu/dtKOEvsE13oT9yJgP93LEI9BsZ13p/V7ArHLAd6stJX8jl4DqC9D9kj
	qjTUislDibA0LaUi5KCYuP36JTsqNCTulkupGyioD17MEYli2iVMOa1vRhAosWwo
	70uU9P52ev8XLdNC3JoaqLia6UMg2p2sLRm15FBt8mdQPyiAZHhPzDOWM1pzesCg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46ra99n25r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 15:10:17 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 54KF1luQ024544;
	Tue, 20 May 2025 15:10:17 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46ra99n25g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 15:10:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54KBebPD007347;
	Tue, 20 May 2025 15:10:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 46q70kcb81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 15:10:16 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54KFAC2v49545622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 15:10:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53AFF2004F;
	Tue, 20 May 2025 15:10:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD4BE20040;
	Tue, 20 May 2025 15:10:11 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 May 2025 15:10:11 +0000 (GMT)
Date: Tue, 20 May 2025 17:10:09 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Houghton
 <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        Yang Shi
 <yang@os.amperecomputing.com>,
        David Hildenbrand <david@redhat.com>,
        "Liam
 R . Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox
 <willy@infradead.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Message-ID: <20250520171009.49b2bd1b@p-imbrenda>
In-Reply-To: <20250519145657.178365-1-lorenzo.stoakes@oracle.com>
References: <20250519145657.178365-1-lorenzo.stoakes@oracle.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=J/mq7BnS c=1 sm=1 tr=0 ts=682c9b59 cx=c_pps a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=VnNF1IyMAAAA:8
 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=TdoRMgLQO9YfxZhadQYA:9 a=CjuIK1q_8ugA:10 a=f1lSKsbWiCfrRWj5-Iac:22 a=0YTRHmU2iG2pZC6F1fw2:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDEyMyBTYWx0ZWRfX6ETF0aPitQjf tBavV1oG8+qlAYCVttmWmV9C699wqmr9mBJ7ugqpYea2/7AUQm4szrF3BjtoL9Vjiu89sIh4WEM v9gj4kS7rrh+nIrYIF8k8OJH8Lr1wLf+0DLLwOG5rXx+1dncZrB3gt1IBs//nmlzibf2W+p9ZXw
 dpsgbWgZSKCi8cXok6DHwjoPH6gr5uP5ucIhMEtCKCjL8ZMPO4eYkgbci5RXlnA/LhEK3JPbDHK lBKGmAQ5rqnEgDfbHNdlYNXkxeQfACqZhGZurgC7mVrOMISoBOy168Dgtn6HOZ6EDZp3TKfmNgG WYbnvlI2F4OYmZJFcWtso4J4bMuzK57obsynuXKlBAhs/NOlqaaZUrBTeQubwBgSxw7xwKqydv1
 vF48ry92+MzxPcfLmH35nu0N/bNJp8Xcn0+1Y6nCR8QZjV1Gsk530291vFQoHDENPYHZxapw
X-Proofpoint-ORIG-GUID: fJP2X6P0Z10eyLO_i1XNVfQ-lXAlgR7H
X-Proofpoint-GUID: je_od0NDs4Y-fTVlpKSl16OI1JQ3pQxb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_06,2025-05-20_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1011 phishscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505200123

On Mon, 19 May 2025 15:56:57 +0100
Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
> unfortunate identifier within it - PROT_NONE.
> 
> This clashes with the protection bit define from the uapi for mmap()
> declared in include/uapi/asm-generic/mman-common.h, which is indeed what
> those casually reading this code would assume this to refer to.
> 
> This means that any changes which subsequently alter headers in any way
> which results in the uapi header being imported here will cause build
> errors.
> 
> Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
> Cc: stable@vger.kernel.org
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
> Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> Acked-by: Yang Shi <yang@os.amperecomputing.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>

if you had put me in CC, you would have gotten this yesterday already:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> Separated out from [0] as problem found in other patch in series.
> 
> [0]: https://lore.kernel.org/all/cover.1747338438.git.lorenzo.stoakes@oracle.com/
> 
>  arch/s390/kvm/gaccess.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index f6fded15633a..4e5654ad1604 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -318,7 +318,7 @@ enum prot_type {
>  	PROT_TYPE_DAT  = 3,
>  	PROT_TYPE_IEP  = 4,
>  	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
> -	PROT_NONE,
> +	PROT_TYPE_DUMMY,
>  };
> 
>  static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
> @@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
>  	switch (code) {
>  	case PGM_PROTECTION:
>  		switch (prot) {
> -		case PROT_NONE:
> +		case PROT_TYPE_DUMMY:
>  			/* We should never get here, acts like termination */
>  			WARN_ON_ONCE(1);
>  			break;
> @@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  			gpa = kvm_s390_real_to_abs(vcpu, ga);
>  			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
>  				rc = PGM_ADDRESSING;
> -				prot = PROT_NONE;
> +				prot = PROT_TYPE_DUMMY;
>  			}
>  		}
>  		if (rc)
> @@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
>  		if (rc == PGM_PROTECTION)
>  			prot = PROT_TYPE_KEYC;
>  		else
> -			prot = PROT_NONE;
> +			prot = PROT_TYPE_DUMMY;
>  		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
>  	}
>  out_unlock:
> --
> 2.49.0
> 


