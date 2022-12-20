Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D78036522AC
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbiLTOdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234035AbiLTOdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:33:25 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379361C11A;
        Tue, 20 Dec 2022 06:33:10 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKEDQd8019938;
        Tue, 20 Dec 2022 14:33:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=61qzrL76S8t3r1ILt15BKCcihcZ3i9gih8qEAWJeto8=;
 b=DCUpX4lo1OOlKGSfgEG4gC6kPs6sqQ6kiqO3J3Oj3qBJ3lypbDwD5P6slvsJajQXQ/Es
 7LM1Xf3Zy/EC0ljFlQmO8EvwoYlkLh6NigvEf8Q/PnE3yEMuKf7yhRAZM7GRttJEbMEM
 9c4/vV0l2wAeWLYxPRH8JSGmBSu5bbbZftPVL8yVG3ytihG2ePY0phg2k/x047l54ozG
 jWHaSzHjddAtwOmnK39n+QInS+4qGoOP04a1FHyeqpF1OM3NdoHMYoNxFeo4N+4HJL+9
 DkV5mUaR0J/6QrUow1V2yF4sMrFSrRk0hkcm7I31TXbBAgGf2s/XJF20Nwp9XGN6b/tS Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkemdgksq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:33:08 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKEX7oo025563;
        Tue, 20 Dec 2022 14:33:07 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkemdgks2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:33:07 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKCOa1R010167;
        Tue, 20 Dec 2022 14:33:07 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([9.208.129.116])
        by ppma02wdc.us.ibm.com (PPS) with ESMTPS id 3mh6yuvu5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:33:06 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKEX5oC6750876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 14:33:05 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 12FF258060;
        Tue, 20 Dec 2022 14:33:05 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18AB65805D;
        Tue, 20 Dec 2022 14:33:04 +0000 (GMT)
Received: from [9.160.121.75] (unknown [9.160.121.75])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 14:33:03 +0000 (GMT)
Message-ID: <7b6d7e91-ba00-6486-39ae-91fca30b2cfb@linux.ibm.com>
Date:   Tue, 20 Dec 2022 09:33:03 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 7/7] s390/vfio_ap: always clean up IRQ resources
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-8-akrowiak@linux.ibm.com>
 <20221219151007.639dff5f.pasic@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20221219151007.639dff5f.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HqdGExhJLlCZC92VegDST_sgE8xCtxjO
X-Proofpoint-ORIG-GUID: 6J7Pzu2NTymBs9MW6X2kRexfWNvTjcAZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_05,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 spamscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 mlxlogscore=999 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2212200116
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/19/22 9:10 AM, Halil Pasic wrote:
> On Tue, 13 Dec 2022 10:44:37 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> Clean up IRQ resources even when a PQAP(ZAPQ) function fails with an error
>> not handled by a case statement.
> Why?


If the ZAPQ failed, then instructions submitted to the same queue will 
likewise fail. Are you saying it's not safe to assume, therefore, that 
interrupts will not be occurring?


>
> I'm afraid this is a step in the wrong direction...


Please explain why.


>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index e80c5a6b91be..2dd8db9ddb39 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1676,7 +1676,7 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
>>   		     "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",
>>   		     AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
>>   		     status.response_code);
>> -		return -EIO;
>> +		break;
>>   	}
>>   
>>   	vfio_ap_free_aqic_resources(q);
