Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5D1414A1D
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 15:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhIVNGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:06:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40168 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230180AbhIVNGt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 09:06:49 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18MCD5kM009203;
        Wed, 22 Sep 2021 09:05:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=z9gdhd93/UAvan1rXwGwITh0P+5rMHlSMbScNaYqTYI=;
 b=tMBINywXUOBATry+6hm1ek5gY7jbuTg5Sc2M6snWJodwmnetiI2Js9xlVCB6m4sPapa1
 GSG+js180RyU/wrL05JyvvO1IjwcztGkMp+sggxhVqA0CPP7rKAS1hFwStno0HMgW0XU
 /oNF9QxY3Xv/SCHnPAhNwq6Sspf8KY7ud7UaT/speXKr+8xbUd/NStxbMDS2hyPMtGaf
 RS5cqj3P8Y1t2MHoJtr85sdRHc9WncOxhrOogwFoAaNAfSR5YT3ONYko1uUH+up3v5/I
 EDBOz5nJ9CytrWVhObi2ADSdq3R6NH9kQX6HCXcB/BMfpb1GfS8ydltW+BhL7cS2CSjs /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b8230vje4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:05:11 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18MC04JR012850;
        Wed, 22 Sep 2021 09:05:11 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b8230vjd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 09:05:11 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18MCw9U0019135;
        Wed, 22 Sep 2021 13:05:10 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 3b7q6td9bd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Sep 2021 13:05:09 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18MD58gc39387414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 13:05:08 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B43AB6E065;
        Wed, 22 Sep 2021 13:05:08 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 636EA6E070;
        Wed, 22 Sep 2021 13:05:07 +0000 (GMT)
Received: from cpe-172-100-181-211.stny.res.rr.com (unknown [9.65.75.198])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 22 Sep 2021 13:05:07 +0000 (GMT)
Subject: Re: [PATCH v3] vfio/ap_ops: Add missed vfio_uninit_group_dev()
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
References: <0-v3-f9b50340cdbb+e4-ap_uninit_jgg@nvidia.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <4a50ed05-c60c-aad0-bceb-de9665602aed@linux.ibm.com>
Date:   Wed, 22 Sep 2021 09:05:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <0-v3-f9b50340cdbb+e4-ap_uninit_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 33bWobvGGjttjIDRF_JqZHHETomYlO3U
X-Proofpoint-ORIG-GUID: Y_mmh8qc6g2KnVJOsbIjsOnFiRVuBOEj
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-22_04,2021-09-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 impostorscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 clxscore=1015 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/21/21 8:11 AM, Jason Gunthorpe wrote:
> Without this call an xarray entry is leaked when the vfio_ap device is
> unprobed. It was missed when the below patch was rebased across the
> dev_set patch. Keep the remove function in the same order as the error
> unwind in probe.
>
> Fixes: eb0feefd4c02 ("vfio/ap_ops: Convert to use vfio_register_group_dev()")
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Tested-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> v3:
>   - Keep the remove sequence the same as remove to avoid a lockdep splat
> v2: https://lore.kernel.org/r/0-v2-25656bbbb814+41-ap_uninit_jgg@nvidia.com/
>   - Fix corrupted diff
> v1: https://lore.kernel.org/r/0-v1-3a05c6000668+2ce62-ap_uninit_jgg@nvidia.com/
>
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 118939a7729a1e..623d5269a52ce5 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -361,6 +361,7 @@ static int vfio_ap_mdev_probe(struct mdev_device *mdev)
>   	mutex_lock(&matrix_dev->lock);
>   	list_del(&matrix_mdev->node);
>   	mutex_unlock(&matrix_dev->lock);
> +	vfio_uninit_group_dev(&matrix_mdev->vdev);
>   	kfree(matrix_mdev);
>   err_dec_available:
>   	atomic_inc(&matrix_dev->available_instances);
> @@ -376,9 +377,10 @@ static void vfio_ap_mdev_remove(struct mdev_device *mdev)
>   	mutex_lock(&matrix_dev->lock);
>   	vfio_ap_mdev_reset_queues(matrix_mdev);
>   	list_del(&matrix_mdev->node);
> +	mutex_unlock(&matrix_dev->lock);
> +	vfio_uninit_group_dev(&matrix_mdev->vdev);
>   	kfree(matrix_mdev);
>   	atomic_inc(&matrix_dev->available_instances);

I think the above line of code should be done under the
matrix_dev->lock after removing the matrix_mdev from
the list since it is changing a value in matrix_dev.


> -	mutex_unlock(&matrix_dev->lock);
>   }
>   
>   static ssize_t name_show(struct mdev_type *mtype,
>
> base-commit: 6880fa6c56601bb8ed59df6c30fd390cc5f6dd8f

