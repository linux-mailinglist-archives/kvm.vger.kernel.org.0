Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82FBA416CF
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 23:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406873AbfFKVYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 17:24:53 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:33657 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388693AbfFKVYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 17:24:52 -0400
Received: by mail-ot1-f68.google.com with SMTP id p4so10158541oti.0;
        Tue, 11 Jun 2019 14:24:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uIRbwWRuO7/1ZwaraC6BCujZR3cVhI4nwmywSXcAgsE=;
        b=WqLWH32JFh35blcEsrkkIXSNKbADGNW5dzqn0v7mN1FPPG5q3J7ccbB72+0v/e/1Ev
         QbTsuroCf30YwfPy6v5+edvC7Fp/HE8ZTBIGklxIVANnybbLzgutyXaEOdLllwZ65WJg
         mJ2rO1lMmsimq9gPNZYH96fyWioWFoCp01Kd7MtkcYPn5GOeIyFZtROEVId9uo1eyNgw
         19Mt8jhSKoalZXHAvJXS0Pulru8XWoOGOZCbRMyCI2niCZdvm6anFMxZz4znofVhVmyp
         2VkDxLSCMjGptNJgMO70UElxLpJ1a5lMqgWdniN5FI2T6qRz3svKH5iLgW/z1cx/Iakq
         hNIQ==
X-Gm-Message-State: APjAAAUoS1zHZykrAFMrweqGcFX0mUyNAdy+v/yFC3voRRtHoZFCU3g9
        kWsgR3SPw7DGr7kTmNiF3upJLO2h1byMm2JXOx0=
X-Google-Smtp-Source: APXvYqwiRbWgoGewJXZNzXGtJm32eKWRtswBFrQTNgXaJJDNmyM0R10HTRvq2SYoP6P/HZcl6x8hus9nwQVpkte5e7s=
X-Received: by 2002:a9d:5e99:: with SMTP id f25mr7850901otl.262.1560288291573;
 Tue, 11 Jun 2019 14:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190603225242.289109849@amt.cnet> <6c411948-9e32-9f41-351e-c9accd1facb0@intel.com>
 <20190610145942.GA24553@amt.cnet> <CAJZ5v0idYgETFg4scgvpJ-eGtFAx1Wi6hznXz7+XZAfKjiSAPA@mail.gmail.com>
 <20190611142627.GB4791@amt.cnet>
