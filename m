Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED74652273
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbiLTOZ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbiLTOZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:25:38 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB36518691;
        Tue, 20 Dec 2022 06:25:35 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKEE1Uw007594;
        Tue, 20 Dec 2022 14:25:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=EavyitgVQTNUbA93VMFdaC0EkgsG5tRK/VujADIf7SU=;
 b=TPzl5DNvZ5Ej/rM5LvOZJ3pRDhQK8nkOY1NlWv/Wx6OK5ReHlZ4InLlyNZ0+56OK+GT4
 fRvUKaPDLCMExHdsrr/In7gKDPkvk3Z/BotYW5ldE+qfOo2N/BXoyuCuDqUW46ngnyja
 5hocJUHikpP+fXsySJ8Saas4oOOMRhkAKuE3YJYXGkTf8yBiIj2KdMP86//VVrQkZxS3
 Y0Dvu+0Ek/jLENn57Z4ivq4hiKJJ/QCrcveyanFItR+0ObuQNSZt4dBvW8O1Z+lCAwBg
 nxfSkJIx7wGHIU2Se6hcvUoMxA0In3sLuUAs1u0pEmLajVgiZVai/6MOMr1TG1Y9a0w2 ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkempgb8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:25:33 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKEEBMr009377;
        Tue, 20 Dec 2022 14:25:33 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkempgb8b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:25:33 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKCOawW010167;
        Tue, 20 Dec 2022 14:25:32 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([9.208.129.116])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yuvswv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:25:32 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKEPUVM55378224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 14:25:31 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C98FF58063;
        Tue, 20 Dec 2022 14:25:30 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEFF65805D;
        Tue, 20 Dec 2022 14:25:29 +0000 (GMT)
Received: from [9.160.121.75] (unknown [9.160.121.75])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 14:25:29 +0000 (GMT)
Message-ID: <a6f174bf-08e2-835d-b609-4d1c160fe658@linux.ibm.com>
Date:   Tue, 20 Dec 2022 09:25:29 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 5/7] s390/vfio_ap: fix handling of error response codes
Content-Language: en-US
To:     freude@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-6-akrowiak@linux.ibm.com>
 <14c13db623907f41fae355c225db08b9@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <14c13db623907f41fae355c225db08b9@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Acm5YGMlKdze79_WmpULeIkrYnaeInBR
X-Proofpoint-GUID: 6Yy6go8vhNsdAwRBBBIYqmcvBCRTvERU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_05,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 spamscore=0 priorityscore=1501 mlxscore=0 malwarescore=0
 impostorscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212200116
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/15/22 5:56 AM, Harald Freudenberger wrote:
> On 2022-12-13 16:44, Tony Krowiak wrote:
>> Some response codes returned from the queue reset function are not being
>> handled correctly; this patch fixes them:
>>
>> 1. Response code 3, AP queue deconfigured: Deconfiguring an AP adapter
>>    resets all of its queues, so this is handled by indicating the reset
>>    verification completed successfully.
>>
>> 2. For all response codes other than 0 (normal reset completion), 2
>>    (queue reset in progress) and 3 (AP deconfigured), the -EIO error 
>> will
>>    be returned from the vfio_ap_mdev_reset_queue() function. In all 
>> cases,
>>    all fields of the status word other than the response code will be
>>    set to zero, so it makes no sense to check status bits.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>  drivers/s390/crypto/vfio_ap_ops.c | 17 +++++++----------
>>  1 file changed, 7 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index c0cf5050be59..dbf681715a6d 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1659,17 +1659,15 @@ static int vfio_ap_mdev_reset_queue(struct
>> vfio_ap_queue *q)
>>          if (ret)
>>              break;
>>          goto retry_zapq;
>> -    case AP_RESPONSE_Q_NOT_AVAIL:
>>      case AP_RESPONSE_DECONFIGURED:
>> -    case AP_RESPONSE_CHECKSTOPPED:
>> -        WARN_ONCE(status.irq_enabled,
>> -              "PQAP/ZAPQ for %02x.%04x failed with rc=%u while IRQ 
>> enabled",
>> -              AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
>> -              status.response_code);
>> -        ret = -EBUSY;
>> -        goto free_resources;
>> +        /*
>> +         * When an AP adapter is deconfigured, the associated
>> +         * queues are reset, so let's return a value indicating the 
>> reset
>> +         * completed successfully.
>> +         */
>> +        ret = 0;
>> +        break;
>>      default:
>> -        /* things are really broken, give up */
>>          WARN(true,
>>               "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
>>               AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
>> @@ -1677,7 +1675,6 @@ static int vfio_ap_mdev_reset_queue(struct
>> vfio_ap_queue *q)
>>          return -EIO;
>>      }
>>
>> -free_resources:
>>      vfio_ap_free_aqic_resources(q);
>>
>>      return ret;
>
> Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>


Thanks for the review.


