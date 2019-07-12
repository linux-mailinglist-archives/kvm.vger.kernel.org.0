Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96D9D66CAF
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 14:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfGLMWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 08:22:20 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60876 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfGLMVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 08:21:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CC90Xl012611;
        Fri, 12 Jul 2019 12:18:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=tHy9732h8J88hlJcyQvuajeYi/Ef6ybEFYf/oRMEAZk=;
 b=CnC3slv8NBqzLVrf761MKmmJDfer7dKnuBEhQa/FXBbm2ow7JK23L0vk/WZwnvkokWMY
 y7IFxlUnVNzQKNe4p+wmxcSzG5SegxPMg9NcgXCCP3pDFFXZkzx3fc+qToYydvHE9SCN
 D2VNz+65cWxxvv46Qv72qUR6O+mtixOx4/eZrTpPz4BIfrqs2KsN0OY93rF2Onbwdv3R
 mFf1I53WjD3Zzr+o0h6RVM/7Mqhm2JZm/L6cXriU/ge5HTHpasP5ibAgh91+08zMQYZJ
 7Nb7JwQ5zG6C15DKK651VACg8j9DiArepwlkSyS76+xjwbCQ0ylHhsNxBlGDkFgi7q45 qA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tjm9r59gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 12:18:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CC88Cl186642;
        Fri, 12 Jul 2019 12:18:36 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tmwgyr9wd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 12:18:35 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6CCIXEh014480;
        Fri, 12 Jul 2019 12:18:33 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 12:17:24 +0000
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
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <1f97f1d9-d209-f2ab-406d-fac765006f91@oracle.com>
Date:   Fri, 12 Jul 2019 14:17:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190712114458.GU3402@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120133
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/12/19 1:44 PM, Peter Zijlstra wrote:
> On Thu, Jul 11, 2019 at 04:25:12PM +0200, Alexandre Chartre wrote:
>> Kernel Address Space Isolation aims to use address spaces to isolate some
>> parts of the kernel (for example KVM) to prevent leaking sensitive data
>> between hyper-threads under speculative execution attacks. You can refer
>> to the first version of this RFC for more context:
>>
>>     https://lkml.org/lkml/2019/5/13/515
> 
> No, no, no!
> 
> That is the crux of this entire series; you're not punting on explaining
> exactly why we want to go dig through 26 patches of gunk.
> 
> You get to exactly explain what (your definition of) sensitive data is,
> and which speculative scenarios and how this approach mitigates them.
> 
> And included in that is a high level overview of the whole thing.
> 

Ok, I will rework the explanation. Sorry about that.

> On the one hand you've made this implementation for KVM, while on the
> other hand you're saying it is generic but then fail to describe any
> !KVM user.
> 
> AFAIK all speculative fails this is relevant to are now public, so
> excruciating horrible details are fine and required.

Ok.

> AFAIK2 this is all because of MDS but it also helps with v1.

Yes, mostly MDS and also L1TF.

> AFAIK3 this wants/needs to be combined with core-scheduling to be
> useful, but not a single mention of that is anywhere.

No. This is actually an alternative to core-scheduling. Eventually, ASI
will kick all sibling hyperthreads when exiting isolation and it needs to
run with the full kernel page-table (note that's currently not in these
patches).

So ASI can be seen as an optimization to disabling hyperthreading: instead
of just disabling hyperthreading you run with ASI, and when ASI can't preserve
isolation you will basically run with a single thread.

I will add all that to the explanation.

Thanks,

alex.
