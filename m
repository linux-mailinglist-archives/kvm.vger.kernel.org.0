Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318C31FB7A
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 22:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfEOU0o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 16:26:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52372 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfEOU0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 16:26:43 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 51A3BC05D266;
        Wed, 15 May 2019 20:26:43 +0000 (UTC)
Received: from amt.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 88EDC1001DE1;
        Wed, 15 May 2019 20:26:40 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 89F41105183;
        Wed, 15 May 2019 17:26:24 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x4FKQKTh010444;
        Wed, 15 May 2019 17:26:20 -0300
Date:   Wed, 15 May 2019 17:26:20 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        kvm-devel <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Bandan Das <bsd@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sched: introduce configurable delay before entering idle
Message-ID: <20190515202618.GA31128@amt.cnet>
References: <20190507185647.GA29409@amt.cnet>
 <CANRm+Cx8zCDG6Oz1m9eukkmx_uVFYcQOdMwZrHwsQcbLm_kuPA@mail.gmail.com>
 <20190514135022.GD4392@amt.cnet>
 <20190514152015.GM20906@char.us.oracle.com>
 <20190514174235.GA12269@amt.cnet>
 <CANRm+CytV7PfS++RnYU0P3HT_QBufrO=bzd6Fx-7dC2=sotvmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANRm+CytV7PfS++RnYU0P3HT_QBufrO=bzd6Fx-7dC2=sotvmA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 15 May 2019 20:26:43 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 15, 2019 at 09:42:48AM +0800, Wanpeng Li wrote:
> On Wed, 15 May 2019 at 02:20, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> >
> > On Tue, May 14, 2019 at 11:20:15AM -0400, Konrad Rzeszutek Wilk wrote:
> > > On Tue, May 14, 2019 at 10:50:23AM -0300, Marcelo Tosatti wrote:
> > > > On Mon, May 13, 2019 at 05:20:37PM +0800, Wanpeng Li wrote:
> > > > > On Wed, 8 May 2019 at 02:57, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > > > > >
> > > > > >
> > > > > > Certain workloads perform poorly on KVM compared to baremetal
> > > > > > due to baremetal's ability to perform mwait on NEED_RESCHED
> > > > > > bit of task flags (therefore skipping the IPI).
> > > > >
> > > > > KVM supports expose mwait to the guest, if it can solve this?
> > > > >
> > > > > Regards,
> > > > > Wanpeng Li
> > > >
> > > > Unfortunately mwait in guest is not feasible (uncompatible with multiple
> > > > guests). Checking whether a paravirt solution is possible.
> > >
> > > There is the obvious problem with that the guest can be malicious and
> > > provide via the paravirt solution bogus data. That is it expose 0% CPU
> > > usage but in reality be mining and using 100%.
> >
> > The idea is to have a hypercall for the guest to perform the
> > need_resched=1 bit set. It can only hurt itself.
> 
> This lets me recall the patchset from aliyun
> https://lkml.org/lkml/2017/6/22/296 

Thanks for the pointer.

"The background is that we(Alibaba Cloud) do get more and more
complaints from our customers in both KVM and Xen compare to bare-mental.
After investigations, the root cause is known to us: big cost in message 
passing workload(David show it in KVM forum 2015) 

A typical message workload like below: 
vcpu 0                             vcpu 1 
1. send ipi                     2.  doing hlt 
3. go into idle                 4.  receive ipi and wake up from hlt 
5. write APIC time twice        6.  write APIC time twice to 
    to stop sched timer              reprogram sched timer 
7. doing hlt                    8.  handle task and send ipi to 
                                     vcpu 0 
9. same to 4.                   10. same to 3"

This is very similar to the client/server example pair 
included in the first message.

 
> They poll after
> __current_set_polling() in do_idle() so avoid this hypercall I think.

Yes, i was thinking about a variant without poll.

> Btw, do you get SAP HANA by 5-10% bonus even if adaptive halt-polling
> is enabled?

host			   = 31.18 
halt_poll_ns set to 200000 = 38.55	(80%)
halt_poll_ns set to 300000 = 33.28	(93%)
idle_spin set to 220000 = 32.22 	(96%)

So avoiding the IPI VM-exits is faster. 

300000 is the optimal value vfor this workload. Haven't checked
adaptive halt-polling.

