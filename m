Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3DAA652269
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbiLTOYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbiLTOYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:24:18 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9ECE0C3;
        Tue, 20 Dec 2022 06:24:16 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKEC8YU000379;
        Tue, 20 Dec 2022 14:24:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=un03Q7iQQiv/FgNM5WjQuY76pQRoHW1nA+pi2yFCpls=;
 b=Dz5zwW+OYpqVOAzDDMTQxzrob0GqCgcT0ssl8ZBAUwGLiVlrpKmu+Z0AdNc7PjAA1YzI
 jz7N5gWKQKW6KTLpXJzUYxrFzSaXc50m21R7P7wcC2NZf8ShUQLnxAIJr1Gkr22JAI0b
 jpxq2V0hCjAe4u5uARY3Yop4imCkBdK6/2Hc9jiYmo/tUxavs0LWFOD0fU88d39IhX3C
 vUFB2EeqzmreJN2seUpiZuGKYRKwzHwI5EidAd1iM4IRvpNcnm7Xez/JgapzidfNBJ3/
 7CnkEI8FgjoAxMuJ0PqjbtePf9LKykiGVBV3J203ZSqOTaOaMTZKkFwi7t4MDpEi7Irb vQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkekp8frf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:24:13 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKECAfm000666;
        Tue, 20 Dec 2022 14:24:13 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkekp8fqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:24:12 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKCrVqY026638;
        Tue, 20 Dec 2022 14:24:11 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([9.208.129.114])
        by ppma04dal.us.ibm.com (PPS) with ESMTPS id 3mh6yvsxhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:24:11 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKEO9wZ29295292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 14:24:10 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0D9D58059;
        Tue, 20 Dec 2022 14:24:09 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B52B958055;
        Tue, 20 Dec 2022 14:24:08 +0000 (GMT)
Received: from [9.160.121.75] (unknown [9.160.121.75])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 14:24:08 +0000 (GMT)
Message-ID: <ba3a2ca1-676d-da53-1168-c22d9dc2e3c5@linux.ibm.com>
Date:   Tue, 20 Dec 2022 09:24:08 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 4/7] s390/vfio_ap: verify ZAPQ completion after return of
 response code zero
Content-Language: en-US
To:     freude@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-5-akrowiak@linux.ibm.com>
 <e16b6e4e4774976eb2f3efb7adaef6a5@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <e16b6e4e4774976eb2f3efb7adaef6a5@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SLbnJ2AbSTApfvTdrlb9CuTVyS0iq1Aw
X-Proofpoint-GUID: G1NReOZs8vPU1AP2SD4onQwXI1meqMZz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_05,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200116
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/15/22 5:54 AM, Harald Freudenberger wrote:
> On 2022-12-13 16:44, Tony Krowiak wrote:
>> Verification that the asynchronous ZAPQ function has completed only 
>> needs
>> to be done when the response code indicates the function was 
>> successfully
>> initiated; so, let's call the apq_reset_check function immediately after
>> the response code zero is returned from the ZAPQ.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>  drivers/s390/crypto/vfio_ap_ops.c | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 5bf2d93ae8af..c0cf5050be59 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1645,6 +1645,9 @@ static int vfio_ap_mdev_reset_queue(struct
>> vfio_ap_queue *q)
>>      switch (status.response_code) {
>>      case AP_RESPONSE_NORMAL:
>>          ret = 0;
>> +        /* if the reset has not completed, wait for it to take 
>> effect */
>> +        if (!status.queue_empty || status.irq_enabled)
>> +            ret = apq_reset_check(q);
>>          break;
>>      case AP_RESPONSE_RESET_IN_PROGRESS:
>>          /*
>> @@ -1674,10 +1677,6 @@ static int vfio_ap_mdev_reset_queue(struct
>> vfio_ap_queue *q)
>>          return -EIO;
>>      }
>>
>> -    /* wait for the reset to take effect */
>> -    if (!status.queue_empty && status.irq_enabled)
>> -        ret = apq_reset_check(q);
>> -
>>  free_resources:
>>      vfio_ap_free_aqic_resources(q);
>
> Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>


Thanks for the review.


