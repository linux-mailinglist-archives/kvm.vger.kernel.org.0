Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CB0271DD9
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 10:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgIUIY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 04:24:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:44666 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726318AbgIUIY5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Sep 2020 04:24:57 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08L82tL5065811;
        Mon, 21 Sep 2020 04:24:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=vS8YPPsrj2iP2hNgx4WZFZGQp+EMbBrT5m6yG9GczQ4=;
 b=mql2vsTWRnCmb/yeVrE3DgIHKSQZmEubCEIHUBanAst7FwsNetXfMVlerxJnVDIUHnl0
 v6+YJ2nuk2nOUF7WdlrkPT25r//a/AO+JSrxkgTvwTyy675H7TQIiyQTH8pPz0N/qzz1
 ifM286C1SXwf5ivLKrCHZYkPx2z7X5e5HphmYM7WJkGVClU0tjpR3ySi2A2XjT6fKRsa
 3WKoR0RBrCRhkK50/pfHX5+ktAWKxCRxPAZjm1UCCXwjizRXEkMJvbxtfTlDn01+KojG
 k8yI42Zr+bMkreH1HGe5POFmAyPHMgMnRxeXZm0R+SO+W2VfNQkpYwd7yGc7F3uk/1lZ DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33pr1k16qu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 04:24:56 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08L83UPG067455;
        Mon, 21 Sep 2020 04:24:56 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33pr1k16q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 04:24:56 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08L8M93E027430;
        Mon, 21 Sep 2020 08:24:53 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 33payu8j67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Sep 2020 08:24:53 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08L8Ooq722348054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 08:24:50 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C0112AE04D;
        Mon, 21 Sep 2020 08:24:50 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4DE46AE045;
        Mon, 21 Sep 2020 08:24:50 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.86.99])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Sep 2020 08:24:50 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: fix unregister GISC when KVM is already
 gone results in OOPS
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pasic@linux.ibm.com, alex.williamson@redhat.com, cohuck@redhat.com,
        kwankhede@nvidia.com, borntraeger@de.ibm.com
References: <20200918170234.5807-1-akrowiak@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <5b7fcfc8-fe8d-c7b4-0174-d1b3ee9de28b@linux.ibm.com>
Date:   Mon, 21 Sep 2020 10:24:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200918170234.5807-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-21_01:2020-09-21,2020-09-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 lowpriorityscore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=2 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009210058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-09-18 19:02, Tony Krowiak wrote:
> Attempting to unregister Guest Interruption Subclass (GISC) when the
> link between the matrix mdev and KVM has been removed results in the
> following:
> 
>     "Kernel panic -not syncing: Fatal exception: panic_on_oops"
> 
> This patch fixes this bug by verifying the matrix mdev and KVM are still
> linked prior to unregistering the GISC.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index e0bde8518745..847a88642644 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -119,11 +119,15 @@ static void vfio_ap_wait_for_irqclear(int apqn)
>    */
>   static void vfio_ap_free_aqic_resources(struct vfio_ap_queue *q)
>   {
> -	if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev)

I think you could have make the patch smaller by adding the missing test 
for kvm here.


> -		kvm_s390_gisc_unregister(q->matrix_mdev->kvm, q->saved_isc);
> -	if (q->saved_pfn && q->matrix_mdev)
> -		vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> -				 &q->saved_pfn, 1);
> +	if (q->matrix_mdev) {
> +		if (q->saved_isc != VFIO_AP_ISC_INVALID && q->matrix_mdev->kvm)
> +			kvm_s390_gisc_unregister(q->matrix_mdev->kvm,
> +						 q->saved_isc);
> +		if (q->saved_pfn)
> +			vfio_unpin_pages(mdev_dev(q->matrix_mdev->mdev),
> +					 &q->saved_pfn, 1);
> +	}
> +
>   	q->saved_pfn = 0;
>   	q->saved_isc = VFIO_AP_ISC_INVALID;
>   }
> 

-- 
Pierre Morel
IBM Lab Boeblingen
