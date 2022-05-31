Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C462538F30
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 12:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343543AbiEaKoy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 06:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233804AbiEaKow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 06:44:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90E18DDED;
        Tue, 31 May 2022 03:44:51 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24VASouu007641;
        Tue, 31 May 2022 10:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0jJlzKzm/DxDvXINYNTGWbXmbG9ORhCTY/VSBeTfRMs=;
 b=gj5NIORWcil2TaNGaofRhfsU4tCbhqSm3oYJCsgAsdAMn9ptMSxyLekrZFlgZAXgXDr/
 RDgfFPg/c7e9ohHm68zaSl1Js78sR16HUvhtKIBSVgS9q4AhdXCj3fQ7mGZ4CQ4En0su
 LSqADtEGdZPOowbAZzGDUjkBYsmlrT0KZF/X87MRCykV4RLTReGJJrOFj3Qb7nELPyMS
 zM128m/mTH9avGy91ihVCNe3f798rsh7+AV752CrEfm80Zok3wf4K9EHCV0NSK87j6vY
 7LQFgijWtAirdgnDb2q5VWnzTrOx+T60ozzBjC9Kkg/33yhORrp97cmsWsxp16nobwW0 Rw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdeedv0ax-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 10:44:49 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24V9bC1x006276;
        Tue, 31 May 2022 10:44:49 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gdeedv0am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 10:44:49 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24VAZiMj026283;
        Tue, 31 May 2022 10:44:48 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma01dal.us.ibm.com with ESMTP id 3gcxt57cjs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 31 May 2022 10:44:48 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24VAilZ026673446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 May 2022 10:44:47 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A575AC062;
        Tue, 31 May 2022 10:44:47 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70BA8AC065;
        Tue, 31 May 2022 10:44:46 +0000 (GMT)
Received: from [9.160.37.241] (unknown [9.160.37.241])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 31 May 2022 10:44:46 +0000 (GMT)
Message-ID: <f838f274-ff4d-496d-2393-14423117ff7e@linux.ibm.com>
Date:   Tue, 31 May 2022 06:44:46 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v19 11/20] s390/vfio-ap: prepare for dynamic update of
 guest's APCB on queue probe/remove
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220404221039.1272245-1-akrowiak@linux.ibm.com>
 <20220404221039.1272245-12-akrowiak@linux.ibm.com>
 <9364a1b7-9060-20aa-b0d6-88c41a30e7d4@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <9364a1b7-9060-20aa-b0d6-88c41a30e7d4@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cVNAkKZarVS-7jTW77s3SoJLqpV2_3Ev
X-Proofpoint-ORIG-GUID: xMKK5ck2dwLiHNrfC5uBN9An8Ouf6PIr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-05-31_03,2022-05-30_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 impostorscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0
 spamscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205310054
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/27/22 9:36 AM, Jason J. Herne wrote:
> On 4/4/22 18:10, Tony Krowiak wrote:
>> The callback functions for probing and removing a queue device must take
>> and release the locks required to perform a dynamic update of a guest's
>> APCB in the proper order.
>>
>> The proper order for taking the locks is:
>>
>>          matrix_dev->guests_lock => kvm->lock => matrix_dev->mdevs_lock
>>
>> The proper order for releasing the locks is:
>>
>>          matrix_dev->mdevs_lock => kvm->lock => matrix_dev->guests_lock
>>
>> A new helper function is introduced to be used by the probe callback to
>> acquire the required locks. Since the probe callback only has
>> access to a queue device when it is called, the helper function will 
>> find
>> the ap_matrix_mdev object to which the queue device's APQN is 
>> assigned and
>> return it so the KVM guest to which the mdev is attached can be 
>> dynamically
>> updated.
>>
>> Note that in order to find the ap_matrix_mdev (matrix_mdev) object, 
>> it is
>> necessary to search the matrix_dev->mdev_list. This presents a
>> locking order dilemma because the matrix_dev->mdevs_lock can't be 
>> taken to
>> protect against changes to the list while searching for the 
>> matrix_mdev to
>> which a queue device's APQN is assigned. This is due to the fact that 
>> the
>> proper locking order requires that the matrix_dev->mdevs_lock be taken
>> after both the matrix_mdev->kvm->lock and the matrix_dev->mdevs_lock.
>> Consequently, the matrix_dev->guests_lock will be used to protect 
>> against
>> removal of a matrix_mdev object from the list while a queue device is
>> being probed. This necessitates changes to the mdev probe/remove
>> callback functions to take the matrix_dev->guests_lock prior to removing
>> a matrix_mdev object from the list.
>>
>> A new macro is also introduced to acquire the locks required to 
>> dynamically
>> update the guest's APCB in the proper order when a queue device is
>> removed.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 126 +++++++++++++++++++++---------
>>   1 file changed, 88 insertions(+), 38 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 2219b1069ceb..080a733f7cd2 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -116,6 +116,74 @@ static const struct vfio_device_ops 
>> vfio_ap_matrix_dev_ops;
>>       mutex_unlock(&matrix_dev->guests_lock);        \
>>   })
>>   +/**
>> + * vfio_ap_mdev_get_update_locks_for_apqn: retrieve the matrix mdev 
>> to which an
>> + *                       APQN is assigned and acquire the
>> + *                       locks required to update the APCB of
>> + *                       the KVM guest to which the mdev is
>> + *                       attached.
>> + *
>> + * @apqn: the APQN of a queue device.
>> + *
>> + * The proper locking order is:
>> + * 1. matrix_dev->guests_lock: required to use the KVM pointer to 
>> update a KVM
>> + *                   guest's APCB.
>> + * 2. matrix_mdev->kvm->lock:  required to update a guest's APCB
>> + * 3. matrix_dev->mdevs_lock:  required to access data stored in a 
>> matrix_mdev
>> + *
>> + * Note: If @apqn is not assigned to a matrix_mdev, the 
>> matrix_mdev->kvm->lock
>> + *     will not be taken.
>> + *
>> + * Return: the ap_matrix_mdev object to which @apqn is assigned or 
>> NULL if @apqn
>> + *       is not assigned to an ap_matrix_mdev.
>> + */
>> +static struct ap_matrix_mdev 
>> *vfio_ap_mdev_get_update_locks_for_apqn(int apqn)
>
> vfio_ap_mdev_get_update_locks_for_apqn is "crazy long".
> How about:
>   get_mdev_for_apqn()
>
> This function is static and the terms mdev and apqn are specific 
> enough that I
> don't think it needs to start with vfio_ap. And there is no need to 
> state in
> the function name that locks are acquired. That point will be obvious 
> to anyone
> reading the prologue or the code.

The primary purpose of the function is to acquire the locks in the 
proper order, so
I think the name should state that purpose. It may be obvious to someone 
reading
the prologue or this function, but not so obvious in the context of the 
calling function.
Having said that, I will shorten the name to:

     get_update_locks_for_apqn



>
> Aside from that, Reviewed-by: Jason J. Herne <jjherne@linux.ibm.com>
>

