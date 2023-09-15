Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279767A2068
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 16:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbjIOOEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 10:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235486AbjIOOEX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 10:04:23 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194D61FCE;
        Fri, 15 Sep 2023 07:04:19 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38FE3ae0018474;
        Fri, 15 Sep 2023 14:04:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Y+WwTtVVIEVlyjTXDCy8B6tsMdV6svWm5RmLNNGeGMg=;
 b=BsduZN1+/M2CqaabPjLd6+oG89nQ4ydUzMy6+96/I6JbjKT7Ht9x84u1//trc7n4dep0
 17qd+NT5lgHuYM1QhRcii4X/Ceya8+ft9BauvpdvcpfzMjfG2Zl4vz6j4EHXCbiqWQvJ
 lZqY7QrANpWraP66fGDT9CeC3IMKOKPTqA86rjOSuB5ZW5ABv30zZ3lSncpNoVx1J6UE
 yQ1zPmkuhMdt9Q2OOohiHJm4q7OA8Q/0oceBApolIGxNG/tj6krxQY1D66xAy+TFxrEp
 gCR1DouR17OdsYdrW/ANabVA5e1FeOKOo5Th0AjKEaViVB6Mq29VygRJdF0tOEO+tKqK lA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t4qk01wfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Sep 2023 14:04:16 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38FDuhjk023498;
        Fri, 15 Sep 2023 14:04:16 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t4qk01weh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Sep 2023 14:04:16 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38FDMGer023099;
        Fri, 15 Sep 2023 14:04:15 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
        by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t141pc61t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Sep 2023 14:04:15 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38FE4Eso24772882
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Sep 2023 14:04:14 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13EC758052;
        Fri, 15 Sep 2023 14:04:14 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 129EB5805D;
        Fri, 15 Sep 2023 14:04:13 +0000 (GMT)
Received: from [9.61.101.13] (unknown [9.61.101.13])
        by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 15 Sep 2023 14:04:12 +0000 (GMT)
Message-ID: <5c7920fc-7e15-dbd2-91e6-c6822500d9ec@linux.ibm.com>
Date:   Fri, 15 Sep 2023 10:04:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 0/2] a couple of corrections to the IRQ enablement
 function
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, borntraeger@linux.ibm.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Michael Mueller <mimu@linux.ibm.com>
References: <20230913130626.217665-1-akrowiak@linux.ibm.com>
 <83cab22d-71c3-2bbc-856f-6527479f10ec@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <83cab22d-71c3-2bbc-856f-6527479f10ec@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: mCYJvD3ViZxvcvtfmu9mDH8lYCSn4K-P
X-Proofpoint-ORIG-GUID: KfGkphu9VH5zwJXooqwTssgi5BLwnm4N
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-15_10,2023-09-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 impostorscore=0
 clxscore=1015 mlxscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309150121
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/13/23 14:13, Matthew Rosato wrote:
> On 9/13/23 9:06 AM, Tony Krowiak wrote:
>> This series corrects two issues related to enablement of interrupts in
>> response to interception of the PQAP(AQIC) command:
>>
>> 1. Returning a status response code 06 (Invalid address of AP-queue
>>     notification byte) when the call to register a guest ISC fails makes no
>>     sense.
>>     
>> 2. The pages containing the interrupt notification-indicator byte are not
>>     freed after a failure to register the guest ISC fails.
>>
> 
> Hi Tony,
> 
> 3. Since you're already making changes related to gisc registration, you might consider a 3rd patch that looks at the return code for kvm_s390_gisc_unregister and tags the unexpected error rc somehow.  This came up in a recent conversation I had with Michael, see this conversation towards the bottom:
> 
> https://lore.kernel.org/linux-s390/0ddf808c-e929-c975-1b39-5ebc1f2fab62@linux.ibm.com/

When we receive a non-zero return code from kvm_s390_gisc_register, we 
log a DBF warning message. We can do the same for a non-zero rc from 
kvm_s390_gisc_unregister.

> 
> 4. While looking at patch 1 I also had a question re: the AP_RESPONSE_OTHERWISE_CHANGED path in vfio_ap_irq_enable.  Here's a snippet of the current code:
> 
> 	case AP_RESPONSE_OTHERWISE_CHANGED:
> 		/* We could not modify IRQ settings: clear new configuration */
> 		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
> 		kvm_s390_gisc_unregister(kvm, isc);
> 		break;
> 
> Is it safe to unpin the page before unregistering the gisc in this case?  Or shouldn't the unpin happen after we have unregistered the gisc / set the IAM?

I don't know the answer to the question, but it makes logical sense; so, 
I'll go ahead and create a third patch as you suggested.

> 
>> Anthony Krowiak (2):
>>    s390/vfio-ap: unpin pages on gisc registration failure
>>    s390/vfio-ap: set status response code to 06 on gisc registration
>>      failure
>>
>>   drivers/s390/crypto/vfio_ap_ops.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
> 
