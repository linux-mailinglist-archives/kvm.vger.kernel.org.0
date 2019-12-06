Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64F7F115673
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 18:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfLFR2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 12:28:02 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33277 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726287AbfLFR2C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 12:28:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575653280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=05gJo/iDZRpCh33ff7JxVNxihlf01laZ3I+XStrtiS8=;
        b=AGFs9sLEQ6dh04N8M8SW1i7C/5Q7rFwChxycMqc+QRKS126HPEDnOt8d3UTZL1nB0Eo9Ds
        ThjD/VlU8fU4w7C/A1hiIS/U9t45CRiU0E1RQtlwhyyN7WQV568kEltyLxtVrivCkCbg+l
        ZTjt2G+WlWE2t8AUgTQLX+8KVixRlrM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-431-cZUedAMGMjSY8CBp_wrjmw-1; Fri, 06 Dec 2019 12:27:59 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0943800C7B;
        Fri,  6 Dec 2019 17:27:57 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 31D1060BF4;
        Fri,  6 Dec 2019 17:27:55 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org
Subject: [kvm-unit-tests RFC 05/10] pmu: Basic event counter Tests
Date:   Fri,  6 Dec 2019 18:27:19 +0100
Message-Id: <20191206172724.947-6-eric.auger@redhat.com>
In-Reply-To: <20191206172724.947-1-eric.auger@redhat.com>
References: <20191206172724.947-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: cZUedAMGMjSY8CBp_wrjmw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
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
 arm/pmu.c         | 254 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  18 ++++
 2 files changed, 272 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index f78c43f..8ffeb93 100644
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
@@ -105,6 +111,9 @@ static inline void precise_instrs_loop(int loop, uint32=
_t pmcr)
=20
 /* event counter tests only implemented for aarch64 */
 static void test_event_introspection(void) {}
