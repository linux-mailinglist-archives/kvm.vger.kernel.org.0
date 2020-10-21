Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698A1295025
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 17:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502686AbgJUPq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 11:46:58 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731418AbgJUPq5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 21 Oct 2020 11:46:57 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09LFZYYf156719;
        Wed, 21 Oct 2020 11:46:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=eSg8TA/oMOmSlb52iatw5KngnYQc5Vgzaw+Vw2aADeI=;
 b=CUZzVTFoft7gpvSW9lNDiZR09SgQf0JXwpEWb5K9MpfWKLY7M2Md/BtB8dzc79ABqftr
 2q3gFmriJcSQrhGU1Xdf+6sFfwaBuKGQuxOQXxikWVPbyIrwwQbLui5togRtCYCAZpDK
 9VsYGGaTTkgyqvyL78VbyojX3jlyjKjqKvS8L2c5dKUjJe+kWsavlHN9s6EEvyztLkTi
 ukPKkZUfqcfell1HGPwg7f1EuVw77XUC8RmuSmlHj1mnSFOGR2VzVHscnilJAHIhk5d9
 US0x8RPTgobEuPjKlxKwu8AHgzJWRWIdxM2JXFhdznOFyQkC+GVunLzhPFUlUrBUOKJv xQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34aqft8tsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 11:46:52 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09LFahPu161103;
        Wed, 21 Oct 2020 11:46:52 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34aqft8tsg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 11:46:52 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09LFW7VT030031;
        Wed, 21 Oct 2020 15:46:51 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03dal.us.ibm.com with ESMTP id 347r89hc99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Oct 2020 15:46:51 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09LFko9B49086876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 15:46:50 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADACF124058;
        Wed, 21 Oct 2020 15:46:50 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DFD6124053;
        Wed, 21 Oct 2020 15:46:50 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.85.170.177])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 21 Oct 2020 15:46:50 +0000 (GMT)
Subject: Re: [PATCH] s390/vfio-ap: fix unregister GISC when KVM is already
 gone results in OOPS
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, cohuck@redhat.com,
        kwankhede@nvidia.com, borntraeger@de.ibm.com
References: <20200918170234.5807-1-akrowiak@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <f3d21bbf-4d25-eac8-cc88-c654b8406316@linux.ibm.com>
Date:   Wed, 21 Oct 2020 11:46:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200918170234.5807-1-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-21_06:2020-10-20,2020-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=2 clxscore=1015
 adultscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 impostorscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010210113
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In trying to recreate this problem in order to get a stack trace, I 
discovered that
it only occurs within a local repository that has several new patches 
applied,
so the problem is not part of the base code and will be fixed via this 
new set
of patches forthcoming.

On 9/18/20 1:02 PM, Tony Krowiak wrote:
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

