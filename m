Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D22A121B25
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 21:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbfLPUsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 15:48:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23991 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727571AbfLPUsh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 15:48:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576529316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+KgNy5VsyIbFC+acRMDGjgJJ4wS9jemc5hSKxwg70KQ=;
        b=ZWvxGfM9nuPVGoQCjzm7HYKlAg1a1baFzlkH57ZlHYLwB7PZm2eSTuUXV4nclYEAzyKj7d
        3dE7hlcRsB1icbi6UGDGzyRYU0rnIG35b37IfIbyKSTLYeGOChXA05eENEUdEoHoSaB/zO
        /eXQ0FikhaG8B4ZG2c0uZylhvVfTIXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-1h7B-h2wNcq0MmOi1a7LSA-1; Mon, 16 Dec 2019 15:48:35 -0500
X-MC-Unique: 1h7B-h2wNcq0MmOi1a7LSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9187A0374;
        Mon, 16 Dec 2019 20:48:33 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33C7C5D9C9;
        Mon, 16 Dec 2019 20:48:30 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH 07/10] arm: pmu: test 32-bit <-> 64-bit transitions
Date:   Mon, 16 Dec 2019 21:47:54 +0100
Message-Id: <20191216204757.4020-8-eric.auger@redhat.com>
In-Reply-To: <20191216204757.4020-1-eric.auger@redhat.com>
References: <20191216204757.4020-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test configurations where we transit from 32b to 64b
counters and conversely. Also tests configuration where
chain counters are configured but only one counter is
enabled.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c         | 135 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |   6 +++
 2 files changed, 141 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index ad98771..8506544 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -115,6 +115,7 @@ static void test_basic_event_count(void) {}
 static void test_mem_access(void) {}
 static void test_chained_counters(void) {}
 static void test_chained_sw_incr(void) {}
+static void test_chain_promotion(void) {}
=20
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -581,6 +582,137 @@ static void test_chained_sw_incr(void)
 		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
 }
=20
+static void test_chain_promotion(void)
+{
+	uint32_t events[] =3D { 0x13 /* MEM_ACCESS */, 0x1E /* CHAIN */};
+	void *addr =3D malloc(PAGE_SIZE);
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	/* Only enable CHAIN counter */
+	pmu_reset();
+	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x2, PMCNTENSET_EL0);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report(!read_regn(pmevcntr, 0),
+		"chain counter not counting if even counter is disabled");
+
+	/* Only enable even counter */
+	pmu_reset();
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_sysreg_s(0x1, PMCNTENSET_EL0);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report(!read_regn(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) =3D=3D 0x1=
),
+		"odd counter did not increment on overflow if disabled");
+	report_info("MEM_ACCESS counter #0 has value %ld",
+		    read_regn(pmevcntr, 0));
+	report_info("CHAIN counter #1 has value %ld",
+		    read_regn(pmevcntr, 1));
+	report_info("overflow counter %ld", read_sysreg(pmovsclr_el0));
+
+	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled=
 */
+	pmu_reset();
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFDC);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn(pmevcntr, 0));
+
+	/* disable the CHAIN event */
+	write_sysreg_s(0x2, PMCNTENCLR_EL0);
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn(pmevcntr, 0));
+	report(read_sysreg(pmovsclr_el0) =3D=3D 0x1,
+		"should have triggered an overflow on #0");
+	report(!read_regn(pmevcntr, 1),
+		"CHAIN counter #1 shouldn't have incremented");
+
+	/* start at 0xFFFFFFDC, +20 with CHAIN disabled, +20 with CHAIN enabled=
 */
+
+	pmu_reset();
+	write_sysreg_s(0x1, PMCNTENSET_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFDC);
+	isb();
+	report_info("counter #0 =3D 0x%lx, counter #1 =3D 0x%lx overflow=3D0x%l=
x",
+		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1),
+		    read_sysreg(pmovsclr_el0));
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn(pmevcntr, 0));
+
+	/* enable the CHAIN event */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	isb();
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn(pmevcntr, 0));
+
+	report((read_regn(pmevcntr, 1) =3D=3D 1) && !read_sysreg(pmovsclr_el0),
+		"CHAIN counter #1 should have incremented and no overflow expected");
+
+	report_info("CHAIN counter #1 =3D 0x%lx, overflow=3D0x%lx",
+		read_regn(pmevcntr, 1), read_sysreg(pmovsclr_el0));
+
+	/* start as MEM_ACCESS/CPU_CYCLES and move to CHAIN/MEM_ACCESS */
+	pmu_reset();
+	write_regn(pmevtyper, 0, 0x13 /* MEM_ACCESS */ | PMEVTYPER_EXCLUDE_EL0)=
;
+	write_regn(pmevtyper, 1, 0x11 /* CPU_CYCLES */ | PMEVTYPER_EXCLUDE_EL0)=
;
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFDC);
+	isb();
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn(pmevcntr, 0));
+
+	/* 0 becomes CHAINED */
+	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	write_regn(pmevtyper, 1, 0x1E /* CHAIN */ | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
+		    read_regn(pmevcntr, 0));
+
+	report((read_regn(pmevcntr, 1) =3D=3D 1) && !read_sysreg(pmovsclr_el0),
+		"CHAIN counter #1 should have incremented and no overflow expected");
+
+	report_info("CHAIN counter #1 =3D 0x%lx, overflow=3D0x%lx",
+		read_regn(pmevcntr, 1), read_sysreg(pmovsclr_el0));
+
+	/* start as CHAIN/MEM_ACCESS and move to MEM_ACCESS/CPU_CYCLES */
+	pmu_reset();
+	write_regn(pmevtyper, 0, 0x13 /* MEM_ACCESS */ | PMEVTYPER_EXCLUDE_EL0)=
;
+	write_regn(pmevtyper, 1, 0x1E /* CHAIN */ | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFDC);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("counter #0=3D0x%lx, counter #1=3D0x%lx",
+			read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
+
+	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	write_regn(pmevtyper, 1, 0x11 /* CPU_CYCLES */ | PMEVTYPER_EXCLUDE_EL0)=
;
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
+	report(read_sysreg(pmovsclr_el0) =3D=3D 1,
+		"overflow is expected on counter 0");
+	report_info("counter #0=3D0x%lx, counter #1=3D0x%lx overflow=3D0x%lx",
+			read_regn(pmevcntr, 0), read_regn(pmevcntr, 1),
+			read_sysreg(pmovsclr_el0));
+}
+
 #endif
=20
 /*
@@ -786,6 +918,9 @@ int main(int argc, char *argv[])
 	} else if (strcmp(argv[1], "chained-sw-incr") =3D=3D 0) {
 		report_prefix_push(argv[1]);
 		test_chained_sw_incr();
+	} else if (strcmp(argv[1], "chain-promotion") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_chain_promotion();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 1bd4319..eb6e87e 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -102,6 +102,12 @@ groups =3D pmu
 arch =3D arm64
 extra_params =3D -append 'chained-sw-incr'
=20
+[pmu-chain-promotion]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'chain-promotion'
+
 # Test PMU support (TCG) with -icount IPC=3D1
 #[pmu-tcg-icount-1]
 #file =3D pmu.flat
--=20
2.20.1

