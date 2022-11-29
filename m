Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5EFC63CAE8
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 23:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbiK2WCk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 17:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236298AbiK2WCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 17:02:37 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F232AD5;
        Tue, 29 Nov 2022 14:02:34 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATLo9So011304;
        Tue, 29 Nov 2022 22:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Lcetb9RicIcWglNgifjgHubk9ZhIypVPUet+BElnXMA=;
 b=sXtEemQR0Qv/A7TEgG2UhLXWTWwwzwZIEmAAzjZNJGhuW+6q1FZEnnFaH//Yfqy3su+C
 gPOiQFSD5jhJjNIZCRhZ4CtdmRBuGLSWXcD2xSBWf+r+In80pbYVa5a0FUGe82kjokIr
 RJ7hSmvETKKxNeS4vGZlTA3FPrgvldcpMGSWVKcJ56Ys6frp6ixgTcopPPwwhVybYhMf
 eUwOkzyIGQJBS3rLOq3lHfauh5QwaAwFSSOc+c2AaWMeWDxxD1NZw/TqP9yoozyy/0QP
 NljpUgAPrH5mmyTB3QsDXmf3NDw2lC3oVSXQvZ7wPXfHYRrTM4D9lFeuOMdy1zPD/S/T 6Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5qr1v7ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 22:02:27 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ATLrILs022914;
        Tue, 29 Nov 2022 22:02:26 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m5qr1v7dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 22:02:26 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ATLpMvp008691;
        Tue, 29 Nov 2022 22:02:26 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 3m3t71kpnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 29 Nov 2022 22:02:26 +0000
Received: from smtpav06.dal12v.mail.ibm.com ([9.208.128.130])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ATM2LR554657332
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 22:02:21 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 89B265805F;
        Tue, 29 Nov 2022 22:02:24 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AE63E58055;
        Tue, 29 Nov 2022 22:02:23 +0000 (GMT)
Received: from [9.65.217.194] (unknown [9.65.217.194])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 29 Nov 2022 22:02:23 +0000 (GMT)
Message-ID: <69fd3f57-4589-2d9e-3aa1-7959cc1711e6@linux.ibm.com>
Date:   Tue, 29 Nov 2022 17:02:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [[RESEND] iommufd PATCH v2 2/2] vfio/ap: validate iova during
 dma_unmap and trigger irq disable
To:     Yi Liu <yi.l.liu@intel.com>, jgg@nvidia.com
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
References: <20221129105831.466954-1-yi.l.liu@intel.com>
 <20221129105831.466954-3-yi.l.liu@intel.com>
Content-Language: en-US
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20221129105831.466954-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: plbhbYOf4vNN-hd8idCHfl5ZOPcO-zZ6
X-Proofpoint-ORIG-GUID: T-dzPpbJb3dB6B702_08VyItjyj50BjP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_13,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 clxscore=1011 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211290127
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LGTM:

Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>

On 11/29/22 5:58 AM, Yi Liu wrote:
> From: Matthew Rosato <mjrosato@linux.ibm.com>
>
> Currently, each mapped iova is stashed in its associated vfio_ap_queue;
> when we get an unmap request, validate that it matches with one or more
> of these stashed values before attempting unpins.
>
> Each stashed iova represents IRQ that was enabled for a queue.  Therefore,
> if a match is found, trigger IRQ disable for this queue to ensure that
> underlying firmware will no longer try to use the associated pfn after
> the page is unpinned. IRQ disable will also handle the associated unpin.
>
> Cc: Tony Krowiak <akrowiak@linux.ibm.com>
> Cc: Halil Pasic <pasic@linux.ibm.com>
> Cc: Jason Herne <jjherne@linux.ibm.com>
> Cc: linux-s390@vger.kernel.org
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 18 +++++++++++++++++-
>   1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 0b4cc8c597ae..8bf353d46820 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -1535,13 +1535,29 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>   	return 0;
>   }
>   
> +static void unmap_iova(struct ap_matrix_mdev *matrix_mdev, u64 iova, u64 length)
> +{
> +	struct ap_queue_table *qtable = &matrix_mdev->qtable;
> +	struct vfio_ap_queue *q;
> +	int loop_cursor;
> +
> +	hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
> +		if (q->saved_iova >= iova && q->saved_iova < iova + length)
> +			vfio_ap_irq_disable(q);
> +	}
> +}
> +
>   static void vfio_ap_mdev_dma_unmap(struct vfio_device *vdev, u64 iova,
>   				   u64 length)
>   {
>   	struct ap_matrix_mdev *matrix_mdev =
>   		container_of(vdev, struct ap_matrix_mdev, vdev);
>   
> -	vfio_unpin_pages(&matrix_mdev->vdev, iova, 1);
> +	mutex_lock(&matrix_dev->mdevs_lock);
> +
> +	unmap_iova(matrix_mdev, iova, length);
> +
> +	mutex_unlock(&matrix_dev->mdevs_lock);
>   }
>   
>   /**
