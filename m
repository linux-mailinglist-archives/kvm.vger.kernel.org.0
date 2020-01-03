Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444E412F9CE
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 16:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgACPbN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 10:31:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57723 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727539AbgACPbN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jan 2020 10:31:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578065471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m7LwSvw4kZT6m+VWL29hf447kUvmDHEGKUw/r/5JYxo=;
        b=BL58vW74apzSpALrckHvzK5rby4LuEBDCPdT0RGQVeHwlGg5w3XvCwMCUJzZReohQ9FvWB
        cjlVV6PbL5Tz1Ifk25YkBUgeepzgRkCTXxbwv0U7np0zuGhYeX2DV1mdu2g9kg5AmCOe+z
        QGcDMj+u6W6nOWphmT/j+aL7DTxzWvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-3wJwOdW9M2i5n7EYl0QOgQ-1; Fri, 03 Jan 2020 10:31:10 -0500
X-MC-Unique: 3wJwOdW9M2i5n7EYl0QOgQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7DBB801E7A;
        Fri,  3 Jan 2020 15:31:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 33AB3385;
        Fri,  3 Jan 2020 15:31:07 +0000 (UTC)
Date:   Fri, 3 Jan 2020 16:31:04 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 06/18] arm/arm64: psci: Don't run C
 code without stack or vectors
Message-ID: <20200103153104.bletctgkql67ftzu@kamzik.brq.redhat.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-7-git-send-email-alexandru.elisei@arm.com>
 <20200102181121.6895344d@donnerap.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102181121.6895344d@donnerap.cambridge.arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 02, 2020 at 06:11:21PM +0000, Andre Przywara wrote:
> On Tue, 31 Dec 2019 16:09:37 +0000
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> 
> Hi,
> 
> > The psci test performs a series of CPU_ON/CPU_OFF cycles for CPU 1. This is
> > done by setting the entry point for the CPU_ON call to the physical address
> > of the C function cpu_psci_cpu_die.
> > 
> > The compiler is well within its rights to use the stack when generating
> > code for cpu_psci_cpu_die.
> 
> I am a bit puzzled: Is this an actual test failure at the moment? Or just a potential problem? Because I see it using the stack pointer in the generated code in lib/arm/psci.o. But the psci test seems to pass. Or is that just because the SP is somehow not cleared, because of some KVM implementation specifics?

I think the test just doesn't care that the CPU is in an infinite
exception loop. Indeed we should probably put the CPU into an
infinite loop instead of attempting to call PSCI die with it, as
the status of a dying or dead CPU may conflict with our expected
status of the test.

> 
> One more thing below ...
> 
> >  However, because no stack initialization has
> > been done, the stack pointer is zero, as set by KVM when creating the VCPU.
> > This causes a data abort without a change in exception level. The VBAR_EL1
> > register is also zero (the KVM reset value for VBAR_EL1), the MMU is off,
> > and we end up trying to fetch instructions from address 0x200.
> > 
> > At this point, a stage 2 instruction abort is generated which is taken to
> > KVM. KVM interprets this as an instruction fetch from an I/O region, and
> > injects a prefetch abort into the guest. Prefetch abort is a synchronous
> > exception, and on guest return the VCPU PC will be set to VBAR_EL1 + 0x200,
> > which is...  0x200. The VCPU ends up in an infinite loop causing a prefetch
> > abort while fetching the instruction to service the said abort.
> > 
> > cpu_psci_cpu_die is basically a wrapper over the HVC instruction, so
> > provide an assembly implementation for the function which will serve as the
> > entry point for CPU_ON.
> > 
> > Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> > ---
> >  arm/cstart.S   | 7 +++++++
> >  arm/cstart64.S | 7 +++++++
> >  arm/psci.c     | 5 +++--
> >  3 files changed, 17 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arm/cstart.S b/arm/cstart.S
> > index 2c81d39a666b..dfef48e4dbb2 100644
> > --- a/arm/cstart.S
> > +++ b/arm/cstart.S
> > @@ -7,6 +7,7 @@
> >   */
> >  #define __ASSEMBLY__
> >  #include <auxinfo.h>
> > +#include <linux/psci.h>
> >  #include <asm/thread_info.h>
> >  #include <asm/asm-offsets.h>
> >  #include <asm/pgtable-hwdef.h>
> > @@ -139,6 +140,12 @@ secondary_entry:
> >  	blx	r0
> >  	b	do_idle
> >  
> > +.global asm_cpu_psci_cpu_die
> > +asm_cpu_psci_cpu_die:
> > +	ldr	r0, =PSCI_0_2_FN_CPU_OFF
> > +	hvc	#0
> > +	b	.
> 
> I am wondering if this implementation is actually too simple. Both the current implementation and the kernel clear at least the first three arguments to 0.
> I failed to find a requirement for doing this (nothing in the SMCCC or the PSCI spec), but I guess it would make sense when looking at forward compatibility.
> 
> At the very least it's a change in behaviour (ignoring the missing printf).
> So shall we just clear r1, r2 and r3 here? (Same for arm64 below)

