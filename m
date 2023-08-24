Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6AF8786C93
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 12:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238007AbjHXKKN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 06:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238445AbjHXKJm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 06:09:42 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A248419A0;
        Thu, 24 Aug 2023 03:09:38 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OA6wPq003874;
        Thu, 24 Aug 2023 10:09:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=TXcV6QLCl9RWInpxgJLVQEsC29bfa8uVk5T+zILKCxg=;
 b=iVWqYQ3IJq0buvp3oDYJPo8Suk1VUew3YkOcIEjqNR1Klh7JxA/sjfurM9EvQezY3N5S
 KymVTYT6pJI82/Xrr6/d2P/9F/IpC34PiZkAzyrglIs2BwTuhJClOoVC7SdRpJrkcu5d
 5pyVuSmYKE4TgQy1loCa5tkRF4c5qx6g/1oihtltv1/5I+HmREXqtaX5ATkYWLUW6YhK
 SGYQkS+rCSmD//3bSbJ1iCQPk1qBzlFG0fKDACirbBNB/SzfZImOuavUOTgwfdZcDpKT
 emzDJN1uwnQXOJiEt8erShPmDm+ZPeZ41Bqj1jKzIyg1sHYtpFA/3e4obeJOYZx+St6V gw== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sp4hcrv8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 10:09:37 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 37O9m0dr018220;
        Thu, 24 Aug 2023 10:09:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3sn21sp4ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 24 Aug 2023 10:09:36 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 37OA9XXo18940532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Aug 2023 10:09:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 272892004B;
        Thu, 24 Aug 2023 10:09:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D31520043;
        Thu, 24 Aug 2023 10:09:32 +0000 (GMT)
Received: from [9.171.83.138] (unknown [9.171.83.138])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 24 Aug 2023 10:09:32 +0000 (GMT)
Message-ID: <61f13a05-beac-11fc-5657-03f39856d1df@linux.ibm.com>
Date:   Thu, 24 Aug 2023 12:09:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH] KVM: s390: fix gisa destroy operation might lead to cpu
 stalls
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
References: <20230823124140.3839373-1-mimu@linux.ibm.com>
 <ZOYIWuq3iqLjDd+q@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <e144381d-4ff3-d7b6-5624-813ea22f196a@linux.ibm.com>
 <ZOYtd7m2TqMDIb++@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <20230823181627.7903ad6f@p-imbrenda>
From:   Michael Mueller <mimu@linux.ibm.com>
In-Reply-To: <20230823181627.7903ad6f@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: J9fTgKP-WJVTL-f9YT3ZHSTU9gKMBRFQ
X-Proofpoint-GUID: J9fTgKP-WJVTL-f9YT3ZHSTU9gKMBRFQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-24_06,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=801 spamscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 suspectscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308240081
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23.08.23 18:16, Claudio Imbrenda wrote:
> On Wed, 23 Aug 2023 18:01:59 +0200
> Alexander Gordeev <agordeev@linux.ibm.com> wrote:
> 
>> On Wed, Aug 23, 2023 at 04:09:26PM +0200, Michael Mueller wrote:
>>>
>>>
>>> On 23.08.23 15:23, Alexander Gordeev wrote:
>>>> On Wed, Aug 23, 2023 at 02:41:40PM +0200, Michael Mueller wrote:
>>>> ...
>>>>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
>>>>> index 9bd0a873f3b1..73153bea6c24 100644
>>>>> --- a/arch/s390/kvm/interrupt.c
>>>>> +++ b/arch/s390/kvm/interrupt.c
>>>>> @@ -3205,8 +3205,10 @@ void kvm_s390_gisa_destroy(struct kvm *kvm)
>>>>>    	if (gi->alert.mask)
>>>>>    		KVM_EVENT(3, "vm 0x%pK has unexpected iam 0x%02x",
>>>>>    			  kvm, gi->alert.mask);
>>>>> -	while (gisa_in_alert_list(gi->origin))
>>>>> -		cpu_relax();
>>>>> +	while (gisa_in_alert_list(gi->origin)) {
>>>>> +		KVM_EVENT(3, "vm 0x%pK gisa in alert list during destroy", kvm);
>>>>> +		process_gib_alert_list();
>>>>
>>>> process_gib_alert_list() has two nested loops and neither of them
>>>> does cpu_relax(). I guess, those are needed instead of one you remove?
>>>
>>> Calling function process_gib_alert_list() guarantees the gisa
>>> is taken out of the alert list immediately and thus the potential
>>> endless loop on gisa_in_alert_list() is solved. The issue surfaced
>>> with the following patch that accidently disabled the GAL interrupt
>>> processing on the host that normaly handles the alert list.
>>> The patch has been reverted from devel and will be re-applied in v2.
>>>
>>> 88a096a7a460 Revert "s390/airq: remove lsi_mask from airq_struct"
>>> a9d17c5d8813 s390/airq: remove lsi_mask from airq_struct
>>>
>>> Does that make sense for you?
>>
>> Not really. If process_gib_alert_list() does guarantee the removal,
>> then it should be a condition, not the loop.
> 
> this is actually a good question. why is it still a loop?

The reason for the loop aproach was that I was not sure if any late
incoming interrupts would bring the gisa back into the alert list
by the firmware.

I verified that this cannot happen if the mask that restores the
interruption alert mask (IAM) is properly set to 0x00 by the last
device driver de-registration before gisa destruction.

In addition I now enforce it to be 0x00 if not already done. (That would
be a bug.) That finally means the *if in_alert_list then 
process_alert_list* is sufficient.

I will send a v2.

> 
>>
>> But I am actually not into this code. Just wanted to point out that
>> cpu_relax() is removed from this loop and the two other loops within
>> process_gib_alert_list() do not have it either.
>>
>> So up to Christian, Janosch and Claudio.
> 
