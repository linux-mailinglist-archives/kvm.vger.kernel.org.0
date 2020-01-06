Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9523013127B
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2020 14:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgAFNDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jan 2020 08:03:44 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46113 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726173AbgAFNDn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jan 2020 08:03:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578315822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=olGnr8ODc5A4B6AqLBQ/Z10N1hdekpJbdyLPCHhH9PY=;
        b=PSeEWjhHAxGLChFf3T7wueNyqhnikfKiozS2cRYTKZ6HTM0k7a3NWii00dzbupFO+ynDT2
        gq6DcSA0bSo2Y5CWjJ3VntnX10RVx1JXNbYp2i2GDYelO3i5f6+Hs2FJTJBcpFJGiLSUo1
        HumpJYydKA03GFPDTWtWDJryiwB1crs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-O_0hzwpfNni6Lme81MKKqw-1; Mon, 06 Jan 2020 08:03:39 -0500
X-MC-Unique: O_0hzwpfNni6Lme81MKKqw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBC731800D53;
        Mon,  6 Jan 2020 13:03:37 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 17BCD858A6;
        Mon,  6 Jan 2020 13:03:35 +0000 (UTC)
Date:   Mon, 6 Jan 2020 14:03:33 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Andre Przywara <andre.przywara@arm.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, maz@kernel.org, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: Re: [kvm-unit-tests PATCH v3 06/18] arm/arm64: psci: Don't run C
 code without stack or vectors
Message-ID: <20200106130333.7sbzvrdollakayso@kamzik.brq.redhat.com>
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <1577808589-31892-7-git-send-email-alexandru.elisei@arm.com>
 <20200102181121.6895344d@donnerap.cambridge.arm.com>
 <20200103153104.bletctgkql67ftzu@kamzik.brq.redhat.com>
 <64f87f35-d778-761d-80fd-4cf31a50dc2e@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64f87f35-d778-761d-80fd-4cf31a50dc2e@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 06, 2020 at 11:02:16AM +0000, Alexandru Elisei wrote:
