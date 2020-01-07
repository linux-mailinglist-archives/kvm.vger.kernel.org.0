Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4B81325EE
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 13:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgAGMUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 07:20:08 -0500
Received: from foss.arm.com ([217.140.110.172]:56938 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727177AbgAGMUH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 07:20:07 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB08331B;
        Tue,  7 Jan 2020 04:20:06 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E2893F534;
        Tue,  7 Jan 2020 04:20:05 -0800 (PST)
Date:   Tue, 7 Jan 2020 12:19:21 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com,
        andrew.murray@arm.com, peter.maydell@linaro.org,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH 05/10] arm: pmu: Basic event counter
 Tests
Message-ID: <20200107121921.07bbee41@donnerap.cambridge.arm.com>
In-Reply-To: <20191216204757.4020-6-eric.auger@redhat.com>
References: <20191216204757.4020-1-eric.auger@redhat.com>
        <20191216204757.4020-6-eric.auger@redhat.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 16 Dec 2019 21:47:52 +0100
Eric Auger <eric.auger@redhat.com> wrote:

Hi Eric,

thanks a lot for your work on these elaborate tests! I have some PMU test extensions as well, but they are nowhere as sophisticated as yours!

Just ran this on my ThunderX2 desktop (4.15.0-65-generic #74-Ubuntu kernel, QEMU emulator version 2.11.1(Debian 1:2.11+dfsg-1ubuntu7.21)), and it reported the following fails:
INFO: pmu: basic-event-count: counter #0 is 0x207e (CPU_CYCLES)
INFO: pmu: basic-event-count: counter #1 is 0xc89 (INST_RETIRED)
INFO: pmu: basic-event-count: overflow reg = 0x0
FAIL: pmu: basic-event-count: check overflow happened on #0 only
....
INFO: PMU version: 4
INFO: Implements 6 event counters
INFO: pmu: mem-access: counter #0 is 1297 (MEM_ACCESS)
INFO: pmu: mem-access: counter #1 is 1287 (MEM_ACCESS)
FAIL: pmu: mem-access: Ran 20 mem accesses
FAIL: pmu: mem-access: Ran 20 mem accesses with expected overflows on both counters
INFO: pmu: mem-access: cnt#0 = 1353 cnt#1=1259 overflow=0x0

Do you know about this? Is this due to kernel bugs? Because Ubuntu cleverly chose an EOL kernel for their stable distro :-P
Will try to have a look and repeat on a Juno.

Comments inline ....

> Adds the following tests:
> - event-counter-config: test event counter configuration
> - basic-event-count:
>   - programs counters #0 and #1 to count 2 required events
>   (resp. CPU_CYCLES and INST_RETIRED). Counter #0 is preset
>   to a value close enough to the 32b
>   overflow limit so that we check the overflow bit is set
>   after the execution of the asm loop.
> - mem-access: counts MEM_ACCESS event on counters #0 and #1
>   with and without 32-bit overflow.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> ---
>  arm/pmu.c         | 261 ++++++++++++++++++++++++++++++++++++++++++++++
>  arm/unittests.cfg |  18 ++++
>  2 files changed, 279 insertions(+)
> 
> diff --git a/arm/pmu.c b/arm/pmu.c
> index d88ef22..139dae3 100644
> --- a/arm/pmu.c
> +++ b/arm/pmu.c
> @@ -18,9 +18,15 @@
>  #include "asm/barrier.h"
>  #include "asm/sysreg.h"
>  #include "asm/processor.h"
> +#include <bitops.h>
> +#include <asm/gic.h>
>  
>  #define PMU_PMCR_E         (1 << 0)
> +#define PMU_PMCR_P         (1 << 1)
>  #define PMU_PMCR_C         (1 << 2)
> +#define PMU_PMCR_D         (1 << 3)
> +#define PMU_PMCR_X         (1 << 4)
> +#define PMU_PMCR_DP        (1 << 5)
>  #define PMU_PMCR_LC        (1 << 6)
>  #define PMU_PMCR_N_SHIFT   11
>  #define PMU_PMCR_N_MASK    0x1f
> @@ -104,6 +110,9 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>  
>  /* event counter tests only implemented for aarch64 */
>  static void test_event_introspection(void) {}
> +static void test_event_counter_config(void) {}
> +static void test_basic_event_count(void) {}
> +static void test_mem_access(void) {}
>  
>  #elif defined(__aarch64__)
>  #define ID_AA64DFR0_PERFMON_SHIFT 8
> @@ -145,6 +154,32 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>  }
>  
>  #define PMCEID1_EL0 sys_reg(11, 3, 9, 12, 7)
> +#define PMCNTENSET_EL0 sys_reg(11, 3, 9, 12, 1)
> +#define PMCNTENCLR_EL0 sys_reg(11, 3, 9, 12, 2)

