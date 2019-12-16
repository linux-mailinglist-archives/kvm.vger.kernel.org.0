Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB379121B29
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2019 21:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbfLPUst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Dec 2019 15:48:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55041 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727629AbfLPUst (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Dec 2019 15:48:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576529328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JVqCQEMGSyAN0RfyQhlZYKuYj1yMNsDA4gJwuQse6GI=;
        b=UvJJlG0COTddLdz4g05iniGoSgsEGi6rD9DO/Xsn+o5B9JEs81DZniSn6eYl63hCXQE7PQ
        KKnnOCY+cBs8+9T4K9r0KDuLI9Hv/j+pzGzsZ+y96iGCbjSsmk3yvmOeGbXeiXnNmGWaTa
        8GM7YKKFZfsoCNeKiR6MNwzu/l8wPhs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324--XxOX5fLNpmjjCkVjiP1nw-1; Mon, 16 Dec 2019 15:48:47 -0500
X-MC-Unique: -XxOX5fLNpmjjCkVjiP1nw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5E67510B959E;
        Mon, 16 Dec 2019 20:48:45 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A8075D9C9;
        Mon, 16 Dec 2019 20:48:40 +0000 (UTC)
From:   Eric Auger <eric.auger@redhat.com>
To:     eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     drjones@redhat.com, andrew.murray@arm.com, andre.przywara@arm.com,
        peter.maydell@linaro.org, alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH 10/10] arm: pmu: Test overflow interrupts
Date:   Mon, 16 Dec 2019 21:47:57 +0100
Message-Id: <20191216204757.4020-11-eric.auger@redhat.com>
In-Reply-To: <20191216204757.4020-1-eric.auger@redhat.com>
References: <20191216204757.4020-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Test overflows for MEM_ACCESS and SW_INCR events. Also tests
overflows with 64-bit events.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/pmu.c         | 134 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |   6 +++
 2 files changed, 140 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 8506544..9af9e42 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -45,6 +45,11 @@ struct pmu {
 	uint32_t pmcr_ro;
 };
=20
+struct pmu_stats {
+	unsigned long bitmap;
+	uint32_t interrupts[32];
+};
+
 static struct pmu pmu;
=20
 #if defined(__arm__)
@@ -116,6 +121,7 @@ static void test_mem_access(void) {}
 static void test_chained_counters(void) {}
 static void test_chained_sw_incr(void) {}
 static void test_chain_promotion(void) {}
+static void test_overflow_interrupt(void) {}
=20
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -263,6 +269,43 @@ asm volatile(
 	: );
 }
=20
+static struct pmu_stats pmu_stats;
+
+static void irq_handler(struct pt_regs *regs)
+{
+	uint32_t irqstat, irqnr;
+
+	irqstat =3D gic_read_iar();
+	irqnr =3D gic_iar_irqnr(irqstat);
+	gic_write_eoir(irqstat);
+
+	if (irqnr =3D=3D 23) {
+		unsigned long overflows =3D read_sysreg(pmovsclr_el0);
+		int i;
+
+		report_info("--> PMU overflow interrupt %d (counter bitmask 0x%lx)",
+			    irqnr, overflows);
+		for (i =3D 0; i < 32; i++) {
+			if (test_and_clear_bit(i, &overflows)) {
+				pmu_stats.interrupts[i]++;
+				pmu_stats.bitmap |=3D 1 << i;
+			}
+		}
+		write_sysreg(0xFFFFFFFF, pmovsclr_el0);
+	} else {
+		report_info("Unexpected interrupt: %d\n", irqnr);
+	}
+}
+
+static void pmu_reset_stats(void)
+{
+	int i;
+
+	for (i =3D 0; i < 32; i++)
+		pmu_stats.interrupts[i] =3D 0;
+
+	pmu_stats.bitmap =3D 0;
+}
=20
 static void pmu_reset(void)
 {
@@ -274,6 +317,7 @@ static void pmu_reset(void)
 	write_sysreg(0xFFFFFFFF, pmovsclr_el0);
 	/* disable overflow interrupts on all counters */
 	write_sysreg(0xFFFFFFFF, pmintenclr_el1);
+	pmu_reset_stats();
 	isb();
 }
=20
@@ -713,6 +757,93 @@ static void test_chain_promotion(void)
 			read_sysreg(pmovsclr_el0));
 }
=20
+static bool expect_interrupts(uint32_t bitmap)
+{
+	int i;
+
+	if (pmu_stats.bitmap ^ bitmap)
+		return false;
+
+	for (i =3D 0; i < 32; i++) {
+		if (test_and_clear_bit(i, &pmu_stats.bitmap))
+			if (pmu_stats.interrupts[i] !=3D 1)
+				return false;
+	}
+	return true;
+}
+
+static void test_overflow_interrupt(void)
+{
+	uint32_t events[] =3D { 0x13 /* MEM_ACCESS */, 0x00 /* SW_INCR */};
+	void *addr =3D malloc(PAGE_SIZE);
+	int i;
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	setup_irq(irq_handler);
+	gic_enable_irq(23);
+
+	pmu_reset();
+
+	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0xFFFFFFF0);
+	isb();
+
+	/* interrupts are disabled */
+
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	report(expect_interrupts(0), "no overflow interrupt received");
+
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i =3D 0; i < 100; i++)
+		write_sysreg(0x2, pmswinc_el0);
+
+	set_pmcr(pmu.pmcr_ro);
+	report(expect_interrupts(0), "no overflow interrupt received");
+
+	/* enable interrupts */
+
+	pmu_reset_stats();
+
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0xFFFFFFF0);
+	write_sysreg(0xFFFFFFFF, pmintenset_el1);
+	isb();
+
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	for (i =3D 0; i < 100; i++)
+		write_sysreg(0x3, pmswinc_el0);
+
+	mem_access_loop(addr, 200, pmu.pmcr_ro);
+	report_info("overflow=3D0x%lx", read_sysreg(pmovsclr_el0));
+	report(expect_interrupts(0x3),
+		"overflow interrupts expected on #0 and #1");
+
+	/* promote to 64-b */
+
+	pmu_reset_stats();
+
+	events[1] =3D 0x1E /* CHAIN */;
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	isb();
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	report(expect_interrupts(0),
+		"no overflow interrupt expected on 32b boundary");
+
+	/* overflow on odd counter */
+	pmu_reset_stats();
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0xFFFFFFFF);
+	isb();
+	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
+	report(expect_interrupts(0x2),
+		"expect overflow interrupt on odd counter");
+}
 #endif
=20
 /*
@@ -921,6 +1052,9 @@ int main(int argc, char *argv[])
 	} else if (strcmp(argv[1], "chain-promotion") =3D=3D 0) {
 		report_prefix_push(argv[1]);
 		test_chain_promotion();
+	} else if (strcmp(argv[1], "overflow-interrupt") =3D=3D 0) {
+		report_prefix_push(argv[1]);
+		test_overflow_interrupt();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index eb6e87e..1d1bc27 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -108,6 +108,12 @@ groups =3D pmu
 arch =3D arm64
 extra_params =3D -append 'chain-promotion'
=20
+[overflow-interrupt]
+file =3D pmu.flat
+groups =3D pmu
+arch =3D arm64
+extra_params =3D -append 'overflow-interrupt'
+
 # Test PMU support (TCG) with -icount IPC=3D1
 #[pmu-tcg-icount-1]
 #file =3D pmu.flat
--=20
2.20.1

