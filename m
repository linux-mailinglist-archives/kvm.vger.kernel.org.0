Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D765B397E7
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 23:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731357AbfFGVjJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 17:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20046 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729731AbfFGVjI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 17:39:08 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 85F643079B83;
        Fri,  7 Jun 2019 21:39:08 +0000 (UTC)
Received: from amt.cnet (ovpn-112-16.gru2.redhat.com [10.97.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD6141001B04;
        Fri,  7 Jun 2019 21:39:05 +0000 (UTC)
Received: from amt.cnet (localhost [127.0.0.1])
        by amt.cnet (Postfix) with ESMTP id 09775105169;
        Fri,  7 Jun 2019 18:38:34 -0300 (BRT)
Received: (from marcelo@localhost)
        by amt.cnet (8.14.7/8.14.7/Submit) id x57LcUHZ028784;
        Fri, 7 Jun 2019 18:38:30 -0300
Date:   Fri, 7 Jun 2019 18:38:29 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Radim =?iso-8859-1?B?S3LEP23DocU/?= <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux PM <linux-pm@vger.kernel.org>
Subject: Re: [patch 0/3] cpuidle-haltpoll driver (v2)
Message-ID: <20190607213826.GA25364@amt.cnet>
References: <20190603225242.289109849@amt.cnet>
 <6c411948-9e32-9f41-351e-c9accd1facb0@intel.com>
 <20190607171645.GA28275@amt.cnet>
 <9c3853cc-d920-03e8-245c-86c33b280c80@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c3853cc-d920-03e8-245c-86c33b280c80@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Fri, 07 Jun 2019 21:39:08 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 07, 2019 at 08:22:35PM +0200, Paolo Bonzini wrote:
> On 07/06/19 19:16, Marcelo Tosatti wrote:
> > There is no "target residency" concept in the virtualized use-case 
> > (which is what poll_state.c uses to calculate the poll time).
> 
> Actually there is: it is the cost of a vmexit, and it be calibrated with
> a very short CPUID loop (e.g. run 100 CPUID instructions and take the
> smallest TSC interval---it should take less than 50 microseconds, and
> less than a millisecond even on nested virt).

For a given application, you want to configure the poll time to the
maximum time an event happen after starting the idle procedure. For SAP
HANA, that value is between 200us - 800us (most tests require less than
800us, but some require 800us, to significantly avoid the IPIs).

"The target residency is the minimum time the hardware must spend in the
given state, including the time needed to enter it (which may be
substantial), in order to save more energy than it would save by
entering one of the shallower idle states instead."

Clearly these are two different things...

> I think it would make sense to improve poll_state.c to use an adaptive
> algorithm similar to the one you implemented, which includes optionally
> allowing to poll for an interval larger than the target residency.
> 
> Paolo

Ok, so i'll move the adaptive code to poll_state.c, where
the driver selects whether to use target_residency or the 
adaptive value (based on module parameters).

Not sure if its an adaptible value is desirable for 
the non virtualized case.


