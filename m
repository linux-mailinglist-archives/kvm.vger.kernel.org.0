Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD33B5C5B7
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 00:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfGAWlx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 18:41:53 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42414 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfGAWlx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jul 2019 18:41:53 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hi4zV-0004Dh-BP; Tue, 02 Jul 2019 00:41:41 +0200
Date:   Tue, 2 Jul 2019 00:41:40 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Rong Chen <rong.a.chen@intel.com>
cc:     Feng Tang <feng.tang@intel.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "tipbuild@zytor.com" <tipbuild@zytor.com>,
        "lkp@01.org" <lkp@01.org>, Ingo Molnar <mingo@kernel.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: [BUG] kvm: APIC emulation problem - was Re: [LKP] [x86/hotplug]
 ...
In-Reply-To: <d08d55c5-bb02-f832-4306-9daf234428a8@intel.com>
Message-ID: <alpine.DEB.2.21.1907012011460.1802@nanos.tec.linutronix.de>
References: <alpine.DEB.2.21.1906250821220.32342@nanos.tec.linutronix.de> <f5c36f89-61bf-a82e-3d3b-79720b2da2ef@intel.com> <alpine.DEB.2.21.1906251330330.32342@nanos.tec.linutronix.de> <20190628063231.GA7766@shbuild999.sh.intel.com>
 <alpine.DEB.2.21.1906280929010.32342@nanos.tec.linutronix.de> <alpine.DEB.2.21.1906290912390.1802@nanos.tec.linutronix.de> <alpine.DEB.2.21.1906301334290.1802@nanos.tec.linutronix.de> <20190630130347.GB93752@shbuild999.sh.intel.com>
 <alpine.DEB.2.21.1906302021320.1802@nanos.tec.linutronix.de> <alpine.DEB.2.21.1907010829590.1802@nanos.tec.linutronix.de> <20190701083654.GB12486@shbuild999.sh.intel.com> <alpine.DEB.2.21.1907011123220.1802@nanos.tec.linutronix.de>
 <d08d55c5-bb02-f832-4306-9daf234428a8@intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Folks,

after chasing a 0-day test failure for a couple of days, I was finally able
to reproduce the issue.

Background:

   In preparation of supporting IPI shorthands I changed the CPU offline
   code to software disable the local APIC instead of just masking it.
   That's done by clearing the APIC_SPIV_APIC_ENABLED bit in the APIC_SPIV
   register.

Failure:

   When the CPU comes back online the startup code triggers occasionally
   the warning in apic_pending_intr_clear(). That complains that the IRRs
   are not empty.

   The offending vector is the local APIC timer vector who's IRR bit is set
   and stays set.

It took me quite some time to reproduce the issue locally, but now I can
see what happens.

It requires apicv_enabled=0, i.e. full apic emulation. With apicv_enabled=1
(and hardware support) it behaves correctly.

Here is the series of events:

    Guest CPU

    goes down

      native_cpu_disable()		

	apic_soft_disable();

    play_dead()

    ....

    startup()

      if (apic_enabled())
        apic_pending_intr_clear()	<- Not taken

     enable APIC

        apic_pending_intr_clear()	<- Triggers warning because IRR is stale

When this happens then the deadline timer or the regular APIC timer -
happens with both, has fired shortly before the APIC is disabled, but the
interrupt was not serviced because the guest CPU was in an interrupt
disabled region at that point.

The state of the timer vector ISR/IRR bits:

    	     	       	      ISR     IRR
before apic_soft_disable()    0	      1
after apic_soft_disable()     0	      1

On startup		      0	      1

Now one would assume that the IRR is cleared after the INIT reset, but this
happens only on CPU0.

Why?

Because our CPU0 hotplug is just for testing to make sure nothing breaks
and goes through an NMI wakeup vehicle because INIT would send it through
the boots-trap code which is not really working if that CPU was not
physically unplugged.

Now looking at a real world APIC the situation in that case is:

    	     	       	      ISR     IRR
before apic_soft_disable()    0	      1
after apic_soft_disable()     0	      1

On startup		      0	      0

Why?

Once the dying CPU reenables interrupts the pending interrupt gets
delivered as a spurious interupt and then the state is clear.

While that CPU0 hotplug test case is surely an esoteric issue, the APIC
emulation is still wrong, Even if the play_dead() code would not enable
interrupts then the pending IRR bit would turn into an ISR .. interrupt
when the APIC is reenabled on startup.

Thanks,

	tglx

 




	
     
    
   
