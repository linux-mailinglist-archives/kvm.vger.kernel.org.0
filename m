Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD145121B26
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 21:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfLPUsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 15:48:38 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:46418 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfLPUsi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 15:48:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576529317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qqgi4yXzByAocEYIrdhE6bBEIHbw5QcBl06XsTZ132U=;
        b=Njup6Y9fL+Qfr1ldsuF+vN1+ro5AEHNVIry+kRkCSXWBNGwH6NYw3Q6ylnuw41ZUDkrXr1
        3U1a0p1JoIb5HCbwYzoDBbjoLkVdM6wTgqPGspvJQhGKBez5/FXvufmWnqd2nC2JAviIYS
        xczluLbnfA/hRm6iVtwoteqU1uI0GOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-qieL2TobNmy6pxnl1MxLLA-1; Mon, 16 Dec 2019 15:48:28 -0500
X-MC-Unique: qieL2TobNmy6pxnl1MxLLA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0769108EE95;
        Mon, 16 Dec 2019 20:48:26 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D30645D9C9;
        Mon, 16 Dec 2019 20:48:21 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH 05/10] arm: pmu: Basic event counter Tests
Date:   Mon, 16 Dec 2019 21:47:52 +0100
Message-Id: <20191216204757.4020-6-eric.auger@redhat.com>
In-Reply-To: <20191216204757.4020-1-eric.auger@redhat.com>
References: <20191216204757.4020-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adds the following tests:
- event-counter-config: test event counter configuration
- basic-event-count:
  - programs counters #0 and #1 to count 2 required events
  (resp. CPU_CYCLES and INST_RETIRED). Counter #0 is preset
  to a value close enough to the 32b
  overflow limit so that we check the overflow bit is set
  after the execution of the asm loop.
- mem-access: counts MEM_ACCESS event on counters #0 and #1
  with and without 32-bit overflow.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c         | 261 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  18 ++++
 2 files changed, 279 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index d88ef22..139dae3 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -18,9 +18,15 @@
 #include "asm/barrier.h"
 #include "asm/sysreg.h"
 #include "asm/processor.h"
+#include <bitops.h>
+#include <asm/gic.h>
=20
 #define PMU_PMCR_E         (1 << 0)
+#define PMU_PMCR_P         (1 << 1)
 #define PMU_PMCR_C         (1 << 2)
+#define PMU_PMCR_D         (1 << 3)
+#define PMU_PMCR_X         (1 << 4)
+#define PMU_PMCR_DP        (1 << 5)
 #define PMU_PMCR_LC        (1 << 6)
 #define PMU_PMCR_N_SHIFT   11
 #define PMU_PMCR_N_MASK    0x1f
@@ -104,6 +110,9 @@ static inline void precise_instrs_loop(int loop, uint=
32_t pmcr)
=20
 /* event counter tests only implemented for aarch64 */
 static void test_event_introspection(void) {}
+static void test_event_counter_config(void) {}
+static void test_basic_event_count(void) {}
+static void test_mem_access(void) {}
=20
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -145,6 +154,32 @@ static inline void precise_instrs_loop(int loop, uin=
t32_t pmcr)
 }
=20
 #define PMCEID1_EL0 sys_reg(11, 3, 9, 12, 7)
