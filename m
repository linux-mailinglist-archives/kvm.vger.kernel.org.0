Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1834610E7
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 10:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240962AbhK2JSs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 04:18:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236476AbhK2JQs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 29 Nov 2021 04:16:48 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AT8qvVL001400;
        Mon, 29 Nov 2021 09:13:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=7nPk89NXXI8fp8YBHE9si9PFHNe70/jhzYt1keyTdIE=;
 b=Uz9gfuNUr6QAIv3V21X2xj6fmTHHt0afbsv43g8zhn/K33Mm89JJm7C+v0kXfaNNvWrS
 WPrKJuNnWGqnXL4d7SNJIL+9h4RO8Wfu86F/Z7Cjfcm3g05mYfAl9qAK6Mtpqm4wmhXP
 KEtXeS//aFfo1t3TaqrQVIrUkmfP51JOKDVOhR01EVcQ7FcmbeXaFUnwfXMLLltX/rEi
 YNB5yg5W6QSUPwQiSqwr229k1AlWmEbkhbvIJNI97IfX2udxD4P3OE/svxYncL4WLDpR
 nxMEfJ/0x1bN0gq9EeIZ4KJDeQdUChM1zYFJaZ2jzQv3We/JORaknIFGPgJPyXRWBEZd lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cmur90fdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 09:13:30 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AT91T52002298;
        Mon, 29 Nov 2021 09:13:29 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cmur90fd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 09:13:29 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AT93IP7008127;
        Mon, 29 Nov 2021 09:13:27 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3ckca9a00x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 09:13:27 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AT9DO6S31064426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Nov 2021 09:13:24 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E0BA42042;
        Mon, 29 Nov 2021 09:13:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA2AF4204D;
        Mon, 29 Nov 2021 09:13:23 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.116])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 29 Nov 2021 09:13:23 +0000 (GMT)
Date:   Mon, 29 Nov 2021 09:55:28 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] KVM: s390: gaccess: Refactor gpa and length
 calculation
Message-ID: <20211129095528.1a92e72d@p-imbrenda>
In-Reply-To: <20211126164549.7046-2-scgl@linux.ibm.com>
References: <20211126164549.7046-1-scgl@linux.ibm.com>
        <20211126164549.7046-2-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Bvuuscaa7DvBaMo11YL8NvJIi4lBMn4M
X-Proofpoint-GUID: p419T4zynwAI4F6lUzHfnN4_yi0Cm7Gu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-29_05,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 phishscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111290042
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 26 Nov 2021 17:45:47 +0100
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> Improve readability by renaming the length variable and
> not calculating the offset manually.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/gaccess.c | 32 +++++++++++++++++---------------
>  1 file changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 6af59c59cc1b..45966fbba182 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -831,8 +831,9 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  		 unsigned long len, enum gacc_mode mode)
>  {
>  	psw_t *psw = &vcpu->arch.sie_block->gpsw;
> -	unsigned long _len, nr_pages, gpa, idx;
> +	unsigned long nr_pages, gpa, idx;
>  	unsigned long pages_array[2];
> +	unsigned int fragment_len;
>  	unsigned long *pages;
>  	int need_ipte_lock;
>  	union asce asce;
> @@ -855,15 +856,15 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  		ipte_lock(vcpu);
>  	rc = guest_page_range(vcpu, ga, ar, pages, nr_pages, asce, mode);
>  	for (idx = 0; idx < nr_pages && !rc; idx++) {
> -		gpa = *(pages + idx) + (ga & ~PAGE_MASK);
> -		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
> +		gpa = pages[idx] + offset_in_page(ga);
> +		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
>  		if (mode == GACC_STORE)
> -			rc = kvm_write_guest(vcpu->kvm, gpa, data, _len);
> +			rc = kvm_write_guest(vcpu->kvm, gpa, data, fragment_len);
>  		else
> -			rc = kvm_read_guest(vcpu->kvm, gpa, data, _len);
> -		len -= _len;
> -		ga += _len;
> -		data += _len;
> +			rc = kvm_read_guest(vcpu->kvm, gpa, data, fragment_len);
> +		len -= fragment_len;
> +		ga += fragment_len;
> +		data += fragment_len;
>  	}
>  	if (need_ipte_lock)
>  		ipte_unlock(vcpu);
> @@ -875,19 +876,20 @@ int access_guest(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar, void *data,
>  int access_guest_real(struct kvm_vcpu *vcpu, unsigned long gra,
>  		      void *data, unsigned long len, enum gacc_mode mode)
>  {
> -	unsigned long _len, gpa;
> +	unsigned int fragment_len;
> +	unsigned long gpa;
>  	int rc = 0;
>  
>  	while (len && !rc) {
>  		gpa = kvm_s390_real_to_abs(vcpu, gra);
> -		_len = min(PAGE_SIZE - (gpa & ~PAGE_MASK), len);
> +		fragment_len = min(PAGE_SIZE - offset_in_page(gpa), len);
>  		if (mode)
> -			rc = write_guest_abs(vcpu, gpa, data, _len);
> +			rc = write_guest_abs(vcpu, gpa, data, fragment_len);
>  		else
> -			rc = read_guest_abs(vcpu, gpa, data, _len);
> -		len -= _len;
> -		gra += _len;
> -		data += _len;
> +			rc = read_guest_abs(vcpu, gpa, data, fragment_len);
> +		len -= fragment_len;
> +		gra += fragment_len;
> +		data += fragment_len;
>  	}
>  	return rc;
>  }