In-Reply-To: <20190611142627.GB4791@amt.cnet>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Tue, 11 Jun 2019 23:24:39 +0200
Message-ID: <CAJZ5v0gPbSXB3r71XaT-4Q7LsiFO_UVymBwOmU8J1W5+COk_1g@mail.gmail.com>
Subject: Re: [patch 0/3] cpuidle-haltpoll driver (v2)
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LDhD9tw4PCocOFPw==?= <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 11, 2019 at 4:27 PM Marcelo Tosatti <mtosatti@redhat.com> wrote:
>
> On Tue, Jun 11, 2019 at 12:03:26AM +0200, Rafael J. Wysocki wrote:
> > On Mon, Jun 10, 2019 at 5:00 PM Marcelo Tosatti <mtosatti@redhat.com> wrote:
> > >
> > > On Fri, Jun 07, 2019 at 11:49:51AM +0200, Rafael J. Wysocki wrote:
> > > > On 6/4/2019 12:52 AM, Marcelo Tosatti wrote:
> > > > >The cpuidle-haltpoll driver allows the guest vcpus to poll for a specified
> > > > >amount of time before halting. This provides the following benefits
> > > > >to host side polling:
> > > > >
> > > > >         1) The POLL flag is set while polling is performed, which allows
> > > > >            a remote vCPU to avoid sending an IPI (and the associated
> > > > >            cost of handling the IPI) when performing a wakeup.
> > > > >
> > > > >         2) The HLT VM-exit cost can be avoided.
> > > > >
> > > > >The downside of guest side polling is that polling is performed
> > > > >even with other runnable tasks in the host.
> > > > >
> > > > >Results comparing halt_poll_ns and server/client application
> > > > >where a small packet is ping-ponged:
> > > > >
> > > > >host                                        --> 31.33
> > > > >halt_poll_ns=300000 / no guest busy spin    --> 33.40   (93.8%)
> > > > >halt_poll_ns=0 / guest_halt_poll_ns=300000  --> 32.73   (95.7%)
> > > > >
> > > > >For the SAP HANA benchmarks (where idle_spin is a parameter
> > > > >of the previous version of the patch, results should be the
> > > > >same):
> > > > >
> > > > >hpns == halt_poll_ns
> > > > >
> > > > >                           idle_spin=0/   idle_spin=800/    idle_spin=0/
> > > > >                           hpns=200000    hpns=0            hpns=800000
> > > > >DeleteC06T03 (100 thread) 1.76           1.71 (-3%)        1.78   (+1%)
> > > > >InsertC16T02 (100 thread) 2.14           2.07 (-3%)        2.18   (+1.8%)
> > > > >DeleteC00T01 (1 thread)   1.34           1.28 (-4.5%)           1.29   (-3.7%)
> > > > >UpdateC00T03 (1 thread)   4.72           4.18 (-12%)    4.53   (-5%)
> > > > >
> > > > >V2:
> > > > >
> > > > >- Move from x86 to generic code (Paolo/Christian).
> > > > >- Add auto-tuning logic (Paolo).
> > > > >- Add MSR to disable host side polling (Paolo).
> > > > >
> > > > >
> > > > >
> > > > First of all, please CC power management patches (including cpuidle,
> > > > cpufreq etc) to linux-pm@vger.kernel.org (there are people on that
> > > > list who may want to see your changes before they go in) and CC
> > > > cpuidle material (in particular) to Peter Zijlstra.
> > > >
> > > > Second, I'm not a big fan of this approach to be honest, as it kind
> > > > of is a driver trying to play the role of a governor.
> > > >
> > > > We have a "polling state" already that could be used here in
> > > > principle so I wonder what would be wrong with that.  Also note that
> > > > there seems to be at least some code duplication between your code
> > > > and the "polling state" implementation, so maybe it would be
> > > > possible to do some things in a common way?
> > >
> > > Hi Rafael,
> > >
> > > After modifying poll_state.c to use a generic "poll time" driver
> > > callback [1] (since using a variable "target_residency" for that
> > > looks really ugly), would need a governor which does:
> > >
> > > haltpoll_governor_select_next_state()
> > >         if (prev_state was poll and evt happened on prev poll window) -> POLL.
> > >         if (prev_state == HLT)  -> POLL
> > >         otherwise               -> HLT
> > >
> > > And a "default_idle" cpuidle driver that:
> > >
> > > defaultidle_idle()
> > >         if (current_clr_polling_and_test()) {
> > >                 local_irq_enable();
> > >                 return index;
> > >         }
> > >         default_idle();
> > >         return
> > >
> > > Using such governor with any other cpuidle driver would
> > > be pointless (since it would enter the first state only
> > > and therefore not save power).
> > >
> > > Not certain about using the default_idle driver with
> > > other governors: one would rather use a driver that
> > > supports all states on a given machine.
> > >
> > > This combination of governor/driver pair, for the sake
> > > of sharing the idle loop, seems awkward to me.
> > > And fails the governor/driver separation: one will use the
> > > pair in practice.
> > >
> > > But i have no problem with it, so i'll proceed with that.
> > >
> > > Let me know otherwise.
> >
> > If my understanding of your argumentation is correct, it is only
> > necessary to take the default_idle_call() branch of
> > cpuidle_idle_call() in the VM case, so it should be sufficient to
> > provide a suitable default_idle_call() which is what you seem to be
> > trying to do.
>
> In the VM case, we need to poll before actually halting (this is because
> its tricky to implement MWAIT in guests, so polling for some amount
> of time allows the IPI avoidance optimization,
> see trace_sched_wake_idle_without_ipi, to take place).
>
> The amount of time we poll is variable and adjusted (see adjust_haltpoll_ns
> in the patchset).
>
> > I might have been confused by the terminology used in the patch series
> > if that's the case.
> >
> > Also, if that's the case, this is not cpuidle matter really.  It is a
> > matter of providing a better default_idle_call() for the arch at hand.
>
> Peter Zijlstra suggested a cpuidle driver for this.

So I wonder what his rationale was.

> Also, other architectures will use the same "poll before exiting to VM"
> logic (so we'd rather avoid duplicating this code): PPC, x86, S/390,
> MIPS... So in my POV it makes sense to unify this.

The logic is fine IMO, but the implementation here is questionable.

> So, back to your initial suggestion:
>
> Q) "Can you unify code with poll_state.c?"
> A) Yes, but it requires a new governor, which seems overkill and unfit
> for the purpose.
>
> Moreover, the logic in menu to decide whether its necessary or not
> to stop sched tick is useful for us (so a default_idle_call is not
> sufficient), because the cost of enabling/disabling the sched tick is
> high on VMs.

So in fact you need a governor, but you really only need it to decide
whether or not to stop the tick for you.

menu has a quite high overhead for that. :-)

> So i'll fix the comments of the cpuidle driver (which everyone seems
> to agree with, except your understandable distate for it) and repost.