+#define PMCNTENSET_EL0 sys_reg(11, 3, 9, 12, 1)
+#define PMCNTENCLR_EL0 sys_reg(11, 3, 9, 12, 2)
+
+#define PMEVTYPER_EXCLUDE_EL1 (1 << 31)
+#define PMEVTYPER_EXCLUDE_EL0 (1 << 30)
+
+#define regn_el0(__reg, __n) __reg ## __n  ## _el0
+#define write_regn(__reg, __n, __val) \
+	write_sysreg((__val), __reg ## __n ## _el0)
+
+#define read_regn(__reg, __n) \
+	read_sysreg(__reg ## __n ## _el0)
+
+#define print_pmevtyper(__s, __n) do { \
+	uint32_t val; \
+	val =3D read_regn(pmevtyper, __n);\
+	report_info("%s pmevtyper%d=3D0x%x, eventcount=3D0x%x (p=3D%ld, u=3D%ld=
 nsk=3D%ld, nsu=3D%ld, nsh=3D%ld m=3D%ld, mt=3D%ld)", \
+			(__s), (__n), val, val & 0xFFFF,  \
+			(BIT_MASK(31) & val) >> 31, \
+			(BIT_MASK(30) & val) >> 30, \
+			(BIT_MASK(29) & val) >> 29, \
+			(BIT_MASK(28) & val) >> 28, \
+			(BIT_MASK(27) & val) >> 27, \
+			(BIT_MASK(26) & val) >> 26, \
+			(BIT_MASK(25) & val) >> 25); \
+	} while (0)
=20
 static bool is_event_supported(uint32_t n, bool warn)
 {
@@ -207,6 +242,223 @@ static void test_event_introspection(void)
 	report(required_events, "Check required events are implemented");
 }
=20
+static inline void mem_access_loop(void *addr, int loop, uint32_t pmcr)
+{
+asm volatile(
+	"       msr     pmcr_el0, %[pmcr]\n"
+	"       isb\n"
+	"       mov     x10, %[loop]\n"
+	"1:     sub     x10, x10, #1\n"
+	"       mov x8, %[addr]\n"
+	"       ldr x9, [x8]\n"
+	"       cmp     x10, #0x0\n"
+	"       b.gt    1b\n"
+	"       msr     pmcr_el0, xzr\n"
+	"       isb\n"
+	:
+	: [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
+	: );
+}
+
+
+static void pmu_reset(void)
+{
+	/* reset all counters, counting disabled at PMCR level*/
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
+	/* Disable all counters */
+	write_sysreg_s(0xFFFFFFFF, PMCNTENCLR_EL0);
+	/* clear overflow reg */
+	write_sysreg(0xFFFFFFFF, pmovsclr_el0);
+	/* disable overflow interrupts on all counters */
+	write_sysreg(0xFFFFFFFF, pmintenclr_el1);
+	isb();
+}
+
+static void test_event_counter_config(void)
+{
+	int i;
+
+	if (!pmu.nb_implemented_counters) {
+		report_skip("No event counter, skip ...");
+		return;
+	}
+
+	pmu_reset();
+
+	/*
+	 * Test setting through PMESELR/PMXEVTYPER and PMEVTYPERn read,
+	 * select counter 0
+	 */
+	write_sysreg(1, PMSELR_EL0);
+	/* program this counter to count unsupported event */
+	write_sysreg(0xEA, PMXEVTYPER_EL0);
+	write_sysreg(0xdeadbeef, PMXEVCNTR_EL0);
+	report((read_regn(pmevtyper, 1) & 0xFFF) =3D=3D 0xEA,
+		"PMESELR/PMXEVTYPER/PMEVTYPERn");
+	report((read_regn(pmevcntr, 1) =3D=3D 0xdeadbeef),
+		"PMESELR/PMXEVCNTR/PMEVCNTRn");
+
+	/* try configure an unsupported event within the range [0x0, 0x3F] */
+	for (i =3D 0; i <=3D 0x3F; i++) {
+		if (!is_event_supported(i, false))
+			goto test_unsupported;
+	}
+	report_skip("pmevtyper: all events within [0x0, 0x3F] are supported");
+
+test_unsupported:
+	/* select counter 0 */
+	write_sysreg(0, PMSELR_EL0);
+	/* program this counter to count unsupported event */
+	write_sysreg(i, PMXEVCNTR_EL0);
+	/* read the counter value */
+	read_sysreg(PMXEVCNTR_EL0);
+	report(read_sysreg(PMXEVCNTR_EL0) =3D=3D i,
+		"read of a counter programmed with unsupported event");
+
+}
+
+static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_even=
ts)
+{
+	int i;
+
+	if (pmu.nb_implemented_counters < nb_events) {
+		report_skip("Skip test as number of counters is too small (%d)",
+			    pmu.nb_implemented_counters);
+		return false;
+	}
+
+	for (i =3D 0; i < nb_events; i++) {
+		if (!is_event_supported(events[i], false)) {
+			report_skip("Skip test as event %d is not supported",
+				    events[i]);
+			return false;
+		}
+	}
+	return true;
+}
+
+static void test_basic_event_count(void)
+{
+	uint32_t implemented_counter_mask, non_implemented_counter_mask;
+	uint32_t counter_mask;
+	uint32_t events[] =3D {
+		0x11,	/* CPU_CYCLES */
+		0x8,	/* INST_RETIRED */
+	};
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	implemented_counter_mask =3D (1 << pmu.nb_implemented_counters) - 1;
+	non_implemented_counter_mask =3D ~((1 << 31) | implemented_counter_mask=
);
+	counter_mask =3D implemented_counter_mask | non_implemented_counter_mas=
k;
+
+	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+
+	/* disable all counters */
+	write_sysreg_s(0xFFFFFFFF, PMCNTENCLR_EL0);
+	report(!read_sysreg_s(PMCNTENCLR_EL0) && !read_sysreg_s(PMCNTENSET_EL0)=
,
+		"pmcntenclr: disable all counters");
+
+	/*
+	 * clear cycle and all event counters and allow counter enablement
+	 * through PMCNTENSET. LC is RES1.
+	 */
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
+	isb();
+	report(get_pmcr() =3D=3D (pmu.pmcr_ro | PMU_PMCR_LC), "pmcr: reset coun=
ters");
+
+	/* Preset counter #0 to 0xFFFFFFF0 to trigger an overflow interrupt */
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	report(read_regn(pmevcntr, 0) =3D=3D 0xFFFFFFF0,
+		"counter #0 preset to 0xFFFFFFF0");
+	report(!read_regn(pmevcntr, 1), "counter #1 is 0");
+
+	/*
+	 * Enable all implemented counters and also attempt to enable
+	 * not supported counters. Counting still is disabled by !PMCR.E
+	 */
+	write_sysreg_s(counter_mask, PMCNTENSET_EL0);
+
+	/* check only those implemented are enabled */
+	report((read_sysreg_s(PMCNTENSET_EL0) =3D=3D read_sysreg_s(PMCNTENCLR_E=
L0)) &&
+		(read_sysreg_s(PMCNTENSET_EL0) =3D=3D implemented_counter_mask),
+		"pmcntenset: enabled implemented_counters");
+
+	/* Disable all counters but counters #0 and #1 */
+	write_sysreg_s(~0x3, PMCNTENCLR_EL0);
+	report((read_sysreg_s(PMCNTENSET_EL0) =3D=3D read_sysreg_s(PMCNTENCLR_E=
L0)) &&
+		(read_sysreg_s(PMCNTENSET_EL0) =3D=3D 0x3),
+		"pmcntenset: just enabled #0 and #1");
+
+	/* clear overflow register */
+	write_sysreg(0xFFFFFFFF, pmovsclr_el0);
+	report(!read_sysreg(pmovsclr_el0), "check overflow reg is 0");
+
+	/* disable overflow interrupts on all counters*/
+	write_sysreg(0xFFFFFFFF, pmintenclr_el1);
+	report(!read_sysreg(pmintenclr_el1),
+		"pmintenclr_el1=3D0, all interrupts disabled");
+
+	/* enable overflow interrupts on all event counters */
+	write_sysreg(implemented_counter_mask | non_implemented_counter_mask,
+		     pmintenset_el1);
+	report(read_sysreg(pmintenset_el1) =3D=3D implemented_counter_mask,
+		"overflow interrupts enabled on all implemented counters");
+
+	/* Set PMCR.E, execute asm code and unset PMCR.E */
+	precise_instrs_loop(20, pmu.pmcr_ro | PMU_PMCR_E);
+
+	report_info("counter #0 is 0x%lx (CPU_CYCLES)",
+		    read_regn(pmevcntr, 0));
+	report_info("counter #1 is 0x%lx (INST_RETIRED)",
+		    read_regn(pmevcntr, 1));
+
+	report_info("overflow reg =3D 0x%lx", read_sysreg(pmovsclr_el0));
+	report(read_sysreg(pmovsclr_el0) & 0x1,
+		"check overflow happened on #0 only");
+}
+
+static void test_mem_access(void)
+{
+	void *addr =3D malloc(PAGE_SIZE);
+	uint32_t events[] =3D {
+		0x13,   /* MEM_ACCESS */
+		0x13,   /* MEM_ACCESS */
+	};
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	pmu_reset();
+
+	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	isb();
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn(pmevcntr, 0));
+	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn(pmevcntr, 1));
+	/* We may not measure exactly 20 mem access. Depends on the platform */
+	report((read_regn(pmevcntr, 0) =3D=3D read_regn(pmevcntr, 1)) &&
+	       (read_regn(pmevcntr, 0) >=3D 20) && !read_sysreg(pmovsclr_el0),
+	       "Ran 20 mem accesses");
+
+	pmu_reset();
+
+	write_regn(pmevcntr, 0, 0xFFFFFFFA);
+	write_regn(pmevcntr, 1, 0xFFFFFFF0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	isb();
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report(read_sysreg(pmovsclr_el0) =3D=3D 0x3,
+	       "Ran 20 mem accesses with expected overflows on both counters");
+	report_info("cnt#0 =3D %ld cnt#1=3D%ld overflow=3D0x%lx",
+			read_regn(pmevcntr, 0), read_regn(pmevcntr, 1),
+			read_sysreg(pmovsclr_el0));
+}
+
 #endif
=20
 /*
@@ -397,6 +649,15 @@ int main(int argc, char *argv[])
 	} else if (strcmp(argv[1], "event-introspection") =3D=3D 0) {
 		report_prefix_push(argv[1]);
 		test_event_introspection();
+	} else if (strcmp(argv[1], "event-counter-config") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_event_counter_config();
+	} else if (strcmp(argv[1], "basic-event-count") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_basic_event_count();
+	} else if (strcmp(argv[1], "mem-access") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_mem_access();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 4433ef3..7a59403 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -72,6 +72,24 @@ groups =3D pmu
 arch =3D arm64
 extra_params =3D -append 'event-introspection'
=20
+[pmu-event-counter-config]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'event-counter-config'
+
+[pmu-basic-event-count]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'basic-event-count'
+
+[pmu-mem-access]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'mem-access'
+
 # Test PMU support (TCG) with -icount IPC=3D1
 #[pmu-tcg-icount-1]
 #file =3D pmu.flat
--=20
2.20.1

