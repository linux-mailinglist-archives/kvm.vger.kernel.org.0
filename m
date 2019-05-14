Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7777A1CBB7
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 17:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfENPUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 11:20:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:47472 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfENPUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 11:20:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4EFItQ9026749;
        Tue, 14 May 2019 15:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=TAKl7MVPjAyeW4pysbmsSHellOYUJq5rtojHmkQ8ztM=;
 b=IT5FIib4qMNUvf3xltPxmxaRRwANwyP/z12rU6yPZXdhhETRaPilGrFbg0o+KtneSXn7
 kk7cM/yIRL9Hx29OoROgWdRsP2F7m4G7dQminqB9w6jCo6orHLP93besbXIw1dnFSHLs
 XrFy9n4Rhcvr4TLSqTgR/uquEP/1BrdxrPnznS8gj0XhC6EcHzlqrk0ZqqJf7lIuCzGE
 nE3QlU4i4lK6FclhmRddDQ9ZK01sd9cBvCKT35Q/h+1NRj3In0g1yG8HTyFNsmjLYuN8
 pWAtuhVln9NOjzlPlAgdQpmF5bnN+9Z0teSc2aKJn2rzKiZxbYdLb2hLWWc5p19OcTPf xQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2sdnttptps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 15:20:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4EFJHbp053648;
        Tue, 14 May 2019 15:20:10 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2sdmeb4ynx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 15:20:10 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x4EFK9WY018964;
        Tue, 14 May 2019 15:20:10 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 May 2019 08:20:09 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id EA8AB6A010B; Tue, 14 May 2019 11:20:15 -0400 (EDT)
Date:   Tue, 14 May 2019 11:20:15 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, kvm-devel <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
Message-ID: <20190514152015.GM20906@char.us.oracle.com>
References: <20190507185647.GA29409@amt.cnet>
 <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
 <20190514135022.GD4392@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514135022.GD4392@amt.cnet>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=679
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905140108
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9256 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=709 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905140108
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 14, 2019 at 10:50:23AM -0300, Marcelo Tosatti wrote:
> On Mon, May 13, 2019 at 05:20:37PM +0800, Wanpeng Li wrote:
> > On Wed, 8 May 2019 at 02:57, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > >
> > >
> > > Certain workloads perform poorly on KVM compared to baremetal
> > > due to baremetal's ability to perform mwait on NEED_RESCHED
> > > bit of task flags (therefore skipping the IPI).
> > 
> > KVM supports expose mwait to the guest, if it can solve this?
> > 
> > Regards,
> > Wanpeng Li
> 
> Unfortunately mwait in guest is not feasible (uncompatible with multiple
> guests). Checking whether a paravirt solution is possible.

There is the obvious problem with that the guest can be malicious and
provide via the paravirt solution bogus data. That is it expose 0% CPU
usage but in reality be mining and using 100%.

