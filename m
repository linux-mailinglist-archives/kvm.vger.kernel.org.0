Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D134814485
	for <lists+kvm@lfdr.de>; Mon,  6 May 2019 08:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbfEFGlN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 May 2019 02:41:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45130 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725710AbfEFGlN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 May 2019 02:41:13 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x466bVg6042439
        for <kvm@vger.kernel.org>; Mon, 6 May 2019 02:41:12 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sacfa6x3u-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 06 May 2019 02:41:12 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Mon, 6 May 2019 07:41:10 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 6 May 2019 07:41:07 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x466f6CU51445868
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 May 2019 06:41:06 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E228952065;
        Mon,  6 May 2019 06:41:05 +0000 (GMT)
Received: from [9.145.46.119] (unknown [9.145.46.119])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 4AA8D5205A;
        Mon,  6 May 2019 06:41:05 +0000 (GMT)
Reply-To: pmorel@linux.ibm.com
Subject: Re: [PATCH v2 1/7] s390: vfio-ap: wait for queue empty on queue reset
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        frankja@linux.ibm.com, david@redhat.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com
References: <1556918073-13171-1-git-send-email-akrowiak@linux.ibm.com>
 <1556918073-13171-2-git-send-email-akrowiak@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Mon, 6 May 2019 08:41:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1556918073-13171-2-git-send-email-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19050606-0012-0000-0000-00000318B306
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19050606-0013-0000-0000-000021512AA5
Message-Id: <0bdb1655-4c4e-1982-a842-9dfc7c02a576@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-06_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905060056
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/2019 23:14, Tony Krowiak wrote:
> Refactors the AP queue reset function to wait until the queue is empty
> after the PQAP(ZAPQ) instruction is executed to zero out the queue as
> required by the AP architecture.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 35 ++++++++++++++++++++++++++++++++---
>   1 file changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 900b9cf20ca5..b88a2a2ba075 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -271,6 +271,32 @@ static int vfio_ap_mdev_verify_no_sharing(struct ap_matrix_mdev *matrix_mdev)
>   	return 0;
>   }
>   
> +static void vfio_ap_mdev_wait_for_qempty(unsigned long apid, unsigned long apqi)
> +{
> +	struct ap_queue_status status;
> +	ap_qid_t qid = AP_MKQID(apid, apqi);
> +	int retry = 5;
> +
> +	do {
> +		status = ap_tapq(qid, NULL);
> +		switch (status.response_code) {
> +		case AP_RESPONSE_NORMAL:
> +			if (status.queue_empty)
> +				return;
> +			msleep(20);

NIT: 	Fall through ?

> +			break;
> +		case AP_RESPONSE_RESET_IN_PROGRESS:
> +		case AP_RESPONSE_BUSY:
> +			msleep(20);
> +			break;
> +		default:
> +			pr_warn("%s: tapq err %02x: %04lx.%02lx may not be empty\n",
> +				__func__, status.response_code, apid, apqi);

I do not thing the warning sentence is appropriate:
The only possible errors here are if the AP is not available due to AP 
checkstop, deconfigured AP or invalid APQN.


> +			return;
> +		}
> +	} while (--retry);
> +}
> +
>   /**
>    * assign_adapter_store
>    *
> @@ -790,15 +816,18 @@ static int vfio_ap_mdev_group_notifier(struct notifier_block *nb,
>   	return NOTIFY_OK;
>   }
>   
> -static int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> -				    unsigned int retry)
> +int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi)
>   {
>   	struct ap_queue_status status;
> +	int retry = 5;
>   
>   	do {
>   		status = ap_zapq(AP_MKQID(apid, apqi));
>   		switch (status.response_code) {
>   		case AP_RESPONSE_NORMAL:
> +			vfio_ap_mdev_wait_for_qempty(apid, apqi);
> +			return 0;
> +		case AP_RESPONSE_DECONFIGURED:

Since you modify the switch, you can return for all the following cases:
AP_RESPONSE_DECONFIGURE
..._CHECKSTOP
..._INVALID_APQN


And you should wait for qempty on AP_RESET_IN_PROGRESS along with 
AP_RESPONSE_NORMAL

>   			return 0;
>   		case AP_RESPONSE_RESET_IN_PROGRESS:
>   		case AP_RESPONSE_BUSY:

While at modifying this function, the AP_RESPONSE_BUSY is not a valid 
code for ZAPQ, you can remove this.

> @@ -824,7 +853,7 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>   			     matrix_mdev->matrix.apm_max + 1) {
>   		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
>   				     matrix_mdev->matrix.aqm_max + 1) {
> -			ret = vfio_ap_mdev_reset_queue(apid, apqi, 1);
> +			ret = vfio_ap_mdev_reset_queue(apid, apqi);

IMHO, since you are at changing this call, passing the apqn as parameter 
would be a good simplification.



>   			/*
>   			 * Regardless whether a queue turns out to be busy, or
>   			 * is not operational, we need to continue resetting

Depends on why the reset failed, but this is out of scope.

> 


-- 
Pierre Morel
Linux/KVM/QEMU in Böblingen - Germany

