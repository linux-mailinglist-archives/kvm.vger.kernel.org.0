Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCF967070
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 15:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfGLNqu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 09:46:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55252 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbfGLNqu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 09:46:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CDiTbQ090742;
        Fri, 12 Jul 2019 13:45:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dGzIhFt0u54O4Kbeh8RbIfe/e2jNby1b+/yE0CanLKw=;
 b=I3qle/iCNC7VAuoB0DAxu5j9PNjrSqNjf+rVWmK41YEKSGoN9OiSbkyAlre45qgeLtFv
 4sFAcj+k4BiPbPPjoSj6sSzja1imo4cED1Jqsw0nmu6QBA2dzTYgXG2X7jgZ0cafheoO
 EdVvD/RFeBBxmc+NVol1fI8F8zsihyoowAaasRFe4SRSr2vJSOqA9u9VNLL1AQhvwW8G
 hm7wITkGEQ8u6fMAIB8kHLrZjZLx9p3ngRzt14Z9sFLzJOmWmoreQe93CFfwMVT/FYtF
 rgBjFQcc/yzt+XhKz5ajWXfaH6vKZFK3JY+4m6C+YPeY2H4Djfjypiv+wrJp1Rb5CF6t qQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tjm9r5pmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 13:45:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6CDgnqQ001226;
        Fri, 12 Jul 2019 13:45:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2tmwgysfk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Jul 2019 13:45:24 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6CDjMYA006659;
        Fri, 12 Jul 2019 13:45:22 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 12 Jul 2019 06:43:35 -0700
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com, Paul Turner <pjt@google.com>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com>
 <5cab2a0e-1034-8748-fcbe-a17cf4fa2cd4@intel.com>
 <alpine.DEB.2.21.1907120911160.11639@nanos.tec.linutronix.de>
 <61d5851e-a8bf-e25c-e673-b71c8b83042c@oracle.com>
 <20190712125059.GP3419@hirez.programming.kicks-ass.net>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <a03db3a5-b033-a469-cc6c-c8c86fb25710@oracle.com>
Date:   Fri, 12 Jul 2019 15:43:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <20190712125059.GP3419@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9315 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907120148
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


On 7/12/19 2:50 PM, Peter Zijlstra wrote:
> On Fri, Jul 12, 2019 at 01:56:44PM +0200, Alexandre Chartre wrote:
> 
>> I think that's precisely what makes ASI and PTI different and independent.
>> PTI is just about switching between userland and kernel page-tables, while
>> ASI is about switching page-table inside the kernel. You can have ASI without
>> having PTI. You can also use ASI for kernel threads so for code that won't
>> be triggered from userland and so which won't involve PTI.
> 
> PTI is not mapping         kernel space to avoid             speculation crap (meltdown).
> ASI is not mapping part of kernel space to avoid (different) speculation crap (MDS).
> 
> See how very similar they are?
>
> 
> Furthermore, to recover SMT for userspace (under MDS) we not only need
> core-scheduling but core-scheduling per address space. And ASI was
> specifically designed to help mitigate the trainwreck just described.
> 
> By explicitly exposing (hopefully harmless) part of the kernel to MDS,
> we reduce the part that needs core-scheduling and thus reduce the rate
> the SMT siblngs need to sync up/schedule.
> 
> But looking at it that way, it makes no sense to retain 3 address
> spaces, namely:
> 
>    user / kernel exposed / kernel private.
> 
> Specifically, it makes no sense to expose part of the kernel through MDS
> but not through Meltdow. Therefore we can merge the user and kernel
> exposed address spaces.

The goal of ASI is to provide a reduced address space which exclude sensitive
data. A user process (for example a database daemon, a web server, or a vmm
like qemu) will likely have sensitive data mapped in its user address space.
Such data shouldn't be mapped with ASI because it can potentially leak to the
sibling hyperthread. For example, if an hyperthread is running a VM then the
VM could potentially access user sensitive data if they are mapped on the
sibling hyperthread with ASI.

The current approach is assuming that anything in the user address space
can be sensitive, and so the user address space shouldn't be mapped in ASI.

It looks like what you are suggesting could be an optimization when creating
an ASI for a process which has no sensitive data (this could be an option to
specify when creating an ASI, for example).

alex.

> 
> And then we've fully replaced PTI.
> 
> So no, they're not orthogonal.
> 
