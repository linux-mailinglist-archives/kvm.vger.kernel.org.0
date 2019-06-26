Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83B6F57098
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 20:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbfFZSbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 14:31:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36874 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZSbi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 14:31:38 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QIUCIg023435;
        Wed, 26 Jun 2019 18:30:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=PWK8zgZUc1duSqq0sBFI2rltZ5c+K251lGC1vdXqBck=;
 b=R6geli0BVLzmP6AdHRxxu6FMDyEju3vwc4GI5j4640rFHmJ+7YPqLc7I8XMq1tQKtxoL
 4DoK68aOg4jhzMHS0mvD37WuHmWIDVkXUu19lenYA2FL74gaf9Ns295jxQXBahbHrYgP
 osiHytC/xL9mldAUYpbf6D6R5upLiR7zDeue5Zg82ef2eIh7E8dPVOhUih2+gKHE/+qs
 M+hIDr99Mpx0YdpT5VQX54nY+oRSAj6ROcKRRkZ4U224irYYZ1D6KzCqHViDi2D0U30x
 qPlFdsHZF/60z7a0M0zmeuCPg3xqHXqxQESTQ9jSu71ZdyqsO4sJ19WJxJ3M/17QQSpo ww== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t9c9pv1mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 18:30:56 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5QISuJ0094373;
        Wed, 26 Jun 2019 18:28:56 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2t9p6ux4ns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jun 2019 18:28:56 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5QISqnp000865;
        Wed, 26 Jun 2019 18:28:53 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Jun 2019 11:28:52 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id 142646A0150; Wed, 26 Jun 2019 14:30:16 -0400 (EDT)
Date:   Wed, 26 Jun 2019 14:30:16 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KarimAllah <karahmed@amazon.de>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Subject: Re: cputime takes cstate into consideration
Message-ID: <20190626183016.GA16439@char.us.oracle.com>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>
 <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>
 <20190626145413.GE6753@char.us.oracle.com>
 <20190626161608.GM3419@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626161608.GM3419@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260213
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9300 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260214
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 26, 2019 at 06:16:08PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 26, 2019 at 10:54:13AM -0400, Konrad Rzeszutek Wilk wrote:
> > On Wed, Jun 26, 2019 at 12:33:30PM +0200, Thomas Gleixner wrote:
> > > On Wed, 26 Jun 2019, Wanpeng Li wrote:
> > > > After exposing mwait/monitor into kvm guest, the guest can make
> > > > physical cpu enter deeper cstate through mwait instruction, however,
> > > > the top command on host still observe 100% cpu utilization since qemu
> > > > process is running even though guest who has the power management
> > > > capability executes mwait. Actually we can observe the physical cpu
> > > > has already enter deeper cstate by powertop on host. Could we take
> > > > cstate into consideration when accounting cputime etc?
> > > 
> > > If MWAIT can be used inside the guest then the host cannot distinguish
> > > between execution and stuck in mwait.
> > > 
> > > It'd need to poll the power monitoring MSRs on every occasion where the
> > > accounting happens.
> > > 
> > > This completely falls apart when you have zero exit guest. (think
> > > NOHZ_FULL). Then you'd have to bring the guest out with an IPI to access
> > > the per CPU MSRs.
> > > 
> > > I assume a lot of people will be happy about all that :)
> > 
> > There were some ideas that Ankur (CC-ed) mentioned to me of using the perf
> > counters (in the host) to sample the guest and construct a better
> > accounting idea of what the guest does. That way the dashboard
> > from the host would not show 100% CPU utilization.
> 
> But then you generate extra noise and vmexits on those cpus, just to get
> this accounting sorted, which sounds like a bad trade.

Considering that the CPUs aren't doing anything and if you do say the 
IPIs "only" 100/second - that would be so small but give you a big benefit
in properly accounting the guests.

But perhaps there are other ways too to "snoop" if a guest is sitting on
an MWAIT?

