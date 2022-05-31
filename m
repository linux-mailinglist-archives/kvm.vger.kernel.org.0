Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5147538F15
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 12:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244389AbiEaKcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 06:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbiEaKcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 06:32:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52827939DC;
        Tue, 31 May 2022 03:32:17 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24V83rCr010010;
        Tue, 31 May 2022 10:32:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Y6q79ERAMUaIpl0cMYd5kSnQ2wdZ0Y+PfO+20S65H48=;
 b=HRqi5qBF7bRLOeE8wrs+coTUIfJkWBRF/t4b9RxxZti3Z6Xuvvf2E8qGFfvY9W0P1uJS
 QbhdVGBMuLJTzf/spXDMV40QP+M26aevW91RLkbkyBUZv9dsBRFkg0qpyPN3bmoaoybg
 zVz5NNb3ADLrKqNmJKNPKPko/nuQueDqqd1/ViuXqpkhX1lGtwnh6ZErn1gd+ZPg1/L4
 /wFb6knSBBdKeQDmvm850R68x2Ybqo7SLQnmHF7ZowGm1VeXpI7YW/OO3A7fNKVC8VI+
 ruSW8Q7YK/+j44F7R537MSxe1vF9QzRdDvjaG0qeZRE1/eencstwVby9hg1Wh2jrBzGa Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gd95krrc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 10:32:15 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24VAQGl4031983;
        Tue, 31 May 2022 10:32:14 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gd95krrc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 10:32:14 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24VAJlcX019014;
        Tue, 31 May 2022 10:32:14 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma03wdc.us.ibm.com with ESMTP id 3gbc9vbctx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 10:32:14 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24VAWDqE27853092
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 10:32:13 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45242AC059;
        Tue, 31 May 2022 10:32:13 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6C4AAC060;
        Tue, 31 May 2022 10:32:12 +0000 (GMT)
Received: from [9.160.37.241] (unknown [9.160.37.241])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 31 May 2022 10:32:12 +0000 (GMT)
Message-ID: <94c8947f-4186-e399-a79f-6f94e91ed8b9@linux.ibm.com>
Date:   Tue, 31 May 2022 06:32:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v19 10/20] s390/vfio-ap: prepare for dynamic update of
 guest's APCB on assign/unassign
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-11-akrowiak@linux.ibm.com>
 <67f17a73-28e2-d458-a052-2782e16fe96d@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <67f17a73-28e2-d458-a052-2782e16fe96d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Xm_4Jh3m-fOdP9d4n_ntP69PtqDpAiNq
X-Proofpoint-ORIG-GUID: 7L5msjg_n1UU24_CNKU4PS-uh8wr2QK8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-05-31_03,2022-05-30_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310052
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/27/22 9:18 AM, Jason J. Herne wrote:
> On 4/4/22 18:10, Tony Krowiak wrote:
>> The functions backing the matrix mdev's sysfs attribute interfaces to
>> assign/unassign adapters, domains and control domains must take and
>> release the locks required to perform a dynamic update of a guest's APCB
>> in the proper order.
>>
>> The proper order for taking the locks is:
>>
>> matrix_dev->guests_lock => kvm->lock => matrix_dev->mdevs_lock
>>
>> The proper order for releasing the locks is:
>>
>> matrix_dev->mdevs_lock => kvm->lock => matrix_dev->guests_lock
>>
>> Two new macros are introduced for this purpose: One to take the locks 
>> and
>> the other to release the locks. These macros will be used by the
>> assignment/unassignment functions to prepare for dynamic update of
>> the KVM guest's APCB.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 69 +++++++++++++++++++++++++------
>>   1 file changed, 57 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 757bbf449b04..2219b1069ceb 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -71,6 +71,51 @@ static const struct vfio_device_ops 
>> vfio_ap_matrix_dev_ops;
>>       mutex_unlock(&matrix_dev->guests_lock);    \
>>   })
>>   +/**
>> + * get_update_locks_for_mdev: Acquire the locks required to 
>> dynamically update a
>> + *                  KVM guest's APCB in the proper order.
>> + *
>> + * @matrix_mdev: a pointer to a struct ap_matrix_mdev object 
>> containing the AP
>> + *         configuration data to use to update a KVM guest's APCB.
>> + *
>> + * The proper locking order is:
>> + * 1. matrix_dev->guests_lock: required to use the KVM pointer to 
>> update a KVM
>> + *                   guest's APCB.
>> + * 2. matrix_mdev->kvm->lock:  required to update a guest's APCB
>> + * 3. matrix_dev->mdevs_lock:  required to access data stored in a 
>> matrix_mdev
>> + *
>> + * Note: If @matrix_mdev is NULL or is not attached to a KVM guest, 
>> the KVM
>> + *     lock will not be taken.
>> + */
>
> Perhaps the locking order should be documented once at the top of all 
> of the locking
> functions instead of in each comment. The current method seems 
> needlessly verbose.

Perhaps, but I surmise this comment was motivated by the fact you are 
reviewing the
locking macros/functions en masse. On the other hand, someone debugging 
the code
may miss the locking order comments if their debug thread leads them to 
a locking
macro/function that does not have said comments. I think the value of 
leaving the
comments in place outweighs the value of limiting them as you suggested.

>
>> +#define get_update_locks_for_mdev(matrix_mdev) ({    \
>> +    mutex_lock(&matrix_dev->guests_lock);        \
>> +    if (matrix_mdev && matrix_mdev->kvm)        \
>> +        mutex_lock(&matrix_mdev->kvm->lock);    \
>> +    mutex_lock(&matrix_dev->mdevs_lock);        \
>> +})
>
> It does not make sense to reference matrix_dev on the first line of 
> this macro and
> then check it for a null value on the next line. If it can be null 
> then the check
> needs to come before the usage. If it cannot be null, then we can 
> remove the check.
> Same comment for the release macro.

You must have misread the code. The second line checks the value of 
matrix_mdev
for NULL, not matrix_dev. There are definitely cases where matrix_mdev 
can be
passed as NULL.

>
>> +/**
>> + * release_update_locks_for_mdev: Release the locks used to 
>> dynamically update a
>> + *                  KVM guest's APCB in the proper order.
>> + *
>> + * @matrix_mdev: a pointer to a struct ap_matrix_mdev object 
>> containing the AP
>> + *         configuration data to use to update a KVM guest's APCB.
>> + *
>> + * The proper unlocking order is:
>> + * 1. matrix_dev->mdevs_lock
>> + * 2. matrix_mdev->kvm->lock
>> + * 3. matrix_dev->guests_lock
>> + *
>> + * Note: If @matrix_mdev is NULL or is not attached to a KVM guest, 
>> the KVM
>> + *     lock will not be released.
>> + */
>> +#define release_update_locks_for_mdev(matrix_mdev) ({    \
>> +    mutex_unlock(&matrix_dev->mdevs_lock);        \
>> +    if (matrix_mdev && matrix_mdev->kvm)        \
>> +        mutex_unlock(&matrix_mdev->kvm->lock); \
>> +    mutex_unlock(&matrix_dev->guests_lock);        \
>> +})
>> +

