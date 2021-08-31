Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D34403FC9CC
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 16:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbhHaOda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 10:33:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1905 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232774AbhHaOd2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 10:33:28 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17VE4WBm032539;
        Tue, 31 Aug 2021 10:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aLHlqks51Yz2yAH+b9GNoPK2+kd9oKOUmDc/x11pwMU=;
 b=D8+/Dplnk94P41NYr6OVXMjWeTcJKpm3E99D9J/i9UXGqFQdHbS+sDcFH5Qss8JQNzFZ
 XicMDhFpcXMnjTQO5DcgRoO3OPpSmNtvOFFqwrpcv2i7HB7897gBomkfmKg4yn+wNDjW
 dsp6hMT7cFUol7HwvPYx0mpXi1ZVJU8DlHaJ96evTYm5j2phMCVbhdWeup+NoJncPpwY
 geDa8KwNxht9r0GEXiuri1lWSQVS5tvYCfIfNDdSghYDT6oaNATCNGctNnPYxPZV31WY
 B3EqARqO9RMY7Pr551CcfdjkT336WLLSowtvExEJejJUzApLCEGz1gqbAZUjR2LLRV6S NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3asnt71885-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 10:32:33 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17VE4YeK032780;
        Tue, 31 Aug 2021 10:32:32 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3asnt71874-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 10:32:32 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17VEHYIO006906;
        Tue, 31 Aug 2021 14:32:30 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3aqcs9c65f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 Aug 2021 14:32:30 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17VEWP1N52101556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Aug 2021 14:32:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77DEBAE06A;
        Tue, 31 Aug 2021 14:32:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03FC9AE05F;
        Tue, 31 Aug 2021 14:32:25 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.145.164.122])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 31 Aug 2021 14:32:24 +0000 (GMT)
Subject: Re: [PATCH v4 04/14] KVM: s390: pv: avoid stalls when making pages
 secure
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich.Weigand@de.ibm.com
References: <20210818132620.46770-1-imbrenda@linux.ibm.com>
 <20210818132620.46770-5-imbrenda@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <731aeb25-3883-5941-9400-7cd8c43fc31c@de.ibm.com>
Date:   Tue, 31 Aug 2021 16:32:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818132620.46770-5-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nmgsrCJs4maGmaCDAAGwWqGZKiYANIHd
X-Proofpoint-ORIG-GUID: 4sx5EiE5QIMtZANOyzQ3koe6epN6LH9T
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_05:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108310078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18.08.21 15:26, Claudio Imbrenda wrote:
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

To me it looks like
handle_pv_uvc does not handle EAGAIN but also calls into this code. Is this code
path ok or do we need to change something here?

> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Fixes: 214d9bbcd3a672 ("s390/mm: provide memory management functions for protected KVM guests")
> ---
>   arch/s390/kernel/uv.c | 29 +++++++++++++++++++++++------
>   1 file changed, 23 insertions(+), 6 deletions(-)
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
> 
