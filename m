Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D41914D9B1
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 12:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbgA3L0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 06:26:05 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:48084 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727175AbgA3L0F (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 30 Jan 2020 06:26:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580383564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Dh7u1VGwKPHqmTMtPa/XKRGnIPltwtTeChnZ592ayOE=;
        b=GfrNxwVJB5voXF9WkUIJloSjcjvXT3lSU7mzgiCQlTGCxrhhzUs+1lnVhVYO6ltL0SKBTj
        1O7+TZc1aw48xF68/8fKslYgy1E2uRBhlYvf80lDjeJTKtSbe4W9ddd+WUiSFbZI96/AeQ
        LEU6UpX18vcWxj9EyhEjgDIYojrD3rM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-o1pkDkYwMGegcQt8Adf7KQ-1; Thu, 30 Jan 2020 06:26:02 -0500
X-MC-Unique: o1pkDkYwMGegcQt8Adf7KQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CE862DB61;
        Thu, 30 Jan 2020 11:26:00 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-37.ams2.redhat.com [10.36.116.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50E471001B05;
        Thu, 30 Jan 2020 11:25:52 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 6/9] arm: pmu: Test chained counter
Date:   Thu, 30 Jan 2020 12:25:07 +0100
Message-Id: <20200130112510.15154-7-eric.auger@redhat.com>
In-Reply-To: <20200130112510.15154-1-eric.auger@redhat.com>
References: <20200130112510.15154-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add 2 tests exercising chained counters. The first one uses
CPU_CYCLES and the second one uses SW_INCR.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c         | 128 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  12 +++++
 2 files changed, 140 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 1b0101f..538fbeb 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -113,6 +113,8 @@ static void test_event_introspection(void) {}
 static void test_event_counter_config(void) {}
 static void test_basic_event_count(void) {}
 static void test_mem_access(void) {}
+static void test_chained_counters(void) {}
+static void test_chained_sw_incr(void) {}
=20
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -458,6 +460,126 @@ static void test_mem_access(void)
 			read_sysreg(pmovsclr_el0));
 }
=20
+static void test_chained_counters(void)
+{
+	uint32_t events[] =3D { 0x11 /* CPU_CYCLES */, 0x1E /* CHAIN */};
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	pmu_reset();
+
+	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	/* enable counters #0 and #1 */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	/* preset counter #0 at 0xFFFFFFF0 */
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+
+	report(read_regn(pmevcntr, 1) =3D=3D 1, "CHAIN counter #1 incremented")=
;
+	report(!read_sysreg(pmovsclr_el0), "check no overflow is recorded");
+
+	/* test 64b overflow */
+
+	pmu_reset();
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0x1);
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("overflow reg =3D 0x%lx", read_sysreg(pmovsclr_el0));
+	report(read_regn(pmevcntr, 1) =3D=3D 2, "CHAIN counter #1 incremented")=
;
+	report(!read_sysreg(pmovsclr_el0), "check no overflow is recorded");
+
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0xFFFFFFFF);
+
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("overflow reg =3D 0x%lx", read_sysreg(pmovsclr_el0));
+	report(!read_regn(pmevcntr, 1), "CHAIN counter #1 wrapped");
+	report(read_sysreg(pmovsclr_el0) =3D=3D 0x2,
+		"check no overflow is recorded");
+}
+
+static void test_chained_sw_incr(void)
+{
+	uint32_t events[] =3D { 0x0 /* SW_INCR */, 0x0 /* SW_INCR */};
+	int i;
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	pmu_reset();
+
+	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	/* enable counters #0 and #1 */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	/* preset counter #0 at 0xFFFFFFF0 */
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+
+	for (i =3D 0; i < 100; i++)
+		write_sysreg(0x1, pmswinc_el0);
+
+	report_info("SW_INCR counter #0 has value %ld", read_regn(pmevcntr, 0))=
;
+	report(read_regn(pmevcntr, 0) =3D=3D 0xFFFFFFF0,
+		"PWSYNC does not increment if PMCR.E is unset");
+
+	pmu_reset();
+
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+
+	for (i =3D 0; i < 100; i++)
+		write_sysreg(0x3, pmswinc_el0);
+
+	report(read_regn(pmevcntr, 0)  =3D=3D 84, "counter #1 after + 100 SW_IN=
CR");
+	report(read_regn(pmevcntr, 1)  =3D=3D 100,
+		"counter #0 after + 100 SW_INCR");
+	report_info("counter values after 100 SW_INCR #0=3D%ld #1=3D%ld",
+		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
+	report(read_sysreg(pmovsclr_el0) =3D=3D 0x1,
+		"overflow reg after 100 SW_INCR");
+
+	/* 64b SW_INCR */
+	pmu_reset();
+
+	events[1] =3D 0x1E /* CHAIN */;
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i =3D 0; i < 100; i++)
+		write_sysreg(0x3, pmswinc_el0);
+
+	report(!read_sysreg(pmovsclr_el0) && (read_regn(pmevcntr, 1) =3D=3D 1),
+		"overflow reg after 100 SW_INCR/CHAIN");
+	report_info("overflow=3D0x%lx, #0=3D%ld #1=3D%ld", read_sysreg(pmovsclr=
_el0),
+		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
+
+	/* 64b SW_INCR and overflow on CHAIN counter*/
+	pmu_reset();
+
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0xFFFFFFFF);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i =3D 0; i < 100; i++)
+		write_sysreg(0x3, pmswinc_el0);
+
+	report((read_sysreg(pmovsclr_el0) =3D=3D 0x2) &&
+		(read_regn(pmevcntr, 1) =3D=3D 0) &&
+		(read_regn(pmevcntr, 0) =3D=3D 84),
+		"overflow reg after 100 SW_INCR/CHAIN");
+	report_info("overflow=3D0x%lx, #0=3D%ld #1=3D%ld", read_sysreg(pmovsclr=
_el0),
+		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
+}
+
 #endif
=20
 /*
@@ -657,6 +779,12 @@ int main(int argc, char *argv[])
 	} else if (strcmp(argv[1], "mem-access") =3D=3D 0) {
 		report_prefix_push(argv[1]);
 		test_mem_access();
+	} else if (strcmp(argv[1], "chained-counters") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_chained_counters();
+	} else if (strcmp(argv[1], "chained-sw-incr") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_chained_sw_incr();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 7a59403..1bd4319 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -90,6 +90,18 @@ groups =3D pmu
 arch =3D arm64
 extra_params =3D -append 'mem-access'
=20
+[pmu-chained-counters]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'chained-counters'
+
+[pmu-chained-sw-incr]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'chained-sw-incr'
+
 # Test PMU support (TCG) with -icount IPC=3D1
 #[pmu-tcg-icount-1]
 #file =3D pmu.flat
--=20
2.20.1

