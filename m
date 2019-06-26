Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A51C571D0
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 21:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfFZTcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 15:32:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50205 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZTcl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 15:32:41 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgDem-0004av-8B; Wed, 26 Jun 2019 21:32:36 +0200
Date:   Wed, 26 Jun 2019 21:32:35 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Raslan, KarimAllah" <karahmed@amazon.de>
cc:     "peterz@infradead.org" <peterz@infradead.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
Subject: Re: cputime takes cstate into consideration
In-Reply-To: <1561577254.25880.15.camel@amazon.de>
Message-ID: <alpine.DEB.2.21.1906262129200.32342@nanos.tec.linutronix.de>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>  <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>  <20190626145413.GE6753@char.us.oracle.com>  <20190626161608.GM3419@hirez.programming.kicks-ass.net> 
 <20190626183016.GA16439@char.us.oracle.com>  <alpine.DEB.2.21.1906262038040.32342@nanos.tec.linutronix.de>  <1561575336.25880.7.camel@amazon.de>  <20190626192100.GP3419@hirez.programming.kicks-ass.net> <1561577254.25880.15.camel@amazon.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-596458942-1561577556=:32342"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-596458942-1561577556=:32342
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 26 Jun 2019, Raslan, KarimAllah wrote:
> On Wed, 2019-06-26 at 21:21 +0200, Peter Zijlstra wrote:
> > On Wed, Jun 26, 2019 at 06:55:36PM +0000, Raslan, KarimAllah wrote:
> > 
> > > 
> > > If the host is completely in no_full_hz mode and the pCPU is dedicated to a 
> > > single vCPU/task (and the guest is 100% CPU bound and never exits), you would 
> > > still be ticking in the host once every second for housekeeping, right? Would 
> > > not updating the mwait-time once a second be enough here?
> > 
> > People are trying very hard to get rid of that remnant tick. Lets not
> > add dependencies to it.
> > 
> > IMO this is a really stupid issue, 100% time is correct if the guest
> > does idle in pinned vcpu mode.
> 
> One use case for proper accounting (obviously for a slightly relaxed definition 
> or *proper*) is *external* monitoring of CPU utilization for scaling group
> (i.e. more VMs will be launched when you reach a certain CPU utilization).
> These external monitoring tools needs to account CPU utilization properly.

Then you need a trusted cooperative guest and that can give you the
information. If it doesn't, then either do not give him MWAIT or the scheme
does not work.

If you can afford to waste performance counters for that, you can do that
from user space.

There are lots of options, but the kernel won't chose one because it's
guaranteed to be the wrong choice for most scenarios.

Thanks,

	tglx
--8323329-596458942-1561577556=:32342--
