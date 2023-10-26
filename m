Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429B77D8474
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 16:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345180AbjJZOU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 10:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbjJZOU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 10:20:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D481B1;
        Thu, 26 Oct 2023 07:20:54 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QEFaqE017693;
        Thu, 26 Oct 2023 14:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0IjMWkowhLLUbyvviUP9QIhTC8ofFln9OXEuj3q/iWo=;
 b=hcO2tjb88UdgwuRrsaFhwp7u8Pzq4zp4yia3W152T6hZoSqI1lNVPxMHmeboNLudRL28
 lfSUNm4k2D2+5yjbpf3J3aA7B9w1vIPeAYusNLGzDjkhbnwhoDL8G5WPy+NE0I1aIz+T
 XANr6qSpSTQR2Pdq+iWNNmzboAtRgIMg/iP28gHti7a199aa/sSKKpGZ2UPefwk1ELej
 XWBLKFxnr8z/fnwZV/CD2y2LIY618pgvNe52Pq9kWQrkQk/N5udBCxHmn1wb3RqWd6vO
 KK/B9IsRqIdp0/j6PrZyffPFeHMvfdGQ6NXovminZXrSCKpU3Uu/mcQXbCGK3DbsWorq /g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tysqa05s3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 14:20:53 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39QEH8Vc024380;
        Thu, 26 Oct 2023 14:20:52 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tysqa05rs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 14:20:52 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39QEJWNu010305;
        Thu, 26 Oct 2023 14:20:52 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
        by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tvsbyxtxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 26 Oct 2023 14:20:52 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
        by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39QEKpaH17826364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 14:20:51 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 217E558052;
        Thu, 26 Oct 2023 14:20:51 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59EDE58056;
        Thu, 26 Oct 2023 14:20:50 +0000 (GMT)
Received: from [9.61.161.121] (unknown [9.61.161.121])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 26 Oct 2023 14:20:50 +0000 (GMT)
Message-ID: <1e7a9e4a-6d4a-4328-9fe8-0826e6348729@linux.ibm.com>
Date:   Thu, 26 Oct 2023 10:20:49 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] s390/vfio-ap: unpin pages on gisc registration
 failure
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Matthew Rosato <mjrosato@linux.ibm.com>, stable@vger.kernel.org
References: <20231018133829.147226-1-akrowiak@linux.ibm.com>
 <20231018133829.147226-2-akrowiak@linux.ibm.com>
 <c6951c45-b091-11a6-5684-ba2ef0c94df3@linux.ibm.com>
 <7ccf21c4-511c-4de6-bc02-4a936b020a10@linux.ibm.com>
 <ad89deb2-0028-46e4-ccc2-259308f01660@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <ad89deb2-0028-46e4-ccc2-259308f01660@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nkrKO0qceOIs0zPHnVzHu9LSjIF9-t7P
X-Proofpoint-ORIG-GUID: VBV1Kccn6PKVJs_QiW50wV7SoLnEaI69
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_12,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310170001 definitions=main-2310260123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/26/23 09:25, Christian Borntraeger wrote:
> 
> 
> Am 26.10.23 um 15:16 schrieb Tony Krowiak:
>>
>>
>> On 10/26/23 08:18, Christian Borntraeger wrote:
>>>
>>>
>>> Am 18.10.23 um 15:38 schrieb Tony Krowiak:
>>>> From: Anthony Krowiak <akrowiak@linux.ibm.com>
>>>>
>>>> In the vfio_ap_irq_enable function, after the page containing the
>>>> notification indicator byte (NIB) is pinned, the function attempts
>>>> to register the guest ISC. If registration fails, the function sets the
>>>> status response code and returns without unpinning the page containing
>>>> the NIB. In order to avoid a memory leak, the NIB should be unpinned 
>>>> before
>>>> returning from the vfio_ap_irq_enable function.
>>>>
>>>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>>>
>>> Where is Janoschs signed off coming from here?
>>
>> Janosch found this and composed the patch originally. I just tweaked 
>> the description and posted it.
> 
> So we should add
> 
> Co-developed-by: Janosch Frank <frankja@linux.ibm.com>
> 
> in front of Janoschs signoff.

Will do.

> 
>>
>>>
>>>> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
>>>> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>>> Fixes: 783f0a3ccd79 ("s390/vfio-ap: add s390dbf logging to the 
>>>> vfio_ap_irq_enable function")
>>>> Cc: <stable@vger.kernel.org>
>>>> ---
>>>>   drivers/s390/crypto/vfio_ap_ops.c | 1 +
>>>>   1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>>>> b/drivers/s390/crypto/vfio_ap_ops.c
>>>> index 4db538a55192..9cb28978c186 100644
>>>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>>>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>>>> @@ -457,6 +457,7 @@ static struct ap_queue_status 
>>>> vfio_ap_irq_enable(struct vfio_ap_queue *q,
>>>>           VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, 
>>>> isc=%d, apqn=%#04x\n",
>>>>                    __func__, nisc, isc, q->apqn);
>>>> +        vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
>>>>           status.response_code = AP_RESPONSE_INVALID_GISA;
>>>>           return status;
>>>>       }
