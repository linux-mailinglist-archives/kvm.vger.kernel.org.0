Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8AA3916CE
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 13:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhEZL6h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 07:58:37 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37256 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232869AbhEZL6g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 07:58:36 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QBZ061171514;
        Wed, 26 May 2021 07:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eO8+n+Sq2ZxdbE7fydKtJxxn77bqvxKFRhLTUXbsAdc=;
 b=VEYDl1bwRKw7Qpl/Df4QCMQ+ojmViELmF4i2C//WWp8XyeeimoaMcqRHz+mK+b6b+Hgw
 xwwMBM4hX2qS9xSk9cIz7mDbvORWvJZu2hp5D4xm2KEhGjZA9IvlPqiui3/GD+o179xQ
 cZiRC94oXblwDBb5Gde3PRw83rVVpbh9ChYwZGihk9rCW5xDsVyuFMWq0YTYgjL3UUT4
 7aQKfRB9jska1YcUhPnBYrd9yTwFgKAvAxOKwyWXR61Xscsh+kn3lwYmq5111iBfYVGd
 ub6dAwpMkYMrDxLwSQCMJnBqqBGUEIzdhg21j2IK8HptJ2Com9ezy8oA69Z3fckHc6q2 aA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38smgm2fek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 07:57:04 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14QBZ60R173013;
        Wed, 26 May 2021 07:57:04 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38smgm2fe1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 07:57:04 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 14QBrmV1013272;
        Wed, 26 May 2021 11:57:02 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 38s1r48gvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 11:57:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14QBux3b32768438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 11:56:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 010454C04E;
        Wed, 26 May 2021 11:56:59 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 718354C044;
        Wed, 26 May 2021 11:56:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.174.11])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 May 2021 11:56:58 +0000 (GMT)
Subject: Re: [PATCH v1 07/11] KVM: s390: pv: add export before import
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
 <20210517200758.22593-8-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Message-ID: <2ccebdfa-af59-a81f-9a18-35c3fb080331@linux.ibm.com>
Date:   Wed, 26 May 2021 13:56:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517200758.22593-8-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6kB_OUbu9yEuqU2TKvNrxfqAwd8gtELF
X-Proofpoint-ORIG-GUID: mMriH-6jgR_8uHuwK78QEmK9ezzsoTBC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_08:2021-05-26,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2105260077
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/17/21 10:07 PM, Claudio Imbrenda wrote:
> Due to upcoming changes, it will be possible to temporarily have
> multiple protected VMs in the same address space. When that happens,
> it is necessary to perform an export of every page that is to be
> imported.

... since the Ultravisor doesn't allow KVM to import a secure page
belonging to guest A to be imported for guest B in order to guarantee
proper guest isolation.

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>  arch/s390/kernel/uv.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index b19b1a1444ec..dbcf4434eb53 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -242,6 +242,12 @@ static int make_secure_pte(pte_t *ptep, unsigned long addr,
>  	return rc;
>  }
>  
> +static bool should_export_before_import(struct uv_cb_header *uvcb, struct mm_struct *mm)
> +{
> +	return uvcb->cmd != UVC_CMD_UNPIN_PAGE_SHARED &&
> +		atomic_read(&mm->context.is_protected) > 1;
> +}
> +
>  /*
>   * Requests the Ultravisor to make a page accessible to a guest.
>   * If it's brought in the first time, it will be cleared. If
> @@ -285,6 +291,8 @@ int gmap_make_secure(struct gmap *gmap, unsigned long gaddr, void *uvcb)
>  
>  	lock_page(page);
>  	ptep = get_locked_pte(gmap->mm, uaddr, &ptelock);
> +	if (should_export_before_import(uvcb, gmap->mm))
> +		uv_convert_from_secure(page_to_phys(page));
>  	rc = make_secure_pte(ptep, uaddr, page, uvcb);
>  	pte_unmap_unlock(ptep, ptelock);
>  	unlock_page(page);
> 

