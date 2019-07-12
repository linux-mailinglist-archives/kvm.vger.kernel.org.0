Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358776708A
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 15:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfGLNvY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 09:51:24 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:60572 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbfGLNvX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 09:51:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CDibWT175649;
        Fri, 12 Jul 2019 13:47:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=2TNZ9h7pACCt3IUFNoHpTzTBPzs/ZEZEH8ovFfWNlCs=;
 b=GzivNqdLQWmLHwFSLtjBb5hgZ/6skpeLOc/wyZdgE7AQoBQBV9MoaP8HCyn0Wi7hbumt
 JxH7WeiTo51RSzWzU44B3FLonPUKH5xqpqIgC3wlJWl4XaHeWPGOTGtIjnYFlni6afKf
 myQRwBz8e/4VStXUb0QFP0APmdAMZuVnNoW5LjzXQD4TRRL4ZzwgdV7uCgxx8bii1rp0
 92yUiuBi3HqHraJcXxhPoXwK9Cq7ry0+yksAJSa6GrD2vE6xfGbrPYlLMIlEvnnCyrBH
 A5XhGaFnpC0uPUql8SL+zUGGqo6SEEhI1vUaL2dKvqd7iWj9wy+otuieM78IwgJklx1p cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2tjkkq5pv4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 13:47:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CDlS8M011118;
        Fri, 12 Jul 2019 13:47:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tmwgysgmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 13:47:51 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6CDloOS026847;
        Fri, 12 Jul 2019 13:47:50 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 06:46:30 -0700
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
To:     Peter Zijlstra <peterz@infradead.org>
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
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <8b84ac05-f639-b708-0f7f-810935b323e8@oracle.com>
Date:   Fri, 12 Jul 2019 15:46:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190712130720.GQ3419@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120148
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/12/19 3:07 PM, Peter Zijlstra wrote:
> On Fri, Jul 12, 2019 at 02:47:23PM +0200, Alexandre Chartre wrote:
>> On 7/12/19 2:36 PM, Peter Zijlstra wrote:
>>> On Fri, Jul 12, 2019 at 02:17:20PM +0200, Alexandre Chartre wrote:
>>>> On 7/12/19 1:44 PM, Peter Zijlstra wrote:
>>>
>>>>> AFAIK3 this wants/needs to be combined with core-scheduling to be
>>>>> useful, but not a single mention of that is anywhere.
>>>>
>>>> No. This is actually an alternative to core-scheduling. Eventually, ASI
>>>> will kick all sibling hyperthreads when exiting isolation and it needs to
>>>> run with the full kernel page-table (note that's currently not in these
>>>> patches).
>>>>
>>>> So ASI can be seen as an optimization to disabling hyperthreading: instead
>>>> of just disabling hyperthreading you run with ASI, and when ASI can't preserve
>>>> isolation you will basically run with a single thread.
>>>
>>> You can't do that without much of the scheduler changes present in the
>>> core-scheduling patches.
>>>
>>
>> We hope we can do that without the whole core-scheduling mechanism. The idea
>> is to send an IPI to all sibling hyperthreads. This IPI will interrupt these
>> sibling hyperthreads and have them wait for a condition that will allow them
>> to resume execution (for example when re-entering isolation). We are
>> investigating this in parallel to ASI.
> 
> You cannot wait from IPI context, so you have to go somewhere else to
> wait.
> 
> Also, consider what happens when the task that entered isolation decides
> to schedule out / gets migrated.
> 
> I think you'll quickly find yourself back at core-scheduling.
> 

I haven't looked at details about what has been done so far. Hopefully, we
can do something not too complex, or reuse a (small) part of co-scheduling.

Thanks for pointing this out.

alex.
