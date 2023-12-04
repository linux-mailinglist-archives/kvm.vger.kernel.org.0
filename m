Return-Path: <kvm+bounces-3361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AB6B80379F
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 15:54:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B8951C20B5F
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 14:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB0828DD8;
	Mon,  4 Dec 2023 14:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="J5nDe2bJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EFFA1;
	Mon,  4 Dec 2023 06:54:21 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4Eq96E020640;
	Mon, 4 Dec 2023 14:54:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0H1CuKAYogqCZsn/ksRFsa0G5IRLpU8w0lcNqSiLkgI=;
 b=J5nDe2bJY8810A2POgau07YJ+6BBhLAgOgcvI2Ci205uilYsK9d+daXaH84IKWe5itOG
 C1AR894X1yKWRJ+YVYFUH6SyrQlFUuRoToPOerVgjfLQvyHuw+X7J4Cu1K+7TzN46a/a
 AExr1ZZhPzYlfxdNxp/+c2YJxq/X9ycZQNiXgIcIONv3kIChUNDWX7Io8QZelrjqEFBm
 BWHwFCDvEcuzzc/1948Y8fvO7EBS6e7GZtGFUu7X2NPLbBSPzJ2jnU+ZPOSO/c6PBL7T
 reBo+H4mJ8+jMAP/h+53DWgoXiL/UbeyTMGW0MitQ6PfEv6dQhiTtiqPvoj+peEXBgqB 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3usekcdq5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 14:54:18 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B4ERj1B026528;
	Mon, 4 Dec 2023 14:54:06 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3usekcdpwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 14:54:06 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4EJSev020522;
	Mon, 4 Dec 2023 14:53:52 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3urv8dnjc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 14:53:52 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B4Erp3R24707688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Dec 2023 14:53:51 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 888815805A;
	Mon,  4 Dec 2023 14:53:51 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE24C5803F;
	Mon,  4 Dec 2023 14:53:50 +0000 (GMT)
Received: from [9.61.175.228] (unknown [9.61.175.228])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 Dec 2023 14:53:50 +0000 (GMT)
Message-ID: <1f4720d7-93f1-4e38-a3ad-abaf99596e7c@linux.ibm.com>
Date: Mon, 4 Dec 2023 09:53:50 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] s390/vfio-ap: handle response code 01 on queue reset
Content-Language: en-US
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc: jjherne@linux.ibm.com, pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        david@redhat.com
References: <20231129143529.260264-1-akrowiak@linux.ibm.com>
 <b43414ef-7aa4-9e5c-a706-41861f0d346c@linux.ibm.com>
From: Tony Krowiak <akrowiak@linux.ibm.com>
Organization: IBM
In-Reply-To: <b43414ef-7aa4-9e5c-a706-41861f0d346c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LiPqEQEffht9-OMuMmPGu4mqf9N3NKXc
X-Proofpoint-ORIG-GUID: FusNM78Gsy9mHp2FC5kLwwcm7lUPOau7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-04_13,2023-12-04_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 impostorscore=0 mlxscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312040112



On 11/29/23 12:12, Christian Borntraeger wrote:
> Am 29.11.23 um 15:35 schrieb Tony Krowiak:
>> In the current implementation, response code 01 (AP queue number not 
>> valid)
>> is handled as a default case along with other response codes returned 
>> from
>> a queue reset operation that are not handled specifically. Barring a bug,
>> response code 01 will occur only when a queue has been externally removed
>> from the host's AP configuration; nn this case, the queue must
>> be reset by the machine in order to avoid leaking crypto data if/when the
>> queue is returned to the host's configuration. The response code 01 case
>> will be handled specifically by logging a WARN message followed by 
>> cleaning
>> up the IRQ resources.
>>
> 
> To me it looks like this can be triggered by the LPAR admin, correct? So it
> is not desireable but possible.
> In that case I prefer to not use WARN, maybe use dev_warn or dev_err 
> instead.
> WARN can be a disruptive event if panic_on_warn is set.

Yes, it can be triggered by the LPAR admin. I can't use dev_warn here 
because we don't have a reference to any device, but I can use pr_warn 
if that suffices.

> 
> 
>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 31 +++++++++++++++++++++++++++++++
>>   1 file changed, 31 insertions(+)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c 
>> b/drivers/s390/crypto/vfio_ap_ops.c
>> index 4db538a55192..91d6334574d8 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -1652,6 +1652,21 @@ static int apq_status_check(int apqn, struct 
>> ap_queue_status *status)
>>            * a value indicating a reset needs to be performed again.
>>            */
>>           return -EAGAIN;
>> +    case AP_RESPONSE_Q_NOT_AVAIL:
>> +        /*
>> +         * This response code indicates the queue is not available.
>> +         * Barring a bug, response code 01 will occur only when a queue
>> +         * has been externally removed from the host's AP configuration;
>> +         * in which case, the queue must be reset by the machine in
>> +         * order to avoid leaking crypto data if/when the queue is
>> +         * returned to the host's configuration. In this case, let's go
>> +         * ahead and log a warning message and return 0 so the AQIC
>> +         * resources get cleaned up by the caller.
>> +         */
>> +        WARN(true,
>> +             "Unable to reset queue %02x.%04x: not in host AP 
>> configuration\n",
>> +             AP_QID_CARD(apqn), AP_QID_QUEUE(apqn));
>> +            return 0;
>>       default:
>>           WARN(true,
>>                "failed to verify reset of queue %02x.%04x: TAPQ rc=%u\n",
>> @@ -1736,6 +1751,22 @@ static void vfio_ap_mdev_reset_queue(struct 
>> vfio_ap_queue *q)
>>           q->reset_status.response_code = 0;
>>           vfio_ap_free_aqic_resources(q);
>>           break;
>> +    case AP_RESPONSE_Q_NOT_AVAIL:
>> +        /*
>> +         * This response code indicates the queue is not available.
>> +         * Barring a bug, response code 01 will occur only when a queue
>> +         * has been externally removed from the host's AP configuration;
>> +         * in which case, the queue must be reset by the machine in
>> +         * order to avoid leaking crypto data if/when the queue is
>> +         * returned to the host's configuration. In this case, let's go
>> +         * ahead and log a warning message then clean up the AQIC
>> +         * resources.
>> +         */
>> +        WARN(true,
>> +             "Unable to reset queue %02x.%04x: not in host AP 
>> configuration\n",
>> +             AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
>> +        vfio_ap_free_aqic_resources(q);
>> +        break;
>>       default:
>>           WARN(true,
>>                "PQAP/ZAPQ for %02x.%04x failed with invalid rc=%u\n",

