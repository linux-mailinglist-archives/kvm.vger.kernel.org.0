Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41A3F7A1F9E
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 15:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbjIONRD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 09:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbjIONRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 09:17:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F85E19AE;
        Fri, 15 Sep 2023 06:16:57 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38FCqZuj002988;
        Fri, 15 Sep 2023 13:16:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=1txY/cVrwU7XlQx6bYJVrhDcE8JZWjz4XQPeFrkswyg=;
 b=f+CdJou4m+/V4UEiTKKybawAKOuuJXzvatO5Ihu7tw6Wpg6KZFsU/Pu3M8gyNaWsZggV
 xJHQUEAw5k0bkpsvHh71kN28wwjvRvVfJYF4PNktWU5oqEYQElHm3Ivb9NJ8FlwWO/Ue
 IbbLmIp2Hq4+7Kmpwz9dTlyB7mctLGEDf2WsKHM4T7uVArrHxv/mxOqYvilHt84Owt8L
 jk4h9OKBb8DrXTQOqNEOOy/C2l6wx8x+ECeO7zTv9KmBBiYV8LMYtxvbdVe6f+/qcnhn
 rDuuNsJhIgQrOyN3uTVzcbbU0EvWbH2rtpb3otcATnUwgRlG0Jm0ejP8tB4HPcNvNdGL zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t4qnjgwcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Sep 2023 13:16:54 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38FD4KGo009148;
        Fri, 15 Sep 2023 13:16:54 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t4qnjgwbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Sep 2023 13:16:54 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38FBIuE9022879;
        Fri, 15 Sep 2023 13:16:53 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t141pbtr7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Sep 2023 13:16:53 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
        by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38FDGppV30737042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Sep 2023 13:16:52 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2D3D58056;
        Fri, 15 Sep 2023 13:16:51 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DC29C5805D;
        Fri, 15 Sep 2023 13:16:50 +0000 (GMT)
Received: from [9.61.101.13] (unknown [9.61.101.13])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 15 Sep 2023 13:16:50 +0000 (GMT)
Message-ID: <9108ed33-3009-a959-4635-3d81af697bb9@linux.ibm.com>
Date:   Fri, 15 Sep 2023 09:16:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 1/2] s390/vfio-ap: unpin pages on gisc registration
 failure
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, borntraeger@linux.ibm.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com, stable@vger.kernel.org
References: <20230913130626.217665-1-akrowiak@linux.ibm.com>
 <20230913130626.217665-2-akrowiak@linux.ibm.com>
 <a7da9ab2-b137-8a1c-acb0-c973bbda3462@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <a7da9ab2-b137-8a1c-acb0-c973bbda3462@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kAr4Hjm8fd_E7iMBRAjxnbBeNWlafCld
X-Proofpoint-GUID: eGsoZrjDEif28TJYaedIUZp2i-v_jwbA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-15_09,2023-09-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 priorityscore=1501 clxscore=1015 spamscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309150117
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/13/23 14:10, Matthew Rosato wrote:
> On 9/13/23 9:06 AM, Tony Krowiak wrote:
>> From: Anthony Krowiak <akrowiak@linux.ibm.com>
>>
>> In the vfio_ap_irq_enable function, after the page containing the
>> notification indicator byte (NIB) is pinned, the function attempts
>> to register the guest ISC. If registration fails, the function sets the
>> status response code and returns without unpinning the page containing
>> the NIB. In order to avoid a memory leak, the NIB should be unpinned before
>> returning from the vfio_ap_irq_enable function.
>>
>> Fixes: 783f0a3ccd79 ("s390/vfio-ap: add s390dbf logging to the vfio_ap_irq_enable function")
>>
>> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
>> Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
>> Cc: <stable@vger.kernel.org>
> 
> Oops, good find.

Yes, thanks to Janosch/

> 
> Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
>> ---
>>   drivers/s390/crypto/vfio_ap_ops.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
>> index 4db538a55192..9cb28978c186 100644
>> --- a/drivers/s390/crypto/vfio_ap_ops.c
>> +++ b/drivers/s390/crypto/vfio_ap_ops.c
>> @@ -457,6 +457,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
>>   		VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, isc=%d, apqn=%#04x\n",
>>   				 __func__, nisc, isc, q->apqn);
>>   
>> +		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
>>   		status.response_code = AP_RESPONSE_INVALID_GISA;
>>   		return status;
>>   	}
> 
