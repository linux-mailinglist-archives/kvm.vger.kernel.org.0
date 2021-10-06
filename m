Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F384241E1
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 17:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhJFP4D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 11:56:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40572 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230014AbhJFP4C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 11:56:02 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 196Fam55024338;
        Wed, 6 Oct 2021 11:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=YVOZsWQsqzQcF7M5quXzwIKSlGys+PDhZXZPie/0uHM=;
 b=IGrRXBHSQreW3nQ8uVlkOGm5sffxQhFIteS8S/1c+az/V+GUlqzan0hF3g5AmqfirHna
 RZfdSuRtsxcA4AYV2wcLn1E/SXpHvtaqWoz4TyXtejeEuBSdS/FiXeatAmIhiUSPLJ3K
 BzXc7mm0l+4Wn6DmULPdlqw2Xu5v+iUDzqCcst+slzhRbP2hak1a1U8uWF7HTAy13fhD
 fBc3N1NsMkp8jYEVcQZFUXT4EgMFelXKVMCkRVtzF0FBar6SIylKbMimnvDiTzB6hBfu
 EHlN9E/8WNadujoYsFLnsehLERasc/MeWA+5yaBl27HPIads3qKj9Ptb8n4S8Z6gyFwM dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcsckybp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 11:54:09 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 196FamT0024363;
        Wed, 6 Oct 2021 11:54:09 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3bhcsckyb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 11:54:09 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 196FmjI8003301;
        Wed, 6 Oct 2021 15:54:07 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3bhepcr2dq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Oct 2021 15:54:07 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 196Fs1pC40567268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Oct 2021 15:54:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEF1B11C058;
        Wed,  6 Oct 2021 15:54:01 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E51811C04C;
        Wed,  6 Oct 2021 15:54:01 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.18.96])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Oct 2021 15:54:01 +0000 (GMT)
Subject: Re: [PATCH v5 04/14] KVM: s390: pv: avoid stalls when making pages
 secure
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
 <20210920132502.36111-5-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <f1c3068c-6fa4-02e3-1513-464694660511@de.ibm.com>
Date:   Wed, 6 Oct 2021 17:54:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210920132502.36111-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: udScA1uxJcZ4wc2zvBSjHXaTC1tiTXdI
X-Proofpoint-GUID: bb-8SV5XLr36GD39aSeHgyC3rrrQXilB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 phishscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 adultscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110060097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 20.09.21 um 15:24 schrieb Claudio Imbrenda:
> Improve make_secure_pte to avoid stalls when the system is heavily
> overcommitted. This was especially problematic in kvm_s390_pv_unpack,
> because of the loop over all pages that needed unpacking.
> 
> Due to the locks being held, it was not possible to simply replace
> uv_call with uv_call_sched. A more complex approach was
> needed, in which uv_call is replaced with __uv_call, which does not
> loop. When the UVC needs to be executed again, -EAGAIN is returned, and
> the caller (or its caller) will try again.
> 
> When -EAGAIN is returned, the path is the same as when the page is in
> writeback (and the writeback check is also performed, which is
> harmless).
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
> ---
>   arch/s390/kernel/uv.c     | 29 +++++++++++++++++++++++------
>   arch/s390/kvm/intercept.c |  5 +++++
>   2 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index aeb0a15bcbb7..68a8fbafcb9c 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -180,7 +180,7 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>   {
>   	pte_t entry = READ_ONCE(*ptep);
>   	struct page *page;
> -	int expected, rc = 0;
> +	int expected, cc = 0;
>   
>   	if (!pte_present(entry))
>   		return -ENXIO;
> @@ -196,12 +196,25 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>   	if (!page_ref_freeze(page, expected))
>   		return -EBUSY;
>   	set_bit(PG_arch_1, &page->flags);
> -	rc = uv_call(0, (u64)uvcb);
> +	/*
> +	 * If the UVC does not succeed or fail immediately, we don't want to
> +	 * loop for long, or we might get stall notifications.
> +	 * On the other hand, this is a complex scenario and we are holding a lot of
> +	 * locks, so we can't easily sleep and reschedule. We try only once,
> +	 * and if the UVC returned busy or partial completion, we return
> +	 * -EAGAIN and we let the callers deal with it.
> +	 */
> +	cc = __uv_call(0, (u64)uvcb);
>   	page_ref_unfreeze(page, expected);
> -	/* Return -ENXIO if the page was not mapped, -EINVAL otherwise */
> -	if (rc)
> -		rc = uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
> -	return rc;
> +	/*
> +	 * Return -ENXIO if the page was not mapped, -EINVAL for other errors.
> +	 * If busy or partially completed, return -EAGAIN.
> +	 */
> +	if (cc == UVC_CC_OK)
> +		return 0;
> +	else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
> +		return -EAGAIN;
> +	return uvcb->rc == 0x10a ? -ENXIO : -EINVAL;
>   }
>   
>   /*
> @@ -254,6 +267,10 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>   	mmap_read_unlock(gmap->mm);
>   
>   	if (rc == -EAGAIN) {
> +		/*
> +		 * If we are here because the UVC returned busy or partial
> +		 * completion, this is just a useless check, but it is safe.
> +		 */
>   		wait_on_page_writeback(page);
>   	} else if (rc == -EBUSY) {
>   		/*
> diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
> index 72b25b7cc6ae..47833ade4da5 100644
> --- a/arch/s390/kvm/intercept.c
> +++ b/arch/s390/kvm/intercept.c
> @@ -516,6 +516,11 @@ static int handle_pv_uvc(struct kvm_vcpu *vcpu)
>   	 */
>   	if (rc == -EINVAL)
>   		return 0;
> +	/*
> +	 * If we got -EAGAIN here, we simply return it. It will eventually
> +	 * get propagated all the way to userspace, which should then try
> +	 * again.
> +	 */

This cpoment is new over v4, right? Can this happen often? If not then this is ok
otherwise we should consider your proposal of doing

if (rc == -EINVAL || rc == -EAGAIN)

to reduce overhead.

Anyway,for both ways

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

>   	return rc;
>   }
>   
> 
