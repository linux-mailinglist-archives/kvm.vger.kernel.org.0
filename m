Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F113F1FA2A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 20:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfEOSnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 14:43:19 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43826 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbfEOSnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 14:43:19 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4FIdRhN007966;
        Wed, 15 May 2019 18:42:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=otXXOszYdsBjfduSwJUQZMWPrfd3KE8B1WDi+bhrywk=;
 b=ITAdYKE1B/U0xNlismRf6Qdi+fFFUhlE60wD5BkDOFle1E4oerlFWH5BN4cn+Oq3NaSL
 UixopBNoYqtHSys4Lcf4By4RPyZP7a1oQuEKag2VubVoE9YiwWIx1o1DCh5nDbR3LkqL
 Cw72lo/JDO5YdQWUANbGRuPM/QdAovfkJ5Yhp4Xdu757pmJOktPivaNlAhYERbX/w6uZ
 3NBc5goakeLwFMJ+hoBzs1u0XOxVhYAh6yVfQEofs/X8z4wfOOg8QYB3NmwSqsC1gk4B
 iltYLhrKJkmVadl5MvuYw0zZaK+uWrITUL+0s9tYPP1VBzBhvp1k9hRVFnkcyyX6Y7WU bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2sdq1qpr5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 18:42:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4FIgE9p104332;
        Wed, 15 May 2019 18:42:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2sgkx3n23q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 18:42:42 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4FIgf6k002096;
        Wed, 15 May 2019 18:42:41 GMT
Received: from [10.156.75.204] (/10.156.75.204)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 May 2019 18:42:40 +0000
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20190507185647.GA29409@amt.cnet>
 <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
 <20190514135022.GD4392@amt.cnet>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <7e390fef-e0df-963f-4e18-e44ac2766be3@oracle.com>
Date:   Wed, 15 May 2019 11:42:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190514135022.GD4392@amt.cnet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9257 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905150112
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9257 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905150113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/14/19 6:50 AM, Marcelo Tosatti wrote:
> On Mon, May 13, 2019 at 05:20:37PM +0800, Wanpeng Li wrote:
>> On Wed, 8 May 2019 at 02:57, Marcelo Tosatti <mtosatti@redhat.com> wrote:
>>>
>>>
>>> Certain workloads perform poorly on KVM compared to baremetal
>>> due to baremetal's ability to perform mwait on NEED_RESCHED
>>> bit of task flags (therefore skipping the IPI).
>>
>> KVM supports expose mwait to the guest, if it can solve this?
>>
>> Regards,
>> Wanpeng Li
> 
> Unfortunately mwait in guest is not feasible (uncompatible with multiple
> guests). Checking whether a paravirt solution is possible.

Hi Marcelo,

I was also looking at making MWAIT available to guests in a safe manner:
whether through emulation or a PV-MWAIT. My (unsolicited) thoughts
follow.

We basically want to handle this sequence:

     monitor(monitor_address);
     if (*monitor_address == base_value)
          mwaitx(max_delay);

Emulation seems problematic because, AFAICS this would happen:

     guest                                   hypervisor
     =====                                   ====

     monitor(monitor_address);
         vmexit  ===>                        monitor(monitor_address)
     if (*monitor_address == base_value)
          mwait();
               vmexit    ====>               mwait()

There's a context switch back to the guest in this sequence which seems
problematic. Both the AMD and Intel specs list system calls and
far calls as events which would lead to the MWAIT being woken up: 
"Voluntary transitions due to fast system call and far calls (occurring 
prior to issuing MWAIT but after setting the monitor)".


We could do this instead:

     guest                                   hypervisor
     =====                                   ====

     monitor(monitor_address);
         vmexit  ===>                        cache monitor_address
     if (*monitor_address == base_value)
          mwait();
               vmexit    ====>              monitor(monitor_address)
                                            mwait()

But, this would miss the "if (*monitor_address == base_value)" check in
the host which is problematic if *monitor_address changed simultaneously
when monitor was executed.
(Similar problem if we cache both the monitor_address and
*monitor_address.)


So, AFAICS, the only thing that would work is the guest offloading the
whole PV-MWAIT operation.

AFAICS, that could be a paravirt operation which needs three parameters:
(monitor_address, base_value, max_delay.)

This would allow the guest to offload this whole operation to
the host:
     monitor(monitor_address);
     if (*monitor_address == base_value)
          mwaitx(max_delay);

I'm guessing you are thinking on similar lines?


High level semantics: If the CPU doesn't have any runnable threads, then
we actually do this version of PV-MWAIT -- arming a timer if necessary
so we only sleep until the time-slice expires or the MWAIT max_delay does.

If the CPU has any runnable threads then this could still finish its 
time-quanta or we could just do a schedule-out.


So the semantics guaranteed to the host would be that PV-MWAIT returns 
after >= max_delay OR with the *monitor_address changed.



Ankur
