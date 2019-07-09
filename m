Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A356962DD4
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 04:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfGICBS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 22:01:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42352 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfGICBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 22:01:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x691xQaL151075;
        Tue, 9 Jul 2019 02:00:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=U2t+vwAtO3tIITUDeTKxOkzeYb9biWe96LNHTTtlwYk=;
 b=kTnLdxhWXDvwtHf0Z/iVaFvjD7DwuOqUOLuf4mJ1qB1ItIZtcbnOpKoiRIVqHwFClm4T
 7GuMv5ClVP9jGiJBqv9x5rT9uOidsYTpJFTZPecnJArbvIn4p2L/2qzfj3y9kGjqmkUS
 8mIXjXoF56650APDkXVFI3q3IjvcR55mTv+7I6ILqLseFFi/34pOfVXatXU094AqzOXW
 FrPNhORCg5bYsr1a9zHRxmHOW0kjm8JzPwcPghKtM7KGhBX1ycukmwSpSNVGr5TasAXl
 SNOQw97LpTInpH6hHAl4KwXNI3KjYS7hP3ekoPWMaizL7Zx8x8mct3keTPzDeFI/7DEb EA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tjm9qhdyg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 02:00:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x691wUbu105527;
        Tue, 9 Jul 2019 02:00:14 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2tjjykh0ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 02:00:14 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6920Aii004992;
        Tue, 9 Jul 2019 02:00:13 GMT
Received: from [10.159.242.95] (/10.159.242.95)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jul 2019 19:00:10 -0700
Subject: Re: cputime takes cstate into consideration
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>
Cc:     "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
 <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
 <20190626145413.GE6753@char.us.oracle.com>
 <1561575536.25880.10.camel@amazon.de>
 <alpine.DEB.2.21.1906262119430.32342@nanos.tec.linutronix.de>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <7f721d94-aa19-20a4-6930-9ed4d1cd4834@oracle.com>
Date:   Mon, 8 Jul 2019 19:00:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1906262119430.32342@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090024
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-06-26 12:23 p.m., Thomas Gleixner wrote:
> On Wed, 26 Jun 2019, Raslan, KarimAllah wrote:
>> On Wed, 2019-06-26 at 10:54 -0400, Konrad Rzeszutek Wilk wrote:
>>> There were some ideas that Ankur (CC-ed) mentioned to me of using the perf
>>> counters (in the host) to sample the guest and construct a better
>>> accounting idea of what the guest does. That way the dashboard
>>> from the host would not show 100% CPU utilization.
>>
>> You can either use the UNHALTED cycles perf-counter or you can use MPERF/APERF
>> MSRs for that. (sorry I got distracted and forgot to send the patch)
> 
> Sure, but then you conflict with the other people who fight tooth and nail
> over every single performance counter.
How about using Intel PT PwrEvt extensions? This should allow us to
precisely track idle residency via just MWAIT and TSC packets. Should
be pretty cheap too. It's post Cascade Lake though.

Ankur

> 
> Thanks,
> 
> 	tglx
> 

