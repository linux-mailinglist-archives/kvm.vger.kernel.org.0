Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC69136AA1
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 11:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgAJKJb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Fri, 10 Jan 2020 05:09:31 -0500
Received: from 2.mo178.mail-out.ovh.net ([46.105.39.61]:47759 "EHLO
        2.mo178.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgAJKJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 05:09:31 -0500
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Jan 2020 05:09:29 EST
Received: from player688.ha.ovh.net (unknown [10.108.54.38])
        by mo178.mail-out.ovh.net (Postfix) with ESMTP id B9A4A8A813
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2020 10:51:20 +0100 (CET)
Received: from kaod.org (lns-bzn-46-82-253-208-248.adsl.proxad.net [82.253.208.248])
        (Authenticated sender: groug@kaod.org)
        by player688.ha.ovh.net (Postfix) with ESMTPSA id 56885DFACE0A;
        Fri, 10 Jan 2020 09:50:58 +0000 (UTC)
Date:   Fri, 10 Jan 2020 10:50:55 +0100
From:   Greg Kurz <groug@kaod.org>
To:     Philippe =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@redhat.com>
Cc:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        Juan Quintela <quintela@redhat.com>, qemu-ppc@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        qemu-arm@nongnu.org, Alistair Francis <alistair.francis@wdc.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <rth@twiddle.net>,
        Eric Blake <eblake@redhat.com>
Subject: Re: [PATCH 04/15] hw/ppc/spapr_rtas: Restrict variables scope to
 single switch case
Message-ID: <20200110105055.3e72ddf4@bahia.lan>
In-Reply-To: <9870f8ed-3fa0-1deb-860d-7481cb3db556@redhat.com>
References: <20200109152133.23649-1-philmd@redhat.com>
        <20200109152133.23649-5-philmd@redhat.com>
        <20200109184349.1aefa074@bahia.lan>
        <9870f8ed-3fa0-1deb-860d-7481cb3db556@redhat.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Ovh-Tracer-Id: 5266959766281034019
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrvdeifedgtdelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfgjfhfogggtgfesthhqredtredtjeenucfhrhhomhepifhrvghgucfmuhhriicuoehgrhhouhhgsehkrghougdrohhrgheqnecukfhppedtrddtrddtrddtpdekvddrvdehfedrvddtkedrvdegkeenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrieekkedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehgrhhouhhgsehkrghougdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Jan 2020 10:34:07 +0100
Philippe Mathieu-Daudé <philmd@redhat.com> wrote:

> On 1/9/20 6:43 PM, Greg Kurz wrote:
> > On Thu,  9 Jan 2020 16:21:22 +0100
> > Philippe Mathieu-Daudé <philmd@redhat.com> wrote:
> > 
> >> We only access these variables in RTAS_SYSPARM_SPLPAR_CHARACTERISTICS
> >> case, restrict their scope to avoid unnecessary initialization.
> >>
> > 
> > I guess a decent compiler can be smart enough detect that the initialization
> > isn't needed outside of the RTAS_SYSPARM_SPLPAR_CHARACTERISTICS branch...
> > Anyway, reducing scope isn't bad. The only hitch I could see is that some
> > people do prefer to have all variables declared upfront, but there's a nested
> > param_val variable already so I guess it's okay.
> 
> I don't want to outsmart compilers :)
> 
> The MACHINE() macro is not a simple cast, it does object introspection 
> with OBJECT_CHECK(), thus is not free. Since 

Sure, I understand the motivation in avoiding an unneeded call
to calling object_dynamic_cast_assert().

> object_dynamic_cast_assert() argument is not const, I'm not sure the 
> compiler can remove the call.
> 

Not remove the call, but delay it to the branch that uses it,
ie. parameter == RTAS_SYSPARM_SPLPAR_CHARACTERISTICS.

> Richard, Eric, do you know?
> 
> >> Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
> >> ---
> >>   hw/ppc/spapr_rtas.c | 4 ++--
> >>   1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/hw/ppc/spapr_rtas.c b/hw/ppc/spapr_rtas.c
> >> index 6f06e9d7fe..7237e5ebf2 100644
> >> --- a/hw/ppc/spapr_rtas.c
> >> +++ b/hw/ppc/spapr_rtas.c
> >> @@ -267,8 +267,6 @@ static void rtas_ibm_get_system_parameter(PowerPCCPU *cpu,
> >>                                             uint32_t nret, target_ulong rets)
> >>   {
> >>       PowerPCCPUClass *pcc = POWERPC_CPU_GET_CLASS(cpu);
> >> -    MachineState *ms = MACHINE(spapr);
> >> -    unsigned int max_cpus = ms->smp.max_cpus;
> >>       target_ulong parameter = rtas_ld(args, 0);
> >>       target_ulong buffer = rtas_ld(args, 1);
> >>       target_ulong length = rtas_ld(args, 2);
> >> @@ -276,6 +274,8 @@ static void rtas_ibm_get_system_parameter(PowerPCCPU *cpu,
> >>   
> >>       switch (parameter) {
> >>       case RTAS_SYSPARM_SPLPAR_CHARACTERISTICS: {
> >> +        MachineState *ms = MACHINE(spapr);
> >> +        unsigned int max_cpus = ms->smp.max_cpus;
> > 
> > The max_cpus variable used to be a global. Now that it got moved
> > below ms->smp, I'm not sure it's worth keeping it IMHO. What about
> > dropping it completely and do:
> > 
> >          char *param_val = g_strdup_printf("MaxEntCap=%d,"
> >                                            "DesMem=%" PRIu64 ","
> >                                            "DesProcs=%d,"
> >                                            "MaxPlatProcs=%d",
> >                                            ms->smp.max_cpus,
> >                                            current_machine->ram_size / MiB,
> >                                            ms->smp.cpus,
> >                                            ms->smp.max_cpus);
> 
> OK, good idea.
> 
> > And maybe insert an empty line between the declaration of param_val
> > and the code for a better readability ?
> > 
> >>           char *param_val = g_strdup_printf("MaxEntCap=%d,"
> >>                                             "DesMem=%" PRIu64 ","
> >>                                             "DesProcs=%d,"
> > 
> 

