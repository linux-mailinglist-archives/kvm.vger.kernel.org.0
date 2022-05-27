Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CC6536341
	for <lists+kvm@lfdr.de>; Fri, 27 May 2022 15:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351881AbiE0NTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 May 2022 09:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351813AbiE0NTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 May 2022 09:19:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6024212E302;
        Fri, 27 May 2022 06:19:01 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24RCOxSZ008191;
        Fri, 27 May 2022 13:18:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : reply-to : subject : to : cc : references : from :
 in-reply-to : content-type : content-transfer-encoding; s=pp1;
 bh=f23C3xxBBfsLaAopGI9TJZOFDsNE3/fH4UusDvpSzzs=;
 b=lwQeF+y1C5OywdUER8mFiyJXmXt0N1auPd0VjQyrBXRuyP9uDLX2Ec2SdWjsn8bQBpf4
 9xBf3gUK6rowzENwK5Vozuz7sEHvxh6wDZCzIWFn0zyb3GWEksOzqeJIRTp6eU8d5+02
 JIwYqpDDv0whcF2ykC/TV7KNt8WUaWoz5tRpNwwc4K5FGUm9Dh3rmcTAPd6V6cV6lps1
 OlvvDqVoyLzuXgyS7PjZYJLqWIB6lriqIeQsvJG5K95w9V+VvAI58i9q6yIVK3wJRTT1
 poS3PanZYuH4ovmXr6T9bSGHF85TnGCkn3f0h7VNbsZTPx98a+PIqJVjmbz94CgOeuxv lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gaxm9s4gp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 13:18:59 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24RCww5K022631;
        Fri, 27 May 2022 13:18:58 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gaxm9s4ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 13:18:58 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24RDIPeE028572;
        Fri, 27 May 2022 13:18:57 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma04dal.us.ibm.com with ESMTP id 3g93uugwdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 27 May 2022 13:18:57 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24RDIuGO27066646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 May 2022 13:18:56 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A455028066;
        Fri, 27 May 2022 13:18:56 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4EEE32805C;
        Fri, 27 May 2022 13:18:56 +0000 (GMT)
Received: from [9.60.75.219] (unknown [9.60.75.219])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 27 May 2022 13:18:56 +0000 (GMT)
Message-ID: <67f17a73-28e2-d458-a052-2782e16fe96d@linux.ibm.com>
Date:   Fri, 27 May 2022 09:18:56 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: jjherne@linux.ibm.com
Subject: Re: [PATCH v19 10/20] s390/vfio-ap: prepare for dynamic update of
 guest's APCB on assign/unassign
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-11-akrowiak@linux.ibm.com>
From:   "Jason J. Herne" <jjherne@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220404221039.1272245-11-akrowiak@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: genKKtD4RdXLDKXaqDDuq7ISobzM4MVG
X-Proofpoint-ORIG-GUID: l5PCuPKg7uSX2EpDaUQlvYLJCf2QgPBQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-27_03,2022-05-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 spamscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205270063
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
> The functions backing the matrix mdev's sysfs attribute interfaces to
> assign/unassign adapters, domains and control domains must take and
> release the locks required to perform a dynamic update of a guest's APCB
> in the proper order.
> 
> The proper order for taking the locks is:
> 
> matrix_dev->guests_lock => kvm->lock => matrix_dev->mdevs_lock
> 
> The proper order for releasing the locks is:
> 
> matrix_dev->mdevs_lock => kvm->lock => matrix_dev->guests_lock
> 
> Two new macros are introduced for this purpose: One to take the locks and
> the other to release the locks. These macros will be used by the
> assignment/unassignment functions to prepare for dynamic update of
> the KVM guest's APCB.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
>   drivers/s390/crypto/vfio_ap_ops.c | 69 +++++++++++++++++++++++++------
>   1 file changed, 57 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 757bbf449b04..2219b1069ceb 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -71,6 +71,51 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
>   	mutex_unlock(&matrix_dev->guests_lock);	\
>   })
>   
> +/**
> + * get_update_locks_for_mdev: Acquire the locks required to dynamically update a
> + *			      KVM guest's APCB in the proper order.
> + *
> + * @matrix_mdev: a pointer to a struct ap_matrix_mdev object containing the AP
> + *		 configuration data to use to update a KVM guest's APCB.
> + *
> + * The proper locking order is:
> + * 1. matrix_dev->guests_lock: required to use the KVM pointer to update a KVM
> + *			       guest's APCB.
> + * 2. matrix_mdev->kvm->lock:  required to update a guest's APCB
> + * 3. matrix_dev->mdevs_lock:  required to access data stored in a matrix_mdev
> + *
> + * Note: If @matrix_mdev is NULL or is not attached to a KVM guest, the KVM
> + *	 lock will not be taken.
> + */

Perhaps the locking order should be documented once at the top of all of the locking
functions instead of in each comment. The current method seems needlessly verbose.

> +#define get_update_locks_for_mdev(matrix_mdev) ({	\
> +	mutex_lock(&matrix_dev->guests_lock);		\
> +	if (matrix_mdev && matrix_mdev->kvm)		\
> +		mutex_lock(&matrix_mdev->kvm->lock);	\
> +	mutex_lock(&matrix_dev->mdevs_lock);		\
> +})

It does not make sense to reference matrix_dev on the first line of this macro and
then check it for a null value on the next line. If it can be null then the check
needs to come before the usage. If it cannot be null, then we can remove the check.
Same comment for the release macro.

> +/**
> + * release_update_locks_for_mdev: Release the locks used to dynamically update a
> + *				  KVM guest's APCB in the proper order.
> + *
> + * @matrix_mdev: a pointer to a struct ap_matrix_mdev object containing the AP
> + *		 configuration data to use to update a KVM guest's APCB.
> + *
> + * The proper unlocking order is:
> + * 1. matrix_dev->mdevs_lock
> + * 2. matrix_mdev->kvm->lock
> + * 3. matrix_dev->guests_lock
> + *
> + * Note: If @matrix_mdev is NULL or is not attached to a KVM guest, the KVM
> + *	 lock will not be released.
> + */
> +#define release_update_locks_for_mdev(matrix_mdev) ({	\
> +	mutex_unlock(&matrix_dev->mdevs_lock);		\
> +	if (matrix_mdev && matrix_mdev->kvm)		\
> +		mutex_unlock(&matrix_mdev->kvm->lock);		\
> +	mutex_unlock(&matrix_dev->guests_lock);		\
> +})
> +
-- 
-- Jason J. Herne (jjherne@linux.ibm.com)
