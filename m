Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443497D95BF
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 12:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345598AbjJ0K4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 06:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345705AbjJ0K4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 06:56:53 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C8918F;
        Fri, 27 Oct 2023 03:56:50 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39RAjJTH023549;
        Fri, 27 Oct 2023 10:56:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3xTOujzU2+wfvwjQLEOWJbIoUBF5JE+bAZsliuvGrZc=;
 b=er96YzU/6CqXwgpvpeq9EEZLkhQAm21cVl8uzuddC/ZIHFssj45d2/ZdR6UmMv+rB9In
 NjjNwYhpARUlxiMT7mW6LGFRf8vcE3rTnvA9Afl6Vi66wc9kvWX97V4l4We3wr0bkULy
 Ws41wGzk1EDIi7cZ/0kTbnqmbl3PPkMxL46p0ClpPMKqphOvj+o3PV2RQjKD6IXMAZos
 Irgtje/f1X8REbgt/+kFBNfbtkNjK824ryVPIlgOEbaYbU8bXxhsfh8g8gYdPuVKdlgB
 aPbjWBL9rajGrHDeW7PPPnnw+7Iri0flYTWAD7HotRUqZ9U+/G/8c6/930sXOtaYlap6 Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0bqv8bw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 10:56:49 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39RAl17H028892;
        Fri, 27 Oct 2023 10:56:46 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u0bqv8bvr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 10:56:46 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39RASYoD021676;
        Fri, 27 Oct 2023 10:56:45 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tywqscgay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 Oct 2023 10:56:45 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39RAugOc11141710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Oct 2023 10:56:42 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 441142004B;
        Fri, 27 Oct 2023 10:56:42 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B78420043;
        Fri, 27 Oct 2023 10:56:42 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 27 Oct 2023 10:56:41 +0000 (GMT)
Date:   Fri, 27 Oct 2023 12:56:38 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v2 2/3] s390/vfio-ap: set status response code to 06 on
 gisc registration failure
Message-ID: <20231027125638.67a65ab9.pasic@linux.ibm.com>
In-Reply-To: <20231018133829.147226-3-akrowiak@linux.ibm.com>
References: <20231018133829.147226-1-akrowiak@linux.ibm.com>
        <20231018133829.147226-3-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ccMaKxqSscfAkitskD15OcwWmpme2vXw
X-Proofpoint-ORIG-GUID: TnkQt8qym4ubyKi7kND7DFziGp3zYyWx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-27_08,2023-10-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 adultscore=0 mlxlogscore=999 clxscore=1011 impostorscore=0
 phishscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2310270093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 18 Oct 2023 09:38:24 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> From: Anthony Krowiak <akrowiak@linux.ibm.com>
> 
> The interception handler for the PQAP(AQIC) command calls the
> kvm_s390_gisc_register function to register the guest ISC with the channel
> subsystem. If that call fails, the status response code 08 - indicating
> Invalid ZONE/GISA designation - is returned to the guest. This response
> code does not make sense because the non-zero return code from the
> kvm_s390_gisc_register function can be due one of two things: Either the
> ISC passed as a parameter by the guest to the PQAP(AQIC) command is greater
> than the maximum ISC value allowed, or the guest is not using a GISA.

The "ISC passed as a parameter by the guest to the PQAP(AQIC) command is
greater than the maximum ISC value allowed" is not possible. The isc is
3 bits wide and all 8 values that can be represented on 3 bits are valid.

This is only possible if the hypervisor was to mess up, or if the machine
was broken.

> 
> Since this scenario is very unlikely to happen and there is no status
> response code to indicate an invalid ISC value, let's set the
> response code to 06 indicating 'Invalid address of AP-queue notification
> byte'. While this is not entirely accurate, it is better than indicating
> that the ZONE/GISA designation is invalid which is something the guest
> can do nothing about since those values are set by the hypervisor.
> 
> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Suggested-by: Halil Pasic <pasic@linux.ibm.com>


> ---
>  drivers/s390/crypto/vfio_ap_ops.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 9cb28978c186..25d7ce2094f8 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -393,8 +393,8 @@ static int ensure_nib_shared(unsigned long addr, struct gmap *gmap)
>   * Register the guest ISC to GIB interface and retrieve the
>   * host ISC to issue the host side PQAP/AQIC
>   *
> - * Response.status may be set to AP_RESPONSE_INVALID_ADDRESS in case the
> - * vfio_pin_pages failed.
> + * status.response_code may be set to AP_RESPONSE_INVALID_ADDRESS in case the
> + * vfio_pin_pages or kvm_s390_gisc_register failed.
>   *
>   * Otherwise return the ap_queue_status returned by the ap_aqic(),
>   * all retry handling will be done by the guest.
> @@ -458,7 +458,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
>  				 __func__, nisc, isc, q->apqn);
>  
>  		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
> -		status.response_code = AP_RESPONSE_INVALID_GISA;
> +		status.response_code = AP_RESPONSE_INVALID_ADDRESS;
>  		return status;
>  	}
>  

