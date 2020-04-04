Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A2A19E5C3
	for <lists+kvm@lfdr.de>; Sat,  4 Apr 2020 16:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgDDOii (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 4 Apr 2020 10:38:38 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20736 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgDDOii (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 4 Apr 2020 10:38:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586011117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n+3o8PoghrtRWVjUXbWsW8ZVUhM/vWmMfbc7K3QtvdU=;
        b=iCGPH0zFItVRyC5448GWWikGeBUVPqDsQzJuRwle06lY9VikZHPA1EG4qYHwPBxprRRKut
        /PwFOfVrGPMHeFrIk7vQh6zurO9PJ6qzbeCi3hT+RCuC+fQF+281FOqFJsGL5rEngAR2JZ
        q0naRbaw1eKZ8UnhbdQV488itTAAqyQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-ZEh05rO8OLqUOEDa7FGbYw-1; Sat, 04 Apr 2020 10:38:35 -0400
X-MC-Unique: ZEh05rO8OLqUOEDa7FGbYw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 704B32F2A;
        Sat,  4 Apr 2020 14:38:34 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8BC4B1147D3;
        Sat,  4 Apr 2020 14:38:32 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Eric Auger <eric.auger@redhat.com>
Subject: [PULL kvm-unit-tests 23/39] arm: pmu: Test chained counters
Date:   Sat,  4 Apr 2020 16:37:15 +0200
Message-Id: <20200404143731.208138-24-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Auger <eric.auger@redhat.com>

Add 2 tests exercising chained counters. The first one uses
CPU_CYCLES and the second one uses SW_INCR.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/pmu.c         | 98 ++++++++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg | 12 ++++++
 2 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 16d723463395..73e55498284d 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -47,6 +47,7 @@
 #define INST_PREC		0x1B
 #define STALL_FRONTEND		0x23
 #define STALL_BACKEND		0x24
+#define CHAIN			0x1E
=20
 #define COMMON_EVENTS_LOW	0x0
 #define COMMON_EVENTS_HIGH	0x3F
@@ -141,6 +142,8 @@ static void test_event_counter_config(void) {}
 static void test_basic_event_count(void) {}
 static void test_mem_access(void) {}
 static void test_sw_incr(void) {}
+static void test_chained_counters(void) {}
+static void test_chained_sw_incr(void) {}
=20
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -503,7 +506,92 @@ static void test_sw_incr(void)
 	report_info("counter values after 100 SW_INCR #0=3D%ld #1=3D%ld",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) =3D=3D 0x1,
-		"overflow reg after 100 SW_INCR");
+		"overflow on counter #0 after 100 SW_INCR");
+}
+
+static void test_chained_counters(void)
+{
+	uint32_t events[] =3D {CPU_CYCLES, CHAIN};
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	pmu_reset();
+
+	write_regn_el0(pmevtyper, 0, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	/* enable counters #0 and #1 */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+
+	report(read_regn_el0(pmevcntr, 1) =3D=3D 1, "CHAIN counter #1 increment=
ed");
+	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained in=
cr #1");
+
+	/* test 64b overflow */
+
+	pmu_reset();
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, 0x1);
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("overflow reg =3D 0x%lx", read_sysreg(pmovsclr_el0));
+	report(read_regn_el0(pmevcntr, 1) =3D=3D 2, "CHAIN counter #1 set to 2"=
);
+	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained in=
cr #2");
+
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, ALL_SET);
+
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("overflow reg =3D 0x%lx", read_sysreg(pmovsclr_el0));
+	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
+	report(read_sysreg(pmovsclr_el0) =3D=3D 0x2, "overflow on chain counter=
");
+}
+
+static void test_chained_sw_incr(void)
+{
+	uint32_t events[] =3D {SW_INCR, CHAIN};
+	int i;
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	pmu_reset();
+
+	write_regn_el0(pmevtyper, 0, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	/* enable counters #0 and #1 */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i =3D 0; i < 100; i++)
+		write_sysreg(0x1, pmswinc_el0);
+
+	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) =3D=3D=
 1),
+		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
+	report_info("overflow=3D0x%lx, #0=3D%ld #1=3D%ld", read_sysreg(pmovsclr=
_el0),
+		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
+
+	/* 64b SW_INCR and overflow on CHAIN counter*/
+	pmu_reset();
+
+	write_regn_el0(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, ALL_SET);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i =3D 0; i < 100; i++)
+		write_sysreg(0x1, pmswinc_el0);
+
+	report((read_sysreg(pmovsclr_el0) =3D=3D 0x2) &&
+		(read_regn_el0(pmevcntr, 1) =3D=3D 0) &&
+		(read_regn_el0(pmevcntr, 0) =3D=3D 84),
+		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN=
");
+	report_info("overflow=3D0x%lx, #0=3D%ld #1=3D%ld", read_sysreg(pmovsclr=
_el0),
+		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
=20
 #endif
@@ -696,6 +784,14 @@ int main(int argc, char *argv[])
 		report_prefix_push(argv[1]);
 		test_sw_incr();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "pmu-chained-counters") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_chained_counters();
+		report_prefix_pop();
+	} else if (strcmp(argv[1], "pmu-chained-sw-incr") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_chained_sw_incr();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 175afe68225a..d31dcbf6c56f 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -96,6 +96,18 @@ groups =3D pmu
 arch =3D arm64
 extra_params =3D -append 'pmu-sw-incr'
=20
+[pmu-chained-counters]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'pmu-chained-counters'
+
+[pmu-chained-sw-incr]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'pmu-chained-sw-incr'
+
 # Test PMU support (TCG) with -icount IPC=3D1
 #[pmu-tcg-icount-1]
 #file =3D pmu.flat
--=20
2.25.1

