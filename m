Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1E0428799
	for <lists+kvm@lfdr.de>; Mon, 11 Oct 2021 09:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhJKH0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 03:26:49 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32584 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233605AbhJKH0s (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Oct 2021 03:26:48 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19B5BfYn003164;
        Mon, 11 Oct 2021 03:24:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=4nwB9zbPvj3BCfAHwy/rsz9h1srAE355aDnRP5VAIMc=;
 b=kfZOQ9k21aAE/WhK35gmRTJp5cfVHYr6tgL1aL88caK32tZobX6b4tFWiAEDvn9qLU6s
 QcVWCUSFTkXnrmwExN5UEWzftn5gmW3YBibJ5NsfsEaGY6Ee1ZoecvEvWFo7N6IB1bXg
 3InASFi5qWbDlhetMt+GRcSBm4zFx0jFr+yx+X4pL3ogGVebHSJ7HqJzQi+iTsWQaaeV
 pcXEgGejXIaMC+oiUABeGClyUfLFjNBYYCDdgAIDyoW/Q8jMCx3+LeniJTDheHohLCTz
 ZB1lyLy/0qlf3OpIDvbH1dlTi0YvX1jZFgvwMG+bcetiXe/OOMz8o6VpVDbcqJXjtT1/ DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmewgab2u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 03:24:47 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19B70X5I011759;
        Mon, 11 Oct 2021 03:24:47 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bmewgab2e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 03:24:47 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19B7DKuX000745;
        Mon, 11 Oct 2021 07:24:45 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3bk2q9hwx8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Oct 2021 07:24:45 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19B7OdXx43385122
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Oct 2021 07:24:39 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C575AE051;
        Mon, 11 Oct 2021 07:24:39 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C76D6AE059;
        Mon, 11 Oct 2021 07:24:36 +0000 (GMT)
Received: from li-43c5434c-23b8-11b2-a85c-c4958fb47a68.ibm.com (unknown [9.171.26.102])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Oct 2021 07:24:36 +0000 (GMT)
Subject: Re: [RFC PATCH v1 1/6] KVM: s390: Simplify SIGP Set Arch handling
To:     Thomas Huth <thuth@redhat.com>, Eric Farman <farman@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20211008203112.1979843-1-farman@linux.ibm.com>
 <20211008203112.1979843-2-farman@linux.ibm.com>
 <912906c5-5932-c6d5-76c7-0751412c1344@redhat.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <b8ea7e8b-1303-e5da-b469-f582d2dd1452@de.ibm.com>
Date:   Mon, 11 Oct 2021 09:24:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <912906c5-5932-c6d5-76c7-0751412c1344@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qmUbbgrVsIngYE4fsteJxrnMOg1BqAuu
X-Proofpoint-GUID: pyPWFVLwHq75q9JQhnhTiVYzW4l53XwJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-11_02,2021-10-07_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 mlxscore=0 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110110040
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 11.10.21 um 08:29 schrieb Thomas Huth:
> On 08/10/2021 22.31, Eric Farman wrote:
>> The Principles of Operations describe the various reasons that
>> each individual SIGP orders might be rejected, and the status
>> bit that are set for each condition.
>>
>> For example, for the Set Architecture order, it states:
>>
>>    "If it is not true that all other CPUs in the configu-
>>     ration are in the stopped or check-stop state, ...
>>     bit 54 (incorrect state) ... is set to one."
>>
>> However, it also states:
>>
>>    "... if the CZAM facility is installed, ...
>>     bit 55 (invalid parameter) ... is set to one."
>>
>> Since the Configuration-z/Architecture-Architectural Mode (CZAM)
>> facility is unconditionally presented, there is no need to examine
>> each VCPU to determine if it is started/stopped. It can simply be
>> rejected outright with the Invalid Parameter bit.
>>
>> Fixes: b697e435aeee ("KVM: s390: Support Configuration z/Architecture Mode")
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>   arch/s390/kvm/sigp.c | 14 +-------------
>>   1 file changed, 1 insertion(+), 13 deletions(-)
>>
>> diff --git a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
>> index 683036c1c92a..cf4de80bd541 100644
>> --- a/arch/s390/kvm/sigp.c
>> +++ b/arch/s390/kvm/sigp.c
>> @@ -151,22 +151,10 @@ static int __sigp_stop_and_store_status(struct kvm_vcpu *vcpu,
>>   static int __sigp_set_arch(struct kvm_vcpu *vcpu, u32 parameter,
>>                  u64 *status_reg)
>>   {
>> -    unsigned int i;
>> -    struct kvm_vcpu *v;
>> -    bool all_stopped = true;
>> -
>> -    kvm_for_each_vcpu(i, v, vcpu->kvm) {
>> -        if (v == vcpu)
>> -            continue;
>> -        if (!is_vcpu_stopped(v))
>> -            all_stopped = false;
>> -    }
>> -
>>       *status_reg &= 0xffffffff00000000UL;
>>       /* Reject set arch order, with czam we're always in z/Arch mode. */
>> -    *status_reg |= (all_stopped ? SIGP_STATUS_INVALID_PARAMETER :
>> -                    SIGP_STATUS_INCORRECT_STATE);
>> +    *status_reg |= SIGP_STATUS_INVALID_PARAMETER;
>>       return SIGP_CC_STATUS_STORED;
>>   }
> 
> I was initially a little bit torn by this modification, since, as you already mentioned, it could theoretically be possible that a userspace (like an older version of QEMU) does not use CZAM bit yet. But then I read an older version of the PoP which does not feature CZAM yet, and it reads:

I had the same concern, if we should cope in the kernel for ancient userspace, but your explanation below makes this actually even better.
And by definition in KVM we ARE always in z/Arch mode.

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> 
> "The set-architecture order is completed as follows:
> • If the code in the parameter register is not 0, 1, or
>    2, or if the CPU is already in the architectural
>    mode specified by the code, the order is not
>    accepted. Instead, bit 55 (invalid parameter) of
>    the general register designated by the R 1 field of
>    the SIGNAL PROCESSOR instruction is set to
>    one, and condition code 1 is set.
> • If it is not true that all other CPUs in the configu-
>    ration are in the stopped or check-stop state, the
>    order is not accepted. Instead, bit 54 (incorrect
>    state) of the general register designated by the
>    R 1 field of the SIGNAL PROCESSOR instruction
>    is set to one, and condition code 1 is set.
> • The architectural mode of all CPUs in the config-
>    uration is set as specified by the code.
>    ..."
> 
> So to me this sounds like "invalid parameter" has a higher priority than "incorrect state" anyway, so we likely never
> should have reported here "incorrect state"...?
> 
> Thus, I think it's the right way to go now:
> 
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> 
