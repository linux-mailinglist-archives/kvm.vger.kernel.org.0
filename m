Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E63863AF1
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 20:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728676AbfGIS20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 14:28:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53378 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbfGIS20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 14:28:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69IOJ71146036;
        Tue, 9 Jul 2019 18:27:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=ZuuBmd+hn0gNy1yFa1x6CDg54lC3wgXrt5IpUQJMaw8=;
 b=lRX0A7gL0wgwbmshdLkJUR2nj6Nkv0327AL5K1+MgOC/0emwkvWtP24UtlurMRGDHP+8
 3sKCLAT/0m+YdzcMvusZtNfGFsvBPgpSVbtNF8lbJSfJzm1P9qoxZvpFjZADFI84SZ9U
 hIVeITJmHqlhA1wH8rLYqIXinP7/oAKZKrCjmb8bNmdVljnM7c+gDv6rNypd0DOp34Sa
 +r2eXShIlfFW4wHe8xtLXa2bWI4nvSoqHFSfL6XHiB3Zijd1wqGrpLbhH+lH8D3Iv7Wy
 S04ZamFBMOiywBd63+jP0fCC6yrZ505RRPJIgyAiRDiiTOBmYfEAXsDPi9L9Rc6wBQPY gA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tjk2tp0s8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 18:27:03 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69IIhwl138656;
        Tue, 9 Jul 2019 18:27:02 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tmmh3474u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 18:27:02 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x69IR19r025057;
        Tue, 9 Jul 2019 18:27:01 GMT
Received: from [10.156.75.135] (/10.156.75.135)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 11:27:01 -0700
Subject: Re: cputime takes cstate into consideration
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
 <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
 <20190626145413.GE6753@char.us.oracle.com>
 <1561575536.25880.10.camel@amazon.de>
 <alpine.DEB.2.21.1906262119430.32342@nanos.tec.linutronix.de>
 <7f721d94-aa19-20a4-6930-9ed4d1cd4834@oracle.com>
 <20190709123838.GA3402@hirez.programming.kicks-ass.net>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <a1dbbed2-17e4-89e5-d141-9c30dc352c5f@oracle.com>
Date:   Tue, 9 Jul 2019 11:27:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190709123838.GA3402@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=565
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090215
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=606 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090216
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/9/19 5:38 AM, Peter Zijlstra wrote:
> On Mon, Jul 08, 2019 at 07:00:08PM -0700, Ankur Arora wrote:
>> On 2019-06-26 12:23 p.m., Thomas Gleixner wrote:
>>> On Wed, 26 Jun 2019, Raslan, KarimAllah wrote:
>>>> On Wed, 2019-06-26 at 10:54 -0400, Konrad Rzeszutek Wilk wrote:
>>>>> There were some ideas that Ankur (CC-ed) mentioned to me of using the perf
>>>>> counters (in the host) to sample the guest and construct a better
>>>>> accounting idea of what the guest does. That way the dashboard
>>>>> from the host would not show 100% CPU utilization.
>>>>
>>>> You can either use the UNHALTED cycles perf-counter or you can use MPERF/APERF
>>>> MSRs for that. (sorry I got distracted and forgot to send the patch)
>>>
>>> Sure, but then you conflict with the other people who fight tooth and nail
>>> over every single performance counter.
>> How about using Intel PT PwrEvt extensions? This should allow us to
>> precisely track idle residency via just MWAIT and TSC packets. Should
>> be pretty cheap too. It's post Cascade Lake though.
> 
> That would fully claim PT just for this stupid accounting thing and be
> completely Intel specific.
> 
> Just stop this madness already.
I see the point about just accruing guest time (in mwait or not) as
guest CPU time.
But, to take this madness a little further, I'm not sure I see why it
fully claims PT. AFAICS, we should be able to enable PwrEvt and whatever
else simultaneously.

Ankur

> 
