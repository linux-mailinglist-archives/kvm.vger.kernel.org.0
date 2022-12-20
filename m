Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3FB65228B
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234025AbiLTO2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbiLTO1g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:27:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BEC31CB0E;
        Tue, 20 Dec 2022 06:27:08 -0800 (PST)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKEBZCT013246;
        Tue, 20 Dec 2022 14:27:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kAiTr09gTCSa0bRz1xrLbKGHm6rIsulW+/p4y36QdY4=;
 b=lQV38wCUW/L8B5NQfYfZ164Mfffw3VJOfVCJAUc//vCzW+6T+R8o7eV5qU0AqncfEjeS
 U85jRA25ngQ8YX8lEZATLaQBmEA2YKlsDfgWdDaTJVxjwz+GI8lZ8eufDnKGP5l/TA0Y
 9e6SRK2CFbEsIsdy6JIpFwLGcGvFI2vii2bEFiEj73cV8+wuqH0b9lxbaSclFpFqabYH
 htCNBSCk/LkhaG57Lj2/vEYnxwI2BbpyJ/zVzfVw6kGWVJ+vZfB3LuZK/v/8hEVp6RPH
 YNPDpNaBYkRhXXdzkkmVlBL+lH9PynXasLavHbPV5YuHzRFXm5dSORzds6vFBEs1GjzU Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkekjrkq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:27:07 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKEBmu0018099;
        Tue, 20 Dec 2022 14:27:06 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkekjrkp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:27:06 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKC38VR021674;
        Tue, 20 Dec 2022 14:27:05 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma03wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yxmtk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:27:05 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKER4A436176342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 14:27:04 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34A255805D;
        Tue, 20 Dec 2022 14:27:04 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 38DE058043;
        Tue, 20 Dec 2022 14:27:03 +0000 (GMT)
Received: from [9.160.121.75] (unknown [9.160.121.75])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 14:27:03 +0000 (GMT)
Message-ID: <021bd231-409b-f9c5-7371-c77425c131d4@linux.ibm.com>
Date:   Tue, 20 Dec 2022 09:27:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 6/7] s390/vfio_ap: increase max wait time for reset
 verification
Content-Language: en-US
To:     freude@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-7-akrowiak@linux.ibm.com>
 <14f20c6e389f8a9d169e398621bec13f@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <14f20c6e389f8a9d169e398621bec13f@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FDgLIqM8yhoGkryiafvAH4y_x6tOI5Xm
X-Proofpoint-ORIG-GUID: ynP9c-kn7ecmJ0XbZLNgpRcxw4_GO6hk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_05,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999
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


On 12/15/22 5:58 AM, Harald Freudenberger wrote:
> On 2022-12-13 16:44, Tony Krowiak wrote:
>> Increase the maximum time to wait for verification of a queue reset
>> operation to 200ms.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>  drivers/s390/crypto/vfio_ap_ops.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index dbf681715a6d..e80c5a6b91be 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -30,6 +30,9 @@
>>  #define AP_QUEUE_UNASSIGNED "unassigned"
>>  #define AP_QUEUE_IN_USE "in use"
>>
>> +#define MAX_RESET_CHECK_WAIT    200    /* Sleep max 200ms for reset 
>> check    */
>> +#define AP_RESET_INTERVAL        20    /* Reset sleep interval 
>> (20ms)        */
>> +
>>  static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable);
>>  static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>>  static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
>> @@ -1615,11 +1618,12 @@ static int apq_status_check(int apqn, struct
>> ap_queue_status *status)
>>
>>  static int apq_reset_check(struct vfio_ap_queue *q)
>>  {
>> -    int iters = 2, ret;
>> +    int ret;
>> +    int iters = MAX_RESET_CHECK_WAIT / AP_RESET_INTERVAL;
>>      struct ap_queue_status status;
>>
>> -    while (iters--) {
>> -        msleep(20);
>> +    for (; iters > 0; iters--) {
>> +        msleep(AP_RESET_INTERVAL);
>>          status = ap_tapq(q->apqn, NULL);
>>          ret = apq_status_check(q->apqn, &status);
>>          if (ret != -EBUSY)
>
> Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>


Thanks for the review.


