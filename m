Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5E647DA2
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 10:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFQIwr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 04:52:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51532 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbfFQIwr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 Jun 2019 04:52:47 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5H8q4Qb034720
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 04:52:46 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t67eqrs1p-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Jun 2019 04:52:46 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <freude@linux.ibm.com>;
        Mon, 17 Jun 2019 09:47:43 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 17 Jun 2019 09:47:40 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5H8lctl59441296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jun 2019 08:47:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3F7DD4203F;
        Mon, 17 Jun 2019 08:47:38 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 921304204D;
        Mon, 17 Jun 2019 08:47:37 +0000 (GMT)
Received: from [10.0.2.15] (unknown [9.152.224.114])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Jun 2019 08:47:37 +0000 (GMT)
Subject: Re: [PATCH v4 2/7] s390: vfio-ap: wait for queue empty on queue reset
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, cohuck@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, mjrosato@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, pmorel@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com
References: <1560454780-20359-1-git-send-email-akrowiak@linux.ibm.com>
 <1560454780-20359-3-git-send-email-akrowiak@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Mon, 17 Jun 2019 10:47:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1560454780-20359-3-git-send-email-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19061708-0008-0000-0000-000002F464B3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061708-0009-0000-0000-000022617551
Message-Id: <b7f2d9df-26d8-9915-5345-f17e6cd0ef93@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170084
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13.06.19 21:39, Tony Krowiak wrote:
> Refactors the AP queue reset function to wait until the queue is empty
> after the PQAP(ZAPQ) instruction is executed to zero out the queue as
> required by the AP architecture.
>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 49 +++++++++++++++++++++++++++------------
>  1 file changed, 34 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index bf2ab02b9a0b..60efd3d7896d 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1128,23 +1128,46 @@ static void vfio_ap_irq_disable_apqn(int apqn)
>  	}
>  }
>  
> -int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi,
> -			     unsigned int retry)
> +static void vfio_ap_mdev_wait_for_qempty(ap_qid_t qid)
> +{
> +	struct ap_queue_status status;
> +	int retry = 5;
> +
> +	do {
> +		status = ap_tapq(qid, NULL);
> +		switch (status.response_code) {
> +		case AP_RESPONSE_NORMAL:
> +			if (status.queue_empty)
> +				return;
> +		case AP_RESPONSE_RESET_IN_PROGRESS:
> +		case AP_RESPONSE_BUSY:
> +			msleep(20);
> +			break;
> +		default:
> +			pr_warn("%s: tapq response %02x waiting for queue %04x.%02x empty\n",
> +				__func__, status.response_code,
> +				AP_QID_CARD(qid), AP_QID_QUEUE(qid));
The ap and zcrypt code uses %02x.%04x for displaying an APQN.
I would also recommend to handle 0x01 (AP_RESPONSE_Q_NOT_AVAIL) and
0x03 (AP_RESPONSE_DECONFIGURED) as this code may run when a APQN
is removed from the configuration of the LPAR. However, it's up to you if you
want to handle these with the default statement and issue an sysfs warning.
> +			return;
> +		}
> +	} while (--retry);
> +
> +	WARN_ON_ONCE(retry <= 0);
> +}
> +
> +int vfio_ap_mdev_reset_queue(unsigned int apid, unsigned int apqi)
>  {
>  	struct ap_queue_status status;
> -	int retry2 = 2;
>  	int apqn = AP_MKQID(apid, apqi);
> +	int retry = 5;
>  
>  	do {
>  		status = ap_zapq(apqn);
>  		switch (status.response_code) {
>  		case AP_RESPONSE_NORMAL:
> -			while (!status.queue_empty && retry2--) {
> -				msleep(20);
> -				status = ap_tapq(apqn, NULL);
> -			}
> -			WARN_ON_ONCE(retry <= 0);
> +			vfio_ap_mdev_wait_for_qempty(AP_MKQID(apid, apqi));
>  			return 0;
> +		case AP_RESPONSE_DECONFIGURED:
> +			return -ENODEV;
>  		case AP_RESPONSE_RESET_IN_PROGRESS:
>  		case AP_RESPONSE_BUSY:
>  			msleep(20);
> @@ -1169,14 +1192,10 @@ static int vfio_ap_mdev_reset_queues(struct mdev_device *mdev)
>  			     matrix_mdev->matrix.apm_max + 1) {
>  		for_each_set_bit_inv(apqi, matrix_mdev->matrix.aqm,
>  				     matrix_mdev->matrix.aqm_max + 1) {
> -			ret = vfio_ap_mdev_reset_queue(apid, apqi, 1);
> -			/*
> -			 * Regardless whether a queue turns out to be busy, or
> -			 * is not operational, we need to continue resetting
> -			 * the remaining queues.
> -			 */
> +			ret = vfio_ap_mdev_reset_queue(apid, apqi);
>  			if (ret)
>  				rc = ret;
> +
>  			vfio_ap_irq_disable_apqn(AP_MKQID(apid, apqi));
>  		}
>  	}
> @@ -1326,7 +1345,7 @@ void vfio_ap_mdev_remove_queue(struct ap_queue *queue)
>  	dev_set_drvdata(&queue->ap_dev.device, NULL);
>  	apid = AP_QID_CARD(q->apqn);
>  	apqi = AP_QID_QUEUE(q->apqn);
> -	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> +	vfio_ap_mdev_reset_queue(apid, apqi);
>  	vfio_ap_irq_disable(q);
>  	kfree(q);
>  }

