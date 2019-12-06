Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3B4115671
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 18:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfLFR2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 12:28:00 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24388 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726403AbfLFR17 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 6 Dec 2019 12:27:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575653278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WMQUa3khr5jsekFu/skIEP0pnlonAM+9sITcAnn0lGM=;
        b=UPotZyqMhn3HXPQwkXqU42VdoN5rNg+zs7d8/TXKADZbgZrj4KhP7j3B9gzZwphD/vOiPX
        una8aZ0hGX+J+FBYV3l8DxVU0anICDq86DJuqNBhWWz78pBrVJ6VDGnkwQmv4x4NCLnLI7
        RGD4eoEcHqT461keUGdQiWc81gcSONg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-bNevScXFNg-cmD5S24rlpg-1; Fri, 06 Dec 2019 12:27:56 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE4C31005502;
        Fri,  6 Dec 2019 17:27:54 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CC286CE40;
        Fri,  6 Dec 2019 17:27:47 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org
Subject: [kvm-unit-tests RFC 04/10] pmu: Check Required Event Support
Date:   Fri,  6 Dec 2019 18:27:18 +0100
Message-Id: <20191206172724.947-5-eric.auger@redhat.com>
In-Reply-To: <20191206172724.947-1-eric.auger@redhat.com>
References: <20191206172724.947-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: bNevScXFNg-cmD5S24rlpg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If event counters are implemented check the common events
required by the PMUv3 are implemented.

Some are unconditionally required (SW_INCR, CPU_CYCLES,
either INST_RETIRED or INST_SPEC). Some others only are
required if the implementation implements some other features.

Check those wich are unconditionally required.

This test currently fails on TCG as neither INST_RETIRED
or INST_SPEC are supported.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c         | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  6 ++++
 2 files changed, 76 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 8e95251..f78c43f 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -102,6 +102,10 @@ static inline void precise_instrs_loop(int loop, uint3=
2_t pmcr)
 =09: [pmcr] "r" (pmcr), [z] "r" (0)
 =09: "cc");
 }
+
+/* event counter tests only implemented for aarch64 */
+static void test_event_introspection(void) {}
+
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
 #define ID_AA64DFR0_PERFMON_MASK  0xf
@@ -140,6 +144,69 @@ static inline void precise_instrs_loop(int loop, uint3=
2_t pmcr)
 =09: [pmcr] "r" (pmcr)
 =09: "cc");
 }
+
+#define PMCEID1_EL0 sys_reg(11, 3, 9, 12, 7)
+
+static bool is_event_supported(uint32_t n, bool warn)
+{
+=09uint64_t pmceid0 =3D read_sysreg(pmceid0_el0);
+=09uint64_t pmceid1 =3D read_sysreg_s(PMCEID1_EL0);
+=09bool supported;
+=09uint32_t reg;
+
+=09if (n >=3D 0x0  && n <=3D 0x1F) {
+=09=09reg =3D pmceid0 & 0xFFFFFFFF;
+=09} else if  (n >=3D 0x4000 && n <=3D 0x401F) {
+=09=09reg =3D pmceid0 >> 32;
+=09} else if (n >=3D 0x20  && n <=3D 0x3F) {
+=09=09reg =3D pmceid1 & 0xFFFFFFFF;
+=09} else if (n >=3D 0x4020 && n <=3D 0x403F) {
+=09=09reg =3D pmceid1 >> 32;
+=09} else {
+=09=09abort();
+=09}
+=09supported =3D  reg & (1 << n);
+=09if (!supported && warn)
+=09=09report_info("event %d is not supported", n);
+=09return supported;
+}
+
+static void test_event_introspection(void)
+{
+=09bool required_events;
+
+=09if (!pmu.nb_implemented_counters) {
+=09=09report_skip("No event counter, skip ...");
+=09=09return;
+=09}
+=09if (pmu.nb_implemented_counters < 2)
+=09=09report_info("%d event counters are implemented. "
+                            "ARM recommends to implement at least 2",
+                            pmu.nb_implemented_counters);
+
+=09/* PMUv3 requires an implementation includes some common events */
+=09required_events =3D is_event_supported(0x0, true) /* SW_INCR */ &&
+=09=09=09  is_event_supported(0x11, true) /* CPU_CYCLES */ &&
+=09=09=09  (is_event_supported(0x8, true) /* INST_RETIRED */ ||
+=09=09=09   is_event_supported(0x1B, true) /* INST_PREC */);
+=09if (!is_event_supported(0x8, false))
+=09=09report_info("ARM strongly recomments INST_RETIRED (0x8) event "
+=09=09=09    "to be implemented");
+
+=09if (pmu.version =3D=3D 0x4) {
+=09=09/* ARMv8.1 PMU: STALL_FRONTEND and STALL_BACKEND are required */
+=09=09required_events =3D required_events ||
+=09=09=09=09  is_event_supported(0x23, true) ||
+=09=09=09=09  is_event_supported(0x24, true);
+=09}
+
+=09/* L1D_CACHE_REFILL(0x3) and L1D_CACHE(0x4) are only required if
+=09   L1 data / unified cache. BR_MIS_PRED(0x10), BR_PRED(0x12) are only
+=09   required if program-flow prediction is implemented. */
+
+=09report("Check required events are implemented", required_events);
+}
+
 #endif
=20
 /*
@@ -324,6 +391,9 @@ int main(int argc, char *argv[])
 =09=09report("Monotonically increasing cycle count", check_cycles_increase=
());
 =09=09report("Cycle/instruction ratio", check_cpi(cpi));
 =09=09pmccntr64_test();
+=09} else if (strcmp(argv[1], "event-introspection") =3D=3D 0) {
+=09=09report_prefix_push(argv[1]);
+=09=09test_event_introspection();
 =09} else {
 =09=09report_abort("Unknown subtest '%s'", argv[1]);
 =09}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 79f0d7a..4433ef3 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -66,6 +66,12 @@ file =3D pmu.flat
 groups =3D pmu
 extra_params =3D -append 'cycle-counter 0'
=20
+[pmu-event-introspection]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'event-introspection'
+
 # Test PMU support (TCG) with -icount IPC=3D1
 #[pmu-tcg-icount-1]
 #file =3D pmu.flat
--=20
2.20.1