op0 (the first argument) is only two bits, so it should read "3" instead of "11" here. That's already a bug in the existing PMCEID1_EL0 definition. We get away with it because the macro masks with 3, but it should be still written correctly here. Not sure where the "11" actually comes from.

> +
> +#define PMEVTYPER_EXCLUDE_EL1 (1 << 31)
> +#define PMEVTYPER_EXCLUDE_EL0 (1 << 30)
> +
> +#define regn_el0(__reg, __n) __reg ## __n  ## _el0
> +#define write_regn(__reg, __n, __val) \
> +	write_sysreg((__val), __reg ## __n ## _el0)
> +
> +#define read_regn(__reg, __n) \
> +	read_sysreg(__reg ## __n ## _el0)
> +
> +#define print_pmevtyper(__s, __n) do { \
> +	uint32_t val; \
> +	val = read_regn(pmevtyper, __n);\
> +	report_info("%s pmevtyper%d=0x%x, eventcount=0x%x (p=%ld, u=%ld nsk=%ld, nsu=%ld, nsh=%ld m=%ld, mt=%ld)", \
> +			(__s), (__n), val, val & 0xFFFF,  \
> +			(BIT_MASK(31) & val) >> 31, \
> +			(BIT_MASK(30) & val) >> 30, \
> +			(BIT_MASK(29) & val) >> 29, \
> +			(BIT_MASK(28) & val) >> 28, \
> +			(BIT_MASK(27) & val) >> 27, \
> +			(BIT_MASK(26) & val) >> 26, \
> +			(BIT_MASK(25) & val) >> 25); \

Just a nit, but later versions of the ARMv8 ARM list bit 24 as "SH", for filtering Secure EL2 events. For the sake of completeness you could add this as well, since we list the EL3 filter bit as well.

> +	} while (0)
>  
>  static bool is_event_supported(uint32_t n, bool warn)
>  {
> @@ -207,6 +242,223 @@ static void test_event_introspection(void)
>  	report(required_events, "Check required events are implemented");
>  }
>  
> +static inline void mem_access_loop(void *addr, int loop, uint32_t pmcr)

Do we really need the "inline" here? If you rely on this being inlined, we need something stronger, I believe (because inline itself is just a hint).

And can you please add a comment about what this code is supposed to do (because that's much harder to derive in assembly)? And why it needs to be in assembly?

> +{
> +asm volatile(
> +	"       msr     pmcr_el0, %[pmcr]\n"
> +	"       isb\n"
> +	"       mov     x10, %[loop]\n"

Given that %[loop] is just a register, do we need to use x10 at all?

> +	"1:     sub     x10, x10, #1\n"
> +	"       mov x8, %[addr]\n"

Are you doing this on purpose inside the loop? And do you actually need to move it to a new register anyway? Why not just use %[addr] directly instead of x8?

> +	"       ldr x9, [x8]\n"

I think you could declare some "asm" variable to avoid explicitly specifying a numbered register.

> +	"       cmp     x10, #0x0\n"
> +	"       b.gt    1b\n"

I think "cbnz" (Compare and Branch on Nonzero) can replace those two instructions.

> +	"       msr     pmcr_el0, xzr\n"
> +	"       isb\n"
> +	:
> +	: [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
> +	: );

Don't you need to tell the compiler that you clobber x8 - x10?

> +}
> +
> +
> +static void pmu_reset(void)
> +{
> +	/* reset all counters, counting disabled at PMCR level*/
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
> +	/* Disable all counters */
> +	write_sysreg_s(0xFFFFFFFF, PMCNTENCLR_EL0);
> +	/* clear overflow reg */
> +	write_sysreg(0xFFFFFFFF, pmovsclr_el0);
> +	/* disable overflow interrupts on all counters */
> +	write_sysreg(0xFFFFFFFF, pmintenclr_el1);
> +	isb();
> +}
> +
> +static void test_event_counter_config(void)
> +{
> +	int i;
> +
> +	if (!pmu.nb_implemented_counters) {
> +		report_skip("No event counter, skip ...");
> +		return;
> +	}
> +
> +	pmu_reset();
> +
> +	/*
> +	 * Test setting through PMESELR/PMXEVTYPER and PMEVTYPERn read,
> +	 * select counter 0
> +	 */
> +	write_sysreg(1, PMSELR_EL0);
> +	/* program this counter to count unsupported event */
> +	write_sysreg(0xEA, PMXEVTYPER_EL0);
> +	write_sysreg(0xdeadbeef, PMXEVCNTR_EL0);
> +	report((read_regn(pmevtyper, 1) & 0xFFF) == 0xEA,
> +		"PMESELR/PMXEVTYPER/PMEVTYPERn");
> +	report((read_regn(pmevcntr, 1) == 0xdeadbeef),
> +		"PMESELR/PMXEVCNTR/PMEVCNTRn");
> +
> +	/* try configure an unsupported event within the range [0x0, 0x3F] */
> +	for (i = 0; i <= 0x3F; i++) {
> +		if (!is_event_supported(i, false))
> +			goto test_unsupported;
> +	}
> +	report_skip("pmevtyper: all events within [0x0, 0x3F] are supported");

Doesn't report_skip just *mark* it as SKIP, but then proceeds anyway? So you would need to return here?

And I wonder if it would be nicer to use a break, then check for i being 0x40, instead of using goto.

> +
> +test_unsupported:
> +	/* select counter 0 */
> +	write_sysreg(0, PMSELR_EL0);
> +	/* program this counter to count unsupported event */
> +	write_sysreg(i, PMXEVCNTR_EL0);
> +	/* read the counter value */
> +	read_sysreg(PMXEVCNTR_EL0);
> +	report(read_sysreg(PMXEVCNTR_EL0) == i,
> +		"read of a counter programmed with unsupported event");
> +
> +}
> +
> +static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events)
> +{
> +	int i;
> +
> +	if (pmu.nb_implemented_counters < nb_events) {
> +		report_skip("Skip test as number of counters is too small (%d)",
> +			    pmu.nb_implemented_counters);
> +		return false;
> +	}
> +
> +	for (i = 0; i < nb_events; i++) {
> +		if (!is_event_supported(events[i], false)) {
> +			report_skip("Skip test as event %d is not supported",
> +				    events[i]);
> +			return false;
> +		}
> +	}
> +	return true;
> +}
> +
> +static void test_basic_event_count(void)
> +{
> +	uint32_t implemented_counter_mask, non_implemented_counter_mask;
> +	uint32_t counter_mask;
> +	uint32_t events[] = {
> +		0x11,	/* CPU_CYCLES */
> +		0x8,	/* INST_RETIRED */
> +	};
> +
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +		return;
> +
> +	implemented_counter_mask = (1 << pmu.nb_implemented_counters) - 1;
> +	non_implemented_counter_mask = ~((1 << 31) | implemented_counter_mask);

I might be paranoid, but I think it's good practise to use "1U << ...", to avoid signed shifts. Or use the BIT() macro.

> +	counter_mask = implemented_counter_mask | non_implemented_counter_mask;
> +
> +	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
> +
> +	/* disable all counters */
> +	write_sysreg_s(0xFFFFFFFF, PMCNTENCLR_EL0);
> +	report(!read_sysreg_s(PMCNTENCLR_EL0) && !read_sysreg_s(PMCNTENSET_EL0),
> +		"pmcntenclr: disable all counters");
> +
> +	/*
> +	 * clear cycle and all event counters and allow counter enablement
> +	 * through PMCNTENSET. LC is RES1.
> +	 */
> +	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
> +	isb();
> +	report(get_pmcr() == (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset counters");
> +
> +	/* Preset counter #0 to 0xFFFFFFF0 to trigger an overflow interrupt */
> +	write_regn(pmevcntr, 0, 0xFFFFFFF0);
> +	report(read_regn(pmevcntr, 0) == 0xFFFFFFF0,
> +		"counter #0 preset to 0xFFFFFFF0");
> +	report(!read_regn(pmevcntr, 1), "counter #1 is 0");
> +
> +	/*
> +	 * Enable all implemented counters and also attempt to enable
> +	 * not supported counters. Counting still is disabled by !PMCR.E
> +	 */
> +	write_sysreg_s(counter_mask, PMCNTENSET_EL0);
> +
> +	/* check only those implemented are enabled */
> +	report((read_sysreg_s(PMCNTENSET_EL0) == read_sysreg_s(PMCNTENCLR_EL0)) &&
> +		(read_sysreg_s(PMCNTENSET_EL0) == implemented_counter_mask),
> +		"pmcntenset: enabled implemented_counters");
> +
> +	/* Disable all counters but counters #0 and #1 */
> +	write_sysreg_s(~0x3, PMCNTENCLR_EL0);
> +	report((read_sysreg_s(PMCNTENSET_EL0) == read_sysreg_s(PMCNTENCLR_EL0)) &&
> +		(read_sysreg_s(PMCNTENSET_EL0) == 0x3),
> +		"pmcntenset: just enabled #0 and #1");
> +
> +	/* clear overflow register */
> +	write_sysreg(0xFFFFFFFF, pmovsclr_el0);
> +	report(!read_sysreg(pmovsclr_el0), "check overflow reg is 0");
> +
> +	/* disable overflow interrupts on all counters*/
> +	write_sysreg(0xFFFFFFFF, pmintenclr_el1);
> +	report(!read_sysreg(pmintenclr_el1),
> +		"pmintenclr_el1=0, all interrupts disabled");
> +
> +	/* enable overflow interrupts on all event counters */
> +	write_sysreg(implemented_counter_mask | non_implemented_counter_mask,
> +		     pmintenset_el1);
> +	report(read_sysreg(pmintenset_el1) == implemented_counter_mask,
> +		"overflow interrupts enabled on all implemented counters");
> +
> +	/* Set PMCR.E, execute asm code and unset PMCR.E */
> +	precise_instrs_loop(20, pmu.pmcr_ro | PMU_PMCR_E);
> +
> +	report_info("counter #0 is 0x%lx (CPU_CYCLES)",
> +		    read_regn(pmevcntr, 0));
> +	report_info("counter #1 is 0x%lx (INST_RETIRED)",
> +		    read_regn(pmevcntr, 1));
> +
> +	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
> +	report(read_sysreg(pmovsclr_el0) & 0x1,
> +		"check overflow happened on #0 only");
> +}
> +
> +static void test_mem_access(void)
> +{
> +	void *addr = malloc(PAGE_SIZE);
> +	uint32_t events[] = {
> +		0x13,   /* MEM_ACCESS */
> +		0x13,   /* MEM_ACCESS */
> +	};
> +
> +	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
> +		return;
> +
> +	pmu_reset();
> +
> +	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
> +	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	isb();
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn(pmevcntr, 0));
> +	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn(pmevcntr, 1));
> +	/* We may not measure exactly 20 mem access. Depends on the platform */

Are you thinking about speculative accesses here? Could you name this explicitly? "Platform" suggests it's something in the SoC or the board, but I believe this is a pure core choice.

> +	report((read_regn(pmevcntr, 0) == read_regn(pmevcntr, 1)) &&
> +	       (read_regn(pmevcntr, 0) >= 20) && !read_sysreg(pmovsclr_el0),
> +	       "Ran 20 mem accesses");
> +
> +	pmu_reset();
> +
> +	write_regn(pmevcntr, 0, 0xFFFFFFFA);
> +	write_regn(pmevcntr, 1, 0xFFFFFFF0);
> +	write_sysreg_s(0x3, PMCNTENSET_EL0);
> +	isb();
> +	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
> +	report(read_sysreg(pmovsclr_el0) == 0x3,
> +	       "Ran 20 mem accesses with expected overflows on both counters");
> +	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
> +			read_regn(pmevcntr, 0), read_regn(pmevcntr, 1),
> +			read_sysreg(pmovsclr_el0));
> +}
> +
>  #endif
>  
>  /*
> @@ -397,6 +649,15 @@ int main(int argc, char *argv[])
>  	} else if (strcmp(argv[1], "event-introspection") == 0) {
>  		report_prefix_push(argv[1]);
>  		test_event_introspection();
> +	} else if (strcmp(argv[1], "event-counter-config") == 0) {
> +		report_prefix_push(argv[1]);
> +		test_event_counter_config();
> +	} else if (strcmp(argv[1], "basic-event-count") == 0) {
> +		report_prefix_push(argv[1]);
> +		test_basic_event_count();
> +	} else if (strcmp(argv[1], "mem-access") == 0) {
> +		report_prefix_push(argv[1]);
> +		test_mem_access();

I was wondering if we need all of them as separately selectable tests? Could this be just one "basic_counter" test?

Cheers,
Andre

>  	} else {
>  		report_abort("Unknown sub-test '%s'", argv[1]);
>  	}
> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
> index 4433ef3..7a59403 100644
> --- a/arm/unittests.cfg
> +++ b/arm/unittests.cfg
> @@ -72,6 +72,24 @@ groups = pmu
>  arch = arm64
>  extra_params = -append 'event-introspection'
>  
> +[pmu-event-counter-config]
> +file = pmu.flat
> +groups = pmu
> +arch = arm64
> +extra_params = -append 'event-counter-config'
> +
> +[pmu-basic-event-count]
> +file = pmu.flat
> +groups = pmu
> +arch = arm64
> +extra_params = -append 'basic-event-count'
> +
> +[pmu-mem-access]
> +file = pmu.flat
> +groups = pmu
> +arch = arm64
> +extra_params = -append 'mem-access'
> +
>  # Test PMU support (TCG) with -icount IPC=1
>  #[pmu-tcg-icount-1]
>  #file = pmu.flat

