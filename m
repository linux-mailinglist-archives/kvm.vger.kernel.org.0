Return-Path: <kvm+bounces-1345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 169FD7E6AC1
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 13:44:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DC6028166A
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 12:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FA6D269;
	Thu,  9 Nov 2023 12:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FfnPtD0A"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5B51C3F
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 12:44:35 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1549B1B3;
	Thu,  9 Nov 2023 04:44:35 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9Ce38i030484;
	Thu, 9 Nov 2023 12:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Dth4Aqj24dwQKPK9nGhX+J3127jEeRIPgkj8pYjzpXM=;
 b=FfnPtD0AX70bEU5OOOYfIAZ4pjKVQ59BayDh/L+qEO2Lmw9aUthg1+VO5zkuzh/YV9dv
 mg5tRTeiWBpr3p55+wUqMdWhlxxriJPUL4ntR/7VW4T+DflP8ZvHsBqlLWEV1muWlv8s
 FY0YDQkH9i0bWUv8lkLS9LtfGjSWvWzu1ZTq4cjt0zbvDD9Dd38uHreoqthlH1VwpOmZ
 ZsxBispVuBLFeiiYFfdxPpzkDWUE7VprkfodPL2i39cQZPRWOiUemjreDsClTzBfqGHi
 JFADrL13q/utLrap494JpG9E27VGBnzdPJ0XwXYVVn6aSwU4peQnK8A7hPOeg7Ly8p9h NA== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8ymkg3jc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 12:44:34 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9BjTw6019286;
	Thu, 9 Nov 2023 12:44:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u7w243qc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Nov 2023 12:44:33 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A9CiUfC40764140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Nov 2023 12:44:30 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3564620043;
	Thu,  9 Nov 2023 12:44:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EBF0320040;
	Thu,  9 Nov 2023 12:44:29 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Nov 2023 12:44:29 +0000 (GMT)
Date: Thu, 9 Nov 2023 13:44:28 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, nrb@linux.ibm.com, nsg@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, gor@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com
Subject: Re: [PATCH v1 1/1] KVM: s390/mm: Properly reset no-dat
Message-ID: <20231109134428.613ba70e@p-imbrenda>
In-Reply-To: <20231109123624.37314-1-imbrenda@linux.ibm.com>
References: <20231109123624.37314-1-imbrenda@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dg_zb4aOOUFS37rvtlgWXi7GrxUXvtiP
X-Proofpoint-GUID: dg_zb4aOOUFS37rvtlgWXi7GrxUXvtiP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_10,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 phishscore=0 clxscore=1015 impostorscore=0 mlxlogscore=767
 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311090095

Sorry, I had copy-pasted the wrong email address for Gerald, fixed now

On Thu,  9 Nov 2023 13:36:24 +0100
Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> When the CMMA state needs to be reset, the no-dat bit also needs to be
> reset. Failure to do so could cause issues in the guest, since the
> guest expects the bit to be cleared after a reset.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/mm/pgtable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
> index 3bd2ab2a9a34..5cb92941540b 100644
> --- a/arch/s390/mm/pgtable.c
> +++ b/arch/s390/mm/pgtable.c
> @@ -756,7 +756,7 @@ void ptep_zap_unused(struct mm_struct *mm, unsigned long addr,
>  		pte_clear(mm, addr, ptep);
>  	}
>  	if (reset)
> -		pgste_val(pgste) &= ~_PGSTE_GPS_USAGE_MASK;
> +		pgste_val(pgste) &= ~(_PGSTE_GPS_USAGE_MASK | _PGSTE_GPS_NODAT);
>  	pgste_set_unlock(ptep, pgste);
>  	preempt_enable();
>  }


