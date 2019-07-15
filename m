Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB7F68515
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 10:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729303AbfGOIY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 04:24:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42146 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfGOIY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 04:24:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6F8Islg030262;
        Mon, 15 Jul 2019 08:23:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=LW+DBcVS9oyDDsJmOLra8xpi1dc7wYTn6BTkn7k6LvI=;
 b=fOaRolnv2ZDHS2Exy04imAS1bU4vFOS2IeLppcGLAZkthhxkzSW6YdtEtRK+VZ/1t8g+
 mWzdx/PrPqsIMT1rfzyRzlNqddFnczL0HhEOt6OzP7q0VZRxTVUqr4J/XGjuF4Mb/J60
 A/e69AKDT8tUutMIQInJOg2qlFg48tthoFbqB6VSECx/ReHIJRSH//zDKamV4Jw3VNXl
 Eh4enfETBToLntLjAHw2KXs6FoY0zNmI4BNmHT+Od2T7T75axmFBiM9WOwU6bQAY6p4e
 NsrTusUAhJuR8clrtGBTOzr0MNHu2LsBV+c7HXr3g++51RazT4d/4hbRNUrsK0tdhzMC yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tq6qtd21w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 08:23:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6F8MeFM123723;
        Mon, 15 Jul 2019 08:23:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tq6mm59ea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 08:23:23 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6F8NKm2017595;
        Mon, 15 Jul 2019 08:23:20 GMT
Received: from [10.166.106.34] (/10.166.106.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 01:23:19 -0700
Subject: Re: [RFC v2 00/27] Kernel Address Space Isolation
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
 <alpine.DEB.2.21.1907121459180.1788@nanos.tec.linutronix.de>
 <3ca70237-bf8e-57d9-bed5-bc2329d17177@oracle.com>
 <alpine.DEB.2.21.1907122059430.1669@nanos.tec.linutronix.de>
From:   Alexandre Chartre <alexandre.chartre@oracle.com>
Organization: Oracle Corporation
Message-ID: <fd98f388-1080-ff9e-1f9a-b089272c0037@oracle.com>
Date:   Mon, 15 Jul 2019 10:23:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1907122059430.1669@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9318 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907150099
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9318 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907150099
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/12/19 9:48 PM, Thomas Gleixner wrote:
> On Fri, 12 Jul 2019, Alexandre Chartre wrote:
>> On 7/12/19 5:16 PM, Thomas Gleixner wrote:
>>> On Fri, 12 Jul 2019, Peter Zijlstra wrote:
>>>> On Fri, Jul 12, 2019 at 01:56:44PM +0200, Alexandre Chartre wrote:
>>>> And then we've fully replaced PTI.
>>>>
>>>> So no, they're not orthogonal.
>>>
>>> Right. If we decide to expose more parts of the kernel mappings then that's
>>> just adding more stuff to the existing user (PTI) map mechanics.
>>   
>> If we expose more parts of the kernel mapping by adding them to the existing
>> user (PTI) map, then we only control the mapping of kernel sensitive data but
>> we don't control user mapping (with ASI, we exclude all user mappings).
> 
> What prevents you from adding functionality to do so to the PTI
> implementation? Nothing.
> 
> Again, the underlying concept is exactly the same:
> 
>    1) Create a restricted mapping from an existing mapping
> 
>    2) Switch to the restricted mapping when entering a particular execution
>       context
> 
>    3) Switch to the unrestricted mapping when leaving that execution context
> 
>    4) Keep track of the state
> 
> The restriction scope is different, but that's conceptually completely
> irrelevant. It's a detail which needs to be handled at the implementation
> level.
> 
> What matters here is the concept and because the concept is the same, this
> needs to share the infrastructure for #1 - #4.
> 

You are totally right, that's the same concept (page-table creation and switching),
it is just used in different contexts. Sorry it took me that long to realize it,
I was too focus on the use case.


> It's obvious that this requires changes to the way PTI works today, but
> anything which creates a parallel implementation of any part of the above
> #1 - #4 is not going anywhere.
> 
> This stuff is way too sensitive and has pretty well understood limitations
> and corner cases. So it needs to be designed from ground up to handle these
> proper. Which also means, that the possible use cases are going to be
> limited.
>
> As I said before, come up with a list of possible usage scenarios and
> protection scopes first and please take all the ideas other people have
> with this into account. This includes PTI of course.
> 
> Once we have that we need to figure out whether these things can actually
> coexist and do not contradict each other at the semantical level and
> whether the outcome justifies the resulting complexity.
> 
> After that we can talk about implementation details.

Right, that makes perfect sense. I think so far we have the following scenarios:

  - PTI
  - KVM (i.e. VMExit handler isolation)
  - maybe some syscall isolation?

I will look at them in more details, in particular what particular mappings they
need and when they need to switch mappings.


And thanks for putting me back on the right track.


alex.

> This problem is not going to be solved with handwaving and an ad hoc
> implementation which creates more problems than it solves.
> 
> Thanks,
> 
> 	tglx
> 
