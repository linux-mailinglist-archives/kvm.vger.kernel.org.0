Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4554226699
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 17:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729723AbfEVPFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 11:05:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45030 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728466AbfEVPFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 11:05:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 89C6B19CBA4;
        Wed, 22 May 2019 15:05:24 +0000 (UTC)
Received: from amt.cnet (ovpn-112-15.gru2.redhat.com [10.97.112.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BACE60857;
        Wed, 22 May 2019 15:05:20 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id ABF5110518F;
        Wed, 22 May 2019 12:05:02 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x4MF4tlt002677;
        Wed, 22 May 2019 12:04:55 -0300
Date:   Wed, 22 May 2019 12:04:54 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: Re: [PATCH] x86: add cpuidle_kvm driver to allow guest side halt
 polling
Message-ID: <20190522150451.GA2317@amt.cnet>
References: <20190517174857.GA8611@amt.cnet>
 <fd5caf49-6d98-4887-0052-ccbc999fc077@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd5caf49-6d98-4887-0052-ccbc999fc077@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 22 May 2019 15:05:39 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 01:51:57PM +0200, Paolo Bonzini wrote:
> On 17/05/19 19:48, Marcelo Tosatti wrote:
> > 
> > The cpuidle_kvm driver allows the guest vcpus to poll for a specified
> > amount of time before halting. This provides the following benefits
> > to host side polling:
> > 
> > 	1) The POLL flag is set while polling is performed, which allows
> > 	   a remote vCPU to avoid sending an IPI (and the associated
> >  	   cost of handling the IPI) when performing a wakeup.
> > 
> > 	2) The HLT VM-exit cost can be avoided.
> > 
> > The downside of guest side polling is that polling is performed
> > even with other runnable tasks in the host.
> > 
> > Results comparing halt_poll_ns and server/client application
> > where a small packet is ping-ponged:
> > 
> > host                                        --> 31.33	
> > halt_poll_ns=300000 / no guest busy spin    --> 33.40	(93.8%)
> > halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73	(95.7%)
> > 
> > For the SAP HANA benchmarks (where idle_spin is a parameter 
> > of the previous version of the patch, results should be the
> > same):
> > 
> > hpns == halt_poll_ns
> > 
> >                           idle_spin=0/   idle_spin=800/	   idle_spin=0/
> > 			  hpns=200000    hpns=0            hpns=800000
> > DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78	  (+1%)
> > InsertC16T02 (100 thread) 2.14     	 2.07 (-3%)        2.18   (+1.8%)
> > DeleteC00T01 (1 thread)   1.34 		 1.28 (-4.5%)	   1.29   (-3.7%)
> > UpdateC00T03 (1 thread)	  4.72		 4.18 (-12%)	   4.53   (-5%)
> 
> Hi Marcelo,
> 
> some quick observations:
> 
> 1) This is actually not KVM-specific, so the name and placement of the
> docs should be adjusted.
> 
> 2) Regarding KVM-specific code, however, we could add an MSR so that KVM
> disables halt_poll_ns for this VM when this is active in the guest?
> 
> 3) The spin time could use the same adaptive algorithm that KVM uses in
> the host.

Hi Paolo,

Consider sequence of wakeup events as follows:
20us, 200us, 20us, 200us...

1) halt_poll_ns=250us   v->halt_poll_ns=0us     wakeup=20us

grow sets v->halt_poll_ns = 20us

2) halt_poll_ns=250us   v->halt_poll_ns=20us     wakeup=200us

grow sets v->halt_poll_ns = 40us

3) halt_poll_ns=250us   v->halt_poll_ns=40us     wakeup=20us

v->halt_poll_ns untouched

Doubling repeats until

v->halt_poll_ns=80, 160, 250us.

N) halt_poll_ns=250us   v->halt_poll_ns=250us   wakeup=20us

If in the middle of the 20us,200us,20us... sequence you block
for a value larger than halt_poll_ns (250 in this case),
the logic today will either:

        1) set v->halt_poll_ns to zero.

        2) set halt_poll_ns to 125us (if you set shrink to 2).

In either case, you lose (one missed event any time
block_time > halt_poll_ns).

If one enables guest halt polling in the first place,
then the energy/performance tradeoff is bend towards
performance, and such misses are harmful.

So going to add something along the lines of:

"If, after 50 consecutive times, block_time is much larger than
halt_poll_ns, then set cpu->halt_poll_ns to zero".

Restore user halt_poll_ns value once one smaller block_time
is observed.

This should cover the full idle case, and cause minimal
harm to performance.

Is that OK or is there any other characteristic of
adaptive halt poll you are looking for?


