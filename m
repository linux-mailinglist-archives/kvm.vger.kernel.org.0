Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54B9623BF9
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 17:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388127AbfETPXh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 11:23:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731389AbfETPXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 11:23:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4C1EBC02938A;
        Mon, 20 May 2019 15:23:32 +0000 (UTC)
Received: from amt.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2636061D13;
        Mon, 20 May 2019 15:23:27 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 1361F10518C;
        Mon, 20 May 2019 09:49:48 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x4KCnihw003938;
        Mon, 20 May 2019 09:49:44 -0300
Date:   Mon, 20 May 2019 09:49:44 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
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
Message-ID: <20190520124940.GB3800@amt.cnet>
References: <20190517174857.GA8611@amt.cnet>
 <fd5caf49-6d98-4887-0052-ccbc999fc077@redhat.com>
 <a584d271-8a0b-25f8-bf3b-ef1a177220bb@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a584d271-8a0b-25f8-bf3b-ef1a177220bb@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 20 May 2019 15:23:37 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 02:07:09PM +0200, Christian Borntraeger wrote:
> 
> 
> On 20.05.19 13:51, Paolo Bonzini wrote:
> > On 17/05/19 19:48, Marcelo Tosatti wrote:
> >>
> >> The cpuidle_kvm driver allows the guest vcpus to poll for a specified
> >> amount of time before halting. This provides the following benefits
> >> to host side polling:
> >>
> >> 	1) The POLL flag is set while polling is performed, which allows
> >> 	   a remote vCPU to avoid sending an IPI (and the associated
> >>  	   cost of handling the IPI) when performing a wakeup.
> >>
> >> 	2) The HLT VM-exit cost can be avoided.
> >>
> >> The downside of guest side polling is that polling is performed
> >> even with other runnable tasks in the host.
> >>
> >> Results comparing halt_poll_ns and server/client application
> >> where a small packet is ping-ponged:
> >>
> >> host                                        --> 31.33	
> >> halt_poll_ns=300000 / no guest busy spin    --> 33.40	(93.8%)
> >> halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73	(95.7%)
> >>
> >> For the SAP HANA benchmarks (where idle_spin is a parameter 
> >> of the previous version of the patch, results should be the
> >> same):
> >>
> >> hpns == halt_poll_ns
> >>
> >>                           idle_spin=0/   idle_spin=800/	   idle_spin=0/
> >> 			  hpns=200000    hpns=0            hpns=800000
> >> DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78	  (+1%)
> >> InsertC16T02 (100 thread) 2.14     	 2.07 (-3%)        2.18   (+1.8%)
> >> DeleteC00T01 (1 thread)   1.34 		 1.28 (-4.5%)	   1.29   (-3.7%)
> >> UpdateC00T03 (1 thread)	  4.72		 4.18 (-12%)	   4.53   (-5%)
> > 
> > Hi Marcelo,
> > 
> > some quick observations:
> > 
> > 1) This is actually not KVM-specific, so the name and placement of the
> > docs should be adjusted.
> > 
> > 2) Regarding KVM-specific code, however, we could add an MSR so that KVM
> > disables halt_poll_ns for this VM when this is active in the guest?
> 
> The whole code looks pretty much architecture independent. I have also seen cases
> on s390 where this kind of code would make sense. Can we try to make this
> usable for other archs as well?

Will move to drivers/cpuidle/

