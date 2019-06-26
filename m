Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC79B57170
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 21:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbfFZTTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 15:19:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50173 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbfFZTTg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 15:19:36 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgDS6-0004EZ-AY; Wed, 26 Jun 2019 21:19:30 +0200
Date:   Wed, 26 Jun 2019 21:19:29 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Raslan, KarimAllah" <karahmed@amazon.de>
cc:     "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kernellwp@gmail.com" <kernellwp@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>
Subject: Re: cputime takes cstate into consideration
In-Reply-To: <1561575336.25880.7.camel@amazon.de>
Message-ID: <alpine.DEB.2.21.1906262115530.32342@nanos.tec.linutronix.de>
References: <CANRm+Cyge6viybs63pt7W-cRdntx+wfyOq5EWE2qmEQ71SzMHg@mail.gmail.com>  <alpine.DEB.2.21.1906261211410.32342@nanos.tec.linutronix.de>  <20190626145413.GE6753@char.us.oracle.com>  <20190626161608.GM3419@hirez.programming.kicks-ass.net> 
 <20190626183016.GA16439@char.us.oracle.com>  <alpine.DEB.2.21.1906262038040.32342@nanos.tec.linutronix.de> <1561575336.25880.7.camel@amazon.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-1322792470-1561576770=:32342"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1322792470-1561576770=:32342
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 26 Jun 2019, Raslan, KarimAllah wrote:
> On Wed, 2019-06-26 at 20:41 +0200, Thomas Gleixner wrote:
> > The host doesn't know what the guest CPUs are doing. And if you have a full
> > zero exit setup and the guest is computing stuff or doing that network
> > offloading thing then they will notice the 100/s vmexits and complain.
> 
> If the host is completely in no_full_hz mode and the pCPU is dedicated to a 
> single vCPU/task (and the guest is 100% CPU bound and never exits), you would 
> still be ticking in the host once every second for housekeeping, right? Would 
> not updating the mwait-time once a second be enough here?

It maybe that it 'still' does that, but the goal is to fix that by doing
remote accounting. I think Frederic is pretty close to that.

Then your 'lets do accounting' on the housekeeping tick falls apart.

And even with that tick every second, the nohz full people take every
shortcut to go back into the guest ASAP. Doing a dozen MSR reads will
surely not find many enthusiastic supporters.

Thanks,

	tglx


--8323329-1322792470-1561576770=:32342--
