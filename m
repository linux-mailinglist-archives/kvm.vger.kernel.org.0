Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1F6CE9757
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2019 08:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfJ3HoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Oct 2019 03:44:20 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34230 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726063AbfJ3HoT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 30 Oct 2019 03:44:19 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9U7gmft099000
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2019 03:44:18 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vy37vw25j-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 30 Oct 2019 03:44:18 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <freude@linux.ibm.com>;
        Wed, 30 Oct 2019 07:44:16 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 30 Oct 2019 07:44:12 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9U7iCO361866182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Oct 2019 07:44:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E728642041;
        Wed, 30 Oct 2019 07:44:11 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DCF642052;
        Wed, 30 Oct 2019 07:44:11 +0000 (GMT)
Received: from funtu.home (unknown [9.145.158.134])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Oct 2019 07:44:11 +0000 (GMT)
Subject: Re: [PATCH] s390: vfio-ap: disable IRQ in remove callback results in
 kernel OOPS
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com
References: <1572386946-22566-1-git-send-email-akrowiak@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Wed, 30 Oct 2019 08:44:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1572386946-22566-1-git-send-email-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19103007-0008-0000-0000-0000032907CB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19103007-0009-0000-0000-00004A484CD5
Message-Id: <0565c250-726f-dd99-f933-f91162dc107e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-30_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910300076
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29.10.19 23:09, Tony Krowiak wrote:
> From: aekrowia <akrowiak@linux.ibm.com>
>
> When an AP adapter card is configured off via the SE or the SCLP
> Deconfigure Adjunct Processor command and the AP bus subsequently detects
> that the adapter card is no longer in the AP configuration, the card
> device representing the adapter card as well as each of its associated
> AP queue devices will be removed by the AP bus. If one or more of the
> affected queue devices is bound to the VFIO AP device driver, its remove
> callback will be invoked for each queue to be removed. The remove callback
> resets the queue and disables IRQ processing. If interrupt processing was
> never enabled for the queue, disabling IRQ processing will fail resulting
> in a kernel OOPS.
>
> This patch verifies IRQ processing is enabled before attempting to disable
> interrupts for the queue.
>
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Signed-off-by: aekrowia <akrowiak@linux.ibm.com>
> ---
>  drivers/s390/crypto/vfio_ap_drv.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
> index be2520cc010b..42d8308fd3a1 100644
> --- a/drivers/s390/crypto/vfio_ap_drv.c
> +++ b/drivers/s390/crypto/vfio_ap_drv.c
> @@ -79,7 +79,8 @@ static void vfio_ap_queue_dev_remove(struct ap_device *apdev)
>  	apid = AP_QID_CARD(q->apqn);
>  	apqi = AP_QID_QUEUE(q->apqn);
>  	vfio_ap_mdev_reset_queue(apid, apqi, 1);
> -	vfio_ap_irq_disable(q);
> +	if (q->saved_isc != VFIO_AP_ISC_INVALID)
> +		vfio_ap_irq_disable(q);
>  	kfree(q);
>  	mutex_unlock(&matrix_dev->lock);
>  }
Reset of an APQN does also clear IRQ processing. I don't say that the
resources associated with IRQ handling for the APQN are also cleared.
But when you call PQAP(AQIC) after an PQAP(RAPQ) or PQAP(ZAPQ)
it is superfluous. However, there should not appear any kernel OOPS.
So can you please give me more details about this kernel oops - maybe
I need to add exception handler code to the inline ap_aqic() function.

regards, Harald Freudenberger

