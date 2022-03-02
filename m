Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 281354CB2DD
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 00:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiCBXps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 18:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiCBXpr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 18:45:47 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8A73E5C5;
        Wed,  2 Mar 2022 15:43:33 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222Mnb7N008466;
        Wed, 2 Mar 2022 23:43:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=i5BWb3tqsZ4eoh82ODgmPwJgY+o4LlIyFrdu6rEg8Ak=;
 b=pJtwsLeTgC1Ub+ayC8j8aUk3FRTc3evGdqJgL6RzT6j8vs5Gk7vvIFTpli27VUngJ23w
 eZ5Qg/Z8wY5bRs0zhXtJ7PB8k3dSaByBOe6VYH/aMIWSyIZ4mzhljrZggZdiGnD08ksZ
 SHkJJXclmN4W9woqvwtNK4E0P+Ddpoe4PmysCr5475b+ziDDt/QiPP9SEHrQas7YqJk9
 AoK0lRQdVGPpgDHLzj+MWLB3uFIyoqWYjirNTi8pAdADBoNe8AzQjMmPNtsWfzQI0FDQ
 v5haQDeFLs8gv0fKVJqSr2lBaMQEEdpR885+NPUrEjHlDHJu6blQfvZtBHo+b+XRRaQv Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejc03g1pr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 23:43:08 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222NWN4R024561;
        Wed, 2 Mar 2022 23:43:08 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ejc03g1ph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 23:43:08 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222Nb81Y025228;
        Wed, 2 Mar 2022 23:43:06 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma05wdc.us.ibm.com with ESMTP id 3ej75rmnmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 23:43:06 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222Nh5tf34603432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 23:43:05 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85205AE066;
        Wed,  2 Mar 2022 23:43:05 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3AD3DAE05F;
        Wed,  2 Mar 2022 23:43:04 +0000 (GMT)
Received: from [9.160.116.147] (unknown [9.160.116.147])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Mar 2022 23:43:04 +0000 (GMT)
Message-ID: <11ab9dfa-494b-5103-5f26-aa6c29567f52@linux.ibm.com>
Date:   Wed, 2 Mar 2022 18:43:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v18 07/18] s390/vfio-ap: refresh guest's APCB by filtering
 APQNs assigned to mdev
Content-Language: en-US
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-8-akrowiak@linux.ibm.com>
 <2b1f788b-5197-f5e8-52cf-58995d758ef7@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <2b1f788b-5197-f5e8-52cf-58995d758ef7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qwP7h1CS1yQLyuuEgo_Weg01A1yRzyDt
X-Proofpoint-ORIG-GUID: zPYtVih04kZnTT8H_SA9_2e3W9lyBqk4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 impostorscore=0 spamscore=0 clxscore=1011 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/2/22 14:35, Jason J. Herne wrote:
> On 2/14/22 19:50, Tony Krowiak wrote:
>> Refresh the guest's APCB by filtering the APQNs assigned to the 
>> matrix mdev
>> that do not reference an AP queue device bound to the vfio_ap device
>> driver. The mdev's APQNs will be filtered according to the following 
>> rules:
>>
>> * The APID of each adapter and the APQI of each domain that is not in 
>> the
>> host's AP configuration is filtered out.
>>
>> * The APID of each adapter comprising an APQN that does not reference a
>> queue device bound to the vfio_ap device driver is filtered. The APQNs
>> are derived from the Cartesian product of the APID of each adapter and
>> APQI of each domain assigned to the mdev.
>>
>> The control domains that are not assigned to the host's AP configuration
>> will also be filtered before assigning them to the guest's APCB.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 96 ++++++++++++++++++++++++++++++-
>>   1 file changed, 93 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 4b676a55f203..b67b2f0faeea 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -317,6 +317,63 @@ static void vfio_ap_matrix_init(struct 
>> ap_config_info *info,
>>       matrix->adm_max = info->apxa ? info->Nd : 15;
>>   }
>>   +static void vfio_ap_mdev_filter_cdoms(struct ap_matrix_mdev 
>> *matrix_mdev)
>> +{
>> +    bitmap_and(matrix_mdev->shadow_apcb.adm, matrix_mdev->matrix.adm,
>> +           (unsigned long *)matrix_dev->info.adm, AP_DOMAINS);
>> +}
>> +
>> +/*
>> + * vfio_ap_mdev_filter_matrix - copy the mdev's AP configuration to 
>> the KVM
>> + *                guest's APCB then filter the APIDs that do not
>> + *                comprise at least one APQN that references a
>> + *                queue device bound to the vfio_ap device driver.
>> + *
>> + * @matrix_mdev: the mdev whose AP configuration is to be filtered.
>> + */
>> +static void vfio_ap_mdev_filter_matrix(unsigned long *apm, unsigned 
>> long *aqm,
>> +                       struct ap_matrix_mdev *matrix_mdev)
>> +{
>> +    int ret;
>> +    unsigned long apid, apqi, apqn;
>> +
>> +    ret = ap_qci(&matrix_dev->info);
>> +    if (ret)
>> +        return;
>> +
>> +    vfio_ap_matrix_init(&matrix_dev->info, &matrix_mdev->shadow_apcb);
>
> Do you need to call vfio_ap_matrix_init here? It seems to me like this 
> would
> only be necesarry if apxa could be dynamically added or removed. Here 
> is a
> copy of vfio_ap_matrix_init, for reference:
>
> static void vfio_ap_matrix_init(struct ap_config_info *info,
>                 struct ap_matrix *matrix)
> {
>     matrix->apm_max = info->apxa ? info->Na : 63;
>     matrix->aqm_max = info->apxa ? info->Nd : 15;
>     matrix->adm_max = info->apxa ? info->Nd : 15;
> }
>
> It seems like this should be figured out once and stored when the
> ap_matrix_mdev struct is first created. Unless I'm wrong, and the 
> status of
> apxa can change dynamically, in which case the maximums would need to be
> updated somewhere.

It's an interesting question to which I don't have a definitive answer. 
I'll run it
by our architects. On the other hand, making this call here is not entirely
unreasonable and merely superfluous at worst, but I'll look into it.

Tony K

>
>

