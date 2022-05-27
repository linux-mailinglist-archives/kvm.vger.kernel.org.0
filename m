Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A50C5362E5
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 14:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353164AbiE0MoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 08:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353053AbiE0MoK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 08:44:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FE63E0D6;
        Fri, 27 May 2022 05:41:52 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24RCJcRR001889;
        Fri, 27 May 2022 12:41:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=bBiYtXJVgWLjjSCHZlPXNqDaa7wJjMzBr9HamsBxpCs=;
 b=oPpBe8gvA4PYngav51UQJNeg5yssMIqvBa6nf3l2ITL5cgaOI/axgrW0Y6hBPfazIWGe
 1QoN7JBqzKC/Yotw2OrC2eR3oNHlV/M28V0C7H4W0sgYFq1Bu7eYyHg3ORWxrLeCnBvr
 UrVkYCu262BLPdDQOtTPvo6Fak0pscMLD9Pa5NtqjIWnYTE4luFacX3Ofu4xpVyKBVQ7
 +TPzlv1jTBVi6X+3X0TM+LzpYandJ0dU+Qg/ndXO37uD0IfRuLkI5nYiZYQOd3g1sKry
 FOmvJRspWwUIwtOLDt+hfnisGkuQqu3pTCQJeghB/wMV18RLsJKvta7Fzs/NwqNl1x20 mw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gaxhqrdcn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 12:41:49 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24RCKHD3005041;
        Fri, 27 May 2022 12:41:49 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3gaxhqrdc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 12:41:49 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24RCcecH009011;
        Fri, 27 May 2022 12:41:48 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma03wdc.us.ibm.com with ESMTP id 3gabgmer0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 12:41:48 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24RCflKB27722208
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 May 2022 12:41:47 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12EDB7805E;
        Fri, 27 May 2022 12:41:47 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5113A7805C;
        Fri, 27 May 2022 12:41:46 +0000 (GMT)
Received: from [9.60.75.219] (unknown [9.60.75.219])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 27 May 2022 12:41:46 +0000 (GMT)
Message-ID: <d787a512-339e-671f-4e59-44d2b92b26ce@linux.ibm.com>
Date:   Fri, 27 May 2022 08:41:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v19 09/20] s390/vfio-ap: use proper locking order when
 setting/clearing KVM pointer
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-10-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220404221039.1272245-10-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: DzKGn0k8unqGc4d1rQNL6v2f01crMypZ
X-Proofpoint-ORIG-GUID: j-E_Lw0hXeO3ic4_RDPubSk8_eRs2qkk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-27_03,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2204290000 definitions=main-2205270059
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/22 18:10, Tony Krowiak wrote:
> The group notifier that handles the VFIO_GROUP_NOTIFY_SET_KVM event must
> use the required locks in proper locking order to dynamically update the
> guest's APCB. The proper locking order is:
> 
>         1. matrix_dev->guests_lock: required to use the KVM pointer to
>            update a KVM guest's APCB.
> 
>         2. matrix_mdev->kvm->lock: required to update a KVM guest's APCB.
> 
>         3. matrix_dev->mdevs_lock: required to store or access the data
>            stored in a struct ap_matrix_mdev instance.
> 
> Two macros are introduced to acquire and release the locks in the proper
> order. These macros are now used by the group notifier functions.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 56 +++++++++++++++++++++++++------
>   1 file changed, 46 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 077b8c9c831b..757bbf449b04 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -30,6 +30,47 @@ static int vfio_ap_mdev_reset_queues(struct ap_matrix_mdev *matrix_mdev);
>   static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>   static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
>   
> +/**
> + * get_update_locks_for_kvm: Acquire the locks required to dynamically update a
> + *			     KVM guest's APCB in the proper order.
> + *
> + * @kvm: a pointer to a struct kvm object containing the KVM guest's APCB.
> + *
> + * The proper locking order is:
> + * 1. matrix_dev->guests_lock: required to use the KVM pointer to update a KVM
> + *			       guest's APCB.
> + * 2. kvm->lock:	       required to update a guest's APCB
> + * 3. matrix_dev->mdevs_lock:  required to access data stored in a matrix_mdev
> + *
> + * Note: If @kvm is NULL, the KVM lock will not be taken.
> + */
> +#define get_update_locks_for_kvm(kvm) ({	\
> +	mutex_lock(&matrix_dev->guests_lock);	\
> +	if (kvm)				\
> +		mutex_lock(&kvm->lock);		\
> +	mutex_lock(&matrix_dev->mdevs_lock);	\
> +})
> +
> +/**
> + * release_update_locks_for_kvm: Release the locks used to dynamically update a
> + *				 KVM guest's APCB in the proper order.
> + *
> + * @kvm: a pointer to a struct kvm object containing the KVM guest's APCB.
> + *
> + * The proper unlocking order is:
> + * 1. matrix_dev->mdevs_lock
> + * 2. kvm->lock
> + * 3. matrix_dev->guests_lock
> + *
> + * Note: If @kvm is NULL, the KVM lock will not be released.
> + */
> +#define release_update_locks_for_kvm(kvm) ({	\
> +	mutex_unlock(&matrix_dev->mdevs_lock);	\
> +	if (kvm)				\
> +		mutex_unlock(&kvm->lock);		\
> +	mutex_unlock(&matrix_dev->guests_lock);	\
> +})
> +
>   /**
>    * vfio_ap_mdev_get_queue - retrieve a queue with a specific APQN from a
>    *			    hash table of queues assigned to a matrix mdev
> @@ -1263,13 +1304,11 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>   		kvm->arch.crypto.pqap_hook = &matrix_mdev->pqap_hook;
>   		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
>   
> -		mutex_lock(&kvm->lock);
> -		mutex_lock(&matrix_dev->mdevs_lock);
> +		get_update_locks_for_kvm(kvm);
>   
>   		list_for_each_entry(m, &matrix_dev->mdev_list, node) {
>   			if (m != matrix_mdev && m->kvm == kvm) {
> -				mutex_unlock(&kvm->lock);
> -				mutex_unlock(&matrix_dev->mdevs_lock);
> +				release_update_locks_for_kvm(kvm);
>   				return -EPERM;
>   			}
>   		}
> @@ -1280,8 +1319,7 @@ static int vfio_ap_mdev_set_kvm(struct ap_matrix_mdev *matrix_mdev,
>   					  matrix_mdev->shadow_apcb.aqm,
>   					  matrix_mdev->shadow_apcb.adm);
>   
> -		mutex_unlock(&kvm->lock);
> -		mutex_unlock(&matrix_dev->mdevs_lock);
> +		release_update_locks_for_kvm(kvm);
>   	}
>   
>   	return 0;
> @@ -1332,16 +1370,14 @@ static void vfio_ap_mdev_unset_kvm(struct ap_matrix_mdev *matrix_mdev)
>   		kvm->arch.crypto.pqap_hook = NULL;
>   		up_write(&kvm->arch.crypto.pqap_hook_rwsem);
>   
> -		mutex_lock(&kvm->lock);
> -		mutex_lock(&matrix_dev->mdevs_lock);
> +		get_update_locks_for_kvm(kvm);
>   
>   		kvm_arch_crypto_clear_masks(kvm);
>   		vfio_ap_mdev_reset_queues(matrix_mdev);
>   		kvm_put_kvm(kvm);
>   		matrix_mdev->kvm = NULL;
>   
> -		mutex_unlock(&kvm->lock);
> -		mutex_unlock(&matrix_dev->mdevs_lock);
> +		release_update_locks_for_kvm(kvm);
>   	}
>   }
>   

In isolation... Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>

-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
