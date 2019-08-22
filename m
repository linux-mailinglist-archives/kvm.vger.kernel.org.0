Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AA9993BF
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2019 14:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388632AbfHVMdk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Aug 2019 08:33:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388623AbfHVMdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Aug 2019 08:33:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MCObdR143553;
        Thu, 22 Aug 2019 12:31:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=8ipepF8fIFfgoy7WBs+ngpSF9Cs8x/q2LfMnzNUB/ck=;
 b=c6VeasvPQc1NQSKzFfMUV3Q9iwsBfVzX7BCmaQyJcM546IjuYiwUPqLvJX2FOh1H/TM2
 TONIPr5h9l8xsSfUs6YdJo83HL+HgEexK2mj/yD3j5mAOJ54h//jkZ6FF9+556qcJR09
 l+2n+BQys+78y/cqGYi31paXsLQqvRANm9lLev1S6SFzPzbjk/WcrRa/6ndjkheE6EbQ
 KmxXtKC0fZxcBhfERzIL3c1VwZv0fYrTCDzrW58KCPFD29N8GNpOzCG+gD6Ch9+c5SpS
 5QCbfpERA0i+D+J7R0XGsNBPP+5zOJhacSHp38PHiKWWjcwHRpfjtbbXGipLwKlQDUC/ XA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ue9hpw4w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 12:31:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7MCNnH6051591;
        Thu, 22 Aug 2019 12:31:33 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2uh83q0uxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Aug 2019 12:31:33 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7MCVNQI022232;
        Thu, 22 Aug 2019 12:31:27 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 22 Aug 2019 05:31:23 -0700
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
To:     dario.faggioli@linux.it, Peter Zijlstra <peterz@infradead.org>
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <20190712114458.GU3402@hirez.programming.kicks-ass.net>
 <1f97f1d9-d209-f2ab-406d-fac765006f91@oracle.com>
 <20190712123653.GO3419@hirez.programming.kicks-ass.net>
 <b1b7f85f-dac3-80a3-c05c-160f58716ce8@oracle.com>
 <20190712130720.GQ3419@hirez.programming.kicks-ass.net>
 <8b84ac05-f639-b708-0f7f-810935b323e8@oracle.com>
 <715155f37708852ea8075190aeb4f2ec9ab158fe.camel@gmail.com>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <062d7de5-2061-f7a6-acf9-8e7f50b78e29@oracle.com>
Date:   Thu, 22 Aug 2019 14:31:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <715155f37708852ea8075190aeb4f2ec9ab158fe.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908220134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9355 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908220134
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/31/19 6:31 PM, Dario Faggioli wrote:
> Hello all,
> 
> I know this is a bit of an old thread, so apologies for being late to
> the party. :-)

And sorry for the late reply, I was away for a while.

> I would have a question about this:
> 
>>>> On 7/12/19 2:36 PM, Peter Zijlstra wrote:
>>>>> On Fri, Jul 12, 2019 at 02:17:20PM +0200, Alexandre Chartre
>>>>> wrote:
>>>>>> On 7/12/19 1:44 PM, Peter Zijlstra wrote:
>>>>>>> AFAIK3 this wants/needs to be combined with core-scheduling
>>>>>>> to be
>>>>>>> useful, but not a single mention of that is anywhere.
>>>>>>
>>>>>> No. This is actually an alternative to core-scheduling.
>>>>>> Eventually, ASI
>>>>>> will kick all sibling hyperthreads when exiting isolation and
>>>>>> it needs to
>>>>>> run with the full kernel page-table (note that's currently
>>>>>> not in these
>>>>>> patches).
>>
> I.e., about the fact that ASI is presented as an alternative to
> core-scheduling or, at least, as it will only need integrate a small
> subset of the logic (and of the code) from core-scheduling, as said
> here:
> 
>> I haven't looked at details about what has been done so far.
>> Hopefully, we
>> can do something not too complex, or reuse a (small) part of co-
>> scheduling.
>>
> Now, sticking to virtualization examples, if you don't have core-
> scheduling, it means that you can have two vcpus, one from VM A and the
> other from VM B, running on the same core, one on thread 0 and the
> other one on thread 1, at the same time.
> 
> And if VM A's vcpu, running on thread 0, exits, then VM B's vcpu
> running in guest more on thread 1 can read host memory, as it is
> speculatively accessed (either "normally" or because of cache load
> gadgets) and brought in L1D cache by thread 0. And Indeed I do see how
> ASI protects us from this attack scenario.
> 
>
> However, when the two VMs' vcpus are both running in guest mode, each
> one on a thread of the same core, VM B's vcpu running on thread 1 can
> exploit L1TF to peek at and steal secrets that VM A's vcpu, running on
> thread 0, is accessing, as they're brought into L1D cache... can't it?
> 
> How can, ASI *without* core-scheduling, prevent this other attack
> scenario?
>
> Because I may very well be missing something, but it looks to me that
> it can't. In which case, I'm not sure we can call it "alternative" to
> core-scheduling.... Or is the second attack scenario that I tried to
> describe above, not considered interesting?
> 

Correct, ASI doesn't prevent this attack scenario. However, this case can
be prevented by pinning each VM to different CPU cores (for example, using
cgroups) so that you never have two different VMs running with CPU threads
from the same CPU core. Of course, this limits the number of VMs you can
run to the number of CPU cores on the system but we assume this is a
reasonable configuration when you want to have high performing VM.

Rgds,

alex.
