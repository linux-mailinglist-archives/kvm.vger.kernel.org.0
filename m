Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0C065225D
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 15:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233416AbiLTOWk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 09:22:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234037AbiLTOW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 09:22:28 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3873B195;
        Tue, 20 Dec 2022 06:22:28 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKEBWk7008452;
        Tue, 20 Dec 2022 14:22:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1Kv7LQYhQQAacZH4s0dEzTM7w5tjcoS6eKG5FsQ37LQ=;
 b=Gyz0RirGM4JabGZGe+0wmNkOzLZKm/THAGGKkUFoDT+47JTMWUerEtOWyCMaoPKG6W4I
 UbAwUqyeC5fnaEnblhq4xbTlpB1IbKf63BSuaFEFhTW5a+F/lAjRtNR/FIh1uQBZdaHM
 r+e1Smkd8Y4tjPGQoko1tocAv2pZb6gLbchzO+HFul8pF0uQH1Es37ypieGXOpjqSZKs
 9QluqepQ6gBC3eG5Z6TQGkrNpkzXGrtr1sXAUHWmnZ9qV7keNy4l74cC/NPKl4YucQeU
 bkTyEuxyra84yHAo2I3xoI7cKVJkoqEgf61WGeXFijgU9aaTYbrb1GWQ2+t4nyWIJqN8 kA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkekk0fm0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:22:25 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BKEBndB011069;
        Tue, 20 Dec 2022 14:22:25 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkekk0fkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:22:25 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKD1Lqp032666;
        Tue, 20 Dec 2022 14:22:24 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([9.208.129.119])
        by ppma01dal.us.ibm.com (PPS) with ESMTPS id 3mh6yysy7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 14:22:24 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
        by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKEMM7o36766370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 14:22:22 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A7375805F;
        Tue, 20 Dec 2022 14:22:22 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1174158043;
        Tue, 20 Dec 2022 14:22:21 +0000 (GMT)
Received: from [9.160.121.75] (unknown [9.160.121.75])
        by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 20 Dec 2022 14:22:20 +0000 (GMT)
Message-ID: <ab8b7ef4-3402-aec1-e8a2-ccfa109da0fa@linux.ibm.com>
Date:   Tue, 20 Dec 2022 09:22:20 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 3/7] s390/vfio_ap: use TAPQ to verify reset in progress
 completes
Content-Language: en-US
To:     freude@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
 <20221213154437.15480-4-akrowiak@linux.ibm.com>
 <2541e0d3d4fb38af995e8bd91a34986d@linux.ibm.com>
From:   Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <2541e0d3d4fb38af995e8bd91a34986d@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4eveAoJ9miQitOBABL1XkO1wYh4DAYIH
X-Proofpoint-GUID: AhnnxKH_NO3XISpPI0uOQpsLyHd8K5ry
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_05,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200116
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/15/22 5:51 AM, Harald Freudenberger wrote:
> On 2022-12-13 16:44, Tony Krowiak wrote:
>> To eliminate the repeated calls to the PQAP(ZAPQ) function to verify 
>> that
>> a reset in progress completed successfully and ensure that error 
>> response
>> codes get appropriately logged, let's call the apq_reset_check() 
>> function
>> when the ZAPQ response code indicates that a reset that is already in
>> progress.
>>
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>  drivers/s390/crypto/vfio_ap_ops.c | 24 +++++++++++++-----------
>>  1 file changed, 13 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index a5530a46cf31..5bf2d93ae8af 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -33,7 +33,7 @@
>>  static int vfio_ap_mdev_reset_queues(struct ap_queue_table *qtable);
>>  static struct vfio_ap_queue *vfio_ap_find_queue(int apqn);
>>  static const struct vfio_device_ops vfio_ap_matrix_dev_ops;
>> -static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q, unsigned
>> int retry);
>> +static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q);
>>
>>  /**
>>   * get_update_locks_for_kvm: Acquire the locks required to 
>> dynamically update a
>> @@ -1632,8 +1632,7 @@ static int apq_reset_check(struct vfio_ap_queue 
>> *q)
>>      return ret;
>>  }
>>
>> -static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
>> -                    unsigned int retry)
>> +static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
>>  {
>>      struct ap_queue_status status;
>>      int ret;
>> @@ -1648,12 +1647,15 @@ static int vfio_ap_mdev_reset_queue(struct
>> vfio_ap_queue *q,
>>          ret = 0;
>>          break;
>>      case AP_RESPONSE_RESET_IN_PROGRESS:
>> -        if (retry--) {
>> -            msleep(20);
>> -            goto retry_zapq;
>> -        }
>> -        ret = -EBUSY;
>> -        break;
>> +        /*
>> +         * There is a reset issued by another process in progress. 
>> Let's wait
>> +         * for that to complete. Since we have no idea whether it 
>> was a RAPQ or
>> +         * ZAPQ, then if it completes successfully, let's issue the 
>> ZAPQ.
>> +         */
>> +        ret = apq_reset_check(q);
>> +        if (ret)
>> +            break;
>> +        goto retry_zapq;
>>      case AP_RESPONSE_Q_NOT_AVAIL:
>>      case AP_RESPONSE_DECONFIGURED:
>>      case AP_RESPONSE_CHECKSTOPPED:
>> @@ -1688,7 +1690,7 @@ static int vfio_ap_mdev_reset_queues(struct
>> ap_queue_table *qtable)
>>      struct vfio_ap_queue *q;
>>
>>      hash_for_each(qtable->queues, loop_cursor, q, mdev_qnode) {
>> -        ret = vfio_ap_mdev_reset_queue(q, 1);
>> +        ret = vfio_ap_mdev_reset_queue(q);
>>          /*
>>           * Regardless whether a queue turns out to be busy, or
>>           * is not operational, we need to continue resetting
>> @@ -1931,7 +1933,7 @@ void vfio_ap_mdev_remove_queue(struct ap_device 
>> *apdev)
>>          }
>>      }
>>
>> -    vfio_ap_mdev_reset_queue(q, 1);
>> +    vfio_ap_mdev_reset_queue(q);
>>      dev_set_drvdata(&apdev->device, NULL);
>>      kfree(q);
>>      release_update_locks_for_mdev(matrix_mdev);
>
> Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>


Thanks for the review.


