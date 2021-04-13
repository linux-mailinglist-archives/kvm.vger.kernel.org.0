Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A44535D949
	for <lists+kvm@lfdr.de>; Tue, 13 Apr 2021 09:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239552AbhDMHtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Apr 2021 03:49:40 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28658 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239157AbhDMHtj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Apr 2021 03:49:39 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13D7Y0gp060432;
        Tue, 13 Apr 2021 03:48:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pRem/9ovijFsdIKVVvdI5Qpu47qJlfNIL1Gp5VLSCTQ=;
 b=VFYz8VIO3GJlbff+3+cecWGt54nQEEeLXt/y5o2z0n4U4SnQpjOLXpCn2FhDhB3x42R0
 WonrptR15GZOrQvk+m5g9QB1k8lTU8kNxP3Nv89gJWcset6P/UwyG+XbcubQap5XbIE6
 tYljEMQNf2wzl/XPqBwoQlphDu+q5jNjYoxxzkYcn+DNWXHTtnBvLHtGRKU3CyC1tVnP
 nkl3ag0Ty65jL3ILt8Sgfgfv+PDCNZAYZMutogWggDkCsTt9qG5Q7US/pbfEA51iptaK
 PfiPXXuZPDQ5doGE+jD3klZcRKB0+HOjhqn340ZYiI3ZA3RcyIgyKB6FajsEXUvbfo2O BA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37usjc3skc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 03:48:40 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13D7YP91061477;
        Tue, 13 Apr 2021 03:48:40 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37usjc3shs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 03:48:39 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13D7mFVv009766;
        Tue, 13 Apr 2021 07:48:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 37u3n89acu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 07:48:37 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13D7mZPb39059960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 07:48:35 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0665C4C059;
        Tue, 13 Apr 2021 07:48:35 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6A5C4C04A;
        Tue, 13 Apr 2021 07:48:33 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.28.118])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 07:48:33 +0000 (GMT)
Subject: Re: [PATCH v2 1/3] context_tracking: Split guest_enter/exit_irqoff
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Tokarev <mjt@tls.msk.ru>
References: <1618298169-3831-1-git-send-email-wanpengli@tencent.com>
 <1618298169-3831-2-git-send-email-wanpengli@tencent.com>
 <81112cec-72fa-dd8c-21c8-b24f51021f43@de.ibm.com>
 <CANRm+CwNxcKPKdV4Bxr-5sWJtg_SKZEN5atGJKRyLcVnWVSKSg@mail.gmail.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <4551632e-5584-29f6-68dd-d85fa968858b@de.ibm.com>
Date:   Tue, 13 Apr 2021 09:48:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CwNxcKPKdV4Bxr-5sWJtg_SKZEN5atGJKRyLcVnWVSKSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _b_6jJ8GaLr3fNFIFcmuEqxr6TWgkCc3
X-Proofpoint-GUID: nFa8FT1HIHdvd3pFJzq44Q_3GLcP7t4-
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_03:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 mlxlogscore=999 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130052
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13.04.21 09:38, Wanpeng Li wrote:
> On Tue, 13 Apr 2021 at 15:35, Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
>>
>>
>>
>> On 13.04.21 09:16, Wanpeng Li wrote:
>> [...]
>>
>>> @@ -145,6 +155,13 @@ static __always_inline void guest_exit_irqoff(void)
>>>    }
>>>
>>>    #else
THis is the else part


>>> +static __always_inline void context_guest_enter_irqoff(void)
>>> +{
>>> +     instrumentation_begin();

2nd on
>>> +     rcu_virt_note_context_switch(smp_processor_id());
>>> +     instrumentation_end();
2nd off
>>> +}
>>> +
>>>    static __always_inline void guest_enter_irqoff(void)
>>>    {
>>>        /*
>>> @@ -155,10 +172,13 @@ static __always_inline void guest_enter_irqoff(void)
>>>        instrumentation_begin();

first on
>>>        vtime_account_kernel(current);
>>>        current->flags |= PF_VCPU;
>>> -     rcu_virt_note_context_switch(smp_processor_id());
>>>        instrumentation_end();

first off
>>> +
>>> +     context_guest_enter_irqoff();
here we call the 2nd on and off.
>>
>> So we now do instrumentation_begin 2 times?
> 
> Similar to context_guest_enter_irqoff() ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN.

For the
ifdef CONFIG_VIRT_CPU_ACCOUNTING_GEN part
context_guest_enter_irqoff()
does not have instrumentation_begin/end.

Or did I miss anything.
