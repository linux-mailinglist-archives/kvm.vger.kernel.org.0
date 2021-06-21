Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A2F3AF15B
	for <lists+kvm@lfdr.de>; Mon, 21 Jun 2021 19:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbhFURIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 13:08:14 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42882 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230056AbhFURIJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 21 Jun 2021 13:08:09 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15LH4Wt9155774;
        Mon, 21 Jun 2021 13:05:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=o8wMvApiow6Zn5Y2v41+NZF8QNWxGVvu1MeLNe4pPLE=;
 b=XxZHApvNlYxDYeg6b302oVDGy6AqPV9Z1StDDIB/kjdFaujjS9eu9EFd0hKxj5AYVgmA
 iAVuNvJ0sRS45N+YK1lVihToNnlNiFIe+WiOiVxkyZgkG4+MO91I8dDaOepoephIgeBm
 0tf2em+Z3JSP91Y1wj4GhtwpPvrRzUF+xvsYHfN+eZjhRx6z+CgAIDHQ3keZ/Rh6ByqW
 zFTc9W1hFW9W0l3DWv0WldkugrkUbEbTdZ5dOnlg7S6tQbdvgsjgUbUyIer5N+jAWWYB
 2rAJO7w01JQ2aZlaEL9q/m7sk/DDZzWFow+xlQthBJq4yWSV3vw6rS5unjQHRnHBG7L5 uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39aup3q0am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 13:05:54 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15LH4eRJ156570;
        Mon, 21 Jun 2021 13:05:54 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39aup3q0a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 13:05:53 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 15LH4i2o021544;
        Mon, 21 Jun 2021 17:05:52 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3998789101-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 17:05:52 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 15LH5n3M21823890
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Jun 2021 17:05:49 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 427ED52069;
        Mon, 21 Jun 2021 17:05:49 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.79.141])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 36A7652078;
        Mon, 21 Jun 2021 17:05:48 +0000 (GMT)
Subject: Re: [PATCH] virtio/s390: get rid of open-coded kvm hypercall
To:     Heiko Carstens <hca@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210621144522.1304273-1-hca@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <410630b4-589d-cc35-a31f-9af9de93ec01@de.ibm.com>
Date:   Mon, 21 Jun 2021 19:05:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210621144522.1304273-1-hca@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: S3IGO6cOwp8wKAPKlQDUu6vL0C3gJz1r
X-Proofpoint-GUID: iuB3PKU47DaHWagxWNx8VS6OIZe02hM7
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-21_06:2021-06-21,2021-06-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 clxscore=1015 spamscore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106210097
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.06.21 16:45, Heiko Carstens wrote:
> do_kvm_notify() and __do_kvm_notify() are an (exact) open-coded variant
> of kvm_hypercall3(). Therefore simply make use of kvm_hypercall3(),
> and get rid of duplicated code.
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>   drivers/s390/virtio/virtio_ccw.c | 30 ++++--------------------------
>   1 file changed, 4 insertions(+), 26 deletions(-)

Certainly a nice improvement in terms of LOCs.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

  
> diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
> index 54e686dca6de..d35e7a3f7067 100644
> --- a/drivers/s390/virtio/virtio_ccw.c
> +++ b/drivers/s390/virtio/virtio_ccw.c
> @@ -388,31 +388,6 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
>   	ccw_device_dma_free(vcdev->cdev, thinint_area, sizeof(*thinint_area));
>   }
>   
> -static inline long __do_kvm_notify(struct subchannel_id schid,
> -				   unsigned long queue_index,
> -				   long cookie)
> -{
> -	register unsigned long __nr asm("1") = KVM_S390_VIRTIO_CCW_NOTIFY;
> -	register struct subchannel_id __schid asm("2") = schid;
> -	register unsigned long __index asm("3") = queue_index;
> -	register long __rc asm("2");
> -	register long __cookie asm("4") = cookie;
> -
> -	asm volatile ("diag 2,4,0x500\n"
> -		      : "=d" (__rc) : "d" (__nr), "d" (__schid), "d" (__index),
> -		      "d"(__cookie)
> -		      : "memory", "cc");
> -	return __rc;
> -}
> -
> -static inline long do_kvm_notify(struct subchannel_id schid,
> -				 unsigned long queue_index,
> -				 long cookie)
> -{
> -	diag_stat_inc(DIAG_STAT_X500);
> -	return __do_kvm_notify(schid, queue_index, cookie);
> -}
> -
>   static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
>   {
>   	struct virtio_ccw_vq_info *info = vq->priv;
> @@ -421,7 +396,10 @@ static bool virtio_ccw_kvm_notify(struct virtqueue *vq)
>   
>   	vcdev = to_vc_device(info->vq->vdev);
>   	ccw_device_get_schid(vcdev->cdev, &schid);
> -	info->cookie = do_kvm_notify(schid, vq->index, info->cookie);
> +	BUILD_BUG_ON(sizeof(struct subchannel_id) != sizeof(unsigned int));
> +	info->cookie = kvm_hypercall3(KVM_S390_VIRTIO_CCW_NOTIFY,
> +				      *((unsigned int *)&schid),
> +				      vq->index, info->cookie);
   	if (info->cookie < 0)
>   		return false;
>   	return true;
> 