> Hi,
> 
> On 1/3/20 3:31 PM, Andrew Jones wrote:
> > On Thu, Jan 02, 2020 at 06:11:21PM +0000, Andre Przywara wrote:
> >> On Tue, 31 Dec 2019 16:09:37 +0000
> >> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> >>
> >> Hi,
> >>
> >>> The psci test performs a series of CPU_ON/CPU_OFF cycles for CPU 1. This is
> >>> done by setting the entry point for the CPU_ON call to the physical address
> >>> of the C function cpu_psci_cpu_die.
> >>>
> >>> The compiler is well within its rights to use the stack when generating
> >>> code for cpu_psci_cpu_die.
> >> I am a bit puzzled: Is this an actual test failure at the moment? Or just a potential problem? Because I see it using the stack pointer in the generated code in lib/arm/psci.o. But the psci test seems to pass. Or is that just because the SP is somehow not cleared, because of some KVM implementation specifics?
> > I think the test just doesn't care that the CPU is in an infinite
> > exception loop. Indeed we should probably put the CPU into an
> > infinite loop instead of attempting to call PSCI die with it, as
> > the status of a dying or dead CPU may conflict with our expected
> > status of the test.
> 
> I don't like this idea, I'll explain below why.
> 
> >> One more thing below ...
> >>
> >>>  However, because no stack initialization has
> >>> been done, the stack pointer is zero, as set by KVM when creating the VCPU.
> >>> This causes a data abort without a change in exception level. The VBAR_EL1
> >>> register is also zero (the KVM reset value for VBAR_EL1), the MMU is off,
> >>> and we end up trying to fetch instructions from address 0x200.
> >>>
> >>> At this point, a stage 2 instruction abort is generated which is taken to
> >>> KVM. KVM interprets this as an instruction fetch from an I/O region, and
> >>> injects a prefetch abort into the guest. Prefetch abort is a synchronous
> >>> exception, and on guest return the VCPU PC will be set to VBAR_EL1 + 0x200,
> >>> which is...  0x200. The VCPU ends up in an infinite loop causing a prefetch
> >>> abort while fetching the instruction to service the said abort.
> >>>
> >>> cpu_psci_cpu_die is basically a wrapper over the HVC instruction, so
> >>> provide an assembly implementation for the function which will serve as the
> >>> entry point for CPU_ON.
> >>>
> >>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> >>> ---
> >>>  arm/cstart.S   | 7 +++++++
> >>>  arm/cstart64.S | 7 +++++++
> >>>  arm/psci.c     | 5 +++--
> >>>  3 files changed, 17 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/arm/cstart.S b/arm/cstart.S
> >>> index 2c81d39a666b..dfef48e4dbb2 100644
> >>> --- a/arm/cstart.S
> >>> +++ b/arm/cstart.S
> >>> @@ -7,6 +7,7 @@
> >>>   */
> >>>  #define __ASSEMBLY__
> >>>  #include <auxinfo.h>
> >>> +#include <linux/psci.h>
> >>>  #include <asm/thread_info.h>
> >>>  #include <asm/asm-offsets.h>
> >>>  #include <asm/pgtable-hwdef.h>
> >>> @@ -139,6 +140,12 @@ secondary_entry:
> >>>  	blx	r0
> >>>  	b	do_idle
> >>>  
> >>> +.global asm_cpu_psci_cpu_die
> >>> +asm_cpu_psci_cpu_die:
> >>> +	ldr	r0, =PSCI_0_2_FN_CPU_OFF
> >>> +	hvc	#0
> >>> +	b	.
> >> I am wondering if this implementation is actually too simple. Both the current implementation and the kernel clear at least the first three arguments to 0.
> >> I failed to find a requirement for doing this (nothing in the SMCCC or the PSCI spec), but I guess it would make sense when looking at forward compatibility.
> >>
> >> At the very least it's a change in behaviour (ignoring the missing printf).
> >> So shall we just clear r1, r2 and r3 here? (Same for arm64 below)
> > If we were to keep this function, then I agree we should zero the
> > registers, but as I said above, I think the proper fix for this issue is
> 
> Regarding zero'ing unused arguments, I've explained my point of view in my reply
> to Andre.
> 
> > to just not call PSCI die. Rather we should drop into an infinite loop,
> > which also doesn't use the stack. Maybe something like this will work
> >
> > diff --git a/arm/psci.c b/arm/psci.c
> > index 5c1accb6cea4..74c179d4976c 100644
> > --- a/arm/psci.c
> > +++ b/arm/psci.c
> > @@ -79,10 +79,14 @@ static void cpu_on_secondary_entry(void)
> >  	cpumask_set_cpu(cpu, &cpu_on_ready);
> >  	while (!cpu_on_start)
> >  		cpu_relax();
> > -	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
> > +	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(halt));
> >  	cpumask_set_cpu(cpu, &cpu_on_done);
> >  }
> >  
> > +/*
> > + * This test expects CPU1 to not have previously been boot,
> > + * and when this test completes CPU1 will be stuck in halt.
> > + */
> >  static bool psci_cpu_on_test(void)
> >  {
> >  	bool failed = false;
> > @@ -104,7 +108,7 @@ static bool psci_cpu_on_test(void)
> >  	cpu_on_start = 1;
> >  	smp_mb();
> >  
> > -	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
> > +	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(halt));
> >  	cpumask_set_cpu(0, &cpu_on_done);
> >  
> >  	while (!cpumask_full(&cpu_on_done))
> 
> Trying to turn a CPU on and off concurrently from separate threads seems like a
> nifty test to me, and good for catching possible races. With your version, 2
> threads are enough to get all possible results: success and CPU already on.
> 
> Besides that, if my memory serves me right, this exact test was the reason for a
> refactoring of the VCPU reset code, in commit 03fdfb269009 ("KVM: arm64: Don't
> write junk to sysregs on reset").

It wasn't because there was a CPU_OFF involved. Two simultaneous CPU_ON's
was enough. The first, successful CPU_ON reset the target VCPU causing the
second CPU_ON to fail to look it up by MPIDR, resulting in
PSCI_RET_INVALID_PARAMS.

> 
> My preference would be to keep calling CPU_ON and CPU_OFF repeatedly.
>

Your analysis showed we never called CPU_OFF, because CPU1 got stuck
in an exception loop. So we haven't actually done a repeated ON/OFF
test yet. That's not a bad idea, but I also like a test that ensures
a single successful CPU_ON, like the patch below would ensure if we
halted instead of CPU_OFF'ed.

It should be possible to have both tests if we do the CPU_OFF test first.

Thanks,
drew


diff --git a/arm/psci.c b/arm/psci.c
index 5c1accb6cea4..8a24860bde28 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -86,7 +86,7 @@ static void cpu_on_secondary_entry(void)
 static bool psci_cpu_on_test(void)
 {
 	bool failed = false;
-	int cpu;
+	int cpu, ret_success = 0;
 
 	cpumask_set_cpu(1, &cpu_on_ready);
 	cpumask_set_cpu(1, &cpu_on_done);
@@ -113,7 +113,12 @@ static bool psci_cpu_on_test(void)
 	for_each_present_cpu(cpu) {
 		if (cpu == 1)
 			continue;
-		if (cpu_on_ret[cpu] != PSCI_RET_SUCCESS && cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
+		if (cpu_on_ret[cpu] == PSCI_RET_SUCCESS) {
+			if (++ret_success > 1) {
+				report_info("more than one cpu_on success");
+				failed = true;
+			}
+		} else if (cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
 			report_info("unexpected cpu_on return value: caller=CPU%d, ret=%d", cpu, cpu_on_ret[cpu]);
 			failed = true;
 		}