If we were to keep this function, then I agree we should zero the
registers, but as I said above, I think the proper fix for this issue is
to just not call PSCI die. Rather we should drop into an infinite loop,
which also doesn't use the stack. Maybe something like this will work

diff --git a/arm/psci.c b/arm/psci.c
index 5c1accb6cea4..74c179d4976c 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -79,10 +79,14 @@ static void cpu_on_secondary_entry(void)
 	cpumask_set_cpu(cpu, &cpu_on_ready);
 	while (!cpu_on_start)
 		cpu_relax();
-	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
+	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(halt));
 	cpumask_set_cpu(cpu, &cpu_on_done);
 }
 
+/*
+ * This test expects CPU1 to not have previously been boot,
+ * and when this test completes CPU1 will be stuck in halt.
+ */
 static bool psci_cpu_on_test(void)
 {
 	bool failed = false;
@@ -104,7 +108,7 @@ static bool psci_cpu_on_test(void)
 	cpu_on_start = 1;
 	smp_mb();
 
-	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
+	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(halt));
 	cpumask_set_cpu(0, &cpu_on_done);
 
 	while (!cpumask_full(&cpu_on_done))

Thanks,
drew

> 
> Cheers,
> Andre
> 
> > +
> >  .globl halt
> >  halt:
> >  1:	wfi
> > diff --git a/arm/cstart64.S b/arm/cstart64.S
> > index b0e8baa1a23a..c98842f11e90 100644
> > --- a/arm/cstart64.S
> > +++ b/arm/cstart64.S
> > @@ -7,6 +7,7 @@
> >   */
> >  #define __ASSEMBLY__
> >  #include <auxinfo.h>
> > +#include <linux/psci.h>
> >  #include <asm/asm-offsets.h>
> >  #include <asm/ptrace.h>
> >  #include <asm/processor.h>
> > @@ -128,6 +129,12 @@ secondary_entry:
> >  	blr	x0
> >  	b	do_idle
> >  
> > +.globl asm_cpu_psci_cpu_die
> > +asm_cpu_psci_cpu_die:
> > +	ldr	x0, =PSCI_0_2_FN_CPU_OFF
> > +	hvc	#0
> > +	b	.
> > +
> >  .globl halt
> >  halt:
> >  1:	wfi
> > diff --git a/arm/psci.c b/arm/psci.c
> > index 5c1accb6cea4..c45a39c7d6e8 100644
> > --- a/arm/psci.c
> > +++ b/arm/psci.c
> > @@ -72,6 +72,7 @@ static int cpu_on_ret[NR_CPUS];
> >  static cpumask_t cpu_on_ready, cpu_on_done;
> >  static volatile int cpu_on_start;
> >  
> > +extern void asm_cpu_psci_cpu_die(void);
> >  static void cpu_on_secondary_entry(void)
> >  {
> >  	int cpu = smp_processor_id();
> > @@ -79,7 +80,7 @@ static void cpu_on_secondary_entry(void)
> >  	cpumask_set_cpu(cpu, &cpu_on_ready);
> >  	while (!cpu_on_start)
> >  		cpu_relax();
> > -	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
> > +	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(asm_cpu_psci_cpu_die));
> >  	cpumask_set_cpu(cpu, &cpu_on_done);
> >  }
> >  
> > @@ -104,7 +105,7 @@ static bool psci_cpu_on_test(void)
> >  	cpu_on_start = 1;
> >  	smp_mb();
> >  
> > -	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
> > +	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(asm_cpu_psci_cpu_die));
> >  	cpumask_set_cpu(0, &cpu_on_done);
> >  
> >  	while (!cpumask_full(&cpu_on_done))
> 

