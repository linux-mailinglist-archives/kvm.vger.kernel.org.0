Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5410F66F3B
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 14:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfGLMyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 08:54:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33476 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727014AbfGLMyC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 08:54:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CCnDU5044556;
        Fri, 12 Jul 2019 12:51:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=8vLEs/JBMWlFWXGIz+UNcNz5pVXTEU4KP1e0LBWVMWA=;
 b=NX3566Q5oHi6CcoRFVXeDCUAd2SUixaEFsGt/kWj+xlLRBG3Q0bb+0+ZcHXax9tbOrma
 jOavemz+RkRm9sLFEAI2a1//NAu+YVa9CqE9l4XddjHl4H+J2Iza83IToF7sZlPa5Jl1
 R5SmSPrUfve8+ZaabvSmPvKDvrGmKLnixX7lh0PGQqqrcZpGPBpouxXXYzBhAP3PsGZ9
 w0bsi8u3/mNn9/eHzLLYkLYgVSdw2Ina+tuTbPSQuew6n0ClflQVEIXepzBnHXtJjz1y
 2qSJiTotkYAYun7ywTdz/2kTzUMnJAwmiWu1PYLPMJSQcv+5VEpzK0QyM/Ec5kxuqsrz WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tjm9r5e0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 12:51:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CClhL5192025;
        Fri, 12 Jul 2019 12:51:24 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2tpefd2wwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 12:51:24 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6CCpLW1010069;
        Fri, 12 Jul 2019 12:51:21 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 05:47:27 -0700
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
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <b1b7f85f-dac3-80a3-c05c-160f58716ce8@oracle.com>
Date:   Fri, 12 Jul 2019 14:47:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190712123653.GO3419@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907120140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/12/19 2:36 PM, Peter Zijlstra wrote:
> On Fri, Jul 12, 2019 at 02:17:20PM +0200, Alexandre Chartre wrote:
>> On 7/12/19 1:44 PM, Peter Zijlstra wrote:
> 
>>> AFAIK3 this wants/needs to be combined with core-scheduling to be
>>> useful, but not a single mention of that is anywhere.
>>
>> No. This is actually an alternative to core-scheduling. Eventually, ASI
>> will kick all sibling hyperthreads when exiting isolation and it needs to
>> run with the full kernel page-table (note that's currently not in these
>> patches).
>>
>> So ASI can be seen as an optimization to disabling hyperthreading: instead
>> of just disabling hyperthreading you run with ASI, and when ASI can't preserve
>> isolation you will basically run with a single thread.
> 
> You can't do that without much of the scheduler changes present in the
> core-scheduling patches.
> 

We hope we can do that without the whole core-scheduling mechanism. The idea
is to send an IPI to all sibling hyperthreads. This IPI will interrupt these
sibling hyperthreads and have them wait for a condition that will allow them
to resume execution (for example when re-entering isolation). We are
investigating this in parallel to ASI.

alex.