+static void test_event_counter_config(void) {}
+static void test_basic_event_count(void) {}
+static void test_mem_access(void) {}
=20
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -146,6 +155,32 @@ static inline void precise_instrs_loop(int loop, uint3=
2_t pmcr)
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
+=09write_sysreg((__val), __reg ## __n ## _el0)
+
+#define read_regn(__reg, __n) \
+=09read_sysreg(__reg ## __n ## _el0)
+
+#define print_pmevtyper(__s , __n) do { \
+=09uint32_t val; \
+=09val =3D read_regn(pmevtyper, __n);\
+=09report_info("%s pmevtyper%d=3D0x%x, eventcount=3D0x%x (p=3D%ld, u=3D%ld=
 nsk=3D%ld, nsu=3D%ld, nsh=3D%ld m=3D%ld, mt=3D%ld)", \
+=09=09=09(__s), (__n), val, val & 0xFFFF,  \
+=09=09=09(BIT_MASK(31) & val) >> 31, \
+=09=09=09(BIT_MASK(30) & val) >> 30, \
+=09=09=09(BIT_MASK(29) & val) >> 29, \
+=09=09=09(BIT_MASK(28) & val) >> 28, \
+=09=09=09(BIT_MASK(27) & val) >> 27, \
+=09=09=09(BIT_MASK(26) & val) >> 26, \
+=09=09=09(BIT_MASK(25) & val) >> 25); \
+=09} while (0)
=20
 static bool is_event_supported(uint32_t n, bool warn)
 {
@@ -207,6 +242,216 @@ static void test_event_introspection(void)
 =09report("Check required events are implemented", required_events);
 }
=20
+static inline void mem_access_loop(void *addr, int loop, uint32_t pmcr)
+{
+asm volatile(
+=09"       msr     pmcr_el0, %[pmcr]\n"
+=09"       isb\n"
+=09"       mov     x10, %[loop]\n"
+=09"1:     sub     x10, x10, #1\n"
+=09"       mov x8, %[addr]\n"
+=09"       ldr x9, [x8]\n"
+=09"       cmp     x10, #0x0\n"
+=09"       b.gt    1b\n"
+=09"       msr     pmcr_el0, xzr\n"
+=09"       isb\n"
+=09:
+=09: [addr] "r" (addr), [pmcr] "r" (pmcr), [loop] "r" (loop)
+=09: );
+}
+
+
+static void pmu_reset(void)
+{
+=09/* reset all counters, counting disabled at PMCR level*/
+=09set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
+=09/* Disable all counters */
+=09write_sysreg_s(0xFFFFFFFF, PMCNTENCLR_EL0);
+=09/* clear overflow reg */
+=09write_sysreg(0xFFFFFFFF, pmovsclr_el0);
+=09/* disable overflow interrupts on all counters */
+=09write_sysreg(0xFFFFFFFF, pmintenclr_el1);
+=09isb();
+}
+
+static void test_event_counter_config(void) {
+=09int i;
+
+=09if (!pmu.nb_implemented_counters) {
+=09=09report_skip("No event counter, skip ...");
+=09=09return;
+=09}
+
+=09pmu_reset();
+
+=09/* Test setting through PMESELR/PMXEVTYPER and PMEVTYPERn read */
+        /* select counter 0 */
+        write_sysreg(1, PMSELR_EL0);
+        /* program this counter to count unsupported event */
+        write_sysreg(0xEA, PMXEVTYPER_EL0);
+        write_sysreg(0xdeadbeef, PMXEVCNTR_EL0);
+=09report("PMESELR/PMXEVTYPER/PMEVTYPERn",
+=09=09(read_regn(pmevtyper, 1) & 0xFFF) =3D=3D 0xEA);
+=09report("PMESELR/PMXEVCNTR/PMEVCNTRn",
+=09=09(read_regn(pmevcntr, 1) =3D=3D 0xdeadbeef));
+
+=09/* try configure an unsupported event within the range [0x0, 0x3F] */
+=09for (i =3D 0; i <=3D 0x3F; i++) {
+=09=09if (!is_event_supported(i, false))
+=09=09=09goto test_unsupported;
+=09}
+=09report_skip("pmevtyper: all events within [0x0, 0x3F] are supported");
+
+test_unsupported:
+=09/* select counter 0 */
+=09write_sysreg(0, PMSELR_EL0);
+=09/* program this counter to count unsupported event */
+=09write_sysreg(i, PMXEVCNTR_EL0);
+=09/* read the counter value */
+=09read_sysreg(PMXEVCNTR_EL0);
+=09report("read of a counter programmed with unsupported event", read_sysr=
eg(PMXEVCNTR_EL0) =3D=3D i);
+
+}
+
+static bool satisfy_prerequisites(uint32_t *events, unsigned int nb_events=
)
+{
+=09int i;
+
+=09if (pmu.nb_implemented_counters < nb_events) {
+=09=09report_skip("Skip test as number of counters is too small (%d)",
+=09=09=09    pmu.nb_implemented_counters);
+=09=09return false;
+=09}
+
+=09for (i =3D 0; i < nb_events; i++) {
+=09=09if (!is_event_supported(events[i], false)) {
+=09=09=09report_skip("Skip test as event %d is not supported",
+=09=09=09=09    events[i]);
+=09=09=09return false;
+=09=09}
+=09}=09=09
+=09return true;
+}
+
+static void test_basic_event_count(void)
+{
+=09uint32_t implemented_counter_mask, non_implemented_counter_mask;
+=09uint32_t counter_mask;
+=09uint32_t events[] =3D {
+=09=090x11,=09/* CPU_CYCLES */
+=09=090x8,=09/* INST_RETIRED */
+=09};
+
+=09if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+=09=09return;
+
+=09implemented_counter_mask =3D (1 << pmu.nb_implemented_counters) - 1;
+=09non_implemented_counter_mask =3D ~((1 << 31) | implemented_counter_mask=
);
+=09counter_mask =3D implemented_counter_mask | non_implemented_counter_mas=
k;
+
+        write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+        write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+
+=09/* disable all counters */
+=09write_sysreg_s(0xFFFFFFFF, PMCNTENCLR_EL0);
+=09report("pmcntenclr: disable all counters",
+=09       !read_sysreg_s(PMCNTENCLR_EL0) && !read_sysreg_s(PMCNTENSET_EL0)=
);
+
+=09/*
+=09 * clear cycle and all event counters and allow counter enablement
+=09 * through PMCNTENSET. LC is RES1.
+=09 */
+=09set_pmcr(pmu.pmcr_ro | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_P);
+=09isb();=09
+=09report("pmcr: reset counters", get_pmcr() =3D=3D (pmu.pmcr_ro | PMU_PMC=
R_LC));
+
+=09/* Preset counter #0 to 0xFFFFFFF0 to trigger an overflow interrupt */
+=09write_regn(pmevcntr, 0, 0xFFFFFFF0);
+=09report("counter #0 preset to 0xFFFFFFF0",
+=09=09read_regn(pmevcntr, 0) =3D=3D 0xFFFFFFF0);
+=09report("counter #1 is 0", !read_regn(pmevcntr, 1));
+
+=09/*
+=09 * Enable all implemented counters and also attempt to enable
+=09 * not supported counters. Counting still is disabled by !PMCR.E
+=09 */
+=09write_sysreg_s(counter_mask, PMCNTENSET_EL0);
+
+=09/* check only those implemented are enabled */
+=09report("pmcntenset: enabled implemented_counters",
+=09       (read_sysreg_s(PMCNTENSET_EL0) =3D=3D read_sysreg_s(PMCNTENCLR_E=
L0)) &&
+=09=09(read_sysreg_s(PMCNTENSET_EL0) =3D=3D implemented_counter_mask));
+
+=09/* Disable all counters but counters #0 and #1 */
+=09write_sysreg_s(~0x3, PMCNTENCLR_EL0);
+=09report("pmcntenset: just enabled #0 and #1",
+=09       (read_sysreg_s(PMCNTENSET_EL0) =3D=3D read_sysreg_s(PMCNTENCLR_E=
L0)) &&
+=09=09(read_sysreg_s(PMCNTENSET_EL0) =3D=3D 0x3));
+
+=09/* clear overflow register */
+=09write_sysreg(0xFFFFFFFF, pmovsclr_el0);
+=09report("check overflow reg is 0", !read_sysreg(pmovsclr_el0));
+
+=09/* disable overflow interrupts on all counters*/
+=09write_sysreg(0xFFFFFFFF, pmintenclr_el1);
+=09report("pmintenclr_el1=3D0, all interrupts disabled",
+=09=09!read_sysreg(pmintenclr_el1));
+
+=09/* enable overflow interrupts on all event counters */
+=09write_sysreg(implemented_counter_mask | non_implemented_counter_mask,
+=09=09     pmintenset_el1);
+=09report("overflow interrupts enabled on all implemented counters",
+=09=09read_sysreg(pmintenset_el1) =3D=3D implemented_counter_mask);
+
+=09/* Set PMCR.E, execute asm code and unset PMCR.E */
+=09precise_instrs_loop(20, pmu.pmcr_ro | PMU_PMCR_E);
+
+=09report_info("counter #0 is 0x%lx (CPU_CYCLES)", read_regn(pmevcntr, 0))=
;
+=09report_info("counter #1 is 0x%lx (INST_RETIRED)", read_regn(pmevcntr, 1=
));
+
+=09report_info("overflow reg =3D 0x%lx", read_sysreg(pmovsclr_el0) );
+=09report("check overflow happened on #0 only", read_sysreg(pmovsclr_el0) =
& 0x1);
+}
+
+static void test_mem_access(void)
+{
+=09void *addr =3D malloc(PAGE_SIZE);
+=09uint32_t events[] =3D {
+                0x13,   /* MEM_ACCESS */
+                0x13,   /* MEM_ACCESS */
+        };
+
+=09if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+=09=09return;
+
+=09pmu_reset();
+
+        write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+        write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+=09write_sysreg_s(0x3, PMCNTENSET_EL0);
+=09isb();
+=09mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+=09report_info("counter #0 is %ld (MEM_ACCESS)", read_regn(pmevcntr, 0));
+=09report_info("counter #1 is %ld (MEM_ACCESS)", read_regn(pmevcntr, 1));
+=09/* We may not measure exactly 20 mem access, this depends on the platfo=
rm */
+=09report("Ran 20 mem accesses",
+=09       (read_regn(pmevcntr, 0) =3D=3D read_regn(pmevcntr, 1)) &&
+=09       (read_regn(pmevcntr, 0) >=3D 20) && !read_sysreg(pmovsclr_el0));
+
+=09pmu_reset();
+
+=09write_regn(pmevcntr, 0, 0xFFFFFFFA);
+=09write_regn(pmevcntr, 1, 0xFFFFFFF0);
+=09write_sysreg_s(0x3, PMCNTENSET_EL0);
+=09isb();
+=09mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+=09report("Ran 20 mem accesses with expected overflows on both counters",
+=09       read_sysreg(pmovsclr_el0) =3D=3D 0x3);
+=09report_info("cnt#0 =3D %ld cnt#1=3D%ld overflow=3D0x%lx",
+=09=09=09read_regn(pmevcntr, 0), read_regn(pmevcntr, 1),
+=09=09=09read_sysreg(pmovsclr_el0));
+}
+
 #endif
=20
 /*
@@ -394,6 +639,15 @@ int main(int argc, char *argv[])
 =09} else if (strcmp(argv[1], "event-introspection") =3D=3D 0) {
 =09=09report_prefix_push(argv[1]);
 =09=09test_event_introspection();
+        } else if (strcmp(argv[1], "event-counter-config") =3D=3D 0) {
+                report_prefix_push(argv[1]);
+=09=09test_event_counter_config();
+=09} else if (strcmp(argv[1], "basic-event-count") =3D=3D 0) {
+=09=09report_prefix_push(argv[1]);
+=09=09test_basic_event_count();
+=09} else if (strcmp(argv[1], "mem-access") =3D=3D 0) {
+=09=09report_prefix_push(argv[1]);
+=09=09test_mem_access();
 =09} else {
 =09=09report_abort("Unknown subtest '%s'", argv[1]);
 =09}
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

